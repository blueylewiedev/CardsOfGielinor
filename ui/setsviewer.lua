-- ui/setsviewer.lua
-- The Sets window: the sets in deck/sets.lua (every shopkeeper, every musician...) and how much of each the player
-- has. Which cards a set holds is core/sets.lua; this file is the window and the picked set's page. The picked set is kept
-- while the plugin runs.
--   left a search box and an NPCs / items drop-down over a tile per set ("3 / 4", gold when complete), with a scroll bar when there
--     are more than fit (ui/setslist.lua)
--   right the picked set's name, progress and bar, then its cards, 6 a page (3 on a short
--     screen). A card the player does not have is a shadow
--          silhouette with its name and rarity and the packs it comes in where its description
--            would be (CardView opts.silhouette and lockedText).
-- ui/setslayout.lua is where everything sits.
--
-- The state is one table, `S`, which ui/setslist.lua is given: S.kept is what the player chose, kept between openings (the picked
-- set and page, the list's place, the search and the drop-down), and S.open is the window and everything drawn in it, made by
-- open() and nil once it is closed. S.redraw is what a change in the list calls.

local Cards = require("core/cards")
local Sets = require("core/sets")
local Browse = require("core/browse")
local Packs = require("core/packs")
local Logger = require("core/logger")
local CardView = require("ui/cardview")
local CardArt = require("ui/cardart")
local Kit = require("ui/kit")
local Theme = require("ui/theme")
local WHITE, GREY, GOLD, DIM = Theme.WHITE, Theme.GREY, Theme.GOLD, Theme.DIM
local Util = require("ui/util")
local setHidden, destroyAll, toVec4, readNumber = Util.setHidden, Util.destroyAll, Util.toVec4, Util.readNumber
local CollectionLayout = require("ui/collectionlayout")
local panel = CollectionLayout.panel
local SetsLayout = require("ui/setslayout")
local SetsList = require("ui/setslist")
local TOP, BODY_Y, GRID_COLS, COLUMN_W, GRID_X, GRID_W, columnX = SetsLayout.TOP, SetsLayout.BODY_Y, SetsLayout.GRID_COLS,
    SetsLayout.COLUMN_W, SetsLayout.GRID_X, SetsLayout.GRID_W, SetsLayout.columnX

local SetsViewer = {}
SetsViewer.layoutFor = SetsLayout.layoutFor

local BAR_BACK = Vector4.new(0.18, 0.16, 0.13, 0.95)
local BAR_FILL = Vector4.new(0.85, 0.68, 0.16, 0.95)

-- open: { api (api.getState(), api.hiddenCards() (optional)), window, content, layout (see SetsLayout.layoutFor), widgets
-- (text and buttons that stay while the window is open), rows (the set list's tiles, made once), gridParts (what the grid
-- draws for the current page), shownSets (the sets the search and the drop-down let through, worked out on each redraw),
-- shownRows (the list's rows from them: group headings, and the sets of the open groups; see ui/setslist.lua),
-- scrollBar (its track, thumb and grip, and a drag of it while held), watchedState and watchedStamp (the collection as
-- the window was last drawn from it), drawnKey (what the grid shows, so a tick with nothing new does not rebuild the cards) }.
local S = {
    kept = { selectedId = nil,                -- the id of the set shown
        listTop = 0,                          -- how many rows the list has scrolled past
        openGroups = {},                      -- the groups opened in the list, as { [group name] = true }
        search = nil,                         -- what is typed in the search box (nil: nothing)
        kindFilter = nil,                     -- "npc" or "item": only the sets with cards of that kind (nil: both)
        page = 1 },
    open = nil,
}

-- The collection as the window shows it: the cards of a pack being opened that have not been turned over yet are left out
-- (api.hiddenCards, if the plugin has it, says which).
local function viewState(state)
    local api = S.open.api
    return Browse.visibleState(state, api.hiddenCards ~= nil and api.hiddenCards() or nil)
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

-- What a card the player does not have says in place of its description: the packs it comes in, with " pack" taken
-- off, in the 3 lines of about 17 to 19 letters the description box holds (the Standard pack is left out unless it is
-- the only one). dev/check_sets_ui.lua checks every card fits.
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

-- Destroys the grid's cards, and forgets the turns their silhouettes were to be sent again (CardArt.applyPending).
local function clearGrid()
    destroyAll(S.open.gridParts)
    CardArt.clearPending()
end

local function selectedSet()
    local id = S.kept.selectedId
    return id ~= nil and Sets.byId[id] or nil
end

local function pageCount(cards)
    return math.max(1, math.ceil(#cards / S.open.layout.gridPerPage))
end

local function wheelPage(delta)
    local set = selectedSet()
    if S.open == nil or set == nil or type(delta) ~= "number" or delta == 0 then
        return
    end
    local target = CollectionLayout.wheel(S.kept.page, pageCount(Sets.cardsOf(set)), delta)
    if target ~= S.kept.page then
        S.kept.page = target
        S.redraw()
    end
end

-- The current page of the set's cards, in the grid. Only rebuilt when the set, the page or what the player has of it changes.
local function showCards(state, set, cards)
    local o, kept = S.open, S.kept
    local layout = o.layout
    local perPage = layout.gridPerPage
    local first = (kept.page - 1) * perPage
    local owned = Browse.ownedByCard(state)          -- { card id = { finish = copies } }
    local keyParts = { set.id, tostring(kept.page) }
    for slot = 1, perPage do
        local card = cards[first + slot]
        if card ~= nil then
            keyParts[#keyParts + 1] = card.id .. "=" .. copiesOf(owned[card.id])
        end
    end
    local key = table.concat(keyParts, "|")
    if key == o.drawnKey then
        return
    end
    o.drawnKey = key
    clearGrid()
    local content, gridParts = o.content, o.gridParts
    for slot = 1, perPage do
        local card = cards[first + slot]
        if card == nil then
            break
        end
        local copies = copiesOf(owned[card.id])
        local locked = copies == 0
        local x = columnX((slot - 1) % GRID_COLS + 2) + (COLUMN_W - layout.cardW) // 2
        local y = BODY_Y + ((slot - 1) // GRID_COLS) * layout.tileH
        local view = CardView.create(content, card, { locked = locked, silhouette = true, scale = layout.scale,
            -- (every finish counts towards the set; a card is shown as the collection shows it, the rarest finish first)
            lockedText = locked and lockedText(card) or nil,
            finish = Browse.preferredFinish(owned[card.id]) })
        view.root:SetPos(x, y)
        gridParts[#gridParts + 1] = view.root

        -- the caption: a bar under the card in the rarity's own colour
        local rarity = Cards.rarities[card.rarity]
        local caption, back, border = panel(content, x, y + layout.cardH + 6, layout.cardW, 30)
        back.colour = toVec4(rarity.colour, locked and 0.08 or 0.22)
        border.colour = toVec4(rarity.colour, locked and 0.35 or 0.8)
        Kit.text(caption, 0, 0, layout.cardW, 30, locked and "Not collected" or ("Owned: " .. copies),
            locked and DIM or GOLD)
        gridParts[#gridParts + 1] = caption

        -- the wheel over a card turns the page
        local grip = ui.Layer.new(content)
        grip.clickthrough = false
        grip:SetPos(x, y)
        grip:SetSize(layout.cardW, layout.cardH + 36, 0, 0)
        Kit.onWheel(grip, wheelPage)
        gridParts[#gridParts + 1] = grip
    end
    if #cards == 0 then
        gridParts[#gridParts + 1] = Kit.text(content, GRID_X, BODY_Y + 20, GRID_W, 24, "This set has no cards yet.", GREY)
    end
end

-- The header (name, progress and bar) and the current page of the set's cards.
local function showSet(state, ownedIds)
    local o, kept = S.open, S.kept
    local widgets, layout = o.widgets, o.layout
    local set = selectedSet()
    if set == nil then
        clearGrid()
        o.drawnKey = nil
        widgets.setName.content = #Sets.list == 0 and "There are no sets yet."
            or (#o.shownSets == 0 and "No set matches." or "Click a set to see its cards.")
        widgets.setProgress.content = ""
        widgets.pageText.content = ""
        setHidden(widgets.barFill, true)
        return
    end
    local cards = Sets.cardsOf(set)
    kept.page = math.max(1, math.min(kept.page, pageCount(cards)))
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
    widgets.pageText.content = "Page " .. kept.page .. " of " .. pageCount(cards)

    showCards(state, set, cards)
end

-- ----- the window -------------------------------------------------------------------------------------------

-- Draws the list, the picked set and the footer from the collection as it is now.
function S.redraw()
    local o, kept = S.open, S.kept
    if o == nil then
        return
    end
    local state = o.api.getState()
    if state == nil then
        SetsViewer.close()
        return
    end
    local view = viewState(state)
    o.watchedState, o.watchedStamp = state, Browse.stamp(view)
    local ownedIds = Sets.ownedIds(view)
    SetsList.find(S)
    local listRows = o.layout.listRows
    kept.listTop = math.max(0, math.min(kept.listTop, #o.shownRows - listRows))
    SetsList.show(S, view, ownedIds)
    showSet(view, ownedIds)
    local complete = 0
    for _, set in ipairs(Sets.list) do
        local progress = Sets.progress(view, set, ownedIds)
        if progress.cards > 0 and progress.owned == progress.cards then
            complete = complete + 1
        end
    end
    o.widgets.footer.content = "Sets complete: " .. complete .. " of " .. #Sets.list
        .. (#o.shownSets < #Sets.list and ("   |   Showing " .. #o.shownSets) or "")
        .. (#o.shownRows > listRows and "   |   Scroll the list for more" or "")
end

-- Called about every 0.6 seconds (by the plugin's tick). Draws again when the collection has changed while the window
-- is open (a pack was opened, or a card won). Closes the window if there is no character any more.
function SetsViewer.refresh()
    local o = S.open
    if o == nil then
        return
    end
    CardArt.applyPending()
    SetsList.tick(S)
    local state = o.api.getState()
    if state == nil then
        SetsViewer.close()
        return
    end
    if state ~= o.watchedState or Browse.stamp(viewState(state)) ~= o.watchedStamp then
        S.redraw()
    end
end

-- One line in the log when the window opens: the screen's size in units and what the window made of it. For a report that
-- the window does not fit.
local function logScreen(gameWindow, screenHeight, layout)
    Logger.note("sets window: screen", tostring(readNumber(function() return gameWindow.width end)), "x",
        tostring(screenHeight), "units | grid rows", layout.gridRows, "at card scale", layout.scale, "| list rows", layout.listRows,
        "| window", layout.height + Kit.titleBarHeight(), "units tall")
end

-- Opens the window. `newApi` needs getState(), and can have hiddenCards().
function SetsViewer.open(newApi)
    if S.open ~= nil or newApi.getState() == nil then
        return
    end
    local kept = S.kept
    if selectedSet() == nil then
        kept.selectedId = Sets.list[1] ~= nil and Sets.list[1].id or nil
        kept.page = 1
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local screenHeight = readNumber(function() return gameWindow.height end)
    local layout = SetsLayout.layoutFor(screenHeight)
    logScreen(gameWindow, screenHeight, layout)
    local o = { api = newApi, layout = layout, widgets = {}, rows = {}, gridParts = {}, shownSets = {}, shownRows = {},
        scrollBar = {} }
    local width = SetsLayout.CONTENT_W + SetsLayout.WINDOW_SLACK
    o.window, o.content = Kit.window(gameWindow, "Sets", width, layout.height + Kit.titleBarHeight(), function()
        SetsViewer.close()
    end, { xAnchor = 0.35, yAnchor = 0.04 })
    S.open = o
    local content, widgets = o.content, o.widgets

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

    local function turn(step)
        local set = selectedSet()
        if set == nil then
            return
        end
        kept.page = CollectionLayout.turn(kept.page, pageCount(Sets.cardsOf(set)), step)
        S.redraw()
    end
    widgets.footer, widgets.pageText = CollectionLayout.footer(content, SetsLayout.LEFT, layout.footerY,
        function() turn(-1) end, function() turn(1) end)
    Kit.onWheel(content, wheelPage)
    SetsList.build(S)
    SetsList.buildFilter(S)
    local ok, err = pcall(S.redraw)
    if not ok then
        Logger.error("sets window failed:", err)
    end
end

-- Closes the window and forgets what was drawn (the picked set and page are kept).
function SetsViewer.close()
    local o = S.open
    if o == nil then
        return
    end
    clearGrid()
    for _, row in ipairs(o.rows) do
        pcall(function() row.grip:Destroy() end)
        pcall(function() row.root:Destroy() end)
    end
    pcall(function() o.window:Destroy() end)
    S.open = nil
    Util.emptied(o)                    -- (the scroll bar's handlers hold it)
end

-- Opens the window if it is closed, and closes it if it is open.
function SetsViewer.toggle(newApi)
    if S.open ~= nil then
        SetsViewer.close()
    else
        SetsViewer.open(newApi)
    end
end

-- True while the window is open.
function SetsViewer.isOpen()
    return S.open ~= nil
end

-- The window's state, for tests: { kept, open (nil while closed) } as described at the top.
function SetsViewer.state()
    return S
end

return SetsViewer
