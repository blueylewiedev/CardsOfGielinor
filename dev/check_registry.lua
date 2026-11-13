-- dev/check_registry.lua
-- Checks the parts of core/cards.lua that add, replace and retire cards after the deck has loaded (what the
-- over-the-air overlay uses): Cards.problem, Cards.register, Cards.deprecate and Cards.resort. A card that is
-- not sound must be refused with a message and change nothing; a replaced card must be changed in place.
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_registry.lua

package.path = "./?.lua;" .. package.path

function log() end          -- the client's log function

local Cards = require("core/cards")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function snapshot()
    local ids = {}
    for index, card in ipairs(Cards.list) do
        ids[index] = card.id
    end
    return table.concat(ids, ",")
end

local liveBefore = #Cards.list
local orderBefore = snapshot()

local function card(fields)
    local made = { id = "zz_test_card", name = "Test card", kind = "item", rarity = "common", desc = "A test.",
        art = { item = "TEST" }, tags = { category = { "armour" } } }
    for key, value in pairs(fields or {}) do
        made[key] = value
    end
    return made
end

-- Cards.problem --------------------------------------------------------------------------------------------
check(Cards.problem(card()) == nil, "a sound card has no problem (" .. tostring(Cards.problem(card())) .. ")")
check(Cards.problem(Cards.list[1]) == nil, "a card from the deck has no problem")
check(Cards.problem("hans") ~= nil, "a text is not a card")
check(Cards.problem(card({ id = false })) ~= nil, "no id")
check(Cards.problem(card({ id = "" })) ~= nil, "an empty id")
check(Cards.problem(card({ id = "a|b" })) ~= nil, "an id with a bar")
check(Cards.problem(card({ name = false })) ~= nil, "no name")
check(Cards.problem(card({ rarity = "mythic" })) ~= nil, "an unknown rarity")
check(Cards.problem(card({ rarity = false })) ~= nil, "no rarity")
check(Cards.problem(card({ kind = "monster" })) ~= nil, "an unknown kind")
check(Cards.problem(card({ art = "TEST" })) ~= nil, "art that is not a table")
check(Cards.problem(card({ tags = "armour" })) ~= nil, "tags that are not a table")
check(Cards.problem(card({ tags = { category = "armour" } })) ~= nil, "a tag kind that is not a list")
check(Cards.problem(card({ tags = { category = { 7 } } })) ~= nil, "a tag word that is not text")
check(Cards.problem(card({ tags = { category = { "no_such_word" } } })) ~= nil, "an unknown tag word")
check(Cards.problem(card({ tags = { membership = { "f2p", "p2p" } } })) ~= nil, "two membership words")
check(Cards.problem(card({ variants = {} })) ~= nil, "empty variants")
check(Cards.problem(card({ variants = { { name = "x" } } })) ~= nil, "a variant with no item")
check(Cards.problem(card({ variants = { { item = "A" }, { item = "B" } } })) == nil, "sound variants")
do
    local message = Cards.problem(card({ rarity = "mythic" }))
    check(type(message) == "string" and string.find(message, "zz_test_card", 1, true) ~= nil, "a message names the card")
end

-- every kind of problem names the card (in the client `id` is the game's table, which is how a slip here showed)
for _, wrong in ipairs({
    { tags = { category = { "no_such_word" } } },
    { tags = { category = "armour" } },
    { tags = { category = { 7 } } },
    { tags = { membership = { "f2p", "p2p" } } },
    { tags = { regions = { "misthalin", "asgarnia", "kandarin" } } },
    { rarity = "mythic" },
    { variants = {} },
}) do
    local message = Cards.problem(card(wrong))
    check(type(message) == "string" and string.find(message, "zz_test_card", 1, true) ~= nil,
        "the message names the card: " .. tostring(message))
end

-- Cards.register: a new card ---------------------------------------------------------------------------------
do
    local ok, why = Cards.register(card())
    check(ok == true and why == nil, "a new card is added (" .. tostring(why) .. ")")
    check(#Cards.list == liveBefore + 1 and Cards.byId["zz_test_card"] ~= nil, "it is in the list and the lookup")
end

-- Cards.register: replacing in place
do
    local held = Cards.byId["zz_test_card"]
    local ok = Cards.register(card({ name = "Renamed", rarity = "legendary", desc = "New words." }))
    check(ok == true, "a card with the same id is replaced")
    check(Cards.byId["zz_test_card"] == held, "it is the same table, changed in place")
    check(held.name == "Renamed" and held.rarity == "legendary" and held.desc == "New words.", "its fields are the new ones")
    check(#Cards.list == liveBefore + 1, "the count did not change")
    local replaced = Cards.register(card({ desc = false, art = nil }))
    check(replaced == true and held.name == "Test card" and held.rarity == "common", "an older field does not survive a replace")
    local extra = card()
    extra.variants = { { item = "A" } }
    Cards.register(extra)
    Cards.register(card())
    check(held.variants == nil, "a field the new card lacks is gone")
end

-- Cards.register: refused cards change nothing -----------------------------------------------------------------
do
    local before = snapshot()
    local held = Cards.byId["zz_test_card"]
    local ok, why = Cards.register(card({ rarity = "mythic" }))
    check(ok == nil and type(why) == "string", "an unsound replacement is refused with a reason")
    check(held.rarity == "common" and Cards.byId["zz_test_card"] == held, "the card is as it was")
    ok, why = Cards.register(card({ id = "zz_draft", art = { item = "" } }))
    check(ok == nil and string.find(why, "draft", 1, true) ~= nil, "a draft is refused")
    check(Cards.byId["zz_draft"] == nil, "a refused card is not added")
    ok = Cards.register(card({ id = "zz_bad", tags = { category = { "no_such_word" } } }))
    check(ok == nil and Cards.byId["zz_bad"] == nil, "a card with a bad tag is not added")
    check(snapshot() == before, "the list is as it was")
end

-- Cards.resort ----------------------------------------------------------------------------------------------
do
    Cards.register(card({ rarity = "legendary" }))
    Cards.register(card({ id = "zz_test_two", name = "Two", rarity = "common" }))
    Cards.resort()
    local lastRank, ordered = 0, true
    for _, listed in ipairs(Cards.list) do
        local rank = Cards.rarityRank[listed.rarity] or 0
        if rank < lastRank then
            ordered = false
        end
        lastRank = rank
    end
    check(ordered, "the list is lowest rarity first after a resort")
    check(Cards.list[#Cards.list] == Cards.byId["zz_test_card"], "the new legendary card is last")
end

-- Cards.deprecate ---------------------------------------------------------------------------------------------
do
    check(Cards.deprecate("zz_test_card") == true, "a card is retired")
    check(Cards.byId["zz_test_card"] == nil, "it leaves the lookup")
    local found = false
    for _, listed in ipairs(Cards.list) do
        found = found or listed.id == "zz_test_card"
    end
    check(not found, "it leaves the list")
    check(Cards.deprecate("zz_test_card") == false, "retiring it again says there was no such card")
    check(Cards.deprecate("no_such_card") == false, "an unknown id says so")
    Cards.deprecate("zz_test_two")
    check(#Cards.list == liveBefore, "the list is back to its size")
    check(snapshot() == orderBefore, "and in its old order")
end

-- A deck with something wrong in it still loads: what is wrong is left out and described in Cards.loadProblems --
-- (dev/check_cards.lua turns a problem into a failure for the pull request check, and the dev copy of the plugin
-- stops on one; a released plugin carries on).
-- `files` is { file name = what it returns }; `packs` is what deck/packs.lua returns.
local function loadDeck(files, packs)
    package.loaded["core/cards"] = nil
    local names = {}
    for name, value in pairs(files) do
        names[#names + 1] = name
        package.loaded[name] = nil
        package.preload[name] = function()
            if value == "error" then
                error("boom")
            end
            return value
        end
    end
    table.sort(names)
    package.loaded["deck/index"] = names
    package.loaded["deck/packs"] = packs or {}
    local ok, result = pcall(require, "core/cards")
    return ok, result
end

local function mentions(loaded, text)
    for _, message in ipairs(loaded.loadProblems or {}) do
        if string.find(message, text, 1, true) then
            return true
        end
    end
    return false
end

do
    local sound = { id = "a", name = "A", rarity = "common" }
    local ok, loaded = loadDeck({ fake_a = { cards = { sound } } })
    check(ok and #loaded.list == 1 and #loaded.loadProblems == 0, "a sound one-card deck loads with no problems")

    ok, loaded = loadDeck({ fake_a = { cards = { sound, { id = "a", name = "Again", rarity = "common" } } } })
    check(ok and #loaded.list == 1 and loaded.byId["a"].name == "A" and mentions(loaded, "used by two cards"),
        "a duplicate id: the first card stays and the second is reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound, { id = "b", name = "B", rarity = "mythic" } } } })
    check(ok and #loaded.list == 1 and loaded.byId["b"] == nil and mentions(loaded, "Unknown rarity on card b"),
        "an unknown rarity: the card is left out and reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound, { id = "c", name = "C", rarity = "common",
        tags = { skills = { "no_such_skill" } } } } } })
    check(ok and #loaded.list == 1 and mentions(loaded, "unknown skills tag"), "an unknown tag word: left out and reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound, { id = "d|e", name = "D", rarity = "common" } } } })
    check(ok and #loaded.list == 1 and mentions(loaded, "cannot contain"), "an id with a bar: left out and reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound, { id = "f", name = "F", rarity = "common",
        tags = { skills = { false } } } } } })
    check(ok and #loaded.list == 1 and mentions(loaded, "must be text"), "a tag word that is not text: left out and reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound, "not a card", { name = "no id" } } } })
    check(ok and #loaded.list == 1 and #loaded.loadProblems == 2, "a card that is not a table, or has no id: left out and reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound, { id = "g", name = "G", art = { npc = "" },
        tags = { skills = { "no_such_skill" } } } } } })
    check(ok and #loaded.drafts == 0 and mentions(loaded, "unknown skills tag"), "a draft with a bad tag is left out and reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound } }, fake_b = "error", fake_c = { cards = { { id = "h", name = "H",
        rarity = "common" } } } })
    check(ok and #loaded.list == 2 and mentions(loaded, "fake_b did not load"),
        "a deck file that fails to load is left out and the other files still load")

    ok, loaded = loadDeck({ fake_a = { cards = { sound } } }, { { id = "mine", name = "Mine", minRarity = "mythic" } })
    check(ok and loaded.packTypes["mine"] == nil and mentions(loaded, "Unknown minRarity on pack mine"),
        "a pack with an unknown minRarity is left out and reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound } } }, { { id = "mine2", name = "M", filter = { skills = { "nope" } } } })
    check(ok and loaded.packTypes["mine2"] == nil and mentions(loaded, "filters on unknown"), "a pack filtering on a bad word is left out")

    ok, loaded = loadDeck({ fake_a = { cards = { sound } } }, { { id = "dup", name = "1" }, { id = "dup", name = "2" } })
    check(ok and loaded.packTypes["dup"].name == "1" and mentions(loaded, "Duplicate pack type id dup"), "a duplicate pack id is reported")

    ok, loaded = loadDeck({ fake_a = { cards = { sound } } }, { { name = "no id" } })
    check(ok and mentions(loaded, "has no id"), "a pack with no id is left out")

    ok, loaded = loadDeck({ fake_a = { cards = { sound } } }, { { id = "standard", name = "Renamed standard" } })
    check(ok and loaded.packTypes.standard.name == "Renamed standard", "a line for a pack type that exists still changes it")
end

if failures > 0 then
    io.stderr:write(failures .. " registry check(s) failed\n")
    os.exit(1)
end
print("Registry checks passed.")
