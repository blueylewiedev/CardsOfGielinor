-- dev/grants.lua
-- The development copy asks for its own permissions each time it starts, since the client forgets grants when it restarts.
-- ppr requests the manifest's permissions and ppe turns one on; both take the plugin's folder name (core/pluginid.lua).
-- The released plugin has no console commands at all: the player decides what to grant. (This file is not in the release.)

local PluginId = require("core/pluginid")

local Grants = {}

local PERMISSIONS = { "trackingAccess", "httpAccess" }

local function command(name, argument)
    ExecuteConsoleCommand(name .. " " .. PluginId.FOLDER .. (argument and (" " .. argument) or ""))
end

-- Requests the manifest's permissions and turns each on. Never raises.
function Grants.grant()
    local ok, err = pcall(function()
        command("ppr")
        for _, permission in ipairs(PERMISSIONS) do
            command("ppe", permission)
        end
    end)
    if not ok then
        log("DEV: could not ask for the permissions:", err)
    end
end

return Grants
