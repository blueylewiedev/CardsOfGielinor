-- dev/check_version.lua
-- Fails if the version in core/version.lua (which the overlay is matched against) is not the version in
-- plugin.json (the one Jagex sees and dev/build_overlay.py reads). Bump both together when a version is
-- submitted. The "Check cards" workflow runs it.
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_version.lua

package.path = "./?.lua;" .. package.path

local Json = require("core/json")
local Version = require("core/version")

local file = io.open("plugin.json", "rb")
if file == nil then
    io.stderr:write("plugin.json not found: run this from the plugin's folder\n")
    os.exit(1)
end
local manifest, err = Json.decode(file:read("a"))
file:close()
if manifest == nil then
    io.stderr:write("plugin.json does not decode: " .. tostring(err) .. "\n")
    os.exit(1)
end

if manifest.version ~= Version then
    io.stderr:write("The version in plugin.json is " .. tostring(manifest.version) .. " but core/version.lua says "
        .. tostring(Version) .. ": change them together\n")
    os.exit(1)
end
print("Version " .. Version .. " in plugin.json and core/version.lua.")
