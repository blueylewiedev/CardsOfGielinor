-- dev/check_storage.lua
-- Checks that a collection saves and loads (core/storage.lua) against a pretend PersistentDB that can
-- refuse a value that is too big or a write to a chosen key, as the client does. Run it before opening
-- a pull request that touches the storage; the "Check cards" workflow runs it too.
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_storage.lua

package.path = "./?.lua;" .. package.path

function log() end          -- the client's log function

-- ---------------------------------------------------------------------------------------------------
-- The pretend database. A value is copied on the way in (the client serialises it), and counts as
-- too big if it has more than `maxEntries` entries in all.
-- ---------------------------------------------------------------------------------------------------
local db, writes, failKeys = {}, {}, {}
local maxEntries = 1000

local function copy(value)
    if type(value) ~= "table" then
        return value
    end
    local out = {}
    for k, v in pairs(value) do
        out[k] = copy(v)
    end
    return out
end

local function entries(value)
    local total = 0
    if type(value) == "table" then
        for _, v in pairs(value) do
            total = total + 1 + entries(v)
        end
    end
    return total
end

PersistentDB = {}
function PersistentDB:GetStructuredData(key)
    return copy(db[key])
end
function PersistentDB:SetStructuredData(key, value)
    if failKeys[key] or entries(value) > maxEntries then
        return false
    end
    db[key] = copy(value)
    writes[#writes + 1] = key
    return true
end
function PersistentDB:Delete(key)
    local had = db[key] ~= nil
    db[key] = nil
    return had
end
function PersistentDB:CheckExists(key)
    return db[key] ~= nil
end
function PersistentDB:IterateEntries(callback)
    local keys = {}
    for key in pairs(db) do
        keys[#keys + 1] = key
    end
    table.sort(keys)
    for _, key in ipairs(keys) do
        if callback(key, db[key]) then
            break
        end
    end
    return #keys
end

local function reset()
    db, writes, failKeys = {}, {}, {}
    maxEntries = 1000
end

-- ---------------------------------------------------------------------------------------------------
local Cards = require("core/cards")
local Storage = require("core/storage")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function count(t)
    local n = 0
    for _ in pairs(t) do
        n = n + 1
    end
    return n
end

local function sameOwned(a, b)
    if count(a) ~= count(b) then
        return false
    end
    for k, v in pairs(a) do
        if b[k] ~= v then
            return false
        end
    end
    return true
end

-- A collection with every card in it (copies of the first few, to see counts survive).
local function fullState()
    local state = Storage.newState()
    for i, card in ipairs(Cards.list) do
        Storage.addCard(state, Cards.variantKey(card.id, "normal"), i <= 5 and 3 or 1)
    end
    return state
end

-- 1. Nothing saved: a fresh collection
reset()
do
    local state = Storage.load("collection_nobody")
    check(state.credits == 0 and count(state.owned) == 0 and state.dirty == false, "a fresh collection is empty and clean")
end

-- 2. A full collection saves under a limit one value could not meet, and loads back whole
reset()
do
    local state = fullState()
    state.credits, state.xpPool, state.difficulty = 42, 7, "normal"
    state.stats.packsOpened = 9
    check(count(state.owned) > maxEntries, "the test collection is bigger than one value may be (" .. count(state.owned) .. ")")
    check(Storage.save("collection_a", state), "a full collection saves in buckets")
    check(db["collection_a"].owned == nil, "the main key holds no owned cards")
    check(db["collection_a"].version == 1, "the save layout is version 1")
    local biggest = 0
    for bucket = 1, Storage.BUCKETS do
        local saved = db[Storage.bucketKey("collection_a", bucket)]
        biggest = math.max(biggest, saved and count(saved) or 0)
    end
    check(biggest > 0 and biggest <= maxEntries, "no bucket is over the limit (biggest " .. biggest .. ")")
    local back = Storage.load("collection_a")
    check(sameOwned(back.owned, state.owned), "every owned card comes back with its count")
    check(back.credits == 42 and back.xpPool == 7 and back.difficulty == "normal" and back.stats.packsOpened == 9,
        "credits, xp pool, difficulty and stats come back")
    check(back.dirty == false and next(back.dirtyBuckets) == nil, "a loaded collection is clean")
end

-- 3. A change rewrites only its bucket (and the main key)
reset()
do
    local state = fullState()
    Storage.save("collection_a", state)
    writes = {}
    local variant = Cards.variantKey(Cards.list[100].id, "normal")
    Storage.addCard(state, variant, 1)
    check(Storage.save("collection_a", state), "the second save works")
    check(#writes == 2, "one changed card writes its bucket and the main key (wrote " .. #writes .. ")")
    check(writes[1] == Storage.bucketKey("collection_a", Storage.bucketOf(variant)), "it is the card's own bucket")
    writes = {}
    state.dirty = true
    Storage.save("collection_a", state)
    check(#writes == 1 and writes[1] == "collection_a", "a credits change writes only the main key")
    check(Storage.load("collection_a").owned[variant] == 2, "the new copy is there after loading")
end

-- 4. A refused bucket stays dirty and is tried again
reset()
do
    local state = fullState()
    local variant = Cards.variantKey(Cards.list[1].id, "normal")
    local badKey = Storage.bucketKey("collection_a", Storage.bucketOf(variant))
    failKeys[badKey] = true
    check(Storage.save("collection_a", state) == false, "a refused write makes the save report false")
    check(state.dirtyBuckets[Storage.bucketOf(variant)] == true, "the refused bucket stays dirty")
    local others = 0
    for bucket in pairs(state.dirtyBuckets) do
        others = others + 1
    end
    check(others == 1, "only the refused bucket stays dirty (" .. others .. ")")
    failKeys = {}
    check(Storage.save("collection_a", state), "the retry works")
    check(sameOwned(Storage.load("collection_a").owned, state.owned), "everything is there after the retry")
end

-- 5. A refused main key is reported
reset()
do
    local state = Storage.newState()
    failKeys["collection_a"] = true
    check(Storage.save("collection_a", state) == false, "a refused main key makes the save report false")
end

-- 6. Characters stay apart, and no character's name can make another's key
reset()
do
    local a, b = fullState(), Storage.newState()
    Storage.addCard(b, Cards.variantKey(Cards.list[1].id, "normal"), 1)
    Storage.save("collection_a", a)
    Storage.save("collection_a_o1", b)          -- a character called "A O1"
    check(count(Storage.load("collection_a").owned) == count(a.owned), "a second character does not change the first")
    check(count(Storage.load("collection_a_o1").owned) == 1, "the second character has only their own card")
    local names = { Storage.keyForName("Bucket1 Collection A"), Storage.keyForTracking("bucket1_collection_a") }
    check(names[1]:sub(1, 6) ~= "bucket" and names[2]:sub(1, 6) ~= "bucket", "no character key starts like a bucket key")
end

-- 7. The dev profile suffix keeps its own collections
reset()
do
    Storage.setProfileSuffix("-dev")
    local key = Storage.keyForName("Some Name")
    check(key == "collection_some_name-dev", "the dev key ends with the suffix")
    local state = Storage.newState()
    Storage.addCard(state, Cards.variantKey(Cards.list[1].id, "normal"), 1)
    Storage.save(key, state)
    check(db[Storage.bucketKey(key, Storage.bucketOf(Cards.variantKey(Cards.list[1].id, "normal")))] ~= nil,
        "its bucket key ends with the suffix too")
    Storage.setProfileSuffix("")
end

-- 8. Cards the deck does not have are kept; broken entries are dropped
reset()
do
    db["collection_a"] = { version = 1, buckets = Storage.BUCKETS, credits = 3 }
    db[Storage.bucketKey("collection_a", 1)] = {
        ["gone_card|normal"] = 2, ["x|holo"] = 1, ["plain_id"] = 1, ["bad|normal"] = -1, ["ok|normal"] = "many",
    }
    local state = Storage.load("collection_a")
    check(state.owned["gone_card|normal"] == 2, "a card the deck does not have is kept")
    check(count(state.owned) == 1, "a retired finish, an old key, a negative or a text count are dropped (" .. count(state.owned) .. ")")
end

-- 9. A save made with another bucket count loads whole, is rewritten, and its extra keys go
reset()
do
    local state = fullState()
    db["collection_a"] = { version = 1, buckets = 20, credits = 5 }
    local n = 0
    for variantKey, owned in pairs(state.owned) do          -- spread over 20 buckets (any way will do)
        n = n + 1
        local key = Storage.bucketKey("collection_a", n % 20 + 1)
        db[key] = db[key] or {}
        db[key][variantKey] = owned
    end
    local back = Storage.load("collection_a")
    check(sameOwned(back.owned, state.owned), "a save with 20 buckets loads every card")
    check(back.dirty and back.staleBuckets == 20, "it is marked to be rewritten")
    check(Storage.save("collection_a", back), "it saves again")
    check(db[Storage.bucketKey("collection_a", Storage.BUCKETS + 1)] == nil, "the buckets past the new count are gone")
    check(db["collection_a"].buckets == Storage.BUCKETS, "the main key records the new count")
    check(sameOwned(Storage.load("collection_a").owned, state.owned), "every card survives the rewrite")
end

-- 10. Deleting the saves takes only this profile's collections
reset()
do
    db["collection_a"], db["collection_a-dev"] = { credits = 1 }, { credits = 1 }
    db["bucket3_collection_a"], db["bucket3_collection_a-dev"] = { ["x|normal"] = 1 }, { ["x|normal"] = 1 }
    db["tracking_7-dev"], db["bucket16_tracking_7-dev"] = { credits = 1 }, { ["x|normal"] = 1 }
    db["dev_wiki_review_3"], db["dev_card_queue_0001-dev"], db["card_settings"] = { a = 1 }, { a = 1 }, { a = 1 }
    local deleted, why = Storage.deleteAllCollections()
    check(deleted == nil, "the copy with no suffix refuses to delete saves")
    Storage.setProfileSuffix("-dev")
    deleted = Storage.deleteAllCollections()
    check(deleted == 4, "the dev copy deletes its 4 collection keys (" .. tostring(deleted) .. ")")
    check(db["collection_a"] and db["bucket3_collection_a"], "a released copy's collections are left")
    check(db["dev_wiki_review_3"] and db["dev_card_queue_0001-dev"] and db["card_settings"], "everything else is left")
    Storage.setProfileSuffix("")
end

-- 11. The bucket is stable (saves depend on it) and spread over every bucket
do
    check(Storage.bucketOf("hans|normal") == Storage.bucketOf("hans|normal"), "a card always lands in the same bucket")
    check(Storage.bucketOf("hans|normal") == Storage.bucketOf("hans|holo"), "all finishes of a card share a bucket")
    check(Storage.bucketOf("hans|normal") == 16, "pinned: hans is in bucket 16 (changing the hash would lose saved cards)")
    local sizes = {}
    for _, card in ipairs(Cards.list) do
        local b = Storage.bucketOf(card.id .. "|normal")
        sizes[b] = (sizes[b] or 0) + 1
    end
    local least, most = math.huge, 0
    for bucket = 1, Storage.BUCKETS do
        least, most = math.min(least, sizes[bucket] or 0), math.max(most, sizes[bucket] or 0)
    end
    check(least > 0 and most < 2 * (#Cards.list / Storage.BUCKETS), "the cards are spread evenly (" .. least .. " to " .. most .. ")")
end

if failures > 0 then
    io.stderr:write(failures .. " storage check(s) failed\n")
    os.exit(1)
end
print("Storage checks passed.")
