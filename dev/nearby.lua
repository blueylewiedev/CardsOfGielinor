-- nearby.lua
-- Developer-only: lists the NPCs standing near the player, so you can find out exactly which
-- NPC config (variant) one in the world uses. Many NPCs have dozens of variants with the same
-- name (GIANTRAT, GIANTRAT_1, ...) and each has its own model; the config an NPC in the world
-- uses is exactly what a card's `art = { npc = "..." }` needs.
--
-- Press Scan to list the NPCs within RANGE tiles, nearest first, one row for each different
-- config. The Filter box narrows the list by name. View shows that NPC's models in the NPC
-- browser, and also writes the line to paste into core/cards.lua to the Output window.

local Kit = require("ui/kit")
local OutputWindow = require("dev/outputwindow")
local NpcBrowser = require("dev/npcbrowser")

local Nearby = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local RANGE = 12            -- how many tiles around the player to look
local MAX_ROWS = 10         -- how many different configs to list
local WIDTH, ROW_H = 900, 36      -- wide enough for the longest config and animation set names
local LIST_TOP = 76         -- where the list of NPCs starts

local window = nil
local content = nil           -- where the window's contents go
local filterField = nil
local rows = {}             -- the components of the listed rows, rebuilt on every scan
local statusText = nil
local picker = nil             -- set by the Card Builder: called with the NPC chosen with "Use"

-- The animation an NPC in the world is playing, as "NAME (id)", or nil. The API docs don't say
-- how to read it, so these names are tried on each NPC listed (each one that gives a value is
-- logged, to find out which one works; the first number is shown). Once it is known, keep only
-- that one.
local ANIM_FIELDS = { "animation", "animationID", "animationId", "anim", "animID", "animId", "currentAnimation",
    "seq", "seqID", "seqId", "sequence", "sequenceID", "readyAnim", "readyAnimation", "standAnim", "idleAnim" }

local function playingAnim(npc)
    local shown = nil
    for _, field in ipairs(ANIM_FIELDS) do
        local ok, value = pcall(function() return npc[field] end)
        if ok and value ~= nil then
            local number = tonumber(value)
            if number == nil then     -- (an object for the animation, with its id on it)
                local okId, valueId = pcall(function() return value.id end)
                number = okId and tonumber(valueId) or nil
            end
            log("nearby: probe", tostring(npc.config and npc.config.configName), field, "=", tostring(value))
            if number ~= nil and number >= 0 and shown == nil then
                local okName, name = pcall(function() return id.Seq[number] end)
                shown = ((okName and type(name) == "string") and name .. " " or "") .. "(" .. number .. ") via " .. field
            end
        end
    end
    return shown
end

-- Finds the NPCs near the player. Returns a list of { id, configName, name, bas, entity, distance },
-- one for each different config (the nearest NPC of each), nearest first, narrowed by `filter`
-- (a piece of the display or config name, any case) when it is not empty.
function Nearby.scan(filter)
    local player = Player.GetEntity()
    if player == nil then
        return nil, "no player"
    end
    local entities = NPCList.ByDistance(player.coordGrid, RANGE)
    local found, seen = {}, {}
    local needle = string.lower(filter or "")
    for _, npc in ipairs(entities) do
        local cfg = npc.config
        if cfg ~= nil and not seen[npc.configID] then
            local name = tostring(cfg.name)
            local configName = tostring(cfg.configName)
            local haystack = string.lower(name .. " " .. configName)
            if needle == "" or string.find(haystack, needle, 1, true) then
                seen[npc.configID] = true
                local bas = cfg.bas
                -- Distance is only for sorting and display, so a failure here is not fatal.
                local okDist, tiles = pcall(function()
                    local dx = npc.position.x - player.position.x
                    local dz = npc.position.z - player.position.z
                    return math.floor(math.sqrt(dx * dx + dz * dz) / 512 + 0.5)   -- 512 units per tile
                end)
                found[#found + 1] = {
                    id = npc.configID,
                    configName = configName,
                    name = name,
                    bas = bas and tostring(bas.configName) or "none",
                    entity = npc,
                    distance = okDist and tiles or 0,
                }
            end
        end
    end
    table.sort(found, function(a, b)
        if a.distance ~= b.distance then return a.distance < b.distance end
        return a.id < b.id
    end)
    return found
end

local function clearRows()
    for _, part in ipairs(rows) do
        pcall(function() part:Destroy() end)
    end
    rows = {}
end

-- Lets another tool (the Card Builder) receive the NPC the player picks: while a function is set,
-- every row has a "Use" button that calls it with { id, configName, name }. Pass nil to remove it.
function Nearby.setPicker(fn)
    picker = fn
end

-- Scans and redraws the list.
local function showList()
    clearRows()
    local found, err = Nearby.scan(filterField.content)
    if found == nil then
        statusText.content = "Cannot scan: " .. tostring(err)
        return
    end
    statusText.content = #found .. " configs within " .. RANGE .. " tiles"
        .. (#found > MAX_ROWS and (" (showing " .. MAX_ROWS .. ")") or "")
    for i = 1, math.min(#found, MAX_ROWS) do
        local npc = found[i]
        local y = LIST_TOP + (i - 1) * ROW_H
        -- Name and config on the first line of a row; on the second, the NPC's config id, its animation
        -- set (a name for its set of animations, not one of them) and the animation it is playing.
        rows[#rows + 1] = Kit.text(content, 10, y, WIDTH - 250, 16, npc.name .. "  " .. npc.configName, WHITE,
            ui.AlignMode.TOPLEFT)
        rows[#rows + 1] = Kit.text(content, 10, y + 15, WIDTH - 250, 16,
            "npc id " .. npc.id .. "   animation set " .. npc.bas .. "   " .. npc.distance .. " tiles   playing "
                .. (playingAnim(npc.entity) or "? (can't read it)"), WHITE,
            ui.AlignMode.TOPLEFT)
        if picker ~= nil then
            rows[#rows + 1] = Kit.buttonAt(content, "Use", WIDTH - 220, y + 1, 100, 30, function()
                if picker ~= nil then
                    picker(npc)
                end
            end, "positive")
        end
        rows[#rows + 1] = Kit.buttonAt(content, "View", WIDTH - 110, y + 1, 100, 30, function()
            local line = "npc = \"" .. npc.configName .. "\"   -- id " .. npc.id .. ", anim set " .. npc.bas
            log("nearby:", npc.name, line)
            OutputWindow.add(npc.configName, line)
            NpcBrowser.showId(npc.id)
        end)
    end
end

function Nearby.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Nearby NPCs", WIDTH, LIST_TOP + MAX_ROWS * ROW_H + 10 + Kit.titleBarHeight(),
        function() Nearby.hide() end, 0.2, 0.05)

    Kit.text(content, 10, 4, 100, 26, "Name filter:", WHITE, ui.AlignMode.TOPLEFT)
    filterField = Kit.inputField(content, 115, 4, 250, 26, 30, false)
    Kit.buttonAt(content, "Scan", WIDTH - 130, 2, 120, 30, showList, "positive")
    statusText = Kit.text(content, 10, 42, WIDTH - 20, 24, "Press Scan to list the NPCs around you.", WHITE,
        ui.AlignMode.TOPLEFT)
end

function Nearby.hide()
    clearRows()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
    content = nil
    filterField = nil
    statusText = nil
end

function Nearby.isOpen()
    return window ~= nil
end

function Nearby.toggle()
    if window ~= nil then
        Nearby.hide()
    else
        Nearby.show()
    end
end

return Nearby
