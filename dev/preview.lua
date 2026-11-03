-- preview.lua
-- Debug window for looking at cards while the rendering is built and tuned. The card is drawn
-- at PREVIEW_SCALE (bigger than in the game) to make the camera easier to fine tune; the values
-- found are the same at any size. The window can be dragged by its title bar.
--
-- Under the card:
--   Prev / Next     : cycle through every card
--   Save / Reset    : keep this card's camera across reloads / go back to the card's own values
--   Clip review     : Prev / Next visit only the NPC cards with a Clip fix camera (a wide view,
--                     CLIP_FOV or more) that have not been saved yet, so saving ends a card's review
--   Swap to depth   : changes such a card to a narrower view at the same size, with Depth fix on
--   Depth fix       : steps near as in the Card Builder
--   Find a card     : type part of a card's name or id (every word must be in it, capitals,
--                     spaces and hyphens don't matter: "off hand rune dag") and the preview jumps
--                     to the first card found; Prev match / Next match step through the others.
--                     For looking up a card made earlier to read its camera in the art line.
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
--   Frames: On/Off  : draws cards with the frame images, or the plain layout, to compare
--   Use in Builder  : gives this card's camera to the Card Builder's card (only the camera, and
--                     only item to item or NPC to NPC), to frame a card like this one
--   Show: Back      : shows the card back image (resources/images/card_back.png) over a
--                     magenta and white backdrop, to check its transparency in the client
-- Animation (right side): type a sequence id, or step it with the buttons; Off stops it. Search
-- finds one by name (its Use plays it on the card); Guess tries the NPC's standing animation
-- (see Builder.readyAnim).
--
-- Under everything, a box holds the card's `art = { ... }` line as tuned, to copy (Ctrl+A, Ctrl+C)
-- over the card's art line in its deck file. Every press also logs the line to the console and to
-- the Output window (toggle it from the Home window). dev/apply_tuning.py writes every saved card's
-- line into the deck files, for when there are too many to paste.

local Kit = require("ui/kit")
local Cards = require("core/cards")
local CardView = require("ui/cardview")
local OutputWindow = require("dev/outputwindow")
local Tuning = require("dev/tuning")
local AnimSearch = require("dev/animsearch")
local Builder = require("dev/builder")

local Preview = {}

-- The card's `art = { ... }` line for a camera `cam` (with its body and anim), as written in the
-- deck files (see Builder.artText), with the card's own npc or item if it names one.
local function artLine(card, cam)
    local art = (card and card.art) or {}
    local itemArt = cam.kind == "item"
    return Builder.artText(itemArt, itemArt and art.item or art.npc, cam.body, cam.anim, cam,
        CardView.defaultsFor(cam), art.model) .. ","
end

-- The deck file a card is written in (as listed in deck/index.lua), or nil.
local function deckFileOf(card)
    for _, setName in ipairs(Cards.sets) do
        local ok, set = pcall(require, setName)
        if ok and type(set) == "table" then
            for _, written in ipairs(set.cards or {}) do
                if written == card then
                    return setName .. ".lua"
                end
            end
        end
    end
    return nil
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

local CLIP_FOV = 60                             -- an NPC camera this wide is taken as clip fixed
local SWAP_FOV, SWAP_NEAR = 30, 0.25            -- what Swap to depth changes it to
-- The find block under the Clip review rows: a label, the box, a line saying what was found,
-- and the match buttons.
local FIND_Y = UNDER_Y + 4 * STEP + 20 + 8       -- (under the Clip review rows and their status line)
local FIND_H = 20 + 28 + 4 + 18 + 4 + 30

local CONTENT_W = PANEL_X + PANEL_W + 10
local GREY = Vector4.new(0.7, 0.7, 0.7, 1.0)

local window = nil
local content = nil

function Preview.show()
    if window ~= nil then
        return
    end

    -- Where each part of the right-hand panel starts, and the art line's box under everything.
    local cameraTop = 10
    local viewTop = cameraTop + 24 + 6 * STEP + 8
    local animTop = viewTop + 24 + 4 * STEP + 8
    local boxTop = math.max(FIND_Y + FIND_H + 8, animTop + 24 + 34 + 4 * STEP - 6) + 14
    local contentH = boxTop + 20 + 32 + 22

    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Card Preview", CONTENT_W, contentH + Kit.titleBarHeight(),
        function() Preview.hide() end, 0.4, 0.05, false, true)

    local index = 1
    local reviewing = nil         -- while in Clip review, the indexes in Cards.list still to review
    local reviewStatus = nil
    local view = nil
    local bodyOverride = nil      -- nil = the card's own setting; true/false = chosen with the button
    local modelButton = nil
    local showAnimLabel = nil      -- set once the Anim box is made
    local artBox, artHint = nil, nil
    local updateFindStatus = nil   -- set once the Find box is made

    -- Puts the shown card's art line in the box (and says which file it goes in). Returns it.
    local function showArtLine()
        if view == nil or view.cam == nil then
            return nil
        end
        local text = artLine(view.card, view.cam)
        if artBox ~= nil then
            artBox.content = text
            artHint.content = "Click the box, Ctrl+A, Ctrl+C, and paste it over the art line of " .. view.card.id
                .. " in " .. (deckFileOf(view.card) or "its deck file") .. "."
        end
        return text
    end

    -- Shows the art line in the box and logs it (after every change).
    local function report(label)
        local text = showArtLine()
        if text ~= nil then
            log("preview: paste into", view.card.id, text)
            OutputWindow.add(view.card.id .. (label or ""), text)
        end
    end

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
        view = CardView.create(content, card, { body = bodyOverride, scale = PREVIEW_SCALE })
        if reviewStatus ~= nil then
            local own = Cards.getArt(card).cam or {}
            reviewStatus.content = reviewing == nil and "" or string.format("Clip review: %d left. %s: zoom %.0f, size %.0f",
                #reviewing, card.id, own.dist or 0, own.fov or 0)
        end
        view.root:SetPos(CARD_X, CARD_Y)
        if modelButton ~= nil then
            -- An item has one model (no body or head), so the button is greyed out for it.
            if Cards.kindOf(card) == "item" then
                Kit.setLabel(modelButton, "Model: Item")
                Kit.setEnabled(modelButton, false)
            else
                Kit.setEnabled(modelButton, true)
                Kit.setLabel(modelButton, (view.cam ~= nil and view.cam.body) and "Model: Body" or "Model: Head")
            end
        end
        if showAnimLabel ~= nil then
            showAnimLabel()
        end
        showArtLine()
        if updateFindStatus ~= nil then
            updateFindStatus()
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

    -- Changes the camera with `change(cam)`, applies it and shows the new art line.
    local function withCamera(change)
        if view == nil or view.cam == nil then
            return
        end
        change(view.cam)
        CardView.applyCamera(view.cam)
        report()
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
    -- The card `direction` (1 or -1) along from the shown one: among the cards left to review
    -- during Clip review, otherwise among all of them. The review's cards are saved as they go, so
    -- this finds its place by index rather than by counting.
    local function stepCard(direction)
        local list = reviewing
        if list ~= nil and #list == 0 then
            -- (none left to review, or none at all: back to every card)
            reviewing, list = nil, nil
            OutputWindow.add("Clip review", "no wide-view cards left to review")
        end
        if list == nil then
            index = (index - 1 + direction) % #Cards.list + 1
        else
            local found = direction > 0 and list[1] or list[#list]
            for i = direction > 0 and 1 or #list, direction > 0 and #list or 1, direction do
                if (list[i] - index) * direction > 0 then
                    found = list[i]
                    break
                end
            end
            index = found
        end
        bodyOverride = nil
        showCard()
    end
    underButton("Prev", 1, function() stepCard(-1) end)
    underButton("Next", 2, function() stepCard(1) end)
    -- Save keeps the current camera for this card (until Reset), so it survives a reload and
    -- applies everywhere the card is drawn. Reset goes back to what the card's file says.
    underButton("Save", 3, function()
        if view ~= nil and view.cam ~= nil then
            local cam = view.cam
            if Tuning.set(view.card.id, cam.body, cam, cam.anim, artLine(view.card, cam)) then
                report(" (saved)")
                for i, listed in ipairs(reviewing or {}) do
                    if listed == index then
                        table.remove(reviewing, i)
                        break
                    end
                end
                if reviewing ~= nil then
                    stepCard(1)
                end
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

    -- Clip review, under Save and Reset. (Plain buttons: they need their whole label.)
    local function reviewButton(text, slot, onPress, tooltip)
        local column, row = (slot - 1) % 2, (slot - 1) // 2
        Kit.smallButton(content, text, CARD_X + column * (UNDER_W + GAP), UNDER_Y + 2 * STEP + row * STEP, UNDER_W, 30,
            onPress, tooltip)
    end
    reviewButton("Clip review", 1, function()
        if reviewing ~= nil then
            reviewing = nil
            return showCard()
        end
        reviewing = {}
        for i, card in ipairs(Cards.list) do
            local cam = Cards.getArt(card).cam
            if Cards.kindOf(card) ~= "item" and cam ~= nil and (cam.fov or 0) >= CLIP_FOV and Tuning.entry(card.id) == nil then
                reviewing[#reviewing + 1] = i
            end
        end
        if #reviewing > 0 then
            index = 0
        end
        stepCard(1)
    end, "Prev and Next visit only the wide-view NPC cards not yet saved; press again to leave")
    reviewButton("Swap to depth", 2, function()
        withCamera(function(c)
            if c.fov > SWAP_FOV then
                Builder.setFov(c, SWAP_FOV)
            end
            c.near = SWAP_NEAR
        end)
    end, "The same size with a narrow view and Depth fix on, so a held item is no longer enlarged")
    reviewButton("Depth fix", 3, function()
        withCamera(function(c) c.near = Builder.nextDepthFix(c.near) end)
    end, "Each press goes 0.25, 0.5, then off; off again if the front of the model is cut")
    reviewStatus = Kit.text(content, CARD_X, UNDER_Y + 4 * STEP, PW, 20, "", GREY, ui.AlignMode.TOPLEFT)
    -- Find a card: typing jumps to the first card whose id and name hold every word typed (in any
    -- order; capitals, spaces and hyphens ignored), and the match buttons step through the rest.
    -- The art line below then shows the camera that card has.
    local findField, findStatus = nil, nil
    local matches = {}                  -- indexes into Cards.list, best first

    local function simple(text)
        return (string.gsub(string.lower(tostring(text or "")), "[^%w]", ""))
    end

    -- The indexes of the cards that have every word of `query`; the shortest names come first
    -- (a search for "rune scimitar" lists Rune scimitar before Off-hand rune scimitar), then deck order.
    local function findCards(query)
        local words = {}
        for word in string.gmatch(string.lower(query or ""), "%S+") do
            local plain = simple(word)
            if plain ~= "" then
                words[#words + 1] = plain
            end
        end
        local found = {}
        if #words == 0 then
            return found
        end
        for cardIndex, card in ipairs(Cards.list) do
            local text = simple(card.id) .. " " .. simple(card.name)
            local all = true
            for _, word in ipairs(words) do
                if string.find(text, word, 1, true) == nil then
                    all = false
                    break
                end
            end
            if all then
                found[#found + 1] = cardIndex
            end
        end
        table.sort(found, function(a, b)
            local la, lb = #tostring(Cards.list[a].name or ""), #tostring(Cards.list[b].name or "")
            if la ~= lb then
                return la < lb
            end
            return a < b
        end)
        return found
    end

    -- Where the shown card is among the matches (0 if it is not one of them).
    local function matchPosition()
        for position, cardIndex in ipairs(matches) do
            if cardIndex == index then
                return position
            end
        end
        return 0
    end

    function updateFindStatus()
        if findStatus == nil then
            return
        end
        if #matches == 0 then
            findStatus.content = simple(findField.content) == "" and "Type part of a card's name or id"
                or "No card found"
            return
        end
        local position = matchPosition()
        findStatus.content = (position > 0 and ("Match " .. position .. " of " .. #matches) or (#matches .. " found"))
            .. ": " .. tostring(Cards.list[index].name or Cards.list[index].id)
    end

    local function showMatch(position)
        index = matches[position]
        bodyOverride = nil
        showCard()
    end

    Kit.text(content, CARD_X, FIND_Y, PW, 20, "Find a card", GREY, ui.AlignMode.TOPLEFT)
    findField = Kit.inputField(content, CARD_X, FIND_Y + 20, PW, 28, 60, false)
    findStatus = Kit.text(content, CARD_X, FIND_Y + 20 + 28 + 4, PW, 18, "", GREY, ui.AlignMode.TOPLEFT)
    findField:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        matches = findCards(findField.content)
        if #matches > 0 then
            showMatch(1)
        else
            updateFindStatus()
        end
    end)
    local matchY = FIND_Y + 20 + 28 + 4 + 18 + 4
    Kit.buttonAt(content, "Prev match", CARD_X, matchY, UNDER_W, 30, function()
        if #matches > 0 then
            local position = matchPosition()
            showMatch(position <= 1 and #matches or position - 1)
        end
    end)
    Kit.buttonAt(content, "Next match", CARD_X + UNDER_W + GAP, matchY, UNDER_W, 30, function()
        if #matches > 0 then
            local position = matchPosition()
            showMatch(position >= #matches and 1 or position + 1)
        end
    end)
    updateFindStatus()

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
    y = y + STEP
    -- Gives the shown card's camera to the card the Builder is making (what it says goes in the
    -- line under the Find box).
    panelButton("Use in Builder", nil, y, function()
        if view == nil or view.cam == nil then
            findStatus.content = "No camera to give (no card is shown)"
            return
        end
        local cam = view.cam
        local ok, why = Builder.useCamera(
            { yaw = cam.yaw, pitch = cam.pitch, dist = cam.dist, fov = cam.fov, ty = cam.ty, tx = cam.tx },
            Cards.kindOf(view.card), cam.body)
        findStatus.content = ok and ("Camera of " .. tostring(view.card.name or view.card.id) .. " sent to the Builder")
            or tostring(why)
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

    -- Plays animation `animId` (nil stops it) on the shown model and shows the new art line.
    local function setAnim(animId)
        if view == nil or view.cam == nil or view.model == nil or Cards.kindOf(view.card) == "item" then
            return          -- (items have no animation)
        end
        view.cam.anim = animId
        CardView.playAnimation(view.model, animId)
        report()
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
    y = y + STEP
    -- Search finds an animation by name; its Use plays it on this card.
    panelButton("Search", 1, y, function()
        AnimSearch.setPicker(function(seq)
            setAnim(seq.id)
            showAnimLabel()
        end)
        AnimSearch.show()
    end)
    -- Guess tries the NPC's standing animation from its name (as the Wiki Review does).
    panelButton("Guess", 2, y, function()
        if view == nil or Cards.kindOf(view.card) == "item" then
            return
        end
        local guess = Builder.readyAnimFor(Cards.getArt(view.card).npc, view.card)
        if guess ~= nil then
            setAnim(guess)
            showAnimLabel()
        end
    end)

    -- The art line to copy into the deck file.
    Kit.text(content, CARD_X, boxTop, CONTENT_W - 20, 20, "Art line (as tuned)", GREY, ui.AlignMode.TOPLEFT)
    artBox = Kit.inputField(content, CARD_X, boxTop + 20, CONTENT_W - 20, 28, 1000, false)
    artHint = Kit.text(content, CARD_X, boxTop + 52, CONTENT_W - 20, 18, "", GREY, ui.AlignMode.TOPLEFT)

    -- List what is already saved, so it can be read from the Output window.
    for _, cardId in ipairs(Tuning.ids()) do
        local entry = Tuning.entry(cardId)
        local saved = Cards.byId[cardId]
        local cam = { body = entry.body, anim = entry.anim,
            kind = (saved ~= nil and Cards.kindOf(saved) == "item") and "item" or nil }
        for field, value in pairs(entry.cam) do
            cam[field] = value
        end
        for _, field in ipairs(CardView.CAMERA_FIELDS) do
            cam[field] = cam[field] or CardView.defaultsFor(cam)[field]
        end
        OutputWindow.add(cardId .. " (saved)", artLine(saved, cam))
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
