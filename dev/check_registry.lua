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

-- The deck is still strict: a bad card stops the plugin loading, and the message names the card ---------------
local function loadDeck(cards)
    package.loaded["core/cards"] = nil
    package.loaded["deck/index"] = { "fake_deck_file" }
    package.loaded["fake_deck_file"] = { cards = cards }
    local ok, err = pcall(require, "core/cards")
    return ok, tostring(err)
end

do
    local sound = { id = "a", name = "A", rarity = "common" }
    local ok, err = loadDeck({ sound })
    check(ok, "a sound one-card deck loads (" .. err .. ")")
    ok, err = loadDeck({ sound, { id = "a", name = "Again", rarity = "common" } })
    check(not ok and string.find(err, "used by two cards", 1, true) ~= nil, "a duplicate id stops the load (" .. err .. ")")
    ok, err = loadDeck({ { id = "b", name = "B", rarity = "mythic" } })
    check(not ok and string.find(err, "Unknown rarity on card b", 1, true) ~= nil, "an unknown rarity stops the load (" .. err .. ")")
    ok, err = loadDeck({ { id = "c", name = "C", rarity = "common", tags = { skills = { "no_such_skill" } } } })
    check(not ok and string.find(err, "unknown skills tag", 1, true) ~= nil, "an unknown tag word stops the load (" .. err .. ")")
    ok, err = loadDeck({ { id = "d|e", name = "D", rarity = "common" } })
    check(not ok and string.find(err, "cannot contain", 1, true) ~= nil, "an id with a bar stops the load (" .. err .. ")")
    ok, err = loadDeck({ { id = "f", name = "F", rarity = "common", tags = { skills = { false } } } })
    check(not ok and string.find(err, "must be text", 1, true) ~= nil, "a tag word that is not text stops the load (" .. err .. ")")
end

if failures > 0 then
    io.stderr:write(failures .. " registry check(s) failed\n")
    os.exit(1)
end
print("Registry checks passed.")
