-- core/version.lua
-- The plugin's own version, the same as "version" in plugin.json (the plugin API has no way to read it, so the
-- code keeps its own copy; dev/check_version.lua fails if the two differ). An overlay (core/overlay.lua) is
-- only applied to the version it was built for.
return "0.1.0"
