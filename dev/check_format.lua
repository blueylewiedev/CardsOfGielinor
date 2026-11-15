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

if failures > 0 then
    io.stderr:write(failures .. " check(s) failed\n")
    os.exit(1)
end
print("OK: the credits text reads as it should")
