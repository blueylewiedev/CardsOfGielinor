-- core/rate.lua
-- How many credits per hour the player is earning: the credits earned over the last hour of play, as an hourly rate.
--
-- Time is counted in the plugin's ticks (about every 0.6 seconds, see main.lua), and only while a character's collection
-- is loaded, so time spent logged out does not count against the rate. Credits are added to a bucket for the minute they
-- were earned in, and the rate is the credits in the last WINDOW_MINUTES minutes over the time that has really passed (up
-- to the whole window), so it follows how the player is doing now and not over their whole session. It starts afresh at
-- each login. For the first MIN_MINUTES minutes there is nothing to show (nil): a rate from a few minutes of play swings
-- too wildly to mean anything.
--
-- No UI and no client calls, so dev/check_rate.lua tests it on its own.

local Format = require("core/format")

local Rate = {}

Rate.SECONDS_PER_TICK = 0.6
Rate.TICKS_PER_MINUTE = 100          -- 60 / 0.6
Rate.WINDOW_MINUTES = 60
Rate.MIN_MINUTES = 3

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

-- Credits have been earned (by playing, not added by the dev tools).
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

-- The rate as text for the screen: "12 345", or "-" while there is not enough play to say.
function Rate.text()
    local rate = Rate.perHour()
    if rate == nil then
        return "-"
    end
    return Format.credits(math.floor(rate + 0.5))
end

return Rate
