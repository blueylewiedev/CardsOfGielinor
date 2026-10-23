-- ui/cardview.lua
-- Draws a card from its data using live UI components (no image files needed).
--
-- Layout (all sizes in interface units), 160 x 224. With a frame image (the normal case):
--   frame image on top, its art window showing the NPC through a camera, and the name,
--   rarity and description drawn over the frame's panels. Without one (the image is missing)
--   a plain rectangle layout is used instead.

local Cards = require("core/cards")
local Settings = require("core/settings")

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
-- Anything left out uses these defaults. NPCs with no chathead use `art.body = true`, which
-- shows the whole body model, so they have their own defaults (the body is much bigger).
CardView.CAMERA_DEFAULTS = {
    head = { yaw = 0.0, pitch = 0.0, dist = 2040, fov = 55, ty = 0, tx = 0 },
    body = { yaw = 0.0, pitch = 0.0, dist = 1500, fov = 50, ty = 0, tx = 0 },
}

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
local function applyCamera(cam)
    local camera = newCamera()
    camera:SetFOV(cam.fov, 0)
    -- The camera orbits the look-at point. tx slides that point sideways (along the camera's
    -- right-hand direction) and the camera moves with it, so the NPC shifts across the card
    -- without changing angle or size.
    local targetX = cam.tx * math.cos(cam.yaw)
    local targetZ = cam.tx * math.sin(cam.yaw)
    local x = targetX + cam.dist * math.sin(cam.yaw) * math.cos(cam.pitch)
    local y = cam.ty + cam.dist * math.sin(cam.pitch)
    local z = targetZ - cam.dist * math.cos(cam.yaw) * math.cos(cam.pitch)
    camera:SetPosition(Vector3.new(x, y, z), 0)
    camera:SetLookAt(Vector3.new(targetX, cam.ty, targetZ), 0)
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

-- Shows the card's NPC inside the art box `box` = { x, y, w, h }. Returns the model and the
-- `cam` table (the camera settings, which applyCamera can re-apply), or nil if the NPC could
-- not be shown. If the camera cannot be set up, a plain model is shown instead (no `cam`).
local function addArt(parent, card, box, bodyOverride)
    local art = Cards.getArt(card)
    -- Developer-saved settings (from the preview's Save button) sit on top of the card's own.
    -- Only the development tools set CardView.artOverride; it is nil in the released plugin.
    local saved = CardView.artOverride and CardView.artOverride(card.id) or nil
    if saved ~= nil then
        art.body = saved.body
        art.cam = saved.cam
        art.anim = saved.anim
    end
    -- `bodyOverride` (true/false, from the preview) beats the card's own setting.
    local body = art.body
    if bodyOverride ~= nil then
        body = bodyOverride
    end
    local ok, npcID = pcall(function() return id.NPC[art.npc] end)
    if not ok or not Cards.isValidNpcId(npcID) then
        log("card art: NPC not found for", card.id, art.npc, "->", tostring(npcID))
        return nil
    end
    local modelType = ui.ModelType[body and "NPC_MODEL" or "NPC_HEAD"]

    local built, model, cam = pcall(function()
        local group = ui.ModelGroup.new(parent)
        group:SetPos(box.x, box.y)
        group:SetSize(box.w, box.h)
        local child = ui.Model.new(group)
        child:SetSize(box.w, box.h)
        child:SetModel(modelType, npcID)

        local state = { group = group, body = body == true, anim = art.anim }
        if art.anim ~= nil then
            CardView.playAnimation(child, art.anim)
        end
        local defaults = CardView.CAMERA_DEFAULTS[body and "body" or "head"]
        -- The card's own camera values belong to its own model type, so they are ignored when
        -- the preview has switched to the other one.
        local own = ((body == true) == (art.body == true)) and art.cam or {}
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
    local shown, err = pcall(function() plain:SetModel(modelType, npcID) end)
    if not shown then
        log("card art: SetModel failed for", card.id, err)
        plain:Destroy()
        return nil
    end
    plain.modelWidth = box.w
    plain.modelHeight = box.h
    plain.viewDistance = body and 1500 or 1000
    return plain
end


-- Holo and reverse holo shine.
-- A holo card has a shimmering rainbow sheen over its art; a reverse holo has it over the frame
-- instead. Both are made of two translucent images that are cross-faded back and forth, which
-- makes the bands and sparkles seem to drift. The images are in resources/images:
--   holo_a / holo_b                     stretched over the art window
--   reverse_<rarity>_a / _b             the size of the card, shaped like that rarity's frame
-- If an image is missing the card is drawn without the shine.
CardView.SHINE = true
local SHINE_SPEED = 1.4          -- cross-fade speed (radians per second)
local HOLO_ALPHA = 0.85          -- brightness of the shine over the art
local REVERSE_ALPHA = 0.8        -- brightness of the shine over the frame
local MAX_SHINES = 60            -- how many shining cards are animated at once

local imageCache = {}            -- image name -> resource, or false if it is missing

-- Loads an image from resources/images, once. Returns nil (and logs) if it is not there.
local function loadImage(name)
    local cached = imageCache[name]
    if cached ~= nil then
        return cached or nil
    end
    local ok, resource = pcall(function() return Plugin.resources.images[name] end)
    if not ok or resource == nil then
        log("card shine: no image resources/images/" .. name .. ".png")
        imageCache[name] = false
        return nil
    end
    pcall(function() resource:Load() end)
    imageCache[name] = resource
    return resource
end

local shines = {}                -- every shine being animated: { a, b, base, offset }
local shineClock = 0

-- Adds a shine of two sprites (cross-faded) at x, y with size w x h, in `parent`.
local function addShine(parent, imageA, imageB, x, y, w, h, base)
    local sprites = {}
    for _, image in ipairs({ imageA, imageB }) do
        local sprite = ui.Sprite.new(parent)
        sprite:SetPos(x, y)
        sprite:SetSize(w, h)
        sprite.sprite = image
        sprite.alpha = 0.0
        sprites[#sprites + 1] = sprite
    end
    -- Each card starts at a different point, so a page of holos does not pulse in step.
    shines[#shines + 1] = { a = sprites[1], b = sprites[2], base = base, offset = math.random() * 6.28 }
    if #shines > MAX_SHINES then
        table.remove(shines, 1)
    end
end

-- Runs every frame. A card that has been destroyed makes its sprites error, which removes it.
local function onShineDraw(e)
    local ok, dt = pcall(function() return e.timeDeltaSecs end)
    if not ok or type(dt) ~= "number" then
        dt = 0.016
    end
    shineClock = shineClock + dt
    local i = 1
    while i <= #shines do
        local shine = shines[i]
        local theta = shineClock * SHINE_SPEED + shine.offset
        local alive = pcall(function()
            shine.a.alpha = shine.base * math.sin(theta) ^ 2
            shine.b.alpha = shine.base * math.cos(theta) ^ 2
        end)
        if alive then
            i = i + 1
        else
            table.remove(shines, i)
        end
    end
end

Event.Draw.Subscribe("cardcollector_shine", onShineDraw)

-- A frame zone scaled by CardView.SCALE. The zone tables are in 160 x 224 card units.
local function scaled(zone)
    return { x = zone.x * S, y = zone.y * S, w = zone.w * S, h = zone.h * S }
end

-- (label() sizes are an offset from the full parent width, hence `w - CardView.WIDTH`.)
-- Builds a card that uses a frame image. Order matters: whatever is created later is drawn on
-- top, so the backdrop and the model go first, then the frame, then the text.
local function buildFramed(root, card, opts, locked, frameImage, rarity, rarityColour)
    local base = CardView.FRAME_ZONES
    local zones = { title = scaled(base.title), rarity = scaled(base.rarity), desc = scaled(base.desc) }
    local win = scaled(base.window[card.rarity] or base.window.common)
    local nameColour = locked and DIM_TEXT_COLOUR or TEXT_COLOUR

    solid(root, win.x, win.y, win.w, win.h, 0, 0, ART_COLOUR)   -- backdrop behind the model
    local model, cam = nil, nil
    if not locked then
        model, cam = addArt(root, card, win, opts and opts.body)
    end
    -- Holo: the shine goes over the art, under the frame.
    local finish = (opts and opts.finish) or "normal"
    if CardView.SHINE and Settings.get("shine") and not locked and finish == "holo" then
        local a, b = loadImage("holo_a"), loadImage("holo_b")
        if a ~= nil and b ~= nil then
            addShine(root, a, b, win.x, win.y, win.w, win.h, HOLO_ALPHA)
        end
    end
    if model == nil then
        label(root, win.x, win.y, win.w - CardView.WIDTH, win.h, "?", locked and DIM_TEXT_COLOUR or rarityColour)
    end

    local frame = ui.Sprite.new(root)                            -- frame on top of the model
    frame:SetPos(0, 0)
    frame:SetSize(CardView.WIDTH, CardView.HEIGHT)
    frame.sprite = frameImage
    if locked then
        frame.alpha = 0.5
    end
    -- Reverse holo: the shine goes over the frame, under the text.
    if CardView.SHINE and Settings.get("shine") and not locked and finish == "reverse" then
        local a = loadImage("reverse_" .. card.rarity .. "_a")
        local b = loadImage("reverse_" .. card.rarity .. "_b")
        if a ~= nil and b ~= nil then
            addShine(root, a, b, 0, 0, CardView.WIDTH, CardView.HEIGHT, REVERSE_ALPHA)
        end
    end

    label(root, zones.title.x, zones.title.y, zones.title.w - CardView.WIDTH, zones.title.h, card.name, nameColour)
    label(root, zones.rarity.x, zones.rarity.y, zones.rarity.w - CardView.WIDTH, zones.rarity.h, rarity.name,
        locked and DIM_TEXT_COLOUR or rarityColour)
    label(root, zones.desc.x, zones.desc.y, zones.desc.w - CardView.WIDTH, zones.desc.h,
        locked and "Not collected yet" or card.desc,
        locked and DIM_TEXT_COLOUR or DESC_COLOUR, ui.AlignMode.TOPLEFT, 3)
    return model, cam
end

-- Builds a card inside `parent` at the top-left (call :SetPos on the result to move it).
-- `opts` is optional.
-- opts.locked = true draws a placeholder for a card the player does not own yet: dimmed,
-- with a "?" instead of the art and no description.
-- opts.frame = false skips the frame image and uses the plain layout (preview only).
-- opts.finish = "normal" (default), "reverse" or "holo" adds the shine for that finish.
-- opts.body = true/false forces the body or head model, whatever the card says (preview only).
-- Returns { root = <Layer>, model = <Model or nil>, cam = <camera settings or nil>, card = <card data> }.
function CardView.create(parent, card, opts)
    local locked = opts ~= nil and opts.locked == true

    local rarity = Cards.rarities[card.rarity]
    local rarityColour = toVec4(rarity.colour)
    local frameColour = locked and toVec4(rarity.colour, 0.35) or rarityColour
    local nameColour = locked and DIM_TEXT_COLOUR or TEXT_COLOUR

    local root = ui.Layer.new(parent)
    root:SetSize(CardView.WIDTH, CardView.HEIGHT)

    -- With a frame image the card is built from the image alone. (A coloured rectangle behind
    -- it would show at the edges, and gives the rarity away when something sits on top of
    -- the card, like the card back in the pack opening.)
    local frameImage = CardView.frameResource(card.rarity)
    if frameImage ~= nil and not (opts and opts.frame == false) then
        local model, cam = buildFramed(root, card, opts, locked, frameImage, rarity, rarityColour)
        return { root = root, model = model, cam = cam, card = card }
    end

    solid(root, 0, 0, 0, 0, 1.0, 1.0, frameColour)           -- frame
    solid(root, 4, 4, -8, -8, 1.0, 1.0, PANEL_COLOUR)        -- inner panel

    -- Plain layout, used when there is no frame image.
    label(root, 8, 8, -16, 22, card.name, nameColour)        -- name

    solid(root, 10, 34 * S, -20, 110 * S, 1.0, 0.0, ART_COLOUR)      -- art box
    local model, cam = nil, nil
    if not locked then
        model, cam = addArt(root, card, { x = 10, y = 34 * S, w = CardView.WIDTH - 20, h = 110 * S }, opts and opts.body)
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
