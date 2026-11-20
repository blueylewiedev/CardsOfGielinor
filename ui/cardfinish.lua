-- ui/cardfinish.lua
-- What makes a card foil or holo: the holo's rainbow behind the picture and the foil's drifting shine over the whole card. ui/cardview.lua
-- adds them while it builds a card.

local Config = require("core/config")
local Logger = require("core/logger")
local Events = require("core/events")

local CardFinish = {}

-- Holo: a ui.Canvas over the art box's backdrop and under the picture (models draw over 2D components), a see-through
-- rainbow in diagonal bands. A canvas gradient only runs straight across or down, so the bands are thin one-colour
-- stripes of triangles, stepping round the hues. It is drawn once, in the art window, so it is revealed with the
-- picture (CardView.uncover).
CardFinish.HOLO = {
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
    local f = CardFinish.HOLO
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
-- They depend only on the size and CardFinish.HOLO, so each size is worked out once (a page of holo cards shares them).
local holoTriangles = {}

local function holoStripes(w, h)
    local key = w .. "x" .. h
    if holoTriangles[key] ~= nil then
        return holoTriangles[key]
    end
    local f = CardFinish.HOLO
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
function CardFinish.addHolo(parent, box)
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
CardFinish.SHINE = {
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
function CardFinish.addShine(parent, W, H)
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
        made[1].alpha = CardFinish.SHINE.alpha * math.sin(offset) ^ 2
        made[2].alpha = CardFinish.SHINE.alpha * math.cos(offset) ^ 2
        return made
    end)
    if not ok then
        Logger.error("card shine failed:", tostring(sprites))
        return nil
    end
    shines[#shines + 1] = { a = sprites[1], b = sprites[2], offset = offset }
    if #shines > CardFinish.SHINE.most then
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
    local t = CardFinish.SHINE
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

return CardFinish
