-- npcsearch.lua
-- Developer-only: finds an NPC by (part of) its name, anywhere in the game, not just nearby.
-- Type part of the in-game name or the config name and press Search. The client has no way to
-- search its NPC list, so this looks at every NPC id in turn (a few hundred each frame, so the
-- game does not stall) and lists the first matches. When a function is set with setPicker
-- (the Card Builder does this), each row has a "Use" button that hands that NPC to it.
--
-- Many NPCs share a name (GIANTRAT, GIANTRAT_1...), and each has its own model, so a search for
-- a common name lists only the first few; type more of the config name to narrow it.

local Kit = require("ui/kit")

local NpcSearch = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local WIDTH, ROW_H = 600, 36
local MAX_ROWS = 10         -- how many matches to list before stopping
local LIST_TOP = 76
local LAST_ID = 40000       -- searches NPC ids 0 to this (the game has about 33,000)
local PER_FRAME = 400       -- how many ids are looked at each frame

local window, content = nil, nil
local filterField, statusText = nil, nil
local rows = {}
local picker = nil
local search = nil          -- the search in progress: { needle, nextId, found }

-- Lets the Card Builder receive the NPC the player picks. Pass nil to remove it.
function NpcSearch.setPicker(fn)
    picker = fn
end

local function clearRows()
    for _, part in ipairs(rows) do
        pcall(function() part:Destroy() end)
    end
    rows = {}
end

-- Looks at NPC `npcId`. Returns its { id, configName, name }, or nil if there is no such NPC.
local function readNpc(npcId)
    local ok, cfg = pcall(function() return config.NPC.FromID(npcId) end)
    if not ok or cfg == nil then
        return nil
    end
    local nameOk, name = pcall(function() return tostring(cfg.name) end)
    local cfgOk, configName = pcall(function() return tostring(cfg.configName) end)
    if not cfgOk then
        return nil
    end
    return { id = npcId, configName = configName, name = nameOk and name or "?" }
end

-- True if the NPC's name or config name contains `needle` (lower case).
function NpcSearch.matches(npc, needle)
    local haystack = string.lower(npc.name .. " " .. npc.configName)
    return string.find(haystack, needle, 1, true) ~= nil
end

local function showRows()
    clearRows()
    for i, npc in ipairs(search.found) do
        local y = LIST_TOP + (i - 1) * ROW_H
        rows[#rows + 1] = Kit.text(content, 10, y, WIDTH - 130, 16, npc.name .. "  " .. npc.configName, WHITE,
            ui.AlignMode.TOPLEFT)
        rows[#rows + 1] = Kit.text(content, 10, y + 15, WIDTH - 130, 16, "id " .. npc.id, WHITE,
            ui.AlignMode.TOPLEFT)
        if picker ~= nil then
            rows[#rows + 1] = Kit.buttonAt(content, "Use", WIDTH - 110, y + 1, 100, 30, function()
                if picker ~= nil then
                    picker(npc)
                end
            end, "positive")
        end
    end
end

-- Looks at the next batch of ids. Called every frame while a search is running.
function NpcSearch.step()
    if search == nil then
        return
    end
    local stop = math.min(LAST_ID, search.nextId + PER_FRAME - 1)
    for npcId = search.nextId, stop do
        local npc = readNpc(npcId)
        if npc ~= nil and NpcSearch.matches(npc, search.needle) then
            search.found[#search.found + 1] = npc
            if #search.found >= MAX_ROWS then
                break
            end
        end
    end
    search.nextId = stop + 1
    local full = #search.found >= MAX_ROWS
    local finished = full or search.nextId > LAST_ID
    if statusText ~= nil then
        if finished then
            statusText.content = #search.found .. " found" .. (full and " (first " .. MAX_ROWS .. ", type more to narrow it)" or "")
        else
            statusText.content = "Searching... " .. math.floor(100 * search.nextId / LAST_ID) .. "%"
        end
    end
    if finished then
        showRows()
        search = nil
    end
end
Event.Draw.Subscribe("cardcollector_npcsearch", function() NpcSearch.step() end)

-- Starts a search for `text`.
function NpcSearch.start(text)
    clearRows()
    local needle = string.lower(text or "")
    if needle == "" then
        search = nil
        if statusText ~= nil then
            statusText.content = "Type part of a name first."
        end
        return
    end
    search = { needle = needle, nextId = 0, found = {} }
end

function NpcSearch.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Search NPCs", WIDTH, LIST_TOP + MAX_ROWS * ROW_H + 10 + Kit.titleBarHeight(),
        function() NpcSearch.hide() end, 0.35, 0.3)
    Kit.text(content, 10, 4, 100, 26, "Name:", WHITE, ui.AlignMode.TOPLEFT)
    filterField = Kit.inputField(content, 70, 4, 295, 26, 40, false)
    Kit.buttonAt(content, "Search", WIDTH - 130, 2, 120, 30, function() NpcSearch.start(filterField.content) end, "positive")
    statusText = Kit.text(content, 10, 42, WIDTH - 20, 24, "Type part of an NPC's name or config name.", WHITE,
        ui.AlignMode.TOPLEFT)
end

function NpcSearch.hide()
    search = nil
    clearRows()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, filterField, statusText = nil, nil, nil, nil
end

function NpcSearch.isOpen()
    return window ~= nil
end

function NpcSearch.toggle()
    if window ~= nil then
        NpcSearch.hide()
    else
        NpcSearch.show()
    end
end

return NpcSearch
