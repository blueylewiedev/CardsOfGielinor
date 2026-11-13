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

if type(Version) ~= "table" or type(Version.number) ~= "string" then
    io.stderr:write("core/version.lua must return a table with the version as its number (the client's require gives nothing back for a module that returns text)\n")
    os.exit(1)
end
if manifest.version ~= Version.number then
    io.stderr:write("The version in plugin.json is " .. tostring(manifest.version) .. " but core/version.lua says "
        .. tostring(Version.number) .. ": change them together\n")
    os.exit(1)
end
print("Version " .. Version.number .. " in plugin.json and core/version.lua.")
