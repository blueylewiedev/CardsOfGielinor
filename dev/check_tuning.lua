-- dev/check_tuning.lua
-- Checks docs/tuning.json, the file whose numbers, lists and switches dev/build_overlay.py puts in the overlay as its tuning
-- line: that it is JSON, and that every key in it passes core/config.lua's own checks (a key outside its limits, of the wrong
-- type or not in the schema would be ignored by the plugin, so it is a mistake here). The "Check cards" workflow runs it, so a
-- change to the file that the plugin would not accept fails before it is published.
--
-- Run from the plugin's folder:  lua dev/check_tuning.lua            (docs/tuning.json)
--                                lua dev/check_tuning.lua other.json (another file, to try it)

package.path = "./?.lua;./dev/?.lua;" .. package.path

function log() end          -- the client's log function

local Json = require("core/json")
local Config = require("core/config")

local path = arg and arg[1] or "docs/tuning.json"
local file = io.open(path, "rb")
if file == nil then
    print("OK: there is no " .. path .. " (the overlay has no tuning line)")
    os.exit(0)
end
local text = file:read("a")
file:close()
text = string.gsub(text, "^\239\187\191", "")          -- a byte order mark

local failures = 0
local function fail(what)
    failures = failures + 1
    io.stderr:write("FAIL: " .. what .. "\n")
end

local data, err = Json.decode(text)
if type(data) ~= "table" then
    fail(path .. " is not a JSON object (" .. tostring(err) .. ")")
else
    local report = Config.apply(data)
    for _, why in ipairs(report.ignored) do
        fail(path .. ": the plugin would ignore " .. why)
    end
    if report.more > 0 then
        fail(path .. ": and " .. report.more .. " more keys the plugin would ignore")
    end
    if failures == 0 then
        if #report.changed == 0 then
            print("OK: " .. path .. " changes nothing (every key is at its default, or there are none)")
        else
            print("OK: " .. path .. " is accepted whole; it changes " .. #report.changed .. " keys from their defaults: "
                .. table.concat(report.changed, ", "))
        end
    end
end
Config.reset()

if failures > 0 then
    os.exit(1)
end
