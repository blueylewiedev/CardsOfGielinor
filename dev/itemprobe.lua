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
--   * Results are paged (arrows at the bottom of the list), so a search is not limited to a few rows.
-- Every id/name line it finds also goes to the Output window, where it can be copied.
-- Item ids: id.Obj. Icon: ui.Sprite with associatedObjectID. Model: ui.ModelType.OBJECT.

local Kit = require("ui/kit")
local OutputWindow = require("dev/outputwindow")

local ItemProbe = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.7, 0.7, 0.7, 1)
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)

local WIDTH = 980
local LEFT_W = 600                   -- the list of results
local RIGHT_X, RIGHT_W = 630, 340     -- the preview
local ROW_H, PAGE_SIZE = 28, 14
local ROWS_TOP = 78
local PAGER_Y = ROWS_TOP + PAGE_SIZE * ROW_H + 8
local MODEL_Y, MODEL_W, MODEL_H = 204, RIGHT_W, 230
local HEIGHT = PAGER_Y + 44
local MAX_RESULTS = 3000              -- a search stops collecting here
local PER_FRAME = 400                 -- in-game names looked at each frame

local STAGES = { [0] = "EMPTY", "ADDING", "ADDED", "VERIFYING", "ABORTING", "FINISHED" }
local TYPES = { [0] = "BUY", "SELL" }

local window, content = nil, nil
local field, statusText = nil, nil
local rowParts = {}
local results = {}                 -- what the list shows: { text, id (optional) }
local page = 1
local pageText = nil
local previewParts = {}
local index = nil                      -- every item: { id, configName, key }, read once
local search = nil                     -- a search still checking in-game names: { wanted, next, seen, count }
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
            if limit ~= nil and #found >= limit then
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
-- Sprites for the buttons. SEARCH, EYE and the arrows are PrettyUI's own. It has no Grand Exchange
-- picture, so the game's sprite list (id.Sprite) is searched for one; the names it finds are
-- written to the Output window once so a better one can be chosen.

local geSpriteId, geSearched = nil, false

local function findGeSprite()
    if geSearched then
        return geSpriteId
    end
    geSearched = true
    local names = {}
    pcall(function()
        for key, value in pairs(id.Sprite) do
            local spriteId, name = key, value
            if type(key) == "string" and type(value) == "number" then
                spriteId, name = value, key
            end
            if type(spriteId) == "number" and type(name) == "string" then
                local upper = string.upper(name)
                if string.find(upper, "GRAND_EXCHANGE", 1, true) or string.find(upper, "GRANDEXCHANGE", 1, true)
                    or string.find(upper, "GEBUTTON", 1, true) or string.find(upper, "GE_ICON", 1, true) then
                    names[#names + 1] = { id = spriteId, name = name }
                end
            end
        end
    end)
    table.sort(names, function(a, b) return a.id < b.id end)
    local listed = {}
    for i = 1, math.min(#names, 30) do
        listed[#listed + 1] = names[i].id .. " " .. names[i].name
    end
    say("sprites that mention the Grand Exchange", #names .. " found: " .. table.concat(listed, ", "))
    if #names > 0 then
        geSpriteId = names[1].id
    end
    return geSpriteId
end

-- A small button with the Grand Exchange sprite on it, or the letters GE if there is none.
local function geButton(x, y, onPress)
    local spriteId = findGeSprite()
    if spriteId ~= nil and Kit.available() and prettyui.SimpleButton ~= nil then
        local ok, button = pcall(prettyui.SimpleButton.new, content, spriteId, function() onPress() end, {
            x = x, y = y, width = 36, height = 28, absolute = true, tooltip = "Read my Grand Exchange offers",
        })
        if ok and button ~= nil then
            return button
        end
        say("GE sprite button failed", tostring(button))
    end
    return Kit.smallButton(content, "GE", x, y, 40, 28, onPress, "Read my Grand Exchange offers")
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
    local function text(x, y, w, line, colour)
        previewParts[#previewParts + 1] = Kit.text(content, x, y, w, 24, line, colour or WHITE, ui.AlignMode.TOPLEFT)
    end

    text(RIGHT_X, ROWS_TOP, RIGHT_W, name, GOLD)
    text(RIGHT_X, ROWS_TOP + 26, RIGHT_W, "id " .. objId .. "   " .. configName, WHITE)

    local ok, err = pcall(function()
        local sprite = ui.Sprite.new(content)
        previewParts[#previewParts + 1] = sprite
        sprite:SetPos(RIGHT_X, ROWS_TOP + 54)
        sprite:SetSize(64, 64)
        sprite.associatedObjectID = objId
        sprite.associatedObjectQuantity = 1
    end)
    if not ok then
        say("icon failed", tostring(err))
    end
    text(RIGHT_X + 76, ROWS_TOP + 54, RIGHT_W - 76,
        "members: " .. tostring(prop(cfg, "isMembers")) .. "   tradeable: " .. tostring(prop(cfg, "isTradeable")), GREY)
    text(RIGHT_X + 76, ROWS_TOP + 78, RIGHT_W - 76,
        "category: " .. tostring(prop(cfg, "category")) .. "   cost: " .. tostring(prop(cfg, "cost")), GREY)
    text(RIGHT_X + 76, ROWS_TOP + 102, RIGHT_W - 76,
        "stack: " .. tostring(prop(cfg, "stackType")) .. "   GE: " .. tostring(prop(cfg, "isStockmarket"))
            .. "   limit: " .. tostring(prop(cfg, "stockmarketBuyLimit")), GREY)

    local modelOk, modelErr = pcall(function()
        local model = ui.Model.new(content)
        previewParts[#previewParts + 1] = model
        model:SetPos(RIGHT_X, MODEL_Y)
        model:SetSize(MODEL_W, MODEL_H)
        model.modelWidth = MODEL_W
        model.modelHeight = MODEL_H
        model.viewDistance = distance
        model:SetModel(ui.ModelType.OBJECT, objId)
    end)
    if not modelOk then
        say("model failed", tostring(modelErr))
    end
    text(RIGHT_X, MODEL_Y + MODEL_H + 2, 160, "Model, distance " .. distance, GREY)
    say("show", objId .. " " .. configName .. " = " .. name)
end

local function zoom(factor)
    distance = math.max(20, math.floor(distance * factor + 0.5))
    if shownId ~= nil then
        showItem(shownId)
    end
end

-- ---------------------------------------------------------------------------------------------
-- The list of results, a page at a time.

local function pageCount()
    return math.max(1, math.ceil(#results / PAGE_SIZE))
end

local function renderPage()
    destroyAll(rowParts)
    if content == nil then
        return
    end
    page = math.max(1, math.min(page, pageCount()))
    local first = (page - 1) * PAGE_SIZE + 1
    for n = 0, PAGE_SIZE - 1 do
        local entry = results[first + n]
        if entry == nil then
            break
        end
        local y = ROWS_TOP + n * ROW_H
        rowParts[#rowParts + 1] = Kit.text(content, 10, y, LEFT_W - 50, ROW_H - 4, entry.text, WHITE, ui.AlignMode.TOPLEFT)
        if entry.id ~= nil then
            rowParts[#rowParts + 1] = Kit.iconButton(content, "EYE", LEFT_W - 28, y, function()
                showItem(entry.id)
            end, "Show this item", "Show", 70)
        end
    end
    if pageText ~= nil then
        pageText.content = "Page " .. page .. " of " .. pageCount() .. "   (" .. #results .. " results)"
    end
end

local function setResults(list)
    results = list
    page = 1
    renderPage()
end

local function changePage(delta)
    page = page + delta
    renderPage()
end

local function rowFor(item)
    return { id = item.id, text = item.id .. "   " .. item.configName .. "   -   " .. item.name }
end

local function reportResults()
    for _, entry in ipairs(results) do
        OutputWindow.add("itemprobe", entry.text)
    end
end

-- ---------------------------------------------------------------------------------------------
-- Search. Config-name matches are listed at once; in-game names are checked afterwards, a batch
-- each frame, and any new matches are added to the end of the list.

function ItemProbe.step()
    if search == nil then
        return
    end
    local list = index
    local stop = math.min(#list, search.next + PER_FRAME - 1)
    local added = false
    for position = search.next, stop do
        local entry = list[position]
        if not search.seen[entry.id] and #results < MAX_RESULTS then
            local name = displayName(entry.id)
            if string.find(ItemProbe.simplify(name), search.wanted, 1, true) ~= nil then
                results[#results + 1] = rowFor({ id = entry.id, configName = entry.configName, name = name })
                search.seen[entry.id] = true
                added = true
            end
        end
    end
    search.next = stop + 1
    if added then
        renderPage()
    end
    if search.next > #list or #results >= MAX_RESULTS then
        setStatus(#results .. " found" .. (#results >= MAX_RESULTS and " (stopped at " .. MAX_RESULTS .. ", type more)" or ""))
        reportResults()
        search = nil
    else
        setStatus(#results .. " found so far. Checking in-game names... " .. math.floor(100 * search.next / #list) .. "%")
    end
end
Event.Draw.Subscribe("cardcollector_itemprobe", function() ItemProbe.step() end)

function ItemProbe.search(text)
    search = nil
    setResults({})
    local wanted = ItemProbe.simplify(text)
    if wanted == "" then
        setStatus("Type part of an item's name first.")
        return
    end
    local found = ItemProbe.find(text, MAX_RESULTS)
    if found == nil then
        setStatus("The client would not list item names (id.Obj).")
        return
    end
    local list, seen = {}, {}
    for _, item in ipairs(found) do
        list[#list + 1] = rowFor(item)
        seen[item.id] = true
    end
    setResults(list)
    search = { wanted = wanted, next = 1, seen = seen }
    setStatus(#list .. " found so far. Checking in-game names...")
end

-- ---------------------------------------------------------------------------------------------
-- Grand Exchange.

function ItemProbe.readGrandExchange()
    search = nil
    if GrandExchange == nil then
        setResults({})
        setStatus("This client has no GrandExchange table.")
        return
    end
    local okMax, maxOffers = pcall(function() return GrandExchange.MaxOffers() end)
    if not okMax or type(maxOffers) ~= "number" then
        maxOffers = 8
    end
    local list = {}
    local used = 0
    for slot = 1, maxOffers do
        local ok, offer = pcall(function() return GrandExchange.GetOffer(slot) end)
        if ok and offer ~= nil then
            local stage = prop(offer, "stage")
            local kind = prop(offer, "type")
            local item = prop(offer, "item")
            local itemId = prop(item, "id")
            if type(itemId) == "number" and itemId >= 0 and stage ~= 0 then
                used = used + 1
                list[#list + 1] = { id = itemId, text = "Slot " .. slot .. " " .. tostring(TYPES[kind] or kind) .. " "
                    .. tostring(STAGES[stage] or stage) .. "   " .. itemId .. " " .. tostring(prop(item, "configName"))
                    .. " - " .. tostring(prop(item, "name")) .. "   x" .. tostring(prop(offer, "itemCount"))
                    .. " (" .. tostring(prop(offer, "soldCount")) .. " done) @ " .. tostring(prop(offer, "price")) .. "gp" }
            else
                list[#list + 1] = { text = "Slot " .. slot .. " empty" }
            end
        else
            list[#list + 1] = { text = "Slot " .. slot .. " - no offer data (" .. tostring(offer) .. ")" }
        end
    end
    setResults(list)
    reportResults()
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
        function() ItemProbe.hide() end, 0.15, 0.1)
    Kit.text(content, 10, 6, 60, 26, "Item:", WHITE, ui.AlignMode.TOPLEFT)
    field = Kit.inputField(content, 70, 6, 520, 26, 40, false)
    pcall(function() field.content = "LOGS" end)
    Kit.iconButton(content, "SEARCH", 610, 6, function() ItemProbe.search(field.content) end,
        "Search items by name", "Search", 80)
    Kit.iconButton(content, "EYE", 660, 6, showTyped, "Show the item typed (config name or id)", "Show", 70)
    geButton(710, 4, function()
        local ok, err = pcall(ItemProbe.readGrandExchange)
        if not ok then
            setStatus("Grand Exchange read failed: " .. tostring(err))
            say("GE failed", tostring(err))
        end
    end)
    statusText = Kit.text(content, 10, 42, WIDTH - 20, 26,
        "Search by name, show by config name or id, or read your Grand Exchange offers.", GREY, ui.AlignMode.TOPLEFT)

    -- Pager under the list.
    Kit.iconButton(content, "ARROW_LEFT", 10, PAGER_Y, function() changePage(-1) end, "Previous page", "<", 40)
    Kit.iconButton(content, "ARROW_RIGHT", 50, PAGER_Y, function() changePage(1) end, "Next page", ">", 40)
    pageText = Kit.text(content, 96, PAGER_Y, 400, 26, "", GREY, ui.AlignMode.TOPLEFT)

    Kit.smallButton(content, "Zoom -", RIGHT_X + RIGHT_W - 170, HEIGHT - 36, 80, 28, function() zoom(1.25) end)
    Kit.smallButton(content, "Zoom +", RIGHT_X + RIGHT_W - 84, HEIGHT - 36, 80, 28, function() zoom(0.8) end)
    renderPage()
end

function ItemProbe.hide()
    search = nil
    destroyAll(rowParts)
    destroyAll(previewParts)
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, field, statusText, pageText, shownId = nil, nil, nil, nil, nil, nil
    results, page = {}, 1
end

function ItemProbe.toggle()
    if window ~= nil then
        ItemProbe.hide()
    else
        ItemProbe.show()
    end
end

return ItemProbe
