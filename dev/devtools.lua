-- dev/devtools.lua
-- The Dev tools window: one button for each development tool and debug action. The Home window has a
-- single "Dev tools" button that opens it (dev/dev.lua builds the list and hands it over with setButtons),
-- so the Home window stays the size players will see.

local Kit = require("ui/kit")

local DevTools = {}

local COLUMNS = 2
local BUTTON_W, BUTTON_H, GAP = 180, 28, 10          -- the width is of the drawn button; labels must fit it
local WIDTH = COLUMNS * BUTTON_W + (COLUMNS - 1) * GAP + 44      -- the frame and padding take 44

local buttons = {}                  -- { label, action, style, tooltip }, set by setButtons
local window, content = nil, nil

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
    window, content = Kit.window(gameWindow, "Dev tools", WIDTH,
        rows * (BUTTON_H + GAP) + 16 + Kit.titleBarHeight(), function() DevTools.hide() end, 0.15, 0.2)
    for i, tool in ipairs(buttons) do
        local column, row = (i - 1) % COLUMNS, math.floor((i - 1) / COLUMNS)
        Kit.buttonAt(content, tool.label, column * (BUTTON_W + GAP), 4 + row * (BUTTON_H + GAP), BUTTON_W, BUTTON_H,
            tool.action, tool.style, tool.tooltip)
    end
end

function DevTools.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
    content = nil
end

function DevTools.toggle()
    if window ~= nil then
        DevTools.hide()
    else
        DevTools.show()
    end
end

return DevTools
