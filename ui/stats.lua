-- ui/stats.lua
-- The Stats window, three views picked from a drop-down at its top:
--   Collection        : progress bars for all the cards, the NPC cards and the item cards, then one for each rarity
--   Regions           : a progress bar for each region, in two columns
--   Packs and credits : packs opened, cards pulled, credits earned, spent and per hour, and the pull rates by rarity
-- The bars come from Browse.progress (core/browse.lua), counted in one pass over the deck and kept for a few seconds
-- (the window refreshes every tick, and nothing in a collection changes that fast); cards from a pack that is still being
-- opened do not count until they have been turned over. The text of the last view comes from state.stats (see
-- core/storage.lua) through Stats.lines, which has no UI, so it can be tested on its own.

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

local LEFT = 10
local TOP = 40                          -- the drop-down is above this
local BOTTOM = 12
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

-- The lines of the "Packs and credits" view, top to bottom, as { text, colour }. A blank line is { "" }.
function Stats.lines(state)
    local s = state.stats
    local lines = {
        { "Packs opened: " .. Format.credits(s.packsOpened), WHITE },
        { "Cards pulled: " .. Format.credits(s.cardsPulled), WHITE },
        { "Credits earned: " .. Format.credits(s.creditsEarned), WHITE },
        { "Credits spent: " .. Format.credits(s.creditsSpent), WHITE },
        { "Credits per hour: " .. Rate.text(), WHITE },
    }
    lines[#lines + 1] = { "" }
    lines[#lines + 1] = { "Pull rates by rarity", GOLD }
    for _, rarity in ipairs(RARITY_ORDER) do
        if Cards.rarities[rarity] ~= nil then
            lines[#lines + 1] = { Cards.rarities[rarity].name .. ": " .. rate(s.rarities[rarity] or 0, s.cardsPulled), GREY }
        end
    end
    return lines
end

local api = nil          -- api.getState() : the logged-in character's collection, or nil;
                         -- api.hiddenCards() : the cards of a pack being opened that have not been turned over
local window = nil
local content = nil
local dropdown = nil
local views = {}         -- view name -> { layer, width, height, refresh(progress, state), destroy() }
local current = nil      -- the view shown
local cache, cacheAge = nil, 0
local selected = "progress"   -- the view chosen (kept while the plugin runs)

-- The three views --------------------------------------------------------------------------------------------------

local function newLayer()
    local layer = ui.Layer.new(content)
    layer:SetPos(0, TOP)
    layer:SetSize(0, 0, 1.0, 1.0)
    layer.hidden = true
    return layer
end

local function viewProgress(width)
    local layer = newLayer()
    local w = Kit.contentWidth(width) - 2 * LEFT
    local bars = {}
    local y = 0
    local function add(key, label, colour, labelColour)
        bars[key] = Bars.new(layer, LEFT, y, w, label, colour, labelColour)
        y = y + BAR_STEP
    end
    add("all", "All cards", nil, GOLD)
    add("npc", "NPC cards")
    add("item", "Item cards")
    y = y + 4
    local heading = Kit.text(layer, LEFT, y, w, 20, "BY RARITY", GOLD, ui.AlignMode.TOPLEFT)
    y = y + 26
    local rarityBars = {}
    for _, id in ipairs(RARITY_ORDER) do
        local rarity = Cards.rarities[id]
        if rarity ~= nil then
            local colour = Bars.colour(rarity.colour)
            rarityBars[id] = Bars.new(layer, LEFT, y, w, rarity.name, colour, colour)
            y = y + BAR_STEP
        end
    end
    return {
        layer = layer, width = width, height = y,
        refresh = function(p)
            bars.all.set(p.all.owned, p.all.cards)
            local npc, item = p.kinds.npc or { owned = 0, cards = 0 }, p.kinds.item or { owned = 0, cards = 0 }
            bars.npc.set(npc.owned, npc.cards)
            bars.item.set(item.owned, item.cards)
            for id, bar in pairs(rarityBars) do
                local count = p.rarities[id] or { owned = 0, cards = 0 }
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

local function viewRegions(width)
    local layer = newLayer()
    local column = (Kit.contentWidth(width) - 2 * LEFT - COLUMN_GAP) // 2
    local bars = {}
    local words = Cards.tagWords.regions or {}
    for i, word in ipairs(words) do
        local x = LEFT + ((i - 1) % 2) * (column + COLUMN_GAP)
        local y = ((i - 1) // 2) * BAR_STEP
        bars[word] = Bars.new(layer, x, y, column, Browse.label(word))
    end
    return {
        layer = layer, width = width, height = ((#words + 1) // 2) * BAR_STEP,
        refresh = function(p)
            for word, bar in pairs(bars) do
                local count = p.regions[word] or { owned = 0, cards = 0 }
                bar.set(count.owned, count.cards)
            end
        end,
        destroy = function()
            for _, bar in pairs(bars) do bar.destroy() end
        end,
    }
end

local function viewPacks(width)
    local layer = newLayer()
    local texts = {}
    local count = 12                    -- enough lines for Stats.lines (more are made if it grows)
    local function build(n)
        for _, text in ipairs(texts) do
            pcall(function() text:Destroy() end)
        end
        texts = {}
        for i = 1, n do
            texts[i] = Kit.text(layer, LEFT, (i - 1) * LINE_H, Kit.contentWidth(width) - 2 * LEFT, LINE_H, "", WHITE,
                ui.AlignMode.TOPLEFT)
        end
    end
    build(count)
    return {
        layer = layer, width = width, height = count * LINE_H, lines = true,
        refresh = function(_, state)
            local lines = Stats.lines(state)
            if #lines > #texts then
                build(#lines)
            end
            for i, text in ipairs(texts) do
                local line = lines[i] or { "" }
                if text.content ~= line[1] then
                    text.content = line[1]
                end
                local colour = line[2] or WHITE
                if text.colour ~= colour then
                    pcall(function() text.colour = colour end)
                end
            end
        end,
        destroy = function()
            for _, text in ipairs(texts) do
                pcall(function() text:Destroy() end)
            end
        end,
    }
end

local VIEWS = {
    { value = "progress", label = "Collection", make = function() return viewProgress(400) end },
    { value = "regions", label = "Regions", make = function() return viewRegions(560) end },
    { value = "packs", label = "Packs and credits", make = function() return viewPacks(400) end },
}

-- The window -------------------------------------------------------------------------------------------------------

-- The bars' numbers: counted again when the window opens, when the view changes, when cards of a pack being opened have
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

-- Shows one view and sizes the window to it.
local function showView(name, state)
    local view = views[name]
    if view == nil then
        return
    end
    selected, current = name, name
    for viewName, other in pairs(views) do
        other.layer.hidden = (viewName ~= name)
    end
    window:SetSize(view.width, TOP + view.height + BOTTOM + Kit.titleBarHeight())
    view.refresh(progress(state, true), state)
end

-- Switches the open window to a view ("progress", "regions" or "packs"). For tests; the player uses the drop-down.
function Stats.setView(name)
    local state = api ~= nil and api.getState() or nil
    if window ~= nil and state ~= nil then
        showView(name, state)
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
    local view = views[current]
    if view ~= nil then
        view.refresh(progress(state, false), state)
    end
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
    window, content = Kit.window(gameWindow, "Statistics", 400, TOP + 300 + Kit.titleBarHeight(), function()
        Stats.hide()
    end, 0.45, 0.15)
    for _, spec in ipairs(VIEWS) do
        local ok, view = pcall(spec.make)
        if ok then
            views[spec.value] = view
        else
            Logger.error("stats window: a view could not be made:", tostring(view))
            Stats.hide()
            return
        end
    end
    cache, cacheAge = nil, 0
    if views[selected] == nil then
        selected = "progress"
    end
    showView(selected, state)
    -- The drop-down is made last so its list opens on top of the rest.
    local entries = {}
    for _, spec in ipairs(VIEWS) do
        entries[#entries + 1] = { label = spec.label, value = spec.value }
    end
    dropdown = Kit.dropdown(content, LEFT, 4, 200, 26, entries, selected, function(name)
        local now = api.getState()
        if now ~= nil then
            showView(name, now)
        end
    end)
end

-- Closes the window.
function Stats.hide()
    for _, view in pairs(views) do
        pcall(view.destroy)
        pcall(function() view.layer:Destroy() end)
    end
    views = {}
    if dropdown ~= nil then
        pcall(dropdown.destroy)
        dropdown = nil
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, current = nil, nil, nil
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
