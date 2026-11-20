-- core/pluginid.lua
-- What the plugin is called. TITLE is what players see. The console commands (prl, ppr, ppe) take the plugin's folder
-- name, not its title. The plugin's id in the client's saved data (PluginData.db) is the "name" in plugin.json, so
-- renaming it moves the saves (dev/card_queue.py reads them under that name). The released plugin sends no console
-- commands; the dev copy's are in dev/grants.lua.
local PluginId = {}

PluginId.TITLE = "Cards of Gielinor"
PluginId.FOLDER = "cardsofgielinor"

return PluginId
