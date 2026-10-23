-- preview.lua
-- Debug window for looking at cards while the rendering is built and tuned.
--
--   Prev / Next     : cycle through every card
--   Zoom +/-        : camera distance (closer is a bigger NPC)
--   Size +/-        : camera field of view (narrower is a bigger NPC)
--   Up / Down       : move the NPC up or down the card
--   Yaw -/+         : turn the camera left/right around the NPC
--   Pitch -/+       : tilt the camera up/down
--   Left / Right    : move the NPC across the card
--   Save / Reset    : keep this card's camera across reloads / go back to core/cards.lua's values
--   Finish          : cycles Normal / Reverse / Holo to see the shine on the card
--   Model: Head/Body: switches this card between its head and body model (back to the
--                     card's own setting when you change card)
--   Frames: On/Off  : draws cards with the frame images, or the plain layout, to compare
--   Show: Back      : shows the card back image (resources/images/card_back.png) over a
--                     magenta and white backdrop, to check its transparency in the client
--
-- Every press logs a line to the console and to the Output window (toggle it from the Home
-- window) that can be pasted into the card's `art` entry in core/cards.lua, e.g.
-- `cam = { ... }`, with `body = true, ` in front for a body model. Only created when DEBUG
-- is on in main.lua.

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


local window = nil

function Preview.show()
    if window ~= nil then
        return
    end

    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window = ui.GroupBox.new(gameWindow)
    window.stylesheetID = id.StyleSheet.DEFAULT
    window:SetHeaderLayout(0, 0, 0, 0, 0)
    window:SetSize(200 + (CardView.WIDTH - 160), 870 + (CardView.HEIGHT - 224))
    window:SetPos(0, 0, 0.5, 0.15)

    local index = 1
    local view = nil
    local finish = "normal"        -- which finish the preview shows: normal, reverse or holo
    local bodyOverride = nil      -- nil = the card's own setting; true/false = chosen with the button
    local modelButton = nil
    local showAnimLabel = nil      -- set once the Anim buttons are made

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
            backButton.label = "Show: Back"
        end
    end

    local function showBack()
        if view ~= nil then
            view.root:Destroy()
            view = nil
        end
        clearBack()
        showingBack = true
        backButton.label = "Show: Card"

        local ok, resource = pcall(function() return Plugin.resources.images.card_back end)
        if not ok or resource == nil then
            log("preview: card back not found - is it at resources/images/card_back.png? Run prf, then prl.", tostring(resource))
            return
        end
        log("preview: card_back resource", type(resource), "path", tostring(resource.path), "loaded", tostring(resource.loaded))
        local loadOk, result = pcall(function() return resource:Load() end)
        log("preview: card_back Load ->", loadOk and tostring(result) or ("FAILED: " .. tostring(result)))

        local made, err = pcall(function()
            local left = ui.Rectangle.new(window)
            left:SetPos(20, 10)
            left:SetSize(CardView.WIDTH // 2, CardView.HEIGHT)
            left.fill = true
            left.colour = Vector4.new(1.0, 0.0, 1.0, 1.0)
            backParts[#backParts + 1] = left
            local right = ui.Rectangle.new(window)
            right:SetPos(20 + CardView.WIDTH // 2, 10)
            right:SetSize(CardView.WIDTH // 2, CardView.HEIGHT)
            right.fill = true
            right.colour = Vector4.new(1.0, 1.0, 1.0, 1.0)
            backParts[#backParts + 1] = right
            local sprite = ui.Sprite.new(window)
            sprite:SetPos(20, 10)
            sprite:SetSize(CardView.WIDTH, CardView.HEIGHT)
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
        view = CardView.create(window, card, { body = bodyOverride, finish = finish })
        view.root:SetPos(20, 10)
        if modelButton ~= nil then
            modelButton.label = (view.cam ~= nil and view.cam.body) and "Model: Body" or "Model: Head"
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

    local function makeButton(text, x, y, w, onPress)
        local button = ui.Button.new(window)
        -- The buttons were laid out under a 224-high card; shift them down for a bigger one.
        button:SetPos(x + (CardView.WIDTH - 160) // 2, y + (CardView.HEIGHT - 224))
        button:SetSize(w, 30)
        button.label = text
        button.stylesheetID = id.StyleSheet.BUTTON_DEFAULT
        button:Subscribe(ui.Hook.ONBUTTONPRESSED, onPress)
        return button
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

    makeButton("Prev", 10, 244, 85, function()
        index = index - 1
        if index < 1 then index = #Cards.list end
        bodyOverride = nil
        showCard()
    end)
    makeButton("Next", 105, 244, 85, function()
        index = index + 1
        if index > #Cards.list then index = 1 end
        bodyOverride = nil
        showCard()
    end)
    makeButton("Zoom -", 10, 284, 85, function() zoom(-1) end)
    makeButton("Zoom +", 105, 284, 85, function() zoom(1) end)
    makeButton("Size -", 10, 324, 85, function() resize(-1) end)
    makeButton("Size +", 105, 324, 85, function() resize(1) end)
    makeButton("Up", 10, 364, 85, function() move(1) end)
    makeButton("Down", 105, 364, 85, function() move(-1) end)
    makeButton("Yaw -", 10, 404, 85, function() withCamera(function(c) c.yaw = c.yaw - 0.2 end) end)
    makeButton("Yaw +", 105, 404, 85, function() withCamera(function(c) c.yaw = c.yaw + 0.2 end) end)
    makeButton("Pitch -", 10, 444, 85, function() withCamera(function(c) c.pitch = c.pitch - 0.15 end) end)
    makeButton("Pitch +", 105, 444, 85, function() withCamera(function(c) c.pitch = c.pitch + 0.15 end) end)
    -- Left / Right move the NPC across the card (the camera's look-at slides the other way).
    makeButton("Left", 10, 484, 85, function() withCamera(function(c) c.tx = c.tx + 10 end) end)
    makeButton("Right", 105, 484, 85, function() withCamera(function(c) c.tx = c.tx - 10 end) end)

    modelButton = makeButton("Model: Head", 10, 564, 180, function()
        local isBody = view ~= nil and view.cam ~= nil and view.cam.body
        bodyOverride = not isBody
        showCard()
    end)
    modelButton.label = (view ~= nil and view.cam ~= nil and view.cam.body) and "Model: Body" or "Model: Head"

    -- Save keeps the current camera for this card (until Reset), so it survives a reload and
    -- applies everywhere the card is drawn. Reset goes back to what core/cards.lua says.
    makeButton("Save", 10, 604, 85, function()
        if view ~= nil and view.cam ~= nil then
            local cam = view.cam
            if Tuning.set(view.card.id, cam.body, cam, cam.anim) then
                local text = pasteText(cam)
                log("preview: saved", view.card.id, text)
                OutputWindow.add(view.card.id .. " (saved)", text)
            end
        end
    end)
    makeButton("Reset", 105, 604, 85, function()
        if view ~= nil then
            Tuning.clear(view.card.id)
            OutputWindow.add(view.card.id .. " (reset)", "saved settings removed")
            bodyOverride = nil
            showCard()
        end
    end)

    -- Finish cycles normal -> reverse holo -> holo, to see the shine on the card shown.
    local finishNames = { normal = "Normal", reverse = "Reverse", holo = "Holo" }
    local finishNext = { normal = "reverse", reverse = "holo", holo = "normal" }
    local finishButton = nil
    finishButton = makeButton("Finish: Normal", 10, 644, 180, function()
        finish = finishNext[finish]
        finishButton.label = "Finish: " .. finishNames[finish]
        showCard()
    end)

    -- Animation: type an animation id into the box to play it, or step it with the buttons (by
    -- 1 or 100); Off stops it. The id is added to the line that Save and the Output window give.
    -- Ids are the client's sequence ids and there are many thousands.
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

    animField = ui.InputField.new(window)
    animField:SetPos(10 + (CardView.WIDTH - 160) // 2, 684 + (CardView.HEIGHT - 224))
    animField:SetSize(180, 30)
    local sheet = id.StyleSheet.INPUT_DEFAULT
    if sheet ~= nil then
        animField.stylesheetID = sheet
    end
    animField:Setup(ui.TextContentVisibilityMode.VISIBLE, ui.InputFieldFilterMode.NUMERIC, 6)
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
    makeButton("Anim -100", 10, 724, 85, function() stepAnim(-100) end)
    makeButton("Anim +100", 105, 724, 85, function() stepAnim(100) end)
    makeButton("Anim -1", 10, 764, 85, function() stepAnim(-1) end)
    makeButton("Anim +1", 105, 764, 85, function() stepAnim(1) end)
    makeButton("Anim off", 10, 804, 180, function()
        setAnim(nil)
        showAnimLabel()
    end)

    local framesButton = nil
    framesButton = makeButton("Frames: On", 10, 524, 85, function()
        CardView.USE_FRAMES = not CardView.USE_FRAMES
        framesButton.label = CardView.USE_FRAMES and "Frames: On" or "Frames: Off"
        showCard()
    end)
    backButton = makeButton("Show: Back", 105, 524, 85, function()
        if showingBack then
            showCard()
        else
            showBack()
        end
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
