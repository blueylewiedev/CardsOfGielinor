-- core/overlay.lua
-- Applies an overlay: the card changes published since the version Jagex last approved (docs/overlay.jsonl,
-- made by dev/build_overlay.py; see CONTRIBUTING.md). This file does no networking (core/overlayloader.lua
-- fetches the text). The format is JSON lines:
--
--     {"base":"0.1.0","format":1,"revision":3}      the header: the version it is for
--     {"id":"swamp_frog","name":...}                 a new card, or a card that replaces the one with that id
--     {"deprecated":"old_card_id"}                   a card to take out of the game
--
-- It is applied a few lines at a time (Overlay.step, from a tick), so a big overlay never stalls a frame, and it
-- never raises an error: a line that is not sound is skipped and described in job.problems, and the rest is still
-- applied. The client crashes on coroutines, so the work is split by hand.
--
--     local job, why = Overlay.begin(text)     nil and why if the overlay is not for this plugin
--     repeat until Overlay.step(job, 100)     once a tick; true when everything is applied
--
-- Safety: the header's format must be one this plugin reads and its base must be this plugin's version, and an
-- overlay may retire only a few cards (a wrongly built one cannot empty the game).

local Cards = require("core/cards")
local Json = require("core/json")
local Version = require("core/version")

local Overlay = {}

Overlay.FORMAT = 1                  -- the layout of the file this code reads
Overlay.MAX_RETIRED_SHARE = 0.05    -- an overlay may retire this share of the cards...
Overlay.MIN_RETIRED_ALLOWED = 50    -- ...or this many, whichever is more
local MAX_PROBLEMS = 20             -- how many skipped lines are described

local find, sub = string.find, string.sub

-- The line starting at `pos` (without its line break) and where the next starts.
local function nextLine(text, pos)
    local stop = find(text, "\n", pos, true)
    if stop == nil then
        return sub(text, pos), #text + 1
    end
    return sub(text, pos, stop - 1), stop + 1
end

local function trim(line)
    return (string.gsub(line, "^%s+", ""):gsub("%s+$", ""))
end

-- Starts applying an overlay. `version` is the plugin's version (core/version.lua unless a test gives one).
-- Returns a job for Overlay.step, or nil and the reason it is not applied (an empty or damaged header, a format
-- this plugin does not read, or an overlay built for another version).
function Overlay.begin(text, version)
    version = version or Version.number
    if type(text) ~= "string" then
        return nil, "no overlay text"
    end
    local pos, header = 1, nil
    while pos <= #text do
        local line
        line, pos = nextLine(text, pos)
        line = trim(line)
        if line ~= "" then
            header = line
            break
        end
    end
    if header == nil then
        return nil, "the overlay is empty"
    end
    local head, err = Json.decode(header)
    if type(head) ~= "table" then
        return nil, "the overlay header is not JSON (" .. tostring(err) .. ")"
    end
    if head.format ~= Overlay.FORMAT then
        return nil, "the overlay is format " .. tostring(head.format) .. ", this version reads format " .. Overlay.FORMAT
    end
    if head.base ~= version then
        return nil, "the overlay is for version " .. tostring(head.base) .. ", this is version " .. version
    end
    return {
        text = text, pos = pos, finished = false, base = head.base,
        revision = type(head.revision) == "number" and head.revision or nil,
        lines = 0, added = 0, replaced = 0, retired = 0, skipped = 0, problems = {},
        allowedRetired = math.max(Overlay.MIN_RETIRED_ALLOWED, math.floor(#Cards.list * Overlay.MAX_RETIRED_SHARE)),
    }
end

local function skip(job, why)
    job.skipped = job.skipped + 1
    if #job.problems < MAX_PROBLEMS then
        job.problems[#job.problems + 1] = "line " .. job.lines .. ": " .. tostring(why)
    end
end

local function applyLine(job, line)
    local value, err = Json.decode(line)
    if type(value) ~= "table" then
        skip(job, err or "not an object")
        return
    end
    if value.deprecated ~= nil then
        if type(value.deprecated) ~= "string" then
            skip(job, "deprecated needs a card id")
        elseif job.retired >= job.allowedRetired then
            skip(job, "more cards retired than an overlay may (" .. job.allowedRetired .. "): " .. value.deprecated .. " kept")
        elseif Cards.deprecate(value.deprecated) then
            job.retired = job.retired + 1
        end                                      -- (a card that is not there needs no retiring)
        return
    end
    local existed = type(value.id) == "string" and Cards.byId[value.id] ~= nil
    local ok, why = Cards.register(value)
    if not ok then
        skip(job, why)
    elseif existed then
        job.replaced = job.replaced + 1
    else
        job.added = job.added + 1
    end
end

-- Applies up to `budget` more lines. Returns true once the whole overlay is applied (the cards are then put back
-- in rarity order), false if there is more.
function Overlay.step(job, budget)
    local done = 0
    while done < budget and job.pos <= #job.text do
        local line
        line, job.pos = nextLine(job.text, job.pos)
        line = trim(line)
        if line ~= "" then
            done = done + 1
            job.lines = job.lines + 1
            applyLine(job, line)
        end
    end
    if job.pos > #job.text then
        if not job.finished then
            job.finished = true
            Cards.resort()
        end
        return true
    end
    return false
end

-- One line saying what a finished job did.
function Overlay.summary(job)
    return "revision " .. tostring(job.revision) .. " of the overlay for version " .. tostring(job.base) .. ": "
        .. job.added .. " new cards, " .. job.replaced .. " changed, " .. job.retired .. " retired, "
        .. job.skipped .. " lines skipped"
end

return Overlay
