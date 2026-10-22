-- outputwindow.lua
-- A small window that shows the lines the debug tools produce (the paste-ready card settings
-- from the preview, the marks from the NPC browser), so one line can be selected and copied.
-- The developer console only lets you copy everything at once.
--
-- Each line is shown in its own text field, because a field's text can be selected with the
-- mouse and copied (Ctrl+C), which plain text components do not allow.
--
-- Lines are remembered while the window is closed, so opening it shows what it missed.
-- Only used when DEBUG is on in main.lua.

local OutputWindow = {}

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR
local WIDTH = 640
local ROWS = 8                 -- how many of the newest lines are shown
local ROW_H = 30
local KEEP = 60                -- how many lines are remembered
local MAX_LENGTH = 400         -- longest line a field can hold

local lines = {}               -- { label = "chicken", text = "body = true, cam = { ... }" }, newest last
local window = nil
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

    for row = 1, ROWS do
        local entry = lines[#lines - row + 1]
        if entry == nil then
            break
        end
        local y = 38 + (row - 1) * ROW_H

        local caption = ui.Text.new(window)
        caption:SetPos(10, y)
        caption:SetSize(110, 26)
        caption.font = FONT
        caption.content = entry.label
        caption.colour = Vector4.new(0.85, 0.85, 0.85, 1.0)
        caption.isShadowed = true
        caption:AlignTo(ui.AlignMode.TOPLEFT, ui.AlignMode.CENTRE)
        rowParts[#rowParts + 1] = caption

        local field = ui.InputField.new(window)
        field:SetPos(125, y)
        field:SetSize(WIDTH - 135, 26)
        local sheet = id.StyleSheet.INPUT_DEFAULT
        if sheet ~= nil then
            field.stylesheetID = sheet
        end
        field:Setup(ui.TextContentVisibilityMode.VISIBLE, ui.InputFieldFilterMode.NONE, MAX_LENGTH)
        field.content = entry.text
        rowParts[#rowParts + 1] = field
    end
end

function OutputWindow.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window = ui.GroupBox.new(gameWindow)
    window.stylesheetID = id.StyleSheet.DEFAULT
    window:SetHeaderLayout(0, 0, 0, 0, 0)
    window:SetSize(WIDTH, 38 + ROWS * ROW_H + 40)
    window:SetPos(0, 0, 0.2, 0.7)

    local title = ui.Text.new(window)
    title:SetPos(10, 8)
    title:SetSize(WIDTH - 130, 24)
    title.font = FONT
    title.content = "Output - click a line, Ctrl+A then Ctrl+C to copy it"
    title.colour = Vector4.new(1, 1, 1, 1)
    title.isShadowed = true
    title:AlignTo(ui.AlignMode.TOPLEFT, ui.AlignMode.CENTRE)

    local clear = ui.Button.new(window)
    clear:SetPos(WIDTH - 110, 6)
    clear:SetSize(100, 28)
    clear.label = "Clear"
    clear.stylesheetID = id.StyleSheet.BUTTON_DEFAULT
    clear:Subscribe(ui.Hook.ONBUTTONPRESSED, function() OutputWindow.clear() end)

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
end

function OutputWindow.toggle()
    if window ~= nil then
        OutputWindow.hide()
    else
        OutputWindow.show()
    end
end

return OutputWindow
