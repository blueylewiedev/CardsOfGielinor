-- dev/check_events.lua
-- Checks core/events.lua (every event subscription is recorded and undone at shutdown) and that no shipped file
-- subscribes to the client's events around it, which would leave a handler running after the plugin shuts down.
-- The "Check cards" workflow runs it.
--
-- Run from the plugin's folder:  lua dev/check_events.lua

package.path = "./?.lua;" .. package.path

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        print("FAIL: " .. what)
    end
end

-- A stand-in for the client's Event: each event keeps its handlers by name.
local live = {}
Event = setmetatable({}, { __index = function(t, event)
    local e = {
        Subscribe = function(name, fn) live[event .. "|" .. name] = fn end,
        Unsubscribe = function(name) live[event .. "|" .. name] = nil end,
    }
    rawset(t, event, e)
    return e
end })
local function count(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

local Events = require("core/events")
Events.on("Draw", "a", function() end)
Events.on("Draw", "b", function() end)
Events.on("ServerLogic", "a", function() end)
check(count(live) == 3 and Events.count() == 3, "three subscriptions are made and recorded")
Events.on("Draw", "a", function() end)
check(count(live) == 3 and Events.count() == 3, "subscribing the same name again replaces it, not adds one")
Events.off("Draw", "b")
check(live["Draw|b"] == nil and Events.count() == 2, "off unsubscribes one")
Events.off("Draw", "never")
check(Events.count() == 2, "off for a name that was never subscribed changes nothing")
Event.Broken = { Subscribe = function() end, Unsubscribe = function() error("client refused") end }
Events.on("Broken", "x", function() end)
Events.shutdown()
check(count(live) == 0 and Events.count() == 0, "shutdown unsubscribes everything, even past an Unsubscribe that fails")

-- No shipped file subscribes around the registry (comments do not count).
local files = {}
local list = io.popen("git ls-files main.lua core ui")
for line in list:lines() do
    if line:match("%.lua$") then
        files[#files + 1] = line
    end
end
list:close()
check(#files > 20, "found the shipped files (" .. #files .. ")")
for _, path in ipairs(files) do
    if path ~= "core/events.lua" then
        local number = 0
        for line in io.lines(path) do
            number = number + 1
            local code = line:gsub("%-%-.*$", "")
            if code:find("Event%.[%w_]+%.Subscribe") or code:find("Event%.[%w_]+%.Unsubscribe") then
                check(false, path .. ":" .. number .. " subscribes to Event directly: use Events.on / Events.off (core/events.lua)")
            end
        end
    end
end

if failures > 0 then
    os.exit(1)
end
print("OK: event subscriptions are recorded, undone at shutdown, and all go through core/events.lua")
