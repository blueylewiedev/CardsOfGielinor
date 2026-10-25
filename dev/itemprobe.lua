-- itemprobe.lua
-- Developer-only: a window for finding items (called "Obj" in the API) and seeing how they would
-- look on a card. It can
--   * Search: find an item by part of its config name or its in-game name, anywhere in the game
--     (like the NPC search). Ignores capitals, spaces and underscores.
--   * Show: type a config name (LOGS) or an id (1511) and show that item's icon and 3D model, with
--     its data. Zoom - / Zoom + change the model's distance.
--   * Read GE: list the player's Grand Exchange offers (the game only exposes offers that have
--     been placed, not the item in the search or buy window) with each offer's item id,
--     config name and in-game name. Each row has a Show button.
-- Every id/name line it finds also goes to the Output window, where it can be copied.
-- Item ids: id.Obj. Icon: ui.Sprite with associatedObjectID. Model: ui.ModelType.OBJECT.

local Kit = require("ui/kit")
local OutputWindow = require("dev/outputwindow")

local ItemProbe = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.7, 0.7, 0.7, 1)
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)

local WIDTH = 700
local ROW_H, MAX_ROWS = 30, 8
local ROWS_TOP = 74
local PREVIEW_TOP = ROWS_TOP + MAX_ROWS * ROW_H + 14
local BOX = 150
local HEIGHT = PREVIEW_TOP + BOX + 50
local PER_FRAME = 400                 -- in-game names looked at each frame

local STAGES = { [0] = "EMPTY", "ADDING", "ADDED", "VERIFYING", "ABORTING", "FINISHED" }
local TYPES = { [0] = "BUY", "SELL" }

local window, content = nil, nil
local field, statusText, infoText = nil, nil, nil
local rowParts = {}
local previewParts = {}
local index = nil                      -- every item: { id, configName, key }, read once
local search = nil                     -- a search still checking in-game names
local shownId = nil
local distance = 300                   -- the model's viewDistance

-- Lower case with everything but letters and digits removed.
function ItemProbe.simplify(text)
    return (string.gsub(string.lower(tostring(text or "")), "[^%w]", ""))
end

local function say(label, text)
    log("itemprobe:", label, text)
    OutputWindow.add("itemprobe", label .. " " .. text)
end

local function setStatus(text)
    if statusText ~= nil then
        statusText.content = text
    end
end

local function destroyAll(list)
    for i = #list, 1, -1 do
        pcall(function() list[i]:Destroy() end)
        list[i] = nil
    end
end

-- The Obj config for an id, or nil.
local function configOf(objId)
    local ok, cfg = pcall(function() return config.Obj.FromID(objId) end)
    if ok then
        return cfg
    end
    return nil
end

-- A property of a config, or nil if it cannot be read.
local function prop(cfg, name)
    if cfg == nil then
        return nil
    end
    local ok, value = pcall(function() return cfg[name] end)
    if ok then
        return value
    end
    return nil
end

local function displayName(objId)
    local name = prop(configOf(objId), "name")
    return type(name) == "string" and name or "?"
end

-- Reads id.Obj once. Returns the list, or nil if the client would not list it.
local function loadIndex()
    if index ~= nil then
        return index
    end
    local list = {}
    local ok = pcall(function()
        for key, value in pairs(id.Obj) do
            local objId, name = key, value
            if type(key) == "string" and type(value) == "number" then
                objId, name = value, key
            end
            if type(objId) == "number" and type(name) == "string" then
                list[#list + 1] = { id = objId, configName = name, key = ItemProbe.simplify(name) }
            end
        end
    end)
    if not ok or #list == 0 then
        return nil
    end
    table.sort(list, function(a, b) return a.id < b.id end)
    index = list
    return index
end

-- The items whose config name contains `text` (at most `limit`), as { id, configName, name }.
function ItemProbe.find(text, limit)
    local list = loadIndex()
    if list == nil then
        return nil
    end
    local wanted = ItemProbe.simplify(text)
    local found = {}
    if wanted == "" then
        return found
    end
    for _, entry in ipairs(list) do
        if string.find(entry.key, wanted, 1, true) ~= nil then
            found[#found + 1] = { id = entry.id, configName = entry.configName, name = displayName(entry.id) }
            if #found >= limit then
                break
            end
        end
    end
    return found
end

-- Resolves what was typed: an id (digits), or a config name. Returns id, configName or nil.
function ItemProbe.resolve(text)
    text = tostring(text or "")
    local number = tonumber(text)
    if number ~= nil then
        local cfg = configOf(number)
        if cfg ~= nil and prop(cfg, "id") ~= nil then
            return number, prop(cfg, "configName")
        end
        return nil
    end
    local wanted = ItemProbe.simplify(text)
    if wanted == "" then
        return nil
    end
    local list = loadIndex()
    if list == nil then
        return nil
    end
    for _, entry in ipairs(list) do
        if entry.key == wanted then
            return entry.id, entry.configName
        end
    end
    return nil
end

-- ---------------------------------------------------------------------------------------------
-- The preview: icon, model and data for one item.

local function showItem(objId)
    destroyAll(previewParts)
    shownId = objId
    local cfg = configOf(objId)
    local configName = prop(cfg, "configName") or "?"
    local name = prop(cfg, "name") or "?"
    if content == nil then
        return
    end

    local ok, err = pcall(function()
        local sprite = ui.Sprite.new(content)
        previewParts[#previewParts + 1] = sprite
        sprite:SetPos(10, PREVIEW_TOP + 40)
        sprite:SetSize(64, 64)
        sprite.associatedObjectID = objId
        sprite.associatedObjectQuantity = 1
    end)
    if not ok then
        say("icon failed", tostring(err))
    end
    previewParts[#previewParts + 1] = Kit.text(content, 10, PREVIEW_TOP + 108, 80, 20, "Icon", GREY, ui.AlignMode.TOPLEFT)

    local modelOk, modelErr = pcall(function()
        local model = ui.Model.new(content)
        previewParts[#previewParts + 1] = model
        model:SetPos(100, PREVIEW_TOP)
        model:SetSize(BOX, BOX)
        model.modelWidth = BOX
        model.modelHeight = BOX
        model.viewDistance = distance
        model:SetModel(ui.ModelType.OBJECT, objId)
    end)
    if not modelOk then
        say("model failed", tostring(modelErr))
    end
    previewParts[#previewParts + 1] = Kit.text(content, 100, PREVIEW_TOP + BOX + 2, BOX, 20,
        "Model, distance " .. distance, GREY, ui.AlignMode.TOPLEFT)

    local lines = {
        name,
        "id " .. objId .. "   " .. configName,
        "members: " .. tostring(prop(cfg, "isMembers")) .. "   tradeable: " .. tostring(prop(cfg, "isTradeable")),
        "category: " .. tostring(prop(cfg, "category")) .. "   cost: " .. tostring(prop(cfg, "cost")),
        "stack: " .. tostring(prop(cfg, "stackType")) .. "   GE item: " .. tostring(prop(cfg, "isStockmarket"))
            .. "   GE limit: " .. tostring(prop(cfg, "stockmarketBuyLimit")),
    }
    previewParts[#previewParts + 1] = Kit.text(content, 270, PREVIEW_TOP, WIDTH - 290, 26, lines[1], GOLD, ui.AlignMode.TOPLEFT)
    for i = 2, #lines do
        previewParts[#previewParts + 1] = Kit.text(content, 270, PREVIEW_TOP + (i - 1) * 28, WIDTH - 290, 26,
            lines[i], WHITE, ui.AlignMode.TOPLEFT)
    end
    say("show", objId .. " " .. configName .. " = " .. name)
end

local function zoom(factor)
    distance = math.max(20, math.floor(distance * factor + 0.5))
    if shownId ~= nil then
        showItem(shownId)
    end
end

-- ---------------------------------------------------------------------------------------------
-- The rows (search results or Grand Exchange offers). Each is { text, id }.

local function showRows(entries)
    destroyAll(rowParts)
    for i, entry in ipairs(entries) do
        if i > MAX_ROWS then
            break
        end
        local y = ROWS_TOP + (i - 1) * ROW_H
        rowParts[#rowParts + 1] = Kit.text(content, 10, y, WIDTH - 110, ROW_H - 4, entry.text, WHITE, ui.AlignMode.TOPLEFT)
        if entry.id ~= nil then
            rowParts[#rowParts + 1] = Kit.smallButton(content, "Show", WIDTH - 90, y, 70, ROW_H - 4, function()
                showItem(entry.id)
            end)
        end
    end
end

local function rowFor(item)
    return { id = item.id, text = item.id .. "   " .. item.configName .. "   -   " .. item.name }
end

local function reportFound(entries)
    for _, entry in ipairs(entries) do
        OutputWindow.add("itemprobe", entry.text)
    end
end

-- ---------------------------------------------------------------------------------------------
-- Search.

-- Checks the next batch of in-game names. Runs every frame while a search is going.
function ItemProbe.step()
    if search == nil then
        return
    end
    local list = index
    local stop = math.min(#list, search.next + PER_FRAME - 1)
    for position = search.next, stop do
        local entry = list[position]
        if not search.seen[entry.id] then
            local name = displayName(entry.id)
            if string.find(ItemProbe.simplify(name), search.wanted, 1, true) ~= nil then
                search.found[#search.found + 1] = { id = entry.id, configName = entry.configName, name = name }
                search.seen[entry.id] = true
                if #search.found >= MAX_ROWS then
                    break
                end
            end
        end
    end
    search.next = stop + 1
    local entries = {}
    for _, item in ipairs(search.found) do
        entries[#entries + 1] = rowFor(item)
    end
    if #search.found >= MAX_ROWS or search.next > #list then
        showRows(entries)
        reportFound(entries)
        setStatus(#entries .. " found" .. (#entries >= MAX_ROWS and " (first " .. MAX_ROWS .. ", type more to narrow it)" or ""))
        search = nil
    else
        setStatus("Checking in-game names... " .. math.floor(100 * search.next / #list) .. "%")
    end
end
Event.Draw.Subscribe("cardcollector_itemprobe", function() ItemProbe.step() end)

function ItemProbe.search(text)
    destroyAll(rowParts)
    search = nil
    local wanted = ItemProbe.simplify(text)
    if wanted == "" then
        setStatus("Type part of an item's name first.")
        return
    end
    local found = ItemProbe.find(text, MAX_ROWS)
    if found == nil then
        setStatus("The client would not list item names (id.Obj).")
        return
    end
    local entries = {}
    local seen = {}
    for _, item in ipairs(found) do
        entries[#entries + 1] = rowFor(item)
        seen[item.id] = true
    end
    showRows(entries)
    if #found >= MAX_ROWS then
        reportFound(entries)
        setStatus(#found .. " found (first " .. MAX_ROWS .. ", type more to narrow it)")
        return
    end
    -- Few config names matched, so look at the in-game names too, a batch each frame.
    search = { wanted = wanted, next = 1, found = found, seen = seen }
    setStatus(#found .. " found so far. Checking in-game names...")
end

-- ---------------------------------------------------------------------------------------------
-- Grand Exchange.

function ItemProbe.readGrandExchange()
    destroyAll(rowParts)
    search = nil
    if GrandExchange == nil then
        setStatus("This client has no GrandExchange table.")
        return
    end
    local okMax, maxOffers = pcall(function() return GrandExchange.MaxOffers() end)
    if not okMax or type(maxOffers) ~= "number" then
        maxOffers = 8
    end
    local entries = {}
    local used = 0
    for slot = 1, maxOffers do
        local ok, offer = pcall(function() return GrandExchange.GetOffer(slot) end)
        if ok and offer ~= nil then
            local stage = prop(offer, "stage")
            local kind = prop(offer, "type")
            local item = prop(offer, "item")
            local itemId = prop(item, "id")
            local text
            if type(itemId) == "number" and itemId >= 0 and stage ~= 0 then
                used = used + 1
                text = "Slot " .. slot .. " " .. tostring(TYPES[kind] or kind) .. " " .. tostring(STAGES[stage] or stage)
                    .. "   " .. itemId .. " " .. tostring(prop(item, "configName")) .. " - " .. tostring(prop(item, "name"))
                    .. "   x" .. tostring(prop(offer, "itemCount")) .. " (" .. tostring(prop(offer, "soldCount")) .. " done)"
                    .. " @ " .. tostring(prop(offer, "price")) .. "gp"
                entries[#entries + 1] = { id = itemId, text = text }
            else
                entries[#entries + 1] = { text = "Slot " .. slot .. " empty" }
            end
        else
            entries[#entries + 1] = { text = "Slot " .. slot .. " - no offer data (" .. tostring(offer) .. ")" }
        end
    end
    showRows(entries)
    reportFound(entries)
    setStatus(used .. " offer(s) in " .. maxOffers .. " slots. Place an offer to read an item that is not listed.")
end

-- ---------------------------------------------------------------------------------------------
-- The window.

local function showTyped()
    local text = field ~= nil and field.content or ""
    if type(text) ~= "string" or text == "" then
        text = "LOGS"
    end
    local objId, configName = ItemProbe.resolve(text)
    if objId == nil then
        setStatus("No item with that id or exact config name. Use Search to find it.")
        return
    end
    setStatus("Showing " .. tostring(configName))
    showItem(objId)
end

function ItemProbe.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Item probe", WIDTH, HEIGHT + Kit.titleBarHeight(),
        function() ItemProbe.hide() end, 0.5, 0.2)
    Kit.text(content, 10, 4, 60, 26, "Item:", WHITE, ui.AlignMode.TOPLEFT)
    field = Kit.inputField(content, 70, 4, 290, 26, 40, false)
    pcall(function() field.content = "LOGS" end)
    Kit.buttonAt(content, "Search", 372, 2, 100, 30, function() ItemProbe.search(field.content) end, "positive")
    Kit.buttonAt(content, "Show", 478, 2, 90, 30, showTyped)
    Kit.buttonAt(content, "Read GE", 574, 2, 116, 30, function()
        local ok, err = pcall(ItemProbe.readGrandExchange)
        if not ok then
            setStatus("Grand Exchange read failed: " .. tostring(err))
            say("GE failed", tostring(err))
        end
    end)
    statusText = Kit.text(content, 10, 40, WIDTH - 20, 26,
        "Search by name, Show by config name or id, or Read GE for your offers.", GREY, ui.AlignMode.TOPLEFT)
    Kit.smallButton(content, "Zoom -", WIDTH - 180, HEIGHT - 36, 80, 28, function() zoom(1.25) end)
    Kit.smallButton(content, "Zoom +", WIDTH - 90, HEIGHT - 36, 80, 28, function() zoom(0.8) end)
end

function ItemProbe.hide()
    search = nil
    destroyAll(rowParts)
    destroyAll(previewParts)
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, field, statusText, infoText, shownId = nil, nil, nil, nil, nil, nil
end

function ItemProbe.toggle()
    if window ~= nil then
        ItemProbe.hide()
    else
        ItemProbe.show()
    end
end

return ItemProbe
