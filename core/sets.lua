-- core/sets.lua
-- The sets in deck/sets.lua: which cards each one holds and how many of them the player has. No drawing and no client
-- calls, so it is tested on its own against the real deck (dev/check_sets.lua).
--
-- A set's cards are worked out from the deck as it is when they are asked for, not when the plugin starts, so cards
-- the overlay adds later (core/overlay.lua) join a set whose `names` or `filter` take them in.
--
--   Sets.list                    the usable sets, in the file's order (a set that is not the right shape is left out
--                                and described in Sets.loadProblems)
--   Sets.byId[id]                one of them
--   Sets.cardsOf(set)            its cards, in the deck's order (lowest rarity first)
--   Sets.progress(state, set)    { cards = how many it holds, owned = how many of those the player has }
--   Sets.problems()              what is wrong with the sets against the deck (unknown ids, empty sets)

local Cards = require("core/cards")

local Sets = {}

Sets.list = {}
Sets.byId = {}
Sets.loadProblems = {}

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
    for _, field in ipairs({ "names", "add", "leave" }) do
        if set[field] ~= nil and not isTextList(set[field]) then
            return "set " .. set.id .. ": " .. field .. " must be a list of text"
        end
    end
    if set.filter ~= nil then
        if type(set.filter) ~= "table" then
            return "set " .. set.id .. ": filter must be a table, e.g. { kind = \"npc\" }"
        end
        for key, wanted in pairs(set.filter) do
            if type(key) ~= "string" or not (type(wanted) == "string" or isTextList(wanted)) then
                return "set " .. set.id .. ": filter must be words or lists of words, e.g. { category = \"shopkeeper\" }"
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

-- True if the set's names and filter take the card in (before `add` and `leave`).
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
    return set.filter == nil or Cards.matches(card, set.filter)
end

-- The set's cards, in the deck's order (Cards.list: lowest rarity first).
-- (worked out once a set, again only when an overlay changes the cards, Cards.revision; the Sets window asks for
-- every set's cards on each redraw. Callers must not change the list.)
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

-- The card ids the player has at least one of, from `state.owned` ("<card id>|<finish>" = count).
function Sets.ownedIds(state)
    local owned = {}
    for key, count in pairs(state and state.owned or {}) do
        local cardId = Cards.parseKey(key)
        if cardId ~= nil and type(count) == "number" and count > 0 then
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

local loaded, list = pcall(require, "deck/sets")
if loaded then
    Sets.load(list)
else
    Sets.load({})
    leaveOut("deck/sets.lua did not load: " .. tostring(list))
end

return Sets
