-- core/slayer.lua
-- Credits from Slayer tasks: a credit for each task kill (the combat level of the monster killed) and a bonus when
-- the task is completed. This file is the logic only and calls nothing from the client, so dev/check_slayer.lua can
-- replay what the game sent. core/slayerevents.lua feeds it the game's events and pays the credits out.
--
-- How a kill is seen. The server counts the kills, in VarPlayer 183 (SLAYER_COUNT, the kills left): it drops when a
-- task monster is killed. That alone is not enough, because cancelling a task (or a reset) moves it too, so a drop
-- only counts if Slayer XP arrives within XP_WINDOW server ticks of it (a kill always gives Slayer XP, a cancel
-- never does), and a drop of more than MAX_DROP is never kills. The count does not say which monster died. The
-- monster leaves the world a few server ticks later (2 to 6 were seen, once its death animation ends), so after a
-- confirmed drop the NPCs that leave are looked at for WAIT_TICKS: the first ones that leave after the drop
-- and count for the task (core/slayertasks.lua) are the kills, and each is paid its own combat level. (Always after the
-- drop: in the same update as it is too soon to be the kill.) A monster that left before the drop died earlier (and a monster leaving is not always a death: it may only have walked out of
-- view), so it is never matched. A drop of 5 can be one monster (an abyssal lord counts as five), so the credits
-- are per monster killed, not per unit of the count. A drop with no monster to match still pays one kill, at the
-- level of the last monster killed for the task (or the task's example monster).
--
-- Completion. VarPlayer 10077 (SMKI_MISSION_COUNT, the streak) rises by exactly 1 when a task is completed. Cancelling
-- keeps the streak, and skipping resets it to 0, so neither is mistaken for a completion. The bonus is
-- "slayer.bonusMultiplier" times the average level of the kills paid on that task, and is paid once the last kill is.
--
-- Time here is the server tick (about 0.6 seconds): `now` counts them, and advance() is called once for each.

local SlayerTasks = require("core/slayertasks")
local Config = require("core/config")

local Slayer = {}

-- The variables the game keeps the task in (VarPlayer ids): Config "slayer.vars.count", ".task" and ".streak" (183, 185 and
-- 10077; a game update may move them).
-- The credits. A kill pays "slayer.creditsPerLevel" (1) for each combat level of the monster, and the bonus is
-- "slayer.bonusMultiplier" (5) times that for the average level. Whole credits only (at least 1). "slayer.levelCap", if
-- set, is the highest level that is paid for (a few bosses report levels in the thousands); none is no cap. "slayer.enabled"
-- is the switch for all Slayer credits (core/slayerevents.lua).
Slayer.DEFAULT_LEVEL = 1        -- the level of a kill when nothing at all is known about it

-- How the game's behaviour is read.
Slayer.XP_WINDOW = 2            -- Slayer XP must arrive this many server ticks before or after a count drop
Slayer.WAIT_TICKS = 12          -- how long after a drop the monster may take to leave the world
Slayer.MAX_DROP = 25            -- a drop larger than this is a cancel or a reset, not kills
Slayer.MAX_XP_GAIN = 100000     -- a Slayer XP gain larger than this is the client sending the total at login

-- Credits for a kill of a monster of this level.
function Slayer.creditsForLevel(level)
    if type(level) ~= "number" or level < 1 then
        level = Slayer.DEFAULT_LEVEL
    end
    local cap = Config.get("slayer.levelCap")
    if cap ~= nil and level > cap then
        level = cap
    end
    return math.max(1, math.floor(level * Config.get("slayer.creditsPerLevel") + 0.5))
end

-- The bonus for completing a task whose kills averaged this level.
function Slayer.bonusForLevel(level)
    if type(level) ~= "number" or level < 1 then
        level = Slayer.DEFAULT_LEVEL
    end
    local cap = Config.get("slayer.levelCap")
    if cap ~= nil and level > cap then
        level = cap
    end
    return math.max(1, math.floor(level * Config.get("slayer.creditsPerLevel") * Config.get("slayer.bonusMultiplier") + 0.5))
end

-- Makes the function that says whether a monster counts for a task: isMember(task, category), where both are keys of
-- the game's Slayer task list and `names` is { key = the task's name in lower case }. A monster counts for a task
-- if its category is the task, or has the task's name, or is listed under the task in core/slayertasks.lua. With no
-- task known (nil or 0) every monster that has a category counts. A monster with no category never does.
function Slayer.membership(names)
    local includes = {}
    for broad, list in pairs(SlayerTasks.includes) do
        local set = {}
        for _, narrow in ipairs(list) do
            set[narrow] = true
        end
        includes[broad] = set
    end
    return function(task, category)
        if category == nil then
            return false
        end
        if task == nil or task == 0 or task == category then
            return true
        end
        local taskName, categoryName = names[task], names[category]
        if taskName == nil or categoryName == nil then
            return false
        end
        if taskName == categoryName then
            return true
        end
        local set = includes[taskName]
        return set ~= nil and set[categoryName] == true
    end
end

-- Makes the function that says how many kills of the task a monster counts as: unitsOf(category).
function Slayer.unitsOf(names)
    return function(category)
        local name = category ~= nil and names[category] or nil
        return name ~= nil and SlayerTasks.units[name] or 1
    end
end

local Tracker = {}
Tracker.__index = Tracker

-- Starts following a task. `env` supplies:
--   count, task, streak : the three variables as they are now (any may be nil)
--   isMember(task, category), unitsOf(category) : see Slayer.membership and Slayer.unitsOf
--   fallbackLevel(task) : the level of the task's example monster, or nil (optional)
--   award(kind, credits, info) : called to pay out; kind is "kill" or "bonus", info has level, task, category
--     and, for a kill paid at a guessed level, fallback = true
--   log(...) : optional
function Slayer.new(env)
    local self = setmetatable({}, Tracker)
    self.env = env
    self.now = 0
    self.count, self.task, self.streak = env.count, env.task, env.streak
    self.xpTicks = {}           -- the server ticks Slayer XP arrived in
    self.removals = {}          -- monsters that left the world: { tick, category, level, used }
    self.drops = {}             -- count drops waiting for their monsters: see onCount
    self.levels = { sum = 0, count = 0 }    -- the levels paid for on this task
    self.lastLevel = {}         -- task -> the level of the last monster paid for
    self.completion = nil       -- { tick } while a completed task's bonus is waiting for its last kill
    return self
end

function Tracker:say(...)
    if self.env.log ~= nil then
        self.env.log(...)
    end
end

-- The level to pay a kill at when the monster is not known.
function Tracker:fallbackLevel(task)
    local level = self.lastLevel[task]
    if level == nil and self.env.fallbackLevel ~= nil then
        level = self.env.fallbackLevel(task)
    end
    if type(level) ~= "number" or level < 1 then
        level = Slayer.DEFAULT_LEVEL
    end
    return level
end

-- Pays one kill. `removal` is the monster that left (with a category and maybe a level), or nil for a kill whose
-- monster was not seen.
function Tracker:payKill(drop, removal)
    local level = removal ~= nil and removal.level or nil
    local guessed = type(level) ~= "number" or level < 1
    if guessed then
        level = self:fallbackLevel(drop.task)
    else
        self.lastLevel[drop.task] = level
        self.levels.sum = self.levels.sum + level
        self.levels.count = self.levels.count + 1
    end
    local units = removal ~= nil and self.env.unitsOf(removal.category) or drop.remaining
    drop.remaining = drop.remaining - math.max(1, units)
    drop.kills = drop.kills + 1
    self.env.award("kill", Slayer.creditsForLevel(level),
        { level = level, task = drop.task, category = removal ~= nil and removal.category or nil, fallback = guessed })
end

-- True if Slayer XP arrived within XP_WINDOW ticks before `tick` (or at it).
function Tracker:xpBefore(tick)
    for _, xpTick in ipairs(self.xpTicks) do
        if xpTick <= tick and tick - xpTick <= Slayer.XP_WINDOW then
            return true
        end
    end
    return false
end

-- VarPlayer 183 changed. A fall is a candidate for kills; a rise is a new task.
function Tracker:onCount(old, new)
    if type(new) ~= "number" then
        return
    end
    if type(old) == "number" and new < old then
        local units = old - new
        if units <= Slayer.MAX_DROP then
            self.drops[#self.drops + 1] = {
                tick = self.now, units = units, remaining = units, task = self.task, kills = 0,
                confirmed = self:xpBefore(self.now),
            }
            self:say("count fell by", units, "with" .. (self.drops[#self.drops].confirmed and "" or "out") .. " Slayer XP so far")
            self:match()
        else
            self:say("count fell by", units, ": not kills")
        end
    end
    self.count = new
end

-- VarPlayer 185 changed: a new task.
function Tracker:onTask(_, new)
    if new ~= self.task then
        self.task = new
        if self.completion == nil then
            self.levels = { sum = 0, count = 0 }
        end
    end
end

-- VarPlayer 10077 changed. The streak rising by exactly one is a completed task.
function Tracker:onStreak(_, new)
    if type(new) ~= "number" then
        return
    end
    if self.streak ~= nil and new == self.streak + 1 and self.completion == nil then
        self.completion = { tick = self.now }
        self:say("task completed (streak", self.streak, "to", new .. ")")
    end
    self.streak = new
end

-- Slayer XP was gained.
function Tracker:onSlayerXp(gain)
    if type(gain) ~= "number" or gain <= 0 or gain > Slayer.MAX_XP_GAIN then
        return
    end
    self.xpTicks[#self.xpTicks + 1] = self.now
    for _, drop in ipairs(self.drops) do
        if not drop.confirmed and self.now - drop.tick <= Slayer.XP_WINDOW then
            drop.confirmed = true
        end
    end
    self:match()
end

-- A monster left the world. `npc` is { category = its Slayer category or nil, level = its combat level or nil }.
function Tracker:onRemoved(npc)
    self.removals[#self.removals + 1] = { tick = self.now, category = npc.category, level = npc.level, used = false }
    self:match()
end

-- Pairs confirmed drops with the monsters that left at or after them.
function Tracker:match()
    for _, drop in ipairs(self.drops) do
        if drop.confirmed then
            for _, removal in ipairs(self.removals) do
                if drop.remaining <= 0 then
                    break
                end
                if not removal.used and removal.tick > drop.tick and removal.tick <= drop.tick + Slayer.WAIT_TICKS
                    and self.env.isMember(drop.task, removal.category) then
                    removal.used = true
                    self:payKill(drop, removal)
                end
            end
        end
    end
    local waiting = {}
    for _, drop in ipairs(self.drops) do
        if drop.remaining > 0 then
            waiting[#waiting + 1] = drop
        end
    end
    self.drops = waiting
end

-- One server tick has passed: gives up on drops that were not kills or whose monster never left, drops old
-- removals, and pays a completion bonus once its last kill is paid.
function Tracker:advance()
    self.now = self.now + 1
    local now = self.now

    local kept = {}
    for _, drop in ipairs(self.drops) do
        if not drop.confirmed and now > drop.tick + Slayer.XP_WINDOW then
            self:say("count fell by", drop.units, "with no Slayer XP: not kills (a cancelled task?)")
        elseif drop.confirmed and now > drop.tick + Slayer.WAIT_TICKS then
            if drop.kills == 0 then
                self:payKill(drop, nil)
            end
        else
            kept[#kept + 1] = drop
        end
    end
    self.drops = kept

    local xpKept = {}
    for _, xpTick in ipairs(self.xpTicks) do
        if now - xpTick <= Slayer.XP_WINDOW + 1 then
            xpKept[#xpKept + 1] = xpTick
        end
    end
    self.xpTicks = xpKept
    local removalsKept = {}
    for _, removal in ipairs(self.removals) do
        if removal.tick >= now - Slayer.WAIT_TICKS - 1 then
            removalsKept[#removalsKept + 1] = removal
        end
    end
    self.removals = removalsKept

    local completion = self.completion
    if completion ~= nil and now > completion.tick
        and (#self.drops == 0 or now > completion.tick + Slayer.WAIT_TICKS + Slayer.XP_WINDOW) then
        local level
        if self.levels.count > 0 then
            level = self.levels.sum / self.levels.count
        else
            level = self:fallbackLevel(self.task)
        end
        self.completion = nil
        self.levels = { sum = 0, count = 0 }
        self.env.award("bonus", Slayer.bonusForLevel(level), { level = level, task = self.task })
    end
end

-- How many count drops are waiting for their monsters (for the checks).
function Tracker:pending()
    return #self.drops
end

return Slayer
