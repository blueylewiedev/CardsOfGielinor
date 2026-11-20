-- core/bosses.lua
-- Credits for boss kills, by the boss's combat level. Logic only, no client calls (dev/check_bosses.lua replays what the game sent);
-- core/bossevents.lua feeds it the game's events and pays out.
--
-- How a kill is seen: the server counts boss kills in VarPlayers named BSLAY_BOSS_KILLS<n>, and a kill raises one by a single power
-- of two (+1, +65536 for the high half, ...). The variable does not say which boss, so the boss that was last in view (an NPC with a
-- BSLAY_ID, polled every POLL_EVERY ticks) when the count rose is the one killed. Some counts rise for something else (the Barrows
-- chest): the "bosses.activities" tuning key lists those and they pay a fixed amount.
--
-- Safeguards: no boss seen within SEEN_WINDOW ticks pays nothing; nothing is paid in the first QUIET_TICKS after the collection
-- loads; a paid boss is not paid again until PAID_BLOCK ticks pass and it is seen again. Time is the server tick (about 0.6 s).

local Config = require("core/config")

local Bosses = {}

-- The credits by the boss's combat level (Config "bosses.tiers": { lowest level, credits }, highest first). These are the
-- shipped bands; they can be adjusted through the card overlay's tuning line. Also Config "bosses.activities", "bosses.overrides"
-- (credits for one boss by BSLAY_ID, 0 stops it paying) and "bosses.enabled" (the switch for all boss credits).
Bosses.DEFAULT_LEVEL = 1        -- the level of a kill when the boss's level is not known

-- How the game's behaviour is read.
Bosses.PAID_BLOCK = 12          -- a boss that has been paid is not paid again for this many server ticks (Vindicta stayed in view
                                -- 10 ticks after her count rose)
Bosses.SEEN_WINDOW = 6          -- the boss must have been in view this many server ticks before the count rose, at most
Bosses.QUIET_TICKS = 50         -- nothing is paid for this many server ticks after the collection loads
Bosses.POLL_EVERY = 2           -- (used by core/bossevents.lua) how often, in server ticks, the NPCs in view are checked

-- True if `name` is one of the boss kill counts.
function Bosses.isKillVar(name)
    return type(name) == "string" and string.find(name, "^BSLAY_BOSS_KILLS%d+$") ~= nil
end

-- True if a count went from `old` to `new` by one kill: up by a single power of two (1, 65536, ...).
function Bosses.isKill(old, new)
    if type(old) ~= "number" or type(new) ~= "number" then
        return false
    end
    local before, after = math.tointeger(old), math.tointeger(new)
    if before == nil or after == nil or after <= before then
        return false
    end
    local rise = after - before
    return rise & (rise - 1) == 0
end

-- Credits for a kill of a boss of this combat level.
function Bosses.creditsForLevel(level)
    if type(level) ~= "number" or level < 1 then
        level = Bosses.DEFAULT_LEVEL
    end
    local tiers = Config.get("bosses.tiers")
    for _, tier in ipairs(tiers) do
        if level >= tier[1] then
            return tier[2]
        end
    end
    return tiers[#tiers][2]
end

local Tracker = {}
Tracker.__index = Tracker

-- `env`: award(kind, credits, info) pays credits (info: { name, level, id }); log(...) writes a line (optional).
function Bosses.new(env)
    local self = setmetatable({}, Tracker)
    self.env = env
    self.now = 0
    self.bosses = {}            -- BSLAY_ID -> { tick (last seen), level, name, paidAt }
    return self
end

function Tracker:say(...)
    if self.env.log ~= nil then
        self.env.log(...)
    end
end

-- One server tick has passed.
function Tracker:advance()
    self.now = self.now + 1
end

-- A boss (an NPC with a BSLAY_ID, `id`) is in view now. `level` is its combat level (or nil), `name` for the log.
function Tracker:seen(id, level, name)
    local boss = self.bosses[id]
    if boss == nil then
        boss = { paidAt = -1 }
        self.bosses[id] = boss
    end
    -- One sighting is every poll since the last payment. Some bosses show several NPCs with different levels (Gorvek and
    -- Vindicta report 0 and 1,000, Har-Aken 800 and 1,600), so the highest level of the sighting is the boss's.
    if boss.tick ~= nil and boss.paidAt < boss.tick and type(boss.level) == "number" and boss.level > (type(level) == "number" and level or 0) then
        level = boss.level
    end
    boss.tick, boss.level, boss.name = self.now, level, name
end

-- A boss kill count (the variable `name`) went from `old` to `new`. Pays the credits if it was a kill and a boss was in view;
-- returns whether it paid.
function Tracker:onKillVar(name, old, new)
    if not Bosses.isKill(old, new) then
        return false
    end
    if self.now < Bosses.QUIET_TICKS then
        self:say("boss kill count", name, old, "->", new, "ignored: the collection has only just loaded")
        return false
    end
    local activity = Config.get("bosses.activities")[name]
    activity = activity ~= nil and activity[math.tointeger(new) - math.tointeger(old)] or nil
    if activity ~= nil then
        self.env.award("activity", activity.credits, { name = activity.name })
        return true
    end
    local best, bestId = nil, nil
    for id, boss in pairs(self.bosses) do
        if self.now - boss.tick <= Bosses.SEEN_WINDOW and boss.paidAt < boss.tick and self.now - boss.paidAt >= Bosses.PAID_BLOCK then
            if best == nil or boss.tick > best.tick or (boss.tick == best.tick and (boss.level or 0) > (best.level or 0)) then
                best, bestId = boss, id
            end
        end
    end
    if best == nil then
        self:say("boss kill count", name, old, "->", new, "but no boss was in view: nothing paid")
        return false
    end
    best.paidAt = self.now
    local credits = Config.get("bosses.overrides")[bestId] or Bosses.creditsForLevel(best.level)
    if credits <= 0 then
        self:say("boss", bestId, best.name, "pays 0 credits (tuning): nothing paid")
        return false
    end
    self.env.award("boss", credits, { name = best.name, level = best.level, id = bestId })
    return true
end

return Bosses
