-- ui/revealpack.lua
-- The sealed pack of the pack opening: a pack type with a design (made in the Pack Maker) is drawn as two pieces that tear
-- apart, lifts and glows under the mouse, can be flipped over (Flip pack) and is torn by a click or by dragging across its
-- top; any other pack is an image that swells and fades. ui/revealscreen.lua runs the stages around it and says what to
-- do when the pack is gone; ui/revealcards.lua has the cards that come out of it.
--
-- Every function takes `R`, the reveal under way (its fields are listed in ui/revealscreen.lua), and the ones that change
-- the stage take `ev`: { changed = a function to call when the controls need redrawing, opened = a function to call once
-- the pack is gone and the cards are in a stack }. The pack's parts are in R.tear (a designed pack) or R.pack (an image).
--
-- The client keeps an event handler after its component is destroyed, so the handlers here hold only `tear`, which is
-- emptied (Util.emptied) when its parts are destroyed, and `R`, which is emptied when the reveal closes.

local Anim = require("ui/anim")
local Kit = require("ui/kit")
local PackArt = require("ui/packart")
local RevealCards = require("ui/revealcards")
local Util = require("ui/util")
local setHidden, destroy, emptied = Util.setHidden, Util.destroy, Util.emptied

local RevealPack = {}

local HOVER_LIFT, HOVER_SECONDS = 10, 0.15
local HOVER_GLOW_PAD, HOVER_GLOW_ALPHA = 8, 0.4   -- the hover glow: how far it reaches past the pack, and how bright
local SWELL_SECONDS = 0.45              -- a pack without a design: it swells and fades
local RIP_SECONDS = 0.45                -- the tear running across, when it isn't dragged
local CAP_SECONDS = 0.35
local DROP_SECONDS = 0.55               -- starts halfway through the cap flying off
local SETTLE_SECONDS = 0.3
local PEEL_LIFT = 10                    -- how far the torn cap lifts behind the tear, in pixels
local PEEL_W = 0.35                     -- over how much of the pack's width (behind the tear) it lifts
local DRAG_FINISH = 0.6                 -- let go after dragging this far and the tear finishes itself
local GRIP_H = 80                       -- the part of the pack (pack units from the top) to drag across
local STACK_W = 0.72                    -- the cards inside the pack, as a fraction of its width
local STACK_TOP = 66                    -- where they start, in pack units from the top (under the tear)
local GUIDE_H = 24
local GUIDE_PULSE = 3                   -- radians per second
local GLINT_EVERY, GLINT_SECONDS = 1.6, 0.9
local GLINT_SIZE = 20
local SEALED_FLIP_SECONDS = 0.4         -- turning the sealed pack over (Flip pack); edge-on halfway
local FLIP_ICON = 24                    -- the Flip pack button (PrettyUI's sprite buttons are 24 x 24)

local image = PackArt.image

-- The Flip pack button: a small refresh arrow under a designed sealed pack, while the pack is untouched. `onFlip` is what
-- pressing it does.
local function setFlipButton(R, shown, onFlip)
    if R.flipButton ~= nil then
        destroy(R.flipButton)
        R.flipButton = nil
    end
    if shown then
        local tear = R.tear
        R.flipButton = Kit.iconButton(R.root, "REFRESH", (R.SW - FLIP_ICON) // 2, tear.y0 + tear.h + 10, onFlip, "Flip pack")
    end
end

-- Moves the pack and what goes with it (its glow, the tear guide, the cards inside) to `lift` pixels above its place.
local function setLift(R, lift)
    local tear = R.tear
    tear.lift = lift
    tear.y = tear.y0 - lift
    tear.body.root:SetPos(tear.x, tear.y)
    if tear.rip < 1 and not tear.torn then
        tear.cap.root:SetPos(tear.x, tear.y)
    end
    if tear.glow ~= nil then
        tear.glow:SetPos(tear.x - HOVER_GLOW_PAD, tear.y - HOVER_GLOW_PAD)   -- (it lifts with the pack, so it stays even round it)
    end
end

-- The guide's place for the tear `cut` pixels across.
local function placeGuide(R, guide, cut)
    local tear = R.tear
    guide.y = tear.y + math.floor(PackArt.TEAR_Y * tear.cap.s) - GUIDE_H // 2
    guide.clip:SetPos(tear.x + cut, guide.y)
end

-- Shows the tear `rip` (0 to 1) of the way across the pack: the cap's columns behind the tear lift, the furthest behind
-- the most, so the cap peels up.
local function drawRip(R, rip)
    local tear = R.tear
    tear.rip = rip
    if rip > 0 and R.flipButton ~= nil then
        setFlipButton(R, false)                -- too late to turn it over
    end
    local w = tear.w
    local front = rip * (1 + PEEL_W) * w
    for _, strip in ipairs(tear.cap.strips) do
        local behind = math.max(0, math.min(1, (front - strip.x - strip.w / 2) / (PEEL_W * w)))
        strip.layer:SetPos(strip.x, strip.y - math.floor(PEEL_LIFT * behind * behind + 0.5))
    end
    -- The guide only shows ahead of the tear.
    local guide = tear.guide
    if guide ~= nil then
        local cut = math.min(w, math.floor(front))
        setHidden(guide.clip, cut >= w)
        placeGuide(R, guide, cut)
        guide.clip:SetSize(math.max(1, w - cut), GUIDE_H)
        guide.inner:SetPos(-cut, 0)
        tear.cut = cut
    end
end

-- Pulses the tear guide and runs its glint along it (every frame while the pack is sealed).
local function animateGuide(R)
    local guide = R.tear.guide
    if guide == nil then
        return
    end
    local clock = R.clock
    guide.line.alpha = 0.6 + 0.4 * math.sin(clock * GUIDE_PULSE)
    if guide.glint ~= nil then
        local phase = clock % GLINT_EVERY
        if phase < GLINT_SECONDS then
            local f = phase / GLINT_SECONDS
            guide.glint:SetPos(f * R.tear.w - GLINT_SIZE / 2, (GUIDE_H - GLINT_SIZE) / 2)
            guide.glint.alpha = math.sin(f * math.pi)
            pcall(function() guide.glint.rotationDegrees = 180 * f end)
        else
            guide.glint.alpha = 0
        end
    end
end

-- Places the stack of cards: inside the pack (hidden behind it) at settle = 0, grown into the grid's stack at 1. The
-- cards behind the front one sit a little higher.
local function placeStack(R, settle)
    local tear = R.tear
    local sw = math.floor(tear.w * STACK_W)
    local sh = math.floor(sw * R.ch / R.cw)
    local fromX, fromY = tear.x + (tear.w - sw) / 2, tear.y0 + STACK_TOP * tear.cap.s
    local w, h = sw + (R.cw - sw) * settle, sh + (R.ch - sh) * settle
    local x, y = fromX + (R.stackX - fromX) * settle, fromY + (R.stackY - fromY) * settle
    RevealCards.placeStack(R, x, y, w, h)
end

-- Tears the designed pack open from wherever the tear has got to: the rest of the tear, the cap flying off up and to the
-- right, the pack dropping away below the stack of cards, and the stack growing into place. Then ev.opened().
local function startTear(R, ev)
    local tear = R.tear
    if tear == nil or R.stage ~= "sealed" or Anim.running(R) then
        return
    end
    R.stage = "tearing"
    tear.torn = true
    if tear.glow ~= nil then
        setHidden(tear.glow, true)
    end
    setFlipButton(R, false)
    ev.changed()
    local from = tear.rip
    local ripEnd = RIP_SECONDS * (1 - from)
    local dropStart = ripEnd + CAP_SECONDS / 2
    local dropEnd = dropStart + DROP_SECONDS
    local total = dropEnd + SETTLE_SECONDS
    local capH = math.floor(PackArt.TEAR_MAX * tear.cap.s) + PEEL_LIFT
    local function phase(t, start, length)
        return math.max(0, math.min(1, (t - start) / length))
    end
    Anim.start(R, total, function(p)
        local t = p * total
        if tear.rip < 1 then
            drawRip(R, from + (1 - from) * phase(t, 0, ripEnd))
        end
        -- The cap speeds up as it goes, until it is out of the top of the screen.
        local cap = phase(t, ripEnd, CAP_SECONDS) ^ 2
        tear.cap.root:SetPos(tear.x + math.floor(70 * cap), tear.y - math.floor((tear.y + capH) * cap))
        -- The pack drops out of the bottom of the screen, uncovering the cards.
        local drop = phase(t, dropStart, DROP_SECONDS) ^ 2
        tear.body.root:SetPos(tear.x, tear.y + math.floor((R.SH - tear.y) * drop))
        placeStack(R, Anim.smooth(phase(t, dropEnd, SETTLE_SECONDS)))
    end, function()
        for _, piece in ipairs(R.packArts or {}) do
            PackArt.destroy(piece)
        end
        R.packArts = {}
        if tear.guide ~= nil then
            destroy(tear.guide.clip)
        end
        destroy(tear.glow)
        destroy(R.grip)
        destroy(R.catcher)
        R.grip, R.catcher = nil, nil
        R.tear = nil
        emptied(tear)                             -- (the grip's handlers hold `tear`, which held the pack's parts)
        RevealCards.placeStack(R, R.stackX, R.stackY, R.cw, R.ch)
        ev.opened()
    end)
end

-- A pack without a design swells a little and fades out; then ev.opened().
local function swellPack(R, ev)
    local pack = R.pack
    R.stage = "tearing"
    ev.changed()
    Anim.start(R, SWELL_SECONDS, function(p)
        local grow = 1 + 0.15 * p
        local w, h = math.floor(pack.w * grow), math.floor(pack.h * grow)
        pack.sprite:SetPos(pack.x - (w - pack.w) // 2, pack.y - (h - pack.h) // 2)
        pack.sprite:SetSize(w, h)
        pack.sprite.alpha = 1 - p
    end, function()
        destroy(pack.sprite)
        R.pack = nil
        for _, c in ipairs(R.cards) do
            setHidden(c.back, false)
        end
        ev.opened()
    end)
end

-- What the main button and a click on the pack do while it is sealed: tear it open, or swell it away.
function RevealPack.open(R, ev)
    if R.stage ~= "sealed" then
        return
    end
    if R.tear ~= nil then
        startTear(R, ev)
    elseif R.pack ~= nil then
        swellPack(R, ev)
    end
end

-- Dragging across the top of the pack tears it as far as the mouse goes (left to right). As in the Pack Maker, pressing
-- stretches the invisible grip over the whole screen so it keeps getting the hold and release wherever the mouse goes.
-- A press without a drag tears it open by itself.
local function makeGrip(R, tear, ev)
    local gripH = math.floor(GRIP_H * tear.cap.s)
    -- The pack is many small parts, so a see-through rectangle over the whole of it takes a click, and tells (every frame,
    -- see RevealPack.animate) whether the mouse is over it, which makes the pack lift and glow like a prompt. The grip, over
    -- its top, is made after it so it gets the clicks there.
    local catcher = ui.Rectangle.new(R.root)
    R.catcher = catcher
    catcher:SetPos(tear.x, tear.y0)
    catcher:SetSize(tear.w, tear.h)
    catcher.fill = true
    catcher.colour = Vector4.new(0, 0, 0, 0)
    pcall(function() catcher.clickthrough = false end)
    pcall(function() catcher:Subscribe(ui.Hook.ONCLICK, function() RevealPack.open(R, ev) end) end)
    local grip = ui.Layer.new(R.root)
    R.grip = grip
    grip.clickthrough = false
    local function rest()
        grip:SetPos(tear.x, tear.y0)
        grip:SetSize(tear.w, gripH)
    end
    rest()
    local drag = nil
    local function finishDrag()
        drag = nil
        rest()
    end
    grip:Subscribe(ui.Hook.ONCLICK, function()
        if R.tear ~= tear or R.stage ~= "sealed" or Anim.running(R) or drag ~= nil then
            return
        end
        local x = Kit.mouseX()
        if x == nil then
            RevealPack.open(R, ev)
            return
        end
        drag = { mouseX = x, rip = tear.rip, moved = false }
        grip:SetPos(0, 0)
        grip:SetSize(0, 0, 1, 1)
        pcall(function() grip:MoveToFront() end)
    end)
    grip:Subscribe(ui.Hook.ONHOLD, function()
        local x = drag and Kit.mouseX()
        if x == nil or R.tear ~= tear then
            return
        end
        local dx = x - drag.mouseX
        drag.moved = drag.moved or math.abs(dx) > 3
        -- The tear only goes forward.
        local rip = math.max(tear.rip, math.min(1, drag.rip + dx / tear.w))
        drawRip(R, rip)
        if rip >= 1 then
            finishDrag()
            startTear(R, ev)
        end
    end)
    grip:Subscribe(ui.Hook.ONRELEASE, function()
        if drag == nil then
            return
        end
        local moved = drag.moved
        finishDrag()
        if R.tear == tear and (not moved or tear.rip >= DRAG_FINISH) then
            startTear(R, ev)
        end
    end)
end

-- Draws a designed pack, `side` up, as the two pieces it tears into (see PackArt.tearY), in the sealed pack's place.
-- Returns body, cap.
local function makePieces(R, tear, side, art)
    local body = PackArt.new(R.root, side, R.packH, "body")
    local cap = PackArt.new(R.root, side, R.packH, "cap")
    for _, piece in ipairs({ body, cap }) do
        piece.root:SetPos(tear.x, tear.y)
        PackArt.draw(piece, art)
    end
    return body, cap
end

-- The glowing guide along the tear line, in a layer that drawRip narrows as the tear passes (with one inside it moving
-- the other way, so the guide stays put). Nil if its image is missing.
local function makeGuide(R, tear)
    local guideImage = image("tear_guide")
    if guideImage == nil then
        return nil
    end
    local guide = { y = 0 }
    guide.clip = ui.Layer.new(R.root)
    guide.inner = ui.Layer.new(guide.clip)
    guide.inner:SetSize(tear.w, GUIDE_H)
    guide.line = ui.Sprite.new(guide.inner)
    guide.line:SetSize(tear.w, GUIDE_H)
    guide.line.sprite = guideImage
    local glint = image("sparkle_legendary")
    if glint ~= nil then
        guide.glint = ui.Sprite.new(guide.inner)
        guide.glint:SetSize(GLINT_SIZE, GLINT_SIZE)
        guide.glint.sprite = glint
        guide.glint.alpha = 0
    end
    return guide
end

-- Turns the sealed pack over (Flip pack): the torn pieces narrow to nothing (PackArt.squash), then are swapped for
-- the other side's pieces, which widen out. Only one side exists at a time, as each is many parts. The cards inside
-- and the tear guide are hidden meanwhile. Opened back side up, its cards are all turned over once dealt.
local function flipSealed(R, ev)
    local tear = R.tear
    local art = PackArt.designFor(R.packTypeId)
    if tear == nil or art == nil or R.stage ~= "sealed" or Anim.running(R) or tear.rip > 0 then
        return
    end
    local to = (R.side == "front") and "back" or "front"
    local function squash(f)
        PackArt.squash(tear.body, f)
        PackArt.squash(tear.cap, f)
    end
    local function flipAgain()
        flipSealed(R, ev)
    end
    for _, c in ipairs(R.cards) do
        setHidden(c.back, true)
    end
    if tear.guide ~= nil then
        setHidden(tear.guide.clip, true)
    end
    R.stage = "flipping"
    if tear.glow ~= nil then
        tear.glow.alpha = 0
    end
    setFlipButton(R, false)
    ev.changed()
    local turned = false
    Anim.start(R, SEALED_FLIP_SECONDS, function(p)
        local f = math.abs(math.cos(p * math.pi))
        if p < 0.5 then
            squash(f)
            return
        end
        if not turned then
            turned = true
            for _, piece in ipairs(R.packArts) do
                PackArt.destroy(piece)
            end
            tear.body, tear.cap = makePieces(R, tear, to, art)
            R.packArts = { tear.body, tear.cap }
        end
        squash(math.max(f, 0.01))
    end, function()
        squash(1)
        if tear.guide ~= nil then
            setHidden(tear.guide.clip, false)
            pcall(function() tear.guide.clip:MoveToFront() end)
        end
        R.side, R.faceUp = to, to == "back"
        for _, c in ipairs(R.cards) do
            setHidden(c.back, false)
        end
        R.stage = "sealed"
        setLift(R, tear.lift)
        drawRip(R, 0)
        placeStack(R, 0)
        setFlipButton(R, true, flipAgain)
        ev.changed()
    end)
end

-- Shows the sealed pack in the middle of the screen, over the stack of face-down cards (R.cards, made first so they are
-- behind it). Returns false, with nothing shown, if there is neither a design nor the pack image.
function RevealPack.show(R, ev)
    local art = PackArt.designFor(R.packTypeId)
    local packH = R.packH
    local w = (art ~= nil) and math.floor(PackArt.W * packH / PackArt.H + 0.5) or math.floor(packH * PackArt.PACK_IMAGE_ASPECT)
    local x = (R.SW - w) // 2
    local y0 = math.floor((R.areaH - packH) / 2)
    if art ~= nil then
        local tear = { rip = 0, x = x, y0 = y0, y = y0, w = w, h = packH, lift = 0, hover = 0 }
        R.tear = tear
        -- The glow behind the pack, which shows when the mouse is over it.
        local glowImage = image("glow_legendary")
        if glowImage ~= nil then
            tear.glow = ui.Sprite.new(R.root)
            tear.glow.sprite = glowImage
            tear.glow:SetSize(w + 2 * HOVER_GLOW_PAD, packH + 2 * HOVER_GLOW_PAD)
            tear.glow.alpha = 0
        end
        tear.body, tear.cap = makePieces(R, tear, R.side, art)
        R.packArts = { tear.body, tear.cap }
        tear.guide = makeGuide(R, tear)
        makeGrip(R, tear, ev)
        setLift(R, 0)
        drawRip(R, 0)
        placeStack(R, 0)
        setFlipButton(R, true, function() flipSealed(R, ev) end)
        return true
    end
    local picture = image("pack")
    if picture == nil then
        return false
    end
    local sprite = ui.Sprite.new(R.root)
    sprite:SetPos(x, y0)
    sprite:SetSize(w, packH)
    sprite.sprite = picture
    sprite.clickthrough = false
    pcall(function() sprite:Subscribe(ui.Hook.ONCLICK, function() RevealPack.open(R, ev) end) end)
    R.pack = { sprite = sprite, x = x, y = y0, w = w, h = packH }
    for _, c in ipairs(R.cards) do
        setHidden(c.back, true)
    end
    return true
end

-- Every frame while the pack is sealed: the guide's pulse and glint, and the pack lifting and glowing under the mouse.
function RevealPack.animate(R, dt)
    local tear = R.tear
    if tear == nil or R.stage ~= "sealed" then
        return
    end
    animateGuide(R)
    -- The lift follows the mouse smoothly; nothing is redrawn once it has settled.
    local over = false
    pcall(function() over = R.catcher.isMouseOver == true or R.grip.isMouseOver == true end)
    local target = (over and tear.rip == 0) and 1 or 0
    local step = dt / HOVER_SECONDS
    tear.hover = tear.hover + math.max(-step, math.min(step, target - tear.hover))
    local lift = math.floor(HOVER_LIFT * Anim.smooth(tear.hover) + 0.5)
    if lift ~= tear.lift then
        setLift(R, lift)
        drawRip(R, tear.rip)
        placeStack(R, 0)
    end
    if tear.glow ~= nil then
        tear.glow.alpha = HOVER_GLOW_ALPHA * Anim.smooth(tear.hover)
    end
end

-- Removes the pack's pieces and button when the reveal closes (the rest of it goes with the screen's root layer), and
-- empties `tear`, which the grip's handlers hold.
function RevealPack.destroy(R)
    for _, piece in ipairs(R.packArts or {}) do
        pcall(PackArt.destroy, piece)
    end
    destroy(R.flipButton)
    emptied(R.tear)
end

return RevealPack
