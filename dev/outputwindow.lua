-- outputwindow.lua
-- A window that shows the lines the developer tools produce (the paste-ready card settings
-- from the preview, the marks from the NPC browser, the lines from Nearby NPCs), so one line can
-- be selected and copied. The developer console only lets you copy everything at once.
--
-- Each line is shown in its own text field, because a field's text can be selected with the
-- mouse and copied (Ctrl+C), which plain text components do not allow.
--
-- The newest line is at the top. Older lines are reached with the Older / Newer buttons, one
-- page of ROWS lines at a time (PrettyUI's `scrollable` window did not scroll lines placed at
-- fixed positions like these).
--
-- Lines are remembered while the window is closed, so opening it shows what it missed.
-- Only used by the developer tools (the dev folder).

local Kit = require("ui/kit")

local OutputWindow = {}

local WIDTH = 640
local ROWS = 14                -- how many lines are shown at a time
local ROW_H = 30
local TOP = 44                 -- space for the buttons above the lines
local KEEP = 300               -- how many lines are remembered
local MAX_LENGTH = 1000        -- longest line a field can hold (a card block on one line is long)

local GREY = Vector4.new(0.85, 0.85, 0.85, 1.0)
local WHITE = Vector4.new(1, 1, 1, 1)

local lines = {}               -- { label = "chicken", text = "body = true, cam = { ... }" }, newest last
local window = nil
local content = nil            -- where the window's contents go
local rowParts = {}            -- the components of the rows currently shown
local page = 0                 -- 0 shows the newest lines, 1 the ones before them, and so on
local statusText = nil         -- "Lines 1-14 of 87"

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

-- How many pages the remembered lines fill (at least one).
local function pageCount()
    return math.max(1, math.ceil(#lines / ROWS))
end

-- Rebuilds the rows and the line that says which ones are shown. Newest line first, so the
-- newest is at the top of page 0.
function OutputWindow.redraw()
    for _, part in ipairs(rowParts) do
        pcall(function() part:Destroy() end)
    end
    rowParts = {}
    if window == nil then
        return
    end

    page = math.max(0, math.min(page, pageCount() - 1))
    local first = page * ROWS + 1                        -- the newest line on this page
    local last = math.min(#lines, first + ROWS - 1)
    for row = first, last do
        local entry = lines[#lines - row + 1]
        local y = TOP + (row - first) * ROW_H

        rowParts[#rowParts + 1] = Kit.text(content, 10, y, 110, 26, entry.label, GREY, ui.AlignMode.TOPLEFT)

        local field = Kit.inputField(content, 125, y, WIDTH - 150, 26, MAX_LENGTH, false)
        field.content = entry.text
        rowParts[#rowParts + 1] = field
    end
    if statusText ~= nil then
        statusText.content = #lines == 0 and "No lines yet"
            or ("Lines " .. first .. "-" .. last .. " of " .. #lines)
    end
end

function OutputWindow.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Output", WIDTH, TOP + ROWS * ROW_H + 10 + Kit.titleBarHeight(),
        function() OutputWindow.hide() end, 0.2, 0.55)

    -- These are not rebuilt on every redraw, so they are not in rowParts.
    Kit.buttonAt(content, "Newer", 10, 4, 120, 30, function()
        page = page - 1
        OutputWindow.redraw()
    end)
    Kit.buttonAt(content, "Older", 134, 4, 120, 30, function()
        page = page + 1
        OutputWindow.redraw()
    end)
    statusText = Kit.text(content, 264, 4, WIDTH - 264 - 140, 30, "", WHITE)
    Kit.buttonAt(content, "Clear", WIDTH - 130, 4, 120, 30, function() OutputWindow.clear() end)

    page = 0
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
    statusText = nil
end

function OutputWindow.toggle()
    if window ~= nil then
        OutputWindow.hide()
    else
        OutputWindow.show()
    end
end

return OutputWindow
