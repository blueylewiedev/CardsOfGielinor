-- dev/check_packs.lua
-- Checks the card weight (core/cards.lua `weight`, core/packs.lua Packs.pickCard): which weights a card may have,
-- that the pick inside a rarity follows the weights exactly, that a pack roll uses them, and that a weight survives
-- the overlay's JSON. Cards with no weight must be picked exactly as before (all alike).
--
-- Run from the plugin's folder:  lua dev/check_packs.lua

package.path = "./?.lua;./dev/?.lua;" .. package.path

function log() end          -- the client's log function

local Json = require("core/json")
local Cards = require("core/cards")
local Packs = require("core/packs")
local Encode = require("jsonencode")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function card(fields)
    local made = { id = "zz_test_card", name = "Test card", kind = "item", rarity = "common", desc = "A test.",
        art = { item = "TEST" }, tags = { category = { "armour" } } }
    for key, value in pairs(fields or {}) do
        made[key] = value
    end
    return made
end

-- Which weights a card may have --------------------------------------------------------------------------------
check(Cards.problem(card()) == nil, "no weight is fine")
for _, weight in ipairs({ 1, 10, 0.5, 0.001, 50, Cards.MAX_WEIGHT }) do
    check(Cards.problem(card({ weight = weight })) == nil, "weight " .. weight .. " is allowed")
end
for _, weight in ipairs({ 0, -1, Cards.MAX_WEIGHT + 1, math.huge, -math.huge, 0 / 0, "5", true, {} }) do
    local message = Cards.problem(card({ weight = weight }))
    check(message ~= nil, "weight " .. tostring(weight) .. " is refused")
    check(type(message) == "string" and string.find(message, "zz_test_card", 1, true) ~= nil,
        "the message about weight " .. tostring(weight) .. " names the card")
end
check(Cards.register(card({ weight = 0 })) == nil, "a card with a bad weight is not registered")
check(Cards.byId["zz_test_card"] == nil, "and is not in the deck")

-- The pick: with no weights every card is alike; the boundaries are exact ---------------------------------------
do
    local list = { { id = "a" }, { id = "b" }, { id = "c" }, { id = "d" } }
    local expected = { [0] = "a", [0.2499] = "a", [0.25] = "b", [0.4999] = "b", [0.5] = "c", [0.75] = "d", [0.9999] = "d" }
    for roll, id in pairs(expected) do
        check(Packs.pickCard(list, roll).id == id, "without weights roll " .. roll .. " picks " .. id)
    end
end
do
    local list = { { id = "plain" }, { id = "heavy", weight = 9 } }      -- 1 : 9
    check(Packs.pickCard(list, 0).id == "plain" and Packs.pickCard(list, 0.0999).id == "plain", "the first tenth is the plain card")
    check(Packs.pickCard(list, 0.1).id == "heavy" and Packs.pickCard(list, 0.9999).id == "heavy", "the rest is the heavy card")
    check(Packs.pickCard({ { id = "only" } }, 0.5).id == "only", "a list of one")
    check(Packs.pickCard({ { id = "x", weight = 0.5 }, { id = "y", weight = 0.5 } }, 0.5).id == "y", "weights below 1")
end

-- The shares over many evenly spaced rolls match the weights --------------------------------------------------
do
    local list = {}
    for index = 1, 99 do
        list[index] = { id = "c" .. index }
    end
    list[100] = { id = "coins", weight = 10 }                           -- 10 of a total 109
    local count, rolls = 0, 109000
    for step = 0, rolls - 1 do
        if Packs.pickCard(list, step / rolls).id == "coins" then
            count = count + 1
        end
    end
    check(count == 10000, "10 of 109 of the rolls pick the weighted card (got " .. count .. " of " .. rolls .. ")")
end

-- A whole pack roll uses the weights, and without them every card is as likely as the next ----------------------
do
    local function share(pool, wanted, rolls)
        math.randomseed(20241113)
        local hits = 0
        for _ = 1, rolls do
            if Packs.rollCard(pool).card.id == wanted then
                hits = hits + 1
            end
        end
        return hits / rolls
    end
    local weighted = { common = { { id = "a", rarity = "common" }, { id = "b", rarity = "common", weight = 9 } } }
    local alike = { common = { { id = "a", rarity = "common" }, { id = "b", rarity = "common" } } }
    local weightedShare = share(weighted, "b", 20000)
    check(math.abs(weightedShare - 0.9) < 0.02, "a pack roll gives the weight 9 card about 90% of the time (" .. weightedShare .. ")")
    local alikeShare = share(alike, "b", 20000)
    check(math.abs(alikeShare - 0.5) < 0.02, "without weights a pack roll gives each of two cards about half (" .. alikeShare .. ")")
    -- rarity still comes first: a weight does not lift a card over a rarer rarity's share
    local pool = { common = { { id = "c", rarity = "common", weight = 1000 } }, legendary = { { id = "l", rarity = "legendary" } } }
    local legendaryShare = share(pool, "l", 20000)
    local expected = Cards.rarities.legendary.weight / (Cards.rarities.common.weight + Cards.rarities.legendary.weight)
    check(math.abs(legendaryShare - expected) < 0.005, "a weight does not change how often a rarity comes up (" .. legendaryShare .. ", expected " .. expected .. ")")
end

-- The rarity weights are percentages: they add up to 100 (their comment in core/cards.lua says so) ---------------
do
    local total = 0
    for _, rarity in pairs(Cards.rarities) do
        total = total + rarity.weight
    end
    check(math.abs(total - 100) < 1e-9, "the rarity weights add up to 100 (they add up to " .. total .. ")")
end

-- The deck: every card passes, and the pool still builds ------------------------------------------------------------
do
    local pool, count = Packs.poolFor(Cards.packTypes.standard)
    check(count == #Cards.list, "the standard pack holds every card")
    check(Packs.rollCard(pool).card ~= nil, "a roll from the real deck gives a card")
    for _, listed in ipairs(Cards.list) do
        check(Cards.problem(listed) == nil, "deck card " .. listed.id .. " has no problem")
    end
end

-- The overlay: a weight is written and read back, and a card with one registers -------------------------------
do
    local text = Encode.encode(card({ weight = 12.5 }))
    local back = Json.decode(text)
    check(type(back) == "table" and back.weight == 12.5, "a weight survives the overlay's JSON (" .. text .. ")")
    check(Cards.problem(back) == nil, "the card read back has no problem")
    check(Cards.register(back) == true, "a card with a weight registers")
    check(Cards.byId["zz_test_card"].weight == 12.5, "and keeps it")
    Cards.deprecate("zz_test_card")
end

if failures > 0 then
    io.stderr:write(failures .. " check(s) failed\n")
    os.exit(1)
end
print("OK: weights are validated and the pick follows them")
