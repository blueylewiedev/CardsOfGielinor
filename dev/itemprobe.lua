-- itemprobe.lua
-- Developer-only, throwaway: finds out how the client can show an item (an "Obj" in the API) on
-- a card. Type an item's config name (for example LOGS or STEEL_BAR) and press Probe. It
--   1. lists the members of ui.ModelType, ui.Model, ui.Sprite and config.Obj,
--   2. shows the item's inventory icon with a Sprite (SetAssociatedObject),
--   3. tries every ModelType that might be an item model, and shows each one it could load.
-- Everything it learns goes to the log and to the Output window, where lines can be copied.
-- Once the answer is known, this file can be deleted.

local Kit = require("ui/kit")
local OutputWindow = require("dev/outputwindow")

local ItemProbe = {}

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.7, 0.7, 0.7, 1)

local WIN_W, WIN_H = 640, 420
local BOX = 110

local window, content = nil, nil
local nameField = nil
local parts = {}            -- components made by the last probe, destroyed by the next one

-- Names that an item model type might have. Tried one by one, because the enum may not be listable.
local GUESSES = {
    "OBJECT", "OBJ", "OBJ_MODEL", "OBJ_HEAD", "OBJECT", "OBJECT_MODEL", "ITEM", "ITEM_MODEL", "INV", "INV_OBJ",
    "LOC", "LOC_MODEL", "OBJ_MALE", "OBJ_FEMALE", "OBJ_WORN", "WORN", "PLAYER_MODEL", "PLAYER_HEAD",
    "NPC_MODEL", "NPC_HEAD",
}

local function say(label, text)
    log("itemprobe:", label, text)
    OutputWindow.add("itemprobe", label .. " " .. text)
end

-- The member names of a userdata or table, as far as the client lets us list them.
local function members(object)
    local names = {}
    local function collect(source)
        pcall(function()
            for key, value in pairs(source) do
                names[#names + 1] = tostring(key) .. (type(value) ~= "function" and ("=" .. tostring(value)) or "()")
            end
        end)
    end
    collect(object)
    if #names == 0 then
        local meta = getmetatable(object)
        if type(meta) == "table" then
            collect(meta)
            if type(meta.__index) == "table" then
                collect(meta.__index)
            end
        end
    end
    table.sort(names)
    return names
end

local function listOf(label, object)
    if object == nil then
        say(label, "is nil")
        return
    end
    local names = members(object)
    say(label, #names .. " members: " .. table.concat(names, ", "))
end

local function clear()
    for _, part in ipairs(parts) do
        pcall(function() part:Destroy() end)
    end
    parts = {}
end

-- Finds the Obj for a config name. Returns its numeric id, or nil.
local function findObj(name)
    local ok, cfg = pcall(function() return config.Obj[name] end)
    if ok and cfg ~= nil then
        local idOk, value = pcall(function() return cfg.id end)
        if idOk and type(value) == "number" then
            say("config.Obj." .. name, "id " .. value .. ", display name " .. tostring(cfg.name))
            return value, cfg
        end
    end
    local ok2, value = pcall(function() return id.Obj[name] end)
    if ok2 and type(value) == "number" then
        say("id.Obj." .. name, "id " .. value)
        return value, nil
    end
    say("lookup", "no Obj named " .. name .. " (config.Obj: " .. tostring(cfg) .. ")")
    return nil, nil
end

local function probeIcon(objId)
    local ok, err = pcall(function()
        local sprite = ui.Sprite.new(content)
        parts[#parts + 1] = sprite
        sprite:SetPos(10, 90)
        sprite:SetSize(64, 64)
        -- The first probe showed the members are associatedObjectID, associatedObjectQuantity and
        -- associatedObjectQuantityMode (I had used the wrong name). Try the properties first.
        local function attempt(label, fn)
            local done, problem = pcall(fn)
            say("icon " .. label, done and "ok" or ("failed: " .. tostring(problem)))
            return done
        end
        attempt("property associatedObjectID", function() sprite.associatedObjectID = objId end)
        attempt("property associatedObjectQuantity", function() sprite.associatedObjectQuantity = 1 end)
        say("icon reads back", "id=" .. tostring(sprite.associatedObjectID) .. " quantity="
            .. tostring(sprite.associatedObjectQuantity) .. " mode=" .. tostring(sprite.associatedObjectQuantityMode)
            .. " spriteID=" .. tostring(sprite.spriteID))
        -- The method rejected (id, 1), so try other shapes: the config, the id alone, three arguments.
        attempt("SetAssociatedObject(id)", function() sprite:SetAssociatedObject(objId) end)
        attempt("SetAssociatedObject(config)", function() sprite:SetAssociatedObject(config.Obj.FromID(objId)) end)
        attempt("SetAssociatedObject(config, 1)", function() sprite:SetAssociatedObject(config.Obj.FromID(objId), 1) end)
        attempt("SetAssociatedObject(id, 1, 0)", function() sprite:SetAssociatedObject(objId, 1, 0) end)
        say("icon reads back after", "id=" .. tostring(sprite.associatedObjectID) .. " quantity="
            .. tostring(sprite.associatedObjectQuantity))
    end)
    if not ok then
        say("icon", "failed: " .. tostring(err))
    end
    parts[#parts + 1] = Kit.text(content, 10, 156, 120, 20, "Icon (Sprite)", GREY, ui.AlignMode.TOPLEFT)
end

-- Lists the model types by asking the enum for each number (it cannot be listed with pairs).
local function listModelTypes()
    local found = {}
    for number = 0, 60 do
        local ok, value = pcall(function() return ui.ModelType.FromID(number) end)
        if ok and value ~= nil then
            found[#found + 1] = number .. "=" .. tostring(value)
        end
    end
    say("ui.ModelType.FromID 0-60", #found .. " found: " .. table.concat(found, ", "))
end

local function tryModel(typeName, modelType, objId, slot)
    local x = 150 + (slot - 1) * (BOX + 10)
    local ok, err = pcall(function()
        local model = ui.Model.new(content)
        parts[#parts + 1] = model
        model:SetPos(x, 90)
        model:SetSize(BOX, BOX)
        model.modelWidth = BOX
        model.modelHeight = BOX
        model.viewDistance = 300
        model:SetModel(modelType, objId)
    end)
    say("SetModel " .. typeName, ok and "ok (a model box is shown)" or ("failed: " .. tostring(err)))
    parts[#parts + 1] = Kit.text(content, x, 90 + BOX + 2, BOX, 20, typeName, ok and WHITE or GREY, ui.AlignMode.TOPLEFT)
end

local function probe()
    clear()
    local name = nameField ~= nil and nameField.content or ""
    if type(name) ~= "string" or name == "" then
        name = "LOGS"
    end
    name = string.upper((string.gsub(name, "%s+", "_")))
    say("probe", "item " .. name)

    listOf("ui.ModelType", ui.ModelType)
    listModelTypes()
    listOf("ui.Model (class)", ui.Model)
    listOf("ui.Sprite (class)", ui.Sprite)
    local objId, cfg = findObj(name)
    if cfg ~= nil then
        listOf("config.Obj instance", cfg)
    end
    local total = 0
    pcall(function() for _ in pairs(id.Obj) do total = total + 1 end end)
    say("id.Obj", total .. " entries")
    if objId == nil then
        return
    end

    probeIcon(objId)

    -- Every ModelType, listed or guessed, once. Only the ones that look like items are drawn
    -- first; the rest are tried afterwards so a wrong guess cannot hide a right one.
    local seen, ordered = {}, {}
    local function add(typeName)
        if seen[typeName] then return end
        local ok, value = pcall(function() return ui.ModelType[typeName] end)
        if ok and value ~= nil then
            seen[typeName] = true
            ordered[#ordered + 1] = { name = typeName, value = value }
        end
    end
    pcall(function() for key in pairs(ui.ModelType) do add(tostring(key)) end end)
    for _, guess in ipairs(GUESSES) do add(guess) end
    local slot = 0
    for _, entry in ipairs(ordered) do
        local upper = string.upper(entry.name)
        if (string.find(upper, "OBJ", 1, true) or string.find(upper, "ITEM", 1, true)
            or string.find(upper, "INV", 1, true) or string.find(upper, "LOC", 1, true)) and slot < 4 then
            slot = slot + 1
            tryModel(entry.name, entry.value, objId, slot)
        end
    end
    if slot == 0 then
        say("ModelType", "no member name mentions OBJ, ITEM, INV or LOC (so no item model type)")
    end
end

function ItemProbe.show()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Item probe", WIN_W, WIN_H + Kit.titleBarHeight(),
        function() ItemProbe.hide() end, 0.5, 0.2)
    Kit.text(content, 10, 6, 200, 26, "Item config name:", WHITE, ui.AlignMode.TOPLEFT)
    nameField = Kit.inputField(content, 190, 6, 240, 26, 40, false)
    pcall(function() nameField.content = "LOGS" end)
    Kit.buttonAt(content, "Probe", 440, 4, 120, 30, function()
        local ok, err = pcall(probe)
        if not ok then
            say("probe", "crashed: " .. tostring(err))
        end
    end)
    Kit.text(content, 10, 44, WIN_W - 20, 40,
        "Shows the item's icon and any item model the client will load. Results also go to the Output window.",
        GREY, ui.AlignMode.TOPLEFT)
end

function ItemProbe.hide()
    clear()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, nameField = nil, nil, nil
end

function ItemProbe.toggle()
    if window ~= nil then
        ItemProbe.hide()
    else
        ItemProbe.show()
    end
end

return ItemProbe
