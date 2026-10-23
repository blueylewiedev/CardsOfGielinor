-- core/earning.lua
-- Turns game activity into credits. Currently: XP gained in any skill.

local Storage = require("core/storage")

local Earning = {}

-- How much XP adds up to one credit.
Earning.XP_PER_CREDIT = 1000

-- Works out how much XP a SkillTransmit event is worth, or 0 if it should be ignored.
-- Every real gain counts, including big ones (quest rewards, lamps) and the first XP
-- in a brand new skill. Only a missing value or no gain at all is ignored.
function Earning.xpGainFromEvent(e)
    local oldXP, newXP = e.oldXP, e.newXP
    if type(oldXP) ~= "number" or type(newXP) ~= "number" then
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
