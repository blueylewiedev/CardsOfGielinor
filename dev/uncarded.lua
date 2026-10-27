-- uncarded.lua
-- Developer-only: draws a yellow box round every NPC near the player that has no card yet, so the
-- ones we missed are easy to spot while walking around.
--
-- It is passive: from the moment the developer tools are in use it looks at the NPCs around the
-- player every half second or so and keeps a box round each one that has no card. Nothing has to
-- be opened or scanned. The "Uncarded NPCs" window (Home window button) turns the boxes on or off,
-- sets how far to look, and lists the NPCs seen, each with an Ignore button, for the ones that will
-- never get a card or that have a card with another model. Ignoring is by NPC name, so every
-- variant of that NPC goes quiet, and it is remembered between sessions (PersistentDB).
--
-- An NPC counts as having a card when a card's NPC has the same config id, or the same display
-- name (so a card for "Giant rat" covers every variant of it). Item cards are not looked at.

local Cards = require("core/cards")
local Kit = require("ui/kit")
local Builder = require("dev/builder")

local Uncarded = {}

local DB_KEY = "dev_uncarded"
local SUBSCRIBER = "cardcollector_uncarded"

local DEFAULT_RANGE = 20     -- how many tiles around the player to look, until it is changed
local MIN_RANGE, MAX_RANGE, RANGE_STEP = 2, 50, 2
local SCAN_FRAMES = 30       -- frames between looks at the NPCs around the player
local MAX_BOXES = 12         -- boxes drawn at once (the nearest NPCs)
local OUTLINE_RGBA = 0xFFE633FF     -- the box round the NPC: yellow, as a packed RGBA number
local OUTLINE_WIDTH = 2

-- The window. The visible width of its contents is a little less than WIDTH, so things lined up on
-- the right edge use RIGHT.
local WIDTH, ROW_H = 640, 52
local RIGHT = WIDTH - 80
local ROWS = 7               -- rows on a page
local ROWS_TOP = 118
local BUTTON_H = 30
local LINE_H = 17            -- each row has three lines of text: name, config name, animation set
local ACTION_W = 100         -- width of the Ignore / Restore buttons
local CARD_W = 100           -- width of the Card button
local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.7, 0.7, 0.7, 1)

local data = nil             -- { enabled = true/false, range = tiles, ignored = { [lower case name] = name } }
local active = false         -- true while the Draw handler is running
local frame = 0
local tracked = {}           -- the uncarded NPCs found by the last look: { npc, name }, nearest first
local seen = {}              -- [lower case name] = { name, configName, order } for the window
local seenCounter = 0

local carded = nil           -- { ids = { [config id] = true }, names = { [lower case name] = true } }
local cardedCount = -1       -- how many cards the sets above were built for

local window, content = nil, nil
local rows = {}
local statusText = nil
local pageText = nil
local boxButton = nil
local modeButton = nil
local rangeText = nil
local showIgnored = false
local page = 1

-- ---------------------------------------------------------------- saved settings

local function load()
    if data ~= nil then
        return
    end
    data = { enabled = true, range = DEFAULT_RANGE, ignored = {} }
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(DB_KEY) end)
    if not ok or type(saved) ~= "table" then
        return
    end
    if saved.enabled == false then
        data.enabled = false
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

-- True if this NPC has a card.
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
                    local okCfg, configName = pcall(function() return tostring(npc.config.configName) end)
                    -- The animation set is a clue to which animations suit the NPC.
                    local okBas, bas = pcall(function() return tostring(npc.config.bas.configName) end)
                    seen[key] = { name = name, configName = okCfg and configName or "?",
                        bas = okBas and bas or "none", order = 0 }
                end
                seenCounter = seenCounter + 1
                seen[key].order = seenCounter
            end
        end
    end
end

-- ---------------------------------------------------------------- the boxes

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

local drawFailed = false     -- set when drawing lines does not work here, so it is not tried every frame

-- Draws a box round the NPC's hull in the world (visible through walls), so it stands out at a glance.
local function drawBox(npc)
    local box = npc.aabb
    if box == nil then
        return       -- an NPC with no hull to draw: skip it, the others are fine
    end
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

local function drawBoxes()
    if drawFailed or not data.enabled or ShapeList == nil then
        return
    end
    for i, entry in ipairs(tracked) do
        if i > MAX_BOXES then
            break
        end
        local ok, err = pcall(function()
            if entry.npc.isValid then
                drawBox(entry.npc)
            end
        end)
        if not ok then
            drawFailed = true
            log("uncarded: drawing the boxes failed, turned off until reload:", err)
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
    drawBoxes()
end

-- Starts looking for uncarded NPCs. Safe to call again.
function Uncarded.start()
    load()
    if active then
        return
    end
    active = true
    frame = 0
    Event.Draw.Subscribe(SUBSCRIBER, onDraw)
end

-- Stops, and takes the boxes away.
function Uncarded.stop()
    active = false
    pcall(function() Event.Draw.Unsubscribe(SUBSCRIBER) end)
    tracked = {}
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
            list[#list + 1] = { key = key, name = name }
        end
        table.sort(list, function(a, b) return a.key < b.key end)
    else
        for key, entry in pairs(seen) do
            if data.ignored[key] == nil then
                list[#list + 1] = { key = key, name = entry.name, configName = entry.configName, bas = entry.bas,
                    order = entry.order }
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
    boxButton.label = data.enabled and "Boxes: ON" or "Boxes: OFF"
    modeButton.label = showIgnored and "Show seen" or "Show ignored"
    rangeText.content = "Look within " .. data.range .. " tiles"

    local list = listed()
    local pages = math.max(1, math.ceil(#list / ROWS))
    page = math.max(1, math.min(page, pages))
    local ignoredCount = 0
    for _ in pairs(data.ignored) do ignoredCount = ignoredCount + 1 end
    if showIgnored then
        statusText.content = "Ignored NPCs: " .. #list
    else
        statusText.content = "Uncarded NPCs seen: " .. #list .. "   (" .. ignoredCount .. " ignored)"
    end
    pageText.content = "Page " .. page .. " of " .. pages

    local first = (page - 1) * ROWS + 1
    for i = first, math.min(#list, first + ROWS - 1) do
        local entry = list[i]
        local y = ROWS_TOP + (i - first) * ROW_H
        local textW = RIGHT - ACTION_W - (showIgnored and 0 or CARD_W) - 30
        rows[#rows + 1] = Kit.text(content, 10, y, textW, LINE_H, entry.name, WHITE, ui.AlignMode.TOPLEFT)
        if not showIgnored then
            rows[#rows + 1] = Kit.text(content, 10, y + LINE_H, textW, LINE_H, entry.configName, GREY,
                ui.AlignMode.TOPLEFT)
            rows[#rows + 1] = Kit.text(content, 10, y + 2 * LINE_H, textW, LINE_H, "Animation set: " .. entry.bas,
                GREY, ui.AlignMode.TOPLEFT)
            -- Starts a card for this NPC in the Card Builder.
            rows[#rows + 1] = Kit.buttonAt(content, "Card", RIGHT - ACTION_W - CARD_W - 10, y + 8, CARD_W, BUTTON_H,
                function() Builder.loadNpc(entry) end, "positive", "Start a card for this NPC in the Card Builder")
        end
        rows[#rows + 1] = Kit.buttonAt(content, showIgnored and "Restore" or "Ignore", RIGHT - ACTION_W, y + 8,
            ACTION_W, BUTTON_H, function() setIgnored(entry, not showIgnored) end)
    end
    if #list == 0 then
        rows[#rows + 1] = Kit.text(content, 10, ROWS_TOP, RIGHT - 10, BUTTON_H,
            showIgnored and "Nothing is ignored." or "No uncarded NPCs seen yet. Walk around.", GREY,
            ui.AlignMode.TOPLEFT)
    end
end

function Uncarded.show()
    if window ~= nil then
        return
    end
    load()
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local height = ROWS_TOP + ROWS * ROW_H + 10 + Kit.titleBarHeight()
    window, content = Kit.window(gameWindow, "Uncarded NPCs", WIDTH, height,
        function() Uncarded.hide() end, 0.2, 0.10)

    -- Top row: the switch, and which list is shown.
    boxButton = Kit.buttonAt(content, "Boxes", 10, 2, 150, BUTTON_H, function()
        data.enabled = not data.enabled
        save()
        refresh()
    end, "positive")
    modeButton = Kit.buttonAt(content, "Show ignored", RIGHT - 170, 2, 170, BUTTON_H, function()
        showIgnored = not showIgnored
        page = 1
        refresh()
    end)

    -- Second row: how far to look. Changing it takes effect straight away.
    rangeText = Kit.text(content, 10, 40, 260, BUTTON_H, "", WHITE, ui.AlignMode.TOPLEFT)
    local function changeRange(by)
        data.range = math.max(MIN_RANGE, math.min(MAX_RANGE, data.range + by))
        save()
        pcall(look)
        refresh()
    end
    Kit.buttonAt(content, "- " .. RANGE_STEP, RIGHT - 190, 40, 90, BUTTON_H, function() changeRange(-RANGE_STEP) end)
    Kit.buttonAt(content, "+ " .. RANGE_STEP, RIGHT - 90, 40, 90, BUTTON_H, function() changeRange(RANGE_STEP) end)

    -- Third row: what the list holds, and the pages.
    statusText = Kit.text(content, 10, 78, 320, 24, "", WHITE, ui.AlignMode.TOPLEFT)
    Kit.buttonAt(content, "Prev", RIGHT - 300, 76, 80, 28, function() page = page - 1 refresh() end)
    pageText = Kit.text(content, RIGHT - 210, 78, 120, 24, "", WHITE)
    Kit.buttonAt(content, "Next", RIGHT - 80, 76, 80, 28, function() page = page + 1 refresh() end)
    refresh()
end

function Uncarded.hide()
    clearRows()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, statusText, pageText, boxButton, modeButton, rangeText = nil, nil, nil, nil, nil, nil, nil
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
