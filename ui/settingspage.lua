-- ui/settingspage.lua
-- The plugin's settings: the card effects, how the collection is saved and whether card updates are on. Shown in two places, each
-- kept up to date:
--   "client" the plugin's page in the client's settings (needs "hasSettingsIcon" in
--     plugin.json), one column in PrettyUI's SimpleView
--   "window" a window opened by the cog in the main window's title bar: General on the left, Your collection and
--     Card updates on the right

local Logger = require("core/logger")
local PluginId = require("core/pluginid")
local Settings = require("core/settings")
local Format = require("core/format")
local OverlayLoader = require("core/overlayloader")
local Kit = require("ui/kit")
local Events = require("core/events")
local Theme = require("ui/theme")
local WHITE, GREY = Theme.WHITE, Theme.GREY

local SettingsPage = {}

local SUBSCRIBER = "cardcollector_settings"
-- The divider line sits low in its box, so a negative space above pulls it up under the note and
-- the space below keeps the next heading off it. Adjust these to move it.
local DIVIDER_HEIGHT, DIVIDER_ABOVE, DIVIDER_BELOW = 10, -24, 50
local DIVIDER_STEP = DIVIDER_HEIGHT + DIVIDER_ABOVE + DIVIDER_BELOW    -- the height one divider adds
-- Dividers separate the page's parts. "Your collection" and the card updates each have one line of text with an info
-- icon whose tooltip gives the explanation (the tooltip wraps itself, so the rows stay one line).
local ICON_WIDTH, MARGINS = 24, 44

-- The window: two columns of panels, MARGIN apart and from the edges. A window's content is its width less the frame (8 each side).
local WINDOW_WIDTH = 600
local WINDOW_BORDER = 8
local MARGIN, PAD = 10, 10                 -- round the panels, and inside one
local COLUMN_W = (WINDOW_WIDTH - 2 * WINDOW_BORDER - 3 * MARGIN) // 2
local HEADING_H = Kit.PANEL_HEADING_H + 4  -- a panel's heading and the space under it
local LINE_ROW_H = 24                      -- a line of text with its info icon

-- api.getState() and api.saveNow(), as for the pack window; api.keyKind() (how the collection is saved: "tracking",
-- "name" or nil) and api.onSettingChanged(id, on), called after an option changes.
local api = nil
local pages = {}         -- "client" / "window" -> { view = <PrettyUI view>, widgets = {...} }
local window = nil       -- the settings window's frame, while it is open

-- The options the player can change, as the checkboxes' choices.
local function choices()
    local list = {}
    for _, option in ipairs(Settings.options) do
        if not option.hidden then
            list[#list + 1] = { text = option.label, value = option.id, selected = Settings.get(option.id) }
        end
    end
    return list
end

-- Removes one of the two copies of the page ("client" or "window") from the screen.
local function destroyPage(key)
    local page = pages[key]
    if page ~= nil then
        if page.view ~= nil then
            pcall(function() page.view:Destroy() end)
        end
        pages[key] = nil
    end
end

-- Fills `parent` with the settings and remembers it under `key`.
local function build(key, parent, width, height)
    destroyPage(key)
    local view = prettyui.SimpleView.new(parent, { width = width, height = height, categoryID = "auto" })
    local page = { view = view, widgets = {} }
    pages[key] = page
    view:AddTitle(PluginId.TITLE)

    -- PrettyUI's divider is 60 units tall by default; `height` shrinks it if it is supported.
    local function divider()
        view:AddDivider({ height = DIVIDER_HEIGHT, marginTop = DIVIDER_ABOVE, marginBottom = DIVIDER_BELOW })
    end

    -- The options, as checkboxes.
    view:AddText("General")
    page.widgets.effects = view:AddCheckboxButton(choices(), {
        onChange = function(_, _, changedValue, selected)
            Settings.set(changedValue, selected)
            if api.onSettingChanged ~= nil then
                api.onSettingChanged(changedValue, selected)
            end
        end,
    })
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
    -- How this session's collection is saved is fixed at login; the permission can change after that, and takes
    -- effect at the next login, so the line says so (Format.collectionLine).
    local granted = false
    pcall(function() granted = Plugin.HasPermission(PluginPermissions.trackingAccess) == true end)
    local kind = api.keyKind ~= nil and api.keyKind() or nil
    showLine(page, "saved", Format.collectionLine(kind, granted))
    showLine(page, "updates", OverlayLoader.playerLine())
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


-- The heights of the panels (a heading, then the rows, then PAD).
local function checkboxPanelHeight(rows, extra)
    return HEADING_H + rows * Kit.CHECKBOX_ROW_H + (extra or 0) + PAD
end
local LINE_PANEL_MIN_H = HEADING_H + LINE_ROW_H + PAD
-- General is as tall as Your collection and Card updates together, so the two columns end level; its rows are spaced out to
-- fill it. With more options than that has room for it is taller, and the two panels on the right grow to match.
local function generalHeight()
    return math.max(2 * LINE_PANEL_MIN_H + MARGIN, checkboxPanelHeight(#choices()))
end
local function linePanelHeight()
    return (generalHeight() - MARGIN) // 2
end

-- How tall the window's content is: the column's height, with the margin round it.
local function windowHeight()
    return generalHeight() + 2 * MARGIN
end

-- A line of text with an info icon at its right, inside a panel at (x, y): returns the text and the icon.
local function lineWithIcon(content, x, y, w)
    local text = Kit.text(content, x + PAD, y, w - 2 * PAD - ICON_WIDTH - 6, LINE_ROW_H, "", WHITE, ui.AlignMode.TOPLEFT)
    local icon = Kit.iconButton(content, "INFO", x + w - PAD - ICON_WIDTH, y, function() end, "...")
    return text, icon
end

-- Fills the settings window's content with its panels. `page` is what refreshPage keeps up to date.
local function buildWindow(content)
    local page = { widgets = {} }
    pages.window = page
    local x1, x2 = MARGIN, MARGIN + COLUMN_W + MARGIN
    local inner = COLUMN_W - 2 * PAD

    -- Left: the options as checkboxes, spaced evenly down a panel as tall as the two on the right together.
    local options = choices()
    local height = generalHeight()
    local step = nil
    if #options > 1 then
        step = (height - HEADING_H - PAD - Kit.CHECKBOX_ROW_H) // (#options - 1)
    end
    Kit.panel(content, x1, MARGIN, COLUMN_W, height, "GENERAL")
    page.widgets.effects = Kit.checkboxes(content, x1 + PAD, MARGIN + HEADING_H, inner, options, function(value, selected)
        Settings.set(value, selected)
        if api.onSettingChanged ~= nil then
            api.onSettingChanged(value, selected)
        end
    end, height ~= checkboxPanelHeight(#options) and step or nil)

    -- Right: how the collection is saved, and the card updates. Each line has an icon with the explanation as its tooltip.
    local linePanelH = linePanelHeight()
    Kit.panel(content, x2, MARGIN, COLUMN_W, linePanelH, "YOUR COLLECTION")
    page.widgets.saved, page.widgets.savedIcon = lineWithIcon(content, x2, MARGIN + HEADING_H, COLUMN_W)
    local y = MARGIN + linePanelH + MARGIN
    Kit.panel(content, x2, y, COLUMN_W, linePanelH, "CARD UPDATES")
    page.widgets.updates, page.widgets.updatesIcon = lineWithIcon(content, x2, y + HEADING_H, COLUMN_W)
end

-- Opens the settings window, if it is not open already.
function SettingsPage.openWindow()
    if window ~= nil then
        return
    end
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    local content
    local height = windowHeight()
    window, content = Kit.window(gameWindow, "Settings", WINDOW_WIDTH, height + Kit.titleBarHeight(),
        function() SettingsPage.closeWindow() end, 0.3, 0.2)
    local ok, err = pcall(buildWindow, content)
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
    if Event.SettingsLayerReady == nil then
        Logger.error("settings page: not available (the client has no settings layer)")
        return
    end
    Events.on("SettingsLayerReady", SUBSCRIBER, function(event)
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
    pcall(function() Events.off("SettingsLayerReady", SUBSCRIBER) end)
    SettingsPage.closeWindow()
    destroyPage("client")
end

return SettingsPage
