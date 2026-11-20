-- core/logger.lua
-- What the plugin writes to the Lua console, which every plugin shares (Jagex ask that heavy logging be off by default):
--   Logger.note(...)   a milestone worth one line each start-up
--   Logger.error(...) something failed and the plugin carried on. Always written, but each
--     message once, and at most a fixed number of different ones
--   Logger.debug(...)  routine detail, only with "Detailed logging for bug reports" on in the settings (or in the development copy)
-- Nothing is stored or sent anywhere: it is the client's own log().

local Settings = require("core/settings")

local Logger = {}

local MAX_DIFFERENT_ERRORS = 100
local devCopy = false
local seen, seenCount, saidLimit = {}, 0, false

-- The development copy always writes the detail (main.lua calls this once).
function Logger.setDevCopy(isDev)
    devCopy = isDev == true
end

-- True if the detail is being written.
function Logger.debugOn()
    return devCopy or Settings.get("debugLogging")
end

-- A line, as `log` writes it.
function Logger.note(...)
    log(...)
end

-- A line only while detailed logging is on.
function Logger.debug(...)
    if Logger.debugOn() then
        log(...)
    end
end

-- A failure. The same message is written once.
function Logger.error(...)
    local parts = table.pack(...)
    for index = 1, parts.n do
        parts[index] = tostring(parts[index])
    end
    local message = table.concat(parts, " ", 1, parts.n)
    if seen[message] then
        return
    end
    if seenCount >= MAX_DIFFERENT_ERRORS then
        if not saidLimit then
            saidLimit = true
            log("(more than " .. MAX_DIFFERENT_ERRORS .. " different problems: the rest are not written)")
        end
        return
    end
    seen[message] = true
    seenCount = seenCount + 1
    log(message)
end

-- Forgets which errors were written (for the tests).
function Logger.reset()
    seen, seenCount, saidLimit = {}, 0, false
    devCopy = false
end

return Logger
