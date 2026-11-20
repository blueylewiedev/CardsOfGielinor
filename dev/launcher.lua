-- dev/launcher.lua
-- A small window of its own with the development copy's two always-there buttons: "Dev tools" (opens the Dev tools window) and
-- "Preview as released" (switches the tools off, so the plugin looks and behaves as players will have it; saved, so it stays as left).
-- It is not part of the plugin's own windows: the plugin has no place for development buttons. Not in the release.

local Kit = require("ui/kit")

local Launcher = {}

local KEY = "dev_preview-dev"            -- ends with the dev copy's key suffix, like its other keys
local WIDTH, BUTTON_H, GAP = 200, 28, 8

local window, previewButton = nil, nil

-- True if "Preview as released" was left on.
function Launcher.previewing()
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(KEY) end)
    return ok and type(saved) == "table" and saved.on == true
end

local function previewLabel(on)
    return "Preview as released: " .. (on and "ON" or "off")
end

-- Shows the window. `openTools()` opens the Dev tools window; `onPreview(on)` is called when "Preview as released" is switched.
function Launcher.show(openTools, onPreview)
    if window ~= nil then
        return
    end
    local previewing = Launcher.previewing()
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local content
    window, content = Kit.window(gameWindow, "Dev copy", WIDTH + 44, 2 * BUTTON_H + 3 * GAP + Kit.titleBarHeight(),
        function() Launcher.hide() end, 0.0, 0.35)
    Kit.buttonAt(content, "Dev tools", 12, GAP, WIDTH - 20, BUTTON_H, openTools, "positive",
        "Opens the Dev tools window: the card tools, probes and debug actions")
    previewButton = Kit.buttonAt(content, previewLabel(previewing), 12, 2 * GAP + BUTTON_H, WIDTH - 20, BUTTON_H, function()
        previewing = not previewing
        pcall(function() PersistentDB:SetStructuredData(KEY, { on = previewing }) end)
        Kit.setLabel(previewButton, previewLabel(previewing))
        onPreview(previewing)
    end, "neutral", "Switches the development tools off, so the plugin looks and behaves as players will have it")
end

function Launcher.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, previewButton = nil, nil
end

return Launcher
