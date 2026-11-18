-- dev/check_parked.lua
-- Checks the parked cards (dev/parked_cards/): cards that were taken out of the game but are kept so one can be brought back
-- (see dev/parked_cards/README.md). A parked card that has gone bad, because a tag word was renamed or the card format
-- changed, would only be found when someone tried to restore it; this finds it now. Each parked card must
--   * pass the same checks as a card from the overlay (Cards.problem), and not be a draft,
--   * not have the id of a card that is in the deck (it would replace that card), or of another parked card,
--   * be registered by Cards.register, the way the overlay would add it.
-- The plugin and the release never load these files (dev/ is left out of the release).
--
-- Run from the plugin's folder:  lua dev/check_parked.lua

package.path = "./?.lua;./dev/?.lua;" .. package.path

function log() end          -- the client's log function

local Cards = require("core/cards")
local files = require("dev/parked_cards/index")

local failures = 0
local function fail(what)
    failures = failures + 1
    io.stderr:write("FAIL: " .. what .. "\n")
end

-- Tags every card in a file gets (a deck file's `defaults`), merged the way core/cards.lua does it.
local function addDefaults(card, defaults)
    card.tags = card.tags or {}
    for kind, words in pairs(defaults) do
        local have = card.tags[kind] or {}
        local seen = {}
        for _, word in ipairs(have) do seen[word] = true end
        for _, word in ipairs(words) do
            if not seen[word] then
                have[#have + 1] = word
                seen[word] = true
            end
        end
        card.tags[kind] = have
    end
end

local total, parkedIds, registered = 0, {}, {}
local deckSize = #Cards.list
for _, name in ipairs(files) do
    local loaded, set = pcall(require, name)
    if not loaded or type(set) ~= "table" or type(set.cards) ~= "table" then
        fail(name .. " does not load as a deck file: " .. tostring(set))
    else
        if #set.cards == 0 then
            fail(name .. " has no cards: take it out of dev/parked_cards/index.lua and delete it")
        end
        for _, card in ipairs(set.cards) do
            total = total + 1
            if type(card) ~= "table" then
                fail(name .. ": a card is not a table")
            else
                if set.defaults ~= nil then
                    addDefaults(card, set.defaults)
                end
                local id = tostring(card.id)
                if parkedIds[id] then
                    fail(id .. " is parked twice (" .. parkedIds[id] .. " and " .. name .. ")")
                end
                parkedIds[id] = name
                local problem = Cards.problem(card)
                if Cards.byId[id] ~= nil then
                    fail(id .. " is parked in " .. name .. " but is also a card in the deck: restoring it would replace that card")
                elseif problem ~= nil then
                    fail(id .. " in " .. name .. " is no longer a sound card: " .. problem)
                elseif Cards.isDraft(card) then
                    fail(id .. " in " .. name .. " is a draft (empty art): it would be refused")
                else
                    local ok, why = Cards.register(card)
                    if ok then
                        registered[#registered + 1] = id
                    else
                        fail(id .. " in " .. name .. " would be refused: " .. tostring(why))
                    end
                end
            end
        end
    end
end
for _, id in ipairs(registered) do
    Cards.deprecate(id)
end
if #Cards.list ~= deckSize then
    fail("the deck changed size while checking (" .. deckSize .. " to " .. #Cards.list .. ")")
end

if failures > 0 then
    io.stderr:write(failures .. " parked card check(s) failed\n")
    os.exit(1)
end
print("OK: " .. total .. " parked cards in " .. #files .. " files are sound and none is in the deck")
