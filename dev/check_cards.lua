-- dev/check_cards.lua
-- Checks that every card loads: core/cards.lua loads each deck file and stops with an error for a
-- card it would refuse in the game (a tag word that is not in its lists, a duplicate id, an
-- unknown rarity, and the rest of its checks), naming the card. Run it before opening a pull
-- request; the "Check cards" workflow runs it on every pull request too.
--
-- It also warns about a description longer than Cards.MAX_DESC, which the card cuts off. That
-- doesn't stop the plugin loading, so the check still passes (on GitHub each one is shown on the
-- pull request as a warning).
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_cards.lua

package.path = "./?.lua;" .. package.path

local ok, result = pcall(require, "core/cards")
if not ok then
    io.stderr:write("The cards do not load:\n" .. tostring(result) .. "\n")
    os.exit(1)
end

local long = {}
for _, list in ipairs({ result.list, result.drafts }) do
    for _, card in ipairs(list) do
        if #(card.desc or "") > result.MAX_DESC then
            long[#long + 1] = card
        end
    end
end
table.sort(long, function(a, b) return a.id < b.id end)
local onGitHub = os.getenv("GITHUB_ACTIONS") == "true"
for _, card in ipairs(long) do
    local text = card.id .. ": the description is " .. #card.desc .. " letters; cards show " .. result.MAX_DESC
    print(onGitHub and ("::warning title=Long description::" .. text) or ("warning: " .. text))
end

local count = #result.list + #result.drafts
print("All " .. count .. " cards load (" .. #result.drafts .. " of them drafts)"
    .. (#long > 0 and (", " .. #long .. " with a description that is too long") or "") .. ".")
