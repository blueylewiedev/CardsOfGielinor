-- ui/cardview.lua
-- Draws a card from its data with live UI components: the frame image on top, its art window showing the NPC or item
-- through a camera, and the name, rarity and description over the frame's panels (160 x 224 units at scale 1).

local Cards = require("core/cards")
local Logger = require("core/logger")
local Settings = require("core/settings")
local Config = require("core/config")
local Events = require("core/events")

local CardView = {}

-- Card size. The layout below was measured on a 160 x 224 card; SCALE enlarges everything to
-- fit (frame zones and the card itself). Change SCALE to resize the cards.
CardView.SCALE = 1.25
local S = CardView.SCALE

-- A card at scale 1 is this many units across and down; sizeAt(scale) is its width and height at another scale.
CardView.BASE_W, CardView.BASE_H = 160, 224
function CardView.sizeAt(scale)
    return math.floor(CardView.BASE_W * scale), math.floor(CardView.BASE_H * scale)
end
CardView.WIDTH, CardView.HEIGHT = CardView.sizeAt(S)

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR

-- A font in the client by its name, or nil if the client has none of that name.
local function fontNamed(name)
    local ok, value = pcall(function() return id.Font[name] end)
    if ok and value ~= nil then
        return value
    end
    return nil
end

-- The font sizes a card's title steps down through when it is too long, with `perLetter`, about how much room a
-- letter takes at that size (measured in the client; it cannot measure text, so how many letters fit is a guess). A
-- size the client does not have is left out.
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

local ART_COLOUR   = Vector4.new(0.16, 0.16, 0.20, 1.0)
local TEXT_COLOUR  = Vector4.new(1.0, 1.0, 1.0, 1.0)
local DESC_COLOUR  = Vector4.new(0.80, 0.80, 0.80, 1.0)

local DIM_TEXT_COLOUR = Vector4.new(0.60, 0.60, 0.65, 1.0)

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
local SILHOUETTE_BACK = Vector4.new(0.16, 0.16, 0.20, 1.0)

-- Converts a 0xRRGGBBAA number into the 0..1 Vector4 the components expect. `alpha` (0..1) replaces the colour's own
-- alpha if given.
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

-- Returns the frame image for a rarity, or nil if the file is not there (the card is then drawn without a frame; the
-- images ship with the plugin, so only a broken install has none). Looked up once per rarity; a missing file is logged once.
function CardView.frameResource(rarity)
    local cached = frameCache[rarity]
    if cached ~= nil then
        return cached or nil
    end
    local ok, resource = pcall(function() return Plugin.resources.images["frame_" .. rarity] end)
    if not ok or resource == nil then
        Logger.error("card frame: no image for", rarity, "(resources/images/frame_" .. rarity .. ".png) - drawn without a frame")
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

-- The picture is drawn through a camera: the NPC goes in a ui.ModelGroup, which has a real camera. A card's `art.cam`
-- can hold yaw and pitch (radians, 0 is straight on), dist (smaller is closer), fov (degrees), ty (height looked at),
-- tx (left/right) and near (where the camera starts drawing, as a share of dist). Anything left out uses these
-- defaults: the body model, the head (`art.body = false`) and items each have their own, and an item looks down on
-- its model (pitch 1.5) since items lie flat.
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

-- Shows the card's NPC (or item) inside the art box { x, y, w, h }. Returns the model and the `cam` table (which
-- applyCamera can re-apply), or nil. If the camera cannot be set up a plain model is shown (no `cam`); an item whose
-- model will not load shows its icon.
local function addArt(parent, card, box, dark)
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

-- Holo: a ui.Canvas over the art box's backdrop and under the picture (models draw over 2D components), a see-through
-- rainbow in diagonal bands. A canvas gradient only runs straight across or down, so the bands are thin one-colour
-- stripes of triangles, stepping round the hues. It is drawn once, in the art window, so it is revealed with the
-- picture (CardView.uncover).
CardView.HOLO = {
    -- pastels round the rainbow, back to the first
    hues = { 0xFFB3B3, 0xFFD9A8, 0xFFF2A8, 0xB8F0C4, 0xA8E4FF, 0xB8C2FF, 0xE0B8FF },
    alpha = 0x60,        -- the rainbow's see-through-ness (0 clear, 0xFF solid): a tint over the backdrop
    angle = 30,          -- how far the bands lean from upright, in degrees
    stripes = 48,        -- the most stripes across the box (more is smoother; a small box has fewer)
    cycles = 1.0,        -- how many times the rainbow goes round across the box
}

local function round(v)
    return math.floor(v + 0.5)
end

-- The colour `t` of the way round the hues (any number: it wraps), blended between the two nearest.
local function holoColour(t)
    local f = CardView.HOLO
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

-- The holo's stripes for an art box w x h (whole numbers), as a list of { x0, y0, x1, y1, x2, y2, colour } triangles.
-- They depend only on the size and CardView.HOLO, so each size is worked out once (a page of holo cards shares them).
local holoTriangles = {}

local function holoStripes(w, h)
    local key = w .. "x" .. h
    if holoTriangles[key] ~= nil then
        return holoTriangles[key]
    end
    local f = CardView.HOLO
    local triangles = {}
    local angle = math.rad(f.angle)
    local dx, dy = math.cos(angle), math.sin(angle)        -- across the bands
    local corners = { 0, w * dx, h * dy, w * dx + h * dy }
    local low, high = math.min(table.unpack(corners)), math.max(table.unpack(corners))
    local rect = { { 0, 0 }, { w, 0 }, { w, h }, { 0, h } }
    -- (about 4 pixels a stripe, up to f.stripes: a small card's are as smooth with half as many, each one call to draw)
    local count = math.max(1, math.min(math.floor(f.stripes), math.ceil((high - low) / 4)))
    for i = 1, count do
        local u0 = low + (high - low) * (i - 1) / count
        local u1 = low + (high - low) * i / count
        local piece = clipPolygon(clipPolygon(rect, dx, dy, u0, 1), dx, dy, u1, -1)
        if #piece >= 3 then
            local colour = holoColour((i - 0.5) / count * f.cycles)
            local x0, y0 = round(piece[1][1]), round(piece[1][2])
            for k = 2, #piece - 1 do
                triangles[#triangles + 1] = { x0, y0, round(piece[k][1]), round(piece[k][2]),
                    round(piece[k + 1][1]), round(piece[k + 1][2]), colour }
            end
        end
    end
    holoTriangles[key] = triangles
    return triangles
end

-- Draws the holo's stripes in `parent` over `box` (the art box, in card units), in whole pixels. Returns the canvas, or
-- nil (and nothing is left behind) if it could not be made. Config "holo.enabled" false turns holos off.
local function addHolo(parent, box)
    if not Config.get("holo.enabled") then
        return nil
    end
    local canvas = nil
    local ok, err = pcall(function()
        local w, h = round(box.w), round(box.h)
        canvas = ui.Canvas.new(parent)
        canvas:SetPos(round(box.x), round(box.y))
        canvas:SetSize(w, h)
        for _, t in ipairs(holoStripes(w, h)) do
            canvas:AddTriangle(t[1], t[2], t[3], t[4], t[5], t[6], t[7])
        end
    end)
    if not ok then
        Logger.error("card art: holo failed:", tostring(err))
        if canvas ~= nil then
            pcall(function() canvas:Destroy() end)
        end
        return nil
    end
    return canvas
end

-- Foil shine (a foil card's finish): two almost see-through pastel images, the size of the whole card
-- (resources/images/foil_a.png and foil_b.png, made by dev/make_foil.py), laid over it and cross-faded so the bands seem
-- to drift. It is made after the picture, so it covers the whole card: the frame, the backdrop, the picture and the text.
CardView.SHINE = {
    alpha = 0.85,        -- how strong it is at its brightest (times the images' own see-through-ness)
    speed = 1.4,         -- cross-fade speed (radians per second)
    most = 60,           -- how many shining cards are animated at once (the oldest stop first)
}

local shineImages = {}           -- image name -> resource, or false if it is missing

local function shineImage(name)
    local cached = shineImages[name]
    if cached ~= nil then
        return cached or nil
    end
    local ok, resource = pcall(function() return Plugin.resources.images[name] end)
    if not ok or resource == nil then
        Logger.error("card shine: no image resources/images/" .. name .. ".png")
        shineImages[name] = false
        return nil
    end
    pcall(function() resource:Load() end)
    shineImages[name] = resource
    return resource
end

local shines = {}                -- every shine being animated: { a, b, offset } (a and b are its two sprites)
local shineClock = 0

-- Lays the shine over the card (`W` x `H`) in `parent`. Returns its two sprites, or nil.
local function addShine(parent, W, H)
    local a, b = shineImage("foil_a"), shineImage("foil_b")
    if a == nil or b == nil then
        return nil
    end
    -- Each card starts at a different point, so a page of foils does not pulse in step.
    local offset = math.random() * 6.28
    local ok, sprites = pcall(function()
        local made = {}
        for _, image in ipairs({ a, b }) do
            local sprite = ui.Sprite.new(parent)
            sprite:SetPos(0, 0)
            sprite:SetSize(W, H)
            sprite.sprite = image
            made[#made + 1] = sprite
        end
        made[1].alpha = CardView.SHINE.alpha * math.sin(offset) ^ 2
        made[2].alpha = CardView.SHINE.alpha * math.cos(offset) ^ 2
        return made
    end)
    if not ok then
        Logger.error("card shine failed:", tostring(sprites))
        return nil
    end
    shines[#shines + 1] = { a = sprites[1], b = sprites[2], offset = offset }
    if #shines > CardView.SHINE.most then
        table.remove(shines, 1)
    end
    return sprites
end

Events.on("Draw", "cardcollector_shine", function(e)
    local ok, dt = pcall(function() return e.timeDeltaSecs end)
    if not ok or type(dt) ~= "number" then
        dt = 0.016
    end
    shineClock = shineClock + dt
    local t = CardView.SHINE
    local i = 1
    while i <= #shines do
        local shine = shines[i]
        local theta = shineClock * t.speed + shine.offset
        local alive = pcall(function()
            shine.a.alpha = t.alpha * math.sin(theta) ^ 2
            shine.b.alpha = t.alpha * math.cos(theta) ^ 2
        end)
        if alive then
            i = i + 1
        else
            table.remove(shines, i)          -- (its card was destroyed)
        end
    end
end)

-- A frame zone scaled by CardView.SCALE. The zone tables are in 160 x 224 card units.
local function scaled(zone, s)
    return { x = zone.x * s, y = zone.y * s, w = zone.w * s, h = zone.h * s }
end

-- The size of a card drawn at `scale` (the default is CardView.SCALE). Returns scale, width, height.
local function metrics(scale)
    scale = scale or S
    local width, height = CardView.sizeAt(scale)
    return scale, width, height
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

-- (label() sizes are an offset from the full parent width, hence `w - CardView.WIDTH`.) Builds a card. Whatever is
-- created later is drawn on top: the backdrop (and a holo's rainbow) and the model go first, then the frame, the text
-- and a foil's shine. Returns model, cam, silhouette and, with opts.animated, what CardView.squash and
-- CardView.uncover need.
local function buildFramed(root, card, opts, locked, silhouette, frameImage, rarity, rarityColour, s, W, H)
    local base = CardView.FRAME_ZONES
    local zones = { title = scaled(base.title, s), rarity = scaled(base.rarity, s), desc = scaled(base.desc, s) }
    local win = scaled(base.window[card.rarity] or base.window.common, s)
    local nameColour = locked and DIM_TEXT_COLOUR or TEXT_COLOUR
    local animated = opts ~= nil and opts.animated
    local squash = { mid = W / 2, parts = {} }
    local function part(comp, x, y, w, h)
        squash.parts[#squash.parts + 1] = { comp = comp, x = x, y = y, w = w, h = h }
    end
    -- Where the model and the text go: windows for uncover, or the card itself.
    local function holder()
        return animated and window(root, W, H) or { inner = root }
    end

    -- the backdrop behind the model
    part(solid(root, win.x, win.y, win.w, win.h, 0, 0, silhouette and SILHOUETTE_BACK or ART_COLOUR), win.x, win.y, win.w, win.h)
    local art = holder()
    -- a holo's rainbow over the backdrop, under the picture (in the art window, so it is revealed with the picture)
    if opts ~= nil and opts.finish == "holo" and not locked then
        addHolo(art.inner, win)
    end
    local model, cam = nil, nil
    if not locked or silhouette then
        model, cam = addArt(art.inner, card, win, silhouette)
    end
    if model == nil then
        label(art.inner, win.x, win.y, win.w - W, win.h, "?", locked and DIM_TEXT_COLOUR or rarityColour)
    end

    if frameImage ~= nil then
        local frame = ui.Sprite.new(root)                        -- frame on top of the model
        frame:SetPos(0, 0)
        frame:SetSize(W, H)
        frame.sprite = frameImage
        if locked then
            frame.alpha = 0.5
        end
        part(frame, 0, 0, W, H)
    end

    local text = holder()
    label(text.inner, zones.title.x, zones.title.y, zones.title.w - W, zones.title.h, titleOf(card), nameColour, nil, nil,
        (CardView.nameFont(#titleOf(card), zones.title.w)))
    label(text.inner, zones.rarity.x, zones.rarity.y, zones.rarity.w - W, zones.rarity.h, rarity.name,
        locked and DIM_TEXT_COLOUR or rarityColour)
    label(text.inner, zones.desc.x, zones.desc.y, zones.desc.w - W, zones.desc.h,
        locked and (opts and opts.lockedText or "Not collected yet") or card.desc,
        locked and DIM_TEXT_COLOUR or DESC_COLOUR, ui.AlignMode.TOPLEFT, 3)

    -- a foil's shine goes over the whole card, the text included (and narrows with the frame when the card is turned)
    if opts ~= nil and opts.finish == "foil" and not locked and Settings.get("shine")
        and Config.get("shine.enabled") then
        for _, sprite in ipairs(addShine(root, W, H) or {}) do
            part(sprite, 0, 0, W, H)
        end
    end

    local view = { model = model, cam = cam, silhouette = silhouette }
    if animated then
        view.squash = squash
        view.uncover = { windows = { art, text }, w = W, h = H, x = win.x + win.w / 2, y = win.y + win.h / 2 }
    end
    return view
end

-- Squeezes a card sideways to `f` (0 to 1) of its width, about its middle. Only the frame, the backdrop and a foil's
-- shine narrow: the model and the text cannot be squeezed, so hide them first with CardView.uncover(view, 0). Only a
-- card made with opts.animated can be squeezed.
function CardView.squash(view, f)
    local squash = view.squash
    if squash == nil then
        return false
    end
    for _, part in ipairs(squash.parts) do
        part.comp:SetPos(squash.mid + (part.x - squash.mid) * f, part.y)
        part.comp:SetSize(math.max(1, part.w * f), part.h)
    end
    return true
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
-- Only a card made with opts.animated can do this; for any other it returns false.
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

-- Builds a card inside `parent` at the top-left (SetPos on the result moves it). Optional opts:
--   locked       a placeholder for a card the player does not own: dimmed, a "?" and no description
--   silhouette   (with locked) the picture as a shadow instead of the "?"
--   finish "foil" draws the shine over the card (CardView.SHINE), "holo" the rainbow behind
--     the picture (CardView.HOLO); not for locked cards
--   lockedText   what a locked card says (default "Not collected yet")
--   scale        a size other than CardView.SCALE; the text stays the same size
--   animated     a card that can be flipped and revealed (CardView.squash and CardView.uncover; the pack opening)
-- Returns { root, model, cam, card, squash, uncover, silhouette }.
function CardView.create(parent, card, opts)
    local S, W, H = metrics(opts and opts.scale)
    local locked = opts ~= nil and opts.locked == true
    local silhouette = locked and opts.silhouette == true

    local rarity = Cards.rarities[card.rarity]
    local root = ui.Layer.new(parent)
    root:SetSize(W, H)
    -- The card's edge is its frame image alone. (A coloured rectangle behind it would show at the edges, and gives
    -- the rarity away when something sits on top of the card, like the card back in the pack opening.)
    local view = buildFramed(root, card, opts, locked, silhouette, CardView.frameResource(card.rarity), rarity,
        toVec4(rarity.colour), S, W, H)
    view.root, view.card = root, card
    return view
end

return CardView
