-- dev/check_viewer_ui.lua
-- Runs ui/viewer.lua against a stand-in for the client's ui (components that remember what was set on them and the
-- functions given to Subscribe), and drives it the way a player would: search, each drop-down, picking a row, the
-- grid view, paging, Clear filters, closing and opening again. It finds a crash or a filter that is not wired to the
-- list; it cannot see how anything looks (that is checked in the client).
--
-- Run from the plugin's folder:  lua dev/check_viewer_ui.lua

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
            if k == "hasSelection" then return false end
            if k == "SetEntries" then
                return function(self, byLabel) self._entries = byLabel end
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
    InputField = class("InputField"), ComboField = class("ComboField"), Sprite = class("Sprite"),
    GroupBox = class("GroupBox"), Model = class("Model"),
    Hook = setmetatable({}, { __index = function(_, k) return k end }),
    AlignMode = setmetatable({}, { __index = function(_, k) return k end }),
    Interfaces = { GetComponent = function() return component("parent") end },
    TextContentVisibilityMode = anything, InputFieldFilterMode = anything,
}, { __index = function() return anything end })
id = anything
prettyui = nil
Vector4 = { new = function(x, y, z, w) return { x = x, y = y, z = z, w = w } end }
Plugin = { resources = { images = {} } }
Mouse = { IsAvailable = function() return false end }
Event = { Draw = { Subscribe = function() end } }

local Cards = require("core/cards")
local Browse = require("core/browse")
local Viewer = require("ui/viewer")

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end

-- the size of a card's name steps down with its length (CardView.nameFont); fonts here are stand-in numbers
do
    local CardView = require("ui/cardview")
    local fonts = { { font = 15, perLetter = 7.5 }, { font = 13, perLetter = 6.5 }, { font = 11, perLetter = 5.5 } }
    local function pick(length, width) return (CardView.nameFont(length, width, fonts)) end
    check(pick(10, 165) == 15 and pick(22, 165) == 15, "a short name keeps the normal size (up to 22 letters on a 165 wide title)")
    check(pick(23, 165) == 13 and pick(25, 165) == 13, "a longer name steps down once")
    check(pick(26, 165) == 11 and pick(30, 165) == 11, "and again")
    local font, fits = CardView.nameFont(31, 165, fonts)
    check(font == 11 and fits == false, "a name too long for any size gets the smallest and is reported as not fitting")
    check(select(2, CardView.nameFont(30, 165, fonts)) == true, "30 letters fit at the smallest size")
    check(pick(34, 264) == 15, "a wider title (the big card) keeps the normal size for longer")
    check(pick(26, 165) == 11 and CardView.nameFont(26, 165, { fonts[1], fonts[3] }) == 11, "a size the client lacks is skipped")
end

-- the window's size follows the screen: Viewer.layoutFor
do
    local full = Viewer.layoutFor(nil)
    check(full.listRows == 13 and full.gridRows == 2 and full.detailScale == 2.0,
        "an unknown screen height gets the full-size layout")
    local big = Viewer.layoutFor(5000)
    check(big.height == full.height and big.listRows == 13 and big.gridRows == 2 and big.detailScale == 2.0,
        "a tall screen gets the full-size layout")
    local before = nil
    for height = 500, 1500, 10 do
        local layout = Viewer.layoutFor(height)
        local ok = layout.listRows >= 10 and layout.listRows <= 13 and layout.gridRows >= 1 and layout.gridRows <= 2
            and layout.detailScale >= 1.25 and layout.detailScale <= 2.0 and layout.gridScale >= 1.1
            and layout.bodyH >= layout.listRows * 50 and layout.bodyH >= layout.gridRows * layout.tileH
            and layout.bodyH >= math.floor(224 * layout.detailScale) + 10 + 190
        check(ok, "the layout for a screen " .. height .. " units tall is within its limits")
        if layout.budget >= 10 * 50 and layout.budget >= layout.gridRows * layout.tileH then
            check(layout.bodyH <= layout.budget, "the body for a screen " .. height .. " units tall fits it")
        end
        check(before == nil or layout.height >= before, "a taller screen never gets a shorter window (" .. height .. ")")
        before = layout.height
    end
end

local state = { owned = {}, credits = 0, stats = {}, dirtyBuckets = {} }
for i = 1, 40, 3 do state.owned[Cards.variantKey(Cards.list[i].id, "normal")] = i end
local api = { getState = function() return state end }

Viewer.open(api)
local info = Viewer.debugInfo()
local ownedNow = #Browse.entries(state, { owned = "owned" })
check(info.open and info.filter.owned == "owned" and info.matches == ownedNow and ownedNow > 0,
    "opens listing the cards the player owns (" .. tostring(info.matches) .. ")")


-- (destroying a component destroys what is inside it, as the client does)
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
local combos, inputs = live("ComboField"), live("InputField")
check(#combos == 8 and #inputs == 1, "8 drop-downs and the search box (" .. #combos .. ", " .. #inputs .. ")")

local function choose(combo, label)
    local entryId = combo._entries and combo._entries[label]
    assert(entryId ~= nil, "no entry '" .. label .. "'")
    combo._handlers["ONSELECTIONCHANGED"](combo, entryId)
end
-- creation order: sort, owned, kind, rarity, membership, region, skill, category
local SORT, OWNED, KIND, RARITY, MEMBER, REGION, SKILL, CATEGORY = 1, 2, 3, 4, 5, 6, 7, 8

-- the rest of the checks start from the whole deck
choose(combos[OWNED], "All cards")
info = Viewer.debugInfo()
check(info.matches == #Cards.list, "the owned drop-down can show every card (" .. tostring(info.matches) .. ")")
check(info.pages == math.ceil(#Cards.list / 13), "13 cards a page in the list")

-- search
inputs[1].content = "dragon"
inputs[1]._handlers["ONCONTENTCHANGED"](inputs[1])
info = Viewer.debugInfo()
check(info.matches == Browse.counts(state, { search = "dragon" }).cards and info.matches > 0, "search 'dragon' narrows the list (" .. info.matches .. ")")
check(info.page == 1, "and goes to page 1")

-- a card is picked by clicking a row; the detail shows it
local grips = {}
for _, c in ipairs(live("Layer")) do if rawget(c, "clickthrough") == false then grips[#grips + 1] = c end end
local contentLayer = grips[1]._parent
local rowGrips = 0
for _, g in ipairs(grips) do if g._parent == contentLayer then rowGrips = rowGrips + 1 end end
check(rowGrips == 13, "13 clickable rows (" .. rowGrips .. ")")
grips[2]._handlers["ONCLICK"](grips[2])

-- the chips under the card: clicking one sets that filter, clicking it again clears it, and the picked card stays
local function chipGrips()
    local list = {}
    for _, c in ipairs(live("Layer")) do
        if rawget(c, "clickthrough") == false and c._parent ~= contentLayer then list[#list + 1] = c end
    end
    return list
end
local function clickChip(index)
    local list = chipGrips()
    list[index]._handlers["ONCLICK"](list[index])
end
local function selectedStillListed()
    local d = Viewer.debugInfo()
    for _, entry in ipairs(Browse.entries(state, d.filter)) do
        if entry.card.id == d.selected then return true end
    end
    return false
end
check(#chipGrips() >= 3, "the detail has clickable chips (" .. #chipGrips() .. ")")
local before = Viewer.debugInfo().matches
clickChip(1)    -- the kind (the owned chip is not clickable)
local kindSet = Viewer.debugInfo().filter.kind
check(kindSet == "npc" or kindSet == "item", "the type chip sets the kind filter (" .. tostring(kindSet) .. ")")
check(selectedStillListed(), "the picked card is still listed after a chip filter")
check(Viewer.debugInfo().matches < before, "and the list narrows (" .. before .. " to " .. Viewer.debugInfo().matches .. ")")
clickChip(1)
check(Viewer.debugInfo().filter.kind == nil and Viewer.debugInfo().matches == before, "clicking it again clears the kind")
clickChip(2)    -- membership
check(Viewer.debugInfo().filter.membership ~= nil, "the membership chip sets the membership filter")
clickChip(2)
check(Viewer.debugInfo().filter.membership == nil, "and clears it")
local lastChip = #chipGrips()
clickChip(lastChip)    -- a region, skill or category word
local fs = Viewer.debugInfo().filter
check(fs.region ~= nil or fs.skill ~= nil or fs.category ~= nil, "a tag chip sets its tag's filter")
check(selectedStillListed(), "the picked card is still listed after a tag chip")
local d = Viewer.debugInfo()
check(d.page == (function()
    for i, entry in ipairs(Browse.entries(state, d.filter)) do
        if entry.card.id == d.selected then return (i - 1) // 13 + 1 end
    end
end)(), "the list shows the page the picked card is on")
for _, b in ipairs(live("Button")) do
    if rawget(b, "label") == "Clear filters" then b._handlers["ONBUTTONPRESSED"](b) end
end

-- owned filter, kind, rarity
choose(combos[OWNED], "Owned")
check(Viewer.debugInfo().filter.owned == "owned", "Owned filter set")
choose(combos[OWNED], "All cards")
choose(combos[KIND], "Items")
check(Viewer.debugInfo().filter.kind == "item", "kind set to item")
choose(combos[RARITY], "Rare")
check(Viewer.debugInfo().filter.rarity == "rare", "rarity set")
choose(combos[KIND], "NPCs and items")
check(Viewer.debugInfo().filter.kind == nil, "'any' clears a filter")
choose(combos[REGION], "Asgarnia")
choose(combos[SKILL], "Thieving")
choose(combos[MEMBER], "Free to play")
local f = Viewer.debugInfo().filter
check(f.region == "asgarnia" and f.skill == "thieving" and f.membership == "f2p", "region, skill and membership set")
check(Viewer.debugInfo().matches == #Browse.entries(state, f), "the list matches Browse for the whole filter")
choose(combos[SORT], "Name A to Z")
check(Viewer.debugInfo().filter.sort == "name", "sort set")

-- the category list follows the other filters: only categories that cards matching them have
local function pressClear()
    for _, b in ipairs(live("Button")) do
        if rawget(b, "label") == "Clear filters" then b._handlers["ONBUTTONPRESSED"](b) end
    end
end
-- Clear filters goes back to the start (the owned cards); this then shows every card
local function clearAll()
    pressClear()
    check(Viewer.debugInfo().filter.owned == "owned", "Clear filters goes back to the owned cards")
    choose(combos[OWNED], "All cards")
end
clearAll()
local function countOf(t) local n = 0; for _ in pairs(t or {}) do n = n + 1 end; return n end
local everyCategory = countOf(combos[CATEGORY]._entries)
check(everyCategory > 200, "with no filter the category list has them all (" .. everyCategory .. ")")
choose(combos[REGION], "Asgarnia")
local inAsgarnia = countOf(combos[CATEGORY]._entries)
check(inAsgarnia > 1 and inAsgarnia < everyCategory, "choosing a region narrows the category list (" .. inAsgarnia .. " of " .. everyCategory .. ")")
choose(combos[CATEGORY], "Humanoid")
check(Viewer.debugInfo().filter.category == "humanoid", "a category can be chosen from the narrowed list")
choose(combos[REGION], "Misthalin")
check(combos[CATEGORY]._entries["Humanoid"] ~= nil, "the chosen category stays in the list when the region changes")
choose(combos[CATEGORY], " Any category")
check(Viewer.debugInfo().filter.category == nil, "the any-category entry clears it")
clearAll()
check(countOf(combos[CATEGORY]._entries) == everyCategory, "Clear filters brings the whole category list back")

-- category list follows the kind
choose(combos[KIND], "Items")
local itemCats = combos[CATEGORY]._entries
choose(combos[KIND], "NPCs")
local npcCats = combos[CATEGORY]._entries
local count = function(t) local n = 0; for _ in pairs(t or {}) do n = n + 1 end; return n end
check(count(itemCats) > 1 and count(npcCats) > 1 and count(itemCats) ~= count(npcCats), "the category list changes with the kind (" .. count(itemCats) .. " vs " .. count(npcCats) .. ")")

-- (the grid needs cards to show: clear the filters first)
clearAll()
check(Viewer.debugInfo().matches == #Cards.list, "Clear filters before the grid test")

-- grid view
local toggle = nil
for _, b in ipairs(live("Button")) do if rawget(b, "label") == "List / grid" then toggle = b end end
check(toggle ~= nil, "found the list / grid button")
toggle._handlers["ONBUTTONPRESSED"](toggle)
check(Viewer.debugInfo().grid == true, "grid view on")
-- a click on a card in the grid opens it in the list, picked, on its page
local gridGrips = {}
for _, c in ipairs(live("Layer")) do
    if rawget(c, "clickthrough") == false and rawget(c, "_gridCard") == nil then gridGrips[#gridGrips + 1] = c end
end
check(#gridGrips >= 13 + 8, "the grid adds a click area for each of its 8 cards (" .. #gridGrips .. " in all)")
local lastGrip = gridGrips[#gridGrips]
lastGrip._handlers["ONCLICK"](lastGrip)
local opened = Viewer.debugInfo()
check(opened.grid == false and opened.selected ~= nil, "clicking a card in the grid switches to the list with it picked (" .. tostring(opened.selected) .. ")")
toggle._handlers["ONBUTTONPRESSED"](toggle)
check(Viewer.debugInfo().grid == true, "the button goes back to the grid")
toggle._handlers["ONBUTTONPRESSED"](toggle)
check(Viewer.debugInfo().grid == false, "and to the list again")

-- paging
local function press(label)
    for _, b in ipairs(live("Button")) do
        if rawget(b, "label") == label then b._handlers["ONBUTTONPRESSED"](b); return true end
    end
end
choose(combos[REGION], "Any region"); choose(combos[SKILL], "Any skill"); choose(combos[MEMBER], "Any membership")
choose(combos[KIND], "NPCs and items"); choose(combos[RARITY], "Any rarity")
inputs[1].content = ""; inputs[1]._handlers["ONCONTENTCHANGED"](inputs[1])
check(Viewer.debugInfo().matches == #Cards.list, "all filters cleared one by one: the whole deck")
check(press("Next") and Viewer.debugInfo().page == 2, "Next goes to page 2")
check(press("Prev") and Viewer.debugInfo().page == 1, "Prev goes back")
check(press("Prev") and Viewer.debugInfo().page == Viewer.debugInfo().pages, "Prev from page 1 wraps to the last page")
check(press("Next") and Viewer.debugInfo().page == 1, "Next from the last page wraps to page 1")

-- the mouse wheel turns the pages; it stops at the ends
local function wheel(target, delta)
    target._handlers["ONSCROLLWHEEL"](target, delta)
end
local wheelGrips = {}
for _, c in ipairs(live("Layer")) do if rawget(c, "clickthrough") == false and c._parent == contentLayer then wheelGrips[#wheelGrips + 1] = c end end
check(wheelGrips[1] ~= nil and wheelGrips[1]._handlers["ONSCROLLWHEEL"] ~= nil, "a row listens for the wheel")
check(contentLayer._handlers["ONSCROLLWHEEL"] ~= nil, "so does the window behind the rows")
check(Viewer.debugInfo().page == 1, "(starting from page 1)")
wheel(wheelGrips[1], 1)
check(Viewer.debugInfo().page == 2, "wheel down on a row goes to the next page")
wheel(contentLayer, 1)
check(Viewer.debugInfo().page == 3, "wheel down on the window goes on")
wheel(contentLayer, -1)
wheel(contentLayer, -1)
check(Viewer.debugInfo().page == 1, "wheel up goes back")
wheel(contentLayer, -1)
check(Viewer.debugInfo().page == 1, "and stops at the first page (does not wrap)")
for _ = 1, Viewer.debugInfo().pages + 2 do wheel(contentLayer, 1) end
check(Viewer.debugInfo().page == Viewer.debugInfo().pages, "wheel down stops at the last page")
wheel(contentLayer, 0)
check(Viewer.debugInfo().page == Viewer.debugInfo().pages, "a wheel with no movement does nothing")
while Viewer.debugInfo().page > 1 do wheel(contentLayer, -1) end

-- the viewer follows the collection while it is open
choose(combos[OWNED], "Owned")
local ownedBefore = Viewer.debugInfo().matches
local made = #created
Viewer.refresh()
check(#created == made and Viewer.debugInfo().matches == ownedBefore, "nothing changed: refresh redraws nothing")
local newCard = nil
for _, card in ipairs(Cards.list) do
    if state.owned[Cards.variantKey(card.id, "normal")] == nil then newCard = card break end
end
state.owned[Cards.variantKey(newCard.id, "normal")] = 1
Viewer.refresh()
check(Viewer.debugInfo().matches == ownedBefore + 1, "a card added while the viewer is open appears in the list (" .. ownedBefore .. " to " .. Viewer.debugInfo().matches .. ")")
-- a copy more of the picked card: its detail shows the new count
local selected = Viewer.debugInfo().selected
local selectedId = selected      -- (the picked card's id)
local key = Cards.variantKey(selectedId, "normal")
local function showsCount(n)
    for _, c in ipairs(live("Text")) do if rawget(c, "content") == "Owned: " .. n then return true end end
    return false
end
local copies = state.owned[key]
check(copies ~= nil and showsCount(copies), "the picked card shows how many copies the player has (" .. tostring(copies) .. ")")
state.owned[key] = copies + 5
Viewer.refresh()
check(showsCount(copies + 5) and not showsCount(copies), "and the new count when a pack gives more")
-- cards of a pack that have not been turned over yet are left out until they have
local hiddenNow = {}
api.hiddenCards = function() return hiddenNow end
choose(combos[OWNED], "Owned")
local beforePack = Viewer.debugInfo().matches
local first, second = nil, nil
for _, card in ipairs(Cards.list) do
    local k = Cards.variantKey(card.id, "normal")
    if state.owned[k] == nil then
        if first == nil then first = k elseif second == nil then second = k break end
    end
end
state.owned[first], state.owned[second] = 1, 1      -- a pack of two new cards is opened: both are in the collection at once
hiddenNow = { [first] = 1, [second] = 1 }
Viewer.refresh()
check(Viewer.debugInfo().matches == beforePack, "cards not yet turned over do not appear")
hiddenNow = { [second] = 1 }                          -- the first is turned over
Viewer.refresh()
check(Viewer.debugInfo().matches == beforePack + 1, "a card appears once it has been turned over")
hiddenNow = {}                                        -- the pack is finished
Viewer.refresh()
check(Viewer.debugInfo().matches == beforePack + 2, "and the rest when the pack is done")
-- it stays on the page that was showing
choose(combos[OWNED], "All cards")
press("Next")
local pageNow = Viewer.debugInfo().page
state.owned[Cards.variantKey(Cards.list[200].id, "normal")] = 1
Viewer.refresh()
check(Viewer.debugInfo().page == pageNow, "a refresh stays on the page that was showing")
choose(combos[OWNED], "Owned")
choose(combos[OWNED], "All cards")

-- clear
choose(combos[RARITY], "Epic"); inputs[1].content = "a"; inputs[1]._handlers["ONCONTENTCHANGED"](inputs[1])
press("Clear filters")
local after = Viewer.debugInfo()
check(after.filter.rarity == nil and after.filter.search == nil and after.filter.owned == "owned" and after.matches == #Browse.entries(state, { owned = "owned" }), "Clear filters resets everything to the start")

-- a search nothing matches
inputs[1].content = "zzzzqqq"; inputs[1]._handlers["ONCONTENTCHANGED"](inputs[1])
check(Viewer.debugInfo().matches == 0 and Viewer.debugInfo().pages == 1, "no match: an empty list and one page")

-- filters survive closing
choose(combos[RARITY], "Legendary")
Viewer.close()
check(not Viewer.isOpen(), "closes")
created = {}
Viewer.open(api)
check(Viewer.debugInfo().filter.rarity == "legendary", "the filter is kept while the plugin runs")
Viewer.close()

-- a player with no cards yet starts from all of them (an empty list would look broken)
do
    package.loaded["ui/viewer"] = nil
    local Fresh = require("ui/viewer")
    local noCards = { owned = {}, credits = 0, stats = {}, dirtyBuckets = {} }
    Fresh.open({ getState = function() return noCards end })
    local first = Fresh.debugInfo()
    check(first.filter.owned == "all" and first.matches == #Cards.list, "with no cards the viewer starts from all of them")
    Fresh.close()
end

-- the character logs out while the viewer is open
Viewer.open(api)
check(Viewer.isOpen(), "opens again")
local keepState = state
state = nil
Viewer.refresh()
check(not Viewer.isOpen(), "closes by itself when there is no character any more")
state = keepState

-- logged out
state = nil
Viewer.open(api)
check(not Viewer.isOpen(), "does not open with no character")

-- the swap button in the title bar (needs PrettyUI, so a stand-in for it): made on the window's own parent layer, put
-- over the title bar, registered as an overlay so the window keeps it on top and moves it with the window
do
    local Kit = require("ui/kit")
    local placed, registered, pressed = {}, {}, 0
    local buttonRoot = component("Sprite")
    local made = nil
    prettyui = {
        SpriteButton = { new = function(parent, name, action, options)
            made = { parent = parent, name = name, action = action, options = options, root = buttonRoot,
                Destroy = function(self) self.destroyed = true end }
            buttonRoot.SetPos = function(_, x, y) placed[#placed + 1] = { x, y } end
            return made
        end },
    }
    local gameLayer = component("Layer")
    local window = { parent = gameLayer, root = { x = 100, y = 50, width = 900 },
        _RegisterOverlay = function(_, comp, _, layout) registered[comp] = layout end,
        _UnregisterOverlay = function(_, comp) registered[comp] = nil end }
    local handle = Kit.titleButton(window, "SWAP", function() pressed = pressed + 1 end, "tip")
    check(handle ~= nil, "a title button is made when PrettyUI is there")
    check(made ~= nil and made.parent == gameLayer, "it is made on the window's parent layer, not inside the window (the drag layer would take its clicks)")
    check(made ~= nil and made.name == "SWAP" and made.options.tooltip == "tip", "it is the SWAP sprite, with its tooltip")
    check(placed[1] ~= nil and placed[1][1] == 100 + 900 - 62 and placed[1][2] == 54, "it is placed over the title bar, left of the close button")
    check(registered[buttonRoot] ~= nil, "it is registered with the window as an overlay")
    window.root.x, window.root.y = 300, 200
    registered[buttonRoot]()
    check(placed[#placed][1] == 300 + 900 - 62 and placed[#placed][2] == 204, "and follows the window when it moves")
    made.action()
    check(pressed == 1, "pressing it calls the function")
    handle:Destroy()
    check(made.destroyed == true and registered[buttonRoot] == nil, "destroying it unregisters and removes it")
    check(Kit.titleButton({ root = window.root }, "SWAP", function() end) == nil, "no parent layer: no button, so the caller uses its own")
    prettyui = {}
    check(Kit.titleButton(window, "SWAP", function() end) == nil, "no SpriteButton: no button")
    prettyui = nil
end

-- a short screen: the window opens with fewer list rows and one row of cards in the grid, and pages by those
do
    state = keepState
    Viewer.close()
    local realGet = ui.Interfaces.GetComponent
    ui.Interfaces.GetComponent = function()
        local parent = component("parent")
        parent.width, parent.height = 1366, 560
        return parent
    end
    local opened, err = pcall(Viewer.open, api)
    check(opened, "opening on a short screen does not error: " .. tostring(err))
    local short = Viewer.layoutFor(560)
    check(short.listRows == 10 and short.gridRows == 1, "a 560 unit screen gets 10 list rows and one row of cards")
    local info = Viewer.debugInfo()
    check(info.open, "it opens on a short screen"); check(info.pages == math.max(1, math.ceil(info.matches / 10)),
        "the list pages by the 10 rows it has (" .. tostring(info.pages) .. " pages for " .. tostring(info.matches) .. ")")
    Viewer.refilter()
    Viewer.close()
    ui.Interfaces.GetComponent = realGet
    check(not Viewer.isOpen(), "it closes again")
    state = nil
end

if failures > 0 then os.exit(1) end
print("OK: the viewer's controls drive the list, the grid and the counts")
