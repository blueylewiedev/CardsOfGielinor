-- tagpicker.lua
-- Developer-only: a window for choosing a card's tags from the words that are allowed (the lists in
-- Cards.tagWords), so nobody has to type them or remember them. There is a page (tab) for each
-- kind of tag: location, skills and category. Click a word to add it to the card; click it again
-- to take it off. Words on the card already show as pressed in. The Filter box narrows the words
-- on every page.
--
-- The window does not know about the card. The Card Builder gives it a target with
-- TagPicker.setTarget { words = function(kind) -> the words now on the card (a list),
-- toggle = function(kind, word, on) -> add or remove one, cardKind = function() -> "npc" or "item"
-- (optional, "npc" if left out) }, and calls TagPicker.refresh() when the tag boxes are changed by
-- typing so the buttons agree, and TagPicker.rebuild() when the kind of card changes (an item's
-- category words are not an NPC's, and items have no location).
--
-- A group with a `requires` word (see Cards.itemTagGroups) is only shown while that word is on the
-- card, and its words are taken off the card when the required word is.
--
-- A page holds at most MAX_ROWS rows of words; when there are more (a long list, or the filter
-- is empty), a line at the bottom says so, and typing in the Filter box finds the rest.

local Kit = require("ui/kit")
local Cards = require("core/cards")

local TagPicker = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.7, 0.7, 0.7, 1)
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)

local KINDS = { "location", "skills", "category" }
local TAB_NAMES = { "Location", "Skills", "Category" }
local COLS, COL_W, ROW_H = 3, 190, 32
local MAX_ROWS = 14
local TABS_Y = 40
local TABS_H = 40 + (MAX_ROWS + 1) * ROW_H
local WIDTH = COLS * COL_W + 30
local HEIGHT = TABS_Y + TABS_H + 50

local window, content = nil, nil
local filterField, tabs = nil, nil
local target = nil
local buttons = {}            -- kind -> { word -> the toggle button }
local builtSignature = {}     -- kind -> which groups were open when its page was built
local needsRebuild = false    -- set when a group has opened or closed since a page was built

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

-- True if a group is shown: it has no `requires`, or the word it requires is in `selected`
-- (a set of the words now on the card).
local function groupOpen(group, selected)
    return group.requires == nil or (selected ~= nil and selected[group.requires] == true)
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

-- Builds the contents of one page (used by Kit.tabs). Returns the components it made.
local function buildPage(index, parent, originX, originY)
    local kind = KINDS[index]
    local parts = {}
    buttons[kind] = {}
    local filterText = filterField ~= nil and filterField.content or ""
    if type(filterText) ~= "string" then
        filterText = ""
    end
    local cardKind = targetKind()
    if cardKind == "item" and kind == "location" then
        parts[#parts + 1] = Kit.text(parent, originX + 4, originY, COLS * COL_W, 26,
            "Items are not tagged with a location.", GREY, ui.AlignMode.TOPLEFT)
        return parts
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
            parts[#parts + 1] = toggle.part
        end
    end
    if #entries == 0 then
        parts[#parts + 1] = Kit.text(parent, originX + 4, originY, COLS * COL_W, 26,
            "No words match the filter.", GREY, ui.AlignMode.TOPLEFT)
    elseif hidden > 0 then
        parts[#parts + 1] = Kit.text(parent, originX + 4, originY + MAX_ROWS * ROW_H, COLS * COL_W, 26,
            hidden .. " more words: type in the Filter box to find them.", GREY, ui.AlignMode.TOPLEFT)
    end
    return parts
end

-- Rebuilds every page (after the filter changes).
local function rebuildAll()
    if tabs == nil then
        return
    end
    for index = 1, #KINDS do
        tabs.rebuild(index)
    end
end

-- Rebuilds every page, for when the kind of card has changed.
function TagPicker.rebuild()
    rebuildAll()
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
    if needsRebuild then
        local ok, err = pcall(syncGroups)
        if not ok then
            needsRebuild = false
            log("tag picker: could not update the groups:", tostring(err))
        end
    end
end)

function TagPicker.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Pick tags", WIDTH, HEIGHT + Kit.titleBarHeight(),
        function() TagPicker.hide() end, 0.6, 0.08)
    Kit.text(content, 10, 4, 70, 26, "Filter:", WHITE, ui.AlignMode.TOPLEFT)
    filterField = Kit.inputField(content, 80, 4, 300, 26, 30, false)
    filterField:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        rebuildAll()
    end)
    Kit.text(content, 390, 4, WIDTH - 400, 26, "Click a word to add it; click again to remove it.", GREY,
        ui.AlignMode.TOPLEFT)
    tabs = Kit.tabs(content, 10, TABS_Y, WIDTH - 30, TABS_H, TAB_NAMES, buildPage)
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
