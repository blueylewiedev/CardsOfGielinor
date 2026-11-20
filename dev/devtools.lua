-- dev/devtools.lua
-- The Dev tools window: one button for each development tool and debug action, in two columns. It is on the screen whenever the
-- development copy is running (dev/dev.lua builds the list and hands it over with setButtons, then shows it). It is small, scrolls
-- (the mouse wheel works over the buttons too) and can be dragged and resized; it has no close button, so it cannot be lost.

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
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window = prettyui.Window.new(gameWindow, {
        title = "Dev tools", width = WIDTH, height = HEIGHT, x = 12, y = 0, xAnchor = 0, yAnchor = 0.3,
        scrollable = true, resizable = true, hideCloseButton = true, minWidth = WIDTH, minHeight = 140,
        contentHeight = rows * (BUTTON_H + GAP) + 16, categoryID = "auto",
    })
    for i, tool in ipairs(buttons) do
        local column, row = (i - 1) % COLUMNS, math.floor((i - 1) / COLUMNS)
        local button = Kit.buttonAt(window.content, tool.label, LEFT + column * (BUTTON_W + GAP), 4 + row * (BUTTON_H + GAP),
            BUTTON_W, BUTTON_H, tool.action, tool.style, tool.tooltip)
        -- a PrettyUI button does not pass the wheel on to the window's scrolling, so it does
        Kit.onWheel(button, function(delta)
            window:ScrollBy(delta > 0 and WHEEL_STEP or -WHEEL_STEP)
        end)
    end
end

function DevTools.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
end

return DevTools
