-- dev/devkit.lua
-- Controls only the development tools use (the Card Builder, the tag picker, Wiki Fetch and Wiki Review), kept out of
-- ui/kit.lua so the released plugin does not carry them. Built with PrettyUI, like ui/kit.lua. Not in the release.

local DevKit = {}

-- A button that stays pressed in once it is clicked, and lets go when it is clicked again: for choosing words from a
-- list. `active` is whether it starts pressed in, and onToggle(active) is called when the player clicks it. Returns
-- { part = the button, setActive = function(active) } where setActive changes it from code without calling onToggle.
-- It is the client's own button, not PrettyUI's: PrettyUI checks every new component against the others, and the tag
-- picker makes a few hundred of these at once, which ran past the client's one-second limit. A pressed-in button says
-- so in its label ("[x] word"); `tooltip` is not shown.
function DevKit.toggleButton(parent, label, left, y, w, h, active, onToggle, tooltip)
    local state = active == true
    local button = ui.Button.new(parent)
    button:SetPos(left, y)
    button:SetSize(w, h)
    button.stylesheetID = id.StyleSheet.BUTTON_DEFAULT
    local function show()
        button.label = state and ("[x] " .. label) or label
    end
    local function setActive(value)
        state = value == true
        pcall(show)
    end
    button:Subscribe(ui.Hook.ONBUTTONPRESSED, function()
        state = not state
        show()
        onToggle(state)
    end)
    show()
    return { part = button, setActive = setActive }
end

-- Tabbed pages (PrettyUI's tabs) at x, y, w wide and h tall. `names` is the list of tab titles.
-- `build(index, parent, originX, originY)` makes the contents of one page inside `parent`, with
-- its top-left corner at originX, originY, and returns the list of the components it made (so
-- they can be removed again). Returns { select = function(index), rebuild = function(index),
-- scrollBy = function(index, delta), destroy = function() }.
-- A page is built only when it is shown (the first at once, the others when their tab is picked): the client stops any
-- call that runs for more than a second, and an NPC card's pages together are about 500 PrettyUI buttons, which took
-- longer than that. For the same reason rebuild(index) rebuilds a page now only if it is the one showing; any other is
-- cleared and built again when it is next shown.
-- With `pageHeight`, the pages scroll (with the mouse wheel too) when their contents are taller
-- than the tabs. `pageHeight` is the contents' height until `build` says otherwise: it can return
-- the height its page really needs as a second value, so a short page shows no scrollbar. Without
-- `pageHeight` the pages do not scroll. scrollBy(index, delta) scrolls a page (delta above 0 scrolls down).
function DevKit.tabs(parent, x, y, w, h, names, build, pageHeight)
    local made = {}                     -- index -> the components a built page made (nil: not built)
    local active = 1
    local pageObjects, pages = {}, {}
    local function clear(index)
        for _, part in ipairs(made[index] or {}) do
            pcall(function() part:Destroy() end)
        end
        made[index] = nil
    end
    -- Builds a page and tells PrettyUI how tall its contents are.
    local function buildPage(index)
        local parts, height = build(index, pages[index], 0, 0)
        height = height or pageHeight
        if height ~= nil then
            pcall(function() pageObjects[index]:SetContentHeight(height) end)
        end
        made[index] = parts or {}
    end
    local function show(index)
        active = index
        if made[index] == nil then
            buildPage(index)
        end
    end
    local tabList = {}
    for i, name in ipairs(names) do
        tabList[i] = { text = name, value = i }       -- (onChange is given the value: the index)
    end
    local tabs = prettyui.Tabs.new(parent, tabList, {
        x = x, y = y, width = w, height = h, absolute = true, activeIndex = 1,
        scrollable = pageHeight ~= nil, contentHeight = pageHeight,
        onChange = function(_, index) show(index) end,
    })
    for i = 1, #names do
        pageObjects[i] = tabs:GetPage(i)
        pages[i] = pageObjects[i].content or pageObjects[i]
    end
    show(1)
    return {
        select = function(index)
            pcall(function() tabs:SetActive(index, false) end)
            show(index)
        end,
        rebuild = function(index)
            local wasBuilt = made[index] ~= nil
            clear(index)
            if wasBuilt and index == active then
                buildPage(index)
            end
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
