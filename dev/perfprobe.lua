-- dev/perfprobe.lua
-- Times what the plugin does in the client, which has no os.clock and no working os.time. Two clocks are left: the
-- frame times the Draw event reports (summed, see dev/framestats.lua) and the Logic event's tick, which is counted
-- since the client started, 50 a second. One "PROBE" line is written to the log for each thing it measures.
--
--   PROBE start-up        the first 10 seconds after the probe loads. main.lua loads dev/dev, which loads the probe, before anything else.
--   PROBE <mark>          "start", "main.lua finished", "session loaded", "main window usable": the
--                         seconds of frames since the probe loaded, and the logic ticks since the first one. "main window
--                         usable" is when the main window first shows the home screen instead of the loading screen.
--   PROBE reload gap      the logic ticks between the old plugin stopping (its last tick is kept in PersistentDB) and
--                         the first tick of the new one: how long the reload took, as the client counts it. Nothing
--                         is drawn while the plugin's files load, so the frame clock cannot see it.
--   PROBE slow frame      any frame over 100 ms, with when it was and the last mark before it, to say what caused it.
--   PROBE collection viewer opened   the 3 seconds after the Collection window is opened (it is built in one go).
--   PROBE manual          the "Perf probe" button in the Dev tools window: the next 10 seconds, for scrolling the
--                         viewer, opening a pack, or anything else.
--
-- Dev copy only: this folder is not in the release, so none of it can run for players. The probe changes nothing
-- the plugin does; it reads the clocks, writes one value to PersistentDB when the plugin stops, and writes to the log.

local FrameStats = require("dev/framestats")
local Quiet = require("dev/quiet")                  -- the automatic PROBE lines are dropped while the console is quiet

-- The memory probe (dev/memprobe.lua) has to wrap the client's component classes before the plugin makes any, and this file is
-- the first to load, so it starts it here.
local memLoaded, memError = pcall(require, "dev/memprobe")
if not memLoaded then
    log("MEM: the memory probe did not load: " .. tostring(memError))
end

local Probe = {}

local FRAME_SUBSCRIBER, LOGIC_SUBSCRIBER = "cardcollector_dev_perf", "cardcollector_dev_perf_logic"
local TICK_KEY = "dev_perf_last_tick-dev"     -- ends with the dev profile suffix, like the dev copy's other keys
local TICKS_PER_SECOND = 50

local clock = 0                 -- seconds of frames since this file loaded
local running = {}              -- the stretches being measured
local warnedNoTime = false
local wrapped = false
local marks = {}                -- { name, at } for each Probe.mark, so a slow frame can say what came before it
local slowLogged, MAX_SLOW_LINES = 0, 30
local firstTick, lastTick       -- the Logic event's tick at the first and the latest event

-- Writes a line saying the plugin has reached `name`: the seconds of frames so far, and the logic ticks since the first
-- one once there has been one (20 ms each).
function Probe.mark(name)
    marks[#marks + 1] = { name = name, at = clock }
    local ticks = ""
    if firstTick ~= nil and lastTick ~= nil then
        ticks = string.format(", %d logic ticks in", lastTick - firstTick)
    end
    Quiet.line(string.format("PROBE %s: %.1f s of frames%s", name, clock, ticks))
end

-- Starts measuring a stretch of `seconds` seconds, called `label`.
function Probe.measure(label, seconds)
    running[#running + 1] = FrameStats.new(label, seconds)
end

local function onDraw(e)
    local ok, dt = pcall(function() return e.timeDeltaSecs end)
    if not ok or type(dt) ~= "number" then
        if not warnedNoTime then
            warnedNoTime = true
            Quiet.line("PROBE: the Draw event has no timeDeltaSecs, so frames cannot be timed")
        end
        return
    end
    clock = clock + dt
    if dt > FrameStats.FREEZE and slowLogged < MAX_SLOW_LINES then
        slowLogged = slowLogged + 1
        local last = marks[#marks]
        Quiet.line(string.format("PROBE slow frame: %.0f ms, ending %.1f s of frames in, after '%s' (%.1f s)", dt * 1000, clock,
            last and last.name or "no mark yet", last and last.at or 0))
    end
    for index = #running, 1, -1 do
        if FrameStats.add(running[index], dt) then
            Quiet.line(FrameStats.summary(running[index]), running[index].label == "manual")
            table.remove(running, index)
        end
    end
end

-- The first Logic event of this plugin: compares its tick with the one the last plugin stopped at.
local function reportReloadGap(tick)
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(TICK_KEY) end)
    if not ok or type(saved) ~= "table" or type(saved.tick) ~= "number" then
        Quiet.line("PROBE reload gap: no earlier run stopped cleanly, so there is nothing to compare")
        return
    end
    pcall(function() PersistentDB:Delete(TICK_KEY) end)       -- so an old value is never compared with a later start
    local gap = tick - saved.tick
    if gap < 0 then
        Quiet.line("PROBE reload gap: the tick count went back, so the client was restarted in between")
    else
        Quiet.line(string.format("PROBE reload gap: %d logic ticks = %.1f s between the old plugin stopping and the new one's first tick",
            gap, gap / TICKS_PER_SECOND))
    end
end

local function onLogic(e)
    local ok, tick = pcall(function() return e.logicTick end)
    if not ok or type(tick) ~= "number" then
        return
    end
    lastTick = tick
    if firstTick == nil then
        firstTick = tick
        reportReloadGap(tick)
    end
end

-- Subscribes as soon as the file loads. Like the other dev modules it never unsubscribes: "Preview as released" turns
-- the tools off and on again, and the plugin's reload clears its subscriptions.
Event.Draw.Subscribe(FRAME_SUBSCRIBER, onDraw)
Event.Logic.Subscribe(LOGIC_SUBSCRIBER, onLogic)
Probe.measure("start-up", 10)
Probe.mark("start")

-- Called when the character's collection has loaded (dev/dev.lua, when a collection has loaded).
function Probe.sessionLoaded()
    Probe.mark("session loaded")
end

-- Called when the plugin stops (main.lua's PluginShutdown): keeps the latest logic tick for the next start.
function Probe.shutdown()
    if lastTick ~= nil then
        pcall(function() PersistentDB:SetStructuredData(TICK_KEY, { tick = lastTick }) end)
    end
end

-- Called once the plugin has finished loading (Dev.start): wraps the collection viewer's open, so the frames after it are
-- measured, and the main window's refresh, to mark when it first shows a screen a player can use.
function Probe.start()
    if wrapped then
        return
    end
    wrapped = true
    local Viewer = require("ui/viewer")
    local openViewer = Viewer.open
    Viewer.open = function(newApi)
        if not Viewer.isOpen() then
            Probe.measure("collection viewer opened", 3)
        end
        return openViewer(newApi)
    end

    local PackWindow = require("ui/packwindow")
    local refresh = PackWindow.refresh
    local markedUsable = false
    PackWindow.refresh = function(...)
        local result = refresh(...)
        if not markedUsable then
            local screen = PackWindow.currentScreen()
            if screen == "home" then
                markedUsable = true
                Probe.mark("main window usable")
            end
        end
        return result
    end
end

-- The Dev tools button: measures the next 10 seconds.
function Probe.manual()
    Probe.measure("manual", 10)
    log("PROBE: measuring the next 10 seconds")
end

return Probe
