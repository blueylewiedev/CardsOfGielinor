-- ui/carousel.lua
-- The pack chooser on the Home screen: the chosen pack drawn large between two arrows. An arrow
-- slides the next or previous pack in, and Carousel.slideTo slides straight to a pack (for the
-- drop-down above it).
--
-- A pack type with a design (made in the Pack Maker, see ui/packart.lua) is drawn from it; any
-- other shows the pack image. The packs are drawn once and then only moved while they slide, as
-- drawing a designed pack makes hundreds of parts.

local PackArt = require("ui/packart")
local Kit = require("ui/kit")
local Anim = require("ui/anim")

local Carousel = {}

local SLIDE_SECONDS = 0.3
local ARROW_W = 24                     -- PrettyUI's sprite buttons are 24 x 24
local ARROW_GAP = 4                    -- between an arrow and the area the packs slide in

-- The front of a pack, `height` tall, in `parent`: { root, w, destroy() }.
local function drawPack(parent, packTypeId, height)
    local art = PackArt.designFor(packTypeId)
    if art ~= nil then
        local pack = PackArt.new(parent, "front", height)
        PackArt.draw(pack, art)
        return { root = pack.root, w = pack.w, destroy = function() PackArt.destroy(pack) end }
    end
    -- No design: the pack image.
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

-- Puts a drawn pack `offset` from the middle of the stage.
local function place(c, pack, offset)
    pack.root:SetPos(math.floor((c.stageW - pack.w) / 2 + offset + 0.5), 0)
end

-- Makes a carousel in `parent`, with its top-left at x, y, `w` wide and `h` tall (the packs are
-- drawn h tall). `packIds` is the list of pack type ids to go round, `selected` the one shown
-- first, and onChange(packTypeId) is called when another is slid in.
function Carousel.new(parent, x, y, w, h, packIds, selected, onChange)
    local c = { ids = packIds, h = h, onChange = onChange, index = 1 }
    for i, packTypeId in ipairs(packIds) do
        if packTypeId == selected then
            c.index = i
        end
    end
    -- The packs slide inside this layer, which crops them, so they vanish behind the arrows.
    local stageX = ARROW_W + ARROW_GAP
    c.stageW = w - 2 * stageX
    c.stage = ui.Layer.new(parent)
    c.stage:SetPos(x + stageX, y)
    c.stage:SetSize(c.stageW, h)

    local arrowY = y + (h - ARROW_W) // 2
    c.arrows = {
        Kit.iconButton(parent, "ARROW_LEFT", x, arrowY, function() Carousel.slide(c, -1) end, "Previous pack", "<lt>", ARROW_W),
        Kit.iconButton(parent, "ARROW_RIGHT", x + w - ARROW_W, arrowY, function() Carousel.slide(c, 1) end, "Next pack", "<gt>", ARROW_W),
    }
    c.current = drawPack(c.stage, packIds[c.index], h)
    place(c, c.current, 0)
    return c
end

-- Slides the pack at `index` in, from the right (dir = 1) or the left (dir = -1).
local function slideIn(c, index, dir)
    Anim.skip(c)
    c.index = index
    local old = c.current
    local new = drawPack(c.stage, c.ids[index], c.h)
    place(c, new, dir * c.stageW)
    c.current = new
    Anim.start(c, SLIDE_SECONDS, function(p)
        local e = Anim.smooth(p)
        place(c, old, -dir * c.stageW * e)
        place(c, new, dir * c.stageW * (1 - e))
    end, old.destroy)
    if c.onChange ~= nil then
        c.onChange(c.ids[index])
    end
end

-- Slides the next pack (dir = 1) or the previous one (dir = -1) in, going round at the ends.
function Carousel.slide(c, dir)
    if #c.ids < 2 then
        return
    end
    slideIn(c, (c.index - 1 + dir) % #c.ids + 1, dir)
end

-- Slides straight to a pack type (from whichever side it is on in the list).
function Carousel.slideTo(c, packTypeId)
    for i, id in ipairs(c.ids) do
        if id == packTypeId and i ~= c.index then
            slideIn(c, i, (i > c.index) and 1 or -1)
            return
        end
    end
end

function Carousel.destroy(c)
    Anim.cancel(c)
    if c.current ~= nil then
        c.current.destroy()
        c.current = nil
    end
    pcall(function() c.stage:Destroy() end)
    for _, arrow in ipairs(c.arrows) do
        pcall(function() arrow:Destroy() end)
    end
end

return Carousel
