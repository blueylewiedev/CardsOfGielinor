-- ui/settingspage.lua
-- The plugin's settings, built with PrettyUI. They let the player change the pack difficulty
-- of the logged-in character and switch the card effects on and off.
--
-- The same page is shown in two places, each kept up to date:
--   "client" : the plugin's page in the client's settings (needs "hasSettingsIcon" in plugin.json)
--   "window" : a window of its own, opened by the Settings button in the main window

local Packs = require("core/packs")
local Logger = require("core/logger")
local PluginId = require("core/pluginid")
local Settings = require("core/settings")
local Storage = require("core/storage")
local Format = require("core/format")
local OverlayLoader = require("core/overlayloader")
local Kit = require("ui/kit")

local SettingsPage = {}

local SUBSCRIBER = "cardcollector_settings"
-- The divider line sits low in its box, so a negative space above pulls it up under the note and
-- the space below keeps the next heading off it. Adjust these to move it.
local DIVIDER_HEIGHT, DIVIDER_ABOVE, DIVIDER_BELOW = 10, -24, 50
local DIVIDER_STEP = DIVIDER_HEIGHT + DIVIDER_ABOVE + DIVIDER_BELOW    -- the height one divider adds
-- Dividers separate the page's parts: difficulty, effects, how the collection is saved, card updates and (with
-- the development tools) the developer options.
-- The "Your collection" part adds a heading, one line of text and a divider. Its text and the card updates text are
-- short, with an info icon beside them that shows the explanation as a tooltip (the tooltip wraps itself, so the
-- rows stay one line). The text is as wide as the page less the margins and the icon.
local SAVED_HEIGHT = 56         -- the heading and the line, a guess like the other heights here
local ICON_WIDTH, MARGINS = 24, 44
local WINDOW_WIDTH, WINDOW_HEIGHT = 320, 445 + 2 * DIVIDER_STEP + SAVED_HEIGHT
local DEV_HEIGHT = 40 + DIVIDER_STEP    -- extra height for the Developer options, when the development tools are there

-- api.getState() and api.saveNow(), as for the pack window; api.keyKind() (how the collection is saved: "tracking",
-- "name" or nil); api.devTools (true when the
-- development tools are there) and api.onSettingChanged(id, on), called after an option changes.
local api = nil
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
    view:AddTitle(PluginId.TITLE)

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
    local function divider()
        view:AddDivider({ height = DIVIDER_HEIGHT, marginTop = DIVIDER_ABOVE, marginBottom = DIVIDER_BELOW })
    end
    divider()

    -- The options, as checkboxes: the effects, then (only with the development tools) theirs.
    local function checkboxes(heading, dev)
        local list = {}
        for _, option in ipairs(Settings.options) do
            if (option.dev == true) == dev and not option.hidden then
                list[#list + 1] = { text = option.label, value = option.id, selected = Settings.get(option.id) }
            end
        end
        view:AddText(heading)
        return view:AddCheckboxButton(list, {
            onChange = function(_, _, changedValue, selected)
                Settings.set(changedValue, selected)
                if api.onSettingChanged ~= nil then
                    api.onSettingChanged(changedValue, selected)
                end
            end,
        })
    end
    page.widgets.effects = checkboxes("General", false)
    divider()
    -- A line of text with an info icon beside it; the icon's tooltip is set by refreshPage.
    local textWidth = math.max(120, width - MARGINS - ICON_WIDTH - 6)
    local function lineWithIcon()
        local text = view:AddText({ text = "", width = textWidth })
        local icon = view:AddSpriteButton("INFO", nil, { inline = true, tooltip = "..." })
        return text, icon
    end
    view:AddText("Your collection")
    page.widgets.saved, page.widgets.savedIcon = lineWithIcon()
    divider()
    view:AddText("Card updates")
    page.widgets.updates, page.widgets.updatesIcon = lineWithIcon()
    if api.devTools then
        divider()
        page.widgets.dev = checkboxes("Developer (hides the dev tools)", true)
    end
end

-- Shows a line and the explanation for its icon's tooltip, changing each only when it is different.
local function showLine(page, name, text, detail)
    local widgets = page.widgets
    if widgets[name].content ~= text then
        widgets[name].content = text
    end
    local icon = widgets[name .. "Icon"]
    if icon ~= nil and page[name .. "Detail"] ~= detail then
        page[name .. "Detail"] = detail
        -- Runs every tick, so a failure is logged once (Logger.error) and never stops the tick.
        local ok, err = pcall(function() icon:SetTooltip(detail) end)
        if not ok then
            Logger.error("settings tooltip failed:", err)
        end
    end
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

    -- How this session's collection is saved is fixed at login; the permission can change after that, and takes
    -- effect at the next login, so the line says so (Format.collectionLine).
    local granted = false
    pcall(function() granted = Plugin.HasPermission(PluginPermissions.trackingAccess) == true end)
    local kind = api.keyKind ~= nil and api.keyKind() or nil
    showLine(page, "saved", Format.collectionLine(kind, granted))
    showLine(page, "updates", OverlayLoader.playerLine())

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
    local height = WINDOW_HEIGHT + (api.devTools and DEV_HEIGHT or 0)
    window, content = Kit.window(gameWindow, "Settings", WINDOW_WIDTH, height + Kit.titleBarHeight(),
        function() SettingsPage.closeWindow() end, 0.3, 0.2)
    local ok, err = pcall(build, "window", content, WINDOW_WIDTH, height)
    if not ok then
        Logger.error("settings window failed:", err)
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
        Logger.error("settings page: not available (needs PrettyUI and the settings layer)")
        return
    end
    Event.SettingsLayerReady.Subscribe(SUBSCRIBER, function(event)
        local parent = event.component
        local ok, err = pcall(build, "client", parent, parent.width, parent.height)
        if not ok then
            Logger.error("settings page failed:", err)
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
