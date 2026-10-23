-- stats.lua
-- The Stats window: lifetime numbers (packs opened, credits earned, pull rates) for the
-- logged-in character. The numbers come from state.stats (see storage.lua).
--
-- Stats.lines() turns the numbers into the lines of text to show. It has no UI, so it can be
-- tested on its own.

local Cards = require("cards")
local Kit = require("kit")

local Stats = {}

local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)
local GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
local CYAN = Vector4.new(0.45, 0.90, 1.0, 1.0)
local PURPLE = Vector4.new(0.80, 0.55, 1.0, 1.0)

local WIDTH = 300
local LINE_H = 22
local TOP = 8

-- Display order and colours for the finish and rarity lines.
local FINISH_ORDER = { "normal", "reverse", "holo" }
local FINISH_COLOUR = { normal = GREY, reverse = PURPLE, holo = CYAN }
local RARITY_ORDER = { "common", "uncommon", "rare", "epic", "legendary" }

-- "3 (10.0%, 1 in 10)", or just "0" when nothing has been pulled yet.
local function rate(count, total)
    if total == 0 or count == 0 then
        return tostring(count)
    end
    return string.format("%d (%.1f%%, 1 in %.1f)", count, count * 100 / total, total / count)
end

-- The lines of the window, top to bottom, as { text, colour }. A blank line is { "" }.
function Stats.lines(state)
    local s = state.stats
    local lines = {
        { "Packs opened: " .. s.packsOpened, WHITE },
        { "Cards pulled: " .. s.cardsPulled, WHITE },
        { "Credits earned: " .. s.creditsEarned, WHITE },
        { "Credits spent: " .. s.creditsSpent, WHITE },
        { "" },
        { "Pull rates", GOLD },
    }
    for _, finish in ipairs(FINISH_ORDER) do
        if Cards.finishes[finish] ~= nil then
            lines[#lines + 1] = { Cards.finishes[finish].name .. ": " .. rate(s.finishes[finish] or 0, s.cardsPulled),
                FINISH_COLOUR[finish] }
        end
    end
    lines[#lines + 1] = { "" }
    lines[#lines + 1] = { "By rarity", GOLD }
    for _, rarity in ipairs(RARITY_ORDER) do
        if Cards.rarities[rarity] ~= nil then
            lines[#lines + 1] = { Cards.rarities[rarity].name .. ": " .. rate(s.rarities[rarity] or 0, s.cardsPulled), GREY }
        end
    end
    return lines
end

local api = nil          -- api.getState() : the logged-in character's collection, or nil
local window = nil
local content = nil
local texts = {}         -- one ui text per line

-- Creates `count` empty text lines in the window, replacing any that were there.
local function buildLines(count)
    for _, text in ipairs(texts) do
        pcall(function() text:Destroy() end)
    end
    texts = {}
    for i = 1, count do
        texts[i] = Kit.text(content, 10, TOP + (i - 1) * LINE_H, WIDTH - 20, LINE_H, "", WHITE)
    end
end

-- Brings the text up to date. Does nothing if the window is closed.
function Stats.refresh()
    if window == nil then
        return
    end
    local state = api.getState()
    if state == nil then
        Stats.hide()
        return
    end
    local lines = Stats.lines(state)
    if #texts ~= #lines then
        buildLines(#lines)
    end
    for i, line in ipairs(lines) do
        if texts[i].content ~= line[1] then
            texts[i].content = line[1]
        end
        local colour = line[2] or WHITE
        if texts[i].colour ~= colour then
            pcall(function() texts[i].colour = colour end)
        end
    end
end

-- Opens the window. `newApi` needs getState().
function Stats.show(newApi)
    if window ~= nil then
        return
    end
    api = newApi
    local state = api.getState()
    if state == nil then
        return
    end
    local height = TOP * 2 + #Stats.lines(state) * LINE_H
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Statistics", WIDTH, height + Kit.titleBarHeight(), function()
        Stats.hide()
    end, 0.45, 0.15)
    Stats.refresh()
end

-- Closes the window.
function Stats.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
    content = nil
    texts = {}
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
