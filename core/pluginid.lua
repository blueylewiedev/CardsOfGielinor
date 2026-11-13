-- core/pluginid.lua
-- What the plugin is called. TITLE is what players see (window titles, the settings page, the plugin hub:
-- plugin.json's "name" says the same). The console commands that manage a plugin (prl, ppr, ppe) take "the plugin
-- name" and the docs do not say whether that is the manifest name or the folder name, so the dev copy tries both
-- (a wrong one does nothing). The folder is still called CardCollector.
local PluginId = {}

PluginId.TITLE = "Cards of Gielinor"
PluginId.CONSOLE_NAMES = { "CardCollector", '"Cards of Gielinor"' }

-- Runs a console command about this plugin, for each name it might go by: PluginId.command("ppe", "httpAccess")
-- sends `ppe <name> httpAccess`. With no argument it sends `ppr <name>`.
function PluginId.command(command, argument)
    for _, name in ipairs(PluginId.CONSOLE_NAMES) do
        ExecuteConsoleCommand(command .. " " .. name .. (argument and (" " .. argument) or ""))
    end
end

return PluginId
