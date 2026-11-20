-- ui/revealscreen.lua
-- The pack opening, on a screen of its own: a full-screen layer dims the game and blocks its clicks, and the pack
-- bought sits in the middle (one pack however many were bought; the cards of all of them are shown in pages of up to
-- PAGE_SIZE). Stages:
--   sealed the pack lifts and glows under the mouse. "Tear open", a click or a drag across
--     its top tears it; Flip pack turns it over first
--             (then its cards are all revealed at once)
--   tearing   the cap flies off, the pack drops away and the stack of cards grows into place
--   dealing   the face-down stack is shuffled and the cards fly out into a grid
--   cards click a card (or "Reveal all") to turn it over; its border and glow stay hidden
--     until then, so nothing gives its rarity away.
--             Next page, then Done on the last. "Skip" turns every card at once, a card a frame as its model is made.
-- The cards were rolled and saved by core/packs.lua before this starts; this only shows them. A result not yet turned
-- over has results[i].seen == nil (Reveal.hiddenCards lists them for the collection viewer). Anything that goes wrong
-- here closes the screen, since a click-blocking layer that could not be removed would trap the player.
-- Reveal.start(results, packTypeId, hooks): hooks.onClose() is called when the screen closes for any reason.

local Cards = require("core/cards")
local Logger = require("core/logger")
local Settings = require("core/settings")
local CardView = require("ui/cardview")
local PackArt = require("ui/packart")
local Kit = require("ui/kit")
local Anim = require("ui/anim")
local Events = require("core/events")
local Theme = require("ui/theme")
local WHITE, GREY, GOLD = Theme.WHITE, Theme.GREY, Theme.GOLD
local Util = require("ui/util")
local setHidden, destroy, setText = Util.setHidden, Util.destroy, Util.setText

local Reveal = {}


-- The screen.
local DIM_ALPHA = 0.78
local DIM_SECONDS = 0.3
local GAP = 20                          -- between cards
local LABEL_H = 22                      -- the line under a turned card ("NEW CARD!")
local SIDE_MARGIN = 60
local BAR_H = 130                       -- the bottom bar (the line of text and the button) and the space above it
local PAGE_COLS, PAGE_SIZE = 5, 10
local MIN_FIT = 0.5                     -- cards are shrunk at most to this fraction to fit a small screen
local GLOW_PAD = 14

-- The pack.
local PACK_H_MIN, PACK_H_MAX = 240, 480
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
local STACK_STEP = 3                    -- how far each card in the stack sits from the one in front
local GUIDE_H = 24
local GUIDE_PULSE = 3                   -- radians per second
local GLINT_EVERY, GLINT_SECONDS = 1.6, 0.9
local GLINT_SIZE = 20
local SEALED_FLIP_SECONDS = 0.4         -- turning the sealed pack over (Flip pack); edge-on halfway
local FLIP_ICON = 24                    -- the Flip pack button (PrettyUI's sprite buttons are 24 x 24)

-- The shuffle and the spread.
local SHUFFLE_SECONDS, SHUFFLE_ROUNDS = 1.4, 3
local SHUFFLE_SWING = 0.1                     -- how far the cards swing out to a side, as a fraction of their width
local SPREAD_SECONDS, SPREAD_STAGGER = 0.6, 0.05
local AUTO_STEP = 0.18                  -- seconds between cards when they are turned all at once

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

-- The reveal under way, or nil. Fields: results, packTypeId, hooks, root, dim, SW, SH, cx (screen middle), scale, cw, ch
-- (card size), cols, pageSize, page, pages, cards (this page's), slots, stackX, stackY, stage, side, faceUp, clock,
-- tear, status, main, skip, newCards, auto, instant (Skip was used: no more animations).
local R = nil

local startTear, flipSealed, updateControls, startDealing, onMain, closeReveal, flipCard

-- The client keeps an event handler after the component it was given is destroyed, so a handler whose closure reaches
-- a card's view and model, or the pack's parts, keeps them (and the client's memory for them) alive. A handler
-- therefore holds only a handle or a table that is emptied here when its parts are destroyed. dev/check_reveal_ui.lua
-- checks that no handler left behind reaches a model, a model group or a sprite.
local function emptied(tbl)
    if tbl ~= nil then
        for key in pairs(tbl) do
            tbl[key] = nil
        end
    end
end

local function clamp01(x)
    return math.max(0, math.min(1, x))
end

-- Keeps `part` on the card `c`, to be destroyed with it.
local function own(c, part)
    c.parts[#c.parts + 1] = part
    return part
end

-- The screen's size in pixels (the plugin's layer), or a guess if the client does not say.
local function screenSize()
    local w, h = nil, nil
    pcall(function()
        local layer = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
        w, h = layer.width, layer.height
    end)
    if type(w) ~= "number" or type(h) ~= "number" or w < 640 or h < 480 then
        Logger.error("reveal: the screen size is not known (" .. tostring(w) .. " x " .. tostring(h) .. "), assuming 1920 x 1080")
        return 1920, 1080
    end
    return w, h
end

local cardSize = CardView.sizeAt

-- ---------------------------------------------------------------------------------------
-- Layout.

-- How big to draw the cards: CardView.SCALE if a page fits on the screen, smaller (down to MIN_FIT of it) if not.
local function chooseScale(SW, SH, total)
    local cols = math.min(PAGE_COLS, total)
    local rows = math.min(2, math.ceil(math.min(total, PAGE_SIZE) / PAGE_COLS))
    local cw, ch = cardSize(CardView.SCALE)
    local needW = cols * cw + (cols - 1) * GAP
    local needH = rows * (ch + LABEL_H) + (rows - 1) * GAP
    local fit = math.min(1, (SW - 2 * SIDE_MARGIN) / needW, (SH - BAR_H - 20) / needH)
    if fit < 1 then
        fit = fit * 0.97                  -- (the card's size is whole pixels, so leave a little to spare)
    end
    return CardView.SCALE * math.max(MIN_FIT, fit)
end

-- The sizes of the rows of `count` cards, as even as can be: 10 is 5 and 5, 7 is 4 and 3.
local function rowSizes(count, maxCols)
    local rows = math.ceil(count / maxCols)
    local base, extra = count // rows, count % rows
    local sizes = {}
    for r = 1, rows do
        sizes[r] = base + ((r <= extra) and 1 or 0)
    end
    return sizes
end

-- Where each of `count` cards goes: { x, y } top left corners, each row centred, the whole grid centred above the bar.
local function slotsFor(count)
    local sizes = rowSizes(count, R.cols)
    local rows = #sizes
    local gridH = rows * (R.ch + LABEL_H) + (rows - 1) * GAP
    local top = math.floor(((R.SH - BAR_H) - gridH) / 2)
    local slots, i = {}, 0
    for r, n in ipairs(sizes) do
        local rowW = n * R.cw + (n - 1) * GAP
        local x0 = math.floor((R.SW - rowW) / 2)
        for k = 1, n do
            i = i + 1
            slots[i] = { x = x0 + (k - 1) * (R.cw + GAP), y = top + (r - 1) * (R.ch + LABEL_H + GAP) }
        end
    end
    return slots
end

-- ---------------------------------------------------------------------------------------
-- The cards.

-- The card back, in the stack and then in its place in the grid: the card back image, or a plain dark card.
local function makeBack(c)
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

-- Turns a card (see flipCard) when it is clicked, or does nothing if it can't be.
local function onCardClick(c)
    if R == nil or R.stage ~= "cards" or c.flipped then
        return
    end
    if c.flipping then
        Anim.skip(c)
        return
    end
    flipCard(c)
end

local function makeCard(index)
    local c = { index = index, result = R.results[index], parts = {}, w = R.cw, h = R.ch, flipped = false }
    c.back = makeBack(c)
    pcall(function() c.back.clickthrough = false end)
    -- (the handler holds this handle, not the card; clearCards empties it)
    local handle = { card = c }
    c.handle = handle
    pcall(function()
        c.back:Subscribe(ui.Hook.ONCLICK, function()
            if handle.card ~= nil then
                onCardClick(handle.card)
            end
        end)
    end)
    return c
end

-- The burst over a card as its picture and text appear, in the card's rarity colour: a flash, a ring round the opening
-- and sparkles flying out. Built hidden over the card; played by drawBurst. A missing image is left out, and with the
-- "burst" setting off (or a card that can't be uncovered) there is no burst: c.burst stays nil.
local function buildBurst(c)
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
-- the cards are laid out (see onDraw), or when a card is clicked before its turn comes.
local function prepare(c)
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
        buildBurst(c)
    end)
    if not ok then
        Logger.error("reveal: a card could not be made:", tostring(err))
        c.failed = true
        c.view = nil
    end
end

-- The words under a turned card: whether it is new.
local function addLabel(c)
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

local function pageCounts()
    local flipped = 0
    for _, c in ipairs(R.cards) do
        if c.flipped then
            flipped = flipped + 1
        end
    end
    return flipped, #R.cards
end

-- The card is face up: shows all of it (whatever its animation got to) and what it is.
local function showFaceUp(c)
    if R == nil then
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
    addLabel(c)
    updateControls()
end

-- Turns a card over (see FLIP_SECONDS): the back lifts and closes edge-on, the face widens out, then its picture and
-- text come in. Without a burst it ends as the face opens.
flipCard = function(c)
    if R == nil or c.flipped or c.flipping then
        return
    end
    prepare(c)
    if c.view == nil then
        -- Its model could not be made: it is shown as turned anyway, with what it is written under it.
        c.flipping = true
        showFaceUp(c)
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
    end, function() showFaceUp(c) end)
end

-- Removes the cards of the page on show.
local function clearCards()
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

-- ---------------------------------------------------------------------------------------
-- The controls: a line of text and the main button at the bottom of the screen.

local function setLabel(label)
    if R.mainLabel ~= label then
        R.mainLabel = label
        Kit.setLabel(R.main, label)
    end
end

local function setEnabled(enabled)
    if R.mainEnabled ~= enabled then
        R.mainEnabled = enabled
        Kit.setEnabled(R.main, enabled)
    end
end

updateControls = function()
    if R == nil then
        return
    end
    local stage = R.stage
    if stage == "sealed" then
        setText(R.status, #R.results .. (#R.results == 1 and " card inside" or " cards inside"))
        setLabel("Tear open")
        setEnabled(true)
    elseif stage == "cards" then
        local flipped, total = pageCounts()
        local text = flipped .. " of " .. total .. " revealed"
        if R.pages > 1 then
            text = "Page " .. R.page .. " of " .. R.pages .. "  -  " .. text
        end
        if flipped == total and R.page == R.pages then
            text = text .. "  -  " .. R.newCards .. (R.newCards == 1 and " new card" or " new cards")
        end
        setText(R.status, text)
        if flipped < total then
            setLabel("Reveal all")
            setEnabled(R.auto == nil)
        else
            setLabel((R.page < R.pages) and "Next page" or "Done")
            setEnabled(true)
        end
    elseif stage == "dealing" then
        setText(R.status, R.dealingText or "Shuffling...")
        setEnabled(false)
    else
        setEnabled(false)
    end
end

-- ---------------------------------------------------------------------------------------
-- The pages: a stack of face-down cards, shuffled and dealt out into a grid.

-- Makes page `k`'s cards, face down, in a stack: inside the pack (placeStack) for the first page of a designed pack, or
-- straight at the middle for the others. Their places in the grid are worked out.
local function makePage(k)
    clearCards()
    R.page = k
    local first = (k - 1) * R.pageSize + 1
    local last = math.min(#R.results, k * R.pageSize)
    local count = last - first + 1
    R.slots = slotsFor(count)
    -- The first is made last, so it is in front.
    for i = count, 1, -1 do
        R.cards[i] = makeCard(first + i - 1)
    end
    for i, c in ipairs(R.cards) do
        c.x, c.y = R.slots[i].x, R.slots[i].y
    end
    -- The stack's place: centred, level with the middle of the grid.
    local rows = #rowSizes(count, R.cols)
    local gridH = rows * (R.ch + LABEL_H) + (rows - 1) * GAP
    local top = math.floor(((R.SH - BAR_H) - gridH) / 2)
    R.stackX = math.floor((R.SW - R.cw) / 2)
    R.stackY = top + (gridH - LABEL_H - R.ch) // 2
    for i, c in ipairs(R.cards) do
        placeBack(c, R.stackX, R.stackY - (i - 1) * STACK_STEP, R.cw, R.ch)
    end
end

-- Shuffles the stack (the cards swing out to either side and back, a few times), then deals them out into their places,
-- one after the other.
startDealing = function(noShuffle)
    R.stage = "dealing"
    R.dealingText = noShuffle and "Dealing..." or "Shuffling..."
    updateControls()
    local cards = R.cards
    local n = #cards
    local shuffle = noShuffle and 0 or SHUFFLE_SECONDS       -- (the later pages are only dealt out)
    local total = shuffle + SPREAD_SECONDS + SPREAD_STAGGER * (n - 1)
    Anim.start(R, total, function(p)
        local t = p * total
        local u = shuffle > 0 and math.min(1, t / shuffle) or 1
        local env = math.sin(u * math.pi)
        for i, c in ipairs(cards) do
            local bx, by = R.stackX, R.stackY - (i - 1) * STACK_STEP
            if t < shuffle then
                local dir = (i % 2 == 0) and 1 or -1
                local swing = math.sin(u * SHUFFLE_ROUNDS * 2 * math.pi + (i % 3) * 0.4)
                c.back:SetPos(math.floor(bx + dir * swing * R.cw * SHUFFLE_SWING * env), math.floor(by + ((i % 3) - 1) * 8 * env))
                pcall(function() c.back.rotationDegrees = dir * swing * 8 * env end)
                c.rotated = true
            else
                local q = clamp01((t - shuffle - (i - 1) * SPREAD_STAGGER) / SPREAD_SECONDS)
                local e = Anim.smooth(q)
                if c.rotated then
                    c.rotated = false
                    pcall(function() c.back.rotationDegrees = 0 end)
                end
                c.back:SetPos(math.floor(bx + (c.x - bx) * e), math.floor(by + (c.y - by) * e))
            end
        end
    end, function()
        for _, c in ipairs(cards) do
            if c.back ~= nil then
                pcall(function() c.back.rotationDegrees = 0 end)
                placeBack(c, c.x, c.y, c.w, c.h)
            end
        end
        R.stage = "cards"
        if R.faceUp then
            R.auto = { timer = 0 }        -- a pack opened back side up: all its cards turn by themselves
        end
        updateControls()
    end)
end

-- ---------------------------------------------------------------------------------------
-- The sealed pack: tearing it open and flipping it over.

-- The Flip pack button: a small refresh arrow under a designed sealed pack, while the pack is untouched.
local function setFlipButton(shown)
    if R.flipButton ~= nil then
        destroy(R.flipButton)
        R.flipButton = nil
    end
    if shown then
        local tear = R.tear
        R.flipButton = Kit.iconButton(R.root, "REFRESH", (R.SW - FLIP_ICON) // 2, tear.y0 + tear.h + 10,
            function() flipSealed() end, "Flip pack")
    end
end

-- Moves the pack and what goes with it (its glow, the tear guide, the cards inside) to `lift` pixels above its place.
local function setLift(lift)
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
local function placeGuide(guide, cut)
    local tear = R.tear
    guide.y = tear.y + math.floor(PackArt.TEAR_Y * tear.cap.s) - GUIDE_H // 2
    guide.clip:SetPos(tear.x + cut, guide.y)
end

-- Shows the tear `rip` (0 to 1) of the way across the pack: the cap's columns behind the tear lift, the furthest behind
-- the most, so the cap peels up.
local function drawRip(rip)
    local tear = R.tear
    tear.rip = rip
    if rip > 0 and R.flipButton ~= nil then
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
        placeGuide(guide, cut)
        guide.clip:SetSize(math.max(1, w - cut), GUIDE_H)
        guide.inner:SetPos(-cut, 0)
        tear.cut = cut
    end
end

-- Pulses the tear guide and runs its glint along it (every frame while the pack is sealed).
local function animateGuide(clock)
    local guide = R.tear and R.tear.guide
    if guide == nil or R.stage ~= "sealed" then
        return
    end
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
local function placeStack(settle)
    local tear = R.tear
    local sw = math.floor(tear.w * STACK_W)
    local sh = math.floor(sw * R.ch / R.cw)
    local fromX, fromY = tear.x + (tear.w - sw) / 2, tear.y0 + STACK_TOP * tear.cap.s
    local w, h = sw + (R.cw - sw) * settle, sh + (R.ch - sh) * settle
    local x, y = fromX + (R.stackX - fromX) * settle, fromY + (R.stackY - fromY) * settle
    for i, c in ipairs(R.cards) do
        placeBack(c, x, y - (i - 1) * STACK_STEP, w, h)
    end
end

-- Dragging across the top of the pack tears it as far as the mouse goes (left to right). As in the Pack Maker, pressing
-- stretches the invisible grip over the whole screen so it keeps getting the hold and release wherever the mouse goes.
-- A press without a drag tears it open by itself.
local function makeGrip()
    local tear = R.tear
    local gripH = math.floor(GRIP_H * tear.cap.s)
    -- The pack is many small parts, so a see-through rectangle over the whole of it takes a click, and tells (every frame,
    -- see onFrame) whether the mouse is over it, which makes the pack lift and glow like a prompt. The grip, over its top,
    -- is made after it so it gets the clicks there.
    local catcher = ui.Rectangle.new(R.root)
    R.catcher = catcher
    catcher:SetPos(tear.x, tear.y0)
    catcher:SetSize(tear.w, tear.h)
    catcher.fill = true
    catcher.colour = Vector4.new(0, 0, 0, 0)
    pcall(function() catcher.clickthrough = false end)
    pcall(function() catcher:Subscribe(ui.Hook.ONCLICK, function() onMain() end) end)
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
        if R == nil or R.tear ~= tear or R.stage ~= "sealed" or Anim.running(R) or drag ~= nil then
            return
        end
        local x = Kit.mouseX()
        if x == nil then
            onMain()
            return
        end
        drag = { mouseX = x, rip = tear.rip, moved = false }
        grip:SetPos(0, 0)
        grip:SetSize(0, 0, 1, 1)
        pcall(function() grip:MoveToFront() end)
    end)
    grip:Subscribe(ui.Hook.ONHOLD, function()
        local x = drag and Kit.mouseX()
        if x == nil or R == nil or R.tear ~= tear then
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
        if R ~= nil and R.tear == tear and (not moved or tear.rip >= DRAG_FINISH) then
            startTear()
        end
    end)
end

-- Draws a designed pack, `side` up, as the two pieces it tears into (see PackArt.tearY), in the sealed pack's place.
-- Returns body, cap.
local function makePieces(tear, side, art)
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
local function makeGuide(tear)
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

-- First stage: the sealed pack. A pack type with a design (made in the Pack Maker) shows its front, can be flipped over
-- (Flip pack) and tears open; any other shows the pack image. If neither can be shown the cards are dealt at once.
local function showSealed()
    R.stage = "sealed"
    local art = PackArt.designFor(R.packTypeId)
    local packH = R.packH
    local w = (art ~= nil) and math.floor(PackArt.W * packH / PackArt.H + 0.5) or math.floor(packH * PackArt.PACK_IMAGE_ASPECT)
    local x = (R.SW - w) // 2
    local y0 = math.floor(((R.SH - BAR_H) - packH) / 2)
    makePage(1)
    if art ~= nil then
        local tear = { rip = 0, x = x, y0 = y0, y = y0, w = w, h = packH, lift = 0 }
        R.tear = tear
        -- The glow behind the pack, which shows when the mouse is over it.
        local glowImage = image("glow_legendary")
        if glowImage ~= nil then
            tear.glow = ui.Sprite.new(R.root)
            tear.glow.sprite = glowImage
            tear.glow:SetSize(w + 2 * HOVER_GLOW_PAD, packH + 2 * HOVER_GLOW_PAD)
            tear.glow.alpha = 0
        end
        -- (the cards of the first page were made first, so they are behind the pack)
        tear.body, tear.cap = makePieces(tear, R.side, art)
        R.packArts = { tear.body, tear.cap }
        tear.guide = makeGuide(tear)
        makeGrip()
        setLift(0)
        drawRip(0)
        placeStack(0)
        setFlipButton(true)
    else
        local sprite = ui.Sprite.new(R.root)
        sprite:SetPos(x, y0)
        sprite:SetSize(w, packH)
        local picture = image("pack")
        if picture == nil then
            destroy(sprite)
            for i, c in ipairs(R.cards) do
                placeBack(c, R.stackX, R.stackY - (i - 1) * STACK_STEP, R.cw, R.ch)
            end
            startDealing()
            return
        end
        sprite.sprite = picture
        sprite.clickthrough = false
        pcall(function() sprite:Subscribe(ui.Hook.ONCLICK, function() onMain() end) end)
        R.pack = { sprite = sprite, x = x, y = y0, w = w, h = packH }
        for i, c in ipairs(R.cards) do
            placeBack(c, R.stackX, R.stackY - (i - 1) * STACK_STEP, R.cw, R.ch)
            setHidden(c.back, true)
        end
    end
    updateControls()
end

-- A pack without a design swells a little and fades out; then the cards are dealt.
local function swellPack()
    local pack = R.pack
    R.stage = "tearing"
    updateControls()
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
        startDealing()
    end)
end

-- Turns the sealed pack over (Flip pack): the torn pieces narrow to nothing (PackArt.squash), then are swapped for
-- the other side's pieces, which widen out. Only one side exists at a time, as each is many parts. The cards inside
-- and the tear guide are hidden meanwhile. Opened back side up, its cards are all turned over once dealt.
flipSealed = function()
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
    setFlipButton(false)
    updateControls()
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
            tear.body, tear.cap = makePieces(tear, to, art)
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
        setLift(tear.lift)
        drawRip(0)
        placeStack(0)
        setFlipButton(true)
        updateControls()
    end)
end

-- Tears the designed pack open from wherever the tear has got to: the rest of the tear, the cap flying off up and to the
-- right, the pack dropping away below the stack of cards, and the stack growing into place. Then the cards are shuffled.
startTear = function()
    local tear = R ~= nil and R.tear or nil
    if tear == nil or R.stage ~= "sealed" or Anim.running(R) then
        return
    end
    R.stage = "tearing"
    tear.torn = true
    if tear.glow ~= nil then
        setHidden(tear.glow, true)
    end
    setFlipButton(false)
    updateControls()
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
            drawRip(from + (1 - from) * phase(t, 0, ripEnd))
        end
        -- The cap speeds up as it goes, until it is out of the top of the screen.
        local cap = phase(t, ripEnd, CAP_SECONDS) ^ 2
        tear.cap.root:SetPos(tear.x + math.floor(70 * cap), tear.y - math.floor((tear.y + capH) * cap))
        -- The pack drops out of the bottom of the screen, uncovering the cards.
        local drop = phase(t, dropStart, DROP_SECONDS) ^ 2
        tear.body.root:SetPos(tear.x, tear.y + math.floor((R.SH - tear.y) * drop))
        placeStack(Anim.smooth(phase(t, dropEnd, SETTLE_SECONDS)))
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
        for i, c in ipairs(R.cards) do
            placeBack(c, R.stackX, R.stackY - (i - 1) * STACK_STEP, R.cw, R.ch)
        end
        startDealing()
    end)
end

-- ---------------------------------------------------------------------------------------
-- The buttons.

local function revealAll()
    if R.auto == nil then
        R.auto = { timer = AUTO_STEP }       -- the first turns at once
    end
    updateControls()
end

local function nextPage()
    if R.page < R.pages then
        R.auto = nil
        makePage(R.page + 1)
        startDealing(true)
        if R.instant then
            Anim.skip(R)                         -- (after Skip the cards are just put in their places)
        end
    else
        closeReveal()
    end
end

-- The main button (and a click on the pack): what it does depends on the stage.
onMain = function()
    if R == nil then
        return
    end
    if R.stage == "sealed" then
        if R.tear ~= nil then
            startTear()
        elseif R.pack ~= nil then
            swellPack()
        end
    elseif R.stage == "cards" then
        local flipped, total = pageCounts()
        if flipped < total then
            revealAll()
        else
            nextPage()
        end
    end
end

-- Skip: finishes what is playing (the flipping of the sealed pack, the tear, the shuffle and the dealing, each starting the
-- next as it ends) until the cards are down, and turns them all over without their animation (see onFrame). Pages after
-- this one are the same. Does nothing when it has been used already.
local function skipToCards()
    if R == nil or R.instant then
        return
    end
    R.instant = true
    R.auto = nil
    for _ = 1, 8 do
        if R == nil or R.stage == "cards" then
            break
        end
        if Anim.running(R) then
            Anim.skip(R)
        elseif R.stage == "sealed" then
            onMain()                             -- tears it open, or swells the pack image away
        else
            break
        end
    end
    if R == nil then
        return
    end
    for _, c in ipairs(R.cards) do
        if c.flipping then
            Anim.skip(c)
        end
    end
    destroy(R.skip)                              -- nothing left to skip
    R.skip = nil
    updateControls()
end
Reveal.skip = skipToCards

-- ---------------------------------------------------------------------------------------
-- Running it.

-- Runs every frame: the clock, the pack's lift and its guide, the cards' faces being made, the cards being turned all at
-- once, and the glows of the turned cards.
local function onFrame(dt)
    R.clock = R.clock + dt
    local tear = R.tear
    if tear ~= nil and R.stage == "sealed" then
        animateGuide(R.clock)
        -- The lift follows the mouse smoothly; nothing is redrawn once it has settled.
        local over = false
        pcall(function() over = R.catcher.isMouseOver == true or R.grip.isMouseOver == true end)
        local target = (over and tear.rip == 0) and 1 or 0
        local step = dt / HOVER_SECONDS
        R.hoverT = R.hoverT + math.max(-step, math.min(step, target - R.hoverT))
        local lift = math.floor(HOVER_LIFT * Anim.smooth(R.hoverT) + 0.5)
        if lift ~= tear.lift then
            setLift(lift)
            drawRip(tear.rip)
            placeStack(0)
        end
        if tear.glow ~= nil then
            tear.glow.alpha = HOVER_GLOW_ALPHA * Anim.smooth(R.hoverT)
        end
    end

    if R.stage == "cards" then
        -- Faces are made one a frame, so turning a card never has to make it.
        for _, c in ipairs(R.cards) do
            if c.view == nil and not c.failed then
                prepare(c)
                break
            end
        end
        -- After Skip: every card whose face is made is turned over at once (the others as they are made).
        if R.instant then
            for _, c in ipairs(R.cards) do
                if not c.flipped and (c.view ~= nil or c.failed) then
                    if c.flipping then
                        Anim.skip(c)
                    else
                        showFaceUp(c)
                    end
                end
            end
        end
        -- "Reveal all": a card every AUTO_STEP seconds.
        if R.auto ~= nil then
            R.auto.timer = R.auto.timer + dt
            if R.auto.timer >= AUTO_STEP then
                R.auto.timer = 0
                local nextCard = nil
                for _, c in ipairs(R.cards) do
                    if not c.flipped and not c.flipping then
                        nextCard = c
                        break
                    end
                end
                if nextCard ~= nil then
                    flipCard(nextCard)
                else
                    R.auto = nil
                    updateControls()
                end
            end
        end
        -- The glow of a turned card flashes bright as its picture appears, dies down over GLOW_FLASH_SECONDS, then
        -- breathes between GLOW_MIN and full brightness. Only one value changes each frame (the image's alpha).
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
end

local failures = 0

local function onDraw(e)
    if R == nil then
        return
    end
    local ok, err = pcall(onFrame, Anim.frameSeconds(e))
    if ok then
        failures = 0
        return
    end
    failures = failures + 1
    Logger.error("reveal: a frame failed:", tostring(err))
    if failures >= 3 then
        Logger.error("reveal: closing, as it keeps failing")
        closeReveal()
    end
end

Events.on("Draw", "cardcollector_reveal", onDraw)

-- True while cards that were bought are still being revealed (a new purchase has to wait).
function Reveal.active()
    return R ~= nil
end

-- The cards of the pack being opened that the player has not seen yet, as { [variant key] = copies }: they are already in
-- the collection (Packs.open adds the whole pack at once), so the collection viewer leaves them out until they have been
-- turned over. Empty when no pack is being opened.
function Reveal.hiddenCards()
    local hidden = {}
    if R == nil then
        return hidden
    end
    for _, result in ipairs(R.results) do
        if not result.seen then
            hidden[result.key] = (hidden[result.key] or 0) + 1
        end
    end
    return hidden
end

-- Closes the screen and everything on it. Safe to call when it is not open.
closeReveal = function()
    local r = R
    if r == nil then
        return
    end
    Anim.cancel(r)
    Anim.cancel(r.fade)
    pcall(clearCards)
    for _, piece in ipairs(r.packArts or {}) do
        pcall(PackArt.destroy, piece)
    end
    destroy(r.flipButton)
    destroy(r.main)
    destroy(r.skip)
    destroy(r.status)
    destroy(r.root)                -- and with it everything made inside it
    emptied(r.tear)                -- (a pack still sealed: the grip's handlers hold `tear`, which holds the pack's parts)
    R = nil
    failures = 0
    if r.hooks ~= nil and r.hooks.onClose ~= nil then
        pcall(r.hooks.onClose)
    end
end

Reveal.close = closeReveal

local function begin(results, packTypeId, hooks)
    local SW, SH = screenSize()
    local parent = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    R = { results = results, packTypeId = packTypeId, hooks = hooks, SW = SW, SH = SH, clock = 0, hoverT = 0,
        side = "front", faceUp = false, newCards = 0, fade = {}, cards = {} }
    R.root = ui.Layer.new(parent)
    R.root:SetPos(0, 0)
    R.root:SetSize(0, 0, 1.0, 1.0)
    R.root.clickthrough = false
    pcall(function() R.root:MoveToFront() end)
    R.dim = ui.Rectangle.new(R.root)
    R.dim:SetPos(0, 0)
    R.dim:SetSize(0, 0, 1.0, 1.0)
    R.dim.fill = true
    R.dim.colour = Vector4.new(0, 0, 0, 0)
    Anim.start(R.fade, DIM_SECONDS, function(p)
        R.dim.colour = Vector4.new(0, 0, 0, DIM_ALPHA * p)
    end)

    R.scale = chooseScale(SW, SH, #results)
    R.cw, R.ch = cardSize(R.scale)
    R.cols = math.max(1, math.min(PAGE_COLS, (SW - 2 * SIDE_MARGIN + GAP) // (R.cw + GAP)))
    local maxRows = math.max(1, (SH - BAR_H - 20 + GAP) // (R.ch + LABEL_H + GAP))
    R.pageSize = math.max(1, math.min(PAGE_SIZE, R.cols * maxRows))
    R.pages = math.ceil(#results / R.pageSize)
    R.packH = math.max(PACK_H_MIN, math.min(PACK_H_MAX, math.floor(SH * 0.45)))

    -- The bottom bar: a line of text over the main button, and Skip at the top right.
    R.status = Kit.text(R.root, R.SW // 2 - 250, SH - BAR_H + 30, 500, 22, "", GREY)
    R.main = Kit.buttonAt(R.root, "Tear open", R.SW // 2 - 100, SH - BAR_H + 62, 200, 34, function()
        local ok, err = pcall(onMain)
        if not ok then
            Logger.error("reveal: the button failed:", tostring(err))
            closeReveal()
        end
    end, "positive")
    R.mainLabel = "Tear open"
    R.skip = Kit.buttonAt(R.root, "Skip", SW - 150, 24, 110, 30, function()
        local ok, err = pcall(skipToCards)
        if not ok then
            Logger.error("reveal: Skip failed:", tostring(err))
            closeReveal()
        end
    end, nil, "Show the cards now")

    R.results = results
    showSealed()
end

-- The main button's action, as if it had been pressed (used by dev/check_reveal_ui.lua; the reveal is otherwise driven by
-- its own buttons and clicks).
function Reveal.pressMain()
    if R ~= nil then
        onMain()
    end
end

-- The reveal under way (for tests), or nil.
function Reveal.state()
    return R
end

-- Starts the reveal of cards that were just bought (and saved): `results` from Packs.open, `packTypeId` the pack bought.
-- Returns true if it started. `hooks.onClose` is called when it closes, for whatever reason.
function Reveal.start(results, packTypeId, hooks)
    if R ~= nil or results == nil or #results == 0 then
        return false
    end
    local ok, err = pcall(begin, results, packTypeId, hooks)
    if not ok then
        Logger.error("reveal: could not be started:", tostring(err))
        closeReveal()
        return false
    end
    return true
end

return Reveal
