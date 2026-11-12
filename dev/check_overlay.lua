-- dev/check_overlay.lua
-- Checks that the deck survives being turned into overlay lines and back: the JSON encoder (dev/jsonencode.lua),
-- the lines (dev/overlay_lines.lua), the decoder (core/json.lua) and Cards.register. The test exports every card,
-- decodes every line, registers the cards into an empty registry, and compares every field of every card with
-- the original. Any difference is a bug in one of them. The "Check cards" workflow runs it.
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_overlay.lua

package.path = "./?.lua;./dev/?.lua;" .. package.path

function log() end          -- the client's log function

local Json = require("core/json")
local Cards = require("core/cards")
local Encode = require("jsonencode")
local Lines = require("overlay_lines")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function deepEqual(a, b)
    if type(a) ~= type(b) then
        return false
    end
    if type(a) ~= "table" then
        return a == b
    end
    for key, value in pairs(a) do
        if not deepEqual(value, b[key]) then
            return false
        end
    end
    for key in pairs(b) do
        if a[key] == nil then
            return false
        end
    end
    return true
end

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end
    local copy = {}
    for key, inner in pairs(value) do
        copy[key] = deepCopy(inner)
    end
    return copy
end

-- The encoder ---------------------------------------------------------------------------------------------------
local function encodes(value, expected, what)
    local ok, text = pcall(Encode.encode, value)
    check(ok and text == expected, what .. " (got " .. tostring(text) .. ")")
end

local function refusesToEncode(value, what)
    local ok = pcall(Encode.encode, value)
    check(not ok, what .. ": should be refused")
end

encodes("hi", '"hi"', "a string")
encodes('a"b\\c', '"a\\"b\\\\c"', "quote and backslash")
encodes("a\nb\tc\r\b\f", '"a\\nb\\tc\\r\\b\\f"', "short escapes")
encodes("a\1b\31", '"a\\u0001b\\u001f"', "other control characters")
encodes("\195\169 \226\130\172 \240\159\152\128", '"\195\169 \226\130\172 \240\159\152\128"', "UTF-8 is written as it is")
encodes(true, "true", "true")
encodes(false, "false", "false")
encodes(Json.null, "null", "null")
encodes(0, "0", "zero")
encodes(-17, "-17", "a negative whole number")
encodes(916.0, "916", "a whole number held as a float")
encodes(0.2, "0.2", "0.2")
encodes(-0.04, "-0.04", "-0.04")
encodes(1.5, "1.5", "1.5")
encodes(0.1 + 0.2, "0.30000000000000004", "a number that needs 17 digits")
encodes({}, "[]", "an empty table")
encodes({ 1, 2, 3 }, "[1,2,3]", "an array")
encodes({ b = 1, a = { 2 } }, '{"a":[2],"b":1}', "an object, keys in order")
encodes({ { x = 1 }, {} }, '[{"x":1},[]]', "nesting")
refusesToEncode(function() end, "a function")
refusesToEncode({ 1, 2, a = 3 }, "a table mixing a list and keys")
refusesToEncode({ [1] = "a", [3] = "c" }, "a list with a gap")
refusesToEncode({ [true] = 1 }, "a key that is not text")
refusesToEncode(0 / 0, "NaN")
refusesToEncode(math.huge, "infinity")
do
    local loop = {}
    loop[1] = loop
    refusesToEncode(loop, "a table that contains itself")
end
for _, number in ipairs({ 0.1, 1 / 3, 123456.789, 1e-7, 2.5e20, -3.14159, 0.20000000000000001, 1e15 + 0.5 }) do
    local text = Encode.encode(number)
    check(tonumber(text) == number, "the number " .. text .. " reads back as itself")
    check(Json.decode(text) == number, "the decoder reads " .. text .. " back as itself")
end

-- The deck as lines ----------------------------------------------------------------------------------------------
local lines = Lines.cards(Cards)
check(#lines == #Cards.list and #lines > 0, "one line for every live card (" .. #lines .. " and " .. #Cards.list .. ")")
check(table.concat(Lines.cards(Cards), "\n") == table.concat(lines, "\n"), "exporting twice gives the same lines")

local last = ""
local ordered, canonical, bare = true, true, true
for _, line in ipairs(lines) do
    local card = Json.decode(line)
    if card == nil then
        check(false, "a line that does not decode: " .. line:sub(1, 80))
        break
    end
    ordered = ordered and card.id > last
    last = card.id
    canonical = canonical and Encode.encode(card) == line
    bare = bare and line:find("\n", 1, true) == nil
end
check(ordered, "the lines are in order of id, with no id twice")
check(canonical, "a line is what the encoder writes for its own decoded card")
check(bare, "no line holds a line break")

-- Back into a registry: every card, every field ----------------------------------------------------------------------
local originals, ids = {}, {}
for _, card in ipairs(Cards.list) do
    originals[card.id] = deepCopy(card)
    ids[#ids + 1] = card.id
end
for _, id in ipairs(ids) do
    Cards.deprecate(id)
end
check(#Cards.list == 0 and next(Cards.byId) == nil, "the registry is empty before the cards are read back")

local refused = 0
for _, line in ipairs(lines) do
    local card = Json.decode(line)
    local ok, why = Cards.register(card)
    if not ok then
        refused = refused + 1
        if refused <= 3 then
            io.stderr:write("refused " .. tostring(card.id) .. ": " .. tostring(why) .. "\n")
        end
    end
end
Cards.resort()
check(refused == 0, refused .. " cards were refused by Cards.register")
check(#Cards.list == #ids, "as many cards come back as went out (" .. #Cards.list .. " and " .. #ids .. ")")

local different = 0
for _, id in ipairs(ids) do
    local back = Cards.byId[id]
    if back == nil or not deepEqual(back, originals[id]) then
        different = different + 1
        if different <= 3 then
            io.stderr:write("differs: " .. id .. "\n")
        end
    end
end
check(different == 0, different .. " cards differ from the deck after the round trip")

local lastRank, sorted = 0, true
for _, card in ipairs(Cards.list) do
    local rank = Cards.rarityRank[card.rarity]
    sorted = sorted and rank >= lastRank
    lastRank = rank
end
check(sorted, "the registry is lowest rarity first after the resort")

-- What the game reads from a card is the same too
local artDifferent = 0
for _, id in ipairs(ids) do
    if not deepEqual(Cards.getArt(Cards.byId[id]), Cards.getArt(originals[id])) then
        artDifferent = artDifferent + 1
    end
end
check(artDifferent == 0, artDifferent .. " cards have different art after the round trip")

if failures > 0 then
    io.stderr:write(failures .. " overlay check(s) failed\n")
    os.exit(1)
end
print("Overlay checks passed (" .. #ids .. " cards round-tripped).")
