-- ui/stats.lua
-- The Stats window: one size whatever is shown, with three tabs across its top:
--   Collection        : progress bars for all the cards, the NPC cards and the item cards, then one for each rarity
--   Regions           : a progress bar for each region, in two columns, and one for the cards that have no region (the
--                       regions' counts alone would not add up to the deck)
--   Packs and credits : an overview (packs opened, cards pulled, credits earned and spent, time played and the average
--                       credits per hour over all sessions) beside the pull rates by rarity, in the rarities' colours
-- The bars come from Browse.progress (core/browse.lua), counted in one pass over the deck and kept for a few seconds
-- (the window refreshes every tick, and nothing in a collection changes that fast); cards from a pack that is still being
-- opened do not count until they have been turned over. The text of the last tab comes from state.stats (see
-- core/storage.lua) through Stats.overview and Stats.pullRates, which have no UI, so they can be tested on their own.

local Cards = require("core/cards")
local Browse = require("core/browse")
local Rate = require("core/rate")
local Format = require("core/format")
local Logger = require("core/logger")
local Kit = require("ui/kit")
local Bars = require("ui/bars")

local Stats = {}

local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)
local GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)

local WIDTH = 560                       -- wide enough for two columns of bars with a label and numbers each
local LEFT = 10
local TOP_PAD = 14                      -- between the tab strip and what a tab starts with
local PAGE_H = TOP_PAD + 280            -- what a tab's page has room for: the Regions tab, the tallest, is 7 rows of bars
local HEIGHT = Kit.TABS_HEIGHT + PAGE_H + 10
local LINE_H = 22
local BAR_STEP = Bars.HEIGHT + 4
local COLUMN_GAP = 10
local CACHE_REFRESHES = 10              -- the bars are counted again after this many refreshes (about 6 seconds)

-- Display order for the rarity lines and bars.
local RARITY_ORDER = { "common", "uncommon", "rare", "epic", "legendary" }

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
    for _, rarity in ipairs(RARITY_ORDER) do
        local info = Cards.rarities[rarity]
        if info ~= nil then
            lines[#lines + 1] = { info.name .. ": " .. rate(s.rarities[rarity] or 0, s.cardsPulled), Bars.colour(info.colour) }
        end
    end
    return lines
end

local api = nil          -- api.getState() : the logged-in character's collection, or nil;
                         -- api.hiddenCards() : the cards of a pack being opened that have not been turned over
local window = nil
local content = nil
local tabs = nil         -- the tab strip: { pages, select, destroy }
local views = {}         -- tab index -> { refresh(progress, state), destroy() }
local current = 1        -- the tab shown (kept while the plugin runs)
local cache, cacheAge = nil, 0

-- The tabs' contents ---------------------------------------------------------------------------------------------------

local EMPTY = { owned = 0, cards = 0 }
local NO_REGION = "(no region)"           -- the key of the bar for the cards that have none
local GOLD_BAR = Vector4.new(0.85, 0.68, 0.16, 1.0)

local function viewProgress(page)
    local full = Kit.contentWidth(WIDTH) - 2 * LEFT
    local column = (full - COLUMN_GAP) // 2
    local second = LEFT + column + COLUMN_GAP
    local bars, y = {}, TOP_PAD
    bars.all = Bars.new(page, LEFT, y, full, "All cards", nil, GOLD)
    y = y + BAR_STEP
    bars.npc = Bars.new(page, LEFT, y, column, "NPC cards")
    bars.item = Bars.new(page, second, y, column, "Item cards")
    y = y + BAR_STEP + 4
    local heading = Kit.text(page, LEFT, y, full, 20, "BY RARITY", GOLD, ui.AlignMode.TOPLEFT)
    y = y + 26
    local rarityBars = {}
    for i, id in ipairs(RARITY_ORDER) do
        local rarity = Cards.rarities[id]
        if rarity ~= nil then
            local colour = Bars.colour(rarity.colour)
            rarityBars[id] = Bars.new(page, (i % 2 == 1) and LEFT or second, y, column, rarity.name, colour, colour)
            if i % 2 == 0 then
                y = y + BAR_STEP
            end
        end
    end
    return {
        refresh = function(p)
            bars.all.set(p.all.owned, p.all.cards)
            local npc, item = p.kinds.npc or EMPTY, p.kinds.item or EMPTY
            bars.npc.set(npc.owned, npc.cards)
            bars.item.set(item.owned, item.cards)
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

local function viewRegions(page)
    local full = Kit.contentWidth(WIDTH) - 2 * LEFT
    local column = (full - COLUMN_GAP) // 2
    local bars = {}
    for i, word in ipairs(Cards.tagWords.regions or {}) do
        local x = LEFT + ((i - 1) % 2) * (column + COLUMN_GAP)
        local y = TOP_PAD + ((i - 1) // 2) * BAR_STEP
        -- (the numbers only: a region's name and its numbers and a percentage would not fit a column)
        bars[word] = Bars.new(page, x, y, column, Browse.label(word), nil, nil, { percent = false })
    end
    -- The cards with no region at all: the last bar, after the regions.
    local last = #(Cards.tagWords.regions or {})
    bars[NO_REGION] = Bars.new(page, LEFT + (last % 2) * (column + COLUMN_GAP), TOP_PAD + (last // 2) * BAR_STEP, column,
        "Global (no region)", GOLD_BAR, GOLD, { percent = false })
    return {
        refresh = function(p)
            for word, bar in pairs(bars) do
                local count = (word == NO_REGION) and p.noRegion or p.regions[word] or EMPTY
                bar.set(count.owned, count.cards)
            end
        end,
        destroy = function()
            for _, bar in pairs(bars) do bar.destroy() end
        end,
    }
end

local function viewPacks(page)
    local full = Kit.contentWidth(WIDTH) - 2 * LEFT
    local column = (full - COLUMN_GAP) // 2
    local second = LEFT + column + COLUMN_GAP
    -- Two columns, each a heading over lines of text: `count` lines, made once and rewritten by refresh.
    local function makeColumn(x, heading, count)
        local parts = { Kit.text(page, x, TOP_PAD, column, 20, heading, GOLD, ui.AlignMode.TOPLEFT) }
        local texts = {}
        for i = 1, count do
            texts[i] = Kit.text(page, x, TOP_PAD + 26 + (i - 1) * LINE_H, column, LINE_H, "", WHITE, ui.AlignMode.TOPLEFT)
        end
        return { heading = parts[1], texts = texts }
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
    local left = makeColumn(LEFT, "OVERVIEW", 6)
    local right = makeColumn(second, "PULL RATES", #RARITY_ORDER)
    return {
        refresh = function(_, state)
            fill(left, Stats.overview(state))
            fill(right, Stats.pullRates(state))
        end,
        destroy = function()
            for _, col in ipairs({ left, right }) do
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

-- Brings the tab shown up to date.
local function refreshView(state, force)
    local view = views[current]
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
    end, 0.45, 0.15)
    local ok, err = pcall(function()
        local labels = {}
        for i, spec in ipairs(TABS) do
            labels[i] = spec.label
        end
        if TABS[current] == nil then
            current = 1
        end
        tabs = Kit.tabs(content, labels, 0, 0, Kit.contentWidth(WIDTH), HEIGHT, function(index)
            local now = api.getState()
            if now ~= nil then
                showTab(index, now)
            end
        end, current)
        for i, spec in ipairs(TABS) do
            views[i] = spec.make(tabs.pages[i])
        end
    end)
    if not ok then
        Logger.error("stats window: could not be built:", tostring(err))
        Stats.hide()
        return
    end
    cache, cacheAge = nil, 0
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
