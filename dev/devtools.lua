-- dev/devtools.lua
-- The Dev tools window: one button for each development tool and debug action, in two columns. It is on the screen whenever the
-- development copy is running (dev/dev.lua builds the list and hands it over with setButtons, then shows it). It is small, scrolls
-- (the mouse wheel works over the buttons too) and can be dragged and resized. It has no close button, so it cannot be lost; the
-- arrow in its title bar collapses it to just the title bar and expands it again.

local Kit = require("ui/kit")

local DevTools = {}

local COLUMNS = 2
local BUTTON_W, BUTTON_H, GAP = 180, 28, 10          -- the width is of the drawn button; labels must fit it
local WIDTH = COLUMNS * BUTTON_W + (COLUMNS - 1) * GAP + 44      -- the frame and padding take 44
local HEIGHT = 330                                   -- about seven rows show; the rest scroll, or resize the window
local WHEEL_STEP = 64
local LEFT = 12            -- the buttons start this far in: the content area starts near the frame's edge, so with
                           -- none the left gap was a few pixels and the right gap about 30

local buttons = {}                  -- { label, action, style, tooltip }, set by setButtons
local window = nil
local collapseButton = nil          -- the arrow in the title bar
local contentHeight = 0             -- how tall the buttons are together
local collapsed = false             -- kept when the window is redrawn
local fullHeight = HEIGHT           -- the window's height when it was last expanded

-- Shows the window as the state says: just the title bar, or the buttons.
local function applyCollapsed()
    window.content.hidden = collapsed
    window:SetContentHeight(collapsed and 0 or contentHeight)
    window:SetSize(window.root.width, collapsed and Kit.titleBarHeight() or fullHeight)
end

local function toggleCollapsed()
    if not collapsed then
        fullHeight = window.root.height
    end
    collapsed = not collapsed
    applyCollapsed()
end

-- The tools to show: a list of { label, action, style (optional), tooltip (optional) }. If the window is open it is redrawn.
function DevTools.setButtons(list)
    buttons = list or {}
    if window ~= nil then
        DevTools.hide()
        DevTools.show()
    end
end

function DevTools.show()
    if window ~= nil then
        return
    end
    local rows = math.ceil(#buttons / COLUMNS)
    contentHeight = rows * (BUTTON_H + GAP) + 16
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window = prettyui.Window.new(gameWindow, {
        title = "Dev tools", width = WIDTH, height = HEIGHT, x = 12, y = 0, xAnchor = 0, yAnchor = 0.3,
        scrollable = true, resizable = true, hideCloseButton = true, minWidth = WIDTH, minHeight = Kit.titleBarHeight(),
        contentHeight = contentHeight, categoryID = "auto",
    })
    collapseButton = Kit.titleButton(window, "ARROW_UP", toggleCollapsed, "Collapse to the title bar, or expand", -1)
    for i, tool in ipairs(buttons) do
        local column, row = (i - 1) % COLUMNS, math.floor((i - 1) / COLUMNS)
        local button = Kit.buttonAt(window.content, tool.label, LEFT + column * (BUTTON_W + GAP), 4 + row * (BUTTON_H + GAP),
            BUTTON_W, BUTTON_H, tool.action, tool.style, tool.tooltip)
        -- a PrettyUI button does not pass the wheel on to the window's scrolling, so it does
        Kit.onWheel(button, function(delta)
            window:ScrollBy(delta > 0 and WHEEL_STEP or -WHEEL_STEP)
        end)
    end
    if collapsed then
        applyCollapsed()
    end
end

function DevTools.hide()
    if collapseButton ~= nil then
        collapseButton.Destroy()
        collapseButton = nil
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
end

return DevTools
