-- ui/kit.lua
-- Small wrapper that builds the plugin's plain controls (text, buttons, the window frame)
-- with PrettyUI when it is installed, and with the built-in ui.* components when it is not.
--
-- Everything else in the plugin calls these functions instead of ui.Text.new / ui.Button.new,
-- so the look of the whole plugin can be changed in this one file. The cards themselves are
-- not built here: they are custom (see ui/cardview.lua).
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
local function plainText(parent, x, y, w, h, content, colour, alignX)
    local text = ui.Text.new(parent)
    text:SetPos(x, y)
    text:SetSize(w, h)
    text.font = FONT
    text.content = content
    text.colour = colour or WHITE
    text.isShadowed = true
    text:AlignTo(alignX or ui.AlignMode.CENTRE, ui.AlignMode.CENTRE)
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

-- A line of text at a fixed position, centred in its box unless `alignX` is another
-- ui.AlignMode (for example ui.AlignMode.TOPLEFT to start at the left edge).
function Kit.text(parent, x, y, w, h, content, colour, alignX)
    if Kit.available() and prettyui.Text ~= nil then
        local ok, text = pcall(prettyui.Text.new, parent, {
            text = "", colour = packColour(colour or WHITE),
            x = x, y = y, width = w, height = h, absolute = true,
        })
        if ok and text ~= nil then
            pcall(function() text:AlignTo(alignX or ui.AlignMode.CENTRE, ui.AlignMode.CENTRE) end)
            -- Set the words last: giving them at creation drew the text twice.
            text.content = content
            return text
        end
        log("Kit.text: PrettyUI text failed, using plain text:", tostring(text))
    end
    return plainText(parent, x, y, w, h, content, colour, alignX)
end

-- A button at a fixed position. `style` is optional: "positive", "neutral" or "negative"
-- (only PrettyUI buttons show it).
function Kit.button(parent, label, x, y, w, h, onPress, style, tooltip)
    if Kit.available() and prettyui.FancyButton ~= nil then
        local ok, button = pcall(prettyui.FancyButton.new, parent, label, function() onPress() end, {
            variant = style or "neutral", x = x + BUTTON_INSET, y = y, width = w - 2 * BUTTON_INSET,
            absolute = true, tooltip = tooltip,
        })
        if ok and button ~= nil then
            prettyButtons[button] = true
            return button
        end
        log("Kit.button: PrettyUI button failed, using plain button:", tostring(button))
    end
    return plainButton(parent, label, x, y, w, h, onPress)
end

-- A button whose visible left edge is `left` and whose visible width is `visibleWidth`. Kit.button
-- takes a box that PrettyUI then shrinks by BUTTON_INSET on each side, which is awkward when
-- buttons are lined up; this does that sum. PrettyUI makes a button at least as wide as its label
-- needs (a label such as "ZOOM +" needs about 146), so choose a width that fits the longest label.
-- `tooltip` (optional) is the text shown when the mouse rests on the button (PrettyUI only).
function Kit.buttonAt(parent, label, left, y, visibleWidth, height, onPress, style, tooltip)
    if Kit.available() and prettyui.FancyButton ~= nil then
        return Kit.button(parent, label, left - BUTTON_INSET, y, visibleWidth + 2 * BUTTON_INSET, height, onPress,
            style, tooltip)
    end
    return Kit.button(parent, label, left, y, visibleWidth, height, onPress, style)
end

-- A plainer, flatter button for small controls such as the +/- nudges (PrettyUI's "simple
-- button"). Unlike Kit.buttonAt it draws exactly the width it is given, with no side padding.
-- Without PrettyUI (or if it fails) it is an ordinary Kit.buttonAt. It cannot be relabelled or
-- greyed out afterwards; use Kit.buttonAt for a button that changes.
function Kit.smallButton(parent, label, left, y, w, h, onPress, tooltip)
    if Kit.available() and prettyui.SimpleButton ~= nil then
        local ok, button = pcall(prettyui.SimpleButton.new, parent, label, function() onPress() end, {
            x = left, y = y, width = w, height = h, absolute = true, tooltip = tooltip,
        })
        if ok and button ~= nil then
            return button
        end
        log("Kit.smallButton: PrettyUI simple button failed, using a normal button:", tostring(button))
    end
    return Kit.buttonAt(parent, label, left, y, w, h, onPress)
end

-- A button that stays pressed in (highlighted) once it is clicked, and lets go when it is
-- clicked again: for choosing words from a list. `active` is whether it starts pressed in, and
-- onToggle(active) is called when the player clicks it. Returns { part = the button,
-- setActive = function(active) } where setActive changes it from code without calling onToggle.
function Kit.toggleButton(parent, label, left, y, w, h, active, onToggle, tooltip)
    local muted = false
    local state = active == true
    if Kit.available() and prettyui.SimpleButton ~= nil then
        local ok, button = pcall(prettyui.SimpleButton.new, parent, label, function(_, isActive)
            if muted then
                return
            end
            if type(isActive) == "boolean" then
                state = isActive
            else
                state = not state
            end
            onToggle(state)
        end, {
            x = left, y = y, width = w, height = h, absolute = true, toggleable = true, tooltip = tooltip,
        })
        if ok and button ~= nil then
            local function setActive(value)
                state = value == true
                muted = true
                pcall(function() button:SetActive(state) end)
                muted = false
            end
            if state then
                setActive(true)
            end
            return { part = button, setActive = setActive }
        end
        log("Kit.toggleButton: PrettyUI simple button failed, using a normal button:", tostring(button))
    end
    -- Fallback: a normal button that turns green while it is on.
    local button = nil
    local function setActive(value)
        state = value == true
        Kit.setStyle(button, state and "positive" or "neutral")
    end
    button = Kit.buttonAt(parent, label, left, y, w, h, function()
        setActive(not state)
        onToggle(state)
    end, state and "positive" or "neutral", tooltip)
    return { part = button, setActive = setActive }
end

-- A drop-down list (PrettyUI's combo box) at x, y, w wide. `labels` is the list of choices,
-- `current` the number of the one showing, and onPick(index) is called when the player picks
-- one. Returns { part = the control, select = function(index) } (select changes the choice
-- from code without calling onPick), or nil when PrettyUI's drop-down is not available, so the
-- caller can build its own. Make it after the other controls so its list opens on top of them.
function Kit.dropdown(parent, x, y, w, labels, current, onPick)
    if not (Kit.available() and prettyui.ComboBox ~= nil) then
        return nil
    end
    local muted = false
    local entries = {}
    for i, label in ipairs(labels) do
        entries[i] = { label = label, id = i }
    end
    local ok, combo = pcall(prettyui.ComboBox.new, parent, {
        entries = entries, selectedID = current, x = x, y = y, width = w, absolute = true,
        onChange = function(_, choice)
            if muted or type(choice) ~= "number" then
                return
            end
            onPick(choice)
        end,
    })
    if not ok or combo == nil then
        log("Kit.dropdown: PrettyUI combo box failed:", tostring(combo))
        return nil
    end
    return {
        part = combo,
        select = function(index)
            muted = true
            pcall(function() combo:Select(index) end)
            muted = false
        end,
    }
end

-- Tabbed pages (PrettyUI's tabs) at x, y, w wide and h tall. `names` is the list of tab titles.
-- `build(index, parent, originX, originY)` makes the contents of one page inside `parent`, with
-- its top-left corner at originX, originY, and returns the list of the components it made (so
-- they can be removed again). Returns { select = function(index),
-- rebuild = function(index), destroy = function() } and calls build for every page at once.
-- If PrettyUI's tabs are not available, a row of buttons does the same job and only the page
-- showing is built.
function Kit.tabs(parent, x, y, w, h, names, build)
    local made = {}
    local function clear(index)
        for _, part in ipairs(made[index] or {}) do
            pcall(function() part:Destroy() end)
        end
        made[index] = nil
    end
    if Kit.available() and prettyui.Tabs ~= nil then
        local tabList = {}
        for i, name in ipairs(names) do
            tabList[i] = { text = name }
        end
        local ok, tabs = pcall(prettyui.Tabs.new, parent, tabList, {
            x = x, y = y, width = w, height = h, absolute = true, activeIndex = 1, scrollable = false,
        })
        if ok and tabs ~= nil then
            local pages = {}
            local complete = true
            for i = 1, #names do
                local okPage, page = pcall(function() return tabs:GetPage(i) end)
                pages[i] = okPage and page ~= nil and (page.content or page) or nil
                if pages[i] == nil then
                    complete = false
                end
            end
            if complete then
                for i = 1, #names do
                    made[i] = build(i, pages[i], 0, 0)
                end
                return {
                    select = function(index) pcall(function() tabs:SetActive(index, false) end) end,
                    rebuild = function(index)
                        clear(index)
                        made[index] = build(index, pages[index], 0, 0)
                    end,
                    destroy = function()
                        for i = 1, #names do clear(i) end
                        pcall(function() tabs:Destroy() end)
                    end,
                }
            end
            pcall(function() tabs:Destroy() end)
        end
        log("Kit.tabs: PrettyUI tabs failed, using a row of buttons:", tostring(tabs))
    end
    -- Fallback: a row of buttons and one page that is rebuilt when the choice changes.
    local active = 1
    local buttons = {}
    local show = nil
    local gap = 6
    local tabW = math.floor((w - gap * (#names - 1)) / #names)
    for i, name in ipairs(names) do
        buttons[i] = Kit.buttonAt(parent, name, x + (i - 1) * (tabW + gap), y, tabW, 30, function() show(i) end,
            i == 1 and "positive" or "neutral")
    end
    show = function(index)
        clear(active)
        active = index
        for i, button in ipairs(buttons) do
            Kit.setStyle(button, i == index and "positive" or "neutral")
        end
        made[index] = build(index, parent, x, y + 40)
    end
    made[1] = build(1, parent, x, y + 40)
    return {
        select = function(index) show(index) end,
        rebuild = function(index)
            if index == active then
                clear(index)
                made[index] = build(index, parent, x, y + 40)
            end
        end,
        destroy = function()
            clear(active)
            for _, button in ipairs(buttons) do
                pcall(function() button:Destroy() end)
            end
        end,
    }
end

-- Asks the player to confirm something with a small pop-up (PrettyUI's confirm dialog), then
-- calls onConfirm(). Without PrettyUI it just calls onConfirm() straight away.
function Kit.confirm(parent, title, body, confirmLabel, onConfirm)
    if Kit.available() and prettyui.Confirm ~= nil then
        local ok, err = pcall(prettyui.Confirm.new, parent, {
            title = title, body = body, confirmLabel = confirmLabel, confirmVariant = "negative",
            onConfirm = function() onConfirm() end,
        })
        if ok then
            return
        end
        log("Kit.confirm: PrettyUI confirm failed, going ahead without asking:", tostring(err))
    end
    onConfirm()
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

-- Colours of the drop-down lists, as 0xRRGGBBAA (the ones rsprite-finder uses, which match
-- the game's own fields).
local DROPDOWN_COLOURS = {
    text = 0xE9E5DDFF, hover = 0x393530F2, selected = 0x4A4640FF, disabled = 0x8B8882FF, caret = 0xFFFFFFFF,
}

-- The two kinds of drop-down behind Kit.dropdown. Each takes the entries numbered 1, 2, ... as
-- { label, id, order } and gives back fill(entries, index), pick(index) and destroy().

-- PrettyUI's ComboBox. It picks its kind when it is made, from the entries it is given then
-- (ordered entries make the ordered kind), so it needs the first entries straight away.
local function prettyDropdown(parent, x, y, w, h, numbered, index, choose)
    local ok, combo = pcall(prettyui.ComboBox.new, parent, {
        x = x, y = y, width = w, height = h, maxVisibleEntries = 12,
        entries = numbered, selectedID = index,
        onChange = function(_, entryId) choose(entryId) end,
    })
    if not ok or combo == nil then
        log("Kit.dropdown: PrettyUI combo box failed, using the plain one:", tostring(combo))
        return nil
    end
    return {
        fill = function(list, i) combo:SetEntries(list, i) end,
        pick = function(i) combo:Select(i, false) end,
        destroy = function() pcall(function() combo:Destroy() end) end,
    }
end

-- The client's own ComboField (sorted by label, no typing).
local function plainDropdown(parent, x, y, w, h, choose)
    local combo = ui.ComboField.new(parent)
    local quiet = false             -- true while the code changes it, so that isn't a choice
    pcall(function() combo.stylesheetID = id.StyleSheet.COMBO_DEFAULT end)
    combo:SetPos(x, y)
    combo:SetSize(w, h)
    pcall(function()
        combo.entryHeight = 20
        combo.dropdownMaxVisibleEntries = 12
        combo.contentMargin = ui.Margin.new(8, 0, 8, 0)
        combo.headerMargin = ui.Margin.new(8, 0, 8, 0)
        combo.entryText.font = id.Font.MUSEO_SANS_11PT_REGULAR
        combo.entryText.rgba = DROPDOWN_COLOURS.text
        combo.entryText.isShadowed = true
        combo.mouseoverForegroundRGBA = DROPDOWN_COLOURS.text
        combo.mouseoverBackgroundRGBA = DROPDOWN_COLOURS.hover
        combo.selectedForegroundRGBA = DROPDOWN_COLOURS.text
        combo.selectedBackgroundRGBA = DROPDOWN_COLOURS.selected
        combo.disabledForegroundRGBA = DROPDOWN_COLOURS.disabled
        combo.selectionHighlightRGBA = DROPDOWN_COLOURS.selected
        combo.caretRGBA = DROPDOWN_COLOURS.caret
        combo.errorCaretRGBA = DROPDOWN_COLOURS.caret
    end)
    combo:Subscribe(ui.Hook.ONSELECTIONCHANGED, function(_, entryId)
        if not quiet then
            local ok, i = pcall(function() return combo.hasSelection and combo.selectedID or entryId end)
            choose(ok and i or entryId)
        end
    end)
    return {
        fill = function(list, i)
            local byLabel = {}
            for _, entry in ipairs(list) do
                byLabel[entry.label] = entry.id
            end
            quiet = true
            local ok, err = pcall(function() combo:SetEntries(byLabel, i) end)
            quiet = false
            assert(ok, err)
        end,
        pick = function(i)
            quiet = true
            pcall(function() combo:Select(i, false) end)
            quiet = false
        end,
        destroy = function() pcall(function() combo:Destroy() end) end,
    }
end

-- A drop-down list. `entries` is a list of { label = "...", value = anything }; the labels must
-- all be different. `selected` is the value shown at first (or nil). `onChoose(value)` is called
-- when the player picks an entry. Returns { set(entries, selected), select(value), destroy() }:
-- set replaces the list, select shows a choice; neither calls onChoose.
-- With PrettyUI it is PrettyUI's ComboBox. By default it is given the entries in order, which
-- makes it PrettyUI's ordered kind: it keeps the order given, but it has a text box, so the
-- player can type in it to filter the list. `sorted` = true gives the plain kind instead: the
-- client's own list, which can't be typed in but shows the entries sorted by label.
-- Without PrettyUI it is the client's ComboField (sorted, no typing).
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
    local function choose(entryId)
        local value = dropdown.values[entryId]
        if value ~= nil then
            onChoose(value)
        end
    end

    entries = entries or {}
    local backend = nil
    if Kit.available() and prettyui.ComboBox ~= nil then
        -- An empty ordered list starts with a placeholder (which does nothing when picked), so
        -- PrettyUI still makes the ordered kind.
        local first = (#entries > 0 or sorted) and entries or { { label = "...", value = nil } }
        local numbered = number(first)
        backend = prettyDropdown(parent, x, y, w, h, numbered, indexOf(selected), choose)
    end

    function dropdown.set(list, value)
        local ok, err = pcall(backend.fill, number(list), indexOf(value))
        if not ok then
            log("Kit.dropdown: could not fill the list:", tostring(err))
        end
    end
    function dropdown.select(value)
        local i = indexOf(value)
        if i ~= nil then
            pcall(backend.pick, i)
        end
    end
    function dropdown.destroy()
        backend.destroy()
    end

    if backend == nil then
        backend = plainDropdown(parent, x, y, w, h, choose)
        dropdown.set(entries, selected)
    end
    return dropdown
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
-- `scrollable` (PrettyUI only) lets the content be longer than the window and scroll.
-- `resizable` (PrettyUI only) lets the player drag the window's edge to change its size. The
-- contents keep their positions, so it only gives more or less room.
-- PrettyUI windows can be dragged by their title bar.
function Kit.window(parent, title, width, height, onClose, xAnchor, yAnchor, scrollable, resizable)
    xAnchor, yAnchor = xAnchor or 0.2, yAnchor or 0.15
    if Kit.available() and prettyui.Window ~= nil then
        local ok, win = pcall(prettyui.Window.new, parent, {
            title = title, width = width, height = height,
            x = 0, y = 0, xAnchor = xAnchor, yAnchor = yAnchor,
            scrollable = scrollable == true, resizable = resizable == true, onClose = onClose,
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
