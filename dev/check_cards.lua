-- dev/check_cards.lua
-- Checks that every card loads: core/cards.lua loads each deck file and stops with an error for a
-- card it would refuse in the game (a tag word that is not in its lists, a duplicate id, an
-- unknown rarity, and the rest of its checks), naming the card. Run it before opening a pull
-- request; the "Check cards" workflow runs it on every pull request too.
--
-- It also warns about a description longer than Cards.MAX_DESC, which the card cuts off. That
-- doesn't stop the plugin loading, so the check still passes (on GitHub each one is shown on the
-- pull request as a warning). So is an id in dev/wiki_pages.json that no card has.
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_cards.lua

package.path = "./?.lua;" .. package.path

local ok, result = pcall(require, "core/cards")
if not ok then
    io.stderr:write("The cards do not load:\n" .. tostring(result) .. "\n")
    os.exit(1)
end

-- A card, file or pack the plugin leaves out is not a failure in the released plugin, but it must not get that far.
if #result.loadProblems > 0 then
    local lines = {}
    for _, message in ipairs(result.loadProblems) do
        lines[#lines + 1] = "  " .. message
    end
    io.stderr:write("The deck has " .. #result.loadProblems .. " problem(s); the plugin would leave these out:\n"
        .. table.concat(lines, "\n") .. "\n")
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

-- dev/wiki_pages.json (one card to a line): an id no card has is left from a renamed or removed card
local known, recorded, stale = {}, {}, {}
for _, list in ipairs({ result.list, result.drafts }) do
    for _, card in ipairs(list) do known[card.id] = true end
end
local pagesFile = io.open("dev/wiki_pages.json", "r")
if pagesFile then
    for line in pagesFile:lines() do
        local id = line:match('^%s*"([^"]+)"%s*:')
        if id then
            recorded[id] = true
            if not known[id] then stale[#stale + 1] = id end
        end
    end
    pagesFile:close()
end
for _, id in ipairs(stale) do
    local text = "dev/wiki_pages.json has " .. id .. ", which no card has: rename or remove it"
    print(onGitHub and ("::warning title=Stale wiki page::" .. text) or ("warning: " .. text))
end
local unrecorded = 0                -- (not counting drafts, which the backfill leaves out)
for _, card in ipairs(result.list) do
    if not recorded[card.id] then unrecorded = unrecorded + 1 end
end

local count = #result.list + #result.drafts
print("All " .. count .. " cards load (" .. #result.drafts .. " of them drafts)"
    .. (#long > 0 and (", " .. #long .. " with a description that is too long") or "")
    .. (#stale > 0 and (", " .. #stale .. " stale in dev/wiki_pages.json") or "") .. ".")
print(unrecorded .. " cards have no wiki page in dev/wiki_pages.json (python dev/wiki_pages.py --backfill).")
