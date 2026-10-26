-- dev/wikireview.lua
-- The Wiki Review window: steps through the card candidates made from the RuneScape Wiki by
-- dev/wiki_cards.py (dev/wiki_candidates.lua), so the Card Builder becomes a reviewer instead of
-- a form. For each candidate, "Load into Card Builder" fills the builder in (NPC, name,
-- description, suggested rarity, tags, deck file); there it is checked, framed and copied as
-- usual. Then "Done" (or "Skip") moves on.
--
-- Candidates whose NPC is already on a card (or a draft) are left out, and so are the ones marked
-- Done or Skipped; those marks are kept in the plugin's database (PersistentDB, on this computer
-- only). Only used by the developer tools (the dev folder).

local Kit = require("ui/kit")
local Cards = require("core/cards")
local Builder = require("dev/builder")

local WikiReview = {}

local DB_KEY = "dev_wiki_review"         -- { [npc config name] = "done" or "skipped" }
local WIDTH, HEIGHT = 420, 330
local NOTE_ROWS = 6

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1)
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)
local AMBER = Vector4.new(0.94, 0.70, 0.35, 1)
local BLUE = Vector4.new(0.55, 0.78, 0.95, 1)

local window, content = nil, nil
local widgets = {}
local queue = {}      -- the candidates still to review
local index = 1       -- the one shown

local function reviewed()
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(DB_KEY) end)
    return (ok and type(saved) == "table") and saved or {}
end

local function mark(npc, verdict)
    local saved = reviewed()
    saved[npc] = verdict
    pcall(function() PersistentDB:SetStructuredData(DB_KEY, saved) end)
end

-- The NPC config names already on a card or a draft (an NPC card shows art.npc, or its id
-- upper-cased; its variants can show others).
local function npcsInDeck()
    local used = {}
    local function scan(list)
        for _, card in ipairs(list) do
            if Cards.kindOf(card) ~= "item" then
                local art = card.art or {}
                used[(art.npc ~= nil and art.npc ~= "") and art.npc or string.upper(card.id)] = true
                for _, variant in ipairs(card.variants or {}) do
                    if variant.npc ~= nil and variant.npc ~= "" then
                        used[variant.npc] = true
                    end
                end
            end
        end
    end
    scan(Cards.list)
    scan(Cards.drafts)
    return used
end

-- Reads the candidates again, leaving out the ones done, skipped or already on a card. Returns
-- the list, or nil if dev/wiki_candidates.lua has not been made yet.
local function loadQueue()
    local ok, candidates = pcall(require, "dev/wiki_candidates")
    if not ok or type(candidates) ~= "table" then
        return nil
    end
    local done, inDeck, list = reviewed(), npcsInDeck(), {}
    for _, candidate in ipairs(candidates) do
        if not done[candidate.npc] and not inDeck[candidate.npc] then
            list[#list + 1] = candidate
        end
    end
    return list
end

local function setText(widget, text, colour)
    widget.content = text
    if colour ~= nil then
        pcall(function() widget.colour = colour end)
    end
end

-- Shows the current candidate (or what to do if there is none).
local function refresh()
    if window == nil then
        return
    end
    local candidate = queue[index]
    for _, row in ipairs(widgets.notes) do
        setText(row, "")
    end
    if candidate == nil then
        setText(widgets.status, "Nothing to review", WHITE)
        setText(widgets.name, "Make candidates with:", GREY)
        setText(widgets.npc, "python dev/wiki_cards.py --category Lumbridge", BLUE)
        setText(widgets.notes[1], "then reload the plugin (prf) and open this window again.", GREY)
        return
    end
    setText(widgets.status, "Candidate " .. index .. " of " .. #queue, WHITE)
    setText(widgets.name, candidate.name .. "  (wiki: " .. candidate.page .. ")", GOLD)
    setText(widgets.npc, "NPC " .. candidate.npc .. ((#(candidate.others or {}) > 0)
        and ("  (also: " .. table.concat(candidate.others, ", ") .. ")") or ""), GREY)
    for i, note in ipairs(candidate.notes or {}) do
        if i <= NOTE_ROWS then
            setText(widgets.notes[i], note, AMBER)
        end
    end
end

-- Moves to another candidate (dir = 1 next, -1 back), going round at the ends.
local function step(dir)
    if #queue > 0 then
        index = (index - 1 + dir) % #queue + 1
    end
    refresh()
end

-- Marks the current candidate and takes it off the list.
local function finish(verdict)
    local candidate = queue[index]
    if candidate == nil then
        return
    end
    mark(candidate.npc, verdict)
    table.remove(queue, index)
    if index > #queue then
        index = 1
    end
    refresh()
end

function WikiReview.show()
    if window ~= nil then
        return
    end
    queue = loadQueue() or {}
    index = 1
    widgets = { notes = {} }
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Wiki Review", WIDTH, HEIGHT + Kit.titleBarHeight(),
        function() WikiReview.hide() end, 0.75, 0.1)

    Kit.iconButton(content, "ARROW_LEFT", 10, 6, function() step(-1) end, "Previous candidate", "Back", 60)
    Kit.iconButton(content, "ARROW_RIGHT", 40, 6, function() step(1) end, "Next candidate", "Next", 60)
    widgets.status = Kit.text(content, 74, 4, 220, 28, "", WHITE, ui.AlignMode.TOPLEFT)
    Kit.iconButton(content, "UNDO", WIDTH - 44, 6, function()
        Kit.confirm(gameWindow, "Review again?", "Every candidate marked Done or Skip comes back.", "Review again", function()
            pcall(function() PersistentDB:SetStructuredData(DB_KEY, {}) end)
            queue = loadQueue() or {}
            index = 1
            refresh()
        end)
    end, "Bring back the candidates marked Done or Skip", "Reset", 70)

    widgets.name = Kit.text(content, 10, 40, WIDTH - 20, 22, "", GOLD, ui.AlignMode.TOPLEFT)
    widgets.npc = Kit.text(content, 10, 64, WIDTH - 20, 20, "", GREY, ui.AlignMode.TOPLEFT)
    for i = 1, NOTE_ROWS do
        widgets.notes[i] = Kit.text(content, 10, 88 + (i - 1) * 20, WIDTH - 20, 20, "", AMBER, ui.AlignMode.TOPLEFT)
    end

    local buttonsY = 96 + NOTE_ROWS * 20
    Kit.buttonAt(content, "Load into Card Builder", 10, buttonsY, WIDTH - 20, 32, function()
        if queue[index] ~= nil then
            Builder.loadCandidate(queue[index])
        end
    end, "positive", "Fill the Card Builder in from this candidate, to check, frame and copy it")
    local half = (WIDTH - 26) // 2
    Kit.buttonAt(content, "Done", 10, buttonsY + 40, half, 30, function() finish("done") end, "neutral",
        "The card is made: take it off the list")
    Kit.buttonAt(content, "Skip", 16 + half, buttonsY + 40, half, 30, function() finish("skipped") end, "negative",
        "Not a card: take it off the list")
    refresh()
end

function WikiReview.hide()
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, widgets = nil, nil, {}
end

function WikiReview.toggle()
    if window ~= nil then
        WikiReview.hide()
    else
        WikiReview.show()
    end
end

return WikiReview
