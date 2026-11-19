-- dev/devsaves.lua
-- Save tools for the development copy only (this file is not in the release, so the released plugin cannot delete saves).

local Storage = require("core/storage")

local DevSaves = {}

-- Deletes every collection saved by this copy of the plugin (the keys that end with the profile suffix,
-- so the dev copy leaves a released copy's collections alone): the main keys and their buckets. Nothing
-- else in the database is touched. Returns how many keys were deleted, or nil and a reason. Only for the
-- development tools; a copy with no suffix refuses.
function DevSaves.deleteAllCollections()
    local suffix = Storage.profileSuffix()
    if suffix == "" then
        return nil, "no profile suffix: only the dev copy may do this"
    end
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
