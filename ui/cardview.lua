-- ui/cardview.lua
-- Draws a card from its data with live UI components: the frame image on top, its art window showing the NPC or item
-- through a camera, and the name, rarity and description over the frame's panels (160 x 224 units at scale 1).

local Cards = require("core/cards")
local Logger = require("core/logger")
local Settings = require("core/settings")
local Config = require("core/config")
local CardArt = require("ui/cardart")
local CardFinish = require("ui/cardfinish")
local Util = require("ui/util")

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

local SILHOUETTE_BACK = Vector4.new(0.16, 0.16, 0.20, 1.0)

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
        CardFinish.addHolo(art.inner, win)
    end
    local model, cam = nil, nil
    if not locked or silhouette then
        model, cam = CardArt.add(art.inner, card, win, silhouette)
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
        for _, sprite in ipairs(CardFinish.addShine(root, W, H) or {}) do
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
--   finish "foil" draws the shine over the card (CardFinish.SHINE), "holo" the rainbow behind
--     the picture (CardFinish.HOLO); not for locked cards
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
        Util.toVec4(rarity.colour), S, W, H)
    view.root, view.card = root, card
    return view
end

return CardView
