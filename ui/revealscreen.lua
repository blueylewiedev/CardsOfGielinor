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
--
-- This file runs the stages and the buttons and owns the reveal's table `R`. ui/revealpack.lua is the sealed pack,
-- ui/revealcards.lua a card and ui/revealgrid.lua works out where they go. They are given `R` and say what happened
-- through the functions they are passed, so no stage calls another by name.

local Logger = require("core/logger")
local Kit = require("ui/kit")
local Anim = require("ui/anim")
local Events = require("core/events")
local RevealCards = require("ui/revealcards")
local RevealGrid = require("ui/revealgrid")
local RevealPack = require("ui/revealpack")
local Theme = require("ui/theme")
local GREY = Theme.GREY
local Util = require("ui/util")
local destroy, setText, emptied = Util.destroy, Util.setText, Util.emptied

local Reveal = {}

-- The screen.
local DIM_ALPHA = 0.78
local DIM_SECONDS = 0.3
local BAR_H = RevealGrid.BAR_H          -- the bottom bar (the line of text and the button) and the space above it

-- The shuffle and the spread.
local SHUFFLE_SECONDS, SHUFFLE_ROUNDS = 1.4, 3
local SHUFFLE_SWING = 0.1                     -- how far the cards swing out to a side, as a fraction of their width
local SPREAD_SECONDS, SPREAD_STAGGER = 0.6, 0.05
local AUTO_STEP = 0.18                  -- seconds between cards when they are turned all at once
local STACK_STEP = RevealCards.STACK_STEP

-- The reveal under way, or nil. Fields: results, packTypeId, hooks, root, dim, SW, SH, areaH (the height above the bottom
-- bar), scale, cw, ch (card size), cols, pageSize, page, pages, cards (this page's), slots, stackX, stackY, stage, side,
-- faceUp, clock, tear / pack / packArts / grip / catcher / flipButton (the sealed pack, see ui/revealpack.lua), status,
-- main, skip, newCards, auto, instant (Skip was used: no more animations).
-- `R` is emptied when the screen closes (Util.emptied), as the client keeps the handlers of destroyed components and
-- they reach `R`. dev/check_reveal_ui.lua checks that none left behind reaches a model, a model group or a sprite.
local R = nil

local failures = 0                       -- frames in a row that failed (see onDraw)

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

local function updateControls()
    if R == nil then
        return
    end
    local stage = R.stage
    if stage == "sealed" then
        setText(R.status, #R.results .. (#R.results == 1 and " card inside" or " cards inside"))
        setLabel("Tear open")
        setEnabled(true)
    elseif stage == "cards" then
        local flipped, total = RevealCards.counts(R)
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

-- Closes the screen and everything on it. Safe to call when it is not open.
local function closeReveal()
    local r = R
    if r == nil then
        return
    end
    Anim.cancel(r)
    Anim.cancel(r.fade)
    pcall(RevealCards.clear, r)
    RevealPack.destroy(r)
    destroy(r.main)
    destroy(r.skip)
    destroy(r.status)
    destroy(r.root)                -- and with it everything made inside it
    R = nil
    failures = 0
    local onClose = r.hooks ~= nil and r.hooks.onClose or nil
    emptied(r)                     -- (what the handlers left in the client reach through it)
    if onClose ~= nil then
        pcall(onClose)
    end
end

-- ---------------------------------------------------------------------------------------
-- The pages: a stack of face-down cards, shuffled and dealt out into a grid.

-- Turns a card (see RevealCards.flip) when its back is clicked, or does nothing if it can't be.
local function onCardClick(c)
    if R == nil or R.stage ~= "cards" or c.flipped then
        return
    end
    if c.flipping then
        Anim.skip(c)
        return
    end
    RevealCards.flip(R, c, updateControls)
end

-- Makes page `k`'s cards, face down, in a stack: inside the pack (see RevealPack.show) for the first page of a designed
-- pack, or straight at the middle for the others. Their places in the grid are worked out.
local function makePage(k)
    RevealCards.clear(R)
    R.page = k
    local first = (k - 1) * R.pageSize + 1
    local last = math.min(#R.results, k * R.pageSize)
    local count = last - first + 1
    R.slots, R.stackX, R.stackY = RevealGrid.page(R, count)
    -- The first is made last, so it is in front.
    for i = count, 1, -1 do
        R.cards[i] = RevealCards.make(R, first + i - 1, onCardClick)
    end
    for i, c in ipairs(R.cards) do
        c.x, c.y = R.slots[i].x, R.slots[i].y
    end
    RevealCards.placeStack(R, R.stackX, R.stackY, R.cw, R.ch)
end

-- Shuffles the stack (the cards swing out to either side and back, a few times), then deals them out into their places,
-- one after the other.
local function startDealing(noShuffle)
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
                local q = math.max(0, math.min(1, (t - shuffle - (i - 1) * SPREAD_STAGGER) / SPREAD_SECONDS))
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
                RevealCards.placeBack(c, c.x, c.y, c.w, c.h)
            end
        end
        R.stage = "cards"
        if R.faceUp then
            R.auto = { timer = 0 }        -- a pack opened back side up: all its cards turn by themselves
        end
        updateControls()
    end)
end

-- What the sealed pack does when it needs the controls redrawn, and once it is gone: the cards are shuffled and dealt.
local packEvents = { changed = updateControls, opened = function() startDealing() end }

-- First stage: the sealed pack (see RevealPack.show). If there is nothing to show of it the cards are dealt at once.
local function showSealed()
    R.stage = "sealed"
    makePage(1)
    if RevealPack.show(R, packEvents) then
        updateControls()
    else
        startDealing()
    end
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
local function onMain()
    if R == nil then
        return
    end
    if R.stage == "sealed" then
        RevealPack.open(R, packEvents)
    elseif R.stage == "cards" then
        local flipped, total = RevealCards.counts(R)
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
    RevealPack.animate(R, dt)

    if R.stage == "cards" then
        -- Faces are made one a frame, so turning a card never has to make it.
        for _, c in ipairs(R.cards) do
            if c.view == nil and not c.failed then
                RevealCards.prepare(R, c)
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
                        RevealCards.showFaceUp(R, c, updateControls)
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
                    RevealCards.flip(R, nextCard, updateControls)
                else
                    R.auto = nil
                    updateControls()
                end
            end
        end
        RevealCards.animateGlows(R, dt)
    end
end

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

Reveal.close = closeReveal

local function begin(results, packTypeId, hooks)
    local SW, SH = screenSize()
    local parent = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    R = { results = results, packTypeId = packTypeId, hooks = hooks, SW = SW, SH = SH, areaH = SH - BAR_H, clock = 0,
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

    local fit = RevealGrid.fit(SW, SH, #results)
    R.scale, R.cw, R.ch, R.cols = fit.scale, fit.cw, fit.ch, fit.cols
    R.pageSize, R.pages, R.packH = fit.pageSize, fit.pages, fit.packH

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
