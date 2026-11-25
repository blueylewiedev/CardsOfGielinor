-- core/sets.lua
-- The sets in deck/sets.lua: which cards each holds and how many the player has. No drawing and no client calls
-- (dev/check_sets.lua). A set's cards are worked out when asked for, so cards the overlay adds later join a set whose
-- `names` or `filter` take them in.
--   Sets.list / Sets.byId   the usable sets (one of the wrong shape is left out and described in Sets.loadProblems)
--   Sets.cardsOf(set)       its cards, in the deck's order
--   Sets.progress(state, set)  { cards, owned }
--   Sets.problems()         what is wrong with the sets against the deck (an unknown id, an empty set)
--   Sets.oversized()        the sets over Sets.SOFT_LIMIT, as messages (a warning, not a problem)
--   Sets.loneGroups()       the groups with only one set, as messages (a warning)

local Cards = require("core/cards")
local Browse = require("core/browse")

local Sets = {}

Sets.list = {}
Sets.byId = {}
Sets.loadProblems = {}

-- About how many cards a set should hold at most: a set is a spread of a kind of card to collect, not every card of
-- that kind. (About 30; the skill masters, the biggest set picked by hand, are 31.) A soft limit: dev/check_sets.lua
-- warns about a set over it but does not fail.
Sets.SOFT_LIMIT = 32

local function leaveOut(message)
    Sets.loadProblems[#Sets.loadProblems + 1] = message
end

-- True if `value` is a list of text (an empty list is fine).
local function isTextList(value)
    if type(value) ~= "table" then
        return false
    end
    for key, item in pairs(value) do
        if type(key) ~= "number" or type(item) ~= "string" then
            return false
        end
    end
    return true
end

-- True if `value` is one filter: { tag kind, "kind" or "name" = word or list of words }.
local function isFilter(value)
    if type(value) ~= "table" then
        return false
    end
    for key, wanted in pairs(value) do
        if type(key) ~= "string" or not (type(wanted) == "string" or isTextList(wanted)) then
            return false
        end
    end
    return true
end

-- Why a set from deck/sets.lua cannot be used, or nil.
function Sets.shapeProblem(set)
    if type(set) ~= "table" then
        return "a set must be a table"
    end
    if type(set.id) ~= "string" or not string.match(set.id, "^[a-z0-9_]+$") then
        return "a set's id must be lower case letters, numbers and _"
    end
    if type(set.name) ~= "string" or set.name == "" then
        return "set " .. set.id .. " has no name"
    end
    if set.group ~= nil and (type(set.group) ~= "string" or string.find(set.group, "%S") == nil) then
        return "set " .. set.id .. ": group must be text, e.g. \"Metal armour\""
    end
    for _, field in ipairs({ "names", "add", "leave" }) do
        if set[field] ~= nil and not isTextList(set[field]) then
            return "set " .. set.id .. ": " .. field .. " must be a list of text"
        end
    end
    for _, field in ipairs({ "filter", "except" }) do
        local filter = set[field]
        if filter ~= nil then
            if type(filter) ~= "table" then
                return "set " .. set.id .. ": " .. field .. " must be a table, e.g. { kind = \"npc\" }"
            end
            local ok = isFilter(filter)
            if not ok and filter[1] ~= nil then
                ok = true
                for key, one in pairs(filter) do
                    ok = ok and type(key) == "number" and isFilter(one)
                end
            end
            if not ok then
                return "set " .. set.id .. ": " .. field .. " must be words or lists of words, e.g. "
                    .. "{ category = \"shopkeeper\" }, or a list of those, e.g. { { category = \"cook\" }, "
                    .. "{ name = \"chef\" } }"
            end
        end
    end
    local hasRule = (set.names ~= nil and #set.names > 0) or set.filter ~= nil or (set.add ~= nil and #set.add > 0)
    if not hasRule then
        return "set " .. set.id .. " takes in no cards: give it names, a filter or cards to add"
    end
    return nil
end

-- Loads the sets from `list` (what deck/sets.lua returns), replacing any loaded before. Called once below; the checks
-- call it with sets of their own.
function Sets.load(list)
    Sets.list, Sets.byId, Sets.loadProblems = {}, {}, {}
    if type(list) ~= "table" then
        leaveOut("deck/sets.lua must return a list of sets")
        return
    end
    for _, set in ipairs(list) do
        local problem = Sets.shapeProblem(set)
        if problem == nil and Sets.byId[set.id] ~= nil then
            problem = "two sets have the id " .. set.id
        end
        if problem ~= nil then
            leaveOut(problem)
        else
            Sets.list[#Sets.list + 1] = set
            Sets.byId[set.id] = set
        end
    end
end

-- True if a card called `cardName` is `base` or one of its variants: "Musician" and "Musician (Lumbridge)" are,
-- "Musicianship" and "Guard dog" (for "Guard") are not.
function Sets.isVariantOf(cardName, base)
    if cardName == base then
        return true
    end
    local prefix = base .. " ("
    return string.sub(cardName, 1, #prefix) == prefix
end

-- A list of text as { text = true }.
local function lookup(list)
    local set = {}
    for _, item in ipairs(list or {}) do
        set[item] = true
    end
    return set
end

-- True if the set's names and filter take the card in and `except` does not keep it out (before `add` and `leave`).
local function ruleTakes(set, card)
    if set.names == nil and set.filter == nil then
        return false
    end
    if set.names ~= nil then
        local named = false
        for _, base in ipairs(set.names) do
            if Sets.isVariantOf(card.name, base) then
                named = true
                break
            end
        end
        if not named then
            return false
        end
    end
    return Cards.matches(card, set.filter) and not (set.except ~= nil and Cards.matches(card, set.except))
end

-- The set's cards, in the deck's order (Cards.list: lowest rarity first). (worked out once a set, again only when an
-- overlay changes the cards, Cards.revision; the Sets window asks for every set's cards on each redraw. Callers must
-- not change the list.)
local cardsCache, cardsCacheAt = setmetatable({}, { __mode = "k" }), -1
function Sets.cardsOf(set)
    if cardsCacheAt ~= Cards.revision then
        cardsCache, cardsCacheAt = setmetatable({}, { __mode = "k" }), Cards.revision
    end
    local cards = cardsCache[set]
    if cards ~= nil then
        return cards
    end
    local added, left = lookup(set.add), lookup(set.leave)
    cards = {}
    for _, card in ipairs(Cards.list) do
        if not left[card.id] and (added[card.id] or ruleTakes(set, card)) then
            cards[#cards + 1] = card
        end
    end
    cardsCache[set] = cards
    return cards
end

-- The card ids the player has at least one of, as { [card id] = true }.
function Sets.ownedIds(state)
    local owned = {}
    if state ~= nil then
        for cardId in pairs(Browse.ownedByCard(state)) do
            owned[cardId] = true
        end
    end
    return owned
end

-- How much of the set the player has: { cards = how many it holds, owned = how many of those they have }.
-- `ownedIds` (from Sets.ownedIds) can be passed in when working out many sets at once.
function Sets.progress(state, set, ownedIds)
    ownedIds = ownedIds or Sets.ownedIds(state)
    local counts = { cards = 0, owned = 0 }
    for _, card in ipairs(Sets.cardsOf(set)) do
        counts.cards = counts.cards + 1
        if ownedIds[card.id] then
            counts.owned = counts.owned + 1
        end
    end
    return counts
end

-- What is wrong with the loaded sets against the deck as it is now, as a list of messages: the sets that were left
-- out, ids in `add` or `leave` that are not cards, an id in both, and sets that end up holding no card.
function Sets.problems()
    local problems = {}
    for _, message in ipairs(Sets.loadProblems) do
        problems[#problems + 1] = message
    end
    for _, set in ipairs(Sets.list) do
        local added = lookup(set.add)
        for _, field in ipairs({ "add", "leave" }) do
            for _, cardId in ipairs(set[field] or {}) do
                if Cards.byId[cardId] == nil then
                    problems[#problems + 1] = "set " .. set.id .. ": " .. field .. " names " .. cardId
                        .. ", which is not a card in the deck"
                elseif field == "leave" and added[cardId] then
                    problems[#problems + 1] = "set " .. set.id .. " both adds and leaves out " .. cardId
                end
            end
        end
        if #Sets.cardsOf(set) == 0 then
            problems[#problems + 1] = "set " .. set.id .. " holds no card"
        end
    end
    return problems
end

-- The groups that hold only one set, as a list of messages: a group is for gathering several sets under one heading.
function Sets.loneGroups()
    local counts = {}
    for _, set in ipairs(Sets.list) do
        if set.group ~= nil then
            counts[set.group] = (counts[set.group] or 0) + 1
        end
    end
    local messages = {}
    for _, set in ipairs(Sets.list) do
        if counts[set.group] == 1 then
            messages[#messages + 1] = "group \"" .. set.group .. "\" holds only one set"
        end
    end
    return messages
end

-- The sets holding more than Sets.SOFT_LIMIT cards, as a list of messages.
function Sets.oversized()
    local messages = {}
    for _, set in ipairs(Sets.list) do
        local count = #Sets.cardsOf(set)
        if count > Sets.SOFT_LIMIT then
            messages[#messages + 1] = "set " .. set.id .. " holds " .. count .. " cards, more than about "
                .. Sets.SOFT_LIMIT .. ": narrow it with except or leave, or split it into sets of its own"
        end
    end
    return messages
end

local loaded, list = pcall(require, "deck/sets")
if loaded then
    Sets.load(list)
else
    Sets.load({})
    leaveOut("deck/sets.lua did not load: " .. tostring(list))
end

return Sets
