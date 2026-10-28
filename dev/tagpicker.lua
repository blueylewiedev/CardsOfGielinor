-- tagpicker.lua
-- Developer-only: a window for choosing a card's tags from the words that are allowed (the lists in
-- Cards.tagWords), so nobody has to type them or remember them. There is a page (tab) for each
-- kind of tag: region (items only), location, skills and category. Click a word to add it to the card; click it again
-- to take it off. Words on the card already show as pressed in. The Filter box narrows the words
-- on every page.
--
-- The window does not know about the card. The Card Builder gives it a target with
-- TagPicker.setTarget { words = function(kind) -> the words now on the card (a list),
-- toggle = function(kind, word, on) -> add or remove one, cardKind = function() -> "npc" or "item"
-- (optional, "npc" if left out) }, and calls TagPicker.refresh() when the tag boxes are changed by
-- typing so the buttons agree, and TagPicker.rebuild() when the kind of card changes (an item's
-- category words are not an NPC's, items have no location and only items pick a region).
--
-- A group with a `requires` word (see Cards.itemTagGroups) is only shown while that word is on the
-- card, and its words are taken off the card when the required word is.
--
-- The pages are as tall as the longest one needs (with every group open). If that is taller than
-- MAX_VISIBLE_H the page scrolls, and the Filter box narrows the words down.

local Kit = require("ui/kit")
local Cards = require("core/cards")

local TagPicker = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.7, 0.7, 0.7, 1)
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)

local KINDS = { "regions", "location", "skills", "category" }
local TAB_NAMES = { "Region", "Location", "Skills", "Category" }
local COLS, COL_W, ROW_H = 3, 190, 32
local MAX_ROWS = 80               -- a page never gets this long; it is only a safety stop
local TABS_Y = 62              -- below the Filter box and the line of instructions
local TAB_HEADER_H = 40           -- the row of tab titles
local WIDTH = COLS * COL_W + 30
local MAX_VISIBLE_H = 640         -- taller than this and the page scrolls

local window, content = nil, nil
local filterField, tabs = nil, nil
local target = nil
local buttons = {}            -- kind -> { word -> the toggle button }
local builtSignature = {}     -- kind -> which groups were open when its page was built
local needsRebuild = false    -- set when a group has opened or closed since a page was built
local builtLayout = {}       -- kind -> what its page shows, so a rebuild that would change nothing is skipped
local filterWait = nil        -- frames left before the Filter box's new text is applied (nil if none)
local FILTER_FRAMES = 20      -- typing is applied this many frames after the last key

-- Every component uses one of the client's 4096 dynamic IDs, so this counts what the picker has
-- made, to show in the log if the IDs ever run out.
local builtTotal = 0

-- Lets the Card Builder say which card the picker works on. Pass nil to remove it.
function TagPicker.setTarget(newTarget)
    target = newTarget
end

-- The words for a kind, as a list of groups { title = text or nil, words = list }. `cardKind` is
-- the kind of card being tagged ("npc", the default, or "item").
function TagPicker.groups(kind, cardKind)
    local grouped = Cards.tagGroupsFor(cardKind, kind)
    if grouped ~= nil then
        return grouped
    end
    return { { words = Cards.wordsFor(cardKind, kind) or {} } }
end

-- The kind of card the target is tagging.
local function targetKind()
    if target ~= nil and target.cardKind ~= nil then
        return target.cardKind()
    end
    return "npc"
end

-- Lower case, nothing but letters and digits, so "quest giver" finds quest_giver.
local function simplify(text)
    return (string.gsub(string.lower(tostring(text or "")), "[^%w]", ""))
end

-- True if `word` is on the list of the words that suit the filter text.
function TagPicker.matchesFilter(word, filterText)
    local wanted = simplify(filterText)
    return wanted == "" or string.find(simplify(word), wanted, 1, true) ~= nil
end

-- True if a group is shown: it has no `requires`, or a word it requires is in `selected`
-- (a set of the words now on the card).
local function groupOpen(group, selected)
    if group.requires == nil then
        return true
    end
    if selected == nil then
        return false
    end
    if type(group.requires) == "table" then       -- any one of several words will do
        for _, word in ipairs(group.requires) do
            if selected[word] == true then
                return true
            end
        end
        return false
    end
    return selected[group.requires] == true
end

-- Which of a kind's groups are open, as a string like "10", to tell when a page needs rebuilding.
local function openSignature(kind, cardKind, selected)
    local parts = {}
    for _, group in ipairs(TagPicker.groups(kind, cardKind)) do
        parts[#parts + 1] = groupOpen(group, selected) and "1" or "0"
    end
    return table.concat(parts)
end

-- The layout of one page: a list of entries { heading = text } or { word = w, col = c, row = r }
-- and how many words did not fit. `selected` is the set of words now on the card, which opens the
-- groups that need one of them. Pure, so it can be tested without the client.
function TagPicker.layout(kind, filterText, cardKind, selected)
    local entries = {}
    local row, col = 0, 0
    local hidden = 0
    for _, group in ipairs(TagPicker.groups(kind, cardKind)) do
        local shown = {}
        for _, word in ipairs(group.words) do
            if groupOpen(group, selected) and TagPicker.matchesFilter(word, filterText) then
                shown[#shown + 1] = word
            end
        end
        if #shown > 0 then
            if group.title ~= nil then
                if col > 0 then
                    row, col = row + 1, 0
                end
                if row < MAX_ROWS then
                    entries[#entries + 1] = { heading = group.title, row = row }
                end
                row = row + 1
            end
            for _, word in ipairs(shown) do
                if row < MAX_ROWS then
                    entries[#entries + 1] = { word = word, col = col, row = row }
                else
                    hidden = hidden + 1
                end
                col = col + 1
                if col >= COLS then
                    row, col = row + 1, 0
                end
            end
        end
    end
    return entries, hidden
end

local function chosen(kind)
    local set = {}
    if target ~= nil then
        for _, word in ipairs(target.words(kind) or {}) do
            set[word] = true
        end
    end
    return set
end

-- A short text that is the same for two pages that look the same.
local function layoutSignature(kind, filterText, cardKind, selected)
    if cardKind == "item" and kind == "location" then
        return "no location"
    end
    if cardKind ~= "item" and kind == "regions" then
        return "no regions"
    end
    local entries, hidden = TagPicker.layout(kind, filterText, cardKind, selected)
    local parts = { hidden }
    for _, entry in ipairs(entries) do
        parts[#parts + 1] = (entry.heading or entry.word) .. "@" .. entry.row .. "," .. (entry.col or "")
    end
    return table.concat(parts, "|")
end

local function currentFilter()
    local text = filterField ~= nil and filterField.content or ""
    return type(text) == "string" and text or ""
end

-- Builds the contents of one page (used by Kit.tabs). Returns the components it made and how tall
-- the page is.
local function buildPage(index, parent, originX, originY)
    local kind = KINDS[index]
    local parts = {}
    buttons[kind] = {}
    local filterText = filterField ~= nil and filterField.content or ""
    if type(filterText) ~= "string" then
        filterText = ""
    end
    local cardKind = targetKind()
    builtLayout[kind] = layoutSignature(kind, filterText, cardKind, chosen(kind))
    if cardKind == "item" and kind == "location" then
        parts[#parts + 1] = Kit.text(parent, originX + 4, originY, COLS * COL_W, 26,
            "Items are not tagged with a location.", GREY, ui.AlignMode.TOPLEFT)
        builtTotal = builtTotal + #parts
        return parts, ROW_H
    end
    if cardKind ~= "item" and kind == "regions" then
        parts[#parts + 1] = Kit.text(parent, originX + 4, originY, COLS * COL_W, 26,
            "An NPC's region comes from its deck file.", GREY, ui.AlignMode.TOPLEFT)
        builtTotal = builtTotal + #parts
        return parts, ROW_H
    end
    local selected = chosen(kind)
    builtSignature[kind] = openSignature(kind, cardKind, selected)
    local entries, hidden = TagPicker.layout(kind, filterText, cardKind, selected)
    for _, entry in ipairs(entries) do
        if entry.heading ~= nil then
            parts[#parts + 1] = Kit.text(parent, originX + 4, originY + entry.row * ROW_H, COLS * COL_W, 26,
                entry.heading, GOLD, ui.AlignMode.TOPLEFT)
        else
            local word = entry.word
            local toggle = Kit.toggleButton(parent, word, originX + entry.col * COL_W, originY + entry.row * ROW_H,
                COL_W - 8, 28, selected[word] == true, function(on)
                    if target ~= nil then
                        target.toggle(kind, word, on)
                    end
                    TagPicker.refresh()
                end)
            buttons[kind][word] = toggle
            -- A hand-placed button does not pass the mouse wheel on to the page, so it does.
            Kit.onWheel(toggle.part, function(delta)
                if tabs ~= nil then
                    tabs.scrollBy(index, delta)
                end
            end)
            parts[#parts + 1] = toggle.part
        end
    end
    local rows = 1
    for _, entry in ipairs(entries) do
        rows = math.max(rows, entry.row + 1)
    end
    if #entries == 0 then
        parts[#parts + 1] = Kit.text(parent, originX + 4, originY, COLS * COL_W, 26,
            "No words match the filter.", GREY, ui.AlignMode.TOPLEFT)
    elseif hidden > 0 then
        parts[#parts + 1] = Kit.text(parent, originX + 4, originY + MAX_ROWS * ROW_H, COLS * COL_W, 26,
            hidden .. " more words: type in the Filter box to find them.", GREY, ui.AlignMode.TOPLEFT)
        rows = MAX_ROWS + 1
    end
    -- How tall this page really is, so the scrollbar only shows when its words do not fit.
    builtTotal = builtTotal + #parts
    return parts, rows * ROW_H
end

-- Rebuilds the pages whose words have changed (after the filter changes), or every page with
-- `force`. A page that would look the same is left alone: rebuilding makes and destroys all of
-- its buttons.
local function rebuildAll(force)
    if tabs == nil then
        return
    end
    local filterText, cardKind = currentFilter(), targetKind()
    for index, kind in ipairs(KINDS) do
        if force or builtLayout[kind] ~= layoutSignature(kind, filterText, cardKind, chosen(kind)) then
            tabs.rebuild(index)
        end
    end
end

-- Rebuilds every page, for when the kind of card has changed.
function TagPicker.rebuild()
    filterWait = nil
    rebuildAll(true)
end

-- Makes the buttons show the words that are on the card now. If that opens or closes a group
-- (such as "equipable" opening the worn-or-wielded words), the page is rebuilt on the next frame,
-- not here, as this can be called from the button that is being pressed.
function TagPicker.refresh()
    for _, kind in ipairs(KINDS) do
        local selected = chosen(kind)
        for word, toggle in pairs(buttons[kind] or {}) do
            toggle.setActive(selected[word] == true)
        end
        if builtSignature[kind] ~= nil and builtSignature[kind] ~= openSignature(kind, targetKind(), selected) then
            needsRebuild = true
        end
    end
end

-- Rebuilds the pages whose groups opened or closed. A word from a group that has just closed is
-- taken off the card, as it could no longer be seen or taken off in the picker.
local function syncGroups()
    needsRebuild = false
    if tabs == nil then
        return
    end
    local cardKind = targetKind()
    for index, kind in ipairs(KINDS) do
        -- Taking words off can close more groups (turning "equipable" off takes "weapon" off, which
        -- closes the weapon types), so go on until nothing more comes off.
        local removed, passes = true, 0
        while removed and target ~= nil and passes < 5 do
            removed = false
            passes = passes + 1
            local selected = chosen(kind)
            for _, group in ipairs(TagPicker.groups(kind, cardKind)) do
                if not groupOpen(group, selected) then
                    for _, word in ipairs(group.words) do
                        if selected[word] then
                            target.toggle(kind, word, false)
                            removed = true
                        end
                    end
                end
            end
        end
        if builtSignature[kind] ~= nil and builtSignature[kind] ~= openSignature(kind, cardKind, chosen(kind)) then
            tabs.rebuild(index)
        end
    end
end
Event.Draw.Subscribe("cardcollector_tagpicker", function()
    if filterWait ~= nil then
        filterWait = filterWait - 1
        if filterWait <= 0 then
            filterWait = nil
            local ok, err = pcall(rebuildAll)
            if not ok then
                log("tag picker: could not apply the filter:", tostring(err))
            end
        end
    end
    if needsRebuild then
        local ok, err = pcall(syncGroups)
        if not ok then
            needsRebuild = false
            log("tag picker: could not update the groups:", tostring(err))
        end
    end
end)

-- How many rows the tallest page needs, for any kind of card with every group open, so a page
-- never has to cut words off.
local ALL_OPEN = setmetatable({}, { __index = function() return true end })
local function tallestPage()
    local tallest = 1
    for _, cardKind in ipairs({ "npc", "item" }) do
        for _, kind in ipairs(KINDS) do
            for _, entry in ipairs((TagPicker.layout(kind, "", cardKind, ALL_OPEN))) do
                tallest = math.max(tallest, entry.row + 1)
            end
        end
    end
    return tallest
end

function TagPicker.show()
    if window ~= nil then
        return
    end
    -- Each page is as tall as the longest one needs. The tabs are shorter than that if they have
    -- to be, and then the page scrolls inside them (PrettyUI tab pages scroll with the mouse wheel;
    -- the window itself stays a fixed size).
    log("tag picker: opened;", builtTotal, "components built so far")
    local pageHeight = (tallestPage() + 1) * ROW_H + 10
    local tabsHeight = math.min(TAB_HEADER_H + pageHeight, MAX_VISIBLE_H - TABS_Y - 50)
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Pick tags", WIDTH, TABS_Y + tabsHeight + 50 + Kit.titleBarHeight(),
        function() TagPicker.hide() end, 0.6, 0.08)
    Kit.text(content, 10, 4, 70, 26, "Filter:", WHITE, ui.AlignMode.TOPLEFT)
    filterField = Kit.inputField(content, 80, 4, 300, 26, 30, false)
    -- Wait until the typing stops, so a word typed letter by letter rebuilds the pages once.
    filterField:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        filterWait = FILTER_FRAMES
    end)
    Kit.text(content, 10, 34, WIDTH - 20, 22, "Click a word to add it; click again to remove it.", GREY,
        ui.AlignMode.TOPLEFT)
    tabs = Kit.tabs(content, 10, TABS_Y, WIDTH - 30, tabsHeight, TAB_NAMES, buildPage, pageHeight)
end

function TagPicker.hide()
    if tabs ~= nil then
        tabs.destroy()
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, filterField, tabs = nil, nil, nil, nil
    buttons = {}
    builtSignature = {}
    builtLayout = {}
    filterWait = nil
    needsRebuild = false
end

function TagPicker.isOpen()
    return window ~= nil
end

function TagPicker.toggle()
    if window ~= nil then
        TagPicker.hide()
    else
        TagPicker.show()
    end
end

return TagPicker
