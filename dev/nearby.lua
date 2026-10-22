-- nearby.lua
-- Developer-only: lists the NPCs standing near the player, so you can find out exactly which
-- NPC config (variant) one in the world uses. Many NPCs have dozens of variants with the same
-- name (GIANTRAT, GIANTRAT_1, ...) and each has its own model; the config an NPC in the world
-- uses is exactly what a card's `art = { npc = "..." }` needs.
--
-- Press Scan to list the NPCs within RANGE tiles, nearest first, one row for each different
-- config. The Filter box narrows the list by name. View shows that NPC's models in the NPC
-- browser, and also writes the line to paste into cards.lua to the Output window.

local OutputWindow = require("dev/outputwindow")
local NpcBrowser = require("dev/npcbrowser")

local Nearby = {}

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR
local RANGE = 12            -- how many tiles around the player to look
local MAX_ROWS = 10         -- how many different configs to list
local WIDTH, ROW_H = 600, 34

local window = nil
local filterField = nil
local rows = {}             -- the components of the listed rows, rebuilt on every scan
local statusText = nil

-- Finds the NPCs near the player. Returns a list of { id, configName, name, bas, distance },
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

local function addText(x, y, w, h, content)
    local t = ui.Text.new(window)
    t:SetPos(x, y)
    t:SetSize(w, h)
    t.font = FONT
    t.content = content
    t.colour = Vector4.new(1, 1, 1, 1)
    t.isShadowed = true
    t:AlignTo(ui.AlignMode.TOPLEFT, ui.AlignMode.CENTRE)
    return t
end

local function addButton(label, x, y, w, h, onPress)
    local b = ui.Button.new(window)
    b:SetPos(x, y)
    b:SetSize(w, h)
    b.label = label
    b.stylesheetID = id.StyleSheet.BUTTON_DEFAULT
    b:Subscribe(ui.Hook.ONBUTTONPRESSED, onPress)
    return b
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
        local y = 96 + (i - 1) * ROW_H
        -- Name and config on the first line of a row, id and animation set on the second.
        rows[#rows + 1] = addText(10, y, 300, 16, npc.name .. "  " .. npc.configName)
        rows[#rows + 1] = addText(10, y + 15, 300, 16,
            "id " .. npc.id .. "   anim set " .. npc.bas .. "   " .. npc.distance .. " tiles")
        rows[#rows + 1] = addButton("View", 520, y + 2, 70, 28, function()
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
    window = ui.GroupBox.new(gameWindow)
    window.stylesheetID = id.StyleSheet.DEFAULT
    window:SetHeaderLayout(0, 0, 0, 0, 0)
    window:SetSize(WIDTH, 96 + MAX_ROWS * ROW_H + 10)
    window:SetPos(0, 0, 0.35, 0.05)

    addText(10, 8, 120, 26, "Name filter:")
    filterField = ui.InputField.new(window)
    filterField:SetPos(120, 8)
    filterField:SetSize(180, 26)
    local sheet = id.StyleSheet.INPUT_DEFAULT
    if sheet ~= nil then
        filterField.stylesheetID = sheet
    end
    filterField:Setup(ui.TextContentVisibilityMode.VISIBLE, ui.InputFieldFilterMode.NONE, 30)
    addButton("Scan", 310, 6, 80, 30, showList)
    statusText = addText(10, 50, 380, 30, "Press Scan to list the NPCs around you.")
end

function Nearby.hide()
    clearRows()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
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
