-- core/earning.lua
-- Turns game activity into credits. Currently: XP gained in any skill except the combat skills.

local Storage = require("core/storage")
local Config = require("core/config")

local Earning = {}

-- How much XP adds up to one credit (Config "earning.xpPerCredit", 10), and the skills whose XP earns nothing: the combat
-- skills (the game's own "combat" group) and Slayer ("earning.combatSkills"). Fighting pays through the Slayer credits
-- (core/slayer.lua: a kill and a finished task) and boss kills; Slayer's own XP would pay for the same kills twice. Names are
-- SkillType members (Constitution is HITPOINTS, skill 3: it was listed as CONSTITUTION, which is not a member, so its XP
-- earned credits until 2026-11-17). "earning.enabled" is the switch for all XP credits.

-- True if `skill` (the skill of a SkillTransmit event) earns nothing: one of the combat skills, or Slayer.
function Earning.isCombatSkill(skill)
    if skill == nil or SkillType == nil then
        return false
    end
    for _, name in ipairs(Config.get("earning.combatSkills")) do
        local ok, member = pcall(function() return SkillType[name] end)
        if ok and member ~= nil and member == skill then
            return true
        end
    end
    return false
end

-- Works out how much XP a SkillTransmit event is worth, or 0 if it should be ignored.
-- Every real gain counts, including big ones (quest rewards, lamps) and the first XP
-- in a brand new skill. Ignored: a missing value, no gain at all, and the combat skills and Slayer.
function Earning.xpGainFromEvent(e)
    if not Config.get("earning.enabled") then
        return 0
    end
    local oldXP, newXP = e.oldXP, e.newXP
    if type(oldXP) ~= "number" or type(newXP) ~= "number" then
        return 0
    end
    if Earning.isCombatSkill(e.skill) then
        return 0
    end
    local gain = newXP - oldXP
    if gain <= 0 then
        return 0
    end
    return gain
end

-- Adds XP to the pool and converts every full "earning.xpPerCredit" of it into a credit.
-- Returns the number of credits earned.
function Earning.addXP(state, gain)
    if gain <= 0 then
        return 0
    end
    state.xpPool = state.xpPool + gain
    local perCredit = Config.get("earning.xpPerCredit")
    local credits = math.floor(state.xpPool / perCredit)
    if credits > 0 then
        state.xpPool = state.xpPool - credits * perCredit
        Storage.earnCredits(state, credits)
    else
        state.dirty = true
    end
    return credits
end

return Earning
