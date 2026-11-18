-- dev/check_stats_ui.lua
-- Runs ui/stats.lua against a stand-in for the client's ui (see check_viewer_ui.lua): opens the window, looks at what its
-- bars and lines say for a collection, switches between the three views, and closes it. It finds a crash or a bar that
-- is not wired to its numbers; it cannot see how anything looks (that is checked in the client).
--
-- Run from the plugin's folder:  lua dev/check_stats_ui.lua

package.path = "./?.lua;" .. package.path
function log() end

local created = {}
local function component(kind)
    local obj = { _kind = kind, _handlers = {}, _destroyed = false }
    created[#created + 1] = obj
    return setmetatable(obj, {
        __index = function(t, k)
            if k == "Subscribe" then
                return function(self, hook, fn) self._handlers[tostring(hook)] = fn end
            end
            if k == "Destroy" then
                return function(self) self._destroyed = true end
            end
            return function() return nil end
        end,
    })
end

local anything
anything = setmetatable({}, {
    __index = function(_, k) return anything end,
    __call = function() return anything end,
    __concat = function() return "x" end,
    __len = function() return 0 end,
})

local function class(kind)
    return { new = function(parent)
        local obj = component(kind)
        obj._parent = parent
        return obj
    end }
end

ui = setmetatable({
    Layer = class("Layer"), Rectangle = class("Rectangle"), Text = class("Text"), Button = class("Button"),
    InputField = class("InputField"), ComboField = class("ComboField"), Sprite = class("Sprite"),
    GroupBox = class("GroupBox"),
    Hook = setmetatable({}, { __index = function(_, k) return k end }),
    AlignMode = setmetatable({}, { __index = function(_, k) return k end }),
    Interfaces = { GetComponent = function() return component("parent") end },
}, { __index = function() return anything end })
Event = setmetatable({}, { __index = function() return { Subscribe = function() end } end })
id = anything
prettyui = nil
Vector4 = { new = function(x, y, z, w) return { x = x, y = y, z = z, w = w } end }
Plugin = { resources = { images = {} } }
Mouse = { IsAvailable = function() return false end }

local Cards = require("core/cards")
local Storage = require("core/storage")
local Rate = require("core/rate")
local Stats = require("ui/stats")

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end

-- every text a window shows, in one list
local function textsOf()
    local out = {}
    for _, obj in ipairs(created) do
        if not obj._destroyed and type(rawget(obj, "content")) == "string" then
            out[#out + 1] = rawget(obj, "content")
        end
    end
    return out
end
local function has(pattern)
    for _, text in ipairs(textsOf()) do
        if string.find(text, pattern) then
            return true
        end
    end
    return false
end

local state = Storage.newState()
local owned = 0
for i, card in ipairs(Cards.list) do
    if i % 4 == 0 then
        state.owned[Cards.variantKey(card.id, "normal")] = 1
        owned = owned + 1
    end
end
state.stats.packsOpened = 12
state.stats.cardsPulled = 60
state.stats.creditsEarned = 123456
local hiddenNow = {}
local api = { getState = function() return state end, hiddenCards = function() return hiddenNow end }

Stats.toggle(api)
check(Stats.isOpen(), "the window opens")
Stats.refresh()
check(has("All cards"), "the Collection tab has its bars")
check(has("%d+ / %d+"), "a bar shows owned / total")
check(has("25%.%d%%") or has("24%.%d%%") or has("26%.%d%%"), "the all-cards bar shows about a quarter")

-- the cache: more cards owned, but no new count until it is due
for i, card in ipairs(Cards.list) do
    if i % 4 == 1 then
        state.owned[Cards.variantKey(card.id, "normal")] = 1
    end
end
Stats.refresh()
local function allCardsText()
    for _, obj in ipairs(created) do
        if not obj._destroyed and type(rawget(obj, "content")) == "string" and string.find(rawget(obj, "content"), "^%d[%d ]* / %d[%d ]*   ") then
            return rawget(obj, "content")
        end
    end
end
local cachedText = allCardsText()
for _ = 1, 12 do Stats.refresh() end
check(allCardsText() ~= cachedText, "the bars are counted again after a few refreshes")

-- hidden cards make it count every refresh (so a pack being opened does not give itself away)
hiddenNow = { [Cards.variantKey(Cards.list[1].id, "normal")] = 1 }
Stats.refresh()
hiddenNow = {}

-- the other views
Stats.setTab(2)
check(has("Misthalin") and has("Kharidian desert"), "the Regions tab has a bar for each region")
check(has("Global %(no region%)"), "the Regions tab has the bar for cards with no region")
Stats.setTab(3)
check(has("Packs opened: 12") and has("Credits earned: 123 456"), "the Packs tab has the numbers")
check(has("PULL RATES") and has("OVERVIEW"), "the Packs tab has its two headings")
check(has("Common: "), "the Packs tab has the pull rates")
Stats.setTab(1)
check(has("All cards"), "back to the Collection tab")

Rate.reset()
Stats.hide()
check(not Stats.isOpen(), "the window closes")
Stats.toggle(api)
check(Stats.isOpen(), "it opens again")
state = nil
Stats.refresh()
check(not Stats.isOpen(), "it closes itself when the character goes")

-- the lines of the last tab are text only and can be checked alone
state = Storage.newState()
state.stats.packsOpened = 3
local function joined(lines)
    local out = {}
    for _, line in ipairs(lines) do out[#out + 1] = line[1] end
    return table.concat(out, " | ")
end
local overview = joined(Stats.overview(state))
check(string.find(overview, "Packs opened: 3", 1, true), "the overview has the packs opened")
check(string.find(overview, "Time played: 0m", 1, true), "the overview has the time played")
check(string.find(overview, "Average credits per hour: -", 1, true), "the average is a dash until there is enough play")
state.stats.playTicks = 100 * 120          -- two hours
state.stats.creditsEarned = 24000
overview = joined(Stats.overview(state))
check(string.find(overview, "Time played: 2h 00m", 1, true), "two hours played, got " .. overview)
check(string.find(overview, "Average credits per hour: 12 000", 1, true), "24000 credits in 2 hours is 12 000 an hour, got " .. overview)
local rates = Stats.pullRates(state)
check(#rates == 6, "a pull rate line per rarity, and one for holos")
check(string.find(rates[6][1], "Holo: ", 1, true) == 1, "the last line is the holo rate (" .. tostring(rates[6][1]) .. ")")
check(rates[1][2] ~= rates[5][2], "the lines are in the rarities' colours")

if failures == 0 then
    print("OK: the Stats window opens, shows its bars and lines, recounts, and closes on a stand-in client")
else
    print(failures .. " check(s) failed")
    os.exit(1)
end
