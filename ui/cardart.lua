-- ui/cardart.lua
-- The picture on a card: the NPC or item in a model group drawn through a camera (its `art.cam`), the silhouette shadow of a card the player does not
-- have, and playing an animation. ui/cardview.lua puts it in the frame.

local Cards = require("core/cards")
local Logger = require("core/logger")

local CardArt = {}

-- A silhouette (opts.silhouette, the Sets window) is a card the player does not have, drawn as the shadow its model
-- casts: the card's camera is moved to the sun, a large flat model stands behind the figure as a screen, and the
-- figure itself is clipped away, leaving its grey outline on the screen (shadowLook). A model in a ModelGroup cannot
-- be darkened, which is why it is done with shadows.
local SHADOW = {
    sunYaw = -0.75, sunPitch = 0.10,   -- where the camera looks from (the default sun is about (-0.7, 0.14, -0.7))
    size = 1.45,                       -- how big the shadow is drawn, against the figure on its own card
    itemSize = 0.70,                   -- items' shadows, on top of `size`
    itemTurn = { -0.40, -0.70, 0.70 }, -- an item's yaw, pitch and roll (radians): stood up, facing the sun
    screenModel = 124827,              -- raw model FAI_VARROCK_SINGLE_BED
    screenScale = 5.5,
    screenDist = 800,                  -- how far behind the figure the screen stands (world units, full-body card)
    screenCount = 3,                   -- copies side by side, so a wide shadow stays on the screen
    clipBefore = 100,                  -- the near clip plane, this far in front of the screen
}

-- The picture is drawn through a camera: the NPC goes in a ui.ModelGroup, which has a real camera. A card's `art.cam`
-- can hold yaw and pitch (radians, 0 is straight on), dist (smaller is closer), fov (degrees), ty (height looked at),
-- tx (left/right) and near (where the camera starts drawing, as a share of dist). Anything left out uses these
-- defaults: the body model, the head (`art.body = false`) and items each have their own, and an item looks down on
-- its model (pitch 1.5) since items lie flat.
CardArt.CAMERA_FIELDS = { "yaw", "pitch", "dist", "fov", "ty", "tx", "near" }
CardArt.CAMERA_DEFAULTS = {
    head = { yaw = 0.0, pitch = 0.0, dist = 2040, fov = 55, ty = 0, tx = 0, near = 0 },
    body = { yaw = 0.0, pitch = 0.0, dist = 1500, fov = 50, ty = 0, tx = 0, near = 0 },
    item = { yaw = 0.0, pitch = 1.5, dist = 300, fov = 50, ty = 0, tx = 0, near = 0 },
}

-- The camera defaults for a camera state or art table: { kind = "item" } for an item card,
-- otherwise the body model if `body` is true and the head if not.
function CardArt.defaultsFor(state)
    if state ~= nil and state.kind == "item" then
        return CardArt.CAMERA_DEFAULTS.item
    end
    return CardArt.CAMERA_DEFAULTS[(state ~= nil and state.body) and "body" or "head"]
end

-- Makes a camera object. The docs call the type ui.ModelCamera, but the client calls it
-- ui.ModelCameraInfo, so try both.
local function newCamera()
    local kind = ui.ModelCamera or ui.ModelCameraInfo
    if kind == nil then
        error("the client has neither ui.ModelCamera nor ui.ModelCameraInfo")
    end
    return kind.new()
end

-- Moves the camera to match cam.yaw / pitch / dist / fov / ty / tx. A camera the group hands
-- back is only a copy, so instead of editing it a fresh camera is added, switched to, and the
-- old one deleted.
local ITEM_MAX_PITCH = 1.55      -- just short of straight down (1.5708); past it the picture flips over

local function applyCamera(cam)
    local camera = newCamera()
    camera:SetFOV(cam.fov, 0)
    -- The camera orbits the look-at point. tx slides that point sideways (along the camera's
    -- right-hand direction) and the camera moves with it, so the NPC shifts across the card
    -- without changing angle or size.
    local sinYaw, cosYaw = math.sin(cam.yaw), math.cos(cam.yaw)
    local targetX, targetY, targetZ
    if cam.kind == "item" then
        -- An item is seen from nearly straight above, so tx and ty move the look-at point along the camera's own
        -- right and up directions, and the pitch is stopped short of straight down, which flips the picture.
        cam.pitch = math.max(-ITEM_MAX_PITCH, math.min(ITEM_MAX_PITCH, cam.pitch))
        local sinPitch, cosPitch = math.sin(cam.pitch), math.cos(cam.pitch)
        targetX = cam.tx * cosYaw - cam.ty * sinYaw * sinPitch
        targetY = cam.ty * cosPitch
        targetZ = cam.tx * sinYaw + cam.ty * cosYaw * sinPitch
    else
        targetX = cam.tx * cosYaw
        targetY = cam.ty
        targetZ = cam.tx * sinYaw
    end
    local x = targetX + cam.dist * sinYaw * math.cos(cam.pitch)
    local y = targetY + cam.dist * math.sin(cam.pitch)
    local z = targetZ - cam.dist * cosYaw * math.cos(cam.pitch)
    camera:SetPosition(Vector3.new(x, y, z), 0)
    camera:SetLookAt(Vector3.new(targetX, targetY, targetZ), 0)
    camera:SetClipPlanes(math.max(1, cam.dist * (cam.near or 0)), cam.dist * 20)
    camera.clearColour = Vector4.new(0, 0, 0, 0)      -- see-through, so the card backdrop shows
    camera.useLookAt = true
    local old = cam.cameraIndex
    cam.cameraIndex = cam.group:AddCamera(camera)
    cam.group:SwitchCamera(cam.cameraIndex, ui.ModelCameraTransition.NONE, -1, 0)
    if old ~= nil then
        cam.group:DeleteCamera(old)
    end
end

CardArt.applyCamera = applyCamera

-- Calls to make again on the next tick (the Sets window calls CardArt.applyPending every tick, and
-- CardArt.clearPending when it destroys its cards): a SetTransform sent before the model has loaded may be lost.
local pendingCalls = {}

function CardArt.applyPending()
    local calls = pendingCalls
    pendingCalls = {}
    for _, call in ipairs(calls) do
        pcall(call)
    end
end

function CardArt.clearPending()
    pendingCalls = {}
end

-- SetTransform now and again on the next tick.
local function transform(model, place, turn, scale)
    local function call()
        model:SetTransform(place, turn, Vector3.new(scale, scale, scale), 0)
    end
    call()
    pendingCalls[#pendingCalls + 1] = call
end

-- Turns the card's ModelGroup into a shadow silhouette (see SHADOW), changing the camera in `state` into the shadow
-- camera. Everything grows with `view`, how much of the world the card's camera sees against the full-body card's
-- (dist 859, fov 50), so the screen sits the same on every card.
local function shadowLook(group, child, state, box)
    local isItem = state.kind == "item"
    local cardYaw = state.yaw
    local view = (state.dist * math.tan(math.rad(state.fov) / 2)) / (859 * math.tan(math.rad(50) / 2))
    local screen = state.dist + SHADOW.screenDist * view

    -- The camera, at the sun. An item card's camera looks down on an item lying flat, so the item is stood up and
    -- looked at like an NPC. The shadow is further off than the figure, so the field of view is narrowed by that ratio.
    state.kind = nil
    state.yaw, state.pitch = SHADOW.sunYaw, SHADOW.sunPitch
    state.near = math.max(1, screen - SHADOW.clipBefore * view) / state.dist
    local size = SHADOW.size * (isItem and SHADOW.itemSize or 1)
    state.fov = math.deg(2 * math.atan(math.tan(math.rad(state.fov) / 2) * state.dist / screen / size))
    applyCamera(state)

    -- The figure, turned so its shadow shows the side its card does (an item card's own turn is left out: a turned
    -- item card shows its item flipped, which keeps its shape).
    local zero = Vector3.new(0.0, 0.0, 0.0)
    if isItem then
        local t = SHADOW.itemTurn
        transform(child, zero, Vector3.new(t[1], t[2], t[3]), 1.0)
    else
        transform(child, zero, Vector3.new(cardYaw - state.yaw, 0.0, 0.0), 1.0)
    end

    -- The screen: copies of the bed, side by side behind the figure across the camera's line of sight, facing it.
    local cosYaw, sinYaw = math.cos(state.yaw), math.sin(state.yaw)
    local tx, ty = state.tx or 0, state.ty or 0
    local quarter = math.pi / 2
    local turn = Vector3.new(quarter - state.yaw, quarter, quarter)
    local forward = SHADOW.screenDist * view
    for i = 1, SHADOW.screenCount do
        local right = (i - (SHADOW.screenCount + 1) / 2) * 512 * SHADOW.screenScale * view
        local wall = ui.Model.new(group)
        wall:SetSize(box.w, box.h)
        wall:SetModel(ui.ModelType.MODEL, SHADOW.screenModel)
        state.screens[#state.screens + 1] = wall
        local place = Vector3.new((tx + right) * cosYaw - forward * sinYaw, ty, (tx + right) * sinYaw + forward * cosYaw)
        transform(wall, place, turn, SHADOW.screenScale * view)
    end
end

-- Plays animation `animId` on a model, or stops its animation if `animId` is nil. Many models
-- do not move until they are given one. Animation ids are the client's sequence ids; the
-- preview's Anim buttons are for finding good ones. Returns true if the client accepted it.
function CardArt.playAnimation(model, animId)
    local ok, err = pcall(function()
        model.animID = animId or -1
        -- Starts the animation from its first frame. The argument is the logic tick; 0 is a
        -- guess, so a failure here only means the animation may not restart.
        model:RestartAnimation(0)
    end)
    if not ok then
        Logger.error("card animation failed:", tostring(err))
    end
    return ok
end

-- Shows the icon of an item (its inventory picture) in the art box. Used when the item's model
-- cannot be shown. Returns the sprite, or nil.
local function addItemIcon(parent, objId, box)
    local ok, sprite = pcall(function()
        local icon = ui.Sprite.new(parent)
        local size = math.min(box.w, box.h)
        icon:SetSize(size, size)
        icon:SetPos(box.x + (box.w - size) // 2, box.y + (box.h - size) // 2)
        icon.associatedObjectID = objId
        icon.associatedObjectQuantity = 1
        return icon
    end)
    if ok then
        return sprite
    end
    Logger.error("card art: item icon failed for", objId, tostring(sprite))
    return nil
end

-- Shows the card's NPC (or item) inside the art box { x, y, w, h }. Returns the model and the `cam` table (which
-- applyCamera can re-apply), or nil. If the camera cannot be set up a plain model is shown (no `cam`); an item whose
-- model will not load shows its icon.
function CardArt.add(parent, card, box, dark)
    local art = Cards.getArt(card)
    local isItem = Cards.kindOf(card) == "item"
    local body = art.body
    local modelId, modelType
    if isItem then
        local ok, objId = pcall(function() return id.Obj[art.item] end)
        if not ok or not Cards.isValidObjId(objId) then
            Logger.error("card art: item not found for", card.id, tostring(art.item), "->", tostring(objId))
            return nil
        end
        modelId, modelType = objId, ui.ModelType.OBJECT
    elseif art.model ~= nil then
        -- (a raw model the card names: scenery the NPC is shown as, see core/cards.lua)
        modelId, modelType, body = art.model, ui.ModelType.MODEL, true
    else
        local ok, npcID = pcall(function() return id.NPC[art.npc] end)
        if not ok or not Cards.isValidNpcId(npcID) then
            Logger.error("card art: NPC not found for", card.id, art.npc, "->", tostring(npcID))
            return nil
        end
        modelId, modelType = npcID, ui.ModelType[body and "NPC_MODEL" or "NPC_HEAD"]
    end

    local group = nil
    local built, model, cam = pcall(function()
        group = ui.ModelGroup.new(parent)
        group:SetPos(box.x, box.y)
        group:SetSize(box.w, box.h)
        local child = ui.Model.new(group)
        child:SetSize(box.w, box.h)
        child:SetModel(modelType, modelId)

        -- (screens: a silhouette's extra models)
        local state = { group = group, body = body == true, anim = art.anim, kind = isItem and "item" or nil,
            screens = {} }
        if art.anim ~= nil and not isItem then
            CardArt.playAnimation(child, art.anim)
        end
        local defaults = CardArt.defaultsFor(state)
        -- The card's own camera values belong to its own model type, so they are ignored when
        -- the preview has switched to the other one. (An item has only one model type.)
        local own = (isItem or (body == true) == (art.body == true)) and art.cam or {}
        for _, field in ipairs(CardArt.CAMERA_FIELDS) do
            state[field] = own[field] or defaults[field]
        end
        if dark then
            shadowLook(group, child, state, box)
        else
            applyCamera(state)
        end
        return child, state
    end)
    if built then
        return model, cam
    end
    if dark then
        -- (the half-made group may show the real figure, and a plain model would give the card away: the "?" shows)
        Logger.error("card art: silhouette failed for", card.id, tostring(model))
        if group ~= nil then
            pcall(function() group:Destroy() end)
        end
        return nil
    end
    Logger.error("card art: camera failed for", card.id, "- showing a plain model:", tostring(model))

    local plain = ui.Model.new(parent)
    plain:SetPos(box.x, box.y)
    plain:SetSize(box.w, box.h)
    local shown, err = pcall(function() plain:SetModel(modelType, modelId) end)
    if not shown then
        Logger.error("card art: SetModel failed for", card.id, err)
        plain:Destroy()
        if isItem then
            return addItemIcon(parent, modelId, box)
        end
        return nil
    end
    plain.modelWidth = box.w
    plain.modelHeight = box.h
    plain.viewDistance = isItem and 300 or (body and 1500 or 1000)
    return plain
end

return CardArt
