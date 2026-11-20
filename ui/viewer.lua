-- ui/viewer.lua
-- The collection viewer: every card in the game, searchable and filterable, owned or not. Which cards show is core/browse.lua; this
-- file is the window and what it does when the filter, the page or the picked card changes. The filters are kept while the plugin
-- runs. Two views of the same cards, switched by the swap button in the title bar:
--   list  a tile per card (name, rarity, copies) with the picked card large beside it and what is known about it under that
--   grid  the cards themselves, 8 a page (4 on a short screen) with their counts; clicking one opens it in the list
-- ui/viewerfilters.lua is the filter bar, ui/viewerlist.lua the list and the picked card, ui/viewergrid.lua the grid and
-- ui/viewerlayout.lua where everything sits.
--
-- The state is one table, `V`, which the pieces are given: V.kept is what the player chose, kept between openings (the filter,
-- the view, the page, the picked card, the finishes picked), and V.open is the window and everything drawn in it, made by
-- open() and nil once it is closed. The functions the pieces call back are fields of V (refreshView, refilter, showInList...).

local Logger = require("core/logger")
local Browse = require("core/browse")
local Memory = require("core/memory")
local Kit = require("ui/kit")
local Util = require("ui/util")
local readNumber = Util.readNumber
local CollectionLayout = require("ui/collectionlayout")
local ViewerFilters = require("ui/viewerfilters")
local ViewerGrid = require("ui/viewergrid")
local ViewerLayout = require("ui/viewerlayout")
local ViewerList = require("ui/viewerlist")

local Viewer = {}
Viewer.layoutFor = ViewerLayout.layoutFor

-- open: { api (api.getState()), window, content, layout (ViewerLayout.layoutFor), widgets, dropdowns (by filter field), rows (the
-- list's tiles, made once), gridParts, detailParts, detailKey (the card the detail panel shows), titleButton (the swap button),
-- entries (what the filter finds), watchedState and watchedStamp (the collection as the list was last worked out from it),
-- shownCategories }.
local V = {
    kept = { filter = { owned = "all", sort = "rarity" }, filterStarted = false, gridView = false, page = 1,
        selectedKey = nil,                    -- the id of the card shown beside the list
        chosenFinish = {} },                  -- { card id = finish } picked with a card's finish toggles
    open = nil,
}

-- The collection as the viewer shows it: the cards of a pack being opened that have not been turned over yet are left out
-- (api.hiddenCards, if the plugin has it, says which).
function V.viewState(state)
    local api = V.open.api
    return Browse.visibleState(state, api.hiddenCards ~= nil and api.hiddenCards() or nil)
end

function V.destroyAll(list)
    if #list > 0 then
        Memory.collectSoon()                 -- (the cards destroyed here are freed by a collection soon, see core/memory.lua)
    end
    Util.destroyAll(list)
end

-- The finish a card is shown in (see Browse.shownFinish), and showing it in another it is owned in (a toggle under it).
function V.shownFinish(entry)
    return Browse.shownFinish(entry, V.kept.chosenFinish[entry.card.id])
end

function V.chooseFinish(entry, finish)
    V.kept.chosenFinish[entry.card.id] = finish
    V.refreshView()
end

local function perPage()
    local layout = V.open.layout
    return V.kept.gridView and layout.gridPerPage or layout.listRows
end

function V.pageCount()
    return math.max(1, math.ceil(#V.open.entries / perPage()))
end

-- The mouse wheel turns the pages: down for the next, up for the previous (and stops at the first and the last, where
-- the Prev and Next buttons wrap round).
function V.wheelPage(delta)
    Logger.debug("viewer: mouse wheel", tostring(delta))
    if V.open == nil or type(delta) ~= "number" or delta == 0 then
        return
    end
    local target = CollectionLayout.wheel(V.kept.page, V.pageCount(), delta)
    if target ~= V.kept.page then
        V.kept.page = target
        V.refreshView()
    end
end

-- Shows the list (from the grid, or already there) with `key` picked, on the page it is on.
function V.showInList(key)
    local o, kept = V.open, V.kept
    if o == nil then
        return
    end
    kept.selectedKey = key
    kept.gridView = false
    for index, entry in ipairs(o.entries) do
        if entry.card.id == key then
            kept.page = (index - 1) // o.layout.listRows + 1
            break
        end
    end
    V.refreshView()
end

-- The swap button: from the list to the grid, and back. Going to the grid shows the page the picked card is on; going
-- back to the list picks the first card the grid was showing.
local function swapView()
    local o, kept = V.open, V.kept
    local perGridPage = o.layout.gridPerPage
    if kept.gridView then
        local first = o.entries[(kept.page - 1) * perGridPage + 1]
        V.showInList(first ~= nil and first.card.id or kept.selectedKey)
        return
    end
    local index = 1
    for position, entry in ipairs(o.entries) do
        if entry.card.id == kept.selectedKey then
            index = position
            break
        end
    end
    kept.gridView = true
    kept.page = (index - 1) // perGridPage + 1
    V.refreshView()
end

-- Draws what the current page, view and picked card need. Called when any of those change (when the filter does,
-- V.refilter works out the cards again first).
function V.refreshView()
    local o, kept = V.open, V.kept
    if o == nil then
        return
    end
    kept.page = math.max(1, math.min(kept.page, V.pageCount()))
    if kept.gridView then
        ViewerList.hide(V, true)
    else
        ViewerList.show(V)
    end
    ViewerGrid.show(V)
    ViewerList.showDetail(V)
    o.widgets.pageText.content = "Page " .. kept.page .. " of " .. V.pageCount()
end

-- Works out the cards the filter finds, and shows them from the first page. With `follow` = true it shows the page the
-- picked card is on instead (when it is still among them), and with "stay" the page that was showing.
function V.refilter(follow)
    local o, kept = V.open, V.kept
    if o == nil then
        return
    end
    local state = o.api.getState()
    if state == nil then
        Viewer.close()
        return
    end
    ViewerFilters.updateCategories(V)
    local view = V.viewState(state)
    o.watchedState, o.watchedStamp = state, Browse.stamp(view)
    o.entries = Browse.entries(view, kept.filter)
    local counts = Browse.counts(view, kept.filter)
    -- (the whole deck, a card counted when the player has it in any finish)
    local whole = Browse.counts(view, {})
    o.widgets.counts.content = counts.owned .. " of " .. counts.cards .. " cards owned"
        .. "   |   Whole collection: " .. whole.owned .. " / " .. whole.cards
    local pageBefore = kept.page
    kept.page = 1
    local keep, position = false, nil
    for index, entry in ipairs(o.entries) do
        if entry.card.id == kept.selectedKey then
            keep, position = true, index
            break
        end
    end
    if not keep then
        kept.selectedKey = o.entries[1] ~= nil and o.entries[1].card.id or nil
    elseif follow == true then
        kept.page = (position - 1) // perPage() + 1    -- the picked card stays in view
    end
    if follow == "stay" then
        kept.page = pageBefore
    end
    V.refreshView()
end

-- Called about every 0.6 seconds (by the plugin's tick). When the collection has changed while the viewer is open (a pack
-- was opened, or a card won) the list, counts and picked card are worked out again, on the page that was showing. Closes
-- the viewer if there is no character any more.
function Viewer.refresh()
    local o = V.open
    if o == nil then
        return
    end
    local state = o.api.getState()
    if state == nil then
        Viewer.close()
        return
    end
    if state ~= o.watchedState or Browse.stamp(V.viewState(state)) ~= o.watchedStamp then
        V.refilter("stay")
    end
end

-- One line in the log when the viewer opens: the screen's size in units, the interface scale setting and what the viewer
-- made of them. For a report that the window does not fit.
local function logScreen(gameWindow, screenHeight, layout)
    local scale = readNumber(function() return game.options.InterfaceScale.setting end)
    local label = nil
    pcall(function() label = game.options.InterfaceScale:GetLabel(scale) end)
    Logger.note("collection viewer: screen", tostring(readNumber(function() return gameWindow.width end)), "x",
        tostring(screenHeight), "units | interface scale setting", tostring(scale), "(" .. tostring(label) .. ")",
        "| list rows", layout.listRows, "| grid rows", layout.gridRows, "at scale", layout.gridScale, "| picked card at",
        layout.detailScale, "| window", layout.height + Kit.titleBarHeight(), "units tall")
end

-- Opens the viewer. `newApi` needs getState().
function Viewer.open(newApi)
    if V.open ~= nil or newApi.getState() == nil then
        return
    end

    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local screenHeight = readNumber(function() return gameWindow.height end)
    local layout = ViewerLayout.layoutFor(screenHeight)
    logScreen(gameWindow, screenHeight, layout)
    local o = { api = newApi, layout = layout, widgets = {}, dropdowns = {}, rows = {}, gridParts = {}, detailParts = {},
        entries = {} }
    local width = ViewerLayout.CONTENT_W + 2 * ViewerLayout.MARGIN + CollectionLayout.FRAME
    o.window, o.content = Kit.window(gameWindow, "Collection", width, layout.height + Kit.titleBarHeight(), function()
        Viewer.close()
    end, { xAnchor = 0.3, yAnchor = 0.02 })
    V.open = o

    -- The swap button goes in the title bar.
    o.titleButton = Kit.titleButton(o.window, "SWAP", swapView, "Switch between the list and the grid")

    -- The page buttons and counts first, then the list, then the filters: a drop-down's list is drawn over what is
    -- made before it. The counts are under the first two columns, the page and its buttons under the last two.
    local kept = V.kept
    o.widgets.counts, o.widgets.pageText = CollectionLayout.footer(o.content, ViewerLayout.LEFT, layout.footerY, function()
        kept.page = CollectionLayout.turn(kept.page, V.pageCount(), -1)
        V.refreshView()
    end, function()
        kept.page = CollectionLayout.turn(kept.page, V.pageCount(), 1)
        V.refreshView()
    end)
    if not kept.filterStarted then
        kept.filter, kept.filterStarted = ViewerFilters.default(V), true
    end
    Kit.onWheel(o.content, V.wheelPage)
    ViewerList.build(V)
    ViewerFilters.build(V)
    V.refilter()
end

-- Closes the window and forgets what was drawn (the filters are kept).
function Viewer.close()
    local o = V.open
    if o == nil then
        return
    end
    V.destroyAll(o.gridParts)
    V.destroyAll(o.detailParts)
    for _, dropdown in pairs(o.dropdowns) do
        pcall(function() dropdown.destroy() end)
    end
    for _, row in ipairs(o.rows) do
        pcall(function() row.grip:Destroy() end)
        pcall(function() row.root:Destroy() end)
    end
    if o.titleButton ~= nil then
        pcall(function() o.titleButton:Destroy() end)
    end
    pcall(function() o.window:Destroy() end)
    V.open = nil
end

-- True while the window is open.
function Viewer.isOpen()
    return V.open ~= nil
end

-- True while the window is open and showing the grid (not the list).
function Viewer.isGrid()
    return V.open ~= nil and V.kept.gridView
end

-- The component of the button that swaps the list and the grid, for the tutorial's pointer: "grid". nil if the window
-- is not open.
function Viewer.anchor(name)
    local control = V.open ~= nil and name == "grid" and V.open.titleButton or nil
    if control == nil then
        return nil
    end
    return control.root or control
end

-- The viewer's state, for tests: { kept, open (nil while closed), refilter... } as described at the top.
function Viewer.state()
    return V
end

return Viewer
