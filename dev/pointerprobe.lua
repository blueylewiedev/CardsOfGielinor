-- dev/pointerprobe.lua
-- Probe for the in-game tutorial (notes/example_tutorials.md): can the plugin point at one of its own components?
-- Dev copy only (this folder is not in the release). Dev tools > Pointer probe opens a small window with three buttons;
-- a gold pointer (the game's own sprite, as the Bank Tags tutorial uses) and a flashing frame sit on the chosen button.
-- It answers five things, in "POINTER ..." lines on the console and in the Output window:
--   1. Do the game sprites exist in this client? (the pointer, the info icon, the navigation arrow, the nine flash frames)
--   2. Does component.xyGlobal exist, and does it agree with adding up .x and .y through the parents?
--   3. Is the position right at the owner's interface scale (120%), and does it follow when the window is dragged?
--   4. What do the screen size (parent.width / height) and game.options.InterfaceScale say?
--   5. Does the pointer stay put when the window is dragged (it is moved every Logic tick from the live position)?
-- Buttons in the probe window: "Next target" moves the pointer to the next button; the pointer flips below the target when
-- there is no room above (press "Next target" with the window dragged to the top of the screen).

local Kit = require("ui/kit")
local memLoaded, MemProbe = pcall(require, "dev/memprobe")

local Probe = {}

local EVENT = "cardcollector_dev_pointerprobe"
local SPRITES = { "RS3_INFO_DISPLAY_POINTER", "TUTSYS_INFO_ICON", "RS3_ICON_CALENDAR_NAVIGATION_24PX_0",
    "AIF_EXAMINE_HIGHLIGHT_1_0", "AIF_EXAMINE_HIGHLIGHT_1_4", "AIF_EXAMINE_HIGHLIGHT_1_8",
    "AIF_EXAMINE_HIGHLIGHT_2_0", "AIF_EXAMINE_HIGHLIGHT_2_8" }
local WIDTH, HEIGHT = 520, 200

local window, overlay, pointer, frame = nil, nil, nil, nil
local buttons, target, ticks, lastReport = {}, 1, 0, ""
local frameParts = {}                 -- the nine pieces of the flash frame

-- Nine pieces: corners 10 px, stretched middle strips.
local function sizeFrame(width, height)
    local xs, ys = { 0, 10, width - 10 }, { 0, 10, height - 10 }
    local ws, hs = { 10, width - 20, 10 }, { 10, height - 20, 10 }
    for index, part in ipairs(frameParts) do
        local column, row = (index - 1) % 3 + 1, (index - 1) // 3 + 1
        part:SetPos(xs[column], ys[row])
        part:SetSize(ws[column], hs[row])
    end
end

local function say(text)
    if memLoaded and MemProbe.say ~= nil then
        MemProbe.say("POINTER", text)
    else
        log("POINTER " .. text)
    end
end

local function layer()
    return ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
end

-- What the sprite names resolve to in this client.
local function reportSprites()
    for _, name in ipairs(SPRITES) do
        local ok, value = pcall(function() return id.Sprite[name] end)
        say(string.format("sprite %s = %s", name, ok and tostring(value) or ("error " .. tostring(value))))
    end
end

-- The position by adding up .x and .y through the parents (what Bank Tags falls back to).
local function summed(component)
    local x, y, current, depth = 0, 0, component, 0
    while current ~= nil and depth < 32 do
        x = x + (tonumber(current.x) or 0)
        y = y + (tonumber(current.y) or 0)
        current = current.parent
        depth = depth + 1
    end
    return x, y
end

local function globalOf(component)
    local ok, point = pcall(function() return component.xyGlobal end)
    if ok and point ~= nil then return point.x, point.y end
    return nil, nil
end

local function interfaceScale()
    local option = game and game.options and game.options.InterfaceScale
    return option and tonumber(option.setting) or nil
end

-- Moves the pointer and the frame onto the current target (called every Logic tick).
local function place()
    local button = buttons[target]
    if button == nil or button.root == nil then return end
    local root = button.root
    local gx, gy = globalOf(root)
    local sx, sy = summed(root)
    local ox, oy = globalOf(overlay)
    local x, y = gx or sx, gy or sy
    -- relative to the overlay, which fills the layer
    local lx, ly = x - (ox or 0), y - (oy or 0)
    local w, h = tonumber(root.width) or 0, tonumber(root.height) or 0
    frame:SetPos(lx - 1, ly - 1)
    frame:SetSize(w + 3, h + 3)
    sizeFrame(w + 3, h + 3)
    local bob = 3 + 3 * math.sin(ticks / 7)
    if ly >= 62 then
        pointer.rotationDegrees = 0
        pointer:SetPos(lx + w / 2 - 20, ly - 58 - bob)
    else
        pointer.rotationDegrees = 180
        pointer:SetPos(lx + w / 2 - 20, ly + h + 4 + bob)
    end
    local report = string.format("target %d: global=%s,%s summed=%d,%d size=%dx%d overlay=%s,%s layer=%sx%s scale=%s", target,
        tostring(gx), tostring(gy), sx, sy, w, h, tostring(ox), tostring(oy), tostring(overlay.parent and overlay.parent.width),
        tostring(overlay.parent and overlay.parent.height), tostring(interfaceScale()))
    -- Written only when it changes and has stayed put for a moment (a drag would write a line every tick).
    if report ~= lastReport then
        lastReport = report
        ticks = 0
        Probe.pending = report
    end
end

local function close()
    pcall(function() Event.Logic.Unsubscribe(EVENT) end)
    for _, part in ipairs({ overlay, window }) do
        if part ~= nil then pcall(function() part:Destroy() end) end
    end
    window, overlay, pointer, frame, buttons, frameParts, Probe.pending = nil, nil, nil, nil, {}, {}, nil
end

function Probe.toggle()
    if window ~= nil then
        close()
        say("closed")
        return
    end
    reportSprites()
    local parent = layer()
    if parent == nil then say("no plugin layer"); return end
    local content
    window, content = Kit.window(parent, "Pointer probe", WIDTH, HEIGHT + Kit.titleBarHeight(), function() close() end,
        { xAnchor = 0.5, yAnchor = 0.4 })
    buttons = {}
    buttons[1] = Kit.buttonAt(content, "Left", 10, 20, 140, 30, function() end)
    buttons[2] = Kit.buttonAt(content, "Middle", 170, 70, 150, 30, function() end)
    buttons[3] = Kit.buttonAt(content, "Right", 340, 120, 140, 30, function() end)
    Kit.buttonAt(content, "Next target", 10, 120, 170, 30, function()
        target = target % #buttons + 1
        lastReport = ""
    end)
    -- A layer the size of the screen, above the window, that lets clicks through.
    overlay = ui.Layer.new(parent)
    overlay:SetPos(0, 0)
    overlay:SetSize(0, 0, 1.0, 1.0)
    overlay.clickthrough = true
    frame = ui.Layer.new(overlay)
    frame.clickthrough = true
    frameParts = {}
    for index = 0, 8 do
        local part = ui.Sprite.new(frame)
        part.spriteID = id.Sprite["AIF_EXAMINE_HIGHLIGHT_1_" .. index]
        part.clickthrough = true
        part.isTiling = true
        frameParts[index + 1] = part
    end
    pointer = ui.Sprite.new(overlay)
    pointer.spriteID = id.Sprite.RS3_INFO_DISPLAY_POINTER
    pointer:SetSize(41, 54)
    pointer.clickthrough = true
    target, ticks, lastReport = 1, 0, ""
    Event.Logic.Subscribe(EVENT, function()
        if window == nil then return end
        ticks = ticks + 1
        local ok, err = pcall(place)
        if not ok then
            say("place failed: " .. tostring(err))
            close()
            return
        end
        if Probe.pending ~= nil and ticks >= 10 then
            say(Probe.pending)
            Probe.pending = nil
        end
        overlay:MoveToFront()
    end)
    say("open. Drag the window, press Next target, move it to the top of the screen. Then press Output.")
end

return Probe
