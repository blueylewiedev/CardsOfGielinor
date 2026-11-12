-- dev/dblimit.lua
-- Finds how big one PersistentDB value may be before the client refuses it, so the collection's
-- buckets (core/storage.lua) can be sized with room to spare. The Home window's "DB limit probe" button
-- runs it; the result is in the log (the Output window shows it).
--
-- It writes to one throwaway key, never to a collection, and deletes it at the end. Two tests, because
-- the limit might be on the number of entries or on the number of bytes:
--   entries: a table of N entries, "card_id_NNNNN|normal" = 1 (the shape of a collection's owned cards)
--   text   : one string of N letters
-- Each size is written, read back and compared. The first size that fails is the limit to stay well under.

local DbLimit = {}

local KEY = "dev_db_limit_probe"
local ENTRY_SIZES = { 500, 1000, 2000, 3000, 4000, 5000, 6000, 8000, 12000, 20000 }
local TEXT_SIZES = { 16384, 65536, 100000, 131056, 131072, 200000, 500000, 1000000 }

-- Runs one test over `sizes`; `make(size)` builds the value and `measure(value)` counts it back. Stops at
-- the first size that fails. Returns the biggest size that worked, the one that failed (or nil), and why.
local function sweep(sizes, make, measure)
    local biggest, failedAt, why = nil, nil, nil
    for _, size in ipairs(sizes) do
        local ok, wrote = pcall(function() return PersistentDB:SetStructuredData(KEY, make(size)) end)
        if not ok then
            failedAt, why = size, "error: " .. tostring(wrote)
            break
        elseif not wrote then
            failedAt, why = size, "the write returned false"
            break
        end
        local readOk, back = pcall(function() return PersistentDB:GetStructuredData(KEY) end)
        if not readOk or back == nil or measure(back) ~= size then
            failedAt, why = size, "it came back with " .. tostring(readOk and back ~= nil and measure(back) or "nothing")
            break
        end
        biggest = size
        log("DB limit probe: ok at", size)
    end
    return biggest, failedAt, why
end

function DbLimit.run()
    log("DB limit probe: starting (key " .. KEY .. ", deleted at the end)")

    local entriesOk, entriesFail, entriesWhy = sweep(ENTRY_SIZES, function(size)
        local value = {}
        for i = 1, size do
            value[string.format("card_id_%05d|normal", i)] = 1
        end
        return value
    end, function(value)
        local count = 0
        for _ in pairs(value) do
            count = count + 1
        end
        return count
    end)
    log("DB limit probe: entries - biggest that worked:", entriesOk, "| first failure:", entriesFail, entriesWhy)

    local textOk, textFail, textWhy = sweep(TEXT_SIZES, function(size)
        return { text = string.rep("x", size) }
    end, function(value)
        return #(value.text or "")
    end)
    log("DB limit probe: text (letters) - biggest that worked:", textOk, "| first failure:", textFail, textWhy)

    local deleted = PersistentDB:Delete(KEY)
    log("DB limit probe: finished, probe key deleted:", deleted)
end

return DbLimit
