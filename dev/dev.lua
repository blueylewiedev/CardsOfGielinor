-- dev/dev.lua
-- Everything that is only for developing the plugin, in one place. main.lua loads this with
-- pcall(require, "dev/dev"). The released plugin does not contain the dev folder, so there the
-- load fails quietly and none of this exists.
--
-- It provides: the card preview window, the NPC browser, the nearby NPC lister, the Output window,
-- the Pack Maker (dev/packmaker.lua), the Wiki Review and Wiki Fetch windows (dev/wikireview.lua,
-- dev/wikifetch.lua), the saved camera
-- tuning for card art, extra buttons on the Home window (+20 credits, reset setup, the tool
-- toggles), and a few debug extras at login and when XP is gained.

local Cards = require("core/cards")
local Storage = require("core/storage")
local CardView = require("ui/cardview")
local Preview = require("dev/preview")
local Builder = require("dev/builder")
local NpcBrowser = require("dev/npcbrowser")
local Nearby = require("dev/nearby")
local NpcSearch = require("dev/npcsearch")
local AnimSearch = require("dev/animsearch")
local TagPicker = require("dev/tagpicker")
local OutputWindow = require("dev/outputwindow")
local ItemProbe = require("dev/itemprobe")
local Tuning = require("dev/tuning")
local PackMaker = require("dev/packmaker")
local WikiReview = require("dev/wikireview")

local Dev = {}

-- Called when a character's collection has just loaded: adds a credit (so you can see saving
-- work across restarts) and a Hans card, and checks the card art names.
function Dev.onLogin(state)
    Storage.addCredits(state, 1)
    local hans = Cards.variantKey("hans", "normal")
    if Storage.countOwned(state, hans) == 0 then
        Storage.addCard(state, hans, 1)
    end
    log("DEV: credits are now", state.credits)
    Cards.checkArtNames()
end

-- Called when XP is gained, to log how it turned into credits.
function Dev.onXp(skill, gain, state, earned, ticksSinceLoad)
    log("skill", skill, "gained", gain, "xp | pool:", state.xpPool, "| credits earned:", earned,
        "| total:", state.credits, "| ticks since load:", ticksSinceLoad)
end

-- The extra buttons for the Home window. `api` is the plugin's api (see main.lua) and
-- `refresh` redraws the Home window.
function Dev.buttons(api, refresh)
    return {
        { label = "+20 Credits", action = function()
            local state = api.getState()
            if state ~= nil then
                Storage.addCredits(state, 20)
                refresh()
            end
        end },
        -- Takes the character back to the first-run difficulty choice, to try that screen.
        { label = "Reset setup", action = function()
            local state = api.getState()
            if state ~= nil then
                Storage.setDifficulty(state, nil)
                api.saveNow()
                refresh()
            end
        end },
        { label = "Preview", action = Preview.toggle },
        { label = "Builder", action = Builder.toggle },
        { label = "Wiki Review", action = WikiReview.toggle },
        { label = "Pack Maker", action = PackMaker.toggle },
        { label = "NPC Viewer", action = NpcBrowser.toggle },
        { label = "Nearby NPCs", action = Nearby.toggle },
        { label = "Item probe", action = ItemProbe.toggle },
        { label = "Output", action = OutputWindow.toggle },
    }
end

-- Reports draft cards in the log, once, when the plugin starts.
function Dev.start()
    if #Cards.drafts > 0 then
        log("cards:", #Cards.drafts, "draft cards are waiting for an npc name (see the deck folder)")
    end
end

-- Switches the tools on or off. Off (the "Preview as released" setting) makes the plugin look and
-- behave as players will have it: the camera settings saved from the preview stop applying to the
-- cards, and the tools' windows close. (main.lua also leaves out the Home buttons and the login
-- and XP extras.)
function Dev.setActive(active)
    Dev.active = active
    Tuning.enabled = active
    CardView.artOverride = active and Tuning.get or nil
    if not active then
        Dev.shutdown()
    end
end

function Dev.shutdown()
    Preview.hide()
    Builder.hide()
    WikiReview.hide()
    PackMaker.hide()
    NpcBrowser.hide()
    Nearby.hide()
    NpcSearch.hide()
    AnimSearch.hide()
    TagPicker.hide()
    ItemProbe.hide()
    OutputWindow.hide()
end

return Dev
