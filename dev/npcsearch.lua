-- npcsearch.lua
-- Developer-only: finds an NPC by (part of) its name, anywhere in the game, not just nearby.
-- Type part of the in-game name or the config name and press Search. The client's own list of
-- NPC config names (id.NPC) is read once, the first time it is needed, and searched straight
-- away, ignoring capitals, spaces and underscores ("giant rat" finds GIANTRAT and GIANT_RAT).
-- A name shown in the game can differ from the config name, so when fewer than a full page of
-- config names match, the in-game names are checked too, a few hundred each frame so the game
-- does not stall. When a function is set with setPicker (the Card Builder does this), each row
-- has a "Use" button that hands that NPC to it.
--
-- Many NPCs share a name (GIANTRAT, GIANTRAT_1...), and each has its own model, so a search for
-- a common name lists only the first few; type more of the config name to narrow it.

local Kit = require("ui/kit")

local NpcSearch = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local WIDTH, ROW_H = 600, 36
local MAX_ROWS = 10         -- how many matches to list before stopping
local LIST_TOP = 76
local PER_FRAME = 400       -- how many in-game names are looked at each frame

local window, content = nil, nil
local filterField, statusText = nil, nil
local rows = {}
local picker = nil
local index = nil           -- every NPC: { id, configName, key }, read once
local search = nil          -- a search still looking at in-game names: { needle, next, found, seen }

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

-- Lower case with everything but letters and digits taken out, so "Giant rat", GIANT_RAT and
-- GIANTRAT all compare equal.
function NpcSearch.simplify(text)
    return (string.gsub(string.lower(tostring(text or "")), "[^%w]", ""))
end

-- Reads the client's list of NPC config names (once). Returns it, or nil if the client would not
-- list them.
local function loadIndex()
    if index ~= nil then
        return index
    end
    local list = {}
    local ok = pcall(function()
        for npcId, configName in pairs(id.NPC) do
            if type(npcId) == "number" and type(configName) == "string" then
                list[#list + 1] = { id = npcId, configName = configName, key = NpcSearch.simplify(configName) }
            end
        end
    end)
    if not ok or #list == 0 then
        return nil
    end
    table.sort(list, function(a, b)
        if a.configName ~= b.configName then return a.configName < b.configName end
        return a.id < b.id
    end)
    index = list
    return index
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

-- True if the NPC's name or config name contains `needle` (any case, ignoring spaces and
-- underscores).
function NpcSearch.matches(npc, needle)
    local wanted = NpcSearch.simplify(needle)
    if wanted == "" then
        return false
    end
    return string.find(NpcSearch.simplify(npc.name), wanted, 1, true) ~= nil
        or string.find(NpcSearch.simplify(npc.configName), wanted, 1, true) ~= nil
end

-- The NPCs whose config name contains `text`, as a list of { id, configName, name }, at most
-- MAX_ROWS. Returns nil if the client would not list the NPCs. Quick: no in-game names are read
-- except for the NPCs found.
function NpcSearch.find(text)
    local list = loadIndex()
    if list == nil then
        return nil
    end
    local wanted = NpcSearch.simplify(text)
    local found = {}
    if wanted == "" then
        return found
    end
    for _, entry in ipairs(list) do
        if string.find(entry.key, wanted, 1, true) then
            local npc = readNpc(entry.id) or { id = entry.id, configName = entry.configName, name = "?" }
            found[#found + 1] = npc
            if #found >= MAX_ROWS then
                break
            end
        end
    end
    return found
end

local function showRows(found)
    clearRows()
    for i, npc in ipairs(found) do
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

local function setStatus(text)
    if statusText ~= nil then
        statusText.content = text
    end
end

local function foundText(count)
    if count >= MAX_ROWS then
        return count .. " found (first " .. MAX_ROWS .. ", type more to narrow it)"
    end
    return count .. " found"
end

-- Looks at the next batch of in-game names. Called every frame while a search is running.
function NpcSearch.step()
    if search == nil then
        return
    end
    local list = index
    local stop = math.min(#list, search.next + PER_FRAME - 1)
    for position = search.next, stop do
        local entry = list[position]
        if not search.seen[entry.id] then
            local npc = readNpc(entry.id)
            if npc ~= nil and NpcSearch.matches(npc, search.needle) then
                search.found[#search.found + 1] = npc
                search.seen[entry.id] = true
                if #search.found >= MAX_ROWS then
                    break
                end
            end
        end
    end
    search.next = stop + 1
    local finished = #search.found >= MAX_ROWS or search.next > #list
    if finished then
        setStatus(foundText(#search.found))
        showRows(search.found)
        search = nil
    else
        setStatus("Checking in-game names... " .. math.floor(100 * search.next / #list) .. "%")
    end
end
Event.Draw.Subscribe("cardcollector_npcsearch", function() NpcSearch.step() end)

-- Starts a search for `text`. The config name matches are listed at once; the in-game names
-- are checked afterwards only if there is room for more.
function NpcSearch.start(text)
    clearRows()
    search = nil
    if NpcSearch.simplify(text) == "" then
        setStatus("Type part of a name first.")
        return
    end
    local found = NpcSearch.find(text)
    if found == nil then
        setStatus("The client would not list NPC names.")
        return
    end
    showRows(found)
    if #found >= MAX_ROWS then
        setStatus(foundText(#found))
        return
    end
    local seen = {}
    for _, npc in ipairs(found) do
        seen[npc.id] = true
    end
    search = { needle = text, next = 1, found = found, seen = seen }
    setStatus(#found .. " found so far. Checking in-game names...")
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
