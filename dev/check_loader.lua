-- dev/check_loader.lua
-- Checks the overlay: core/overlay.lua (applying the text) and core/overlayloader.lua (fetching it), without the
-- client or the network. The loader is run against a pretend HTTPRequest, Plugin and permission that the test
-- controls, ticked by hand. It checks the rules that matter most: a request is never started from a callback (a
-- known client crash), only a 200 that is `successful` counts, and an overlay for another version or format, or a
-- damaged one, never changes or breaks the game.
--
-- Run from the plugin's folder (CardsOfGielinor):  lua dev/check_loader.lua

package.path = "./?.lua;./dev/?.lua;" .. package.path

function log() end          -- the client's log function

local Cards = require("core/cards")
local Json = require("core/json")
local Overlay = require("core/overlay")
local Loader = require("core/overlayloader")
local Packs = require("core/packs")
local Version = require("core/version")
local Encode = require("jsonencode")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local function deepCopy(value)
    if type(value) ~= "table" then
        return value
    end
    local copy = {}
    for key, inner in pairs(value) do
        copy[key] = deepCopy(inner)
    end
    return copy
end

local function header(fields)
    local head = { base = Version.number, format = 1, revision = 1 }
    for key, value in pairs(fields or {}) do
        head[key] = value
    end
    return Encode.encode(head)
end

local function testCard(id, fields)
    local card = { id = id, name = "Test " .. id, kind = "item", rarity = "common", desc = "A test card.",
        art = { item = "TEST" }, tags = { category = { "armour" } } }
    for key, value in pairs(fields or {}) do
        card[key] = value
    end
    return card
end

local function overlayText(head, lines)
    local out = { head }
    for _, line in ipairs(lines) do
        out[#out + 1] = type(line) == "table" and Encode.encode(line) or line
    end
    return table.concat(out, "\n") .. "\n"
end

-- Runs a job to the end, returning how many steps it took.
local function runJob(job, budget)
    local steps = 0
    repeat
        steps = steps + 1
    until Overlay.step(job, budget) or steps > 100000
    return steps
end

local function cardCount()
    return #Cards.list
end

local function snapshot()
    local ids = {}
    for index, card in ipairs(Cards.list) do
        ids[index] = card.id .. ":" .. card.rarity
    end
    return table.concat(ids, ",")
end

local startCount, startSnapshot = cardCount(), snapshot()

-- The client's require gives nothing back for a module that returns text, so the version must be a table
check(type(Version) == "table" and type(Version.number) == "string", "core/version.lua returns a table with a text number")

-- Overlay.begin: when an overlay is not for this plugin -------------------------------------------------------------
do
    local function refused(text, what, version)
        local job, why = Overlay.begin(text, version)
        check(job == nil and type(why) == "string", what .. ": should not be applied")
    end
    refused(nil, "no text")
    refused("", "empty text")
    refused("\n  \n", "only blank lines")
    refused("not json\n", "a header that is not JSON")
    refused("[1,2]\n", "a header that is a list")
    refused("5\n", "a header that is a number")
    refused(header({ format = 2 }) .. "\n", "an unknown format")
    refused(header({ format = "1" }) .. "\n", "a format that is text")
    refused(header({ format = Json.null }) .. "\n", "a null format")
    refused(header({ base = "9.9.9" }) .. "\n", "an overlay for another version")
    refused(header() .. "\n", "an overlay for another version than the one asked for", "0.0.1")
    refused('{"format":1,"revision":1}\n', "a header with no base")
    check(Overlay.begin(header() .. "\n") ~= nil, "a header for this version and format is accepted")
    check(Overlay.begin("\n\n" .. header() .. "\n") ~= nil, "blank lines before the header are fine")
    check(Overlay.begin(header() .. "\r\n") ~= nil, "a header with a Windows line end is fine")
    check(Overlay.begin(header()) ~= nil, "a header with no line end at all is fine")
    check(Overlay.begin(header({ base = "0.0.1" }), "0.0.1") ~= nil, "the version asked for is the one compared")
    check(cardCount() == startCount, "refused overlays changed nothing")
end

-- Applying -------------------------------------------------------------------------------------------------------
do
    local first = Cards.list[1]
    local changed = deepCopy(first)
    changed.rarity = "legendary"
    changed.desc = "Changed by the overlay."
    local gone = Cards.list[2]
    local goneCopy = deepCopy(gone)
    local text = overlayText(header({ revision = 7 }), {
        testCard("zz_new_one"),
        changed,
        { deprecated = gone.id },
        testCard("zz_new_two", { rarity = "epic" }),
    })
    local job = Overlay.begin(text)
    check(job ~= nil and job.revision == 7, "the revision is read from the header")
    local steps = runJob(job, 2)
    check(steps == 2, "four lines at two a step take two steps (" .. steps .. ")")
    check(job.finished and job.added == 2 and job.replaced == 1 and job.retired == 1 and job.skipped == 0,
        "two added, one changed, one retired (" .. Overlay.summary(job) .. ")")
    check(Cards.byId["zz_new_one"] ~= nil and Cards.byId["zz_new_two"].rarity == "epic", "new cards are in")
    check(Cards.byId[first.id].rarity == "legendary" and Cards.byId[first.id].desc == "Changed by the overlay.",
        "a card is replaced")
    check(Cards.byId[first.id] == first, "a replaced card is the same table, changed in place")
    check(Cards.byId[gone.id] == nil, "a retired card is out of the lookup")
    local found = false
    for _, card in ipairs(Cards.list) do
        found = found or card.id == gone.id
    end
    check(not found, "a retired card is out of the list")
    local lastRank, ordered = 0, true
    for _, card in ipairs(Cards.list) do
        local rank = Cards.rarityRank[card.rarity]
        ordered = ordered and rank >= lastRank
        lastRank = rank
    end
    check(ordered, "the list is in rarity order once the job is done")

    -- applying it again changes nothing more
    local again = Overlay.begin(text)
    runJob(again, 100)
    check(again.added == 0 and again.replaced == 3 and again.retired == 0,
        "applying again: replaces what is there and retires nothing more (" .. Overlay.summary(again) .. ")")

    -- put the deck back
    Cards.deprecate("zz_new_one")
    Cards.deprecate("zz_new_two")
    Cards.register(goneCopy)
    first.rarity, first.desc = Cards.byId[first.id].rarity, first.desc
    local restore = deepCopy(changed)
    restore.rarity, restore.desc = Cards.byId[first.id].rarity, Cards.byId[first.id].desc
end

-- Bad lines are skipped, the rest is applied -------------------------------------------------------------------------
do
    local text = overlayText(header(), {
        testCard("zz_ok_before"),
        "this is not json",
        "[1,2,3]",
        '"just a string"',
        '{"deprecated":5}',
        { id = "zz_no_name", rarity = "common" },
        testCard("zz_bad_rarity", { rarity = "mythic" }),
        testCard("zz_bad_tag", { tags = { category = { "no_such_word" } } }),
        testCard("zz_draft", { art = { item = "" } }),
        testCard("zz_ok_after"),
        "",
        "   ",
    })
    local job = Overlay.begin(text)
    runJob(job, 3)
    check(job.added == 2 and job.skipped == 8, "two good lines applied and eight bad ones skipped ("
        .. Overlay.summary(job) .. ")")
    check(Cards.byId["zz_ok_before"] ~= nil and Cards.byId["zz_ok_after"] ~= nil, "the good lines around bad ones are applied")
    check(Cards.byId["zz_bad_rarity"] == nil and Cards.byId["zz_bad_tag"] == nil and Cards.byId["zz_draft"] == nil,
        "the bad cards are not in the game")
    check(#job.problems == 8 and string.find(job.problems[1], "line 2", 1, true) ~= nil, "each skipped line is described")
    Cards.deprecate("zz_ok_before")
    Cards.deprecate("zz_ok_after")
end

-- An overlay cannot retire more than a few cards ---------------------------------------------------------------------
do
    local allowed = Overlay.begin(header() .. "\n").allowedRetired
    check(allowed >= 50, "an overlay may always retire at least 50 cards (" .. allowed .. ")")
    local total = allowed + 30
    local lines, saved = {}, {}
    for index = 1, total do
        lines[index] = { deprecated = Cards.list[index].id }
        saved[index] = Cards.list[index]
    end
    local job = Overlay.begin(overlayText(header(), lines))
    runJob(job, 100)
    check(job.retired == allowed and job.skipped == 30, "retiring stops at the limit (" .. Overlay.summary(job) .. ")")
    for _, card in ipairs(saved) do
        if Cards.byId[card.id] == nil then
            Cards.register(card)
        end
    end
    Cards.resort()
    check(cardCount() == startCount, "the deck is back to its size after the test")
end

-- Pack sizes are worked out again after a change -------------------------------------------------------------------------
do
    local before = Packs.poolSize("standard")
    local job = Overlay.begin(overlayText(header(), { testCard("zz_pool_card") }))
    runJob(job, 100)
    check(Packs.poolSize("standard") == before + 1, "a new card changes the pack size without a restart (" .. before .. ", "
        .. Packs.poolSize("standard") .. ")")
    Cards.deprecate("zz_pool_card")
    check(Packs.poolSize("standard") == before, "and a retired one changes it back")
end

-- A real-sized overlay: every card of the deck as a replacement ------------------------------------------------------------
do
    local lines = {}
    for index, card in ipairs(Cards.list) do
        lines[index] = card
    end
    local job = Overlay.begin(overlayText(header(), lines))
    local started = os.clock()
    local steps = runJob(job, 100)
    local took = os.clock() - started
    check(job.replaced == #lines and job.added == 0 and job.skipped == 0, "every card of the deck is replaced by itself ("
        .. Overlay.summary(job) .. ")")
    check(steps == math.ceil(#lines / 100), "at 100 lines a step it takes " .. math.ceil(#lines / 100) .. " steps (" .. steps .. ")")
    check(snapshot() == startSnapshot or cardCount() == startCount, "the deck is as it was")
    print(string.format("applied %d cards in %d steps, %.2f s in all (%.1f ms a step)", #lines, steps, took, took / steps * 1000))
end

-- The loader ---------------------------------------------------------------------------------------------------------
-- A pretend HTTPRequest. The test completes requests by hand. Starting one from inside a callback is the crash the
-- real client has, so the pretend one fails the test if that happens.
local requests, inCallback, granted = {}, false, true

local FakeRequest = {}
FakeRequest.__index = FakeRequest
function FakeRequest.new(base, path)
    local request = setmetatable({ base = base, path = path, cancelled = false }, FakeRequest)
    requests[#requests + 1] = request
    check(not inCallback, "a request was started from inside a callback")
    return request
end
function FakeRequest:Get(completion)
    check(not inCallback, "Get was called from inside a callback")
    self.completion = completion
end
function FakeRequest:Cancel()
    self.cancelled = true
end
local function complete(request, code, body, successful)
    request.responseCode, request.data, request.successful = code, body, successful
    inCallback = true
    request.completion(request)
    inCallback = false
end

Plugin = { urls = { cards = "https://example.test" }, HasPermission = function() return granted end }
PluginPermissions = { httpAccess = "httpAccess" }
Loader.http = FakeRequest

local function tick(count)
    for _ = 1, count or 1 do
        Loader.tick()
    end
end

local function fresh()
    requests, granted = {}, true
    Plugin.urls = { cards = "https://example.test" }
    Loader.begin()
end

local good = overlayText(header({ revision = 4 }), { testCard("zz_loaded") })

-- the whole happy path
fresh()
check(Loader.status().phase == "waiting", "the loader starts out waiting")
tick(1)
check(#requests == 1 and requests[1].base == "https://example.test" and requests[1].path == "/CardsOfGielinor/overlay.jsonl",
    "it asks for the overlay file on the cards url")
check(Loader.status().phase == "fetching", "and waits for the answer")
tick(50)
check(#requests == 1, "it does not ask again while it waits")
complete(requests[1], 200, good, true)
check(#requests == 1 and Cards.byId["zz_loaded"] == nil, "answering applies nothing and starts nothing at once")
tick(1)
check(Loader.status().phase == "applying" or Loader.status().phase == "done", "the next tick reads the answer")
tick(2)
check(Loader.status().phase == "done" and Cards.byId["zz_loaded"] ~= nil, "the overlay is applied")
check(Loader.status().revision == 4, "the revision is reported")
Cards.deprecate("zz_loaded")

-- a big overlay takes several ticks
fresh()
do
    local lines = {}
    for index = 1, 250 do
        lines[index] = testCard("zz_batch_" .. index)
    end
    tick(1)
    complete(requests[1], 200, overlayText(header(), lines), true)
    tick(1)
    local ticks = 0
    while Loader.status().phase == "applying" do
        tick(1)
        ticks = ticks + 1
        if ticks > 50 then break end
    end
    check(ticks == 5 and Loader.status().phase == "done", "250 lines are applied over 5 ticks, 50 a tick (" .. ticks .. ")")
    for index = 1, 250 do
        Cards.deprecate("zz_batch_" .. index)
    end
end

-- no permission yet: it waits, then goes ahead when granted
fresh()
granted = false
tick(1500)
check(#requests == 0 and Loader.status().phase == "waiting", "without the permission it makes no request")
granted = true
tick(100)
check(#requests == 1, "it fetches once the permission is granted")

-- no url in plugin.json
fresh()
Plugin.urls = {}
tick(1)
check(Loader.status().phase == "off" and #requests == 0, "with no cards url it is off")

-- a 404 is not an overlay; it tries again, then works
fresh()
tick(1)
complete(requests[1], 404, "<html>Not found</html>", false)
tick(1)
check(Loader.status().phase == "retrying" and Cards.byId["zz_loaded"] == nil, "a 404 is a failure, not an overlay")
tick(2900)
check(#requests == 1, "it waits a minute before trying again")
tick(150)
check(#requests == 2, "then it tries again")
complete(requests[2], 200, good, true)
tick(5)
check(Loader.status().phase == "done" and Cards.byId["zz_loaded"] ~= nil, "and the second try can succeed")
Cards.deprecate("zz_loaded")

-- a 200 that is not successful, and a successful one that is not 200, both fail
fresh()
tick(1)
complete(requests[1], 200, good, false)
tick(1)
check(Loader.status().phase == "retrying", "a 200 that is not successful is a failure")
fresh()
tick(1)
complete(requests[1], 304, good, true)
tick(1)
check(Loader.status().phase == "retrying", "a code other than 200 is a failure")

-- three failures and it gives up for the session
fresh()
tick(1)
complete(requests[1], 500, "", false)
tick(3100)
complete(requests[2], 500, "", false)
tick(15100)
complete(requests[3], 500, "", false)
tick(2)
check(#requests == 3 and Loader.status().phase == "failed", "after three failures it gives up")
tick(40000)
check(#requests == 3, "and does not try a fourth time")

-- no answer: it times out, and a late answer to the old request is ignored
fresh()
tick(1)
tick(1501)
check(requests[1].cancelled and Loader.status().phase == "retrying", "a request with no answer is cancelled and retried")
complete(requests[1], 200, good, true)
tick(5)
check(Cards.byId["zz_loaded"] == nil, "a late answer to a given-up request is ignored")

-- an overlay for another version or format is ignored, not retried, and changes nothing
for _, other in ipairs({ header({ base = "9.9.9" }), header({ format = 2 }), "garbage" }) do
    fresh()
    tick(1)
    complete(requests[1], 200, overlayText(other, { testCard("zz_loaded") }), true)
    tick(3)
    check(Loader.status().phase == "ignored" and Cards.byId["zz_loaded"] == nil and #requests == 1,
        "an overlay that is not for this version is ignored (" .. Loader.status().message .. ")")
end

-- a request that cannot even be made
fresh()
Loader.http = { new = function() error("no network") end }
tick(1)
check(Loader.status().phase == "retrying", "an error making the request is a failure, not a crash")
Loader.http = FakeRequest

-- an error inside the loader is caught: it stops for the session and is logged once
do
    local booby = setmetatable({}, { __index = function() error("boom") end })
    Loader.http = { new = function() return { Get = function(_, completion) completion(booby) end } end }
    fresh()
    local logged, realLog = 0, log
    log = function() logged = logged + 1 end
    Loader.safeTick()                    -- sends the request; the pretend one answers at once
    Loader.safeTick()                    -- reads the answer: reading it raises an error
    log = realLog
    check(Loader.status().phase == "failed" and logged == 1, "an error inside the loader stops it and is logged once (" .. logged .. ")")
    Loader.safeTick()
    Loader.safeTick()
    check(Loader.status().phase == "failed", "and it stays stopped")
    Loader.http = FakeRequest
end

-- fetching again
fresh()
tick(1)
complete(requests[1], 200, good, true)
tick(5)
check(Loader.refetch() == true and Loader.status().phase == "waiting", "after it is done, a fetch can be started again")
check(Loader.refetch() == false, "but not while one is under way")
Cards.deprecate("zz_loaded")

check(cardCount() == startCount, "the deck ends the test at its starting size (" .. cardCount() .. " and " .. startCount .. ")")

if failures > 0 then
    io.stderr:write(failures .. " loader check(s) failed\n")
    os.exit(1)
end
print("Loader checks passed.")
