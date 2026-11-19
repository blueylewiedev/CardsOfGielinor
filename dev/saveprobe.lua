-- dev/saveprobe.lua
-- Vetting check V2 (notes/code_vetting.md, finding F5): does PersistentDB's CheckExists agree with GetStructuredData?
-- core/storage.lua leans on CheckExists to tell a save that could not be read from one that is not there, so this logs,
-- for the logged-in character's collection: what the main entry reads as and whether CheckExists says it is there, the
-- same for every bucket (and how many disagree), the name collection it could be copied from, and what both calls say
-- about a key that has never existed. Run by the Dev tools' "Save probe" button, and once at each login. Not in the release.

local Storage = require("core/storage")
local Identity = require("core/identity")

local SaveProbe = {}

local function say(...)
    log("SAVE PROBE:", ...)
end

-- What a call gives back, as text: "nil", "table (12 entries)", "true", or "error: ...".
local function describe(call)
    local ok, value = pcall(call)
    if not ok then
        return "error: " .. tostring(value)
    end
    if type(value) == "table" then
        local n = 0
        for _ in pairs(value) do
            n = n + 1
        end
        return "table (" .. n .. " entries)"
    end
    return tostring(value)
end

-- Both calls for one key, and whether they agree (a table and true, or nil and false).
local function probeKey(key)
    local read = describe(function() return PersistentDB:GetStructuredData(key) end)
    local there = describe(function() return PersistentDB:CheckExists(key) end)
    local agree = (read == "nil") == (there == "false")
    return read, there, agree
end

local function characterName()
    local ok, name = pcall(function() return Player.GetEntity().displayName end)
    return ok and name or nil
end

function SaveProbe.run()
    local name = characterName()
    local profile = Identity.profile(name)
    if profile == nil then
        say("no character loaded yet (name " .. tostring(name) .. ")")
        return
    end
    local keys = { { "collection", profile.key } }
    if profile.adoptFrom ~= nil and profile.adoptFrom ~= profile.key then
        keys[#keys + 1] = { "name collection", profile.adoptFrom }
    end
    for _, entry in ipairs(keys) do
        local label, key = entry[1], entry[2]
        local read, there, agree = probeKey(key)
        say(label, key, "| GetStructuredData:", read, "| CheckExists:", there, agree and "| agree" or "| DISAGREE",
            "| Storage.absentKind:", describe(function() return Storage.absentKind(key) end))
        local present, disagree = 0, 0
        for bucket = 1, Storage.BUCKETS do
            local bucketRead, _, bucketAgree = probeKey(Storage.bucketKey(key, bucket))
            if bucketRead ~= "nil" then
                present = present + 1
            end
            if not bucketAgree then
                disagree = disagree + 1
            end
        end
        say(label, "buckets:", present, "of", Storage.BUCKETS, "read as data,", disagree, "where the two calls disagree")
    end
    local missing = "save_probe_never_written_" .. tostring(math.random(1, 1000000000))
    local read, there = probeKey(missing)
    say("a key that has never existed | GetStructuredData:", read, "| CheckExists:", there)
end

return SaveProbe
