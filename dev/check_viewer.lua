-- dev/check_viewer.lua
-- Checks what the collection viewer shows (core/browse.lua): the search, each filter, the sorts and the counts,
-- against the real deck. Each result is compared with a plain loop over Cards.list written here, so a filter that
-- quietly matches too much or too little is found. No client is needed.
--
-- Run from the plugin's folder:  lua dev/check_viewer.lua

package.path = "./?.lua;" .. package.path
function log() end

local Cards = require("core/cards")
local Browse = require("core/browse")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function ids(entries)
    local list = {}
    for index, entry in ipairs(entries) do
        list[index] = entry.card.id .. "|" .. entry.finish
    end
    return table.concat(list, ",")
end

-- The ids of the cards for which `keep` is true, in deck order, as the entries of an all-variants list would have them.
local function expected(keep)
    local list = {}
    for _, card in ipairs(Cards.list) do
        if keep(card) then
            for finish in pairs(Cards.finishes) do
                list[#list + 1] = card.id .. "|" .. finish
            end
        end
    end
    return table.concat(list, ",")
end

local function sameSet(filter, keep, what)
    local got, want = ids(Browse.entries({ owned = {} }, filter)), expected(keep)
    check(got == want, what .. " (got " .. #got .. " characters, expected " .. #want .. ")")
    return got ~= ""
end

local deckSize = #Cards.list
check(deckSize > 1000, "the real deck is loaded (" .. deckSize .. " cards)")

-- A collection: a few cards owned, one the deck does not have.
local sample = { Cards.list[1], Cards.list[2], Cards.list[100], Cards.list[deckSize] }
local state = { owned = {} }
for index, card in ipairs(sample) do
    state.owned[Cards.variantKey(card.id, "normal")] = index
end
state.owned["a_card_that_was_removed|normal"] = 9

-- no filter: every card, in deck order, the way the viewer always listed them
local all = Browse.entries(state, nil)
check(#all == deckSize, "no filter lists every card once (" .. #all .. " of " .. deckSize .. ")")
check(ids(all) == expected(function() return true end), "and in the deck's order")
check(ids(Browse.entries(state, {})) == ids(all) and ids(Browse.entries(state, { owned = "all" })) == ids(all),
    "an empty filter and owned = all are the same")

-- owned and unowned
local owned = Browse.entries(state, { owned = "owned" })
check(#owned == #sample, "owned lists the cards the player has, and not one the deck no longer has (" .. #owned .. ")")
check(owned[1].card.id == sample[1].id and owned[1].count == 1 and owned[1].locked == false, "an owned entry has its count and is not locked")
local unowned = Browse.entries(state, { owned = "unowned" })
check(#unowned == deckSize - #sample, "unowned lists the rest (" .. #unowned .. ")")
check(unowned[1].count == 0 and unowned[1].locked == true, "an unowned entry has count 0 and is locked")
check(#Browse.entries({ owned = {} }, { owned = "owned" }) == 0, "a player with nothing owns nothing")

-- kind
local npcs, items = 0, 0
for _, card in ipairs(Cards.list) do
    if Cards.kindOf(card) == "item" then items = items + 1 else npcs = npcs + 1 end
end
check(#Browse.entries(state, { kind = "npc" }) == npcs and #Browse.entries(state, { kind = "item" }) == items, "kind splits the deck into NPC and item cards")
check(npcs + items == deckSize and npcs > 0 and items > 0, "(and both kinds exist)")

-- rarity
for rarity in pairs(Cards.rarities) do
    local want = 0
    for _, card in ipairs(Cards.list) do
        if card.rarity == rarity then want = want + 1 end
    end
    check(#Browse.entries(state, { rarity = rarity }) == want, "rarity " .. rarity .. " matches " .. want .. " cards")
end

-- the tag filters, each with a word the deck really uses
local function firstWord(tagKind)
    for _, card in ipairs(Cards.list) do
        local list = card.tags and card.tags[tagKind]
        if list ~= nil and list[1] ~= nil then
            return list[1]
        end
    end
end
for field, tagKind in pairs({ region = "regions", skill = "skills", category = "category", membership = "membership" }) do
    local word = firstWord(tagKind)
    check(word ~= nil, "the deck uses a " .. tagKind .. " word")
    if word ~= nil then
        local found = sameSet({ [field] = word }, function(card) return Cards.hasTag(card, tagKind, word) end,
            field .. " = " .. word .. " matches the cards tagged with it")
        check(found, field .. " = " .. word .. " matches something")
    end
end
check(#Browse.entries(state, { region = "no_such_region" }) == 0, "a word no card has matches nothing")
check(#Browse.entries(state, { rarity = "mythic" }) == 0, "a rarity that does not exist matches nothing")

-- search
local function nameHas(card, text) return string.find(string.lower(card.name), text, 1, true) ~= nil end
sameSet({ search = "dragon" }, function(card) return nameHas(card, "dragon") end, "search finds names with the word")
sameSet({ search = "DrAgOn" }, function(card) return nameHas(card, "dragon") end, "search ignores case")
sameSet({ search = "  dragon  " }, function(card) return nameHas(card, "dragon") end, "and extra spaces")
sameSet({ search = "rune sword" }, function(card) return nameHas(card, "rune") and nameHas(card, "sword") end,
    "every word of a search must be in the name, in any order")
sameSet({ search = "sword rune" }, function(card) return nameHas(card, "rune") and nameHas(card, "sword") end, "(whichever order)")
check(#Browse.entries(state, { search = "zzzzqqq" }) == 0, "a search nothing matches gives an empty list")
check(ids(Browse.entries(state, { search = "" })) == ids(all) and ids(Browse.entries(state, { search = "   " })) == ids(all),
    "an empty search is no search")
check(pcall(Browse.entries, state, { search = "%" }) and pcall(Browse.entries, state, { search = "(" }), "pattern characters in a search do not error")

-- filters combine (every one must pass)
local word = firstWord("skills")
sameSet({ kind = "item", skill = word, search = "a" }, function(card)
    return Cards.kindOf(card) == "item" and Cards.hasTag(card, "skills", word) and nameHas(card, "a")
end, "kind, skill and search together")
local combined = Browse.entries(state, { owned = "owned", kind = sample[1].kind or "npc" })
local keptAll = true
for _, entry in ipairs(combined) do
    keptAll = keptAll and not entry.locked
end
check(keptAll, "owned and kind together: nothing locked")

-- sorts
local byName = Browse.entries(state, { sort = "name" })
local sorted = #byName == deckSize
for index = 2, #byName do
    if string.lower(byName[index - 1].card.name) > string.lower(byName[index].card.name) then
        sorted = false
    end
end
check(sorted, "name sort puts the names in alphabetical order, case ignored")

local rankOf = function(entry) return Cards.rarityRank[entry.card.rarity] or 0 end
local up, down = Browse.entries(state, { sort = "rarity" }), Browse.entries(state, { sort = "rarity_desc" })
local upOk, downOk = true, true
for index = 2, #up do
    if rankOf(up[index - 1]) > rankOf(up[index]) then upOk = false end
    if rankOf(down[index - 1]) < rankOf(down[index]) then downOk = false end
end
check(upOk and downOk and #down == deckSize, "rarity sorts low to high and high to low")
check(rankOf(down[1]) >= rankOf(down[#down]), "(and the first of the high-to-low list is the rarest)")

local byOwned = Browse.entries(state, { sort = "owned" })
check(byOwned[1].count == #sample and byOwned[#sample].count == 1 and byOwned[#sample + 1].count == 0,
    "owned sort puts the most copies first, then the unowned")
check(#byOwned == deckSize, "(every entry is still there)")

-- a sort does not lose or repeat entries
local function sortedIds(entries)
    local list = {}
    for index, entry in ipairs(entries) do list[index] = entry.card.id .. "|" .. entry.finish end
    table.sort(list)
    return table.concat(list, ",")
end
check(sortedIds(byName) == sortedIds(all) and sortedIds(down) == sortedIds(all) and sortedIds(byOwned) == sortedIds(all),
    "every sort holds exactly the same entries")

-- counts: the progress of the set shown
local counts = Browse.counts(state, nil)
check(counts.cards == deckSize and counts.owned == #sample, "counts: the whole deck, and the cards owned (" .. counts.cards .. ", " .. counts.owned .. ")")
local itemCounts = Browse.counts(state, { kind = "item" })
check(itemCounts.cards == items, "counts follow the filter")
check(Browse.counts(state, { kind = "item", owned = "unowned", sort = "name" }).cards == items, "counts ignore owned and sort")
check(Browse.counts({ owned = {} }, nil).owned == 0, "counts: nothing owned")

-- label
check(Browse.label("kharidian_desert") == "Kharidian desert" and Browse.label("f2p") == "F2p" and Browse.label("food") == "Food",
    "a tag word is labelled for a list")

if failures > 0 then
    io.stderr:write(failures .. " check(s) failed\n")
    os.exit(1)
end
print("OK: the viewer's search, filters and sorts match the deck (" .. deckSize .. " cards)")
