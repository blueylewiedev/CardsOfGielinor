-- dev/check_json.lua
-- Checks the JSON decoder (core/json.lua): the standard's good cases, every kind of bad input it must refuse
-- (and never raise an error on), the UTF-8 and unicode escapes, and a decode of the real docs/cards.json
-- compared with the cards the plugin loads. Run it before opening a pull request that touches the decoder;
-- the "Check cards" workflow runs it too.
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_json.lua

package.path = "./?.lua;" .. package.path

function log() end          -- the client's log function

local Json = require("core/json")
local Cards = require("core/cards")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function decodes(text, expected, what)
    local value, err = Json.decode(text)
    check(err == nil and value == expected, what .. " (got " .. tostring(value) .. ", " .. tostring(err) .. ")")
end

local function refuses(text, what)
    local ok, value, err = pcall(Json.decode, text)
    check(ok, what .. ": raised an error instead of returning one")
    check(ok and value == nil and type(err) == "string", what .. ": should be refused")
end

-- Scalars -----------------------------------------------------------------------------------------------
decodes("true", true, "true")
decodes("false", false, "false")
decodes("null", Json.null, "null is Json.null")
decodes("0", 0, "zero")
decodes("-0", 0, "minus zero")
decodes("42", 42, "integer")
decodes("-17", -17, "negative integer")
decodes("3.25", 3.25, "fraction")
decodes("-0.5", -0.5, "negative fraction")
decodes("1e3", 1000, "exponent")
decodes("1E+2", 100, "capital exponent with a plus")
decodes("25e-1", 2.5, "negative exponent")
decodes("  7 \n\t", 7, "whitespace around a value")
decodes('"hi"', "hi", "string")
decodes('""', "", "empty string")

-- Strings -----------------------------------------------------------------------------------------------
decodes([["a\"b\\c\/d"]], 'a"b\\c/d', "quote, backslash, slash escapes")
decodes([["\b\f\n\r\t"]], "\b\f\n\r\t", "control escapes")
decodes([["A"]], "A", "\\u ASCII")
decodes([["é"]], "\195\169", "\\u two-byte letter becomes UTF-8")
decodes([["€"]], "\226\130\172", "\\u three-byte letter (capitals in the hex)")
decodes([["😀"]], "\240\159\152\128", "a surrogate pair becomes one four-byte letter")
decodes('"\195\169 \226\130\172"', "\195\169 \226\130\172", "raw UTF-8 passes through")
decodes('"a\127b"', "a\127b", "DEL is allowed in a string")
decodes('"x\127\\n"', "x\127\n", "DEL then an escape")
decodes([["a\u0000b"]], "a\0b", "\\u0000")
decodes('\239\187\191"bom"', "bom", "a byte order mark is skipped")

-- Containers --------------------------------------------------------------------------------------------
do
    local v = Json.decode('{"a": 1, "b": [true, null, "x", {"c": []}], "d": {}}')
    check(v ~= nil and v.a == 1 and v.b[1] == true and v.b[2] == Json.null and v.b[3] == "x"
        and #v.b[4].c == 0 and next(v.d) == nil and #v.b == 4, "nested containers")
    check(Json.decode("[]") ~= nil and #Json.decode("[]") == 0, "empty array")
    check(next(Json.decode("{}")) == nil, "empty object")
    check(Json.decode('{"k":1,"k":2}').k == 2, "a repeated key keeps the last value")
    local long = {}
    for i = 1, 1000 do
        long[i] = tostring(i)
    end
    local list = Json.decode("[" .. table.concat(long, ",") .. "]")
    check(#list == 1000 and list[1000] == 1000, "a long array")
end

-- Bad input: refused, with a message, never an error ------------------------------------------------------
refuses("", "empty text")
refuses("   ", "only whitespace")
refuses("nul", "a cut-off null")
refuses("tru", "a cut-off true")
refuses("truee", "extra letters after a value")
refuses("[1,]", "a trailing comma in an array")
refuses('{"a":1,}', "a trailing comma in an object")
refuses("[1 2]", "a missing comma")
refuses('{"a" 1}', "a missing colon")
refuses("{a:1}", "an unquoted key")
refuses("{'a':1}", "a single-quoted key")
refuses("[1", "an unterminated array")
refuses('{"a":1', "an unterminated object")
refuses('"abc', "an unterminated string")
refuses('"a\\', "a string ending in a backslash")
refuses('"\\x"', "an unknown escape")
refuses('"\\u12"', "a short \\u escape")
refuses('"\\u12G4"', "a non-hex \\u escape")
refuses('"\\uD800"', "a lone high surrogate")
refuses('"\\uD800x"', "a high surrogate followed by text")
refuses('"\\uD800\\u0041"', "a high surrogate followed by a letter")
refuses('"\\uDC00"', "a lone low surrogate")
refuses('"a\nb"', "a raw newline in a string")
refuses('"a\tb"', "a raw tab in a string")
refuses("01", "a leading zero")
refuses("-01", "a negative leading zero")
refuses("1.", "a dot with no digits")
refuses(".5", "no digits before the dot")
refuses("1e", "an exponent with no digits")
refuses("1e+", "an exponent sign with no digits")
refuses("+1", "a plus sign")
refuses("-", "a lone minus")
refuses("[1] [2]", "two values")
refuses("[1] x", "text after the value")
refuses("NaN", "NaN")
refuses("Infinity", "Infinity")
refuses("// no\n1", "a comment")
refuses(nil, "nil")
refuses(12, "a number")
refuses(string.rep("[", 200) .. string.rep("]", 200), "nesting that is too deep")
check(Json.decode(string.rep("[", 60) .. string.rep("]", 60)) ~= nil, "nesting of 60 is fine")

-- Where an error is
do
    local _, err = Json.decode('{\n  "a": 1,\n  "b": ?\n}')
    check(err ~= nil and string.find(err, "line 3, column 8", 1, true) ~= nil, "the error says where (" .. tostring(err) .. ")")
end

-- The real card data ------------------------------------------------------------------------------------
do
    local file = io.open("docs/cards.json", "rb")
    if file == nil then
        io.stderr:write("note: docs/cards.json not found, skipping the real-data check\n")
    else
        local text = file:read("a")
        file:close()
        local started = os.clock()
        local data, err = Json.decode(text)
        local took = os.clock() - started
        check(data ~= nil, "docs/cards.json decodes (" .. tostring(err) .. ")")
        if data ~= nil then
            check(#data.cards == #Cards.list, "docs/cards.json holds as many cards as the deck (" .. #data.cards
                .. " and " .. #Cards.list .. "): run python dev/build_site.py")
            local wrong = 0
            for i, card in ipairs(data.cards) do
                local own = Cards.list[i]
                if own == nil or card.id ~= own.id or card.name ~= own.name or card.rarity ~= own.rarity
                    or card.desc ~= own.desc then
                    wrong = wrong + 1
                end
            end
            check(wrong == 0, wrong .. " cards in docs/cards.json differ from the deck")
            print(string.format("decoded docs/cards.json: %d bytes, %d cards in %.2f s", #text, #data.cards, took))
        end
    end
end

if failures > 0 then
    io.stderr:write(failures .. " JSON check(s) failed\n")
    os.exit(1)
end
print("JSON checks passed.")
