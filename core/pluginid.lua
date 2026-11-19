-- core/pluginid.lua
-- What the plugin is called. TITLE is what players see (window titles, the settings page, the plugin hub:
-- plugin.json's "name" says the same). The console commands that manage a plugin (prl, ppr, ppe) take "the plugin
-- name", which is the name of the plugin's folder (tried in the client: `prl cardsofgielinor`), not its title. The
-- plugin's id in the client's saved data (PluginData.db) is different: it is the "name" in plugin.json, so renaming
-- the manifest name moves the saves (dev/card_queue.py reads them under that name). (The released plugin sends no
-- console commands: the dev copy's are in dev/grants.lua.)
local PluginId = {}

PluginId.TITLE = "Cards of Gielinor"
PluginId.FOLDER = "cardsofgielinor"

return PluginId
