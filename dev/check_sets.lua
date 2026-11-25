-- dev/check_sets.lua
-- Checks the sets (deck/sets.lua, core/sets.lua): every set in the file is usable against the real deck (its add and
-- leave ids are cards, none ends up empty; one over Sets.SOFT_LIMIT is a warning), and the rules do what deck/sets.lua
-- says: a name takes in its variants and nothing else, filter narrows (by tags, by part of the name, or by any of a list of filters), except
-- keeps out, add and leave win over the rules, and the progress counts what the player owns.
--
-- Run from the plugin's folder:  lua dev/check_sets.lua

package.path = "./?.lua;./dev/?.lua;" .. package.path

function log() end          -- the client's log function

local Cards = require("core/cards")
local Sets = require("core/sets")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function ids(cards)
    local list = {}
    for _, card in ipairs(cards) do
        list[#list + 1] = card.id
    end
    return list
end

local function has(list, value)
    for _, item in ipairs(list) do
        if item == value then
            return true
        end
    end
    return false
end

-- The sets in deck/sets.lua --------------------------------------------------------------------------------------
for _, problem in ipairs(Sets.problems()) do
    check(false, problem)
end
for _, messages in ipairs({ Sets.oversized(), Sets.loneGroups() }) do
    for _, message in ipairs(messages) do
        io.stderr:write("WARNING: " .. message .. "\n")
    end
end
check(#Sets.list > 0, "deck/sets.lua has sets")

-- Names take in their variants only ----------------------------------------------------------------------------------
check(Sets.isVariantOf("Musician", "Musician"), "a name takes in the card of that name")
check(Sets.isVariantOf("Musician (Lumbridge)", "Musician"), "and its variants")
check(not Sets.isVariantOf("Guard dog", "Guard"), "not a card whose name only starts with it")
check(not Sets.isVariantOf("Guardsman Brawn", "Guard"), "nor one that runs on from it")
check(not Sets.isVariantOf("Shopkeeper (Falador)", "Shop"), "a variant must be of the whole name")

local saved = { list = Sets.list, byId = Sets.byId, loadProblems = Sets.loadProblems }

-- The rules, against the real deck --------------------------------------------------------------------------------
Sets.load({
    { id = "musicians", name = "Musicians", names = { "Musician" } },
    { id = "bartenders", name = "Bartenders", names = { "Bartender" }, add = { "cheri" },
        leave = { "bartender_rusty_anchor" } },
    { id = "npc_guards", name = "Guards", names = { "Guard" }, filter = { kind = "npc" } },
    { id = "by_filter", name = "Shopkeepers", filter = { category = "shopkeeper" } },
    { id = "only_added", name = "Two cards", add = { "cheri", "bartender_dancing_donkey" } },
    { id = "except", name = "Not in Lumbridge", filter = { category = "shopkeeper" }, except = { location = "lumbridge" },
        add = { "lumbridge_guard" } },
    { id = "cooks_only", name = "Cooks", filter = { category = "cook" } },
    { id = "either", name = "Either", filter = { { category = "shopkeeper" }, { category = "cook" } } },
    { id = "by_name", name = "Wizards", filter = { kind = "npc", name = { "WIZARD", "mage" } },
        except = { { name = "dark" }, { category = "monster" } } },
})
check(#Sets.loadProblems == 0, "the test sets load (" .. tostring(Sets.loadProblems[1]) .. ")")

local musicians = ids(Sets.cardsOf(Sets.byId.musicians))
check(#musicians >= 6, "Musician takes in every musician (" .. #musicians .. ")")
for _, card in ipairs(Sets.cardsOf(Sets.byId.musicians)) do
    check(Sets.isVariantOf(card.name, "Musician"), card.name .. " is a musician")
end

local bartenders = ids(Sets.cardsOf(Sets.byId.bartenders))
check(has(bartenders, "cheri"), "add puts a card in")
check(not has(bartenders, "bartender_rusty_anchor"), "leave keeps a card out")
check(has(bartenders, "bartender_dancing_donkey"), "the other bartenders stay")

for _, card in ipairs(Sets.cardsOf(Sets.byId.npc_guards)) do
    check(Cards.kindOf(card) == "npc", "the filter keeps " .. card.id .. " out unless it is an NPC")
end

local shopkeepers = Sets.cardsOf(Sets.byId.by_filter)
check(#shopkeepers > 10, "a filter on its own takes in every card it matches (" .. #shopkeepers .. ")")
for _, card in ipairs(shopkeepers) do
    check(Cards.hasTag(card, "category", "shopkeeper"), card.id .. " is a shopkeeper")
end

local kept = Sets.cardsOf(Sets.byId.except)
check(#kept > 0 and #kept < #shopkeepers, "except keeps some of the filter's cards out (" .. #kept .. ")")
for _, card in ipairs(kept) do
    check(card.id == "lumbridge_guard" or not Cards.hasTag(card, "location", "lumbridge"),
        "except keeps " .. card.id .. " out")
end
check(has(ids(kept), "lumbridge_guard"), "add wins over except")

local either = Sets.cardsOf(Sets.byId.either)
check(#Sets.cardsOf(Sets.byId.cooks_only) > 0, "there are cook cards to test with")
check(#either > #shopkeepers, "a list of filters takes in a card that matches any one (" .. #either .. ")")
for _, card in ipairs(either) do
    check(Cards.hasTag(card, "category", "shopkeeper") or Cards.hasTag(card, "category", "cook"),
        card.id .. " matches one of the filters")
end

local named = Sets.cardsOf(Sets.byId.by_name)
check(#named > 0, "name takes in cards by part of their name (" .. #named .. ")")
for _, card in ipairs(named) do
    local lower = string.lower(card.name)
    check(string.find(lower, "wizard", 1, true) or string.find(lower, "mage", 1, true), card.id .. " has wizard or mage in its name")
    check(not string.find(lower, "dark", 1, true), "except by name keeps " .. card.id .. " out")
    check(not Cards.hasTag(card, "category", "monster"), "a list in except keeps " .. card.id .. " out")
end
check(has(ids(named), "wizard_mizgog"), "the name is matched in any case")

local two = ids(Sets.cardsOf(Sets.byId.only_added))
check(#two == 2, "a set of added cards only holds those (" .. #two .. ")")

-- in the deck's order: lowest rarity first
local previous = 0
for _, card in ipairs(Sets.cardsOf(Sets.byId.by_filter)) do
    local rank = Cards.rarityRank[card.rarity]
    check(rank >= previous, "cards are in the deck's order (" .. card.id .. ")")
    previous = rank
end

-- Progress ------------------------------------------------------------------------------------------------------------
local first, second = Sets.cardsOf(Sets.byId.musicians)[1], Sets.cardsOf(Sets.byId.musicians)[2]
local state = { owned = {
    [Cards.variantKey(first.id, "normal")] = 3,
    [Cards.variantKey(second.id, "normal")] = 1,
    ["not_a_card|normal"] = 2,
} }
local progress = Sets.progress(state, Sets.byId.musicians)
check(progress.cards == #musicians and progress.owned == 2, "progress counts the cards owned, not the copies ("
    .. progress.owned .. " of " .. progress.cards .. ")")
check(Sets.progress({ owned = {} }, Sets.byId.musicians).owned == 0, "nothing owned is 0")

-- Sets that are not the right shape are left out, the rest still load ---------------------------------------------
Sets.load({
    { id = "good", name = "Good", names = { "Musician" } },
    { id = "Bad Id", name = "Bad", names = { "Musician" } },
    { id = "no_name", names = { "Musician" } },
    { id = "no_rule", name = "Nothing" },
    { id = "names_text", name = "Text", names = "Musician" },
    { id = "bad_filter", name = "Filter", filter = { kind = 3 } },
    { id = "bad_except", name = "Except", names = { "Musician" }, except = "lumbridge" },
    { id = "bad_list", name = "List", filter = { { category = "cook" }, "chef" } },
    { id = "bad_group", name = "Group", names = { "Musician" }, group = 3 },
    { id = "blank_group", name = "Blank group", names = { "Musician" }, group = " " },
    { id = "good", name = "Twice", names = { "Cook" } },
    "not a table",
})
check(#Sets.list == 1 and Sets.byId.good ~= nil and Sets.byId.good.name == "Good", "only the good set loads")
check(#Sets.loadProblems == 11, "each bad set is described (" .. #Sets.loadProblems .. ")")

-- Groups: a group with one set is a warning
Sets.load({
    { id = "one", name = "One", names = { "Musician" }, group = "Alone" },
    { id = "two", name = "Two", names = { "Musician" }, group = "Pair" },
    { id = "three", name = "Three", names = { "Bartender" }, group = "Pair" },
    { id = "free", name = "Free", names = { "Bartender" } },
})
check(#Sets.loadProblems == 0 and #Sets.list == 4, "sets with groups load")
local lone = table.concat(Sets.loneGroups(), "\n")
check(string.find(lone, "Alone", 1, true) ~= nil and string.find(lone, "Pair", 1, true) == nil,
    "a group with one set is a warning, one with two is not")

-- Problems against the deck ---------------------------------------------------------------------------------------
Sets.load({
    { id = "unknown", name = "Unknown", add = { "no_such_card" } },
    { id = "both", name = "Both", names = { "Bartender" }, add = { "cheri" }, leave = { "cheri" } },
    { id = "empty", name = "Empty", names = { "No card is called this" } },
    { id = "too_big", name = "Too big", filter = { kind = "npc" } },
})
local problems = Sets.problems()
local text = table.concat(problems, "\n")
check(string.find(text, "no_such_card", 1, true) ~= nil, "an unknown id is a problem")
check(string.find(text, "both adds and leaves out cheri", 1, true) ~= nil, "an id in add and leave is a problem")
check(string.find(text, "set empty holds no card", 1, true) ~= nil, "an empty set is a problem")
check(string.find(text, "too_big", 1, true) == nil, "a big set is not a problem")
check(string.find(table.concat(Sets.oversized(), "\n"), "set too_big holds", 1, true) ~= nil,
    "but a set over Sets.SOFT_LIMIT is a warning")

Sets.list, Sets.byId, Sets.loadProblems = saved.list, saved.byId, saved.loadProblems

if failures > 0 then
    io.stderr:write(failures .. " check(s) failed\n")
    os.exit(1)
end
print("sets: all checks passed (" .. #Sets.list .. " sets)")
