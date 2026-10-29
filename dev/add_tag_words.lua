-- dev/add_tag_words.lua
-- Adds the tag words the cards use that core/cards.lua does not list yet, so a new location or
-- category from the Card Builder or the Wiki Review never stops the plugin loading. Only words a
-- card actually uses are added (the wiki suggests many that are changed or dropped in the
-- builder):
--   location      -> the end of Cards.tagWords.location
--   NPC category  -> the "What it is" group of Cards.tagGroups.category (move it to a better
--                    group by hand if it is what the NPC does, or whether it can be fought)
-- Other words that are not listed are only reported: regions, skills and membership are fixed
-- lists, so there it is a typo; item categories go in the right group of
-- Cards.itemTagGroups.category by hand. Then every card is loaded (dev/check_cards.lua).
--
-- Run from the plugin's folder (CardsOfGielinor):
--   lua dev/add_tag_words.lua            add the words, then check the cards
--   lua dev/add_tag_words.lua --dry-run  only say what would be added

package.path = "./?.lua;" .. package.path

local CARDS_FILE = "core/cards.lua"
local dryRun = arg[1] == "--dry-run"

local file = assert(io.open(CARDS_FILE, "rb"))
local text = file:read("a")
file:close()
local newline = text:find("\r\n", 1, true) and "\r\n" or "\n"

-- Where a list is in the text: the start and end of the first { ... } after `pattern` (found from
-- `init`; `plain` for a pattern without magic characters).
local function listAt(pattern, init, plain)
    local _, after = text:find(pattern, init, plain)
    assert(after, "core/cards.lua no longer has " .. pattern)
    return text:find("%b{}", after + 1)
end

-- The quoted words in the { ... } at first..last, as a set.
local function wordsAt(first, last)
    local set = {}
    for word in text:sub(first, last):gmatch('"([^"]+)"') do
        set[word] = true
    end
    return set
end

local tagWordsAt = listAt("Cards.tagWords = ", 1, true)
local function tagWordsList(kind)
    return listAt(kind .. "%s*=%s*", tagWordsAt)
end

local known = {}
for _, kind in ipairs({ "regions", "location", "skills", "membership" }) do
    known[kind] = wordsAt(tagWordsList(kind))
end
known.npcCategory = wordsAt(listAt("Cards%.tagGroups%s*=%s*"))
known.itemCategory = wordsAt(listAt("Cards%.itemTagGroups%s*=%s*"))

-- Every word the cards use that is not listed, by where it goes ("other": only reported). Each
-- list holds its words in order, and each word the cards that use it.
local missing = { location = {}, npcCategory = {}, other = {} }
local function note(listName, word, label)
    -- (a tag word is lowercase letters, digits and underscores; anything else is a typo)
    if listName ~= "other" and not word:match("^[a-z0-9_]+$") then
        listName, label = "other", label .. ": not a tag word (lowercase letters, digits and _)"
    end
    local list = missing[listName]
    if list[word] == nil then
        list[word] = {}
        list[#list + 1] = word
    end
    table.insert(list[word], label)
end

for _, setName in ipairs(require("deck/index")) do
    local set = require(setName)
    for _, card in ipairs(set.cards or {}) do
        local item = card.kind == "item"
        local label = tostring(card.id) .. " (" .. setName .. ")"
        for _, tags in ipairs({ card.tags or {}, set.defaults or {} }) do
            for tagKind, words in pairs(tags) do
                for _, word in ipairs(words) do
                    if tagKind == "category" then
                        if not (item and known.itemCategory or known.npcCategory)[word] then
                            note(item and "other" or "npcCategory", word, label .. (item and ": item category" or ""))
                        end
                    elseif tagKind == "location" then
                        if not known.location[word] then
                            note("location", word, label)
                        end
                    elseif known[tagKind] ~= nil and not known[tagKind][word] then
                        note("other", word, label .. ": " .. tagKind)
                    end
                end
            end
        end
    end
end

-- Adds words to the end of the { ... } at first..last, on a new line indented like `indent`.
local function addToList(first, last, words, indent)
    local quoted = {}
    for _, word in ipairs(words) do
        quoted[#quoted + 1] = '"' .. word .. '"'
    end
    local body = text:sub(first, last):gsub("%s*}$", "")
    text = text:sub(1, first - 1) .. body .. "," .. newline .. indent .. table.concat(quoted, ", ") .. " }"
        .. text:sub(last + 1)
end

local function report(title, listName)
    for _, word in ipairs(missing[listName]) do
        print(title .. word .. "  (" .. table.concat(missing[listName][word], ", ") .. ")")
    end
end

report(dryRun and "would add location " or "added location ", "location")
report(dryRun and "would add NPC category " or "added NPC category ", "npcCategory")
if #missing.location + #missing.npcCategory == 0 then
    print("Every location and NPC category the cards use is in core/cards.lua.")
elseif not dryRun then
    -- (the category list is after the location list, so it is changed first)
    if #missing.npcCategory > 0 then
        local first, last = listAt('{ title = "What it is", words = ', 1, true)
        addToList(first, last, missing.npcCategory, "            ")
    end
    if #missing.location > 0 then
        local first, last = tagWordsList("location")
        addToList(first, last, missing.location, "                 ")
    end
    file = assert(io.open(CARDS_FILE, "wb"))
    file:write(text)
    file:close()
end
if #missing.other > 0 then
    print("To fix by hand (not added):")
    report("  ", "other")
end
if dryRun then
    return
end

-- Every card loads now? The deck files are loaded again, fresh, by the check.
for name in pairs(package.loaded) do
    if name:match("^deck/") then
        package.loaded[name] = nil
    end
end
dofile("dev/check_cards.lua")
