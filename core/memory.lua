-- core/memory.lua
-- Gives the client's memory back promptly after cards are destroyed. Every card is about 10 MB of the client's
-- memory, freed only when Lua collects the objects that wrap it, and Lua decides from its own small heap.
-- Memory.collectSoon() asks for one full collection about a second from now; asking again before it runs changes
-- nothing, so a burst of page turns gets about one a second and always one after the last. It runs from the Draw
-- event and takes a few milliseconds.

local Events = require("core/events")

local Memory = {}

local DELAY = 1.0              -- seconds between asking and collecting
local due = nil                -- seconds left until the collection, or nil if none is wanted
local collections = 0

-- Asks for a collection soon (see above).
function Memory.collectSoon()
    if due == nil then
        due = DELAY
    end
end

-- How many collections have run (for the tests).
function Memory.collections()
    return collections
end

-- Moves time on by `dt` seconds; collects if the wait is over. The Draw event calls it; the tests call it directly.
function Memory.step(dt)
    if due == nil then
        return
    end
    due = due - dt
    if due <= 0 then
        due = nil
        collections = collections + 1
        collectgarbage("collect")
    end
end

Events.on("Draw", "cardcollector_memory", function(e)
    local ok, dt = pcall(function() return e.timeDeltaSecs end)
    Memory.step((ok and type(dt) == "number") and dt or 0.016)
end)

return Memory
