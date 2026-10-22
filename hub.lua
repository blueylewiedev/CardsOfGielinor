-- hub.lua
-- The plugin's page behind its ribbon icon (it needs the "hasRibbonIcon" flag in plugin.json).
-- It appears inside the client's Plugins window and is the way to get the main window back
-- after closing it. It has buttons for the main window, the collection and the statistics.

local Hub = {}

local SUBSCRIBER = "cardcollector_hub"
local BUTTON_WIDTH = 200

local api = nil      -- api.getState(), api.openMain(), api.openCollection(), api.toggleStats()
local view = nil
local widgets = {}

local function destroyView()
    if view ~= nil then
        pcall(function() view:Destroy() end)
    end
    view = nil
    widgets = {}
end

local function build(parent)
    destroyView()
    view = prettyui.SimpleView.new(parent, { width = parent.width, height = parent.height })
    view:AddTitle("Card Collector")
    widgets.credits = view:AddText("")
    -- The same width for all three, so the buttons line up whatever their labels are.
    view:AddFancyButton("Open", function() api.openMain() end, { variant = "positive", width = BUTTON_WIDTH })
    view:AddFancyButton("Collection", function() api.openCollection() end, { width = BUTTON_WIDTH })
    view:AddFancyButton("Statistics", function() api.toggleStats() end, { width = BUTTON_WIDTH })
    Hub.refresh()
end

-- Shows the character's credits. Called every tick.
function Hub.refresh()
    if view == nil or widgets.credits == nil then
        return
    end
    local state = api.getState()
    local text = state and ("Credits: " .. state.credits) or "Log in to a character to play."
    if widgets.credits.content ~= text then
        widgets.credits.content = text
    end
end

function Hub.init(newApi)
    api = newApi
    if prettyui == nil or Event.ContentLayerReady == nil then
        log("ribbon page: not available (needs PrettyUI and the content layer)")
        return
    end
    Event.ContentLayerReady.Subscribe(SUBSCRIBER, function(event)
        local ok, err = pcall(build, event.component)
        if not ok then
            log("ribbon page failed:", err)
        end
    end)
end

function Hub.shutdown()
    -- Stopping listening must never stop the rest of the shutdown.
    pcall(function() Event.ContentLayerReady.Unsubscribe(SUBSCRIBER) end)
    destroyView()
end

return Hub
