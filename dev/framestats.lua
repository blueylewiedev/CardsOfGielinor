-- dev/framestats.lua
-- The numbers for a stretch of frames, with no client in it so dev/check_framestats.lua can test it. The client has no
-- os.clock, so time is the sum of the frame times the Draw event reports (e.timeDeltaSecs): a stretch lasts until the
-- frames in it add up to `seconds`.
--
--   local stats = FrameStats.new("start-up", 10)
--   FrameStats.add(stats, dt)        -- every frame; true when the stretch is over
--   FrameStats.summary(stats)        -- one line for the log
--
-- A frame that does a lot of work (a window being built, the deck loading) shows up as one long frame, because
-- nothing is drawn while it runs and the next Draw event reports the whole wait.

local FrameStats = {}

-- A frame slower than 1/30 s is a visible stutter; slower than 0.1 s is a freeze.
FrameStats.STUTTER, FrameStats.FREEZE = 1 / 30, 0.1

function FrameStats.new(label, seconds)
    return { label = label, limit = seconds, elapsed = 0, frames = 0, first = nil, longest = 0, longestAfterFirst = 0,
        stutters = 0, freezes = 0, done = false }
end

-- Adds one frame of `dt` seconds. Returns true once the stretch is over (the frame that ends it is counted).
function FrameStats.add(stats, dt)
    if stats.done or type(dt) ~= "number" or dt ~= dt or dt < 0 then
        return stats.done
    end
    stats.frames = stats.frames + 1
    stats.elapsed = stats.elapsed + dt
    if stats.first == nil then
        stats.first = dt
    else
        stats.longestAfterFirst = math.max(stats.longestAfterFirst, dt)
    end
    stats.longest = math.max(stats.longest, dt)
    if dt > FrameStats.STUTTER then
        stats.stutters = stats.stutters + 1
    end
    if dt > FrameStats.FREEZE then
        stats.freezes = stats.freezes + 1
    end
    if stats.elapsed >= stats.limit then
        stats.done = true
    end
    return stats.done
end

local function ms(seconds)
    return string.format("%.0f ms", seconds * 1000)
end

-- One line: how long it ran for, the first frame, the longest frame and the longest after the first (the first is
-- where one-off work lands), the average frame, and how many frames stuttered (over 33 ms) or froze (over 100 ms).
function FrameStats.summary(stats)
    if stats.frames == 0 then
        return "PROBE " .. stats.label .. ": no frames were drawn"
    end
    return string.format("PROBE %s (%.1f s, %d frames): first frame %s, longest %s, longest after the first %s, "
        .. "average %s, over 33 ms: %d, over 100 ms: %d",
        stats.label, stats.elapsed, stats.frames, ms(stats.first), ms(stats.longest), ms(stats.longestAfterFirst),
        ms(stats.elapsed / stats.frames), stats.stutters, stats.freezes)
end

return FrameStats
