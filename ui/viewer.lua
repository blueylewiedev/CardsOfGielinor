-- ui/viewer.lua
-- The collection viewer: every card in the game, searchable and filterable, whether the player has it or not.
--
-- Two views of the same cards, switched by the swap button in the title bar:
--   list  a tile for each card (name, rarity, how many copies) tinted by its rarity, with the picked card shown large
--         beside it, and what is known about it under that.
--   grid  the cards themselves, 8 a page (4 on a short screen), each with its count underneath. Clicking one opens it in the list.
--
-- Everything sits on four equal columns (COLUMN_W wide): the filters, the list (two columns), the picked card (two
-- columns) and the grid (one card to a column), so the edges line up from the top to the bottom.
--
-- A card the player does not have shows no picture and no description (its card is the "?" placeholder), only its
-- name, rarity and tags, so browsing the deck gives nothing away.
--
-- Which cards show, and in what order, is core/browse.lua (tested on its own). This file only draws and takes the
-- mouse and keyboard. The filters are kept while the plugin runs, so closing and opening the viewer does not lose them.

local Cards = require("core/cards")
local Logger = require("core/logger")
local Browse = require("core/browse")
local CardView = require("ui/cardview")
local Kit = require("ui/kit")

local Viewer = {}

local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)
local DIM = Vector4.new(0.55, 0.55, 0.60, 1.0)
local GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
local DARK = { 0.07, 0.07, 0.09 }                       -- what a tile's rarity colour is mixed into
local PANEL_BACK = Vector4.new(0.08, 0.07, 0.06, 0.90)  -- the same dark bar and brown border as the credits overlay
local PANEL_BORDER = Vector4.new(0.45, 0.36, 0.22, 0.95)
local SELECTED_BORDER = Vector4.new(1.0, 1.0, 1.0, 0.95)
local CHIP_BACK = Vector4.new(0.18, 0.16, 0.13, 0.95)
local CHIP_BORDER = Vector4.new(0.50, 0.40, 0.24, 0.95)
local CHIP_GOLD_BORDER = Vector4.new(0.85, 0.68, 0.16, 0.95)
local CHIP_ACTIVE_BACK = Vector4.new(0.40, 0.30, 0.10, 0.98)   -- a chip whose filter is on

-- Layout, in the window's content area. Filters across the top, then the cards, then the counts and page buttons.
local COLUMNS, COLUMN_W, GAP = 4, 216, 12
local CONTENT_W = COLUMNS * COLUMN_W + (COLUMNS - 1) * GAP
-- The window's content is its width less the frame (8 at each side). What is in it keeps MARGIN from all four edges (the
-- same at both sides and the same above as below), as in the settings window.
local MARGIN = 10
local FRAME = Kit.available() and 16 or 0
local LEFT = MARGIN
local FILTER_Y = { MARGIN, MARGIN + 36, MARGIN + 72 }   -- the three rows of filters
local FILTER_H = 28
local BODY_Y = MARGIN + 114             -- where the list or grid starts
local ROW_H, ROW_STEP = 46, 50         -- a tile in the list, and the distance from one to the next
local LIST_W = 2 * COLUMN_W + GAP      -- the list takes the first two columns
local GRID_COLS = COLUMNS
local CAPTION_H = 44                   -- under a card in the grid: the gap and the bar with its count
local FOOTER_GAP, FOOTER_H = 8, 42     -- under the body: the gap, then the counts and the page buttons
local FOOTER_SHIFT = 22                -- Prev and Next sit this far left of their column, or Next is clipped by the frame

-- How tall the body (the list, the grid, the picked card) is depends on the screen: see layoutFor. The most that is shown
-- is 13 list rows, or 2 rows of cards in the grid, and the picked card drawn at DETAIL_MAX; on a short screen there are fewer
-- rows, smaller cards, and a smaller picked card, down to the limits below.
local LIST_ROWS_MAX, LIST_ROWS_MIN = 13, 10
local DETAIL_MAX, DETAIL_MIN = 2.0, 1.25     -- the picked card's size (a card in the grid is CardView.SCALE at most)
local GRID_MIN_SCALE = 1.1                   -- the smallest a card in the grid is made to keep two rows of them
local INFO_RESERVE = 190                     -- the room the picked card's info panel may need under the card
local SCREEN_USED = 0.97                     -- the window may take this much of the screen's height

-- The numbers that depend on the screen, set by applyLayout when the window opens (the full-size layout until then).
local LIST_ROWS, GRID_ROWS, GRID_PER_PAGE
local GRID_SCALE, GRID_CARD_W, GRID_CARD_H, TILE_H
local DETAIL_SCALE, DETAIL_W_CARD, DETAIL_H_CARD
local BODY_H, FOOTER_Y, HEIGHT
local CHIP_H, CHIP_STEP = 22, 28       -- a chip, and the distance from one line of chips to the next
local CHIP_GAP = 6                     -- between chips on a line
local CHIP_CHAR_W, CHIP_PAD = 8.5, 9   -- a letter's width and the space either side of it: a chip is sized round its text
local INFO_LABEL_W = 96                -- the field names in the info panel take this much, the chips the rest

local ANY = "any"                      -- the value of a drop-down's "no filter" entry

-- Where column `number` (1 to 4) starts.
local function columnX(number)
    return LEFT + (number - 1) * (COLUMN_W + GAP)
end
local DETAIL_X = columnX(3)            -- the picked card is over the last two columns
local DETAIL_W = 2 * COLUMN_W + GAP

local function clamp(value, low, high)
    return math.max(low, math.min(high, value))
end

-- The sizes that fit a screen `screenHeight` units tall (nil if unknown: then the full size). The window takes at most
-- SCREEN_USED of the height, less its title bar and frame; what is left after the filters and the footer is the body's.
--   * list rows: as many as fit, from LIST_ROWS_MAX down to LIST_ROWS_MIN;
--   * grid: two rows of cards, shrunk down to GRID_MIN_SCALE if that is what it takes, else one row at full size;
--   * the picked card: as big as the body leaves room for (with INFO_RESERVE under it), from DETAIL_MAX down to DETAIL_MIN.
-- Below the minimum the window is taller than the screen (the smallest it goes is fixed by what must fit in it).
-- Returns a table of the numbers; `budget` is the body's height the screen allows.
function Viewer.layoutFor(screenHeight)
    local fullTile = CardView.HEIGHT + CAPTION_H
    local layout = { listRows = LIST_ROWS_MAX, gridRows = 2, gridScale = CardView.SCALE }
    if screenHeight ~= nil then
        local budget = math.floor(screenHeight * SCREEN_USED) - Kit.titleBarHeight() - FRAME // 2 - BODY_Y - FOOTER_GAP
            - FOOTER_H
        layout.budget = budget
        if budget < math.max(LIST_ROWS_MAX * ROW_STEP, 2 * fullTile) then
            layout.listRows = clamp(budget // ROW_STEP, LIST_ROWS_MIN, LIST_ROWS_MAX)
            local fit = math.floor((budget // 2 - CAPTION_H) / 224 * 100) / 100     -- the card scale two rows allow
            if fit >= GRID_MIN_SCALE then
                layout.gridScale = math.min(CardView.SCALE, fit)
            else
                layout.gridRows = 1
            end
        end
    end
    layout.cardW, layout.cardH = math.floor(160 * layout.gridScale), math.floor(224 * layout.gridScale)
    layout.tileH = layout.cardH + CAPTION_H
    layout.bodyH = math.max(layout.listRows * ROW_STEP, layout.gridRows * layout.tileH,
        math.floor(224 * DETAIL_MIN) + 10 + INFO_RESERVE)
    layout.detailScale = clamp(math.floor((layout.bodyH - 10 - INFO_RESERVE) / 224 * 100) / 100, DETAIL_MIN, DETAIL_MAX)
    layout.height = BODY_Y + layout.bodyH + FOOTER_GAP + FOOTER_H
    return layout
end

-- Makes the numbers above the ones the window is built from.
local function applyLayout(layout)
    LIST_ROWS, GRID_ROWS = layout.listRows, layout.gridRows
    GRID_PER_PAGE = GRID_COLS * GRID_ROWS
    GRID_SCALE, GRID_CARD_W, GRID_CARD_H, TILE_H = layout.gridScale, layout.cardW, layout.cardH, layout.tileH
    DETAIL_SCALE = layout.detailScale
    DETAIL_W_CARD, DETAIL_H_CARD = math.floor(160 * DETAIL_SCALE), math.floor(224 * DETAIL_SCALE)
    BODY_H = layout.bodyH
    FOOTER_Y = BODY_Y + BODY_H + FOOTER_GAP
    HEIGHT = layout.height
end
applyLayout(Viewer.layoutFor(nil))

local api = nil                       -- api.getState() : the logged-in character's collection, or nil
local window, content = nil, nil
local widgets = {}                     -- text and buttons that stay while the window is open
local dropdowns = {}
local rows = {}                        -- the list's tiles, made once
local gridParts = {}                   -- what the grid draws for the current page
local detailParts = {}                 -- what the detail panel draws for the picked card
local detailKey = nil                  -- which card that is (so typing in the search does not rebuild the same card)
local titleButton = nil                -- the swap button in the title bar

-- What the player has chosen. Kept between openings.
local filter = { owned = "all", sort = "rarity" }
local filterStarted = false               -- the filter starts from the default the first time the viewer opens
local gridView = false
local page = 1
local selectedKey = nil                -- the id of the card shown beside the list
local chosenFinish = {}                -- { card id = finish } picked with a card's finish toggles (kept while the plugin runs)
local entries = {}                     -- what the filter finds, worked out when the filter changes
local watchedState, watchedStamp = nil, nil   -- the collection as the list was last worked out from it (see Viewer.refresh)

-- Where the filter starts, and what Clear filters goes back to: the cards the player owns, or all of them while they
-- own none (an empty list on a first visit would look broken).
local function defaultFilter()
    local state = api ~= nil and api.getState() or nil
    local owning = state ~= nil and Browse.counts(state, {}).owned > 0
    return { owned = owning and "owned" or "all", sort = "rarity" }
end

-- The collection as the viewer shows it: the cards of a pack that is being opened and have not been turned over yet are
-- already in the collection, but are left out until they have been seen (api.hiddenCards, if the plugin has it, says
-- which). Gives `state` itself when there are none.
local function viewState(state)
    local hidden = api ~= nil and api.hiddenCards ~= nil and api.hiddenCards() or nil
    if hidden == nil or next(hidden) == nil then
        return state
    end
    local view = {}
    for field, value in pairs(state) do
        view[field] = value
    end
    view.owned = {}
    for key, count in pairs(state.owned) do
        local left = count - (hidden[key] or 0)
        if left > 0 then
            view.owned[key] = left
        end
    end
    return view
end

local function setHidden(component, hidden)
    pcall(function() component.hidden = hidden end)
end

local function destroyAll(list)
    for index = #list, 1, -1 do
        pcall(function() list[index]:Destroy() end)
        list[index] = nil
    end
end

-- 0xRRGGBBAA -> the Vector4 the components take, with an alpha of your own.
local function toVec4(hex, alpha)
    return Vector4.new(((hex >> 24) & 0xFF) / 255, ((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255, alpha or 1.0)
end

-- A rarity's colour mixed into the dark background: `amount` 0 is all dark, 1 is all the rarity colour.
local function tint(hex, amount, alpha)
    local r, g, b = ((hex >> 24) & 0xFF) / 255, ((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255
    return Vector4.new(DARK[1] + (r - DARK[1]) * amount, DARK[2] + (g - DARK[2]) * amount,
        DARK[3] + (b - DARK[3]) * amount, alpha)
end

local function entryKey(entry)
    return entry.card.id
end

-- The finish a card is shown in: the one picked with its toggles if the player still has it, otherwise the entry's
-- own (the filter's finish, or the rarest the player has, Browse.preferredFinish).
local function shownFinish(entry)
    local chosen = chosenFinish[entry.card.id]
    if chosen ~= nil and entry.finishes[chosen] ~= nil then
        return chosen
    end
    return entry.finish
end

-- The finishes the player has of a card, in the order the toggles show them (Browse.FINISH_PREFERENCE), as
-- { finish, count } pairs.
local function ownedFinishes(entry)
    local list = {}
    for _, finish in ipairs(Browse.FINISH_PREFERENCE) do
        if entry.finishes[finish] ~= nil then
            list[#list + 1] = { finish = finish, count = entry.finishes[finish] }
        end
    end
    return list
end

-- Shows a card in another finish it is owned in (a toggle under it).
local function chooseFinish(entry, finish)
    chosenFinish[entry.card.id] = finish
    Viewer.refreshView()
end

local function perPage()
    return gridView and GRID_PER_PAGE or LIST_ROWS
end

local function pageCount()
    return math.max(1, math.ceil(#entries / perPage()))
end

-- A dark box with a thin border, as a layer to put texts in. Returns the layer, the background and the border.
local function panel(parent, x, y, w, h)
    local layer = ui.Layer.new(parent)
    layer:SetPos(x, y)
    layer:SetSize(w, h, 0, 0)
    local back = ui.Rectangle.new(layer)
    back:SetPos(0, 0)
    back:SetSize(w, h, 0, 0)
    back.fill = true
    back.colour = PANEL_BACK
    local border = ui.Rectangle.new(layer)
    border:SetPos(0, 0)
    border:SetSize(w, h, 0, 0)
    border.fill = false
    border.outlineThickness = 1
    border.colour = PANEL_BORDER
    return layer, back, border
end

-- The word list a tag filter offers, as { label, value } entries: "any" first, then the words by their label.
local function wordEntries(anyLabel, words)
    local list = {}
    for _, word in ipairs(words or {}) do
        list[#list + 1] = { label = Browse.label(word), value = word }
    end
    table.sort(list, function(a, b) return a.label < b.label end)
    table.insert(list, 1, { label = anyLabel, value = ANY })
    return list
end

-- The categories are the longest list (over 200). PrettyUI's drop-down that can be typed in takes longer for every
-- entry it has (it rebuilds the whole list for each one when it opens, and gave up after a second), so this one is the
-- plain, sorted kind (see Kit.dropdown), which sorts "Any category" in with the rest: the space in front keeps it at
-- the top.
local ANY_CATEGORY = " Any category"

-- The categories to offer: the ones that cards matching the other filters have (so every one finds something), and the
-- one chosen now, whatever the other filters are, so the box never shows a choice that is not in its list.
local function categoryEntries()
    local state = api ~= nil and api.getState() or nil
    local present = state ~= nil and Browse.words(viewState(state), filter, "category") or nil
    local words = {}
    for _, word in ipairs(Cards.wordsFor(filter.kind, "category") or {}) do
        if present == nil or present[word] or word == filter.category then
            words[#words + 1] = word
        end
    end
    return wordEntries(ANY_CATEGORY, words)
end

-- Puts the category list right for the filters as they are now (not when it is already so: setting a drop-down's list
-- is not free).
local shownCategories = nil
local function updateCategories()
    if dropdowns.category == nil then
        return
    end
    local list = categoryEntries()
    local values = {}
    for _, entry in ipairs(list) do
        values[#values + 1] = entry.value
    end
    local key = table.concat(values, ",") .. "|" .. tostring(filter.category)
    if key == shownCategories then
        return
    end
    shownCategories = key
    pcall(function() dropdowns.category.set(list, filter.category or ANY) end)
end

local MEMBERSHIP_NAMES = { f2p = "Free to play", p2p = "Members" }

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

-- A category chosen with the kind of card that does not have it is dropped.
local function dropInvalidCategory()
    local valid = false
    for _, word in ipairs(Cards.wordsFor(filter.kind, "category") or {}) do
        valid = valid or word == filter.category
    end
    if not valid then
        filter.category = nil
    end
end

-- A chip was clicked: its field is set to its value in the filter, or cleared if it already was. The drop-downs follow.
-- (The owned / not collected chip does nothing: it only says what the player has.)
local function toggleFilter(field, value)
    if filter[field] == value then
        filter[field] = nil
    else
        filter[field] = value
    end
    if field == "kind" then
        dropInvalidCategory()
    end
    if dropdowns[field] ~= nil then
        pcall(function() dropdowns[field].select(filter[field] or ANY) end)
    end
    Viewer.refilter(true)
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

-- ----- the list ---------------------------------------------------------------------------------------------

local function pick(key)
    selectedKey = key
    Viewer.refreshView()
end

-- The mouse wheel turns the pages: down for the next, up for the previous (and stops at the first and the last, where
-- the Prev and Next buttons wrap round).
local function wheelPage(delta)
    Logger.debug("viewer: mouse wheel", tostring(delta))
    if window == nil or type(delta) ~= "number" or delta == 0 then
        return
    end
    local target = math.max(1, math.min(pageCount(), page + (delta > 0 and 1 or -1)))
    if target ~= page then
        page = target
        Viewer.refreshView()
    end
end

-- Makes the list's tiles once. A tile is a rarity-tinted box with its name (in capitals) and rarity, and the
-- copies owned at the right, with an invisible layer on top that takes the click.
local function buildRows()
    for index = 1, LIST_ROWS do
        local y = BODY_Y + (index - 1) * ROW_STEP
        local row = {}
        row.root, row.back, row.border = panel(content, LEFT, y, LIST_W, ROW_H)
        row.name = Kit.text(row.root, 56, 2, LIST_W - 112, 24, "", WHITE, ui.AlignMode.CENTRE)
        row.rarity = Kit.text(row.root, 56, 23, LIST_W - 112, 20, "", WHITE, ui.AlignMode.CENTRE)
        row.count = Kit.text(row.root, LIST_W - 56, 0, 50, ROW_H, "", GOLD, ui.AlignMode.CENTRE)
        row.grip = ui.Layer.new(content)
        row.grip.clickthrough = false
        row.grip:SetPos(LEFT, y)
        row.grip:SetSize(LIST_W, ROW_H, 0, 0)
        Kit.onWheel(row.grip, wheelPage)
        row.grip:Subscribe(ui.Hook.ONCLICK, function()
            local entry = row.entry
            if entry ~= nil then
                pick(entryKey(entry))
            end
        end)
        rows[index] = row
    end
end

local function setRowsHidden(hidden)
    for _, row in ipairs(rows) do
        setHidden(row.root, hidden)
        setHidden(row.grip, hidden)
    end
end

local function showRows()
    local first = (page - 1) * LIST_ROWS
    for index, row in ipairs(rows) do
        local entry = entries[first + index]
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
            if entryKey(entry) == selectedKey then
                row.border.colour = SELECTED_BORDER
                row.border.outlineThickness = 2
            else
                row.border.colour = toVec4(rarity.colour, locked and 0.35 or 0.7)
                row.border.outlineThickness = 1
            end
        end
    end
end

-- What the detail panel shows depends on the picked card, how many of it the player has and the filters its chips set;
-- this changes when any of them does.
local function detailStamp(picked)
    return table.concat({ tostring(selectedKey), picked ~= nil and picked.count or "-",
        picked ~= nil and shownFinish(picked) or "-", tostring(filter.kind),
        tostring(filter.membership), tostring(filter.region), tostring(filter.skill), tostring(filter.category) }, "|")
end

-- The card picked in the list, large, with what is known about it under it.
local function showDetail()
    if gridView then
        destroyAll(detailParts)
        detailKey = nil
        return
    end
    local picked = nil
    for _, entry in ipairs(entries) do
        if entryKey(entry) == selectedKey then
            picked = entry
            break
        end
    end
    if picked ~= nil and detailKey == detailStamp(picked) and #detailParts > 0 then
        return
    end
    destroyAll(detailParts)
    detailKey = picked ~= nil and detailStamp(picked) or nil
    if picked == nil then
        detailParts[#detailParts + 1] = Kit.text(content, DETAIL_X, BODY_Y + 20, DETAIL_W, 24,
            #entries == 0 and "No card matches." or "Click a card to see it.", GREY)
        return
    end

    local x = DETAIL_X + (DETAIL_W - DETAIL_W_CARD) // 2
    local view = CardView.create(content, picked.card, { locked = picked.locked, finish = shownFinish(picked),
        scale = DETAIL_SCALE })
    view.root:SetPos(x, BODY_Y)
    detailParts[#detailParts + 1] = view.root

    -- What is known about the card, as chips: how many the player has (all finishes together), the type and whether
    -- it is members only on the first line; then the finishes they have it in, each a toggle that shows the card in
    -- it (the one shown lit); then a line for each of region, skill and category (a chip for each word, wrapping onto
    -- more lines when there are too many for one). Clicking a tag chip sets that filter (or clears it if it is on).
    local card = picked.card
    local kindWord = Cards.kindOf(card) == "item" and "item" or "npc"
    local finishItems = {}
    local shown = shownFinish(picked)
    for _, owned in ipairs(ownedFinishes(picked)) do
        local finish = owned.finish
        finishItems[#finishItems + 1] = { text = Cards.finishes[finish].name .. " x" .. owned.count,
            colour = finish == shown and GOLD or WHITE, active = finish == shown,
            onClick = function() chooseFinish(picked, finish) end }
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
    local info = panel(content, DETAIL_X, BODY_Y + DETAIL_H_CARD + 10, DETAIL_W, y + 6)
    detailParts[#detailParts + 1] = info
    for _, row in ipairs(rowsToShow) do
        if row.label ~= nil then
            Kit.text(info, 10, row.y, INFO_LABEL_W - 14, CHIP_H, row.label, GREY, ui.AlignMode.TOPLEFT)
        end
        for index, place in ipairs(row.places) do
            local item = row.items[index]
            local active = item.active or (item.field ~= nil and filter[item.field] == item.value)
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
                        toggleFilter(field, value)
                    end
                end)
            end
        end
    end
end

-- ----- the grid ---------------------------------------------------------------------------------------------

local function showGrid()
    destroyAll(gridParts)
    if not gridView then
        return
    end
    local first = (page - 1) * GRID_PER_PAGE
    for slot = 1, GRID_PER_PAGE do
        local entry = entries[first + slot]
        if entry == nil then
            break
        end
        local x = columnX((slot - 1) % GRID_COLS + 1) + (COLUMN_W - GRID_CARD_W) // 2
        local y = BODY_Y + ((slot - 1) // GRID_COLS) * TILE_H
        local shown = shownFinish(entry)
        local view = CardView.create(content, entry.card, { locked = entry.locked, finish = shown, scale = GRID_SCALE })
        view.root:SetPos(x, y)
        gridParts[#gridParts + 1] = view.root
        local key = entryKey(entry)

        -- the caption: a bar under the card in the rarity's own colour. A card owned in more than one finish has a
        -- toggle for each instead ("Foil x1 | Normal x2"), the one shown lit; clicking one shows the card in it.
        -- Otherwise a click on the caption opens the card in the list, as a click on the card does.
        local rarity = Cards.rarities[entry.card.rarity]
        local captionY = y + GRID_CARD_H + 6
        local caption, back, border = panel(content, x, captionY, GRID_CARD_W, 30)
        back.colour = tint(rarity.colour, entry.locked and 0.08 or 0.22, 0.92)
        border.colour = toVec4(rarity.colour, entry.locked and 0.35 or 0.8)
        gridParts[#gridParts + 1] = caption
        local finishes = ownedFinishes(entry)
        local function captionGrip(cx, cw, onClick)
            local grip = ui.Layer.new(content)
            grip.clickthrough = false
            grip:SetPos(x + cx, captionY)
            grip:SetSize(cw, 30, 0, 0)
            Kit.onWheel(grip, wheelPage)
            grip:Subscribe(ui.Hook.ONCLICK, onClick)
            gridParts[#gridParts + 1] = grip
        end
        if #finishes > 1 then
            local segment = GRID_CARD_W / #finishes
            for index, owned in ipairs(finishes) do
                local cx = math.floor((index - 1) * segment)
                local cw = math.floor(index * segment) - cx
                local lit = owned.finish == shown
                -- (three toggles do not fit the finishes' names in a small card: their short names, "H x1")
                local info = Cards.finishes[owned.finish]
                local name = #finishes > 2 and info.short or info.name
                Kit.text(caption, cx, 0, cw, 30, name .. " x" .. owned.count, lit and GOLD or DIM)
                local finish = owned.finish
                captionGrip(cx, cw, function() chooseFinish(entry, finish) end)
            end
        else
            local text = entry.locked and "Not collected" or ("Owned: " .. entry.count)
            if shown ~= "normal" and not entry.locked then
                text = Cards.finishes[shown].name .. "  |  " .. text
            end
            Kit.text(caption, 0, 0, GRID_CARD_W, 30, text, entry.locked and DIM or GOLD)
            captionGrip(0, GRID_CARD_W, function() Viewer.showInList(key) end)
        end

        -- a click on the card opens it in the list
        local grip = ui.Layer.new(content)
        grip.clickthrough = false
        grip:SetPos(x, y)
        grip:SetSize(GRID_CARD_W, GRID_CARD_H, 0, 0)
        Kit.onWheel(grip, wheelPage)
        grip:Subscribe(ui.Hook.ONCLICK, function()
            Viewer.showInList(key)
        end)
        gridParts[#gridParts + 1] = grip
    end
    if #entries == 0 then
        gridParts[#gridParts + 1] = Kit.text(content, LEFT, BODY_Y + 20, CONTENT_W, 24, "No card matches.", GREY)
    end
end

-- ----- the page ---------------------------------------------------------------------------------------------

-- Shows the list (from the grid, or already there) with `key` picked, on the page it is on.
function Viewer.showInList(key)
    if window == nil then
        return
    end
    selectedKey = key
    gridView = false
    for index, entry in ipairs(entries) do
        if entryKey(entry) == key then
            page = (index - 1) // LIST_ROWS + 1
            break
        end
    end
    Viewer.refreshView()
end

-- The swap button: from the list to the grid, and back. Going to the grid shows the page the picked card is on; going
-- back to the list picks the first card the grid was showing.
local function swapView()
    if gridView then
        local first = entries[(page - 1) * GRID_PER_PAGE + 1]
        Viewer.showInList(first ~= nil and entryKey(first) or selectedKey)
        return
    end
    local index = 1
    for position, entry in ipairs(entries) do
        if entryKey(entry) == selectedKey then
            index = position
            break
        end
    end
    gridView = true
    page = (index - 1) // GRID_PER_PAGE + 1
    Viewer.refreshView()
end

-- Draws what the current page, view and picked card need. Called when any of those change (when the filter does,
-- Viewer.refilter works out the cards again first).
function Viewer.refreshView()
    if window == nil then
        return
    end
    page = math.max(1, math.min(page, pageCount()))
    if gridView then
        setRowsHidden(true)
    else
        showRows()
    end
    showGrid()
    showDetail()
    widgets.pageText.content = "Page " .. page .. " of " .. pageCount()
end

-- A short fingerprint of what the player owns (and has seen): how many kinds of card and how many copies. It changes when
-- a card is turned over in a pack or added; that is all Viewer.refresh needs to see.
local function collectionStamp(state)
    local kinds, copies = 0, 0
    for _, count in pairs(state.owned) do
        kinds = kinds + 1
        copies = copies + (type(count) == "number" and count or 0)
    end
    return kinds .. ":" .. copies
end

-- Called about every 0.6 seconds (by the plugin's tick). When the collection has changed while the viewer is open (a pack
-- was opened, or a card won) the list, counts and picked card are worked out again, on the page that was showing. Closes
-- the viewer if there is no character any more.
function Viewer.refresh()
    if window == nil then
        return
    end
    local state = api.getState()
    if state == nil then
        Viewer.close()
        return
    end
    if state ~= watchedState or collectionStamp(viewState(state)) ~= watchedStamp then
        Viewer.refilter("stay")
    end
end

-- Works out the cards the filter finds, and shows them from the first page. With `follow` = true it shows the page the
-- picked card is on instead (when it is still among them), and with "stay" the page that was showing.
function Viewer.refilter(follow)
    if window == nil then
        return
    end
    local state = api.getState()
    if state == nil then
        Viewer.close()
        return
    end
    updateCategories()
    local view = viewState(state)
    watchedState, watchedStamp = state, collectionStamp(view)
    entries = Browse.entries(view, filter)
    local counts = Browse.counts(view, filter)
    -- (the whole deck, a card counted when the player has it in any finish)
    local whole = Browse.counts(view, {})
    widgets.counts.content = counts.owned .. " of " .. counts.cards .. " cards owned"
        .. "   |   Whole collection: " .. whole.owned .. " / " .. whole.cards
    local pageBefore = page
    page = 1
    local keep, position = false, nil
    for index, entry in ipairs(entries) do
        if entryKey(entry) == selectedKey then
            keep, position = true, index
            break
        end
    end
    if not keep then
        selectedKey = entries[1] ~= nil and entryKey(entries[1]) or nil
    elseif follow == true then
        page = (position - 1) // perPage() + 1    -- the picked card stays in view
    end
    if follow == "stay" then
        page = pageBefore
    end
    Viewer.refreshView()
end

-- ----- the filter bar ---------------------------------------------------------------------------------------

-- A drop-down that sets one field of the filter. `list` is { label, value } entries; "any" clears the field.
-- The width has to fit the longest label (about 9 units a letter, and 45 for the arrow), or the label is cut.
-- `sorted` makes it the plain kind that is sorted by label and cannot be typed in, for a long list.
local function filterDropdown(field, x, y, w, list, afterChange, sorted)
    local dropdown = Kit.dropdown(content, x, y, w, FILTER_H, list, filter[field] or ANY, function(value)
        filter[field] = (value ~= ANY) and value or nil
        if afterChange ~= nil then
            afterChange()
        end
        Viewer.refilter()
    end, sorted)
    dropdowns[field] = dropdown
    return dropdown
end

local function clearFilters()
    filter = defaultFilter()
    if widgets.search ~= nil then
        pcall(function() widgets.search.content = "" end)
    end
    for field, dropdown in pairs(dropdowns) do
        pcall(function() dropdown.select(filter[field] or ANY) end)
    end
    Viewer.refilter()
end

local function buildFilters()
    -- Row 1: the search over the first two columns, then the sort, then Clear filters.
    Kit.text(content, columnX(1), FILTER_Y[1], 56, FILTER_H, "Search", GREY, ui.AlignMode.TOPLEFT)
    widgets.search = Kit.inputField(content, columnX(1) + 60, FILTER_Y[1], 2 * COLUMN_W + GAP - 60, FILTER_H, 40, false)
    widgets.search.content = filter.search or ""
    widgets.search:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        local text = widgets.search.content
        filter.search = (text ~= nil and text ~= "") and text or nil
        Viewer.refilter()
    end)
    filterDropdown("sort", columnX(3), FILTER_Y[1], COLUMN_W, {
        { label = "Lowest rarity first", value = "rarity" },
        { label = "Highest rarity first", value = "rarity_desc" },
        { label = "Name A to Z", value = "name" },
        { label = "Most owned first", value = "owned" } })
    widgets.clear = Kit.buttonAt(content, "Clear filters", columnX(4), FILTER_Y[1], COLUMN_W, FILTER_H, clearFilters)

    -- Row 2: who has it, what kind, how rare, free or members.
    filterDropdown("owned", columnX(1), FILTER_Y[2], COLUMN_W, {
        { label = "All cards", value = "all" }, { label = "Owned", value = "owned" },
        { label = "Not owned", value = "unowned" } })
    -- The kind is a filter too, and decides which categories there are to choose from.
    filterDropdown("kind", columnX(2), FILTER_Y[2], COLUMN_W, {
        { label = "NPCs and items", value = ANY }, { label = "NPCs", value = "npc" }, { label = "Items", value = "item" } },
        dropInvalidCategory)    -- (the category list itself is put right by refilter)
    local rarities = { { label = "Any rarity", value = ANY } }
    for _, rarityId in ipairs(Cards.rarityOrder) do
        rarities[#rarities + 1] = { label = Cards.rarities[rarityId].name, value = rarityId }
    end
    filterDropdown("rarity", columnX(3), FILTER_Y[2], COLUMN_W, rarities)
    filterDropdown("membership", columnX(4), FILTER_Y[2], COLUMN_W, {
        { label = "Any membership", value = ANY }, { label = "Free to play", value = "f2p" },
        { label = "Members", value = "p2p" } })

    -- Row 3: where, which skill, what it is.
    filterDropdown("region", columnX(1), FILTER_Y[3], COLUMN_W, wordEntries("Any region", Cards.tagWords.regions))
    filterDropdown("skill", columnX(2), FILTER_Y[3], COLUMN_W, wordEntries("Any skill", Cards.tagWords.skills))
    filterDropdown("category", columnX(3), FILTER_Y[3], COLUMN_W, categoryEntries(), nil, true)
    -- The finish (foil, holo...), in the last place on the row unless the List / grid button needs it (no PrettyUI).
    if widgets.swap == nil then
        local finishes = { { label = "Any finish", value = ANY } }
        for _, finish in ipairs(Cards.finishOrder) do
            finishes[#finishes + 1] = { label = Cards.finishes[finish].name, value = finish }
        end
        filterDropdown("finish", columnX(4), FILTER_Y[3], COLUMN_W, finishes)
    end
end

-- ----- open and close ---------------------------------------------------------------------------------------

-- A number the client gives, or nil if the call fails or gives something else (or 0 or less).
local function readNumber(read)
    local ok, value = pcall(read)
    return (ok and type(value) == "number" and value > 0) and value or nil
end

-- One line in the log when the viewer opens: the screen's size in units, the interface scale setting and what the viewer
-- made of them. For a report that the window does not fit.
local function logScreen(gameWindow, screenHeight)
    local scale = readNumber(function() return game.options.InterfaceScale.setting end)
    local label = nil
    pcall(function() label = game.options.InterfaceScale:GetLabel(scale) end)
    Logger.note("collection viewer: screen", tostring(readNumber(function() return gameWindow.width end)), "x",
        tostring(screenHeight), "units | interface scale setting", tostring(scale), "(" .. tostring(label) .. ")",
        "| list rows", LIST_ROWS, "| grid rows", GRID_ROWS, "at scale", GRID_SCALE, "| picked card at", DETAIL_SCALE,
        "| window", HEIGHT + Kit.titleBarHeight(), "units tall")
end

-- Opens the viewer. `newApi` needs getState().
function Viewer.open(newApi)
    if window ~= nil then
        return
    end
    api = newApi
    if api.getState() == nil then
        return
    end

    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local screenHeight = readNumber(function() return gameWindow.height end)
    applyLayout(Viewer.layoutFor(screenHeight))
    logScreen(gameWindow, screenHeight)
    local width = CONTENT_W + 2 * MARGIN + FRAME
    window, content = Kit.window(gameWindow, "Collection", width, HEIGHT + Kit.titleBarHeight(), function()
        Viewer.close()
    end, 0.3, 0.02)

    -- The swap button goes in the title bar. Without PrettyUI there is no such bar, so it is a button on the bottom
    -- row of filters instead.
    titleButton = Kit.titleButton(window, "SWAP", swapView, "Switch between the list and the grid")
    if titleButton == nil then
        widgets.swap = Kit.buttonAt(content, "List / grid", columnX(4), FILTER_Y[3], COLUMN_W, FILTER_H, swapView)
    end

    -- The page buttons and counts first, then the list, then the filters: a drop-down's list is drawn over what is
    -- made before it. The counts are under the first two columns, the page and its buttons under the last two.
    local half = (COLUMN_W - GAP) // 2
    widgets.counts = Kit.text(content, columnX(1), FOOTER_Y + 4, 2 * COLUMN_W + GAP, 28, "", GREY, ui.AlignMode.TOPLEFT)
    widgets.pageText = Kit.text(content, columnX(3), FOOTER_Y + 4, COLUMN_W, 28, "", GREY)
    Kit.buttonAt(content, "Prev", columnX(4) - FOOTER_SHIFT, FOOTER_Y, half, 32, function()
        page = page - 1
        if page < 1 then page = pageCount() end
        Viewer.refreshView()
    end)
    Kit.buttonAt(content, "Next", columnX(4) + half + GAP - FOOTER_SHIFT, FOOTER_Y, half, 32, function()
        page = page + 1
        if page > pageCount() then page = 1 end
        Viewer.refreshView()
    end)
    if not filterStarted then
        filter, filterStarted = defaultFilter(), true
    end
    Kit.onWheel(content, wheelPage)
    buildRows()
    buildFilters()
    Viewer.refilter()
end

-- Closes the window and forgets what was drawn (the filters are kept).
function Viewer.close()
    destroyAll(gridParts)
    destroyAll(detailParts)
    for _, dropdown in pairs(dropdowns) do
        pcall(function() dropdown.destroy() end)
    end
    for _, row in ipairs(rows) do
        pcall(function() row.grip:Destroy() end)
        pcall(function() row.root:Destroy() end)
    end
    if titleButton ~= nil then
        pcall(function() titleButton:Destroy() end)
        titleButton = nil
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content = nil, nil
    widgets, dropdowns, rows = {}, {}, {}
    entries = {}
    detailKey = nil
    shownCategories = nil
end

-- True while the window is open.
function Viewer.isOpen()
    return window ~= nil
end

-- What is showing, for tests.
function Viewer.debugInfo()
    return { open = window ~= nil, page = page, pages = pageCount(), matches = #entries, grid = gridView, filter = filter,
        selected = selectedKey }
end

return Viewer
