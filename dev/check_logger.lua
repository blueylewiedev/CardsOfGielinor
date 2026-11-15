-- dev/check_logger.lua
-- Checks core/logger.lua: what the plugin writes to the Lua console. Routine detail is off unless "Detailed logging
-- for bug reports" is on (or this is the development copy), a failure is always written but not repeated, and
-- there is a limit on how many different failures are written.
--
-- Also checks that the shipped files (main.lua, core/, ui/) write to the console only through the logger (apart
-- from the few lines noted below), so a new log() call that skips it is caught.
--
-- Run from the plugin's folder:  lua dev/check_logger.lua

package.path = "./?.lua;" .. package.path

local written = {}
function log(...)
    local parts = table.pack(...)
    for index = 1, parts.n do parts[index] = tostring(parts[index]) end
    written[#written + 1] = table.concat(parts, " ", 1, parts.n)
end
local saved = {}
PersistentDB = {
    GetStructuredData = function(_, key) return saved[key] end,
    SetStructuredData = function(_, key, value) saved[key] = value; return true end,
}

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end
local function clear() written = {} end

local Settings = require("core/settings")
local Logger = require("core/logger")
Settings.load()

-- off by default
Logger.reset()
clear()
Logger.debug("a routine line")
check(#written == 0, "detail is not written by default")
check(Settings.get("debugLogging") == false, "detailed logging is off by default")
Logger.note("a milestone")
check(#written == 1 and written[1] == "a milestone", "a milestone is always written")

-- the setting turns the detail on and off
Settings.set("debugLogging", true)
clear()
Logger.debug("now", 42)
check(#written == 1 and written[1] == "now 42", "detail is written while the setting is on")
Settings.set("debugLogging", false)
clear()
Logger.debug("again")
check(#written == 0, "and stops when it is switched off")

-- the development copy always writes the detail
Logger.setDevCopy(true)
Logger.debug("dev")
check(#written == 1, "the development copy writes the detail")
Logger.setDevCopy(false)

-- a failure is written once
Logger.reset()
clear()
Logger.error("thing failed:", "reason")
Logger.error("thing failed:", "reason")
Logger.error("thing failed:", "reason")
check(#written == 1 and written[1] == "thing failed: reason", "a failure is written once, however often it happens")
Logger.error("thing failed:", "another reason")
check(#written == 2, "a different message is written")
Logger.error("a number", 5, "and nil", nil)
check(written[3] == "a number 5 and nil nil", "arguments of any type are written")

-- the limit on different failures
Logger.reset()
clear()
for number = 1, 150 do
    Logger.error("problem number", number)
end
check(#written == 101, "100 different failures and one line saying the rest are not written (" .. #written .. ")")
check(string.find(written[101], "not written", 1, true) ~= nil, "the last line says so")
Logger.error("problem number", 1)
check(#written == 101, "nothing more is written after the limit")

-- no stray log() calls in what ships: they go through the logger. (Left on the raw log on purpose: the failed saves
-- in core/storage.lua and core/settings.lua, which must be written every time and which the logger itself needs
-- working; core/cards.lua's art check, which only the development tools run; core/logger.lua itself.)
local function shippedFiles()
    local files = { "main.lua" }
    local listing = io.popen('git ls-files "core/*.lua" "ui/*.lua"')
    if listing == nil then
        return nil
    end
    for name in listing:lines() do
        files[#files + 1] = name
    end
    listing:close()
    return files
end
local allowed = { ["core/logger.lua"] = true, ["core/storage.lua"] = true, ["core/settings.lua"] = true, ["core/cards.lua"] = true }
local files = shippedFiles()
if files == nil or #files < 10 then
    print("(skipped the stray log() check: could not list the files with git)")
else
    for _, name in ipairs(files) do
        if not allowed[name] then
            local file = assert(io.open(name, "r"))
            local number = 0
            for line in file:lines() do
                number = number + 1
                local code = line:gsub("%-%-.*$", "")
                if code:find("[^%w_.:]log%(") or code:find("^log%(") then
                    check(false, name .. ":" .. number .. " writes to the console with log(); use Logger.note, Logger.error or Logger.debug")
                end
            end
            file:close()
        end
    end
end

if failures > 0 then
    io.stderr:write(failures .. " check(s) failed\n")
    os.exit(1)
end
print("OK: the console stays quiet unless something fails or detailed logging is on")
