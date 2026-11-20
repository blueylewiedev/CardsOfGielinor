-- core/cards.lua
-- The card registry: rarities, finishes, the card format, loading the deck from deck/index.lua, the checks every card must pass, and the
-- pack types. A card that is not sound is left out and described in Cards.loadProblems; dev/check_cards.lua treats any problem as a failure.

local TagWords = require("core/tagwords")

local Cards = {}

-- Rarity tiers. colour: the card frame and the pack-opening pips (0xRRGGBBAA); glow: 0..1, how strongly a turned card glows.
-- Pull odds are Config "odds.rarity.<rarity>" (core/config.lua).
Cards.rarities = {
    common    = { name = "Common",    colour = 0x9AA0A6FF, glow = 0.0 },
    uncommon  = { name = "Uncommon",  colour = 0x4CAF50FF, glow = 0.6 },
    rare      = { name = "Rare",      colour = 0x2196F3FF, glow = 0.75 },
    epic      = { name = "Epic",      colour = 0x9C27B0FF, glow = 0.9 },
    legendary = { name = "Legendary", colour = 0xFFC107FF, glow = 1.0 },
}

-- The rarities from lowest to highest. Used by packs that guarantee a minimum rarity.
Cards.rarityOrder = { "common", "uncommon", "rare", "epic", "legendary" }
Cards.rarityRank = {}
for rank, key in ipairs(Cards.rarityOrder) do
    Cards.rarityRank[key] = rank
end

-- Finishes. A card the player owns is one card + one finish, saved as "<card id>|<finish>": normal (as it is), foil
-- (a pastel shine over the card) or holo (a rainbow behind the picture). Written once, commonest first; the tables
-- below are made from it: Cards.finishes[id] ({ id, name, short, colour }), Cards.finishOrder, Cards.specialFinishes
-- (all but normal), Cards.finishRank[id].
local FINISHES = {
    { id = "normal", name = "Normal", short = "N" },
    { id = "foil",   name = "Foil",   short = "F", colour = 0x8CCCFFFF },     -- a pale silver-blue
    { id = "holo",   name = "Holo",   short = "H", colour = 0xCC8CFFFF },     -- a violet
}
Cards.finishes, Cards.finishOrder, Cards.specialFinishes, Cards.finishRank = {}, {}, {}, {}
for rank, finish in ipairs(FINISHES) do
    Cards.finishes[finish.id] = finish
    Cards.finishOrder[rank] = finish.id
    Cards.finishRank[finish.id] = rank
    if rank > 1 then
        Cards.specialFinishes[#Cards.specialFinishes + 1] = finish.id
    end
end

-- Pull odds are Config keys (core/config.lua): "odds.finish.normal" 17, "odds.finish.foil" 2 and "odds.finish.holo" 1
-- (out of 20: foil 1 in 10, holo 1 in 20), relative weights rolled separately from rarity, so they stack.

-- The card format (cards are in the files listed in deck/index.lua; CONTRIBUTING.md has the full guide).
--   id       unique, never changed once players own the card (it is what is saved). NPC and item cards share one set of ids.
--            It is also what is shown: the id uppercased is id.NPC.<ID> (or id.Obj.<ID> for an item card).
--   name     what the card is called in the viewer and on the card
--   title    optional, printed on the card instead of `name` when the name is too long (Cards.MAX_TITLE)
--   rarity   a key of Cards.rarities
--   desc     flavour text, at most Cards.MAX_DESC letters (the frame's panel shows three lines)
--   kind     "npc" (the default) or "item" (an Obj)
--   weight   optional, how much likelier than other cards of its rarity (1 if left out; at most Cards.MAX_WEIGHT)
--   tags     optional, { kind = { words } } such as { skills = { "thieving" }, regions = { "misthalin" } }, for themed packs
--   variants optional, other models a card can be shown with (the first is its picture); entries hold the fields of `art` and a name
--   art      optional, overrides the picture:
--              npc / item   the config name to show instead of the id's
--              model        a raw model id, for an NPC that is scenery in the game
--              body         false shows the NPC's head (chathead) instead of its body
--              cam          yaw, pitch (radians), dist, fov (degrees), ty, tx, near; see ui/cardview.lua
Cards.list = {}

-- The longest description that fits on a card (see desc above).
Cards.MAX_DESC = 80

-- The most letters the title of a card (its `title`, or its `name` if it has none) can have before the card cuts it off.
-- The title steps down to the smallest font (ui/cardview.lua), and about 32 letters of it fit between the card's edges
-- (measured in the client); a few more are cut. dev/check_cards.lua lists the titles longer than this.
Cards.MAX_TITLE = 32

-- The largest `weight` a card may have (see weight above). A mistyped weight cannot make one card swallow its whole
-- rarity.
Cards.MAX_WEIGHT = 1000

-- How many regions a card may have. An item's regions are chosen by hand (see "Choosing regions for an item" in
-- CONTRIBUTING.md). An NPC's region comes from its deck file; one found in two regions goes in the first's file and lists
-- the other in `regions` (one found in more is a general card, in deck/npcs/general.lua).
Cards.MAX_ITEM_REGIONS = 2
Cards.MAX_NPC_REGIONS = 2      -- (its deck file's, and one in `regions`)

-- A deck file returns { cards = { ... }, defaults = tags }: the defaults (such as the region) are added to every card in it. A card
-- whose `art.npc` (or `art.item`) is "" is a draft: kept in Cards.drafts and left out of packs and totals.
Cards.deckFiles = require("deck/index")
Cards.drafts = {}

-- Adds tags to a card without removing the ones it has: { kind = { words } } merges word by word.
local function addTags(card, tags)
    card.tags = card.tags or {}
    for tagKind, words in pairs(tags) do
        local have = card.tags[tagKind] or {}
        local seen = {}
        for _, word in ipairs(have) do seen[word] = true end
        for _, word in ipairs(words) do
            if not seen[word] then
                have[#have + 1] = word
                seen[word] = true
            end
        end
        card.tags[tagKind] = have
    end
end

-- True if the card's art names nothing yet (an NPC card with `npc = ""` or an item card with
-- `item = ""`), so it is still a draft.
function Cards.isDraft(card)
    if type(card.art) ~= "table" then
        return false
    end
    if card.kind == "item" then
        return card.art.item == ""
    end
    return card.art.npc == ""
end

-- A card, file or pack that cannot be used is left out, not allowed to stop the plugin loading, and described in
-- Cards.loadProblems. dev/check_cards.lua, which the pull request check runs, treats any problem as an error, so one is
-- found before release.
Cards.loadProblems = {}
local function leaveOut(message)
    Cards.loadProblems[#Cards.loadProblems + 1] = message
end

-- Why a deck file's `defaults` (tags every card in the file gets) are not usable, or nil: a table of lists of words.
local function defaultsProblem(defaults)
    if type(defaults) ~= "table" then
        return "defaults must be a table"
    end
    for tagKind, words in pairs(defaults) do
        if type(tagKind) ~= "string" or type(words) ~= "table" then
            return "defaults must be lists of words, e.g. regions = { \"asgarnia\" }"
        end
        for _, word in ipairs(words) do
            if type(word) ~= "string" then
                return "the words in defaults must be text"
            end
        end
    end
    return nil
end

for _, setName in ipairs(Cards.deckFiles) do
    local loaded, set = pcall(require, setName)
    if not loaded or type(set) ~= "table" then
        leaveOut("The deck file " .. tostring(setName) .. " did not load: " .. tostring(set))
        set = {}
    end
    -- A file whose cards or defaults are not the right shape is left out whole: its cards cannot be told apart from
    -- ones that would be wrong in other ways, and half a file with the wrong tags is worse than none.
    local shape = nil
    if set.cards ~= nil and type(set.cards) ~= "table" then
        shape = "cards must be a table (a list of cards)"
    elseif set.defaults ~= nil then
        shape = defaultsProblem(set.defaults)
    end
    if shape ~= nil then
        leaveOut("The deck file " .. tostring(setName) .. " is left out: " .. shape)
        set = {}
    end
    for _, card in ipairs(set.cards or {}) do
        if type(card) ~= "table" then
            leaveOut("A card in " .. tostring(setName) .. " is not a table")
        else
            -- (a card whose own tags are the wrong shape cannot be merged with the defaults; it is left out here
            -- and Cards.problem says why when it is checked below)
            local merged = true
            if set.defaults ~= nil then
                merged = pcall(addTags, card, set.defaults)
            end
            if not merged then
                leaveOut("Card " .. tostring(card.id) .. ": its tags must be lists of words, e.g. regions = { \"asgarnia\" }")
            elseif Cards.isDraft(card) then
                Cards.drafts[#Cards.drafts + 1] = card
            else
                Cards.list[#Cards.list + 1] = card
            end
        end
    end
end

-- Counts every change to the cards after the deck has loaded (Cards.register, Cards.deprecate, Cards.resort), so
-- code that keeps something worked out from the cards (the pack sizes) knows when to work it out again.
Cards.revision = 0

-- Lowest rarity first, keeping the order of the files within a rarity, so the collection and the
-- card preview go from common to legendary. Run again after cards are added (Cards.register).
function Cards.resort()
    Cards.revision = Cards.revision + 1
    local position = {}
    for index, card in ipairs(Cards.list) do
        position[card] = index
    end
    table.sort(Cards.list, function(a, b)
        local rankA, rankB = Cards.rarityRank[a.rarity] or 0, Cards.rarityRank[b.rarity] or 0
        if rankA ~= rankB then
            return rankA < rankB
        end
        return position[a] < position[b]
    end)
end
Cards.resort()

-- Variant keys. Owned cards are saved under "<card id>|<finish>", for example "hans|normal", "hans|foil" or
-- "hans|holo".
function Cards.variantKey(cardId, finish)
    assert(Cards.finishes[finish], "Unknown finish " .. tostring(finish))
    return cardId .. "|" .. finish
end

-- Splits a variant key back into card id and finish, or returns nil if the key is not in
-- that format.
function Cards.parseKey(key)
    return string.match(key, "^([^|]+)|([^|]+)$")
end

-- What the card shows: "npc" unless the card says otherwise.
function Cards.kindOf(card)
    return card.kind or "npc"
end

-- True if the card has this word under this kind of tag, e.g. Cards.hasTag(card, "skills", "thieving").
function Cards.hasTag(card, tagKind, word)
    local list = card.tags and card.tags[tagKind]
    if list == nil then
        return false
    end
    for _, value in ipairs(list) do
        if value == word then
            return true
        end
    end
    return false
end

-- The filter word that matches a card with no words of that tag kind (see core/packtypes.lua).
Cards.NO_TAG = "none"

-- True if the card matches a pack filter (see core/packtypes.lua). No filter matches every card.
function Cards.matches(card, filter)
    if filter == nil then
        return true
    end
    for key, wanted in pairs(filter) do
        local words = type(wanted) == "table" and wanted or { wanted }
        local hit = false
        for _, word in ipairs(words) do
            if key == "kind" then
                hit = hit or Cards.kindOf(card) == word
            elseif word == Cards.NO_TAG then
                local list = card.tags and card.tags[key]
                hit = hit or list == nil or #list == 0
            else
                hit = hit or Cards.hasTag(card, key, word)
            end
        end
        if not hit then
            return false
        end
    end
    return true
end

-- A card's art settings: { npc, body, cam } or { item, cam }. The NPC (or item) is the id uppercased unless `art` (or the first
-- variant) names another; `body` is true unless the card sets it false.
function Cards.getArt(card)
    local result = {}
    local first = card.variants and card.variants[1]
    for field, value in pairs(first or {}) do
        if field ~= "name" then
            result[field] = value
        end
    end
    for field, value in pairs(card.art or {}) do
        result[field] = value
    end
    if Cards.kindOf(card) == "item" then
        result.item = result.item or string.upper(card.id)
        return result
    end
    result.npc = result.npc or string.upper(card.id)
    -- NPC cards show the NPC's whole body model unless the card says `body = false` (the head).
    if result.body == nil then
        result.body = true
    end
    return result
end

-- Why a card's tags are not sound, as a message that names the card, or nil if they are.
local function tagsProblem(card)
    local id = tostring(card.id)
    if card.tags == nil then
        return nil
    end
    if type(card.tags) ~= "table" then
        return "Tags on card " .. id .. " must be a table"
    end
    for tagKind, words in pairs(card.tags) do
        if not (type(tagKind) == "string" and type(words) == "table") then
            return "Tags on card " .. id .. " must be lists of words, e.g. skills = { \"thieving\" }"
        end
        for _, word in ipairs(words) do
            if type(word) ~= "string" then
                return "Tag words on card " .. id .. " must be text"
            end
            if not TagWords.isKnown(tagKind, word, Cards.kindOf(card)) then
                return "Card " .. id .. ": unknown " .. tagKind .. " tag \"" .. word .. "\" for "
                    .. (Cards.kindOf(card) == "item" and "an item" or "an NPC") .. " card (add it to core/tagwords.lua?)"
            end
        end
        if tagKind == "membership" and #words > 1 then
            return "Card " .. id .. ": membership is one word, f2p or p2p"
        end
        if tagKind == "regions" and Cards.kindOf(card) == "item" and #words > Cards.MAX_ITEM_REGIONS then
            return "Card " .. id .. ": an item takes at most " .. Cards.MAX_ITEM_REGIONS
                .. " regions (leave it empty if it comes from more)"
        end
        -- (an NPC's regions here include its deck file's, added before the cards are checked)
        if tagKind == "regions" and Cards.kindOf(card) ~= "item" and #words > Cards.MAX_NPC_REGIONS then
            return "Card " .. id .. ": an NPC is in at most " .. Cards.MAX_NPC_REGIONS .. " regions, its deck file's and one"
                .. " in `regions` (one found in more goes in deck/npcs/general.lua with none)"
        end
        -- A word from a group with a `requires` (such as a weapon kind) needs that word too.
        local missing = TagWords.missingRequired(Cards.kindOf(card), tagKind, words)[1]
        if missing ~= nil then
            return "Card " .. id .. ": the " .. tagKind .. " tag \"" .. tostring(missing.word)
                .. "\" needs \"" .. tostring(missing.needs) .. "\" on the card too"
        end
    end
    return nil
end

-- Why a card is not sound, as a message that names it, or nil if it is: the checks every card must pass, whether
-- it is in the deck or comes from the overlay. Either way a card that fails is left out and the rest carry on. That
-- its id is not used by another card is checked where cards are added.
function Cards.problem(card)
    if type(card) ~= "table" then
        return "a card must be a table"
    end
    if type(card.id) ~= "string" or card.id == "" then
        return "a card has no id"
    end
    if string.find(card.id, "|", 1, true) then
        return "Card id cannot contain '|': " .. card.id
    end
    if type(card.name) ~= "string" or card.name == "" then
        return "Card " .. card.id .. " has no name"
    end
    if card.title ~= nil and (type(card.title) ~= "string" or card.title == "") then
        return "The title of card " .. card.id .. " must be text, and not empty"
    end
    if not Cards.rarities[card.rarity] then
        return "Unknown rarity on card " .. card.id
    end
    if not (card.kind == nil or card.kind == "npc" or card.kind == "item") then
        return "Unknown kind on card " .. card.id
    end
    if card.art ~= nil and type(card.art) ~= "table" then
        return "The art of card " .. card.id .. " must be a table"
    end
    -- (a number that is not above 0, or is not a number at all, fails this; so does NaN)
    if card.weight ~= nil and not (type(card.weight) == "number" and card.weight > 0 and card.weight <= Cards.MAX_WEIGHT) then
        return "The weight of card " .. card.id .. " must be a number above 0 and at most " .. Cards.MAX_WEIGHT
    end
    local tags = tagsProblem(card)
    if tags ~= nil then
        return tags
    end
    -- What the card draws must be the kind of value the card view expects, or it fails when the card is shown.
    if card.desc ~= nil and type(card.desc) ~= "string" then
        return "The description of card " .. card.id .. " must be text"
    end
    for _, field in ipairs({ "npc", "item" }) do
        if card.art ~= nil and card.art[field] ~= nil and type(card.art[field]) ~= "string" then
            return "art." .. field .. " of card " .. card.id .. " must be text (a config name)"
        end
    end
    if card.art ~= nil and card.art.cam ~= nil and type(card.art.cam) ~= "table" then
        return "art.cam of card " .. card.id .. " must be a table"
    end
    if card.variants ~= nil then
        if type(card.variants) ~= "table" or #card.variants == 0 then
            return "variants on card " .. card.id .. " cannot be empty"
        end
        for _, entry in ipairs(card.variants) do
            local needed = card.kind == "item" and "item" or "npc"
            if type(entry) ~= "table" or entry[needed] == nil then
                return "Every variant of " .. card.id .. " needs an " .. needed
            end
        end
    end
    return nil
end

-- Drafts are checked too, so a typo is found before the card goes live.
do
    local kept = {}
    for _, card in ipairs(Cards.drafts) do
        local problem = tagsProblem(card)
        if problem ~= nil then
            leaveOut(problem)
        else
            kept[#kept + 1] = card
        end
    end
    Cards.drafts = kept
end

-- The live cards: one that is not sound, or whose id another card has, is left out (the first one with an id
-- stays). The list is filled again in place, in the same order.
Cards.byId = {}
do
    local kept = {}
    for _, card in ipairs(Cards.list) do
        local problem = Cards.problem(card)
        if problem == nil and Cards.byId[card.id] ~= nil then
            problem = "Card id \"" .. card.id .. "\" is used by two cards. NPC and item cards share "
                .. "one set of ids, so give one of them another id (an item can name its object in art.item)"
        end
        if problem ~= nil then
            leaveOut(problem)
        else
            Cards.byId[card.id] = card
            kept[#kept + 1] = card
        end
    end
    for index = #Cards.list, 1, -1 do
        Cards.list[index] = nil
    end
    for index, card in ipairs(kept) do
        Cards.list[index] = card
    end
end

-- Adds a card that is not in the deck (from the overlay), or replaces the card with the same id, in place. Returns true, or nil and
-- why not (a card that is not sound, or a draft, changes nothing). Call Cards.resort() after a batch.
function Cards.register(card)
    local problem = Cards.problem(card)
    if problem ~= nil then
        return nil, problem
    end
    if Cards.isDraft(card) then
        return nil, "Card " .. card.id .. " is a draft"
    end
    Cards.revision = Cards.revision + 1
    local existing = Cards.byId[card.id]
    if existing == nil then
        Cards.list[#Cards.list + 1] = card
        Cards.byId[card.id] = card
        return true
    end
    for field in pairs(existing) do
        existing[field] = nil
    end
    for field, value in pairs(card) do
        existing[field] = value
    end
    return true
end

-- Takes a card out of the game (a card the overlay retires). A player's copies stay in their save and come back
-- if the card does. Returns true if there was such a card.
function Cards.deprecate(cardId)
    local card = Cards.byId[cardId]
    if card == nil then
        return false
    end
    Cards.byId[cardId] = nil
    Cards.revision = Cards.revision + 1
    for index, listed in ipairs(Cards.list) do
        if listed == card then
            table.remove(Cards.list, index)
            break
        end
    end
    return true
end

-- True if an id.NPC value is a real NPC. The client gives -1, not nil, for a name it does
-- not know, so both mean "not found".
function Cards.isValidNpcId(value)
    return type(value) == "number" and value >= 0
end

-- True if an id.Obj value is a real item. Like id.NPC, the client gives -1 for an unknown name.
function Cards.isValidObjId(value)
    return type(value) == "number" and value >= 0
end

return Cards
