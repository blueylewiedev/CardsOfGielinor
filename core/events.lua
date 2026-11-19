-- core/events.lua
-- Every subscription the plugin makes to the client's events goes through here, so they can all be undone when the
-- plugin shuts down (PluginShutdown calls Events.shutdown): a handler left subscribed after a reload or a disable could
-- keep running beside the new copy of the plugin. It only keeps a list: each handler is still subscribed to the client
-- on its own, under its own name, and the client calls it exactly as if it had been subscribed directly.
--
--   Events.on("Draw", "cardcollector_shine", fn)   subscribes fn to Event.Draw under that name, and remembers it
--   Events.off("Draw", "cardcollector_shine")      unsubscribes it (never raises)
--   Events.shutdown()                              unsubscribes everything still subscribed

local Events = {}

local subscribed = {}           -- "<event>|<name>" -> { event, name }, in no order

function Events.on(event, name, handler)
    Event[event].Subscribe(name, handler)
    subscribed[event .. "|" .. name] = { event = event, name = name }
end

function Events.off(event, name)
    subscribed[event .. "|" .. name] = nil
    pcall(function() Event[event].Unsubscribe(name) end)
end

-- How many subscriptions are still in place (for the checks).
function Events.count()
    local n = 0
    for _ in pairs(subscribed) do
        n = n + 1
    end
    return n
end

function Events.shutdown()
    local all = subscribed
    subscribed = {}
    for _, entry in pairs(all) do
        pcall(function() Event[entry.event].Unsubscribe(entry.name) end)
    end
end

return Events
