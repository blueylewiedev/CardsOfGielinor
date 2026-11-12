-- dev/jsonencode.lua
-- A JSON encoder for the card data the overlay carries (the plugin only decodes, see core/json.lua, so this
-- is a development tool). It is deterministic: the same data always gives the same text, so two exports can be
-- compared line by line.
--   * an object's keys are in sorted order; a table is an array if its keys are 1..n, else an object
--   * a table with nothing in it is written as [] (the decoder gives {} for both)
--   * a whole number is written without a fraction; any other number with as few digits as read back exactly
--   * a string is written as UTF-8, with only the escapes JSON requires (a control character is \u00XX)
--   * a function, a mixed table, a key that is not text, NaN, infinity or a table nested too deep is an error
-- Json.null (core/json.lua) is written as null.

local Encode = {}

local MAX_DEPTH = 64

local SHORT = { ['"'] = '\\"', ["\\"] = "\\\\", ["\b"] = "\\b", ["\f"] = "\\f", ["\n"] = "\\n", ["\r"] = "\\r", ["\t"] = "\\t" }

local function quote(text)
    return '"' .. string.gsub(text, '[%c"\\]', function(letter)
        return SHORT[letter] or string.format("\\u%04x", string.byte(letter))
    end) .. '"'
end

local function number(value)
    if value ~= value or value == math.huge or value == -math.huge then
        error("cannot encode the number " .. tostring(value), 0)
    end
    if value == math.floor(value) and math.abs(value) < 2 ^ 53 then
        return string.format("%d", value)
    end
    for precision = 15, 17 do
        local text = string.format("%." .. precision .. "g", value)
        if tonumber(text) == value then
            return text
        end
    end
    return string.format("%.17g", value)
end

local encodeValue

local function encodeTable(value, depth)
    if depth > MAX_DEPTH then
        error("nested more than " .. MAX_DEPTH .. " levels deep", 0)
    end
    if next(value) == nil then
        return "[]"
    end
    local count, length = 0, #value
    for _ in pairs(value) do
        count = count + 1
    end
    if count == length then                                -- keys 1..n: an array
        local parts = {}
        for index = 1, length do
            parts[index] = encodeValue(value[index], depth + 1)
        end
        return "[" .. table.concat(parts, ",") .. "]"
    end
    local keys = {}
    for key in pairs(value) do
        if type(key) ~= "string" then
            error("a table mixes list entries with other keys, or has a key that is not text: " .. tostring(key), 0)
        end
        keys[#keys + 1] = key
    end
    table.sort(keys)
    local parts = {}
    for index, key in ipairs(keys) do
        parts[index] = quote(key) .. ":" .. encodeValue(value[key], depth + 1)
    end
    return "{" .. table.concat(parts, ",") .. "}"
end

encodeValue = function(value, depth)
    local kind = type(value)
    if kind == "string" then
        return quote(value)
    elseif kind == "number" then
        return number(value)
    elseif kind == "boolean" then
        return value and "true" or "false"
    elseif kind == "table" then
        local ok, Json = pcall(require, "core/json")
        if ok and value == Json.null then
            return "null"
        end
        return encodeTable(value, depth)
    end
    error("cannot encode a " .. kind, 0)
end

-- The JSON text for a value. Raises an error (with a message) for anything that cannot be encoded.
function Encode.encode(value)
    return encodeValue(value, 0)
end

return Encode
