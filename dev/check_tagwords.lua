-- dev/check_tagwords.lua
-- Checks core/tagwords.lua: the word lists are sound (no word twice in a list, no word that is both an NPC and an item category,
-- the category list is the groups' words, every `requires` word exists) and the functions about them answer as the card checks
-- and the Card Builder expect. The "Check cards" workflow runs it.
--
-- Run from the plugin's folder:  lua dev/check_tagwords.lua

package.path = "./?.lua;" .. package.path

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        print("FAIL: " .. what)
    end
end

local TagWords = require("core/tagwords")

local function set(list)
    local out = {}
    for _, word in ipairs(list) do out[word] = true end
    return out
end

-- every list has words, each once, written as a tag word
for kind, list in pairs(TagWords.words) do
    local seen = {}
    check(#list > 0, kind .. " has words")
    for _, word in ipairs(list) do
        check(type(word) == "string" and word:match("^[a-z0-9_]+$") ~= nil, kind .. ": '" .. tostring(word) .. "' is a tag word")
        check(not seen[word], kind .. ": '" .. word .. "' is listed twice")
        seen[word] = true
    end
end

-- the category list is the NPC groups' words, then the item groups'; no word is in both
local npcCategory, itemCategory, expected = {}, {}, {}
for _, group in ipairs(TagWords.groups.category) do
    for _, word in ipairs(group.words) do
        npcCategory[word] = true
        expected[#expected + 1] = word
    end
end
for _, group in ipairs(TagWords.itemGroups.category) do
    for _, word in ipairs(group.words) do
        check(not npcCategory[word], "'" .. word .. "' is an NPC category word and an item one")
        itemCategory[word] = true
        expected[#expected + 1] = word
    end
end
check(#TagWords.words.category == #expected, "the category list holds every group's words (" .. #TagWords.words.category .. " of " .. #expected .. ")")
for index, word in ipairs(expected) do
    if TagWords.words.category[index] ~= word then
        check(false, "the category list is the NPC groups' words then the item groups' (differs at " .. index .. ")")
        break
    end
end

-- a group's `requires` words are item category words, and a group is not empty
for _, group in ipairs(TagWords.itemGroups.category) do
    check(#group.words > 0, "item group '" .. group.title .. "' has words")
    local needs = group.requires
    for _, word in ipairs(type(needs) == "table" and needs or { needs }) do
        check(itemCategory[word], "item group '" .. group.title .. "' requires '" .. word .. "', which is not an item category word")
    end
end

-- wordsFor, groupsFor, requiredWords, missingRequired
check(TagWords.wordsFor(nil, "skills") == TagWords.words.skills, "with no card kind a tag kind's own list is given")
check(TagWords.wordsFor("npc", "regions") == TagWords.words.regions, "a kind with no groups gives its list")
local forItem, forNpc = set(TagWords.wordsFor("item", "category")), set(TagWords.wordsFor("npc", "category"))
check(forItem.food and not forItem.dragon and forNpc.dragon and not forNpc.food, "an item's category words are the item groups', an NPC's the NPC groups'")
check(TagWords.groupsFor("item", "category") == TagWords.itemGroups.category and TagWords.groupsFor("npc", "category") == TagWords.groups.category
    and TagWords.groupsFor("npc", "skills") == nil, "groupsFor gives the groups of the right kind, or nil")
local needs = TagWords.requiredWords("item", "category", "scimitar")
check(needs ~= nil and needs[1] == "weapon", "a scimitar needs a weapon")
check(TagWords.requiredWords("item", "category", "weapon") == nil, "a weapon needs nothing")
check(#TagWords.missingRequired("item", "category", { "scimitar" }) == 1 and TagWords.missingRequired("item", "category", { "scimitar" })[1].needs == "weapon",
    "a scimitar alone is missing its weapon")
check(#TagWords.missingRequired("item", "category", { "scimitar", "weapon" }) == 0, "and with it nothing is missing")

-- isKnown, asked twice (the lists are made into sets the first time)
for _ = 1, 2 do
    check(TagWords.isKnown("regions", "misthalin"), "a known region")
    check(not TagWords.isKnown("regions", "no_such_region"), "an unknown region")
    check(TagWords.isKnown("category", "dragon", "npc") and not TagWords.isKnown("category", "dragon", "item"), "an NPC category word is not an item one")
    check(TagWords.isKnown("category", "food", "item") and not TagWords.isKnown("category", "food", "npc"), "and an item one is not an NPC one")
    check(TagWords.isKnown("category", "food") and TagWords.isKnown("category", "dragon"), "with no card kind either is known")
    check(TagWords.isKnown("not_a_listed_kind", "anything"), "a tag kind with no list accepts any word")
end

if failures > 0 then
    os.exit(1)
end
print("OK: the tag words are sound and their functions answer as expected")
