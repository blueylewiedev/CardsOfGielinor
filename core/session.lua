-- core/session.lua
-- The logged-in character's collection: loading it when the character is known, saving it at a steady pace, counting play time,
-- crediting XP, and saving and forgetting it when the player reaches the login screen. main.lua calls Session.start() once,
-- Session.tick() about every 0.6 seconds and Session.finish() at shutdown; the windows reach the collection through the api
-- table main.lua builds (Session.getState, Session.save, Session.keyKind).

local Storage = require("core/storage")
local Logger = require("core/logger")
local Identity = require("core/identity")
local Earning = require("core/earning")
local SlayerEvents = require("core/slayerevents")
local BossEvents = require("core/bossevents")
local Rate = require("core/rate")
local Events = require("core/events")

local Session = {}

-- Save at most once every this many server ticks (about 0.6 seconds each) while changes are pending, so frequent
-- changes such as XP gains do not save every tick.
local SAVE_INTERVAL_TICKS = 10

-- A save that is there but cannot be read is tried again every tick, and nothing is saved meanwhile (core/storage.lua,
-- Storage.load). After LOAD_TRIES failed tries (about 12 seconds) a save whose main entry is missing is loaded from its
-- buckets alone; one whose main entry is there but unreadable is never written over, however long it takes.
local LOAD_TRIES = 20

-- Set while a character is logged in: { name = "...", key = "<storage key>", kind = "tracking" or "name", state = <collection> }
local current = nil
local ticksSinceSave = 0
local ticksSinceLoad = 0
local failedLoads = 0

-- The logged-in character's collection, or nil while none is loaded.
function Session.getState()
    return current and current.state or nil
end

-- How the collection is saved: "tracking" (the tracking id), "name" or nil (not loaded).
function Session.keyKind()
    return current and current.kind or nil
end

-- Returns the logged-in character's name, or nil if it is not available yet. The name can arrive a moment after
-- login, so callers must be ready for nil.
local function currentCharacterName()
    if not Player.IsAvailable() then
        return nil
    end
    local entity = Player.GetEntity()
    if entity == nil then
        return nil
    end
    local name = entity.displayName
    if name == nil or name == "" then
        return nil
    end
    return name
end

-- Saves the collection if it has unsaved changes.
function Session.save()
    if current ~= nil and current.state.dirty then
        if Storage.save(current.key, current.state) then
            current.state.dirty = false
        end
    end
end

-- Loads the collection for a newly logged-in character. profile comes from Identity.profile. If the save cannot be read
-- yet, nothing happens (the next tick tries again).
local function begin(profile)
    -- With a tracking key and nothing saved under it yet, a collection kept under the character's name is copied
    -- (core/storage.lua), and saved at once so the copy exists before anything else changes.
    local state, adopted, problem = Storage.loadOrAdopt(profile.key, profile.adoptFrom,
        { acceptMissingMain = failedLoads >= LOAD_TRIES })
    if state == nil then
        failedLoads = failedLoads + 1
        if failedLoads == 1 then
            Logger.error("the saved collection for", profile.name, "could not be read (" .. tostring(problem)
                .. "): trying again, and nothing is saved until it is read")
        end
        return
    end
    failedLoads = 0
    current = { name = profile.name, key = profile.key, kind = profile.kind, state = state }
    ticksSinceSave = 0
    ticksSinceLoad = 0
    Rate.reset()                -- credits per hour start afresh for each character
    if adopted then
        Session.save()
        Logger.note("trackingAccess is on: the collection saved under the character name was copied to the tracking id")
    end
    Logger.debug("loaded collection for", profile.name, "(" .. profile.key .. ", " .. profile.how .. ") - credits:",
        state.credits, "unique cards:", Storage.countUniqueOwned(state), "variants:", Storage.countVariantsOwned(state))

    -- Slayer credits and boss kills follow this character from where they stand now.
    SlayerEvents.begin()
    BossEvents.begin()
end

-- Saves and forgets the current character, e.g. on logout or at shutdown.
function Session.finish()
    SlayerEvents.finish()
    BossEvents.finish()
    if current ~= nil then
        Storage.addPlayTicks(current.state, ticksSinceLoad % Rate.TICKS_PER_MINUTE)   -- the part of a minute since the last count
    end
    Session.save()
    current = nil
    failedLoads = 0
    Rate.reset()
end

-- Called about every 0.6 seconds. Waits for the character to be available, then loads their collection, and afterwards
-- saves pending changes at a steady pace.
function Session.tick()
    if current == nil then
        local profile = Identity.profile(currentCharacterName())
        if profile ~= nil then
            begin(profile)
        end
        return
    end

    Rate.tick()                 -- the clock of the credits per hour: only runs while a collection is loaded
    ticksSinceSave = ticksSinceSave + 1
    ticksSinceLoad = ticksSinceLoad + 1
    if ticksSinceLoad % Rate.TICKS_PER_MINUTE == 0 then
        Storage.addPlayTicks(current.state, Rate.TICKS_PER_MINUTE)    -- the play time for the Stats window, a minute at a time
    end
    if ticksSinceSave >= SAVE_INTERVAL_TICKS then
        ticksSinceSave = 0
        Session.save()
    end
end

-- Starts crediting XP and unloading at logout.
function Session.start()
    -- Credits from XP. Ignored until a character's collection has loaded.
    Events.on("SkillTransmit", "cardcollector_xp", function(e)
        if current == nil then
            return
        end
        local gain = Earning.xpGainFromEvent(e)
        if gain > 0 then
            Earning.addXP(current.state, gain)
        end
    end)

    -- Save and unload when the player reaches the login screen or lobby, so switching accounts never mixes up two
    -- collections.
    Events.on("GameStateChanged", "cardcollector_state", function(stateEvent)
        if stateEvent.newState == GameState.LOGINSCREEN or stateEvent.newState == GameState.LOBBY then
            Session.finish()
            Identity.reset()
        end
    end)
end

return Session
