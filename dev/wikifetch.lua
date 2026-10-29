-- dev/wikifetch.lua
-- The Wiki Fetch window: choose what to fetch from the RuneScape Wiki (league regions and places
-- for NPC cards, kinds of item for item cards, single pages), and how to narrow them (a race,
-- free to play only), and it writes the command that fetches them (dev/wiki_cards.py), to copy
-- and run in the plugin's folder. The narrowing is done by the wiki before anything is fetched,
-- so only the matching pages are; it belongs to this fetch's places and regions only, and what
-- was fetched before is kept as it was. The plugin can't reach the web itself. Opened from the
-- Wiki Review window, which shows the candidates after a prf.
-- Only used by the developer tools (the dev folder).

local Kit = require("ui/kit")

local WikiFetch = {}

-- What can be chosen, with about how many pages each had on the wiki (October 2026), so the
-- window can say how many requests a choice might take. Any other category can be typed in.
-- League regions, as the wiki writes them (Module:LeagueRegion; its name for the desert is
-- Desert). Global: found all over the world, like rats. Multiple (not a wiki region): found in
-- several regions, like imps; general cards too. None (not a wiki region either): given no region
-- on the wiki, like Lucien; each is filed by its places' regions where it can be.
local REGIONS = {
    { "Global", 130 }, { "Multiple", 305 }, { "None", 2668 }, { "Misthalin", 600 }, { "Asgarnia", 600 }, { "Kandarin", 600 }, { "Desert", 600 },
    { "Fremennik", 400 }, { "Karamja", 300 }, { "Morytania", 400 }, { "Wilderness", 300 }, { "Tirannwn", 400 },
    { "Havenhythe", 200 }, { "Anachronia", 200 },
}
local PLACES = {
    { "Lumbridge", 162 }, { "Varrock", 328 }, { "Falador", 164 }, { "Draynor Village", 72 },
    { "Al Kharid", 92 }, { "Burthorpe", 104 }, { "Taverley", 91 }, { "Catherby", 26 },
    { "Ardougne", 217 }, { "Port Sarim", 66 }, { "Rimmington", 64 }, { "Edgeville", 55 },
    { "Canifis", 49 }, { "Musa Point", 31 }, { "Brimhaven", 59 }, { "Seers' Village", 31 },
    { "Shilo Village", 55 }, { "Menaphos", 351 }, { "Prifddinas", 527 },
}
-- Races as the wiki's infoboxes write them. The wiki keeps no list of these values, so any other
-- can be typed into the drop-down's box.
local RACES = {
    "Aviansie", "Bat", "Bear", "Bird", "Cat", "Centaur", "Chicken", "Cow", "Crab", "Cyclops", "Dagannoth",
    "Demon", "Dog", "Dorgeshuun", "Dragon", "Dwarf", "Elemental", "Elf", "Fairy", "Frog", "Ghost", "Ghoul",
    "Giant", "Gnome", "Goat", "Goblin", "Golem", "Hobgoblin", "Human", "Icyene", "Kalphite", "Mahjarrat",
    "Mole", "Monkey", "Ogre", "Ork", "Penguin", "Rat", "Scorpion", "Sheep", "Skeleton", "Snake", "Spider",
    "Spirit", "Troll", "TzHaar", "Unicorn", "Vampyre", "Werewolf", "Wolf", "Yeti", "Zombie",
}
-- Kinds of item, as the wiki's categories (under Melee weapons, Ranged weapons, Magic weapons
-- and Armour types, October 2026).
local ITEM_GROUPS = {
    { title = "Melee", list = {
        { "Battleaxes", 2 }, { "Blackjacks", 11 }, { "Ceremonial swords", 57 }, { "Daggers", 19 },
        { "Halberds", 42 }, { "Hastae", 7 }, { "Hatchets", 39 }, { "Longswords", 1 }, { "Maces", 2 },
        { "Mauls", 5 }, { "Pickaxes", 71 }, { "Rapiers", 25 }, { "Scimitars", 8 }, { "Shortswords", 1 },
        { "Spears", 64 }, { "Two-handed swords", 6 }, { "Warhammers", 1 } } },
    { title = "Ranged", list = {
        { "Bows", 128 }, { "Longbows", 31 }, { "Shieldbows", 3 }, { "Crossbows", 183 }, { "Darts", 28 },
        { "Javelins", 17 }, { "Throwing knives", 47 }, { "Ammunition", 189 } } },
    { title = "Magic", list = { { "Staves", 232 }, { "Wands", 94 }, { "Necromancy weapons", 95 } } },
    { title = "Armour", list = {
        { "Platebodies", 116 }, { "Chainbodies", 27 }, { "Platelegs", 215 }, { "Plateskirts", 60 },
        { "Shields", 299 }, { "Cloaks", 39 }, { "Capes", 159 }, { "Rings", 184 }, { "God armour", 43 },
        { "Fremennik armour", 74 } } },
    { title = "Resources", list = {
        { "Logs", 75 }, { "Ores", 72 }, { "Gems", 58 }, { "Herbs", 96 }, { "Seeds", 155 }, { "Fish", 142 },
        { "Runes", 58 } } },
    { title = "Consumables", list = { { "Food", 351 }, { "Potions", 293 } } },
}
local PAGES_PER_REQUEST = 25        -- as dev/wiki_cards.py asks for them
local REQUESTS_PER_RUN = 30         -- its limit per run
local TYPED_PAGES = 100             -- the guess for a typed-in category's size

local PAGE_COUNTS = {}              -- category or region -> about how many pages, from the lists above
local counted = { REGIONS, PLACES }
for _, group in ipairs(ITEM_GROUPS) do
    counted[#counted + 1] = group.list
end
for _, list in ipairs(counted) do
    for _, entry in ipairs(list) do
        PAGE_COUNTS[entry[1]] = entry[2]
    end
end

local WIDTH = 572
local FULL = Kit.contentWidth(WIDTH)
local HALF = (FULL - 10) // 2           -- a column: a label and its drop-down
local LABEL_W = 104
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1)
local WHITE = Vector4.new(1, 1, 1, 1)
local BLUE = Vector4.new(0.55, 0.78, 0.95, 1)

local window, content = nil, nil
-- What is chosen (kept while the plugin runs): each drop-down's choice (region, place, and one
-- for each group of items), and how to narrow them.
local picks = {}            -- drop-down -> the region or category chosen in it
local race = nil
local f2pOnly = false
local npcsOnly = false        -- no items from the categories and regions (a place's items too)
local typed = { categories = "", pages = "" }
local widgets = {}
local dropdowns = {}        -- destroyed with the window (PrettyUI keeps their lists outside it)

-- Splits "A, B ,C" into { "A", "B", "C" }.
local function list(text)
    local out = {}
    for raw in string.gmatch(text or "", "[^,]+") do
        local part = raw:match("^%s*(.-)%s*$")
        if part ~= "" then
            out[#out + 1] = part
        end
    end
    return out
end

-- The command for what is chosen, and at most how many requests it takes (nothing cached). Its
-- preview is the same with --count.
local function command()
    local parts, requests = { "python dev/wiki_cards.py" }, 0
    local regions, categories = {}, {}
    -- (a place with a region is the place within it: --within; a region alone is fetched whole)
    if picks.place == nil then
        regions[#regions + 1] = picks.region        -- (none if nothing is picked)
    end
    categories[#categories + 1] = picks.place
    for _, group in ipairs(ITEM_GROUPS) do
        categories[#categories + 1] = picks[group.title]
    end
    for _, name in ipairs(list(typed.categories)) do
        categories[#categories + 1] = name
    end
    -- A race leaves about a tenth of the pages to fetch, free to play about half (a guess); each
    -- costs two searches (for a category; a region's membership is in its own query).
    local share = (race ~= nil and 0.1 or 1) * (f2pOnly and 0.5 or 1)
    for _, name in ipairs(categories) do
        parts[#parts + 1] = '--category "' .. name .. '"'
        requests = requests + 1 + (race ~= nil and 2 or 0) + (f2pOnly and 2 or 0)
            + math.ceil((PAGE_COUNTS[name] or TYPED_PAGES) * share / PAGES_PER_REQUEST)
    end
    for _, name in ipairs(regions) do
        parts[#parts + 1] = '--region "' .. name .. '"'
        requests = requests + 2 + (race ~= nil and 2 or 0)
            + math.ceil(PAGE_COUNTS[name] * share / PAGES_PER_REQUEST)
    end
    local pages = list(typed.pages)
    for _, name in ipairs(pages) do
        parts[#parts + 1] = '--page "' .. name .. '"'
    end
    requests = requests + math.ceil(#pages / PAGES_PER_REQUEST)
    if #categories == 0 and #regions == 0 and #pages == 0 then
        return nil, 0
    end
    if race ~= nil then
        parts[#parts + 1] = '--race "' .. race .. '"'
    end
    if npcsOnly then
        parts[#parts + 1] = "--npcs"
    end
    if picks.place ~= nil and picks.region ~= nil then
        parts[#parts + 1] = '--within "' .. picks.region .. '"'
    end
    if f2pOnly then
        parts[#parts + 1] = "--members f2p"
    end
    return table.concat(parts, " "), requests
end

local function refresh()
    -- (the drop-downs are made, and their choices restored, before the command boxes)
    if window == nil or widgets.command == nil then
        return
    end
    local line, requests = command()
    widgets.command.content = line or "(choose something above, or type categories or pages)"
    widgets.preview.content = line ~= nil and (line .. " --count") or ""
    if line == nil then
        widgets.estimate.content = ""
    else
        local runs = math.max(1, math.ceil(requests / REQUESTS_PER_RUN))
        widgets.estimate.content = "Up to about " .. requests .. " requests if none are cached"
            .. (runs > 1 and (": run it " .. runs .. " times (30 a run, it carries on)") or "")
    end
end

local function caption(text, x, y, w, colour)
    return Kit.text(content, x, y, w, 20, text, colour or GREY, ui.AlignMode.TOPLEFT)
end

-- A label and a drop-down in column `column` (0 or 1) at `y`. `entries` are { label, value };
-- the first entry is shown at first. onChoose(value) when one is picked.
local function labelledDropdown(column, y, label, entries, onChoose)
    local x = 10 + column * (HALF + 10)
    caption(label, x, y + 5, LABEL_W, WHITE)
    local dropdown = Kit.dropdown(content, x + LABEL_W, y, HALF - LABEL_W, 28, entries, entries[1].value, onChoose)
    dropdowns[#dropdowns + 1] = dropdown
    return dropdown
end

-- A drop-down choosing one name of `group` (entries are names, or { name, pages }), or nothing
-- (`noneLabel`, "None" if not given): set(name or nil) when one is picked, showing `current` at
-- first. Its text box filters the list as you type.
local function picker(column, y, label, group, current, set, noneLabel)
    local entries = { { label = noneLabel or "None", value = false } }
    for _, entry in ipairs(group) do
        local name = type(entry) == "table" and entry[1] or entry
        entries[#entries + 1] = { label = name, value = name }
    end
    labelledDropdown(column, y, label, entries, function(name)
        set(name or nil)
        refresh()
    end).select(current or false)
end

-- A picker for picks[key].
local function pickFor(column, y, label, group, key)
    picker(column, y, label, group, picks[key], function(name) picks[key] = name end)
end

-- A text box; onChange(text) as it is typed in.
local function box(y, value, onChange)
    local field = Kit.inputField(content, 10, y, FULL, 28, 300, false)
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
    widgets, dropdowns = {}, {}
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Wiki Fetch", WIDTH, 600 + Kit.titleBarHeight(),
        function() WikiFetch.hide() end, 0.5, 0.05)

    caption("NPCs", 10, 4, FULL, GOLD)
    Kit.buttonAt(content, "Clear", 10 + FULL - 100, 0, 100, 24, function()
        picks, race, f2pOnly, npcsOnly = {}, nil, false, false
        WikiFetch.hide()            -- (made again, so every drop-down shows None)
        WikiFetch.show()
    end, "negative", "Set every drop-down back to None")
    pickFor(0, 26, "Region", REGIONS, "region")
    pickFor(1, 26, "Place", PLACES, "place")
    picker(0, 60, "Race", RACES, race, function(name) race = name end, "Any race")
    local toggleW = (HALF - 12) // 2
    Kit.toggleButton(content, "F2P only", 20 + HALF, 60, toggleW, 28, f2pOnly, function(on)
        f2pOnly = on
        refresh()
    end, "Only fetch the free to play pages")
    Kit.toggleButton(content, "NPCs only", 26 + HALF + toggleW, 60, toggleW, 28, npcsOnly, function(on)
        npcsOnly = on
        refresh()
    end, "Only fetch NPCs, no items (a place's category lists its items too)")
    caption("These narrow what this fetch asks the wiki for; earlier fetches are kept.", 10, 94, FULL)

    caption("Items", 10, 122, FULL, GOLD)
    for i, group in ipairs(ITEM_GROUPS) do
        local column, row = (i - 1) % 2, (i - 1) // 2
        pickFor(column, 144 + row * 34, group.title, group.list, group.title)
    end

    local y = 144 + math.ceil(#ITEM_GROUPS / 2) * 34 + 8
    caption("More categories (comma separated)", 10, y, FULL)
    box(y + 20, typed.categories, function(text)
        typed.categories = text
        refresh()
    end)
    caption("Pages (comma separated)", 10, y + 54, FULL)
    box(y + 74, typed.pages, function(text)
        typed.pages = text
        refresh()
    end)
    caption("Unsure of a name? Run wiki_cards.py with --subcategories NAME", 10, y + 106, FULL)

    y = y + 134
    caption("Preview: how many pages it would fetch (fetches none)", 10, y, FULL, GOLD)
    widgets.preview = Kit.inputField(content, 10, y + 22, FULL, 28, 1000, false)
    y = y + 58
    caption("The command", 10, y, FULL, GOLD)
    widgets.command = Kit.inputField(content, 10, y + 22, FULL, 28, 1000, false)
    widgets.estimate = caption("", 10, y + 54, FULL)
    local steps = {
        "1. Click a box, press Ctrl+A, then Ctrl+C.",
        "2. Run it in a terminal in the plugin's folder (CardsOfGielinor).",
        "3. After the command, prf in the game, then open Wiki Review.",
    }
    for i, text in ipairs(steps) do
        caption(text, 10, y + 78 + (i - 1) * 20, FULL, BLUE)
    end
    refresh()
end

function WikiFetch.hide()
    for _, dropdown in ipairs(dropdowns) do
        pcall(dropdown.destroy)
    end
    dropdowns = {}
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
