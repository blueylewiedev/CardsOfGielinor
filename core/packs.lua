-- core/packs.lua
-- The price of a pack and pack opening: what a pack costs and how its cards are rolled.
-- This file has no UI. The window that shows packs is in ui/packwindow.lua.

local Cards = require("core/cards")
local Storage = require("core/storage")
local Config = require("core/config")

local Packs = {}

-- Cards in each pack.
Packs.PACK_SIZE = 5

-- What a standard pack costs, in credits (Config "packs.price", 4,000; 1,000 XP = 100 credits, see core/earning.lua). One price
-- for everyone: a themed pack multiplies it by its `priceFactor`, or by "packs.themedPriceFactor" if it has none.
function Packs.price()
    return Config.get("packs.price")
end

-- The most packs one purchase can buy (the Shop's quantity drop-down offers these, up to the largest).
Packs.QUANTITIES = { 1, 2, 3, 5, 10 }

-- The pack type with this id (default "standard"), or nil if there is none.
function Packs.typeById(packTypeId)
    return Cards.packTypes[packTypeId or "standard"]
end

-- The pack types on offer, in the order to show them: the featured packs (a pack type's `featured`, see Cards.packTypes)
-- first, in that order, then the rest by name.
function Packs.offered()
    local list = {}
    for _, packType in pairs(Cards.packTypes) do
        list[#list + 1] = packType
    end
    table.sort(list, function(a, b)
        local rankA, rankB = a.featured or math.huge, b.featured or math.huge
        if rankA ~= rankB then
            return rankA < rankB
        end
        return a.name < b.name
    end)
    return list
end

-- What one pack costs in credits, or nil if there is no such pack type. `packTypeId` is optional (default
-- "standard"): themed packs multiply the price by their `priceFactor` (or the themed factor), rounded up.
function Packs.priceFor(packTypeId)
    local packType = Packs.typeById(packTypeId)
    if packType == nil then
        return nil
    end
    local factor = packType.priceFactor
    if factor == nil then
        factor = packType.themed and Config.get("packs.themedPriceFactor") or 1
    end
    return math.ceil(Packs.price() * factor)
end

-- Picks a key from a { key = weight } table, in proportion to the weights. Keys are sorted first so the result does
-- not depend on the order `pairs` happens to use.
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

-- Weights for which kind of card is drawn first (NPC or item), then rarity, then the card. A kind with no cards in a
-- pack is left out; 0 keeps a kind out of any pack that also has the other.
Packs.kindWeights = { npc = 1, item = 1 }

-- The cards a pack type can give, grouped by rarity, honouring its filter and minimum rarity (dropped if nothing
-- qualifies). Returns the groups, how many cards there are (0: it cannot be opened) and the same cards grouped by
-- kind first.
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

-- The names of the packs a card can come from, in the order the pack window offers them (an empty list if none).
-- Worked out for every card at once, again only when an overlay changes the cards (Cards.revision).
local packNames, packNamesAt = {}, -1
function Packs.namesFor(card)
    if packNamesAt ~= Cards.revision then
        packNames, packNamesAt = {}, Cards.revision
        for _, packType in ipairs(Packs.offered()) do
            local groups = Packs.poolFor(packType)
            for _, list in pairs(groups) do
                for _, member in ipairs(list) do
                    local names = packNames[member.id]
                    if names == nil then
                        names = {}
                        packNames[member.id] = names
                    end
                    names[#names + 1] = packType.name
                end
            end
        end
    end
    return packNames[card.id] or {}
end

-- Rolls one card: its kind, then rarity, then which card (by weight), then finish; the rolls are separate, so they
-- stack. `pool` and `kinds` come from Packs.poolFor (default: the standard pack). Returns { card, finish, key } where
-- key is the variant key used for saving.
function Packs.rollCard(pool, kinds)
    if pool == nil then
        local _
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
    -- Only rarities that actually have cards can be rolled (Config "odds.rarity.<rarity>"). If tuning has left every rarity
    -- this pack has at 0, they are rolled alike rather than not at all.
    local rarityWeights, total = {}, 0
    for rarity in pairs(Cards.rarities) do
        if pool[rarity] ~= nil then
            local weight = Config.get("odds.rarity." .. rarity)
            rarityWeights[rarity] = weight
            total = total + weight
        end
    end
    if total <= 0 then
        for rarity in pairs(rarityWeights) do
            rarityWeights[rarity] = 1
        end
    end
    local rarity = pickWeighted(rarityWeights)
    local card = Packs.pickCard(pool[rarity])

    -- (Config "odds.finish.<finish>": normal 17, foil 2, holo 1)
    local finishWeights = {}
    for finish in pairs(Cards.finishes) do
        finishWeights[finish] = Config.get("odds.finish." .. finish)
    end
    local finish = pickWeighted(finishWeights)

    return { card = card, finish = finish, key = Cards.variantKey(card.id, finish) }
end

-- Buys and opens `count` packs of a type: takes all the credits at once (or nothing), rolls the cards and adds them
-- to the collection. Returns one result per card { card, finish, key, pack, isNewCard, isNewVariant, owned }, or nil
-- and why ("unknown pack", "bad count", "no cards", "not enough credits").
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
