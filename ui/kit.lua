-- ui/kit.lua
-- The plugin's controls (text, buttons, the window frame, drop-downs, tabs), built with PrettyUI. Everything else
-- calls these instead of PrettyUI, so the look of the plugin can be changed here. PrettyUI is a required dependency,
-- so there is no fallback to the client's own components. The cards are custom: ui/cardview.lua.

local Logger = require("core/logger")

local Kit = {}

local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)

-- Buttons made by Kit.buttonAt (PrettyUI's FancyButton: they are relabelled and greyed out with its own methods).
local fancyButtons = setmetatable({}, { __mode = "k" })

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

-- A line of text at a fixed position, centred in its box unless `alignX` is another ui.AlignMode (for example
-- ui.AlignMode.TOPLEFT to start at the left edge).
function Kit.text(parent, x, y, w, h, content, colour, alignX)
    local text = prettyui.Text.new(parent, {
        text = "", colour = packColour(colour or WHITE),
        x = x, y = y, width = w, height = h, absolute = true, categoryID = "auto",
    })
    pcall(function() text:AlignTo(alignX or ui.AlignMode.CENTRE, ui.AlignMode.CENTRE) end)
    -- Set the words last: giving them at creation drew the text twice.
    text.content = content
    return text
end

-- PrettyUI's spinning loading wheel, `size` across, at a fixed position. It is not turning until its Start() is
-- called, and keeps a subscription to the logic tick while it turns, so call Stop() when it is hidden or the window
-- goes.
function Kit.spinner(parent, x, y, size)
    return prettyui.Spinner.new(parent, { x = x, y = y, size = size, autoPlay = false, categoryID = "auto" })
end

-- A button whose visible left edge is `left` and whose visible width is `visibleWidth`; `style` is "positive",
-- "neutral" or "negative". PrettyUI makes a button at least as wide as its label needs (about 146 for "ZOOM +"), so
-- choose a width that fits the longest label.
function Kit.buttonAt(parent, label, left, y, visibleWidth, height, onPress, style, tooltip)
    local button = prettyui.FancyButton.new(parent, label, function() onPress() end, {
        variant = style or "neutral", x = left, y = y, width = visibleWidth, absolute = true, tooltip = tooltip,
        categoryID = "auto",
    })
    fancyButtons[button] = true
    return button
end

-- A plainer, flatter button for small controls such as the +/- nudges (PrettyUI's "simple
-- button"). Unlike Kit.buttonAt it draws exactly the width it is given, with no side padding.
-- It cannot be relabelled or greyed out afterwards; use Kit.buttonAt for a button that changes.
function Kit.smallButton(parent, label, left, y, w, h, onPress, tooltip)
    return prettyui.SimpleButton.new(parent, label, function() onPress() end, {
        x = left, y = y, width = w, height = h, absolute = true, tooltip = tooltip, categoryID = "auto",
    })
end

-- Calls onWheel(delta) when the mouse wheel turns over a component (delta above 0 is down). PrettyUI buttons placed
-- by hand do not pass the wheel on to the scrolling page they are in, so a page that scrolls hands it on with this.
function Kit.onWheel(component, onWheel)
    local function handler(first, second)
        local delta = type(second) == "number" and second or (type(first) == "number" and first or 0)
        onWheel(delta)
        return false
    end
    -- PrettyUI does not say which field holds the client component under a button, so try the
    -- button itself and then the likely names.
    for _, field in ipairs({ "", "root", "component", "frame", "button", "part", "view", "box", "container" }) do
        local ok, target = pcall(function()
            if field == "" then
                return component
            end
            return component[field]
        end)
        if ok and target ~= nil and pcall(function() target:Subscribe(ui.Hook.ONSCROLLWHEEL, handler) end) then
            break
        end
    end
end

-- A small button with just a picture on it. `sprite` is one of PrettyUI's sprite names, such as
-- "SETTINGS" (a cog), "MENU" or "INFO".
function Kit.iconButton(parent, sprite, x, y, onPress, tooltip)
    return prettyui.SpriteButton.new(parent, sprite, function() onPress() end, {
        x = x, y = y, absolute = true, tooltip = tooltip, categoryID = "auto",
    })
end

-- How far a title-bar button sits from the window's right edge: the close button (20 wide, 8 in) and a gap, then
-- the button's own width.
local TITLE_BUTTON_RIGHT = 62
local TITLE_BUTTON_STEP = 28       -- the next button along (a second one sits this far further left)
local TITLE_BUTTON_LEFT = 12       -- from the window's left edge, for a button at the left end of the title bar

-- A small icon button (a PrettyUI sprite such as "SWAP") in a window's title bar. `slot` (default 0) is its place: 0
-- next to the close button, 1 the one to its left, "left" the far left end. Returns a handle with Destroy() and
-- `root` (the component the tutorial points at), or nil if it failed (it uses PrettyUI's private overlay calls, which
-- an update could change; the failure is logged). PrettyUI covers the title bar with a layer for dragging the window,
-- so a button made inside the window never gets the click. This one is made on the game's layer and registered with
-- the window as an overlay: the window keeps it on top and puts it back over the title bar when it moves.
function Kit.titleButton(window, spriteName, onPress, tooltip, slot)
    if window == nil or window.parent == nil then
        return nil
    end
    local ok, handle = pcall(function()
        local button = prettyui.SpriteButton.new(window.parent, spriteName, function() onPress() end, {
            x = 0, y = 0, tooltip = tooltip, categoryID = "auto",
        })
        local function place()
            if slot == "left" then
                button.root:SetPos(window.root.x + TITLE_BUTTON_LEFT, window.root.y + 4)
            else
                button.root:SetPos(window.root.x + window.root.width - TITLE_BUTTON_RIGHT - (slot or 0) * TITLE_BUTTON_STEP,
                    window.root.y + 4)
            end
        end
        place()
        window:_RegisterOverlay(button.root, nil, place)
        button.root:MoveToFront()
        return {
            root = button.root,
            Destroy = function()
                pcall(function() window:_UnregisterOverlay(button.root) end)
                pcall(function() button:Destroy() end)
            end,
        }
    end)
    if ok and handle ~= nil then
        return handle
    end
    Logger.error("Kit.titleButton: PrettyUI sprite button failed:", tostring(handle))
    return nil
end

-- A dark panel with a brown border (the same as the credits overlay's) at (x, y), `w` x `h`, in `parent`, with `heading` in
-- gold across its top if there is one. Made before whatever goes on it. The panel is drawn with rectangles (nothing can be put
-- inside a rectangle), so the heading and the rest are made in `parent` after it. Returns the heading text, or nil.
local PANEL_BACK = Vector4.new(0.08, 0.07, 0.06, 0.90)
local PANEL_BORDER = Vector4.new(0.45, 0.36, 0.22, 0.95)
local PANEL_GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
Kit.PANEL_HEADING_H = 26
function Kit.panel(parent, x, y, w, h, heading)
    local back = ui.Rectangle.new(parent)
    back:SetPos(x, y)
    back:SetSize(w, h)
    back.fill = true
    back.colour = PANEL_BACK
    local border = ui.Rectangle.new(parent)
    border:SetPos(x, y)
    border:SetSize(w, h)
    border.fill = false
    border.outlineThickness = 1
    border.colour = PANEL_BORDER
    if heading ~= nil then
        return Kit.text(parent, x, y + 6, w, 20, heading, PANEL_GOLD)
    end
    return nil
end

-- A block of checkboxes, one to a row, at (x, y) and `w` wide. `choices` is { text, value, selected };
-- onChange(value, selected) is called when one is ticked or cleared. PrettyUI cuts a label off where it runs out of
-- width (about 28 letters in 280 pixels). A `step` over Kit.CHECKBOX_ROW_H spaces the rows further apart, each as a
-- checkbox of its own. Returns a handle with Destroy().
Kit.CHECKBOX_ROW_H = 22
function Kit.checkboxes(parent, x, y, w, choices, onChange, step)
    local function changed(_, _, value, selected)
        onChange(value, selected)
    end
    if step == nil or step <= Kit.CHECKBOX_ROW_H then
        return prettyui.CheckboxButton.new(parent, choices, { x = x, y = y, width = w, onChange = changed, categoryID = "auto" })
    end
    local made = {}
    for i, choice in ipairs(choices) do
        made[i] = prettyui.CheckboxButton.new(parent, { choice }, { x = x, y = y + (i - 1) * step, width = w, onChange = changed, categoryID = "auto" })
    end
    return { Destroy = function() for _, box in ipairs(made) do pcall(function() box:Destroy() end) end end }
end

-- PrettyUI's tab strip height: the pages start this far under the top of the tabs.
Kit.TABS_HEIGHT = 42

-- Tab strip: tabs across the top of a box with a page under each. The box is `w` x `h` at (x, y), or with opts.fill
-- the whole of `parent` (following its size). `onChange(i)` is called when the player picks a tab. Returns a handle
-- with pages[i] (the layer to build tab i in; it scrolls when taller than the room), pageWidth(i),
-- setContentHeight(i, h), refresh() (after the box changed size), select(i) and destroy(). opts.contentHeights = {
-- [i] = h }.
function Kit.tabStrip(parent, labels, x, y, w, h, onChange, selected, opts)
    selected = selected or 1
    opts = opts or {}
    local list = {}
    for i, label in ipairs(labels) do
        list[i] = { text = label, value = i, contentHeight = opts.contentHeights and opts.contentHeights[i] or nil }
    end
    local options = {
        x = x, y = y, width = w, height = h, scrollable = true, activeIndex = selected, categoryID = "auto",
        onChange = function(_, index) onChange(index) end,
    }
    if opts.fill then
        options.width, options.height, options.widthAnchor, options.heightAnchor = 0, 0, 1.0, 1.0
    end
    local tabs = prettyui.Tabs.new(parent, list, options)
    local handle = { pages = {} }
    for i = 1, #labels do
        handle.pages[i] = tabs.pages[i].content
    end
    function handle.pageWidth(i)
        local ok, width = pcall(function() return tabs.pages[i].content.width end)
        return ok and type(width) == "number" and width or nil
    end
    function handle.setContentHeight(i, height)
        pcall(function() tabs.pages[i]:SetContentHeight(height) end)
    end
    function handle.refresh()
        pcall(function() tabs:SetActive(tabs:GetActiveIndex(), false) end)
    end
    function handle.select(i) tabs:SetActive(i, false) end
    function handle.destroy() tabs:Destroy() end
    return handle
end

-- A box to type in, at a fixed position. This is the client's own input box (PrettyUI also has
-- a text field, but the plugin relies on the client's box: it can be selected and copied).
-- `numeric` allows only digits. `maxLength` is the most characters it takes.
function Kit.inputField(parent, x, y, w, h, maxLength, numeric)
    local field = ui.InputField.new(parent)
    field:SetPos(x, y)
    field:SetSize(w, h)
    local sheet = id.StyleSheet.INPUT_DEFAULT
    if sheet ~= nil then
        field.stylesheetID = sheet
    end
    field:Setup(ui.TextContentVisibilityMode.VISIBLE,
        numeric and ui.InputFieldFilterMode.NUMERIC or ui.InputFieldFilterMode.NONE, maxLength or 30)
    return field
end

-- A drop-down list (PrettyUI's ComboBox). `entries` is { label, value } with different labels; `selected` is the
-- value shown first; onChoose(value) is called when the player picks one. Returns { set(entries, selected),
-- select(value), destroy() }; neither set nor select calls onChoose. By default the entries keep the order given and
-- the player can type in the box to filter them (PrettyUI's ordered kind, picked when the box is made, so it needs
-- its first entries at once). `sorted` = true gives the plain kind: sorted by label, no typing, and much quicker to
-- open on a long list.
function Kit.dropdown(parent, x, y, w, h, entries, selected, onChoose, sorted)
    local dropdown = { values = {} }    -- entry i has the id i and the value values[i]
    local function number(list)
        local numbered = {}
        dropdown.values = {}
        for i, entry in ipairs(list) do
            numbered[i] = { label = entry.label, id = i, order = (not sorted) and i or nil }
            dropdown.values[i] = entry.value
        end
        return numbered
    end
    local function indexOf(value)
        for i, v in ipairs(dropdown.values) do
            if v == value then
                return i
            end
        end
        return nil
    end

    -- An empty ordered list starts with a placeholder (which does nothing when picked), so PrettyUI still makes the
    -- ordered kind.
    entries = entries or {}
    local first = (#entries > 0 or sorted) and entries or { { label = "...", value = nil } }
    local combo = prettyui.ComboBox.new(parent, {
        x = x, y = y, width = w, height = h, maxVisibleEntries = 12, categoryID = "auto",
        entries = number(first), selectedID = indexOf(selected),
        onChange = function(_, entryId)
            local value = dropdown.values[entryId]
            if value ~= nil then
                onChoose(value)
            end
        end,
    })

    function dropdown.set(list, value)
        local ok, err = pcall(function() combo:SetEntries(number(list), indexOf(value)) end)
        if not ok then
            Logger.error("Kit.dropdown: could not fill the list:", tostring(err))
        end
    end
    function dropdown.select(value)
        local i = indexOf(value)
        if i ~= nil then
            pcall(function() combo:Select(i, false) end)
        end
    end
    function dropdown.destroy()
        pcall(function() combo:Destroy() end)
    end
    return dropdown
end

-- Enables or greys out a button made by Kit.buttonAt.
function Kit.setEnabled(button, enabled)
    if fancyButtons[button] then
        button:SetDisabled(not enabled)
    end
end

-- Changes the label of a button made by Kit.buttonAt.
function Kit.setLabel(button, label)
    if fancyButtons[button] then
        button:SetText(label)
    end
end

-- The mouse's x on the screen, or nil if the client can't say (for dragging).
function Kit.mouseX()
    return (Kit.mousePosition())
end

-- Where the mouse is, as x, y, or nil if the client can't say.
function Kit.mousePosition()
    local ok, x, y = pcall(function()
        if not Mouse.IsAvailable() then
            return nil
        end
        local position = Mouse.GetPosition()
        return position.x, position.y
    end)
    if ok then
        return x, y
    end
    return nil
end

-- Window height PrettyUI's title bar takes, to add to the height of a window's contents.
Kit.TITLE_BAR_H = 40
function Kit.titleBarHeight()
    return Kit.TITLE_BAR_H
end

-- The width there is room for inside a window `width` wide (its frame and padding take the rest).
function Kit.contentWidth(width)
    return width - 44
end

-- Creates a PrettyUI window (a title bar it is dragged by and a close button). Returns window, content (where to put
-- things). `onClose` is called when the player closes it; `scrollable` lets the content be longer; `resizable` lets
-- the player drag its edge (`limits` is { minWidth, minHeight }). `offsetX` and `offsetY` (default 0) move it from
-- its anchor: with the anchors 0 and 1 a negative offsetY puts it that far above the bottom of the screen.
function Kit.window(parent, title, width, height, onClose, xAnchor, yAnchor, scrollable, resizable, limits, offsetX, offsetY)
    local win = prettyui.Window.new(parent, {
        title = title, width = width, height = height,
        x = offsetX or 0, y = offsetY or 0, xAnchor = xAnchor or 0.2, yAnchor = yAnchor or 0.15, categoryID = "auto",
        scrollable = scrollable == true, resizable = resizable == true, onClose = onClose,
        minWidth = limits and limits.minWidth or nil, minHeight = limits and limits.minHeight or nil,
    })
    return win, win.content
end

return Kit
