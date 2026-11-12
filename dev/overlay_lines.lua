-- dev/overlay_lines.lua
-- The overlay's card lines: every live card as one line of JSON, in order of id (so the same deck always gives
-- the same file, and a card that did not change gives the same line). A card is written exactly as the game has
-- it once the deck has loaded (the deck file's default tags are already in its tags), so a card read back from
-- its line is the card.

local Encode = require("jsonencode")

local Lines = {}

-- { line, ... } for the cards of a loaded core/cards module, one per live card (drafts are not live), by id.
function Lines.cards(Cards)
    local sorted = {}
    for index, card in ipairs(Cards.list) do
        sorted[index] = card
    end
    table.sort(sorted, function(a, b) return a.id < b.id end)
    local lines = {}
    for index, card in ipairs(sorted) do
        local ok, text = pcall(Encode.encode, card)
        if not ok then
            error("card " .. card.id .. ": " .. tostring(text), 0)
        end
        lines[index] = text
    end
    return lines
end

return Lines
