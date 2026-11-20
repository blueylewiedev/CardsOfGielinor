-- ui/packwindow.lua
-- The main window, with two screens of which one shows at a time:
--   nosession the collection has not loaded yet: a spinner and "Loading your
--     collection..." (the wait for the tracking id or permission)
--   home the dashboard: CREDITS, COLLECTION (how much of the deck is owned, and the
--     Collection, Sets and Stats buttons) and PACKS (how many packs
--              the credits buy, and the button that opens the Shop)
-- Packs are bought in the Shop (ui/shopwindow.lua) and shown by ui/revealscreen.lua; PackWindow.startReveal hands the cards over.

local Cards = require("core/cards")
local Logger = require("core/logger")
local Storage = require("core/storage")
local Packs = require("core/packs")
local Format = require("core/format")
local Viewer = require("ui/viewer")
local SetsViewer = require("ui/setsviewer")
local Kit = require("ui/kit")
local PluginId = require("core/pluginid")
local Stats = require("ui/stats")
local Shop = require("ui/shopwindow")
local Reveal = require("ui/revealscreen")
local Rate = require("core/rate")
local Theme = require("ui/theme")
local WHITE, GREY, GOLD, PANEL_BACK, PANEL_BORDER = Theme.WHITE, Theme.GREY, Theme.GOLD, Theme.PANEL_BACK, Theme.PANEL_BORDER
local Util = require("ui/util")
local setText = Util.setText

local PackWindow = {}


local WIDTH = 236
-- The Home screen is wider than the loading screen. PrettyUI's content area is inset further from the left of the frame
-- than from the right, so everything on it is moved left by HOME_SHIFT to look centred.
local HOME_WIDTH = 256
local HOME_SHIFT = -10
local HOME_MID = HOME_WIDTH + 2 * HOME_SHIFT   -- the width to centre things in
-- The Home screen is three dark panels with a gold heading. The collection's buttons are one to a row (PrettyUI makes
-- a button as wide as its label needs, so two side by side would overlap). The window's content is HOME_WIDTH less
-- its 8 pixel frame at each side; panels are 6 in from both.
local PANEL_X, PANEL_W = 6, HOME_MID - 8
local INNER_X, HOME_W = 16, HOME_MID - 28       -- where the text and buttons in a panel start, and their width
local CREDITS_Y, CREDITS_H = 10, 80      -- (10 down from the top, and HEIGHTS.home leaves 10 under the last thing, so the window is even above and below)
local COLLECTION_Y, COLLECTION_H = CREDITS_Y + CREDITS_H + 8, 180
local PACKS_Y, PACKS_H = COLLECTION_Y + COLLECTION_H + 8, 98
local BAR_TRACK = Vector4.new(0.16, 0.14, 0.12, 1.0)
local BAR_FILL = Vector4.new(0.85, 0.68, 0.16, 1.0)
local BAR_H = 14
local LOADING_SPINNER = 40    -- the spinner on the nosession screen, across
-- Window height for each screen.
local HEIGHTS = { nosession = 90, home = PACKS_Y + PACKS_H + 10 }

-- Set by PackWindow.show(): api.getState() (the collection, or nil), api.saveNow(), api.openSettings() (the cog),
-- and api.openTutorial() (the "i"; optional).
local api = nil
local window = nil
local content = nil  -- the component inside the window frame that the screens are built in
local screens = {}   -- screen name -> Layer
local widgets = {}   -- named pieces that need updating later
local current = nil  -- name of the screen being shown
local settingsButton = nil   -- the cog in the title bar, while Home is showing (see showScreen)
local helpButton = nil       -- the "i" at the left end of the title bar, which opens the tutorial (api.openTutorial)
-- Text comes from ui/kit.lua.
local makeText = Kit.text

-- Shows one screen (nosession or home), hides the others and resizes the window to fit it.
local function showScreen(name)
    current = name
    for screenName, layer in pairs(screens) do
        layer.hidden = (screenName ~= name)
    end
    window:SetSize(({ home = HOME_WIDTH })[name] or WIDTH, HEIGHTS[name] + Kit.titleBarHeight())
    -- The settings cog sits in the title bar, which is where the window's width puts it, so it is made once the window
    -- has this screen's size and taken away when another screen shows.
    if settingsButton ~= nil then
        pcall(function() settingsButton:Destroy() end)
        settingsButton = nil
    end
    if helpButton ~= nil then
        pcall(function() helpButton:Destroy() end)
        helpButton = nil
    end
    if name == "home" then
        settingsButton = Kit.titleButton(window, "SETTINGS", function() api.openSettings() end, "Settings")
        if api.openTutorial ~= nil then
            helpButton = Kit.titleButton(window, "INFO", function() api.openTutorial() end, "Tutorial", "left")
        end
    end
    -- The spinner only turns while its screen is showing.
    if widgets.spinner ~= nil then
        pcall(function()
            if name == "nosession" then
                widgets.spinner:Start()
            else
                widgets.spinner:Stop()
            end
        end)
    end
end

-- True while cards that were bought are still being revealed (a new purchase has to wait).
function PackWindow.busy()
    return Reveal.active()
end

-- Starts the reveal of cards that were just bought (and saved): `results` from Packs.open, `packTypeId` the pack bought.
-- The main window refreshes itself when the reveal closes.
function PackWindow.startReveal(results, packTypeId)
    if window == nil then
        return
    end
    Reveal.start(results, packTypeId, { onClose = function() PackWindow.refresh() end })
end

-- The cards of the pack being opened that the player has not seen yet, as { [variant key] = copies } (see ui/revealscreen.lua).
function PackWindow.hiddenCards()
    return Reveal.hiddenCards()
end

-- Builds both screens once, when the window is created. Only one is visible at a time.
local function buildScreens()
    -- Each screen is a Layer that fills the window.
    for _, name in ipairs({ "nosession", "home" }) do
        local layer = ui.Layer.new(content)
        layer:SetPos(0, 0)
        layer:SetSize(0, 0, 1.0, 1.0)
        layer.hidden = true
        screens[name] = layer
    end

    -- nosession: a spinner over "Loading your collection...", centred in the content (which is Kit.contentWidth wide)
    local contentWidth = Kit.contentWidth(WIDTH)
    widgets.spinner = Kit.spinner(screens.nosession, (contentWidth - LOADING_SPINNER) // 2, 8, LOADING_SPINNER)
    makeText(screens.nosession, 0, 8 + LOADING_SPINNER + 6, contentWidth, 24, "Loading your collection...", GREY)

    -- home: three sections. Each is a dark panel with a brown border, made before what goes on it.
    local function panel(y, h, heading)
        Kit.panel(screens.home, PANEL_X, y, PANEL_W, h, heading)
    end
    panel(CREDITS_Y, CREDITS_H, "CREDITS")
    panel(COLLECTION_Y, COLLECTION_H, "COLLECTION")
    panel(PACKS_Y, PACKS_H, "PACKS")

    widgets.creditsText = makeText(screens.home, INNER_X, CREDITS_Y + 28, HOME_W, 22, "", WHITE)
    widgets.rateText = makeText(screens.home, INNER_X, CREDITS_Y + 52, HOME_W, 20, "", GREY)
    -- A small reset button (PrettyUI's UNDO sprite, the stopwatch reset icon) at the end of that line starts the credits per hour
    -- again (it says Calculating... for a minute).
    Kit.iconButton(screens.home, "UNDO", INNER_X + HOME_W - 24, CREDITS_Y + 50, function()
        Rate.reset()
        PackWindow.refresh()
    end, "Start the credits per hour again")

    -- The collection: a bar that fills as the deck is collected, and what it says in words.
    local barY = COLLECTION_Y + 30
    local track = ui.Rectangle.new(screens.home)
    track:SetPos(INNER_X, barY)
    track:SetSize(HOME_W, BAR_H)
    track.fill = true
    track.colour = BAR_TRACK
    widgets.barFill = ui.Rectangle.new(screens.home)
    widgets.barFill:SetPos(INNER_X + 1, barY + 1)
    widgets.barFill:SetSize(1, BAR_H - 2)
    widgets.barFill.fill = true
    widgets.barFill.colour = BAR_FILL
    widgets.barFill.hidden = true
    local trackBorder = ui.Rectangle.new(screens.home)
    trackBorder:SetPos(INNER_X, barY)
    trackBorder:SetSize(HOME_W, BAR_H)
    trackBorder.fill = false
    trackBorder.outlineThickness = 1
    trackBorder.colour = PANEL_BORDER
    widgets.collectionText = makeText(screens.home, INNER_X, COLLECTION_Y + 50, HOME_W, 20, "", GREY)
    widgets.collectionButton = Kit.buttonAt(screens.home, "Collection", INNER_X, COLLECTION_Y + 78, HOME_W, 30, function()
        if Viewer.isOpen() then
            Viewer.close()
        else
            Viewer.open(api)
        end
    end)
    widgets.setsButton = Kit.buttonAt(screens.home, "Sets", INNER_X, COLLECTION_Y + 112, HOME_W, 30, function()
        SetsViewer.toggle(api)
    end)
    Kit.buttonAt(screens.home, "Stats", INNER_X, COLLECTION_Y + 146, HOME_W, 30, function()
        Stats.toggle(api)
    end)

    widgets.affordText = makeText(screens.home, INNER_X, PACKS_Y + 28, HOME_W, 20, "", WHITE)
    widgets.shopButton = Kit.buttonAt(screens.home, "Open the Shop", INNER_X, PACKS_Y + 54, HOME_W, 34, function()
        Shop.toggle({
            getState = function() return api.getState() end,
            saveNow = function() api.saveNow() end,
            busy = PackWindow.busy,
            startReveal = PackWindow.startReveal,
        })
    end, "positive")
end

-- Creates the window. `newApi` supplies getState, saveNow, openSettings and openTutorial (see above).
function PackWindow.show(newApi)
    if window ~= nil then
        return
    end
    api = newApi
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    -- `window` is the frame (resized per screen); `content` is what the screens go inside.
    window, content = Kit.window(gameWindow, PluginId.TITLE, WIDTH, HEIGHTS.nosession, function()
        PackWindow.hide()
        -- (main.lua remembers it was closed, so it stays closed the next time the plugin starts)
        if api ~= nil and api.onMainClosed ~= nil then
            api.onMainClosed()
        end
    end, { xAnchor = 0, yAnchor = 0.2 })
    buildScreens()
    PackWindow.refresh()
end

-- Brings the window up to date with the character's collection. Called every tick, and does nothing while a pack is
-- being revealed so the reveal is not interrupted.
function PackWindow.refresh()
    if window == nil then
        return
    end
    Stats.refresh()
    Shop.refresh()
    local state = api.getState()

    if state == nil then
        Viewer.close()
        SetsViewer.close()
        Shop.hide()
        Reveal.close()
        if current ~= "nosession" then
            showScreen("nosession")
        end
        return
    end

    -- A reveal in progress must not be interrupted. This checks the reveal itself, not the
    -- screen name, so that finishing the reveal lets the window go back to home.
    if Reveal.active() then
        return
    end

    setText(widgets.creditsText, Format.credits(state.credits))
    setText(widgets.rateText, "Per hour: " .. Rate.text())
    -- The collection bar and the words under it.
    local owned, total = Storage.countUniqueOwned(state), #Cards.list
    local fraction = total > 0 and owned / total or 0
    local barWidth = math.floor((HOME_W - 2) * fraction)
    if owned > 0 and barWidth < 2 then
        barWidth = 2                      -- a sliver shows at once
    end
    if widgets.barWidth ~= barWidth then
        widgets.barWidth = barWidth
        widgets.barFill.hidden = (barWidth == 0)
        widgets.barFill:SetSize(math.max(barWidth, 1), BAR_H - 2)
    end
    setText(widgets.collectionText, Format.credits(owned) .. " of " .. Format.credits(total) .. " cards ("
        .. string.format("%.1f", 100 * fraction) .. "%)")
    -- How many packs the credits buy, at the standard pack's price (other packs can cost more or less).
    local price = Packs.priceFor("standard")
    local affordable = price > 0 and state.credits // price or 0
    if affordable >= 1 then
        setText(widgets.affordText, "You can afford " .. affordable .. (affordable == 1 and " pack" or " packs"))
    else
        setText(widgets.affordText, "Next pack in " .. Format.credits(price - state.credits) .. " credits")
    end
    if current ~= "home" then
        showScreen("home")
    end
end

-- The name of the screen being shown, or nil if the window is not created (the tutorial waits for "home").
function PackWindow.currentScreen()
    return current
end

-- The component of one of the Home screen's controls, for the tutorial's pointer: "shop", "collection", "sets" or
-- "settings" (the cog). nil while the Home screen is not showing.
function PackWindow.anchor(name)
    if window == nil or current ~= "home" then
        return nil
    end
    local control = ({ shop = widgets.shopButton, collection = widgets.collectionButton, sets = widgets.setsButton,
        settings = settingsButton })[name]
    if control == nil then
        return nil
    end
    return control.root or control
end

-- Closes the window and everything that belongs to it (collection, statistics, any reveal).
function PackWindow.hide()
    if settingsButton ~= nil then
        pcall(function() settingsButton:Destroy() end)
        settingsButton = nil
    end
    if helpButton ~= nil then
        pcall(function() helpButton:Destroy() end)
        helpButton = nil
    end
    Viewer.close()
    SetsViewer.close()
    Stats.hide()
    Shop.hide()
    Reveal.close()
    if widgets.spinner ~= nil then
        pcall(function() widgets.spinner:Stop() end)     -- it listens to the logic tick while it turns
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
