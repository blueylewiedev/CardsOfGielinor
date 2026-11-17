-- core/packs.lua
-- The price of a pack and pack opening: what a pack costs and how its cards are rolled.
-- This file has no UI. The window that shows packs is in ui/packwindow.lua.

local Cards = require("core/cards")
local Storage = require("core/storage")

local Packs = {}

-- Cards in each pack.
Packs.PACK_SIZE = 5

-- What a standard pack costs, in credits (1,000 XP = 100 credits, see core/earning.lua). One price for everyone: the
-- themed packs multiply it by their `priceFactor`. Storage.STARTER_CREDITS is two of these; keep them in step
-- (dev/check_packs.lua checks).
Packs.PRICE = 4000

-- The most packs one purchase can buy (the Shop's quantity drop-down offers these, up to the largest).
Packs.QUANTITIES = { 1, 2, 3, 5, 10 }

-- The pack type with this id (default "standard"), or nil if there is none.
function Packs.typeById(packTypeId)
    return Cards.packTypes[packTypeId or "standard"]
end

-- The pack types on offer, in the order to show them: the standard pack first, then the themed
-- packs (deck/packs.lua) by name.
function Packs.offered()
    local list = {}
    for _, packType in pairs(Cards.packTypes) do
        list[#list + 1] = packType
    end
    table.sort(list, function(a, b)
        if (a.id == "standard") ~= (b.id == "standard") then
            return a.id == "standard"
        end
        return a.name < b.name
    end)
    return list
end

-- What one pack costs in credits, or nil if there is no such pack type. `packTypeId` is optional (default
-- "standard"): themed packs multiply the price by their `priceFactor`, rounded up.
function Packs.priceFor(packTypeId)
    local packType = Packs.typeById(packTypeId)
    if packType == nil then
        return nil
    end
    return math.ceil(Packs.PRICE * (packType.priceFactor or 1))
end

-- Picks a key from a { key = weight } table, in proportion to the weights. Keys are
-- sorted first so the result does not depend on the order `pairs` happens to use.
local function pickWeighted(weights)
    local keys = {}
    local total = 0
    for key, weight in pairs(weights) do
        keys[#keys + 1] = key
        total = total + weight
    end
    assert(#keys > 0 and total > 0, "nothing to pick from")
    table.sort(keys)
    local roll = math.random() * total
    for _, key in ipairs(keys) do
        roll = roll - weights[key]
        if roll < 0 then
            return key
        end
    end
    return keys[#keys]
end

-- Picks one card from a list of cards (all of one rarity), each in proportion to its `weight` (1 if it has none, see
-- core/cards.lua). With no weights this is a plain uniform pick. `roll` is a number from 0 up to but not including 1;
-- it defaults to math.random() and is a parameter so the odds can be checked exactly.
function Packs.pickCard(list, roll)
    local total = 0
    for _, card in ipairs(list) do
        total = total + (card.weight or 1)
    end
    local left = (roll or math.random()) * total
    for _, card in ipairs(list) do
        left = left - (card.weight or 1)
        if left < 0 then
            return card
        end
    end
    return list[#list]
end

-- How likely each kind of card is to be the one drawn, for every card in a pack: a card is
-- first drawn as an NPC or an item (in proportion to these), then by rarity, then which card.
-- There is no slot kept for either kind, and as items are added they do not crowd the NPCs out.
-- A kind with no cards in a pack is left out of the draw for that pack. Change a weight to tune
-- it (0 keeps that kind out of any pack that also has the other kind).
Packs.kindWeights = { npc = 1, item = 1 }

-- The cards a pack type can give, grouped by rarity: { rarity = { card, ... } }. Honours the
-- pack's filter and minimum rarity. If nothing is left at or above the minimum rarity, the
-- minimum is dropped rather than leaving the pack empty. Returns the groups, how many cards
-- there are in all (0 means the pack cannot be opened), and the same cards grouped by kind
-- first ({ npc = { rarity = { card, ... } }, item = { ... } }, only the kinds that have cards).
function Packs.poolFor(packType)
    local function build(minRank)
        local groups, kinds, count = {}, {}, 0
        for _, card in ipairs(Cards.list) do
            if Cards.rarityRank[card.rarity] >= minRank and Cards.matches(card, packType.filter) then
                local kind = Cards.kindOf(card)
                kinds[kind] = kinds[kind] or {}
                for _, grouped in ipairs({ groups, kinds[kind] }) do
                    local list = grouped[card.rarity]
                    if list == nil then
                        list = {}
                        grouped[card.rarity] = list
                    end
                    list[#list + 1] = card
                end
                count = count + 1
            end
        end
        return groups, count, kinds
    end
    local minRank = packType.minRarity and Cards.rarityRank[packType.minRarity] or 1
    local groups, count, kinds = build(minRank)
    if count == 0 and minRank > 1 then
        groups, count, kinds = build(1)
    end
    return groups, count, kinds
end

-- How many cards a pack type can give (0 means it cannot be opened). The cards only change when an overlay
-- is applied (Cards.revision), so each pack type is counted once until then.
local poolSizes, poolSizesAt = {}, -1
function Packs.poolSize(packTypeId)
    if poolSizesAt ~= Cards.revision then
        poolSizes, poolSizesAt = {}, Cards.revision
    end
    local size = poolSizes[packTypeId]
    if size == nil then
        local packType = Packs.typeById(packTypeId)
        size = packType and select(2, Packs.poolFor(packType)) or 0
        poolSizes[packTypeId] = size
    end
    return size
end

-- Rolls one card: its kind (NPC or item, see Packs.kindWeights), then its rarity, then which
-- card of that rarity (all alike unless a card has a weight, see Packs.pickCard), then its
-- finish. The rolls are separate, so they stack. `pool` and `kinds`
-- come from Packs.poolFor (default: the standard pack). Without `kinds` the kind is not rolled
-- and the card comes from `pool` alone. Returns { card, finish, key } where key is the variant
-- key used for saving.
function Packs.rollCard(pool, kinds)
    if pool == nil then
        pool, _, kinds = Packs.poolFor(Cards.packTypes.standard)
    end
    if kinds ~= nil then
        local weights = {}
        for kind, groups in pairs(kinds) do
            local weight = Packs.kindWeights[kind] or 0
            if next(groups) ~= nil and weight > 0 then
                weights[kind] = weight
            end
        end
        if next(weights) ~= nil then
            pool = kinds[pickWeighted(weights)]
        end
    end
    -- Only rarities that actually have cards can be rolled.
    local rarityWeights = {}
    for rarity, rarityData in pairs(Cards.rarities) do
        if pool[rarity] ~= nil then
            rarityWeights[rarity] = rarityData.weight
        end
    end
    local rarity = pickWeighted(rarityWeights)
    local card = Packs.pickCard(pool[rarity])

    local finish = pickWeighted(Cards.odds.finish)

    return { card = card, finish = finish, key = Cards.variantKey(card.id, finish) }
end

-- Buys and opens `count` packs (default 1) of a type for this character: takes the credits for all of them at once
-- (all or nothing), rolls the cards and adds them to the collection. Returns a list of results, one per card, packs one
-- after the other, each with:
--   card, finish, key       : what was pulled
--   pack                    : which of the packs bought it came from (1 to count)
--   isNewCard               : the player had no variant of this card before (counting the cards pulled before it)
--   isNewVariant            : the player had none of this exact variant before (likewise)
--   owned                   : how many of this variant the player now has
-- If the packs could not be bought, returns nil and a reason ("unknown pack", "bad count", "no cards" or
-- "not enough credits").
function Packs.open(state, packTypeId, count)
    count = count or 1
    local packType = Packs.typeById(packTypeId)
    if packType == nil then
        return nil, "unknown pack"
    end
    if type(count) ~= "number" or count < 1 or count ~= math.floor(count) then
        return nil, "bad count"
    end
    local pool, poolSize, kinds = Packs.poolFor(packType)
    if poolSize == 0 then
        return nil, "no cards"
    end
    if not Storage.spendCredits(state, Packs.priceFor(packTypeId) * count) then
        return nil, "not enough credits"
    end

    local size = packType.size or Packs.PACK_SIZE
    local results = {}
    for pack = 1, count do
        local rolled = {}
        for i = 1, size do
            rolled[i] = Packs.rollCard(pool, kinds)
            rolled[i].pack = pack
        end
        local ofPack = {}
        for i = 1, size do
            local result = rolled[i]
            result.isNewCard = not Storage.ownsCard(state, result.card.id)
            result.isNewVariant = Storage.countOwned(state, result.key) == 0
            Storage.addCard(state, result.key)
            result.owned = Storage.countOwned(state, result.key)
            results[#results + 1] = result
            ofPack[i] = result
        end
        Storage.recordPack(state, ofPack)
    end
    return results
end

return Packs
