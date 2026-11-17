-- dev/check_progress.lua
-- Tests Browse.progress (core/browse.lua), the one-pass count behind the Stats window's bars, against the real deck and
-- against Browse.counts, which does the same sums one filter at a time.
--
-- Run from the plugin's folder:  lua dev/check_progress.lua

package.path = "./?.lua;" .. package.path
function log() end

local Cards = require("core/cards")
local Browse = require("core/browse")

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end

-- A collection: every 3rd card, in a couple of finishes, and a key the deck no longer has.
local state = { owned = {} }
for i, card in ipairs(Cards.list) do
    if i % 3 == 0 then
        state.owned[Cards.variantKey(card.id, "normal")] = 2
    end
end
state.owned[Cards.variantKey("a_card_that_was_removed", "normal")] = 1

local progress = Browse.progress(state)
local all = Browse.counts(state, {})
check(progress.all.cards == #Cards.list, "all.cards is the deck")
check(progress.all.cards == all.cards and progress.all.owned == all.owned,
    "all matches Browse.counts: " .. progress.all.owned .. " vs " .. all.owned)

for _, kind in ipairs({ "npc", "item" }) do
    local want = Browse.counts(state, { kind = kind })
    local got = progress.kinds[kind] or { cards = 0, owned = 0 }
    check(got.cards == want.cards and got.owned == want.owned, kind .. " matches Browse.counts")
end
check((progress.kinds.npc.cards + progress.kinds.item.cards) == #Cards.list, "npc and item cards add up to the deck")

local rarityTotal = 0
for id in pairs(Cards.rarities) do
    local want = Browse.counts(state, { rarity = id })
    local got = progress.rarities[id] or { cards = 0, owned = 0 }
    rarityTotal = rarityTotal + got.cards
    check(got.cards == want.cards and got.owned == want.owned, id .. " matches Browse.counts")
end
check(rarityTotal == #Cards.list, "the rarities add up to the deck")

for _, word in ipairs(Cards.tagWords.regions) do
    local want = Browse.counts(state, { region = word })
    local got = progress.regions[word] or { cards = 0, owned = 0 }
    check(got.cards == want.cards and got.owned == want.owned, "region " .. word .. " matches Browse.counts")
end

-- nothing owned, and everything owned
local empty = Browse.progress({ owned = {} })
check(empty.all.owned == 0 and empty.all.cards == #Cards.list, "an empty collection owns nothing")
local full = { owned = {} }
for _, card in ipairs(Cards.list) do
    full.owned[Cards.variantKey(card.id, "normal")] = 1
end
local complete = Browse.progress(full)
check(complete.all.owned == complete.all.cards, "a full collection owns everything")
for id, bucket in pairs(complete.rarities) do
    check(bucket.owned == bucket.cards, "a full collection owns every " .. id)
end

-- copies not seen yet do not count
do
    local one = { owned = { [Cards.variantKey(Cards.list[1].id, "normal")] = 1, [Cards.variantKey(Cards.list[2].id, "normal")] = 3 } }
    local hidden = { [Cards.variantKey(Cards.list[1].id, "normal")] = 1, [Cards.variantKey(Cards.list[2].id, "normal")] = 1 }
    check(Browse.progress(one).all.owned == 2, "two cards owned")
    check(Browse.progress(one, hidden).all.owned == 1, "a card whose only copy is unseen does not count, one with a spare does")
end

if failures == 0 then
    print("OK: Browse.progress agrees with Browse.counts for the deck, kinds, rarities and regions")
else
    print(failures .. " check(s) failed")
    os.exit(1)
end
