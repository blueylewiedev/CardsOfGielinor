-- dev/artcheck.lua
-- Checks that the game knows each card's NPC or item name (the dev copy runs it at login). Not in the release.

local Cards = require("core/cards")

local ArtCheck = {}

-- Logs similar config names for a name that was not found, if the client lets us list them.
-- `registry` is id.NPC or id.Obj and `label` says which, for the log.
local function suggestNames(registry, label, npcName)
    local token = ""
    for part in string.gmatch(npcName, "[^_]+") do
        if #part > #token then
            token = part
        end
    end
    local ok, err = pcall(function()
        local found, total = 0, 0
        for key, value in pairs(registry) do
            total = total + 1
            if total <= 3 then
                -- Show what the entries look like: the earlier search found nothing in
                -- 32972 entries, so the names may be the values, or not plain strings.
                log("art:   sample entry", type(key), tostring(key), "=", type(value), tostring(value))
            end
            local hit = nil
            for _, text in ipairs({ key, value }) do
                if hit == nil and type(text) == "string" and string.find(string.upper(text), token, 1, true) then
                    hit = text
                end
            end
            if hit ~= nil then
                log("art:   maybe", hit, "=", tostring(type(key) == "string" and value or key))
                found = found + 1
                if found >= 30 then
                    break
                end
            end
        end
        if total == 0 then
            log("art:   " .. label .. " cannot be listed (it has no entries to loop over)")
        elseif found == 0 then
            log("art:   none of", total, label, "names contain", token)
        end
    end)
    if not ok then
        log("art:   cannot list " .. label .. " names here:", err)
    end
end

-- Logs each card whose NPC (or item) cannot be resolved by the game, then how many were checked.
-- Run this once on a developer world, then fix any NOT FOUND by renaming the card's id to
-- the config name, or by setting `npc` (or `item`) in its art entry. The cards that are found
-- are not logged one by one: there are thousands, and they bury everything else in the console.
function ArtCheck.run()
    local notFound = 0
    for _, card in ipairs(Cards.list) do
        local art = Cards.getArt(card)
        local isItem = Cards.kindOf(card) == "item"
        local name = isItem and art.item or art.npc
        local ok, value = pcall(function()
            if isItem then
                return id.Obj[name]
            end
            return id.NPC[name]
        end)
        local valid = isItem and Cards.isValidObjId(value) or (not isItem and Cards.isValidNpcId(value))
        if not (ok and valid) then
            notFound = notFound + 1
            log("art: NOT FOUND", card.id, name, "->", tostring(value))
            if isItem then
                suggestNames(id.Obj, "item", name)
            else
                suggestNames(id.NPC, "NPC", name)
            end
        end
    end
    log("art: checked", #Cards.list, "cards,", notFound, "not found")
end

return ArtCheck
