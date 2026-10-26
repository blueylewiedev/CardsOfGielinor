-- ui/packwindow.lua
-- The window for choosing a difficulty, buying packs and revealing the cards.
--
-- It has four screens, and only one is shown at a time:
--   nosession : nobody is logged in yet
--   setup     : first run, pick a difficulty tier
--   home      : credits, the pack to buy (the standard pack and the themed packs in
--               deck/packs.lua), its price and the Open pack button
--   reveal    : the pulled cards, shown one at a time with a Next button
--
-- The reveal (see "The pack opening" below) is animated: a sealed pack, then each card face
-- down and flipped over one at a time. It only shows what core/packs.lua already rolled.

local Cards = require("core/cards")
local Storage = require("core/storage")
local Packs = require("core/packs")
local CardView = require("ui/cardview")
local Viewer = require("ui/viewer")
local Kit = require("ui/kit")
local Stats = require("ui/stats")
local Settings = require("core/settings")
local PackArt = require("ui/packart")
local Carousel = require("ui/carousel")
local Anim = require("ui/anim")

local PackWindow = {}

local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)

local WIDTH = 236
-- The setup screen is wider: its longest button label ("Master - 20 credits") needs about 250.
local SETUP_WIDTH = 296
local SETUP_BUTTON_W = 260
local TITLE_BAR = 40   -- extra window height taken by PrettyUI's title bar
-- The reveal screen is wider and taller, to fit a whole card (cards can be resized with
-- CardView.SCALE). The card sits at the top, with the text and Next button under it.
-- Room is left around the card for the glow of a flipped card to fade out into.
local GLOW_PAD = 14
local CARD_Y = GLOW_PAD + 4                  -- top of the card (or the pack) in the window
local REVEAL_WIDTH = math.max(WIDTH, CardView.WIDTH + 2 * GLOW_PAD + 12 + 16)
-- PrettyUI's content area is inset further from the left of the frame than from the right, so
-- everything on the reveal screen is moved left by this much to look centred.
local REVEAL_SHIFT = Kit.available() and -10 or 0
local REVEAL_MID = REVEAL_WIDTH + 2 * REVEAL_SHIFT   -- the width to centre things in
local REVEAL_TOP = CARD_Y + CardView.HEIGHT + GLOW_PAD + 4   -- where the text under the card starts
local STAGE_H = REVEAL_TOP - 4               -- the card area: what moves in it is cropped at its edges
-- The bottom of the sealed pack's outline (the pack is drawn as tall as a card).
local PACK_BOTTOM = CARD_Y + math.floor((PackArt.OUTLINE.y + PackArt.OUTLINE.h) * CardView.HEIGHT / PackArt.H)
-- The Home screen is as wide as the reveal screen, for the pack chooser at its top: a drop-down
-- of the packs over a carousel of them (ui/carousel.lua), kept in step. Under it, from HOME_TOP:
-- the price and collection count, the Open pack button, a hint, then the Collection and Stats
-- buttons. The buttons each have a row of their own: PrettyUI makes a button as wide as its label
-- needs, so two side by side would overlap.
local DROPDOWN_Y = 32
local CAROUSEL_Y, CAROUSEL_H = 64, 200
local HOME_TOP = CAROUSEL_Y + CAROUSEL_H + 4
local HOME_W = REVEAL_MID - 20                -- the width of the text and buttons
local EXTRA_TOP = HOME_TOP + 182              -- where the extra buttons on the Home screen start
-- Window height for each screen (Home's is set by buildExtras, as it depends on the extra buttons).
local HEIGHTS = { nosession = 90, setup = 262, reveal = REVEAL_TOP + 124 }

-- Set by PackWindow.show():
--   api.getState() : the logged-in character's collection, or nil
--   api.saveNow()  : saves it straight away
--   api.openSettings() : opens the settings window (the Settings button on Home)
--   api.extraButtons : optional list of { label, action } shown as buttons at the bottom of Home
local api = nil
local window = nil
local content = nil  -- the component inside the window frame that the screens are built in
local screens = {}   -- screen name -> Layer
local widgets = {}   -- named pieces that need updating later
local current = nil  -- name of the screen being shown
-- The pack being opened. Also the owner of its animations (ui/anim.lua).
local reveal = { results = nil, index = 0, parts = {}, pips = {}, stage = nil, clock = 0 }
local chosenPack = "standard"   -- the pack type the Open pack button buys (kept while the plugin runs)

-- The pack type to buy: the one chosen, or the standard pack if that one has gone.
local function currentPack()
    if Packs.typeById(chosenPack) == nil then
        chosenPack = "standard"
    end
    return chosenPack
end

-- Text and buttons come from ui/kit.lua, which uses PrettyUI when it is available.
local makeText = Kit.text
local makeButton = Kit.button

-- Only change text when it differs, so refreshing every tick does no needless work.
local function setText(widget, content)
    if widget.content ~= content then
        widget.content = content
    end
end

-- Shows one screen (nosession, setup, home or reveal), hides the others and resizes the window
-- to fit it.
local function showScreen(name)
    current = name
    for screenName, layer in pairs(screens) do
        layer.hidden = (screenName ~= name)
    end
    window:SetSize(({ reveal = REVEAL_WIDTH, home = REVEAL_WIDTH, setup = SETUP_WIDTH })[name] or WIDTH, HEIGHTS[name] + (Kit.available() and TITLE_BAR or 0))
end

-- ---------------------------------------------------------------------------------------
-- The pack opening.
--
-- A pack is bought and rolled straight away (and saved), then shown in stages:
--   sealed    : the pack. "Tear open" (or clicking the pack) tears it open; a designed pack can
--               also be torn by dragging across its top, or flipped over first (its cards are
--               then dealt face up). The cards slide out as a stack.
--   flipping, tearing : the sealed pack turning over, or being torn open.
--   facedown  : the next card, showing the card back, with the cards still to come stacked
--               behind it. "Flip card" (or clicking it) turns it.
--   faceup    : the card, whether it is new, and a glow for rarer cards.
--                "Next" goes to the following card, "Done" after the last one.
--   leaving   : the card sliding off before the next.
-- The moves between stages are short animations (ui/anim.lua); a click during one skips to its
-- end. If the pack image is missing the sealed stage is skipped; if the card back is missing a
-- plain dark card back is drawn instead.

local GLOW_SPEED = 4                   -- how fast the glow breathes (radians per second; 2 pi is one breath)
local GLOW_MIN = 0.45                  -- the dimmest it gets, as a fraction of its full brightness
local GLOW_STRENGTH = 1.0              -- overall brightness of the glow, on top of each rarity's own
local GLOW_FLASH = 1.5                 -- extra brightness the glow starts with when a card is flipped
local GLOW_FLASH_SECONDS = 0.6         -- how long that flash takes to die down to the normal glow
local SWELL_SECONDS = 0.45             -- a pack without a design: it swells and fades
-- Tearing a designed pack open (see PackArt.tearY): the tear runs across under the top crimp,
-- peeling the cap up behind it; the cap flies off; the pack drops away, leaving the stack of
-- cards that was inside it; the cards grow into place. The tear can also be dragged across by hand.
local RIP_SECONDS = 0.45               -- the tear running across, when it isn't dragged
local CAP_SECONDS = 0.35
local DROP_SECONDS = 0.55              -- starts halfway through the cap flying off
local SETTLE_SECONDS = 0.3
local PEEL_LIFT = 10                   -- how far the torn cap lifts behind the tear, in pixels
local PEEL_W = 0.35                    -- over how much of the pack's width (behind the tear) it lifts
local DRAG_FINISH = 0.6                -- let go after dragging this far and the tear finishes itself
local GRIP_H = 80                      -- the part of the pack (pack units from the top) to drag across
local STACK_W = 0.72                   -- the cards inside the pack, as a fraction of its width
local STACK_TOP = 66                   -- where they start, in pack units from the top (under the tear)
local STACK_STEP = 3                   -- how far each card in the stack sits from the one in front
-- The guide along the tear line while the pack is sealed (resources/images/tear_guide.png, made
-- by dev/make_burst.py): it pulses, and a glint runs along it left to right, the way to tear.
-- It goes as the tear passes.
local GUIDE_H = 24
local GUIDE_PULSE = 3                  -- radians per second
local GLINT_EVERY, GLINT_SECONDS = 1.6, 0.9
local GLINT_SIZE = 20
local SEALED_FLIP_SECONDS = 0.4        -- turning the sealed pack over (Flip pack); edge-on halfway
local FLIP_ICON = 24                   -- the Flip pack button (PrettyUI's sprite buttons are 24 x 24)
local LEAVE_SECONDS = 0.3              -- a revealed card sliding off to the left before the next
-- Flipping a card, in four steps (each one's length in seconds): the back lifts, swelling a
-- little; it turns edge-on (its width closes to nothing); the face widens back out from the
-- middle (see CardView.squash), still without its picture and text, which cannot be squeezed;
-- then those burst into view from the middle of the art box (CardView.uncover) inside a growing
-- ring, in a flash of the card's rarity colour.
local FLIP_LIFT, FLIP_TURN, FLIP_OPEN, FLIP_REVEAL = 0.12, 0.15, 0.2, 0.5
local FLIP_SECONDS = FLIP_LIFT + FLIP_TURN + FLIP_OPEN + FLIP_REVEAL
local FLIP_SWELL = 0.06                -- how much bigger the back gets as it lifts
-- The burst images are made per rarity by dev/make_burst.py (resources/images/burst_<rarity>.png
-- and so on). The flash grows from BURST_FROM to BURST_TO times the card's width while it flares
-- and fades.
local BURST_FROM, BURST_TO = 0.3, 1.5
-- The ring's bright line is RING_RADIUS of its image's half-width (as drawn by make_burst.py).
-- The picture and text show through a square whose corners sit on that line, so the ring's glow
-- covers its straight edges.
local RING_RADIUS = 0.7
local RING_FIT = 0.72                  -- the square's half-width, as a fraction of the ring's radius
-- Sparkles fly SPARKLE_DIST card widths out from the burst, shrinking and spinning.
local SPARKLES = 8
local SPARKLE_SIZE = 26
local SPARKLE_DIST = 0.75
local SPARKLE_SPIN = 200               -- degrees each sparkle turns as it flies

-- Pips under the card, one per card in the pack.
local PIP_W, PIP_H, PIP_GAP = 26, 8, 6

local PIP_UNSEEN = Vector4.new(0.35, 0.35, 0.38, 1.0)
local CARD_BACK_COLOUR = Vector4.new(0.10, 0.10, 0.14, 1.0)   -- if the card back image is missing

-- Loads an image from resources/images, once. Returns nil (and logs) if it is not there.
local image = PackArt.image

local startTear, flipSealed   -- (below) used by the sealed pack's controls

-- Turns a 0xRRGGBBAA colour number into a Vector4 (parts 0-1), with a different alpha.
local function toColour(hex, alpha)
    return Vector4.new(((hex >> 24) & 0xFF) / 255, ((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255, alpha)
end

-- Left edge of the card on the reveal screen, centred in the window.
local function revealCardX()
    return (REVEAL_MID - CardView.WIDTH) // 2
end

local function setHidden(component, hidden)
    pcall(function() component.hidden = hidden end)
end

-- Remembers a piece of the reveal so clearParts can remove it later. Returns the piece.
local function track(part)
    reveal.parts[#reveal.parts + 1] = part
    return part
end

-- Hooks a click on a component to the same action as the main button, if the component
-- supports clicks (the button always works, so this is only a convenience).
local function clickable(component)
    pcall(function() component:Subscribe(ui.Hook.ONCLICK, function() PackWindow.advance() end) end)
end

-- Destroys everything drawn for the current stage (pack, card, back, glow).
local function clearParts()
    for _, part in ipairs(reveal.parts) do
        setHidden(part, true)
        pcall(function() part:Destroy() end)
    end
    reveal.parts = {}
    for _, packArt in ipairs(reveal.packArts or {}) do
        PackArt.destroy(packArt)
    end
    reveal.packArts = {}
    reveal.tear = nil
    reveal.flipButton = nil
    reveal.mover = nil
    reveal.view = nil
    reveal.burst = nil
    reveal.back = nil
    reveal.glow = nil
    reveal.pack = nil
end

-- Removes the row of small markers (one per card in the pack) under the card.
local function clearPips()
    for _, pip in ipairs(reveal.pips) do
        pcall(function() pip:Destroy() end)
    end
    reveal.pips = {}
end

-- Forgets the reveal: the stage's pieces, the pips and the results.
local function clearReveal()
    Anim.cancel(reveal)
    clearParts()
    clearPips()
    reveal.results = nil
    reveal.index = 0
    reveal.stage = nil
    reveal.side = nil
    reveal.faceUp = false
    reveal.clickedAt = nil
end

-- One pip per card. Cards already flipped take their rarity colour.
local function drawPips(flipped)
    clearPips()
    local total = #reveal.results
    local startX = (REVEAL_MID - (total * PIP_W + (total - 1) * PIP_GAP)) // 2
    for i = 1, total do
        local pip = ui.Rectangle.new(content)
        pip:SetPos(startX + (i - 1) * (PIP_W + PIP_GAP), REVEAL_TOP + 104)
        pip:SetSize(PIP_W, PIP_H)
        pip.fill = true
        if i <= flipped then
            pip.colour = toColour(Cards.rarities[reveal.results[i].card.rarity].colour, 1.0)
        else
            pip.colour = PIP_UNSEEN
        end
        reveal.pips[#reveal.pips + 1] = pip
    end
end

-- A card back in `parent` (placed by the caller): the card back image, or a plain dark card.
local function cardBack(parent)
    local back = image("card_back")
    local part
    if back ~= nil then
        part = track(ui.Sprite.new(parent))
        part.sprite = back
    else
        part = track(ui.Rectangle.new(parent))
        part.fill = true
        part.colour = CARD_BACK_COLOUR
    end
    return part
end

-- One card of a stack, with place(x, y, w, h) and destroy(). Face down it is a card back. Face up
-- (a pack opened back side up) it is the card's frame with the dark backdrop in its art window
-- (CardView.shell): how a card dealt face up looks before its burst brings in the picture and
-- text, so dealing it changes nothing.
local function makeStackCard(parent, card, faceUp)
    local shell = faceUp and CardView.shell(parent, card.rarity) or nil
    if shell ~= nil then
        return shell
    end
    local part = cardBack(parent)
    return {
        place = function(x, y, w, h)
            part:SetPos(x, y)
            part:SetSize(w, h)
        end,
        destroy = function() pcall(function() part:Destroy() end) end,
    }
end

-- A stack of the pack's cards from reveal.results[first] on, `count` of them, face up or down
-- (see makeStackCard). The first is made last, so it is in front. They are placed by the caller.
local function makeStack(parent, first, count, faceUp)
    local cards = {}
    for i = count, 1, -1 do
        cards[i] = makeStackCard(parent, reveal.results[first + i - 1].card, faceUp)
    end
    return cards
end

-- ---------------------------------------------------------------------------------------
-- The burst: a face-up card's picture and text appearing.

-- The burst over a card as its picture and text appear, in the card's rarity colour: a flash,
-- a ring round the opening, and sparkles flying out. Built hidden on top of the face-down card
-- (whose left edge is `x`) and played by drawBurst. A missing image is simply left out, and with
-- the "burst" setting off (or a card that can't be uncovered) there is no burst: reveal.burst
-- stays nil.
local function buildBurst(x, rarity)
    if not Settings.get("burst") then
        return
    end
    local ox, oy, reach = CardView.uncoverOrigin(reveal.view)
    if ox == nil then
        return
    end
    -- The ring ends just big enough for the square inside it to uncover the whole card.
    local burst = { ox = x + ox, oy = CARD_Y + oy, ringEnd = reach / RING_FIT, sparkles = {} }
    local function sprite(name)
        local resource = image(name .. "_" .. rarity)
        if resource == nil then
            return nil
        end
        local part = track(ui.Sprite.new(reveal.mover))
        part.sprite = resource
        part.alpha = 0
        return part
    end
    burst.flash = sprite("burst")
    burst.ring = sprite("ring")
    if image("sparkle_" .. rarity) ~= nil then
        for i = 1, SPARKLES do
            -- Spread round the circle, each nudged a little (the same every time) so they do not
            -- look ruled, and some flying further than others.
            local angle = (i - 1 + 0.3 * math.sin(i * 7.1)) * 2 * math.pi / SPARKLES
            local far = 0.75 + 0.25 * math.cos(i * 3.7)
            burst.sparkles[i] = { sprite = sprite("sparkle"), dx = math.cos(angle) * far, dy = math.sin(angle) * far }
        end
    end
    reveal.burst = burst
end

-- Plays the burst at `q` (0 to 1 through the reveal step), uncovering the card's picture and
-- text as the ring grows. At q = 1 the card is all uncovered and the burst has faded away.
local function drawBurst(q)
    local burst = reveal.burst
    -- The ring races out, then slows; the picture and text show through the square inside it.
    local radius = burst.ringEnd * Anim.easeOut(q, 3)
    CardView.uncover(reveal.view, radius * RING_FIT)
    if burst.ring ~= nil then
        local size = 2 * radius / RING_RADIUS
        burst.ring:SetPos(burst.ox - size / 2, burst.oy - size / 2)
        burst.ring:SetSize(math.max(1, size), math.max(1, size))
        burst.ring.alpha = 1 - q * q
    end
    local W = CardView.WIDTH
    -- Everything flares up over the first fifth, then fades.
    local flare = (q < 0.2) and (q / 0.2) or (1 - (q - 0.2) / 0.8)
    if burst.flash ~= nil then
        local size = W * (BURST_FROM + (BURST_TO - BURST_FROM) * Anim.easeOut(q))
        burst.flash:SetPos(burst.ox - size / 2, burst.oy - size / 2)
        burst.flash:SetSize(size, size)
        burst.flash.alpha = flare
    end
    local d = W * SPARKLE_DIST * Anim.easeOut(q, 3)
    local size = SPARKLE_SIZE * (1 - 0.6 * q)
    for _, sparkle in ipairs(burst.sparkles) do
        sparkle.sprite:SetPos(burst.ox + sparkle.dx * d - size / 2, burst.oy + sparkle.dy * d - size / 2)
        sparkle.sprite:SetSize(size, size)
        sparkle.sprite.alpha = flare
        pcall(function() sparkle.sprite.rotationDegrees = SPARKLE_SPIN * q end)
    end
end

-- Brings in a face-up card's picture and text, `q` (0 to 1) of the way: through its burst, or
-- all at once if it has none. The rarity glow starts with them.
local function revealFace(q)
    if reveal.burst ~= nil then
        drawBurst(q)
    else
        CardView.uncover(reveal.view, math.huge)
    end
    if reveal.glow ~= nil then
        reveal.glow.on = true
    end
end

-- ---------------------------------------------------------------------------------------
-- The sealed pack: tearing it open and flipping it over.

-- The Flip pack button: a small refresh arrow just under a designed sealed pack's outline, while
-- the pack is untouched. It belongs to the stage (clearParts removes it).
local function setFlipButton(shown)
    if reveal.flipButton ~= nil then
        setHidden(reveal.flipButton, true)
        pcall(function() reveal.flipButton:Destroy() end)
        reveal.flipButton = nil
    end
    if shown then
        reveal.flipButton = track(Kit.iconButton(content, "REFRESH", (REVEAL_MID - FLIP_ICON) // 2, PACK_BOTTOM + 6,
            function() flipSealed() end, "Flip pack", "Flip", 60))
    end
end

-- Shows the tear `rip` (0 to 1) of the way across the pack: the cap's columns behind the tear
-- lift, the furthest behind the most, so the cap peels up.
local function drawRip(rip)
    local tear = reveal.tear
    tear.rip = rip
    if rip > 0 and reveal.flipButton ~= nil then
        setFlipButton(false)                   -- too late to turn it over
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
        guide.clip:SetPos(tear.x + cut, guide.y)
        guide.clip:SetSize(math.max(1, w - cut), GUIDE_H)
        guide.inner:SetPos(-cut, 0)
    end
end

-- Pulses the tear guide and runs its glint along it (every frame while the pack is sealed).
local function animateGuide(clock)
    local guide = reveal.tear and reveal.tear.guide
    if guide == nil or reveal.stage ~= "sealed" then
        return
    end
    guide.line.alpha = 0.6 + 0.4 * math.sin(clock * GUIDE_PULSE)
    if guide.glint ~= nil then
        local phase = clock % GLINT_EVERY
        if phase < GLINT_SECONDS then
            local f = phase / GLINT_SECONDS
            guide.glint:SetPos(f * reveal.tear.w - GLINT_SIZE / 2, (GUIDE_H - GLINT_SIZE) / 2)
            guide.glint.alpha = math.sin(f * math.pi)
            pcall(function() guide.glint.rotationDegrees = 180 * f end)
        else
            guide.glint.alpha = 0
        end
    end
end

-- Places the stack of cards: inside the pack (hidden behind it) at settle = 0, grown into the
-- card's place at 1. The cards behind the front one sit a little higher, as they stay while the
-- cards are dealt (see cardStage).
local function placeStack(settle)
    local tear = reveal.tear
    local sw = math.floor(tear.w * STACK_W)
    local sh = math.floor(sw * CardView.HEIGHT / CardView.WIDTH)
    local fromX, fromY = tear.x + (tear.w - sw) / 2, tear.y + STACK_TOP * tear.cap.s
    local w, h = sw + (CardView.WIDTH - sw) * settle, sh + (CardView.HEIGHT - sh) * settle
    local x, y = fromX + (revealCardX() - fromX) * settle, fromY + (CARD_Y - fromY) * settle
    for i, card in ipairs(tear.stack) do
        card.place(x, y - (i - 1) * STACK_STEP, w, h)
    end
end

-- Dragging across the top of the pack tears it as far as the mouse goes (left to right). As in
-- the Pack Maker, pressing stretches the invisible grip over the whole screen so it keeps getting
-- the hold and release wherever the mouse goes. A press without a drag tears it open by itself.
local function makeGrip()
    local tear = reveal.tear
    local gripH = math.floor(GRIP_H * tear.cap.s)
    local grip = track(ui.Layer.new(content))
    grip.clickthrough = false
    local function rest()
        grip:SetPos(tear.x, tear.y)
        grip:SetSize(tear.w, gripH)
    end
    rest()
    local drag = nil
    local function finishDrag()
        drag = nil
        rest()
    end
    grip:Subscribe(ui.Hook.ONCLICK, function()
        if reveal.tear ~= tear or Anim.running(reveal) or drag ~= nil then
            return
        end
        local x = Kit.mouseX()
        if x == nil then
            PackWindow.advance()
            return
        end
        drag = { mouseX = x, rip = tear.rip, moved = false }
        grip:SetPos(0, 0)
        grip:SetSize(0, 0, 1, 1)
        pcall(function() grip:MoveToFront() end)
    end)
    grip:Subscribe(ui.Hook.ONHOLD, function()
        local x = drag and Kit.mouseX()
        if x == nil or reveal.tear ~= tear then
            return
        end
        local dx = x - drag.mouseX
        drag.moved = drag.moved or math.abs(dx) > 3
        -- The tear only goes forward.
        local rip = math.max(tear.rip, math.min(1, drag.rip + dx / tear.w))
        drawRip(rip)
        if rip >= 1 then
            finishDrag()
            startTear()
        end
    end)
    grip:Subscribe(ui.Hook.ONRELEASE, function()
        if drag == nil then
            return
        end
        local moved = drag.moved
        finishDrag()
        if reveal.tear == tear and (not moved or tear.rip >= DRAG_FINISH) then
            startTear()
        end
    end)
end

-- Draws a designed pack, `side` up, as the two pieces it tears into (see PackArt.tearY), in the
-- tear's stage, in the sealed pack's place. Returns body, cap.
local function makePieces(tear, side, art)
    local body = PackArt.new(tear.stage, side, CardView.HEIGHT, "body")
    local cap = PackArt.new(tear.stage, side, CardView.HEIGHT, "cap")
    for _, piece in ipairs({ body, cap }) do
        piece.root:SetPos((REVEAL_MID - piece.w) // 2, CARD_Y)
        PackArt.draw(piece, art)
    end
    return body, cap
end

-- The words under the sealed pack: only the count, over the pips (the glowing guide shows where
-- to tear).
local function sealedTexts()
    setText(widgets.variantText, "")
    setText(widgets.newText, "")
    setText(widgets.counterText, #reveal.results .. " cards inside" .. (reveal.faceUp and ", dealt face up" or ""))
end

-- The glowing guide along the tear line, in a layer that drawRip narrows as the tear passes
-- (with one inside it moving the other way, so the guide stays put). Nil if its image is missing.
local function makeGuide(tear)
    local guideImage = image("tear_guide")
    if guideImage == nil then
        return nil
    end
    local guide = { y = tear.y + math.floor(PackArt.TEAR_Y * tear.cap.s) - GUIDE_H // 2 }
    guide.clip = track(ui.Layer.new(tear.stage))
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

-- First stage of a pack: the sealed pack. A pack type with a design (made in the Pack Maker)
-- shows its front, can be flipped over (Flip pack) and tears open; any other shows the pack
-- image. If neither can be shown this stage is skipped.
local function showSealed()
    showScreen("reveal")
    clearParts()
    reveal.stage = "sealed"
    reveal.index = 0
    local art = PackArt.designFor(reveal.packTypeId)
    if art ~= nil then
        -- Drawn in a layer that ends above the text, so the pieces vanish as they fly off and
        -- drop away. First the stack of cards inside, then the body and cap over it, the same
        -- size and place as the pack image. They are drawn now, not when the tear starts, as
        -- they are many small parts.
        local stage = track(ui.Layer.new(content))
        stage:SetSize(REVEAL_WIDTH, STAGE_H)
        local tear = { stage = stage, rip = 0 }
        -- The stack goes in a layer of its own, made first, so a new stack (after the pack is
        -- flipped) is still behind the pack.
        tear.stackLayer = ui.Layer.new(stage)
        tear.stackLayer:SetSize(REVEAL_WIDTH, STAGE_H)
        tear.stack = makeStack(tear.stackLayer, 1, #reveal.results, reveal.faceUp)
        tear.body, tear.cap = makePieces(tear, reveal.side, art)
        reveal.packArts = { tear.body, tear.cap }
        tear.w, tear.h = tear.body.w, tear.body.h
        tear.x, tear.y = (REVEAL_MID - tear.w) // 2, CARD_Y
        reveal.tear = tear
        tear.guide = makeGuide(tear)
        -- The design is many small parts, so a see-through rectangle over it takes the click.
        local catcher = track(ui.Rectangle.new(content))
        catcher:SetPos(tear.x, tear.y)
        catcher:SetSize(tear.w, tear.h)
        catcher.fill = true
        catcher.colour = Vector4.new(0, 0, 0, 0)
        clickable(catcher)
        makeGrip()
        drawRip(0)
        placeStack(0)
        setFlipButton(true)
    else
        local h = CardView.HEIGHT
        local w = math.floor(h * PackArt.PACK_IMAGE_ASPECT)
        local x = (REVEAL_MID - w) // 2
        local sprite = track(ui.Sprite.new(content))
        sprite:SetPos(x, CARD_Y)
        sprite:SetSize(w, h)
        sprite.sprite = image("pack")
        reveal.pack = { sprite = sprite, x = x, y = CARD_Y, w = w, h = h }
        clickable(sprite)
    end
    sealedTexts()
    Kit.setLabel(widgets.nextButton, "Tear open")
    drawPips(0)
end

-- ---------------------------------------------------------------------------------------
-- The cards.

-- The layer a card is drawn in: a still one that crops (so the card vanishes at the edge as it
-- slides off), holding the cards still to come behind it (the stack left from the tear, one
-- smaller each card) and then one that moves (reveal.mover). Returns the moving one.
local function cardStage()
    local stage = track(ui.Layer.new(content))
    stage:SetSize(REVEAL_WIDTH, STAGE_H)
    for k, card in ipairs(makeStack(stage, reveal.index + 1, #reveal.results - reveal.index, reveal.faceUp)) do
        card.place(revealCardX(), CARD_Y - k * STACK_STEP, CardView.WIDTH, CardView.HEIGHT)
    end
    reveal.mover = ui.Layer.new(stage)
    reveal.mover:SetSize(REVEAL_WIDTH, STAGE_H)
    return reveal.mover
end

-- The next card, face down: its face is built underneath, and the card back covers it.
local function showFaceDown()
    showScreen("reveal")
    clearParts()
    reveal.stage = "facedown"
    local result = reveal.results[reveal.index]
    local x = revealCardX()
    local rarity = Cards.rarities[result.card.rarity]
    local layer = cardStage()

    -- The glow is a soft, rounded image (resources/images/glow_<rarity>.png) behind the card.
    -- It is invisible until the card is flipped, so it does not give the rarity away. Common
    -- cards have no glow, and a rarity whose image is missing simply goes without.
    local glowImage = Settings.get("glow") and ((rarity.glow or 0) > 0) and image("glow_" .. result.card.rarity) or nil
    if glowImage ~= nil then
        local glow = track(ui.Sprite.new(layer))
        glow:SetPos(x - GLOW_PAD, CARD_Y - GLOW_PAD)
        glow:SetSize(CardView.WIDTH + 2 * GLOW_PAD, CardView.HEIGHT + 2 * GLOW_PAD)
        glow.sprite = glowImage
        glow.alpha = 0.0
        reveal.glow = { sprite = glow, strength = rarity.glow, age = 0 }
    end

    reveal.view = CardView.create(layer, result.card, { animated = true })
    reveal.view.root:SetPos(x, CARD_Y)
    track(reveal.view.root)
    -- Hidden until it is flipped, so nothing of it (a frame edge, the glow) can show round the
    -- card back and give the rarity away. Its picture and text stay hidden a little longer,
    -- for the burst.
    setHidden(reveal.view.root, true)
    CardView.uncover(reveal.view, 0)
    log("reveal:", result.card.id, result.finish, "model", tostring(reveal.view.model ~= nil))

    reveal.back = cardBack(layer)
    reveal.back:SetPos(x, CARD_Y)
    reveal.back:SetSize(CardView.WIDTH, CardView.HEIGHT)
    clickable(reveal.back)
    buildBurst(x, result.card.rarity)

    setText(widgets.variantText, "")
    setText(widgets.newText, "")
    setText(widgets.counterText, "Card " .. reveal.index .. " of " .. #reveal.results)
    Kit.setLabel(widgets.nextButton, "Flip card")
    drawPips(reveal.index - 1)
end

-- The card is face up: shows all of it (whatever its animation got to) and what it is.
local function showFaceUp()
    reveal.stage = "faceup"
    setHidden(reveal.view.root, false)
    CardView.squash(reveal.view, 1)
    revealFace(1)
    if reveal.back ~= nil then
        pcall(function() reveal.back:Destroy() end)
        reveal.back = nil
    end
    -- Clicking the revealed card moves on to the next one, like the Next button. The card is
    -- made of several pieces that may take the click themselves, so a see-through rectangle is
    -- laid over the whole card to catch it.
    local overlay = track(ui.Rectangle.new(content))
    overlay:SetPos(revealCardX(), CARD_Y)
    overlay:SetSize(CardView.WIDTH, CardView.HEIGHT)
    overlay.fill = true
    overlay.colour = Vector4.new(0.0, 0.0, 0.0, 0.0)
    clickable(overlay)
    local result = reveal.results[reveal.index]
    if result.isNewCard then
        setText(widgets.newText, "NEW CARD!")
        widgets.newText.colour = GOLD
    elseif result.isNewVariant then
        setText(widgets.newText, "New variant!")
        widgets.newText.colour = GOLD
    else
        setText(widgets.newText, "Owned: " .. result.owned)
        widgets.newText.colour = GREY
    end
    Kit.setLabel(widgets.nextButton, (reveal.index < #reveal.results) and "Next" or "Done")
    drawPips(reveal.index)
end

-- Shows the card at reveal.index: face down, to be flipped, or (when the pack was opened back
-- side up) already face up, its picture and text bursting into view straight away.
local function dealCard()
    showFaceDown()
    if not reveal.faceUp then
        return
    end
    setHidden(reveal.back, true)
    setHidden(reveal.view.root, false)
    if reveal.burst == nil then
        showFaceUp()
        return
    end
    Kit.setLabel(widgets.nextButton, "Next")
    Anim.start(reveal, FLIP_REVEAL, revealFace, showFaceUp)
end

-- Turns the face-down card over (see FLIP_SECONDS): the back lifts and closes edge-on, the face
-- widens out, then its picture and text come in. Without a burst it ends as the face opens.
local function flipCard()
    local back, view = reveal.back, reveal.view
    local x, W, H = revealCardX(), CardView.WIDTH, CardView.HEIGHT
    local seconds = (reveal.burst ~= nil) and FLIP_SECONDS or (FLIP_SECONDS - FLIP_REVEAL)
    -- `t` seconds in: the back eases up to its full swell, then shrinks back to its normal
    -- height while its width closes (slowly at first, then quickly, like a card turning).
    local function drawBack(t)
        local lift = Anim.easeOut(math.min(1, t / FLIP_LIFT))
        local close = math.max(0, (t - FLIP_LIFT) / FLIP_TURN)
        local grow = 1 + FLIP_SWELL * lift * (1 - close)
        local w = math.max(1, math.floor(W * grow * math.cos(close * math.pi / 2) + 0.5))
        local h = math.floor(H * grow + 0.5)
        back:SetPos(x + (W - w) // 2, CARD_Y + (H - h) // 2)
        back:SetSize(w, h)
    end
    -- `t` seconds after it was edge-on: the face widens out from the middle (quickly at first,
    -- then slowing), then its picture and text come in. (A card without a frame image can't be
    -- squeezed, so it just appears.)
    local turned = false
    local function drawFace(t)
        local open = math.sin(math.min(1, t / FLIP_OPEN) * math.pi / 2)
        if not turned then
            turned = true
            setHidden(back, true)
            setHidden(view.root, false)
        end
        CardView.squash(view, math.max(open, 0.01))
        if t >= FLIP_OPEN then
            revealFace(math.min(1, (t - FLIP_OPEN) / FLIP_REVEAL))
        end
    end
    Anim.start(reveal, seconds, function(p)
        local t = p * seconds
        if t < FLIP_LIFT + FLIP_TURN then
            drawBack(t)
        else
            drawFace(t - FLIP_LIFT - FLIP_TURN)
        end
    end, showFaceUp)
end

-- The face-up card (with its glow) slides off to the left, speeding up; then the next one is
-- dealt (or, after the last, the window goes back to Home).
local function leaveCard()
    local mover = reveal.mover
    local distance = revealCardX() + CardView.WIDTH + 2 * GLOW_PAD
    reveal.stage = "leaving"
    Anim.start(reveal, LEAVE_SECONDS, function(p)
        mover:SetPos(-math.floor(distance * p * p), 0)
    end, function()
        if reveal.index < #reveal.results then
            reveal.index = reveal.index + 1
            dealCard()
        else
            clearReveal()
            PackWindow.refresh()
        end
    end)
end

-- The pack image (no design to tear) swells a little and fades out; then the first card is dealt.
local function swellPack()
    local pack = reveal.pack
    Anim.start(reveal, SWELL_SECONDS, function(p)
        local grow = 1 + 0.15 * p
        local w, h = math.floor(pack.w * grow), math.floor(pack.h * grow)
        pack.sprite:SetPos(pack.x - (w - pack.w) // 2, pack.y - (h - pack.h) // 2)
        pack.sprite:SetSize(w, h)
        pack.sprite.alpha = 1 - p
    end, function()
        reveal.index = 1
        dealCard()
    end)
end

-- Turns the sealed pack over (the Flip pack button); opened back side up, its cards are dealt
-- face up. The torn pieces themselves narrow to nothing (PackArt.squash); then, while the pack is
-- edge-on, they are swapped for the other side's pieces, which widen out. Only one side exists at
-- a time, as each is many parts. The stack of cards inside and the tear guide are hidden
-- meanwhile, as the narrowing pack would show the stack.
flipSealed = function()
    local tear = reveal.tear
    local art = PackArt.designFor(reveal.packTypeId)
    if tear == nil or art == nil or Anim.running(reveal) or tear.rip > 0 then
        return
    end
    local to = (reveal.side == "front") and "back" or "front"
    local function squash(f)
        PackArt.squash(tear.body, f)
        PackArt.squash(tear.cap, f)
    end
    setHidden(tear.stackLayer, true)
    if tear.guide ~= nil then
        setHidden(tear.guide.clip, true)
    end
    reveal.stage = "flipping"
    setFlipButton(false)
    local turned = false
    Anim.start(reveal, SEALED_FLIP_SECONDS, function(p)
        local f = math.abs(math.cos(p * math.pi))
        if p < 0.5 then
            squash(f)
            return
        end
        if not turned then
            turned = true
            for _, piece in ipairs(reveal.packArts) do
                PackArt.destroy(piece)
            end
            tear.body, tear.cap = makePieces(tear, to, art)
            reveal.packArts = { tear.body, tear.cap }
        end
        squash(math.max(f, 0.01))
    end, function()
        squash(1)
        if tear.guide ~= nil then
            setHidden(tear.guide.clip, false)
            pcall(function() tear.guide.clip:MoveToFront() end)
        end
        reveal.side, reveal.faceUp = to, to == "back"
        -- The cards inside turn with the pack: face up if it is now back side up.
        for _, card in ipairs(tear.stack) do
            card.destroy()
        end
        tear.stack = makeStack(tear.stackLayer, 1, #reveal.results, reveal.faceUp)
        placeStack(0)
        setHidden(tear.stackLayer, false)
        reveal.stage = "sealed"
        drawRip(0)
        sealedTexts()
        setFlipButton(true)
    end)
end

-- Tears the designed pack open from wherever the tear has got to: the rest of the tear, the cap
-- flying off up and to the right, the pack dropping away below the stack of cards, and the
-- stack growing into place. Then the first card is dealt.
startTear = function()
    local tear = reveal.tear
    if tear == nil or Anim.running(reveal) then
        return
    end
    reveal.stage = "tearing"
    setFlipButton(false)
    local from = tear.rip
    local ripEnd = RIP_SECONDS * (1 - from)
    local dropStart = ripEnd + CAP_SECONDS / 2
    local dropEnd = dropStart + DROP_SECONDS
    local total = dropEnd + SETTLE_SECONDS
    local capH = math.floor(PackArt.TEAR_MAX * tear.cap.s) + PEEL_LIFT
    local function phase(t, start, length)
        return math.max(0, math.min(1, (t - start) / length))
    end
    Anim.start(reveal, total, function(p)
        local t = p * total
        if tear.rip < 1 then
            drawRip(from + (1 - from) * phase(t, 0, ripEnd))
        end
        -- The cap speeds up as it goes, until it is out of the top of the window.
        local cap = phase(t, ripEnd, CAP_SECONDS) ^ 2
        tear.cap.root:SetPos(tear.x + math.floor(70 * cap), tear.y - math.floor((tear.y + capH) * cap))
        -- The pack drops out of the bottom of the card area, uncovering the cards.
        local drop = phase(t, dropStart, DROP_SECONDS) ^ 2
        tear.body.root:SetPos(tear.x, tear.y + math.floor((STAGE_H - tear.y) * drop))
        placeStack(Anim.smooth(phase(t, dropEnd, SETTLE_SECONDS)))
    end, function()
        reveal.index = 1
        dealCard()
    end)
end

-- Moves the reveal on one step. Called by the main button and by clicking the pack or card.
function PackWindow.advance()
    if reveal.results == nil then
        return
    end
    -- One click can reach two overlapping parts; only the first in a frame counts.
    if reveal.clickedAt == reveal.clock then
        return
    end
    reveal.clickedAt = reveal.clock
    -- A click during an animation skips to its end.
    if Anim.running(reveal) then
        Anim.skip(reveal)
    elseif reveal.stage == "sealed" then
        if reveal.tear ~= nil then
            startTear()
        else
            swellPack()
        end
    elseif reveal.stage == "facedown" then
        flipCard()
    elseif reveal.stage == "faceup" then
        leaveCard()
    end
end

-- Runs every frame during a reveal: the clock, the tear guide, and the glow of a flipped card.
local function onDraw(e)
    if reveal.results == nil then
        return
    end
    local dt = Anim.frameSeconds(e)
    reveal.clock = reveal.clock + dt
    animateGuide(reveal.clock)

    local glow = reveal.glow
    if glow ~= nil and glow.on then
        -- The glow flashes bright as the card's picture appears, dies down over
        -- GLOW_FLASH_SECONDS, then breathes between GLOW_MIN and full brightness. Only one value
        -- changes each frame (the image's alpha).
        glow.age = glow.age + dt
        local flash = 1 + GLOW_FLASH * math.max(0, 1 - glow.age / GLOW_FLASH_SECONDS)
        local breath = 0.5 + 0.5 * math.sin(reveal.clock * GLOW_SPEED)          -- 0 to 1
        glow.sprite.alpha = math.min(1, glow.strength * GLOW_STRENGTH * (GLOW_MIN + (1 - GLOW_MIN) * breath) * flash)
    end
end

Event.Draw.Subscribe("cardcollector_reveal", onDraw)

-- The Open pack button: buys and rolls a pack, saves it, then starts the reveal.
local function onOpenPack()
    local state = api.getState()
    if state == nil then
        return
    end
    local packTypeId = currentPack()
    local results, reason = Packs.open(state, packTypeId)
    if results == nil then
        log("pack not opened:", reason)
        PackWindow.refresh()
        return
    end
    api.saveNow()
    clearReveal()
    reveal.results = results
    reveal.packTypeId = packTypeId
    reveal.clock = 0
    -- The pack starts front side up; flipped over before it is torn, its cards are dealt face up.
    reveal.side = "front"
    reveal.faceUp = false
    if PackArt.designFor(packTypeId) ~= nil or image("pack") ~= nil then
        showSealed()
    else
        reveal.index = 1
        dealCard()
    end
end

-- Extra buttons under the main ones on Home, one per row, and the Home screen's height to fit
-- them. The released plugin has none; the development tools (dev/dev.lua) supply some, while
-- they are in use. Any made before are removed first.
local function buildExtras()
    for _, button in ipairs(widgets.extras or {}) do
        setHidden(button, true)
        pcall(function() button:Destroy() end)
    end
    widgets.extras = {}
    for i, extra in ipairs(api.extraButtons or {}) do
        widgets.extras[i] = makeButton(screens.home, extra.label, 10, EXTRA_TOP + (i - 1) * 34, HOME_W, 28, extra.action)
    end
    local count = #widgets.extras
    HEIGHTS.home = (count > 0) and (EXTRA_TOP + count * 34 + 12) or (EXTRA_TOP + 40)
end

-- Remakes the extra buttons from api.extraButtons (after the development tools are switched on
-- or off), resizing Home to fit. The window stays where it is.
function PackWindow.rebuildExtras()
    if window == nil then
        return
    end
    buildExtras()
    if current == "home" then
        showScreen("home")
    end
end

-- Builds all four screens once, when the window is created. Only one is visible at a time.
local function buildScreens()
    -- Each screen is a Layer that fills the window.
    for _, name in ipairs({ "nosession", "setup", "home", "reveal" }) do
        local layer = ui.Layer.new(content)
        layer:SetPos(name == "reveal" and REVEAL_SHIFT or 0, 0)
        layer:SetSize(0, 0, 1.0, 1.0)
        layer.hidden = true
        screens[name] = layer
    end

    -- nosession
    makeText(screens.nosession, 10, 20, 200, 50, "Log in to a character to open packs.", GREY)

    -- setup: one button per difficulty tier
    makeText(screens.setup, 10, 10, SETUP_BUTTON_W, 24, "Choose a difficulty", WHITE)
    for i, tier in ipairs(Packs.tiers) do
        makeButton(screens.setup, tier.name .. " - " .. tier.price .. " credits", 10, 40 + (i - 1) * 42, SETUP_BUTTON_W, 34,
            function()
                local state = api.getState()
                if state ~= nil then
                    Storage.setDifficulty(state, tier.id)
                    api.saveNow()
                    PackWindow.refresh()
                end
            end)
    end
    makeText(screens.setup, 10, 40 + #Packs.tiers * 42, SETUP_BUTTON_W, 20, "Price is per pack of " .. Packs.PACK_SIZE, GREY)
    makeText(screens.setup, 10, 40 + #Packs.tiers * 42 + 22, SETUP_BUTTON_W, 20, "Change it later in Settings", GREY)

    -- home
    widgets.creditsText = makeText(screens.home, 10, 8, 200, 20, "", WHITE, ui.AlignMode.TOPLEFT)
    -- The pack to buy, chosen by sliding round the carousel (or from the drop-down, made below).
    local packIds, entries = {}, {}
    for _, packType in ipairs(Packs.offered()) do
        packIds[#packIds + 1] = packType.id
        entries[#entries + 1] = { label = packType.name, value = packType.id }
    end
    widgets.carousel = Carousel.new(screens.home, 6, CAROUSEL_Y, REVEAL_MID - 12, CAROUSEL_H, packIds, currentPack(),
        function(packTypeId)
            chosenPack = packTypeId
            if widgets.packDropdown ~= nil then
                widgets.packDropdown.select(packTypeId)
            end
            PackWindow.refresh()
        end)
    widgets.priceText = makeText(screens.home, 10, HOME_TOP, HOME_W, 20, "", GREY)
    widgets.collectionText = makeText(screens.home, 10, HOME_TOP + 20, HOME_W, 20, "", GREY)
    widgets.openButton = makeButton(screens.home, "Open pack", 10, HOME_TOP + 46, HOME_W, 34, onOpenPack, "positive")
    widgets.hintText = makeText(screens.home, 10, HOME_TOP + 84, HOME_W, 20, "", GOLD)
    makeButton(screens.home, "Collection", 10, HOME_TOP + 108, HOME_W, 30, function()
        if Viewer.isOpen() then
            Viewer.close()
        else
            Viewer.open(api)
        end
    end)
    makeButton(screens.home, "Stats", 10, HOME_TOP + 144, HOME_W, 30, function()
        Stats.toggle(api)
    end)
    -- A cog in the top right corner opens the settings window.
    Kit.iconButton(screens.home, "SETTINGS", REVEAL_MID - 50, 4, function() api.openSettings() end, "Settings", "Settings", 80)
    buildExtras()
    -- The drop-down of packs, made after the rest so its list opens on top of them. Choosing one
    -- slides the carousel to it (which then makes it the pack to buy).
    widgets.packDropdown = Kit.dropdown(screens.home, 10, DROPDOWN_Y, HOME_W, 26, entries, currentPack(),
        function(packTypeId)
            Carousel.slideTo(widgets.carousel, packTypeId)
        end)

    -- reveal: under the pack or card, the main button (Tear open, Flip card, Next, Done), then
    -- what the card is, then the counter ("5 cards inside", "Card 1 of 5") over the pips.
    local rw = REVEAL_WIDTH - 20
    widgets.nextButton = makeButton(screens.reveal, "Next", 10, REVEAL_TOP, rw, 32, function() PackWindow.advance() end)
    widgets.variantText = makeText(screens.reveal, 10, REVEAL_TOP + 38, rw, 20, "", WHITE)
    widgets.newText = makeText(screens.reveal, 10, REVEAL_TOP + 58, rw, 20, "", GOLD)
    widgets.counterText = makeText(screens.reveal, 10, REVEAL_TOP + 80, rw, 18, "", GREY)
end

-- Creates the window. `newApi` supplies getState, saveNow, openSettings and extraButtons (see above).
function PackWindow.show(newApi)
    if window ~= nil then
        return
    end
    api = newApi
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    -- `window` is the frame (resized per screen); `content` is what the screens go inside.
    window, content = Kit.window(gameWindow, "Card Collector", WIDTH, HEIGHTS.nosession, function()
        PackWindow.hide()
    end, 0, 0.2)
    buildScreens()
    PackWindow.refresh()
end

-- Brings the window up to date with the character's collection. Called every tick, and
-- does nothing while a pack is being revealed so the reveal is not interrupted.
function PackWindow.refresh()
    if window == nil then
        return
    end
    Stats.refresh()
    local state = api.getState()

    if state == nil then
        Viewer.close()
        clearReveal()
        if current ~= "nosession" then
            showScreen("nosession")
        end
        return
    end

    -- A reveal in progress must not be interrupted. This checks the reveal itself, not the
    -- screen name, so that finishing the reveal lets the window go back to home.
    if reveal.results ~= nil then
        return
    end

    local tier = Packs.tierFor(state)
    if tier == nil then
        if current ~= "setup" then
            showScreen("setup")
        end
        return
    end

    local price = Packs.priceFor(state, currentPack())
    local poolSize = Packs.poolSize(currentPack())
    setText(widgets.creditsText, "Credits: " .. state.credits)
    setText(widgets.priceText, "Price: " .. price .. " credits (" .. tier.name .. ")")
    setText(widgets.collectionText, "Collection: " .. Storage.countUniqueOwned(state) .. " of " .. #Cards.list
        .. " cards")
    local affordable = state.credits >= price
    Kit.setEnabled(widgets.openButton, affordable and poolSize > 0)
    local hint = ""
    if poolSize == 0 then
        hint = "No cards in this pack yet"
    elseif not affordable then
        hint = "Need " .. (price - state.credits) .. " more credits"
    end
    setText(widgets.hintText, hint)
    if current ~= "home" then
        showScreen("home")
    end
end

-- The name of the screen being shown, or nil if the window is not created. For tests.
function PackWindow.currentScreen()
    return current
end

-- Closes the window and everything that belongs to it (collection, statistics, any reveal).
function PackWindow.hide()
    Viewer.close()
    Stats.hide()
    clearReveal()
    if widgets.carousel ~= nil then
        Carousel.destroy(widgets.carousel)
    end
    if widgets.packDropdown ~= nil then
        widgets.packDropdown.destroy()
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
        window = nil
        content = nil
        screens = {}
        widgets = {}
        current = nil
    end
end

return PackWindow
