-- ui/cardview.lua
-- Draws a card from its data using live UI components (no image files needed).
--
-- Layout (all sizes in interface units), 160 x 224. With a frame image (the normal case):
--   frame image on top, its art window showing the NPC through a camera, and the name,
--   rarity and description drawn over the frame's panels. Without one (the image is missing)
--   a plain rectangle layout is used instead.

local Cards = require("core/cards")

local CardView = {}

-- Card size. The layout below was measured on a 160 x 224 card; SCALE enlarges everything to
-- fit (frame zones, the plain layout, the card itself). Change SCALE to resize the cards.
CardView.SCALE = 1.25
local S = CardView.SCALE
CardView.WIDTH = math.floor(160 * S)
CardView.HEIGHT = math.floor(224 * S)

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR

local PANEL_COLOUR = Vector4.new(0.08, 0.08, 0.10, 1.0)
local ART_COLOUR   = Vector4.new(0.16, 0.16, 0.20, 1.0)
local TEXT_COLOUR  = Vector4.new(1.0, 1.0, 1.0, 1.0)
local DESC_COLOUR  = Vector4.new(0.80, 0.80, 0.80, 1.0)

local DIM_TEXT_COLOUR = Vector4.new(0.60, 0.60, 0.65, 1.0)

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
local function label(parent, x, y, w, h, content, colour, vAlign, maxLines)
    local text = ui.Text.new(parent)
    text:SetPos(x, y)
    text:SetSize(w, h, 1.0, 0.0)
    text.font = FONT
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
        log("card frame: no image for", rarity, "(resources/images/frame_" .. rarity .. ".png) - using the plain layout")
        frameCache[rarity] = false
        return nil
    end
    local loaded, result = pcall(function() return resource:Load() end)
    log("card frame: loaded", rarity, loaded and tostring(result) or ("FAILED: " .. tostring(result)))
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
-- Anything left out uses these defaults. NPC cards show the whole body model unless they set
-- `art.body = false` (the head), so each has its own defaults (the body is much bigger). Item
-- cards show the item's model, which is far smaller than an NPC, so they have their own too.
-- Item models lie flat, as if on the ground, so the item camera looks down on them (pitch 1.5,
-- nearly straight down). The distance is a first guess: items differ a lot in size, so most item
-- cards will set `art.cam`.
CardView.CAMERA_DEFAULTS = {
    head = { yaw = 0.0, pitch = 0.0, dist = 2040, fov = 55, ty = 0, tx = 0 },
    body = { yaw = 0.0, pitch = 0.0, dist = 1500, fov = 50, ty = 0, tx = 0 },
    item = { yaw = 0.0, pitch = 1.5, dist = 300, fov = 50, ty = 0, tx = 0 },
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
    camera:SetClipPlanes(1, cam.dist * 20)
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
        log("card animation failed:", tostring(err))
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
    log("card art: item icon failed for", objId, tostring(sprite))
    return nil
end

-- Shows the card's NPC (or, for an item card, its item) inside the art box `box` = { x, y, w, h }.
-- Returns the model and the `cam` table (the camera settings, which applyCamera can re-apply),
-- or nil if it could not be shown. If the camera cannot be set up, a plain model is shown
-- instead (no `cam`). An item whose model will not load shows its icon instead (no `cam`).
local function addArt(parent, card, box, bodyOverride)
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
            log("card art: item not found for", card.id, tostring(art.item), "->", tostring(objId))
            return nil
        end
        modelId, modelType = objId, ui.ModelType.OBJECT
    else
        local ok, npcID = pcall(function() return id.NPC[art.npc] end)
        if not ok or not Cards.isValidNpcId(npcID) then
            log("card art: NPC not found for", card.id, art.npc, "->", tostring(npcID))
            return nil
        end
        modelId, modelType = npcID, ui.ModelType[body and "NPC_MODEL" or "NPC_HEAD"]
    end

    local built, model, cam = pcall(function()
        local group = ui.ModelGroup.new(parent)
        group:SetPos(box.x, box.y)
        group:SetSize(box.w, box.h)
        local child = ui.Model.new(group)
        child:SetSize(box.w, box.h)
        child:SetModel(modelType, modelId)

        local state = { group = group, body = body == true, anim = art.anim, kind = isItem and "item" or nil }
        if art.anim ~= nil and not isItem then
            CardView.playAnimation(child, art.anim)
        end
        local defaults = CardView.defaultsFor(state)
        -- The card's own camera values belong to its own model type, so they are ignored when
        -- the preview has switched to the other one. (An item has only one model type.)
        local own = (isItem or (body == true) == (art.body == true)) and art.cam or {}
        for _, field in ipairs({ "yaw", "pitch", "dist", "fov", "ty", "tx" }) do
            state[field] = own[field] or defaults[field]
        end
        applyCamera(state)
        return child, state
    end)
    if built then
        return model, cam
    end
    log("card art: camera failed for", card.id, "- showing a plain model:", tostring(model))

    local plain = ui.Model.new(parent)
    plain:SetPos(box.x, box.y)
    plain:SetSize(box.w, box.h)
    local shown, err = pcall(function() plain:SetModel(modelType, modelId) end)
    if not shown then
        log("card art: SetModel failed for", card.id, err)
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
-- With opts.animated it also returns what CardView.squash needs (the pieces that can be
-- narrowed, with their places and sizes) and what CardView.uncover needs (windows round the
-- model and the text, which cannot be narrowed, and the middle of the art box).
local function buildFramed(root, card, opts, locked, frameImage, rarity, rarityColour, s, W, H)
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

    part(solid(root, win.x, win.y, win.w, win.h, 0, 0, ART_COLOUR), win.x, win.y, win.w, win.h)   -- backdrop behind the model
    local art = holder()
    local model, cam = nil, nil
    if not locked then
        model, cam = addArt(art.inner, card, win, opts and opts.body)
    end
    if model == nil then
        label(art.inner, win.x, win.y, win.w - W, win.h, "?", locked and DIM_TEXT_COLOUR or rarityColour)
    end

    local frame = ui.Sprite.new(root)                            -- frame on top of the model
    frame:SetPos(0, 0)
    frame:SetSize(W, H)
    frame.sprite = frameImage
    if locked then
        frame.alpha = 0.5
    end
    part(frame, 0, 0, W, H)

    local text = holder()
    label(text.inner, zones.title.x, zones.title.y, zones.title.w - W, zones.title.h, card.name, nameColour)
    label(text.inner, zones.rarity.x, zones.rarity.y, zones.rarity.w - W, zones.rarity.h, rarity.name,
        locked and DIM_TEXT_COLOUR or rarityColour)
    label(text.inner, zones.desc.x, zones.desc.y, zones.desc.w - W, zones.desc.h,
        locked and "Not collected yet" or card.desc,
        locked and DIM_TEXT_COLOUR or DESC_COLOUR, ui.AlignMode.TOPLEFT, 3)
    if not animated then
        return model, cam
    end
    local uncover = { windows = { art, text }, w = W, h = H, x = win.x + win.w / 2, y = win.y + win.h / 2 }
    return model, cam, squash, uncover
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

-- Squeezes a card sideways to `f` (0 to 1) of its width, about its middle, as if it were turned
-- away. Only the frame and the backdrop behind the model narrow: the model and the text cannot
-- be squeezed, so hide them first with CardView.uncover(view, 0). Only a card made with
-- opts.animated and a frame image can be squeezed; for any other this returns false.
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
-- opts.frame = false skips the frame image and uses the plain layout (preview only).
-- opts.scale = a size other than CardView.SCALE (the preview uses it for a bigger card). The text
-- stays the same size; the picture, frame and layout scale.
-- opts.body = true/false forces the body or head model, whatever the card says (preview only).
-- opts.animated = true makes a card that can be flipped and revealed (CardView.squash and
-- CardView.uncover; the pack opening). Other cards are built without the extra layers that needs.
-- Returns { root = <Layer>, model = <Model or nil>, cam = <camera settings or nil>, card = <card data>,
-- squash, uncover = <what CardView.squash and CardView.uncover use, or nil> }.
function CardView.create(parent, card, opts)
    local S, W, H = metrics(opts and opts.scale)
    local locked = opts ~= nil and opts.locked == true

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
        local model, cam, squash, uncover = buildFramed(root, card, opts, locked, frameImage, rarity, rarityColour, S, W, H)
        return { root = root, model = model, cam = cam, card = card, squash = squash, uncover = uncover }
    end

    solid(root, 0, 0, 0, 0, 1.0, 1.0, frameColour)           -- frame
    solid(root, 4, 4, -8, -8, 1.0, 1.0, PANEL_COLOUR)        -- inner panel

    -- Plain layout, used when there is no frame image.
    label(root, 8, 8, -16, 22, card.name, nameColour)        -- name

    solid(root, 10, 34 * S, -20, 110 * S, 1.0, 0.0, ART_COLOUR)      -- art box
    local model, cam = nil, nil
    if not locked then
        model, cam = addArt(root, card, { x = 10, y = 34 * S, w = W - 20, h = 110 * S }, opts and opts.body)
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
        label(root, 10, 168 * S, -20, 48 * S, "Not collected yet", DIM_TEXT_COLOUR, ui.AlignMode.TOPLEFT, 3)
    else
        label(root, 10, 168 * S, -20, 48 * S, card.desc, DESC_COLOUR, ui.AlignMode.TOPLEFT, 3)
    end

    return { root = root, model = model, cam = cam, card = card }
end

return CardView
