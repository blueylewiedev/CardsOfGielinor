-- core/browse.lua
-- What the collection viewer shows: the cards that match a search and filters, in an order, each with the finishes
-- the player has. No drawing and no client calls (tested by dev/check_viewer.lua). A filter is a table, every field
-- optional (nil means "any"): search (every word in the name), owned ("all", "owned", "unowned"), kind, rarity,
-- region, skill, category, membership, finish (only cards the player has in it, shown in it) and sort ("rarity",
-- "rarity_desc", "name", "owned"). An entry is { card, finishes, count, locked, finish }. A word no card has matches
-- nothing.

local Cards = require("core/cards")

local Browse = {}

-- The filter fields that are words of a tag, and the tag each is a word of.
local TAG_FIELDS = { region = "regions", skill = "skills", category = "category", membership = "membership" }

Browse.OWNED = { "all", "owned", "unowned" }
Browse.SORTS = { "rarity", "rarity_desc", "name", "owned" }

-- "kharidian_desert" -> "Kharidian desert": a tag word as the viewer's lists show it.
function Browse.label(word)
    local text = string.gsub(tostring(word), "_", " ")
    return (string.gsub(text, "^%l", string.upper))
end

-- The words of a search, in lower case. An empty search has none.
local function searchTerms(search)
    local terms = {}
    if type(search) == "string" then
        for term in string.gmatch(string.lower(search), "%S+") do
            terms[#terms + 1] = term
        end
    end
    return terms
end

-- True if the card passes every filter except `owned` (which is about variants, not cards).
local function cardMatches(card, filter, terms, tagFilter)
    if filter.kind ~= nil and Cards.kindOf(card) ~= filter.kind then
        return false
    end
    if filter.rarity ~= nil and card.rarity ~= filter.rarity then
        return false
    end
    if next(tagFilter) ~= nil and not Cards.matches(card, tagFilter) then
        return false
    end
    if #terms > 0 then
        local name = string.lower(card.name)
        for _, term in ipairs(terms) do
            if not string.find(name, term, 1, true) then
                return false
            end
        end
    end
    return true
end

-- The filter's tag words as the { tag kind = word } table Cards.matches takes.
local function tagFilterOf(filter)
    local tagFilter = {}
    for field, tagKind in pairs(TAG_FIELDS) do
        if filter[field] ~= nil then
            tagFilter[tagKind] = filter[field]
        end
    end
    return tagFilter
end

-- True if a card the player has `have` (a { finish = count } table, or nil) of is listed under this `owned` mode.
local function hasEntry(have, mode)
    if mode == "owned" then
        return have ~= nil
    elseif mode == "unowned" then
        return have == nil
    end
    return true
end

-- What the player owns, by card: { card id = { finish = count } }. Cards the deck no longer has, and counts that are
-- not more than 0, are left out. (The Sets window reads it too.)
function Browse.ownedByCard(state)
    local owned = {}
    for key, count in pairs(state.owned) do
        local cardId, finish = Cards.parseKey(key)
        if cardId ~= nil and Cards.byId[cardId] ~= nil and type(count) == "number" and count > 0 then
            local list = owned[cardId]
            if list == nil then
                list = {}
                owned[cardId] = list
            end
            list[finish] = count
        end
    end
    return owned
end

-- The finish a card is shown in by default: the rarest the player has (Cards.finishOrder backwards: a holo, then a foil,
-- then a normal one), or normal if they have none. The Sets window shows cards the same way.
Browse.FINISH_PREFERENCE = {}
for index = #Cards.finishOrder, 1, -1 do
    Browse.FINISH_PREFERENCE[#Browse.FINISH_PREFERENCE + 1] = Cards.finishOrder[index]
end

function Browse.preferredFinish(have)
    for _, finish in ipairs(Browse.FINISH_PREFERENCE) do
        if have ~= nil and have[finish] ~= nil then
            return finish
        end
    end
    return "normal"
end

-- What the player has of a card as far as the filter's finish goes: all of `have` with no finish chosen; with one,
-- only that finish (nil if they have none of it). The list and its counts both go by it.
local function haveInFinish(have, finish)
    if finish == nil or have == nil then
        return have
    end
    return have[finish] ~= nil and { [finish] = have[finish] } or nil
end

-- The entries that match `filter` (see the top), for the collection in `state`: one a card.
function Browse.entries(state, filter)
    filter = filter or {}
    local terms, tagFilter = searchTerms(filter.search), tagFilterOf(filter)
    -- (with a finish chosen, "all" lists only the cards the player has in it: a finish is about copies they have)
    local mode = filter.owned or "all"
    if filter.finish ~= nil and mode == "all" then
        mode = "owned"
    end
    local owned = Browse.ownedByCard(state)
    local entries, position = {}, {}
    for _, card in ipairs(Cards.list) do
        local have = owned[card.id]
        local mine = haveInFinish(have, filter.finish)
        if cardMatches(card, filter, terms, tagFilter) and hasEntry(mine, mode) then
            local count = 0
            for _, n in pairs(have or {}) do
                count = count + n
            end
            local entry = { card = card, finishes = have or {}, count = count, locked = have == nil,
                finish = (filter.finish ~= nil and mine ~= nil) and filter.finish or Browse.preferredFinish(have) }
            entries[#entries + 1] = entry
            position[entry] = #entries
        end
    end

    local sort = filter.sort
    if sort == "rarity_desc" then
        table.sort(entries, function(a, b)
            local rankA, rankB = Cards.rarityRank[a.card.rarity] or 0, Cards.rarityRank[b.card.rarity] or 0
            if rankA ~= rankB then
                return rankA > rankB
            end
            return position[a] < position[b]
        end)
    elseif sort == "name" then
        local lower = {}
        for _, entry in ipairs(entries) do
            lower[entry] = string.lower(entry.card.name)
        end
        table.sort(entries, function(a, b)
            if lower[a] ~= lower[b] then
                return lower[a] < lower[b]
            end
            return position[a] < position[b]
        end)
    elseif sort == "owned" then
        table.sort(entries, function(a, b)
            if a.count ~= b.count then
                return a.count > b.count
            end
            return position[a] < position[b]
        end)
    end
    -- (rarity, lowest first, is the order Cards.list is already in, and entries were made in that order)
    return entries
end

-- The words of one tag kind ("category", "region"...) that the cards matching `filter` have, as { word = true }: what a
-- drop-down for that tag can offer so that every word in it finds something. The filter's own choice for that tag is
-- left out of it (or the list would offer nothing but the word already chosen).
function Browse.words(state, filter, tagKind)
    local rest = {}
    for key, value in pairs(filter or {}) do
        rest[key] = value
    end
    for field, kind in pairs(TAG_FIELDS) do
        if kind == tagKind then
            rest[field] = nil
        end
    end
    local terms, tagFilter = searchTerms(rest.search), tagFilterOf(rest)
    local mode = rest.owned or "all"
    local owned = Browse.ownedByCard(state)
    local present = {}
    for _, card in ipairs(Cards.list) do
        if cardMatches(card, rest, terms, tagFilter) and hasEntry(owned[card.id], mode) then
            for _, word in ipairs(card.tags and card.tags[tagKind] or {}) do
                present[word] = true
            end
        end
    end
    return present
end

-- How much of the cards that match `filter` the player has: { cards = how many match, owned = how many of those they
-- have at least one variant of }. The filter's `owned` and `sort` are ignored: it is the progress of the set shown.
function Browse.counts(state, filter)
    filter = filter or {}
    local terms, tagFilter = searchTerms(filter.search), tagFilterOf(filter)
    local owned = Browse.ownedByCard(state)
    local counts = { cards = 0, owned = 0 }
    for _, card in ipairs(Cards.list) do
        if cardMatches(card, filter, terms, tagFilter) then
            counts.cards = counts.cards + 1
            if haveInFinish(owned[card.id], filter.finish) ~= nil then
                counts.owned = counts.owned + 1
            end
        end
    end
    return counts
end

-- How much of the deck the player has, in one pass (for the Stats window): all, kinds, rarities, regions, noRegion
-- and finishes, each { cards, owned } (a card is owned when the player has any variant of it). `hidden` ({ [variant
-- key] = copies }) are copies still unseen in a pack being opened: they do not count, so the numbers do not give the
-- pack away.
function Browse.progress(state, hidden)
    local result = { all = { cards = 0, owned = 0 }, kinds = {}, rarities = {}, regions = {},
        noRegion = { cards = 0, owned = 0 }, finishes = {} }
    for _, finish in ipairs(Cards.specialFinishes) do
        result.finishes[finish] = { cards = #Cards.list, owned = 0 }
    end
    local have = {}                          -- card id = true
    for key, count in pairs(state.owned) do
        local cardId, finish = Cards.parseKey(key)
        if cardId ~= nil and Cards.byId[cardId] ~= nil and count > ((hidden and hidden[key]) or 0) then
            have[cardId] = true
            -- (a key is one card in one finish, so each counts once)
            local bucket = result.finishes[finish]
            if bucket ~= nil then
                bucket.owned = bucket.owned + 1
            end
        end
    end
    local function count(group, name, owned)
        local bucket = group[name]
        if bucket == nil then
            bucket = { cards = 0, owned = 0 }
            group[name] = bucket
        end
        bucket.cards = bucket.cards + 1
        if owned then
            bucket.owned = bucket.owned + 1
        end
    end
    for _, card in ipairs(Cards.list) do
        local owned = have[card.id] == true
        result.all.cards = result.all.cards + 1
        if owned then
            result.all.owned = result.all.owned + 1
        end
        count(result.kinds, Cards.kindOf(card), owned)
        count(result.rarities, card.rarity, owned)
        local regions = card.tags and card.tags.regions or {}
        for _, word in ipairs(regions) do
            count(result.regions, word, owned)
        end
        if #regions == 0 then
            result.noRegion.cards = result.noRegion.cards + 1
            if owned then
                result.noRegion.owned = result.noRegion.owned + 1
            end
        end
    end
    return result
end

return Browse
