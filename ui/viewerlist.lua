-- ui/viewerlist.lua
-- The list view of the collection viewer (ui/viewer.lua): a tile per card (name, rarity, copies) in the first two columns, and
-- the picked card large beside it with what is known about it under that, as chips (clicking a tag chip sets that filter).
-- A card the player does not have shows no picture and no description (the "?" card), only its name, rarity and tags.
-- Every function takes `V`, the viewer's state (see ui/viewer.lua).

local Cards = require("core/cards")
local Browse = require("core/browse")
local CardView = require("ui/cardview")
local Kit = require("ui/kit")
local Theme = require("ui/theme")
local WHITE, GREY, GOLD, DIM, SELECTED_BORDER = Theme.WHITE, Theme.GREY, Theme.GOLD, Theme.DIM, Theme.SELECTED_BORDER
local Util = require("ui/util")
local setHidden, toVec4 = Util.setHidden, Util.toVec4
local CollectionLayout = require("ui/collectionlayout")
local panel = CollectionLayout.panel
local ViewerFilters = require("ui/viewerfilters")
local ViewerLayout = require("ui/viewerlayout")
local LEFT, BODY_Y, ROW_H, ROW_STEP, LIST_W = ViewerLayout.LEFT, ViewerLayout.BODY_Y, ViewerLayout.ROW_H, ViewerLayout.ROW_STEP,
    ViewerLayout.LIST_W
local DETAIL_X, DETAIL_W, tint = ViewerLayout.DETAIL_X, ViewerLayout.DETAIL_W, ViewerLayout.tint

local ViewerList = {}

local CHIP_BACK = Vector4.new(0.18, 0.16, 0.13, 0.95)
local CHIP_BORDER = Vector4.new(0.50, 0.40, 0.24, 0.95)
local CHIP_GOLD_BORDER = Vector4.new(0.85, 0.68, 0.16, 0.95)
local CHIP_ACTIVE_BACK = Vector4.new(0.40, 0.30, 0.10, 0.98)   -- a chip whose filter is on
local CHIP_H, CHIP_STEP = 22, 28       -- a chip, and the distance from one line of chips to the next
local CHIP_GAP = 6                     -- between chips on a line
local CHIP_CHAR_W, CHIP_PAD = 8.5, 9   -- a letter's width and the space either side of it: a chip is sized round its text
local INFO_LABEL_W = 96                -- the field names in the info panel take this much, the chips the rest

local MEMBERSHIP_NAMES = { f2p = "Free to play", p2p = "Members" }

-- ----- the tiles --------------------------------------------------------------------------------------------

-- Makes the list's tiles once. A tile is a rarity-tinted box with its name (in capitals) and rarity, and the
-- copies owned at the right, with an invisible layer on top that takes the click.
function ViewerList.build(V)
    local o = V.open
    for index = 1, o.layout.listRows do
        local y = BODY_Y + (index - 1) * ROW_STEP
        local row = {}
        row.root, row.back, row.border = panel(o.content, LEFT, y, LIST_W, ROW_H)
        row.name = Kit.text(row.root, 56, 2, LIST_W - 112, 24, "", WHITE, ui.AlignMode.CENTRE)
        row.rarity = Kit.text(row.root, 56, 23, LIST_W - 112, 20, "", WHITE, ui.AlignMode.CENTRE)
        row.count = Kit.text(row.root, LIST_W - 56, 0, 50, ROW_H, "", GOLD, ui.AlignMode.CENTRE)
        row.grip = ui.Layer.new(o.content)
        row.grip.clickthrough = false
        row.grip:SetPos(LEFT, y)
        row.grip:SetSize(LIST_W, ROW_H, 0, 0)
        Kit.onWheel(row.grip, V.wheelPage)
        row.grip:Subscribe(ui.Hook.ONCLICK, function()
            local entry = row.entry
            if entry ~= nil then
                V.kept.selectedKey = entry.card.id
                V.refreshView()
            end
        end)
        o.rows[index] = row
    end
end

function ViewerList.hide(V, hidden)
    for _, row in ipairs(V.open.rows) do
        setHidden(row.root, hidden)
        setHidden(row.grip, hidden)
    end
end

-- Fills the tiles with the current page of the entries.
function ViewerList.show(V)
    local o = V.open
    local first = (V.kept.page - 1) * o.layout.listRows
    for index, row in ipairs(o.rows) do
        local entry = o.entries[first + index]
        row.entry = entry
        if entry == nil then
            setHidden(row.root, true)
            setHidden(row.grip, true)
        else
            setHidden(row.root, false)
            setHidden(row.grip, false)
            local card = entry.card
            local rarity = Cards.rarities[card.rarity]
            local locked = entry.locked
            -- (just the card's name: its finishes are variants of the one entry, shown under the picked card)
            row.name.content = string.upper(card.name)
            row.name.colour = locked and DIM or WHITE
            row.rarity.content = rarity.name
            row.rarity.colour = locked and DIM or toVec4(rarity.colour)
            row.count.content = locked and "-" or ("x" .. entry.count)
            row.count.colour = locked and DIM or GOLD
            local amount = card.rarity == "common" and 0.10 or 0.30
            row.back.colour = tint(rarity.colour, locked and amount * 0.5 or amount, 0.92)
            if card.id == V.kept.selectedKey then
                row.border.colour = SELECTED_BORDER
                row.border.outlineThickness = 2
            else
                row.border.colour = toVec4(rarity.colour, locked and 0.35 or 0.7)
                row.border.outlineThickness = 1
            end
        end
    end
end

-- ----- the picked card --------------------------------------------------------------------------------------

-- A tag's words as chips: { text, field, value }, where field and value are what clicking the chip sets in the filter.
-- One "-" (that does nothing when clicked) if the card has none.
local function tagItems(card, tagKind, field)
    local items = {}
    for _, word in ipairs(card.tags and card.tags[tagKind] or {}) do
        items[#items + 1] = { text = tagKind == "membership" and MEMBERSHIP_NAMES[word] or Browse.label(word),
            field = field, value = word }
    end
    if #items == 0 then
        items[1] = { text = "-" }
    end
    return items
end

local function chipWidth(text)
    return math.floor(#text * CHIP_CHAR_W + 2 * CHIP_PAD)
end

-- Where chips go when laid out left to right, wrapping onto a new line when the next would pass `maxW`: a list of
-- { x, y, w } (from the top left of the area), and the height the lines take.
local function flow(texts, maxW)
    local places, x, y = {}, 0, 0
    for index, text in ipairs(texts) do
        local w = chipWidth(text)
        if x > 0 and x + w > maxW then
            x, y = 0, y + CHIP_STEP
        end
        places[index] = { x = x, y = y, w = w }
        x = x + w + CHIP_GAP
    end
    return places, y + CHIP_STEP
end

-- One chip: its text in a small box with a thin border, a shade lighter than the panel behind it.
local function chip(parent, x, y, w, text, colour, border, backColour)
    local layer, back, edge = panel(parent, x, y, w, CHIP_H)
    back.colour = backColour or CHIP_BACK
    edge.colour = border or CHIP_BORDER
    Kit.text(layer, 0, 0, w, CHIP_H, text, colour or WHITE)
    return layer
end

-- What the detail panel shows depends on the picked card, how many of it the player has and the filters its chips set;
-- this changes when any of them does.
local function detailStamp(V, picked)
    local filter = V.kept.filter
    return table.concat({ tostring(V.kept.selectedKey), picked ~= nil and picked.count or "-",
        picked ~= nil and V.shownFinish(picked) or "-", tostring(filter.kind),
        tostring(filter.membership), tostring(filter.region), tostring(filter.skill), tostring(filter.category) }, "|")
end

-- The chip rows of the info panel for the picked card, as { label, items }: copies owned, type and membership; then the
-- finishes they have it in (a toggle each, the one shown lit); then a line each for region, skill and category.
local function infoRows(V, picked)
    local card = picked.card
    local kindWord = Cards.kindOf(card) == "item" and "item" or "npc"
    local finishItems = {}
    local shown = V.shownFinish(picked)
    for _, owned in ipairs(Browse.ownedFinishes(picked)) do
        local finish = owned.finish
        finishItems[#finishItems + 1] = { text = Cards.finishes[finish].name .. " x" .. owned.count,
            colour = finish == shown and GOLD or WHITE, active = finish == shown,
            onClick = function() V.chooseFinish(picked, finish) end }
    end
    local rowsToShow = {
        { items = {
            { text = picked.locked and "Not collected" or ("Owned: " .. picked.count), colour = picked.locked and DIM or GOLD,
                border = (not picked.locked) and CHIP_GOLD_BORDER or nil },
            { text = kindWord == "item" and "Item" or "NPC", field = "kind", value = kindWord },
            tagItems(card, "membership", "membership")[1],
        } },
    }
    if #finishItems > 0 then            -- (a card not owned has no finish row)
        rowsToShow[#rowsToShow + 1] = { label = "Finish", items = finishItems }
    end
    rowsToShow[#rowsToShow + 1] = { label = "Region", items = tagItems(card, "regions", "region") }
    rowsToShow[#rowsToShow + 1] = { label = "Skill", items = tagItems(card, "skills", "skill") }
    rowsToShow[#rowsToShow + 1] = { label = "Category", items = tagItems(card, "category", "category") }
    return rowsToShow
end

-- The card picked in the list, large, with what is known about it under it. Only rebuilt when what it shows changes.
function ViewerList.showDetail(V)
    local o, kept = V.open, V.kept
    if kept.gridView then
        V.destroyAll(o.detailParts)
        o.detailKey = nil
        return
    end
    local picked = nil
    for _, entry in ipairs(o.entries) do
        if entry.card.id == kept.selectedKey then
            picked = entry
            break
        end
    end
    if picked ~= nil and o.detailKey == detailStamp(V, picked) and #o.detailParts > 0 then
        return
    end
    V.destroyAll(o.detailParts)
    o.detailKey = picked ~= nil and detailStamp(V, picked) or nil
    if picked == nil then
        o.detailParts[#o.detailParts + 1] = Kit.text(o.content, DETAIL_X, BODY_Y + 20, DETAIL_W, 24,
            #o.entries == 0 and "No card matches." or "Click a card to see it.", GREY)
        return
    end

    local layout = o.layout
    local x = DETAIL_X + (DETAIL_W - layout.detailCardW) // 2
    local view = CardView.create(o.content, picked.card, { locked = picked.locked, finish = V.shownFinish(picked),
        scale = layout.detailScale })
    view.root:SetPos(x, BODY_Y)
    o.detailParts[#o.detailParts + 1] = view.root

    local rowsToShow = infoRows(V, picked)
    local y = 8
    for _, row in ipairs(rowsToShow) do
        local texts = {}
        for index, item in ipairs(row.items) do
            texts[index] = item.text
        end
        row.x0 = row.label ~= nil and INFO_LABEL_W or 10
        row.places, row.height = flow(texts, DETAIL_W - row.x0 - 10)
        row.y = y
        y = y + row.height + 2
    end
    local info = panel(o.content, DETAIL_X, BODY_Y + layout.detailCardH + 10, DETAIL_W, y + 6)
    o.detailParts[#o.detailParts + 1] = info
    for _, row in ipairs(rowsToShow) do
        if row.label ~= nil then
            Kit.text(info, 10, row.y, INFO_LABEL_W - 14, CHIP_H, row.label, GREY, ui.AlignMode.TOPLEFT)
        end
        for index, place in ipairs(row.places) do
            local item = row.items[index]
            local active = item.active or (item.field ~= nil and V.kept.filter[item.field] == item.value)
            local x, cy = row.x0 + place.x, row.y + place.y
            chip(info, x, cy, place.w, item.text, item.colour or WHITE, active and SELECTED_BORDER or item.border,
                active and CHIP_ACTIVE_BACK or nil)
            if item.field ~= nil or item.onClick ~= nil then
                local grip = ui.Layer.new(info)
                grip.clickthrough = false
                grip:SetPos(x, cy)
                grip:SetSize(place.w, CHIP_H, 0, 0)
                local field, value, onClick = item.field, item.value, item.onClick
                grip:Subscribe(ui.Hook.ONCLICK, function()
                    if onClick ~= nil then
                        onClick()
                    else
                        ViewerFilters.toggle(V, field, value)
                    end
                end)
            end
        end
    end
end

return ViewerList
