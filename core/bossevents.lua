-- core/bossevents.lua
-- Connects the boss kill credits (core/bosses.lua) to the game: it listens for the boss kill counts, checks the NPCs
-- in view for bosses and pays the credits into the logged-in character's collection. No permission is needed.
-- main.lua calls start() once and shutdown() when the plugin stops; core/session.lua calls begin() when a collection loads and
-- finish() when it unloads.

local Bosses = require("core/bosses")
local Logger = require("core/logger")
local Config = require("core/config")
local Storage = require("core/storage")
local Events = require("core/events")
local ClientReads = require("core/clientreads")
local prop = ClientReads.prop

local BossEvents = {}

local SUBSCRIBERS = {
    var = "cardsofgielinor_boss_var",
    tick = "cardsofgielinor_boss_tick",
}

local api = nil                 -- api.getState() : the logged-in character's collection, or nil
local tracker = nil             -- set while a character is logged in

-- Tells the tracker which bosses are in view (what makes an NPC a boss is read once per config: core/clientreads.lua).
local function look()
    for _, entity in ipairs(NPCList.All()) do
        local id, level, name = ClientReads.bossOf(entity)
        if id ~= nil then
            tracker:seen(id, level, prop(entity, "displayName") or name)
        end
    end
end

-- Pays what the tracker decides, into the logged-in character's collection.
local function award(kind, credits, info)
    local state = api.getState()
    if state == nil or not Config.get("bosses.enabled") then
        return
    end
    Storage.earnCredits(state, credits)
    if Logger.debugOn() then
        Logger.debug("boss credits: +" .. credits, kind, "(" .. tostring(info.name) .. ", level " .. tostring(info.level)
            .. ", boss id " .. tostring(info.id) .. ")")
    end
end

local function onVariable(e)
    if tracker == nil then
        return
    end
    local ok, err = pcall(function()
        local name = prop(prop(e, "var"), "configName")
        if Bosses.isKillVar(name) then
            tracker:onKillVar(name, e.oldValue, e.newValue)
        end
    end)
    if not ok then
        Logger.error("boss credits: variable handler failed:", tostring(err))
    end
end

local function onTick()
    if tracker == nil then
        return
    end
    local ok, err = pcall(function()
        tracker:advance()
        if tracker.now % Bosses.POLL_EVERY == 0 then
            look()
        end
    end)
    if not ok then
        Logger.error("boss credits: tick failed:", tostring(err))
    end
end

-- Starts listening. `newApi` needs getState(). What the tracker sees is written with Logger.debug.
function BossEvents.start(newApi)
    api = newApi
    Events.on("VarTransmit", SUBSCRIBERS.var, onVariable)
    Events.on("ServerLogic", SUBSCRIBERS.tick, onTick)
end

-- A character's collection has loaded: starts looking for their boss kills.
function BossEvents.begin()
    ClientReads.forgetBosses()
    tracker = Bosses.new({
        award = award,
        log = function(...) Logger.debug("bosses:", ...) end,
    })
end

-- The collection has been unloaded (logout, or another character).
function BossEvents.finish()
    tracker = nil
end

-- Stops listening. Called when the plugin is shut down.
function BossEvents.shutdown()
    tracker = nil
    pcall(function() Events.off("VarTransmit", SUBSCRIBERS.var) end)
    pcall(function() Events.off("ServerLogic", SUBSCRIBERS.tick) end)
end

return BossEvents
