-- core/storage.lua
-- Loads and saves one player's collection using PersistentDB.
--
-- PersistentDB is stored per plugin, not per account, so every character gets its own
-- entry, keyed by character name. Without that, two accounts on one computer would
-- share a single collection.
--
-- The client refuses a single value that is too big (see dev/dblimit.lua for the probe that finds
-- where), and a full collection has thousands of entries. So a character has one main key (credits,
-- XP pool, difficulty, stats) and the owned cards are spread over BUCKETS more keys, the bucket
-- chosen by a hash of the card's id. A pack only rewrites the buckets it changed.

local Cards = require("core/cards")

local Storage = {}

-- The layout of a save. Stays at 1 until there is a release candidate.
local DATA_VERSION = 1

-- How many keys the owned cards are spread over. A character's saved count is read back, so changing
-- this loses nothing (the next save rewrites the buckets), but it is a lot of rewriting: leave it.
local BUCKETS = 16
Storage.BUCKETS = BUCKETS

-- Added to the end of every key while the development tools are present (main.lua sets it).
-- The dev copy of the plugin and a released copy on the same computer have the same plugin name,
-- so they share one PersistentDB; the suffix gives each its own collections.
local profileSuffix = ""

function Storage.setProfileSuffix(suffix)
    profileSuffix = suffix or ""
end

-- Lower-cases text and swaps anything but letters and digits for "_", so it is safe in a key.
local function clean(text)
    local key = string.gsub(string.lower(tostring(text)), "[^%w]", "_")
    return key
end

-- PersistentDB key for a collection kept under a character's name,
-- e.g. "Some Name" -> "collection_some_name" (plus the profile suffix, see above).
function Storage.keyForName(characterName)
    return "collection_" .. clean(characterName) .. profileSuffix
end

-- PersistentDB key for a collection kept under a character's tracking id. The different
-- prefix means no character name can ever produce the same key.
function Storage.keyForTracking(trackingId)
    return "tracking_" .. clean(trackingId) .. profileSuffix
end

-- The key of one bucket of a collection (`key` is the main key). It starts with "bucket", which no main
-- key does, so no character name can make a main key that is also somebody's bucket.
function Storage.bucketKey(key, bucket)
    return "bucket" .. bucket .. "_" .. key
end

-- Which bucket a variant key ("<card id>|<finish>") is kept in, from 1 to `count` (BUCKETS if omitted). It
-- depends only on the card's id, so all of a card's variants share a bucket and moving cards between deck
-- files changes nothing.
function Storage.bucketOf(variantKey, count)
    local cardId = Cards.parseKey(variantKey) or variantKey
    local hash = 5381
    for i = 1, #cardId do
        hash = (hash * 33 + string.byte(cardId, i)) % 4294967296
    end
    return hash % (count or BUCKETS) + 1
end

-- A fresh, empty collection.
--   credits : spendable credits
--   difficulty : id of the pack price tier the player chose (see core/packs.lua), or nil
--   xpPool  : XP gained that has not yet added up to a whole credit
--   owned   : { [variantKey] = how many copies the player owns }, where the key is
--             "<card id>|<finish>" (see Cards.variantKey). Each variant is
--             counted separately.
--   stats   : lifetime numbers for the Stats window (see newStats). Only counted from the
--             time they were added, so packs opened before that are not in them.
--   dirty   : true when there are unsaved changes (never written to the database)
--   dirtyBuckets : { [bucket] = true } for the buckets of `owned` that changed since they were saved
--   staleBuckets : how many buckets the loaded save was spread over, if that is not BUCKETS (the keys
--             past the new count are deleted once everything is saved again), else nil
function Storage.newState()
    return { version = DATA_VERSION, credits = 0, xpPool = 0, difficulty = nil, owned = {},
        stats = Storage.newStats(), dirty = false, dirtyBuckets = {} }
end

-- Lifetime statistics.
--   packsOpened, cardsPulled : how many packs were opened and cards pulled from them
--   creditsEarned            : credits earned from XP (not credits added by the dev tools)
--   creditsSpent             : credits spent on packs
--   finishes                 : { [finish] = cards pulled with that finish }
--   rarities                 : { [rarity] = cards pulled of that rarity }
function Storage.newStats()
    return { packsOpened = 0, cardsPulled = 0, creditsEarned = 0, creditsSpent = 0,
        finishes = {}, rarities = {} }
end

-- Reads a saved { [name] = count } table, keeping only sensible numbers.
local function loadCounts(saved)
    local counts = {}
    if type(saved) == "table" then
        for name, count in pairs(saved) do
            if type(name) == "string" and type(count) == "number" and count > 0 then
                counts[name] = math.floor(count)
            end
        end
    end
    return counts
end

-- Adds the owned entries of one saved table to `owned`, keeping only sound ones: a "<card id>|<finish>"
-- key with a known finish and a positive count. A card id the deck does not have is kept, so a card that
-- goes missing and comes back still has its copies.
local function loadOwned(owned, saved)
    if type(saved) ~= "table" then
        return
    end
    for variantKey, count in pairs(saved) do
        if type(variantKey) == "string" and type(count) == "number" and count > 0 then
            local _, finish = Cards.parseKey(variantKey)
            if finish ~= nil and Cards.finishes[finish] ~= nil then
                owned[variantKey] = (owned[variantKey] or 0) + math.floor(count)
            end
        end
    end
end

-- Reads the collection stored under a key (see keyForName / keyForTracking), or returns a
-- fresh one if nothing was saved yet.
-- Values are checked and rounded so a damaged or hand-edited entry cannot crash the plugin.
function Storage.load(key)
    local state = Storage.newState()
    local saved = PersistentDB:GetStructuredData(key)
    if saved == nil then
        return state
    end

    if type(saved.credits) == "number" and saved.credits > 0 then
        state.credits = math.floor(saved.credits)
    end
    if type(saved.xpPool) == "number" and saved.xpPool > 0 then
        state.xpPool = math.floor(saved.xpPool)
    end
    if type(saved.difficulty) == "string" then
        state.difficulty = saved.difficulty
    end

    -- The owned cards, from as many buckets as the save was made with.
    local buckets = BUCKETS
    if type(saved.buckets) == "number" and saved.buckets >= 1 then
        buckets = math.floor(saved.buckets)
    end
    for bucket = 1, buckets do
        loadOwned(state.owned, PersistentDB:GetStructuredData(Storage.bucketKey(key, bucket)))
    end
    if buckets ~= BUCKETS then
        -- Saved under another count: every card moves, so write everything again.
        state.staleBuckets = buckets
        state.dirty = true
        for bucket = 1, BUCKETS do
            state.dirtyBuckets[bucket] = true
        end
    end

    if type(saved.stats) == "table" then
        local stats = state.stats
        for _, field in ipairs({ "packsOpened", "cardsPulled", "creditsEarned", "creditsSpent" }) do
            local value = saved.stats[field]
            if type(value) == "number" and value > 0 then
                stats[field] = math.floor(value)
            end
        end
        stats.finishes = loadCounts(saved.stats.finishes)
        stats.rarities = loadCounts(saved.stats.rarities)
    end
    return state
end

-- Writes the collection under a key: the buckets that changed first, then the main key. Returns true if
-- everything was saved; a write that the database refuses is logged and left dirty, so the next save
-- tries it again.
function Storage.save(key, state)
    local allOk = true

    -- Sort the owned cards into the dirty buckets.
    local pending = {}
    for bucket in pairs(state.dirtyBuckets) do
        pending[bucket] = {}
    end
    if next(pending) ~= nil then
        for variantKey, count in pairs(state.owned) do
            local into = pending[Storage.bucketOf(variantKey)]
            if into ~= nil then
                into[variantKey] = count
            end
        end
    end
    for bucket, entries in pairs(pending) do
        local bucketKey = Storage.bucketKey(key, bucket)
        local ok
        if next(entries) == nil then
            ok = PersistentDB:Delete(bucketKey)       -- nothing in it: no key at all
            ok = ok or not PersistentDB:CheckExists(bucketKey)
        else
            ok = PersistentDB:SetStructuredData(bucketKey, entries)
        end
        if ok then
            state.dirtyBuckets[bucket] = nil
        else
            allOk = false
            log("save FAILED for", bucketKey)
        end
    end

    local ok = PersistentDB:SetStructuredData(key, {
        version = state.version,
        buckets = BUCKETS,
        credits = state.credits,
        xpPool = state.xpPool,
        difficulty = state.difficulty,
        stats = state.stats,
    })
    if not ok then
        allOk = false
        log("save FAILED for", key)
    end

    -- A save made with another bucket count: its extra keys are not read any more.
    if allOk and state.staleBuckets ~= nil then
        for bucket = BUCKETS + 1, state.staleBuckets do
            PersistentDB:Delete(Storage.bucketKey(key, bucket))
        end
        state.staleBuckets = nil
    end
    return allOk
end

-- Deletes every collection saved by this copy of the plugin (the keys that end with the profile suffix,
-- so the dev copy leaves a released copy's collections alone): the main keys and their buckets. Nothing
-- else in the database is touched. Returns how many keys were deleted, or nil and a reason. Only for the
-- development tools; a copy with no suffix refuses.
function Storage.deleteAllCollections()
    if profileSuffix == "" then
        return nil, "no profile suffix: only the dev copy may do this"
    end
    local doomed = {}
    PersistentDB:IterateEntries(function(key)
        if string.sub(key, -#profileSuffix) == profileSuffix then
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

-- Adds credits and marks the collection as needing a save.
function Storage.addCredits(state, amount)
    state.credits = state.credits + amount
    state.dirty = true
end

-- Spends credits if the player has enough. Returns true if it worked.
function Storage.spendCredits(state, amount)
    if state.credits < amount then
        return false
    end
    state.credits = state.credits - amount
    state.stats.creditsSpent = state.stats.creditsSpent + amount
    state.dirty = true
    return true
end

-- Adds credits that were earned by playing (counted in the stats, unlike addCredits).
function Storage.earnCredits(state, amount)
    state.stats.creditsEarned = state.stats.creditsEarned + amount
    Storage.addCredits(state, amount)
end

-- Counts one opened pack in the stats. `results` is the list Packs.open builds, each with a
-- card and a finish.
function Storage.recordPack(state, results)
    local stats = state.stats
    stats.packsOpened = stats.packsOpened + 1
    for _, result in ipairs(results) do
        stats.cardsPulled = stats.cardsPulled + 1
        stats.finishes[result.finish] = (stats.finishes[result.finish] or 0) + 1
        local rarity = result.card.rarity
        stats.rarities[rarity] = (stats.rarities[rarity] or 0) + 1
    end
    state.dirty = true
end

-- How much of the collection the player has, as { owned, total } for each of:
--   normal : cards owned in the normal finish, out of all cards
--   all    : every variant, out of all cards x all finishes
function Storage.progress(state)
    local cardCount = #Cards.list
    local finishCount = 0
    for _ in pairs(Cards.finishes) do
        finishCount = finishCount + 1
    end
    local counts = { normal = 0 }
    local all = 0
    for key in pairs(state.owned) do
        local cardId, finish = Cards.parseKey(key)
        if cardId ~= nil and Cards.byId[cardId] ~= nil and counts[finish] ~= nil then
            counts[finish] = counts[finish] + 1
            all = all + 1
        end
    end
    return {
        normal = { owned = counts.normal, total = cardCount },
        all = { owned = all, total = cardCount * finishCount },
    }
end

-- Adds copies of one variant to the collection (one copy if `count` is omitted).
-- `variantKey` comes from Cards.variantKey(cardId, finish).
function Storage.addCard(state, variantKey, count)
    state.owned[variantKey] = (state.owned[variantKey] or 0) + (count or 1)
    state.dirtyBuckets[Storage.bucketOf(variantKey)] = true
    state.dirty = true
end

-- Sets the pack price tier. `tierId` is an id from Packs.tiers.
function Storage.setDifficulty(state, tierId)
    state.difficulty = tierId
    state.dirty = true
end

-- True if the player owns at least one variant of the card.
function Storage.ownsCard(state, cardId)
    for key in pairs(state.owned) do
        if Cards.parseKey(key) == cardId then
            return true
        end
    end
    return false
end

-- How many copies of a variant the player owns.
function Storage.countOwned(state, variantKey)
    return state.owned[variantKey] or 0
end

-- How many different cards the player owns, counting a card once however many
-- variants of it they have.
function Storage.countUniqueOwned(state)
    local seen = {}
    local total = 0
    for key in pairs(state.owned) do
        local cardId = Cards.parseKey(key)
        if cardId ~= nil and not seen[cardId] then
            seen[cardId] = true
            total = total + 1
        end
    end
    return total
end

-- How many different variants (card + finish) the player owns.
function Storage.countVariantsOwned(state)
    local total = 0
    for _ in pairs(state.owned) do
        total = total + 1
    end
    return total
end

return Storage
