-- ui/stats.lua
-- The Stats window, three tabs (it can be resized; a tab scrolls when taller than the room):
--   Collection         progress bars for all cards, NPC cards, item cards, foils, holos and each rarity
--   Regions            a bar per region in two columns, and one for the cards with no region
--   Packs and credits  an overview (packs, cards, credits earned and spent, time played, average credits per hour) beside the pull rates
--
-- The bars come from Browse.progress, counted in one pass and kept a few seconds (the window refreshes every tick); cards from a pack
-- still being opened do not count until turned over. Stats.overview and Stats.pullRates have no UI, so they are tested on their own.
-- A tab is built to its page's width and built again a moment after the window stops being resized.

local Cards = require("core/cards")
local TagWords = require("core/tagwords")
local Browse = require("core/browse")
local Rate = require("core/rate")
local Format = require("core/format")
local Logger = require("core/logger")
local Anim = require("ui/anim")
local Kit = require("ui/kit")
local Bars = require("ui/bars")
local Events = require("core/events")
local Theme = require("ui/theme")
local WHITE, GREY, GOLD = Theme.WHITE, Theme.GREY, Theme.GOLD

local Stats = {}

local GOLD_BAR = Vector4.new(0.85, 0.68, 0.16, 1.0)
-- The finishes' bars and pull rate lines (every finish but the plain one, Cards.specialFinishes), in their colours.
local FINISH_COLOURS = {}
for _, finish in ipairs(Cards.specialFinishes) do
    FINISH_COLOURS[finish] = Bars.colour(Cards.finishes[finish].colour)
end

local WINDOW_BORDER = 8                 -- PrettyUI's frame at each side of a window's content
local WIDTH = 560
local MIN_WIDTH, MIN_HEIGHT = 460, 190  -- the smallest the window can be made (its whole size, frame and title bar included)
local MARGIN = 10                       -- between a page's edges and what is on it, the same at both sides
local TOP_PAD = 14                      -- between the tab strip and what a tab starts with
local PAGE_H = 280                      -- the height a page starts with: room for the Collection tab, the tallest but one
local HEIGHT = Kit.TABS_HEIGHT + PAGE_H
local LINE_H = 22
local BAR_STEP = Bars.HEIGHT + 4
local COLUMN_GAP = 10
local CACHE_REFRESHES = 10              -- the bars are counted again after this many refreshes (about 6 seconds)
local RELAYOUT_AFTER = 0.25             -- seconds without the size changing before the tabs are built again

-- "3 (10.0%, 1 in 10)", or just "0" when nothing has been pulled yet.
local function rate(count, total)
    if total == 0 or count == 0 then
        return tostring(count)
    end
    return string.format("%d (%.1f%%, 1 in %.1f)", count, count * 100 / total, total / count)
end

-- The overview, the left half of the "Packs and credits" tab, as { text, colour } lines.
function Stats.overview(state)
    local s = state.stats
    local average = Rate.averagePerHour(s)
    return {
        { "Packs opened: " .. Format.credits(s.packsOpened), WHITE },
        { "Cards pulled: " .. Format.credits(s.cardsPulled), WHITE },
        { "Credits earned: " .. Format.credits(s.creditsEarned), WHITE },
        { "Credits spent: " .. Format.credits(s.creditsSpent), WHITE },
        { "Time played: " .. Format.duration((s.playTicks or 0) * Rate.SECONDS_PER_TICK), WHITE },
        { "Average credits per hour: " .. (average ~= nil and Format.credits(math.floor(average + 0.5)) or "-"), WHITE },
    }
end

-- The pull rates, the right half of the tab, as { text, colour } lines: each in its rarity's colour.
function Stats.pullRates(state)
    local s = state.stats
    local lines = {}
    for _, rarity in ipairs(Cards.rarityOrder) do
        local info = Cards.rarities[rarity]
        if info ~= nil then
            lines[#lines + 1] = { info.name .. ": " .. rate(s.rarities[rarity] or 0, s.cardsPulled), Bars.colour(info.colour) }
        end
    end
    -- (the finish is rolled apart from the rarity, so a foil or a holo is also one of the lines above)
    for _, finish in ipairs(Cards.specialFinishes) do
        lines[#lines + 1] = { Cards.finishes[finish].name .. ": " .. rate(s.finishes and s.finishes[finish] or 0, s.cardsPulled),
            FINISH_COLOURS[finish] }
    end
    return lines
end

local api = nil          -- api.getState() : the logged-in character's collection, or nil;
                         -- api.hiddenCards() : the cards of a pack being opened that have not been turned over
local window = nil
local content = nil
local tabs = nil         -- the tab strip: see Kit.tabStrip
local views = {}         -- tab index -> { refresh(progress, state), destroy(), width, height }
local current = 1        -- the tab shown (kept while the plugin runs)
local cache, cacheAge = nil, 0
local lastSize, sizeSince = nil, 0        -- the window's content size as last seen, and how long it has been that

-- The tabs' contents ---------------------------------------------------------------------------------------------------
-- Each `view*` builds one tab's contents in `page` for a page `width` wide, and returns { refresh(progress, state),
-- destroy(), height = how tall what it built is }.

local EMPTY = { owned = 0, cards = 0 }
local NO_REGION = "(no region)"           -- the key of the bar for the cards that have none

-- Two columns' x and width in a page `width` wide.
local function columns(width)
    local full = width - 2 * MARGIN
    local column = (full - COLUMN_GAP) // 2
    return MARGIN, full, column, MARGIN + column + COLUMN_GAP
end

local function viewProgress(page, width)
    local left, full, column, second = columns(width)
    local bars, y = {}, TOP_PAD
    bars.all = Bars.new(page, left, y, full, "All cards", nil, GOLD)
    y = y + BAR_STEP
    bars.npc = Bars.new(page, left, y, column, "NPC cards")
    bars.item = Bars.new(page, second, y, column, "Item cards")
    y = y + BAR_STEP
    -- a bar for each finish (but the plain one), two to a row
    for i, finish in ipairs(Cards.specialFinishes) do
        local colour = FINISH_COLOURS[finish]
        bars[finish] = Bars.new(page, (i % 2 == 1) and left or second, y, column, Cards.finishes[finish].name .. " cards",
            colour, colour)
        if i % 2 == 0 or i == #Cards.specialFinishes then
            y = y + BAR_STEP
        end
    end
    y = y + 4
    local heading = Kit.text(page, left, y, full, 20, "BY RARITY", GOLD, ui.AlignMode.TOPLEFT)
    y = y + 26
    local rarityBars = {}
    for i, id in ipairs(Cards.rarityOrder) do
        local rarity = Cards.rarities[id]
        if rarity ~= nil then
            local colour = Bars.colour(rarity.colour)
            rarityBars[id] = Bars.new(page, (i % 2 == 1) and left or second, y, column, rarity.name, colour, colour)
            if i % 2 == 0 then
                y = y + BAR_STEP
            end
        end
    end
    if #Cards.rarityOrder % 2 == 1 then
        y = y + BAR_STEP
    end
    return {
        height = y,
        refresh = function(p)
            bars.all.set(p.all.owned, p.all.cards)
            local npc, item = p.kinds.npc or EMPTY, p.kinds.item or EMPTY
            bars.npc.set(npc.owned, npc.cards)
            bars.item.set(item.owned, item.cards)
            for _, finish in ipairs(Cards.specialFinishes) do
                local count = (p.finishes or {})[finish] or EMPTY
                bars[finish].set(count.owned, count.cards)
            end
            for id, bar in pairs(rarityBars) do
                local count = p.rarities[id] or EMPTY
                bar.set(count.owned, count.cards)
            end
        end,
        destroy = function()
            for _, bar in pairs(bars) do bar.destroy() end
            for _, bar in pairs(rarityBars) do bar.destroy() end
            pcall(function() heading:Destroy() end)
        end,
    }
end

local function viewRegions(page, width)
    local left, _, column, second = columns(width)
    local bars = {}
    local words = TagWords.words.regions or {}
    -- The regions, then the cards with no region at all, two to a row.
    local function place(index, key, label, fill, labelColour)
        local x = ((index - 1) % 2 == 0) and left or second
        local y = TOP_PAD + ((index - 1) // 2) * BAR_STEP
        -- (the numbers only: a region's name and its numbers and a percentage would not fit a column)
        bars[key] = Bars.new(page, x, y, column, label, fill, labelColour, { percent = false })
    end
    for i, word in ipairs(words) do
        place(i, word, Browse.label(word))
    end
    place(#words + 1, NO_REGION, "Global (no region)", GOLD_BAR, GOLD)
    return {
        height = TOP_PAD + ((#words + 2) // 2) * BAR_STEP,
        refresh = function(p)
            for key, bar in pairs(bars) do
                local count = (key == NO_REGION) and p.noRegion or p.regions[key] or EMPTY
                bar.set(count.owned, count.cards)
            end
        end,
        destroy = function()
            for _, bar in pairs(bars) do bar.destroy() end
        end,
    }
end

local function viewPacks(page, width)
    local left, _, column, second = columns(width)
    -- Two columns, each a heading over lines of text: `count` lines, made once and rewritten by refresh.
    local function makeColumn(x, heading, count)
        local col = { heading = Kit.text(page, x, TOP_PAD, column, 20, heading, GOLD, ui.AlignMode.TOPLEFT), texts = {} }
        for i = 1, count do
            col.texts[i] = Kit.text(page, x, TOP_PAD + 26 + (i - 1) * LINE_H, column, LINE_H, "", WHITE, ui.AlignMode.TOPLEFT)
        end
        return col
    end
    local function fill(col, lines)
        for i, text in ipairs(col.texts) do
            local line = lines[i] or { "" }
            if text.content ~= line[1] then
                text.content = line[1]
            end
            local colour = line[2] or WHITE
            if text.colour ~= colour then
                pcall(function() text.colour = colour end)
            end
        end
    end
    local overview = makeColumn(left, "OVERVIEW", 6)
    local pulls = makeColumn(second, "PULL RATES", #Cards.rarityOrder + #Cards.specialFinishes)
    return {
        height = TOP_PAD + 26 + math.max(#overview.texts, #pulls.texts) * LINE_H,
        refresh = function(_, state)
            fill(overview, Stats.overview(state))
            fill(pulls, Stats.pullRates(state))
        end,
        destroy = function()
            for _, col in ipairs({ overview, pulls }) do
                pcall(function() col.heading:Destroy() end)
                for _, text in ipairs(col.texts) do
                    pcall(function() text:Destroy() end)
                end
            end
        end,
    }
end

local TABS = {
    { label = "Collection", make = viewProgress },
    { label = "Regions", make = viewRegions },
    { label = "Packs and credits", make = viewPacks },
}

-- The window -----------------------------------------------------------------------------------------------------------

-- The bars' numbers: counted again when the window opens, when the tab changes, while cards of a pack being opened have
-- not been seen (they change as cards are turned), and every CACHE_REFRESHES refreshes.
local function progress(state, force)
    cacheAge = cacheAge + 1
    local hidden = api.hiddenCards ~= nil and api.hiddenCards() or nil
    if cache == nil or force or cacheAge >= CACHE_REFRESHES or (hidden ~= nil and next(hidden) ~= nil) then
        cache = Browse.progress(state, hidden)
        cacheAge = 0
    end
    return cache
end

-- How wide a tab's page is: what the strip says, or (before the client has laid it out) what the window's content is.
local function pageWidth(index)
    local width = tabs ~= nil and tabs.pageWidth(index) or nil
    if type(width) == "number" and width >= 200 then
        return width
    end
    local inner = content ~= nil and content.width or nil
    if type(inner) == "number" and inner >= 200 then
        return inner
    end
    return WIDTH - 2 * WINDOW_BORDER
end

-- Builds tab `index`'s contents for the width its page is now, replacing what was there.
local function buildView(index)
    local old = views[index]
    if old ~= nil then
        pcall(old.destroy)
        views[index] = nil
    end
    local width = pageWidth(index)
    local ok, view = pcall(TABS[index].make, tabs.pages[index], width)
    if not ok then
        Logger.error("stats window: a tab could not be built:", tostring(view))
        return nil
    end
    view.width = width
    views[index] = view
    -- It scrolls when the window is shorter than this.
    tabs.setContentHeight(index, view.height + 10)
    return view
end

-- Brings the tab shown up to date, built again first if its page has changed width.
local function refreshView(state, force)
    local view = views[current]
    local width = pageWidth(current)
    if view == nil or (view.width ~= width and force) then
        view = buildView(current)
    end
    if view ~= nil then
        view.refresh(progress(state, force), state)
    end
end

-- Switches to tab `index` (the strip has already shown it, when the player picked it).
local function showTab(index, state)
    current = index
    refreshView(state, true)
end

-- Switches the open window to a tab (1 Collection, 2 Regions, 3 Packs and credits). For tests; the player uses the tabs.
function Stats.setTab(index)
    local state = api ~= nil and api.getState() or nil
    if window ~= nil and state ~= nil and views[index] ~= nil then
        tabs.select(index)
        showTab(index, state)
    end
end

-- Brings the window up to date. Does nothing if the window is closed.
function Stats.refresh()
    if window == nil then
        return
    end
    local state = api.getState()
    if state == nil then
        Stats.hide()
        return
    end
    refreshView(state, false)
end

-- Every frame while the window is open: when it has changed size, the pages are laid out again at once (so scroll bars
-- come and go as the edge is dragged), and the tab shown is built again for the new width once the size has stopped changing.
local function onDraw(e)
    if window == nil or tabs == nil or content == nil then
        return
    end
    local ok, w, h = pcall(function() return content.width, content.height end)
    if not ok or type(w) ~= "number" or type(h) ~= "number" then
        return
    end
    local size = w .. "x" .. h
    if size ~= lastSize then
        lastSize, sizeSince = size, 0
        tabs.refresh()
        return
    end
    if sizeSince >= 0 then
        sizeSince = sizeSince + Anim.frameSeconds(e)
        if sizeSince >= RELAYOUT_AFTER then
            sizeSince = -1                      -- (once for each change)
            local state = api ~= nil and api.getState() or nil
            local view = views[current]
            if state ~= nil and view ~= nil and view.width ~= pageWidth(current) then
                refreshView(state, true)
            end
        end
    end
end

Events.on("Draw", "cardcollector_stats_layout", onDraw)

-- Opens the window. `newApi` needs getState() (and may have hiddenCards()).
function Stats.show(newApi)
    if window ~= nil then
        return
    end
    api = newApi
    local state = api.getState()
    if state == nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Statistics", WIDTH, HEIGHT + Kit.titleBarHeight(), function()
        Stats.hide()
    end, 0.45, 0.15, false, true, { minWidth = MIN_WIDTH, minHeight = MIN_HEIGHT })
    local ok, err = pcall(function()
        local labels = {}
        for i, spec in ipairs(TABS) do
            labels[i] = spec.label
        end
        if TABS[current] == nil then
            current = 1
        end
        tabs = Kit.tabStrip(content, labels, 0, 0, WIDTH - 2 * WINDOW_BORDER, HEIGHT, function(index)
            local now = api.getState()
            if now ~= nil then
                showTab(index, now)
            end
        end, current, { fill = true })
        for i = 1, #TABS do
            buildView(i)
        end
    end)
    if not ok then
        Logger.error("stats window: could not be built:", tostring(err))
        Stats.hide()
        return
    end
    cache, cacheAge = nil, 0
    lastSize, sizeSince = nil, 0
    refreshView(state, true)
end

-- Closes the window.
function Stats.hide()
    for _, view in pairs(views) do
        pcall(view.destroy)
    end
    views = {}
    if tabs ~= nil then
        pcall(tabs.destroy)
        tabs = nil
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content = nil, nil
end

-- True while the window is open.
function Stats.isOpen()
    return window ~= nil
end

-- Opens the window, or closes it if it is open (the Stats button on Home).
function Stats.toggle(newApi)
    if window ~= nil then
        Stats.hide()
    else
        Stats.show(newApi)
    end
end

return Stats
