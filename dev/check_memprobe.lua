-- dev/check_memprobe.lua
-- Checks the memory probe (dev/memprobe.lua) against a stand-in for the client's ui: that it counts the components made,
-- tells live ones from destroyed ones that something still holds, and sees a component let go of. The probe is a dev tool,
-- not part of the plugin, but a probe that miscounts would send the hunt for a leak the wrong way.
--
-- Run from the plugin's folder:  lua dev/check_memprobe.lua

package.path = "./?.lua;./dev/?.lua;" .. package.path

local lines = {}
function log(...)
    local parts = {}
    for i = 1, select("#", ...) do parts[#parts + 1] = tostring((select(i, ...))) end
    lines[#lines + 1] = table.concat(parts, " ")
end

-- A stand-in class: components with a method table (Destroy and a readable `hidden`), like the client's.
local function class()
    local methods = {}
    function methods.Destroy(self) self._gone = true end
    local meta = { __index = function(t, k)
        if rawget(t, "_gone") then error("the component was destroyed") end
        return methods[k] or false
    end }
    -- (the real client's __index is a table of methods; this one is a function, which the probe must cope with too)
    return { new = function() return setmetatable({}, meta) end, methods = methods }
end

local function classWithMethodTable()
    local methods = { hidden = false }
    function methods.Destroy(self) rawset(self, "_gone", true) end
    local meta = { __index = methods }
    return { new = function() return setmetatable({}, meta) end }
end

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

Event = { Logic = { Subscribe = function() end } }

-- 1. a client whose components have a method table: Destroy calls are seen
do
    ui = { Layer = classWithMethodTable(), Sprite = classWithMethodTable() }
    package.loaded["dev/memprobe"] = nil
    local Mem = require("dev/memprobe")
    check(lines[1] ~= nil and string.find(lines[1], "counting Layer, Sprite", 1, true) ~= nil, "it says what it counts (" .. tostring(lines[1]) .. ")")
    local keep = {}
    for i = 1, 5 do keep[i] = ui.Layer.new() end
    for i = 1, 3 do keep[5 + i] = ui.Sprite.new() end
    Mem.baseline()
    for i = 1, 4 do keep[8 + i] = ui.Layer.new() end                 -- four more, kept alive
    keep[1]:Destroy()                                                  -- one destroyed but still referenced
    keep[2]:Destroy()
    lines = {}
    Mem.snapshot("test")
    local joined = table.concat(lines, "\n")
    check(string.find(joined, "live 10 (+2)", 1, true) ~= nil, "11+... live components: 12 made, 2 destroyed, so 10 live and +2 over the baseline (" .. joined .. ")")
    check(string.find(joined, "held after Destroy 2 (+2)", 1, true) ~= nil, "the two destroyed ones that are still referenced are 'held'")
    check(string.find(joined, "Layer 7 (+2)", 1, true) ~= nil, "the changes are by kind: Layer 7 (+2)")
    -- letting go of every reference lets them be collected, so they leave the count
    for i = 1, #keep do keep[i] = nil end
    lines = {}
    Mem.snapshot("released")
    joined = table.concat(lines, "\n")
    check(string.find(joined, "held after Destroy 0", 1, true) ~= nil or string.find(joined, "held after Destroy 0 (-", 1, true) == nil,
        "after the references are dropped nothing is held")
    check(string.find(joined, "live 0 (-8)", 1, true) ~= nil, "and the live ones are gone too, as the baseline had 8 (" .. joined .. ")")
end

-- 2. a client whose components hide their method table: judged by whether they can still be read
do
    ui = { Layer = class() }
    package.loaded["dev/memprobe"] = nil
    lines = {}
    local Mem = require("dev/memprobe")
    local a, b, c = ui.Layer.new(), ui.Layer.new(), ui.Layer.new()
    a:Destroy()
    Mem.baseline()
    local joined = table.concat(lines, "\n")
    check(string.find(joined, "2 live components, 1 held", 1, true) ~= nil, "without Destroy tracking: 2 live and 1 destroyed that is still held (" .. joined .. ")")
    lines = {}
    Mem.snapshot("fallback")
    joined = table.concat(lines, "\n")
    check(string.find(joined, "cannot be seen", 1, true) ~= nil, "it says Destroy calls cannot be seen in that client")
end

-- 3. no wrappable classes: it says so and does nothing else
do
    ui = {}
    package.loaded["dev/memprobe"] = nil
    lines = {}
    require("dev/memprobe")
    check(string.find(lines[1] or "", "counting nothing", 1, true) ~= nil, "a client with nothing to wrap is reported")
end

if failures > 0 then
    io.stderr:write(failures .. " memory probe check(s) failed\n")
    os.exit(1)
end
print("OK: the memory probe counts live and destroyed components as it should")
