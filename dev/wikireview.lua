-- dev/wikireview.lua
-- The Wiki Review window: steps through the card candidates made from the RuneScape Wiki by
-- dev/wiki_cards.py (dev/wiki_candidates.lua), NPCs and items, so the Card Builder becomes a
-- reviewer instead of a form. For each candidate, "Load into Card Builder" fills the builder in
-- (the NPC or item, name, description, suggested rarity, tags, deck file); there it is checked,
-- framed and copied as usual. "Next model" goes through the other models the wiki lists for it
-- (an NPC's other versions, an item's other ids), switching the builder's preview to each in
-- turn. Then "Done" (or "Skip") moves on. The drop-down shows the candidates from one category
-- (or page) asked for at a time, or all of them. The search button opens the Wiki Fetch window
-- (dev/wikifetch.lua), which writes the command that fetches more candidates.
--
-- Candidates already on a card (or a draft), with any of their models, are left out, and so are
-- the ones marked Done or Skipped; those marks are kept in the plugin's database (PersistentDB,
-- on this computer only). Only used by the developer tools (the dev folder).

local Kit = require("ui/kit")
local Cards = require("core/cards")
local Builder = require("dev/builder")
local WikiFetch = require("dev/wikifetch")

local WikiReview = {}

local DB_KEY = "dev_wiki_review"         -- { [wiki page] = "done" or "skipped" }
local WIDTH, HEIGHT = 480, 400
local INNER = Kit.contentWidth(WIDTH)
local NOTE_ROWS = 8
local NOTE_CHARS = 54       -- about how many letters of a note fit on a row
local ALL = "*all"                       -- the drop-down's "every source" choice

local WHITE = Vector4.new(1, 1, 1, 1)
local GREY = Vector4.new(0.75, 0.75, 0.75, 1)
local GOLD = Vector4.new(0.94, 0.81, 0.48, 1)
local AMBER = Vector4.new(0.94, 0.70, 0.35, 1)
local BLUE = Vector4.new(0.55, 0.78, 0.95, 1)

local window, content = nil, nil
local widgets = {}
local remaining = {}  -- every candidate still to review
local filter = ALL    -- the source shown (a category or page asked for), or ALL
local queue = {}      -- the ones of `remaining` from that source
local index = 1       -- the one shown

local function reviewed()
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(DB_KEY) end)
    return (ok and type(saved) == "table") and saved or {}
end

local function mark(candidate, verdict)
    local saved = reviewed()
    saved[candidate.page] = verdict
    pcall(function() PersistentDB:SetStructuredData(DB_KEY, saved) end)
end

-- The item config names by id, from the client's own list (read once, the first time an item
-- candidate is looked at). The list can come as name -> id or id -> name; both are read, as the
-- Item probe does.
local itemNames = nil
local function itemName(objId)
    if itemNames == nil then
        itemNames = {}
        local ok, err = pcall(function()
            for key, value in pairs(id.Obj) do
                local number, name = key, value
                if type(key) == "string" and type(value) == "number" then
                    number, name = value, key
                end
                if type(number) == "number" and type(name) == "string" and itemNames[number] == nil then
                    itemNames[number] = name
                end
            end
        end)
        local count = 0
        for _ in pairs(itemNames) do
            count = count + 1
        end
        log("wiki review: read", count, "item names from the client" .. (ok and "" or (" (" .. tostring(err) .. ")")))
    end
    return itemNames[objId]
end

-- A candidate's models, as config names: for an NPC the one the wiki lists first, then its
-- others; for an item, each of its ids the client knows. Worked out once per candidate.
local function models(candidate)
    if candidate.models == nil then
        local list = {}
        if candidate.kind == "item" then
            for _, objId in ipairs(candidate.ids or {}) do
                local name = itemName(objId)
                if name ~= nil then
                    list[#list + 1] = name
                end
            end
        else
            list[1] = candidate.npc
            for _, other in ipairs(candidate.others or {}) do
                list[#list + 1] = other
            end
        end
        candidate.models = list
    end
    return candidate.models
end

-- The model of a candidate being looked at (Next model moves it on), or nil if it has none.
local function currentModel(candidate)
    return models(candidate)[candidate.model or 1]
end

-- What each card and draft shows, as "npc:NAME" and "item:NAME" (an NPC card shows art.npc, or
-- its id upper-cased; its variants can show others; an item card shows art.item or its id).
local function subjectsInDeck()
    local used = {}
    local function scan(list)
        for _, card in ipairs(list) do
            local kind = Cards.kindOf(card) == "item" and "item" or "npc"
            local art = card.art or {}
            local named = art[kind]
            used[kind .. ":" .. ((named ~= nil and named ~= "") and named or string.upper(card.id))] = true
            for _, variant in ipairs(card.variants or {}) do
                if variant[kind] ~= nil and variant[kind] ~= "" then
                    used[kind .. ":" .. variant[kind]] = true
                end
            end
        end
    end
    scan(Cards.list)
    scan(Cards.drafts)
    return used
end

-- Reads the candidates again, leaving out the ones done, skipped or already on a card (with any
-- of their models). Returns the list, or nil if dev/wiki_candidates.lua has not been made yet.
local function loadRemaining()
    local ok, candidates = pcall(require, "dev/wiki_candidates")
    if not ok or type(candidates) ~= "table" then
        return nil
    end
    local done, inDeck, list = reviewed(), subjectsInDeck(), {}
    for _, candidate in ipairs(candidates) do
        local kind = candidate.kind == "item" and "item" or "npc"
        local made = false
        for _, model in ipairs(models(candidate)) do
            made = made or inDeck[kind .. ":" .. model]
        end
        -- (Marks used to be kept by NPC name; those still count.)
        if not (done[candidate.page] or done[candidate.npc or ""]) and not made then
            list[#list + 1] = candidate
        end
    end
    return list
end

local function fromSource(candidate, source)
    for _, from in ipairs(candidate.sources or {}) do
        if from == source then
            return true
        end
    end
    return false
end

-- The drop-down's choices: all, then each source with how many of its candidates are left.
local function filterEntries()
    local counts, names = {}, {}
    for _, candidate in ipairs(remaining) do
        for _, source in ipairs(candidate.sources or {}) do
            if counts[source] == nil then
                names[#names + 1] = source
            end
            counts[source] = (counts[source] or 0) + 1
        end
    end
    table.sort(names)
    local entries = { { label = "All (" .. #remaining .. ")", value = ALL } }
    for _, name in ipairs(names) do
        entries[#entries + 1] = { label = name .. " (" .. counts[name] .. ")", value = name }
    end
    return entries, counts
end

-- Narrows the list to the chosen source (back to all if it has none left), keeping the
-- drop-down's counts up to date.
local function applyFilter()
    local entries, counts = filterEntries()
    if filter ~= ALL and counts[filter] == nil then
        filter = ALL
    end
    queue = {}
    for _, candidate in ipairs(remaining) do
        if filter == ALL or fromSource(candidate, filter) then
            queue[#queue + 1] = candidate
        end
    end
    if index > #queue then
        index = 1
    end
    if widgets.filter ~= nil then
        widgets.filter.set(entries, filter)
    end
end

local function setText(widget, text, colour)
    widget.content = text
    if colour ~= nil then
        pcall(function() widget.colour = colour end)
    end
end

-- Breaks a note into lines of at most `limit` letters, at spaces (a longer word has its own line).
local function wrapLines(text, limit)
    local lines, line = {}, ""
    for word in string.gmatch(text, "%S+") do
        if line ~= "" and #line + 1 + #word > limit then
            lines[#lines + 1] = line
            line = word
        else
            line = line == "" and word or (line .. " " .. word)
        end
    end
    if line ~= "" then
        lines[#lines + 1] = line
    end
    return lines
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
        setText(widgets.name, "Fetch candidates with the search button above,", GREY)
        setText(widgets.subject, "then prf and open this window again.", GREY)
        return
    end
    setText(widgets.status, "Candidate " .. index .. " of " .. #queue, WHITE)
    setText(widgets.name, candidate.name .. "  (wiki: " .. candidate.page .. ")", GOLD)
    local noun = candidate.kind == "item" and "Item " or "NPC "
    local count = #models(candidate)
    if count == 0 then
        setText(widgets.subject, noun .. "not known to the client (ids " .. table.concat(candidate.ids or {}, ", ") .. ")", AMBER)
    else
        setText(widgets.subject, noun .. currentModel(candidate)
            .. (count > 1 and ("  (model " .. (candidate.model or 1) .. " of " .. count .. ")") or ""), GREY)
    end
    local row = 0
    for _, note in ipairs(candidate.notes or {}) do
        for _, line in ipairs(wrapLines(note, NOTE_CHARS)) do
            row = row + 1
            if row <= NOTE_ROWS then
                setText(widgets.notes[row], line, AMBER)
            end
        end
    end
end

-- Shows the candidate's next model, going round to the first after the last, and switches the
-- Card Builder to it if the builder has this candidate loaded.
local function nextModel()
    local candidate = queue[index]
    if candidate == nil or #models(candidate) < 2 then
        return
    end
    candidate.model = (candidate.model or 1) % #models(candidate) + 1
    if widgets.loaded == candidate and Builder.isOpen() then
        Builder.useModel(currentModel(candidate), candidate)
    end
    refresh()
end

-- Moves to another candidate (dir = 1 next, -1 back), going round at the ends.
local function step(dir)
    if #queue > 0 then
        index = (index - 1 + dir) % #queue + 1
    end
    refresh()
end

-- Saying what happened to the card in the queue, under the buttons.
local function queueMessage(text)
    if widgets.queueText ~= nil then
        widgets.queueText.content = text
    end
end

-- Adds the card in the Card Builder to the card queue in the database, if it is the candidate
-- being marked Done: dev/card_queue.py (run on this computer) writes the queued cards into their
-- deck files. Each card is a key of its own (dev_card_queue_0001...), so none is overwritten.
local QUEUE_KEY, SEQ_KEY = "dev_card_queue_", "dev_card_queue_seq"
local function queueCard(candidate)
    if widgets.loaded ~= candidate or not Builder.isOpen() then
        queueMessage("Not queued: this candidate is not loaded in the Card Builder")
        return
    end
    local entry, why = Builder.queueEntry()
    if entry == nil then
        queueMessage("Not queued: " .. why)
        return
    end
    local ok, seq = pcall(function() return PersistentDB:GetStructuredData(SEQ_KEY) end)
    local number = ((ok and type(seq) == "table" and tonumber(seq.n)) or 0) + 1
    local saved = pcall(function()
        PersistentDB:SetStructuredData(QUEUE_KEY .. string.format("%04d", number), entry)
        PersistentDB:SetStructuredData(SEQ_KEY, { n = number })
    end)
    queueMessage(saved and ("Queued " .. entry.id .. " (#" .. number .. ") for " .. entry.deck) or "Not queued: the database refused it")
end

-- Marks the current candidate and takes it off the list.
local function finish(verdict)
    local candidate = queue[index]
    if candidate == nil then
        return
    end
    if verdict == "done" then
        queueCard(candidate)
    end
    mark(candidate, verdict)
    for i, other in ipairs(remaining) do
        if other == candidate then
            table.remove(remaining, i)
            break
        end
    end
    applyFilter()            -- (index now points at the one after it)
    refresh()
end

-- Takes the marks of `verdict` ("skipped") off the candidates, leaving the others as they are.
local function unmark(verdict)
    local saved = reviewed()
    for page, mark in pairs(saved) do
        if mark == verdict then
            saved[page] = nil
        end
    end
    pcall(function() PersistentDB:SetStructuredData(DB_KEY, saved) end)
end

-- Reads the candidates again (all of them, or after Reset).
local function reload()
    remaining = loadRemaining() or {}
    index = 1
    applyFilter()
    refresh()
end

function WikiReview.show()
    if window ~= nil then
        return
    end
    widgets = { notes = {} }
    local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
    window, content = Kit.window(gameWindow, "Wiki Review", WIDTH, HEIGHT + Kit.titleBarHeight(),
        function() WikiReview.hide() end, 0.75, 0.1)

    Kit.iconButton(content, "ARROW_LEFT", 10, 6, function() step(-1) end, "Previous candidate", "Back", 60)
    Kit.iconButton(content, "ARROW_RIGHT", 40, 6, function() step(1) end, "Next candidate", "Next", 60)
    widgets.status = Kit.text(content, 74, 4, 220, 28, "", WHITE, ui.AlignMode.TOPLEFT)
    Kit.iconButton(content, "SEARCH", INNER - 54, 6, WikiFetch.toggle, "Fetch more candidates from the wiki",
        "Fetch", 70)
    Kit.iconButton(content, "REFRESH", INNER - 84, 6, function()
        Kit.confirm(gameWindow, "Review the skipped again?", "Every candidate marked Skip comes back. Those marked Done stay off the list.",
            "Bring back skipped", function()
                unmark("skipped")
                reload()
            end)
    end, "Bring back only the candidates marked Skip", "Skipped", 70)
    Kit.iconButton(content, "UNDO", INNER - 24, 6, function()
        Kit.confirm(gameWindow, "Review again?", "Every candidate marked Done or Skip comes back.", "Review again", function()
            pcall(function() PersistentDB:SetStructuredData(DB_KEY, {}) end)
            reload()
        end)
    end, "Bring back the candidates marked Done or Skip", "Reset", 70)

    -- (The drop-down that chooses the source goes between the header and these; it is made last.)
    local top = 76
    widgets.name = Kit.text(content, 10, top, INNER, 22, "", GOLD, ui.AlignMode.TOPLEFT)
    widgets.subject = Kit.text(content, 10, top + 24, INNER - 34, 20, "", GREY, ui.AlignMode.TOPLEFT)
    Kit.iconButton(content, "REFRESH", INNER - 20, top + 22, nextModel, "Next model", "Next model", 100)
    for i = 1, NOTE_ROWS do
        widgets.notes[i] = Kit.text(content, 10, top + 48 + (i - 1) * 20, INNER, 20, "", AMBER, ui.AlignMode.TOPLEFT)
    end

    local buttonsY = top + 56 + NOTE_ROWS * 20
    Kit.buttonAt(content, "Load into Card Builder", 10, buttonsY, INNER, 32, function()
        local candidate = queue[index]
        if candidate ~= nil and currentModel(candidate) ~= nil then
            Builder.loadCandidate(candidate, currentModel(candidate))
            widgets.loaded = candidate
        end
    end, "positive", "Fill the Card Builder in from this candidate, to check, frame and copy it")
    local half = (INNER - 6) // 2
    Kit.buttonAt(content, "Done", 10, buttonsY + 40, half, 30, function() finish("done") end, "neutral",
        "The card is made: take it off the list")
    Kit.buttonAt(content, "Skip", 16 + half, buttonsY + 40, half, 30, function() finish("skipped") end, "negative",
        "Not a card: take it off the list")

    widgets.queueText = Kit.text(content, 10, buttonsY + 76, INNER, 18, "", GREY, ui.AlignMode.TOPLEFT)

    -- Which category or page to review the candidates of (made last so its list opens on top).
    widgets.filter = Kit.dropdown(content, 10, 38, INNER, 28, { { label = "All", value = ALL } }, ALL,
        function(source)
            filter = source
            index = 1
            applyFilter()
            refresh()
        end)
    reload()
end

function WikiReview.hide()
    if widgets.filter ~= nil then
        widgets.filter.destroy()
    end
    if window ~= nil then
        pcall(function() window:Destroy() end)
    end
    window, content, widgets = nil, nil, {}
    WikiFetch.hide()
end

function WikiReview.toggle()
    if window ~= nil then
        WikiReview.hide()
    else
        WikiReview.show()
    end
end

return WikiReview
