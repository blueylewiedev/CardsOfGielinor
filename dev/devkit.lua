-- dev/devkit.lua
-- Controls only the development tools use (the Card Builder, the tag picker, Wiki Fetch and Wiki Review), kept out of
-- ui/kit.lua so the released plugin does not carry them. Built with PrettyUI, like ui/kit.lua. Not in the release.

local DevKit = {}

-- A button that stays pressed in (highlighted) once it is clicked, and lets go when it is
-- clicked again: for choosing words from a list. `active` is whether it starts pressed in, and
-- onToggle(active) is called when the player clicks it. Returns { part = the button,
-- setActive = function(active) } where setActive changes it from code without calling onToggle.
function DevKit.toggleButton(parent, label, left, y, w, h, active, onToggle, tooltip)
    local muted = false
    local state = active == true
    local button = prettyui.SimpleButton.new(parent, label, function(_, isActive)
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

-- Tabbed pages (PrettyUI's tabs) at x, y, w wide and h tall. `names` is the list of tab titles.
-- `build(index, parent, originX, originY)` makes the contents of one page inside `parent`, with
-- its top-left corner at originX, originY, and returns the list of the components it made (so
-- they can be removed again). Calls build for every page at once. Returns { select = function(index),
-- rebuild = function(index), scrollBy = function(index, delta), destroy = function() }.
-- With `pageHeight`, the pages scroll (with the mouse wheel too) when their contents are taller
-- than the tabs. `pageHeight` is the contents' height until `build` says otherwise: it can return
-- the height its page really needs as a second value, so a short page shows no scrollbar. Without
-- `pageHeight` the pages do not scroll. scrollBy(index, delta) scrolls a page (delta above 0 scrolls down).
function DevKit.tabs(parent, x, y, w, h, names, build, pageHeight)
    local made = {}
    local function clear(index)
        for _, part in ipairs(made[index] or {}) do
            pcall(function() part:Destroy() end)
        end
        made[index] = nil
    end
    local tabList = {}
    for i, name in ipairs(names) do
        tabList[i] = { text = name }
    end
    local tabs = prettyui.Tabs.new(parent, tabList, {
        x = x, y = y, width = w, height = h, absolute = true, activeIndex = 1,
        scrollable = pageHeight ~= nil, contentHeight = pageHeight,
    })
    local pageObjects, pages = {}, {}
    for i = 1, #names do
        pageObjects[i] = tabs:GetPage(i)
        pages[i] = pageObjects[i].content or pageObjects[i]
    end
    -- Builds a page and tells PrettyUI how tall its contents are.
    local function buildPage(index)
        local parts, height = build(index, pages[index], 0, 0)
        height = height or pageHeight
        if height ~= nil then
            pcall(function() pageObjects[index]:SetContentHeight(height) end)
        end
        made[index] = parts
    end
    for i = 1, #names do
        buildPage(i)
    end
    return {
        select = function(index) pcall(function() tabs:SetActive(index, false) end) end,
        rebuild = function(index)
            clear(index)
            buildPage(index)
        end,
        scrollBy = function(index, delta)
            if type(delta) == "number" and delta ~= 0 then
                pcall(function() pageObjects[index]:ScrollBy(delta > 0 and 64 or -64) end)
            end
        end,
        destroy = function()
            for i = 1, #names do clear(i) end
            pcall(function() tabs:Destroy() end)
        end,
    }
end

-- Asks the player to confirm something with a small pop-up (PrettyUI's confirm dialog), then calls onConfirm().
function DevKit.confirm(parent, title, body, confirmLabel, onConfirm)
    prettyui.Confirm.new(parent, {
        title = title, body = body, confirmLabel = confirmLabel, confirmVariant = "negative",
        onConfirm = function() onConfirm() end,
    })
end

return DevKit
