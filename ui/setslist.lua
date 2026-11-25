-- ui/setslist.lua
-- The set list of the Sets window (ui/setsviewer.lua): a search box and an NPCs / items drop-down over a tile per set ("3 / 4",
-- gold when complete), with a scroll bar when there are more rows than fit. The sets of a group (a set's `group` in
-- deck/sets.lua) are listed under a heading tile that opens and closes them with a click ("+ Metal armour", with how many of its
-- sets are complete); while a search is typed, every group with a set it finds is open. Every function takes `S`, the window's
-- state (see ui/setsviewer.lua); a change calls S.redraw().

local Cards = require("core/cards")
local Sets = require("core/sets")
local Kit = require("ui/kit")
local Theme = require("ui/theme")
local WHITE, GREY, GOLD, DIM, PANEL_BORDER, SELECTED_BORDER = Theme.WHITE, Theme.GREY, Theme.GOLD, Theme.DIM, Theme.PANEL_BORDER,
    Theme.SELECTED_BORDER
local Util = require("ui/util")
local setHidden = Util.setHidden
local CollectionLayout = require("ui/collectionlayout")
local panel = CollectionLayout.panel
local SetsLayout = require("ui/setslayout")
local LEFT, TOP, LIST_TOP, ROW_H, ROW_STEP, TILE_W = SetsLayout.LEFT, SetsLayout.TOP, SetsLayout.LIST_TOP, SetsLayout.ROW_H,
    SetsLayout.ROW_STEP, SetsLayout.TILE_W
local COLUMN_W, SCROLL_W, FILTER_H, FILTER_STEP = SetsLayout.COLUMN_W, SetsLayout.SCROLL_W, SetsLayout.FILTER_H, SetsLayout.FILTER_STEP

local SetsList = {}

local TILE_BACK = Vector4.new(0.13, 0.12, 0.10, 0.92)
local TILE_DONE_BACK = Vector4.new(0.30, 0.23, 0.07, 0.95)    -- a set the player has every card of
local TILE_DONE_BORDER = Vector4.new(0.85, 0.68, 0.16, 0.95)
local GROUP_BACK = Vector4.new(0.10, 0.20, 0.30, 0.95)       -- a group's heading: slate blue, apart from the sets' brown
local GROUP_BORDER = Vector4.new(0.35, 0.55, 0.75, 0.95)
local GROUP_INDENT = 16       -- how far in a set in a group sits: its tile is narrower, with the group's rail at its left
local RAIL_W = 3
local THUMB_MIN = 24
local SCROLL_BACK = Vector4.new(0.18, 0.16, 0.13, 0.9)
local SCROLL_THUMB = Vector4.new(0.62, 0.52, 0.32, 0.95)

-- True if `set` passes the search and the drop-down. The search finds a set when every word typed is in its name, or
-- every word is in the name of one of its cards ("frog" finds a set with a frog in it), whatever the case.
local function setMatches(S, set)
    local kept = S.kept
    local cards = Sets.cardsOf(set)
    if kept.kindFilter ~= nil then
        local any = false
        for _, card in ipairs(cards) do
            if Cards.kindOf(card) == kept.kindFilter then
                any = true
                break
            end
        end
        if not any then
            return false
        end
    end
    if kept.search == nil then
        return true
    end
    local function hasEveryWord(text)
        text = string.lower(text)
        for word in string.gmatch(string.lower(kept.search), "%S+") do
            if not string.find(text, word, 1, true) then
                return false
            end
        end
        return true
    end
    if hasEveryWord(set.name) or (set.group ~= nil and hasEveryWord(set.group)) then
        return true
    end
    for _, card in ipairs(cards) do
        if hasEveryWord(card.name) then
            return true
        end
    end
    return false
end

-- True if the group's sets are listed: it was opened, or a search is typed (which opens every group it finds a set in).
local function groupOpen(S, group)
    return S.kept.search ~= nil or S.kept.openGroups[group] == true
end

-- Works out the sets the search and the drop-down let through (S.open.shownSets) and the list's rows (S.open.shownRows):
-- { set = a set } or { group = its name, sets = its sets let through }. A group's heading sits where its first set is in
-- deck/sets.lua, with all its sets under it while it is open.
function SetsList.find(S)
    local shown, rows, groups = {}, {}, {}
    for _, set in ipairs(Sets.list) do
        if setMatches(S, set) then
            shown[#shown + 1] = set
            if set.group == nil then
                rows[#rows + 1] = { set = set }
            elseif groups[set.group] == nil then
                groups[set.group] = { group = set.group, sets = { set } }
                rows[#rows + 1] = groups[set.group]
            else
                table.insert(groups[set.group].sets, set)
            end
        end
    end
    local listed = {}
    for _, row in ipairs(rows) do
        listed[#listed + 1] = row
        if row.group ~= nil and groupOpen(S, row.group) then
            for _, set in ipairs(row.sets) do
                listed[#listed + 1] = { set = set }
            end
        end
    end
    S.open.shownSets, S.open.shownRows = shown, listed
end

local function scrollList(S, delta)
    local o, kept = S.open, S.kept
    if o == nil or type(delta) ~= "number" or delta == 0 then
        return
    end
    local most = math.max(0, #o.shownRows - o.layout.listRows)
    local target = math.max(0, math.min(most, kept.listTop + (delta > 0 and 1 or -1)))
    if target ~= kept.listTop then
        kept.listTop = target
        S.redraw()
    end
end

-- A tile `inset` in from the list's left: { root, back, border, name, count }.
local function buildFace(S, y, inset)
    local w = TILE_W - inset
    local face = {}
    face.root, face.back, face.border = panel(S.open.content, LEFT + inset, y, w, ROW_H)
    face.name = Kit.text(face.root, 10, 0, w - 80, ROW_H, "", WHITE, ui.AlignMode.TOPLEFT)
    face.count = Kit.text(face.root, w - 72, 0, 64, ROW_H, "", GREY, ui.AlignMode.CENTRE)
    return face
end

-- Makes the list's tiles once: the set's name, and how many of its cards the player has at the right (or a group's name and
-- how many of its sets are complete). Each row has two tiles, the full width one and one set in for a set in a group (with
-- the group's rail beside it, running down to the next row), and shows the one it needs. An invisible layer on top takes the
-- click and the mouse wheel.
local function buildRows(S)
    local o, kept = S.open, S.kept
    for index = 1, o.layout.listRows do
        local y = LIST_TOP + (index - 1) * ROW_STEP
        local row = { full = buildFace(S, y, 0), inset = buildFace(S, y, GROUP_INDENT) }
        row.rail = ui.Rectangle.new(o.content)
        row.rail:SetPos(LEFT + (GROUP_INDENT - RAIL_W) // 2, y - (ROW_STEP - ROW_H))
        row.rail:SetSize(RAIL_W, ROW_STEP, 0, 0)
        row.rail.fill = true
        row.rail.colour = GROUP_BORDER
        row.grip = ui.Layer.new(o.content)
        row.grip.clickthrough = false
        row.grip:SetPos(LEFT, y)
        row.grip:SetSize(TILE_W, ROW_H, 0, 0)
        Kit.onWheel(row.grip, function(delta) scrollList(S, delta) end)
        row.grip:Subscribe(ui.Hook.ONCLICK, function()
            if row.group ~= nil then
                if kept.search == nil then
                    kept.openGroups[row.group] = not kept.openGroups[row.group] or nil
                    S.redraw()
                end
            elseif row.set ~= nil and row.set.id ~= kept.selectedId then
                kept.selectedId = row.set.id
                kept.page = 1
                S.redraw()
            end
        end)
        o.rows[index] = row
    end
end

-- The scroll bar: a track beside the tiles and a thumb as long as the share of the sets that fit, where the list is.
-- Pressing anywhere on it and dragging moves the thumb with the mouse (the grip stretches over the window while held,
-- as other drags do, so the release is caught wherever the mouse goes); the mouse wheel over it scrolls too.
local function placeThumb(S)
    local o = S.open
    local bar, layout = o.scrollBar, o.layout
    local most = #o.shownRows - layout.listRows
    local thumbH = math.max(THUMB_MIN, math.floor(layout.trackH * layout.listRows / math.max(1, #o.shownRows)))
    local y = LIST_TOP + (most > 0 and math.floor((layout.trackH - thumbH) * S.kept.listTop / most) or 0)
    bar.thumbH = thumbH
    bar.thumb:SetPos(LEFT + COLUMN_W - SCROLL_W, y)
    bar.thumb:SetSize(SCROLL_W, thumbH, 0, 0)
end

local function showScrollBar(S)
    local o = S.open
    local bar = o.scrollBar
    local needed = #o.shownRows > o.layout.listRows
    for _, part in ipairs({ bar.track, bar.thumb, bar.grip }) do
        setHidden(part, not needed)
    end
    if needed then
        placeThumb(S)
    end
end

local function restScrollGrip(S)
    local o = S.open
    o.scrollBar.grip:SetPos(LEFT + COLUMN_W - SCROLL_W - 4, LIST_TOP)
    o.scrollBar.grip:SetSize(SCROLL_W + 8, o.layout.trackH, 0, 0)
end

local function endScrollDrag(S)
    local bar = S.open ~= nil and S.open.scrollBar or nil
    if bar ~= nil and bar.drag ~= nil then
        bar.drag = nil
        restScrollGrip(S)
    end
end

local function buildScrollBar(S)
    local o, kept = S.open, S.kept
    local bar = o.scrollBar
    local x = LEFT + COLUMN_W - SCROLL_W
    bar.track = ui.Rectangle.new(o.content)
    bar.track:SetPos(x, LIST_TOP)
    bar.track:SetSize(SCROLL_W, o.layout.trackH, 0, 0)
    bar.track.fill = true
    bar.track.colour = SCROLL_BACK
    bar.thumb = ui.Rectangle.new(o.content)
    bar.thumb.fill = true
    bar.thumb.colour = SCROLL_THUMB
    local grip = ui.Layer.new(o.content)
    grip.clickthrough = false
    bar.grip = grip
    restScrollGrip(S)
    Kit.onWheel(grip, function(delta) scrollList(S, delta) end)
    grip:Subscribe(ui.Hook.ONCLICK, function()
        local _, y = Kit.mousePosition()
        if y == nil or #o.shownRows <= o.layout.listRows then
            return
        end
        bar.drag = { mouseY = y, fromTop = kept.listTop, held = true, missed = 0 }
        grip:SetPos(0, 0)
        grip:SetSize(0, 0, 1, 1)
        pcall(function() grip:MoveToFront() end)
    end)
    grip:Subscribe(ui.Hook.ONHOLD, function()
        local drag = bar.drag
        local _, y = Kit.mousePosition()
        if drag == nil or y == nil then
            return
        end
        drag.held = true
        -- the thumb moves as far as the mouse has: a track's worth of travel is the whole list
        local most = #o.shownRows - o.layout.listRows
        local travel = math.max(1, o.layout.trackH - (bar.thumbH or THUMB_MIN))
        local target = math.max(0, math.min(most, math.floor(drag.fromTop + (y - drag.mouseY) * most / travel + 0.5)))
        if target ~= kept.listTop then
            kept.listTop = target
            S.redraw()
        end
    end)
    grip:Subscribe(ui.Hook.ONRELEASE, function() endScrollDrag(S) end)
end

-- Makes the tiles and the scroll bar, once, when the window opens, with the group of the set shown open.
function SetsList.build(S)
    local selected = S.kept.selectedId ~= nil and Sets.byId[S.kept.selectedId] or nil
    if selected ~= nil and selected.group ~= nil then
        S.kept.openGroups[selected.group] = true
    end
    buildRows(S)
    buildScrollBar(S)
end

-- Called with every tick: a drag of the scroll bar whose holds have stopped coming for a few ticks lost its release.
function SetsList.tick(S)
    local drag = S.open.scrollBar.drag
    if drag ~= nil then
        drag.missed = drag.held and 0 or drag.missed + 1
        drag.held = false
        if drag.missed >= 3 then
            endScrollDrag(S)
        end
    end
end

-- Fills a tile: its label, "have / total" (gold when complete), and its border (the picked one's when `selected`).
local function paintFace(face, label, have, total, selected, back, border)
    local done = total > 0 and have == total
    face.name.content = label
    face.name.colour = done and GOLD or WHITE
    face.count.content = have .. " / " .. total
    face.count.colour = done and GOLD or (have > 0 and WHITE or DIM)
    face.back.colour = done and TILE_DONE_BACK or back
    face.border.colour = selected and SELECTED_BORDER or (done and TILE_DONE_BORDER or border)
    face.border.outlineThickness = selected and 2 or 1
end

-- A group's heading tile: "+ name" (closed) or "- name" (open), and how many of its sets are complete; its border is the
-- picked one's while the set shown is in it and it is closed.
local function showGroup(S, face, entry, state, ownedIds)
    local complete = 0
    local holdsSelected = false
    for _, set in ipairs(entry.sets) do
        local progress = Sets.progress(state, set, ownedIds)
        if progress.cards > 0 and progress.owned == progress.cards then
            complete = complete + 1
        end
        holdsSelected = holdsSelected or set.id == S.kept.selectedId
    end
    local open = groupOpen(S, entry.group)
    paintFace(face, (open and "- " or "+ ") .. entry.group, complete, #entry.sets, holdsSelected and not open,
        GROUP_BACK, GROUP_BORDER)
end

-- Fills the tiles with the rows from the scrolled place, and shows or hides the scroll bar.
function SetsList.show(S, state, ownedIds)
    local o, kept = S.open, S.kept
    for index, row in ipairs(o.rows) do
        local entry = o.shownRows[kept.listTop + index]
        local set = entry ~= nil and entry.set or nil
        row.set, row.group = set, entry ~= nil and entry.group or nil
        local inGroup = set ~= nil and set.group ~= nil
        local face = inGroup and row.inset or row.full
        setHidden(row.full.root, entry == nil or inGroup)
        setHidden(row.inset.root, not inGroup)
        setHidden(row.rail, not inGroup)
        setHidden(row.grip, entry == nil)
        if row.group ~= nil then
            showGroup(S, face, entry, state, ownedIds)
        elseif set ~= nil then
            local progress = Sets.progress(state, set, ownedIds)
            paintFace(face, set.name, progress.owned, progress.cards, set.id == kept.selectedId, TILE_BACK, PANEL_BORDER)
        end
    end
    showScrollBar(S)
end

-- The search and the drop-down, made after the list so the drop-down's list is drawn over it. A change picks the
-- first set they let through if the one shown is left out.
function SetsList.buildFilter(S)
    local o, kept = S.open, S.kept
    local function afterFilter()
        kept.listTop = 0
        SetsList.find(S)
        local keptSet = false
        for _, set in ipairs(o.shownSets) do
            keptSet = keptSet or set.id == kept.selectedId
        end
        if not keptSet and o.shownSets[1] ~= nil then
            kept.selectedId, kept.page = o.shownSets[1].id, 1
        end
        S.redraw()
    end
    o.widgets.search = Kit.inputField(o.content, LEFT, TOP, COLUMN_W, FILTER_H, 40, false)
    o.widgets.search.content = kept.search or ""
    o.widgets.search:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        local text = o.widgets.search.content
        kept.search = (text ~= nil and string.find(text, "%S") ~= nil) and text or nil
        afterFilter()
    end)
    Kit.dropdown(o.content, LEFT, TOP + FILTER_STEP, COLUMN_W, FILTER_H, {
        { label = "NPCs and items", value = "any" }, { label = "NPCs", value = "npc" }, { label = "Items", value = "item" } },
        kept.kindFilter or "any", function(value)
            kept.kindFilter = (value ~= "any") and value or nil
            afterFilter()
        end)
end

return SetsList
