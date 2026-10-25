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

local PackArt = {}

local MASK = require("ui/packmask")
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
            log("pack art: no sprite called", name)
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
            log("no image resources/images/" .. name .. ".png")
            images[name] = false
        end
    end
    return images[name] or nil
end
local image = PackArt.image

-- Draws the picture's tiles into `container`, the picture filling (x, y, w, h). Tiles wholly
-- outside (0, 0, clipW, clipH) are not made. New parts go in `parts`.
function PackArt.drawPicture(container, parts, tiles, x, y, w, h, clipW, clipH)
    local cols, rows = gridFor(#tiles)
    local tw, th = w / cols, h / rows
    for i, tileId in ipairs(tiles) do
        local tx, ty = x + ((i - 1) % cols) * tw, y + ((i - 1) // cols) * th
        if clipW == nil or not (tx + tw < 0 or tx > clipW or ty + th < 0 or ty > clipH) then
            local tile = ui.Sprite.new(container)
            parts[#parts + 1] = tile
            tile.spriteID = tileId
            -- +1 so neighbouring tiles overlap by a pixel instead of leaving a seam
            tile:SetPos(math.floor(tx), math.floor(ty))
            tile:SetSize(math.ceil(tw) + 1, math.ceil(th) + 1)
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

-- A pack, `height` pixels tall, inside `parent` (move it with pack.root:SetPos). `side` is
-- "front" or "back". Draw it with PackArt.draw.
function PackArt.new(parent, side, height)
    local s = height / PackArt.H
    local w = math.floor(PackArt.W * s + 0.5)
    local pack = { side = side, s = s, w = w, h = height, strips = {}, stripLayers = {}, artParts = {}, topParts = {} }
    pack.root = ui.Layer.new(parent)
    pack.root:SetSize(w, height)
    -- Made in this order so the art is under the shading and the name and logo are on top.
    pack.art = ui.Layer.new(pack.root)
    pack.art:SetPos(0, 0)
    pack.art:SetSize(w, height)
    -- The strips that trace the outline depend only on the side and size, so they are made once
    -- here and only the picture's tiles inside them are redrawn.
    for _, r in ipairs(MASK.rects) do
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
            pack.strips[#pack.strips + 1] = { layer = layer, x = x0, y = y0, w = x1 - x0, h = y1 - y0, dy = dy * s }
        end
    end
    local shade = ui.Sprite.new(pack.root)
    shade:SetPos(0, 0)
    shade:SetSize(w, height)
    local shading = image(side == "back" and "pack_shading_back" or "pack_shading")
    if shading ~= nil then
        shade.sprite = shading
    end
    pack.top = ui.Layer.new(pack.root)
    pack.top:SetPos(0, 0)
    pack.top:SetSize(w, height)
    return pack
end

-- The side's part of the login screen over the pack's outline.
function PackArt.drawArt(pack, art)
    destroyAll(pack.artParts)
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
        PackArt.drawPicture(strip.layer, pack.artParts, tiles, px - strip.x, py - strip.y + strip.dy, pw, ph,
            strip.w, strip.h)
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
    local part = ui.Sprite.new(pack.top)
    pack.topParts[#pack.topParts + 1] = part
    part.spriteID = sprite
    part:SetPos(pxX, pxY)
    part:SetSize(pxW, pxH)
    return pxX, pxY, pxW, pxH
end

-- The name (banner and title) and logo. Only the front has them.
function PackArt.drawTop(pack, art)
    destroyAll(pack.topParts)
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
            local part = ui.Sprite.new(pack.top)
            pack.topParts[#pack.topParts + 1] = part
            part.sprite = titleImage
            part:SetPos(bx + (bw - tw) // 2, by + (bh - th) // 2)
            part:SetSize(tw, th)
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

function PackArt.destroy(pack)
    destroyAll(pack.artParts)
    destroyAll(pack.topParts)
    destroyAll(pack.stripLayers)
    pcall(function() pack.root:Destroy() end)
end

return PackArt
