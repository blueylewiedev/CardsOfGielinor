-- dev/memprobe.lua
-- Watches what the plugin leaves behind, to find a memory leak: the Lua heap, and every UI component the plugin has made
-- (Layer, Sprite, Model ...) that is still around. It counts them by kind and tells apart
--   live      : made and not destroyed,
--   held      : destroyed, but something in Lua still holds the object (a closure, a table), which can keep memory alive.
-- It cannot see the client's own memory (models, textures the client keeps); dev/memwatch.ps1 watches the whole process from
-- outside. Together they say whether growth is in the plugin's Lua (this file shows it), in components that are never
-- destroyed (this file shows it), or in what the client keeps (only memwatch shows it).
--
-- It is OFF until you switch it on, because it touches the client more than most dev tools do (it wraps the component
-- constructors and can force a garbage collection), and on 2026-11-19 the client crashed (an access violation inside
-- rs2client.exe) a few seconds after it was first used. Two switches, kept in PersistentDB, each taking effect at the next `prl`:
--   Mem count   wraps ui.<Class>.new so every component is counted (the live / held numbers). Off: only the Lua heap is logged.
--   Mem GC      makes a snapshot run a full garbage collection first, so garbage is not counted as live. Off: the numbers
--               include garbage that has not been collected yet, which is noisier but touches nothing.
--
-- Every line it logs starts with "MEM". The Dev tools window has four buttons: Mem count and Mem GC (the switches, they say
-- what they are now), and
--   Mem baseline   forgets the numbers so far and takes the baseline (do it with every window closed)
--   Mem snapshot   logs the numbers now and what changed since the baseline
-- With Mem count on, a snapshot is also taken by itself two seconds after each pack-opening screen closes ("reveal closed #3").
--
-- Dev copy only (this folder is not in the release). perfprobe.lua loads this first, so it sees every component the plugin
-- makes; the counting wraps ui.<Class>.new and changes nothing else.

local Mem = {}

local FLAGS_KEY = "dev_mem_flags-dev"           -- ends with the dev profile suffix, like the dev copy's other keys

-- The two switches, from PersistentDB (both off if there is nothing saved).
local flags = { count = false, gc = false }
do
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(FLAGS_KEY) end)
    if ok and type(saved) == "table" then
        flags.count = saved.count == true
        flags.gc = saved.gc == true
    end
end
Mem.flags = flags

-- Flips a switch ("count" or "gc"), saves it and says so. It takes effect at the next prl.
function Mem.toggle(name)
    if flags[name] == nil then
        return nil
    end
    flags[name] = not flags[name]
    pcall(function() PersistentDB:SetStructuredData(FLAGS_KEY, { count = flags.count, gc = flags.gc }) end)
    log(string.format("MEM: %s is now %s (saved; it takes effect at the next prl)", name == "count" and "counting components" or "the forced garbage collection",
        flags[name] and "ON" or "OFF"))
    return flags[name]
end

-- The client's component classes (ui.<Class>.new). PrettyUI makes its own parts from these too.
local CLASSES = { "Layer", "Rectangle", "Sprite", "Model", "ModelGroup", "Text", "Button", "InputField", "GroupBox", "Canvas" }
local LOGIC_SUBSCRIBER = "cardcollector_dev_mem"
local TICKS_PER_SECOND = 50
local SETTLE_TICKS = 2 * TICKS_PER_SECOND       -- after a reveal closes, wait this long before the snapshot

local tracked = setmetatable({}, { __mode = "k" })        -- component -> kind
local marked = setmetatable({}, { __mode = "k" })         -- component -> true, once its Destroy was called
local created, destroyed = {}, {}                         -- kind -> how many, since the probe loaded
local patched = {}                                        -- method tables whose Destroy is already wrapped
local wrapped = {}
local countsDestroy = false                               -- true once a Destroy was wrapped, so "marked" can be trusted
local baseline = nil
local batches = 0
local sawDestroy = false

-- Wraps a component's Destroy (found through its metatable) so the probe knows it was called. If the client does not let
-- that be found, a component is judged destroyed by whether reading it fails (as CardView's shine list does).
local function patchDestroy(object, kind)
    local ok = pcall(function()
        local meta = getmetatable(object)
        local index = meta ~= nil and meta.__index or nil
        if type(index) ~= "table" or patched[index] then
            return
        end
        local original = rawget(index, "Destroy")
        if type(original) ~= "function" then
            return
        end
        patched[index] = true
        countsDestroy = true
        rawset(index, "Destroy", function(self, ...)
            marked[self] = true
            local of = tracked[self]
            if of ~= nil then
                destroyed[of] = (destroyed[of] or 0) + 1
            end
            sawDestroy = true
            return original(self, ...)
        end)
    end)
    return ok
end

-- True if the component is gone: its Destroy was called (when those calls can be seen), or else it can no longer be read.
local function isDestroyed(object)
    if countsDestroy then
        return marked[object] == true
    end
    local ok = pcall(function() return object.hidden end)
    return not ok
end

local function wrap(class, kind)
    local original = class.new
    if type(original) ~= "function" or wrapped[class] then
        return false
    end
    wrapped[class] = true
    class.new = function(...)
        local object = original(...)
        if object ~= nil then
            pcall(function()
                tracked[object] = kind
                created[kind] = (created[kind] or 0) + 1
                patchDestroy(object, kind)
            end)
        end
        return object
    end
    return true
end

-- Starts counting. Returns the kinds it could wrap.
function Mem.install(uiTable)
    local done = {}
    for _, kind in ipairs(CLASSES) do
        local ok, class = pcall(function() return uiTable[kind] end)
        if ok and type(class) == "table" then
            local good = pcall(wrap, class, kind)
            if good and wrapped[class] then
                done[#done + 1] = kind
            end
        end
    end
    return done
end

-- ----- numbers -----------------------------------------------------------------------------------------------------

local function census()
    local live, held = {}, {}
    for object, kind in pairs(tracked) do
        if isDestroyed(object) then
            held[kind] = (held[kind] or 0) + 1
        else
            live[kind] = (live[kind] or 0) + 1
        end
    end
    return live, held
end

-- The heap in KB. With the GC switch on, after a full collection twice (a first one can free objects that a finalizer then
-- lets go); off, as it is, which includes garbage not collected yet.
local function heap()
    if flags.gc then
        collectgarbage("collect")
        collectgarbage("collect")
    end
    return collectgarbage("count")
end

local function total(counts)
    local n = 0
    for _, v in pairs(counts) do n = n + v end
    return n
end

local function kinds(a, b)
    local seen, list = {}, {}
    for _, source in ipairs({ a or {}, b or {} }) do
        for kind in pairs(source) do
            if not seen[kind] then
                seen[kind] = true
                list[#list + 1] = kind
            end
        end
    end
    table.sort(list)
    return list
end

local function describe(counts, before)
    local parts = {}
    for _, kind in ipairs(kinds(counts, before)) do
        local now, was = counts[kind] or 0, before and (before[kind] or 0) or nil
        if was == nil then
            parts[#parts + 1] = kind .. " " .. now
        elseif now ~= was then
            parts[#parts + 1] = string.format("%s %d (%+d)", kind, now, now - was)
        end
    end
    return #parts > 0 and table.concat(parts, ", ") or "no change"
end

local function takeSnapshot()
    local kb = heap()
    local live, held = census()
    return { kb = kb, live = live, held = held, created = total(created), destroyed = total(destroyed) }
end

-- Sets the baseline: do this with every plugin window closed.
function Mem.baseline()
    baseline = takeSnapshot()
    log(string.format("MEM baseline: Lua heap %.0f KB%s, %d live components, %d held after Destroy", baseline.kb,
        flags.gc and " (after a full collection)" or " (no collection forced)", total(baseline.live), total(baseline.held)))
    if not flags.count then
        log("MEM: counting components is OFF, so only the Lua heap is meaningful (Dev tools > Mem count, then prl)")
    end
    log("MEM baseline live: " .. describe(baseline.live))
    return baseline
end

-- Logs the numbers now, and what changed since the baseline (taking it first if there is none).
function Mem.snapshot(label)
    local now = takeSnapshot()
    if baseline == nil then
        baseline = now
        log(string.format("MEM %s: no baseline yet, so this one is it: Lua heap %.0f KB, %d live, %d held", label or "snapshot",
            now.kb, total(now.live), total(now.held)))
        log("MEM live: " .. describe(now.live))
        return now
    end
    log(string.format("MEM %s: Lua heap %.0f KB (%+.0f KB), live %d (%+d), held after Destroy %d (%+d)", label or "snapshot",
        now.kb, now.kb - baseline.kb, total(now.live), total(now.live) - total(baseline.live), total(now.held),
        total(now.held) - total(baseline.held)))
    log("MEM   live changes: " .. describe(now.live, baseline.live))
    if total(now.held) > 0 or total(baseline.held) > 0 then
        log("MEM   held after Destroy: " .. describe(now.held, baseline.held))
    end
    log(string.format("MEM   made %d, destroyed %d since the probe loaded%s", now.created, now.destroyed,
        countsDestroy and "" or " (Destroy calls cannot be seen in this client, so a component counts as gone when it can no longer be read)"))
    return now
end

-- ----- the reveal screen: a snapshot after each one closes ---------------------------------------------------------

local Reveal, wasActive, settle = nil, false, nil

local function onLogic(e)
    if Reveal == nil then
        local ok, module = pcall(require, "ui/revealscreen")
        if ok and type(module) == "table" and module.active ~= nil then
            Reveal = module
        else
            return
        end
    end
    local ok, active = pcall(Reveal.active)
    if not ok then
        return
    end
    if wasActive and not active then
        batches = batches + 1
        settle = SETTLE_TICKS
    end
    wasActive = active
    if settle ~= nil then
        settle = settle - 1
        if settle <= 0 then
            settle = nil
            Mem.snapshot("reveal closed #" .. batches)
        end
    end
end

local function start()
    local ok = pcall(function() Event.Logic.Subscribe(LOGIC_SUBSCRIBER, onLogic) end)
    return ok
end

if flags.count and ui ~= nil then
    local done = Mem.install(ui)
    local subscribed = start()
    log(string.format("MEM: counting %s%s%s", #done > 0 and table.concat(done, ", ") or "nothing (the client does not let ui.<Class>.new be wrapped)",
        subscribed and "" or "; no Logic event, so no automatic snapshots", flags.gc and "; forced garbage collection ON" or ""))
else
    log("MEM: the memory probe is loaded but counting is OFF (Dev tools > Mem count, then prl, to turn it on)")
end

return Mem
