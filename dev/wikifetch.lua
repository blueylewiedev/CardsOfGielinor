-- dev/wikifetch.lua
-- The Wiki Fetch window: choose wiki categories (places for NPC cards, kinds of item for item
-- cards) and pages, and it writes the command that fetches them from the RuneScape Wiki
-- (dev/wiki_cards.py), to copy and run in the plugin's folder. The plugin can't reach the web
-- itself. Opened from the Wiki Review window, which shows the candidates after a prf.
-- Only used by the developer tools (the dev folder).

local Kit = require("ui/kit")

local WikiFetch = {}

-- The categories offered, with about how many pages each had on the wiki (October 2026), so the
-- window can say how many requests a choice might take. Any other category can be typed in.
local PLACES = {
    { "Lumbridge", 162 }, { "Varrock", 328 }, { "Falador", 164 }, { "Draynor Village", 72 },
    { "Al Kharid", 92 }, { "Burthorpe", 104 }, { "Taverley", 91 }, { "Catherby", 26 },
    { "Ardougne", 217 }, { "Port Sarim", 66 }, { "Rimmington", 64 }, { "Edgeville", 55 },
    { "Canifis", 49 }, { "Musa Point", 31 }, { "Brimhaven", 59 }, { "Seers' Village", 31 },
    { "Shilo Village", 55 }, { "Menaphos", 351 }, { "Prifddinas", 527 },
}
local ITEMS = {
    { "Logs", 75 }, { "Runes", 58 }, { "Fish", 142 }, { "Food", 351 }, { "Potions", 293 },
    { "Seeds", 155 }, { "Ores", 72 }, { "Gems", 58 }, { "Scimitars", 8 }, { "Daggers", 19 },
    { "Two-handed swords", 6 }, { "Battleaxes", 2 }, { "Maces", 2 }, { "Spears", 64 },
    { "Halberds", 42 }, { "Crossbows", 183 }, { "Longbows", 31 }, { "Staves", 232 },
    { "Wands", 94 }, { "Capes", 159 }, { "Rings", 184 }, { "Shields", 299 },
}
local PAGES_PER_REQUEST = 25        -- as dev/wiki_cards.py asks for them
local REQUESTS_PER_RUN = 30         -- its limit per run
local TYPED_PAGES = 100             -- the guess for a typed-in category's size

local PAGE_COUNTS = {}              -- category -> about how many pages, from the lists above
for _, group in ipairs({ PLACES, ITEMS }) do
    for _, entry in ipairs(group) do
        PAGE_COUNTS[entry[1]] = entry[2]
    end
end

local WIDTH = 572
local COLUMNS, COL_W, ROW_H = 3, 180, 32
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1)
local BLUE = Vector4.new(0.55, 0.78, 0.95, 1)

local window, content = nil, nil
local chosen = {}           -- category -> true (kept while the plugin runs)
local typed = { categories = "", pages = "" }
local widgets = {}

-- Splits "A, B ,C" into { "A", "B", "C" }.
local function list(text)
    local out = {}
    for part in string.gmatch(text or "", "[^,]+") do
        part = part:match("^%s*(.-)%s*$")
        if part ~= "" then
            out[#out + 1] = part
        end
    end
    return out
end

-- The command for what is chosen, and at most how many requests it takes (nothing cached).
local function command()
    local parts, requests = { "python dev/wiki_cards.py" }, 0
    local categories = {}
    for _, group in ipairs({ PLACES, ITEMS }) do
        for _, entry in ipairs(group) do
            if chosen[entry[1]] then
                categories[#categories + 1] = entry[1]
            end
        end
    end
    for _, name in ipairs(list(typed.categories)) do
        categories[#categories + 1] = name
    end
    for _, name in ipairs(categories) do
        parts[#parts + 1] = '--category "' .. name .. '"'
        requests = requests + 1 + math.ceil((PAGE_COUNTS[name] or TYPED_PAGES) / PAGES_PER_REQUEST)
    end
    local pages = list(typed.pages)
    for _, name in ipairs(pages) do
        parts[#parts + 1] = '--page "' .. name .. '"'
    end
    requests = requests + math.ceil(#pages / PAGES_PER_REQUEST)
    if #categories == 0 and #pages == 0 then
        return nil, 0
    end
    return table.concat(parts, " "), requests
end

local function refresh()
    if window == nil then
        return
    end
    local line, requests = command()
    widgets.command.content = line or "(choose categories or type pages above)"
    if line == nil then
        widgets.estimate.content = ""
    else
        local runs = math.max(1, math.ceil(requests / REQUESTS_PER_RUN))
        widgets.estimate.content = "Up to about " .. requests .. " requests if none are cached"
            .. (runs > 1 and (": run it " .. runs .. " times (30 a run, it carries on)") or "")
    end
end

-- A grid of toggles, one per category, from `y`. Returns the y below it.
local function toggles(group, y)
    for i, entry in ipairs(group) do
        local name = entry[1]
        local column, row = (i - 1) % COLUMNS, (i - 1) // COLUMNS
        Kit.toggleButton(content, name, 10 + column * COL_W, y + row * ROW_H, COL_W - 8, 28, chosen[name], function(on)
            chosen[name] = on or nil
            refresh()
        end, "About " .. entry[2] .. " pages on the wiki")
    end
    return y + math.ceil(#group / COLUMNS) * ROW_H
end

local function caption(text, y, colour)
    return Kit.text(content, 10, y, WIDTH - 20, 20, text, colour or GREY, ui.AlignMode.TOPLEFT)
end

-- A text box; onChange(text) as it is typed in.
local function box(y, value, onChange)
    local field = Kit.inputField(content, 10, y, WIDTH - 20, 28, 300, false)
    field.content = value
    field:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        onChange(field.content or "")
    end)
    return field
end

function WikiFetch.show()
    if window ~= nil then
        return
    end
    widgets = {}
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Wiki Fetch", WIDTH, 820 + Kit.titleBarHeight(),
        function() WikiFetch.hide() end, 0.5, 0.05)

    caption("NPCs from a place", 4, GOLD)
    local y = toggles(PLACES, 26) + 8
    caption("Items of a kind", y, GOLD)
    y = toggles(ITEMS, y + 22) + 8
    caption("Other wiki categories, separated by commas (as the wiki names them, without Category:)", y)
    box(y + 20, typed.categories, function(text)
        typed.categories = text
        refresh()
    end)
    caption("Single pages, separated by commas (e.g. Duke Horacio, Rune scimitar)", y + 54)
    box(y + 74, typed.pages, function(text)
        typed.pages = text
        refresh()
    end)

    y = y + 112
    caption("The command", y, GOLD)
    widgets.command = Kit.inputField(content, 10, y + 22, WIDTH - 20, 28, 1000, false)
    widgets.estimate = caption("", y + 54)
    local steps = {
        "1. Click the box above, press Ctrl+A, then Ctrl+C.",
        "2. Paste it into a terminal in the plugin's folder (CardsOfGielinor) and run it.",
        "3. In the game, prf, then open Wiki Review. What was asked for before stays on the list.",
    }
    for i, text in ipairs(steps) do
        caption(text, y + 78 + (i - 1) * 20, BLUE)
    end
    refresh()
end

function WikiFetch.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, widgets = nil, nil, {}
end

function WikiFetch.toggle()
    if window ~= nil then
        WikiFetch.hide()
    else
        WikiFetch.show()
    end
end

return WikiFetch
