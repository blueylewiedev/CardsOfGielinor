-- dev/check_quiet.lua
-- Checks the dev copy's quiet console switch (dev/quiet.lua): on by default, it turns the logger's routine detail off in the dev
-- copy (which otherwise always writes it), drops the automatic lines but not the loud ones, flips and saves, and the player setting
-- "Detailed logging for bug reports" still turns the detail on.
--
-- Run from the plugin's folder:  lua dev/check_quiet.lua

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

local Settings = require("core/settings")
local Logger = require("core/logger")
Settings.load()
local Quiet = require("dev/quiet")

-- on by default; installing it makes the plugin's routine detail follow it
check(Quiet.on == true, "quiet is on by default")
Quiet.install()                                -- what Dev.start does for the dev copy
Quiet.install()                                -- (once only)
written = {}
Logger.debug("routine detail")
check(#written == 0, "quiet: the dev copy does not write routine detail")
Logger.error("a failure")
check(#written == 1 and string.find(written[1], "a failure", 1, true) ~= nil, "quiet: a failure is still written")

-- the automatic lines are dropped, the loud ones are not
written = {}
Quiet.line("PROBE automatic")
Quiet.line("PROBE manual", true)
check(#written == 1 and written[1] == "PROBE manual", "quiet: an automatic line is dropped and a loud one is written")

-- the player's own setting still turns the detail on
Settings.set("debugLogging", true)
written = {}
Logger.debug("detail by setting")
check(#written == 1, "the Detailed logging setting still turns the detail on")
Settings.set("debugLogging", false)

-- flipping: off writes everything again, and it is saved
written = {}
check(Quiet.toggle() == false and Quiet.on == false, "toggling turns quiet off")
check(saved["dev_quiet-dev"] ~= nil and saved["dev_quiet-dev"].on == false, "and saves it")
check(#written == 1 and string.find(written[1], "OFF", 1, true) ~= nil, "and says so")
written = {}
Logger.debug("chatty detail")
Quiet.line("PROBE automatic")
check(#written == 2, "quiet off: the dev copy writes the routine detail and the automatic lines again")

-- a later start reads the saved choice
package.loaded["dev/quiet"] = nil
check(require("dev/quiet").on == false, "a saved off is read back at the next start")
saved["dev_quiet-dev"] = nil
package.loaded["dev/quiet"] = nil
check(require("dev/quiet").on == true, "with nothing saved it is on")

if failures > 0 then
    io.stderr:write(failures .. " quiet check(s) failed\n")
    os.exit(1)
end
print("OK: the quiet console switch drops the routine lines and keeps failures and what the dev buttons say")
