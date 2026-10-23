-- outputwindow.lua
-- A window that shows the lines the developer tools produce (the paste-ready card settings
-- from the preview, the marks from the NPC browser, the lines from Nearby NPCs), so one line can
-- be selected and copied. The developer console only lets you copy everything at once.
--
-- Each line is shown in its own text field, because a field's text can be selected with the
-- mouse and copied (Ctrl+C), which plain text components do not allow.
--
-- The newest line is at the top. The window scrolls, so older lines are reached by scrolling
-- down. If PrettyUI's scrolling does not work for you, set SCROLL to false: the window then
-- shows only the newest ROWS lines.
--
-- Lines are remembered while the window is closed, so opening it shows what it missed.
-- Only used by the developer tools (the dev folder).

local Kit = require("ui/kit")

local OutputWindow = {}

local SCROLL = true            -- show every remembered line in a scrolling window
local WIDTH = 640
local ROWS = 12                -- how many lines are visible at a time (and shown without scrolling)
local ROW_H = 30
local TOP = 40                 -- space for the hint and the Clear button above the lines
local KEEP = 200               -- how many lines are remembered
local MAX_LENGTH = 400         -- longest line a field can hold

local GREY = Vector4.new(0.85, 0.85, 0.85, 1.0)
local WHITE = Vector4.new(1, 1, 1, 1)

local lines = {}               -- { label = "chicken", text = "body = true, cam = { ... }" }, newest last
local window = nil
local content = nil            -- where the window's contents go
local rowParts = {}            -- the components of the rows currently shown

-- Adds a line. `label` is a short tag such as the card id; `text` is what gets copied.
-- Works whether or not the window is open.
function OutputWindow.add(label, text)
    lines[#lines + 1] = { label = tostring(label), text = tostring(text) }
    if #lines > KEEP then
        table.remove(lines, 1)
    end
    if window ~= nil then
        OutputWindow.redraw()
    end
end

function OutputWindow.clear()
    lines = {}
    if window ~= nil then
        OutputWindow.redraw()
    end
end

function OutputWindow.isOpen()
    return window ~= nil
end

-- Rebuilds the rows. Newest line first, so it is always at the top.
function OutputWindow.redraw()
    for _, part in ipairs(rowParts) do
        pcall(function() part:Destroy() end)
    end
    rowParts = {}
    if window == nil then
        return
    end

    local shown = (SCROLL and Kit.available()) and KEEP or ROWS
    for row = 1, shown do
        local entry = lines[#lines - row + 1]
        if entry == nil then
            break
        end
        local y = TOP + (row - 1) * ROW_H

        rowParts[#rowParts + 1] = Kit.text(content, 10, y, 110, 26, entry.label, GREY, ui.AlignMode.TOPLEFT)

        local field = Kit.inputField(content, 125, y, WIDTH - 150, 26, MAX_LENGTH, false)
        field.content = entry.text
        rowParts[#rowParts + 1] = field
    end
end

function OutputWindow.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Output", WIDTH, TOP + ROWS * ROW_H + 10 + Kit.titleBarHeight(),
        function() OutputWindow.hide() end, 0.2, 0.55, SCROLL)

    -- The hint and the Clear button are not rebuilt on every redraw, so they are not in rowParts.
    Kit.text(content, 10, 4, WIDTH - 140, 28,
        "Click a line, Ctrl+A then Ctrl+C to copy it", WHITE, ui.AlignMode.TOPLEFT)
    Kit.button(content, "Clear", WIDTH - 130, 2, 110, 30, function() OutputWindow.clear() end)

    OutputWindow.redraw()
end

function OutputWindow.hide()
    if window == nil then
        return
    end
    -- Destroy the rows first, then the window. Any failure is logged: if the window is not
    -- really gone, hide it so the button still seems to work.
    for _, part in ipairs(rowParts) do
        local ok, err = pcall(function() part:Destroy() end)
        if not ok then
            log("output window: could not destroy a row:", tostring(err))
        end
    end
    rowParts = {}
    local ok, err = pcall(function() window:Destroy() end)
    if not ok then
        log("output window: could not destroy the window, hiding it instead:", tostring(err))
        pcall(function() window.hidden = true end)
    end
    window = nil
    content = nil
end

function OutputWindow.toggle()
    if window ~= nil then
        OutputWindow.hide()
    else
        OutputWindow.show()
    end
end

return OutputWindow
