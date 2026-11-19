-- ui/tutorial.lua
-- The in-game tutorial: a small help panel at the bottom left ("Step 2 of 7", numbered step buttons, arrows, a close X) and a
-- gold pointer over the control to click next. A step is finished when the player does what it asks (a window opens, a pack is
-- opened), which is seen by looking at the windows each few ticks: nothing in them is hooked. The numbered buttons and arrows
-- move between steps by hand, so a step that cannot finish (the player has no credits to buy a pack) never traps anyone.
-- The pointer and the flashing frame are the game's own sprites (the ones the game's tutorials use), moved onto the live
-- position of the control every tick, so they follow a window that is dragged.
--
-- The steps are in core/tutorial.lua. Opened by the "i" in the main window's title bar, the ribbon page's Tutorial button, and
-- once by itself on a character's first look at the main window (the "tutorialSeen" setting; closing the panel counts as seen).
--
-- Handlers here hold only numbers and the module's functions; every live component is kept in `S`, which is emptied when the
-- tutorial closes (the client keeps a handler after its component is destroyed, and what the handler reaches stays in memory:
-- see core/memory.lua). dev/check_tutorial.lua looks at that.

local Kit = require("ui/kit")
local Logger = require("core/logger")
local Settings = require("core/settings")
local Steps = require("core/tutorial")
local PackWindow = require("ui/packwindow")
local Shop = require("ui/shopwindow")
local Reveal = require("ui/revealscreen")
local Viewer = require("ui/viewer")
local SetsViewer = require("ui/setsviewer")
local Events = require("core/events")

local Tutorial = {}

local EVENT = "cardcollector_tutorial"
local WIDTH, HEIGHT = 521, 144              -- the panel, title bar included
local MARGIN = 8                            -- from the left and bottom edges of the screen
local CHECK_EVERY = 5                       -- logic ticks (50 a second) between looks at the windows
local ARROW_W, ARROW_H = 41, 54             -- the pointer sprite
local WHITE = Vector4.new(1.0, 1.0, 1.0, 1.0)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1.0)

-- The nine pieces of each of the game's two flashing frames (yellow, white), if this client has them. They are cross-faded:
-- as one fades out the other fades in, so the border seems to flash between gold and white however the control is coloured.
local FRAMES = { yellow = {}, white = {} }
for name, number in pairs({ yellow = 1, white = 2 }) do
    for index = 0, 8 do
        local ok, sprite = pcall(function() return id.Sprite["AIF_EXAMINE_HIGHLIGHT_" .. number .. "_" .. index] end)
        if ok and sprite ~= nil then
            FRAMES[name][#FRAMES[name] + 1] = sprite
        end
    end
end
local FRAME_GROW = 4                        -- how far the frame stands outside the control
local FLASH_SPEED = 5                       -- ticks (50 a second) per radian of the flash: a full flash is about 0.6 seconds
local FONT = nil                            -- the panel's words: the small font, so two lines fit the box
do
    local ok, font = pcall(function() return id.Font.MUSEO_SANS_11PT_REGULAR end)
    if ok then
        FONT = font
    end
end

-- Everything that is live: the panel, its parts, the pointer and the step. Emptied by close().
local S = {}
local offered = false          -- the first-run offer has been made this session

-- The tutorial's own controls and the first-run offer are looked at by the tests.
function Tutorial.debugState()
    return S
end

local function rootOf(component)
    return component.root or component
end

local function gameLayer()
    return ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
end

-- What the steps can see: which windows are open.
local function observe()
    return {
        shopOpen = Shop.isOpen(),
        revealActive = Reveal.active(),
        collectionOpen = Viewer.isOpen(),
        gridView = Viewer.isGrid(),
        setsOpen = SetsViewer.isOpen(),
    }
end

-- The component for an anchor name, or nil if that control is not on the screen.
local function anchorFor(name)
    if name == nil then
        return nil
    end
    if name == "buy" then
        return Shop.anchor(name)
    elseif name == "grid" then
        return Viewer.anchor(name)
    end
    return PackWindow.anchor(name)
end

-- The screen position and size of a component, or nil if it is hidden.
local function boundsOf(component)
    if component == nil or component.hidden == true or component.visibleGlobal == false then
        return nil
    end
    local point = component.xyGlobal
    if point == nil then
        return nil
    end
    return point.x, point.y, tonumber(component.width) or 0, tonumber(component.height) or 0
end

-- One flashing frame's nine pieces: corners 10 pixels, the middle strips stretched.
local function sizeFrame(frame, width, height)
    frame.layer:SetPos(0, 0)
    frame.layer:SetSize(width, height)
    local xs, ys = { 0, 10, width - 10 }, { 0, 10, height - 10 }
    local ws, hs = { 10, width - 20, 10 }, { 10, height - 20, 10 }
    for index, part in ipairs(frame.parts) do
        local column, row = (index - 1) % 3 + 1, (index - 1) // 3 + 1
        part:SetPos(xs[column], ys[row])
        part:SetSize(ws[column], hs[row])
    end
end

-- Makes one frame (a layer and its nine sprites) inside `parent`.
local function makeFrame(parent, sprites)
    local layer = ui.Layer.new(parent)
    layer.clickthrough = true
    local parts = {}
    for index, sprite in ipairs(sprites) do
        local part = ui.Sprite.new(layer)
        part.spriteID = sprite
        part.clickthrough = true
        part.isTiling = true
        parts[index] = part
    end
    return { layer = layer, parts = parts }
end

-- Puts the panel (and its drag layer) above the other windows, then the pointer above that.
local function bringToFront()
    local window = S.window
    if window == nil then
        return
    end
    if window.Show ~= nil then
        pcall(function() window:Show() end)
    else
        pcall(function() window:MoveToFront() end)
    end
    if S.overlay ~= nil then
        S.overlay:MoveToFront()
    end
end

-- Moves the pointer and the frame onto the current step's control, or hides them.
local function place()
    local name = Steps.target(S.step, S.obs or observe())
    local x, y, width, height = boundsOf(anchorFor(name))
    local hidden = x == nil or width <= 0 or height <= 0
    local screenW, screenH = S.parent.width, S.parent.height
    if not hidden and (x < 0 or y < 0 or x + width > screenW or y + height > screenH) then
        hidden = true                   -- partly off the screen: no pointer rather than a wrong one
    end
    S.pointer.hidden = hidden
    S.frame.hidden = hidden
    if hidden then
        return
    end
    local w, h = width + 2 * FRAME_GROW, height + 2 * FRAME_GROW
    S.frame:SetPos(x - FRAME_GROW, y - FRAME_GROW)
    S.frame:SetSize(w, h)
    sizeFrame(S.yellow, w, h)
    sizeFrame(S.white, w, h)
    local flash = 0.5 + 0.5 * math.sin(S.ticks / FLASH_SPEED)
    S.yellow.layer.alpha, S.white.layer.alpha = flash, 1 - flash
    local bob = 3 + 3 * math.sin(S.ticks / 7)
    if y >= ARROW_H + 8 then
        S.pointer.rotationDegrees = 0
        S.pointer:SetPos(x + width / 2 - ARROW_W / 2, y - ARROW_H - 4 - bob)
    else
        S.pointer.rotationDegrees = 180        -- no room above: below the control, pointing up
        S.pointer:SetPos(x + width / 2 - ARROW_W / 2, y + height + 4 + bob)
    end
end

local function setText(widget, content)
    if widget ~= nil and widget.content ~= content then
        widget.content = content
    end
end

local close

-- Shows step `step` (1 to the number of steps): the words, the counter and which number is outlined.
local function go(step)
    if S.window == nil or step < 1 or step > Steps.count() then
        return
    end
    S.step = step
    S.mem = {}
    S.obs = observe()
    setText(S.text, Steps.text(step))
    setText(S.counter, "Step " .. step .. " of " .. Steps.count())
    for index, outline in ipairs(S.outlines) do
        outline.hidden = index ~= step
    end
    if S.prevArrow ~= nil then
        S.prevArrow.alpha = step == 1 and 0.35 or 1
    end
    if S.nextArrow ~= nil then
        S.nextArrow.alpha = step == Steps.count() and 0.35 or 1
    end
    place()
end

-- Next, from the arrow or from a finished step. The last step's Next ends the tutorial.
local function advance()
    if S.step == nil then
        return
    end
    if S.step >= Steps.count() then
        close(true)
    else
        go(S.step + 1)
    end
end

local function onTick()
    if S.window == nil then
        return
    end
    S.ticks = S.ticks + 1
    local ok, err = pcall(function()
        if S.ticks % CHECK_EVERY == 0 then
            S.obs = observe()
            if Steps.isDone(S.step, S.obs, S.mem) then
                advance()
                return
            end
            bringToFront()
        end
        if S.window ~= nil then
            place()
        end
    end)
    if not ok then
        Logger.error("tutorial: closed after an error:", tostring(err))
        close(false)
    end
end

-- Closes the panel and takes everything away. `remember` records that the tutorial has been seen (the player closed it or
-- came to the end), so it is not offered again.
function close(remember)
    if S.window == nil and S.overlay == nil then
        return
    end
    pcall(function() Events.off("Logic", EVENT) end)
    local window, overlay = S.window, S.overlay
    for key in pairs(S) do
        S[key] = nil                    -- (before anything is destroyed: nothing a handler reaches keeps a component)
    end
    for _, part in ipairs({ overlay, window }) do
        if part ~= nil then
            pcall(function() part:Destroy() end)
        end
    end
    if remember and not Settings.get("tutorialSeen") then
        Settings.set("tutorialSeen", true)
    end
end

-- A numbered step button, an arrow or similar: PrettyUI's flat button, at (x, 72) and 26 across.
local function smallButton(parent, label, x, onPress, tooltip)
    return Kit.smallButton(parent, label, x, 72, 26, 26, onPress, tooltip)
end

local function addText(parent, x, y, w, h, colour)
    return prettyui.Text.new(parent, {
        text = "", x = x, y = y, width = w, height = h, maxLines = 2, absolute = true, font = FONT,
        colour = colour == WHITE and 0xF0F0F0FF or 0xBFBFBFFF,
    })
end

-- Builds the panel and the pointer, shows step 1 and starts watching.
local function build()
    local parent = gameLayer()
    S.parent = parent
    S.ticks = 0
    local stepCount = Steps.count()
    local startX = WIDTH - 66 - stepCount * 31
    local window, content = Kit.window(parent, "Cards of Gielinor Help", WIDTH, HEIGHT, function() close(true) end,
        0, 0, false, false, nil, MARGIN, parent.height - HEIGHT - MARGIN)
    S.window = window
    S.content = content
    -- The "i" over the title bar's left corner.
    local info = ui.Sprite.new(rootOf(window))
    info:SetPos(8, 8)
    info:SetSize(26, 26)
    info.spriteID = id.Sprite.TUTSYS_INFO_ICON
    info.clickthrough = true
    info:MoveToFront()
    -- The words, in a black box with a thin border.
    local back = ui.Rectangle.new(content)
    back:SetPos(8, 16)
    back:SetSize(WIDTH - 32, 40)
    back.fill = true
    back.rgba = 0x000000FF
    back.clickthrough = true
    local border = ui.Rectangle.new(content)
    border:SetPos(8, 16)
    border:SetSize(WIDTH - 32, 40)
    border.fill = false
    border.rgba = 0x756C60FF
    border.clickthrough = true
    S.text = addText(content, 16, 19, WIDTH - 48, 34, WHITE)
    S.counter = addText(content, 16, 74, startX - 64, 24, GREY)
    -- Previous, the numbers, next.
    local prev = smallButton(content, "", startX - 34, function() Tutorial.step(-1) end, "Previous step")
    S.prevArrow = ui.Sprite.new(rootOf(prev))
    S.prevArrow:SetPos(1, 2)
    S.prevArrow:SetSize(24, 24)
    S.prevArrow.spriteID = id.Sprite.RS3_ICON_CALENDAR_NAVIGATION_24PX_0
    S.prevArrow.isFlippedHorizontally = true
    S.prevArrow.clickthrough = true
    S.outlines = {}
    for index = 1, stepCount do
        local number = index
        local button = smallButton(content, tostring(index), startX + (index - 1) * 31, function() Tutorial.show(number) end)
        local outline = ui.Rectangle.new(rootOf(button))
        outline:SetPos(0, 0)
        outline:SetSize(0, 0, 1, 1)
        outline.fill = false
        outline.rgba = 0xD8C078FF
        outline.clickthrough = true
        S.outlines[index] = outline
    end
    local nextButton = smallButton(content, "", WIDTH - 58, function() Tutorial.step(1) end, "Next step")
    S.nextArrow = ui.Sprite.new(rootOf(nextButton))
    S.nextArrow:SetPos(1, 2)
    S.nextArrow:SetSize(24, 24)
    S.nextArrow.spriteID = id.Sprite.RS3_ICON_CALENDAR_NAVIGATION_24PX_0
    S.nextArrow.clickthrough = true

    -- The pointer and the frame, on a layer the size of the screen that lets clicks through.
    S.overlay = ui.Layer.new(parent)
    S.overlay:SetPos(0, 0)
    S.overlay:SetSize(0, 0, 1.0, 1.0)
    S.overlay.clickthrough = true
    S.frame = ui.Layer.new(S.overlay)
    S.frame.clickthrough = true
    S.yellow = makeFrame(S.frame, FRAMES.yellow)
    S.white = makeFrame(S.frame, FRAMES.white)
    S.pointer = ui.Sprite.new(S.overlay)
    S.pointer.spriteID = id.Sprite.RS3_INFO_DISPLAY_POINTER
    S.pointer:SetSize(ARROW_W, ARROW_H)
    S.pointer.clickthrough = true
    S.pointer.hidden = true
    S.frame.hidden = true

    go(1)
    bringToFront()
    Events.on("Logic", EVENT, onTick)
end

-- Moves one step on (+1) or back (-1) by hand.
function Tutorial.step(delta)
    if S.step == nil then
        return
    end
    if delta > 0 then
        advance()
    else
        go(S.step - 1)
    end
end

-- Jumps to a numbered step.
function Tutorial.show(step)
    go(step)
end

-- Opens the tutorial at step 1 (or brings it to the front if it is open). A failure is logged and leaves nothing behind.
function Tutorial.open()
    if S.window ~= nil then
        bringToFront()
        return
    end
    local ok, err = pcall(build)
    if not ok then
        Logger.error("tutorial: could not be built:", tostring(err))
        close(false)
    end
end

-- Takes the panel away. `remember` (false when nothing is said) marks the tutorial as seen.
function Tutorial.close(remember)
    close(remember == true)
end

function Tutorial.isOpen()
    return S.window ~= nil
end

-- Offers the tutorial once, the first time the main window shows the Home screen on an install that has not seen it. Called
-- every server tick; does nothing once offered, seen or open.
function Tutorial.offerFirstRun()
    if offered or Settings.get("tutorialSeen") then
        return
    end
    if S.window ~= nil or PackWindow.currentScreen() ~= "home" then
        return
    end
    offered = true
    Tutorial.open()
end

return Tutorial
