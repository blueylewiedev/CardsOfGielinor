-- core/storage.lua
-- Loads and saves one character's collection in PersistentDB, under their tracking id (or their name when trackingAccess is not
-- granted: core/identity.lua).
--
-- The client refuses a single value of more than about 2,000 table entries, so a character has one main key (credits, XP pool,
-- stats) and the owned cards are spread over BUCKETS more keys by a hash of the card id; a save rewrites only the buckets that
-- changed.

local Cards = require("core/cards")
local Rate = require("core/rate")
local Config = require("core/config")
local Logger = require("core/logger")

local Storage = {}

-- The layout of a save. Stays at 1 until there is a release candidate.
local DATA_VERSION = 1

-- The credits a brand new collection starts with (Config "starterCredits", 8,000: two standard packs, so a new player can
-- open some at once).
function Storage.starterCredits()
    return Config.get("starterCredits")
end

-- How many keys the owned cards are spread over. A save records its own count, so changing this loses nothing, but it rewrites
-- everything: leave it. dev/check_storage.lua fails when the fullest bucket passes half of the 2,000-entry limit.
local BUCKETS = 32
Storage.BUCKETS = BUCKETS

-- The most buckets a save may say it was made with. A damaged or edited count (a billion) must not make the load read a
-- billion keys; the plugin has only ever used 16 and 32.
local MAX_SAVED_BUCKETS = 256

-- Lower-cases text and swaps anything but letters and digits for "_", so it is safe in a key.
local function clean(text)
    local key = string.gsub(string.lower(tostring(text)), "[^%w]", "_")
    return key
end

-- PersistentDB key for a collection kept under a character's name, e.g. "Some Name" -> "collection_some_name".
function Storage.keyForName(characterName)
    return "collection_" .. clean(characterName)
end

-- PersistentDB key for a collection kept under a character's tracking id. The different
-- prefix means no character name can ever produce the same key.
function Storage.keyForTracking(trackingId)
    return "tracking_" .. clean(trackingId)
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

-- A fresh, empty collection: credits, xpPool (XP not yet a whole credit), owned ({ ["<card id>|<finish>"] = copies
-- }), stats (newStats), dirty (unsaved changes), dirtyBuckets ({ [bucket] = true }) and staleBuckets (the bucket
-- count of the loaded save, if it is not BUCKETS).
function Storage.newState()
    return { version = DATA_VERSION, credits = 0, xpPool = 0, owned = {},
        stats = Storage.newStats(), dirty = false, dirtyBuckets = {} }
end

-- Lifetime statistics: packsOpened, cardsPulled, creditsEarned (from play), creditsSpent,
-- playTicks (about 0.6 s each, for the credits per hour) and finishes and rarities ({ name = cards pulled }).
function Storage.newStats()
    return { packsOpened = 0, cardsPulled = 0, creditsEarned = 0, creditsSpent = 0, playTicks = 0,
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

-- True if the database says `key` is there. (Never raises: a failed question is a no.)
local function exists(key)
    local ok, there = pcall(function() return PersistentDB:CheckExists(key) end)
    return ok and there == true
end

-- What is under `key` when its main entry reads as nothing, so a failed read is never taken for a player who has
-- never saved (the first save would write over their real collection): "none" (a new collection), "unreadable" (the
-- main entry is there but could not be read) or "noMain" (buckets but no main entry).
function Storage.absentKind(key)
    if exists(key) then
        return "unreadable"
    end
    for bucket = 1, BUCKETS do
        if exists(Storage.bucketKey(key, bucket)) then
            return "noMain"
        end
    end
    return "none"
end

-- True if anything is saved under `key` (its main entry, or any of its buckets).
function Storage.hasSave(key)
    return PersistentDB:GetStructuredData(key) ~= nil or Storage.absentKind(key) ~= "none"
end

-- Reads the collection under a key, or a fresh one if nothing is saved. Values are checked so a damaged entry cannot
-- crash the plugin. Returns nil and why if a save is there but its main entry cannot be read (Storage.absentKind):
-- the caller retries and saves nothing meanwhile. opts.acceptMissingMain loads a "noMain" save from its buckets
-- alone, with no credits or statistics (main.lua does this after a few tries).
function Storage.load(key, opts)
    local state = Storage.newState()
    local saved = PersistentDB:GetStructuredData(key)
    if saved ~= nil and type(saved) ~= "table" then
        -- Not what a save looks like (the saves are tables): read it as one with nothing in it, so the buckets are still read.
        Logger.error("the collection saved under", key, "is a", type(saved), "and not a table: its credits and statistics are not read")
        saved = {}
    end
    if saved == nil then
        local kind = Storage.absentKind(key)
        if kind == "none" then
            -- A new collection starts with the starter credits (two packs). It is marked as changed so they are saved with
            -- the first save, and the grant is not made again.
            state.credits = Storage.starterCredits()
            state.dirty = true
            return state
        end
        if kind == "unreadable" or not (opts ~= nil and opts.acceptMissingMain) then
            return nil, kind
        end
        -- The cards in the buckets, with no credits or statistics; saved soon, so the main entry is there again.
        Logger.error("the collection saved under", key, "had no main entry: its cards were read from its buckets, its credits and statistics are lost")
        saved = {}
        state.dirty = true
    end

    if type(saved.credits) == "number" and saved.credits > 0 then
        state.credits = math.floor(saved.credits)
    end
    if type(saved.xpPool) == "number" and saved.xpPool > 0 then
        state.xpPool = math.floor(saved.xpPool)
    end

    -- The owned cards, from as many buckets as the save was made with.
    local buckets = BUCKETS
    if type(saved.buckets) == "number" and saved.buckets >= 1 then
        buckets = math.min(math.floor(saved.buckets), MAX_SAVED_BUCKETS)
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
        for _, field in ipairs({ "packsOpened", "cardsPulled", "creditsEarned", "creditsSpent", "playTicks" }) do
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

-- Loads the collection for `key`. If `key` has no save but `oldKey` (the name collection from before trackingAccess)
-- does, that one is copied and marked changed, so the next save writes it under `key`; the old keys are left alone,
-- and once `key` has a save it always wins. Returns the collection and true if copied, or nil, false and why if a
-- save could not be read (opts is passed to Storage.load).
function Storage.loadOrAdopt(key, oldKey, opts)
    if oldKey == nil or oldKey == key or Storage.hasSave(key) or not Storage.hasSave(oldKey) then
        local state, problem = Storage.load(key, opts)
        return state, false, problem
    end
    local state, problem = Storage.load(oldKey, opts)
    if state == nil then
        return nil, false, problem
    end
    state.staleBuckets = nil     -- that is about the old keys, which this save never deletes
    state.dirty = true
    for bucket = 1, BUCKETS do
        state.dirtyBuckets[bucket] = true
    end
    return state, true
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
            Logger.error("save FAILED for", bucketKey)
        end
    end

    local ok = PersistentDB:SetStructuredData(key, {
        version = state.version,
        buckets = BUCKETS,
        credits = state.credits,
        xpPool = state.xpPool,
        stats = state.stats,
    })
    if not ok then
        allOk = false
        Logger.error("save FAILED for", key)
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
    Rate.add(amount)
end

-- Adds ticks of play to the stats and marks the collection as needing a save (main.lua calls it once a minute of play,
-- and with what is left over at logout).
function Storage.addPlayTicks(state, ticks)
    if ticks > 0 then
        state.stats.playTicks = state.stats.playTicks + ticks
        state.dirty = true
    end
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

-- Adds copies of one variant to the collection (one copy if `count` is omitted). `variantKey` comes from
-- Cards.variantKey(cardId, finish).
function Storage.addCard(state, variantKey, count)
    state.owned[variantKey] = (state.owned[variantKey] or 0) + (count or 1)
    state.dirtyBuckets[Storage.bucketOf(variantKey)] = true
    state.dirty = true
end

-- True if the player owns at least one variant of the card.
function Storage.ownsCard(state, cardId)
    for _, finish in ipairs(Cards.finishOrder) do
        if state.owned[Cards.variantKey(cardId, finish)] ~= nil then
            return true
        end
    end
    return false
end

-- How many copies of a variant the player owns.
function Storage.countOwned(state, variantKey)
    return state.owned[variantKey] or 0
end

-- How many different cards the player owns, counting a card once however many variants of it they have.
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
