-- packs.lua
-- Difficulty tiers and pack opening: what a pack costs and how its cards are rolled.
-- This file has no UI. The window that shows packs is in packwindow.lua.

local Cards = require("cards")
local Storage = require("storage")

local Packs = {}

-- Cards in each pack.
Packs.PACK_SIZE = 5

-- Difficulty tiers, chosen once per character. Price is in credits (1,000 XP = 1 credit,
-- see earning.lua). `id` is what gets saved, so never change an id once players use it.
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

-- What a pack costs this character in credits, or nil if they have not chosen a tier.
function Packs.priceFor(state)
    local tier = Packs.tierFor(state)
    return tier and tier.price or nil
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

-- Cards grouped by rarity, built once.
local cardsByRarity = {}
for _, card in ipairs(Cards.list) do
    local list = cardsByRarity[card.rarity]
    if list == nil then
        list = {}
        cardsByRarity[card.rarity] = list
    end
    list[#list + 1] = card
end

-- Rolls one card: its rarity, then which card of that rarity, then its finish. The rolls
-- are separate, so they stack. Returns
-- { card, finish, key } where key is the variant key used for saving.
function Packs.rollCard()
    -- Only rarities that actually have cards can be rolled.
    local rarityWeights = {}
    for rarity, rarityData in pairs(Cards.rarities) do
        if cardsByRarity[rarity] ~= nil then
            rarityWeights[rarity] = rarityData.weight
        end
    end
    local rarity = pickWeighted(rarityWeights)
    local list = cardsByRarity[rarity]
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
function Packs.open(state)
    local price = Packs.priceFor(state)
    if price == nil then
        return nil, "no difficulty"
    end
    if not Storage.spendCredits(state, price) then
        return nil, "not enough credits"
    end

    local results = {}
    for i = 1, Packs.PACK_SIZE do
        local result = Packs.rollCard()
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
