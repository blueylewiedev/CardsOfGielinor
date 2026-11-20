-- core/pluginid.lua
-- What the plugin is called: TITLE is what players see. The plugin's id in the client's saved data (PluginData.db) is
-- the "name" in plugin.json, so renaming it moves the saves (dev/card_queue.py reads them under that name).
local PluginId = {}

PluginId.TITLE = "Cards of Gielinor"

return PluginId
