-- dev/check_framestats.lua
-- Checks the numbers the performance probe (dev/perfprobe.lua) writes, from made-up frame times (dev/framestats.lua).
--
-- Run from the plugin's folder:  lua dev/check_framestats.lua

package.path = "./?.lua;" .. package.path

local FrameStats = require("dev/framestats")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

-- A long first frame (the deck loading), then steady frames, then a stutter and a freeze.
do
    local stats = FrameStats.new("start-up", 2)
    check(not FrameStats.add(stats, 1.0), "one second of a two second stretch is not the end")
    for _ = 1, 10 do
        FrameStats.add(stats, 0.016)
    end
    FrameStats.add(stats, 0.05)       -- a stutter
    FrameStats.add(stats, 0.2)        -- a freeze
    check(not stats.done, "1.41 s of a 2 s stretch is not over")
    check(stats.frames == 13 and math.abs(stats.elapsed - 1.41) < 1e-9, "13 frames adding up to 1.41 s")
    check(stats.first == 1.0 and stats.longest == 1.0, "the first frame is the longest")
    check(stats.longestAfterFirst == 0.2, "the longest after the first is reported apart")
    check(stats.stutters == 3 and stats.freezes == 2, "over 33 ms: the first, the stutter and the freeze; over 100 ms: the first and the freeze ("
        .. stats.stutters .. ", " .. stats.freezes .. ")")
    check(FrameStats.add(stats, 0.6), "the frame that takes it to 2 s ends it")
    check(stats.done and stats.frames == 14, "and is counted")
    check(FrameStats.add(stats, 5) == true and stats.frames == 14, "a frame after the end is ignored")

    local line = FrameStats.summary(stats)
    check(string.find(line, "PROBE start-up (2.0 s, 14 frames)", 1, true) == 1, "the line starts with what and how long (" .. line .. ")")
    check(string.find(line, "first frame 1000 ms", 1, true) and string.find(line, "longest 1000 ms", 1, true)
        and string.find(line, "longest after the first 600 ms", 1, true), "it gives the first and longest frames (" .. line .. ")")
    check(string.find(line, "over 33 ms: 4, over 100 ms: 3", 1, true), "and how many stuttered and froze (" .. line .. ")")
end

-- Bad frame times are ignored, not counted.
do
    local stats = FrameStats.new("x", 1)
    FrameStats.add(stats, nil)
    FrameStats.add(stats, "fast")
    FrameStats.add(stats, -1)
    FrameStats.add(stats, 0 / 0)
    check(stats.frames == 0 and stats.elapsed == 0, "nil, text, negative and NaN frame times are ignored")
    check(string.find(FrameStats.summary(stats), "no frames were drawn", 1, true) ~= nil, "no frames is said, not divided by")
end

-- A stretch ends on the frame that reaches it, however it is made up.
do
    local stats = FrameStats.new("steady", 1)
    local frames = 0
    while not FrameStats.add(stats, 0.02) do
        frames = frames + 1
    end
    check(frames + 1 == 50 and stats.stutters == 0 and stats.freezes == 0, "50 frames of 20 ms make a second, with no stutter (" .. (frames + 1) .. ")")
end

if failures > 0 then
    io.stderr:write(failures .. " frame statistics check(s) failed\n")
    os.exit(1)
end
print("OK: the frame statistics add up")
