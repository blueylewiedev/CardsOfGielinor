-- core/slayerevents.lua
-- Connects the Slayer credits (core/slayer.lua) to the game: it listens for the Slayer variables, Slayer XP and NPCs
-- leaving the world, reads what the tracker needs from the game's data and pays the credits into the logged-in
-- character's collection. No permission is needed. main.lua calls start() once, begin() when a collection loads,
-- finish() when it unloads and shutdown() when the plugin stops.

local Slayer = require("core/slayer")
local Logger = require("core/logger")
local Config = require("core/config")
local Storage = require("core/storage")
local Events = require("core/events")
local ClientReads = require("core/clientreads")
local prop = ClientReads.prop

local SlayerEvents = {}

local SUBSCRIBERS = {
    var = "cardsofgielinor_slayer_var",
    skill = "cardsofgielinor_slayer_xp",
    removed = "cardsofgielinor_slayer_removed",
    tick = "cardsofgielinor_slayer_tick",
}
local TASK_LIST_ENUM = 1563     -- SMKI_CRITTER_NAMES: the Slayer tasks by number
local MASTER_LIST_ENUM = 1553   -- SLAYER_MASTER_ENUM: each Slayer master's own list of tasks
local STRUCTS_PER_TICK = 25     -- task entries looked at each server tick while the example monsters are read

local api = nil                 -- api.getState() : the logged-in character's collection, or nil
local tracker = nil             -- set while a character is logged in
local names = {}                -- number in the task list -> the task's name in lower case
local namesLoaded = false       -- true once the list has been read (it is tried again until it has)
local isMember, unitsOf = nil, nil
local exampleLevel = {}         -- task number -> combat level of the task's example monster
local exampleQueue, exampleNext = nil, 1

-- The value of a player variable, or nil.
local function readVar(varId)
    local ok, value = pcall(function() return var.VarPlayer.FromID(varId).value end)
    if ok and type(value) == "number" then
        return value
    end
    return nil
end

-- Reads the game's Slayer task list once: the name of each task number.
local function loadNames()
    if namesLoaded then
        return
    end
    local found = {}
    local ok, err = pcall(function()
        for _, pair in ipairs(config.Enum.FromID(TASK_LIST_ENUM).values or {}) do
            if type(pair[1]) == "number" and type(pair[2]) == "string" then
                found[pair[1]] = string.lower(pair[2])
            end
        end
    end)
    if next(found) ~= nil then
        names = found
        namesLoaded = true
    elseif not ok then
        Logger.error("slayer credits: could not read the Slayer task list (will try again):", tostring(err))
    end
    isMember = Slayer.membership(names)
    unitsOf = Slayer.unitsOf(names)
end

-- The Slayer category of an NPC config (the number of its Slayer task), or nil if it has none or the number is not
-- a task (a few monsters carry other values).
local function categoryOf(cfg)
    local category = ClientReads.numberParam(cfg, "SLAYER_CATEGORY")
    if category ~= nil and names[category] ~= nil then
        return category
    end
    return nil
end

-- Reading each Slayer master's task entries, a few every tick, for the level of each task's example monster (used
-- only when a kill's monster was not seen).
local function startExamples()
    exampleQueue, exampleNext = {}, 1
    pcall(function()
        for _, pair in ipairs(config.Enum.FromID(MASTER_LIST_ENUM).values or {}) do
            for _, entry in ipairs(prop(pair[2], "values") or {}) do
                exampleQueue[#exampleQueue + 1] = entry[2]
            end
        end
    end)
end

local function exampleStep()
    if exampleQueue == nil or exampleNext > #exampleQueue then
        return
    end
    local okTypes, typeParam, npcParam = pcall(function()
        return config.Param.SLAYER_TYPE, config.Param.SLAYER_EXAMPLE_NPC
    end)
    local last = math.min(exampleNext + STRUCTS_PER_TICK - 1, #exampleQueue)
    if okTypes and typeParam ~= nil and npcParam ~= nil then
        for position = exampleNext, last do
            pcall(function()
                local struct = exampleQueue[position]
                if struct:HasParam(typeParam) and struct:HasParam(npcParam) then
                    local task = struct:GetParamValue(typeParam)
                    local level = prop(struct:GetParamValue(npcParam), "visibleCombatLevel")
                    if type(task) == "number" and type(level) == "number" and level >= 1 and exampleLevel[task] == nil then
                        exampleLevel[task] = level
                    end
                end
            end)
        end
    end
    exampleNext = last + 1
end

-- Pays what the tracker decides, into the logged-in character's collection.
local function award(kind, credits, info)
    local state = api.getState()
    if state == nil or not Config.get("slayer.enabled") then
        return
    end
    Storage.earnCredits(state, credits)
    if Logger.debugOn() then
        local task = info.task ~= nil and names[info.task] or tostring(info.task)
        Logger.debug("slayer credits: +" .. credits, kind, "(level", info.level .. ", task", task .. (info.fallback and ", monster not seen" or "") .. ")")
    end
end

local function onVariable(e)
    if tracker == nil then
        return
    end
    local ok, err = pcall(function()
        local varId = prop(prop(e, "var"), "id")
        if varId == Config.get("slayer.vars.count") then
            tracker:onCount(e.oldValue, e.newValue)
        elseif varId == Config.get("slayer.vars.task") then
            tracker:onTask(e.oldValue, e.newValue)
        elseif varId == Config.get("slayer.vars.streak") then
            tracker:onStreak(e.oldValue, e.newValue)
        end
    end)
    if not ok then
        Logger.error("slayer credits: variable handler failed:", tostring(err))
    end
end

local function onSkill(e)
    if tracker == nil then
        return
    end
    local ok, err = pcall(function()
        local isSlayer = false
        if SkillType ~= nil and SkillType.SLAYER ~= nil then
            isSlayer = e.skill == SkillType.SLAYER
        end
        if isSlayer and type(e.newXP) == "number" and type(e.oldXP) == "number" then
            tracker:onSlayerXp(e.newXP - e.oldXP)
        end
    end)
    if not ok then
        Logger.error("slayer credits: XP handler failed:", tostring(err))
    end
end

-- A monster left the world. Only matters while a count drop is waiting for its monster, so otherwise it is not
-- even read (monsters leave view all the time).
local function onRemoved(e)
    if tracker == nil or tracker:pending() == 0 then
        return
    end
    local ok, err = pcall(function()
        local entity = e.npcEntity
        local cfg, parent = prop(entity, "config"), prop(entity, "parentConfig")
        tracker:onRemoved({ category = categoryOf(cfg) or categoryOf(parent), level = ClientReads.combatLevel(cfg, parent) })
    end)
    if not ok then
        Logger.error("slayer credits: NPC handler failed:", tostring(err))
    end
end

local function onTick()
    if tracker ~= nil then
        local ok, err = pcall(function() tracker:advance() end)
        if not ok then
            Logger.error("slayer credits: tick failed:", tostring(err))
        end
    end
    exampleStep()
end

-- Starts listening. `newApi` needs getState(). What the tracker sees is written with Logger.debug.
function SlayerEvents.start(newApi)
    api = newApi
    loadNames()
    startExamples()
    Events.on("VarTransmit", SUBSCRIBERS.var, onVariable)
    Events.on("SkillTransmit", SUBSCRIBERS.skill, onSkill)
    Events.on("NPCEntityRemoved", SUBSCRIBERS.removed, onRemoved)
    Events.on("ServerLogic", SUBSCRIBERS.tick, onTick)
end

-- A character's collection has loaded: starts following their task from where it stands now.
function SlayerEvents.begin()
    loadNames()
    tracker = Slayer.new({
        count = readVar(Config.get("slayer.vars.count")),
        task = readVar(Config.get("slayer.vars.task")),
        streak = readVar(Config.get("slayer.vars.streak")),
        isMember = isMember,
        unitsOf = unitsOf,
        fallbackLevel = function(task) return exampleLevel[task] end,
        award = award,
        log = function(...) Logger.debug("slayer:", ...) end,
    })
end

-- The collection has been unloaded (logout, or another character).
function SlayerEvents.finish()
    tracker = nil
end

-- Stops listening. Called when the plugin is shut down.
function SlayerEvents.shutdown()
    tracker = nil
    Events.off("VarTransmit", SUBSCRIBERS.var)
    Events.off("SkillTransmit", SUBSCRIBERS.skill)
    Events.off("NPCEntityRemoved", SUBSCRIBERS.removed)
    Events.off("ServerLogic", SUBSCRIBERS.tick)
end

return SlayerEvents
