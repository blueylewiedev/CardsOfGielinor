-- ui/settingspage.lua
-- The plugin's settings, built with PrettyUI. They let the player change the pack difficulty
-- of the logged-in character and switch the card effects on and off.
--
-- The same page is shown in two places, each kept up to date:
--   "client" : the plugin's page in the client's settings (needs "hasSettingsIcon" in plugin.json)
--   "window" : a window of its own, opened by the Settings button in the main window

local Packs = require("core/packs")
local Settings = require("core/settings")
local Storage = require("core/storage")
local Kit = require("ui/kit")

local SettingsPage = {}

local SUBSCRIBER = "cardcollector_settings"
local WINDOW_WIDTH, WINDOW_HEIGHT = 320, 330
-- The divider line sits low in its box, so a negative space above pulls it up under the note and
-- the space below keeps the "Effects" heading off it. Adjust these to move it.
local DIVIDER_HEIGHT, DIVIDER_ABOVE, DIVIDER_BELOW = 10, -24, 50

local api = nil          -- api.getState() and api.saveNow(), as for the pack window
local pages = {}         -- "client" / "window" -> { view = <PrettyUI view>, widgets = {...} }
local window = nil       -- the settings window's frame, while it is open
local updating = false   -- true while the page itself changes a control, so that is not mistaken for the player

-- Removes one of the two copies of the page ("client" or "window") from the screen.
local function destroyPage(key)
    local page = pages[key]
    if page ~= nil then
        pcall(function() page.view:Destroy() end)
        pages[key] = nil
    end
end

-- Fills `parent` with the settings and remembers it under `key`.
local function build(key, parent, width, height)
    destroyPage(key)
    local view = prettyui.SimpleView.new(parent, { width = width, height = height })
    local page = { view = view, widgets = {} }
    pages[key] = page
    view:AddTitle("Card Collector")

    view:AddText("Pack difficulty")
    local choices = {}
    for _, tier in ipairs(Packs.tiers) do
        choices[#choices + 1] = { text = tier.name .. " - " .. tier.price .. " credits per pack", value = tier.id }
    end
    page.widgets.difficulty = view:AddRadioButton(choices, {
        onChange = function(_, value)
            if updating then
                return
            end
            local state = api.getState()
            if state ~= nil then
                Storage.setDifficulty(state, value)
                api.saveNow()
            end
        end,
    })
    page.widgets.note = view:AddText("")

    -- PrettyUI's divider is 60 units tall by default; `height` shrinks it if it is supported.
    view:AddDivider({ height = DIVIDER_HEIGHT, marginTop = DIVIDER_ABOVE, marginBottom = DIVIDER_BELOW })

    view:AddText("Effects")
    local effects = {}
    for _, option in ipairs(Settings.options) do
        effects[#effects + 1] = { text = option.label, value = option.id, selected = Settings.get(option.id) }
    end
    page.widgets.effects = view:AddCheckboxButton(effects, {
        onChange = function(_, _, changedValue, selected)
            Settings.set(changedValue, selected)
        end,
    })
end

-- Brings one page in step with the logged-in character.
local function refreshPage(page)
    local widgets = page.widgets
    local state = api.getState()
    local tier = state and Packs.tierFor(state) or nil
    widgets.difficulty:SetDisabled(state == nil or tier == nil)

    local note
    if state == nil then
        note = "Log in to change difficulty."
    elseif tier == nil then
        note = "Choose one in the main window first."
    else
        note = "Applies to this character."
    end
    if widgets.note.content ~= note then
        widgets.note.content = note
    end

    local shown = tier and tier.id or nil
    if widgets.difficulty:GetSelectedValue() ~= shown then
        updating = true
        widgets.difficulty:SetSelectedValue(shown)
        updating = false
    end
end

-- Keeps every open page in step. Called every tick.
function SettingsPage.refresh()
    for _, page in pairs(pages) do
        refreshPage(page)
    end
end

-- The settings window ---------------------------------------------------------------------

function SettingsPage.closeWindow()
    destroyPage("window")
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window = nil
end

-- Opens the settings window, if it is not open already.
function SettingsPage.openWindow()
    if window ~= nil or prettyui == nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local content
    window, content = Kit.window(gameWindow, "Settings", WINDOW_WIDTH, WINDOW_HEIGHT + Kit.titleBarHeight(),
        function() SettingsPage.closeWindow() end, 0.3, 0.2)
    local ok, err = pcall(build, "window", content, WINDOW_WIDTH, WINDOW_HEIGHT)
    if not ok then
        log("settings window failed:", err)
        SettingsPage.closeWindow()
        return
    end
    SettingsPage.refresh()
end

-- Opens the settings window, or closes it if it is open (the cog button on Home).
function SettingsPage.toggleWindow()
    if window ~= nil then
        SettingsPage.closeWindow()
    else
        SettingsPage.openWindow()
    end
end

-- The client's settings page ---------------------------------------------------------------

-- Starts listening for the client's settings page to open. `newApi` needs getState and saveNow.
function SettingsPage.init(newApi)
    api = newApi
    if prettyui == nil or Event.SettingsLayerReady == nil then
        log("settings page: not available (needs PrettyUI and the settings layer)")
        return
    end
    Event.SettingsLayerReady.Subscribe(SUBSCRIBER, function(event)
        local parent = event.component
        local ok, err = pcall(build, "client", parent, parent.width, parent.height)
        if not ok then
            log("settings page failed:", err)
            return
        end
        SettingsPage.refresh()
    end)
end

-- Stops listening and removes both copies of the page. Called when the plugin is shut down.
function SettingsPage.shutdown()
    -- Stopping listening must never stop the rest of the shutdown.
    pcall(function() Event.SettingsLayerReady.Unsubscribe(SUBSCRIBER) end)
    SettingsPage.closeWindow()
    destroyPage("client")
end

return SettingsPage
