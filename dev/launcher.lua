-- dev/launcher.lua
-- A small window of its own with one button, "Dev tools", which opens the Dev tools window (reopening it after it is closed). The
-- plugin has no place for development buttons, so the development copy adds this window itself. Not in the release.

local Kit = require("ui/kit")

local Launcher = {}

local WIDTH, BUTTON_H, GAP = 200, 28, 8

local window = nil

-- Shows the window. `openTools()` opens the Dev tools window.
function Launcher.show(openTools)
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local content
    window, content = Kit.window(gameWindow, "Dev copy", WIDTH + 44, BUTTON_H + 2 * GAP + Kit.titleBarHeight(),
        function() Launcher.hide() end, 0.0, 0.35)
    Kit.buttonAt(content, "Dev tools", 12, GAP, WIDTH - 20, BUTTON_H, openTools, "positive",
        "Opens the Dev tools window: the card tools, probes and debug actions")
end

function Launcher.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
end

return Launcher
