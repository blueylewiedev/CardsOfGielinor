-- ui/packwindow.lua
-- The window for choosing a difficulty, buying packs and revealing the cards.
--
-- It has four screens, and only one is shown at a time:
--   nosession : nobody is logged in yet
--   setup     : first run, pick a difficulty tier
--   home      : credits, pack price and the Open pack button
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

local PackWindow = {}

local FONT = id.Font.MUSEO_SANS_15PT_REGULAR
local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GOLD = Vector4.new(1.0, 0.84, 0.2, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)

local WIDTH = 236
-- The setup screen is wider: its longest button label ("Master - 20 credits") needs about 250.
local EXTRA_TOP = 220      -- where the extra buttons on the Home screen start
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
-- Window height for each screen.
local HEIGHTS = { nosession = 90, setup = 262, home = 222 + 38, reveal = REVEAL_TOP + 124 }

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
local reveal = { results = nil, index = 0, view = nil, parts = {}, pips = {}, stage = nil, anim = nil, clock = 0 }

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
    window:SetSize(({ reveal = REVEAL_WIDTH, setup = SETUP_WIDTH })[name] or WIDTH, HEIGHTS[name] + (Kit.available() and TITLE_BAR or 0))
end

-- ---------------------------------------------------------------------------------------
-- The pack opening.
--
-- A pack is bought and rolled straight away (and saved), then shown in stages:
--   sealed    : the pack image. "Tear open" (or clicking the pack) opens it.
--   facedown  : the next card, showing the card back. "Flip card" (or clicking it) turns it.
--   faceup    : the card, whether it is new, and a glow for rarer cards.
--                "Next" goes to the following card, "Done" after the last one.
-- Tearing the pack and flipping a card are short animations driven by the Draw event.
-- If the pack image is missing the sealed stage is skipped; if the card back is missing a
-- plain dark card back is drawn instead.

local GLOW_SPEED = 4                   -- how fast the glow breathes (radians per second; 2 pi is one breath)
local GLOW_MIN = 0.45                  -- the dimmest it gets, as a fraction of its full brightness
local GLOW_STRENGTH = 1.0                -- overall brightness of the glow, on top of each rarity's own
local TEAR_SECONDS = 0.45
local FLIP_SECONDS = 0.4
local PACK_ASPECT = 320 / 512            -- the pack image is 320 x 512

-- Pips under the card, one per card in the pack.
local PIP_W, PIP_H, PIP_GAP = 26, 8, 6

local PIP_UNSEEN = Vector4.new(0.35, 0.35, 0.38, 1.0)

local imageCache = {}

-- Loads an image from resources/images, once. Returns nil (and logs) if it is not there.
local function image(name)
    local cached = imageCache[name]
    if cached ~= nil then
        return cached or nil
    end
    local ok, resource = pcall(function() return Plugin.resources.images[name] end)
    if not ok or resource == nil then
        log("reveal: no image resources/images/" .. name .. ".png")
        imageCache[name] = false
        return nil
    end
    pcall(function() resource:Load() end)
    imageCache[name] = resource
    return resource
end

-- Turns a 0xRRGGBBAA colour number into a Vector4 (parts 0-1), with a different alpha.
local function toColour(hex, alpha)
    return Vector4.new(((hex >> 24) & 0xFF) / 255, ((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255, alpha)
end

-- Left edge of the card on the reveal screen, centred in the window.
local function revealCardX()
    return (REVEAL_MID - CardView.WIDTH) // 2
end

-- Destroys everything drawn for the current stage (pack, card, back, glow).
local function clearParts()
    for _, part in ipairs(reveal.parts) do
        pcall(function() part:Destroy() end)
    end
    reveal.parts = {}
    reveal.view = nil
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
    clearParts()
    clearPips()
    reveal.results = nil
    reveal.index = 0
    reveal.stage = nil
    reveal.anim = nil
end

-- One pip per card. Cards already flipped take their rarity colour.
local function drawPips(flipped)
    clearPips()
    local total = #reveal.results
    local startX = (REVEAL_MID - (total * PIP_W + (total - 1) * PIP_GAP)) // 2
    for i = 1, total do
        local pip = ui.Rectangle.new(content)
        pip:SetPos(startX + (i - 1) * (PIP_W + PIP_GAP), REVEAL_TOP + 70)
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

-- First stage of a pack: the sealed pack. If the pack image is missing this stage is skipped.
local function showSealed()
    showScreen("reveal")
    clearParts()
    reveal.stage = "sealed"
    reveal.index = 0
    local pack = image("pack")
    if pack ~= nil then
        local h = CardView.HEIGHT
        local w = math.floor(h * PACK_ASPECT)
        local sprite = track(ui.Sprite.new(content))
        sprite:SetPos((REVEAL_MID - w) // 2, CARD_Y)
        sprite:SetSize(w, h)
        sprite.sprite = pack
        reveal.pack = { sprite = sprite, x = (REVEAL_MID - w) // 2, y = CARD_Y, w = w, h = h }
        clickable(sprite)
    end
    setText(widgets.variantText, "")
    setText(widgets.newText, "")
    setText(widgets.counterText, #reveal.results .. " cards inside")
    Kit.setLabel(widgets.nextButton, "Tear open")
    drawPips(0)
end

-- The next card, face down: its face is built underneath, and the card back covers it.
local function showFaceDown()
    showScreen("reveal")
    clearParts()
    reveal.stage = "facedown"
    local result = reveal.results[reveal.index]
    local x = revealCardX()
    local rarity = Cards.rarities[result.card.rarity]

    -- The glow is a soft, rounded image (resources/images/glow_<rarity>.png) behind the card.
    -- It is invisible until the card is flipped, so it does not give the rarity away. Common
    -- cards have no glow, and a rarity whose image is missing simply goes without.
    reveal.glow = nil
    local glowImage = Settings.get("glow") and ((rarity.glow or 0) > 0) and image("glow_" .. result.card.rarity) or nil
    if glowImage ~= nil then
        local glow = track(ui.Sprite.new(content))
        glow:SetPos(x - GLOW_PAD, CARD_Y - GLOW_PAD)
        glow:SetSize(CardView.WIDTH + 2 * GLOW_PAD, CardView.HEIGHT + 2 * GLOW_PAD)
        glow.sprite = glowImage
        glow.alpha = 0.0
        reveal.glow = { sprite = glow, strength = rarity.glow, age = 0 }
    end

    reveal.view = CardView.create(content, result.card)
    reveal.view.root:SetPos(x, CARD_Y)
    track(reveal.view.root)
    -- Hidden until it is flipped, so nothing of it (a frame edge, the glow) can show round the
    -- card back and give the rarity away.
    pcall(function() reveal.view.root.hidden = true end)
    log("reveal:", result.card.id, result.finish, "model", tostring(reveal.view.model ~= nil))

    local back = image("card_back")
    local cover
    if back ~= nil then
        cover = track(ui.Sprite.new(content))
        cover:SetPos(x, CARD_Y)
        cover:SetSize(CardView.WIDTH, CardView.HEIGHT)
        cover.sprite = back
    else
        cover = track(ui.Rectangle.new(content))
        cover:SetPos(x, CARD_Y)
        cover:SetSize(CardView.WIDTH, CardView.HEIGHT)
        cover.fill = true
        cover.colour = Vector4.new(0.10, 0.10, 0.14, 1.0)
    end
    reveal.back = cover
    clickable(cover)

    setText(widgets.variantText, "")
    setText(widgets.newText, "")
    setText(widgets.counterText, "Card " .. reveal.index .. " of " .. #reveal.results)
    Kit.setLabel(widgets.nextButton, "Flip card")
    drawPips(reveal.index - 1)
end

-- The card has been turned over: show what it is.
local function showFaceUp()
    reveal.stage = "faceup"
    if reveal.view ~= nil then
        pcall(function() reveal.view.root.hidden = false end)
    end
    if reveal.back ~= nil then
        pcall(function() reveal.back:Destroy() end)
        reveal.back = nil
    end
    -- Clicking the revealed card moves on to the next one, like the Next button. The card is
    -- made of several pieces that may take the click themselves, so a see-through rectangle is
    -- laid over the whole card to catch it.
    if reveal.view ~= nil then
        local overlay = track(ui.Rectangle.new(content))
        overlay:SetPos(revealCardX(), CARD_Y)
        overlay:SetSize(CardView.WIDTH, CardView.HEIGHT)
        overlay.fill = true
        overlay.colour = Vector4.new(0.0, 0.0, 0.0, 0.0)
        clickable(overlay)
        clickable(reveal.view.root)
    end
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

-- Starts an animation of `seconds`. update(p) is called every frame with p from 0 to 1, and
-- finish() once at the end. Starting one while another runs finishes the old one first.
local function startAnim(seconds, update, finish)
    if reveal.anim ~= nil then
        reveal.anim.update(1)
        local old = reveal.anim
        reveal.anim = nil
        old.finish()
    end
    reveal.anim = { t = 0, seconds = seconds, update = update, finish = finish }
end

-- Moves the reveal on one step. Called by the main button and by clicking the pack or card.
function PackWindow.advance()
    if reveal.results == nil then
        return
    end
    -- A click during an animation skips to its end.
    if reveal.anim ~= nil then
        local anim = reveal.anim
        reveal.anim = nil
        anim.update(1)
        anim.finish()
        return
    end

    if reveal.stage == "sealed" then
        local pack = reveal.pack
        startAnim(TEAR_SECONDS, function(p)
            -- The pack swells a little and fades out.
            if pack ~= nil then
                local grow = 1 + 0.15 * p
                local w, h = math.floor(pack.w * grow), math.floor(pack.h * grow)
                pack.sprite:SetPos(pack.x - (w - pack.w) // 2, pack.y - (h - pack.h) // 2)
                pack.sprite:SetSize(w, h)
                pack.sprite.alpha = 1 - p
            end
        end, function()
            reveal.index = 1
            showFaceDown()
        end)
        return
    end

    if reveal.stage == "facedown" then
        local back = reveal.back
        if reveal.view ~= nil then
            pcall(function() reveal.view.root.hidden = false end)
        end
        startAnim(FLIP_SECONDS, function(p)
            if back ~= nil then
                back.alpha = 1 - p
            end
        end, showFaceUp)
        return
    end

    if reveal.stage == "faceup" then
        if reveal.index < #reveal.results then
            reveal.index = reveal.index + 1
            showFaceDown()
        else
            clearReveal()
            PackWindow.refresh()
        end
    end
end

-- Runs every frame: advances the current animation and pulses the glow of a flipped card.
local function onDraw(e)
    local ok, dt = pcall(function() return e.timeDeltaSecs end)
    if not ok or type(dt) ~= "number" then
        dt = 0.016
    end
    if reveal.results == nil then
        return
    end
    reveal.clock = reveal.clock + dt

    local anim = reveal.anim
    if anim ~= nil then
        anim.t = anim.t + dt
        local p = math.min(1, anim.t / anim.seconds)
        anim.update(p)
        if p >= 1 then
            reveal.anim = nil
            anim.finish()
        end
    end

    if reveal.stage == "faceup" and reveal.glow ~= nil then
        -- The glow fades in over the first half second after the flip, then breathes between
        -- GLOW_MIN and full brightness. Only one value changes each frame (the image's alpha).
        local glow = reveal.glow
        glow.age = glow.age + dt
        local fadeIn = math.min(1, glow.age / 0.5)
        local breath = 0.5 + 0.5 * math.sin(reveal.clock * GLOW_SPEED)          -- 0 to 1
        glow.sprite.alpha = math.min(1, glow.strength * GLOW_STRENGTH * (GLOW_MIN + (1 - GLOW_MIN) * breath) * fadeIn)
    end
end

Event.Draw.Subscribe("cardcollector_reveal", onDraw)

-- The Open pack button: buys and rolls a pack, saves it, then starts the reveal.
local function onOpenPack()
    local state = api.getState()
    if state == nil then
        return
    end
    local results, reason = Packs.open(state)
    if results == nil then
        log("pack not opened:", reason)
        PackWindow.refresh()
        return
    end
    api.saveNow()
    clearReveal()
    reveal.results = results
    reveal.clock = 0
    if image("pack") ~= nil then
        showSealed()
    else
        reveal.index = 1
        showFaceDown()
    end
end

-- The reveal screen's main button (Tear open, Flip card, Next or Done).
local function onNext()
    PackWindow.advance()
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
    widgets.creditsText = makeText(screens.home, 10, 8, 200, 20, "", WHITE)
    widgets.priceText = makeText(screens.home, 10, 30, 200, 20, "", GREY)
    widgets.collectionText = makeText(screens.home, 10, 52, 200, 20, "", GREY)
    widgets.openButton = makeButton(screens.home, "Open pack", 10, 82, 200, 34, onOpenPack, "positive")
    widgets.hintText = makeText(screens.home, 10, 120, 200, 20, "", GOLD)
    makeButton(screens.home, "Collection", 10, 144, 200, 30, function()
        if Viewer.isOpen() then
            Viewer.close()
        else
            Viewer.open(api)
        end
    end)
    makeButton(screens.home, "Stats", 10, 182, 200, 30, function()
        Stats.toggle(api)
    end)
    -- A cog in the top right corner opens the settings window.
    Kit.iconButton(screens.home, "SETTINGS", 186, 4, function() api.openSettings() end, "Settings", "Settings", 80)
    -- Extra buttons under the main ones, one per row. The released plugin has none; the
    -- development tools (dev/dev.lua) supply some.
    for i, extra in ipairs(api.extraButtons or {}) do
        makeButton(screens.home, extra.label, 10, EXTRA_TOP + (i - 1) * 34, 200, 28, extra.action)
    end

    -- reveal
    local rw = REVEAL_WIDTH - 20
    widgets.variantText = makeText(screens.reveal, 10, REVEAL_TOP, rw, 20, "", WHITE)
    widgets.newText = makeText(screens.reveal, 10, REVEAL_TOP + 22, rw, 20, "", GOLD)
    widgets.counterText = makeText(screens.reveal, 10, REVEAL_TOP + 44, rw, 18, "", GREY)
    widgets.nextButton = makeButton(screens.reveal, "Next", 10, REVEAL_TOP + 86, rw, 32, onNext)
end

-- Creates the window. `newApi` supplies getState, saveNow, openSettings and extraButtons (see above).
function PackWindow.show(newApi)
    if window ~= nil then
        return
    end
    api = newApi
    -- Room for the extra buttons, if there are any.
    if api.extraButtons ~= nil and #api.extraButtons > 0 then
        HEIGHTS.home = EXTRA_TOP + #api.extraButtons * 34 + 12
    end
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

    setText(widgets.creditsText, "Credits: " .. state.credits)
    setText(widgets.priceText, "Pack: " .. tier.price .. " credits (" .. tier.name .. ")")
    setText(widgets.collectionText, "Collection: " .. Storage.countUniqueOwned(state) .. " of " .. #Cards.list
        .. " cards")
    local affordable = state.credits >= tier.price
    Kit.setEnabled(widgets.openButton, affordable)
    setText(widgets.hintText, affordable and "" or ("Need " .. (tier.price - state.credits) .. " more credits"))
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
