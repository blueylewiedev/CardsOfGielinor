-- animsearch.lua
-- Developer-only: finds animations (sequences) by name. Type part of an NPC's or an
-- animation's name (for example "chicken" or "peck") and press Search to list the matching
-- sequences, ten to a page. Each row shows the sequence id and how long it runs, and when a
-- function is set with setPicker (the Card Builder does this) a "Use" button that hands that
-- sequence to it, so the animation plays on the card straight away. Press Use on several rows
-- to try them one after another.
--
-- The client's own list of sequence names (id.Seq) is read once, the first time it is needed.

local Kit = require("ui/kit")

local AnimSearch = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.7, 0.7, 0.7, 1)
local WIDTH, ROW_H = 600, 36
local ROWS = 10               -- how many matches fit on a page
local MAX_MATCHES = 500       -- a search stops listing after this many
local LIST_TOP = 76           -- where the first row starts

local window, content = nil, nil
local filterField, statusText = nil, nil
local rows = {}               -- the parts of the rows, rebuilt on every page change
local picker = nil
local index = nil             -- every sequence: { id, name, lower }, read once
local matches = {}            -- the sequences matching the last search
local page = 0                -- which page of `matches` is shown (0 is the first)

-- Lets the Card Builder receive the sequence the player picks. Pass nil to remove it.
function AnimSearch.setPicker(fn)
    picker = fn
end

-- Reads the client's list of sequence names (once). Returns it, or nil if the client would not
-- list them.
local function loadIndex()
    if index ~= nil then
        return index
    end
    local list = {}
    local ok = pcall(function()
        for seqId, name in pairs(id.Seq) do
            if type(seqId) == "number" and type(name) == "string" then
                list[#list + 1] = { id = seqId, name = name, lower = string.lower(name) }
            end
        end
    end)
    if not ok or #list == 0 then
        return nil
    end
    table.sort(list, function(a, b)
        if a.name ~= b.name then return a.name < b.name end
        return a.id < b.id
    end)
    index = list
    return index
end

-- Every sequence, as a list of { id, name, lower } sorted by name, or nil if the client would
-- not list them (the Card Builder uses it to guess standing animations).
function AnimSearch.all()
    return loadIndex()
end

-- The sequences whose name contains `text` (any case), as a list of { id, name }, at most
-- MAX_MATCHES. Returns nil if the sequence names are not available.
function AnimSearch.find(text)
    local list = loadIndex()
    if list == nil then
        return nil
    end
    local needle = string.lower(text or "")
    local found = {}
    if needle == "" then
        return found
    end
    for _, entry in ipairs(list) do
        if string.find(entry.lower, needle, 1, true) then
            found[#found + 1] = entry
            if #found >= MAX_MATCHES then
                break
            end
        end
    end
    return found
end

-- How long a sequence runs, as text ("42 ticks"), or "?" when the client will not say.
local function lengthText(seqId)
    local ok, ticks = pcall(function() return config.Seq.FromID(seqId).length end)
    if ok and type(ticks) == "number" then
        return string.format("%.0f ticks", ticks)
    end
    return "?"
end

local function clearRows()
    for _, part in ipairs(rows) do
        pcall(function() part:Destroy() end)
    end
    rows = {}
end

local function pageCount()
    return math.max(1, math.ceil(#matches / ROWS))
end

-- Draws the rows of the current page.
local function showRows()
    clearRows()
    local first = page * ROWS + 1
    for i = first, math.min(#matches, first + ROWS - 1) do
        local seq = matches[i]
        local y = LIST_TOP + (i - first) * ROW_H
        rows[#rows + 1] = Kit.text(content, 10, y, WIDTH - 130, 16, seq.name, WHITE, ui.AlignMode.TOPLEFT)
        rows[#rows + 1] = Kit.text(content, 10, y + 15, WIDTH - 130, 16,
            "id " .. seq.id .. "   runs " .. lengthText(seq.id), GREY, ui.AlignMode.TOPLEFT)
        if picker ~= nil then
            rows[#rows + 1] = Kit.buttonAt(content, "Use", WIDTH - 110, y + 1, 100, 30, function()
                if picker ~= nil then
                    picker(seq)
                end
            end, "positive")
        end
    end
    if statusText ~= nil then
        if #matches == 0 then
            statusText.content = "No matches"
        else
            statusText.content = #matches .. (#matches >= MAX_MATCHES and "+" or "") .. " found, page "
                .. (page + 1) .. " of " .. pageCount()
        end
    end
end

-- Searches for `text` and shows the first page.
function AnimSearch.search(text)
    local found = AnimSearch.find(text)
    if found == nil then
        matches = {}
        clearRows()
        if statusText ~= nil then
            statusText.content = "The client would not list animation names."
        end
        return
    end
    matches = found
    page = 0
    if (text or "") == "" and statusText ~= nil then
        clearRows()
        statusText.content = "Type part of a name first."
        return
    end
    showRows()
end

local function turnPage(change)
    local target = page + change
    if target < 0 or target >= pageCount() then
        return
    end
    page = target
    showRows()
end

function AnimSearch.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Search animations", WIDTH,
        LIST_TOP + ROWS * ROW_H + 50 + Kit.titleBarHeight(), function() AnimSearch.hide() end, 0.55, 0.3)
    Kit.text(content, 10, 4, 100, 26, "Name:", WHITE, ui.AlignMode.TOPLEFT)
    filterField = Kit.inputField(content, 70, 4, 295, 26, 40, false)
    Kit.buttonAt(content, "Search", WIDTH - 130, 2, 120, 30, function() AnimSearch.search(filterField.content) end,
        "positive")
    statusText = Kit.text(content, 10, 42, WIDTH - 20, 24, "Type part of a name, such as chicken or peck.", WHITE,
        ui.AlignMode.TOPLEFT)
    local bottom = LIST_TOP + ROWS * ROW_H + 8
    Kit.buttonAt(content, "Previous", 10, bottom, 140, 30, function() turnPage(-1) end)
    Kit.buttonAt(content, "Next", 160, bottom, 140, 30, function() turnPage(1) end)
    matches = {}
    page = 0
end

function AnimSearch.hide()
    clearRows()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, filterField, statusText = nil, nil, nil, nil
end

function AnimSearch.isOpen()
    return window ~= nil
end

function AnimSearch.toggle()
    if window ~= nil then
        AnimSearch.hide()
    else
        AnimSearch.show()
    end
end

return AnimSearch
