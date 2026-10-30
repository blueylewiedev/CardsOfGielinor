-- builder.lua
-- The Card Builder: a developer window for making a new card without knowing how the code
-- works. You fill in the details, tune how the NPC (or item) is framed, and the window gives you
-- the finished card block to paste into a deck file. The NPC / Item buttons at the top choose
-- which kind of card it makes: an item card is picked by the item's config name (or from the
-- item search), has no body/head choice, animation or location, and its category words are the
-- item ones. It is built so that someone who has only
-- cloned the repository can add a card and send it back as a pull request.
--
-- The window has five parts:
--   1. Card details  : the NPC or item (by config name), the card's name and id, description, suggested
--                      rarity, tags and the deck file it belongs in
--   2. Live preview  : the card as it will look
--   3. Tune the art  : body or head model, camera, animation
--   4. Checks        : what is wrong or worth a look (NPC not found, id taken, odd tag words)
--   5. Card block    : the card on one line, in a text box where it can be selected and copied
--                      (Ctrl+A, Ctrl+C) to paste into the deck file. The plugin API has no
--                      clipboard and the boxes cannot hold line breaks, hence one line. "Show in
--                      Output window" sends it, and any note about new tag words, to the
--                      Output window too.
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
local AnimSearch = require("dev/animsearch")
local TagPicker = require("dev/tagpicker")
local ItemProbe = require("dev/itemprobe")
local ItemFacts = require("dev/itemfacts")

local Builder = {}

-- A new, empty card. (Reset goes back to this.)
local function freshDraft()
    return {
        kind = "npc",          -- "npc" or "item": what kind of card this is
        npc = "",              -- the NPC's config name, e.g. FATHER_AERECK; this sets the model
        item = "",             -- for an item card, the item's config name, e.g. RANARR_WEED
        name = "",             -- the name printed on the card
        nameTouched = false,   -- true once the name has been typed (so it stops following the NPC)
        cardId = "",           -- the card's id; follows the name until it is typed
        idTouched = false,
        desc = "",
        rarity = "common",
        regions = "", skills = "", location = "", category = "",     -- tags, as typed (words separated by commas)
        membership = "",       -- "f2p", "p2p" or "" (chosen with the two buttons beside the rarity)
        deck = 1,              -- which deck file (index into Cards.sets); one of the kind's own files
        body = true,           -- body model (true) or head model (false)
        cam = nil,             -- camera values chosen with the buttons, or nil for the defaults
        anim = nil,            -- animation (sequence) id, or nil
        model = nil,           -- a raw model id shown instead of the NPC's (scenery: see core/cards.lua), or nil
    }
end

-- The card the window is working on. It outlives the window.
local draft = freshDraft()

-- ---------------------------------------------------------------------------------------------
-- Text rules
-- ---------------------------------------------------------------------------------------------


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

-- A description without a level requirement on the end: "A sturdy pickaxe. (60)" or "A sturdy pickaxe (60)." becomes
-- "A sturdy pickaxe." (The wiki and the game put the level in brackets after the text.)
function Builder.stripLevel(desc)
    local text = desc or ""
    -- "A sturdy pickaxe (60)." keeps its full stop; "A sturdy pickaxe. (60)" and "... (60)" lose the level.
    local stop = string.match(text, "%s*%(%d+%)%s*([%.!?])%s*$")
    if stop ~= nil then
        return (string.gsub(text, "%s*%(%d+%)%s*[%.!?]%s*$", stop))
    end
    return (string.gsub(text, "%s*%(%d+%)%s*$", ""))
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

-- The text of a tag box with `word` added (on = true) or taken off (on = false), words separated
-- by commas. Used by the tag picker.
function Builder.withWord(text, word, on)
    local words = {}
    for _, existing in ipairs(Builder.parseWords(text)) do
        if existing ~= word then
            words[#words + 1] = existing
        end
    end
    if on then
        words[#words + 1] = word
    end
    return table.concat(words, ", ")
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

-- A guess at the NPC's standing animation (a sequence id), or nil. The client doesn't say which
-- animation an NPC stands with (its animation set, config.NPC's `bas`, only has a name), but
-- the standing sequences are named after the creature (GOBLIN_READY, DRAGON_READY,
-- CHICKEN_UPDATE_READY). So each run of words in the animation set's name, then in the NPC's
-- config name, longest first, is tried with these endings; a humanoid with no match gets the
-- normal human one. It is only a guess: the preview shows it, and the builder can change it.
-- (_PLAYING_BASIC: the resting musicians, whose animation set names their instrument, REST_LUTE
-- or REST_DRUM, and whose standing animation is REST_LUTE_PLAYING_BASIC and so on.)
local READY_ENDINGS = { "_READY", "_UPDATE_READY", "_IDLE", "_STAND", "_PLAYING_BASIC" }
local HUMAN_READY = "HUMAN_READY"

-- The id of a sequence by name, or nil if the client doesn't know it.
local function seqId(name)
    local ok, value = pcall(function() return id.Seq[name] end)
    return (ok and type(value) == "number" and value >= 0) and value or nil
end

-- Every run of words in an underscore name, longest first ("A_B_C": A_B_C, A_B, B_C, A, B, C).
local function wordRuns(name)
    local words = {}
    for word in string.gmatch(name or "", "[^_]+") do
        if word ~= "BAS" then
            words[#words + 1] = word
        end
    end
    local runs = {}
    for length = #words, 1, -1 do
        for first = 1, #words - length + 1 do
            runs[#runs + 1] = table.concat(words, "_", first, first + length - 1)
        end
    end
    return runs
end

-- True if two names differ by at most one letter (one changed, added or left out).
local function oneLetterApart(a, b)
    if math.abs(#a - #b) > 1 then
        return false
    end
    local i = 1
    while i <= math.min(#a, #b) and a:sub(i, i) == b:sub(i, i) do
        i = i + 1
    end
    if #a == #b then
        return a:sub(i + 1) == b:sub(i + 1)
    end
    local longer, shorter = #a > #b and a or b, #a > #b and b or a
    return longer:sub(i + 1) == shorter:sub(i)
end

-- The standing sequences, as { stem, ending, id } lists by the stem's length: the stem is the
-- name without its ending (ADVISOR_RODDICK_READY -> ADVISOR_RODDICK). Made once, from the
-- client's list. (By length, as a name one letter off is at most one letter longer or shorter.)
local readyStems = nil
local function standingSequences()
    if readyStems == nil then
        readyStems = {}
        for _, entry in ipairs(AnimSearch.all() or {}) do
            for _, ending in ipairs(READY_ENDINGS) do
                if #entry.name > #ending and entry.name:sub(-#ending) == ending then
                    local stem = entry.name:sub(1, -#ending - 1)
                    readyStems[#stem] = readyStems[#stem] or {}
                    table.insert(readyStems[#stem], { stem = stem, ending = ending, id = entry.id })
                end
            end
        end
    end
    return readyStems
end

-- Names this long or longer may match a standing sequence one letter off: the game's names are
-- sometimes spelt differently (ADVISOR_RODDECK stands with ADVISOR_RODDICK_READY). Shorter ones
-- only match exactly, so that short words don't match each other.
local NEAR_MATCH_LETTERS = 8

-- A trade's standing pose for a humanoid whose name finds nothing: the game has one for some
-- trades, a man's and a woman's (MALE_FARMER_INTERFACE_ANIM, FEMALE_FISHERMAN_INTERFACE_ANIM).
-- Each word of `text` (the card's name and description: Seth Groats is "A large well built
-- farmer.") is tried as the trade. `gender` is "male" or "female" (the wiki's); without it, the
-- description's he or she decides, and a man's pose is used if it says neither.
local function tradePose(text, gender)
    local lower = string.lower(text or "")
    if gender == nil then
        local she = lower:find("%f[%a]she%f[%A]") or lower:find("%f[%a]her%f[%A]")
        gender = she and "female" or "male"
    end
    for word in lower:gmatch("%a+") do
        local name = string.upper(gender) .. "_" .. string.upper(word) .. "_INTERFACE_ANIM"
        local id = seqId(name)
        if id ~= nil then
            return name, id
        end
    end
    return nil
end

-- Every animation set's animations, read from the game's cache by dev/anim_sets.py (loaded the
-- first time they are needed; nil if that file hasn't been made).
local setFile = nil
local function setsFromCache()
    if setFile == nil then
        local ok, data = pcall(require, "dev/anim_sets")
        setFile = ok and type(data) == "table" and data or false
    end
    return setFile or nil
end

-- The NPC's animation set: its number and its animations from dev/anim_sets.lua (nil if either
-- isn't known).
function Builder.setAnimsOf(npcId)
    local ok, setId = pcall(function() return config.NPC.FromID(npcId).bas.id end)
    if not ok or setId == nil then
        return nil, nil
    end
    local sets = setsFromCache()
    return setId, sets and sets[setId]
end

-- The animation an NPC stands with in the game: its set's standing one, or the idle it plays
-- most often if the set has none (from dev/anim_sets.lua); nil if not known.
local function setStand(anims)
    if anims == nil then
        return nil
    end
    if anims.stand ~= nil and anims.stand >= 0 then
        return anims.stand
    end
    local best = nil
    for _, idle in ipairs(anims.idles or {}) do
        if best == nil or idle[2] > best[2] then
            best = idle
        end
    end
    return best and best[1]
end

-- The NPC's standing animation, the first of:
--   1. the one the game stands it with (see setStand; needs dev/anim_sets.lua), unless that is the
--      plain human one (HUMAN_READY, 808), which only comes last;
--   2. for a humanoid, a pose for a trade its description names (a farmer);
--   3. one named like the NPC or its animation set (Advisor Roddeck's ADVISOR_RODDICK_READY), or
--      spelt a letter differently;
--   4. the plain human one, if the game stands it with that, it is a humanoid, or a name gave it.
-- `text` and `gender` are optional: the card's name and description, and the wiki's gender, for
-- the trade pose (see tradePose).
function Builder.readyAnim(configName, humanoid, text, gender)
    local npcId = Builder.lookupNpc(configName)
    if npcId == nil then
        return nil
    end
    local basName = nil
    pcall(function() basName = tostring(config.NPC.FromID(npcId).bas.configName) end)
    local function found(name, id)
        log("builder: standing animation for", configName, "(animation set " .. tostring(basName) .. "):", name, "=", id)
        return id
    end
    local plainHuman = seqId(HUMAN_READY)
    local _, anims = Builder.setAnimsOf(npcId)
    local stand = setStand(anims)
    if stand ~= nil and stand ~= plainHuman then
        return found("its animation set's", stand)
    end
    if humanoid then
        local name, id = tradePose(text, gender)
        if id ~= nil then
            return found(name .. " (a trade in its description)", id)
        end
    end
    local runs = wordRuns(basName)
    for _, run in ipairs(wordRuns(configName)) do
        runs[#runs + 1] = run
    end
    -- (not the plain human one, which "HUMAN" from HUMAN_2 would give before the NPC's own name
    -- is tried; it comes last. And when the game stands the NPC with that one, only a name of two
    -- words or more: one word is too loose, "SWAN" from George Laxmeister's SWAN_COLONIST_2 is the
    -- bird's SWAN_READY.)
    local function usable(run)
        return stand == nil or run:find("_", 1, true) ~= nil
    end
    local namedHuman = false        -- (whether a name gave the plain human one: a last resort)
    for _, run in ipairs(runs) do
        for _, ending in ipairs(READY_ENDINGS) do
            local id = usable(run) and seqId(run .. ending) or nil
            namedHuman = namedHuman or (id ~= nil and id == plainHuman)
            if id ~= nil and id ~= plainHuman then
                return found(run .. ending, id)
            end
        end
    end
    -- No exact name: one spelt a letter differently.
    local stems = standingSequences()
    for _, run in ipairs(runs) do
        if #run >= NEAR_MATCH_LETTERS and usable(run) then
            for _, ending in ipairs(READY_ENDINGS) do
                for length = #run - 1, #run + 1 do
                    for _, entry in ipairs(stems[length] or {}) do
                        if entry.ending == ending and entry.id ~= plainHuman and oneLetterApart(run, entry.stem) then
                            return found(entry.stem .. ending .. " (spelt " .. run .. " here)", entry.id)
                        end
                    end
                end
            end
        end
    end
    if stand ~= nil then         -- (the plain human one, from its animation set)
        return found("its animation set's", stand)
    end
    local fallback = (humanoid or namedHuman) and plainHuman or nil
    log("builder: no standing animation found by name for", configName, "(animation set " .. tostring(basName) .. ")"
        .. (fallback and "; using " .. HUMAN_READY or ""))
    return fallback
end

-- Animation set names already looked up (config name -> name, or false if it has none), as the
-- framing asks for every card's each time a candidate is loaded.
local animSets = {}

-- The name of the animation set an NPC uses (its config's `bas`), or nil if it is not known. Its
-- name is the best clue to which animations suit the NPC.
function Builder.animSetOf(configName)
    if animSets[configName] ~= nil then
        return animSets[configName] or nil
    end
    local npcId = Builder.lookupNpc(configName)
    if npcId == nil then
        return nil          -- (not remembered: the NPC may be found once its name is fixed)
    end
    local ok, name = pcall(function() return tostring(config.NPC.FromID(npcId).bas.configName) end)
    animSets[configName] = ok and name ~= "nil" and name or false
    return animSets[configName] or nil
end

-- The order a set's animations are listed in (as dev/anim_sets.lua names them).
local SET_ROLES = { "stand", "walk", "run", "walkBack", "walkLeft", "walkRight", "turnLeft", "turnRight",
    "walkTurnLeft", "walkTurnRight", "runBack", "runLeft", "runRight", "runTurnLeft", "runTurnRight", "crawl",
    "crawlBack", "crawlLeft", "crawlRight", "crawlTurnLeft", "crawlTurnRight" }

-- Every animation in the NPC's set, for the Animation Search window: a list of { id, name }, the
-- name saying what it is for ("stand, turnLeft: HUMAN_READY"; "idle, 60%: ..."), an animation
-- used for several things listed once; and the set's name. nil if the set isn't known.
function Builder.setAnimList(configName)
    local npcId = Builder.lookupNpc(configName)
    local setId, anims = Builder.setAnimsOf(npcId)
    if anims == nil then
        return nil
    end
    local list, byId = {}, {}
    local function add(animId, role)
        if animId == nil or animId < 0 then
            return
        end
        if byId[animId] ~= nil then
            byId[animId].roles[#byId[animId].roles + 1] = role
            return
        end
        local entry = { id = animId, roles = { role }, seqName = AnimSearch.nameOf(animId) or "?" }
        byId[animId] = entry
        list[#list + 1] = entry
    end
    for _, role in ipairs(SET_ROLES) do
        add(anims[role], role)
    end
    local total = 0
    for _, idle in ipairs(anims.idles or {}) do
        total = total + idle[2]
    end
    for _, idle in ipairs(anims.idles or {}) do
        add(idle[1], string.format("idle, %.0f%%", total > 0 and idle[2] * 100 / total or 0))
    end
    for _, entry in ipairs(list) do
        entry.name = table.concat(entry.roles, ", ") .. ": " .. entry.seqName
    end
    return list, (Builder.animSetOf(configName) or "?") .. " (" .. tostring(setId) .. ")"
end

-- The animation set line: its name, its number, and the animation it stands with in the game
-- (see setStand).
local function animSetLine(configName)
    local name = Builder.animSetOf(configName)
    if name == nil then
        return ""
    end
    local setId, anims = Builder.setAnimsOf(Builder.lookupNpc(configName))
    local line = "Animation set: " .. name
    if setId ~= nil then
        line = line .. " (" .. tostring(setId) .. ")"
        local stand = setStand(anims)
        if stand ~= nil then
            line = line .. "  stands " .. stand
        end
    end
    return line
end

-- Looks up an item by config name. Returns its numeric id and in-game name, or nil if the client
-- does not know the name.
function Builder.lookupItem(configName)
    if configName == nil or configName == "" then
        return nil
    end
    local ok, objId = pcall(function() return id.Obj[configName] end)
    if not ok or not Cards.isValidObjId(objId) then
        return nil
    end
    local displayName = nil
    pcall(function() displayName = tostring(config.Obj.FromID(objId).name) end)
    return objId, displayName
end

-- True while the window is making an item card.
local function isItem()
    return draft.kind == "item"
end

-- The config name of the NPC or item the card shows.
local function subject()
    return isItem() and draft.item or draft.npc
end

-- Looks up the card's NPC or item: its numeric id and in-game name, or nil.
local function lookupSubject(configName)
    if isItem() then
        return Builder.lookupItem(configName)
    end
    return Builder.lookupNpc(configName)
end

-- The deck files for this kind of card, as { setName, index into Cards.sets }.
local function decksFor(cardKind)
    local list = {}
    for i, setName in ipairs(Cards.sets) do
        if Cards.setKind(setName) == cardKind then
            list[#list + 1] = { setName = setName, index = i }
        end
    end
    return list
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

-- The tag kinds the card has, in the order they are written in.
local function tagKinds()
    return Cards.tagKindsFor(draft.kind)
end

-- The tag boxes in the window, and their labels: an NPC's `regions` box is for a second region
-- (its deck file gives the first), so it is labelled "also in".
local function tagRows()
    return isItem() and { "regions", "skills", "category" } or { "skills", "location", "category", "regions" }
end
local function tagLabel(tagKind)
    return (tagKind == "regions" and not isItem()) and "also in" or tagKind
end

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

-- Cameras saved for a kind of item (local to this computer, in PersistentDB): the models of one
-- kind (all the scimitars, all the logs) mostly want the same camera, so a card of a kind with a
-- saved camera starts from it. The kind is the card's most specific category word.
local CAMERA_DB_KEY = "dev_category_cameras"

-- The most specific word of an item's category tags: one that needs another word (scimitar, which
-- needs weapon) if there is one, otherwise the first word. nil if there are none.
function Builder.categoryKey(words)
    local first = nil
    for _, word in ipairs(words or {}) do
        if Cards.requiredWord("item", "category", word) ~= nil then
            return word
        end
        first = first or word
    end
    return first
end

local function savedCameras()
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(CAMERA_DB_KEY) end)
    return (ok and type(saved) == "table") and saved or {}
end

local function copyCamera(cam)
    return { yaw = cam.yaw, pitch = cam.pitch, dist = cam.dist, fov = cam.fov, ty = cam.ty, tx = cam.tx }
end

-- A copy of the camera saved for a category word, or nil.
local function categoryCamera(key)
    local cam = key ~= nil and savedCameras()[key] or nil
    return type(cam) == "table" and copyCamera(cam) or nil
end

-- The animation box's text for the draft's animation.
local function animText()
    return draft.anim ~= nil and string.format("%.0f", draft.anim) or ""
end

-- The model box's text for the draft's raw model.
local function modelText()
    return draft.model ~= nil and string.format("%.0f", draft.model) or ""
end

local function quote(text)
    local escaped = string.gsub(text, "\\", "\\\\")
    escaped = string.gsub(escaped, '"', '\\"')
    return '"' .. escaped .. '"'
end

-- The `art = { ... }` text, as the deck files write it: the NPC or item `subjectName` (if there is
-- one), body = false for a head, the animation, and the camera values that differ from
-- `defaults`. An item has no body/head choice and no animation. (The Preview writes it too.)
function Builder.artText(itemArt, subjectName, body, anim, cam, defaults, model)
    local parts = {}
    if subjectName ~= nil and subjectName ~= "" then
        parts[#parts + 1] = (itemArt and "item = " or "npc = ") .. quote(subjectName)
    end
    if not itemArt and model ~= nil then
        parts[#parts + 1] = "model = " .. string.format("%.0f", model)     -- (a raw model: see core/cards.lua)
    end
    if not itemArt and not body then
        parts[#parts + 1] = "body = false"
    end
    if not itemArt and anim ~= nil then
        parts[#parts + 1] = "anim = " .. string.format("%.0f", anim)
    end
    if cam ~= nil then
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
    return "art = { " .. table.concat(parts, ", ") .. " }"
end

-- The draft's `art = { ... }` text.
local function artLine()
    return Builder.artText(isItem(), subject(), draft.body, draft.anim, currentCam(),
        CardView.defaultsFor({ body = draft.body, kind = isItem() and "item" or nil }), draft.model)
end

-- The card block on ONE line (the text boxes in the client cannot hold line breaks, and Lua does
-- not mind): { id = "...", name = "...", rarity = "...", desc = "...", art = { ... }, tags = { ... } },
function Builder.blockLine()
    local parts = {
        "id = " .. quote(draft.cardId),
        "name = " .. quote(draft.name),
    }
    if isItem() then
        parts[#parts + 1] = 'kind = "item"'
    end
    parts[#parts + 1] = "rarity = " .. quote(draft.rarity)
    parts[#parts + 1] = "desc = " .. quote(draft.desc)
    parts[#parts + 1] = artLine()
    local tagParts = {}
    for _, tagKind in ipairs(tagKinds()) do
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
        parts[#parts + 1] = "tags = { " .. table.concat(tagParts, ", ") .. " }"
    end
    return "{ " .. table.concat(parts, ", ") .. " },"
end

-- Where in core/cards.lua a new word goes (the category words are in groups).
local function wordHome(tagKind)
    local groupTable = isItem() and "Cards.itemTagGroups." or "Cards.tagGroups."
    if Cards.tagGroupsFor(draft.kind, tagKind) ~= nil then
        return "a group in " .. groupTable .. tagKind
    end
    return "Cards.tagWords." .. tagKind
end

-- The block (one line) followed by a note line for each tag word that is not on Cards.tagWords
-- yet, since those words must be added there too.
function Builder.blockLines()
    local lines = { Builder.blockLine() }

    -- New words for tag kinds that have a fixed list.
    for _, tagKind in ipairs(tagKinds()) do
        local allowed = Cards.wordsFor(draft.kind, tagKind)
        if allowed ~= nil then
            local known = {}
            for _, word in ipairs(allowed) do known[word] = true end
            for _, word in ipairs(tagWords(tagKind)) do
                if not known[word] and Builder.validTagWord(word) then
                    lines[#lines + 1] = "-- Also add " .. quote(word) .. " to " .. wordHome(tagKind) .. " in core/cards.lua"
                end
            end
        end
    end
    return lines
end

-- The finished card as an entry for the card queue (dev/wikireview.lua keeps these in the
-- database for dev/card_queue.py to add to the deck files), or nil and why not: the card has
-- something to fix, or no deck file. `page` is the wiki page it came from (so a failed card can be
-- brought back to the Wiki Review); `notes` holds the lines about new tag words, if any.
function Builder.queueEntry(page)
    local _, ready = Builder.checks()
    if not ready then
        return nil, "the card still has something to fix"
    end
    local deck = Cards.sets[draft.deck]
    if deck == nil then
        return nil, "no deck file chosen"
    end
    local lines = Builder.blockLines()
    local notes = {}
    for i = 2, #lines do
        notes[#notes + 1] = lines[i]
    end
    return { id = draft.cardId, name = draft.name, desc = draft.desc, rarity = draft.rarity, deck = deck,
        block = lines[1], notes = table.concat(notes, " | "), page = page or "" }
end

-- What is right and wrong with the card so far. Returns a list of { level, text } where level
-- is "ok", "note" (worth a look) or "fix" (will not load). `ready` is true when nothing needs fixing.
function Builder.checks()
    local list = {}
    local function add(level, text)
        list[#list + 1] = { level = level, text = text }
    end

    -- The NPC or item.
    local noun = isItem() and "Item" or "NPC"
    if subject() == "" then
        add("fix", "Enter the " .. string.lower(noun) .. "'s config name")
    else
        local subjectId, displayName = lookupSubject(subject())
        if subjectId == nil then
            add("fix", noun .. " " .. subject() .. " was not found")
        else
            add("ok", noun .. " found: " .. tostring(displayName or subject()))
            if isItem() then
                -- Another card for the same item is allowed (it may be a different version), but worth a look.
                for _, list in ipairs({ Cards.list, Cards.drafts }) do
                    for _, card in ipairs(list) do
                        if Cards.kindOf(card) == "item" and Cards.getArt(card).item == subject() and card.id ~= draft.cardId then
                            add("note", "The card " .. card.id .. " already shows this item")
                            break
                        end
                    end
                end
                for _, text in ipairs(draft.factNotes or {}) do
                    add("note", text)
                end
            end
        end
    end

    -- The deck file is one of this kind's own.
    if Cards.setKind(Cards.sets[draft.deck] or "") ~= draft.kind then
        add("fix", "Choose a deck file for " .. (isItem() and "item" or "NPC") .. " cards")
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
    elseif #draft.desc > Cards.MAX_DESC then
        add("fix", "The description is " .. #draft.desc .. " letters; keep it to " .. Cards.MAX_DESC)
    else
        add("ok", "The description fits the card")
    end

    -- Tags.
    local tagProblem, tagNotes = nil, {}
    for _, tagKind in ipairs(tagKinds()) do
        local allowed = Cards.wordsFor(draft.kind, tagKind)
        local known = {}
        for _, word in ipairs(allowed or {}) do known[word] = true end
        local used = existingWords(tagKind)
        for _, word in ipairs(tagWords(tagKind)) do
            if not Builder.validTagWord(word) then
                tagProblem = tagProblem or ("The tag " .. word .. " must be lower case letters, digits or underscores")
            elseif allowed ~= nil and not known[word] then
                tagNotes[#tagNotes + 1] = "New " .. tagKind .. " tag " .. word .. " (add it to " .. wordHome(tagKind) .. ")"
            elseif allowed == nil and not used[word] then
                tagNotes[#tagNotes + 1] = "New " .. tagKind .. " tag " .. word
            end
        end
    end
    -- A word that needs a parent word (a scimitar needs a weapon) must have it on the card too.
    local parentProblem = nil
    for _, tagKind in ipairs(tagKinds()) do
        local missing = Cards.missingRequired(draft.kind, tagKind, tagWords(tagKind))[1]
        if missing ~= nil then
            parentProblem = missing.word .. " needs " .. missing.needs .. " (add " .. missing.needs .. " to " .. tagKind .. ")"
            break
        end
    end
    if #tagWords("membership") > 1 then
        tagProblem = tagProblem or "Choose f2p or p2p, not both"
    end
    if not isItem() and #tagWords("regions") > Cards.MAX_NPC_REGIONS - 1 then
        tagProblem = tagProblem or ("An NPC is in one region besides its deck file's; one found in three or more"
            .. " regions goes in the general deck file with none")
    end
    if isItem() and #tagWords("regions") > Cards.MAX_ITEM_REGIONS then
        tagProblem = tagProblem or ("An item takes at most " .. Cards.MAX_ITEM_REGIONS
            .. " regions; leave regions empty if it comes from more")
    end
    if tagProblem ~= nil then
        add("fix", tagProblem)
    elseif parentProblem ~= nil then
        add("fix", parentProblem)
    elseif #tagNotes > 0 then
        add("note", tagNotes[1] .. (#tagNotes > 1 and (" and " .. (#tagNotes - 1) .. " more") or ""))
    else
        add("ok", "The tags look right")
    end

    if #tagWords("membership") == 0 then
        add("note", "Free to play or members? Choose F2P or P2P (optional)")
    end

    if not isItem() and draft.anim == nil then
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
local BLUE = Vector4.new(0.55, 0.78, 0.95, 1)     -- the instructions, so they stand apart from the code
local LEVEL_COLOUR = { ok = GREEN, note = AMBER, fix = RED }
local LEVEL_PREFIX = { ok = "OK   ", note = "Note ", fix = "Fix  " }

local STEP, GAP = 32, 4
local PREVIEW_SCALE = 1.5
local CARD_W, CARD_H = math.floor(160 * PREVIEW_SCALE), math.floor(224 * PREVIEW_SCALE)

-- Left column (card details), middle (preview), right (art), then the bottom strip.
local LEFT_X, LEFT_W = 10, 470
local MID_X, MID_W = 500, 260
local RIGHT_X, RIGHT_W = 780, 316
local HALF_W = 148                 -- the NPC / Item buttons
local CTRL_X = 120                -- where the buttons of a camera row start (after its label)
local CTRL_W = 56                 -- width of a small "-" / "+" button
local BOTTOM_Y = 510
local WIN_W = RIGHT_X + RIGHT_W + 34      -- leaves a margin so nothing touches the right edge
local WIN_H = BOTTOM_Y + 220

local window, content = nil, nil
local gameLayer = nil      -- the layer the window is in (the reset pop-up goes in it too)
local widgets = {}          -- the parts that change after the window is built
local settingField = false  -- true while the code (not the player) changes a text box
-- What the code last put in each text box. The client can report a change to a box after the
-- code has finished setting it, so a change that matches this is the code's own, not typing.
-- It counts once: the first report that matches is dropped, and any other clears it.
local lastSet = setmetatable({}, { __mode = "k" })
local checkParts = {}       -- the texts of the checks and the block, rebuilt on every change
local pending = nil         -- seconds until the card is redrawn (it waits for typing to stop)
local REDRAW_DELAY = 0.6

local function section(title, x, y, w)
    Kit.text(content, x, y, w, 20, title, GOLD, ui.AlignMode.TOPLEFT)
end

local function caption(text, x, y, w)
    Kit.text(content, x, y, w, 18, text, GREY, ui.AlignMode.TOPLEFT)
end

-- A box to type in (`numeric`: digits only). `onChange(text)` is called as the player types.
local function field(x, y, w, maxLength, value, onChange, numeric)
    local box = Kit.inputField(content, x, y, w, 28, maxLength, numeric == true)
    settingField = true
    box.content = value or ""
    settingField = false
    lastSet[box] = value or ""
    box:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
        if settingField then
            return
        end
        if box.content == lastSet[box] then
            lastSet[box] = nil       -- the code's own change, reported late
            return
        end
        lastSet[box] = nil
        onChange(box.content)
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
    lastSet[box] = text
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
    -- The block is in a text box, because the text in a box can be selected and copied (plain
    -- text cannot). It is one line, as the boxes cannot hold line breaks. Anything typed into
    -- the box is ignored: it is put back the next time the card changes.
    local lines = Builder.blockLines()
    local box = Kit.inputField(content, MID_X, BOTTOM_Y + 28, WIN_W - MID_X - 10, 28, 1000, false)
    box.content = lines[1]
    checkParts[#checkParts + 1] = box
    -- Notes about tag words that must be added to Cards.tagWords (up to two are shown).
    for i = 2, math.min(#lines, 3) do
        checkParts[#checkParts + 1] = Kit.text(content, MID_X, BOTTOM_Y + 62 + (i - 2) * 18, WIN_W - MID_X - 10, 18,
            lines[i], AMBER, ui.AlignMode.TOPLEFT)
    end
    -- What to do with the block.
    local steps = {
        "Click the box above, press Ctrl+A, then Ctrl+C to copy it.",
        "Paste it into " .. tostring(Cards.sets[draft.deck] or "a deck file") .. ".lua, inside the Set.cards list.",
        "Reload the plugin once to check that it loads.",
        "Then commit and open a pull request with a screenshot of the card.",
    }
    for i, text in ipairs(steps) do
        checkParts[#checkParts + 1] = Kit.text(content, MID_X, BOTTOM_Y + 104 + (i - 1) * 18, WIN_W - MID_X - 10, 18,
            text, BLUE, ui.AlignMode.TOPLEFT)
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
        art = { npc = draft.npc, model = draft.model, body = draft.body, anim = draft.anim, cam = draft.cam },
    }
    if isItem() then
        card.kind = "item"
        card.art = { item = draft.item, cam = draft.cam }
    end
    if lookupSubject(subject()) == nil then
        -- shows the empty art box without asking the client for a bad name
        card.art[isItem() and "item" or "npc"] = ""
    end
    view = CardView.create(content, card, { scale = PREVIEW_SCALE })
    view.root:SetPos(MID_X + (MID_W - CARD_W) // 2, 30)
    if widgets.modelButton ~= nil then
        if isItem() then
            Kit.setLabel(widgets.modelButton, "Model: Item")
        else
            Kit.setLabel(widgets.modelButton, draft.body and "Model: Body" or "Model: Head")
        end
    end
    refreshChecks()
end

-- Redraws the card shortly after typing stops, so every key press does not rebuild the model.
local function soon()
    pending = REDRAW_DELAY
    refreshChecks()
end

local rebuildRequested = false   -- true when the window must be built again (the kind of card changed)

local function onDraw(e)
    if rebuildRequested then
        -- Done here, not in the button's own handler, so a button is never destroyed while it is pressed.
        rebuildRequested = false
        Builder.rebuild()
        return
    end
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

-- Shows the draft's membership on the F2P and P2P buttons.
local function showMembership()
    if widgets.f2pToggle ~= nil then
        widgets.f2pToggle.setActive(draft.membership == "f2p")
        widgets.p2pToggle.setActive(draft.membership == "p2p")
    end
end

-- Fills in what the game's item config says (membership, skills, kind of item, a rarity from the
-- level) for the boxes that are still empty, and keeps its notes for the checks.
-- Dungeoneering items are all from Daemonheim: adds that region to an item card's regions box
-- when the skills include dungeoneering (room permitting).
local function addDaemonheim()
    if not isItem() then
        return
    end
    local has = false
    for _, word in ipairs(tagWords("skills")) do
        has = has or word == "dungeoneering"
    end
    local regions = tagWords("regions")
    for _, word in ipairs(regions) do
        if word == "daemonheim" then
            return
        end
    end
    if has and #regions < Cards.MAX_ITEM_REGIONS then
        regions[#regions + 1] = "daemonheim"
        draft.regions = table.concat(regions, ", ")
        setField(widgets.regionsField, draft.regions)
    end
end

local function applyItemFacts(objId)
    draft.factNotes = nil
    local ok, facts = pcall(ItemFacts.read, objId)
    if not ok or facts == nil then
        return
    end
    draft.factNotes = facts.notes
    if draft.membership == "" and facts.members ~= nil then
        draft.membership = facts.members
        showMembership()
    end
    if #tagWords("skills") == 0 and #facts.skills > 0 then
        draft.skills = table.concat(facts.skills, ", ")
        setField(widgets.skillsField, draft.skills)
        addDaemonheim()
    end
    if #tagWords("category") == 0 then
        local words = ItemFacts.validCategory(facts.category)
        if #words > 0 then
            draft.category = table.concat(words, ", ")
            setField(widgets.categoryField, draft.category)
        end
    end
    if draft.rarity == "common" and facts.rarity ~= nil then
        draft.rarity = facts.rarity
        if widgets.rarityRefresh ~= nil then
            widgets.rarityRefresh()
        end
    end
    TagPicker.refresh()
end

-- Chooses the NPC (or, for an item card, the item). A new one starts again with the default
-- camera and no animation, and fills in the name from the in-game name if the name has not been typed.
local function setSubject(configName)
    configName = string.upper((string.gsub(configName or "", "%s", "")))
    if configName == subject() then
        return
    end
    draft[isItem() and "item" or "npc"] = configName
    -- An item starts from the camera saved for its kind, if there is one.
    draft.cam = isItem() and categoryCamera(Builder.categoryKey(tagWords("category"))) or nil
    draft.anim = nil
    setField(widgets.animField, "")
    local subjectId, displayName = lookupSubject(configName)
    if widgets.npcStatus ~= nil then
        widgets.npcStatus.content = subjectId ~= nil and "Found" or (configName == "" and "" or "Not found")
    end
    if widgets.animSet ~= nil then
        widgets.animSet.content = animSetLine(configName)
    end
    if subjectId ~= nil and displayName ~= nil and not draft.nameTouched then
        draft.name = displayName
        setField(widgets.nameField, displayName)
        followName()
    end
    if subjectId ~= nil and isItem() then
        applyItemFacts(subjectId)
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

-- Drop-down lists. Normally these are PrettyUI's own drop-down (see choiceDropdown below). This
-- version is the fallback for when that is not available: a button that shows the choice and,
-- when pressed, opens a column of buttons under it. Only one is open at a time, and it closes
-- when a choice is made.
local openDropdown = nil     -- { owner = the button that opened it, parts = its buttons }

local function closeDropdown()
    if openDropdown ~= nil then
        clearParts(openDropdown.parts)
        openDropdown = nil
    end
end

-- A drop-down at x, y, w wide. `choices()` returns the list of { label } to pick from,
-- `current()` the index now chosen, and `onPick(index)` is called when one is picked.
local function dropdown(x, y, w, choices, current, onPick)
    local button = nil
    local function title()
        local list = choices()
        return (list[current()] and list[current()].label or "?") .. "  v"
    end
    button = Kit.buttonAt(content, title(), x, y, w, 30, function()
        if openDropdown ~= nil and openDropdown.owner == button then
            closeDropdown()
            return
        end
        closeDropdown()
        local parts = {}
        openDropdown = { owner = button, parts = parts }
        for i, choice in ipairs(choices()) do
            parts[#parts + 1] = Kit.buttonAt(content, choice.label, x, y + 32 * i, w, 30, function()
                closeDropdown()
                onPick(i)
                Kit.setLabel(button, title())
            end, i == current() and "positive" or "neutral")
        end
    end)
    -- The second value puts the current choice on the button again (after a reset).
    return button, function() Kit.setLabel(button, title()) end
end

-- The name of a deck file as shown in the drop-down: just the region ("deck/npcs/kharidian_desert"
-- becomes "Kharidian Desert"), so it can be found by typing the region's name.
-- "deck/npcs/kharidian_desert" -> "Kharidian Desert". Item files can sit in folders
-- ("deck/items/weapons/sword" -> "Weapons: Sword"), so the folder is part of the label and two
-- files with the same name in different folders still get different labels.
function Builder.deckLabel(setName)
    local path = string.gsub(setName, "^deck/%a+/", "")
    local parts = {}
    for piece in string.gmatch(path, "[^/]+") do
        local words = string.gsub(piece, "_", " ")
        parts[#parts + 1] = (string.gsub(words, "(%a)(%w*)", function(first, rest) return string.upper(first) .. rest end))
    end
    if #parts == 0 then return setName end
    return table.concat(parts, ": ")
end

-- A drop-down at x, y, w wide, made with PrettyUI's drop-down when it can be (or the button
-- version above if not). `choices()`, `current()` and `onPick(index)` are as for dropdown().
-- Returns a function that shows the current choice again (after a reset).
local function choiceDropdown(x, y, w, choices, current, onPick)
    local entries = {}
    for i, choice in ipairs(choices()) do
        entries[i] = { label = choice.label, value = i }   -- the value is the choice's number
    end
    local native = Kit.dropdown(content, x, y, w, 26, entries, current(), onPick)
    if native ~= nil then
        -- Kept so destroyWindow removes it: PrettyUI's list is not inside the window, so it
        -- would outlive it (and the client only has room for about 4096 parts in all).
        widgets.dropdowns = widgets.dropdowns or {}
        widgets.dropdowns[#widgets.dropdowns + 1] = native
        return function() native.select(current()) end
    end
    return select(2, dropdown(x, y, w, choices, current, onPick))
end

-- True if anything has been entered for the card (so Reset should ask first).
local function hasWork()
    for _, key in ipairs({ "npc", "item", "name", "desc", "skills", "location", "category" }) do
        if draft[key] ~= nil and draft[key] ~= "" then
            return true
        end
    end
    return draft.anim ~= nil or draft.cam ~= nil
end

-- Writes the draft into the open window's boxes and redraws the card (after Reset, or when a
-- wiki candidate is loaded: filling the window again rather than building it again, which would
-- make hundreds of new parts each time, and the client only has room for about 4096).
local function fillWindow()
    setField(widgets.npcField, subject())
    setField(widgets.nameField, draft.name)
    setField(widgets.idField, draft.cardId)
    setField(widgets.descField, draft.desc)
    for _, tagKind in ipairs(tagRows()) do
        setField(widgets[tagKind .. "Field"], draft[tagKind] or "")
    end
    showMembership()
    setField(widgets.animField, animText())
    setField(widgets.modelField, modelText())
    if widgets.npcStatus ~= nil then
        widgets.npcStatus.content = subject() == "" and ""
            or (lookupSubject(subject()) ~= nil and "Found" or "Not found")
    end
    if widgets.animSet ~= nil then
        widgets.animSet.content = animSetLine(subject())
    end
    if widgets.outputStatus ~= nil then
        widgets.outputStatus.content = ""
    end
    for _, refresh in ipairs({ widgets.rarityRefresh, widgets.deckRefresh }) do
        refresh()
    end
    TagPicker.refresh()
    showCard()
end

-- Puts the whole window back to a new, empty card.
local function resetAll()
    closeDropdown()
    pending = nil
    local fresh = freshDraft()
    fresh.kind = draft.kind                       -- Reset keeps the kind of card
    local decks = decksFor(fresh.kind)
    fresh.deck = decks[1] ~= nil and decks[1].index or nil
    for key in pairs(draft) do
        draft[key] = nil
    end
    for key, value in pairs(fresh) do
        draft[key] = value
    end
    fillWindow()
end

-- Takes the window down without touching the pickers or the card being made.
local function destroyWindow()
    pending = nil
    closeDropdown()
    clearParts(checkParts)
    for _, native in ipairs(widgets.dropdowns or {}) do
        native.destroy()
    end
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

-- Switches between NPC cards and item cards. The two use different camera defaults, category
-- words and deck files, so the camera, animation and category words are cleared, the deck goes to
-- the first file of the new kind, and the window is built again.
local function setKind(cardKind)
    if draft.kind == cardKind then
        return
    end
    draft.kind = cardKind
    draft.cam = nil
    draft.anim = nil
    draft.category = ""
    if cardKind == "item" then
        draft.location = ""
        draft.model = nil
    else
        draft.regions = ""          -- (an item's regions don't carry over; an NPC's "also in" starts empty)
    end
    -- A name or id that only followed the old NPC or item is cleared; one that was typed stays.
    if not draft.nameTouched then
        draft.name = ""
    end
    if not draft.idTouched then
        draft.cardId = ""
    end
    local decks = decksFor(cardKind)
    draft.deck = decks[1] ~= nil and decks[1].index or nil
    -- The searches were picking for the other kind.
    Nearby.setPicker(nil)
    NpcSearch.setPicker(nil)
    ItemProbe.setPicker(nil)
    rebuildRequested = true
end

-- Builds the window again for the card as it is now (after the kind changed).
function Builder.rebuild()
    local wasOpen = window ~= nil
    destroyWindow()
    if wasOpen then
        Builder.show()
        if TagPicker.isOpen() then
            TagPicker.rebuild()
            TagPicker.refresh()
        end
    end
end

-- Framing a new NPC card like the deck's own: the cards are put in groups by what they show,
-- and a candidate gets the whole camera of the most typical card in its group (the one whose
-- camera is closest to all the others'), so the values stay together as one framing rather than
-- being averaged into something no card uses. Worked out from the deck as it is, so it follows
-- how cards are framed as more are made.
local HUMANOID_WORDS = { humanoid = true, shopkeeper = true, stallholder = true, royalty = true, guard = true,
    knight = true, wizard = true, priest = true, pirate = true, banker = true, farmer = true, thief = true,
    adventurer = true, quest_giver = true }

-- Builder.readyAnim for the NPC `configName` of a card or wiki candidate, from what it says: a
-- person by its category tags (HUMANOID_WORDS), its name and description, and its gender.
function Builder.readyAnimFor(configName, card)
    local humanoid = false
    for _, word in ipairs((card.tags or {}).category or {}) do
        humanoid = humanoid or HUMANOID_WORDS[word] == true
    end
    return Builder.readyAnim(configName, humanoid, (card.name or "") .. " " .. (card.desc or ""), card.gender)
end
local CAMERA_FIELDS = { "yaw", "pitch", "dist", "fov", "ty", "tx" }
-- How much a difference in each camera value counts when comparing two framings.
local CAMERA_SCALE = { yaw = 1, pitch = 1, dist = 1000, fov = 30, ty = 300, tx = 100 }
-- A person's card is a close portrait (like Bob's) when its field of view is this narrow or less,
-- and shows them whole (like a guard's) when it is wider.
local PORTRAIT_FOV = 25
-- A short card's close-up is made by moving in rather than narrowing the view (Aksel: dist 566,
-- the usual field of view), so for short cards a camera this close or closer is one as well.
local SHORT_CLOSE_DIST = 700

-- The short peoples, framed lower and closer than a person (the deck has no category word for
-- dwarves or gnomes: they are humanoids).
local SHORT_WORDS = { dwarf = true, gnome = true, goblin = true, halfling = true }

-- Creatures that hover off the ground, framed with the camera aimed higher than a creature's
-- (a fruit bat flies at about the height of a person's head). Not "bird": most of them perch, and
-- one that flies says so in its animation set (the crimson swift's BIRD_FLYING_UPDATE_READY).
local FLYING_WORDS = { bat = true, butterfly = true, moth = true, mosquito = true, impling = true, fairy = true,
    wisp = true, firefly = true, flying = true }

-- True if any of the texts names one of `words` (a set of lowercase words).
local function namesAny(words, texts)
    for _, text in pairs(texts) do
        for word in string.gmatch(string.lower(tostring(text)), "%a+") do
            if words[word] then
                return true
            end
        end
    end
    return false
end

-- True if any of the texts (a race, a name, a description: Aksel is "An excited dwarf.") names a
-- short people.
function Builder.isShort(...)
    return namesAny(SHORT_WORDS, { ... })
end

-- True if any of the texts (a race, a name, a description: Immenizz is "An impling"; an animation
-- set) names a flying creature. (Not the NPC's config name: the Fairy Tale quest's FAIRY2_STAG walks.)
function Builder.isFlying(...)
    return namesAny(FLYING_WORDS, { ... })
end

-- The group an NPC card or candidate is framed with, from its category tags: "large" (dragons,
-- bosses), "short character" or "short" (goblins, and anything `short`: see Builder.isShort;
-- framed close like Aksel, or whole like a goblin), "character" (a person framed close, like Bob),
-- "person" (a person framed whole, like a guard), "flying" (see Builder.isFlying) or "creature".
-- For a candidate, closeUp is whether it is a named person rather than a role (dev/wiki_cards.py
-- works that out); for a card, whether its camera is a close-up (PORTRAIT_FOV, and
-- SHORT_CLOSE_DIST for short cards). `isFlying` is a function, only asked when the answer is
-- between those two last groups (it can look up the NPC's animation set).
function Builder.framingGroup(categoryWords, closeUp, short, isFlying)
    local person = false
    for _, word in ipairs(categoryWords or {}) do
        if word == "dragon" or word == "boss" then
            return "large"
        end
        short = short or word == "goblin"
        person = person or HUMANOID_WORDS[word] == true
    end
    if short then
        return closeUp and "short character" or "short"
    end
    if person then
        return closeUp and "character" or "person"
    end
    return isFlying() and "flying" or "creature"
end

-- Words in a name that say how big it is, so "Giant frog" is not framed like "Swamp frog".
local SIZE_WORDS = { giant = true, big = true, baby = true, young = true, greater = true, lesser = true,
    small = true, huge = true, king = true, queen = true, elder = true }
-- How many cards of a family (see nameFamily) it takes to frame by them rather than the group.
local FAMILY_CARDS = 2

-- A name's family: its last word, without a plural s ("Steel titan" -> "titan", "Meerkats" ->
-- "meerkat"), and its size words, as one key ("giant frog"), or nil. Bracketed parts are left out.
local function nameFamily(name)
    local last, sizes = nil, {}
    local plain = string.gsub(string.lower(name or ""), "%b()", "")
    for word in string.gmatch(plain, "%a+") do
        last = word
        if SIZE_WORDS[word] then
            sizes[#sizes + 1] = word
        end
    end
    if last == nil then
        return nil
    end
    table.sort(sizes)
    sizes[#sizes + 1] = (string.gsub(last, "s$", ""))
    return table.concat(sizes, " ")
end

-- The camera of the most typical NPC card framed with the body model in `group`, as a copy, and
-- that card; or nil if no card is in the group yet. Given a `name`, the cards of its family (the
-- titans, the minotaurs: see nameFamily) are used instead when there are FAMILY_CARDS of them, as
-- a creature's size is much more like its family's than its group's.
function Builder.typicalCamera(group, name)
    local defaults = CardView.defaultsFor({ body = true })
    local members = {}
    for _, card in ipairs(Cards.list) do
        local art = card.art or {}
        if Cards.kindOf(card) ~= "item" and art.body ~= false then
            local cam = {}
            for _, field in ipairs(CAMERA_FIELDS) do
                cam[field] = (art.cam or {})[field] or defaults[field]
            end
            local short = Builder.isShort(card.name, card.desc, art.npc)
            local closeUp = cam.fov <= PORTRAIT_FOV or (short and cam.dist <= SHORT_CLOSE_DIST)
            local function flying()
                return Builder.isFlying(card.name, card.desc, art.npc and Builder.animSetOf(art.npc))
            end
            if Builder.framingGroup((card.tags or {}).category, closeUp, short, flying) == group then
                members[#members + 1] = { card = card, cam = cam }
            end
        end
    end
    local function apart(a, b)
        local total = 0
        for _, field in ipairs(CAMERA_FIELDS) do
            total = total + math.abs(a[field] - b[field]) / CAMERA_SCALE[field]
        end
        return total
    end
    local family = nameFamily(name)
    if family ~= nil then
        local kin = {}
        for _, member in ipairs(members) do
            if nameFamily(member.card.name) == family then
                kin[#kin + 1] = member
            end
        end
        if #kin >= FAMILY_CARDS then
            members = kin
        end
    end
    local best, bestTotal = nil, math.huge
    for _, member in ipairs(members) do
        local total = 0
        for _, other in ipairs(members) do
            total = total + apart(member.cam, other.cam)
        end
        if total < bestTotal then
            best, bestTotal = member, total
        end
    end
    if best == nil then
        return nil
    end
    return copyCamera(best.cam), best.card
end

-- Switches the card to another model of the same NPC or item (the Wiki Review window's Next
-- model), keeping everything else that was entered, the camera too (the framing suggested when
-- it was loaded, or as tuned since: it is the same NPC). An NPC's standing animation is guessed
-- again, as each model can have its own.
function Builder.useModel(configName, candidate)
    local cam = draft.cam
    setField(widgets.npcField, configName)
    setSubject(configName)          -- (which starts a new NPC from the default camera)
    draft.cam = cam
    if not isItem() then
        draft.anim = Builder.readyAnimFor(configName, candidate)
        setField(widgets.animField, animText())
    end
    if window == nil then
        Builder.show()
    end
end

-- Starts an NPC card for an NPC found in the game (the Uncarded NPCs window): its model, name, card
-- id and a guess at its standing animation, in the general NPC deck file. `npc` is { configName,
-- name }. Anything entered before is replaced.
function Builder.loadNpc(npc)
    Builder.loadCandidate({ kind = "npc", name = npc.name, desc = "", rarity = "common", tags = {},
        npc = npc.configName }, npc.configName)
end

-- The singular and plural spellings of a name, as the names a deck file or folder might use
-- (raw_material and raw_materials, scimitars and scimitar), the one given first.
local function nameForms(name)
    local forms = { name }
    local function add(form)
        for _, existing in ipairs(forms) do
            if existing == form then
                return
            end
        end
        forms[#forms + 1] = form
    end
    if string.sub(name, -1) == "y" then
        add(string.sub(name, 1, -2) .. "ies")
    elseif string.sub(name, -1) ~= "s" then
        add(name .. "s")
    end
    if #name > 3 and string.sub(name, -1) == "s" and string.sub(name, -2) ~= "ss" then
        add(string.sub(name, 1, -2))
    end
    return forms
end

-- The same names with the plural first, which is how the folders and files are named (a name
-- already in the plural is first as it is).
local function pluralFirst(name)
    local forms = nameForms(name)
    if string.sub(name, -1) ~= "s" and forms[2] ~= nil then
        return { forms[2], forms[1] }
    end
    return forms
end

-- The deck files to try for an item, best first: in the folder for its first category word
-- (raw_materials, the word in the plural; as it is is tried too), the file named
-- for its second category word (weapons/scimitars) or for the wiki category it came from
-- (raw_materials/logs), then that folder's general file, then deck/items/general. `sources` are
-- the wiki categories the candidate came from ("Logs").
function Builder.itemDeckNames(category, sources)
    local names = {}
    local first = category[1]
    if first ~= nil and first ~= "" then
        -- The folder: the word in the plural, which is how they are named, then as it is.
        local folders = pluralFirst(first)
        -- The kinds of item: the second category word, then the wiki categories it came from.
        local kinds = { category[2] }
        for _, source in ipairs(sources or {}) do
            local slug = string.gsub(string.lower(source), "[^a-z0-9]+", "_")
            slug = string.gsub(slug, "^_+", "")
            slug = string.gsub(slug, "_+$", "")
            kinds[#kinds + 1] = slug
        end
        for _, kind in ipairs(kinds) do
            if kind ~= "" then
                for _, form in ipairs(pluralFirst(kind)) do
                    for _, folder in ipairs(folders) do
                        names[#names + 1] = "deck/items/" .. folder .. "/" .. form
                    end
                end
            end
        end
        for _, folder in ipairs(folders) do
            names[#names + 1] = "deck/items/" .. folder .. "/general"
        end
    end
    names[#names + 1] = "deck/items/general"
    return names
end

-- The index in Cards.sets of the first of these deck files that exists, or nil.
local function firstDeck(setNames)
    for _, setName in ipairs(setNames) do
        for i, name in ipairs(Cards.sets) do
            if name == setName then
                return i
            end
        end
    end
    return nil
end

-- Fills the card in from a wiki candidate (see dev/wikireview.lua) and shows it, replacing
-- anything entered before: an NPC or item card with the candidate's model `configName`, name,
-- description, suggested rarity and tags. An NPC goes in its region's deck file (whose defaults
-- give the region tag), an item in the file for its category (deck/items/<categories>/<kind>.lua,
-- see deck/index.lua) if there is one; otherwise the general file. An NPC's camera is the most
-- typical one of the deck's cards like it (see Builder.typicalCamera), an item's the one saved
-- for its category, and an NPC's animation is a guess at its standing one (see Builder.readyAnim).
function Builder.loadCandidate(candidate, configName)
    closeDropdown()
    pending = nil
    local fresh = freshDraft()
    local tags = candidate.tags or {}
    if candidate.kind == "item" then
        fresh.kind = "item"
        fresh.item = configName
        local category = tags.category or {}
        fresh.deck = firstDeck(Builder.itemDeckNames(category, candidate.sources)) or fresh.deck
    else
        fresh.npc = configName or candidate.npc
        fresh.anim = Builder.readyAnimFor(fresh.npc, candidate)
        -- Short by the wiki's race if it gives one, otherwise by what the name and description
        -- say; flying by either.
        local short
        if candidate.race ~= nil then
            short = Builder.isShort(candidate.race)
        else
            short = Builder.isShort(candidate.name, candidate.desc, fresh.npc)
        end
        local function flying()
            return Builder.isFlying(candidate.race, candidate.name, candidate.desc, Builder.animSetOf(fresh.npc))
        end
        local group = Builder.framingGroup(tags.category, candidate.named == true, short, flying)
        local cam, like = Builder.typicalCamera(group, candidate.name)
        if cam ~= nil then
            fresh.cam = cam
            log("builder: framing", candidate.name, "as a " .. group .. ", like", like.name)
        end
        local region = tags.regions and tags.regions[1]
        fresh.deck = firstDeck({ "deck/npcs/" .. (region or ""), "deck/npcs/general" }) or fresh.deck
    end
    fresh.name, fresh.nameTouched = candidate.name, true
    fresh.cardId = Builder.freeId(Builder.slug(candidate.name))
    fresh.desc = Builder.stripLevel(candidate.desc)
    fresh.rarity = Cards.rarities[candidate.rarity] and candidate.rarity or "common"
    for _, tagKind in ipairs(fresh.kind == "item" and { "regions", "skills", "category", "membership" }
        or { "skills", "location", "category", "membership" }) do
        fresh[tagKind] = table.concat(tags[tagKind] or {}, ", ")
    end
    if fresh.kind == "item" then
        fresh.cam = categoryCamera(Builder.categoryKey(Builder.parseWords(fresh.category)))
    else
        -- (an NPC found in two regions: its deck file is the first's, and it is tagged with the second)
        fresh.regions = table.concat({ table.unpack(tags.regions or {}, 2) }, ", ")
    end
    local sameKind = draft.kind == fresh.kind
    for key in pairs(draft) do
        draft[key] = nil
    end
    for key, value in pairs(fresh) do
        draft[key] = value
    end
    if window == nil then
        Builder.show()
    elseif not sameKind then
        Builder.rebuild()           -- an NPC card and an item card have different boxes
    else
        fillWindow()                -- the same kind of card: its boxes are filled in again
    end
end

function Builder.show()
    if window ~= nil then
        return
    end
    widgets = {}
    openDropdown = nil
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    gameLayer = gameWindow
    window, content = Kit.window(gameWindow, "Card Builder", WIN_W, WIN_H + Kit.titleBarHeight(),
        function() Builder.hide() end, 0.15, 0.04, false, true)

    -- A slightly lighter band behind sections 4 and 5, to set them apart from the rest.
    local band = ui.Rectangle.new(content)
    band:SetPos(0, BOTTOM_Y - 8)
    band:SetSize(WIN_W, WIN_H - (BOTTOM_Y - 8))
    band.fill = true
    band.colour = Vector4.new(1, 1, 1, 0.07)

    -- 1. Card details ---------------------------------------------------------------------
    section("1. Card details", LEFT_X, 4, LEFT_W)
    Kit.iconButton(content, "TRASH", LEFT_X + LEFT_W - 40, 2, function()
        if hasWork() then
            Kit.confirm(gameLayer, "Clear this card?", "Everything entered for this card will be cleared.", "Clear",
                resetAll)
        else
            resetAll()
        end
    end, "Clear the card and start a new one", "Reset", 80)

    caption("What kind of card?", LEFT_X, 26, LEFT_W)
    Kit.buttonAt(content, "NPC", LEFT_X, 44, HALF_W, 30, function() setKind("npc") end,
        isItem() and "neutral" or "positive")
    Kit.buttonAt(content, "Item", LEFT_X + HALF_W + GAP, 44, HALF_W, 30, function() setKind("item") end,
        isItem() and "positive" or "neutral")

    caption((isItem() and "Item" or "NPC") .. " config name (this sets the model)", LEFT_X, 82, LEFT_W)
    widgets.npcField = field(LEFT_X, 100, 250, 60, subject(), setSubject)
    local subjectId = lookupSubject(subject())
    widgets.npcStatus = Kit.text(content, LEFT_X + 350, 100, 110, 28,
        subjectId ~= nil and "Found" or (subject() == "" and "" or "Not found"), GREY, ui.AlignMode.TOPLEFT)
    -- The lists hand the NPC or item that was picked back to this window.
    local function usePicked(picked)
        setField(widgets.npcField, picked.configName)
        setSubject(picked.configName)
    end
    if isItem() then
        Kit.iconButton(content, "SEARCH", LEFT_X + 262, 102, function()
            ItemProbe.setPicker(usePicked)
            ItemProbe.show()
        end, "Find any item in the game by name and use it", "Search items", 110)
        Kit.iconButton(content, "SWAP", LEFT_X + 306, 102, function()
            ItemProbe.setPicker(usePicked)
            ItemProbe.show()
            pcall(ItemProbe.readGrandExchange)
        end, "List my Grand Exchange offers and use one of the items", "GE offers", 110)
    else
        Kit.iconButton(content, "SEARCH", LEFT_X + 262, 102, function()
            NpcSearch.setPicker(usePicked)
            NpcSearch.show()
        end, "Find any NPC in the game by name", "Search NPCs", 110)
        Kit.iconButton(content, "EYE", LEFT_X + 306, 102, function()
            Nearby.setPicker(usePicked)
            Nearby.show()
        end, "List the NPCs standing near you and use one of them", "Nearby NPCs", 110)
    end

    caption("Card name", LEFT_X, 136, 225)
    caption("Card id (follows the name)", LEFT_X + 235, 136, 225)
    widgets.nameField = field(LEFT_X, 154, 225, 40, draft.name, function(text)
        draft.name = text
        draft.nameTouched = text ~= ""
        followName()
        soon()
    end)
    widgets.idField = field(LEFT_X + 235, 154, 225, 40, draft.cardId, function(text)
        draft.cardId = text
        draft.idTouched = text ~= ""
        soon()
    end)

    caption("Description (up to " .. Cards.MAX_DESC .. " letters)", LEFT_X, 200, LEFT_W)
    widgets.descField = field(LEFT_X, 218, LEFT_W - 10, 120, draft.desc, function(text)
        local stripped = Builder.stripLevel(text)
        draft.desc = stripped
        if stripped ~= text then
            setField(widgets.descField, stripped)
        end
        soon()
    end)

    -- Left column, below the description: rarity, tags, deck file. (The drop-downs are made
    -- last so their lists open over everything else.)
    caption("Suggested rarity (we may change it in review)", LEFT_X, 256, LEFT_W)

    -- Free to play or members only, beside the rarity: pressing the one that is on turns it off.
    local function chooseMembership(word, on)
        draft.membership = on and word or ""
        showMembership()
        soon()
    end
    widgets.f2pToggle = Kit.toggleButton(content, "F2P", LEFT_X + 318, 274, 70, 28, draft.membership == "f2p",
        function(on) chooseMembership("f2p", on) end, "Free to play: anyone can get this")
    widgets.p2pToggle = Kit.toggleButton(content, "P2P", LEFT_X + 396, 274, 70, 28, draft.membership == "p2p",
        function(on) chooseMembership("p2p", on) end, "Members only (pay to play)")

    caption("Tags: words separated by commas", LEFT_X, 316, LEFT_W - 160)
    Kit.smallButton(content, "Pick tags", LEFT_X + LEFT_W - 150, 310, 140, 24, function()
        TagPicker.setTarget({
            cardKind = function() return draft.kind end,
            words = function(kind) return tagWords(kind) end,
            toggle = function(kind, word, on)
                draft[kind] = Builder.withWord(draft[kind], word, on)
                setField(widgets[kind .. "Field"], draft[kind])
                soon()
            end,
        })
        TagPicker.show()
        TagPicker.refresh()
    end, "Choose tags from the words that are allowed")
    local tagY = 336
    for _, tagKind in ipairs(tagRows()) do
        Kit.text(content, LEFT_X, tagY, 74, 28, tagLabel(tagKind), GREY, ui.AlignMode.TOPLEFT)
        widgets[tagKind .. "Field"] = field(LEFT_X + 78, tagY, LEFT_W - 88, 80, draft[tagKind], function(text)
            draft[tagKind] = text
            TagPicker.refresh()
            soon()
        end)
        tagY = tagY + 28
    end

    caption("Which deck file does it go in?", LEFT_X, 448, LEFT_W)

    -- 2. Live preview -----------------------------------------------------------------------
    section("2. Live preview", MID_X, 4, MID_W)

    -- 3. Tune the art -------------------------------------------------------------------------
    section("3. Tune the art", RIGHT_X, 4, RIGHT_W)
    widgets.modelButton = Kit.buttonAt(content, isItem() and "Model: Item" or "Model: Body", RIGHT_X, 28, RIGHT_W - 4, 30,
        function()
            if isItem() then
                return           -- an item has one model
            end
            draft.body = not draft.body
            draft.cam = nil          -- the head and body models use different camera defaults
            showCard()
        end)
    if isItem() then
        Kit.setEnabled(widgets.modelButton, false)
    end

    -- Reset camera sits at the right of the section title, like Reset does for section 1.
    Kit.iconButton(content, "UNDO", RIGHT_X + RIGHT_W - 40, 2, function()
        draft.cam = nil
        showCard()
    end, "Put the camera back to its starting position", "Reset camera", 130)

    -- Each camera control is a label with two buttons: "-" and "+", or arrows where a direction
    -- makes sense.
    local function control(label, y, first, second, change1, change2)
        Kit.text(content, RIGHT_X, y, CTRL_X - 10, 28, label, GREY, ui.AlignMode.TOPLEFT)
        local function button(spec, x, change)
            if spec.icon ~= nil then
                Kit.iconButton(content, spec.icon, x, y + 2, function() withCamera(change) end, spec.tip,
                    spec.fallback, 60)
            else
                Kit.smallButton(content, spec.text, x, y, CTRL_W, 28, function() withCamera(change) end, spec.tip)
            end
        end
        button(first, RIGHT_X + CTRL_X, change1)
        button(second, RIGHT_X + CTRL_X + CTRL_W + 12, change2)
    end
    local MINUS = { text = "-" }
    local PLUS = { text = "+" }
    local y = 28 + STEP + 6
    control("Zoom", y, MINUS, PLUS,
        function(c) c.dist = c.dist * 1.15 end, function(c) c.dist = math.max(10, c.dist * 0.87) end)
    y = y + STEP
    control("Size", y, MINUS, PLUS,
        function(c) c.fov = math.min(120, c.fov + 5) end, function(c) c.fov = math.max(5, c.fov - 5) end)
    y = y + STEP
    control("Tilt", y, MINUS, PLUS,
        function(c) c.pitch = c.pitch - 0.15 end, function(c) c.pitch = c.pitch + 0.15 end)
    -- The "-" / "+" controls are together above; the arrow controls are together below.
    y = y + STEP
    control("Height", y, { icon = "ARROW_DOWN", tip = "Move the card art down", fallback = "Down" },
        { icon = "ARROW_UP", tip = "Move the card art up", fallback = "Up" },
        function(c) c.ty = c.ty + 20 end, function(c) c.ty = c.ty - 20 end)
    y = y + STEP
    control("Sideways", y, { icon = "ARROW_LEFT", tip = "Move the card art left", fallback = "Left" },
        { icon = "ARROW_RIGHT", tip = "Move the card art right", fallback = "Right" },
        function(c) c.tx = c.tx + 10 end, function(c) c.tx = c.tx - 10 end)
    y = y + STEP
    control("Turn", y, { icon = "ARROW_LEFT", tip = "Turn the model one way", fallback = "Yaw -" },
        { icon = "ARROW_RIGHT", tip = "Turn the model the other way", fallback = "Yaw +" },
        function(c) c.yaw = c.yaw - 0.2 end, function(c) c.yaw = c.yaw + 0.2 end)

    y = y + STEP + 12
    if isItem() then
        caption("An item has no animation.", RIGHT_X, y, RIGHT_W)
        -- The camera of this kind of item (its most specific category word), kept for the next
        -- card of the kind: tune one, press Save, and the others start from it.
        y = y + 26
        widgets.categoryCameraNote = Kit.text(content, RIGHT_X, y + 68, RIGHT_W, 20, "", GREY, ui.AlignMode.TOPLEFT)
        local function note(text)
            widgets.categoryCameraNote.content = text
        end
        Kit.buttonAt(content, "Save camera for this kind", RIGHT_X, y, RIGHT_W - 4, 28, function()
            local key, cam = Builder.categoryKey(tagWords("category")), currentCam()
            if key == nil then
                return note("Choose a category first")
            end
            if cam == nil then
                return note("No card is shown")
            end
            local saved = savedCameras()
            saved[key] = copyCamera(cam)
            pcall(function() PersistentDB:SetStructuredData(CAMERA_DB_KEY, saved) end)
            note("Saved the camera for " .. key)
        end, "neutral", "Keep this camera for every other card of the same kind (its most specific category word)")
        Kit.buttonAt(content, "Use the saved camera", RIGHT_X, y + 34, RIGHT_W - 4, 28, function()
            local key = Builder.categoryKey(tagWords("category"))
            local cam = categoryCamera(key)
            if cam == nil then
                return note(key ~= nil and ("No camera saved for " .. key) or "Choose a category first")
            end
            draft.cam = cam
            showCard()
            note("Using the camera saved for " .. key)
        end, "neutral", "Start this card from the camera saved for its kind")
    else
        caption("Animation (sequence id, optional)", RIGHT_X, y, RIGHT_W)
        y = y + 20
        widgets.animField = Kit.inputField(content, RIGHT_X, y, RIGHT_W - 100, 28, 6, true)
        setField(widgets.animField, animText())
        widgets.animField:Subscribe(ui.Hook.ONCONTENTCHANGED, function()
            if settingField then
                return
            end
            if widgets.animField.content == lastSet[widgets.animField] then
                lastSet[widgets.animField] = nil
                return
            end
            lastSet[widgets.animField] = nil
            local typed = tonumber(widgets.animField.content)
            if typed ~= nil or widgets.animField.content == "" then
                setAnim(typed)
            end
        end)
        -- Search animations by name ("Use" on a result plays it on the card), or switch the animation off.
        local function useAnim(seq)
            setAnim(seq.id)
            setField(widgets.animField, string.format("%.0f", seq.id))
        end
        Kit.iconButton(content, "SEARCH", RIGHT_X + RIGHT_W - 84, y + 2, function()
            AnimSearch.setPicker(useAnim)
            AnimSearch.show()
        end, "Find an animation by name and try it on the card", "Search anims", 110)
        Kit.iconButton(content, "CROSS", RIGHT_X + RIGHT_W - 44, y + 2, function()
            setAnim(nil)
            setField(widgets.animField, "")
        end, "Show the card without an animation", "Anim off", 80)
        y = y + 36
        -- The NPC's animation set, and a button listing its animations (its stand, walk, turns, and
        -- the idles it plays now and then) in the Animation Search window, each with Use.
        widgets.animSet = Kit.text(content, RIGHT_X, y + 2 * STEP + 4, RIGHT_W, 20, animSetLine(subject()), GREY,
            ui.AlignMode.TOPLEFT)
        -- A raw model to show instead of the NPC's: for an NPC whose look is scenery (Aris at her
        -- card table; the Nearby window's "Log scenery" finds the scenery, its config the model).
        Kit.text(content, RIGHT_X + 130, y + 2 * STEP + 32, 70, 22, "Model id", GREY, ui.AlignMode.TOPLEFT)
        widgets.modelField = field(RIGHT_X + 200, y + 2 * STEP + 28, RIGHT_W - 204, 7, modelText(), function(text)
            draft.model = tonumber(text)
            soon()
        end, true)
        Kit.smallButton(content, "Browse set", RIGHT_X, y + 2 * STEP + 28, 120, 28, function()
            local list, setName = Builder.setAnimList(subject())
            if list == nil then
                log("builder: no animation set known for", subject(), "(is dev/anim_sets.lua made? python dev/anim_sets.py)")
                return
            end
            AnimSearch.setPicker(useAnim)
            AnimSearch.showList("Animation set " .. setName .. ": " .. #list .. " animations", list)
        end)
        -- Two rows of three (the "+100" label does not fit in a button six across).
        local steps = { -100, -10, -1, 1, 10, 100 }
        for i, amount in ipairs(steps) do
            local column, row = (i - 1) % 3, (i - 1) // 3
            Kit.smallButton(content, (amount > 0 and "+" or "") .. amount, RIGHT_X + column * 108, y + row * STEP, 100, 28,
                function() stepAnim(amount) end)
        end
    end

    -- 5. The block's buttons sit at the right of the bottom strip.
    widgets.outputStatus = Kit.text(content, LEFT_X + 310, BOTTOM_Y + 176, 150, 30, "", GREY, ui.AlignMode.TOPLEFT)
    Kit.buttonAt(content, "Show in Output window", LEFT_X, BOTTOM_Y + 176, 300, 30, function()
        local _, ready = Builder.checks()
        if not ready then
            widgets.outputStatus.content = "Fix the checks first"
            return
        end
        -- The Output window shows the newest line first, so the block is added backwards to
        -- read in the right order.
        local lines = Builder.blockLines()
        for i = #lines, 1, -1 do
            OutputWindow.add(draft.cardId, lines[i])
        end
        log("builder: card block for", draft.cardId, "sent to the Output window")
        widgets.outputStatus.content = "Sent to Output"
        OutputWindow.show()
    end, "positive")

    showCard()

    -- The drop-downs come last, so their lists open on top of the other parts.
    widgets.rarityRefresh = choiceDropdown(LEFT_X, 274, 300, function()
        local list = {}
        -- PrettyUI's drop-down lists its choices in alphabetical order, so the number at the start
        -- keeps them in order of rarity.
        for rank, key in ipairs(Cards.rarityOrder) do
            list[#list + 1] = { label = rank .. ". " .. Cards.rarities[key].name }
        end
        return list
    end, function() return Cards.rarityRank[draft.rarity] or 1 end, function(i)
        draft.rarity = Cards.rarityOrder[i]
        showCard()
    end)
    widgets.deckRefresh = choiceDropdown(LEFT_X, 466, LEFT_W - 10, function()
        local list = {}
        for _, deck in ipairs(decksFor(draft.kind)) do
            list[#list + 1] = { label = Builder.deckLabel(deck.setName) }
        end
        return list
    end, function()
        for i, deck in ipairs(decksFor(draft.kind)) do
            if deck.index == draft.deck then
                return i
            end
        end
        return 1
    end, function(i)
        local deck = decksFor(draft.kind)[i]
        draft.deck = deck ~= nil and deck.index or draft.deck
        refreshChecks()
    end)
end

function Builder.hide()
    TagPicker.setTarget(nil)
    TagPicker.hide()
    Nearby.setPicker(nil)
    NpcSearch.setPicker(nil)
    AnimSearch.setPicker(nil)
    ItemProbe.setPicker(nil)
    destroyWindow()
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
