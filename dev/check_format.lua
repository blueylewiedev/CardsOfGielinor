-- dev/check_format.lua
-- Checks the number the credits overlay shows (core/format.lua).
--
-- Run from the plugin's folder:  lua dev/check_format.lua

package.path = "./?.lua;" .. package.path

local Format = require("core/format")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

check(Format.credits(19249) == "19 249", "19249 reads 19 249 (the OSRS counter's style)")
check(Format.credits(0) == "0" and Format.credits(7) == "7" and Format.credits(999) == "999", "short numbers have no space")
check(Format.credits(1000) == "1 000" and Format.credits(123456) == "123 456", "groups of three from the right")
check(Format.credits(1234567) == "1 234 567" and Format.credits(1000000) == "1 000 000", "millions")
check(Format.credits(12.9) == "12" and Format.credits(nil) == "0" and Format.credits(-1500) == "-1 500", "a fraction is dropped, nil is 0, a sign stays")

-- The settings page's collection line: short enough for beside an icon, and says what to do.
do
    local LONGEST_LINE = 28
    for _, kind in ipairs({ "tracking", "name", false }) do
        for _, granted in ipairs({ true, false }) do
            local short, detail = Format.collectionLine(kind or nil, granted)
            check(#short <= LONGEST_LINE, "'" .. short .. "' fits beside the icon (" .. #short .. " letters)")
            check(#detail > #short and detail ~= "", "the tooltip for '" .. short .. "' says more")
        end
    end
    local short, detail = Format.collectionLine("name", false)
    check(short == "Saved by character name" and string.find(detail, "Turn on Tracking", 1, true) ~= nil
        and string.find(detail, "rename", 1, true) ~= nil, "not granted: says to turn on Tracking and why")
    short = Format.collectionLine("tracking", true)
    check(short == "Saved by tracking id", "granted and saved by tracking id")
    check(Format.collectionLine("name", true) == "Changes at next login"
        and Format.collectionLine("tracking", false) == "Changes at next login",
        "a permission changed since login says it takes effect at the next login")
    check(Format.collectionLine(nil, false) == "Loading...", "collection not loaded yet")
    for _, kind in ipairs({ "tracking", "name" }) do
        for _, granted in ipairs({ true, false }) do
            local _, text = Format.collectionLine(kind, granted)
            check(string.find(text, "trackingAccess", 1, true) == nil, "the player-facing text does not use the manifest name")
        end
    end
end

if failures > 0 then
    io.stderr:write(failures .. " check(s) failed\n")
    os.exit(1)
end
print("OK: the credits text reads as it should")
