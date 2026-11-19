-- dev/fakeprettyui.lua
-- A stand-in for PrettyUI for the UI checks (dev/check_*_ui.lua, dev/check_tutorial.lua), which run in desktop Lua with a
-- stand-in for the client's `ui`. The plugin needs PrettyUI (ui/kit.lua has no other way to draw), so the checks give it
-- this: every PrettyUI widget is made from the check's own `ui` components, so a check finds a button by its `label`, a
-- text by its `content` and a drop-down by its `_entries`, and presses them through their `_handlers`, as with the
-- client's components. It draws nothing and checks nothing about looks (that is done in the client).
--
-- Use: after the check has set up its `ui`, `prettyui = require("dev/fakeprettyui")`. It reads the global `ui` when a
-- widget is made, so it can be loaded first.

local Fake = {}

local function place(component, opts)
    pcall(function() component:SetPos(opts.x or 0, opts.y or 0) end)
    if opts.width ~= nil and opts.height ~= nil then
        pcall(function() component:SetSize(opts.width, opts.height) end)
    end
end

-- A button that calls `onPress(self, ...)` when the check fires its ONBUTTONPRESSED handler.
local function button(parent, label, onPress, opts)
    opts = opts or {}
    local b = ui.Button.new(parent)
    b.label = label
    b.tooltip = opts.tooltip
    b.root = b
    place(b, opts)
    b.SetText = function(self, text) self.label = text end
    b.SetDisabled = function(self, disabled) self.enabled = not disabled end
    b.SetVariant = function(self, variant) self.variant = variant end
    b:Subscribe(ui.Hook.ONBUTTONPRESSED, function(...) onPress(b, ...) end)
    return b
end

Fake.Window = { new = function(parent, opts)
    local w = ui.GroupBox.new(parent)
    w.title, w.parent, w.onClose = opts.title, parent, opts.onClose
    w.root = { x = 0, y = 0, width = opts.width or 0, height = opts.height or 0 }
    w.content = ui.Layer.new(w)
    w._RegisterOverlay = function() end
    w._UnregisterOverlay = function() end
    return w
end }

Fake.Text = { new = function(parent, opts)
    local t = ui.Text.new(parent)
    t.content = opts.text
    place(t, opts)
    return t
end }

Fake.FancyButton = { new = function(parent, label, onPress, opts)
    return button(parent, label, function() onPress() end, opts)
end }

Fake.SimpleButton = { new = function(parent, label, onPress, opts)
    local active = false
    local b
    b = button(parent, label, function()
        if opts ~= nil and opts.toggleable then
            active = not active
            onPress(b, active)
        else
            onPress(b)
        end
    end, opts)
    b.SetActive = function(_, value) active = value == true end
    return b
end }

Fake.SpriteButton = { new = function(parent, sprite, onPress, opts)
    return button(parent, sprite, function() onPress() end, opts)
end }

Fake.Spinner = { new = function(parent, opts)
    local s = ui.Layer.new(parent)
    place(s, opts)
    s.Start = function(self) self.turning = true end
    s.Stop = function(self) self.turning = false end
    return s
end }

-- One button per choice; pressing it ticks or clears it and calls onChange(self, choice, value, selected).
Fake.CheckboxButton = { new = function(parent, choices, opts)
    local group = { boxes = {} }
    for i, choice in ipairs(choices) do
        local selected = choice.selected == true
        group.boxes[i] = button(parent, choice.text, function()
            selected = not selected
            opts.onChange(group, choice, choice.value, selected)
        end, { x = opts.x, y = (opts.y or 0) + (i - 1) * 22 })
    end
    group.Destroy = function()
        for _, box in ipairs(group.boxes) do
            pcall(function() box:Destroy() end)
        end
    end
    return group
end }

Fake.Tabs = { new = function(parent, list, opts)
    local tabs = { pages = {}, active = opts.activeIndex or 1 }
    local root = ui.Layer.new(parent)
    for i = 1, #list do
        local content = ui.Layer.new(root)
        tabs.pages[i] = { content = content, SetContentHeight = function() end, ScrollBy = function() end }
    end
    function tabs.GetPage(_, i) return tabs.pages[i] end
    function tabs.GetActiveIndex() return tabs.active end
    function tabs.SetActive(_, i)
        tabs.active = i
        for n, page in ipairs(tabs.pages) do
            page.content.hidden = (n ~= i)
        end
    end
    function tabs.Destroy() pcall(function() root:Destroy() end) end
    tabs:SetActive(tabs.active)
    return tabs
end }

-- A drop-down: the check reads `_entries` ({ label = id }) and fires ONSELECTIONCHANGED with an id.
Fake.ComboBox = { new = function(parent, opts)
    local c = ui.ComboField.new(parent)
    place(c, opts)
    c.SetEntries = function(self, list)
        local byLabel = {}
        for _, entry in ipairs(list) do
            byLabel[entry.label] = entry.id
        end
        self._entries = byLabel
    end
    c.Select = function(self, i) self.selectedID = i end
    c:SetEntries(opts.entries or {})
    c:Subscribe(ui.Hook.ONSELECTIONCHANGED, function(_, entryId) opts.onChange(c, entryId) end)
    return c
end }

Fake.SimpleView = { new = function(parent, opts)
    local v = ui.Layer.new(parent)
    place(v, opts)
    v.content = ui.Layer.new(v)
    v.ScrollBy = function() end
    v.SetContentHeight = function() end
    return v
end }

Fake.Confirm = { new = function(_, opts) opts.onConfirm() end }

return Fake
