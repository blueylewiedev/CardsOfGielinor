-- core/version.lua
-- The plugin's own version, the same as "version" in plugin.json (the plugin API has no way to read it, so the
-- code keeps its own copy; dev/check_version.lua fails if the two differ). An overlay (core/overlay.lua) is
-- only applied to the version it was built for. It is a table because the client's require gives nothing back
-- for a module that returns text (desktop Lua does, so the tests could not show it).
return { number = "0.1.0" }
