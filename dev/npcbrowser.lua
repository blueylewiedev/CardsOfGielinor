-- npcbrowser.lua
-- Debug window for finding out which NPCs have a usable chathead. It shows one NPC id at a
-- time with its head model on the left and its body model on the right. Step through ids
-- with the buttons, and the id, config name and display name are logged for each one.
--
--   -1 / +1, -10 / +10, -100 / +100, -1000 / +1000 : change the id
--   Has head / No head : logs a "mark" line for the NPC on screen, so a list of the NPCs
--                        to switch to body art (art = { head = { body = true } }) builds up
--                        in the log
--   Probe              : logs every member name it can find on the NPC's config and on the
--                        head model, looking for anything that tells a real head from a
--                        missing one (the id read back from the model does not)
-- Only created when DEBUG is on in main.lua, and opened from the Home window.

local OutputWindow = require("dev/outputwindow")

local NpcBrowser = {}

local window = nil
local jump = nil     -- set while the window is open: jump(id) shows that NPC id

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR
local BOX_W, BOX_H = 110, 150

-- Looks up an NPC's config name and display name. Returns "?" for anything unreadable.
-- Logs the member names of a userdata object, as far as the client lets us list them.
-- Tries pairs() on the object, then on its metatable's __index table.
local function listMembers(label, object)
    local names = {}
    local function collect(source)
        local ok = pcall(function()
            for key in pairs(source) do
                names[#names + 1] = tostring(key)
            end
        end)
        return ok
    end
    local meta = getmetatable(object)
    local used = "object"
    if not collect(object) or #names == 0 then
        used = "metatable"
        if type(meta) == "table" then
            collect(meta)
            if type(meta.__index) == "table" then
                used = "metatable.__index"
                collect(meta.__index)
            end
        end
    end
    table.sort(names)
    log("npcbrowser probe:", label, "-", #names, "names (from " .. used .. "):", table.concat(names, ", "))
end

local function describe(npcId)
    local ok, cfg = pcall(function() return config.NPC.FromID(npcId) end)
    if not ok or cfg == nil then
        return "?", "?"
    end
    local nameOk, name = pcall(function() return cfg.name end)
    local cfgOk, configName = pcall(function() return cfg.configName end)
    return cfgOk and tostring(configName) or "?", nameOk and tostring(name) or "?"
end

function NpcBrowser.show()
    if window ~= nil then
        return
    end

    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window = ui.GroupBox.new(gameWindow)
    window.stylesheetID = id.StyleSheet.DEFAULT
    window:SetHeaderLayout(0, 0, 0, 0, 0)
    window:SetSize(250, 410)
    window:SetPos(0, 0, 0.72, 0.15)

    local npcId = 1
    local parts = {}      -- components that are rebuilt on every change
    local title = nil
    local shownConfigName = "?"

    local function text(x, y, w, h, content)
        local t = ui.Text.new(window)
        t:SetPos(x, y)
        t:SetSize(w, h)
        t.font = FONT
        t.content = content
        t.colour = Vector4.new(1, 1, 1, 1)
        t.isShadowed = true
        t:AlignTo(ui.AlignMode.CENTRE, ui.AlignMode.CENTRE)
        return t
    end

    -- One model on a dark backdrop. `modelType` is "NPC_HEAD" or "NPC_MODEL".
    local function modelBox(x, modelType, viewDistance)
        local back = ui.Rectangle.new(window)
        back:SetPos(x, 60)
        back:SetSize(BOX_W, BOX_H)
        back.fill = true
        back.colour = Vector4.new(0.16, 0.16, 0.20, 1.0)
        parts[#parts + 1] = back

        local model = ui.Model.new(window)
        model:SetPos(x, 60)
        model:SetSize(BOX_W, BOX_H)
        local ok, err = pcall(function() model:SetModel(ui.ModelType[modelType], npcId) end)
        if not ok then
            log("npcbrowser: SetModel failed for", npcId, modelType, tostring(err))
            model:Destroy()
            return nil
        end
        model.modelWidth = BOX_W
        model.modelHeight = BOX_H
        model.viewDistance = viewDistance
        parts[#parts + 1] = model
        return model
    end

    local function refresh()
        for _, part in ipairs(parts) do
            pcall(function() part:Destroy() end)
        end
        parts = {}

        local configName, name = describe(npcId)
        shownConfigName = configName
        title.content = npcId .. "  " .. configName .. "  (" .. name .. ")"

        local head = modelBox(10, "NPC_HEAD", 1000)
        local body = modelBox(130, "NPC_MODEL", 1500)
        local function read(model)
            if model == nil then return "none" end
            local ok, value = pcall(function() return model.modelID1 end)
            return ok and tostring(value) or "unreadable"
        end
        log("npcbrowser:", npcId, configName, name, "| head modelID1", read(head), "| body modelID1", read(body))
    end

    title = text(5, 5, 240, 22, "")
    text(10, 30, BOX_W, 22, "Head")
    text(130, 30, BOX_W, 22, "Body")

    local function button(label, x, y, w, onPress)
        local b = ui.Button.new(window)
        b:SetPos(x, y)
        b:SetSize(w, 30)
        b.label = label
        b.stylesheetID = id.StyleSheet.BUTTON_DEFAULT
        b:Subscribe(ui.Hook.ONBUTTONPRESSED, onPress)
    end

    local function step(delta)
        npcId = math.max(0, npcId + delta)
        refresh()
    end

    local steps = { -1000, -100, -10, -1, 1, 10, 100, 1000 }
    for i, delta in ipairs(steps) do
        local row = (i <= 4) and 0 or 1
        local col = (i - 1) % 4
        local label = (delta > 0 and "+" or "") .. delta
        button(label, 5 + col * 61, 218 + row * 36, 57, function() step(delta) end)
    end
    button("Probe", 10, 331, 230, function()
        local ok, cfg = pcall(function() return config.NPC.FromID(npcId) end)
        if ok and cfg ~= nil then
            listMembers("config.NPC " .. npcId, cfg)
        else
            log("npcbrowser probe: no config for", npcId)
        end
        local probeModel = ui.Model.new(window)
        pcall(function() probeModel:SetModel(ui.ModelType.NPC_HEAD, npcId) end)
        listMembers("ui.Model (NPC_HEAD)", probeModel)
        pcall(function() probeModel:Destroy() end)

        -- Named models: look in id.Model for models with HEAD in the name that mention this NPC.
        local configName, name = describe(npcId)
        local wanted = string.upper(configName)
        local okModels, err = pcall(function()
            -- Like id.NPC, the numbers may be the keys and the names the values, so look at both.
            local total, hits = 0, 0
            for key, value in pairs(id.Model) do
                total = total + 1
                local text = string.upper(tostring(key) .. " " .. tostring(value))
                if string.find(text, wanted, 1, true) and string.find(text, "HEAD", 1, true) then
                    hits = hits + 1
                    if hits <= 25 then
                        log("npcbrowser probe: id.Model", tostring(key), "=", tostring(value))
                    end
                end
            end
            log("npcbrowser probe: id.Model has", total, "entries,", hits, "mention", wanted, "and HEAD")
        end)
        if not okModels then
            log("npcbrowser probe: cannot list id.Model:", tostring(err))
        end
    end)
    button("Has head", 10, 295, 110, function()
        log("npcbrowser: mark", npcId, shownConfigName, "head = yes")
        OutputWindow.add(shownConfigName, npcId .. " " .. shownConfigName .. " head = yes")
    end)
    button("No head", 130, 295, 110, function()
        log("npcbrowser: mark", npcId, shownConfigName, "head = NO")
        OutputWindow.add(shownConfigName, npcId .. " " .. shownConfigName .. " head = NO")
    end)

    jump = function(newId)
        npcId = newId
        refresh()
    end
    refresh()
end

-- Opens the window (if it is closed) and shows this NPC id.
function NpcBrowser.showId(newId)
    if window == nil then
        NpcBrowser.show()
    end
    if jump ~= nil then
        jump(newId)
    end
end

function NpcBrowser.isOpen()
    return window ~= nil
end

function NpcBrowser.toggle()
    if window ~= nil then
        NpcBrowser.hide()
    else
        NpcBrowser.show()
    end
end

function NpcBrowser.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
        window = nil
        jump = nil
    end
end

return NpcBrowser
