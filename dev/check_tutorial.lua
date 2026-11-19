-- dev/check_tutorial.lua
-- The in-game tutorial: its steps (core/tutorial.lua) and its panel (ui/tutorial.lua) against a stand-in for the client's ui (see
-- check_settings_ui.lua) and stand-ins for the windows it looks at. It finds a step that does not finish when it should, a pointer
-- that is not over its control, a first-run offer that repeats, and a panel that keeps anything after it closes. It cannot see
-- how anything looks (that is checked in the client).
--
-- Run from the plugin's folder:  lua dev/check_tutorial.lua

package.path = "./?.lua;" .. package.path
function log() end

local created = {}
local PLAIN = { root = true, xyGlobal = true, visibleGlobal = true, hidden = true, content = true, label = true, parent = true,
    spriteID = true, alpha = true, rotationDegrees = true, rgba = true }
local function component(kind)
    local obj = { _kind = kind, _handlers = {}, _destroyed = false }
    created[#created + 1] = obj
    return setmetatable(obj, {
        __index = function(t, k)
            if k == "Subscribe" then
                return function(self, hook, fn) self._handlers[#self._handlers + 1] = fn end
            end
            if k == "Destroy" then
                return function(self) self._destroyed = true end
            end
            if k == "SetPos" then
                return function(self, x, y) self._px, self._py = x, y end
            end
            if PLAIN[k] then return nil end
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

local screen = component("parent")
screen.width, screen.height = 1600, 841
ui = setmetatable({
    Layer = class("Layer"), Rectangle = class("Rectangle"), Text = class("Text"), Button = class("Button"),
    InputField = class("InputField"), ComboField = class("ComboField"), Sprite = class("Sprite"),
    GroupBox = class("GroupBox"),
    Hook = setmetatable({}, { __index = function(_, k) return k end }),
    AlignMode = setmetatable({}, { __index = function(_, k) return k end }),
    Interfaces = { GetComponent = function() return screen end },
}, { __index = function() return anything end })
id = anything
local logicTick = nil
Event = setmetatable({}, { __index = function(_, name)
    return {
        Subscribe = function(_, fn) if name == "Logic" then logicTick = fn end end,
        Unsubscribe = function() if name == "Logic" then logicTick = nil end end,
    }
end })
prettyui = {}                                  -- there, so the window opens; empty, so every widget is a plain one
Vector4 = { new = function(x, y, z, w) return { x = x, y = y, z = z, w = w } end }
Plugin = { resources = { images = {} }, HasPermission = function() return false end }
PluginPermissions = anything
Mouse = { IsAvailable = function() return false end }
local saved = {}
PersistentDB = {
    GetStructuredData = function(_, key) return saved[key] end,
    SetStructuredData = function(_, key, value) saved[key] = value; return true end,
}

-- Stand-ins for the windows the tutorial looks at: what is open, and where their controls are.
local world = { shop = false, reveal = false, collection = false, grid = false, sets = false, screen = "home", anchors = {} }
local function control(x, y, w, h)
    return { xyGlobal = { x = x, y = y }, width = w, height = h }
end
package.loaded["ui/packwindow"] = {
    anchor = function(name) return world.anchors[name] end,
    currentScreen = function() return world.screen end,
}
package.loaded["ui/shopwindow"] = {
    isOpen = function() return world.shop end,
    anchor = function(name) return world.anchors[name] end,
}
package.loaded["ui/revealscreen"] = { active = function() return world.reveal end }
package.loaded["ui/viewer"] = {
    isOpen = function() return world.collection end,
    isGrid = function() return world.collection and world.grid end,
    anchor = function(name) return world.anchors[name] end,
}
package.loaded["ui/setsviewer"] = { isOpen = function() return world.sets end }

local Steps = require("core/tutorial")
local Settings = require("core/settings")
local Tutorial = require("ui/tutorial")

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end

-- ---- the steps -------------------------------------------------------------------------------------------------------------

local none = { shopOpen = false, revealActive = false, collectionOpen = false, gridView = false, setsOpen = false }
local function with(change)
    local obs = {}
    for k, v in pairs(none) do obs[k] = v end
    for k, v in pairs(change) do obs[k] = v end
    return obs
end

check(Steps.count() == 7, "seven steps")
for index = 1, Steps.count() do
    local text = Steps.text(index)
    check(#text > 20 and #text <= 150, "step " .. index .. " has words of a length that fits two lines (" .. #text .. ")")
end
check(Steps.text(99) == "", "no words for a step that does not exist")
check(not Steps.isDone(99, none, {}), "a step that does not exist is not done")
check(Steps.target(1, none) == "shop", "step 1 points at the Shop button")
check(Steps.isDone(1, with({ shopOpen = true }), {}), "step 1 is done when the Shop opens")
check(not Steps.isDone(1, none, {}), "step 1 is not done with nothing open")
check(Steps.target(2, none) == "shop", "step 2 points back at the Shop button when the Shop is closed")
check(Steps.target(2, with({ shopOpen = true })) == "buy", "step 2 points at Buy when the Shop is open")
check(Steps.isDone(2, with({ revealActive = true }), {}), "step 2 is done when a pack is bought")
check(Steps.target(3, none) == nil, "step 3 has no pointer")
local mem = {}
check(not Steps.isDone(3, none, mem), "step 3 is not done before a pack was seen")
check(not Steps.isDone(3, with({ revealActive = true }), mem), "step 3 is not done while the pack is open")
check(Steps.isDone(3, none, mem), "step 3 is done once the pack has closed")
check(not Steps.isDone(3, none, {}), "step 3 is not done if no pack was ever seen")
check(Steps.isDone(4, with({ collectionOpen = true }), {}) and Steps.target(4, none) == "collection", "step 4: the Collection")
check(Steps.target(5, none) == "collection", "step 5 points back at the Collection button when it is closed")
check(Steps.target(5, with({ collectionOpen = true })) == "grid", "step 5 points at the swap button when the Collection is open")
check(not Steps.isDone(5, with({ collectionOpen = true }), {}), "step 5 is not done while the list shows")
check(Steps.isDone(5, with({ collectionOpen = true, gridView = true }), {}), "step 5 is done when the grid shows")
check(Steps.isDone(6, with({ setsOpen = true }), {}) and Steps.target(6, none) == "sets", "step 6: Sets")
check(not Steps.isDone(7, with({ shopOpen = true, revealActive = true, collectionOpen = true, gridView = true, setsOpen = true }), {}),
    "step 7 only ends with Next")
check(Steps.target(7, none) == "settings", "step 7 points at the cog")
check(Steps.text(7):find("%d+ XP") ~= nil, "step 7 says how much XP a credit is")

-- ---- the first-run offer ---------------------------------------------------------------------------------------------------

world.screen = "nosession"
Tutorial.offerFirstRun()
check(not Tutorial.isOpen(), "not offered before the Home screen shows")
world.screen = "home"
world.anchors.shop = control(800, 400, 200, 30)
Tutorial.offerFirstRun()
check(Tutorial.isOpen(), "offered on the Home screen of an install that has not seen it")
local S = Tutorial.debugState()
check(S.text ~= nil and S.text.content == Steps.text(1), "opens at step 1")
check(S.counter ~= nil and S.counter.content == "Step 1 of 7", "the counter says Step 1 of 7")

-- ---- the pointer -----------------------------------------------------------------------------------------------------------

check(S.pointer.hidden == false and S.frame.hidden == false, "the pointer shows over the Shop button")
check(math.abs(S.pointer._px - (800 + 100 - 20.5)) < 0.01, "the pointer is centred over the button")
check(S.pointer._py < 400, "the pointer is above the button")
check(S.pointer.rotationDegrees == 0, "pointing down")
world.anchors.shop = control(800, 20, 200, 30)
logicTick(); logicTick(); logicTick(); logicTick(); logicTick()
check(S.pointer._py > 20, "with no room above, the pointer goes below the button")
check(S.pointer.rotationDegrees == 180, "and points up")
world.anchors.shop = control(800, 400, 200, 30)
logicTick()
check(S.pointer._py < 400, "back above when there is room")
world.anchors.shop = control(1590, 400, 200, 30)
logicTick()
check(S.pointer.hidden == true, "no pointer over a control that is partly off the screen")
world.anchors.shop = nil
logicTick()
check(S.pointer.hidden == true and S.frame.hidden == true, "no pointer when the control is not there")
world.anchors.shop = control(800, 400, 200, 30)

-- ---- walking through by doing the things -----------------------------------------------------------------------------------

local function ticks(n) for _ = 1, n do logicTick() end end
ticks(10)
check(S.step == 1, "still step 1 with nothing done")
world.shop = true
ticks(5)
check(S.step == 2, "opening the Shop moves to step 2")
check(S.counter.content == "Step 2 of 7", "and the counter follows")
world.anchors.buy = control(900, 600, 220, 34)
ticks(1)
check(math.abs(S.pointer._px - (900 + 110 - 20.5)) < 0.01, "step 2 points at Buy")
world.shop = false
world.reveal = true
ticks(5)
check(S.step == 3, "buying (the pack opening) moves to step 3")
ticks(5)
check(S.step == 3, "the pack being open does not finish step 3")
world.reveal = false
ticks(5)
check(S.step == 4, "closing the pack opening moves to step 4")
world.anchors.collection = control(500, 300, 200, 30)
world.collection = true
ticks(5)
check(S.step == 5, "opening the Collection moves to step 5")
world.anchors.grid = control(700, 120, 24, 24)
ticks(1)
check(math.abs(S.pointer._px - (700 + 12 - 20.5)) < 0.01, "step 5 points at the swap button")
ticks(5)
check(S.step == 5, "step 5 waits for the grid")
world.grid = true
ticks(5)
check(S.step == 6, "switching to the grid moves to step 6")
world.sets = true
ticks(5)
check(S.step == 7, "opening Sets moves to step 7")
ticks(30)
check(S.step == 7 and Tutorial.isOpen(), "step 7 waits for Next")

-- ---- by hand ---------------------------------------------------------------------------------------------------------------

Tutorial.step(-1)
check(S.step == 6, "back goes to step 6")
Tutorial.show(2)
check(S.step == 2 and S.counter.content == "Step 2 of 7", "a numbered button jumps to that step")
Tutorial.show(1)
Tutorial.step(-1)
check(S.step == 1, "back from step 1 stays on step 1")
Tutorial.show(7)
Tutorial.step(1)
check(not Tutorial.isOpen(), "Next on the last step closes the tutorial")
check(Settings.get("tutorialSeen") == true, "finishing it records that it has been seen")
check(next(S) == nil, "everything is let go when it closes")
check(logicTick == nil, "it stops listening to the logic tick")
local live = 0
for _, obj in ipairs(created) do
    if (obj._kind == "Layer" or obj._kind == "Sprite" or obj._kind == "GroupBox") and obj._parent ~= nil and not obj._destroyed
        and (obj._kind == "GroupBox" or obj._parent == screen) then
        live = live + 1
    end
end
check(live == 0, "the panel and the pointer layer are destroyed (" .. live .. " left)")

Tutorial.offerFirstRun()
check(not Tutorial.isOpen(), "not offered again once seen")

-- ---- the other doors in ----------------------------------------------------------------------------------------------------

Tutorial.open()
check(Tutorial.isOpen() and Tutorial.debugState().step == 1, "the \"i\" and the ribbon button open it at step 1")
Tutorial.open()
check(Tutorial.isOpen(), "opening it again while it is open is harmless")
local before = #created
Tutorial.open()
check(#created == before, "and builds nothing more")
Tutorial.close(false)
check(not Tutorial.isOpen() and next(Tutorial.debugState()) == nil, "closed without remembering is closed and empty")
Tutorial.close(false)
check(true, "closing twice is harmless")

-- An error in a tick closes it instead of repeating.
Tutorial.open()
world.anchors.shop = { xyGlobal = 5, width = 1, height = 1 }
local tickFn = logicTick
local ok = pcall(function() for _ = 1, 5 do tickFn() end end)      -- (it stops listening once closed, so keep the function)
check(ok, "an error while following a control is caught")
check(not Tutorial.isOpen(), "and closes the tutorial")

if failures == 0 then
    print("tutorial: all checks passed")
else
    print("tutorial: " .. failures .. " FAILED")
    os.exit(1)
end
