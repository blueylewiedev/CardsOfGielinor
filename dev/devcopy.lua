-- dev/devcopy.lua
-- What makes this the development copy rather than the released plugin on the same computer: the two share one PersistentDB (they have
-- the same plugin name), so the dev copy keeps its collections under their own keys, ending in SUFFIX. It wraps the two functions
-- that make a collection's key, so the plugin itself knows nothing about it. Not in the release.

local Storage = require("core/storage")

local DevCopy = { SUFFIX = "-dev" }

local installed = false

-- Wraps Storage.keyForName and Storage.keyForTracking once (a bucket's key is made from its collection's, so it ends with the suffix too).
function DevCopy.install()
    if installed then
        return
    end
    installed = true
    for _, name in ipairs({ "keyForName", "keyForTracking" }) do
        local original = Storage[name]
        Storage[name] = function(...)
            return original(...) .. DevCopy.SUFFIX
        end
    end
end

return DevCopy
