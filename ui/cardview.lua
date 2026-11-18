-- ui/cardview.lua
-- Draws a card from its data using live UI components (no image files needed).
--
-- Layout (all sizes in interface units), 160 x 224. With a frame image (the normal case):
--   frame image on top, its art window showing the NPC through a camera, and the name,
--   rarity and description drawn over the frame's panels. Without one (the image is missing)
--   a plain rectangle layout is used instead.

local Cards = require("core/cards")
local Logger = require("core/logger")

local CardView = {}

-- The nearest whole number (halves up). PackArt uses it too.
local function round(v)
    return math.floor(v + 0.5)
end
CardView.round = round

-- Card size. The layout below was measured on a 160 x 224 card; SCALE enlarges everything to
-- fit (frame zones, the plain layout, the card itself). Change SCALE to resize the cards.
CardView.SCALE = 1.25
local S = CardView.SCALE
CardView.WIDTH = math.floor(160 * S)
CardView.HEIGHT = math.floor(224 * S)

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR

-- A font in the client by its name, or nil if the client has none of that name.
local function fontNamed(name)
    local ok, value = pcall(function() return id.Font[name] end)
    if ok and value ~= nil then
        return value
    end
    return nil
end

-- The sizes of text a card's title steps down through when it is too long: the normal size first, then smaller ones.
-- `perLetter` is how much room (in card units) a letter takes at that size, on average, measured from cards in the
-- client (about 8.2, 7.0 and 6.2). The client cannot measure text, so how many letters fit is a guess from this. A size
-- the client does not have is left out.
local NAME_FONTS = {}
for _, size in ipairs({ { FONT, 8.2 }, { fontNamed("MUSEO_SANS_13PT_REGULAR"), 7.0 },
        { fontNamed("MUSEO_SANS_11PT_REGULAR"), 6.2 } }) do
    if size[1] ~= nil then
        NAME_FONTS[#NAME_FONTS + 1] = { font = size[1], perLetter = size[2] }
    end
end

-- The font for a name of `length` letters in a title `width` card units wide: the largest size it fits in, or the
-- smallest there is when it fits in none. `fonts` is a list of { font, perLetter } (default: the sizes above). Returns the
-- font, and whether the name fits in it.
function CardView.nameFont(length, width, fonts)
    fonts = fonts or NAME_FONTS
    for index, size in ipairs(fonts) do
        if length * size.perLetter <= width then
            return size.font, true
        end
        if index == #fonts then
            return size.font, false
        end
    end
    return FONT, true
end

-- What the card's face says at the top: its `title` if it has one, else its name.
local function titleOf(card)
    return card.title or card.name
end

local PANEL_COLOUR = Vector4.new(0.08, 0.08, 0.10, 1.0)
local ART_COLOUR   = Vector4.new(0.16, 0.16, 0.20, 1.0)
local TEXT_COLOUR  = Vector4.new(1.0, 1.0, 1.0, 1.0)
local DESC_COLOUR  = Vector4.new(0.80, 0.80, 0.80, 1.0)

local DIM_TEXT_COLOUR = Vector4.new(0.60, 0.60, 0.65, 1.0)

-- A silhouette (opts.silhouette, the Sets window) is a card the player does not have, drawn as the shadow its model
-- casts. Found in the client (Nov 2026): a model in a ModelGroup ignores any lighting, environment or recolour, so it
-- cannot be darkened, but models in one group cast shadows on each other from the client's default sun, and the
-- camera's near clip plane can cut a model out while its shadow stays. So the card's camera is moved to where the sun
-- is, a big flat model (a Varrock single bed, scaled up) stands behind the figure as a screen, and the figure itself is
-- clipped away: only its grey outline on the screen shows (CardView.shadowLook). The numbers were tuned by eye on the
-- shop, guard and musician NPCs and on swords, bars, ores and herbs.
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
local SILHOUETTE_BACK = Vector4.new(0.16, 0.16, 0.20, 1.0)

-- Converts a 0xRRGGBBAA number into the 0..1 Vector4 the components expect.
-- `alpha` (0..1) replaces the colour's own alpha if given.
local function toVec4(hex, alpha)
    local r = (hex >> 24) & 0xFF
    local g = (hex >> 16) & 0xFF
    local b = (hex >> 8) & 0xFF
    local a = hex & 0xFF
    return Vector4.new(r / 255, g / 255, b / 255, alpha or (a / 255))
end

-- A filled rectangle. Width/height are `w`/`h` units plus `wPct`/`hPct` of the parent.
local function solid(parent, x, y, w, h, wPct, hPct, colour)
    local rect = ui.Rectangle.new(parent)
    rect:SetPos(x, y)
    rect:SetSize(w, h, wPct, hPct)
    rect.fill = true
    rect.colour = colour
    return rect
end

-- A line of text. `vAlign` is optional (centred if omitted).
local function label(parent, x, y, w, h, content, colour, vAlign, maxLines, font)
    local text = ui.Text.new(parent)
    text:SetPos(x, y)
    text:SetSize(w, h, 1.0, 0.0)
    text.font = font or FONT
    text.content = content
    text.colour = colour
    text.isShadowed = true
    if maxLines then
        text.maxLines = maxLines
    end
    text:AlignTo(ui.AlignMode.CENTRE, vAlign or ui.AlignMode.CENTRE)
    return text
end

-- Card frame images (resources/images/frame_<rarity>.png, 320 x 448 px = 2 x the card).
-- The frame is drawn on top of the model; its art window is transparent. The zones below are
-- in card units (pixels / 2), measured from the frames. Only the art window differs by frame.
CardView.USE_FRAMES = true
CardView.FRAME_ZONES = {
    title  = { x = 14, y = 11, w = 132, h = 18 },
    rarity = { x = 14, y = 132, w = 132, h = 16 },
    desc   = { x = 18, y = 155, w = 124, h = 52 },
    window = {
        common    = { x = 16, y = 31, w = 128, h = 100 },
        uncommon  = { x = 20, y = 38, w = 119, h = 88 },
        rare      = { x = 20, y = 37, w = 120, h = 90 },
        epic      = { x = 20, y = 37, w = 120, h = 90 },
        legendary = { x = 20, y = 37, w = 120, h = 89 },
    },
}

local frameCache = {}   -- rarity -> image resource, or false if it is missing

-- Returns the frame image for a rarity, or nil if the file is not there (the plain layout is
-- used instead). Looked up once per rarity; a missing file is logged once.
function CardView.frameResource(rarity)
    if not CardView.USE_FRAMES then
        return nil
    end
    local cached = frameCache[rarity]
    if cached ~= nil then
        return cached or nil
    end
    local ok, resource = pcall(function() return Plugin.resources.images["frame_" .. rarity] end)
    if not ok or resource == nil then
        Logger.error("card frame: no image for", rarity, "(resources/images/frame_" .. rarity .. ".png) - using the plain layout")
        frameCache[rarity] = false
        return nil
    end
    local loaded, result = pcall(function() return resource:Load() end)
    if loaded then
        Logger.debug("card frame: loaded", rarity, tostring(result))
    else
        Logger.error("card frame: could not load", rarity, tostring(result))
    end
    frameCache[rarity] = resource
    return resource
end

-- The picture is drawn through a camera: the NPC goes in a ui.ModelGroup, which has a real
-- camera, so angle, distance and framing can be set. A card's `art.cam` entry can hold:
--   yaw, pitch : angle in radians (0, 0 is straight on)
--   dist       : camera distance (smaller is closer, so the NPC looks bigger)
--   fov        : field of view in degrees (smaller zooms in)
--   ty         : height of the point the camera looks at
--   tx         : left/right of centre it looks at (negative moves the NPC right on the card)
--   near       : how far out the camera starts drawing, as a share of dist (0 is right at the
--                camera; more can stop an old model's surfaces poking through each other, but
--                anything nearer than that is cut off)
-- Anything left out uses these defaults. NPC cards show the whole body model unless they set
-- `art.body = false` (the head), so each has its own defaults (the body is much bigger). Item
-- cards show the item's model, which is far smaller than an NPC, so they have their own too.
-- Item models lie flat, as if on the ground, so the item camera looks down on them (pitch 1.5,
-- nearly straight down). The distance is a first guess: items differ a lot in size, so most item
-- cards will set `art.cam`.
-- The camera's fields, in the order the art lines give them (every list of them uses this one).
CardView.CAMERA_FIELDS = { "yaw", "pitch", "dist", "fov", "ty", "tx", "near" }
CardView.CAMERA_DEFAULTS = {
    head = { yaw = 0.0, pitch = 0.0, dist = 2040, fov = 55, ty = 0, tx = 0, near = 0 },
    body = { yaw = 0.0, pitch = 0.0, dist = 1500, fov = 50, ty = 0, tx = 0, near = 0 },
    item = { yaw = 0.0, pitch = 1.5, dist = 300, fov = 50, ty = 0, tx = 0, near = 0 },
}

-- The camera defaults for a camera state or art table: { kind = "item" } for an item card,
-- otherwise the body model if `body` is true and the head if not.
function CardView.defaultsFor(state)
    if state ~= nil and state.kind == "item" then
        return CardView.CAMERA_DEFAULTS.item
    end
    return CardView.CAMERA_DEFAULTS[(state ~= nil and state.body) and "body" or "head"]
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
        -- An item is looked at from nearly straight above, where "up" in the world is no longer
        -- up on the card (it would move the item towards the camera). So tx and ty move the look-at
        -- point along the camera's own right and up directions, which stay up and sideways on the
        -- card at any pitch. The pitch is stopped before it passes straight down, which flips the picture.
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

CardView.applyCamera = applyCamera

-- Calls to make again on the next tick (the Sets window calls CardView.applyPending every tick, and
-- CardView.clearPending when it destroys its cards): a SetTransform sent before the model has loaded may be lost.
local pendingCalls = {}

function CardView.applyPending()
    local calls = pendingCalls
    pendingCalls = {}
    for _, call in ipairs(calls) do
        pcall(call)
    end
end

function CardView.clearPending()
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

-- Turns the card's ModelGroup into a shadow silhouette (see SHADOW), applying the camera from `state` (the card's
-- camera, which it changes into the shadow camera). SetTransform's rotation is yaw, pitch, roll in radians;
-- everything grows with `view`, how much of the world the card's camera sees against the full-body card's (dist 859,
-- fov 50), so the screen sits the same on every card.
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

-- Hook for the development tools: a function(cardId) returning { body, cam } to use instead of
-- the card's own art settings, or nil.
CardView.artOverride = nil

-- Plays animation `animId` on a model, or stops its animation if `animId` is nil. Many models
-- do not move until they are given one. Animation ids are the client's sequence ids; the
-- preview's Anim buttons are for finding good ones. Returns true if the client accepted it.
function CardView.playAnimation(model, animId)
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

-- Shows the card's NPC (or, for an item card, its item) inside the art box `box` = { x, y, w, h }.
-- Returns the model and the `cam` table (the camera settings, which applyCamera can re-apply),
-- or nil if it could not be shown. If the camera cannot be set up, a plain model is shown
-- instead (no `cam`). An item whose model will not load shows its icon instead (no `cam`).
local function addArt(parent, card, box, bodyOverride, dark)
    local art = Cards.getArt(card)
    local isItem = Cards.kindOf(card) == "item"
    -- Developer-saved settings (from the preview's Save button) sit on top of the card's own.
    -- Only the development tools set CardView.artOverride; it is nil in the released plugin.
    -- An item has no body/head choice and no animation, so only its camera is overridden.
    local saved = CardView.artOverride and CardView.artOverride(card.id) or nil
    if saved ~= nil then
        if not isItem then
            art.body = saved.body
            art.anim = saved.anim
        end
        art.cam = saved.cam
    end
    -- `bodyOverride` (true/false, from the preview) beats the card's own setting.
    local body = art.body
    if bodyOverride ~= nil and not isItem then
        body = bodyOverride
    end
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

        -- (screens: a silhouette's extra models, sized with the figure when the card tilts, fitArt)
        local state = { group = group, body = body == true, anim = art.anim, kind = isItem and "item" or nil,
            screens = {} }
        if art.anim ~= nil and not isItem then
            CardView.playAnimation(child, art.anim)
        end
        local defaults = CardView.defaultsFor(state)
        -- The card's own camera values belong to its own model type, so they are ignored when
        -- the preview has switched to the other one. (An item has only one model type.)
        local own = (isItem or (body == true) == (art.body == true)) and art.cam or {}
        for _, field in ipairs(CardView.CAMERA_FIELDS) do
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

-- Foil (a holo card's finish, or opts.foil): a ui.Canvas over the art box's backdrop, under the model (models draw over every 2D
-- component). A see-through rainbow in diagonal bands. A canvas gradient only runs straight across or straight down,
-- so the bands are thin stripes of one colour each (two or three triangles, cut to the box), stepping round the hues
-- a little at a time. Colours are 0xRRGGBBAA.
CardView.FOIL = {
    hues = { 0xFF3B3B, 0xFF9F1C, 0xFFE14D, 0x4DDB6A, 0x3BC8FF, 0x5B6CFF, 0xC04DFF },   -- round the rainbow, back to the first
    alpha = 0xA0,        -- the rainbow's see-through-ness (0 clear, 0xFF solid)
    angle = 30,          -- how far the bands lean from upright, in degrees
    stripes = 48,        -- how many stripes across the box (more is smoother)
    cycles = 1.0,        -- how many times the rainbow goes round across the box
}

-- The colour `t` of the way round the hues (any number: it wraps), blended between the two nearest.
local function foilColour(t)
    local f = CardView.FOIL
    local n = #f.hues
    local at = (t % 1) * n
    local i = math.floor(at)
    local mix = at - i
    local a, b = f.hues[i % n + 1], f.hues[(i + 1) % n + 1]
    local colour = 0
    for shift = 16, 0, -8 do
        local ca, cb = (a >> shift) & 0xFF, (b >> shift) & 0xFF
        colour = colour | (round(ca + (cb - ca) * mix) << shift)
    end
    return colour * 256 + f.alpha
end

-- The part of a convex polygon (a list of {x, y}) where x * dx + y * dy is at least `limit` (sign 1) or at most (-1).
local function clipPolygon(points, dx, dy, limit, sign)
    local out = {}
    for i = 1, #points do
        local p, q = points[i], points[i % #points + 1]
        local vp = (p[1] * dx + p[2] * dy - limit) * sign
        local vq = (q[1] * dx + q[2] * dy - limit) * sign
        if vp >= 0 then
            out[#out + 1] = p
        end
        if (vp >= 0) ~= (vq >= 0) then
            local t = vp / (vp - vq)
            out[#out + 1] = { p[1] + (q[1] - p[1]) * t, p[2] + (q[2] - p[2]) * t }
        end
    end
    return out
end

-- Draws the foil's stripes on `canvas` (the size of the card) over `box` (the art box, in card units), the rainbow
-- moved round by `phase` (0 at rest; 1 is once round). `map`, if given, takes a point on the flat card to where it
-- shows (CardView.tilt's perspective); the stripes stay straight-edged, so their corners are all that is moved.
local function drawFoil(canvas, box, phase, map)
    local f = CardView.FOIL
    canvas:Clear()
    local w, h = box.w, box.h
    local angle = math.rad(f.angle)
    local dx, dy = math.cos(angle), math.sin(angle)        -- across the bands
    local corners = { 0, w * dx, h * dy, w * dx + h * dy }
    local low, high = math.min(table.unpack(corners)), math.max(table.unpack(corners))
    local rect = { { 0, 0 }, { w, 0 }, { w, h }, { 0, h } }
    local count = math.max(1, math.floor(f.stripes))
    for i = 1, count do
        local u0 = low + (high - low) * (i - 1) / count
        local u1 = low + (high - low) * i / count
        local piece = clipPolygon(clipPolygon(rect, dx, dy, u0, 1), dx, dy, u1, -1)
        if #piece >= 3 then
            local colour = foilColour((i - 0.5) / count * f.cycles + phase)
            local function at(k)
                local x, y = box.x + piece[k][1], box.y + piece[k][2]
                if map ~= nil then
                    x, y = map(x, y)
                end
                return round(x), round(y)
            end
            local x0, y0 = at(1)
            for k = 2, #piece - 1 do
                local x1, y1 = at(k)
                local x2, y2 = at(k + 1)
                canvas:AddTriangle(x0, y0, x1, y1, x2, y2, colour)
            end
        end
    end
end

-- Puts the foil over the art box (`box`, on a card W x H). Returns { draw = function(phase, map) }, or nil: draw
-- moves its rainbow round by `phase`, and with `map` draws it where the tilted card shows it (CardView.tilt).
local function addFoil(parent, box, W, H)
    local ok, result = pcall(function()
        local canvas = ui.Canvas.new(parent)
        canvas:SetPos(0, 0)
        canvas:SetSize(W, H)
        local function draw(phase, map)
            drawFoil(canvas, box, phase, map)
        end
        draw(0)
        return { draw = draw }
    end)
    if not ok then
        Logger.error("card art: foil failed:", tostring(result))
        return nil
    end
    return result
end

-- Wiggle: pressing on a card picks it up, and dragging tilts it: left and right turn it about its
-- upright middle line, up and down tip it about its level one, in perspective (CardView.tilt), and a foil's rainbow
-- moves round. On letting go it springs back flat, wobbling as it settles. CardView.newWiggle does the moving;
-- ui/wiggle.lua passes it the mouse.
CardView.WIGGLE = {
    follow = 0.35,       -- degrees of tilt for each interface unit the mouse moves while held
    maxAngle = 35,       -- the most it tilts either way (degrees)
    stiffness = 220,     -- how hard it springs back once let go
    damping = 11,        -- how quickly the wobble dies down (lower wobbles longer)
    foilShift = 0.5,     -- how far round the rainbow moves, per radian of tilt
    turnModel = 1,       -- how much the figure's camera turns with the card (0 leaves the figure as it is)
}

-- Turning a card (or a card back, or a pack) in perspective: see CardView.tilt.
CardView.TILT = {
    gridX = 10, gridY = 14,   -- how many squares across and down the frame is cut into (more is smoother, and slower)
    distance = 2.5,      -- how far away a turned card or pack is seen from, in its widths (nearer is stronger)
    cameraStep = 0.03,   -- the figure's camera is turned again once the tilt has changed by this much (radians)
}

-- How much a point `depth` behind the flat card (away from the viewer) is scaled, on a card `width` wide seen from
-- CardView.TILT.distance widths away. The tilt, CardView.turnSprite and PackArt.turn all use it.
function CardView.perspective(depth, width)
    local D = CardView.TILT.distance * width
    return D / math.max(D * 0.1, D + depth)
end

-- A line `xc` from the middle of something `width` wide, turned about its upright middle line (sinA, cosA of the
-- angle; + takes the right edge away): how far from the middle it shows, and how much it is scaled there.
-- CardView.turnSprite and PackArt.turn use it.
function CardView.turnPoint(xc, sinA, cosA, width)
    local s = CardView.perspective(xc * sinA, width)
    return xc * cosA * s, s
end

-- Cuts the frame into its grid of squares (CardView.tilt), the first time the card tilts: most cards never do, and a
-- page of cards would otherwise carry thousands of hidden parts. They are made in one layer on top of the card (shown
-- and hidden together); what they cover is in tiltParts.flat, hidden while the card is tilted.
local function makeCells(p)
    if p.cellLayer ~= nil then
        return
    end
    p.cellLayer = ui.Layer.new(p.root)
    p.cellLayer:SetSize(p.W, p.H)
    p.cellLayer.hidden = not p.tilted
    local nx, ny = math.max(1, math.floor(CardView.TILT.gridX)), math.max(1, math.floor(CardView.TILT.gridY))
    p.gridX, p.gridY = nx, ny
    for n = 0, nx * ny - 1 do
        local clip = ui.Layer.new(p.cellLayer)
        clip:SetSize(1, 1)
        local sprite = ui.Sprite.new(clip)
        sprite.sprite = p.frameImage
        if p.locked then
            sprite.alpha = 0.5
        end
        p.cells[#p.cells + 1] = { clip = clip, sprite = sprite, i = n % nx, j = n // nx }
    end
end

-- Makes a card's tilt parts now (CardView.tilt makes them the first time it is needed), for a card that will
-- certainly turn, so the first frames of its turn are not held up making them: the pack window's flip.
function CardView.prepareTilt(view)
    if view.tiltParts ~= nil then
        makeCells(view.tiltParts)
    end
end

-- Draws the backdrop canvas: the art window flat, or the four-cornered shape `project` makes of it.
local function drawBackdrop(p, project)
    local win = p.win
    p.back:Clear()
    if project == nil then
        p.back:AddRectangle(round(win.x), round(win.y), round(win.w), round(win.h), p.backColour)
        return
    end
    local x1, y1 = project(win.x, win.y)
    local x2, y2 = project(win.x + win.w, win.y)
    local x3, y3 = project(win.x + win.w, win.y + win.h)
    local x4, y4 = project(win.x, win.y + win.h)
    x1, y1, x2, y2, x3, y3, x4, y4 = round(x1), round(y1), round(x2), round(y2), round(x3), round(y3), round(x4), round(y4)
    p.back:AddTriangle(x1, y1, x2, y2, x3, y3, p.backColour)
    p.back:AddTriangle(x1, y1, x3, y3, x4, y4, p.backColour)
end

-- Places the picture's ModelGroup (its model, and a silhouette's screens) over x, y, w, h on the card.
local function fitArt(view, x, y, w, h)
    local cam = view.cam
    if cam == nil or cam.group == nil then
        return
    end
    pcall(function()
        cam.group:SetPos(x, y)
        cam.group:SetSize(w, h)
        view.model:SetSize(w, h)
        for _, screen in ipairs(cam.screens) do
            screen:SetSize(w, h)
        end
    end)
end

local function tiltPerspective(view, ax, ay)
    local p = view.tiltParts
    local W, H, win = p.W, p.H, p.win
    local midX, midY = W / 2, H / 2
    local tilted = math.abs(ax) > 0.002 or math.abs(ay) > 0.002
    if not tilted and not p.tilted then
        return          -- (flat, and already drawn flat)
    end
    local sinA, cosA, sinB, cosB = math.sin(ax), math.cos(ax), math.sin(ay), math.cos(ay)
    -- A point on the flat card to where it shows: turned about the upright line, then tipped, then seen from afar.
    local function project(x, y)
        local xc, yc = x - midX, y - midY
        local x1, z1 = xc * cosA, xc * sinA
        local y2, z2 = yc * cosB - z1 * sinB, z1 * cosB + yc * sinB
        local s = CardView.perspective(z2, W)
        return midX + x1 * s, midY + y2 * s
    end

    if tilted then
        makeCells(p)
    end
    if tilted ~= p.tilted then
        p.tilted = tilted
        for _, comp in ipairs(p.flat) do
            comp.hidden = tilted
        end
        p.cellLayer.hidden = not tilted
    end

    if tilted then
        -- Where every grid corner shows, then each square between the halfway lines of its corners.
        local nx, ny = p.gridX, p.gridY
        local cellW, cellH = W / nx, H / ny
        local px, py = p.px or {}, p.py or {}
        p.px, p.py = px, py
        for j = 0, ny do
            px[j], py[j] = px[j] or {}, py[j] or {}
            for i = 0, nx do
                px[j][i], py[j][i] = project(i * cellW, j * cellH)
            end
        end
        for _, cell in ipairs(p.cells) do
            local i, j = cell.i, cell.j
            local x0 = round((px[j][i] + px[j + 1][i]) / 2)
            local x1 = round((px[j][i + 1] + px[j + 1][i + 1]) / 2)
            local y0 = round((py[j][i] + py[j][i + 1]) / 2)
            local y1 = round((py[j + 1][i] + py[j + 1][i + 1]) / 2)
            local cw, ch = math.max(1, x1 - x0), math.max(1, y1 - y0)
            local kx, ky = cw / cellW, ch / cellH
            cell.clip:SetPos(x0, y0)
            cell.clip:SetSize(cw, ch)
            cell.sprite:SetPos(-round(i * cellW * kx), -round(j * cellH * ky))
            cell.sprite:SetSize(math.max(1, round(W * kx)), math.max(1, round(H * ky)))
        end
        drawBackdrop(p, project)
        -- the picture, round the art window's four corners
        local x1, y1 = project(win.x, win.y)
        local x2, y2 = project(win.x + win.w, win.y)
        local x3, y3 = project(win.x + win.w, win.y + win.h)
        local x4, y4 = project(win.x, win.y + win.h)
        local left, top = math.min(x1, x4), math.min(y1, y2)
        fitArt(view, round(left), round(top), math.max(1, round(math.max(x2, x3) - left)),
            math.max(1, round(math.max(y3, y4) - top)))
    else
        drawBackdrop(p, nil)
        fitArt(view, win.x, win.y, win.w, win.h)
    end
    if view.foil ~= nil then
        pcall(view.foil.draw, (ax + ay) * CardView.WIGGLE.foilShift, tilted and project or nil)
    end
end

-- An image that turns about its upright middle line in perspective, as a tilted card does (CardView.tilt): cut into
-- `strips` upright strips, each a layer showing its slice of the image (a layer crops what is inside it). The pack
-- window turns its card backs over with it. Returns { root, place(x, y, w, h, angle), hide(hidden) }: place draws the
-- image w x h at (x, y) in `parent`, turned by `angle` radians (+ takes its right edge away; pi / 2 is edge-on).
function CardView.turnSprite(parent, image, strips)
    local root = ui.Layer.new(parent)
    root:SetPos(0, 0)
    root:SetSize(0, 0, 1, 1)          -- (as big as the parent, so the strips are never cropped by it)
    local list = {}
    for k = 1, math.max(1, math.floor(strips)) do
        local clip = ui.Layer.new(root)
        clip:SetSize(1, 1)
        local sprite = ui.Sprite.new(clip)
        sprite.sprite = image
        list[k] = { clip = clip, sprite = sprite }
    end
    local turn = { root = root }
    function turn.place(x, y, w, h, angle)
        local sinA, cosA = math.sin(angle), math.cos(angle)
        local stripW = w / #list
        for k, strip in ipairs(list) do
            local c0, c1 = (k - 1) * stripW, k * stripW
            local x0, s0 = CardView.turnPoint(c0 - w / 2, sinA, cosA, w)
            local x1, s1 = CardView.turnPoint(c1 - w / 2, sinA, cosA, w)
            x0, x1 = round(x + w / 2 + x0), round(x + w / 2 + x1)
            local sw = math.max(1, x1 - x0)
            local sh = math.max(1, round(h * (s0 + s1) / 2))
            local kx = sw / stripW
            strip.clip:SetPos(x0, round(y + (h - sh) / 2))
            strip.clip:SetSize(sw, sh)
            strip.sprite:SetPos(-round(c0 * kx), 0)
            strip.sprite:SetSize(math.max(1, round(w * kx)), sh)
        end
    end
    function turn.hide(hidden)
        pcall(function() root.hidden = hidden end)
    end
    return turn
end

-- Tilts a card made with opts.tilt by ax radians about its upright middle line (turning it left or right) and ay about
-- its level one (tipping it, + takes the bottom away). 0, 0 is flat. Does nothing to any other card (one without a
-- frame image).
-- The card is turned in 3D and seen from CardView.TILT.distance card widths away. Its frame is cut into a grid of
-- squares, each a layer showing its patch of the frame image (a layer crops what is inside it), placed and sized
-- where that patch shows on the turned card. A square can only be upright, so it covers its patch's shape as near as
-- it can: its edges are halfway between the corners its neighbours share, so the squares meet without gaps. The
-- backdrop canvas is drawn as the four-cornered shape the art window becomes, the foil's stripes are moved the same
-- way, and the picture's ModelGroup is fitted round the art window (its camera turned with the card,
-- CardView.WIGGLE.turnModel; not a silhouette's, whose camera is the sun). Text cannot be stretched a patch at a time,
-- so it is hidden while the card is tilted, with the flat frame (tiltParts.flat).
function CardView.tilt(view, ax, ay)
    if view.tiltParts == nil then
        return
    end
    tiltPerspective(view, ax, ay)
    -- The figure's camera turns with the card (turnModel), when the turn has changed enough to see, and once more
    -- when it is flat again. (Not while CardView.uncover hides the picture: the pack window's flip.)
    local cam = view.cam
    local last = view.camTilt or { 0, 0 }
    local step = CardView.TILT.cameraStep
    if CardView.WIGGLE.turnModel ~= 0 and cam ~= nil and cam.group ~= nil and not view.silhouette
        and (view.uncover == nil or view.uncover.shown ~= false)
        and (math.abs(ax - last[1]) > step or math.abs(ay - last[2]) > step
            or (ax == 0 and ay == 0 and (last[1] ~= 0 or last[2] ~= 0))) then
        view.camTilt = { ax, ay }
        local yaw, pitch = cam.yaw, cam.pitch
        -- (turning the card one way is the camera going round it the other way; tipping it, the same way)
        cam.yaw = yaw - ax * CardView.WIGGLE.turnModel
        cam.pitch = pitch + ay * CardView.WIGGLE.turnModel
        pcall(applyCamera, cam)
        cam.yaw, cam.pitch = yaw, pitch
    end
end

-- A wiggle for `view` (from CardView.create with opts.tilt; ui/wiggle.lua makes and drives them).
--   w:press(x, y)        the mouse went down at screen position (x, y)
--   w:release()          the mouse came up
--   w:step(dt, x, y)     every frame, with where the mouse is now (nil if unknown)
function CardView.newWiggle(view)
    local w = { view = view, x = 0, y = 0, vx = 0, vy = 0, held = nil }     -- x, y: the tilt in degrees
    function w:press(x, y)
        self.held = { x = x, y = y, fromX = self.x, fromY = self.y }
    end
    function w:release()
        self.held = nil
    end
    function w:step(dt, mouseX, mouseY)
        local t = CardView.WIGGLE
        dt = math.min(dt, 0.05)
        if dt <= 0 then
            return
        end
        local oldX, oldY = self.x, self.y
        if self.held ~= nil and mouseX ~= nil then
            local x = self.held.fromX + (mouseX - self.held.x) * t.follow
            local y = self.held.fromY + (mouseY - self.held.y) * t.follow
            self.x = math.max(-t.maxAngle, math.min(t.maxAngle, x))
            self.y = math.max(-t.maxAngle, math.min(t.maxAngle, y))
            self.vx, self.vy = (self.x - oldX) / dt, (self.y - oldY) / dt     -- so letting go flings it on from there
        elseif self.held == nil then
            self.vx = self.vx + (-t.stiffness * self.x - t.damping * self.vx) * dt
            self.vy = self.vy + (-t.stiffness * self.y - t.damping * self.vy) * dt
            self.x, self.y = self.x + self.vx * dt, self.y + self.vy * dt
            if math.abs(self.x) < 0.2 and math.abs(self.y) < 0.2 and math.abs(self.vx) < 2 and math.abs(self.vy) < 2 then
                self.x, self.y, self.vx, self.vy = 0, 0, 0, 0
            end
        end
        if self.x ~= oldX or self.y ~= oldY then
            CardView.tilt(self.view, math.rad(self.x), math.rad(self.y))
        end
    end
    return w
end

-- A frame zone scaled by CardView.SCALE. The zone tables are in 160 x 224 card units.
local function scaled(zone, s)
    return { x = zone.x * s, y = zone.y * s, w = zone.w * s, h = zone.h * s }
end

-- The size of a card drawn at `scale` (the default is CardView.SCALE). Returns scale, width, height.
local function metrics(scale)
    scale = scale or S
    return scale, math.floor(160 * scale), math.floor(224 * scale)
end

-- A card-sized window that CardView.uncover can shrink to any part of the card: a layer (which
-- crops what is inside it) holding a card-sized layer that moves the other way, so whatever is
-- built in `inner` stays put while the window around it changes.
local function window(root, W, H)
    local clip = ui.Layer.new(root)
    clip:SetSize(W, H)
    local inner = ui.Layer.new(clip)
    inner:SetSize(W, H)
    return { clip = clip, inner = inner }
end

-- (label() sizes are an offset from the full parent width, hence `w - CardView.WIDTH`.)
-- Builds a card that uses a frame image. Order matters: whatever is created later is drawn on
-- top, so the backdrop and the model go first, then the frame, then the text.
-- Returns the view's fields: model, cam, foil, tiltParts (CardView.tilt), and with opts.animated what
-- CardView.uncover needs (windows round the model and the text, and the middle of the art box). `silhouette`: a locked card drawn as its shadow (see CardView.create).
local function buildFramed(root, card, opts, locked, silhouette, frameImage, rarity, rarityColour, s, W, H)
    local base = CardView.FRAME_ZONES
    local zones = { title = scaled(base.title, s), rarity = scaled(base.rarity, s), desc = scaled(base.desc, s) }
    local win = scaled(base.window[card.rarity] or base.window.common, s)
    local nameColour = locked and DIM_TEXT_COLOUR or TEXT_COLOUR
    local animated = opts ~= nil and opts.animated
    -- Where the model and the text go: windows for uncover, or the card itself.
    local function holder()
        return animated and window(root, W, H) or { inner = root }
    end

    -- The backdrop behind the model. A card that can tilt (opts.tilt) draws it on a canvas, so it can be drawn turned;
    -- the rest of what CardView.tilt needs is made when it first tilts (makeCells). `flat` is what a tilted card hides.
    local backColour = silhouette and SILHOUETTE_BACK or ART_COLOUR
    local tiltParts = nil
    if opts ~= nil and opts.tilt then
        tiltParts = { W = W, H = H, win = win, backColour = backColour, flat = {}, cells = {}, tilted = false,
            root = root, frameImage = frameImage, locked = locked }
        tiltParts.back = ui.Canvas.new(root)
        tiltParts.back:SetSize(W, H)
        drawBackdrop(tiltParts, nil)
    else
        solid(root, win.x, win.y, win.w, win.h, 0, 0, backColour)
    end
    local foil = nil
    if opts ~= nil and (opts.foil or opts.finish == "holo") and not locked then
        foil = addFoil(root, win, W, H)
    end
    local art = holder()
    local model, cam = nil, nil
    if not locked or silhouette then
        model, cam = addArt(art.inner, card, win, opts and opts.body, silhouette)
    end
    local placeholder = nil
    if model == nil then
        placeholder = label(art.inner, win.x, win.y, win.w - W, win.h, "?", locked and DIM_TEXT_COLOUR or rarityColour)
    end

    local frame = ui.Sprite.new(root)                            -- frame on top of the model
    frame:SetPos(0, 0)
    frame:SetSize(W, H)
    frame.sprite = frameImage
    if locked then
        frame.alpha = 0.5
    end

    local text = holder()
    local texts = {
        label(text.inner, zones.title.x, zones.title.y, zones.title.w - W, zones.title.h, titleOf(card), nameColour, nil,
            nil, (CardView.nameFont(#titleOf(card), zones.title.w))),
        label(text.inner, zones.rarity.x, zones.rarity.y, zones.rarity.w - W, zones.rarity.h, rarity.name,
            locked and DIM_TEXT_COLOUR or rarityColour),
        label(text.inner, zones.desc.x, zones.desc.y, zones.desc.w - W, zones.desc.h,
            locked and (opts and opts.lockedText or "Not collected yet") or card.desc,
            locked and DIM_TEXT_COLOUR or DESC_COLOUR, ui.AlignMode.TOPLEFT, 3),
    }
    if tiltParts ~= nil then
        -- (the frame, the text and the "?" stay flat, so they are hidden while it tilts: a locked card's half
        -- see-through squares would show them through)
        tiltParts.flat[#tiltParts.flat + 1] = frame
        tiltParts.flat[#tiltParts.flat + 1] = placeholder
        for _, t in ipairs(texts) do
            tiltParts.flat[#tiltParts.flat + 1] = t
        end
    end
    local view = { model = model, cam = cam, foil = foil, tiltParts = tiltParts, silhouette = silhouette }
    if animated then
        view.uncover = { windows = { art, text }, w = W, h = H, x = win.x + win.w / 2, y = win.y + win.h / 2 }
    end
    return view
end

-- The look of a card of `rarity` before its picture and text: its frame image, with the dark
-- backdrop in its art window. (The pack window's face-up stacks are made of these.) Returns
-- { place(x, y, w, h), destroy() }, or nil if the rarity has no frame image.
function CardView.shell(parent, rarity)
    local frameImage = CardView.frameResource(rarity)
    if frameImage == nil then
        return nil
    end
    local zone = CardView.FRAME_ZONES.window[rarity] or CardView.FRAME_ZONES.window.common
    local backdrop = solid(parent, 0, 0, 1, 1, 0, 0, ART_COLOUR)
    local frame = ui.Sprite.new(parent)
    frame.sprite = frameImage
    return {
        place = function(x, y, w, h)
            local win = scaled(zone, w / 160)                    -- the zones are in 160-wide card units
            backdrop:SetPos(x + win.x, y + win.y)
            backdrop:SetSize(win.w, win.h)
            frame:SetPos(x, y)
            frame:SetSize(w, h)
        end,
        destroy = function()
            pcall(function() backdrop:Destroy() end)
            pcall(function() frame:Destroy() end)
        end,
    }
end

-- Where CardView.uncover grows from (the middle of the art box), as x, y in card units, and how
-- far it has to reach from there to uncover the whole card. nil for a card that can't be uncovered.
function CardView.uncoverOrigin(view)
    local u = view.uncover
    if u == nil then
        return nil
    end
    return u.x, u.y, math.max(u.x, u.w - u.x, u.y, u.h - u.y)
end

-- Shows a card's model and text within `reach` card units of CardView.uncoverOrigin (a square
-- round it, cut to the card). 0 hides them; the reach uncoverOrigin gives shows all of them.
-- Only a card made with opts.animated and a frame image can do this; for any other it returns false.
function CardView.uncover(view, reach)
    local u = view.uncover
    if u == nil then
        return false
    end
    local left, top = math.max(0, u.x - reach), math.max(0, u.y - reach)
    local right, bottom = math.min(u.w, u.x + reach), math.min(u.h, u.y + reach)
    local shown = reach > 0
    for _, win in ipairs(u.windows) do
        if u.shown ~= shown then
            pcall(function() win.clip.hidden = not shown end)
        end
        if shown then
            win.clip:SetPos(left, top)
            win.clip:SetSize(math.max(1, right - left), math.max(1, bottom - top))
            win.inner:SetPos(-left, -top)
        end
    end
    u.shown = shown
    return true
end

-- Builds a card inside `parent` at the top-left (call :SetPos on the result to move it).
-- `opts` is optional.
-- opts.locked = true draws a placeholder for a card the player does not own yet: dimmed,
-- with a "?" instead of the art and no description.
-- opts.silhouette = true (with locked) shows the locked card's picture as a shadow silhouette instead of the "?"
-- (the Sets window), still with no description.
-- opts.tilt = true lets CardView.tilt draw the card in perspective (the pack window's flip, and picking a card up,
-- ui/wiggle.lua).
-- opts.finish = the card's finish (Cards.finishes): "holo" draws the foil behind the picture (CardView.FOIL;
-- framed cards only, not locked ones). opts.foil = true draws it whatever the finish (the preview).
-- opts.lockedText = what a locked card says in place of its description (default "Not collected yet").
-- opts.frame = false skips the frame image and uses the plain layout (preview only).
-- opts.scale = a size other than CardView.SCALE (the preview uses it for a bigger card). The text
-- stays the same size; the picture, frame and layout scale.
-- opts.body = true/false forces the body or head model, whatever the card says (preview only).
-- opts.animated = true makes a card whose picture and text can be revealed (CardView.uncover; the
-- pack opening). Other cards are built without the extra layers that needs.
-- Returns { root = <Layer>, model = <Model or nil>, cam = <camera settings or nil>, card = <card data>,
-- uncover = <what CardView.uncover uses, or nil>, foil, tiltParts, silhouette }.
function CardView.create(parent, card, opts)
    local S, W, H = metrics(opts and opts.scale)
    local locked = opts ~= nil and opts.locked == true
    local silhouette = locked and opts.silhouette == true

    local rarity = Cards.rarities[card.rarity]
    local rarityColour = toVec4(rarity.colour)
    local frameColour = locked and toVec4(rarity.colour, 0.35) or rarityColour
    local nameColour = locked and DIM_TEXT_COLOUR or TEXT_COLOUR

    local root = ui.Layer.new(parent)
    root:SetSize(W, H)

    -- With a frame image the card is built from the image alone. (A coloured rectangle behind
    -- it would show at the edges, and gives the rarity away when something sits on top of
    -- the card, like the card back in the pack opening.)
    local frameImage = CardView.frameResource(card.rarity)
    if frameImage ~= nil and not (opts and opts.frame == false) then
        local view = buildFramed(root, card, opts, locked, silhouette, frameImage, rarity, rarityColour, S, W, H)
        view.root, view.card = root, card
        return view
    end

    solid(root, 0, 0, 0, 0, 1.0, 1.0, frameColour)           -- frame
    solid(root, 4, 4, -8, -8, 1.0, 1.0, PANEL_COLOUR)        -- inner panel

    -- Plain layout, used when there is no frame image.
    label(root, 8, 8, -16, 22, titleOf(card), nameColour, nil, nil, (CardView.nameFont(#titleOf(card), W - 16)))        -- title

    solid(root, 10, 34 * S, -20, 110 * S, 1.0, 0.0, silhouette and SILHOUETTE_BACK or ART_COLOUR)      -- art box
    local model, cam = nil, nil
    if not locked or silhouette then
        model, cam = addArt(root, card, { x = 10, y = 34 * S, w = W - 20, h = 110 * S }, opts and opts.body, silhouette)
    end
    if model == nil then
        label(root, 10, 34 * S, -20, 110 * S, "?", locked and DIM_TEXT_COLOUR or rarityColour)  -- placeholder art
    end
    local outline = ui.Rectangle.new(root)                   -- art outline, on top of the model
    outline:SetPos(10, 34 * S)
    outline:SetSize(-20, 110 * S, 1.0, 0.0)
    outline.fill = false
    outline.outlineThickness = 1
    outline.colour = frameColour

    label(root, 8, 148 * S, -16, 16, rarity.name, frameColour)   -- rarity
    if locked then
        label(root, 10, 168 * S, -20, 48 * S, opts and opts.lockedText or "Not collected yet", DIM_TEXT_COLOUR,
            ui.AlignMode.TOPLEFT, 3)
    else
        label(root, 10, 168 * S, -20, 48 * S, card.desc, DESC_COLOUR, ui.AlignMode.TOPLEFT, 3)
    end

    return { root = root, model = model, cam = cam, card = card }
end

return CardView
