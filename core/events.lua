-- core/events.lua
-- Every subscription the plugin makes to the client's events goes through here, so PluginShutdown can undo them all
-- (a handler left subscribed after a reload could keep running beside the new copy). It only keeps a list: each
-- handler is still subscribed to the client on its own, under its own name.
--   Events.on("Draw", "name", fn)    subscribes and remembers it
--   Events.off("Draw", "name")       unsubscribes it (never raises)
--   Events.shutdown()                unsubscribes everything still subscribed

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
