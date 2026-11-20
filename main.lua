-- main.lua
-- Cards of Gielinor: earn credits from XP, Slayer and boss kills, open packs, collect cards. Wires the parts together: core/ is
-- the logic, ui/ draws, deck/ holds the cards.

-- The development tools are in dev/, which the release does not contain (there `Dev` is nil). They load first so the
-- performance probe sees the deck load, and attach last (Dev.start below).
local Logger = require("core/logger")
local hasDev, Dev = pcall(require, "dev/dev")
if not hasDev then
    -- Only a missing file is expected (the release has none); any other error is a fault in the dev tools, so it is logged.
    if not string.find(tostring(Dev), "not found", 1, true) then
        Logger.error("the development tools failed to load:", tostring(Dev))
    end
    Dev = nil
end

local PluginId = require("core/pluginid")
local Version = require("core/version")
local Identity = require("core/identity")
local Session = require("core/session")
local SlayerEvents = require("core/slayerevents")
local BossEvents = require("core/bossevents")
local PackWindow = require("ui/packwindow")
local Tutorial = require("ui/tutorial")
local Viewer = require("ui/viewer")
local SetsViewer = require("ui/setsviewer")
local Stats = require("ui/stats")
local Settings = require("core/settings")
local SettingsPage = require("ui/settingspage")
local Hub = require("ui/hub")
local CreditsWindow = require("ui/creditswindow")
local OverlayLoader = require("core/overlayloader")
local Events = require("core/events")

-- A card, deck file or pack that is not sound is left out and the plugin loads without it (core/cards.lua, core/packtypes.lua); each is logged.
local Cards = require("core/cards")
for _, problem in ipairs(Cards.loadProblems) do
    Logger.error("DECK PROBLEM (left out):", problem)
end

-- Starts looking for the tracking id (see core/identity.lua).
Identity.start()

-- Fetches the card overlay (card fixes and new cards since the approved version) and applies it a few lines at a
-- time (core/overlayloader.lua). With no httpAccess permission, or if anything goes wrong, the plugin simply has
-- the cards it shipped with.
OverlayLoader.start()

-- The character's collection (core/session.lua) loads, saves and credits XP.
Session.start()

-- Runs about every 0.6 seconds: the windows follow the collection, and the session loads or saves it.
Events.on("ServerLogic", "cardcollector_tick", function()
    PackWindow.refresh()
    SettingsPage.refresh()
    Hub.refresh()
    CreditsWindow.refresh()
    Viewer.refresh()
    SetsViewer.refresh()
    Tutorial.offerFirstRun()
    OverlayLoader.release()
    Session.tick()
end)

-- Called by the client when the plugin is disabled or reloaded.
function PluginShutdown()
    OverlayLoader.shutdown()
    SlayerEvents.shutdown()
    BossEvents.shutdown()
    SettingsPage.shutdown()
    Hub.shutdown()
    CreditsWindow.hide()
    Tutorial.close(false)
    PackWindow.hide()
    Session.finish()
    -- Last, so nothing above is cut off: every event subscription still in place (core/events.lua).
    Events.shutdown()
end

-- What the windows and pages need from the plugin, in one table: the character's collection, a way to save it, and what to
-- open. Everything that is given an api is given this one.
local api = {}

api.getState = Session.getState
api.saveNow = Session.save
api.keyKind = Session.keyKind
-- The cards of a pack being opened that have not been turned over yet (the collection viewer leaves them out).
api.hiddenCards = function() return PackWindow.hiddenCards() end
api.openSettings = function() SettingsPage.toggleWindow() end

-- The main window remembers that the player closed it (the option is saved with the others), so it stays closed the
-- next time the plugin starts.
api.onMainClosed = function() Settings.set("mainOpen", false) end

-- Opens the main window if it was closed. A failure is logged and does not stop the plugin.
local function showMain()
    local ok, err = pcall(PackWindow.show, api)
    if not ok then
        Logger.error("pack window failed:", err)
    end
end

-- Opens the main window (the ribbon page's Open button and a click on the credits overlay) and remembers that it is
-- open, so it opens again the next time the plugin starts.
api.openMain = function()
    Settings.set("mainOpen", true)
    showMain()
end

-- Opens the tutorial (the "i" in the main window's title bar and the ribbon page's Tutorial button). The tutorial points at
-- the main window's buttons, so the window is opened first if it was closed.
api.openTutorial = function()
    api.openMain()
    Tutorial.open()
end

api.openCollection = function() Viewer.open(api) end
api.openSets = function() SetsViewer.open(api) end
api.toggleStats = function() Stats.toggle(api) end

-- Puts the credits overlay on the screen. A failure is logged and does not stop the plugin.
local function showCredits()
    local ok, err = pcall(CreditsWindow.show, api)
    if not ok then
        Logger.error("credits overlay failed:", err)
    end
    return ok
end

-- Puts the credits overlay on the screen if it was off, and takes it off if it was on; remembers which (the
-- "Show the credits overlay" switch on the settings page is the same option).
api.toggleCredits = function()
    if CreditsWindow.isOpen() then
        CreditsWindow.hide()
        Settings.set("creditsWindow", false)
    elseif showCredits() then
        Settings.set("creditsWindow", true)
    end
end

-- Turning the credits overlay's switch on or off on the settings page shows or hides it at once.
api.onSettingChanged = function(optionId)
    if optionId ~= "creditsWindow" then
        return
    end
    if Settings.get("creditsWindow") then
        showCredits()
    else
        CreditsWindow.hide()
    end
end

-- The saved options, then the pages in the client's settings and behind the ribbon icon.
Settings.load()
SettingsPage.init(api)
Hub.init(api)

-- Slayer credits and boss kills (core/slayerevents.lua, core/bossevents.lua); they pay credits once a character is loaded.
SlayerEvents.start(api)
BossEvents.start(api)

-- What the player left showing last time. (Closing the main window altogether is fine: the credits overlay
-- and the saving carry on, and the ribbon page opens it again.)
if Settings.get("mainOpen") then
    showMain()
end
if Settings.get("creditsWindow") then
    showCredits()
end
Logger.note(PluginId.TITLE .. " " .. Version.number .. " started: " .. #Cards.list .. " cards"
    .. (#Cards.loadProblems > 0 and (", " .. #Cards.loadProblems .. " left out (see above)") or ""))

if Dev ~= nil then
    Dev.start(api)
end
