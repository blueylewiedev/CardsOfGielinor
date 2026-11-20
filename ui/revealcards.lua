-- ui/revealcards.lua
-- The cards of the pack opening: a card's back (in the stack and then in its place), its face made behind the back, the
-- turning over, the burst and glow as it opens, and the words under it. ui/revealscreen.lua lays the cards out and decides
-- when each turns; ui/revealpack.lua is the pack they come out of. Every function takes `R`, the reveal under way (its
-- fields are listed in ui/revealscreen.lua). A card is a plain table: { index, result, parts, x, y, w, h, back, view,
-- glow, burst, flipped, flipping }. A reveal that has closed has an empty `R` (no root), so nothing here does anything.

local Cards = require("core/cards")
local Logger = require("core/logger")
local Settings = require("core/settings")
local CardView = require("ui/cardview")
local PackArt = require("ui/packart")
local Kit = require("ui/kit")
local Anim = require("ui/anim")
local Theme = require("ui/theme")
local GREY, GOLD = Theme.GREY, Theme.GOLD
local Util = require("ui/util")
local setHidden, destroy = Util.setHidden, Util.destroy

local RevealCards = {}

RevealCards.LABEL_H = 22            -- the line under a turned card ("NEW CARD!")
RevealCards.STACK_STEP = 3          -- how far each card in the stack sits from the one in front
local LABEL_H, STACK_STEP = RevealCards.LABEL_H, RevealCards.STACK_STEP
local GLOW_PAD = 14

-- Turning a card, in four steps (seconds): the back lifts and swells; it turns edge-on; the face widens out
-- (CardView.squash) without its picture and text, which cannot be squeezed; then those burst into view from the
-- middle of the art box (CardView.uncover) inside a growing ring.
local FLIP_LIFT, FLIP_TURN, FLIP_OPEN, FLIP_REVEAL = 0.12, 0.15, 0.2, 0.5
local FLIP_SECONDS = FLIP_LIFT + FLIP_TURN + FLIP_OPEN + FLIP_REVEAL
local FLIP_SWELL = 0.06                 -- how much bigger the back gets as it lifts
local GLOW_SPEED = 4                    -- how fast the glow breathes (radians per second)
local GLOW_MIN = 0.45                   -- the dimmest it gets, as a fraction of its full brightness
local GLOW_STRENGTH = 1.0
local GLOW_FLASH = 1.5                  -- extra brightness the glow starts with when a card is turned
local GLOW_FLASH_SECONDS = 0.6
-- The burst images are made per rarity by dev/make_burst.py (resources/images/burst_<rarity>.png and so on). The flash
-- grows from BURST_FROM to BURST_TO times the card's width while it flares and fades.
local BURST_FROM, BURST_TO = 0.3, 1.5
-- The ring's bright line is RING_RADIUS of its image's half-width (as drawn by make_burst.py). The picture and text show
-- through a square whose corners sit on that line, so the ring's glow covers its straight edges.
local RING_RADIUS = 0.7
local RING_FIT = 0.72                   -- the square's half-width, as a fraction of the ring's radius
local SPARKLES = 8
local SPARKLE_SIZE = 26
local SPARKLE_DIST = 0.75
local SPARKLE_SPIN = 200                -- degrees each sparkle turns as it flies

local CARD_BACK_COLOUR = Vector4.new(0.10, 0.10, 0.14, 1.0)   -- if the card back image is missing

local image = PackArt.image

-- Keeps `part` on the card `c`, to be destroyed with it.
local function own(c, part)
    c.parts[#c.parts + 1] = part
    return part
end

-- The card back, in the stack and then in its place in the grid: the card back image, or a plain dark card.
local function makeBack(R, c)
    local back = image("card_back")
    local part
    if back ~= nil then
        part = ui.Sprite.new(R.root)
        part.sprite = back
    else
        part = ui.Rectangle.new(R.root)
        part.fill = true
        part.colour = CARD_BACK_COLOUR
    end
    own(c, part)
    return part
end

local function placeBack(c, x, y, w, h)
    c.back:SetPos(math.floor(x), math.floor(y))
    c.back:SetSize(math.floor(w), math.floor(h))
end
RevealCards.placeBack = placeBack

-- Puts every card's back in the stack: the front card at (x, y), size w x h, the ones behind it a little higher.
function RevealCards.placeStack(R, x, y, w, h)
    for i, c in ipairs(R.cards) do
        placeBack(c, x, y - (i - 1) * STACK_STEP, w, h)
    end
end

-- Makes card number `index` of the reveal, face down (just its back; the face is made by prepare). `onClick(card)` is called
-- when its back is clicked.
function RevealCards.make(R, index, onClick)
    local c = { index = index, result = R.results[index], parts = {}, w = R.cw, h = R.ch, flipped = false }
    c.back = makeBack(R, c)
    pcall(function() c.back.clickthrough = false end)
    -- (the handler holds this handle, not the card; clear empties it)
    local handle = { card = c }
    c.handle = handle
    pcall(function()
        c.back:Subscribe(ui.Hook.ONCLICK, function()
            if handle.card ~= nil then
                onClick(handle.card)
            end
        end)
    end)
    return c
end

-- The burst over a card as its picture and text appear, in the card's rarity colour: a flash, a ring round the opening
-- and sparkles flying out. Built hidden over the card; played by drawBurst. A missing image is left out, and with the
-- "burst" setting off (or a card that can't be uncovered) there is no burst: c.burst stays nil.
local function buildBurst(R, c)
    if not Settings.get("burst") then
        return
    end
    local ox, oy, reach = CardView.uncoverOrigin(c.view)
    if ox == nil then
        return
    end
    local rarity = c.result.card.rarity
    -- The ring ends just big enough for the square inside it to uncover the whole card.
    local burst = { ox = c.x + ox, oy = c.y + oy, ringEnd = reach / RING_FIT, sparkles = {} }
    local function sprite(name)
        local resource = image(name .. "_" .. rarity)
        if resource == nil then
            return nil
        end
        local part = ui.Sprite.new(R.root)
        own(c, part)
        part.sprite = resource
        part.alpha = 0
        return part
    end
    burst.flash = sprite("burst")
    burst.ring = sprite("ring")
    if image("sparkle_" .. rarity) ~= nil then
        for i = 1, SPARKLES do
            -- Spread round the circle, each nudged a little (the same every time) so they do not look ruled, and some
            -- flying further than others.
            local angle = (i - 1 + 0.3 * math.sin(i * 7.1)) * 2 * math.pi / SPARKLES
            local far = 0.75 + 0.25 * math.cos(i * 3.7)
            burst.sparkles[i] = { sprite = sprite("sparkle"), dx = math.cos(angle) * far, dy = math.sin(angle) * far }
        end
    end
    c.burst = burst
end

-- Plays the burst at `q` (0 to 1 through the step), uncovering the card's picture and text as the ring grows. At q = 1
-- the card is all uncovered and the burst has faded away.
local function drawBurst(c, q)
    local burst = c.burst
    local radius = burst.ringEnd * Anim.easeOut(q, 3)
    CardView.uncover(c.view, radius * RING_FIT)
    if burst.ring ~= nil then
        local size = 2 * radius / RING_RADIUS
        burst.ring:SetPos(burst.ox - size / 2, burst.oy - size / 2)
        burst.ring:SetSize(math.max(1, size), math.max(1, size))
        burst.ring.alpha = 1 - q * q
    end
    -- Everything flares up over the first fifth, then fades.
    local flare = (q < 0.2) and (q / 0.2) or (1 - (q - 0.2) / 0.8)
    if burst.flash ~= nil then
        local size = c.w * (BURST_FROM + (BURST_TO - BURST_FROM) * Anim.easeOut(q))
        burst.flash:SetPos(burst.ox - size / 2, burst.oy - size / 2)
        burst.flash:SetSize(size, size)
        burst.flash.alpha = flare
    end
    local d = c.w * SPARKLE_DIST * Anim.easeOut(q, 3)
    local size = SPARKLE_SIZE * (1 - 0.6 * q)
    for _, sparkle in ipairs(burst.sparkles) do
        if sparkle.sprite ~= nil then
            sparkle.sprite:SetPos(burst.ox + sparkle.dx * d - size / 2, burst.oy + sparkle.dy * d - size / 2)
            sparkle.sprite:SetSize(size, size)
            sparkle.sprite.alpha = flare
            pcall(function() sparkle.sprite.rotationDegrees = SPARKLE_SPIN * q end)
        end
    end
end

-- Brings in a turned card's picture and text, `q` (0 to 1) of the way: through its burst, or all at once if it has none.
-- The rarity glow starts with them.
local function revealFace(c, q)
    if c.burst ~= nil then
        drawBurst(c, q)
    else
        CardView.uncover(c.view, math.huge)
    end
    if c.glow ~= nil then
        c.glow.on = true
    end
end

-- Makes a card's face: its model and text (hidden under its back), its glow and its burst. Done one card a frame once
-- the cards are laid out (see revealscreen's frame), or when a card is clicked before its turn comes.
function RevealCards.prepare(R, c)
    if c.view ~= nil or c.failed then
        return
    end
    local ok, err = pcall(function()
        local card = c.result.card
        local rarity = Cards.rarities[card.rarity]
        -- The glow is a soft, rounded image (resources/images/glow_<rarity>.png) behind the card. It is invisible until the
        -- card is turned, so it does not give the rarity away. Common cards have no glow.
        local glowImage = Settings.get("glow") and ((rarity.glow or 0) > 0) and image("glow_" .. card.rarity) or nil
        if glowImage ~= nil then
            local glow = ui.Sprite.new(R.root)
            own(c, glow)
            glow:SetPos(c.x - GLOW_PAD, c.y - GLOW_PAD)
            glow:SetSize(c.w + 2 * GLOW_PAD, c.h + 2 * GLOW_PAD)
            glow.sprite = glowImage
            glow.alpha = 0.0
            c.glow = { sprite = glow, strength = rarity.glow, age = 0 }
        end
        c.view = CardView.create(R.root, card, { animated = true, scale = R.scale, finish = c.result.finish })
        own(c, c.view.root)
        c.view.root:SetPos(c.x, c.y)
        -- Hidden until it is turned, so nothing of it (a frame edge, the glow) can show round the card back and give the
        -- rarity away. Its picture and text stay hidden a little longer, for the burst.
        setHidden(c.view.root, true)
        CardView.uncover(c.view, 0)
        buildBurst(R, c)
    end)
    if not ok then
        Logger.error("reveal: a card could not be made:", tostring(err))
        c.failed = true
        c.view = nil
    end
end

-- The words under a turned card: whether it is new.
local function addLabel(R, c)
    local result = c.result
    local text, colour
    if result.isNewCard then
        text, colour = "NEW CARD!", GOLD
    elseif result.isNewVariant then
        text, colour = "New variant!", GOLD
    else
        text, colour = "Owned: " .. tostring(result.owned), GREY
    end
    if result.finish ~= "normal" then
        text, colour = string.upper(Cards.finishes[result.finish].name) .. "  " .. text, GOLD
    end
    local label = Kit.text(R.root, c.x - 20, c.y + c.h + 2, c.w + 40, LABEL_H, text, colour)
    own(c, label)
    c.labelWidget = label
end

-- How many cards of this page are turned, and how many there are.
function RevealCards.counts(R)
    local flipped = 0
    for _, c in ipairs(R.cards) do
        if c.flipped then
            flipped = flipped + 1
        end
    end
    return flipped, #R.cards
end

-- The card is face up: shows all of it (whatever its animation got to) and what it is. `onShown` is called after.
local function showFaceUp(R, c, onShown)
    if R.root == nil then
        return
    end
    c.flipping = false
    c.flipped = true
    c.result.seen = true
    if c.result.isNewCard then
        R.newCards = R.newCards + 1
    end
    if c.view ~= nil then
        setHidden(c.view.root, false)
        CardView.squash(c.view, 1)
        revealFace(c, 1)
    end
    if c.back ~= nil then
        destroy(c.back)
        c.back = nil
    end
    addLabel(R, c)
    onShown()
end
RevealCards.showFaceUp = showFaceUp

-- Turns a card over (see FLIP_SECONDS): the back lifts and closes edge-on, the face widens out, then its picture and
-- text come in. Without a burst it ends as the face opens. `onShown` is called once it is face up.
function RevealCards.flip(R, c, onShown)
    if R.root == nil or c.flipped or c.flipping then
        return
    end
    RevealCards.prepare(R, c)
    if c.view == nil then
        -- Its model could not be made: it is shown as turned anyway, with what it is written under it.
        c.flipping = true
        showFaceUp(R, c, onShown)
        return
    end
    c.flipping = true
    local back, view = c.back, c.view
    local x, y, W, H = c.x, c.y, c.w, c.h
    local seconds = (c.burst ~= nil) and FLIP_SECONDS or (FLIP_SECONDS - FLIP_REVEAL)
    -- `t` seconds in: the back eases up to its full swell, then shrinks back to its normal height while its width closes
    -- (slowly at first, then quickly, like a card turning).
    local function drawBack(t)
        local lift = Anim.easeOut(math.min(1, t / FLIP_LIFT))
        local close = math.max(0, (t - FLIP_LIFT) / FLIP_TURN)
        local grow = 1 + FLIP_SWELL * lift * (1 - close)
        local w = math.max(1, math.floor(W * grow * math.cos(close * math.pi / 2) + 0.5))
        local h = math.floor(H * grow + 0.5)
        back:SetPos(x + (W - w) // 2, y + (H - h) // 2)
        back:SetSize(w, h)
    end
    -- `t` seconds after it was edge-on: the face widens out from the middle (quickly at first, then slowing), then its
    -- picture and text come in.
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
            revealFace(c, math.min(1, (t - FLIP_OPEN) / FLIP_REVEAL))
        end
    end
    Anim.start(c, seconds, function(p)
        local t = p * seconds
        if t < FLIP_LIFT + FLIP_TURN then
            drawBack(t)
        else
            drawFace(t - FLIP_LIFT - FLIP_TURN)
        end
    end, function() showFaceUp(R, c, onShown) end)
end

-- Removes the cards of the page on show.
function RevealCards.clear(R)
    for _, c in ipairs(R.cards or {}) do
        Anim.cancel(c)
        for _, part in ipairs(c.parts) do
            destroy(part)
        end
        c.parts = {}
        if c.handle ~= nil then
            c.handle.card = nil                   -- (the click handler on its back no longer reaches the card)
        end
    end
    R.cards = {}
end

-- The glow of a turned card flashes bright as its picture appears, dies down over GLOW_FLASH_SECONDS, then breathes
-- between GLOW_MIN and full brightness. Only one value changes each frame (the image's alpha). Called every frame.
function RevealCards.animateGlows(R, dt)
    local breath = 0.5 + 0.5 * math.sin(R.clock * GLOW_SPEED)          -- 0 to 1
    for _, c in ipairs(R.cards) do
        local glow = c.glow
        if glow ~= nil and glow.on then
            glow.age = glow.age + dt
            local flash = 1 + GLOW_FLASH * math.max(0, 1 - glow.age / GLOW_FLASH_SECONDS)
            glow.sprite.alpha = math.min(1, glow.strength * GLOW_STRENGTH * (GLOW_MIN + (1 - GLOW_MIN) * breath) * flash)
        end
    end
end

return RevealCards
