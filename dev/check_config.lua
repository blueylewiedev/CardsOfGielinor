-- dev/check_config.lua
-- Checks core/config.lua, the numbers, lists and switches that can be tuned after release: that the defaults are what the plugin
-- shipped with before they were moved there, that Config.apply keeps what is inside the limits and reports what is not (one key
-- never costs the rest), and that the code that reads them (earning, packs, Slayer, bosses) follows a change.
--
-- Run from the plugin's folder:  lua dev/check_config.lua

package.path = "./?.lua;./dev/?.lua;" .. package.path

function log() end          -- the client's log function

local Config = require("core/config")
local Cards = require("core/cards")
local Packs = require("core/packs")
local Storage = require("core/storage")
local Earning = require("core/earning")
local Slayer = require("core/slayer")
local Bosses = require("core/bosses")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function same(a, b) return Config.sameTable(a, b) end
local function mentions(report, text)
    for _, line in ipairs(report.ignored) do
        if string.find(line, text, 1, true) then return true end
    end
    return false
end

-- 1. The defaults are what the plugin shipped with ------------------------------------------------------------------------
Config.reset()
check(Config.get("earning.enabled") == true and Config.get("earning.xpPerCredit") == 10, "100 credits for 1,000 XP, earning on")
check(same(Config.get("earning.combatSkills"), { "ATTACK", "STRENGTH", "DEFENCE", "HITPOINTS", "RANGED", "PRAYER", "MAGIC",
    "SUMMONING", "NECROMANCY", "SLAYER" }), "the combat skills that earn nothing")
check(Config.get("starterCredits") == 8000 and Config.get("packs.price") == 4000 and Config.get("packs.themedPriceFactor") == 1.25,
    "starter 8,000, pack 4,000, themed packs 1.25 times")
check(Config.get("odds.rarity.common") == 63 and Config.get("odds.rarity.uncommon") == 25 and Config.get("odds.rarity.rare") == 9.4
    and Config.get("odds.rarity.epic") == 2 and Config.get("odds.rarity.legendary") == 0.6, "the rarity weights 63 / 25 / 9.4 / 2 / 0.6")
check(Config.get("odds.finish.normal") == 9 and Config.get("odds.finish.holo") == 1, "holo 1 in 10")
check(Config.get("slayer.enabled") == true and Config.get("slayer.creditsPerLevel") == 1 and Config.get("slayer.bonusMultiplier") == 5
    and Config.get("slayer.levelCap") == nil, "Slayer pays the level, the bonus is five times it, no cap")
check(Config.get("slayer.vars.count") == 183 and Config.get("slayer.vars.task") == 185 and Config.get("slayer.vars.streak") == 10077,
    "the Slayer variables")
check(same(Config.get("bosses.tiers"), { { 9000, 8000 }, { 5000, 4000 }, { 1000, 1800 }, { 500, 800 }, { 0, 400 } }), "the boss tiers")
check(same(Config.get("bosses.activities"), { BSLAY_BOSS_KILLS2 = { [65536] = { name = "Barrows chest", credits = 1800 } } }),
    "the Barrows chest")
check(next(Config.get("bosses.overrides")) == nil and next(Config.get("bosses.ignore")) == nil, "no boss overrides or ignored bosses")
check(Config.get("bosses.enabled") == true and Config.get("shine.enabled") == true and Config.revision == nil, "the other switches are on")

-- 2. The schema agrees with the rest of the plugin ------------------------------------------------------------------------
check(same(Config.RARITIES, Cards.rarityOrder), "Config.RARITIES is Cards.rarityOrder")
for finish in pairs(Cards.finishes) do
    check(Config.SCHEMA["odds.finish." .. finish] ~= nil, "the finish " .. finish .. " has an odds key")
end
for path, entry in pairs(Config.SCHEMA) do
    if entry[1] ~= nil then
        local clean = entry[2](Config.default(path), entry.merge and {} or nil)
        check(clean ~= nil, "the default of " .. path .. " passes its own check")
    end
end
check(not pcall(Config.get, "no.such.key"), "an unknown key is a mistake in the code, so get raises")
local list = Config.get("earning.combatSkills")
Config.reset()
check(list ~= Config.get("earning.combatSkills"), "reset hands back fresh tables")

-- 3. Config.apply: what is accepted ---------------------------------------------------------------------------------------
do
    local report = Config.apply({ revision = 3, earning = { xpPerCredit = 20 }, starterCredits = 0, packs = { price = 2000,
        themedPriceFactor = 2 }, odds = { rarity = { legendary = 0 }, finish = { holo = 0 } },
        slayer = { creditsPerLevel = 0.5, bonusMultiplier = 0, levelCap = 150, vars = { count = 1, streak = 60000 } },
        shine = { enabled = false }, bosses = { enabled = false } })
    check(#report.ignored == 0, "a table inside every limit is accepted whole (" .. table.concat(report.ignored, "; ") .. ")")
    check(Config.get("earning.xpPerCredit") == 20 and Config.get("starterCredits") == 0 and Config.get("packs.price") == 2000
        and Config.get("packs.themedPriceFactor") == 2, "the numbers are set")
    check(Config.get("odds.rarity.legendary") == 0 and Config.get("odds.finish.holo") == 0, "a rarity or the holos can be set to 0")
    check(Config.get("slayer.creditsPerLevel") == 0.5 and Config.get("slayer.bonusMultiplier") == 0
        and Config.get("slayer.levelCap") == 150 and Config.get("slayer.vars.count") == 1 and Config.get("slayer.vars.streak") == 60000
        and Config.get("slayer.vars.task") == 185, "Slayer's numbers are set and the key left out keeps its default")
    check(Config.get("shine.enabled") == false and Config.get("bosses.enabled") == false and Config.get("earning.enabled") == true,
        "a switch can be turned off")
    check(Config.revision == 3, "the revision is kept")
    local changed = table.concat(report.changed, ",")
    check(string.find(changed, "packs.price", 1, true) and not string.find(changed, "slayer.vars.task", 1, true),
        "the report names the keys that differ from their default (" .. changed .. ")")
    Config.reset()
    check(Config.get("packs.price") == 4000 and Config.revision == nil, "reset puts the defaults back")
end

-- 4. Config.apply: what is not (each key alone) -------------------------------------------------------------------------
do
    local report = Config.apply({ earning = { xpPerCredit = 21, enabled = "no" }, packs = { price = 1999, themedPriceFactor = 2.5 },
        slayer = { creditsPerLevel = "1", vars = { count = 0 } }, starterCredits = 12.5, odds = { finish = { normal = 0 } },
        notAKey = 1, packs2 = { price = 1 }, revision = -1 })
    check(Config.get("earning.xpPerCredit") == 10 and Config.get("earning.enabled") == true and Config.get("packs.price") == 4000
        and Config.get("packs.themedPriceFactor") == 1.25 and Config.get("slayer.creditsPerLevel") == 1
        and Config.get("slayer.vars.count") == 183 and Config.get("starterCredits") == 8000 and Config.get("odds.finish.normal") == 9,
        "values outside their limits, or of the wrong type, keep the default")
    check(#report.ignored == 11 and #report.applied == 0 and #report.changed == 0, "all eleven bad keys reported, none applied (" .. #report.ignored .. ")")
    check(mentions(report, "notAKey") and mentions(report, "packs2") and mentions(report, "revision"), "unknown keys and a bad revision are named")
    -- one bad key does not stop the good ones
    report = Config.apply({ packs = { price = 99999, themedPriceFactor = 1.5 }, shine = { enabled = false } })
    check(Config.get("packs.price") == 4000 and Config.get("packs.themedPriceFactor") == 1.5 and Config.get("shine.enabled") == false,
        "a bad key leaves the good ones applied")
    Config.reset()
    -- common cannot be 0: a pack must always have something it can give
    report = Config.apply({ odds = { rarity = { common = 0 } } })
    check(Config.get("odds.rarity.common") == 63 and mentions(report, "common"), "common at 0 is put back")
    Config.reset()
    -- whatever it is given, it does not raise
    for _, odd in ipairs({ 5, "x", true, function() end, { 1, 2, 3 }, { earning = 7 }, { earning = { combatSkills = 7 } },
            { bosses = { tiers = { "a" }, activities = 3, overrides = "x", ignore = 4 } }, { odds = { rarity = 3 } } }) do
        local ok = pcall(Config.apply, odd)
        check(ok, "apply does not raise on " .. type(odd))
        Config.reset()
    end
    -- a long list of mistakes is reported in part, and counted
    local many = {}
    for i = 1, 40 do many["junk" .. i] = i end
    report = Config.apply(many)
    check(#report.ignored == 20 and report.more == 20, "at most 20 ignored keys are listed, the rest counted (" .. #report.ignored .. ", " .. report.more .. ")")
    Config.reset()
end

-- 5. Lists ---------------------------------------------------------------------------------------------------------------
do
    SkillType = { ATTACK = 1, SLAYER = 2, MINING = 3 }
    local report = Config.apply({ earning = { combatSkills = { "ATTACK", "CONSTITUTION", "mining", 7, "SLAYER" } } })
    check(same(Config.get("earning.combatSkills"), { "ATTACK", "SLAYER" }) and #report.ignored == 3,
        "names that are not SkillType members are dropped and reported (" .. #report.ignored .. ")")
    Config.reset()
    report = Config.apply({ earning = { combatSkills = { "CONSTITUTION" } } })
    check(#Config.get("earning.combatSkills") == 10 and mentions(report, "empty"), "a list with nothing left in it is not accepted")
    SkillType = nil
    Config.reset()

    Config.apply({ bosses = { tiers = { { 5000, 100 }, { 0, 10 } } } })
    check(same(Config.get("bosses.tiers"), { { 5000, 100 }, { 0, 10 } }), "tiers replace the shipped ones")
    Config.reset()
    for _, bad in ipairs({ { { 0, 10 }, { 5000, 100 } }, { { 5000, 100 }, { 5000, 10 } }, { { 5000, 100 }, { 0, 20001 } }, {},
            { { 5000 } }, { { 9, 9 }, { 8, 8 }, { 7, 7 }, { 6, 6 }, { 5, 5 }, { 4, 4 }, { 3, 3 }, { 2, 2 }, { 1, 1 } } }) do
        Config.apply({ bosses = { tiers = bad } })
        check(#Config.get("bosses.tiers") == 5 and Config.get("bosses.tiers")[1][1] == 9000, "a damaged tier list is refused whole")
        Config.reset()
    end

    -- activities are added to the shipped ones, an entry replaces the one with its variable and rise, 0 stops one paying
    local report2 = Config.apply({ bosses = { activities = {
        BSLAY_BOSS_KILLS7 = { ["1"] = { name = "Elite chest", credits = 2500 }, ["3"] = { name = "no", credits = 1 } },
        BSLAY_BOSS_KILLS2 = { ["65536"] = { name = "Barrows chest", credits = 0 } },
        NOT_A_COUNT = { ["1"] = { name = "x", credits = 1 } }, BSLAY_BOSS_KILLS9 = { ["2"] = { name = "x", credits = 20001 } } } } })
    local act = Config.get("bosses.activities")
    check(act.BSLAY_BOSS_KILLS7[1].credits == 2500 and act.BSLAY_BOSS_KILLS7[3] == nil and act.BSLAY_BOSS_KILLS2[65536].credits == 0,
        "activities are added, a rise that is not a power of two is dropped, credits 0 stops paying")
    check(act.NOT_A_COUNT == nil and act.BSLAY_BOSS_KILLS9 == nil and #report2.ignored == 3, "an unknown count and credits over the limit are dropped (" .. #report2.ignored .. ")")
    Config.reset()
    check(Config.get("bosses.activities").BSLAY_BOSS_KILLS7 == nil, "and reset takes them away")

    Config.apply({ bosses = { overrides = { ["24"] = 1800, ["0"] = 5, ["201"] = 5, ["x"] = 1, ["30"] = 20001 }, ignore = { 7, 7, 0, 300, "z" } } })
    check(same(Config.get("bosses.overrides"), { [24] = 1800 }) and same(Config.get("bosses.ignore"), { [7] = true }),
        "overrides and ignored bosses keep only boss ids from 1 to 200 and credits from 0 to 20,000")
    Config.reset()
end

-- 6. The code that reads them follows a change ----------------------------------------------------------------------------
do
    local state = Storage.newState()
    check(Storage.starterCredits() == 8000, "a new collection starts with the starter credits")
    Config.apply({ starterCredits = 500 })
    check(Storage.starterCredits() == 500, "...which tuning can change")
    Config.reset()

    local standard = Packs.priceFor("standard")
    check(standard == 4000, "a standard pack costs 4,000")
    local themed
    for id, packType in pairs(Cards.packTypes) do
        if packType.themed then themed = id break end
    end
    check(themed ~= nil and Packs.priceFor(themed) == 5000, "a themed pack costs 5,000 (" .. tostring(themed) .. ")")
    Config.apply({ packs = { price = 2000, themedPriceFactor = 1.5 } })
    check(Packs.priceFor("standard") == 2000 and Packs.priceFor(themed) == 3000, "tuning changes both prices")
    Config.reset()

    -- XP credits
    local pool = Storage.newState()
    check(Earning.addXP(pool, 105) == 10 and pool.xpPool == 5, "105 XP is 10 credits and 5 left over")
    Config.apply({ earning = { xpPerCredit = 20 } })
    check(Earning.addXP(pool, 105) == 5 and pool.xpPool == 10, "at 20 XP a credit the same 105 XP (and the 5 over) is 5 credits")
    Config.reset()
    SkillType = { MINING = 1, ATTACK = 2, SLAYER = 3 }
    local function gain(skill) return Earning.xpGainFromEvent({ skill = skill, oldXP = 0, newXP = 100 }) end
    check(gain(SkillType.MINING) == 100 and gain(SkillType.ATTACK) == 0, "mining earns, attack does not")
    Config.apply({ earning = { enabled = false } })
    check(gain(SkillType.MINING) == 0, "the switch stops all XP credits")
    Config.reset()
    Config.apply({ earning = { combatSkills = { "SLAYER" } } })
    check(gain(SkillType.ATTACK) == 100 and gain(SkillType.SLAYER) == 0, "the list of skills that earn nothing can change")
    Config.reset()
    SkillType = nil

    -- Slayer credits
    check(Slayer.creditsForLevel(70) == 70 and Slayer.bonusForLevel(70) == 350, "Slayer pays the level, the bonus five times")
    Config.apply({ slayer = { creditsPerLevel = 2, bonusMultiplier = 3, levelCap = 100 } })
    check(Slayer.creditsForLevel(70) == 140 and Slayer.creditsForLevel(500) == 200 and Slayer.bonusForLevel(70) == 420,
        "tuning changes the rate, the bonus and the cap")
    Config.reset()

    -- the rarity roll follows the weights
    math.randomseed(7)
    local pool2 = { common = { { id = "c", rarity = "common" } }, rare = { { id = "r", rarity = "rare" } } }
    local function rareShare(n)
        local rare = 0
        for _ = 1, n do
            if Packs.rollCard(pool2).card.id == "r" then rare = rare + 1 end
        end
        return rare / n
    end
    local base = rareShare(20000)
    check(math.abs(base - 9.4 / (63 + 9.4)) < 0.01, "a roll gives a rare at the shipped weights (" .. base .. ")")
    Config.apply({ odds = { rarity = { rare = 63 } } })
    local tuned = rareShare(20000)
    check(math.abs(tuned - 0.5) < 0.02, "and at the tuned ones (" .. tuned .. ")")
    Config.apply({ odds = { rarity = { common = 1, rare = 0 } } })
    check(rareShare(2000) == 0, "a rarity at 0 is never rolled when another is there")
    Config.reset()
    Config.apply({ odds = { rarity = { common = 1, uncommon = 0, rare = 0, epic = 0, legendary = 0 } } })
    local onlyRare = { rare = { { id = "r", rarity = "rare" } } }
    check(Packs.rollCard(onlyRare).card.id == "r", "a pack whose rarities are all at 0 still rolls (they count alike)")
    Config.reset()

    -- the finish roll
    local function holoShare(n)
        local holo = 0
        for _ = 1, n do
            if Packs.rollCard(pool2).finish == "holo" then holo = holo + 1 end
        end
        return holo / n
    end
    check(math.abs(holoShare(20000) - 0.1) < 0.01, "1 card in 10 is a holo")
    Config.apply({ odds = { finish = { holo = 0 } } })
    check(holoShare(2000) == 0, "holo 0 pulls no holos")
    Config.reset()
end

-- 7. Boss credits: tiers, a boss's own credits, an ignored boss, an activity ----------------------------------------------
do
    local paid = {}
    local function run()
        paid = {}
        local tracker = Bosses.new({ award = function(kind, credits, info) paid[#paid + 1] = { kind, credits, info.id } end })
        for _ = 1, Bosses.QUIET_TICKS do tracker:advance() end
        return tracker
    end
    local function kill(tracker, id, level)
        tracker:advance()
        tracker:seen(id, level, "Boss " .. id)
        tracker:advance()
        return tracker:onKillVar("BSLAY_BOSS_KILLS1", 0, 1)
    end
    local t = run()
    check(kill(t, 5, 1200) and paid[1][2] == 1800, "a level 1,200 boss pays the 1,000 tier")
    Config.apply({ bosses = { tiers = { { 0, 77 } }, overrides = { ["5"] = 3000, ["6"] = 0 }, ignore = { 7 } } })
    t = run()
    check(kill(t, 4, 5000) and paid[1][2] == 77, "tuned tiers pay another boss")
    t = run()
    check(kill(t, 5, 1200) and paid[1][2] == 3000, "a boss's own credits beat its tier")
    t = run()
    check(not kill(t, 6, 1200) and #paid == 0, "a boss set to 0 credits pays nothing")
    t = run()
    check(not kill(t, 7, 1200) and #paid == 0, "an ignored boss pays nothing")
    t = run()
    kill(t, 7, 1200)
    t:advance()
    t:seen(7, 1200, "Boss 7")
    check(not t:onKillVar("BSLAY_BOSS_KILLS1", 1, 2) and #paid == 0, "and is not paid when it is seen again soon after")
    Config.reset()
    t = run()
    check(t:onKillVar("BSLAY_BOSS_KILLS2", 0, 65536) and paid[1][1] == "activity" and paid[1][2] == 1800, "the Barrows chest pays 1,800")
    Config.apply({ bosses = { activities = { BSLAY_BOSS_KILLS2 = { ["65536"] = { name = "Barrows chest", credits = 2100 } } } } })
    t = run()
    check(t:onKillVar("BSLAY_BOSS_KILLS2", 0, 65536) and paid[1][2] == 2100, "an activity's credits can change")
    Config.reset()
end

if failures > 0 then os.exit(1) end
print("OK: the tuning keys, their limits and what reads them")
