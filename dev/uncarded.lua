-- uncarded.lua
-- Developer-only: marks the NPCs standing near the player that have no card yet, with a label
-- above their head, so the ones we missed are easy to spot while walking around.
--
-- It is passive: from the moment the developer tools are in use it looks at the NPCs around the
-- player every half second or so and keeps a label on each one that has no card. Nothing has to be
-- opened or scanned. The "Uncarded NPCs" window (Home window button) turns the labels and the
-- outline round each NPC on or off, sets how far to look, and
-- lists the NPCs seen, each with an Ignore button, for the ones that will never get a card or
-- that have a card with another model. Ignoring is by NPC name, so every variant of that NPC goes
-- quiet, and it is remembered between sessions (PersistentDB).
--
-- An NPC counts as having a card when a card's NPC has the same config id, or the same display
-- name (so a card for "Giant rat" covers every variant of it). Item cards are not looked at.

local Cards = require("core/cards")
local Kit = require("ui/kit")

local Uncarded = {}

local DB_KEY = "dev_uncarded"
local SUBSCRIBER = "cardcollector_uncarded"

local DEFAULT_RANGE = 20     -- how many tiles around the player to look, until it is changed
local MIN_RANGE, MAX_RANGE, RANGE_STEP = 2, 50, 2
local SCAN_FRAMES = 30       -- frames between looks at the NPCs around the player
local MAX_MARKERS = 12       -- labels on screen at once (the nearest ones)
local LABEL_HEIGHT = 2000    -- how far above the NPC's feet the label sits, in game units
local LABEL_W, LABEL_H = 220, 22
local MAX_ROWS = 10          -- rows in the window
local WIDTH, ROW_H, LIST_TOP = 620, 34, 112
local WHITE = Vector4.new(1, 1, 1, 1)
local LABEL_COLOUR = Vector4.new(1, 0.9, 0.2, 1)
local BACK_COLOUR = Vector4.new(0, 0, 0, 0.55)
local OUTLINE_RGBA = 0xFFE633FF     -- the outline round the NPC: yellow, as a packed RGBA number
local OUTLINE_WIDTH = 2

local data = nil             -- { enabled = true/false, outline = true/false, range = tiles, ignored = { [lower case name] = name } }
local active = false         -- true while the Draw handler is running
local frame = 0
local tracked = {}           -- the uncarded NPCs found by the last look: { npc, name }, nearest first
local seen = {}              -- [lower case name] = { name, configName, order } for the window
local seenCounter = 0
local markers = {}           -- { back, text } pairs, made when first needed
local parentLayer = nil      -- the game layer the labels are drawn on

local carded = nil           -- { ids = { [config id] = true }, names = { [lower case name] = true } }
local cardedCount = -1       -- how many cards the sets above were built for

local window, content = nil, nil
local rows = {}
local statusText = nil
local toggleButton = nil
local outlineButton = nil
local rangeText = nil
local showIgnored = false

-- ---------------------------------------------------------------- saved settings

local function load()
    if data ~= nil then
        return
    end
    data = { enabled = true, outline = true, range = DEFAULT_RANGE, ignored = {} }
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(DB_KEY) end)
    if not ok or type(saved) ~= "table" then
        return
    end
    if saved.enabled == false then
        data.enabled = false
    end
    if saved.outline == false then
        data.outline = false
    end
    if type(saved.range) == "number" then
        data.range = math.max(MIN_RANGE, math.min(MAX_RANGE, math.floor(saved.range)))
    end
    if type(saved.ignored) == "table" then
        for key, name in pairs(saved.ignored) do
            if type(key) == "string" and type(name) == "string" then
                data.ignored[key] = name
            end
        end
    end
end

local function save()
    local ok = PersistentDB:SetStructuredData(DB_KEY, data)
    if not ok then
        log("uncarded: save FAILED")
    end
end

local function keyOf(name)
    return string.lower(tostring(name))
end

function Uncarded.isEnabled()
    load()
    return data.enabled
end

-- ---------------------------------------------------------------- which NPCs have a card

-- Builds the sets of config ids and names that cards already use. Rebuilt when the number of
-- cards changes (the deck is only loaded once, so in practice this runs once).
local function buildCarded()
    if carded ~= nil and cardedCount == #Cards.list then
        return
    end
    carded = { ids = {}, names = {} }
    cardedCount = #Cards.list
    for _, card in ipairs(Cards.list) do
        if Cards.kindOf(card) == "npc" then
            local art = Cards.getArt(card)
            local okId, npcId = pcall(function() return id.NPC[art.npc] end)
            if okId and Cards.isValidNpcId(npcId) then
                carded.ids[npcId] = true
                local okName, name = pcall(function() return config.NPC.FromID(npcId).name end)
                if okName and type(name) == "string" and name ~= "" then
                    carded.names[keyOf(name)] = true
                end
            end
        end
    end
end

-- True if this NPC has a card (or is not worth a card: no name).
local function hasCard(npc, name)
    if carded.ids[npc.configID] or carded.ids[npc.parentConfigID] then
        return true
    end
    return carded.names[keyOf(name)] == true
end

-- ---------------------------------------------------------------- looking at the NPCs

-- Looks at the NPCs around the player and rebuilds `tracked`.
local function look()
    buildCarded()
    tracked = {}
    local okPlayer, player = pcall(Player.GetEntity)
    if not okPlayer or player == nil then
        return
    end
    local okList, entities = pcall(NPCList.ByDistance, player.coordGrid, data.range)
    if not okList or entities == nil then
        return
    end
    for _, npc in ipairs(entities) do
        local okNpc, name = pcall(function()
            if not npc.isValid then
                return nil
            end
            return npc.config.name
        end)
        if okNpc and type(name) == "string" and name ~= "" and name ~= "null" then
            local key = keyOf(name)
            if data.ignored[key] == nil and not hasCard(npc, name) then
                tracked[#tracked + 1] = { npc = npc, name = name }
                if seen[key] == nil then
                    seenCounter = seenCounter + 1
                    local okCfg, configName = pcall(function() return tostring(npc.config.configName) end)
                    seen[key] = { name = name, configName = okCfg and configName or "?", order = 0 }
                end
                seenCounter = seenCounter + 1
                seen[key].order = seenCounter
            end
        end
    end
end

-- ---------------------------------------------------------------- the labels

local function makeMarker()
    local back = ui.Rectangle.new(parentLayer)
    back.fill = true
    back.colour = BACK_COLOUR
    back:SetSize(LABEL_W, LABEL_H)
    pcall(function() back.clickthrough = true end)
    local text = Kit.text(parentLayer, 0, 0, LABEL_W, LABEL_H, "", LABEL_COLOUR)
    pcall(function() text.clickthrough = true end)
    return { back = back, text = text }
end

local function hideMarker(marker)
    pcall(function()
        marker.back.hidden = true
        marker.text.hidden = true
    end)
end

local function destroyMarkers()
    for _, marker in ipairs(markers) do
        pcall(function() marker.back:Destroy() end)
        pcall(function() marker.text:Destroy() end)
    end
    markers = {}
end

-- Puts the labels over the tracked NPCs, once every frame so they follow the NPCs as they move.
local function placeMarkers()
    local shown = 0
    if data.enabled and parentLayer ~= nil then
        for _, entry in ipairs(tracked) do
            if shown >= MAX_MARKERS then
                break
            end
            local okPos, screen = pcall(function()
                if not entry.npc.isValid then
                    return nil
                end
                return ScreenConvert.CoordFineToScreen(entry.npc.position, LABEL_HEIGHT)
            end)
            if okPos and screen ~= nil then
                shown = shown + 1
                if markers[shown] == nil then
                    markers[shown] = makeMarker()
                end
                local marker = markers[shown]
                local x, y = math.floor(screen.x - LABEL_W / 2), math.floor(screen.y - LABEL_H)
                pcall(function()
                    marker.back:SetPos(x, y)
                    marker.text:SetPos(x, y)
                    marker.text.content = "No card: " .. entry.name
                    marker.back.hidden = false
                    marker.text.hidden = false
                end)
            end
        end
    end
    for i = shown + 1, #markers do
        hideMarker(markers[i])
    end
end

-- The 12 edges of a box, as pairs of corners numbered by their bits: 1 = x, 2 = y, 4 = z (0 = the
-- minimum side, 1 = the maximum).
local EDGES = {}
for corner = 0, 7 do
    for _, bit in ipairs({ 1, 2, 4 }) do
        if corner & bit == 0 then
            EDGES[#EDGES + 1] = { corner, corner | bit }
        end
    end
end

local outlineFailed = false  -- set when drawing lines does not work here, so it is not tried every frame

-- Draws a box round the NPC's hull in the world (visible through walls), so it stands out at a glance.
local function drawOutline(npc)
    local box = npc.aabb
    local lo, hi = box.minimum, box.maximum
    -- If the box is given relative to the NPC rather than in the world, move it to the NPC.
    local centre = box.centre
    local pos = npc.position
    local dx, dz = centre.x - pos.x, centre.z - pos.z
    local ox, oy, oz = 0, 0, 0
    if dx * dx + dz * dz > 5120 * 5120 then
        ox, oy, oz = pos.x, pos.y, pos.z
    end
    local function corner(index)
        return Vector3.new((index & 1 == 0 and lo.x or hi.x) + ox, (index & 2 == 0 and lo.y or hi.y) + oy,
            (index & 4 == 0 and lo.z or hi.z) + oz)
    end
    for _, edge in ipairs(EDGES) do
        ShapeList.DrawLine({
            positions = { corner(edge[1]), corner(edge[2]) },
            ignoreDepth = true, colour = OUTLINE_RGBA, lineWidth = OUTLINE_WIDTH,
        })
    end
end

local function placeOutlines()
    if outlineFailed or not data.enabled or not data.outline or ShapeList == nil then
        return
    end
    for i, entry in ipairs(tracked) do
        if i > MAX_MARKERS then
            break
        end
        local ok, err = pcall(function()
            if entry.npc.isValid then
                drawOutline(entry.npc)
            end
        end)
        if not ok then
            outlineFailed = true
            log("uncarded: outline failed, turned off until reload:", err)
            return
        end
    end
end

local function onDraw()
    if not active then
        return
    end
    frame = frame + 1
    if frame % SCAN_FRAMES == 1 then
        local ok, err = pcall(look)
        if not ok then
            log("uncarded: look failed:", err)
        end
    end
    local ok, err = pcall(placeMarkers)
    if not ok then
        log("uncarded: labels failed:", err)
    end
    placeOutlines()
end

-- Starts looking for uncarded NPCs. Safe to call again.
function Uncarded.start()
    load()
    if active then
        return
    end
    local okLayer, layer = pcall(function()
        return ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    end)
    if not okLayer or layer == nil then
        log("uncarded: no game layer to draw on")
        return
    end
    parentLayer = layer
    active = true
    frame = 0
    Event.Draw.Subscribe(SUBSCRIBER, onDraw)
end

-- Stops, and takes the labels away.
function Uncarded.stop()
    active = false
    pcall(function() Event.Draw.Unsubscribe(SUBSCRIBER) end)
    destroyMarkers()
    tracked = {}
    parentLayer = nil
end

-- ---------------------------------------------------------------- the window

local function clearRows()
    for _, part in ipairs(rows) do
        pcall(function() part:Destroy() end)
    end
    rows = {}
end

-- The NPCs to list: the ones seen and not ignored (latest first), or the ignored ones (A to Z).
local function listed()
    local list = {}
    if showIgnored then
        for key, name in pairs(data.ignored) do
            list[#list + 1] = { key = key, name = name, configName = "" }
        end
        table.sort(list, function(a, b) return a.key < b.key end)
    else
        for key, entry in pairs(seen) do
            if data.ignored[key] == nil then
                list[#list + 1] = { key = key, name = entry.name, configName = entry.configName, order = entry.order }
            end
        end
        table.sort(list, function(a, b) return a.order > b.order end)
    end
    return list
end

local refresh

local function setIgnored(entry, ignore)
    if ignore then
        data.ignored[entry.key] = entry.name
    else
        data.ignored[entry.key] = nil
    end
    save()
    -- Take effect now rather than at the next look.
    pcall(look)
    refresh()
end

refresh = function()
    if window == nil then
        return
    end
    clearRows()
    load()
    toggleButton.label = data.enabled and "Labels: ON" or "Labels: OFF"
    outlineButton.label = data.outline and "Outline: ON" or "Outline: OFF"
    rangeText.content = "Look within " .. data.range .. " tiles"
    local list = listed()
    local ignoredCount = 0
    for _ in pairs(data.ignored) do ignoredCount = ignoredCount + 1 end
    if showIgnored then
        statusText.content = ignoredCount .. " ignored" .. (#list > MAX_ROWS and (" (showing " .. MAX_ROWS .. ")") or "")
    else
        statusText.content = #list .. " uncarded seen" .. (#list > MAX_ROWS and (" (showing " .. MAX_ROWS .. ")") or "")
            .. ", " .. ignoredCount .. " ignored"
    end
    for i = 1, math.min(#list, MAX_ROWS) do
        local entry = list[i]
        local y = LIST_TOP + (i - 1) * ROW_H
        local label = entry.name .. (entry.configName ~= "" and ("   " .. entry.configName) or "")
        rows[#rows + 1] = Kit.text(content, 10, y, WIDTH - 140, 30, label, WHITE, ui.AlignMode.TOPLEFT)
        rows[#rows + 1] = Kit.buttonAt(content, showIgnored and "Restore" or "Ignore", WIDTH - 120, y, 110, 30,
            function() setIgnored(entry, not showIgnored) end)
    end
end

function Uncarded.show()
    if window ~= nil then
        return
    end
    load()
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Uncarded NPCs", WIDTH, LIST_TOP + MAX_ROWS * ROW_H + 10 + Kit.titleBarHeight(),
        function() Uncarded.hide() end, 0.8, 0.05)
    toggleButton = Kit.buttonAt(content, "Labels", 10, 2, 140, 30, function()
        data.enabled = not data.enabled
        save()
        refresh()
    end, "positive")
    outlineButton = Kit.buttonAt(content, "Outline", 160, 2, 150, 30, function()
        data.outline = not data.outline
        save()
        refresh()
    end, "positive")
    Kit.buttonAt(content, "Refresh", 320, 2, 110, 30, refresh)
    -- How far to look: changing it takes effect straight away.
    rangeText = Kit.text(content, 10, 40, 250, 30, "", WHITE, ui.AlignMode.TOPLEFT)
    local function changeRange(by)
        data.range = math.max(MIN_RANGE, math.min(MAX_RANGE, data.range + by))
        save()
        pcall(look)
        refresh()
    end
    Kit.buttonAt(content, "- " .. RANGE_STEP, 270, 38, 90, 30, function() changeRange(-RANGE_STEP) end)
    Kit.buttonAt(content, "+ " .. RANGE_STEP, 370, 38, 90, 30, function() changeRange(RANGE_STEP) end)
    Kit.buttonAt(content, "Seen / Ignored", WIDTH - 170, 2, 160, 30, function()
        showIgnored = not showIgnored
        refresh()
    end)
    statusText = Kit.text(content, 10, 76, WIDTH - 20, 24, "", WHITE, ui.AlignMode.TOPLEFT)
    refresh()
end

function Uncarded.hide()
    clearRows()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, statusText, toggleButton = nil, nil, nil, nil
    outlineButton, rangeText = nil, nil
end

function Uncarded.isOpen()
    return window ~= nil
end

function Uncarded.toggle()
    if window ~= nil then
        Uncarded.hide()
    else
        Uncarded.show()
    end
end

return Uncarded
