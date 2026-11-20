-- dev/check_sets_ui.lua
-- Runs ui/setsviewer.lua against a stand-in for the client's ui (components that remember what was set on them and the
-- functions given to Subscribe), and drives it the way a player would: opening, picking a set, paging, the mouse wheel,
-- a card arriving while it is open, closing and opening again. It finds a crash or a control that is not wired up; it
-- cannot see how anything looks (that is checked in the client).
--
-- Run from the plugin's folder:  lua dev/check_sets_ui.lua

package.path = "./?.lua;" .. package.path
function log() end

local created = {}      -- every component made, in order
local function component(kind)
    local obj = { _kind = kind, _handlers = {}, _children = {} }
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
    __add = function() return anything end, __sub = function() return anything end,
    __mul = function() return anything end, __div = function() return anything end,
    __idiv = function() return anything end, __concat = function() return "x" end,
    __unm = function() return anything end, __len = function() return 0 end,
    __lt = function() return false end, __le = function() return true end,
    __mod = function() return anything end, __pow = function() return anything end,
})

local function class(kind)
    return { new = function(parent)
        local obj = component(kind)
        obj._parent = parent
        created[#created + 1] = obj
        return obj
    end }
end

ui = setmetatable({
    Layer = class("Layer"), Rectangle = class("Rectangle"), Text = class("Text"), Button = class("Button"),
    Sprite = class("Sprite"), Model = class("Model"), ModelGroup = class("ModelGroup"), GroupBox = class("GroupBox"),
    InputField = class("InputField"),
    Hook = setmetatable({}, { __index = function(_, k) return k end }),
    AlignMode = setmetatable({}, { __index = function(_, k) return k end }),
    Interfaces = { GetComponent = function() return component("parent") end },
}, { __index = function() return anything end })
id = anything
prettyui = require("dev/fakeprettyui")   -- (the plugin needs PrettyUI: a stand-in made from the ui above)
Vector4 = { new = function(x, y, z, w) return { x = x, y = y, z = z, w = w } end }
Plugin = { resources = { images = {} } }
Mouse = { IsAvailable = function() return false end }
Event = { Draw = { Subscribe = function() end } }

local Cards = require("core/cards")
local Sets = require("core/sets")
local Packs = require("core/packs")
local CardView = require("ui/cardview")
local SetsViewer = require("ui/setsviewer")

-- What the window is showing, from its state (SetsViewer.state(): `kept` is what the player chose, `open` the window and nil while
-- it is closed): the picked set and page, how many pages it has, the list's place, the cards drawn and the sets listed.
local function infoOf()
    local S = SetsViewer.state()
    local o, kept = S.open, S.kept
    local set = kept.selectedId ~= nil and Sets.byId[kept.selectedId] or nil
    local pages = (set ~= nil and o ~= nil) and math.max(1, math.ceil(#Sets.cardsOf(set) / o.layout.gridPerPage)) or 0
    return { open = o ~= nil, selected = kept.selectedId, page = kept.page, pages = pages, listTop = kept.listTop,
        cards = o ~= nil and #o.gridParts or 0, shown = o ~= nil and #o.shownSets or 0 }
end

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end

local function destroyed(c)
    while c ~= nil do
        if rawget(c, "_destroyed") then return true end
        c = rawget(c, "_parent")
    end
    return false
end
local function live(kind)
    local list = {}
    for _, c in ipairs(created) do if c._kind == kind and not destroyed(c) then list[#list + 1] = c end end
    return list
end
local function button(label)
    for _, b in ipairs(live("Button")) do
        if rawget(b, "label") == label then return b end
    end
end
local function texts()
    local list = {}
    for _, t in ipairs(live("Text")) do list[#list + 1] = tostring(rawget(t, "content")) end
    return table.concat(list, "\n")
end

-- the window's size follows the screen: SetsViewer.layoutFor
do
    local full = SetsViewer.layoutFor(nil)
    check(full.gridRows == 2 and full.scale == CardView.SCALE and full.listRows >= 10,
        "an unknown screen height gets the full-size layout (" .. full.listRows .. " list rows)")
    local big = SetsViewer.layoutFor(5000)
    check(big.height == full.height and big.gridRows == 2 and big.scale == CardView.SCALE,
        "a tall screen gets the full-size layout")
    local before = nil
    for height = 500, 1500, 10 do
        local layout = SetsViewer.layoutFor(height)
        local ok = layout.gridRows >= 1 and layout.gridRows <= 2 and layout.scale >= 1.1 and layout.scale <= CardView.SCALE
            and layout.listRows >= 1 and layout.bodyH == layout.gridRows * layout.tileH
        check(ok, "the layout for a screen " .. height .. " units tall is within its limits")
        if layout.budget >= layout.gridRows * layout.tileH then
            check(layout.bodyH <= layout.budget, "the body for a screen " .. height .. " units tall fits it")
        end
        check(before == nil or layout.height >= before, "a taller screen never gets a shorter window (" .. height .. ")")
        before = layout.height
    end
    check(SetsViewer.layoutFor(768).gridRows == 2 and SetsViewer.layoutFor(768).scale < CardView.SCALE,
        "a 768 unit screen keeps two rows with smaller cards")
    check(SetsViewer.layoutFor(560).gridRows == 1, "a 560 unit screen gets one row of cards")
end

-- the set with the most cards, so paging has something to do
local biggest = Sets.list[1]
for _, set in ipairs(Sets.list) do
    if #Sets.cardsOf(set) > #Sets.cardsOf(biggest) then biggest = set end
end
check(#Sets.cardsOf(biggest) > 6, "a set needs more than one page for this check (" .. biggest.id .. ")")

local ownedCard = Sets.cardsOf(Sets.list[1])[1]
local state = { owned = { [Cards.variantKey(ownedCard.id, "normal")] = 2 }, credits = 0, stats = {}, dirtyBuckets = {} }
local api = { getState = function() return state end }

SetsViewer.open(api)
local info = infoOf()
check(info.open and info.selected == Sets.list[1].id, "opens on the first set (" .. tostring(info.selected) .. ")")
check(string.find(texts(), "1 / " .. #Sets.cardsOf(Sets.list[1]), 1, true) ~= nil, "the first set's tile shows 1 owned")
check(string.find(texts(), "Owned: 2", 1, true) ~= nil, "the owned card's caption shows its copies")
check(string.find(texts(), "Not collected", 1, true) ~= nil, "the others say not collected")

-- the set list: a clickable tile for each set (up to the rows that fit)
local tileGrips = {}
for _, g in ipairs(live("Layer")) do
    if rawget(g, "clickthrough") == false and g._handlers["ONCLICK"] ~= nil then tileGrips[#tileGrips + 1] = g end
end
check(#tileGrips >= #Sets.list or #tileGrips >= 12, "a clickable tile for each set (" .. #tileGrips .. ")")

-- the search box finds a set by its name (the biggest may be further down than the tiles that fit), and picks it
local searchBox = live("InputField")[1]
check(searchBox ~= nil, "there is a search box")
searchBox.content = string.lower(biggest.name)
searchBox._handlers["ONCONTENTCHANGED"](searchBox)
info = infoOf()
check(info.selected == biggest.id and info.page == 1 and info.shown == 1,
    "searching for a set's name lists only it, and shows it from page 1 (" .. tostring(info.shown) .. " listed)")
tileGrips = {}
for _, g in ipairs(live("Layer")) do
    if rawget(g, "clickthrough") == false and g._handlers["ONCLICK"] ~= nil then tileGrips[#tileGrips + 1] = g end
end
tileGrips[1]._handlers["ONCLICK"](tileGrips[1])
check(infoOf().selected == biggest.id, "clicking its tile keeps it")
check(info.pages == math.ceil(#Sets.cardsOf(biggest) / 6), "6 cards a page (" .. info.pages .. " pages)")
check(string.find(texts(), biggest.name, 1, true) ~= nil, "its name is shown")

-- paging: Next, Prev (which wraps round), the wheel
button("Next")._handlers["ONBUTTONPRESSED"](button("Next"))
check(infoOf().page == 2, "Next goes to page 2")
button("Prev")._handlers["ONBUTTONPRESSED"](button("Prev"))
button("Prev")._handlers["ONBUTTONPRESSED"](button("Prev"))
check(infoOf().page == infoOf().pages, "Prev from page 1 wraps to the last")

-- a card arriving while the window is open shows on the next tick
local newCard = Sets.cardsOf(biggest)[1]
state.owned[Cards.variantKey(newCard.id, "normal")] = 1
SetsViewer.refresh()
check(string.find(texts(), "1 / " .. #Sets.cardsOf(biggest), 1, true) ~= nil, "a new card updates the set's count")

-- a card of a pack not turned over yet is left out
api.hiddenCards = function() return { [Cards.variantKey(newCard.id, "normal")] = 1 } end
SetsViewer.refresh()
check(string.find(texts(), "0 / " .. #Sets.cardsOf(biggest), 1, true) ~= nil, "a card not turned over yet is not counted")
api.hiddenCards = nil

-- closing keeps the picked set; opening again comes back to it
SetsViewer.close()
check(not SetsViewer.isOpen() and #live("Text") == 0, "closing removes everything")
SetsViewer.toggle(api)
check(SetsViewer.isOpen() and infoOf().selected == biggest.id, "opening again shows the same set")
SetsViewer.toggle(api)
check(not SetsViewer.isOpen(), "toggle closes it")

-- no character: it does not open
local noState = { getState = function() return nil end }
SetsViewer.open(noState)
check(not SetsViewer.isOpen(), "no character, no window")

-- a short screen: the window opens with one row of cards, pages by the 3 it shows, and closes again
do
    local realGet = ui.Interfaces.GetComponent
    ui.Interfaces.GetComponent = function()
        local parent = component("parent")
        parent.width, parent.height = 1366, 560
        return parent
    end
    local opened, err = pcall(SetsViewer.open, api)
    check(opened, "opening on a short screen does not error: " .. tostring(err))
    local info = infoOf()
    check(info.open and info.selected == biggest.id and info.pages == math.ceil(#Sets.cardsOf(biggest) / 3),
        "it pages by the 3 cards a row holds (" .. tostring(info.pages) .. " pages)")
    SetsViewer.close()
    ui.Interfaces.GetComponent = realGet
    check(not SetsViewer.isOpen(), "it closes again")
end

-- what a card the player does not have says in place of its description: the packs it comes in, in 3 lines at most
do
    local function wrapLines(text, width)       -- a greedy word wrap: how many lines `text` takes at `width` letters a line
        local count, line = 1, ""
        for word in string.gmatch(text, "%S+") do
            if line == "" then
                line = word
            elseif #line + 1 + #word <= width then
                line = line .. " " .. word
            else
                count, line = count + 1, word
            end
        end
        return count
    end
    local LINES, LETTERS = 3, 17                -- the box's 3 lines, and the fewest letters a line has been seen to hold
    local checked, worst, worstLines = 0, "", 0
    local seen = {}
    for _, set in ipairs(Sets.list) do
        for _, card in ipairs(Sets.cardsOf(set)) do
            if not seen[card.id] then
                seen[card.id] = true
                local text = SetsViewer.lockedText(card)
                local lines = wrapLines(text, LETTERS)
                checked = checked + 1
                if lines > worstLines then worst, worstLines = text, lines end
                check(lines <= LINES, "a locked card's pack text fits " .. LINES .. " lines of " .. LETTERS .. " letters: \"" .. text
                    .. "\" (" .. card.id .. ")")
            end
        end
    end
    check(checked > 100, "the pack text of the cards in the sets was checked (" .. checked .. ")")
    local standard = Packs.typeById("standard")
    local sample = Sets.cardsOf(Sets.list[1])[1]
    local text = SetsViewer.lockedText(sample)
    check(string.sub(text, 1, 7) == "Packs: " and not string.find(text, standard.name:gsub(" [Pp]ack$", ""), 1, true),
        "the text starts \"Packs:\" and leaves the Standard pack out (" .. text .. ")")
end

if failures > 0 then os.exit(1) end
print("OK: the sets window's controls pick sets, turn pages and follow the collection")
