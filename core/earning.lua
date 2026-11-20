-- core/earning.lua
-- Turns game activity into credits. Currently: XP gained in any skill except the combat skills.

local Storage = require("core/storage")
local Config = require("core/config")

local Earning = {}

-- How much XP adds up to one credit (Config "earning.xpPerCredit"), and the skills whose XP earns nothing
-- ("earning.combatSkills": the combat skills and Slayer): fighting pays through Slayer and boss credits, and Slayer's
-- own XP would pay for the same kills twice. Names are SkillType members (Constitution is HITPOINTS).
-- "earning.enabled" switches all XP credits.

-- The skills that earn nothing, as a set of SkillType members, made again only when the list in Config changes (tuning).
local listed, members = nil, {}
local function combatSkills()
    local list = Config.get("earning.combatSkills")
    if list ~= listed then
        listed, members = list, {}
        for _, name in ipairs(list) do
            local ok, member = pcall(function() return SkillType[name] end)
            if ok and member ~= nil then
                members[member] = true
            end
        end
    end
    return members
end

-- True if `skill` (the skill of a SkillTransmit event) earns nothing: one of the combat skills, or Slayer.
function Earning.isCombatSkill(skill)
    if skill == nil or SkillType == nil then
        return false
    end
    return combatSkills()[skill] == true
end

-- Works out how much XP a SkillTransmit event is worth, or 0 if it should be ignored. Every real gain counts,
-- including big ones (quest rewards, lamps) and the first XP in a brand new skill. Ignored: a missing value, no gain
-- at all, and the combat skills and Slayer.
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
