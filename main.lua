-- main.lua
-- Cards of Gielinor: earn credits from XP, Slayer and boss kills, open packs, collect cards. Wires the parts together: core/ is
-- the logic, ui/ draws, deck/ holds the cards.

-- The development tools are in dev/, which the release does not contain (there `Dev` is nil). They load first so the
-- performance probe sees the deck load, and attach last (Dev.start below).
local hasDev, Dev = pcall(require, "dev/dev")
if not hasDev then
    Dev = nil
end

local Storage = require("core/storage")
local Logger = require("core/logger")
local PluginId = require("core/pluginid")
local Version = require("core/version")
local Identity = require("core/identity")
local Earning = require("core/earning")
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
local Rate = require("core/rate")
local OverlayLoader = require("core/overlayloader")
local Events = require("core/events")

-- A card, deck file or pack that is not sound is left out and the plugin loads without it (core/cards.lua); each is logged.
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

-- Save at most once every this many server ticks (about 0.6 seconds each) while changes are pending, so frequent
-- changes such as XP gains do not save every tick.
local SAVE_INTERVAL_TICKS = 10

-- Set while a character is logged in: { name = "...", key = "<storage key>", state = <collection> }
local session = nil
local ticksSinceSave = 0
local ticksSinceLoad = 0

-- A save that is there but cannot be read is tried again every tick, and nothing is saved meanwhile (core/storage.lua,
-- Storage.load). After LOAD_TRIES failed tries (about 12 seconds) a save whose main entry is missing is loaded from its
-- buckets alone; one whose main entry is there but unreadable is never written over, however long it takes.
local LOAD_TRIES = 20
local failedLoads = 0

-- Returns the logged-in character's name, or nil if it is not available yet. The name can arrive a moment after
-- login, so callers must be ready for nil.
local function currentCharacterName()
    if not Player.IsAvailable() then
        return nil
    end
    local entity = Player.GetEntity()
    if entity == nil then
        return nil
    end
    local name = entity.displayName
    if name == nil or name == "" then
        return nil
    end
    return name
end

-- Saves the current collection if it has unsaved changes.
local function saveSession()
    if session ~= nil and session.state.dirty then
        if Storage.save(session.key, session.state) then
            session.state.dirty = false
        end
    end
end

-- Loads the collection for a newly logged-in character. profile comes from Identity.profile. If the save cannot be read
-- yet, nothing happens (the next tick tries again).
local function startSession(profile)
    -- With a tracking key and nothing saved under it yet, a collection kept under the character's name is copied
    -- (core/storage.lua), and saved at once so the copy exists before anything else changes.
    local state, adopted, problem = Storage.loadOrAdopt(profile.key, profile.adoptFrom,
        { acceptMissingMain = failedLoads >= LOAD_TRIES })
    if state == nil then
        failedLoads = failedLoads + 1
        if failedLoads == 1 then
            Logger.error("the saved collection for", profile.name, "could not be read (" .. tostring(problem)
                .. "): trying again, and nothing is saved until it is read")
        end
        return
    end
    failedLoads = 0
    session = { name = profile.name, key = profile.key, kind = profile.kind, state = state }
    ticksSinceSave = 0
    ticksSinceLoad = 0
    Rate.reset()                -- credits per hour start afresh for each character
    if adopted then
        saveSession()
        Logger.note("trackingAccess is on: the collection saved under the character name was copied to the tracking id")
    end
    Logger.debug("loaded collection for", profile.name, "(" .. profile.key .. ", " .. profile.how .. ") - credits:",
        session.state.credits,
        "unique cards:", Storage.countUniqueOwned(session.state),
        "variants:", Storage.countVariantsOwned(session.state))

    -- Slayer credits follow this character's task from where it stands now.
    SlayerEvents.begin()
    -- and so do their boss kills.
    BossEvents.begin()
end

-- Saves and forgets the current character, e.g. on logout.
local function endSession()
    SlayerEvents.finish()
    BossEvents.finish()
    if session ~= nil then
        Storage.addPlayTicks(session.state, ticksSinceLoad % Rate.TICKS_PER_MINUTE)   -- the part of a minute since the last count
    end
    saveSession()
    session = nil
    failedLoads = 0
    Rate.reset()
end

-- Runs about every 0.6 seconds. Waits for the character to be available, then loads their collection, and afterwards
-- saves pending changes at a steady pace.
Events.on("ServerLogic", "cardcollector_tick", function()
    PackWindow.refresh()
    SettingsPage.refresh()
    Hub.refresh()
    CreditsWindow.refresh()
    Viewer.refresh()
    SetsViewer.refresh()
    Tutorial.offerFirstRun()
    if session == nil then
        local profile = Identity.profile(currentCharacterName())
        if profile ~= nil then
            startSession(profile)
        end
        return
    end

    Rate.tick()                 -- the clock of the credits per hour: only runs while a collection is loaded
    ticksSinceSave = ticksSinceSave + 1
    ticksSinceLoad = ticksSinceLoad + 1
    if ticksSinceLoad % Rate.TICKS_PER_MINUTE == 0 then
        Storage.addPlayTicks(session.state, Rate.TICKS_PER_MINUTE)    -- the play time for the Stats window, a minute at a time
    end
    if ticksSinceSave >= SAVE_INTERVAL_TICKS then
        ticksSinceSave = 0
        saveSession()
    end
end)

-- Credits from XP. Ignored until a character's collection has loaded.
Events.on("SkillTransmit", "cardcollector_xp", function(e)
    if session == nil then
        return
    end
    local gain = Earning.xpGainFromEvent(e)
    if gain > 0 then
        Earning.addXP(session.state, gain)
    end
end)

-- Save and unload when the player reaches the login screen or lobby, so switching accounts never mixes up two
-- collections.
Events.on("GameStateChanged", "cardcollector_state", function(stateEvent)
    if stateEvent.newState == GameState.LOGINSCREEN or stateEvent.newState == GameState.LOBBY then
        endSession()
        Identity.reset()
    end
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
    endSession()
    -- Last, so nothing above is cut off: every event subscription still in place (core/events.lua).
    Events.shutdown()
end

-- What the windows and pages need from the plugin: the character's collection, a way to save it, and what to open.
local api = {
    getState = function() return session and session.state or nil end,
    saveNow = saveSession,
    -- The cards of a pack being opened that have not been turned over yet (the collection viewer leaves them out).
    hiddenCards = function() return PackWindow.hiddenCards() end,
    -- How the logged-in character's collection is saved: "tracking" (the tracking id), "name" or nil (not loaded).
    keyKind = function() return session and session.kind or nil end,
    openSettings = function() SettingsPage.toggleWindow() end,
}

-- The main window remembers that the player closed it (the option is saved with the others), so it stays closed the
-- next time the plugin starts.
api.onMainClosed = function() Settings.set("mainOpen", false) end

-- Opens the main window if it was closed. A failure is logged and does not stop the plugin.
local function openMain()
    local ok, err = pcall(PackWindow.show, api)
    if not ok then
        Logger.error("pack window failed:", err)
    end
end

-- Opens the tutorial (the "i" in the main window's title bar and the ribbon page's Tutorial button). The tutorial points at
-- the main window's buttons, so the window is opened first if it was closed.
api.openTutorial = function()
    api.openMain()
    Tutorial.open()
end

-- Opens the main window (the ribbon page's Open button and a click on the credits overlay) and remembers that it is
-- open, so it opens again the next time the plugin starts.
api.openMain = function()
    Settings.set("mainOpen", true)
    openMain()
end

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
local function toggleCredits()
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
Hub.init({
    getState = api.getState,
    openMain = api.openMain,
    toggleCredits = toggleCredits,
    openCollection = function() Viewer.open(api) end,
    openSets = function() SetsViewer.open(api) end,
    toggleStats = function() Stats.toggle(api) end,
    openTutorial = function() api.openTutorial() end,
})

-- Listens for Slayer kills and completions (core/slayerevents.lua); it pays credits once a character is loaded.
SlayerEvents.start(api)

-- Listens for boss kills (core/bossevents.lua); it pays credits once a character is loaded.
BossEvents.start(api)

-- What the player left showing last time. (Closing the main window altogether is fine: the credits overlay
-- and the saving carry on, and the ribbon page opens it again.)
if Settings.get("mainOpen") then
    openMain()
end
if Settings.get("creditsWindow") then
    showCredits()
end
Logger.note(PluginId.TITLE .. " " .. Version.number .. " started: " .. #Cards.list .. " cards"
    .. (#Cards.loadProblems > 0 and (", " .. #Cards.loadProblems .. " left out (see above)") or ""))

if Dev ~= nil then
    Dev.start(api)
end
