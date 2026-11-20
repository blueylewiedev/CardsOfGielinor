-- ui/viewerfilters.lua
-- The filter bar of the collection viewer (ui/viewer.lua): a search box, drop-downs for sort, owned, kind, rarity, membership,
-- region, skill, category and finish, and Clear filters. A choice is kept in V.kept.filter (the fields Browse.entries reads); the
-- drop-downs are in V.open.dropdowns by field, so a chip clicked in the detail panel can move them. Every function takes `V`,
-- the viewer's state (see ui/viewer.lua); a change calls V.refilter().

local Cards = require("core/cards")
local TagWords = require("core/tagwords")
local Browse = require("core/browse")
local Kit = require("ui/kit")
local Theme = require("ui/theme")
local GREY = Theme.GREY
local ViewerLayout = require("ui/viewerlayout")
local FILTER_Y, FILTER_H, columnX = ViewerLayout.FILTER_Y, ViewerLayout.FILTER_H, ViewerLayout.columnX
local COLUMN_W, GAP = ViewerLayout.COLUMN_W, ViewerLayout.GAP

local ViewerFilters = {}

local ANY = "any"                      -- the value of a drop-down's "no filter" entry
ViewerFilters.ANY = ANY

-- The categories are the longest list (over 200), so this drop-down is the plain sorted kind (see Kit.dropdown): the
-- typeable kind is too slow to open. The space in front of "Any category" keeps it at the top.
local ANY_CATEGORY = " Any category"

-- Where the filter starts, and what Clear filters goes back to: the cards the player owns, or all of them while they
-- own none (an empty list on a first visit would look broken).
function ViewerFilters.default(V)
    local api = V.open ~= nil and V.open.api or nil
    local state = api ~= nil and api.getState() or nil
    local owning = state ~= nil and Browse.counts(state, {}).owned > 0
    return { owned = owning and "owned" or "all", sort = "rarity" }
end

-- The word list a tag filter offers, as { label, value } entries: "any" first, then the words by their label.
local function wordEntries(anyLabel, words)
    local list = {}
    for _, word in ipairs(words or {}) do
        list[#list + 1] = { label = Browse.label(word), value = word }
    end
    table.sort(list, function(a, b) return a.label < b.label end)
    table.insert(list, 1, { label = anyLabel, value = ANY })
    return list
end

-- The categories to offer: the ones that cards matching the other filters have (so every one finds something), and the
-- one chosen now, whatever the other filters are, so the box never shows a choice that is not in its list.
local function categoryEntries(V)
    local filter = V.kept.filter
    local state = V.open.api.getState()
    local present = state ~= nil and Browse.words(V.viewState(state), filter, "category") or nil
    local words = {}
    for _, word in ipairs(TagWords.wordsFor(filter.kind, "category") or {}) do
        if present == nil or present[word] or word == filter.category then
            words[#words + 1] = word
        end
    end
    return wordEntries(ANY_CATEGORY, words)
end

-- Puts the category list right for the filters as they are now (not when it is already so: setting a drop-down's list
-- is not free).
function ViewerFilters.updateCategories(V)
    local o, filter = V.open, V.kept.filter
    if o.dropdowns.category == nil then
        return
    end
    local list = categoryEntries(V)
    local values = {}
    for _, entry in ipairs(list) do
        values[#values + 1] = entry.value
    end
    local key = table.concat(values, ",") .. "|" .. tostring(filter.category)
    if key == o.shownCategories then
        return
    end
    o.shownCategories = key
    pcall(function() o.dropdowns.category.set(list, filter.category or ANY) end)
end

-- A category chosen with the kind of card that does not have it is dropped.
local function dropInvalidCategory(V)
    local filter = V.kept.filter
    local valid = false
    for _, word in ipairs(TagWords.wordsFor(filter.kind, "category") or {}) do
        valid = valid or word == filter.category
    end
    if not valid then
        filter.category = nil
    end
end

-- A chip was clicked: its field is set to its value in the filter, or cleared if it already was. The drop-downs follow.
-- (The owned / not collected chip does nothing: it only says what the player has.)
function ViewerFilters.toggle(V, field, value)
    local filter = V.kept.filter
    if filter[field] == value then
        filter[field] = nil
    else
        filter[field] = value
    end
    if field == "kind" then
        dropInvalidCategory(V)
    end
    local dropdown = V.open.dropdowns[field]
    if dropdown ~= nil then
        pcall(function() dropdown.select(filter[field] or ANY) end)
    end
    V.refilter(true)
end

-- A drop-down that sets one field of the filter. `list` is { label, value } entries; "any" clears the field.
-- The width has to fit the longest label (about 9 units a letter, and 45 for the arrow), or the label is cut.
-- `sorted` makes it the plain kind that is sorted by label and cannot be typed in, for a long list.
local function filterDropdown(V, field, x, y, w, list, afterChange, sorted)
    local o = V.open
    local dropdown = Kit.dropdown(o.content, x, y, w, FILTER_H, list, V.kept.filter[field] or ANY, function(value)
        V.kept.filter[field] = (value ~= ANY) and value or nil
        if afterChange ~= nil then
            afterChange()
        end
        V.refilter()
    end, sorted)
    o.dropdowns[field] = dropdown
    return dropdown
end

local function clearFilters(V)
    local o = V.open
    V.kept.filter = ViewerFilters.default(V)
    if o.widgets.search ~= nil then
        pcall(function() o.widgets.search.content = "" end)
    end
    for field, dropdown in pairs(o.dropdowns) do
        pcall(function() dropdown.select(V.kept.filter[field] or ANY) end)
    end
    V.refilter()
end

-- Makes the three rows of filters in the window's content. Made last, so a drop-down's list is drawn over what is made
-- before it.
function ViewerFilters.build(V)
    local o, filter = V.open, V.kept.filter
    local content = o.content
    -- Row 1: the search over the first two columns, then the sort, then Clear filters.
    Kit.text(content, columnX(1), FILTER_Y[1], 56, FILTER_H, "Search", GREY, ui.AlignMode.TOPLEFT)
    o.widgets.search = Kit.inputField(content, columnX(1) + 60, FILTER_Y[1], 2 * COLUMN_W + GAP - 60, FILTER_H, 40, false)
    o.widgets.search.content = filter.search or ""
    o.widgets.search:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        local text = o.widgets.search.content
        V.kept.filter.search = (text ~= nil and text ~= "") and text or nil
        V.refilter()
    end)
    filterDropdown(V, "sort", columnX(3), FILTER_Y[1], COLUMN_W, {
        { label = "Lowest rarity first", value = "rarity" },
        { label = "Highest rarity first", value = "rarity_desc" },
        { label = "Name A to Z", value = "name" },
        { label = "Most owned first", value = "owned" } })
    o.widgets.clear = Kit.buttonAt(content, "Clear filters", columnX(4), FILTER_Y[1], COLUMN_W, FILTER_H,
        function() clearFilters(V) end)

    -- Row 2: who has it, what kind, how rare, free or members.
    filterDropdown(V, "owned", columnX(1), FILTER_Y[2], COLUMN_W, {
        { label = "All cards", value = "all" }, { label = "Owned", value = "owned" },
        { label = "Not owned", value = "unowned" } })
    -- The kind is a filter too, and decides which categories there are to choose from.
    filterDropdown(V, "kind", columnX(2), FILTER_Y[2], COLUMN_W, {
        { label = "NPCs and items", value = ANY }, { label = "NPCs", value = "npc" }, { label = "Items", value = "item" } },
        function() dropInvalidCategory(V) end)    -- (the category list itself is put right by refilter)
    local rarities = { { label = "Any rarity", value = ANY } }
    for _, rarityId in ipairs(Cards.rarityOrder) do
        rarities[#rarities + 1] = { label = Cards.rarities[rarityId].name, value = rarityId }
    end
    filterDropdown(V, "rarity", columnX(3), FILTER_Y[2], COLUMN_W, rarities)
    filterDropdown(V, "membership", columnX(4), FILTER_Y[2], COLUMN_W, {
        { label = "Any membership", value = ANY }, { label = "Free to play", value = "f2p" },
        { label = "Members", value = "p2p" } })

    -- Row 3: where, which skill, what it is.
    filterDropdown(V, "region", columnX(1), FILTER_Y[3], COLUMN_W, wordEntries("Any region", TagWords.words.regions))
    filterDropdown(V, "skill", columnX(2), FILTER_Y[3], COLUMN_W, wordEntries("Any skill", TagWords.words.skills))
    filterDropdown(V, "category", columnX(3), FILTER_Y[3], COLUMN_W, categoryEntries(V), nil, true)
    -- The finish (foil, holo...), in the last place on the row.
    local finishes = { { label = "Any finish", value = ANY } }
    for _, finish in ipairs(Cards.finishOrder) do
        finishes[#finishes + 1] = { label = Cards.finishes[finish].name, value = finish }
    end
    filterDropdown(V, "finish", columnX(4), FILTER_Y[3], COLUMN_W, finishes)
end

return ViewerFilters
