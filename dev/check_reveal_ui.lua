-- dev/check_reveal_ui.lua
-- Runs ui/revealscreen.lua against a stand-in for the client's ui (see check_viewer_ui.lua) and plays a reveal the way a
-- player would: tear the pack open, wait for the shuffle and the deal, click a card, "Reveal all", page after page,
-- Done; and Skip part way through. It finds a crash, a stage that never finishes, a leftover click-blocking layer or a
-- card that stays hidden for ever. It cannot see how anything looks (that is checked in the client).
-- It runs twice: with no images in the plugin (everything falls back to plain shapes) and with every image present
-- (card frames, backs, bursts, glows).
--
-- Run from the plugin's folder:  lua dev/check_reveal_ui.lua

package.path = "./?.lua;" .. package.path
-- Only what the reveal itself complains about is shown (the stand-in client knows no NPCs, and images are missing on purpose).
function log(...)
    local first = tostring((...))
    if first:find("reveal", 1, true) or first:find("animation", 1, true) or first:find("frame failed", 1, true) then
        print("LOG", ...)
    end
end

local function component(kind)
    local obj = { _kind = kind, _handlers = {}, _destroyed = false }
    return setmetatable(obj, {
        __index = function(t, k)
            if k == "Subscribe" then
                return function(self, hook, fn) self._handlers[tostring(hook)] = fn end
            end
            if k == "Destroy" then
                return function(self) self._destroyed = true end
            end
            if k == "isMouseOver" then
                return false
            end
            return function() return nil end
        end,
    })
end

local anything
anything = setmetatable({}, {
    __index = function(_, k) return anything end,
    __call = function() return anything end,
    __add = function() return anything end, __sub = function() return anything end,
    __mul = function() return anything end, __div = function() return anything end,
    __idiv = function() return anything end, __concat = function() return "x" end,
    __unm = function() return anything end, __len = function() return 0 end,
    __lt = function() return false end, __le = function() return true end,
    __mod = function() return anything end, __pow = function() return anything end,
})

local roots = {}              -- the full-screen layers made (the ones whose parent is the plugin layer)
local made = {}               -- every component made, to look at the click handlers they were given
local pluginLayer = component("plugin")
pluginLayer.width, pluginLayer.height = 1920, 1080

local function class(kind)
    return { new = function(parent)
        local obj = component(kind)
        obj._parent = parent
        made[#made + 1] = obj
        if parent == pluginLayer then
            roots[#roots + 1] = obj
        end
        return obj
    end }
end

ui = setmetatable({
    Layer = class("Layer"), Rectangle = class("Rectangle"), Text = class("Text"), Button = class("Button"),
    InputField = class("InputField"), ComboField = class("ComboField"), Sprite = class("Sprite"),
    GroupBox = class("GroupBox"), Model = class("Model"), ModelGroup = class("ModelGroup"),
    Hook = setmetatable({}, { __index = function(_, k) return k end }),
    AlignMode = setmetatable({}, { __index = function(_, k) return k end }),
    Interfaces = { GetComponent = function() return pluginLayer end },
    TextContentVisibilityMode = anything, InputFieldFilterMode = anything,
}, { __index = function() return anything end })

local drawHandlers = {}
Event = setmetatable({ Draw = { Subscribe = function(name, fn) drawHandlers[name] = fn end } },
    { __index = function() return { Subscribe = function() end } end })
id = { Sprite = setmetatable({}, { __index = function() return 7 end }), Component = anything,
    NPC = anything, Obj = anything, Font = anything, StyleSheet = anything }
prettyui = nil
Vector4 = { new = function(x, y, z, w) return { x = x, y = y, z = z, w = w } end }
Mouse = { IsAvailable = function() return false end }

local withImages = false
Plugin = { resources = { images = setmetatable({}, { __index = function(_, name)
    if withImages then
        return { Load = function() end }
    end
    return nil
end }) } }

local Cards = require("core/cards")
local Reveal = require("ui/revealscreen")

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end

local function frames(n, dt)
    for _ = 1, n do
        for _, fn in pairs(drawHandlers) do
            fn({ timeDeltaSecs = dt or 0.016 })
        end
    end
end

-- Runs frames until `done()` is true, at most `limit` of them. Returns whether it got there.
local function until_(done, limit)
    for _ = 1, limit or 1500 do
        if done() then
            return true
        end
        frames(1)
    end
    return done()
end

local function makeResults(count)
    local results = {}
    for i = 1, count do
        local card = Cards.list[i * 37]
        results[i] = { card = card, key = Cards.variantKey(card.id, "normal"), finish = "normal", isNewCard = (i % 2 == 1),
            isNewVariant = false, owned = 1 + i % 3, pack = (i - 1) // 5 + 1 }
    end
    return results
end

-- The client keeps an event handler after its component is destroyed (a pack opening grew its memory by gigabytes because the
-- handlers reached the cards' models and the pack's parts through the tables they held). So once a reveal is over, no
-- handler may reach a model, a model group or a sprite other than its own component. This walks everything a handler can
-- reach (its upvalues, and the tables and functions in them) and returns what it finds of those kinds.
local HEAVY = { Model = true, ModelGroup = true, Sprite = true }

local function reachedFrom(handler, own)
    local found, seen, queue, nodes = {}, {}, { handler }, 0
    while #queue > 0 and nodes < 200000 do
        local node = table.remove(queue)
        if type(node) == "function" or type(node) == "table" then
            if not seen[node] then
                seen[node] = true
                nodes = nodes + 1
                if type(node) == "function" then
                    local index = 1
                    while true do
                        local name, value = debug.getupvalue(node, index)
                        if name == nil then break end
                        if name ~= "_ENV" and value ~= nil then
                            queue[#queue + 1] = value
                        end
                        index = index + 1
                    end
                elseif rawget(node, "_kind") ~= nil then
                    if node ~= own and HEAVY[node._kind] then
                        found[#found + 1] = node._kind
                    end
                else
                    for _, value in pairs(node) do
                        if type(value) == "function" or type(value) == "table" then
                            queue[#queue + 1] = value
                        end
                    end
                end
            end
        end
    end
    return found
end

-- Every handler of every component made so far: how many reach something heavy that is not their own component.
local function retainingHandlers()
    local bad = {}
    for _, component in ipairs(made) do
        for hook, handler in pairs(component._handlers) do
            local found = reachedFrom(handler, component)
            if #found > 0 then
                bad[#bad + 1] = string.format("%s %s handler reaches %d (%s...)", component._kind, hook, #found, found[1])
            end
        end
    end
    return bad
end

local function liveRoots()
    local n = 0
    for _, r in ipairs(roots) do
        if not r._destroyed then
            n = n + 1
        end
    end
    return n
end

-- Plays one reveal of `count` cards to the end and checks what it can.
local function play(count, label)
    local before = liveRoots()
    local closed = 0
    local results = makeResults(count)
    check(Reveal.start(results, "standard", { onClose = function() closed = closed + 1 end }), label .. ": starts")
    check(Reveal.active(), label .. ": active after start")
    check(Reveal.start(makeResults(5), "standard", {}) == false, label .. ": a second start is refused")
    local hidden = 0
    for _, n in pairs(Reveal.hiddenCards()) do hidden = hidden + n end
    check(hidden == count, label .. ": every card is hidden at the start (" .. hidden .. " of " .. count .. ")")

    frames(30)
    local R = Reveal.state()
    check(R ~= nil and R.stage == "sealed", label .. ": sealed first, was " .. tostring(R and R.stage))
    check(R.tear ~= nil, label .. ": the standard pack is drawn as a designed pack that tears")
    Reveal.pressMain()
    check(until_(function() return R.stage == "cards" end), label .. ": reaches the cards (stuck at " .. tostring(R.stage) .. ")")
    check(#R.cards == math.min(count, R.pageSize), label .. ": first page has " .. #R.cards .. " cards")

    -- the shape of the first page: rows as even as can be, each centred
    local rowsSeen = {}
    for _, c in ipairs(R.cards) do
        rowsSeen[c.y] = (rowsSeen[c.y] or 0) + 1
    end
    local sizes = {}
    for _, n in pairs(rowsSeen) do sizes[#sizes + 1] = n end
    table.sort(sizes, function(x, y) return x > y end)
    local shape = table.concat(sizes, "+")
    if R.SW == 1920 and count == 7 then check(shape == "4+3", label .. ": 7 cards are 4 + 3, got " .. shape) end
    if R.SW == 1920 and count == 5 then check(shape == "5", label .. ": 5 cards are one row, got " .. shape) end
    if R.SW == 1920 and count >= 10 then check(shape == "5+5", label .. ": a full page is 5 + 5, got " .. shape) end
    print(string.format("  %s: %d cards, pages %d, page size %d, grid %s, card %dx%d", label, count, R.pages, R.pageSize, shape, R.cw, R.ch))

    local pages = 0
    local turned = 0
    while Reveal.active() and pages < 20 do
        pages = pages + 1
        check(until_(function() return R.stage == "cards" end), label .. ": page " .. pages .. " is dealt")
        -- every card is inside the screen
        for _, c in ipairs(R.cards) do
            check(c.x >= 0 and c.y >= 0 and c.x + c.w <= R.SW and c.y + c.h <= R.SH, label .. ": a card is on the screen")
        end
        -- click the first card by hand
        local first = R.cards[1]
        if first.back ~= nil and first.back._handlers.ONCLICK ~= nil then
            first.back._handlers.ONCLICK()
        else
            check(false, label .. ": the first card has a click handler")
        end
        check(until_(function() return first.flipped end), label .. ": the clicked card turns over")
        local seen = 0
        for _, result in ipairs(results) do
            if result.seen then seen = seen + 1 end
        end
        check(seen >= 1, label .. ": a turned card counts as seen")
        -- the rest by Reveal all
        Reveal.pressMain()
        local function allTurned()
            for _, c in ipairs(R.cards) do
                if not c.flipped then return false end
            end
            return true
        end
        check(until_(allTurned), label .. ": Reveal all turns every card on page " .. pages)
        turned = turned + #R.cards
        frames(10)
        Reveal.pressMain()                -- Next page, or Done
        if Reveal.active() then
            check(R.stage == "dealing" or R.stage == "cards", label .. ": the next page starts dealing")
        end
    end
    check(not Reveal.active(), label .. ": closed after the last page")
    check(closed == 1, label .. ": onClose was called once (" .. closed .. ")")
    check(turned == count, label .. ": every card was turned (" .. turned .. " of " .. count .. ")")
    hidden = 0
    for _, n in pairs(Reveal.hiddenCards()) do hidden = hidden + n end
    check(hidden == 0, label .. ": nothing hidden afterwards")
    check(liveRoots() == before, label .. ": the full-screen layer is gone")
    return pages
end

for _, mode in ipairs({ { false, "no images" }, { true, "images" } }) do
    withImages = mode[1]
    local tag = mode[2]
    check(play(5, tag .. " 5 cards") == 1, tag .. ": 5 cards are one page")
    check(play(7, tag .. " 7 cards") == 1, tag .. ": 7 cards are one page")
    check(play(25, tag .. " 25 cards") == 3, tag .. ": 25 cards are three pages")
    local bad = retainingHandlers()
    check(#bad == 0, tag .. ": no click handler left behind reaches a model, model group or sprite of its own reveal (" ..
        #bad .. ", " .. tostring(bad[1]) .. ")")

    -- Skip part way: closes at once, nothing left behind
    local closed = 0
    local before = liveRoots()
    Reveal.start(makeResults(10), "standard", { onClose = function() closed = closed + 1 end })
    frames(20)
    Reveal.pressMain()
    until_(function() return Reveal.state().stage == "dealing" end)
    Reveal.close()
    check(not Reveal.active() and closed == 1 and liveRoots() == before, tag .. ": close while dealing")
    local hidden = 0
    for _, n in pairs(Reveal.hiddenCards()) do hidden = hidden + n end
    check(hidden == 0, tag .. ": nothing is hidden after closing")
    Reveal.close()                       -- harmless when nothing is open

    -- The Skip button: from any stage it ends on the cards, face up, and the screen stays until Done
    for _, when in ipairs({ "sealed", "tearing", "dealing", "cards", "a card turning", "reveal all" }) do
        local label = tag .. " skip from " .. when
        local closed = 0
        local results = makeResults(25)
        Reveal.start(results, "standard", { onClose = function() closed = closed + 1 end })
        frames(20)
        local R = Reveal.state()
        check(R.skip ~= nil, label .. ": there is a Skip button")
        if when ~= "sealed" then
            Reveal.pressMain()
        end
        if when == "tearing" then
            frames(5)
        elseif when == "dealing" then
            until_(function() return R.stage == "dealing" end)
        elseif when == "cards" or when == "a card turning" or when == "reveal all" then
            until_(function() return R.stage == "cards" end)
            if when == "a card turning" then
                R.cards[1].back._handlers.ONCLICK()
                frames(3)
            elseif when == "reveal all" then
                Reveal.pressMain()
                frames(3)
            end
        end
        Reveal.skip()
        check(Reveal.active() and R.stage == "cards", label .. ": the cards are down and the screen is still there (" .. tostring(R.stage) .. ")")
        check(R.skip == nil, label .. ": the Skip button is gone")
        local function allTurned()
            for _, c in ipairs(R.cards) do
                if not c.flipped then return false end
            end
            return #R.cards > 0
        end
        check(until_(allTurned, 80), label .. ": every card of the page is turned over")
        check(R.mainLabel == "Next page", label .. ": the main button says Next page, was " .. tostring(R.mainLabel))
        local shown = 0
        for _, result in ipairs(results) do
            if result.seen then shown = shown + 1 end
        end
        check(shown == #R.cards, label .. ": the page's cards count as seen (" .. shown .. ")")
        for page = 2, 3 do
            Reveal.pressMain()
            check(until_(function() return R.page == page and R.stage == "cards" and allTurned() end, 120),
                label .. ": page " .. page .. " is dealt and turned over by itself")
        end
        check(R.mainLabel == "Done", label .. ": the last page ends with Done, was " .. tostring(R.mainLabel))
        Reveal.pressMain()
        local all = 0
        for _, result in ipairs(results) do
            if result.seen then all = all + 1 end
        end
        check(not Reveal.active() and closed == 1 and all == 25, label .. ": Done closes it with all 25 cards seen (" .. all .. ")")
        Reveal.skip()                    -- harmless when nothing is open
    end
end

-- A small screen: the cards shrink and the pages are smaller
pluginLayer.width, pluginLayer.height = 1280, 720
withImages = true
local pages = play(10, "720p 10 cards")
check(pages >= 1, "720p works")
pluginLayer.width, pluginLayer.height = 800, 600
play(10, "600p 10 cards")

-- Everything above, closes and skips included: no handler left behind reaches a model, a model group or a sprite
local leftBehind = retainingHandlers()
check(#leftBehind == 0, "after every scenario, no click handler left behind reaches a model, model group or sprite (" ..
    #leftBehind .. ", " .. tostring(leftBehind[1]) .. ")")

if failures == 0 then
    print("OK: the reveal plays through on a stand-in client (pack, shuffle, deal, turn, pages, skip)")
else
    print(failures .. " check(s) failed")
    os.exit(1)
end
