-- core/rate.lua
-- Credits per hour: the credits earned over the last WINDOW_MINUTES of play, as an hourly rate. Time is counted in
-- ticks (about 0.6 s, see main.lua) and only while a collection is loaded. Credits go in a bucket for the minute they
-- were earned in, and the rate is the credits in the window over the time really passed, so it follows how the player
-- is doing now. It starts afresh at each login; for the first MIN_MINUTES there is nothing to show (nil) and the
-- screens say "Calculating..." (Rate.text). No UI and no client calls (dev/check_rate.lua).

local Format = require("core/format")

local Rate = {}

Rate.SECONDS_PER_TICK = 0.6
Rate.TICKS_PER_MINUTE = 100          -- 60 / 0.6
Rate.WINDOW_MINUTES = 60
Rate.MIN_MINUTES = 1

local ticks = 0                      -- ticks of play since the last reset
local buckets = {}                   -- minute number (ticks // TICKS_PER_MINUTE) -> credits earned in it

local function minuteNow()
    return ticks // Rate.TICKS_PER_MINUTE
end

-- Forgets everything: a new character has loaded, or the character has gone.
function Rate.reset()
    ticks = 0
    buckets = {}
end

-- The first minute the window still covers: the minute now and the WINDOW_MINUTES - 1 before it, the last of which is
-- only part gone (see Rate.perHour).
local function firstMinute()
    return math.max(0, minuteNow() - (Rate.WINDOW_MINUTES - 1))
end

-- One tick of play has passed. Buckets older than the window are dropped.
function Rate.tick()
    ticks = ticks + 1
    if ticks % Rate.TICKS_PER_MINUTE == 0 then
        local first = firstMinute()
        for minute in pairs(buckets) do
            if minute < first then
                buckets[minute] = nil
            end
        end
    end
end

-- Credits have been earned (by playing: Storage.earnCredits).
function Rate.add(amount)
    if type(amount) ~= "number" or amount <= 0 then
        return
    end
    local minute = minuteNow()
    buckets[minute] = (buckets[minute] or 0) + amount
end

-- Credits per hour over the last hour of play (or the time so far, if less), or nil until MIN_MINUTES minutes have passed.
function Rate.perHour()
    -- The window is the whole minutes from `first` up to the one now, and the part of the one now that has passed.
    local first = firstMinute()
    local minutes = (minuteNow() - first) + (ticks % Rate.TICKS_PER_MINUTE) / Rate.TICKS_PER_MINUTE
    if minutes < Rate.MIN_MINUTES then
        return nil
    end
    local total = 0
    for minute, credits in pairs(buckets) do
        if minute >= first then
            total = total + credits
        end
    end
    return total * 60 / minutes
end

-- True while there is not enough play to say a rate (the first MIN_MINUTES minute after a login).
function Rate.calculating()
    return Rate.perHour() == nil
end

-- What the screens show while calculating: "Calculating.", "Calculating..", "Calculating..." going round, a dot more each tick.
-- The text is always as long as the longest (spaces after the dots), so centred text does not jump about.
function Rate.waitingText()
    local dots = ticks % 3 + 1
    return "Calculating" .. string.rep(".", dots) .. string.rep(" ", 3 - dots)
end

-- The average credits per hour over every session: the credits earned (stats.creditsEarned) over the play time kept in the
-- stats (stats.playTicks), or nil until AVERAGE_MIN_MINUTES minutes of play have been recorded.
Rate.AVERAGE_MIN_MINUTES = 10
function Rate.averagePerHour(stats)
    local minutes = (stats.playTicks or 0) / Rate.TICKS_PER_MINUTE
    if minutes < Rate.AVERAGE_MIN_MINUTES then
        return nil
    end
    return (stats.creditsEarned or 0) * 60 / minutes
end

-- The rate as text for the screen: "12 345", or the waiting text while there is not enough play to say.
function Rate.text()
    local rate = Rate.perHour()
    if rate == nil then
        return Rate.waitingText()
    end
    return Format.credits(math.floor(rate + 0.5))
end

return Rate
