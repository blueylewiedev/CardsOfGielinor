-- core/packs.lua
-- Difficulty tiers and pack opening: what a pack costs and how its cards are rolled.
-- This file has no UI. The window that shows packs is in ui/packwindow.lua.

local Cards = require("core/cards")
local Storage = require("core/storage")

local Packs = {}

-- Cards in each pack.
Packs.PACK_SIZE = 5

-- Difficulty tiers, chosen once per character. Price is in credits (1,000 XP = 1 credit,
-- see core/earning.lua). `id` is what gets saved, so never change an id once players use it.
Packs.tiers = {
    { id = "easy",   name = "Easy",   price = 4 },
    { id = "normal", name = "Normal", price = 7 },
    { id = "hard",   name = "Hard",   price = 12 },
    { id = "master", name = "Master", price = 20 },
}
Packs.tierById = {}
for _, tier in ipairs(Packs.tiers) do
    Packs.tierById[tier.id] = tier
end

-- The tier a character chose, or nil if they have not chosen yet.
function Packs.tierFor(state)
    return Packs.tierById[state.difficulty]
end

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

-- What a pack costs this character in credits, or nil if they have not chosen a tier.
-- `packTypeId` is optional (default "standard"): themed packs multiply the tier's price by
-- their `priceFactor`, rounded up.
function Packs.priceFor(state, packTypeId)
    local tier = Packs.tierFor(state)
    local packType = Packs.typeById(packTypeId)
    if tier == nil or packType == nil then
        return nil
    end
    return math.ceil(tier.price * (packType.priceFactor or 1))
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

-- How many cards a pack type can give (0 means it cannot be opened). The cards don't change
-- while the plugin runs, so each pack type is counted once.
local poolSizes = {}
function Packs.poolSize(packTypeId)
    local size = poolSizes[packTypeId]
    if size == nil then
        local packType = Packs.typeById(packTypeId)
        size = packType and select(2, Packs.poolFor(packType)) or 0
        poolSizes[packTypeId] = size
    end
    return size
end

-- Rolls one card: its kind (NPC or item, see Packs.kindWeights), then its rarity, then which
-- card of that rarity, then its finish. The rolls are separate, so they stack. `pool` and `kinds`
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
    local list = pool[rarity]
    local card = list[math.random(#list)]

    local finish = pickWeighted(Cards.odds.finish)

    return { card = card, finish = finish, key = Cards.variantKey(card.id, finish) }
end

-- Buys and opens a pack for this character: takes the credits, rolls the cards and adds
-- them to the collection. Returns a list of results, one per card, each with:
--   card, finish, key       : what was pulled
--   isNewCard               : the player had no variant of this card before
--   isNewVariant            : the player had none of this exact variant before
--   owned                   : how many of this variant the player now has
-- If the pack could not be bought, returns nil and a reason ("no difficulty" or
-- "not enough credits").
function Packs.open(state, packTypeId)
    local packType = Packs.typeById(packTypeId)
    if packType == nil then
        return nil, "unknown pack"
    end
    local price = Packs.priceFor(state, packTypeId)
    if price == nil then
        return nil, "no difficulty"
    end
    local pool, poolSize, kinds = Packs.poolFor(packType)
    if poolSize == 0 then
        return nil, "no cards"
    end
    if not Storage.spendCredits(state, price) then
        return nil, "not enough credits"
    end

    local size = packType.size or Packs.PACK_SIZE
    local rolled = {}
    for i = 1, size do
        rolled[i] = Packs.rollCard(pool, kinds)
    end

    local results = {}
    for i = 1, size do
        local result = rolled[i]
        result.isNewCard = not Storage.ownsCard(state, result.card.id)
        result.isNewVariant = Storage.countOwned(state, result.key) == 0
        Storage.addCard(state, result.key)
        result.owned = Storage.countOwned(state, result.key)
        results[i] = result
    end
    Storage.recordPack(state, results)
    return results
end

return Packs
