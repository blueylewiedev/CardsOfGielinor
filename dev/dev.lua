-- dev/dev.lua
-- Everything that is only for developing the plugin, in one place. main.lua loads this first with pcall(require, "dev/dev") and calls
-- Dev.start(api) when it has finished; the released plugin does not contain the dev folder, so there the load fails quietly and none
-- of this exists. The plugin has no other hook for it: what the tools change in the plugin they change by wrapping its functions
-- (dev/devcopy.lua, dev/artoverride.lua, dev/quiet.lua, dev/perfprobe.lua) or by subscribing to events themselves.
--
-- It provides the card preview, the NPC browser, the nearby NPC lister, the labels over NPCs that have no card (dev/uncarded.lua), the
-- Output window, the Pack Maker, the Wiki Review and Wiki Fetch windows, the saved camera tuning for card art, the Dev tools window
-- (dev/devtools.lua: the tool buttons and save tools, always on screen), and a few debug extras
-- at login and when XP is gained.

-- First, so its frame timing starts before the deck loads (dev/perfprobe.lua).
local Probe = require("dev/perfprobe")
local memLoaded, MemProbe = pcall(require, "dev/memprobe")          -- (loaded first by perfprobe; its buttons are below)
local Quiet = require("dev/quiet")
local PointerProbe = require("dev/pointerprobe")
local LeakLab = require("dev/leaklab")
local Cards = require("core/cards")
local Storage = require("core/storage")
local Events = require("core/events")
local PackWindow = require("ui/packwindow")
local PluginId = require("core/pluginid")
local CardView = require("ui/cardview")
local Preview = require("dev/preview")
local Builder = require("dev/builder")
local NpcBrowser = require("dev/npcbrowser")
local Nearby = require("dev/nearby")
local Uncarded = require("dev/uncarded")
local NpcSearch = require("dev/npcsearch")
local AnimSearch = require("dev/animsearch")
local TagPicker = require("dev/tagpicker")
local OutputWindow = require("dev/outputwindow")
local ItemProbe = require("dev/itemprobe")
local Tuning = require("dev/tuning")
local PackMaker = require("dev/packmaker")
local WikiReview = require("dev/wikireview")
local DevTools = require("dev/devtools")
local OverlayLoader = require("core/overlayloader")
local Overlay = require("core/overlay")
local ArtCheck = require("dev/artcheck")
local DevSaves = require("dev/devsaves")
local Grants = require("dev/grants")
local DevCopy = require("dev/devcopy")
local ArtOverride = require("dev/artoverride")
local SaveProbe = require("dev/saveprobe")

local Dev = {}

-- What to do when a character's collection has just loaded: adds a credit (so you can see saving work across restarts) and a Hans
-- card, and checks the card art names and the save keys.
local function onLogin(api, state)
    Probe.sessionLoaded()
    Storage.addCredits(state, 1)
    local hans = Cards.variantKey("hans", "normal")
    if Storage.countOwned(state, hans) == 0 then
        Storage.addCard(state, hans, 1)
    end
    log("DEV: credits are now", state.credits)
    ArtCheck.run()
    SaveProbe.run()
    api.saveNow()
end

-- Calls onLogin when a collection has loaded (the plugin has no hook for it: api.getState() is nil until then).
local function watchLogin(api)
    local watched = nil
    Events.on("ServerLogic", "cardcollector_dev_login", function()
        local state = api.getState()
        if state ~= watched then
            watched = state
            if state ~= nil then
                onLogin(api, state)
            end
        end
    end)
end

-- Logs each XP gain and what it did to the credits (the lines are dropped while the console is quiet).
local function watchXp(api)
    Events.on("SkillTransmit", "cardcollector_dev_xp", function(e)
        local state = api.getState()
        if state == nil or Quiet.on or type(e.oldXP) ~= "number" or type(e.newXP) ~= "number" then
            return
        end
        log("DEV: skill", e.skill, "xp", e.oldXP, "->", e.newXP, "| pool:", state.xpPool, "| credits:", state.credits)
    end)
end

-- "Delete saves" asks twice: the first click arms it for about ten seconds, the second does it.
local resetArmedUntil = 0
local logicTicks = 0
Events.on("Logic", "cardcollector_dev_reset", function()
    logicTicks = logicTicks + 1
end)

local function deleteSaves(api, refresh)
    if logicTicks > resetArmedUntil then
        resetArmedUntil = logicTicks + 500       -- 50 ticks a second
        log("DEV: click Delete saves again within 10 seconds to delete EVERY collection of this dev copy")
        return
    end
    resetArmedUntil = 0
    local deleted, why = DevSaves.deleteAllCollections()
    if deleted == nil then
        log("DEV: saves NOT deleted:", why)
        return
    end
    -- The collection in memory is made a new one, in place (what Storage.load makes for a character with nothing saved).
    -- Left alone it would be saved again the next minute: the play time marks it changed, and the autosave or the save on
    -- logout then writes the old collection back (the credits came back after "Delete saves", 2026-11-18).
    local state = api.getState()
    if state ~= nil then
        local fresh = Storage.newState()
        fresh.credits = Storage.starterCredits()
        fresh.dirty = true
        for key in pairs(state) do
            state[key] = nil
        end
        for key, value in pairs(fresh) do
            state[key] = value
        end
    end
    log("DEV:", deleted, "save keys deleted; the collection in memory is a new one with", Storage.starterCredits(), "credits")
    refresh()
end

-- Puts one normal copy of every card in the collection and saves it, to try a full-size save. The
-- log says how many cards there are in all and how full the buckets are; log out and in again and the
-- "loaded collection" line should show the same count. "Delete saves (twice)" clears it afterwards.
local function giveEveryCard(api, refresh)
    local state = api.getState()
    if state == nil then
        log("DEV: log in to a character first")
        return
    end
    local added = 0
    for _, card in ipairs(Cards.list) do
        local variant = Cards.variantKey(card.id, "normal")
        if Storage.countOwned(state, variant) == 0 then
            Storage.addCard(state, variant, 1)
            added = added + 1
        end
    end
    local sizes = {}
    for variant in pairs(state.owned) do
        local bucket = Storage.bucketOf(variant)
        sizes[bucket] = (sizes[bucket] or 0) + 1
    end
    local least, most = math.huge, 0
    for bucket = 1, Storage.BUCKETS do
        least, most = math.min(least, sizes[bucket] or 0), math.max(most, sizes[bucket] or 0)
    end
    api.saveNow()
    log("DEV: gave", added, "cards;", Storage.countVariantsOwned(state), "variants owned of", #Cards.list,
        "cards | buckets hold", least, "to", most, "entries | unsaved:", tostring(state.dirty))
    refresh()
end

-- The tools and debug actions, as the buttons of the Dev tools window. `api` is the plugin's api (see
-- main.lua) and `refresh` redraws the main window.
local function toolButtons(api, refresh)
    return {
        { label = "+10k Credits", action = function()
            local state = api.getState()
            if state ~= nil then
                Storage.addCredits(state, 10000)
                refresh()
            end
        end },
        { label = "Fill deck", action = function() giveEveryCard(api, refresh) end,
            tooltip = "Gives one copy of every card and saves, to try a full-size collection" },
        { label = "Preview", action = Preview.toggle },
        { label = "Builder", action = Builder.toggle },
        { label = "Anim check", action = Builder.checkAnims },
        { label = "Wiki Review", action = WikiReview.toggle },
        { label = "Pack Maker", action = PackMaker.toggle },
        { label = "Save probe", action = SaveProbe.run,
            tooltip = "Vetting V2: logs whether CheckExists agrees with GetStructuredData for this character's save keys" },
        { label = "Pointer probe", action = PointerProbe.toggle,
            tooltip = "Temporary (tutorial): a test window with a gold pointer from the game's own sprites over one of its buttons; drag the window and press Next target, then press Output" },
        { label = "NPC Viewer", action = NpcBrowser.toggle },
        { label = "Nearby NPCs", action = Nearby.toggle },
        { label = "Uncarded", action = Uncarded.toggle },
        { label = "Item probe", action = ItemProbe.toggle },
        { label = "Output", action = function()
            if memLoaded and MemProbe.flush ~= nil then MemProbe.flush(true) end         -- (MEM and LAB lines said while loading)
            OutputWindow.toggle()
        end },
        { label = "Perf probe", action = Probe.manual,
            tooltip = "Logs the frame times over the next 10 seconds (PROBE line): scroll the collection or open a pack meanwhile" },
        { label = "Quiet console", action = Quiet.toggle,
            tooltip = "Flips the dev copy's console between quiet (only failures and what the dev buttons say) and chatty (every routine line). On by default; takes effect at once" },
        { label = "Mem auto", action = function()
            if memLoaded and MemProbe.toggle ~= nil then MemProbe.toggle("auto") else log("MEM: the memory probe did not load") end
        end, tooltip = "Memory probe switch: a full Lua garbage collection every 2 seconds while a pack opening is on screen, and one after it closes. Off by default; works at once. For testing whether collecting stops the client's memory growing" },
        { label = "Mem collect", action = function()
            if memLoaded and MemProbe.collect ~= nil then MemProbe.collect() else log("MEM: the memory probe did not load") end
        end, tooltip = "Memory probe: one full Lua garbage collection now, and says how much the Lua heap fell. Watch memwatch afterwards: does the client's memory fall too?" },
        { label = "Mem baseline", action = function()
            if memLoaded and MemProbe.baseline ~= nil then MemProbe.baseline() else log("MEM: the memory probe did not load") end
        end, tooltip = "Memory probe: takes the baseline for the MEM lines. Close every plugin window first. See notes in dev/memprobe.lua" },
        { label = "Mem snapshot", action = function()
            if memLoaded and MemProbe.snapshot ~= nil then MemProbe.snapshot("manual") else log("MEM: the memory probe did not load") end
        end, tooltip = "Memory probe: logs the Lua heap and the live components now, and what changed since the baseline (also done by itself after each pack opening closes)" },
        { label = "Mem count", action = function()
            if memLoaded and MemProbe.toggle ~= nil then MemProbe.toggle("count") else log("MEM: the memory probe did not load") end
        end, tooltip = "Memory probe switch: counts every component the plugin makes (wraps the client's constructors). Off by default. Takes effect at the next prl" },
        { label = "Mem GC", action = function()
            if memLoaded and MemProbe.toggle ~= nil then MemProbe.toggle("gc") else log("MEM: the memory probe did not load") end
        end, tooltip = "Memory probe switch: a snapshot forces a full garbage collection first. Off by default (it touches the client more). Takes effect at the next prl" },
        { label = "Lab mode", action = LeakLab.mode,
            tooltip = "Leak lab (dev/leaklab.lua): cycles the experiment and logs what it makes and how it frees it. Use with dev/memwatch.ps1" },
        { label = "Lab make", action = LeakLab.make, tooltip = "Leak lab: makes 20 cards the selected way, on screen. Press m in memwatch now" },
        { label = "Lab free", action = LeakLab.free, tooltip = "Leak lab: frees them the selected way. Wait a few seconds, then press m in memwatch" },
        { label = "Fetch updates", action = function()
            local phase = OverlayLoader.status().phase
            if phase == "done" or phase == "ignored" or phase == "failed" or phase == "off" then
                OverlayLoader.restart()
                log("DEV: fetching the card overlay again")
            else
                local status = OverlayLoader.status()
                log("DEV: card updates are", status.phase, "-", status.message, "(attempt", status.attempt .. ")")
            end
        end, tooltip = "Fetches and applies the card overlay again; if one is under way, says what it is doing" },
        { label = "Local overlay", action = function()
            local found, module = pcall(require, "dev/local_overlay")
            if not found or type(module) ~= "table" or type(module.text) ~= "string" then
                log("DEV: no dev/local_overlay.lua: run  python dev/build_overlay.py --local  then reload the plugin (prl)")
                return
            end
            -- (applied all at once, here, not through the loader: it is small, and only for trying a change)
            local job, why = Overlay.begin(module.text)
            if job == nil then
                log("DEV: the local overlay was not applied:", why)
                return
            end
            while not Overlay.step(job, 100) do end
            log("DEV: applied the overlay in dev/local_overlay.lua (not fetched):", Overlay.summary(job))
        end, tooltip = "Applies dev/local_overlay.lua as if it had been fetched (python dev/build_overlay.py --local writes it from docs/tuning.json and the deck). After rebuilding it, reload the plugin (prl)" },
        { label = "Delete saves", action = function() deleteSaves(api, refresh) end, style = "negative",
            tooltip = "Deletes every collection of this dev copy. Click twice within 10 seconds" },
    }
end

-- Finishes the plugin's start-up (main.lua calls it last, with what the plugin's windows need) and attaches the tools to it.
function Dev.start(api)
    -- the dev copy stops on an unsound card: a problem is to be fixed before release, not carried
    if #Cards.loadProblems > 0 then
        error("The deck has " .. #Cards.loadProblems .. " problem(s), the first: " .. Cards.loadProblems[1], 0)
    end
    Grants.grant()
    DevCopy.install()
    ArtOverride.install()
    Quiet.install()
    Probe.start()
    DevTools.setButtons(toolButtons(api, PackWindow.refresh))
    watchLogin(api)
    watchXp(api)
    Uncarded.start()
    DevTools.show()
    -- the plugin's own shutdown is wrapped, so it does not know about the tools
    local pluginShutdown = PluginShutdown
    function PluginShutdown()
        Dev.shutdown()
        pluginShutdown()
    end
    if Quiet.on then
        log("DEV: the quiet console is ON: routine lines, PROBE marks and XP lines are not written (Dev tools > Quiet console turns them back on)")
    end
    if #Cards.drafts > 0 then
        log("cards:", #Cards.drafts, "draft cards are waiting for an npc name (see the deck folder)")
    end
    Probe.mark("main.lua finished")
    log("DEV: " .. PluginId.TITLE .. " development copy started")
end

-- The plugin is shutting down: closes every tool window.
function Dev.shutdown()
    DevTools.hide()
    Preview.hide()
    Builder.hide()
    WikiReview.hide()
    PackMaker.hide()
    NpcBrowser.hide()
    Nearby.hide()
    Uncarded.hide()
    Uncarded.stop()
    NpcSearch.hide()
    AnimSearch.hide()
    TagPicker.hide()
    ItemProbe.hide()
    OutputWindow.hide()
    Probe.shutdown()
end

return Dev
