-- dev/check_cards.lua
-- Checks that every card loads: core/cards.lua loads each deck file and stops with an error for a
-- card it would refuse in the game (a tag word that is not in its lists, a duplicate id, an
-- unknown rarity, and the rest of its checks), naming the card. Run it before opening a pull
-- request; the "Check cards" workflow runs it on every pull request too.
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_cards.lua

package.path = "./?.lua;" .. package.path

local ok, result = pcall(require, "core/cards")
if not ok then
    io.stderr:write("The cards do not load:\n" .. tostring(result) .. "\n")
    os.exit(1)
end

local count = #result.list + #result.drafts
print("All " .. count .. " cards load (" .. #result.drafts .. " of them drafts).")
