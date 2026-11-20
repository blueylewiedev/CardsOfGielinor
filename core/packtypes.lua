-- core/packtypes.lua
-- The pack types: "standard" and the themed ones in deck/packs.lua.

local Cards = require("core/cards")
local TagWords = require("core/tagwords")

local PackTypes = {}

-- A pack left out of the game (not sound, or deck/packs.lua did not load) is described in Cards.loadProblems, with the cards left out.
local function problemWith(message)
    Cards.loadProblems[#Cards.loadProblems + 1] = message
end

-- Pack types: "standard" and the themed ones in deck/packs.lua. A pack type holds:
--   id, name      id is for code, name is what the player sees
--   priceFactor   times the price of a pack (default 1; a themed pack with none uses Config "packs.themedPriceFactor")
--   size          cards in the pack (default Packs.PACK_SIZE)
--   filter only cards matching it can be pulled: { tag kind or "kind" = word or list of words }; all keys must match. The word
--                 Cards.NO_TAG ("none") matches a card with no word of that kind
--   minRarity     only this rarity or better
--   art           how the pack looks (ui/packart.lua; made in the Pack Maker)
--   featured      a number: the pack is in the Shop's General section, in this order (Packs.offered)
PackTypes.byId = {
    standard = { id = "standard", name = "Standard pack", priceFactor = 1, featured = 1 },
}

-- Why a pack type is not sound, or nil. Filter words from a closed list must be on it, so a typo can't make an empty
-- pack.
local function packProblem(packType)
    if type(packType) ~= "table" or type(packType.id) ~= "string" or packType.id == "" then
        return "A pack in deck/packs.lua has no id"
    end
    if packType.minRarity ~= nil and not Cards.rarities[packType.minRarity] then
        return "Unknown minRarity on pack " .. packType.id
    end
    if packType.featured ~= nil and type(packType.featured) ~= "number" then
        return "The featured of pack " .. packType.id .. " must be a number"
    end
    if packType.filter ~= nil and type(packType.filter) ~= "table" then
        return "The filter of pack " .. packType.id .. " must be a table"
    end
    for kind, wanted in pairs(packType.filter or {}) do
        for _, word in ipairs(type(wanted) == "table" and wanted or { wanted }) do
            -- (NO_TAG only on a tag kind with a word list: on a misspelt kind every card has no words, so it would
            -- match every card)
            if word == Cards.NO_TAG then
                if TagWords.words[kind] == nil then
                    return "Pack " .. packType.id .. " filters on " .. tostring(kind) .. " = \"" .. Cards.NO_TAG
                        .. "\", but that is only for a tag kind with a word list"
                end
            elseif not TagWords.isKnown(kind, word) then
                return "Pack " .. packType.id .. " filters on unknown " .. kind .. " word " .. tostring(word)
            end
        end
    end
    return nil
end

-- A line in deck/packs.lua with the id of a pack type already here (such as "standard") changes
-- that pack's fields (its name and look) and keeps the rest; any other is a new themed pack. A line that is
-- not sound is left out.
local listed = {}
local packsLoaded, deckPacks = pcall(require, "deck/packs")
if not packsLoaded or type(deckPacks) ~= "table" then
    problemWith("deck/packs.lua did not load: " .. tostring(deckPacks))
    deckPacks = {}
end
for _, packType in ipairs(deckPacks) do
    local problem = packProblem(packType)
    if problem == nil and listed[packType.id] then
        problem = "Duplicate pack type id " .. packType.id
    end
    if problem ~= nil then
        problemWith(problem)
    else
        listed[packType.id] = true
        local existing = PackTypes.byId[packType.id]
        if existing ~= nil then
            for field, value in pairs(packType) do
                existing[field] = value
            end
        else
            packType.themed = true
            PackTypes.byId[packType.id] = packType
        end
    end
end
-- (the pack types written in this file are code, not data, so a mistake in one is an error)
for key, packType in pairs(PackTypes.byId) do
    assert(packType.id == key, "Pack type id must match its key: " .. key)
    local problem = packProblem(packType)
    assert(problem == nil, problem)
end

return PackTypes
