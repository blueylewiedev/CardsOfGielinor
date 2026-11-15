-- core/earning.lua
-- Turns game activity into credits. Currently: XP gained in any skill except the combat skills.

local Storage = require("core/storage")

local Earning = {}

-- How much XP adds up to one credit.
Earning.XP_PER_CREDIT = 1000

-- The combat skills (the game's own "combat" group). Their XP earns nothing: fighting pays through the Slayer
-- credits (core/slayer.lua) and, later, boss kills. Names are SkillType members.
Earning.COMBAT_SKILLS = { "ATTACK", "STRENGTH", "DEFENCE", "CONSTITUTION", "RANGED", "PRAYER", "MAGIC",
    "SUMMONING", "NECROMANCY" }

-- True if `skill` (the skill of a SkillTransmit event) is one of the combat skills.
function Earning.isCombatSkill(skill)
    if skill == nil or SkillType == nil then
        return false
    end
    for _, name in ipairs(Earning.COMBAT_SKILLS) do
        local ok, member = pcall(function() return SkillType[name] end)
        if ok and member ~= nil and member == skill then
            return true
        end
    end
    return false
end

-- Works out how much XP a SkillTransmit event is worth, or 0 if it should be ignored.
-- Every real gain counts, including big ones (quest rewards, lamps) and the first XP
-- in a brand new skill. Ignored: a missing value, no gain at all, and combat skills.
function Earning.xpGainFromEvent(e)
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

-- Adds XP to the pool and converts every full XP_PER_CREDIT into a credit.
-- Returns the number of credits earned.
function Earning.addXP(state, gain)
    if gain <= 0 then
        return 0
    end
    state.xpPool = state.xpPool + gain
    local credits = math.floor(state.xpPool / Earning.XP_PER_CREDIT)
    if credits > 0 then
        state.xpPool = state.xpPool - credits * Earning.XP_PER_CREDIT
        Storage.earnCredits(state, credits)
    else
        state.dirty = true
    end
    return credits
end

return Earning
