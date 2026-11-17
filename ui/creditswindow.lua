-- ui/creditswindow.lua
-- A small overlay that shows the credits the logged-in character holds, and how many an hour they are earning (core/rate.lua):
-- a coin icon, the word "Credits" and the number, with "Per hour" and its number under them, on a dark see-through bar with
-- a thin border. It is not a window (no title bar, no buttons): it just sits on
-- the screen, independent of the main window, which can be closed altogether. Drag it with the mouse to move it; where
-- it was left is remembered. Clicking it (a press and release without moving) opens the main window. It is switched on
-- and off from the settings page and the ribbon page (ui/hub.lua), and main.lua remembers
-- whether it was on (the "creditsWindow" option, core/settings.lua), so it comes back the next time the plugin starts.
--
-- The number is written by Format.credits (core/format.lua), which is tested on its own.

local Kit = require("ui/kit")
local Logger = require("core/logger")
local Format = require("core/format")
local Rate = require("core/rate")

local CreditsWindow = {}

local WIDTH, HEIGHT = 170, 52
local ROW_H = 30                    -- the credits row; the per hour row is under it
local ICON_SIZE = 24
local CLICK_SLOP = 4                -- the mouse may move this far between press and release and still be a click
local PADDING = 6                       -- from the bar's edges to the icon and to the number
local LABEL_X, LABEL_W = PADDING + ICON_SIZE + 6, 56
local NUMBER_X = LABEL_X + LABEL_W
local NUMBER_W = WIDTH - NUMBER_X - PADDING
local FIRST_RIGHT, FIRST_TOP = 220, 10  -- where it starts the first time: this far from the right edge, near the top
local POSITION_KEY = "credits_window_position"
local COINS_OBJ = 995                   -- the id of Coins, if the game's list of items does not say

local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)
local BACKGROUND = Vector4.new(0.08, 0.07, 0.06, 0.75)
local BORDER = Vector4.new(0.45, 0.36, 0.22, 0.9)

local api = nil              -- api.getState() : the logged-in character's collection, or nil;
                             -- api.openMain() : opens the main window (when the bar is clicked)
local parent = nil           -- the screen layer it is drawn on
local root, grip = nil, nil     -- root is a layer that holds the bar's parts; grip catches the mouse
local numberText, rateText, rateLabel = nil, nil, nil
local posX, posY = 0, 0      -- where the bar is, from the top left of the screen
local drag = nil             -- while it is being moved: { mouse x and y, bar x and y when the press began }
local shown, shownRate = nil, nil   -- the text the numbers show now

-- The mouse's position on the screen, or nil if the client cannot say.
local function mousePosition()
    local ok, x, y = pcall(function()
        if not Mouse.IsAvailable() then
            return nil
        end
        local position = Mouse.GetPosition()
        return position.x, position.y
    end)
    if ok then
        return x, y
    end
    return nil
end

-- Keeps the bar fully on the screen.
local function clamp(x, y)
    local ok, width, height = pcall(function() return parent.width, parent.height end)
    if ok and type(width) == "number" and type(height) == "number" and width > WIDTH and height > HEIGHT then
        x = math.max(0, math.min(width - WIDTH, x))
        y = math.max(0, math.min(height - HEIGHT, y))
    end
    return math.floor(x), math.floor(y)
end

-- Moves the bar.
local function place(x, y)
    posX, posY = clamp(x, y)
    if root ~= nil then
        root:SetPos(posX, posY)
    end
end

local function savePosition()
    local ok = pcall(function()
        PersistentDB:SetStructuredData(POSITION_KEY, { x = posX, y = posY })
    end)
    if not ok then
        Logger.error("credits window: could not save where it is")
    end
end

-- Where the bar goes: where it was left last time, or near the top of the screen.
local function startingPosition()
    local saved = nil
    pcall(function() saved = PersistentDB:GetStructuredData(POSITION_KEY) end)
    if type(saved) == "table" and type(saved.x) == "number" and type(saved.y) == "number" then
        return saved.x, saved.y
    end
    local ok, width = pcall(function() return parent.width end)
    return (ok and type(width) == "number" and width - WIDTH - FIRST_RIGHT or 400), FIRST_TOP
end

-- The coins picture on the left. The game would write the pile's size on it; the mode below stops that.
local function addIcon(bar)
    local ok, sprite = pcall(function()
        local icon = ui.Sprite.new(bar)
        icon:SetSize(ICON_SIZE, ICON_SIZE)
        icon:SetPos(PADDING, (ROW_H - ICON_SIZE) // 2)
        icon.associatedObjectID = (id.Obj ~= nil and id.Obj.COINS) or COINS_OBJ
        icon.associatedObjectQuantity = 10000      -- a big pile
        local modes = ui.ObjectQuantityDisplayMode
        if modes ~= nil and modes.NEVER ~= nil then
            icon.associatedObjectQuantityMode = modes.NEVER
        else
            icon.associatedObjectQuantity = 1      -- (without the mode, a quantity of one shows no number)
        end
        return icon
    end)
    if ok then
        return sprite
    end
    Logger.error("credits window: the coins icon failed:", tostring(sprite))
    return nil
end

-- The invisible layer over the bar that takes the mouse. Pressing it stretches it over the whole screen so it keeps
-- getting the hold and the release wherever the mouse goes (as the pack tearing does, ui/packwindow.lua).
local function addGrip()
    local layer = ui.Layer.new(parent)
    layer.clickthrough = false
    local function rest()
        layer:SetPos(posX, posY)
        layer:SetSize(WIDTH, HEIGHT, 0, 0)
    end
    rest()
    layer:Subscribe(ui.Hook.ONCLICK, function()
        local x, y = mousePosition()
        if x == nil or drag ~= nil then
            return
        end
        drag = { x = x, y = y, barX = posX, barY = posY, moved = false }
        layer:SetPos(0, 0)
        layer:SetSize(0, 0, 1, 1)
        pcall(function() layer:MoveToFront() end)
    end)
    layer:Subscribe(ui.Hook.ONHOLD, function()
        local x, y = mousePosition()
        if drag == nil or x == nil then
            return
        end
        if math.abs(x - drag.x) > CLICK_SLOP or math.abs(y - drag.y) > CLICK_SLOP then
            drag.moved = true
        end
        if drag.moved then
            place(drag.barX + x - drag.x, drag.barY + y - drag.y)
        end
    end)
    layer:Subscribe(ui.Hook.ONRELEASE, function()
        if drag == nil then
            return
        end
        local moved = drag.moved
        drag = nil
        rest()
        if moved then
            savePosition()
        elseif api ~= nil and api.openMain ~= nil then
            local ok, err = pcall(api.openMain)
            if not ok then
                Logger.error("credits overlay: opening the main window failed:", tostring(err))
            end
        end
    end)
    return layer
end

-- The number as it should read now: the credits, or a dash when no character is logged in.
local function currentText()
    local state = api ~= nil and api.getState() or nil
    if state == nil then
        return "-"
    end
    return Format.credits(state.credits)
end

-- Brings the number up to date. Called every tick; does nothing while the overlay is off.
function CreditsWindow.refresh()
    if root == nil or numberText == nil then
        return
    end
    local text = currentText()
    if text ~= shown then
        numberText.content = text
        shown = text
    end
    -- While the rate is being worked out the bar says so in the whole of the row (Calculating... going round), then it is
    -- the label "Per hour" and the number.
    local loaded = api ~= nil and api.getState() ~= nil
    local label, rate
    if not loaded then
        label, rate = "Per hour", "-"
    elseif Rate.calculating() then
        label, rate = Rate.waitingText(), ""
    else
        label, rate = "Per hour", Rate.text()
    end
    local both = label .. "|" .. rate
    if rateText ~= nil and both ~= shownRate then
        rateLabel.content = label
        rateText.content = rate
        shownRate = both
    end
end

-- Puts the overlay on the screen. `newApi` is described at the top.
function CreditsWindow.show(newApi)
    if root ~= nil then
        return
    end
    api = newApi
    parent = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    posX, posY = clamp(startingPosition())

    -- A layer holds the parts: the bar (a filled rectangle), its border, the icon and the two texts. (Things put inside
    -- a rectangle itself are not drawn.)
    root = ui.Layer.new(parent)
    root:SetPos(posX, posY)
    root:SetSize(WIDTH, HEIGHT, 0, 0)

    local background = ui.Rectangle.new(root)
    background:SetPos(0, 0)
    background:SetSize(WIDTH, HEIGHT, 0, 0)
    background.fill = true
    background.colour = BACKGROUND

    local border = ui.Rectangle.new(root)
    border:SetPos(0, 0)
    border:SetSize(WIDTH, HEIGHT, 0, 0)
    border.fill = false
    border.outlineThickness = 1
    border.colour = BORDER

    addIcon(root)
    Kit.text(root, LABEL_X, 0, LABEL_W, ROW_H, "Credits", WHITE, ui.AlignMode.TOPLEFT)
    numberText = Kit.text(root, NUMBER_X, 0, NUMBER_W, ROW_H, "", WHITE, ui.AlignMode.BOTTOMRIGHT)
    -- (a box as tall as the text, so the label at its top and the number at its bottom are level)
    rateLabel = Kit.text(root, LABEL_X, ROW_H - 2, WIDTH - LABEL_X - PADDING, 18, "Per hour", GREY, ui.AlignMode.TOPLEFT)
    rateText = Kit.text(root, NUMBER_X, ROW_H - 2, NUMBER_W, 18, "", GREY, ui.AlignMode.BOTTOMRIGHT)
    grip = addGrip()
    shown, shownRate = nil, nil
    CreditsWindow.refresh()
end

-- Takes the overlay off the screen.
function CreditsWindow.hide()
    drag = nil
    if grip ~= nil then
        pcall(function() grip:Destroy() end)
    end
    if root ~= nil then
        pcall(function() root:Destroy() end)
    end
    root, grip, numberText, rateText, rateLabel, shown, shownRate = nil, nil, nil, nil, nil, nil, nil
end

-- True while the overlay is on the screen.
function CreditsWindow.isOpen()
    return root ~= nil
end

return CreditsWindow
