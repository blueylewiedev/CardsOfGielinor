-- dev/check_bosses.lua
-- Checks the boss kill credits (core/bosses.lua) by replaying what the game sent in real tests (the Boss probe, 2026-11-17: four
-- bosses killed once each, with the server ticks the probe logged) and the cases around them: a count that rises with no boss
-- in view, a rise that is not one kill, the first moments after login, a boss paid twice, and two bosses in view.
--
-- Run from the plugin's folder:  lua dev/check_bosses.lua

package.path = "./?.lua;" .. package.path
local Bosses = require("core/bosses")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

-- A tracker whose payments are collected.
local function tracker()
    local paid = {}
    local t = Bosses.new({ award = function(kind, credits, info) paid[#paid + 1] = { kind = kind, credits = credits, info = info } end })
    return t, paid
end

-- Runs the tracker to server tick `tick`, with the boss `boss` ({ id, level, name }) in view at every second tick from
-- `from` to `to` (the polling of core/bossevents.lua), then calls `at(tick)` there.
local function play(t, tick)
    while t.now < tick do
        t:advance()
    end
end

-- ---------------------------------------------------------------------------------------------------------------------
-- What the game sent, as logged by the probe: a boss seen at every second tick until the count rose.
-- K'ril: seen from tick 74, the count (BSLAY_BOSS_KILLS9) rose at 94, the boss was last seen at 92.
-- Corporeal Beast: seen from 180, count (KILLS4, the high half) rose at 193, last seen at 192.
-- Rasial: seen from 258, count (KILLS37, the high half) rose at 292, last seen at 290.
-- Zemouregal: seen from 394, count (KILLS38) rose at 425, last seen at 424.
local recorded = {
    { name = "K'ril Tsutsaroth", id = 15, level = 650, first = 74, last = 92, rise = 94, var = "BSLAY_BOSS_KILLS9", old = 3541068, new = 3541069, credits = 800 },
    { name = "Corporeal Beast", id = 6, level = 785, first = 180, last = 192, rise = 193, var = "BSLAY_BOSS_KILLS4", old = 41222184, new = 41287720, credits = 800 },
    { name = "Rasial, the First Necromancer", id = 48, level = 8462, first = 258, last = 290, rise = 292, var = "BSLAY_BOSS_KILLS37", old = 4128922, new = 4194458, credits = 4000 },
    { name = "Zemouregal", id = 49, level = 789, first = 394, last = 424, rise = 425, var = "BSLAY_BOSS_KILLS38", old = 15, new = 16, credits = 800 },
}
for _, kill in ipairs(recorded) do
    local t, paid = tracker()
    play(t, Bosses.QUIET_TICKS + kill.first - 2)               -- (the replay starts after the quiet time)
    local shift = t.now - (kill.first - 2)
    for tick = kill.first, kill.last, 2 do
        play(t, tick + shift)
        t:seen(kill.id, kill.level, kill.name)
    end
    play(t, kill.rise + shift)
    check(t:onKillVar(kill.var, kill.old, kill.new) == true, kill.name .. ": the count rising is a kill")
    check(#paid == 1 and paid[1].credits == kill.credits and paid[1].info.id == kill.id,
        kill.name .. ": paid " .. kill.credits .. " for boss " .. kill.id .. " (" .. tostring(paid[1] and paid[1].credits) .. ")")
end

-- ---------------------------------------------------------------------------------------------------------------------
-- The credits by level
check(Bosses.creditsForLevel(206) == 400 and Bosses.creditsForLevel(276) == 400, "King Black Dragon and Ivar are the lowest tier")
check(Bosses.creditsForLevel(499) == 400 and Bosses.creditsForLevel(500) == 800, "500 is where the second tier starts")
check(Bosses.creditsForLevel(596) == 800 and Bosses.creditsForLevel(1000) == 1800, "Zilyana is the second tier and Nex the third")
check(Bosses.creditsForLevel(5000) == 4000 and Bosses.creditsForLevel(8999) == 4000, "5,000 to 8,999 is the fourth tier")
check(Bosses.creditsForLevel(9999) == 8000 and Bosses.creditsForLevel(14000) == 8000, "Amascut and TzKal-Zuk are the top tier")
check(Bosses.creditsForLevel(nil) == 400 and Bosses.creditsForLevel(0) == 400, "an unknown level is the lowest tier")

-- ---------------------------------------------------------------------------------------------------------------------
-- What counts as a kill: up by one power of two
check(Bosses.isKill(2124, 2125) and Bosses.isKill(41222184, 41287720), "+1 and +65536 are kills")
check(Bosses.isKill(0, 1) and Bosses.isKill(5, 261), "the first kill of a boss, and a count in a varbit (+256), are kills")
check(not Bosses.isKill(5, 5) and not Bosses.isKill(5, 4), "no rise and a fall are not kills")
check(not Bosses.isKill(0, 3) and not Bosses.isKill(10, 13) and not Bosses.isKill(0, 3541069), "a rise by 3 is not one kill (nor a whole value at login)")
check(not Bosses.isKill(nil, 1) and not Bosses.isKill(1, nil) and not Bosses.isKill("1", 2), "missing or wrong-typed values are not kills")
check(Bosses.isKillVar("BSLAY_BOSS_KILLS9") and Bosses.isKillVar("BSLAY_BOSS_KILLS38") and Bosses.isKillVar("BSLAY_BOSS_KILLS44"),
    "the boss kill counts are recognised")
check(not Bosses.isKillVar("BSLAY_MONSTER_KILLS7") and not Bosses.isKillVar("BSLAY_BOSS_PRESTIGE1")
    and not Bosses.isKillVar("BSLAY_REAPER_NECKLACE_STACK_AMOUNT") and not Bosses.isKillVar(nil)
    and not Bosses.isKillVar("BSLAY_BOSS_KILLS9X"), "monster counts, prestige and the Reaper necklace are not boss kills")

-- ---------------------------------------------------------------------------------------------------------------------
-- The cases around them
do
    -- a count rising with no boss in view pays nothing
    local t, paid = tracker()
    play(t, 200)
    check(t:onKillVar("BSLAY_BOSS_KILLS9", 5, 6) == false and #paid == 0, "a count rising with no boss seen pays nothing")

    -- a boss seen too long ago pays nothing
    t:seen(15, 650, "K'ril Tsutsaroth")
    play(t, 200 + Bosses.SEEN_WINDOW + 1)
    check(t:onKillVar("BSLAY_BOSS_KILLS9", 5, 6) == false and #paid == 0, "a boss last seen more than " .. Bosses.SEEN_WINDOW .. " ticks ago pays nothing")

    -- within the window it does, and only once until the boss has been seen again
    t:seen(15, 650, "K'ril Tsutsaroth")
    play(t, t.now + 2)
    check(t:onKillVar("BSLAY_BOSS_KILLS9", 5, 6) == true and #paid == 1, "a boss seen 2 ticks ago is paid")
    check(t:onKillVar("BSLAY_BOSS_KILLS9", 6, 7) == false and #paid == 1, "the same sighting is not paid twice")
    play(t, t.now + 10)
    t:seen(15, 650, "K'ril Tsutsaroth")
    play(t, t.now + 1)
    check(t:onKillVar("BSLAY_BOSS_KILLS9", 6, 7) == true and #paid == 2, "seen again, the next kill is paid")
end

do
    -- the first moments after the collection loaded are ignored (the client sends the variables then)
    local t, paid = tracker()
    play(t, 10)
    t:seen(15, 650, "K'ril Tsutsaroth")
    check(t:onKillVar("BSLAY_BOSS_KILLS9", 0, 65536) == false and #paid == 0, "a rise just after login pays nothing")
    play(t, Bosses.QUIET_TICKS)
    t:seen(15, 650, "K'ril Tsutsaroth")
    check(t:onKillVar("BSLAY_BOSS_KILLS9", 0, 65536) == true and #paid == 1, "the same rise later is a kill")
end

do
    -- two bosses in view: the one seen last is paid (the higher level if seen at the same tick)
    local t, paid = tracker()
    play(t, 100)
    t:seen(49, 789, "Zemouregal")
    t:seen(5, 596, "Commander Zilyana")
    play(t, 102)
    t:seen(5, 596, "Commander Zilyana")
    check(t:onKillVar("BSLAY_BOSS_KILLS6", 5, 6) == true and paid[1].info.id == 5, "of two bosses the one still in view is paid")
    local t2, paid2 = tracker()
    play(t2, 100)
    t2:seen(49, 789, "Zemouregal")
    t2:seen(5, 596, "Commander Zilyana")
    check(t2:onKillVar("BSLAY_BOSS_KILLS6", 5, 6) == true and paid2[1].info.id == 49, "seen at the same tick, the higher level is paid")

    -- an unknown level pays the lowest tier
    local t3, paid3 = tracker()
    play(t3, 100)
    t3:seen(9, nil, "Giant mole")
    check(t3:onKillVar("BSLAY_BOSS_KILLS2", 1, 2) == true and paid3[1].credits == 400, "a boss with no level is paid the lowest tier")
end

if failures > 0 then
    os.exit(1)
end
print("OK: boss kill credits replay the four recorded kills and the cases around them")
