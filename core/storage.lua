-- core/storage.lua
-- Loads and saves one player's collection using PersistentDB.
--
-- PersistentDB is stored per plugin, not per account, so every character gets its own
-- entry, keyed by character name. Without that, two accounts on one computer would
-- share a single collection.

local Cards = require("core/cards")

local Storage = {}

local DATA_VERSION = 3

-- Builds the PersistentDB key for a character, e.g. "Some Name" -> "collection_some_name"
local function keyFor(characterName)
    local key = string.lower(characterName)
    key = string.gsub(key, "[^%w]", "_")
    return "collection_" .. key
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
function Storage.newState()
    return { version = DATA_VERSION, credits = 0, xpPool = 0, difficulty = nil, owned = {},
        stats = Storage.newStats(), dirty = false }
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

-- Reads a character's collection, or returns a fresh one if nothing was saved yet.
-- Values are checked and rounded so a damaged or hand-edited entry cannot crash the plugin.
function Storage.load(characterName)
    local state = Storage.newState()
    local saved = PersistentDB:GetStructuredData(keyFor(characterName))
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
    if type(saved.owned) == "table" then
        for key, count in pairs(saved.owned) do
            if type(key) == "string" and type(count) == "number" and count > 0 then
                -- Older saves used other key shapes. Version 1 saved plain card ids (normal
                -- finish); version 2 saved "<id>|<art>|<finish>", and art styles no longer
                -- exist, so that becomes "<id>|<finish>" and any copies add together.
                local variantKey = key
                local oldId, _, oldFinish = string.match(key, "^([^|]+)|([^|]+)|([^|]+)$")
                if oldId ~= nil then
                    variantKey = oldId .. "|" .. oldFinish
                elseif Cards.parseKey(key) == nil then
                    variantKey = key .. "|normal"
                end
                -- Anything that still is not a known finish is dropped.
                local _, finish = Cards.parseKey(variantKey)
                if finish ~= nil and Cards.finishes[finish] ~= nil then
                    state.owned[variantKey] = (state.owned[variantKey] or 0) + math.floor(count)
                end
            end
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

-- Writes a character's collection. Returns true if it was saved.
function Storage.save(characterName, state)
    local ok = PersistentDB:SetStructuredData(keyFor(characterName), {
        version = state.version,
        credits = state.credits,
        xpPool = state.xpPool,
        difficulty = state.difficulty,
        owned = state.owned,
        stats = state.stats,
    })
    if not ok then
        log("save FAILED for", characterName)
    end
    return ok
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
--   normal, reverse, holo : cards owned in that finish, out of all cards
--   all                   : every variant, out of all cards x all finishes
function Storage.progress(state)
    local cardCount = #Cards.list
    local finishCount = 0
    for _ in pairs(Cards.finishes) do
        finishCount = finishCount + 1
    end
    local counts = { normal = 0, reverse = 0, holo = 0 }
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
        reverse = { owned = counts.reverse, total = cardCount },
        holo = { owned = counts.holo, total = cardCount },
        all = { owned = all, total = cardCount * finishCount },
    }
end

-- Adds copies of one variant to the collection (one copy if `count` is omitted).
-- `variantKey` comes from Cards.variantKey(cardId, finish).
function Storage.addCard(state, variantKey, count)
    state.owned[variantKey] = (state.owned[variantKey] or 0) + (count or 1)
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
