-- core/memory.lua
-- Gives the client's memory back promptly after cards are destroyed. Every card is about 10 MB of the client's memory, held by
-- the Lua objects that wrap it, which is freed only when Lua collects them. Lua decides when to collect from its own heap, which
-- is small, so it does not feel the pressure: paging quickly through the Collection's grid made cards faster than they were
-- freed, and the client's memory spiked from 4.2 GB to 8.7 GB for a few seconds before falling back by itself.
--
-- Memory.collectSoon() asks for one full collection about a second from now. Asking again before it runs changes nothing, so a
-- burst of page turns gets a collection about once a second, and always one after the last page. The collection runs from the
-- Draw event, on the frame after the wait. The Lua heap is small (tens of MB), so a collection takes a few milliseconds.

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
