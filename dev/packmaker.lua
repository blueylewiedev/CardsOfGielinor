-- dev/packmaker.lua
-- The Pack Maker: a window for designing a themed pack, opened from the Home window's developer
-- buttons.
--
--   1. Login screen : the game's login screen pictures, found by search and a drop-down (or
--                     stepped through). The picture is shown whole, with a Front box and a Back
--                     box: drag them along it to choose what each side of the pack shows.
--   2. Pack name    : the title on the banner (one per region, from ui/packtitles.lua), moved and
--                     resized with the buttons.
--   3. Logo         : which RuneScape logo (or none), moved and resized with the buttons.
--   4. Cards        : which cards the pack gives: a region for now (the pack's filter, see
--                     Cards.packTypes, so other tags can be added later). It follows the pack name
--                     until a region is picked here.
--   5. Save         : the pack's name and Save. Saved designs are kept in the plugin's database
--                     (PersistentDB, on this computer only) and can be loaded again or deleted.
--                     To put a pack in the game, its line (shown under Save) is pasted into
--                     deck/packs.lua, as the plugin can't write its own files.
--   The front and back of the pack are drawn on the right as they will look.
--
-- The pictures are found by walking the game's sprite names the first time the window opens (a
-- few seconds; the list is kept while the plugin runs): the tiled login screens named
-- RS3_LOGINSCREEN_<name>_0, _1, ... and the single cutscene sprites (names with CUTSCENE in
-- them). Search "CUTSCENE" or a place name to find the cutscenes.
--
-- Dragging a box: pressing it stretches its (invisible) grip over the whole window and brings
-- it to the front, so the grip keeps getting the hold and release wherever the mouse goes; the
-- pack is redrawn a few times a second while dragging, and once more on release. Mouse movement
-- is taken as window pixels (it assumes the interface is not scaled).
--
-- What is being made is kept while the plugin is running, so closing the window does not lose it.

local Kit = require("ui/kit")
local Cards = require("core/cards")
local Packs = require("core/packs")
local PackArt = require("ui/packart")

local PackMaker = {}

local SUBSCRIBER = "cardcollector_packmaker"
local DB_KEY = "packmaker_designs"
local SCREEN_PREFIX = "RS3_LOGINSCREEN_"
local GOLD = Vector4.new(0.96, 0.82, 0.45, 1)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1)
local BLUE = Vector4.new(0.55, 0.78, 0.95, 1)
local GREEN = Vector4.new(0.55, 0.85, 0.55, 1)
local RED = Vector4.new(0.91, 0.49, 0.43, 1)
local FRONT_COLOUR = Vector4.new(1, 0.85, 0.3, 1)
local BACK_COLOUR = Vector4.new(0.5, 0.8, 1, 1)

-- Layout: the login screen, name and logo on the left; the pack's two sides, its cards and
-- saving on the right.
local LEFT_X, LEFT_W = 10, 448
local ART_X, ART_Y, ART_W, ART_H = 10, 96, 448, 252
local DROPDOWN_W = 294                    -- the drop-downs under the picture
local ICON, ICON_GAP = 24, 6              -- PrettyUI sprite buttons
local MAX_LISTED = 400                    -- the most entries the picture drop-down holds (search narrows it)
local PACK_H = 320
local RIGHT_X, RIGHT_W = 480, 430
local FRONT_X, BACK_X, PACK_Y = 480, 700, 40
local WIN_W = BACK_X + 230
local WIN_H = 676

local MOVE_STEP, SIZE_STEP = 4, 10        -- pack units per press
local SCAN_PER_FRAME = 4000               -- sprite ids checked per frame while finding screens
local SCAN_GIVE_UP = 3000                 -- stop after this many missing ids in a row
local DRAG_REDRAW_SECONDS = 0.12

-- The logos as the drop-down names them.
local LOGO_LABELS = {
    RS3_LOGINSCREEN_MOBILE_LOGO = "Login screen logo", RS3_LOGO_MEDIUM = "Medium logo", RS3_LOGO_TINY = "Tiny logo",
}

-- A new look: the first title and logo, the front at the picture's left edge and the back at
-- its right edge, the logo at the top and the name at the bottom (the places used for the
-- Misthalin pack).
local function defaults(screen)
    return {
        screen = screen,
        front = 0, back = 1 - PackArt.WINDOW,
        name = { title = PackArt.TITLES[1].id, x = 0, y = 226, w = 150 },
        logo = { sprite = PackArt.LOGOS[1].sprite, x = 0, y = 40, w = 130 },
    }
end

-- The look as Lua, "art = { ... }", for a pack type's line.
local function artBlock(art)
    local name = art.name
    local parts = {
        string.format("screen = %q", art.screen or ""),
        string.format("front = %.3f, back = %.3f", art.front, art.back),
        string.format("name = { title = %q, x = %d, y = %d, w = %d }", name.title, name.x, name.y, name.w),
    }
    if art.logo ~= nil then
        parts[#parts + 1] = string.format("logo = { sprite = %q, x = %d, y = %d, w = %d }",
            art.logo.sprite, art.logo.x, art.logo.y, art.logo.w)
    end
    return "art = { " .. table.concat(parts, ", ") .. " }"
end

-- The design being made (kept while the plugin runs). nameTouched/regionTouched: the pack name
-- and the region follow the title until they are set by hand.
local function freshDesign()
    return {
        name = "", nameTouched = false,
        region = PackArt.TITLES[1].id, regionTouched = false,
        art = defaults(nil),
    }
end
local design = freshDesign()

local screens = nil                       -- every login screen found, sorted
local scan = nil                          -- { nextId, misses, tiles } while finding them
local search = ""                         -- the search box's text
local shownScreens = {}                   -- the screens matching the search

local window, content = nil, nil
local widgets = {}
local packs = {}                          -- front, back: from PackArt.new
local artParts = {}                       -- the tiles in the login screen panel
local marks = {}                          -- front, back: { box, label, grip }
local drag = nil                          -- { side, mouseX, start, since, dirty } while dragging
local settingField = false                -- true while the code (not the player) fills a text box
local lastLogoPlace = nil                 -- where the logo was before "no logo"

local function section(title, x, y, w)
    Kit.text(content, x, y, w, 20, title, GOLD, ui.AlignMode.TOPLEFT)
end

local function caption(text, x, y, w, colour)
    return Kit.text(content, x, y, w, 18, text, colour or GREY, ui.AlignMode.TOPLEFT)
end

local function setText(widget, text, colour)
    if widget == nil then
        return
    end
    if widget.content ~= text then
        widget.content = text
    end
    if colour ~= nil then
        pcall(function() widget.colour = colour end)
    end
end

-- A box to type in; `onChange(text)` is called as the player types (not when the code fills it).
local function field(x, y, w, maxLength, onChange)
    local box = Kit.inputField(content, x, y, w, 28, maxLength, false)
    box:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        if not settingField then
            onChange(box.content or "")
        end
    end)
    return box
end

local function setField(box, text)
    if box ~= nil and box.content ~= text then
        settingField = true
        box.content = text
        settingField = false
    end
end

local clearParts = PackArt.destroyAll

-- -------------------------------------------------------------------------------------------
-- Names, regions and the pack's line
-- -------------------------------------------------------------------------------------------

local function titleText(titleId)
    local title = PackArt.titleById(titleId)
    return title and title.text or titleId
end

-- The pack's name: as typed, or "<title> pack".
local function packName()
    if design.nameTouched and design.name ~= "" then
        return design.name
    end
    return titleText(design.art.name.title) .. " pack"
end

-- The pack's id: its name in lower case with underscores ("Misthalin pack" -> misthalin_pack).
local function packId()
    local text = string.lower(packName())
    text = string.gsub(text, "[^a-z0-9]+", "_")
    return (string.gsub(text, "^_+", ""):gsub("_+$", ""))
end

local function filter()
    return { regions = design.region }
end

-- How many cards in the game the pack's filter lets through.
-- How many cards the pack would give (the same rule the pack window uses), counted once per
-- region as the cards don't change while the plugin runs.
local cardCounts = {}
local function cardCount()
    local count = cardCounts[design.region]
    if count == nil then
        count = select(2, Packs.poolFor({ filter = filter() }))
        cardCounts[design.region] = count
    end
    return count
end

-- The pack type as one line, to paste into deck/packs.lua.
local function packLine()
    return string.format("{ id = %q, name = %q, filter = { regions = %q }, %s },", packId(), packName(),
        design.region, artBlock(design.art))
end

-- -------------------------------------------------------------------------------------------
-- Saved designs (PersistentDB): { [pack id] = { name, region, art } }
-- -------------------------------------------------------------------------------------------

local function savedDesigns()
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(DB_KEY) end)
    return (ok and type(saved) == "table") and saved or {}
end

local function copy(value)
    if type(value) ~= "table" then
        return value
    end
    local out = {}
    for k, v in pairs(value) do
        out[k] = copy(v)
    end
    return out
end

local function savedEntries()
    local list = {}
    for packKey, saved in pairs(savedDesigns()) do
        list[#list + 1] = { label = (saved.name or packKey) .. "  (" .. packKey .. ")", value = packKey }
    end
    table.sort(list, function(a, b) return a.label < b.label end)
    return list
end

-- -------------------------------------------------------------------------------------------
-- Finding and showing the login screens
-- -------------------------------------------------------------------------------------------

-- Walks the sprite ids a chunk at a time (called every frame until done). It lists:
--   login screens : sets of tiles RS3_LOGINSCREEN_<name>_<n> with a tile 0 and at least four
--   cutscenes     : single sprites with CUTSCENE in the name (the illustrated cutscenes come as
--                   layers, e.g. HAVENHYTHE_INTRO_CUTSCENE_SCENE_02_0001_BG; the _BG ones are
--                   the backgrounds)
-- (Other pictures cut into 9 parts were tried too; none made good packs, and the game's
-- nine-slice frames came up among them.)
local function scanStep()
    local tiles = scan.tiles
    for _ = 1, SCAN_PER_FRAME do
        local spriteNumber = scan.nextId
        scan.nextId = spriteNumber + 1
        local ok, name = pcall(function() return id.Sprite.FromID(spriteNumber) end)
        if ok and type(name) == "string" and name ~= "" then
            scan.misses = 0
            local base, n = name:match("^(" .. SCREEN_PREFIX .. ".+)_(%d+)$")
            if base ~= nil then
                tiles[base] = tiles[base] or {}
                tiles[base][tonumber(n)] = true
            elseif name:find("CUTSCENE", 1, true) then
                scan.singles[#scan.singles + 1] = name
            end
        else
            scan.misses = scan.misses + 1
            if scan.misses >= SCAN_GIVE_UP then
                local loginBases = {}
                for base, ns in pairs(tiles) do
                    local count = 0
                    for _ in pairs(ns) do count = count + 1 end
                    if ns[0] and count >= 4 then
                        loginBases[#loginBases + 1] = base
                    end
                end
                screens = { table.unpack(loginBases) }
                for _, name in ipairs(scan.singles) do
                    screens[#screens + 1] = name
                end
                log("pack maker:", #loginBases, "login screens and", #scan.singles, "cutscene pictures found")
                scan = nil
                return true, loginBases
            end
        end
    end
    return false
end

local function shortName(screen)
    return (screen:gsub("^" .. SCREEN_PREFIX, ""))
end

-- -------------------------------------------------------------------------------------------
-- The login screens' names as the game shows them ("Yak Track: Wintumber Aurora")
--
-- Found in game: enum 12590 (LOGINSCREEN_BACKGROUND_DROPDOWN) gives each login screen's name by
-- a number, and enum 12591 (LOGINSCREEN_BACKGROUNDS) gives, by the same number, a struct whose
-- parameters (LOGINSCREEN_BACKGROUND_NXT_0, _1, ...) are the picture's tile sprite ids. Names left
-- over are matched by their words ("WINTUMBER", "AURORA") to the one sprite set containing them.
-- -------------------------------------------------------------------------------------------

local NAMES_ENUM, SCREENS_ENUM = 12590, 12591
local displayNames = {}                   -- picture name -> the game's name for it

-- A picture's label: the game's name and the sprite name, or just the sprite name.
local function labelOf(screen)
    local display = displayNames[screen]
    return display and (display .. "  (" .. shortName(screen) .. ")") or shortName(screen)
end

-- The login screen whose tile 0 a struct names (sprite ids are plain numbers, or game objects
-- that print as "config.Sprite.NAME(123)").
local function screenOfStruct(struct, tile0)
    local found = nil
    pcall(function()
        for _, param in ipairs(struct.params) do
            local value = struct:GetParamValue(param)
            local number = type(value) == "number" and value or tonumber(tostring(value):match("%((%d+)%)$"))
            found = found or (number and tile0[number])
        end
    end)
    return found
end

-- The name left over goes to the one login screen (not yet named) whose sprite name holds the
-- most of its words of 4 letters or more, if there is just one.
local SKIP_WORDS = { TRACK = true, THE = true, WITH = true, FROM = true, LOGIN = true, SCREEN = true }
local function screenByWords(display, bases, taken)
    local words = {}
    for word in string.gmatch(string.upper(display), "[A-Z0-9]+") do
        if #word >= 4 and not SKIP_WORDS[word] then
            words[#words + 1] = word
        end
    end
    local best, bestScore, tie = nil, 0, false
    for _, base in ipairs(bases) do
        if not taken[base] then
            local score = 0
            for _, word in ipairs(words) do
                if string.find(shortName(base), word, 1, true) then
                    score = score + 1
                end
            end
            if score > bestScore then
                best, bestScore, tie = base, score, false
            elseif score == bestScore and score > 0 then
                tie = true
            end
        end
    end
    return (not tie) and best or nil
end

-- Fills displayNames for the login screens found (`bases`, their sprite names without the tile
-- number). Called once, after the pictures are found.
local function matchNames(bases)
    local names, taken, keyToBase = {}, {}, {}
    local tile0 = {}
    for _, base in ipairs(bases) do
        local ok, value = pcall(function() return id.Sprite[base .. "_0"] end)
        if ok and type(value) == "number" and value >= 0 then
            tile0[value] = base
        end
    end
    local ok, err = pcall(function()
        for _, pair in ipairs(config.Enum.FromID(NAMES_ENUM).values) do
            if type(pair[2]) == "string" and pair[2] ~= "" then
                names[pair[1]] = pair[2]
            end
        end
        for _, pair in ipairs(config.Enum.FromID(SCREENS_ENUM).values) do
            local base = names[pair[1]] and screenOfStruct(pair[2], tile0)
            if base and not taken[base] then
                keyToBase[pair[1]], taken[base] = base, true
            end
        end
    end)
    if not ok then
        log("pack maker: couldn't read the login screen names:", tostring(err))
    end
    local direct, byWords = 0, 0
    for key, display in pairs(names) do
        local base = keyToBase[key]
        if base ~= nil then
            direct = direct + 1
        else
            base = screenByWords(display, bases, taken)
            if base ~= nil then
                taken[base] = true
                byWords = byWords + 1
            end
        end
        if base ~= nil then
            displayNames[base] = display
        end
    end
    log(string.format("pack maker: login screen names: %d matched, %d by their words", direct, byWords))
end

-- The screens whose names contain the search text (any case), and the drop-down filled with them.
local function applySearch()
    shownScreens = {}
    local labels = {}
    local wanted = string.lower(search)
    for _, screen in ipairs(screens or {}) do
        local label = labelOf(screen)
        if wanted == "" or string.find(string.lower(label), wanted, 1, true) then
            shownScreens[#shownScreens + 1] = screen
            labels[screen] = label
        end
    end
    -- In the order the drop-down shows them (the client's list sorts by the name shown), so
    -- the arrows step through it in that order too.
    table.sort(shownScreens, function(a, b) return labels[a] < labels[b] end)
    if widgets.screenDropdown ~= nil then
        local entries = {}
        for i, screen in ipairs(shownScreens) do
            if i > MAX_LISTED then
                break
            end
            entries[#entries + 1] = { label = labels[screen], value = screen }
        end
        widgets.screenDropdown.set(entries, design.art.screen)
    end
end

local function positionOf(screen)
    for i, s in ipairs(shownScreens) do
        if s == screen then
            return i
        end
    end
    return nil
end

local function redrawSide(side)
    if packs[side] ~= nil then
        PackArt.drawArt(packs[side], design.art)
    end
end

local function redrawTop()
    if packs.front ~= nil then
        PackArt.drawTop(packs.front, design.art)
    end
end

-- Puts a side's box (and its grip, unless it is being dragged) over its window of the picture.
local function placeMark(side)
    local mark = marks[side]
    if mark == nil then
        return
    end
    local x = ART_X + math.floor(design.art[side] * ART_W)
    local w = math.floor(PackArt.WINDOW * ART_W)
    mark.box:SetPos(x + 1, ART_Y + 1)
    mark.box:SetSize(w - 2, ART_H - 2)
    mark.label:SetPos(x + 6, ART_Y + (side == "front" and 4 or ART_H - 24))
    if not (drag ~= nil and drag.side == side) then
        mark.grip:SetPos(x, ART_Y)
        mark.grip:SetSize(w, ART_H)
    end
end

-- Everything that shows the design's details: the labels, the pack's line, the counts.
local function refreshDetails()
    if content == nil then
        return
    end
    local art = design.art
    for side, label in pairs({ front = "Front", back = "Back" }) do
        setText(widgets[side .. "Start"], string.format("%s: %d%% along the picture", label,
            math.floor(art[side] / (1 - PackArt.WINDOW) * 100 + 0.5)))
    end
    local count = cardCount()
    setText(widgets.cardCount, string.format("%d card%s", count, count == 1 and "" or "s"),
        count > 0 and GREEN or RED)
    -- The name box shows the made-up name until a name is typed (then it is left alone, so
    -- clearing it while typing doesn't fill it again).
    if not design.nameTouched then
        setField(widgets.nameField, packName())
    end
    setText(widgets.packId, "id: " .. packId())
    setField(widgets.block, packLine())
end

-- Shows the chosen login screen: the whole picture, the boxes and both sides of the pack.
local function showScreen()
    if content == nil then
        return
    end
    clearParts(artParts)
    if screens == nil then
        setText(widgets.screenName, scan and string.format("Finding pictures... (%d)", scan.nextId) or "")
        return
    end
    if design.art.screen == nil then
        design.art.screen = shownScreens[1] or screens[1]
    end
    local position = positionOf(design.art.screen)
    setText(widgets.screenName, string.format("%s of %d shown, %d in all%s", position and tostring(position) or "-",
        #shownScreens, #screens, #shownScreens > MAX_LISTED and " (search to list them all)" or ""))
    local tiles = PackArt.tiles(design.art.screen)
    if tiles ~= nil then
        PackArt.drawPicture(widgets.artLayer, artParts, tiles, 0, 0, ART_W, ART_H)
    end
    placeMark("front")
    placeMark("back")
    redrawSide("front")
    redrawSide("back")
    redrawTop()
    refreshDetails()
end

local function chooseScreen(screen)
    log("pack maker: picture", screen)
    design.art.screen = screen
    if widgets.screenDropdown ~= nil then
        widgets.screenDropdown.select(screen)
    end
    showScreen()
end


-- Back/Next go through the screens matching the search.
local function stepScreen(by)
    if #shownScreens == 0 then
        return
    end
    local position = positionOf(design.art.screen) or 0
    chooseScreen(shownScreens[(position - 1 + by) % #shownScreens + 1])
end

-- -------------------------------------------------------------------------------------------
-- Dragging the Front and Back boxes
-- -------------------------------------------------------------------------------------------

local function mouseX()
    local ok, x = pcall(function()
        if not Mouse.IsAvailable() then
            return nil
        end
        return Mouse.GetPosition().x
    end)
    return ok and x or nil
end

local function updateDrag()
    if drag == nil then
        return
    end
    local x = mouseX()
    if x == nil then
        return
    end
    design.art[drag.side] = math.max(0, math.min(1 - PackArt.WINDOW, drag.start + (x - drag.mouseX) / ART_W))
    placeMark(drag.side)
    refreshDetails()
    drag.dirty = true
end

local function makeMark(side, colour, label)
    local mark = {}
    mark.box = ui.Rectangle.new(content)
    mark.box.fill = false
    mark.box.outlineThickness = 2
    mark.box.colour = colour
    mark.label = ui.Text.new(content)
    mark.label:SetSize(60, 20)
    mark.label.font = id.Font.MUSEO_SANS_15PT_REGULAR
    mark.label.colour = colour
    mark.label.isShadowed = true
    mark.label.content = label
    mark.grip = ui.Layer.new(content)
    mark.grip.clickthrough = false
    mark.grip:Subscribe(ui.Hook.ONCLICK, function()
        if drag ~= nil then
            return
        end
        local x = mouseX()
        if x == nil then
            return
        end
        drag = { side = side, mouseX = x, start = design.art[side], since = 0, dirty = false }
        mark.grip:SetPos(0, 0)
        mark.grip:SetSize(0, 0, 1, 1)
        pcall(function() mark.grip:MoveToFront() end)
    end)
    mark.grip:Subscribe(ui.Hook.ONHOLD, updateDrag)
    mark.grip:Subscribe(ui.Hook.ONRELEASE, function()
        if drag == nil or drag.side ~= side then
            return
        end
        updateDrag()
        drag = nil
        placeMark(side)
        redrawSide(side)
    end)
    marks[side] = mark
end

-- Every frame while the window is open: finds the login screens, and keeps the dragged side's
-- pack following its box.
local function onDraw(e)
    if scan ~= nil then
        local done, loginBases = scanStep()
        if done then
            matchNames(loginBases)
            applySearch()
            showScreen()
        elseif scan.nextId % (SCAN_PER_FRAME * 5) == 0 then
            showScreen()     -- shows the progress
        end
    end
    if drag ~= nil and drag.dirty then
        local ok, dt = pcall(function() return e.timeDeltaSecs end)
        drag.since = drag.since + ((ok and type(dt) == "number") and dt or 0.016)
        if drag.since >= DRAG_REDRAW_SECONDS then
            drag.since, drag.dirty = 0, false
            redrawSide(drag.side)
        end
    end
end

-- -------------------------------------------------------------------------------------------
-- Controls
-- -------------------------------------------------------------------------------------------

-- A PrettyUI sprite button (a plain button labelled `fallback` without PrettyUI).
local function icon(sprite, x, y, tooltip, fallback, onPress)
    return Kit.iconButton(content, sprite, x, y, onPress, tooltip, fallback, 70)
end

-- A row that moves and resizes `item()` (the name or the logo): four arrows, then Smaller and
-- Bigger (PrettyUI has no minus sprite, so these two are words).
local function moveButtons(y, item)
    local function change(fn)
        return function()
            local target = item()
            if target ~= nil then
                fn(target)
                redrawTop()
                refreshDetails()
            end
        end
    end
    local function at(column) return LEFT_X + column * (ICON + ICON_GAP) end
    icon("ARROW_LEFT", at(0), y + 3, "Move left", "Left", change(function(t) t.x = t.x - MOVE_STEP end))
    icon("ARROW_RIGHT", at(1), y + 3, "Move right", "Right", change(function(t) t.x = t.x + MOVE_STEP end))
    icon("ARROW_UP", at(2), y + 3, "Move up", "Up", change(function(t) t.y = t.y - MOVE_STEP end))
    icon("ARROW_DOWN", at(3), y + 3, "Move down", "Down", change(function(t) t.y = t.y + MOVE_STEP end))
    local sizeX = at(4) + 10
    Kit.buttonAt(content, "Smaller", sizeX, y, 140, 30, change(function(t) t.w = math.max(20, t.w - SIZE_STEP) end))
    Kit.buttonAt(content, "Bigger", sizeX + 148, y, 140, 30,
        change(function(t) t.w = math.min(PackArt.W + 60, t.w + SIZE_STEP) end))
end

-- Picks the logo (a sprite name from PackArt.LOGOS, or "none"). The logo keeps its place when
-- it changes, including through "none".
local function chooseLogo(sprite)
    local art = design.art
    if art.logo ~= nil then
        lastLogoPlace = { x = art.logo.x, y = art.logo.y, w = art.logo.w }
    end
    if sprite == "none" then
        art.logo = nil
    else
        local place = lastLogoPlace or defaults(nil).logo
        art.logo = { sprite = sprite, x = place.x, y = place.y, w = place.w }
    end
    redrawTop()
    refreshDetails()
end

local function setStatus(text, colour)
    setText(widgets.status, text, colour or GREY)
end

local function saveDesign()
    if design.art.screen == nil then
        setStatus("Choose a login screen first", RED)
        return
    end
    local saved = savedDesigns()
    local key = packId()
    saved[key] = { name = packName(), region = design.region, art = copy(design.art) }
    local ok, err = pcall(function() return PersistentDB:SetStructuredData(DB_KEY, saved) end)
    if ok and err ~= false then
        setStatus("Saved " .. key, GREEN)
        log("pack maker: saved", key, "-", packLine())
        if widgets.savedDropdown ~= nil then
            widgets.savedDropdown.set(savedEntries(), key)
        end
        widgets.savedChoice = key
    else
        setStatus("Saving failed", RED)
        log("pack maker: saving", key, "failed:", tostring(err))
    end
end

-- Puts a saved design back in the window.
local function loadDesign(key)
    local saved = savedDesigns()[key]
    if saved == nil or type(saved.art) ~= "table" then
        setStatus("Nothing saved as " .. tostring(key), RED)
        return
    end
    design = freshDesign()
    local art = defaults(saved.art.screen)
    for k, v in pairs(saved.art) do
        art[k] = copy(v)
    end
    design.art = art
    design.name, design.nameTouched = saved.name or "", saved.name ~= nil
    design.region, design.regionTouched = saved.region or design.region, true
    widgets.titleDropdown.select(art.name.title)
    widgets.regionDropdown.select(design.region)
    widgets.screenDropdown.select(art.screen)
    widgets.logoDropdown.select(art.logo and art.logo.sprite or "none")
    setField(widgets.nameField, packName())
    setStatus("Loaded " .. key, GREEN)
    showScreen()
end

local function deleteDesign(key)
    local saved = savedDesigns()
    if key == nil or saved[key] == nil then
        setStatus("Choose a saved design first", RED)
        return
    end
    saved[key] = nil
    pcall(function() PersistentDB:SetStructuredData(DB_KEY, saved) end)
    widgets.savedDropdown.set(savedEntries(), nil)
    widgets.savedChoice = nil
    setStatus("Deleted " .. key, GREY)
end

-- -------------------------------------------------------------------------------------------
-- The window
-- -------------------------------------------------------------------------------------------

function PackMaker.show()
    if window ~= nil then
        return
    end
    widgets, marks, packs, artParts = {}, {}, {}, {}
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Pack Maker", WIN_W, WIN_H + Kit.titleBarHeight(),
        function() PackMaker.hide() end, 0.15, 0.04, false, false)

    -- 1. Login screen: search, drop-down, steps, the picture.
    section("1. Picture (login screens and cutscenes)", LEFT_X, 4, LEFT_W)
    widgets.searchField = field(LEFT_X, 28, 150, 40, function(text)
        -- The box also reports a "change" when it loses focus; refilling the drop-down then
        -- would reset it while it is being clicked, so only a real change counts.
        if text == search then
            return
        end
        search = text
        applySearch()
        showScreen()
    end)
    setField(widgets.searchField, search)
    icon("ARROW_LEFT", LEFT_X, 64, "Previous picture", "Back", function() stepScreen(-1) end)
    icon("ARROW_RIGHT", LEFT_X + ICON + ICON_GAP, 64, "Next picture", "Next", function() stepScreen(1) end)
    widgets.screenName = caption("", LEFT_X + 2 * (ICON + ICON_GAP) + 10, 67, LEFT_W - 70)
    widgets.artLayer = ui.Layer.new(content)
    widgets.artLayer:SetPos(ART_X, ART_Y)
    widgets.artLayer:SetSize(ART_W, ART_H)
    caption("Drag the Front and Back boxes to choose what each side shows.", LEFT_X, ART_Y + ART_H + 4, LEFT_W)

    -- 2. Pack name and 3. Logo
    local nameY = ART_Y + ART_H + 30
    section("2. Pack name", LEFT_X, nameY, LEFT_W)
    moveButtons(nameY + 58, function() return design.art.name end)
    local logoY = nameY + 100
    section("3. Logo", LEFT_X, logoY, LEFT_W)
    moveButtons(logoY + 58, function() return design.art.logo end)

    -- The pack, front and back.
    Kit.text(content, FRONT_X, 14, 200, 20, "Front", FRONT_COLOUR)
    Kit.text(content, BACK_X, 14, 200, 20, "Back", BACK_COLOUR)
    packs.front = PackArt.new(content, "front", PACK_H)
    packs.front.root:SetPos(FRONT_X, PACK_Y)
    packs.back = PackArt.new(content, "back", PACK_H)
    packs.back.root:SetPos(BACK_X, PACK_Y)
    widgets.frontStart = caption("", FRONT_X, PACK_Y + PACK_H + 6, 210)
    widgets.backStart = caption("", BACK_X, PACK_Y + PACK_H + 6, 210)

    -- 4. Cards
    local cardsY = PACK_Y + PACK_H + 34
    section("4. Cards in the pack", RIGHT_X, cardsY, RIGHT_W)
    caption("Region", RIGHT_X, cardsY + 28, 60)
    widgets.cardCount = caption("", RIGHT_X + 280, cardsY + 28, 140)

    -- 5. Save
    local saveY = cardsY + 64
    section("5. Save", RIGHT_X, saveY, RIGHT_W)
    widgets.nameField = field(RIGHT_X, saveY + 24, 220, 40, function(text)
        -- The client can report the code's own text late, as if typed; that isn't a new name.
        if text == packName() then
            return
        end
        design.name, design.nameTouched = text, text ~= ""
        refreshDetails()
    end)
    widgets.packId = caption("", RIGHT_X + 230, saveY + 30, 200)
    -- (PrettyUI draws this button about 124 wide whatever it is given, so the status starts after that.)
    Kit.buttonAt(content, "Save", RIGHT_X, saveY + 58, 124, 30, saveDesign, "positive")
    widgets.status = caption("", RIGHT_X + 136, saveY + 64, RIGHT_W - 136)
    caption("Saved", RIGHT_X, saveY + 102, 60)
    icon("IMPORT", RIGHT_X + 370, saveY + 100, "Load this design", "Load", function()
        if widgets.savedChoice then loadDesign(widgets.savedChoice) else setStatus("Choose a saved design first", RED) end
    end)
    icon("TRASH", RIGHT_X + 370 + ICON + ICON_GAP, saveY + 100, "Delete this design", "Delete",
        function() deleteDesign(widgets.savedChoice) end)
    widgets.block = Kit.inputField(content, RIGHT_X, saveY + 134, RIGHT_W, 28, 1200, false)
    caption("To put it in the game: click the box, Ctrl+A, Ctrl+C,", RIGHT_X, saveY + 166, RIGHT_W, BLUE)
    caption("and paste it into the list in deck/packs.lua.", RIGHT_X, saveY + 184, RIGHT_W, BLUE)

    -- The boxes over the picture, then the drop-downs last so their lists open on top.
    makeMark("back", BACK_COLOUR, "Back")
    makeMark("front", FRONT_COLOUR, "Front")

    -- The picture list can't be typed in (the search box does that); it is sorted by name.
    widgets.screenDropdown = Kit.dropdown(content, LEFT_X + 160, 28, LEFT_W - 160, 28, {}, nil, chooseScreen, true)

    local titleEntries, regionEntries = {}, {}
    for _, t in ipairs(PackArt.TITLES) do
        titleEntries[#titleEntries + 1] = { label = t.text, value = t.id }
    end
    for _, word in ipairs(Cards.tagWords.regions) do
        regionEntries[#regionEntries + 1] = { label = titleText(word), value = word }
    end
    widgets.titleDropdown = Kit.dropdown(content, LEFT_X, nameY + 24, DROPDOWN_W, 28, titleEntries,
        design.art.name.title, function(titleId)
            design.art.name.title = titleId
            -- The region follows the title (the titles are the regions, made by
            -- dev/make_pack_art.py) until it is set by hand.
            if not design.regionTouched then
                design.region = titleId
                widgets.regionDropdown.select(titleId)
            end
            redrawTop()
            refreshDetails()
        end)
    widgets.regionDropdown = Kit.dropdown(content, RIGHT_X + 60, cardsY + 24, 210, 28, regionEntries, design.region,
        function(word)
            design.region, design.regionTouched = word, true
            refreshDetails()
        end)
    widgets.savedDropdown = Kit.dropdown(content, RIGHT_X + 60, saveY + 98, 300, 28, savedEntries(), nil,
        function(key) widgets.savedChoice = key end, true)
    local logoEntries = {}
    for _, l in ipairs(PackArt.LOGOS) do
        logoEntries[#logoEntries + 1] = { label = LOGO_LABELS[l.sprite] or l.sprite, value = l.sprite }
    end
    logoEntries[#logoEntries + 1] = { label = "No logo", value = "none" }
    widgets.logoDropdown = Kit.dropdown(content, LEFT_X, logoY + 24, DROPDOWN_W, 28, logoEntries,
        design.art.logo and design.art.logo.sprite or "none", chooseLogo)

    if screens == nil and scan == nil then
        scan = { nextId = 0, misses = 0, tiles = {}, singles = {} }
    end
    Event.Draw.Subscribe(SUBSCRIBER, onDraw)
    applySearch()
    showScreen()
    refreshDetails()
end

function PackMaker.hide()
    pcall(function() Event.Draw.Unsubscribe(SUBSCRIBER) end)
    drag = nil
    for _, key in ipairs({ "screenDropdown", "titleDropdown", "logoDropdown", "regionDropdown", "savedDropdown" }) do
        if widgets[key] ~= nil then
            widgets[key].destroy()
        end
    end
    clearParts(artParts)
    for _, pack in pairs(packs) do
        PackArt.destroy(pack)
    end
    packs, marks = {}, {}
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content = nil, nil
    widgets = {}
end

function PackMaker.toggle()
    if window ~= nil then
        PackMaker.hide()
    else
        PackMaker.show()
    end
end

return PackMaker
