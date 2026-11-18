-- ui/packart.lua
-- Draws a pack wrapper: a game login screen picture over the whole pack, crimps included, with
-- the pack's name on a banner and a logo. A pack's look is chosen in the Pack Maker
-- (dev/packmaker.lua), which gives a line to paste into deck/packs.lua.
--
-- A pack's look is a table:
--   art = {
--       screen = "RS3_LOGINSCREEN_POF_NXT",  -- the login screen: its tiles are <screen>_0, _1, ...
--       front = 0.0, back = 0.65,            -- where each side's window starts along the picture
--                                            -- (0 = its left edge, at most 1 - PackArt.WINDOW)
--       name = { title = "misthalin", x = 0, y = 226, w = 150 },  -- banner and title (front only)
--       logo = { sprite = "RS3_LOGINSCREEN_MOBILE_LOGO", x = 0, y = 40, w = 130 },  -- or nil
--   }
-- x, y and w are in pack units: the pack is PackArt.W x PackArt.H units whatever size it is drawn
-- (x moves an item from the middle, y is its top, w its width).
--
-- How it is drawn, and why (found in the game with a test plugin):
--   * Login screens come in 9 tiles (3 x 3), together a 16:9 picture; a cutscene picture is one
--     sprite, taken to be 16:9 as well (the client can't say). The picture is fitted to
--     the height of the pack's outline (not its box, which has empty margins), so all of it
--     shows top to bottom, and each side shows an outline-wide window of it, about a third.
--   * There is no masking, but layers clip what is inside them. So the pack's outline is traced
--     by strips (ui/packmask.lua), each a layer showing its part of the picture. The crimps are
--     narrow columns shifted up or down a little, so the art looks pinched there.
--   * The light and shadow (resources/images/pack_shading*.png) go on top; the back is mirrored
--     and has a seal seam.
--   * Text can't be scaled, so the titles are images (resources/images/title_<id>.png), drawn
--     ahead of time by dev/make_pack_art.py and shrunk to fit the banner's inner panel.
--   * The client says 0 x 0 for a sprite's size, so the shapes of the banner and logos (width /
--     height) are written below.
-- The mask, shading and titles are made by dev/make_pack_art.py.

local Packs = require("core/packs")
local Logger = require("core/logger")

local PackArt = {}

local MASK = require("ui/packmask")
local CardView = require("ui/cardview")
PackArt.TITLES = require("ui/packtitles")

PackArt.W, PackArt.H = MASK.w, MASK.h
PackArt.PICTURE_ASPECT = 16 / 9

-- The pack's outline inside its W x H box (pack.png has empty margins round the pack), in pack
-- units. The picture is fitted to the outline's height, so all of it shows, top to bottom.
PackArt.OUTLINE = (function()
    local x0, y0, x1, y1 = math.huge, math.huge, -math.huge, -math.huge
    for _, r in ipairs(MASK.rects) do
        x0, y0 = math.min(x0, r[1]), math.min(y0, r[2])
        x1, y1 = math.max(x1, r[1] + r[3]), math.max(y1, r[2] + r[4])
    end
    return { x = x0, y = y0, w = x1 - x0, h = y1 - y0 }
end)()

-- A side's window (the outline's width), as a fraction of the picture's width.
PackArt.WINDOW = PackArt.OUTLINE.w / (PackArt.OUTLINE.h * PackArt.PICTURE_ASPECT)

-- The banner the title sits on. inner = its dark middle panel, as fractions of the banner.
PackArt.BANNER = { sprite = "RS3_LEGACY_INTRO_LOGO_BACKGROUND", shape = 4.0, innerW = 0.70, innerH = 0.42 }
PackArt.LOGOS = {
    { sprite = "RS3_LOGINSCREEN_MOBILE_LOGO", shape = 2.2 },
    { sprite = "RS3_LOGO_MEDIUM", shape = 2.2 },
    { sprite = "RS3_LOGO_TINY", shape = 2.2 },
}

function PackArt.titleById(titleId)
    for _, t in ipairs(PackArt.TITLES) do
        if t.id == titleId then
            return t
        end
    end
    return nil
end

function PackArt.logoBySprite(sprite)
    for _, l in ipairs(PackArt.LOGOS) do
        if l.sprite == sprite then
            return l
        end
    end
    return nil
end

-- A sprite's id by name, or nil if the client doesn't know it (it gives -1 for an unknown name).
local function lookup(name)
    local ok, value = pcall(function() return id.Sprite[name] end)
    return (ok and type(value) == "number" and value >= 0) and value or nil
end

local spriteIds = {}

-- lookup, remembered, and logged once if the sprite is missing.
local function spriteId(name)
    if spriteIds[name] == nil then
        spriteIds[name] = lookup(name) or false
        if not spriteIds[name] then
            Logger.error("pack art: no sprite called", name)
        end
    end
    return spriteIds[name] or nil
end

local tilesByScreen = {}

-- The sprite ids of a picture's tiles: a login screen's <screen>_0, _1, ... while they exist, or,
-- for a picture that is one sprite (such as a cutscene background), that sprite. Nil if neither.
function PackArt.tiles(screen)
    if screen == nil then
        return nil
    end
    if tilesByScreen[screen] == nil then
        local list = {}
        for n = 0, 15 do
            local tile = lookup(screen .. "_" .. n)
            if tile == nil then
                break
            end
            list[#list + 1] = tile
        end
        if #list == 0 then
            list[1] = lookup(screen)
        end
        tilesByScreen[screen] = #list > 0 and list or false
    end
    return tilesByScreen[screen] or nil
end

-- True if this look (see the top of the file) can be drawn: the game has its picture.
function PackArt.canDraw(art)
    return art ~= nil and PackArt.tiles(art.screen) ~= nil
end

-- A pack type's look, if it has one that can be drawn; otherwise nil (it shows the plain pack
-- image, resources/images/pack.png, PACK_IMAGE_ASPECT wide for its height).
function PackArt.designFor(packTypeId)
    local packType = Packs.typeById(packTypeId)
    local art = packType and packType.art
    return PackArt.canDraw(art) and art or nil
end
PackArt.PACK_IMAGE_ASPECT = 320 / 512

-- The grid the tiles make: the columns x rows closest to the picture's shape.
local function gridFor(count)
    local bestC, bestErr = count, math.huge
    for c = 1, count do
        if count % c == 0 then
            local err = math.abs(math.log((c / (count / c)) / PackArt.PICTURE_ASPECT))
            if err < bestErr then
                bestC, bestErr = c, err
            end
        end
    end
    return bestC, count // bestC
end

local images = {}

-- An image from resources/images, loaded once, or nil (logged once). The pack window loads its
-- images through this too.
function PackArt.image(name)
    if images[name] == nil then
        local ok, resource = pcall(function() return Plugin.resources.images[name] end)
        if ok and resource ~= nil then
            pcall(function() resource:Load() end)
            images[name] = resource
        else
            Logger.error("no image resources/images/" .. name .. ".png")
            images[name] = false
        end
    end
    return images[name] or nil
end
local image = PackArt.image

-- Draws the picture's tiles into `container`, the picture filling (x, y, w, h). Tiles wholly
-- outside (0, 0, clipW, clipH) are not made. New parts go in `parts`, and (if given) where each
-- one was put goes in `rects`, as { x, y, w, h }, for PackArt.turn.
function PackArt.drawPicture(container, parts, tiles, x, y, w, h, clipW, clipH, rects)
    local cols, rows = gridFor(#tiles)
    local tw, th = w / cols, h / rows
    for i, tileId in ipairs(tiles) do
        local tx, ty = x + ((i - 1) % cols) * tw, y + ((i - 1) // cols) * th
        if clipW == nil or not (tx + tw < 0 or tx > clipW or ty + th < 0 or ty > clipH) then
            local tile = ui.Sprite.new(container)
            parts[#parts + 1] = tile
            tile.spriteID = tileId
            -- +1 so neighbouring tiles overlap by a pixel instead of leaving a seam
            local rect = { math.floor(tx), math.floor(ty), math.ceil(tw) + 1, math.ceil(th) + 1 }
            tile:SetPos(rect[1], rect[2])
            tile:SetSize(rect[3], rect[4])
            if rects ~= nil then
                rects[#parts] = rect
            end
        end
    end
end

-- Destroys every component in `list` and empties it.
function PackArt.destroyAll(list)
    for i = #list, 1, -1 do
        pcall(function() list[i]:Destroy() end)
        list[i] = nil
    end
end
local destroyAll = PackArt.destroyAll

-- Tearing a pack open: it tears across the top of the body, just under the top crimp, along a
-- jagged line about TEAR_Y pack units down. PackArt.new draws the two pieces: the cap (above the
-- line) and the body (the rest), which together look like the whole pack. Where the line runs,
-- the strips are cut into columns TEAR_COL wide, each ending at the line, and the shading, banner
-- and logo are shown through matching windows.
PackArt.TEAR_Y = 52
local TEAR_JAG = 3                     -- how far the line wanders above and below TEAR_Y
local TEAR_COL = 2
-- A turned pack (PackArt.turn) is drawn in upright columns this wide (pack units; PackArt.W must be a whole number
-- of them, so the back's mirrored columns fall on the same lines). Every strip and window is cut on the column lines,
-- and all of a column is scaled alike, so the picture, the shading, the banner and the logo in it move together.
local TURN_CHUNK = 25

local round = CardView.round

-- The column (0 first) that the whole pixel x is in, the columns being `columnW` pixels wide and their lines falling
-- on whole pixels (floored): the same lines the strips and windows are cut on.
local function columnAt(x, columnW)
    local k = math.floor(x / columnW)
    if math.floor((k + 1) * columnW) <= x then
        k = k + 1
    end
    return k
end

-- Where the tear crosses the column holding pack x (in pack units): jagged, but the same every time.
function PackArt.tearY(x)
    x = x - x % TEAR_COL
    return PackArt.TEAR_Y + math.floor(TEAR_JAG * (0.6 * math.sin(x * 0.9) + 0.4 * math.sin(x * 2.7 + 1.3)) + 0.5)
end

-- The highest and lowest the tear goes, in pack units. (The pack window flies the cap clear of
-- TEAR_MAX.)
local TEAR_MIN, TEAR_MAX = math.huge, -math.huge
for x = 0, PackArt.W - 1, TEAR_COL do
    TEAR_MIN, TEAR_MAX = math.min(TEAR_MIN, PackArt.tearY(x)), math.max(TEAR_MAX, PackArt.tearY(x))
end
PackArt.TEAR_MAX = TEAR_MAX

-- The mask's strips for a whole pack (piece nil) or one piece ("cap" or "body"), as
-- { x, y, w, h, dy }. A strip the tear runs through is cut in three: what is above the band the
-- tear can be in (the cap's), what is below it (the body's), and the band itself, cut into
-- columns that end at the line. Only the band is cut up, to keep the parts few.
local function pieceRects(piece)
    if piece == nil then
        return MASK.rects
    end
    local out = {}
    for _, r in ipairs(MASK.rects) do
        local x, y, w, h, dy = r[1], r[2], r[3], r[4], r[5]
        local bottom = y + h
        if piece == "cap" and y < TEAR_MIN then
            out[#out + 1] = { x, y, w, math.min(bottom, TEAR_MIN) - y, dy }
        elseif piece == "body" and bottom > TEAR_MAX then
            local top = math.max(y, TEAR_MAX)
            out[#out + 1] = { x, top, w, bottom - top, dy }
        end
        local bandTop, bandBottom = math.max(y, TEAR_MIN), math.min(bottom, TEAR_MAX)
        local cx = x
        while bandBottom > bandTop and cx < x + w do
            local nx = math.min(x + w, cx - cx % TEAR_COL + TEAR_COL)
            local tear = math.max(bandTop, math.min(bandBottom, PackArt.tearY(cx)))
            if piece == "cap" and tear > bandTop then
                out[#out + 1] = { cx, bandTop, nx - cx, tear - bandTop, dy }
            elseif piece == "body" and bandBottom > tear then
                out[#out + 1] = { cx, tear, nx - cx, bandBottom - tear, dy }
            end
            cx = nx
        end
    end
    return out
end

-- A pack, `height` pixels tall, inside `parent` (move it with pack.root:SetPos). `side` is
-- "front" or "back". `piece` (optional) draws only the "cap" or the "body" of the pack torn open
-- (see PackArt.tearY). Draw it with PackArt.draw. `turnable` true cuts it on TURN_CHUNK's column lines so PackArt.turn
-- can turn it: about twice the parts, so only a pack that turns has it (the reveal screen's sealed pack, not the Shop's).
function PackArt.new(parent, side, height, piece, turnable)
    local s = height / PackArt.H
    local w = math.floor(PackArt.W * s + 0.5)
    -- artRects holds where each of artParts was put, and artStrips the strip it is in (for PackArt.turn).
    local pack = { side = side, s = s, w = w, h = height, strips = {}, stripLayers = {},
        artParts = {}, topParts = {}, artRects = {}, artStrips = {}, columnW = turnable and TURN_CHUNK * s or nil }
    pack.root = ui.Layer.new(parent)
    pack.root:SetSize(w, height)
    -- Made in this order so the art is under the shading and the name and logo are on top.
    pack.art = ui.Layer.new(pack.root)
    pack.art:SetPos(0, 0)
    pack.art:SetSize(w, height)
    -- The strips that trace the outline depend only on the side and size, so they are made once
    -- here and only the picture's tiles inside them are redrawn.
    -- (a turnable pack's are cut on the column lines, see TURN_CHUNK)
    local rects = {}
    for _, r in ipairs(pieceRects(piece)) do
        local x, right = r[1], r[1] + r[3]
        while x < right do
            local nx = turnable and math.min(right, (x // TURN_CHUNK + 1) * TURN_CHUNK) or right
            rects[#rects + 1] = { x, r[2], nx - x, r[4], r[5] }
            x = nx
        end
    end
    for _, r in ipairs(rects) do
        local rx, ry, rw, rh, dy = r[1], r[2], r[3], r[4], r[5]
        if side == "back" then
            rx = PackArt.W - rx - rw
        end
        -- Whole pixels from the scaled edges, so neighbouring strips meet exactly.
        local x0, x1 = math.floor(rx * s), math.floor((rx + rw) * s)
        local y0, y1 = math.floor(ry * s), math.floor((ry + rh) * s)
        if x1 > x0 and y1 > y0 then
            local layer = ui.Layer.new(pack.art)
            layer:SetPos(x0, y0)
            layer:SetSize(x1 - x0, y1 - y0)
            pack.stripLayers[#pack.stripLayers + 1] = layer
            pack.strips[#pack.strips + 1] = { layer = layer, x = x0, y = y0, w = x1 - x0, h = y1 - y0, dy = dy * s,
                column = turnable and columnAt(x0, pack.columnW) or nil }
        end
    end
    local shading = image(side == "back" and "pack_shading_back" or "pack_shading")
    if piece == nil then
        local shade = ui.Sprite.new(pack.root)
        shade:SetPos(0, 0)
        shade:SetSize(w, height)
        if shading ~= nil then
            shade.sprite = shading
        end
        pack.shade = shade
    else
        -- A piece shows only its own part of the shading (and later the banner and logo, see
        -- addTop) through windows: one over the rows wholly its own, and one per column across
        -- the band the tear runs through, ending at the line.
        local shades = ui.Layer.new(pack.root)
        shades:SetSize(w, height)
        pack.windows = {}
        local function window(x, y, ww, hh)
            if ww <= 0 or hh <= 0 then
                return
            end
            -- (a turnable pack's are cut on the column lines, as its strips are)
            local column = nil
            if turnable then
                column = columnAt(x, pack.columnW)
                local line = math.floor((column + 1) * pack.columnW)      -- the next column line past x
                if x + ww > line then
                    window(x, y, line - x, hh)
                    window(line, y, x + ww - line, hh)
                    return
                end
            end
            local clip = ui.Layer.new(shades)
            clip:SetPos(x, y)
            clip:SetSize(ww, hh)
            local shade = ui.Sprite.new(clip)
            shade:SetPos(-x, -y)
            shade:SetSize(w, height)
            if shading ~= nil then
                shade.sprite = shading
            end
            pack.stripLayers[#pack.stripLayers + 1] = clip
            -- parts: what is inside the window, placed relative to it (for PackArt.turn).
            pack.windows[#pack.windows + 1] = { layer = clip, x = x, y = y, w = ww, h = hh, column = column,
                parts = { { shade, -x, -y, w, height } } }
        end
        local bandTop, bandBottom = math.floor(TEAR_MIN * s), math.floor(TEAR_MAX * s)
        if piece == "cap" then
            window(0, 0, w, bandTop)
        else
            window(0, bandBottom, w, height - bandBottom)
        end
        for cx = 0, PackArt.W - 1, TEAR_COL do
            local rx = (side == "back") and (PackArt.W - cx - TEAR_COL) or cx
            local x0, x1 = math.floor(rx * s), math.floor((rx + TEAR_COL) * s)
            local tear = math.floor(PackArt.tearY(cx) * s)
            if piece == "cap" then
                window(x0, bandTop, x1 - x0, tear - bandTop)
            else
                window(x0, tear, x1 - x0, bandBottom - tear)
            end
        end
    end
    pack.top = ui.Layer.new(pack.root)
    pack.top:SetPos(0, 0)
    pack.top:SetSize(w, height)
    return pack
end

-- The side's part of the login screen over the pack's outline.
function PackArt.drawArt(pack, art)
    destroyAll(pack.artParts)
    pack.artRects = {}
    pack.artStrips = {}        -- the strip each tile is in (for PackArt.turn)
    local tiles = PackArt.tiles(art.screen)
    if tiles == nil then
        return
    end
    local s, back = pack.s, pack.side == "back"
    -- The picture is as tall as the outline and starts at its top; the side's window starts at
    -- the outline's left edge (the back's outline is mirrored).
    local outline = PackArt.OUTLINE
    local ph = outline.h * s
    local pw = ph * PackArt.PICTURE_ASPECT
    local left = back and (PackArt.W - outline.x - outline.w) or outline.x
    local px = left * s - (back and art.back or art.front) * pw
    local py = outline.y * s
    for _, strip in ipairs(pack.strips) do
        local before = #pack.artParts
        PackArt.drawPicture(strip.layer, pack.artParts, tiles, px - strip.x, py - strip.y + strip.dy, pw, ph,
            strip.w, strip.h, pack.artRects)
        for i = before + 1, #pack.artParts do
            pack.artStrips[i] = strip
        end
    end
end

-- Puts a part on top of the pack (a game sprite `sprite`, or an image `picture`) at x, y, w, h
-- in pixels: in pack.top for a whole pack, or for a torn piece in each of its windows it
-- overlaps (see PackArt.new), so it is cut along the tear with the rest of the piece.
local function addTop(pack, sprite, picture, x, y, w, h)
    local function make(parent, ox, oy)
        local part = ui.Sprite.new(parent)
        pack.topParts[#pack.topParts + 1] = part
        if sprite ~= nil then
            part.spriteID = sprite
        else
            part.sprite = picture
        end
        part:SetPos(x - ox, y - oy)
        part:SetSize(w, h)
    end
    if pack.windows == nil then
        make(pack.top, 0, 0)
        return
    end
    for _, win in ipairs(pack.windows) do
        if x < win.x + win.w and x + w > win.x and y < win.y + win.h and y + h > win.y then
            make(win.layer, win.x, win.y)
            win.parts[#win.parts + 1] = { pack.topParts[#pack.topParts], x - win.x, y - win.y, w, h }
        end
    end
end

-- A sprite centred across the pack (moved by x), w wide and w / shape tall, its top at y.
-- All in pack units. Returns its rect in pixels, or nil if the sprite is unknown.
local function placeSprite(pack, name, shape, x, y, w)
    local sprite = spriteId(name)
    if sprite == nil then
        return nil
    end
    local s = pack.s
    local pxW, pxH = math.floor(w * s + 0.5), math.floor(w / shape * s + 0.5)
    local pxX, pxY = math.floor((PackArt.W - w) / 2 * s + x * s + 0.5), math.floor(y * s + 0.5)
    addTop(pack, sprite, nil, pxX, pxY, pxW, pxH)
    return pxX, pxY, pxW, pxH
end

-- The name (banner and title) and logo. Only the front has them.
function PackArt.drawTop(pack, art)
    destroyAll(pack.topParts)
    for _, win in ipairs(pack.windows or {}) do
        for i = #win.parts, 2, -1 do        -- all but the shading (the first)
            win.parts[i] = nil
        end
    end
    if pack.side ~= "front" then
        return
    end
    local name = art.name
    if name ~= nil then
        local banner = PackArt.BANNER
        local bx, by, bw, bh = placeSprite(pack, banner.sprite, banner.shape, name.x, name.y, name.w)
        local title = PackArt.titleById(name.title)
        local titleImage = title and image("title_" .. title.id)
        if bx ~= nil and titleImage ~= nil then
            -- Fitted inside the banner's inner panel, keeping its shape.
            local scale = math.min(bw * banner.innerW / title.w, bh * banner.innerH / title.h)
            local tw, th = math.floor(title.w * scale + 0.5), math.floor(title.h * scale + 0.5)
            addTop(pack, nil, titleImage, bx + (bw - tw) // 2, by + (bh - th) // 2, tw, th)
        end
    end
    local logo = art.logo and PackArt.logoBySprite(art.logo.sprite)
    if logo ~= nil then
        placeSprite(pack, logo.sprite, logo.shape, art.logo.x, art.logo.y, art.logo.w)
    end
end

function PackArt.draw(pack, art)
    PackArt.drawArt(pack, art)
    PackArt.drawTop(pack, art)
end

-- Turns a torn piece of a pack (see PackArt.new) about its upright middle line by `angle` radians (+ takes its right
-- edge away; pi / 2 is edge-on; 0 puts it back flat), in perspective as a turned card is (CardView.perspective): the
-- far edge shorter than the near one. Every strip and window covers its rect as near as an upright rect can, its
-- height scaled about the pack's middle by the scale at the middle of its column (TURN_CHUNK), so everything in a
-- column stays together; what is inside it is scaled with it. Nothing is redrawn.
function PackArt.turn(pack, angle)
    assert(pack.columnW ~= nil, "PackArt.turn needs a pack made turnable (PackArt.new)")
    local mid, midY, columnW = pack.w / 2, pack.h / 2, pack.columnW
    local sinA, cosA = math.sin(angle), math.cos(angle)
    local function project(x)          -- where the line x across the flat pack shows, and the scale there
        local offset, s = CardView.turnPoint(x - mid, sinA, cosA, pack.w)
        return mid + offset, s
    end
    local columnScale = {}
    -- Places a strip or window over its rect; returns how much it was scaled across and down.
    local function place(rec)
        local s = columnScale[rec.column]
        if s == nil then
            s = select(2, project((rec.column + 0.5) * columnW))
            columnScale[rec.column] = s
        end
        local X0, X1 = round(project(rec.x)), round(project(rec.x + rec.w))
        local Y0, Y1 = round(midY + (rec.y - midY) * s), round(midY + (rec.y + rec.h - midY) * s)
        rec.layer:SetPos(X0, Y0)
        rec.layer:SetSize(math.max(1, X1 - X0), math.max(1, Y1 - Y0))
        return math.max(1, X1 - X0) / rec.w, math.max(1, Y1 - Y0) / rec.h
    end
    for _, strip in ipairs(pack.strips) do
        strip.kx, strip.ky = place(strip)
    end
    -- A tile is placed inside its strip, which has already moved, so it is only scaled (with an extra pixel, as when it
    -- was drawn, so tiles still overlap).
    for i, tile in ipairs(pack.artParts) do
        local r, strip = pack.artRects[i], pack.artStrips[i]
        if r ~= nil and strip ~= nil then
            tile:SetPos(math.floor(r[1] * strip.kx), math.floor(r[2] * strip.ky))
            tile:SetSize(math.max(1, math.ceil(r[3] * strip.kx) + 1), math.max(1, math.ceil(r[4] * strip.ky) + 1))
        end
    end
    -- What is inside a window (the shading, banner and logo) is scaled with it, the window having already moved.
    for _, win in ipairs(pack.windows or {}) do
        local kx, ky = place(win)
        for _, part in ipairs(win.parts) do
            part[1]:SetPos(math.floor(part[2] * kx), math.floor(part[3] * ky))
            part[1]:SetSize(math.max(1, math.ceil(part[4] * kx)), math.max(1, math.ceil(part[5] * ky)))
        end
    end
end

function PackArt.destroy(pack)
    destroyAll(pack.artParts)
    destroyAll(pack.topParts)
    destroyAll(pack.stripLayers)
    pcall(function() pack.root:Destroy() end)
end

-- The front of a pack type's pack, `height` tall, in `parent`: { root, w, destroy() }. A pack type with a design is drawn
-- from it (hundreds of parts, so draw it once and keep it); any other shows the plain pack image.
function PackArt.drawFront(parent, packTypeId, height)
    local art = PackArt.designFor(packTypeId)
    if art ~= nil then
        local pack = PackArt.new(parent, "front", height)
        PackArt.draw(pack, art)
        return { root = pack.root, w = pack.w, destroy = function() PackArt.destroy(pack) end }
    end
    local w = math.floor(height * PackArt.PACK_IMAGE_ASPECT)
    local root = ui.Layer.new(parent)
    root:SetSize(w, height)
    local sprite = ui.Sprite.new(root)
    sprite:SetSize(w, height)
    local picture = PackArt.image("pack")
    if picture ~= nil then
        sprite.sprite = picture
    end
    return { root = root, w = w, destroy = function() pcall(function() root:Destroy() end) end }
end

local tileImages = {}

-- The picture shipped for a pack type's tile (resources/images/tile_<pack id>.png: a capture of what the code below draws
-- from the login screen, at 2.4 times the Shop's tile size), or nil if there is none. A pack type without one is drawn
-- from the login screen's sprites instead. Not logged when missing: that is how a new pack type starts.
local function tileImage(packTypeId)
    if tileImages[packTypeId] == nil then
        local ok, resource = pcall(function() return Plugin.resources.images["tile_" .. tostring(packTypeId)] end)
        if ok and resource ~= nil then
            pcall(function() resource:Load() end)
            tileImages[packTypeId] = resource
        else
            tileImages[packTypeId] = false
        end
    end
    return tileImages[packTypeId] or nil
end

-- A small flat picture of a pack type's pack for a list of packs, in a layer `height` tall and as wide as the pack's
-- outline: its shipped tile image if it has one (one sprite, and it loads at once), otherwise the part of the login
-- screen its front shows (one sprite per picture tile, not the hundreds of parts of the full pack, but the client
-- takes about 20 ms to load each). A pack type with no design gets the plain pack image. Returns { root, w, destroy() }.
function PackArt.drawTile(parent, packTypeId, height)
    local art = PackArt.designFor(packTypeId)
    local w = math.floor(height * PackArt.OUTLINE.w / PackArt.OUTLINE.h)
    local root = ui.Layer.new(parent)
    root:SetSize(w, height)
    local parts = {}
    local shipped = tileImage(packTypeId)
    if shipped ~= nil then
        local sprite = ui.Sprite.new(root)
        parts[#parts + 1] = sprite
        sprite:SetSize(w, height)
        sprite.sprite = shipped
    elseif art ~= nil then
        local pictureW = height * PackArt.PICTURE_ASPECT
        PackArt.drawPicture(root, parts, PackArt.tiles(art.screen), -math.floor(art.front * pictureW), 0, pictureW,
            height, w, height)
    else
        local sprite = ui.Sprite.new(root)
        sprite:SetSize(w, height)
        local picture = PackArt.image("pack")
        if picture ~= nil then
            sprite.sprite = picture
        end
    end
    return { root = root, w = w, destroy = function() destroyAll(parts); pcall(function() root:Destroy() end) end }
end

return PackArt
