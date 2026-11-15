-- dev/check_slayer.lua
-- Checks the Slayer credits (core/slayer.lua, core/slayertasks.lua) by replaying what the game sent in real tests
-- (an Imp, an AOE on Lesser demons, a Black demon, Bronze dragons, finishing a task, cancelling and skipping one) and
-- the cases around them: a monster that left before the count fell, a count drop with no Slayer XP, a drop too big
-- to be kills, an abyssal lord counting as five, a task cancelled and a new one taken. The tick numbers are the
-- server ticks the probe logged (shifted to start near 0). It also checks that XP in the combat skills earns no
-- credits (core/earning.lua).
--
-- Run from the plugin's folder:  lua dev/check_slayer.lua

package.path = "./?.lua;" .. package.path

local Slayer = require("core/slayer")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

-- The game's Slayer task list (enum 1563): the numbers the tests use, with the names the game gives them.
local names = {
    [2] = "goblins", [6] = "cows", [11] = "skeletons", [12] = "ghosts", [22] = "dogs", [24] = "green dragons",
    [25] = "blue dragons", [26] = "red dragons", [28] = "lesser demons", [29] = "greater demons",
    [30] = "black demons", [39] = "crawling hands", [42] = "abyssal demons", [58] = "bronze dragons",
    [59] = "iron dragons", [80] = "cave horrors", [134] = "chaos giants", [173] = "dragons", [174] = "demons",
    [179] = "nodon dragonkin", [180] = "abyssal demons", [181] = "abyssal savages", [182] = "abyssal beasts",
    [183] = "abyssal lords", [191] = "undead",
}
local isMember, unitsOf = Slayer.membership(names), Slayer.unitsOf(names)

-- A tracker with a record of what it paid. `start` can set count, task, streak and fallbackLevel.
local function newRun(start)
    local run = { awards = {} }
    start = start or {}
    run.tracker = Slayer.new({
        count = start.count, task = start.task, streak = start.streak,
        isMember = isMember, unitsOf = unitsOf, fallbackLevel = start.fallbackLevel,
        award = function(kind, credits, info)
            run.awards[#run.awards + 1] = { kind = kind, credits = credits, level = info.level, fallback = info.fallback }
        end,
    })
    function run.go(tick)
        while run.tracker.now < tick do
            run.tracker:advance()
        end
    end
    function run.total()
        local sum = 0
        for _, award in ipairs(run.awards) do
            sum = sum + award.credits
        end
        return sum
    end
    function run.kills()
        local count = 0
        for _, award in ipairs(run.awards) do
            if award.kind == "kill" then
                count = count + 1
            end
        end
        return count
    end
    return run
end

-- Who counts for which task ---------------------------------------------------------------------------------------
check(isMember(174, 174), "a monster of the task's own category counts")
check(isMember(174, 28), "Lesser demons count for Demons (seen in the game)")
check(isMember(174, 30), "Black demons count for Demons (seen in the game)")
check(isMember(174, 29), "Greater demons count for Demons (owner's review)")
check(not isMember(174, 11), "Skeletons do not count for Demons (seen in the game)")
check(not isMember(174, 6), "Cows do not count for Demons")
check(isMember(173, 58) and isMember(173, 25) and isMember(173, 26), "Bronze, Blue and Red dragons count for Dragons")
check(not isMember(173, 22), "Dogs do not count for Dragons")
check(isMember(191, 11), "Skeletons count for Undead")
check(not isMember(11, 191), "but a Skeletons task does not count a monster that is only Undead")
check(isMember(24, 24) and not isMember(24, 25), "a narrow task counts only its own monsters")
check(isMember(180, 182), "Abyssal beasts count for the Abyssal demons task (180, by name)")
check(isMember(42, 180), "two numbers with one name count for each other")
check(not isMember(174, nil), "a monster with no category never counts")
check(isMember(nil, 6) and isMember(0, 6), "with no task known any categorised monster counts")
check(not isMember(174, 999), "a category the list does not have does not count")
check(unitsOf(182) == 2 and unitsOf(183) == 5 and unitsOf(28) == 1 and unitsOf(nil) == 1, "abyssal beast 2, lord 5, others 1")

-- The numbers -----------------------------------------------------------------------------------------------------
check(Slayer.creditsForLevel(70) == 70 and Slayer.creditsForLevel(5) == 5, "a kill pays its level at 1 credit a level")
check(Slayer.creditsForLevel(nil) == 1 and Slayer.creditsForLevel(0) == 1, "an unknown level pays at least 1")
check(Slayer.bonusForLevel(70) == 350, "the bonus is five times the level")
do
    Slayer.LEVEL_CAP = 150
    check(Slayer.creditsForLevel(3000) == 150 and Slayer.bonusForLevel(3000) == 750, "a level cap limits both")
    Slayer.LEVEL_CAP = nil
    check(Slayer.creditsForLevel(3000) == 3000, "and nil is no cap")
    Slayer.CREDITS_PER_LEVEL = 0.5
    check(Slayer.creditsForLevel(5) == 3 and Slayer.creditsForLevel(1) == 1, "a smaller rate rounds, never below 1")
    Slayer.CREDITS_PER_LEVEL = 1
end

-- An Imp (Demons task): the count fell at tick 6, Slayer XP one logic tick later, the Imp left at 8. A Cow and a
-- Goblin left around the same time and were not the kill.
do
    local run = newRun({ count = 100, task = 174, streak = 5001 })
    run.go(3); run.tracker:onRemoved({ category = 2, level = 2 })          -- a Goblin, before
    run.go(6)
    run.tracker:onCount(100, 99); run.tracker:onSlayerXp(6)
    run.tracker:onRemoved({ category = 6, level = 2 })                      -- a Cow, in the same update: too soon
    run.go(8)
    run.tracker:onRemoved({ category = 174, level = 5 })                    -- the Imp
    check(#run.awards == 1 and run.awards[1].kind == "kill" and run.awards[1].credits == 5, "Imp: paid 5 once")
    check(run.tracker:pending() == 0, "Imp: nothing left waiting")
    run.go(30)
    check(#run.awards == 1, "Imp: nothing more is paid later")
end

-- AOE on Lesser demons: the count fell by 2 at tick 128 (XP at 128), by 1 at 130 (XP at 129, before it); Skeletons
-- had left at 124; two Lesser demons left at 134. The third is not seen: it is paid at the last level.
do
    local run = newRun({ count = 99, task = 174, streak = 5002 })
    run.go(124); run.tracker:onRemoved({ category = 11, level = 32 })      -- Skeletons, before
    run.go(128); run.tracker:onCount(99, 97); run.tracker:onSlayerXp(174)
    run.go(129); run.tracker:onSlayerXp(86)
    run.go(130); run.tracker:onCount(97, 96)
    run.go(134)
    run.tracker:onRemoved({ category = 28, level = 70 }); run.tracker:onRemoved({ category = 28, level = 70 })
    check(run.kills() == 2 and run.total() == 140, "AOE: two Lesser demons paid 70 each")
    check(run.tracker:pending() == 1, "AOE: the third kill is still waiting for its monster")
    run.go(143)
    check(run.kills() == 3 and run.total() == 210 and run.awards[3].fallback == true, "AOE: the third is paid at the last level (70), marked guessed")
    check(run.tracker:pending() == 0, "AOE: all done")
end

-- The same, with the third monster leaving late (at 137): paid for the monster, not guessed.
do
    local run = newRun({ count = 99, task = 174, streak = 5002 })
    run.go(128); run.tracker:onCount(99, 97); run.tracker:onSlayerXp(174)
    run.go(130); run.tracker:onCount(97, 96)
    run.go(134); run.tracker:onRemoved({ category = 28, level = 70 }); run.tracker:onRemoved({ category = 28, level = 70 })
    run.go(137); run.tracker:onRemoved({ category = 28, level = 70 })
    check(run.kills() == 3 and run.total() == 210 and not run.awards[3].fallback, "AOE (late third): paid 70 three times, none guessed")
end

-- Finishing a task: the streak and the count change in one update at tick 13 (XP at 12), the last Lesser demon leaves
-- at 18. The bonus (5 x 70) is paid after that kill, not before.
do
    local run = newRun({ count = 1, task = 174, streak = 5001 })
    run.go(12); run.tracker:onSlayerXp(87)
    run.go(13); run.tracker:onStreak(5001, 5002); run.tracker:onCount(1, 0)
    run.go(17)
    check(#run.awards == 0, "Completion: nothing is paid before the monster has left")
    run.go(18); run.tracker:onRemoved({ category = 28, level = 70 })
    check(#run.awards == 1 and run.awards[1].kind == "kill" and run.awards[1].credits == 70, "Completion: the last kill is paid first")
    run.go(19)
    check(#run.awards == 2 and run.awards[2].kind == "bonus" and run.awards[2].credits == 350, "Completion: then the bonus, 5 x 70")
    run.go(60)
    check(#run.awards == 2, "Completion: the bonus is paid once")
end

-- The bonus uses the average level of the kills on the task.
do
    local run = newRun({ count = 3, task = 174, streak = 10 })
    for _, level in ipairs({ 5, 70, 98 }) do
        local tick = run.tracker.now + 3
        run.go(tick); run.tracker:onCount(run.tracker.count, run.tracker.count - 1); run.tracker:onSlayerXp(10)
        run.go(tick + 3); run.tracker:onRemoved({ category = 174, level = level })
        if level == 98 then
            run.tracker:onStreak(10, 11)
        end
    end
    run.go(run.tracker.now + 3)
    local bonus = run.awards[#run.awards]
    check(bonus.kind == "bonus" and bonus.credits == math.floor((5 + 70 + 98) / 3 * 5 + 0.5), "Bonus: five times the average level of the kills (" .. tostring(bonus.credits) .. ")")
end

-- Cancelling a task with points: the count falls with no Slayer XP, the streak does not move.
do
    local run = newRun({ count = 3, task = 174, streak = 5002 })
    run.go(10); run.tracker:onCount(3, 0)
    run.go(14); run.tracker:onRemoved({ category = 28, level = 70 })        -- something nearby leaves, a Lesser demon
    run.go(30)
    check(#run.awards == 0 and run.tracker:pending() == 0, "Cancel: a drop with no Slayer XP pays nothing, even with a monster leaving")
end

-- Skipping a task with Spria: the streak is reset to 0 and a new task of 16 kills starts. Nothing is paid, and the next
-- completion (0 to 1) still pays a bonus.
do
    local run = newRun({ count = 3, task = 80, streak = 5002 })
    run.go(10)
    run.tracker:onStreak(5002, 0); run.tracker:onTask(80, 39); run.tracker:onCount(3, 16)
    run.go(30)
    check(#run.awards == 0, "Skip: nothing is paid")
    run.go(40); run.tracker:onStreak(0, 1)
    run.go(42)
    check(#run.awards == 1 and run.awards[1].kind == "bonus", "Skip: the next completion (0 to 1) pays a bonus")
end

-- A Black demon and Bronze dragons are paid at their own levels; a monster that left before the drop is not the kill
-- even when it counts for the task (a Red dragon on a Dragons task).
do
    local run = newRun({ count = 81, task = 173, streak = 5002 })
    run.go(10); run.tracker:onRemoved({ category = 26, level = 84 })        -- a Red dragon, 2 ticks before
    run.go(11); run.tracker:onSlayerXp(124); run.tracker:onRemoved({ category = 22, level = 35 })    -- a Wild dog
    run.go(12); run.tracker:onCount(81, 80)
    run.tracker:onRemoved({ category = 59, level = 98 })                    -- an Iron dragon in the same update: too soon
    run.go(16); run.tracker:onRemoved({ category = 58, level = 86 })        -- the Bronze dragon
    check(run.kills() == 1 and run.awards[1].credits == 86, "Dragons: the Bronze dragon is paid 86, not the Red or Iron dragon that left before or with the drop")
    local black = newRun({ count = 76, task = 174, streak = 5002 })
    black.go(15); black.tracker:onSlayerXp(294); black.tracker:onCount(76, 75)
    black.go(21); black.tracker:onRemoved({ category = 30, level = 98 })
    black.go(25); black.tracker:onRemoved({ category = 22, level = 35 })
    check(black.kills() == 1 and black.awards[1].credits == 98 and black.total() == 98, "Black demon: paid 98 once, the Wild dog later is not a kill")
end

-- Abyssal lords and beasts count for 5 and 2 kills of the task but are one monster: one kill is paid.
do
    local run = newRun({ count = 20, task = 174, streak = 1 })
    run.go(5); run.tracker:onCount(20, 15); run.tracker:onSlayerXp(300)
    run.go(9); run.tracker:onRemoved({ category = 183, level = 120 })
    check(run.kills() == 1 and run.awards[1].credits == 120 and run.tracker:pending() == 0, "Abyssal lord: a drop of 5 pays one kill and is done")
    run.go(40)
    check(run.kills() == 1, "Abyssal lord: nothing more is paid for the other four")
    local beast = newRun({ count = 20, task = 174, streak = 1 })
    beast.go(5); beast.tracker:onCount(20, 18); beast.tracker:onSlayerXp(100)
    beast.go(8); beast.tracker:onRemoved({ category = 182, level = 119 })
    check(beast.kills() == 1 and beast.tracker:pending() == 0, "Abyssal beast: a drop of 2 pays one kill")
end

-- A drop of 5 and one ordinary monster (so an unknown multiplier): one kill is paid and no more, never inflated.
do
    local run = newRun({ count = 20, task = 174, streak = 1 })
    run.go(5); run.tracker:onCount(20, 15); run.tracker:onSlayerXp(100)
    run.go(8); run.tracker:onRemoved({ category = 28, level = 70 })
    run.go(40)
    check(run.kills() == 1 and run.total() == 70, "Unknown multiplier: one monster, one kill, not five")
end

-- Things that are not kills.
do
    local run = newRun({ count = 56, task = 174, streak = 1 })
    run.go(5); run.tracker:onCount(56, 3); run.tracker:onSlayerXp(100)       -- cheat or reset: a drop of 53
    run.go(9); run.tracker:onRemoved({ category = 28, level = 70 })
    run.go(30)
    check(#run.awards == 0, "A drop bigger than MAX_DROP is never kills, even with XP")
    local login = newRun({ count = 56, task = 174, streak = 1 })
    login.go(5); login.tracker:onSlayerXp(68000000); login.tracker:onCount(60, 56)
    login.go(9); login.tracker:onRemoved({ category = 28, level = 70 })
    login.go(30)
    check(#login.awards == 0, "The client's login XP total is not a kill's XP")
    local rise = newRun({ count = 3, task = 80, streak = 1 })
    rise.go(5); rise.tracker:onCount(3, 16); rise.tracker:onSlayerXp(50)
    rise.go(9); rise.tracker:onRemoved({ category = 28, level = 70 })
    rise.go(30)
    check(#rise.awards == 0, "A count that rises (a new task) is not a kill")
end

-- Slayer XP can arrive after the count fell, or never.
do
    local run = newRun({ count = 50, task = 174, streak = 1 })
    run.go(5); run.tracker:onCount(50, 49)
    run.go(6); run.tracker:onRemoved({ category = 28, level = 70 })          -- too early to count anyway
    run.go(7); run.tracker:onSlayerXp(87)                                    -- XP two ticks late: still counts
    run.go(10); run.tracker:onRemoved({ category = 28, level = 70 })
    check(run.kills() == 1 and run.total() == 70, "XP after the drop (within 2 ticks) confirms it")
    local late = newRun({ count = 50, task = 174, streak = 1 })
    late.go(5); late.tracker:onCount(50, 49)
    late.go(9); late.tracker:onSlayerXp(87)                                  -- 4 ticks late: not this drop
    late.go(10); late.tracker:onRemoved({ category = 28, level = 70 })
    late.go(30)
    check(#late.awards == 0, "XP more than 2 ticks after the drop does not confirm it")
end

-- A monster that does not count for the task is not paid for it, and a kill whose monster is not seen is paid at the level of
-- the task's example monster, then at the last level paid.
do
    local run = newRun({ count = 30, task = 174, streak = 1, fallbackLevel = function(task) return task == 174 and 98 or nil end })
    run.go(5); run.tracker:onCount(30, 29); run.tracker:onSlayerXp(100)
    run.go(8); run.tracker:onRemoved({ category = 11, level = 32 })          -- Skeletons: not for Demons
    run.go(30)
    check(run.kills() == 1 and run.awards[1].credits == 98 and run.awards[1].fallback == true, "No matching monster: paid once at the example monster's level (98)")
    run.go(35); run.tracker:onCount(29, 28); run.tracker:onSlayerXp(100)
    run.go(38); run.tracker:onRemoved({ category = 174, level = 5 })
    run.go(45); run.tracker:onCount(28, 27); run.tracker:onSlayerXp(100)
    run.go(70)
    check(run.kills() == 3 and run.awards[3].credits == 5 and run.awards[3].fallback == true, "Then at the last level paid (5)")
    local blank = newRun({ count = 30, task = 174, streak = 1 })
    blank.go(5); blank.tracker:onCount(30, 29); blank.tracker:onSlayerXp(100)
    blank.go(30)
    check(blank.kills() == 1 and blank.awards[1].credits == Slayer.DEFAULT_LEVEL, "With nothing known the default level is paid")
end

-- One monster is paid once, even with two drops waiting.
do
    local run = newRun({ count = 30, task = 174, streak = 1 })
    run.go(5); run.tracker:onCount(30, 29); run.tracker:onSlayerXp(100)
    run.go(6); run.tracker:onCount(29, 28)
    run.go(9); run.tracker:onRemoved({ category = 28, level = 70 })
    check(run.kills() == 1, "One monster leaving pays one kill, not one for each drop waiting")
    run.go(11); run.tracker:onRemoved({ category = 28, level = 70 })
    check(run.kills() == 2 and run.tracker:pending() == 0, "and the second monster pays the second drop")
end

-- The streak: no baseline yet (not readable at login) means the first number seen is only remembered.
do
    local run = newRun({ count = 1, task = 174 })
    run.go(5); run.tracker:onStreak(0, 5002)
    run.go(8)
    check(#run.awards == 0, "A first streak number is a baseline, not a completion")
    run.go(10); run.tracker:onStreak(5002, 5003)
    run.go(12)
    check(#run.awards == 1 and run.awards[1].kind == "bonus", "and the next rise by 1 is")
    run.go(20); run.tracker:onStreak(5003, 5003)
    run.tracker:onStreak(5003, 5008)
    run.go(25)
    check(#run.awards == 1, "a repeat, or a jump of more than 1, is not a completion")
end

-- XP credits: combat skills earn nothing (fighting pays through the Slayer credits), every other skill does.
do
    SkillType = {}
    for number, name in ipairs({ "ATTACK", "DEFENCE", "STRENGTH", "CONSTITUTION", "RANGED", "PRAYER", "MAGIC", "COOKING",
        "MINING", "SLAYER", "SUMMONING", "DUNGEONEERING", "NECROMANCY", "DIVINATION" }) do
        SkillType[name] = { name = name, number = number }   -- the game's members are not plain numbers; compare as given
    end
    local Earning = require("core/earning")
    local function gain(skill, from, to) return Earning.xpGainFromEvent({ skill = skill, oldXP = from, newXP = to }) end
    for _, name in ipairs(Earning.COMBAT_SKILLS) do
        check(gain(SkillType[name], 0, 5000) == 0, name .. " XP earns nothing")
    end
    check(gain(SkillType.COOKING, 100, 600) == 500 and gain(SkillType.MINING, 0, 40) == 40, "non-combat XP still counts")
    check(gain(SkillType.SLAYER, 0, 300) == 300, "Slayer XP is not a combat skill, it still counts")
    check(gain(SkillType.COOKING, 600, 600) == 0 and gain(SkillType.COOKING, nil, 5) == 0, "no gain and missing values still earn nothing")
    check(gain(nil, 0, 50) == 50, "an event with no skill is not mistaken for a combat skill")
    local seen = SkillType.ATTACK
    SkillType = nil
    check(Earning.isCombatSkill(seen) == false, "no SkillType in the client: nothing is excluded, nothing breaks")
end

if failures > 0 then
    io.stderr:write(failures .. " check(s) failed\n")
    os.exit(1)
end
print("OK: the Slayer credits follow the recorded games")
