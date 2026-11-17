-- dev/check_rate.lua
-- Tests core/rate.lua, the credits per hour: nothing until a few minutes of play, a steady rate read back correctly,
-- the window sliding so only the last hour counts, a reset, and Storage.earnCredits feeding it (but not addCredits).
--
-- Run from the plugin's folder:  lua dev/check_rate.lua

package.path = "./?.lua;" .. package.path
function log() end

local Rate = require("core/rate")
local Storage = require("core/storage")

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end
local function near(a, b) return a ~= nil and math.abs(a - b) < 0.5 end

local PER_MIN = Rate.TICKS_PER_MINUTE
local function minutes(n, creditsEachMinute)
    for _ = 1, n do
        for t = 1, PER_MIN do
            if t == 1 and creditsEachMinute then
                Rate.add(creditsEachMinute)
            end
            Rate.tick()
        end
    end
end

-- nothing to say before MIN_MINUTES (one minute): "Calculating..." with the dots going round
Rate.reset()
check(Rate.perHour() == nil and Rate.calculating(), "no rate at the start")
local seen = {}
for _ = 1, 30 do
    Rate.tick()
    seen[Rate.text()] = true
    check(Rate.text():sub(1, 11) == "Calculating", "the waiting text starts with Calculating")
    check(#Rate.text() == #"Calculating...", "the waiting text is always the same length, got '" .. Rate.text() .. "'")
end
check(seen["Calculating.  "] and seen["Calculating.. "] and seen["Calculating..."], "the dots go . .. ...")
check(Rate.perHour() == nil, "still nothing after 30 ticks")
for _ = 1, 69 do Rate.tick() end
check(Rate.perHour() == nil, "still nothing at 99 ticks, just under a minute")
Rate.add(100)
Rate.tick()
check(near(Rate.perHour(), 6000), "100 credits in the first minute is 6000 an hour, got " .. tostring(Rate.perHour()))
check(not Rate.calculating() and Rate.text() == "6 000", "the text groups the digits, got " .. Rate.text())

-- a steady rate
Rate.reset()
minutes(30, 500)
check(near(Rate.perHour(), 30000), "500 a minute for 30 minutes is 30000 an hour, got " .. tostring(Rate.perHour()))

-- the window slides: two hours, the first at 1000 a minute, the second at 200 a minute: only the second counts
Rate.reset()
minutes(60, 1000)
check(near(Rate.perHour(), 60000), "an hour at 1000 a minute is 60000, got " .. tostring(Rate.perHour()))
minutes(60, 200)
check(near(Rate.perHour(), 12000), "after a slower hour only that hour counts: 12000, got " .. tostring(Rate.perHour()))

-- half way through the slide the rate is a mix
Rate.reset()
minutes(60, 1000)
minutes(30, 200)
local mix = (30 * 1000 + 30 * 200) -- credits in the last 60 minutes
local got = Rate.perHour()
check(got ~= nil and math.abs(got - mix) / mix < 0.03, "half a window slid: about " .. mix .. " an hour, got " .. tostring(got))

-- no credits at all is a rate of 0, not nothing
Rate.reset()
minutes(10)
check(Rate.perHour() == 0 and Rate.text() == "0", "ten idle minutes is 0 an hour")

-- bad amounts are ignored
Rate.reset()
Rate.add(-5); Rate.add(0); Rate.add("x"); Rate.add(nil)
minutes(5)
check(Rate.perHour() == 0, "negative, zero and non-number amounts do not count")

-- reset forgets
Rate.reset()
minutes(10, 100)
Rate.reset()
check(Rate.perHour() == nil, "a reset starts again")

-- Storage.earnCredits counts, addCredits does not
Rate.reset()
local state = Storage.newState()
if state ~= nil then
    Storage.earnCredits(state, 300)
    Storage.addCredits(state, 99999)
    minutes(1)
    check(near(Rate.perHour(), 18000), "earnCredits feeds the rate and addCredits does not, got " .. tostring(Rate.perHour()))
else
    print("(skipped the Storage check: no way to make a state here)")
end

if failures == 0 then
    print("OK: credits per hour follow the last hour of play")
else
    print(failures .. " check(s) failed")
    os.exit(1)
end
