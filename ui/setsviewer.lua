-- ui/setsviewer.lua
-- The Sets window: the sets in deck/sets.lua (every shopkeeper, every musician...) and how much of each the player has.
--
--   left   a search box and an NPCs / items drop-down over a tile for each set they let through, with how many of
--          its cards the player has ("3 / 4"), gold once it is complete. Clicking one shows it. When there are more
--          sets than fit, a scroll bar beside the tiles shows where the list is; the mouse wheel over the list scrolls
--          it, and the bar can be dragged.
--   right  the picked set's name, its progress and a bar, then its cards, 6 a page (3 on a short screen; Prev and Next under them, or the
--          mouse wheel). A card the player does not have is a shadow silhouette of its picture, with its name and rarity,
--          and the packs it comes in where its description would be (CardView's opts.silhouette and lockedText).
--
-- Which cards a set holds is core/sets.lua (tested on its own). This file only draws and takes the mouse. The picked set
-- is kept while the plugin runs, so closing and opening the window comes back to it.

local Cards = require("core/cards")
local Sets = require("core/sets")
local Browse = require("core/browse")
local Packs = require("core/packs")
local Logger = require("core/logger")
local CardView = require("ui/cardview")
local Kit = require("ui/kit")

local SetsViewer = {}

local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)
local DIM = Vector4.new(0.55, 0.55, 0.60, 1.0)
local GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
local PANEL_BACK = Vector4.new(0.08, 0.07, 0.06, 0.90)  -- the same dark box and brown border as the collection viewer
local PANEL_BORDER = Vector4.new(0.45, 0.36, 0.22, 0.95)
local SELECTED_BORDER = Vector4.new(1.0, 1.0, 1.0, 0.95)
local TILE_BACK = Vector4.new(0.13, 0.12, 0.10, 0.92)
local TILE_DONE_BACK = Vector4.new(0.30, 0.23, 0.07, 0.95)    -- a set the player has every card of
local TILE_DONE_BORDER = Vector4.new(0.85, 0.68, 0.16, 0.95)
local BAR_BACK = Vector4.new(0.18, 0.16, 0.13, 0.95)
local BAR_FILL = Vector4.new(0.85, 0.68, 0.16, 0.95)

-- Layout, in the window's content area: the same four columns as the collection viewer. The set list takes the first,
-- the picked set's cards the other three.
local COLUMNS, COLUMN_W, GAP = 4, 216, 12
local CONTENT_W = COLUMNS * COLUMN_W + (COLUMNS - 1) * GAP
local WINDOW_SLACK = 30                -- the window's frame takes this much of the width it is made with
local LEFT = Kit.available() and 4 or 10
local TOP = 4
local HEADER_H = 52                    -- the set's name, its progress and the bar over the cards
local BODY_Y = TOP + HEADER_H
local GRID_COLS = COLUMNS - 1
local CAPTION_H = 44                   -- under a card: the gap and the bar with its count
local FOOTER_GAP, FOOTER_H = 8, 42     -- under the body: the gap, then the counts and the page buttons
local FRAME = Kit.available() and 16 or 0
local ROW_H, ROW_STEP = 46, 50         -- a set's tile, and the distance from one to the next
local FILTER_H, FILTER_STEP = 28, 34   -- the search box and the drop-down over the list
local LIST_TOP = TOP + 2 * FILTER_STEP -- the set list runs from under them to the footer
local SCROLL_W = 8                     -- the scroll bar at the right of the list
local TILE_W = COLUMN_W - SCROLL_W - 4 -- a set's tile, leaving room for it
local THUMB_MIN = 24
local SCROLL_BACK = Vector4.new(0.18, 0.16, 0.13, 0.9)
local SCROLL_THUMB = Vector4.new(0.62, 0.52, 0.32, 0.95)
local FOOTER_SHIFT = 22                -- Prev and Next sit this far left of their column, or Next is clipped by the frame

-- How tall the window is depends on the screen, as the collection viewer's does (see layoutFor): two rows of cards at the
-- full card size where the screen allows, else the cards are made smaller (down to GRID_MIN_SCALE, where the text on a
-- card still fits), else one row of them.
local GRID_MIN_SCALE = 1.1
local SCREEN_USED = 0.97                     -- the window may take this much of the screen's height

-- The numbers that depend on the screen, set by applyLayout when the window opens (the full-size layout until then).
local GRID_ROWS, GRID_PER_PAGE
local CARD_SCALE, CARD_W, CARD_H, TILE_H
local BODY_H, LIST_ROWS, TRACK_H, FOOTER_Y, HEIGHT

local function columnX(number)
    return LEFT + (number - 1) * (COLUMN_W + GAP)
end
local GRID_X = columnX(2)
local GRID_W = GRID_COLS * COLUMN_W + (GRID_COLS - 1) * GAP

-- The sizes that fit a screen `screenHeight` units tall (nil if unknown: then the full size). The window takes at most
-- SCREEN_USED of the height, less its title bar and frame; what is left after the header and the footer is the body's.
-- Returns a table of the numbers; `budget` is the body's height the screen allows.
function SetsViewer.layoutFor(screenHeight)
    local layout = { gridRows = 2, scale = CardView.SCALE }
    if screenHeight ~= nil then
        local budget = math.floor(screenHeight * SCREEN_USED) - Kit.titleBarHeight() - FRAME // 2 - BODY_Y - FOOTER_GAP
            - FOOTER_H
        layout.budget = budget
        if budget < 2 * (CardView.HEIGHT + CAPTION_H) then
            local fit = math.floor((budget // 2 - CAPTION_H) / 224 * 100) / 100     -- the card scale two rows allow
            if fit >= GRID_MIN_SCALE then
                layout.scale = math.min(CardView.SCALE, fit)
            else
                layout.gridRows = 1
            end
        end
    end
    layout.cardW, layout.cardH = math.floor(160 * layout.scale), math.floor(224 * layout.scale)
    layout.tileH = layout.cardH + CAPTION_H
    layout.bodyH = layout.gridRows * layout.tileH
    -- the set list runs from under the search box and drop-down to the footer
    layout.listRows = math.floor((HEADER_H + layout.bodyH - (LIST_TOP - TOP) + ROW_STEP - ROW_H) / ROW_STEP)
    layout.height = BODY_Y + layout.bodyH + FOOTER_GAP + FOOTER_H
    return layout
end

-- Makes the numbers above the ones the window is built from.
local function applyLayout(layout)
    GRID_ROWS = layout.gridRows
    GRID_PER_PAGE = GRID_COLS * GRID_ROWS
    CARD_SCALE, CARD_W, CARD_H, TILE_H = layout.scale, layout.cardW, layout.cardH, layout.tileH
    BODY_H = layout.bodyH
    LIST_ROWS = layout.listRows
    TRACK_H = LIST_ROWS * ROW_STEP - (ROW_STEP - ROW_H)
    FOOTER_Y = BODY_Y + BODY_H + FOOTER_GAP
    HEIGHT = layout.height
end
applyLayout(SetsViewer.layoutFor(nil))

local api = nil                        -- api.getState(), api.hiddenCards() (optional)
local window, content = nil, nil
local widgets = {}                     -- text and buttons that stay while the window is open
local rows = {}                        -- the set list's tiles, made once
local gridParts = {}                   -- what the grid draws for the current page

-- What the player has chosen. Kept between openings.
local selectedId = nil                 -- the id of the set shown
local listTop = 0                      -- how many sets the list has scrolled past
local search = nil                     -- what is typed in the search box (nil: nothing)
local kindFilter = nil                 -- "npc" or "item": only the sets with cards of that kind (nil: both)
local shownSets = {}                   -- the sets the search and the drop-down let through, worked out on each redraw
local scrollBar = {}                   -- the scroll bar's track, thumb and grip, and a drag of it while held
local page = 1
local watchedState, watchedStamp = nil, nil   -- the collection as the window was last drawn from it
local drawnKey = nil                   -- what the grid shows (so a tick with nothing new does not rebuild the cards)

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

-- The collection as the window shows it: the cards of a pack that is being opened and have not been turned over yet
-- are left out until they have been seen, as in the collection viewer.
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

-- A short fingerprint of what the player owns: it changes when a card is turned over in a pack or added.
local function collectionStamp(state)
    local kinds, copies = 0, 0
    for _, count in pairs(state.owned) do
        kinds = kinds + 1
        copies = copies + (type(count) == "number" and count or 0)
    end
    return kinds .. ":" .. copies
end

-- How many copies of a card the player has, over every finish, from what they have of it ({ finish = copies },
-- Browse.ownedByCard).
local function copiesOf(have)
    local total = 0
    for _, count in pairs(have or {}) do
        total = total + count
    end
    return total
end

-- What a card the player does not have says in place of its description: the packs it comes in, with " pack" taken off
-- each name. The description box holds 3 lines of about 17 to 19 letters, so this has to be short: the Standard pack is
-- left out (it has every card, so it would only take room) unless it is the only one, and the lead-in is "Packs:".
-- dev/check_sets_ui.lua checks that every card in a set fits in 3 lines of 17 letters, so a new pack cannot clip it.
function SetsViewer.lockedText(card)
    local standard = Packs.typeById("standard")
    local names, onlyStandard = {}, false
    for _, name in ipairs(Packs.namesFor(card)) do
        if standard ~= nil and name == standard.name then
            onlyStandard = true
        else
            names[#names + 1] = (name:gsub(" [Pp]ack$", ""))
        end
    end
    if #names == 0 then
        return onlyStandard and "Packs: Standard" or "Not in any pack"
    end
    return "Packs: " .. table.concat(names, ", ")
end
local lockedText = SetsViewer.lockedText

-- Destroys the grid's cards, and forgets the turns their silhouettes were to be sent again (CardView.applyPending).
local function clearGrid()
    destroyAll(gridParts)
    CardView.clearPending()
end

local function selectedSet()
    return selectedId ~= nil and Sets.byId[selectedId] or nil
end

local function pageCount(cards)
    return math.max(1, math.ceil(#cards / GRID_PER_PAGE))
end

-- ----- the set list -----------------------------------------------------------------------------------------

-- True if `set` passes the search and the drop-down. The search finds a set when every word typed is in its name, or
-- every word is in the name of one of its cards ("frog" finds a set with a frog in it), whatever the case.
local function setMatches(set)
    local cards = Sets.cardsOf(set)
    if kindFilter ~= nil then
        local any = false
        for _, card in ipairs(cards) do
            if Cards.kindOf(card) == kindFilter then
                any = true
                break
            end
        end
        if not any then
            return false
        end
    end
    if search == nil then
        return true
    end
    local function hasEveryWord(text)
        text = string.lower(text)
        for word in string.gmatch(string.lower(search), "%S+") do
            if not string.find(text, word, 1, true) then
                return false
            end
        end
        return true
    end
    if hasEveryWord(set.name) then
        return true
    end
    for _, card in ipairs(cards) do
        if hasEveryWord(card.name) then
            return true
        end
    end
    return false
end

local function findShownSets()
    shownSets = {}
    for _, set in ipairs(Sets.list) do
        if setMatches(set) then
            shownSets[#shownSets + 1] = set
        end
    end
end

local function scrollList(delta)
    if window == nil or type(delta) ~= "number" or delta == 0 then
        return
    end
    local most = math.max(0, #shownSets - LIST_ROWS)
    local target = math.max(0, math.min(most, listTop + (delta > 0 and 1 or -1)))
    if target ~= listTop then
        listTop = target
        SetsViewer.redraw()
    end
end

-- Makes the list's tiles once: the set's name, and how many of its cards the player has at the right. An invisible
-- layer on top takes the click and the mouse wheel.
local function buildRows()
    for index = 1, LIST_ROWS do
        local y = LIST_TOP + (index - 1) * ROW_STEP
        local row = {}
        row.root, row.back, row.border = panel(content, LEFT, y, TILE_W, ROW_H)
        row.name = Kit.text(row.root, 10, 0, TILE_W - 80, ROW_H, "", WHITE, ui.AlignMode.TOPLEFT)
        row.count = Kit.text(row.root, TILE_W - 72, 0, 64, ROW_H, "", GREY, ui.AlignMode.CENTRE)
        row.grip = ui.Layer.new(content)
        row.grip.clickthrough = false
        row.grip:SetPos(LEFT, y)
        row.grip:SetSize(TILE_W, ROW_H, 0, 0)
        Kit.onWheel(row.grip, scrollList)
        row.grip:Subscribe(ui.Hook.ONCLICK, function()
            if row.set ~= nil and row.set.id ~= selectedId then
                selectedId = row.set.id
                page = 1
                SetsViewer.redraw()
            end
        end)
        rows[index] = row
    end
end

-- The scroll bar: a track beside the tiles and a thumb as long as the share of the sets that fit, where the list is.
-- Pressing anywhere on it and dragging moves the thumb with the mouse (the grip stretches over the window while held,
-- as other drags do, so the release is caught wherever the mouse goes); the mouse wheel over it scrolls too.
local function placeThumb()
    local most = #shownSets - LIST_ROWS
    local thumbH = math.max(THUMB_MIN, math.floor(TRACK_H * LIST_ROWS / math.max(1, #shownSets)))
    local y = LIST_TOP + (most > 0 and math.floor((TRACK_H - thumbH) * listTop / most) or 0)
    scrollBar.thumbH = thumbH
    scrollBar.thumb:SetPos(LEFT + COLUMN_W - SCROLL_W, y)
    scrollBar.thumb:SetSize(SCROLL_W, thumbH, 0, 0)
end

local function showScrollBar()
    local needed = #shownSets > LIST_ROWS
    for _, part in ipairs({ scrollBar.track, scrollBar.thumb, scrollBar.grip }) do
        setHidden(part, not needed)
    end
    if needed then
        placeThumb()
    end
end

local function restScrollGrip()
    scrollBar.grip:SetPos(LEFT + COLUMN_W - SCROLL_W - 4, LIST_TOP)
    scrollBar.grip:SetSize(SCROLL_W + 8, TRACK_H, 0, 0)
end

local function endScrollDrag()
    if scrollBar.drag ~= nil then
        scrollBar.drag = nil
        restScrollGrip()
    end
end

local function buildScrollBar()
    local x = LEFT + COLUMN_W - SCROLL_W
    scrollBar.track = ui.Rectangle.new(content)
    scrollBar.track:SetPos(x, LIST_TOP)
    scrollBar.track:SetSize(SCROLL_W, TRACK_H, 0, 0)
    scrollBar.track.fill = true
    scrollBar.track.colour = SCROLL_BACK
    scrollBar.thumb = ui.Rectangle.new(content)
    scrollBar.thumb.fill = true
    scrollBar.thumb.colour = SCROLL_THUMB
    local grip = ui.Layer.new(content)
    grip.clickthrough = false
    scrollBar.grip = grip
    restScrollGrip()
    Kit.onWheel(grip, scrollList)
    grip:Subscribe(ui.Hook.ONCLICK, function()
        local _, y = Kit.mousePosition()
        if y == nil or #shownSets <= LIST_ROWS then
            return
        end
        scrollBar.drag = { mouseY = y, fromTop = listTop, held = true, missed = 0 }
        grip:SetPos(0, 0)
        grip:SetSize(0, 0, 1, 1)
        pcall(function() grip:MoveToFront() end)
    end)
    grip:Subscribe(ui.Hook.ONHOLD, function()
        local drag = scrollBar.drag
        local _, y = Kit.mousePosition()
        if drag == nil or y == nil then
            return
        end
        drag.held = true
        -- the thumb moves as far as the mouse has: a track's worth of travel is the whole list
        local most = #shownSets - LIST_ROWS
        local travel = math.max(1, TRACK_H - (scrollBar.thumbH or THUMB_MIN))
        local target = math.max(0, math.min(most, math.floor(drag.fromTop + (y - drag.mouseY) * most / travel + 0.5)))
        if target ~= listTop then
            listTop = target
            SetsViewer.redraw()
        end
    end)
    grip:Subscribe(ui.Hook.ONRELEASE, endScrollDrag)
end

local function showRows(state, ownedIds)
    for index, row in ipairs(rows) do
        local set = shownSets[listTop + index]
        row.set = set
        setHidden(row.root, set == nil)
        setHidden(row.grip, set == nil)
        if set ~= nil then
            local progress = Sets.progress(state, set, ownedIds)
            local done = progress.cards > 0 and progress.owned == progress.cards
            row.name.content = set.name
            row.name.colour = done and GOLD or WHITE
            row.count.content = progress.owned .. " / " .. progress.cards
            row.count.colour = done and GOLD or (progress.owned > 0 and WHITE or DIM)
            row.back.colour = done and TILE_DONE_BACK or TILE_BACK
            if set.id == selectedId then
                row.border.colour = SELECTED_BORDER
                row.border.outlineThickness = 2
            else
                row.border.colour = done and TILE_DONE_BORDER or PANEL_BORDER
                row.border.outlineThickness = 1
            end
        end
    end
end

-- ----- the picked set ---------------------------------------------------------------------------------------

local function wheelPage(delta)
    local set = selectedSet()
    if window == nil or set == nil or type(delta) ~= "number" or delta == 0 then
        return
    end
    local target = math.max(1, math.min(pageCount(Sets.cardsOf(set)), page + (delta > 0 and 1 or -1)))
    if target ~= page then
        page = target
        SetsViewer.redraw()
    end
end

-- The header (name, progress and bar) and the current page of the set's cards. The cards are only rebuilt when the
-- set, the page or what the player has of it changes.
local function showSet(state, ownedIds)
    local set = selectedSet()
    if set == nil then
        clearGrid()
        drawnKey = nil
        widgets.setName.content = #Sets.list == 0 and "There are no sets yet."
            or (#shownSets == 0 and "No set matches." or "Click a set to see its cards.")
        widgets.setProgress.content = ""
        widgets.pageText.content = ""
        setHidden(widgets.barFill, true)
        return
    end
    local cards = Sets.cardsOf(set)
    page = math.max(1, math.min(page, pageCount(cards)))
    local progress = Sets.progress(state, set, ownedIds)
    local done = progress.cards > 0 and progress.owned == progress.cards
    widgets.setName.content = set.name
    widgets.setName.colour = done and GOLD or WHITE
    widgets.setProgress.content = done and ("Complete! All " .. progress.cards .. " collected")
        or (progress.owned .. " of " .. progress.cards .. " collected")
    widgets.setProgress.colour = done and GOLD or GREY
    local share = progress.cards > 0 and progress.owned / progress.cards or 0
    setHidden(widgets.barFill, share <= 0)
    if share > 0 then
        widgets.barFill:SetSize(math.max(2, math.floor(GRID_W * share)), 8, 0, 0)
    end
    widgets.pageText.content = "Page " .. page .. " of " .. pageCount(cards)

    local first = (page - 1) * GRID_PER_PAGE
    local owned = Browse.ownedByCard(state)          -- { card id = { finish = copies } }
    local keyParts = { set.id, tostring(page) }
    for slot = 1, GRID_PER_PAGE do
        local card = cards[first + slot]
        if card ~= nil then
            keyParts[#keyParts + 1] = card.id .. "=" .. copiesOf(owned[card.id])
        end
    end
    local key = table.concat(keyParts, "|")
    if key == drawnKey then
        return
    end
    drawnKey = key
    clearGrid()
    for slot = 1, GRID_PER_PAGE do
        local card = cards[first + slot]
        if card == nil then
            break
        end
        local copies = copiesOf(owned[card.id])
        local locked = copies == 0
        local x = columnX((slot - 1) % GRID_COLS + 2) + (COLUMN_W - CARD_W) // 2
        local y = BODY_Y + ((slot - 1) // GRID_COLS) * TILE_H
        local view = CardView.create(content, card, { locked = locked, silhouette = true, scale = CARD_SCALE,
            -- (every finish counts towards the set; a card is shown as the collection shows it, the rarest finish first)
            lockedText = locked and lockedText(card) or nil,
            finish = Browse.preferredFinish(owned[card.id]) })
        view.root:SetPos(x, y)
        gridParts[#gridParts + 1] = view.root

        -- the caption: a bar under the card in the rarity's own colour
        local rarity = Cards.rarities[card.rarity]
        local caption, back, border = panel(content, x, y + CARD_H + 6, CARD_W, 30)
        back.colour = toVec4(rarity.colour, locked and 0.08 or 0.22)
        border.colour = toVec4(rarity.colour, locked and 0.35 or 0.8)
        Kit.text(caption, 0, 0, CARD_W, 30, locked and "Not collected" or ("Owned: " .. copies),
            locked and DIM or GOLD)
        gridParts[#gridParts + 1] = caption

        -- the wheel over a card turns the page
        local grip = ui.Layer.new(content)
        grip.clickthrough = false
        grip:SetPos(x, y)
        grip:SetSize(CARD_W, CARD_H + 36, 0, 0)
        Kit.onWheel(grip, wheelPage)
        gridParts[#gridParts + 1] = grip
    end
    if #cards == 0 then
        gridParts[#gridParts + 1] = Kit.text(content, GRID_X, BODY_Y + 20, GRID_W, 24, "This set has no cards yet.", GREY)
    end
end

-- ----- the window -------------------------------------------------------------------------------------------

-- Draws the list, the picked set and the footer from the collection as it is now.
function SetsViewer.redraw()
    if window == nil then
        return
    end
    local state = api.getState()
    if state == nil then
        SetsViewer.close()
        return
    end
    local view = viewState(state)
    watchedState, watchedStamp = state, collectionStamp(view)
    local ownedIds = Sets.ownedIds(view)
    findShownSets()
    listTop = math.max(0, math.min(listTop, #shownSets - LIST_ROWS))
    showRows(view, ownedIds)
    showScrollBar()
    showSet(view, ownedIds)
    local complete = 0
    for _, set in ipairs(Sets.list) do
        local progress = Sets.progress(view, set, ownedIds)
        if progress.cards > 0 and progress.owned == progress.cards then
            complete = complete + 1
        end
    end
    widgets.footer.content = "Sets complete: " .. complete .. " of " .. #Sets.list
        .. (#shownSets < #Sets.list and ("   |   Showing " .. #shownSets) or "")
        .. (#shownSets > LIST_ROWS and "   |   Scroll the list for more" or "")
end

-- Called about every 0.6 seconds (by the plugin's tick). Draws again when the collection has changed while the window
-- is open (a pack was opened, or a card won). Closes the window if there is no character any more.
function SetsViewer.refresh()
    if window == nil then
        return
    end
    CardView.applyPending()
    -- (a drag of the scroll bar whose holds have stopped coming for a few ticks lost its release)
    local drag = scrollBar.drag
    if drag ~= nil then
        drag.missed = drag.held and 0 or drag.missed + 1
        drag.held = false
        if drag.missed >= 3 then
            endScrollDrag()
        end
    end
    local state = api.getState()
    if state == nil then
        SetsViewer.close()
        return
    end
    if state ~= watchedState or collectionStamp(viewState(state)) ~= watchedStamp then
        SetsViewer.redraw()
    end
end

-- A number the client gives, or nil if the call fails or gives something else (or 0 or less).
local function readNumber(read)
    local ok, value = pcall(read)
    return (ok and type(value) == "number" and value > 0) and value or nil
end

-- One line in the log when the window opens: the screen's size in units and what the window made of it. For a report that
-- the window does not fit.
local function logScreen(gameWindow, screenHeight)
    Logger.note("sets window: screen", tostring(readNumber(function() return gameWindow.width end)), "x",
        tostring(screenHeight), "units | grid rows", GRID_ROWS, "at card scale", CARD_SCALE, "| list rows", LIST_ROWS,
        "| window", HEIGHT + Kit.titleBarHeight(), "units tall")
end

-- Opens the window. `newApi` needs getState(), and can have hiddenCards().
function SetsViewer.open(newApi)
    if window ~= nil then
        return
    end
    api = newApi
    if api.getState() == nil then
        return
    end
    if selectedSet() == nil then
        selectedId = Sets.list[1] ~= nil and Sets.list[1].id or nil
        page = 1
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local screenHeight = readNumber(function() return gameWindow.height end)
    applyLayout(SetsViewer.layoutFor(screenHeight))
    logScreen(gameWindow, screenHeight)
    listTop = math.max(0, math.min(listTop, #Sets.list - LIST_ROWS))
    local width = CONTENT_W + (Kit.available() and WINDOW_SLACK or 0)
    window, content = Kit.window(gameWindow, "Sets", width, HEIGHT + Kit.titleBarHeight(), function()
        SetsViewer.close()
    end, 0.35, 0.04)

    widgets.setName = Kit.text(content, GRID_X, TOP, GRID_W, 24, "", WHITE, ui.AlignMode.TOPLEFT)
    widgets.setProgress = Kit.text(content, GRID_X, TOP, GRID_W, 24, "", GREY, ui.AlignMode.RIGHT)
    local bar = ui.Rectangle.new(content)
    bar:SetPos(GRID_X, TOP + 30)
    bar:SetSize(GRID_W, 8, 0, 0)
    bar.fill = true
    bar.colour = BAR_BACK
    widgets.barFill = ui.Rectangle.new(content)
    widgets.barFill:SetPos(GRID_X, TOP + 30)
    widgets.barFill:SetSize(1, 8, 0, 0)
    widgets.barFill.fill = true
    widgets.barFill.colour = BAR_FILL

    local half = (COLUMN_W - GAP) // 2
    widgets.footer = Kit.text(content, columnX(1), FOOTER_Y + 4, 2 * COLUMN_W + GAP, 28, "", GREY, ui.AlignMode.TOPLEFT)
    widgets.pageText = Kit.text(content, columnX(3), FOOTER_Y + 4, COLUMN_W, 28, "", GREY)
    Kit.buttonAt(content, "Prev", columnX(4) - FOOTER_SHIFT, FOOTER_Y, half, 32, function()
        local set = selectedSet()
        if set == nil then return end
        page = page - 1
        if page < 1 then page = pageCount(Sets.cardsOf(set)) end
        SetsViewer.redraw()
    end)
    Kit.buttonAt(content, "Next", columnX(4) + half + GAP - FOOTER_SHIFT, FOOTER_Y, half, 32, function()
        local set = selectedSet()
        if set == nil then return end
        page = page + 1
        if page > pageCount(Sets.cardsOf(set)) then page = 1 end
        SetsViewer.redraw()
    end)
    Kit.onWheel(content, wheelPage)
    buildRows()
    buildScrollBar()
    -- The search and the drop-down, made after the list so the drop-down's list is drawn over it. A change picks the
    -- first set they let through if the one shown is left out.
    local function afterFilter()
        listTop = 0
        findShownSets()
        local kept = false
        for _, set in ipairs(shownSets) do
            kept = kept or set.id == selectedId
        end
        if not kept and shownSets[1] ~= nil then
            selectedId, page = shownSets[1].id, 1
        end
        SetsViewer.redraw()
    end
    widgets.search = Kit.inputField(content, LEFT, TOP, COLUMN_W, FILTER_H, 40, false)
    widgets.search.content = search or ""
    widgets.search:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        local text = widgets.search.content
        search = (text ~= nil and string.find(text, "%S") ~= nil) and text or nil
        afterFilter()
    end)
    Kit.dropdown(content, LEFT, TOP + FILTER_STEP, COLUMN_W, FILTER_H, {
        { label = "NPCs and items", value = "any" }, { label = "NPCs", value = "npc" }, { label = "Items", value = "item" } },
        kindFilter or "any", function(value)
            kindFilter = (value ~= "any") and value or nil
            afterFilter()
        end)
    local ok, err = pcall(SetsViewer.redraw)
    if not ok then
        Logger.error("sets window failed:", err)
    end
end

-- Closes the window and forgets what was drawn (the picked set and page are kept).
function SetsViewer.close()
    clearGrid()
    for _, row in ipairs(rows) do
        pcall(function() row.grip:Destroy() end)
        pcall(function() row.root:Destroy() end)
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content = nil, nil
    widgets, rows, scrollBar = {}, {}, {}
    drawnKey = nil
end

-- Opens the window if it is closed, and closes it if it is open.
function SetsViewer.toggle(newApi)
    if window ~= nil then
        SetsViewer.close()
    else
        SetsViewer.open(newApi)
    end
end

-- True while the window is open.
function SetsViewer.isOpen()
    return window ~= nil
end

-- What is showing, for tests.
function SetsViewer.debugInfo()
    local set = selectedSet()
    return { open = window ~= nil, selected = selectedId, page = page,
        pages = set ~= nil and pageCount(Sets.cardsOf(set)) or 0, listTop = listTop, cards = #gridParts,
        shown = #shownSets }
end

return SetsViewer
