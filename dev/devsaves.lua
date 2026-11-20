-- dev/devsaves.lua
-- Save tools for the development copy only (this file is not in the release, so the released plugin cannot delete saves).

local DevCopy = require("dev/devcopy")

local DevSaves = {}

-- Deletes every collection saved by this copy of the plugin (the keys that end with the dev copy's suffix, so a released
-- copy's collections are left alone): the main keys and their buckets. Nothing else in the database is touched. Returns how many
-- keys were deleted.
function DevSaves.deleteAllCollections()
    local suffix = DevCopy.SUFFIX
    local doomed = {}
    PersistentDB:IterateEntries(function(key)
        if string.sub(key, -#suffix) == suffix then
            local name = string.gsub(key, "^bucket%d+_", "")
            if string.find(name, "^collection_") or string.find(name, "^tracking_") then
                doomed[#doomed + 1] = key
            end
        end
        return false
    end)
    local deleted = 0
    for _, key in ipairs(doomed) do
        if PersistentDB:Delete(key) then
            deleted = deleted + 1
        end
    end
    return deleted
end

return DevSaves
