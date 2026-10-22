-- viewer.lua
-- The collection viewer: a paged grid of the cards the player owns.
--
-- Every variant the player owns (a card + finish) gets its own slot, so a
-- holo Hans is shown separately from a standard Hans. A toggle adds a dimmed placeholder
-- for every variant of every card that is not owned yet, which turns the grid into a
-- checklist.
--
-- Cards are created directly in the window, one layer deep, as the preview window does.

local Cards = require("cards")
local Storage = require("storage")
local CardView = require("cardview")
local Kit = require("kit")

local Viewer = {}

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR
local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)
local DIM = Vector4.new(0.60, 0.60, 0.65, 1.0)
local GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
local CYAN = Vector4.new(0.45, 0.90, 1.0, 1.0)
local PURPLE = Vector4.new(0.80, 0.55, 1.0, 1.0)
local BAR_BACK = Vector4.new(0.10, 0.10, 0.13, 1.0)
local BAR_BASE = Vector4.new(0.55, 0.70, 0.80, 1.0)

-- Layout. Change COLS and ROWS to fit more or fewer cards on a page. The buttons and counts
-- sit in a panel down the right-hand side.
local COLS, ROWS = 3, 2
local TILE_W = CardView.WIDTH + 10
local TILE_H = CardView.HEIGHT + 40     -- the card, then a variant line and a count line
local TOP = 10
local SIDE_W = 184                       -- width of the side panel; PrettyUI buttons are as wide as their label needs (about 168 for "Unowned") or this, whichever is larger
local LEFT = Kit.available() and 5 or 10   -- left margin: PrettyUI's content area already starts further in
-- Gap between the last card column and the side panel. With PrettyUI the buttons draw wider than
-- the panel box, so this is small: it makes the gap left of the buttons match the one to their right.
local SIDE_GAP = Kit.available() and -1 or 10
local SIDE_X = LEFT + COLS * TILE_W + SIDE_GAP   -- left edge of the side panel
local WIDTH = SIDE_X + SIDE_W + (Kit.available() and 26 or 10)   -- the extra keeps the window as wide as before
local HEIGHT = TOP + ROWS * TILE_H + 10
local PER_PAGE = COLS * ROWS

-- Display order for a card's variants: standard first, then by finish.
local FINISH_ORDER = { normal = 1, reverse = 2, holo = 3 }

local api = nil          -- api.getState() : the logged-in character's collection, or nil
local window = nil
local content = nil      -- the component inside the window frame that everything is built in
local widgets = {}
local parts = {}         -- everything drawn for the current page, destroyed on page change
local page = 1
local pages = 1
local shown = 0          -- how many slots the current page is showing
local showUnowned = false

-- Builds the list of slots to show, in order. Each slot is
--   { card, finish, count, locked }
-- With `includeUnowned`, every variant a card can be pulled in that the player does not own
-- gets a `locked` placeholder slot (count 0): one for each finish.
-- Variants the player owns always show, even if the card's data no longer offers them.
-- Pure function of the collection, so it can be tested without any UI.
function Viewer.buildEntries(state, includeUnowned)
    local ownedByCard = {}
    for key, count in pairs(state.owned) do
        local cardId, finish = Cards.parseKey(key)
        if cardId ~= nil and Cards.byId[cardId] ~= nil then
            local list = ownedByCard[cardId]
            if list == nil then
                list = {}
                ownedByCard[cardId] = list
            end
            list[finish] = { finish = finish, count = count, locked = false }
        end
    end

    local entries = {}
    for _, card in ipairs(Cards.list) do
        local slots = ownedByCard[card.id] or {}
        if includeUnowned then
            for finish in pairs(Cards.finishes) do
                if slots[finish] == nil then
                    slots[finish] = { finish = finish, count = 0, locked = true }
                end
            end
        end

        local list = {}
        for _, slot in pairs(slots) do
            slot.card = card
            list[#list + 1] = slot
        end
        table.sort(list, function(a, b)
            local finA, finB = FINISH_ORDER[a.finish] or 99, FINISH_ORDER[b.finish] or 99
            if finA ~= finB then return finA < finB end
            return a.finish < b.finish
        end)
        for _, slot in ipairs(list) do
            entries[#entries + 1] = slot
        end
    end
    return entries
end

local makeText = Kit.text

-- Buttons live in the window's content area.
local function makeButton(label, x, y, w, h, onPress)
    return Kit.button(content, label, x, y, w, h, onPress)
end

-- Progress bars in the side panel: how much of each finish (and of everything) is collected.
-- Each is a text line with a bar under it: a dark rectangle with a coloured one on top that
-- is as wide as the fraction collected.
local BAR_W, BAR_H = SIDE_W - 24, 12
local BARS = {
    { key = "normal",  label = "Base set",     colour = BAR_BASE },
    { key = "reverse", label = "Reverse holo", colour = PURPLE },
    { key = "holo",    label = "Holo",         colour = CYAN },
    { key = "all",     label = "Total",        colour = GOLD },
}
local BARS_TOP = 200
local BAR_STEP = 44

local function buildBars()
    for i, bar in ipairs(BARS) do
        local y = BARS_TOP + (i - 1) * BAR_STEP
        local x = SIDE_X + (SIDE_W - BAR_W) // 2
        bar.text = makeText(content, SIDE_X, y, SIDE_W, 20, "", WHITE)
        bar.back = ui.Rectangle.new(content)
        bar.back:SetPos(x, y + 22)
        bar.back:SetSize(BAR_W, BAR_H)
        bar.back.fill = true
        bar.back.colour = BAR_BACK
        bar.fill = ui.Rectangle.new(content)
        bar.fill:SetPos(x, y + 22)
        bar.fill:SetSize(1, BAR_H)
        bar.fill.fill = true
        bar.fill.colour = bar.colour
        bar.x = x
    end
end

local function updateBars(state)
    local progress = Storage.progress(state)
    for _, bar in ipairs(BARS) do
        local p = progress[bar.key]
        bar.text.content = bar.label .. ": " .. p.owned .. " / " .. p.total
        local width = (p.total > 0) and math.floor(BAR_W * p.owned / p.total + 0.5) or 0
        pcall(function() bar.fill.hidden = (width <= 0) end)
        bar.fill:SetSize(math.max(width, 1), BAR_H)
    end
end

local function destroyBars()
    for _, bar in ipairs(BARS) do
        for _, part in ipairs({ bar.text, bar.back, bar.fill }) do
            pcall(function() part:Destroy() end)
        end
        bar.text, bar.back, bar.fill = nil, nil, nil
    end
end

local function clearPage()
    for _, part in ipairs(parts) do
        part:Destroy()
    end
    parts = {}
    shown = 0
end

-- The text under a card: which variant it is, coloured so special ones stand out.
local function variantLabel(entry)
    local names = {}
    if entry.finish ~= "normal" then
        names[#names + 1] = Cards.finishes[entry.finish].name
    end
    if entry.locked then
        return (#names == 0) and "Standard" or table.concat(names, " "), DIM
    end
    if #names == 0 then
        return "Standard", GREY
    end
    local colour = CYAN
    if entry.finish == "reverse" then colour = PURPLE end
    return table.concat(names, " "), colour
end

local function showPage()
    local state = api.getState()
    if state == nil then
        Viewer.close()
        return
    end

    local entries = Viewer.buildEntries(state, showUnowned)
    pages = math.max(1, math.ceil(#entries / PER_PAGE))
    if page > pages then page = pages end
    if page < 1 then page = 1 end

    clearPage()
    local first = (page - 1) * PER_PAGE
    for slot = 1, PER_PAGE do
        local entry = entries[first + slot]
        if entry == nil then
            break
        end
        local col = (slot - 1) % COLS
        local row = (slot - 1) // COLS
        local x = LEFT + col * TILE_W
        local y = TOP + row * TILE_H

        local view = CardView.create(content, entry.card, { locked = entry.locked, finish = entry.finish })
        view.root:SetPos(x, y)
        parts[#parts + 1] = view.root

        local variantText, colour = variantLabel(entry)
        parts[#parts + 1] = makeText(content, x, y + CardView.HEIGHT + 2, CardView.WIDTH, 18, variantText, colour)
        if entry.locked then
            parts[#parts + 1] = makeText(content, x, y + CardView.HEIGHT + 20, CardView.WIDTH, 18,
                "Not collected", DIM)
        else
            parts[#parts + 1] = makeText(content, x, y + CardView.HEIGHT + 20, CardView.WIDTH, 18,
                "Owned: " .. entry.count, WHITE)
        end
        shown = shown + 1
    end
    if #entries == 0 then
        parts[#parts + 1] = makeText(content, LEFT, TOP + 20, COLS * TILE_W, 24, "No cards yet. Open a pack!", GREY)
    end

    updateBars(state)
    widgets.pageText.content = "Page " .. page .. " of " .. pages
    -- PrettyUI buttons are too narrow for "Unowned: Off", so there the state shows as a colour
    -- (green when on); plain buttons spell it out.
    if Kit.available() then
        -- The label is never changed here: changing a PrettyUI button's text after it is made
        -- resizes it to fit the text, which breaks the alignment with the buttons above it.
        Kit.setStyle(widgets.toggle, showUnowned and "positive" or "neutral")
    else
        Kit.setLabel(widgets.toggle, "Unowned: " .. (showUnowned and "On" or "Off"))
    end
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
    window, content = Kit.window(gameWindow, "Collection", WIDTH, HEIGHT + Kit.titleBarHeight(), function()
        Viewer.close()
    end, 0.35, 0.05)

    -- Side panel, top to bottom: page number, Prev / Next, the unowned toggle, Close.
    local bx, bw = SIDE_X, SIDE_W
    widgets.pageText = makeText(content, bx, 10, bw, 24, "", GREY)
    makeButton("Prev", bx, 40, bw, 32, function()
        page = page - 1
        if page < 1 then page = pages end
        showPage()
    end)
    makeButton("Next", bx, 80, bw, 32, function()
        page = page + 1
        if page > pages then page = 1 end
        showPage()
    end)
    widgets.toggle = makeButton(Kit.available() and "Unowned" or "", bx, 140, bw, 32, function()
        showUnowned = not showUnowned
        page = 1
        showPage()
    end)
    -- Without PrettyUI there is no title bar close button, so keep a Close button.
    if not Kit.available() then
        makeButton("Close", bx, HEIGHT - 42, bw, 32, function()
            Viewer.close()
        end)
    end

    buildBars()
    page = 1
    showPage()
end

function Viewer.close()
    destroyBars()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
    content = nil
    widgets = {}
    parts = {}
    shown = 0
end

function Viewer.isOpen()
    return window ~= nil
end

-- Page state, for tests.
function Viewer.debugInfo()
    return { open = window ~= nil, page = page, pages = pages, shown = shown, showUnowned = showUnowned }
end

return Viewer
