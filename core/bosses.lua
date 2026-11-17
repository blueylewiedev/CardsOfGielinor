-- core/bosses.lua
-- Credits for boss kills: one credit amount for each boss killed, by the boss's combat level. This file is the logic only and
-- calls nothing from the client, so dev/check_bosses.lua can replay what the game sent. core/bossevents.lua feeds it the
-- game's events and pays the credits out.
--
-- How a kill is seen (found with the Boss probe, 2026-11-17, in K'ril Tsutsaroth, Corporeal Beast, Rasial and Zemouregal):
--   * The server counts boss kills in the VarPlayers named BSLAY_BOSS_KILLS<n> (about 45 of them). A kill raises a count
--     inside one of them by exactly 1 at the count's own place: +1, or +65536 for a count in the high 16 bits, or another
--     power of two for a count in a varbit. So a rise by a single power of two is a kill. (Which half is the normal count and
--     which hard mode differs from boss to boss, so no half is treated differently.)
--   * The variable does not say which boss it was. The bosses carry a BSLAY_ID parameter, and a boss in view is
--     seen by checking the NPCs every POLL_EVERY server ticks (core/bossevents.lua). The boss was in view 0 to 2 ticks before the
--     count rose in all four tests and left view in the same tick or one after, so the boss that was last in view at
--     the moment of the rise is the one killed. (NPCEntityRemoved is no use here: the entities cannot be read when it fires.)
--
-- Activities. Some counts are not rises while a boss is in view: the Barrows count rises when the chest is looted, about
-- 90 seconds after the last brother died, and only Verac of the brothers carries a BSLAY_ID. Those are listed in
-- Bosses.ACTIVITIES by variable and rise, and pay a fixed amount whatever is in view.
--
-- Safeguards. A rise with no boss seen within SEEN_WINDOW ticks pays nothing (the game sends many variables when a character
-- logs in, and a count can rise for other reasons); everything in the first QUIET_TICKS after the collection loaded is
-- ignored for the same reason; and a boss that has been paid is not paid again until it has been seen again.
--
-- Time here is the server tick (about 0.6 seconds): `now` counts them, and advance() is called once for each.

local Bosses = {}

-- The credits, by the boss's combat level: { lowest level, credits }, highest first. Combat levels run from about 150 to 14,000
-- and say how hard a boss is better than how quickly it dies, so the levels are grouped. Placeholders, to be tuned with the
-- credit system once there are real credits per hour from play-testing.
Bosses.TIERS = {
    { 9000, 8000 },     -- Vorago, Seiryu, Zamorak, Amascut, TzKal-Zuk
    { 5000, 4000 },     -- Solak, Rasial, Arch-Glacor, Croesus, Raksha, Nex: Angel of Death, the Ambassador
    { 1000, 1800 },     -- Telos, Araxxi, Kalphite King, Nex, Kezalam, Nakatra, and most others of the last years
    { 500, 800 },       -- the God Wars bosses, Corporeal Beast, Har-Aken, Queen Black Dragon, TzTok-Jad, Zemouregal
    { 0, 400 },         -- King Black Dragon, Giant Mole, Kalphite Queen, Chaos Elemental, the Dagannoth Kings
}

-- Counts that rise for something other than a boss dying in view: { [variable name] = { [rise] = { name, credits } } }. Found
-- with the Boss probe; add one only after seeing the count rise in the game.
Bosses.ACTIVITIES = {
    BSLAY_BOSS_KILLS2 = {
        [65536] = { name = "Barrows chest", credits = 1800 },     -- the chest looted (high half of the count)
    },
}
Bosses.DEFAULT_LEVEL = 1        -- the level of a kill when the boss's level is not known

-- How the game's behaviour is read.
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
    for _, tier in ipairs(Bosses.TIERS) do
        if level >= tier[1] then
            return tier[2]
        end
    end
    return Bosses.TIERS[#Bosses.TIERS][2]
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
    local activity = Bosses.ACTIVITIES[name]
    activity = activity ~= nil and activity[math.tointeger(new) - math.tointeger(old)] or nil
    if activity ~= nil then
        self.env.award("activity", activity.credits, { name = activity.name })
        return true
    end
    local best, bestId = nil, nil
    for id, boss in pairs(self.bosses) do
        if self.now - boss.tick <= Bosses.SEEN_WINDOW and boss.paidAt < boss.tick then
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
    self.env.award("boss", Bosses.creditsForLevel(best.level), { name = best.name, level = best.level, id = bestId })
    return true
end

return Bosses
