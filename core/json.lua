-- core/json.lua
-- A small JSON decoder (decoding only), for the card data the plugin may fetch over HTTP. The client's
-- API has no JSON support. It follows the JSON standard (RFC 8259) strictly, so a damaged or
-- hand-edited file is refused with a message instead of half-read:
--   * objects, arrays, strings, numbers, true, false and null
--   * strings: the escapes \" \\ \/ \b \f \n \r \t and \uXXXX (a pair of surrogates becomes one letter),
--     written out as UTF-8; a raw control character in a string is an error
--   * numbers: -?(0|[1-9][0-9]*)(.[0-9]+)?([eE][+-]?[0-9]+)?
--   * nothing but whitespace after the value; nesting no deeper than MAX_DEPTH; a leading UTF-8 byte order
--     mark is skipped
--
-- Json.decode(text) returns the value, or nil and a message ("line 3, column 14: ..."). It never raises an
-- error. JSON null becomes Json.null (a table you can compare with), because Lua cannot keep nil in a table.
-- A repeated key in an object keeps the last value.
--
-- It does not use coroutines (the client crashes on them). To keep a big file from stalling a frame, the
-- caller can split the data and decode the parts on different ticks.

local Json = {}

Json.null = setmetatable({}, { __tostring = function() return "null" end })

local MAX_DEPTH = 64

local byte, sub, find, char = string.byte, string.sub, string.find, string.char
local concat = table.concat

local SIMPLE_ESCAPES = {
    [34] = '"', [92] = "\\", [47] = "/", [98] = "\b", [102] = "\f", [110] = "\n", [114] = "\r", [116] = "\t",
}

-- Raises a decoding error (caught by Json.decode).
local function fail(pos, message)
    error({ pos = pos, message = message }, 0)
end

-- A code point as UTF-8.
local function utf8Char(code)
    if code < 0x80 then
        return char(code)
    elseif code < 0x800 then
        return char(0xC0 + math.floor(code / 0x40), 0x80 + code % 0x40)
    elseif code < 0x10000 then
        return char(0xE0 + math.floor(code / 0x1000), 0x80 + math.floor(code / 0x40) % 0x40, 0x80 + code % 0x40)
    end
    return char(0xF0 + math.floor(code / 0x40000), 0x80 + math.floor(code / 0x1000) % 0x40,
        0x80 + math.floor(code / 0x40) % 0x40, 0x80 + code % 0x40)
end

-- The four hex digits after "\u" at `pos` (the position of the "u"), as a number.
local function hex4(text, pos)
    local digits = sub(text, pos + 1, pos + 4)
    if #digits ~= 4 or find(digits, "^%x%x%x%x$") == nil then
        fail(pos, "bad \\u escape")
    end
    return tonumber(digits, 16)
end

local function skipSpace(text, pos)
    local _, last = find(text, "^[ \t\r\n]*", pos)
    return last + 1
end

local parseValue

-- The string whose opening quote is at `pos`. Returns the string and the position after its closing quote.
local function parseString(text, pos)
    local parts, count = nil, 0
    local start = pos + 1
    while true do
        -- the next quote, backslash or control character (%c also matches DEL, which a string may hold)
        local at = find(text, '[%c"\\]', start)
        while at ~= nil and byte(text, at) == 127 do
            at = find(text, '[%c"\\]', at + 1)
        end
        if at == nil then
            fail(pos, "unterminated string")
        end
        local c = byte(text, at)
        if c == 34 then
            if parts == nil then
                return sub(text, start, at - 1), at + 1
            end
            count = count + 1
            parts[count] = sub(text, start, at - 1)
            return concat(parts), at + 1
        elseif c == 92 then
            parts = parts or {}
            count = count + 1
            parts[count] = sub(text, start, at - 1)
            local e = byte(text, at + 1)
            local plain = SIMPLE_ESCAPES[e]
            if plain ~= nil then
                count = count + 1
                parts[count] = plain
                start = at + 2
            elseif e == 117 then                       -- \u
                local code = hex4(text, at + 1)
                start = at + 6
                if code >= 0xD800 and code <= 0xDBFF then
                    if sub(text, start, start + 1) ~= "\\u" then
                        fail(at, "a high surrogate with no low surrogate after it")
                    end
                    local low = hex4(text, start + 1)
                    if low < 0xDC00 or low > 0xDFFF then
                        fail(at, "a high surrogate with no low surrogate after it")
                    end
                    code = 0x10000 + (code - 0xD800) * 0x400 + (low - 0xDC00)
                    start = start + 6
                elseif code >= 0xDC00 and code <= 0xDFFF then
                    fail(at, "a low surrogate with no high surrogate before it")
                end
                count = count + 1
                parts[count] = utf8Char(code)
            else
                fail(at, "bad escape")
            end
        else
            fail(at, "a raw control character in a string")
        end
    end
end

-- The number at `pos`. Returns it and the position after it.
local function parseNumber(text, pos)
    local _, last = find(text, "^-?%d+", pos)
    if last == nil then
        fail(pos, "bad number")
    end
    local digits = sub(text, pos, last)
    if find(digits, "^-?0%d") ~= nil then
        fail(pos, "a number cannot start with 0 and more digits")
    end
    local _, fractionEnd = find(text, "^%.%d+", last + 1)
    if fractionEnd ~= nil then
        last = fractionEnd
    elseif byte(text, last + 1) == 46 then
        fail(last + 1, "a . with no digits after it")
    end
    local _, exponentEnd = find(text, "^[eE][+-]?%d+", last + 1)
    if exponentEnd ~= nil then
        last = exponentEnd
    elseif find(text, "^[eE]", last + 1) ~= nil then
        fail(last + 1, "an exponent with no digits")
    end
    return tonumber(sub(text, pos, last)), last + 1
end

local function parseArray(text, pos, depth)
    local result, count = {}, 0
    pos = skipSpace(text, pos + 1)
    if byte(text, pos) == 93 then
        return result, pos + 1
    end
    while true do
        local value
        value, pos = parseValue(text, pos, depth)
        count = count + 1
        result[count] = value
        pos = skipSpace(text, pos)
        local c = byte(text, pos)
        if c == 44 then
            pos = skipSpace(text, pos + 1)
        elseif c == 93 then
            return result, pos + 1
        else
            fail(pos, "expected , or ] in an array")
        end
    end
end

local function parseObject(text, pos, depth)
    local result = {}
    pos = skipSpace(text, pos + 1)
    if byte(text, pos) == 125 then
        return result, pos + 1
    end
    while true do
        if byte(text, pos) ~= 34 then
            fail(pos, "expected a string as the key")
        end
        local key
        key, pos = parseString(text, pos)
        pos = skipSpace(text, pos)
        if byte(text, pos) ~= 58 then
            fail(pos, "expected : after a key")
        end
        pos = skipSpace(text, pos + 1)
        local value
        value, pos = parseValue(text, pos, depth)
        result[key] = value
        pos = skipSpace(text, pos)
        local c = byte(text, pos)
        if c == 44 then
            pos = skipSpace(text, pos + 1)
        elseif c == 125 then
            return result, pos + 1
        else
            fail(pos, "expected , or } in an object")
        end
    end
end

parseValue = function(text, pos, depth)
    local c = byte(text, pos)
    if c == 34 then
        return parseString(text, pos)
    elseif c == 123 or c == 91 then
        if depth >= MAX_DEPTH then
            fail(pos, "nested more than " .. MAX_DEPTH .. " levels deep")
        end
        if c == 123 then
            return parseObject(text, pos, depth + 1)
        end
        return parseArray(text, pos, depth + 1)
    elseif c == 116 then
        if sub(text, pos, pos + 3) == "true" then
            return true, pos + 4
        end
    elseif c == 102 then
        if sub(text, pos, pos + 4) == "false" then
            return false, pos + 5
        end
    elseif c == 110 then
        if sub(text, pos, pos + 3) == "null" then
            return Json.null, pos + 4
        end
    elseif c == 45 or (c ~= nil and c >= 48 and c <= 57) then
        return parseNumber(text, pos)
    elseif c == nil then
        fail(pos, "the data ends too soon")
    end
    fail(pos, "unexpected " .. string.format("%q", sub(text, pos, pos)))
end

-- "line 3, column 14" for a position in the text.
local function where(text, pos)
    local line, lineStart = 1, 1
    local at = find(text, "\n", 1, true)
    while at ~= nil and at < pos do
        line, lineStart = line + 1, at + 1
        at = find(text, "\n", at + 1, true)
    end
    return "line " .. line .. ", column " .. (pos - lineStart + 1)
end

local function run(text)
    local pos = 1
    if sub(text, 1, 3) == "\239\187\191" then
        pos = 4                                   -- skip a byte order mark
    end
    pos = skipSpace(text, pos)
    local value
    value, pos = parseValue(text, pos, 0)
    pos = skipSpace(text, pos)
    if pos <= #text then
        fail(pos, "extra data after the value")
    end
    return value
end

-- Decodes JSON text. Returns the value, or nil and a message.
function Json.decode(text)
    if type(text) ~= "string" then
        return nil, "not text"
    end
    local ok, result = pcall(run, text)
    if ok then
        return result
    end
    if type(result) == "table" and result.pos ~= nil then
        return nil, where(text, result.pos) .. ": " .. result.message
    end
    return nil, "decoder error: " .. tostring(result)
end

return Json
