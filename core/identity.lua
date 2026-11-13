-- core/identity.lua
-- Works out whose collection is loaded: the logged-in character's tracking id when the
-- trackingAccess permission has been granted, otherwise their character name.
--
-- The tracking id is better because it does not change when a character is renamed. It
-- is sent to the client at login and "several seconds may pass before it becomes available"
-- (Player.GetTrackingID docs), so it is polled from a ServerLogic handler until it arrives.

local Storage = require("core/storage")
local PluginId = require("core/pluginid")

local Identity = {}

local SUBSCRIBER = "cardcollector_identity"

-- Ticks (about 0.6 seconds each) to wait for the permission to show up before settling for
-- the character name. The dev copy asks for the permission as it loads, and the client may
-- take a moment to apply it.
local PERMISSION_GRACE_TICKS = 20

-- In the dev copy the plugin asks for the permission itself on every start, since the client
-- forgets grants when it restarts: ppr requests the manifest's permissions, ppe turns one on.
-- A released plugin never does this; the player decides whether to grant it.
local DEV_GRANTS_PERMISSION = true

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
        pcall(function() Event.ServerLogic.Unsubscribe(SUBSCRIBER) end)
    end
end

local function subscribe()
    if not subscribed then
        subscribed = true
        Event.ServerLogic.Subscribe(SUBSCRIBER, poll)
    end
end

-- Call once when the plugin loads. devCopy is true while the development tools are present.
function Identity.start(devCopy)
    if devCopy and DEV_GRANTS_PERMISSION then
        local ok, err = pcall(function()
            PluginId.command("ppr")
            PluginId.command("ppe", "trackingAccess")
        end)
        if not ok then
            log("could not ask for the trackingAccess permission:", err)
        end
    end
    subscribe()
end

-- Call when the player leaves the game, so the next character is not given the last one's id.
function Identity.reset()
    trackingId = nil
    ticksWithoutPermission = 0
    subscribe()
end

-- Returns { name, key, how } for the logged-in character, or nil if it is not known yet.
-- key is what the collection is stored under and how says why that key was chosen.
function Identity.profile(characterName)
    if characterName == nil then
        return nil
    end
    if trackingId ~= nil then
        return { name = characterName, key = Storage.keyForTracking(trackingId), how = "tracking id" }
    end
    if ticksWithoutPermission >= PERMISSION_GRACE_TICKS then
        return { name = characterName, key = Storage.keyForName(characterName), how = "name, trackingAccess not granted" }
    end
    return nil
end

return Identity
