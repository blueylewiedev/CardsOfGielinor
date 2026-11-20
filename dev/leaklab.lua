-- dev/leaklab.lua
-- A controlled experiment for the memory leak (see notes/memory_monitoring.md): the client's memory grows about 600 MB for each
-- round of 10 packs and does not come back when the reveal closes. This makes a screenful of cards in different ways and
-- frees them in different ways, so dev/memwatch.ps1 shows which part keeps its memory. Nothing here runs unless the Dev tools
-- buttons are pressed (and this folder is not in the release).
--
-- The Dev tools buttons:
--   Lab mode   cycles through the experiments below and logs which one is selected
--   Lab make   makes 20 cards in the way the selected experiment says (each press uses the next 20 cards, so repeated
--              rounds meet new models, as a pack opening does)
--   Lab free   frees them the way the experiment says
--
-- Use it with memwatch: press m in memwatch after "Lab make" (once the cards are on screen), and again a few seconds after
-- "Lab free". Do three make / free cycles of one experiment, and read the marker table: a step that is near zero after
-- the first cycle is memory the client reuses; a step that repeats every cycle is memory that is never given back.

local Cards = require("core/cards")
local CardView = require("ui/cardview")
local CardArt = require("ui/cardart")
local memLoaded, MemProbe = pcall(require, "dev/memprobe")

-- A line to the console and to the Output window (through the memory probe's helper, if it loaded).
local function say(text)
    if memLoaded and MemProbe.say ~= nil then
        MemProbe.say("LAB", text)
    else
        log(text)
    end
end

local Lab = {}

local COUNT = 20
local COLUMNS = 5
local SCALE = 0.6

-- name, what it builds, how it frees
local MODES = {
    { id = "cards", what = "full cards (frame, text, model, camera), as the pack opening builds them",
        free = "the card's root layer destroyed, as the reveal does" },
    { id = "cards_explicit", what = "full cards, as above",
        free = "the camera deleted, then the model, the model group and the root destroyed, one by one" },
    { id = "cards_same", what = "the SAME card 20 times (one model asset)",
        free = "the root layer destroyed. If memory does not grow here after the first cycle, the client caches by model" },
    { id = "model_only", what = "a model group with a model, no camera set",
        free = "the group destroyed" },
    { id = "model_camera", what = "a model group with a model and the card camera",
        free = "the group destroyed (the camera is not deleted first)" },
    { id = "frames", what = "locked cards: frame and text, no model at all",
        free = "the root layer destroyed. Growth here means the frames, text or images leak, not the models" },
    -- (added after the first results: the reveal leaks about twice as much a card as the first mode did, so what is different?)
    { id = "cards_foil", what = "full cards, every one a FOIL (the shine sprites)", finish = "foil",
        free = "the root layer destroyed" },
    { id = "cards_holo", what = "full cards, every one a HOLO (the rainbow canvas of triangles)", finish = "holo",
        free = "the root layer destroyed" },
    { id = "cards_big", what = "full cards at the reveal's size (scale 1.2, 8 across) instead of 0.6", scale = 1.2, columns = 8,
        free = "the root layer destroyed. If this leaks much more a card than the small ones, it is the picture buffers" },
    { id = "pool", what = "REUSED models: the first make builds 20 model groups, every later make only gives them a new model (SetModel)",
        pool = true,
        free = "nothing destroyed, the holder is only hidden. If memory stays flat from cycle 2 on, reusing components fixes the growth" },
    -- (the reveal puts click handlers on its cards, and the client may keep a handler's closure after the component is destroyed)
    { id = "cards_hooked", what = "full cards, each with a click handler whose closure holds the card's record (as the reveal's back-of-card handler does)",
        hook = true,
        free = "the root layer destroyed, nothing cleared. If the lines say the cards are STILL referenced, the client keeps the closure" },
    { id = "cards_hooked_fixed", what = "the same, but the card's record is emptied (record.view = nil) before the card is destroyed",
        hook = true, clear = true,
        free = "the record emptied, then the root layer destroyed. If this one reports 0 still referenced, emptying the record is the fix" },
}

local modeIndex = 1
local offset = 0                   -- how far into the list of cards the next make starts
local holder = nil                 -- the layer the cards are in
local made = {}                    -- what was made: { root, view, group, model, mode }
local pool = nil                   -- the pool experiment's holder and its 20 groups, kept between makes: { holder, items }

-- Weak references to what was made. After Lab free the strong ones are dropped and one full collection is run; whatever is still
-- here then is still referenced from somewhere, so Lua could not collect it (see Lab.free). If nothing is left and the client's
-- memory has not fallen either, the client is keeping the native memory itself.
local function weakSet() return setmetatable({}, { __mode = "v" }) end
local weak = { roots = weakSet(), models = weakSet(), groups = weakSet(), total = 0 }

local function remember(kind, object)
    if object ~= nil then
        weak[kind][#weak[kind] + 1] = object
    end
end

local function survivors(set)
    local n = 0
    for _ in pairs(set) do n = n + 1 end
    return n
end

local function parent()
    return ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
end

-- The next `COUNT` cards that have a model to show (NPCs, or items for the item experiments), starting after the last make.
local function pick(wantNpc)
    local list = {}
    for _, card in ipairs(Cards.list) do
        local isNpc = Cards.kindOf(card) == "npc"
        if card.art ~= nil and ((wantNpc and isNpc and card.art.npc ~= nil and card.art.npc ~= "")
            or (not wantNpc and not isNpc and card.art.item ~= nil and card.art.item ~= "")) then
            list[#list + 1] = card
        end
    end
    local chosen = {}
    for i = 1, COUNT do
        chosen[i] = list[(offset + i - 1) % #list + 1]
    end
    return chosen
end

local function place(piece, index, w, h, columns)
    columns = columns or COLUMNS
    local column, row = (index - 1) % columns, (index - 1) // columns
    piece:SetPos(20 + column * (w + 8), 60 + row * (h + 8))
end

function Lab.mode()
    modeIndex = modeIndex % #MODES + 1
    local m = MODES[modeIndex]
    say(string.format("LAB mode %d of %d, %s: makes %s; frees with %s", modeIndex, #MODES, m.id, m.what, m.free))
end

-- The pool experiment: the first make builds 20 model groups, later ones only point them at the next 20 models.
local function makePool(cards)
    if pool == nil then
        local holderLayer = ui.Layer.new(parent())
        holderLayer:SetPos(0, 0)
        holderLayer:SetSize(0, 0, 1.0, 1.0)
        holderLayer.clickthrough = true
        pool = { holder = holderLayer, items = {} }
        for i = 1, COUNT do
            local group = ui.ModelGroup.new(holderLayer)
            group:SetSize(96, 134)
            place(group, i, 96, 134)
            local model = ui.Model.new(group)
            model:SetSize(96, 134)
            local state = { group = group, kind = nil, yaw = 0, pitch = 0.1, dist = 500, fov = 40, ty = 0, tx = 0, near = 0 }
            pool.items[i] = { group = group, model = model }
            pcall(function() CardArt.applyCamera(state) end)
        end
        say("LAB: built the pool of " .. COUNT .. " model groups (this is the only time it makes any)")
    end
    pool.holder.hidden = false
    local failed = 0
    for i, card in ipairs(cards) do
        local ok = pcall(function()
            pool.items[i].model:SetModel(ui.ModelType.NPC_HEAD, id.NPC[card.art.npc])
        end)
        if not ok then failed = failed + 1 end
    end
    say(string.format("LAB: pointed the pool at cards %d to %d of the list%s. Press m in memwatch now.", offset + 1,
        offset + COUNT, failed > 0 and (", " .. failed .. " failed") or ""))
    offset = offset + COUNT
end

function Lab.make()
    local mode = MODES[modeIndex]
    if mode.pool then
        makePool(pick(true))
        return
    end
    if #made > 0 then
        say("LAB: free the cards first (Lab free)")
        return
    end
    holder = ui.Layer.new(parent())
    holder:SetPos(0, 0)
    holder:SetSize(0, 0, 1.0, 1.0)
    holder.clickthrough = true
    local cards = pick(true)
    if mode.id == "cards_same" then
        for i = 1, COUNT do cards[i] = pick(true)[1] end
    end
    local failed = 0
    for i, card in ipairs(cards) do
        local ok, err = pcall(function()
            if mode.id == "model_only" or mode.id == "model_camera" then
                local npc = id.NPC[card.art.npc]
                local group = ui.ModelGroup.new(holder)
                group:SetSize(96, 134)
                place(group, i, 96, 134)
                local model = ui.Model.new(group)
                model:SetSize(96, 134)
                model:SetModel(ui.ModelType.NPC_HEAD, npc)
                local state = nil
                if mode.id == "model_camera" then
                    state = { group = group, kind = nil, yaw = 0, pitch = 0.1, dist = 500, fov = 40, ty = 0, tx = 0, near = 0 }
                    CardArt.applyCamera(state)
                end
                made[#made + 1] = { group = group, model = model, cam = state }
                remember("groups", group)
                remember("models", model)
            else
                local locked = mode.id == "frames"
                local scale = mode.scale or SCALE
                local view = CardView.create(holder, card, { animated = true, scale = scale, locked = locked,
                    finish = mode.finish })
                local w, h = 160 * scale, 224 * scale
                place(view.root, i, w, h, mode.columns)
                made[#made + 1] = { view = view }
                if mode.hook then
                    local record = { view = view }
                    view.root:Subscribe(ui.Hook.ONCLICK, function() return record end)       -- the closure holds the record
                    made[#made].record = record
                end
                remember("roots", view.root)
                remember("models", view.model)
                remember("groups", view.cam ~= nil and view.cam.group or nil)
            end
        end)
        if not ok then
            failed = failed + 1
            if failed <= 3 then
                say("LAB: a card could not be made:", tostring(err))
            end
        end
    end
    say(string.format("LAB: made %d (%s), cards %d to %d of the list%s. Press m in memwatch now.", #made, mode.id, offset + 1,
        offset + COUNT, failed > 0 and (", " .. failed .. " failed") or ""))
    if mode.id ~= "cards_same" then
        offset = offset + COUNT
    end
end

function Lab.free()
    local mode = MODES[modeIndex]
    if mode.pool then
        if pool ~= nil then
            pool.holder.hidden = true
            say("LAB: hid the pool (nothing destroyed). Wait a few seconds, then press m in memwatch.")
        else
            say("LAB: nothing to free")
        end
        return
    end
    if #made == 0 and holder == nil then
        say("LAB: nothing to free")
        return
    end
    for _, item in ipairs(made) do
        pcall(function()
            if mode.id == "cards_explicit" and item.view ~= nil then
                local view = item.view
                if view.cam ~= nil and view.cam.group ~= nil then
                    if view.cam.cameraIndex ~= nil then
                        view.cam.group:DeleteCamera(view.cam.cameraIndex)
                    end
                    if view.model ~= nil then
                        view.model:Destroy()
                    end
                    view.cam.group:Destroy()
                end
                view.root:Destroy()
            elseif item.view ~= nil then
                if mode.clear and item.record ~= nil then
                    item.record.view = nil                    -- the fix being tried: the closure no longer reaches the card
                end
                item.view.root:Destroy()
            elseif item.group ~= nil then
                item.group:Destroy()
            end
        end)
    end
    local count = #made
    made = {}
    if holder ~= nil then
        pcall(function() holder:Destroy() end)
        holder = nil
    end
    -- One full collection with no strong references left: what survives is still referenced from Lua.
    local before = collectgarbage("count")
    collectgarbage("collect")
    local after = collectgarbage("count")
    say(string.format("LAB: freed %d (%s). After one full collection (Lua heap %.0f to %.0f KB) these are STILL referenced: %d roots, "
        .. "%d models, %d groups. Wait a few seconds, then press m in memwatch.", count, mode.id, before, after,
        survivors(weak.roots), survivors(weak.models), survivors(weak.groups)))
    weak = { roots = weakSet(), models = weakSet(), groups = weakSet() }
end

return Lab
