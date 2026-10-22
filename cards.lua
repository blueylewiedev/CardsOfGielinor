-- cards.lua
-- Static card data: rarity tiers, variants, pull odds and the card list.
-- Nothing in this file touches the game or saves anything, so it is safe to edit freely.

local Cards = {}

-- Rarity tiers.
--   weight : relative chance of pulling this tier from a pack (used when packs are added)
--   colour : 0xRRGGBBAA colour used for the card frame and the pack opening pips
--   glow   : 0..1, how strongly a flipped card of this rarity glows in the pack opening
Cards.rarities = {
    common    = { name = "Common",    weight = 60, colour = 0x9AA0A6FF, glow = 0.0 },
    uncommon  = { name = "Uncommon",  weight = 25, colour = 0x4CAF50FF, glow = 0.6 },
    rare      = { name = "Rare",      weight = 10, colour = 0x2196F3FF, glow = 0.75 },
    epic      = { name = "Epic",      weight = 4,  colour = 0x9C27B0FF, glow = 0.9 },
    legendary = { name = "Legendary", weight = 1,  colour = 0xFFC107FF, glow = 1.0 },
}

-- Variants. Every card the player owns is one card + one finish.
--   finish    : the shine on top. holo is over the art, reverse is over the frame.
Cards.finishes = {
    normal  = { name = "Normal" },
    reverse = { name = "Reverse Holo" },
    holo    = { name = "Holo" },
}

-- Pull odds. This is a relative weight, rolled separately from rarity, so they stack.
--   finish   : normal 44 / reverse 10 / holo 6   (out of 60)
--              -> normal 73.3%, reverse holo 16.7% (1 in 6), holo 10% (1 in 10)
Cards.odds = {
    finish = { normal = 44, reverse = 10, holo = 6 },
}

-- The card list.
--   id     : unique, never change it once players own the card (it is what gets saved).
--            For NPC cards it is also the NPC to show: the id uppercased is looked up as
--            id.NPC.<ID>, so "king_dragon" shows id.NPC.KING_DRAGON. Use the NPC's config
--            name, in lower case.
--   name   : name shown on the card
--   rarity : a key of Cards.rarities
--   desc   : short flavour text. Keep it to about 40 characters: the frame's text panel
--            shows three lines and cuts off anything longer.
--   art    : optional. Only needed to override or tune the picture. Each entry holds:
--              npc  : use this NPC instead of the one from the id
--              body : true shows the NPC's body model instead of its head, for an NPC with
--                     no chathead (they show an empty box; the NPC browser helps find them)
--              cam  : camera settings, any of yaw, pitch (radians), dist, fov (degrees),
--                     ty (height looked at) and tx (left/right). Leave out to use the
--                     defaults in cardview.lua. Find good values with the buttons in the
--                     preview window, then paste the line it logs.
Cards.list = {
    -- Common
    { id = "chicken",    name = "Chicken",     rarity = "common",    desc = "Forever crossing roads for no reason.", art = { body = true } },
    { id = "POF_ANIMAL_COW_COW",        name = "Cow",         rarity = "common",    desc = "Content to stand in a field all day.", art = { npc = "POF_ANIMAL_COW_COW" } },
    { id = "sheep",      name = "Sheep",       rarity = "common",    desc = "Gives wool and little else." },
    { id = "GOBLIN_UNARMED_MELEE_1",     name = "Goblin",      rarity = "common",    desc = "Squabbles over the colour of its armour." },
    { id = "LUMBRIDGE_GIANTRAT_BROWN",  name = "Giant rat",   rarity = "common",    desc = "Larger than a rat should be.", art = { body = true } },
    { id = "LUMBRIDGE_MARKET_MAN1",        name = "Man",         rarity = "common",    desc = "Just a man, going about his day." },
    { id = "dog_stray",  name = "Stray dog",   rarity = "common",    desc = "Follows anyone who might have snacks." },

    -- Uncommon
    { id = "hans",       name = "Hans",        rarity = "uncommon",  desc = "Has walked Lumbridge Castle forever." },
    { id = "guide",      name = "Lumbridge Guide", rarity = "uncommon", desc = "Happy to help new adventurers.", art = { npc = "LUMBRIDGE_GUIDE" } },
    { id = "cook",       name = "Cook",        rarity = "uncommon",  desc = "Always one ingredient short of a cake." },
    { id = "bob",        name = "Bob",         rarity = "uncommon",  desc = "Sells axes and strong opinions." },
    { id = "fred",       name = "Fred the Farmer", rarity = "uncommon", desc = "Very fond of his sheep.", art = { npc = "FRED_THE_FARMER" } },
    { id = "aereck",     name = "Father Aereck", rarity = "uncommon", desc = "Keeps the chapel quiet and tidy.", art = { npc = "FATHER_AERECK" } },

    -- Rare
    { id = "horacio",    name = "Duke Horacio", rarity = "rare",     desc = "Rules Lumbridge from the castle." },
    { id = "doric",      name = "Doric",       rarity = "rare",      desc = "A dwarf serious about his anvil." },
    { id = "gertrude",   name = "Gertrude",    rarity = "rare",      desc = "Lives with a great many cats." },
    { id = "aggie",      name = "Aggie",       rarity = "rare",      desc = "Mixes dyes and asks for coins." },

    -- Epic
    { id = "wise_old_man", name = "Wise Old Man", rarity = "epic",   desc = "Claims to know a great deal about everything." },
    { id = "elvarg",     name = "Elvarg",      rarity = "epic",      desc = "A dragon who prefers to be left alone." },

    -- Legendary
    { id = "king_dragon", name = "King Black Dragon", rarity = "legendary", desc = "Three heads, all of them hungry." },
}

-- Variant keys. Owned cards are saved under "<card id>|<finish>", for example
-- "hans|normal" or "hans|holo".
function Cards.variantKey(cardId, finish)
    assert(Cards.finishes[finish], "Unknown finish " .. tostring(finish))
    return cardId .. "|" .. finish
end

-- Splits a variant key back into card id and finish, or returns nil if the key is not in
-- that format.
function Cards.parseKey(key)
    return string.match(key, "^([^|]+)|([^|]+)$")
end

-- Returns a card's art settings: { npc = <config name>, body, cam }. The NPC is the card's id
-- uppercased unless the card's `art` entry names another one.
function Cards.getArt(card)
    local result = {}
    for field, value in pairs(card.art or {}) do
        result[field] = value
    end
    result.npc = result.npc or string.upper(card.id)
    return result
end

-- Lookup table by id, built once at load. Also checks the data above for mistakes, so a
-- typo shows up immediately as an error when the plugin loads.
Cards.byId = {}
for _, card in ipairs(Cards.list) do
    assert(not string.find(card.id, "|", 1, true), "Card id cannot contain '|': " .. card.id)
    assert(Cards.rarities[card.rarity], "Unknown rarity on card " .. card.id)
    assert(Cards.byId[card.id] == nil, "Duplicate card id " .. card.id)
    Cards.byId[card.id] = card
end
for finish in pairs(Cards.odds.finish) do
    assert(Cards.finishes[finish], "Odds mention unknown finish " .. finish)
end

-- True if an id.NPC value is a real NPC. The client gives -1, not nil, for a name it does
-- not know, so both mean "not found".
function Cards.isValidNpcId(value)
    return type(value) == "number" and value >= 0
end

-- Logs similar NPC names for a name that was not found, if the client lets us list them.
local function suggestNames(npcName)
    local token = ""
    for part in string.gmatch(npcName, "[^_]+") do
        if #part > #token then
            token = part
        end
    end
    local ok, err = pcall(function()
        local found, total = 0, 0
        for key, value in pairs(id.NPC) do
            total = total + 1
            if total <= 3 then
                -- Show what the entries look like: the earlier search found nothing in
                -- 32972 entries, so the names may be the values, or not plain strings.
                log("art:   sample entry", type(key), tostring(key), "=", type(value), tostring(value))
            end
            local hit = nil
            for _, text in ipairs({ key, value }) do
                if hit == nil and type(text) == "string" and string.find(string.upper(text), token, 1, true) then
                    hit = text
                end
            end
            if hit ~= nil then
                log("art:   maybe", hit, "=", tostring(type(key) == "string" and value or key))
                found = found + 1
                if found >= 30 then
                    break
                end
            end
        end
        if total == 0 then
            log("art:   id.NPC cannot be listed (it has no entries to loop over)")
        elseif found == 0 then
            log("art:   none of", total, "NPC names contain", token)
        end
    end)
    if not ok then
        log("art:   cannot list NPC names here:", err)
    end
end

-- Logs whether each card's NPC can be resolved by the game.
-- Run this once on a developer world, then fix any NOT FOUND by renaming the card's id to
-- the NPC's config name, or by setting `npc` in its art entry.
function Cards.checkArtNames()
    for _, card in ipairs(Cards.list) do
        local art = Cards.getArt(card)
        local ok, value = pcall(function() return id.NPC[art.npc] end)
        if ok and Cards.isValidNpcId(value) then
            log("art: ok", card.id, art.npc, "->", tostring(value))
        else
            log("art: NOT FOUND", card.id, art.npc, "->", tostring(value))
            suggestNames(art.npc)
        end
    end
end

return Cards
