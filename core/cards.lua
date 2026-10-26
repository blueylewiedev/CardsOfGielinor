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
--            NPC and item cards share one set of ids, so an item cannot reuse an NPC's id
--            (give it another id and name the item in `art.item`).
--            For NPC cards it is also the NPC to show: the id uppercased is looked up as
--            id.NPC.<ID>, so "king_dragon" shows id.NPC.KING_DRAGON. Use the NPC's config
--            name, in lower case. Item cards work the same way with id.Obj: the id
--            "abyssal_whip" shows id.Obj.ABYSSAL_WHIP.
--   name   : name shown on the card
--   rarity : a key of Cards.rarities
--   desc   : short flavour text. Keep it to about 40 characters: the frame's text panel
--            shows three lines and cuts off anything longer.
--   kind   : optional, what the card shows: "npc" (the default) or "item" (an object in the
--            game's data, called an Obj by the API).
--   tags   : optional. Groups the card for themed packs. Each key is a kind of tag and holds
--            a list of lower case words, for example
--              tags = { skills = { "thieving" }, regions = { "misthalin" }, category = { "humanoid" } }
--            Any key can be used, a pack's `filter` just has to use the same key and words.
--   variants : optional. The different models a card can be shown with, e.g. the NPC's other
--            config versions. The first one is the card's picture. Each entry holds the same
--            fields as `art` (npc or item, body, anim, cam) plus an optional `name`. Leave it out for
--            a card with one picture, which then just uses `art`.
--   art    : optional. Only needed to override or tune the picture. Each entry holds:
--              npc  : use this NPC instead of the one from the id (NPC cards)
--              item : use this item (an id.Obj config name, upper case) instead of the one from
--                     the id (item cards). Item cards show the item's 3D model; they have no
--                     body/head choice and no animation. Use `cam` to frame the model, as the
--                     items differ a lot in size.
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
--   art           : optional. How the pack looks (see ui/packart.lua; made in the Pack Maker).
-- Themed packs (made in the Pack Maker) are listed in deck/packs.lua and added below. They cost
-- a little more than the standard pack (THEMED_PRICE_FACTOR) unless they set their own priceFactor.
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
                "tirannwn", "fremennik_province", "wilderness", "anachronia", "havenhythe" },
    location = { "lumbridge", "falador", "ardougne", "draynor", "varrock", "ranch_out_of_time", "lumbridge_swamp", "dorgesh_kaan", "burthorpe", "chaos_tunnels",
                "fremennik_slayer_dungeon" },
    skills   = { "attack", "defence", "strength", "constitution", "ranged", "prayer", "magic",
                "cooking", "woodcutting", "fletching", "fishing", "firemaking", "crafting",
                "smithing", "mining", "herblore", "agility", "thieving", "slayer", "farming",
                "runecrafting", "hunter", "construction", "summoning", "dungeoneering",
                "divination", "invention", "archaeology", "necromancy" },
    category = {},        -- filled in below from Cards.tagGroups.category
}

-- Tag words that are shown in groups when they are picked in the Card Builder. The groups are
-- only for display; the allowed words are the ones in all the groups together. A new category
-- word goes in the group that fits it best.
Cards.tagGroups = {
    category = {
        { title = "What it is", words = { "humanoid", "animal", "dragon", "undead", "demon", "giant", "goblin",
            "troll", "spirit", "elemental", "insect", "construct" } },
        { title = "What it does", words = { "shopkeeper", "stallholder", "guard", "knight", "royalty", "adventurer",
            "wizard", "priest", "quest_giver", "banker", "farmer", "pirate", "thief" } },
        { title = "Whether it can be fought", words = { "monster", "boss" } },
    },
}
for _, group in ipairs(Cards.tagGroups.category) do
    for _, word in ipairs(group.words) do
        Cards.tagWords.category[#Cards.tagWords.category + 1] = word
    end
end

-- The category words for item cards, in groups the same way. A card's category tag only takes
-- words for its own kind (an item cannot be a "dragon", an NPC cannot be "food"), but a pack
-- filter can use any of them, so Cards.tagWords.category holds both lists. A new word goes in the
-- group that fits it best, and must not already be an NPC category word.
Cards.itemTagGroups = {
    category = {
        { title = "What it is used for", words = { "raw_material", "processed_material", "food", "drink", "potion",
            "tool", "rune", "seed", "quest_item", "currency", "decoration", "craftable", "weapon", 
            "armour", "jewellery", "pocket", "ammunition", "fashion" } },
        { title = "What kind of weapon", requires = "weapon",
            words = { "dagger", "sword", "scimitar", "two_handed_sword", "axe", "mace", "spear", "halberd",
                "whip", "claw", "shortbow", "longbow", "crossbow", "thrown", "staff", "wand", "lantern", "siphon" } },
        { title = "Which armour slot", requires = "armour",
            words = { "helmet", "body", "legs", "gloves", "boots", "off_hand", "back" } },
        { title = "Which jewellery slot", requires = "jewellery",
            words = { "ring", "neck" } },
        { title = "What type of ammo", requires = "ammunition",
            words = { "arrow", "bolt", "spike" } },
    },
}
local npcCategoryWords = {}
for _, word in ipairs(Cards.tagWords.category) do
    npcCategoryWords[word] = true
end
for _, group in ipairs(Cards.itemTagGroups.category) do
    for _, word in ipairs(group.words) do
        assert(not npcCategoryWords[word], "The category word \"" .. word .. "\" is in both the NPC and the item lists")
        Cards.tagWords.category[#Cards.tagWords.category + 1] = word
    end
end

-- The tag kinds that cards of this kind ("npc" or "item") use, in the order they are written.
-- Items are not tagged with a location.
function Cards.tagKindsFor(cardKind)
    if cardKind == "item" then
        return { "skills", "category" }
    end
    return { "location", "skills", "category" }
end

-- The groups the words of a tag kind are shown in for this kind of card, or nil if the words
-- are not in groups.
function Cards.tagGroupsFor(cardKind, tagKind)
    local groups = cardKind == "item" and Cards.itemTagGroups or Cards.tagGroups
    return groups[tagKind]
end

-- The words a card of this kind may use under a tag kind, or nil if the tag kind has no list.
-- With no card kind, every word that any pack filter may use.
function Cards.wordsFor(cardKind, tagKind)
    local groups = cardKind ~= nil and Cards.tagGroupsFor(cardKind, tagKind) or nil
    if groups == nil then
        return Cards.tagWords[tagKind]
    end
    local words = {}
    for _, group in ipairs(groups) do
        for _, word in ipairs(group.words) do
            words[#words + 1] = word
        end
    end
    return words
end

-- What kind of cards a deck file holds: "item" for the files in deck/items/, otherwise "npc".
function Cards.setKind(setName)
    if string.sub(setName or "", 1, 11) == "deck/items/" then
        return "item"
    end
    return "npc"
end

-- The cards are written in their own files in the deck folder (the layout is described in
-- deck/index.lua). A card file returns { cards = { ... }, defaults = tags }: the defaults (such
-- as the region) are added to every card in the file. A card whose `art = { npc = "" }` is empty
-- (or, for an item card, `art = { item = "" }`) is a draft: it is kept in Cards.drafts and left
-- out of packs and totals until its NPC or item name is filled in.
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

-- True if the card's art names nothing yet (an NPC card with `npc = ""` or an item card with
-- `item = ""`), so it is still a draft.
function Cards.isDraft(card)
    if card.art == nil then
        return false
    end
    if card.kind == "item" then
        return card.art.item == ""
    end
    return card.art.npc == ""
end

for _, setName in ipairs(Cards.sets) do
    local set = require(setName)
    for _, card in ipairs(set.cards or {}) do
        if set.defaults ~= nil then
            addTags(card, set.defaults)
        end
        if Cards.isDraft(card) then
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

-- Returns a card's art settings: { npc = <config name>, body, cam } for an NPC card, or
-- { item = <config name>, cam } for an item card. The NPC (or item) is the card's id uppercased
-- unless the card's `art` entry (or its first variant) names another one, and for an NPC card
-- `body` is true (the body model) unless the card sets `body = false` (the head).
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

-- Lookup table by id, built once at load. Also checks the data above for mistakes, so a
-- typo shows up immediately as an error when the plugin loads.
-- Stops with an error naming the card if its tags are malformed or use a word that is not on
-- Cards.tagWords.
-- True if `word` may be used for this tag kind: it is on the kind's list in Cards.tagWords, or
-- the kind has no list. With a card kind ("npc" or "item"), the category words are the ones for
-- that kind of card only.
local function isKnownWord(tagKind, word, cardKind)
    local allowed = Cards.wordsFor(cardKind, tagKind)
    if allowed == nil then
        return true
    end
    for _, w in ipairs(allowed) do
        if w == word then
            return true
        end
    end
    return false
end

local function checkTags(card)
    if card.tags == nil then
        return
    end
    for tagKind, words in pairs(card.tags) do
        assert(type(tagKind) == "string" and type(words) == "table",
            "Tags on card " .. card.id .. " must be lists of words, e.g. skills = { \"thieving\" }")
        for _, word in ipairs(words) do
            assert(type(word) == "string", "Tag words on card " .. card.id .. " must be text")
            assert(isKnownWord(tagKind, word, Cards.kindOf(card)),
                "Card " .. card.id .. ": unknown " .. tagKind .. " tag \"" .. word .. "\" for "
                .. (Cards.kindOf(card) == "item" and "an item" or "an NPC") .. " card (add it to Cards.tagWords?)")
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
    assert(Cards.byId[card.id] == nil, "Card id \"" .. card.id .. "\" is used by two cards. NPC and item cards share "
        .. "one set of ids, so give one of them another id (an item can name its object in art.item)")
    assert(card.kind == nil or card.kind == "npc" or card.kind == "item", "Unknown kind on card " .. card.id)
    checkTags(card)
    if card.variants ~= nil then
        assert(#card.variants > 0, "variants on card " .. card.id .. " cannot be empty")
        for _, entry in ipairs(card.variants) do
            local needed = card.kind == "item" and "item" or "npc"
            assert(type(entry) == "table" and entry[needed] ~= nil, "Every variant of " .. card.id .. " needs an " .. needed)
        end
    end
    Cards.byId[card.id] = card
end
Cards.THEMED_PRICE_FACTOR = 1.25
for _, packType in ipairs(require("deck/packs")) do
    assert(type(packType.id) == "string" and packType.id ~= "", "A pack in deck/packs.lua has no id")
    packType.priceFactor = packType.priceFactor or Cards.THEMED_PRICE_FACTOR
    assert(Cards.packTypes[packType.id] == nil, "Duplicate pack type id " .. packType.id)
    Cards.packTypes[packType.id] = packType
end
for key, packType in pairs(Cards.packTypes) do
    assert(packType.id == key, "Pack type id must match its key: " .. key)
    assert(packType.minRarity == nil or Cards.rarities[packType.minRarity], "Unknown minRarity on pack " .. key)
    -- Filter words from a closed list must be on it, so a typo can't make an empty pack.
    for kind, wanted in pairs(packType.filter or {}) do
        for _, word in ipairs(type(wanted) == "table" and wanted or { wanted }) do
            assert(isKnownWord(kind, word), "Pack " .. key .. " filters on unknown " .. kind .. " word " .. tostring(word))
        end
    end
end
for finish in pairs(Cards.odds.finish) do
    assert(Cards.finishes[finish], "Odds mention unknown finish " .. finish)
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

-- Logs similar config names for a name that was not found, if the client lets us list them.
-- `registry` is id.NPC or id.Obj and `label` says which, for the log.
local function suggestNames(registry, label, npcName)
    local token = ""
    for part in string.gmatch(npcName, "[^_]+") do
        if #part > #token then
            token = part
        end
    end
    local ok, err = pcall(function()
        local found, total = 0, 0
        for key, value in pairs(registry) do
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
            log("art:   " .. label .. " cannot be listed (it has no entries to loop over)")
        elseif found == 0 then
            log("art:   none of", total, label, "names contain", token)
        end
    end)
    if not ok then
        log("art:   cannot list " .. label .. " names here:", err)
    end
end

-- Logs whether each card's NPC (or item) can be resolved by the game.
-- Run this once on a developer world, then fix any NOT FOUND by renaming the card's id to
-- the config name, or by setting `npc` (or `item`) in its art entry.
function Cards.checkArtNames()
    for _, card in ipairs(Cards.list) do
        local art = Cards.getArt(card)
        local isItem = Cards.kindOf(card) == "item"
        local name = isItem and art.item or art.npc
        local ok, value = pcall(function()
            if isItem then
                return id.Obj[name]
            end
            return id.NPC[name]
        end)
        local valid = isItem and Cards.isValidObjId(value) or (not isItem and Cards.isValidNpcId(value))
        if ok and valid then
            log("art: ok", card.id, name, "->", tostring(value))
        else
            log("art: NOT FOUND", card.id, name, "->", tostring(value))
            if isItem then
                suggestNames(id.Obj, "item", name)
            else
                suggestNames(id.NPC, "NPC", name)
            end
        end
    end
end

return Cards
