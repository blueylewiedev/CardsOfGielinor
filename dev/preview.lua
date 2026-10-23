-- preview.lua
-- Debug window for looking at cards while the rendering is built and tuned. The card is drawn
-- at PREVIEW_SCALE (bigger than in the game) to make the camera easier to fine tune; the values
-- found are the same at any size. The window can be dragged by its title bar.
--
-- Under the card:
--   Prev / Next     : cycle through every card
--   Save / Reset    : keep this card's camera across reloads / go back to the card's own values
-- Camera (right side):
--   Zoom +/-        : camera distance (closer is a bigger NPC)
--   Size +/-        : camera field of view (narrower is a bigger NPC)
--   Up / Down       : move the NPC up or down the card
--   Left / Right    : move the NPC across the card
--   Yaw -/+         : turn the camera left/right around the NPC
--   Pitch -/+       : tilt the camera up/down
-- View (right side):
--   Model: Head/Body: switches this card between its head and body model (back to the
--                     card's own setting when you change card)
--   Finish          : cycles Normal / Reverse / Holo to see the shine on the card
--   Frames: On/Off  : draws cards with the frame images, or the plain layout, to compare
--   Show: Back      : shows the card back image (resources/images/card_back.png) over a
--                     magenta and white backdrop, to check its transparency in the client
-- Animation (right side): type a sequence id, or step it with the buttons; Off stops it.
--
-- Every press logs a line to the console and to the Output window (toggle it from the Home
-- window) that can be pasted into the card's `art` entry in core/cards.lua, e.g.
-- `cam = { ... }`, with `body = true, ` in front for a body model. Only created when DEBUG
-- is on in main.lua.

local Kit = require("ui/kit")
local Cards = require("core/cards")
local CardView = require("ui/cardview")
local OutputWindow = require("dev/outputwindow")
local Tuning = require("dev/tuning")

local Preview = {}

-- The text to put in a card's `art = { ... }` entry for a camera. Only the values that differ
-- from the defaults are written, so the line stays short enough to type by hand.
local function pasteText(cam)
    local defaults = CardView.CAMERA_DEFAULTS[cam.body and "body" or "head"]
    local parts = {}
    for _, field in ipairs({ "yaw", "pitch", "dist", "fov", "ty", "tx" }) do
        local value, default = cam[field], defaults[field]
        if math.abs(value - default) >= 0.005 then
            if field == "yaw" or field == "pitch" then
                parts[#parts + 1] = string.format("%s = %.2f", field, value)
            else
                parts[#parts + 1] = string.format("%s = %.0f", field, value)
            end
        end
    end
    local text = "cam = { " .. table.concat(parts, ", ") .. " }"
    if #parts == 0 then
        text = "cam = { }  -- same as the defaults"
    end
    if cam.body then
        text = "body = true, " .. text
    end
    if cam.anim ~= nil then
        text = "anim = " .. string.format("%.0f", cam.anim) .. ", " .. text
    end
    return text
end


-- The card is drawn at this scale in the preview (the game's cards use CardView.SCALE).
local PREVIEW_SCALE = 2.0
local PW = math.floor(160 * PREVIEW_SCALE)      -- the card's size on screen
local PH = math.floor(224 * PREVIEW_SCALE)
local CARD_X, CARD_Y = 10, 10

-- The buttons are in a panel to the right of the card, in two columns. PrettyUI makes a button
-- at least as wide as its label needs ("ZOOM +" needs about 146), so a half-width button is 148.
local PANEL_X = CARD_X + PW + 20
local HALF_W = 148                              -- visible width of a button that shares its row
local GAP = 4
local PANEL_W = 2 * HALF_W + GAP
local STEP = 36                                 -- height of a row of buttons
local UNDER_Y = CARD_Y + PH + 12                -- the rows of buttons under the card
local UNDER_W = (PW - GAP) // 2                 -- width of each of the two buttons in a row there

local CONTENT_W = PANEL_X + PANEL_W + 10
local GREY = Vector4.new(0.7, 0.7, 0.7, 1.0)

local window = nil
local content = nil

function Preview.show()
    if window ~= nil then
        return
    end

    -- Where each part of the right-hand panel starts.
    local cameraTop = 10
    local viewTop = cameraTop + 24 + 6 * STEP + 8
    local animTop = viewTop + 24 + 4 * STEP + 8
    local contentH = math.max(UNDER_Y + STEP + 30, animTop + 24 + 34 + 3 * STEP - 6) + 10

    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Card Preview", CONTENT_W, contentH + Kit.titleBarHeight(),
        function() Preview.hide() end, 0.4, 0.05, false, true)

    local index = 1
    local view = nil
    local finish = "normal"        -- which finish the preview shows: normal, reverse or holo
    local bodyOverride = nil      -- nil = the card's own setting; true/false = chosen with the button
    local modelButton = nil
    local showAnimLabel = nil      -- set once the Anim box is made

    -- The card back test: a split backdrop with the image on top. If the image's corners
    -- are truly transparent, magenta shows in the left corners and white in the right ones.
    local backParts = {}
    local showingBack = false
    local backButton = nil

    local function clearBack()
        for _, part in ipairs(backParts) do
            pcall(function() part:Destroy() end)
        end
        backParts = {}
        showingBack = false
        if backButton ~= nil then
            Kit.setLabel(backButton, "Show: Back")
        end
    end

    local function showBack()
        if view ~= nil then
            view.root:Destroy()
            view = nil
        end
        clearBack()
        showingBack = true
        Kit.setLabel(backButton, "Show: Card")

        local ok, resource = pcall(function() return Plugin.resources.images.card_back end)
        if not ok or resource == nil then
            log("preview: card back not found - is it at resources/images/card_back.png? Run prf, then prl.", tostring(resource))
            return
        end
        log("preview: card_back resource", type(resource), "path", tostring(resource.path), "loaded", tostring(resource.loaded))
        local loadOk, result = pcall(function() return resource:Load() end)
        log("preview: card_back Load ->", loadOk and tostring(result) or ("FAILED: " .. tostring(result)))

        local made, err = pcall(function()
            local left = ui.Rectangle.new(content)
            left:SetPos(CARD_X, CARD_Y)
            left:SetSize(PW // 2, PH)
            left.fill = true
            left.colour = Vector4.new(1.0, 0.0, 1.0, 1.0)
            backParts[#backParts + 1] = left
            local right = ui.Rectangle.new(content)
            right:SetPos(CARD_X + PW // 2, CARD_Y)
            right:SetSize(PW // 2, PH)
            right.fill = true
            right.colour = Vector4.new(1.0, 1.0, 1.0, 1.0)
            backParts[#backParts + 1] = right
            local sprite = ui.Sprite.new(content)
            sprite:SetPos(CARD_X, CARD_Y)
            sprite:SetSize(PW, PH)
            sprite.sprite = resource
            backParts[#backParts + 1] = sprite
            log("preview: card back sprite created", sprite.width, sprite.height)
        end)
        if not made then
            log("preview: card back sprite FAILED:", tostring(err))
        end
    end

    local function showCard()
        clearBack()
        if view ~= nil then
            view.root:Destroy()
        end
        local card = Cards.list[index]
        view = CardView.create(content, card, { body = bodyOverride, finish = finish, scale = PREVIEW_SCALE })
        view.root:SetPos(CARD_X, CARD_Y)
        if modelButton ~= nil then
            Kit.setLabel(modelButton, (view.cam ~= nil and view.cam.body) and "Model: Body" or "Model: Head")
        end
        if showAnimLabel ~= nil then
            showAnimLabel()
        end

        if view.cam ~= nil then
            local c = view.cam
            log("preview:", card.id, "yaw", c.yaw, "pitch", c.pitch, "dist", c.dist, "fov", c.fov,
                "ty", c.ty, "tx", c.tx)
        else
            log("preview:", card.id, "(no camera: NPC not found or the camera failed)")
        end
    end

    -- A button in the right-hand panel: `half` 1 or 2 is the left or right of a pair, nil is a
    -- full-width one.
    local function panelButton(text, half, y, onPress, style)
        if half == nil then
            return Kit.buttonAt(content, text, PANEL_X, y, PANEL_W, 30, onPress, style)
        end
        return Kit.buttonAt(content, text, PANEL_X + (half - 1) * (HALF_W + GAP), y, HALF_W, 30, onPress, style)
    end

    local function section(title, y)
        Kit.text(content, PANEL_X, y, PANEL_W, 20, title, GREY, ui.AlignMode.TOPLEFT)
    end

    -- Changes the camera with `change(cam)`, applies it and logs a paste-ready line.
    local function withCamera(change)
        if view == nil or view.cam == nil then
            return
        end
        local cam = view.cam
        change(cam)
        CardView.applyCamera(cam)
        local text = pasteText(cam)
        log("preview: paste into", view.card.id, "art:", text)
        OutputWindow.add(view.card.id, text)
    end

    -- Zoom + moves the camera closer: the distance shrinks by about 13%.
    local function zoom(direction)
        withCamera(function(c) c.dist = math.max(10, c.dist * (direction > 0 and 0.87 or 1.15)) end)
    end

    -- Size + narrows the field of view, which makes the NPC bigger.
    local function resize(direction)
        withCamera(function(c) c.fov = math.max(5, math.min(120, c.fov + (direction > 0 and -5 or 5))) end)
    end

    -- Up moves the NPC up the card, so the camera looks lower.
    local function move(direction)
        withCamera(function(c) c.ty = c.ty - direction * 20 end)
    end

    -- Under the card: Prev / Next on one row, Save / Reset on the next.
    local function underButton(text, slot, onPress, style)
        local column = (slot - 1) % 2
        local row = (slot - 1) // 2
        return Kit.buttonAt(content, text, CARD_X + column * (UNDER_W + GAP), UNDER_Y + row * STEP, UNDER_W, 30,
            onPress, style)
    end
    underButton("Prev", 1, function()
        index = index - 1
        if index < 1 then index = #Cards.list end
        bodyOverride = nil
        showCard()
    end)
    underButton("Next", 2, function()
        index = index + 1
        if index > #Cards.list then index = 1 end
        bodyOverride = nil
        showCard()
    end)
    -- Save keeps the current camera for this card (until Reset), so it survives a reload and
    -- applies everywhere the card is drawn. Reset goes back to what the card's file says.
    underButton("Save", 3, function()
        if view ~= nil and view.cam ~= nil then
            local cam = view.cam
            if Tuning.set(view.card.id, cam.body, cam, cam.anim) then
                local text = pasteText(cam)
                log("preview: saved", view.card.id, text)
                OutputWindow.add(view.card.id .. " (saved)", text)
            end
        end
    end, "positive")
    underButton("Reset", 4, function()
        if view ~= nil then
            Tuning.clear(view.card.id)
            OutputWindow.add(view.card.id .. " (reset)", "saved settings removed")
            bodyOverride = nil
            showCard()
        end
    end, "negative")

    -- Camera.
    section("Camera", cameraTop)
    local y = cameraTop + 24
    panelButton("Zoom -", 1, y, function() zoom(-1) end)
    panelButton("Zoom +", 2, y, function() zoom(1) end)
    y = y + STEP
    panelButton("Size -", 1, y, function() resize(-1) end)
    panelButton("Size +", 2, y, function() resize(1) end)
    y = y + STEP
    panelButton("Up", 1, y, function() move(1) end)
    panelButton("Down", 2, y, function() move(-1) end)
    y = y + STEP
    -- Left / Right move the NPC across the card (the camera's look-at slides the other way).
    panelButton("Left", 1, y, function() withCamera(function(c) c.tx = c.tx + 10 end) end)
    panelButton("Right", 2, y, function() withCamera(function(c) c.tx = c.tx - 10 end) end)
    y = y + STEP
    panelButton("Yaw -", 1, y, function() withCamera(function(c) c.yaw = c.yaw - 0.2 end) end)
    panelButton("Yaw +", 2, y, function() withCamera(function(c) c.yaw = c.yaw + 0.2 end) end)
    y = y + STEP
    panelButton("Pitch -", 1, y, function() withCamera(function(c) c.pitch = c.pitch - 0.15 end) end)
    panelButton("Pitch +", 2, y, function() withCamera(function(c) c.pitch = c.pitch + 0.15 end) end)

    -- View.
    section("View", viewTop)
    y = viewTop + 24
    modelButton = panelButton("Model: Head", nil, y, function()
        local isBody = view ~= nil and view.cam ~= nil and view.cam.body
        bodyOverride = not isBody
        showCard()
    end)

    -- Finish cycles normal -> reverse holo -> holo, to see the shine on the card shown.
    local finishNames = { normal = "Normal", reverse = "Reverse", holo = "Holo" }
    local finishNext = { normal = "reverse", reverse = "holo", holo = "normal" }
    local finishButton = nil
    y = y + STEP
    finishButton = panelButton("Finish: Normal", nil, y, function()
        finish = finishNext[finish]
        Kit.setLabel(finishButton, "Finish: " .. finishNames[finish])
        showCard()
    end)

    local framesButton = nil
    y = y + STEP
    framesButton = panelButton("Frames: On", nil, y, function()
        CardView.USE_FRAMES = not CardView.USE_FRAMES
        Kit.setLabel(framesButton, CardView.USE_FRAMES and "Frames: On" or "Frames: Off")
        showCard()
    end)
    y = y + STEP
    backButton = panelButton("Show: Back", nil, y, function()
        if showingBack then
            showCard()
        else
            showBack()
        end
    end)

    -- Animation: type an animation id into the box to play it, or step it with the buttons (by
    -- 1 or 100); Off stops it. The id is added to the line that Save and the Output window give.
    -- Ids are the client's sequence ids and there are many thousands.
    section("Animation (sequence id)", animTop)
    local animField = nil
    local settingField = false     -- true while the code, not the player, changes the box

    -- Puts the model's current animation id (or nothing) in the box.
    function showAnimLabel()
        if animField == nil then
            return
        end
        local current = view ~= nil and view.cam ~= nil and view.cam.anim or nil
        settingField = true
        animField.content = current ~= nil and string.format("%.0f", current) or ""
        settingField = false
    end

    -- Plays animation `animId` (nil stops it) on the shown model and logs the paste-ready line.
    local function setAnim(animId)
        if view == nil or view.cam == nil or view.model == nil then
            return
        end
        view.cam.anim = animId
        CardView.playAnimation(view.model, animId)
        local text = pasteText(view.cam)
        log("preview: paste into", view.card.id, "art:", text)
        OutputWindow.add(view.card.id, text)
    end

    local function stepAnim(change)
        local current = view ~= nil and view.cam ~= nil and view.cam.anim or 0
        setAnim(math.max(0, current + change))
        showAnimLabel()
    end

    y = animTop + 24
    animField = Kit.inputField(content, PANEL_X, y, PANEL_W, 30, 6, true)
    animField:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        if settingField then
            return
        end
        -- Typing an id plays it; clearing the box stops the animation.
        local typed = tonumber(animField.content)
        if typed ~= nil or animField.content == "" then
            setAnim(typed)
        end
    end)
    y = y + 34
    panelButton("-100", 1, y, function() stepAnim(-100) end)
    panelButton("+100", 2, y, function() stepAnim(100) end)
    y = y + STEP
    panelButton("-1", 1, y, function() stepAnim(-1) end)
    panelButton("+1", 2, y, function() stepAnim(1) end)
    y = y + STEP
    panelButton("Anim off", nil, y, function()
        setAnim(nil)
        showAnimLabel()
    end)

    -- List what is already saved, so it can be read from the Output window.
    for _, cardId in ipairs(Tuning.ids()) do
        local entry = Tuning.entry(cardId)
        local cam = { body = entry.body, anim = entry.anim }
        for field, value in pairs(entry.cam) do
            cam[field] = value
        end
        for _, field in ipairs({ "yaw", "pitch", "dist", "fov", "ty", "tx" }) do
            cam[field] = cam[field] or CardView.CAMERA_DEFAULTS[entry.body and "body" or "head"][field]
        end
        OutputWindow.add(cardId .. " (saved)", pasteText(cam))
    end

    showCard()
end

function Preview.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
        window = nil
        content = nil
    end
end

function Preview.isOpen()
    return window ~= nil
end

-- Closes the preview window if it is open, opens it if it is closed.
function Preview.toggle()
    if window ~= nil then
        Preview.hide()
    else
        Preview.show()
    end
end

return Preview
