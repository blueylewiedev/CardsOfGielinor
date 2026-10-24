-- builder.lua
-- The Card Builder: a developer window for making a new card without knowing how the code
-- works. You fill in the details, tune how the NPC is framed, and the window gives you the
-- finished card block to paste into a deck file. It is built so that someone who has only
-- cloned the repository can add a card and send it back as a pull request.
--
-- The window has five parts:
--   1. Card details  : the NPC (by config name), the card's name and id, description, suggested
--                      rarity, tags and the deck file it belongs in
--   2. Live preview  : the card as it will look, in each finish
--   3. Tune the art  : body or head model, camera, animation
--   4. Checks        : what is wrong or worth a look (NPC not found, id taken, odd tag words)
--   5. Card block    : the text to paste into the deck file. "Show in Output window" puts it
--                      in the Output window, one line per row, where it can be selected and
--                      copied (the plugin API has no clipboard).
--
-- Nothing is written to any file. The card only exists in this window until it is pasted into
-- a deck file by hand. What was typed is remembered while the plugin is running, so closing and
-- reopening the window does not lose it. Only used by the developer tools (the dev folder).

local Kit = require("ui/kit")
local Cards = require("core/cards")
local CardView = require("ui/cardview")
local OutputWindow = require("dev/outputwindow")
local Nearby = require("dev/nearby")
local NpcSearch = require("dev/npcsearch")

local Builder = {}

-- The card the window is working on. It outlives the window.
local draft = {
    npc = "",              -- the NPC's config name, e.g. FATHER_AERECK; this sets the model
    name = "",             -- the name printed on the card
    nameTouched = false,   -- true once the name has been typed (so it stops following the NPC)
    cardId = "",           -- the card's id; follows the name until it is typed
    idTouched = false,
    desc = "",
    rarity = "common",
    skills = "", towns = "", category = "",     -- tags, as typed (words separated by commas)
    deck = 1,              -- which deck file (index into Cards.sets)
    finish = "normal",     -- which finish the preview shows
    body = true,           -- body model (true) or head model (false)
    cam = nil,             -- camera values chosen with the buttons, or nil for the defaults
    anim = nil,            -- animation (sequence) id, or nil
}

-- ---------------------------------------------------------------------------------------------
-- Text rules
-- ---------------------------------------------------------------------------------------------

-- The longest description that fits on a card. (The longest one in the deck is 45.)
local MAX_DESC = 60

-- The card id rule: lower case, spaces become underscores, anything else that is not a letter or
-- digit is dropped. "Sir Amik Varze" becomes sir_amik_varze.
function Builder.slug(name)
    local text = string.lower(name or "")
    text = string.gsub(text, "%s+", "_")
    text = string.gsub(text, "[^a-z0-9_]", "")
    text = string.gsub(text, "_+", "_")
    text = string.gsub(text, "^_", "")
    text = string.gsub(text, "_$", "")
    return text
end

-- A tag word must be lower case letters, digits and underscores, starting with a letter.
function Builder.validTagWord(word)
    return string.match(word, "^[a-z][a-z0-9_]*$") ~= nil
end

-- Splits "prayer, thieving" into { "prayer", "thieving" }, lower case, without repeats. Commas
-- and spaces both separate words.
function Builder.parseWords(text)
    local words, seen = {}, {}
    for word in string.gmatch(string.lower(text or ""), "[^,%s]+") do
        if not seen[word] then
            seen[word] = true
            words[#words + 1] = word
        end
    end
    return words
end

-- True if a card (live or draft) already has this id.
local function idTaken(cardId)
    if Cards.byId[cardId] ~= nil then
        return true
    end
    for _, card in ipairs(Cards.drafts) do
        if card.id == cardId then
            return true
        end
    end
    return false
end

-- `base`, or base_2, base_3... if it is already taken.
function Builder.freeId(base)
    if base == "" or not idTaken(base) then
        return base
    end
    local n = 2
    while idTaken(base .. "_" .. n) do
        n = n + 1
    end
    return base .. "_" .. n
end

-- Looks up an NPC by config name. Returns its numeric id and in-game name, or nil if the client
-- does not know the name.
function Builder.lookupNpc(configName)
    if configName == nil or configName == "" then
        return nil
    end
    local ok, npcId = pcall(function() return id.NPC[configName] end)
    if not ok or not Cards.isValidNpcId(npcId) then
        return nil
    end
    local displayName = nil
    pcall(function() displayName = tostring(config.NPC.FromID(npcId).name) end)
    return npcId, displayName
end

-- Words used in a tag kind by cards that already exist, as a set.
local function existingWords(tagKind)
    local used = {}
    local function scan(list)
        for _, card in ipairs(list) do
            for _, word in ipairs((card.tags or {})[tagKind] or {}) do
                used[word] = true
            end
        end
    end
    scan(Cards.list)
    scan(Cards.drafts)
    return used
end

-- ---------------------------------------------------------------------------------------------
-- The checks and the card block (both are worked out from `draft`)
-- ---------------------------------------------------------------------------------------------

local TAG_KINDS = { "towns", "skills", "category" }   -- the order they are written in

-- The words typed for a tag kind, split apart.
local function tagWords(tagKind)
    return Builder.parseWords(draft[tagKind])
end

-- The camera values currently on the card, from the shown view if there is one.
local view = nil
local function currentCam()
    if view ~= nil and view.cam ~= nil then
        return view.cam
    end
    return nil
end

local function quote(text)
    local escaped = string.gsub(text, "\\", "\\\\")
    escaped = string.gsub(escaped, '"', '\\"')
    return '"' .. escaped .. '"'
end

-- The `art = { ... }` text. Only values that differ from the defaults are written.
local function artLine()
    local parts = { "npc = " .. quote(draft.npc) }
    if not draft.body then
        parts[#parts + 1] = "body = false"
    end
    if draft.anim ~= nil then
        parts[#parts + 1] = "anim = " .. string.format("%.0f", draft.anim)
    end
    local cam = currentCam()
    if cam ~= nil then
        local defaults = CardView.CAMERA_DEFAULTS[draft.body and "body" or "head"]
        local camParts = {}
        for _, field in ipairs({ "yaw", "pitch", "dist", "fov", "ty", "tx" }) do
            local value, default = cam[field], defaults[field]
            if value ~= nil and math.abs(value - default) >= 0.005 then
                if field == "yaw" or field == "pitch" then
                    camParts[#camParts + 1] = string.format("%s = %.2f", field, value)
                else
                    camParts[#camParts + 1] = string.format("%s = %.0f", field, value)
                end
            end
        end
        if #camParts > 0 then
            parts[#parts + 1] = "cam = { " .. table.concat(camParts, ", ") .. " }"
        end
    end
    return "art = { " .. table.concat(parts, ", ") .. " },"
end

-- The card block, as a list of lines, in the layout the deck files use. Tag words that are not
-- on Cards.tagWords yet are listed in comment lines at the end, since they must be added there.
function Builder.blockLines()
    local lines = {
        "{",
        "    id = " .. quote(draft.cardId) .. ", name = " .. quote(draft.name)
            .. ", rarity = " .. quote(draft.rarity) .. ",",
        "    desc = " .. quote(draft.desc) .. ",",
        "    " .. artLine(),
    }
    local tagParts = {}
    for _, tagKind in ipairs(TAG_KINDS) do
        local words = tagWords(tagKind)
        if #words > 0 then
            local quoted = {}
            for _, word in ipairs(words) do
                quoted[#quoted + 1] = quote(word)
            end
            tagParts[#tagParts + 1] = tagKind .. " = { " .. table.concat(quoted, ", ") .. " }"
        end
    end
    if #tagParts > 0 then
        lines[#lines + 1] = "    tags = { " .. table.concat(tagParts, ", ") .. " },"
    end
    lines[#lines + 1] = "},"

    -- New words for tag kinds that have a fixed list.
    for _, tagKind in ipairs(TAG_KINDS) do
        local allowed = Cards.tagWords[tagKind]
        if allowed ~= nil then
            local known = {}
            for _, word in ipairs(allowed) do known[word] = true end
            for _, word in ipairs(tagWords(tagKind)) do
                if not known[word] and Builder.validTagWord(word) then
                    lines[#lines + 1] = "-- Also add " .. quote(word) .. " to Cards.tagWords." .. tagKind
                        .. " in core/cards.lua"
                end
            end
        end
    end
    return lines
end

-- What is right and wrong with the card so far. Returns a list of { level, text } where level
-- is "ok", "note" (worth a look) or "fix" (will not load). `ready` is true when nothing needs fixing.
function Builder.checks()
    local list = {}
    local function add(level, text)
        list[#list + 1] = { level = level, text = text }
    end

    -- The NPC.
    if draft.npc == "" then
        add("fix", "Enter the NPC's config name")
    else
        local npcId, displayName = Builder.lookupNpc(draft.npc)
        if npcId == nil then
            add("fix", "NPC " .. draft.npc .. " was not found")
        else
            add("ok", "NPC found: " .. tostring(displayName or draft.npc))
        end
    end

    -- Name and id.
    if draft.name == "" then
        add("fix", "Give the card a name")
    end
    if draft.cardId == "" then
        add("fix", "The card needs an id")
    elseif Builder.slug(draft.cardId) ~= draft.cardId then
        add("fix", "The id may only use lower case letters, digits and underscores")
    elseif idTaken(draft.cardId) then
        add("fix", "The id " .. draft.cardId .. " is already used by another card")
    else
        add("ok", "The id " .. draft.cardId .. " is free")
    end

    -- Description.
    if draft.desc == "" then
        add("fix", "Write a short description")
    elseif #draft.desc > MAX_DESC then
        add("fix", "The description is " .. #draft.desc .. " letters; keep it to " .. MAX_DESC)
    else
        add("ok", "The description fits the card")
    end

    -- Tags.
    local tagProblem, tagNotes = nil, {}
    for _, tagKind in ipairs(TAG_KINDS) do
        local allowed = Cards.tagWords[tagKind]
        local known = {}
        for _, word in ipairs(allowed or {}) do known[word] = true end
        local used = existingWords(tagKind)
        for _, word in ipairs(tagWords(tagKind)) do
            if not Builder.validTagWord(word) then
                tagProblem = tagProblem or ("The tag " .. word .. " must be lower case letters, digits or underscores")
            elseif allowed ~= nil and not known[word] then
                tagNotes[#tagNotes + 1] = "New " .. tagKind .. " tag " .. word .. " (add it to Cards.tagWords)"
            elseif allowed == nil and not used[word] then
                tagNotes[#tagNotes + 1] = "New " .. tagKind .. " tag " .. word
            end
        end
    end
    if tagProblem ~= nil then
        add("fix", tagProblem)
    elseif #tagNotes > 0 then
        add("note", tagNotes[1] .. (#tagNotes > 1 and (" and " .. (#tagNotes - 1) .. " more") or ""))
    else
        add("ok", "The tags look right")
    end

    if draft.anim == nil then
        add("note", "No animation set (optional)")
    end

    local ready = true
    for _, item in ipairs(list) do
        if item.level == "fix" then
            ready = false
        end
    end
    return list, ready
end

-- ---------------------------------------------------------------------------------------------
-- The window
-- ---------------------------------------------------------------------------------------------

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.7, 0.7, 0.7, 1)
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)
local GREEN = Vector4.new(0.5, 0.82, 0.55, 1)
local AMBER = Vector4.new(0.94, 0.70, 0.35, 1)
local RED = Vector4.new(0.91, 0.49, 0.43, 1)
local LEVEL_COLOUR = { ok = GREEN, note = AMBER, fix = RED }
local LEVEL_PREFIX = { ok = "OK   ", note = "Note ", fix = "Fix  " }

local STEP, GAP = 36, 4
local PREVIEW_SCALE = 1.5
local CARD_W, CARD_H = math.floor(160 * PREVIEW_SCALE), math.floor(224 * PREVIEW_SCALE)

-- Left column (card details), middle (preview), right (art), then the bottom strip.
local LEFT_X, LEFT_W = 10, 470
local MID_X, MID_W = 500, 260
local RIGHT_X, RIGHT_W = 780, 300
local HALF_W = 148
local BOTTOM_Y = 560
local WIN_W = RIGHT_X + RIGHT_W + 10
local WIN_H = BOTTOM_Y + 215

local window, content = nil, nil
local widgets = {}          -- the parts that change after the window is built
local settingField = false  -- true while the code (not the player) changes a text box
local checkParts = {}       -- the texts of the checks and the block, rebuilt on every change
local pending = nil         -- seconds until the card is redrawn (it waits for typing to stop)
local REDRAW_DELAY = 0.6

local function section(title, x, y, w)
    Kit.text(content, x, y, w, 20, title, GOLD, ui.AlignMode.TOPLEFT)
end

local function caption(text, x, y, w)
    Kit.text(content, x, y, w, 18, text, GREY, ui.AlignMode.TOPLEFT)
end

-- A box to type in. `onChange(text)` is called as the player types.
local function field(x, y, w, maxLength, value, onChange)
    local box = Kit.inputField(content, x, y, w, 28, maxLength, false)
    settingField = true
    box.content = value or ""
    settingField = false
    box:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        if not settingField then
            onChange(box.content)
        end
    end)
    return box
end

-- Puts text in a box without it counting as the player typing.
local function setField(box, text)
    if box == nil then
        return
    end
    settingField = true
    box.content = text
    settingField = false
end

local function clearParts(list)
    for i = #list, 1, -1 do
        pcall(function() list[i]:Destroy() end)
        list[i] = nil
    end
end

-- Redraws the checks and the card block (cheap, so it is done on every change).
local function refreshChecks()
    if content == nil then
        return
    end
    clearParts(checkParts)
    local list, ready = Builder.checks()
    checkParts[#checkParts + 1] = Kit.text(content, LEFT_X, BOTTOM_Y + 6, LEFT_W, 20, "4. Checks", GOLD,
        ui.AlignMode.TOPLEFT)
    for i, item in ipairs(list) do
        if i <= 7 then
            checkParts[#checkParts + 1] = Kit.text(content, LEFT_X, BOTTOM_Y + 28 + (i - 1) * 20, LEFT_W, 18,
                LEVEL_PREFIX[item.level] .. item.text, LEVEL_COLOUR[item.level], ui.AlignMode.TOPLEFT)
        end
    end
    checkParts[#checkParts + 1] = Kit.text(content, MID_X, BOTTOM_Y + 6, 400, 20,
        ready and "5. Your card block (ready)" or "5. Your card block (fix the checks first)", GOLD,
        ui.AlignMode.TOPLEFT)
    local lines = Builder.blockLines()
    for i, text in ipairs(lines) do
        if i <= 8 then
            checkParts[#checkParts + 1] = Kit.text(content, MID_X, BOTTOM_Y + 28 + (i - 1) * 18, WIN_W - MID_X - 10, 18,
                text, ready and WHITE or GREY, ui.AlignMode.TOPLEFT)
        end
    end
end

-- Redraws the card in the middle of the window from `draft`.
local function showCard()
    if content == nil then
        return
    end
    pending = nil
    if view ~= nil then
        pcall(function() view.root:Destroy() end)
        view = nil
    end
    local rarity = Cards.rarities[draft.rarity] and draft.rarity or "common"
    -- The card is given its own id, so saved tuning for a real card never applies to it.
    local card = {
        id = "builder_draft", name = draft.name, rarity = rarity, desc = draft.desc,
        art = { npc = draft.npc, body = draft.body, anim = draft.anim, cam = draft.cam },
    }
    local npcId = Builder.lookupNpc(draft.npc)
    if npcId == nil then
        card.art.npc = ""      -- shows the empty art box without asking the client for a bad name
    end
    view = CardView.create(content, card, { finish = draft.finish, scale = PREVIEW_SCALE })
    view.root:SetPos(MID_X + (MID_W - CARD_W) // 2, 30)
    if widgets.modelButton ~= nil then
        Kit.setLabel(widgets.modelButton, draft.body and "Model: Body" or "Model: Head")
    end
    refreshChecks()
end

-- Redraws the card shortly after typing stops, so every key press does not rebuild the model.
local function soon()
    pending = REDRAW_DELAY
    refreshChecks()
end

local function onDraw(e)
    if pending == nil then
        return
    end
    local ok, dt = pcall(function() return e.timeDeltaSecs end)
    pending = pending - ((ok and type(dt) == "number") and dt or 0.016)
    if pending <= 0 then
        showCard()
    end
end
Event.Draw.Subscribe("cardcollector_builder", onDraw)

-- Fills in the id from the name, unless the id has been typed by hand.
local function followName()
    if not draft.idTouched then
        draft.cardId = Builder.freeId(Builder.slug(draft.name))
        setField(widgets.idField, draft.cardId)
    end
end

-- Chooses the NPC. A new NPC starts again with the default camera and no animation, and fills
-- in the name from the NPC's in-game name if the name has not been typed.
local function setNpc(configName)
    configName = string.upper((string.gsub(configName or "", "%s", "")))
    if configName == draft.npc then
        return
    end
    draft.npc = configName
    draft.cam = nil
    draft.anim = nil
    setField(widgets.animField, "")
    local npcId, displayName = Builder.lookupNpc(configName)
    if widgets.npcStatus ~= nil then
        widgets.npcStatus.content = npcId ~= nil and "Found" or (configName == "" and "" or "Not found")
    end
    if npcId ~= nil and displayName ~= nil and not draft.nameTouched then
        draft.name = displayName
        setField(widgets.nameField, displayName)
        followName()
    end
    soon()
end

-- Changes the camera with `change(cam)`, applies it and keeps the values for redraws.
local function withCamera(change)
    local cam = currentCam()
    if cam == nil then
        return
    end
    change(cam)
    CardView.applyCamera(cam)
    draft.cam = { yaw = cam.yaw, pitch = cam.pitch, dist = cam.dist, fov = cam.fov, ty = cam.ty, tx = cam.tx }
    refreshChecks()
end

local function setAnim(animId)
    draft.anim = animId
    if view ~= nil and view.model ~= nil then
        CardView.playAnimation(view.model, animId)
    end
    refreshChecks()
end

local function stepAnim(change)
    local nextId = math.max(0, (draft.anim or 0) + change)
    setAnim(nextId)
    setField(widgets.animField, string.format("%.0f", nextId))
end

local function styleRarityButtons()
    for key, button in pairs(widgets.rarityButtons) do
        Kit.setStyle(button, key == draft.rarity and "positive" or "neutral")
    end
end

local function deckLabel()
    return "Deck: " .. tostring(Cards.sets[draft.deck] or "?")
end

function Builder.show()
    if window ~= nil then
        return
    end
    widgets = { rarityButtons = {} }
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Card Builder", WIN_W, WIN_H + Kit.titleBarHeight(),
        function() Builder.hide() end, 0.15, 0.04, false, true)

    -- 1. Card details ---------------------------------------------------------------------
    section("1. Card details", LEFT_X, 4, LEFT_W)

    caption("What kind of card?", LEFT_X, 26, LEFT_W)
    Kit.buttonAt(content, "NPC", LEFT_X, 44, HALF_W, 30, function() end, "positive")
    local itemButton = Kit.buttonAt(content, "Item (soon)", LEFT_X + HALF_W + GAP, 44, HALF_W, 30, function() end)
    Kit.setEnabled(itemButton, false)

    caption("NPC config name (this sets the model)", LEFT_X, 82, LEFT_W)
    widgets.npcField = field(LEFT_X, 100, 250, 60, draft.npc, setNpc)
    local npcId = Builder.lookupNpc(draft.npc)
    widgets.npcStatus = Kit.text(content, LEFT_X + 260, 100, 110, 28,
        npcId ~= nil and "Found" or (draft.npc == "" and "" or "Not found"), GREY, ui.AlignMode.TOPLEFT)
    -- Both lists hand the NPC that was picked back to this window.
    local function usePicked(npc)
        setField(widgets.npcField, npc.configName)
        setNpc(npc.configName)
    end
    Kit.buttonAt(content, "Nearby NPCs", LEFT_X, 134, 225, 30, function()
        Nearby.setPicker(usePicked)
        Nearby.show()
    end)
    Kit.buttonAt(content, "Search NPCs", LEFT_X + 235, 134, 225, 30, function()
        NpcSearch.setPicker(usePicked)
        NpcSearch.show()
    end)

    caption("Card name", LEFT_X, 176, 225)
    caption("Card id (follows the name)", LEFT_X + 235, 176, 225)
    widgets.nameField = field(LEFT_X, 194, 225, 40, draft.name, function(text)
        draft.name = text
        draft.nameTouched = text ~= ""
        followName()
        soon()
    end)
    widgets.idField = field(LEFT_X + 235, 194, 225, 40, draft.cardId, function(text)
        draft.cardId = text
        draft.idTouched = text ~= ""
        soon()
    end)

    caption("Description (up to " .. MAX_DESC .. " letters)", LEFT_X, 240, LEFT_W)
    widgets.descField = field(LEFT_X, 258, LEFT_W - 10, 120, draft.desc, function(text)
        draft.desc = text
        soon()
    end)

    caption("Suggested rarity (we may change it in review)", LEFT_X, 296, LEFT_W)
    for i, key in ipairs(Cards.rarityOrder) do
        local column = (i - 1) % 3
        local row = (i - 1) // 3
        widgets.rarityButtons[key] = Kit.buttonAt(content, Cards.rarities[key].name,
            LEFT_X + column * 156, 314 + row * STEP, 150, 30, function()
                draft.rarity = key
                styleRarityButtons()
                showCard()
            end)
    end
    styleRarityButtons()

    caption("Tags: words separated by commas", LEFT_X, 392, LEFT_W)
    local tagY = 410
    for _, tagKind in ipairs({ "skills", "towns", "category" }) do
        Kit.text(content, LEFT_X, tagY, 74, 28, tagKind, GREY, ui.AlignMode.TOPLEFT)
        widgets[tagKind .. "Field"] = field(LEFT_X + 78, tagY, LEFT_W - 88, 80, draft[tagKind], function(text)
            draft[tagKind] = text
            soon()
        end)
        tagY = tagY + 34
    end

    widgets.deckButton = Kit.buttonAt(content, deckLabel(), LEFT_X, 520, LEFT_W - 10, 30, function()
        draft.deck = draft.deck % #Cards.sets + 1
        Kit.setLabel(widgets.deckButton, deckLabel())
        refreshChecks()
    end)

    -- 2. Live preview -----------------------------------------------------------------------
    section("2. Live preview", MID_X, 4, MID_W)
    local finishNames = { normal = "Normal", reverse = "Reverse holo", holo = "Holo" }
    local finishNext = { normal = "reverse", reverse = "holo", holo = "normal" }
    widgets.finishButton = Kit.buttonAt(content, "Finish: " .. finishNames[draft.finish], MID_X, 30 + CARD_H + 10,
        MID_W - 10, 30, function()
            draft.finish = finishNext[draft.finish]
            Kit.setLabel(widgets.finishButton, "Finish: " .. finishNames[draft.finish])
            showCard()
        end)

    -- 3. Tune the art -------------------------------------------------------------------------
    section("3. Tune the art", RIGHT_X, 4, RIGHT_W)
    widgets.modelButton = Kit.buttonAt(content, "Model: Body", RIGHT_X, 28, RIGHT_W - 4, 30, function()
        draft.body = not draft.body
        draft.cam = nil          -- the head and body models use different camera defaults
        showCard()
    end)

    local function pair(label1, label2, y, change1, change2)
        Kit.buttonAt(content, label1, RIGHT_X, y, HALF_W, 30, function() withCamera(change1) end)
        Kit.buttonAt(content, label2, RIGHT_X + HALF_W + GAP, y, HALF_W, 30, function() withCamera(change2) end)
    end
    local y = 28 + STEP + 4
    pair("Zoom -", "Zoom +", y,
        function(c) c.dist = c.dist * 1.15 end, function(c) c.dist = math.max(10, c.dist * 0.87) end)
    y = y + STEP
    pair("Size -", "Size +", y,
        function(c) c.fov = math.min(120, c.fov + 5) end, function(c) c.fov = math.max(5, c.fov - 5) end)
    y = y + STEP
    pair("Down", "Up", y, function(c) c.ty = c.ty + 20 end, function(c) c.ty = c.ty - 20 end)
    y = y + STEP
    pair("Left", "Right", y, function(c) c.tx = c.tx + 10 end, function(c) c.tx = c.tx - 10 end)
    y = y + STEP
    pair("Yaw -", "Yaw +", y, function(c) c.yaw = c.yaw - 0.2 end, function(c) c.yaw = c.yaw + 0.2 end)
    y = y + STEP
    pair("Pitch -", "Pitch +", y, function(c) c.pitch = c.pitch - 0.15 end, function(c) c.pitch = c.pitch + 0.15 end)
    y = y + STEP
    Kit.buttonAt(content, "Reset camera", RIGHT_X, y, RIGHT_W - 4, 30, function()
        draft.cam = nil
        showCard()
    end)

    y = y + STEP + 12
    caption("Animation (sequence id, optional)", RIGHT_X, y, RIGHT_W)
    y = y + 20
    widgets.animField = Kit.inputField(content, RIGHT_X, y, RIGHT_W - 10, 28, 6, true)
    setField(widgets.animField, draft.anim ~= nil and string.format("%.0f", draft.anim) or "")
    widgets.animField:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        if settingField then
            return
        end
        local typed = tonumber(widgets.animField.content)
        if typed ~= nil or widgets.animField.content == "" then
            setAnim(typed)
        end
    end)
    y = y + 34
    Kit.buttonAt(content, "-100", RIGHT_X, y, HALF_W, 30, function() stepAnim(-100) end)
    Kit.buttonAt(content, "+100", RIGHT_X + HALF_W + GAP, y, HALF_W, 30, function() stepAnim(100) end)
    y = y + STEP
    Kit.buttonAt(content, "-1", RIGHT_X, y, HALF_W, 30, function() stepAnim(-1) end)
    Kit.buttonAt(content, "+1", RIGHT_X + HALF_W + GAP, y, HALF_W, 30, function() stepAnim(1) end)
    y = y + STEP
    Kit.buttonAt(content, "Anim off", RIGHT_X, y, RIGHT_W - 4, 30, function()
        setAnim(nil)
        setField(widgets.animField, "")
    end)

    -- 5. The block's buttons sit at the right of the bottom strip.
    Kit.buttonAt(content, "Show in Output window", RIGHT_X, BOTTOM_Y + 178, RIGHT_W - 4, 30, function()
        local _, ready = Builder.checks()
        if not ready then
            OutputWindow.add("builder", "-- fix the checks in the Card Builder first")
            return
        end
        -- The Output window shows the newest line first, so the block is added backwards to
        -- read in the right order.
        local lines = Builder.blockLines()
        for i = #lines, 1, -1 do
            OutputWindow.add(draft.cardId, lines[i])
        end
        log("builder: card block for", draft.cardId, "sent to the Output window")
    end, "positive")

    showCard()
end

function Builder.hide()
    pending = nil
    Nearby.setPicker(nil)
    NpcSearch.setPicker(nil)
    clearParts(checkParts)
    if view ~= nil then
        pcall(function() view.root:Destroy() end)
        view = nil
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content = nil, nil
    widgets = {}
end

function Builder.isOpen()
    return window ~= nil
end

function Builder.toggle()
    if window ~= nil then
        Builder.hide()
    else
        Builder.show()
    end
end

return Builder
