-- core/browse.lua
-- What the collection viewer shows: the cards (and each variant of them) that match a search and some filters, in
-- an order. No drawing and no client calls, so it is tested on its own against the real deck (dev/check_viewer.lua).
--
-- A filter is a table, every field optional (a missing one, or nil, means "any"):
--   search     text: every word of it must be in the card's name, whatever the case ("abyssal dem" finds Abyssal demon)
--   owned      "all" (the default), "owned" (the variants the player has) or "unowned" (the ones they have not)
--   kind       "npc" or "item"
--   rarity     a rarity id, such as "rare"
--   region     a word of the regions tag, such as "asgarnia"
--   skill      a word of the skills tag, such as "thieving"
--   category   a word of the category tag, such as "food"
--   membership "f2p" or "p2p"
--   sort       "rarity" (lowest first, the default), "rarity_desc", "name" or "owned" (most copies first)
--
-- An entry is { card, finish, count, locked }, the same as the viewer has always used: locked is a variant the
-- player does not have (count 0). Anything a filter names that no card has (a mistyped word) simply matches nothing.

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

-- What the player owns, by card: { card id = { finish = count } }. Cards the deck no longer has are left out.
local function ownedByCard(state)
    local owned = {}
    for key, count in pairs(state.owned) do
        local cardId, finish = Cards.parseKey(key)
        if cardId ~= nil and Cards.byId[cardId] ~= nil then
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

-- The order variants of one card are listed in: normal first, then by finish name.
local FINISH_ORDER = { normal = 1 }
local function finishesOf(owned, includeUnowned)
    local finishes = {}
    for finish in pairs(owned or {}) do
        finishes[#finishes + 1] = finish
    end
    if includeUnowned then
        for finish in pairs(Cards.finishes) do
            if owned == nil or owned[finish] == nil then
                finishes[#finishes + 1] = finish
            end
        end
    end
    table.sort(finishes, function(a, b)
        local orderA, orderB = FINISH_ORDER[a] or 99, FINISH_ORDER[b] or 99
        if orderA ~= orderB then
            return orderA < orderB
        end
        return a < b
    end)
    return finishes
end

-- The entries that match `filter` (see the top), for the collection in `state`.
function Browse.entries(state, filter)
    filter = filter or {}
    local terms, tagFilter = searchTerms(filter.search), tagFilterOf(filter)
    local mode = filter.owned or "all"
    local owned = ownedByCard(state)
    local entries, position = {}, {}
    for _, card in ipairs(Cards.list) do
        if cardMatches(card, filter, terms, tagFilter) then
            local have = owned[card.id]
            for _, finish in ipairs(finishesOf(have, mode ~= "owned")) do
                local count = have ~= nil and have[finish] or 0
                local locked = have == nil or have[finish] == nil
                if (mode == "all") or (mode == "owned" and not locked) or (mode == "unowned" and locked) then
                    local entry = { card = card, finish = finish, count = count, locked = locked }
                    entries[#entries + 1] = entry
                    position[entry] = #entries
                end
            end
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

-- True if a card the player has `have` (a { finish = count } table, or nil) of has an entry under this `owned` mode.
local function hasEntry(have, mode)
    if mode == "owned" then
        return have ~= nil
    end
    if mode == "unowned" then
        for finish in pairs(Cards.finishes) do
            if have == nil or have[finish] == nil then
                return true
            end
        end
        return false
    end
    return true
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
    local owned = ownedByCard(state)
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
    local owned = ownedByCard(state)
    local counts = { cards = 0, owned = 0 }
    for _, card in ipairs(Cards.list) do
        if cardMatches(card, filter, terms, tagFilter) then
            counts.cards = counts.cards + 1
            if owned[card.id] ~= nil then
                counts.owned = counts.owned + 1
            end
        end
    end
    return counts
end

-- How much of the deck the player has, in one pass over it (the Stats window shows all of these at once):
--   all      : { cards, owned } for every card
--   kinds    : { npc = { cards, owned }, item = { cards, owned } }
--   rarities : { [rarity id] = { cards, owned } }
--   regions  : { [region word] = { cards, owned } }   (a card with several regions counts in each)
--   noRegion : { cards, owned } for the cards that have no region at all (the ones every region's count leaves out)
-- A card counts as owned when the player has at least one variant of it. `hidden` (optional, { [variant key] = copies }, as
-- the pack opening gives it) are copies the player has not seen yet: they do not count, so the numbers do not give away
-- what is in a pack that is still being opened.
function Browse.progress(state, hidden)
    local have = {}
    for key, count in pairs(state.owned) do
        local cardId = Cards.parseKey(key)
        if cardId ~= nil and Cards.byId[cardId] ~= nil and count > ((hidden and hidden[key]) or 0) then
            have[cardId] = true
        end
    end
    local result = { all = { cards = 0, owned = 0 }, kinds = {}, rarities = {}, regions = {},
        noRegion = { cards = 0, owned = 0 } }
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
