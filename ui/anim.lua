-- ui/anim.lua
-- Short animations driven by the Draw event, for the pack window and the pack carousel.
--
-- Each owner (any table) runs at most one animation at a time: update(p) is called every frame
-- with p going from 0 to 1, then finish() once. Starting another, or Anim.skip, jumps the
-- running one to its end first. A step that fails is logged once and the animation ended, rather
-- than failing again every frame. Also a few easing curves, and the frame time from a Draw event.

local Anim = {}

local running = {}   -- owner -> { t, seconds, update, finish }

-- Calls fn(...), logging a failure. Returns true if it worked.
local function call(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        log("animation failed:", tostring(err))
    end
    return ok
end

-- Jumps the owner's animation (if any) to its end: its last step, then finish().
function Anim.skip(owner)
    local anim = running[owner]
    if anim ~= nil then
        running[owner] = nil
        call(anim.update, 1)
        call(anim.finish)
    end
end

-- Starts an animation of `seconds` for `owner`. `finish` is optional.
function Anim.start(owner, seconds, update, finish)
    Anim.skip(owner)
    running[owner] = { t = 0, seconds = seconds, update = update, finish = finish or function() end }
end

-- Drops the owner's animation without finishing it (when what it moves is being destroyed).
function Anim.cancel(owner)
    running[owner] = nil
end

function Anim.running(owner)
    return running[owner] ~= nil
end

-- The seconds since the last frame, from a Draw event (a sixtieth if the client doesn't say).
function Anim.frameSeconds(e)
    local ok, dt = pcall(function() return e.timeDeltaSecs end)
    return (ok and type(dt) == "number") and dt or 0.016
end

-- Easing curves, each taking and giving 0 to 1.
function Anim.easeOut(x, power)      -- fast, then slowing (power 2 by default)
    return 1 - (1 - x) ^ (power or 2)
end

function Anim.smooth(x)              -- slow, fast, slow
    return x * x * (3 - 2 * x)
end

Event.Draw.Subscribe("cardcollector_anim", function(e)
    if next(running) == nil then
        return
    end
    local dt = Anim.frameSeconds(e)
    -- Listed first, as a finish() may start another animation for the same owner.
    local owners = {}
    for owner in pairs(running) do
        owners[#owners + 1] = owner
    end
    for _, owner in ipairs(owners) do
        local anim = running[owner]
        anim.t = anim.t + dt
        local p = math.min(1, anim.t / anim.seconds)
        if not call(anim.update, p) then
            p = 1
        end
        if p >= 1 and running[owner] == anim then
            running[owner] = nil
            call(anim.finish)
        end
    end
end)

return Anim
