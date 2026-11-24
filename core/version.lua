-- core/version.lua
-- The plugin's version, the same as "version" in plugin.json (dev/check_version.lua fails if they differ); an overlay
-- only applies to the version it was built for. A table because the client's require gives nothing back for a module
-- that returns text.
return { number = "1.0.1" }
