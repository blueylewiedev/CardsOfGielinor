-- kit.lua
-- Small wrapper that builds the plugin's plain controls (text, buttons, the window frame)
-- with PrettyUI when it is installed, and with the built-in ui.* components when it is not.
--
-- Everything else in the plugin calls these functions instead of ui.Text.new / ui.Button.new,
-- so the look of the whole plugin can be changed in this one file. The cards themselves are
-- not built here: they are custom (see cardview.lua).
--
-- PrettyUI is declared as a required dependency in plugin.json, so it should always be there.
-- The fallbacks keep the plugin usable if something goes wrong while it is being set up.

local Kit = {}

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR
local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)

-- Set to false to ignore PrettyUI and use the plain controls everywhere.
Kit.ENABLED = true

-- True when PrettyUI can be used.
function Kit.available()
    return Kit.ENABLED and prettyui ~= nil
end

-- The plain (built-in) versions, also used as the fallback.
local function plainText(parent, x, y, w, h, content, colour)
    local text = ui.Text.new(parent)
    text:SetPos(x, y)
    text:SetSize(w, h)
    text.font = FONT
    text.content = content
    text.colour = colour or WHITE
    text.isShadowed = true
    text:AlignTo(ui.AlignMode.CENTRE, ui.AlignMode.CENTRE)
    return text
end

-- A button built from the client's own components, at a fixed position.
local function plainButton(parent, label, x, y, w, h, onPress)
    local button = ui.Button.new(parent)
    button:SetPos(x, y)
    button:SetSize(w, h)
    button.label = label
    button.stylesheetID = id.StyleSheet.BUTTON_DEFAULT
    button:Subscribe(ui.Hook.ONBUTTONPRESSED, onPress)
    return button
end

-- PrettyUI buttons draw wider than the width they are given (they add side padding), so the
-- width is reduced and the button moved in by this much to keep it inside the box it is given.
local BUTTON_INSET = 12

-- Buttons made by PrettyUI (they are enabled and disabled differently to plain ones).
local prettyButtons = setmetatable({}, { __mode = "k" })

-- PrettyUI takes colours as one packed number, 0xRRGGBBAA (each part 0-255), where the rest of
-- the plugin uses a Vector4 with each part 0-1. This converts one to the other.
local function packColour(v)
    -- Turns a 0-1 colour part into a whole number from 0 to 255.
    local function byte(part)
        return math.max(0, math.min(255, math.floor(part * 255 + 0.5)))
    end
    local r, g, b, a = v.x or v[1], v.y or v[2], v.z or v[3], v.w or v[4]
    return (byte(r) << 24) | (byte(g) << 16) | (byte(b) << 8) | byte(a or 1)
end

-- A line of text at a fixed position.
function Kit.text(parent, x, y, w, h, content, colour)
    if Kit.available() and prettyui.Text ~= nil then
        local ok, text = pcall(prettyui.Text.new, parent, {
            text = "", colour = packColour(colour or WHITE),
            x = x, y = y, width = w, height = h, absolute = true,
        })
        if ok and text ~= nil then
            pcall(function() text:AlignTo(ui.AlignMode.CENTRE, ui.AlignMode.CENTRE) end)
            -- Set the words last: giving them at creation drew the text twice.
            text.content = content
            return text
        end
        log("Kit.text: PrettyUI text failed, using plain text:", tostring(text))
    end
    return plainText(parent, x, y, w, h, content, colour)
end

-- A button at a fixed position. `style` is optional: "positive", "neutral" or "negative"
-- (only PrettyUI buttons show it).
function Kit.button(parent, label, x, y, w, h, onPress, style)
    if Kit.available() and prettyui.FancyButton ~= nil then
        local ok, button = pcall(prettyui.FancyButton.new, parent, label, function() onPress() end, {
            variant = style or "neutral", x = x + BUTTON_INSET, y = y, width = w - 2 * BUTTON_INSET,
            absolute = true,
        })
        if ok and button ~= nil then
            prettyButtons[button] = true
            return button
        end
        log("Kit.button: PrettyUI button failed, using plain button:", tostring(button))
    end
    return plainButton(parent, label, x, y, w, h, onPress)
end

-- A small button with just a picture on it. `sprite` is one of PrettyUI's sprite names, such as
-- "SETTINGS" (a cog), "MENU" or "INFO". Without PrettyUI it becomes a plain button with
-- `fallbackLabel` on it instead.
function Kit.iconButton(parent, sprite, x, y, onPress, tooltip, fallbackLabel, fallbackWidth)
    if Kit.available() and prettyui.SpriteButton ~= nil then
        local ok, button = pcall(prettyui.SpriteButton.new, parent, sprite, function() onPress() end, {
            x = x, y = y, absolute = true, tooltip = tooltip,
        })
        if ok and button ~= nil then
            return button
        end
        log("Kit.iconButton: PrettyUI sprite button failed, using plain button:", tostring(button))
    end
    local w = fallbackWidth or 80
    return plainButton(parent, fallbackLabel or sprite, x - (w - 24), y, w, 26, onPress)
end

-- Enables or greys out a button made by Kit.button.
function Kit.setEnabled(button, enabled)
    if prettyButtons[button] then
        button:SetDisabled(not enabled)
    else
        button.enabled = enabled
    end
end

-- Changes the label of a button made by Kit.button.
function Kit.setLabel(button, label)
    if prettyButtons[button] then
        button:SetText(label)
    else
        button.label = label
    end
end

-- Changes the colour style of a button made by Kit.button ("positive", "neutral", "negative").
-- Plain buttons have no styles, so nothing happens for them.
function Kit.setStyle(button, style)
    if prettyButtons[button] then
        button:SetVariant(style)
    end
end

-- Extra window height the PrettyUI title bar takes, to add to a plain window's height.
function Kit.titleBarHeight()
    return Kit.available() and 40 or 0
end

-- Creates the main window frame. Returns window, content: `content` is the component to put
-- things in. `onClose` is called when the player closes the window with its close button.
-- With PrettyUI the frame has a title bar; without, it is the plain header-less group box.
function Kit.window(parent, title, width, height, onClose, xAnchor, yAnchor)
    xAnchor, yAnchor = xAnchor or 0.2, yAnchor or 0.15
    if Kit.available() and prettyui.Window ~= nil then
        local ok, win = pcall(prettyui.Window.new, parent, {
            title = title, width = width, height = height,
            x = 0, y = 0, xAnchor = xAnchor, yAnchor = yAnchor,
            scrollable = false, onClose = onClose,
        })
        if ok and win ~= nil and win.content ~= nil then
            return win, win.content
        end
        log("Kit.window: PrettyUI window failed, using plain window:", tostring(win))
    end
    local box = ui.GroupBox.new(parent)
    box.stylesheetID = id.StyleSheet.DEFAULT
    box:SetHeaderLayout(0, 0, 0, 0, 0)
    box:SetSize(width, height)
    box:SetPos(0, 0, xAnchor, yAnchor)
    return box, box
end

return Kit
