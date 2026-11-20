-- core/identity.lua
-- Works out whose collection is loaded: the logged-in character's tracking id when trackingAccess is granted (it does not change when
-- a character is renamed), otherwise their character name. The tracking id arrives some seconds after login (Player.GetTrackingID
-- docs), so it is polled from a ServerLogic handler until it does.

local Storage = require("core/storage")
local Events = require("core/events")

local Identity = {}

local SUBSCRIBER = "cardcollector_identity"

-- Ticks (about 0.6 s each) to wait for the permission to show up before settling for the character name: 10, about 6
-- seconds. If it is ever late for a player who has granted it, they start on the name collection for the session; the
-- tracking collection already exists and wins next login (core/storage.lua), so look in the client for a late
-- permission before making this shorter.
local PERMISSION_GRACE_TICKS = 10

local trackingId = nil
local subscribed = false
local ticksWithoutPermission = 0

local function poll()
    if trackingId ~= nil then
        return
    end
    if not Plugin.HasPermission(PluginPermissions.trackingAccess) then
        ticksWithoutPermission = ticksWithoutPermission + 1
        return
    end
    if not Player.IsAvailable() then
        return
    end
    trackingId = Player.GetTrackingID()
    if trackingId ~= nil then
        subscribed = false
        pcall(function() Events.off("ServerLogic", SUBSCRIBER) end)
    end
end

local function subscribe()
    if not subscribed then
        subscribed = true
        Events.on("ServerLogic", SUBSCRIBER, poll)
    end
end

-- Call once when the plugin loads. (The dev copy asks for the permission itself: dev/grants.lua. The plugin never does:
-- the player decides whether to grant it.)
function Identity.start()
    subscribe()
end

-- Call when the player leaves the game, so the next character is not given the last one's id.
function Identity.reset()
    trackingId = nil
    ticksWithoutPermission = 0
    subscribe()
end

-- Returns { name, key, how } for the logged-in character, or nil if it is not known yet.
-- key is what the collection is stored under and how says why that key was chosen. kind is "tracking" or "name";
-- a "tracking" profile also has adoptFrom, the name key to copy a collection from if there is no tracking one yet.
function Identity.profile(characterName)
    if characterName == nil then
        return nil
    end
    if trackingId ~= nil then
        -- adoptFrom: the key of a collection kept under the name before the permission was granted, to be copied
        -- here the first time (Storage.loadOrAdopt).
        return { name = characterName, key = Storage.keyForTracking(trackingId), how = "tracking id", kind = "tracking",
            adoptFrom = Storage.keyForName(characterName) }
    end
    if ticksWithoutPermission >= PERMISSION_GRACE_TICKS then
        return { name = characterName, key = Storage.keyForName(characterName), how = "name, trackingAccess not granted",
            kind = "name" }
    end
    return nil
end

return Identity
