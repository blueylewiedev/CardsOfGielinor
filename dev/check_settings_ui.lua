-- dev/check_settings_ui.lua
-- Runs the settings window of ui/settingspage.lua against a stand-in for the client's ui (see check_viewer_ui.lua): opens it
-- with and without the development tools, looks for its panels and lines, refreshes it and closes it. It finds a crash or a
-- panel that is missing; it cannot see how anything looks (that is checked in the client). PrettyUI is stood in for by an
-- empty table, so every widget takes its plain fallback.
--
-- Run from the plugin's folder:  lua dev/check_settings_ui.lua

package.path = "./?.lua;" .. package.path
function log() end

local created = {}
local function component(kind)
    local obj = { _kind = kind, _handlers = {}, _destroyed = false }
    created[#created + 1] = obj
    return setmetatable(obj, {
        __index = function(t, k)
            if k == "Subscribe" then
                return function(self, hook, fn) self._handlers[tostring(hook)] = fn end
            end
            if k == "Destroy" then
                return function(self) self._destroyed = true end
            end
            return function() return nil end
        end,
    })
end

local anything
anything = setmetatable({}, {
    __index = function(_, k) return anything end,
    __call = function() return anything end,
    __concat = function() return "x" end,
    __len = function() return 0 end,
})

local function class(kind)
    return { new = function(parent)
        local obj = component(kind)
        obj._parent = parent
        return obj
    end }
end

ui = setmetatable({
    Layer = class("Layer"), Rectangle = class("Rectangle"), Text = class("Text"), Button = class("Button"),
    InputField = class("InputField"), ComboField = class("ComboField"), Sprite = class("Sprite"),
    GroupBox = class("GroupBox"),
    Hook = setmetatable({}, { __index = function(_, k) return k end }),
    AlignMode = setmetatable({}, { __index = function(_, k) return k end }),
    Interfaces = { GetComponent = function() return component("parent") end },
}, { __index = function() return anything end })
id = anything
Event = setmetatable({}, { __index = function() return { Subscribe = function() end, Unsubscribe = function() end } end })
prettyui = require("dev/fakeprettyui")   -- (the plugin needs PrettyUI: a stand-in made from the ui above)
Vector4 = { new = function(x, y, z, w) return { x = x, y = y, z = z, w = w } end }
Plugin = { resources = { images = {} }, HasPermission = function() return false end }
PluginPermissions = anything
Mouse = { IsAvailable = function() return false end }

local Settings = require("core/settings")
local SettingsPage = require("ui/settingspage")

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end

local function has(pattern)
    for _, obj in ipairs(created) do
        local content = rawget(obj, "content")
        local label = rawget(obj, "label")
        if not obj._destroyed then
            if type(content) == "string" and string.find(content, pattern) then return true end
            if type(label) == "string" and string.find(label, pattern) then return true end
        end
    end
    return false
end

local changed = {}
for _, dev in ipairs({ false, true }) do
    created = {}
    SettingsPage.init({
        getState = function() return {} end, saveNow = function() end,
        keyKind = function() return "tracking" end, devTools = dev,
        onSettingChanged = function(optionId, on) changed[#changed + 1] = optionId end,
    })
    SettingsPage.openWindow()
    local tag = dev and "with the dev tools" or "without the dev tools"
    check(has("^GENERAL$") and has("^YOUR COLLECTION$") and has("^CARD UPDATES$"), tag .. ": the three panels have headings")
    check(has("^DEVELOPER$") == dev, tag .. ": the Developer panel is there only for the development copy")
    for _, option in ipairs(Settings.options) do
        if not option.hidden and ((option.dev == true) == false or dev) then
            check(has(option.label), tag .. ": a checkbox for '" .. option.label .. "'")
        end
    end
    SettingsPage.refresh()
    check(has("Saved by tracking id") or has("Changes at next login") or has("Saved by character name"),
        tag .. ": the line about how the collection is saved is filled in")
    SettingsPage.closeWindow()
    local left = 0
    for _, obj in ipairs(created) do
        if obj._kind == "GroupBox" and not obj._destroyed then left = left + 1 end
    end
    check(left == 0, tag .. ": the window is gone after closing")
end

if failures == 0 then
    print("OK: the settings window opens, shows its panels and lines, and closes on a stand-in client")
else
    print(failures .. " check(s) failed")
    os.exit(1)
end
