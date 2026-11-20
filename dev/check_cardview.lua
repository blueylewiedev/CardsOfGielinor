-- dev/check_cardview.lua
-- Runs ui/cardview.lua (with ui/cardart.lua and ui/cardfinish.lua) against a stand-in for the client's ui and builds cards every way the plugin
-- does: an NPC card, an item card, a locked card, a silhouette, a foil, a holo and an animated one that is squashed and uncovered. It finds a
-- call to something that is not there (a name left behind when the code moved between files); it cannot see how anything looks.
--
-- Run from the plugin's folder:  lua dev/check_cardview.lua

package.path = "./?.lua;" .. package.path
function log() end

local anything
anything = setmetatable({}, {
    __index = function() return anything end,
    __call = function() return anything end,
    __add = function() return anything end, __sub = function() return anything end,
    __mul = function() return anything end, __div = function() return anything end,
    __idiv = function() return anything end, __concat = function() return "x" end,
    __unm = function() return anything end, __len = function() return 0 end,
    __lt = function() return false end, __le = function() return true end,
})

local made = 0
local function component()
    made = made + 1
    return setmetatable({ _children = {} }, { __index = function(t, k)
        if k == "Destroy" then return function(self) self._destroyed = true end end
        if k == "AddCamera" then return function() return 1 end end
        return function() return nil end
    end })
end
local function class() return { new = function() return component() end } end

ui = setmetatable({
    Layer = class(), Rectangle = class(), Text = class(), Sprite = class(), Model = class(), ModelGroup = class(), Canvas = class(),
    ModelCamera = { new = function() return component() end },
    ModelType = setmetatable({}, { __index = function(_, k) return k end }),
    ModelCameraTransition = { NONE = 0 },
    AlignMode = setmetatable({}, { __index = function(_, k) return k end }),
}, { __index = function() return anything end })
id = setmetatable({ NPC = setmetatable({}, { __index = function() return 1 end }), Obj = setmetatable({}, { __index = function() return 1 end }) },
    { __index = function() return anything end })
Vector3 = { new = function(x, y, z) return { x = x, y = y, z = z } end }
Vector4 = { new = function(x, y, z, w) return { x = x, y = y, z = z, w = w } end }
Plugin = { resources = { images = setmetatable({}, { __index = function() return { Load = function() end } end }) } }
Event = { Draw = { Subscribe = function() end, Unsubscribe = function() end } }
PersistentDB = { GetStructuredData = function() return nil end, SetStructuredData = function() return true end }

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        print("FAIL: " .. what)
    end
end

local Cards = require("core/cards")
local CardView = require("ui/cardview")
local CardArt = require("ui/cardart")
local CardFinish = require("ui/cardfinish")

local npc, item
for _, card in ipairs(Cards.list) do
    npc = npc or (Cards.kindOf(card) == "npc" and card or nil)
    item = item or (Cards.kindOf(card) == "item" and card or nil)
end
local parent = component()

local function build(card, opts, what)
    local ok, view = pcall(CardView.create, parent, card, opts)
    check(ok and type(view) == "table" and view.card == card and view.root ~= nil, what .. " builds" .. (ok and "" or ": " .. tostring(view)))
    return ok and view or nil
end

build(npc, nil, "an NPC card")
build(item, nil, "an item card")
build(npc, { locked = true }, "a locked card")
build(item, { locked = true, silhouette = true, lockedText = "Packs: Standard" }, "a silhouette")
build(npc, { finish = "foil" }, "a foil")
build(item, { finish = "holo" }, "a holo")
build(npc, { scale = 2 }, "a bigger card")
local animated = build(npc, { animated = true, finish = "foil" }, "an animated card")
if animated ~= nil then
    check(CardView.squash(animated, 0.5) == true, "an animated card squashes")
    check(CardView.uncover(animated, 0) == true and CardView.uncover(animated, math.huge) == true, "and uncovers")
    check(CardView.uncoverOrigin(animated) ~= nil, "and has an origin")
end
local plain = build(npc, nil, "a plain card")
check(plain ~= nil and CardView.squash(plain, 0.5) == false and CardView.uncover(plain, 1) == false, "a card that is not animated cannot be squashed")

-- the parts that moved
local w, h = CardView.sizeAt(CardView.SCALE)
check(w == CardView.WIDTH and h == CardView.HEIGHT, "sizeAt gives the card's size")
check(CardArt.defaultsFor({ kind = "item" }) == CardArt.CAMERA_DEFAULTS.item and CardArt.defaultsFor({ body = true }) == CardArt.CAMERA_DEFAULTS.body
    and CardArt.defaultsFor({}) == CardArt.CAMERA_DEFAULTS.head, "the camera defaults are by kind and body")
check(#CardArt.CAMERA_FIELDS == 7, "the camera has seven fields")
check(select(2, pcall(CardArt.applyPending)) == nil and select(2, pcall(CardArt.clearPending)) == nil, "the pending transforms can be applied and cleared")
check(CardArt.playAnimation(component(), 5) == true, "an animation plays")
check(CardFinish.HOLO.hues ~= nil and CardFinish.SHINE.most > 0, "the finishes' numbers are there")
check(pcall(CardFinish.addHolo, parent, { x = 10, y = 10, w = 100, h = 80 }), "a holo can be added")
check(CardView.nameFont(5, 100) ~= nil, "the title font is chosen")

if failures > 0 then
    os.exit(1)
end
print("OK: cards build every way (NPC, item, locked, silhouette, foil, holo, animated) on a stand-in client")
