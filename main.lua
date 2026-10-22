-- main.lua
-- Card Collector (working title)
-- Earn credits, open packs, collect cards.
--
-- Saves a collection per character, earns credits from XP, and logs its progress to the
-- Lua console with log().

local Storage = require("storage")
local Earning = require("earning")
local PackWindow = require("packwindow")
local Viewer = require("viewer")
local Stats = require("stats")
local Settings = require("settings")
local SettingsPage = require("settingspage")
local Hub = require("hub")

-- The development tools (card preview, NPC browser, debug buttons...) live in the dev folder.
-- That folder is left out of the released plugin, so there Dev is nil and nothing below runs.
local devLoaded, Dev = pcall(require, "dev/dev")
if not devLoaded then
    Dev = nil
end

-- Save at most once every this many server ticks (about 0.6 seconds each) while
-- changes are pending, so frequent changes such as XP gains do not save every tick.
local SAVE_INTERVAL_TICKS = 10

-- Set while a character is logged in: { name = "...", state = <collection> }
local session = nil
local ticksSinceSave = 0
local ticksSinceLoad = 0

-- Returns the logged-in character's name, or nil if it is not available yet.
-- The name can arrive a moment after login, so callers must be ready for nil.
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
        if Storage.save(session.name, session.state) then
            session.state.dirty = false
        end
    end
end

-- Loads the collection for a newly logged-in character.
local function startSession(name)
    session = { name = name, state = Storage.load(name) }
    ticksSinceSave = 0
    ticksSinceLoad = 0
    log("loaded collection for", name, "- credits:", session.state.credits,
        "unique cards:", Storage.countUniqueOwned(session.state),
        "variants:", Storage.countVariantsOwned(session.state))

    if Dev ~= nil then
        Dev.onLogin(session.state)
        saveSession()
    end
end

-- Saves and forgets the current character, e.g. on logout.
local function endSession()
    saveSession()
    session = nil
end

-- Runs about every 0.6 seconds. Waits for the character to be available, then loads
-- their collection, and afterwards saves pending changes at a steady pace.
Event.ServerLogic.Subscribe("cardcollector_tick", function()
    PackWindow.refresh()
    SettingsPage.refresh()
    Hub.refresh()
    if session == nil then
        local name = currentCharacterName()
        if name ~= nil then
            startSession(name)
        end
        return
    end

    ticksSinceSave = ticksSinceSave + 1
    ticksSinceLoad = ticksSinceLoad + 1
    if ticksSinceSave >= SAVE_INTERVAL_TICKS then
        ticksSinceSave = 0
        saveSession()
    end
end)

-- Credits from XP. Ignored until a character's collection has loaded.
Event.SkillTransmit.Subscribe("cardcollector_xp", function(e)
    if session == nil then
        return
    end
    local gain = Earning.xpGainFromEvent(e)
    if gain > 0 then
        local earned = Earning.addXP(session.state, gain)
        if Dev ~= nil then
            Dev.onXp(e.skill, gain, session.state, earned, ticksSinceLoad)
        end
    end
end)

-- Save and unload when the player reaches the login screen or lobby, so switching
-- accounts never mixes up two collections.
Event.GameStateChanged.Subscribe("cardcollector_state", function(stateEvent)
    if stateEvent.newState == GameState.LOGINSCREEN or stateEvent.newState == GameState.LOBBY then
        endSession()
    end
end)

-- Called by the client when the plugin is disabled or reloaded.
function PluginShutdown()
    SettingsPage.shutdown()
    Hub.shutdown()
    PackWindow.hide()
    if Dev ~= nil then
        Dev.shutdown()
    end
    endSession()
end

-- What the windows and pages need from the plugin: the character's collection, a way to save it
-- and the extra buttons the development tools add (if they are there).
local api = {
    getState = function() return session and session.state or nil end,
    saveNow = saveSession,
    openSettings = function() SettingsPage.toggleWindow() end,
}

-- Opens the main window if it was closed. A failure is logged and does not stop the plugin.
local function openMain()
    local ok, err = pcall(PackWindow.show, api)
    if not ok then
        log("pack window failed:", err)
    end
end

-- The saved options, then the pages in the client's settings and behind the ribbon icon.
Settings.load()
SettingsPage.init(api)
Hub.init({
    getState = api.getState,
    openMain = openMain,
    openCollection = function() Viewer.open(api) end,
    toggleStats = function() Stats.toggle(api) end,
})

-- With the development tools present, their buttons go on the Home window...
if Dev ~= nil then
    api.extraButtons = Dev.buttons(api, PackWindow.refresh)
end

openMain()

-- ...and their windows open (after the main window, so they sit on top of it).
if Dev ~= nil then
    Dev.start()
end

log("Card Collector started")
