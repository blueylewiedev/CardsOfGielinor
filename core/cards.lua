-- core/cards.lua
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

-- The rarities from lowest to highest. Used by packs that guarantee a minimum rarity.
Cards.rarityOrder = { "common", "uncommon", "rare", "epic", "legendary" }
Cards.rarityRank = {}
for rank, key in ipairs(Cards.rarityOrder) do
    Cards.rarityRank[key] = rank
end

-- Variants. Every card the player owns is one card + one finish. For now there is only the
-- normal finish; reverse holo and holo were taken out to keep things simple, but the saving
-- format ("<card id>|<finish>") still has room for them, so they can be added back later.
Cards.finishes = {
    normal = { name = "Normal" },
}

-- Pull odds. This is a relative weight, rolled separately from rarity, so they stack.
Cards.odds = {
    finish = { normal = 1 },
}

-- The card format (the cards are written in the files listed in deck/index.lua).
--   id     : unique, never change it once players own the card (it is what gets saved).
--            For NPC cards it is also the NPC to show: the id uppercased is looked up as
--            id.NPC.<ID>, so "king_dragon" shows id.NPC.KING_DRAGON. Use the NPC's config
--            name, in lower case.
--   name   : name shown on the card
--   rarity : a key of Cards.rarities
--   desc   : short flavour text. Keep it to about 40 characters: the frame's text panel
--            shows three lines and cuts off anything longer.
--   kind   : optional, what the card shows: "npc" (the default). Item cards will use "item".
--   tags   : optional. Groups the card for themed packs. Each key is a kind of tag and holds
--            a list of lower case words, for example
--              tags = { skills = { "thieving" }, regions = { "misthalin" }, category = { "humanoid" } }
--            Any key can be used, a pack's `filter` just has to use the same key and words.
--   variants : optional. The different models a card can be shown with, e.g. the NPC's other
--            config versions. The first one is the card's picture. Each entry holds the same
--            fields as `art` (npc, body, anim, cam) plus an optional `name`. Leave it out for
--            a card with one picture, which then just uses `art`.
--   art    : optional. Only needed to override or tune the picture. Each entry holds:
--              npc  : use this NPC instead of the one from the id
--              body : NPC cards show the NPC's whole body model by default. `body = false`
--                     shows its head (chathead) instead; an NPC with no chathead shows an
--                     empty box (the NPC browser helps find them)
--              cam  : camera settings, any of yaw, pitch (radians), dist, fov (degrees),
--                     ty (height looked at) and tx (left/right). Leave out to use the
--                     defaults in ui/cardview.lua. Find good values with the buttons in the
--                     preview window, then paste the line it logs.
-- The cards themselves are in the deck folder (see below and deck/index.lua).
Cards.list = {}

-- Pack types. The pack the player buys today is "standard". A pack type holds:
--   id, name      : id is for code, name is what the player sees
--   priceFactor   : multiplies the price of the player's difficulty tier (default 1)
--   size          : cards in the pack (default Packs.PACK_SIZE)
--   filter        : optional. Only cards matching it can be pulled. Each key is a tag kind
--                   (or "kind"), each value a word or a list of words (any one matches). All
--                   keys must match. Example: { skills = "thieving" } or
--                   { category = { "weapon", "tool" } }
--   minRarity     : optional. Only cards of this rarity or better can be pulled.
-- Packs that cannot be bought yet are still listed here, so adding a pack to the shop later
-- only needs the window; nothing in this table touches the game.
Cards.packTypes = {
    standard = { id = "standard", name = "Standard pack", priceFactor = 1 },
}

-- The words allowed for the tag kinds that come from a closed list. A card with any other word
-- under one of these kinds stops the plugin loading, with the card named in the error, so a typo
-- never silently drops a card out of a themed pack. Add a word here before using it. Tag kinds
-- that are not listed are not checked.
Cards.tagWords = {
    regions  = { "misthalin", "asgarnia", "kandarin", "karamja", "kharidian_desert", "morytania",
                "tirannwn", "fremennik_province", "wilderness" },
    location = { "lumbridge", "falador", "ardougne", "draynor", "varrock", "dino_farm", "lumbridge_swamp" },
    skills   = { "attack", "defence", "strength", "constitution", "ranged", "prayer", "magic",
                "cooking", "woodcutting", "fletching", "fishing", "firemaking", "crafting",
                "smithing", "mining", "herblore", "agility", "thieving", "slayer", "farming",
                "runecrafting", "hunter", "construction", "summoning", "dungeoneering",
                "divination", "invention", "archaeology", "necromancy" },
    -- What a card is (its kind of creature), what it does (its job), and whether it can be fought.
    category = {
        -- what it is
        "humanoid", "animal", "dragon", "undead", "demon", "giant", "goblin", "troll", "spirit",
        "elemental", "insect", "construct",
        -- what it does
        "shopkeeper", "stallholder", "guard", "knight", "royalty", "adventurer", "wizard", "priest",
        "quest_giver", "banker", "farmer", "pirate", "thief",
        -- whether it can be fought
        "monster", "boss",
    },
}

-- The cards are written in their own files in the deck folder (the layout is described in
-- deck/index.lua). A card file returns { cards = { ... }, defaults = tags }: the defaults (such
-- as the region) are added to every card in the file. A card whose `art = { npc = "" }` is empty
-- is a draft: it is kept in Cards.drafts and left out of packs and totals until its NPC name is
-- filled in.
Cards.sets = require("deck/index")
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

for _, setName in ipairs(Cards.sets) do
    local set = require(setName)
    for _, card in ipairs(set.cards or {}) do
        if set.defaults ~= nil then
            addTags(card, set.defaults)
        end
        if card.art ~= nil and card.art.npc == "" then
            Cards.drafts[#Cards.drafts + 1] = card
        else
            Cards.list[#Cards.list + 1] = card
        end
    end
end

-- Lowest rarity first, keeping the order of the files within a rarity, so the collection and the
-- card preview go from common to legendary.
do
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

-- Variant keys. Owned cards are saved under "<card id>|<finish>", for example
-- "hans|normal".
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

-- True if the card matches a pack filter (see Cards.packTypes). No filter matches every card.
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

-- The pictures a card can be shown with, as a list of { name, npc, body, anim, cam }. The first
-- is the card's own picture. A card with no `variants` has just that one.
function Cards.getVariants(card)
    local list = {}
    if card.variants ~= nil then
        for _, entry in ipairs(card.variants) do
            local copy = { name = entry.name or card.name }
            for field, value in pairs(entry) do
                copy[field] = value
            end
            list[#list + 1] = copy
        end
    else
        local art = Cards.getArt(card)
        art.name = card.name
        list[1] = art
    end
    return list
end

-- Returns a card's art settings: { npc = <config name>, body, cam }. The NPC is the card's id
-- uppercased unless the card's `art` entry (or its first variant) names another one, and `body`
-- is true (the body model) unless the card sets `body = false` (the head).
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
    result.npc = result.npc or string.upper(card.id)
    -- NPC cards show the NPC's whole body model unless the card says `body = false` (the head).
    if result.body == nil and Cards.kindOf(card) == "npc" then
        result.body = true
    end
    return result
end

-- Lookup table by id, built once at load. Also checks the data above for mistakes, so a
-- typo shows up immediately as an error when the plugin loads.
-- Stops with an error naming the card if its tags are malformed or use a word that is not on
-- Cards.tagWords.
local function checkTags(card)
    if card.tags == nil then
        return
    end
    for tagKind, words in pairs(card.tags) do
        assert(type(tagKind) == "string" and type(words) == "table",
            "Tags on card " .. card.id .. " must be lists of words, e.g. skills = { \"thieving\" }")
        local allowed = Cards.tagWords[tagKind]
        local allowedSet = {}
        for _, word in ipairs(allowed or {}) do allowedSet[word] = true end
        for _, word in ipairs(words) do
            assert(type(word) == "string", "Tag words on card " .. card.id .. " must be text")
            assert(allowed == nil or allowedSet[word],
                "Card " .. card.id .. ": unknown " .. tagKind .. " tag \"" .. word .. "\" (add it to Cards.tagWords?)")
        end
    end
end
-- Drafts are checked too, so a typo is found before the card goes live.
for _, card in ipairs(Cards.drafts) do
    checkTags(card)
end

Cards.byId = {}
for _, card in ipairs(Cards.list) do
    assert(not string.find(card.id, "|", 1, true), "Card id cannot contain '|': " .. card.id)
    assert(Cards.rarities[card.rarity], "Unknown rarity on card " .. card.id)
    assert(Cards.byId[card.id] == nil, "Duplicate card id " .. card.id)
    assert(card.kind == nil or card.kind == "npc" or card.kind == "item", "Unknown kind on card " .. card.id)
    checkTags(card)
    if card.variants ~= nil then
        assert(#card.variants > 0, "variants on card " .. card.id .. " cannot be empty")
        for _, entry in ipairs(card.variants) do
            assert(type(entry) == "table" and entry.npc ~= nil, "Every variant of " .. card.id .. " needs an npc")
        end
    end
    Cards.byId[card.id] = card
end
for key, packType in pairs(Cards.packTypes) do
    assert(packType.id == key, "Pack type id must match its key: " .. key)
    assert(packType.minRarity == nil or Cards.rarities[packType.minRarity], "Unknown minRarity on pack " .. key)
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
