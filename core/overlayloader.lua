-- core/overlayloader.lua
-- Fetches the card overlay (docs/overlay.jsonl on the project's GitHub Pages site) when the plugin starts and
-- applies it with core/overlay.lua, so card fixes and new cards reach players between Jagex's reviews. If the
-- fetch fails, or the overlay is not for this version, the plugin simply has the cards it shipped with.
--
-- The client crashes when a request is sent from a coroutine or from inside another request's callback (other
-- plugin developers' findings, checked with dev/httpprobe.lua), so:
--   * everything runs from Event.Logic ticks (50 a second) and nothing uses a coroutine;
--   * a request is only ever started from a tick, and its callback only records that it finished;
--   * the response is read, and the overlay applied (100 lines a tick), on later ticks.
-- A response counts only if the code is 200 and `successful` is true: on a 404 the data is the host's error page.
--
-- It needs the httpAccess permission and the "cards" url in plugin.json. Without the permission it waits (the
-- player may grant it later); the dev copy asks for it on every start, as core/identity.lua does for tracking.

local Overlay = require("core/overlay")

local Loader = {}

local SUBSCRIBER = "cardcollector_overlayloader"
local PATH = "/CardsOfGielinor/overlay.jsonl"      -- on the "cards" url (https://blueylewiedev.github.io)
local CHECK_EVERY = 100                -- ticks between looks for the permission (2 s)
local WARN_AFTER = 500                 -- ticks without the permission before saying so (10 s)
local LINES_PER_TICK = 50                -- about 5 ms of work a tick (measured: 100 lines take about 10 ms)
local TIMEOUT = 1500                   -- ticks to wait for a response (30 s)
local RETRY_AFTER = { 3000, 15000 }    -- ticks before the second and third try (1 and 5 minutes); then give up

local DEV_GRANTS_PERMISSION = true

-- phase: "idle" (not started), "waiting" (for the permission or the next try), "fetching", "applying",
-- "retrying", "done", "ignored" (an overlay not for this version), "failed", "off" (no url in plugin.json)
local state = nil
local subscribed = false

local function reset()
    state = { phase = "idle", ticks = 0, nextCheck = 0, attempt = 0, generation = 0, warned = false,
        retryAt = 0, startedAt = 0, request = nil, finished = nil, job = nil, revision = nil, message = "not started" }
end
reset()

local function say(...)
    log("card updates:", ...)
end

local function settle(phase, message)
    state.phase, state.message = phase, message
    state.request, state.finished = nil, nil
end

-- A failed try: try again after a pause, or give up after the last.
local function retryOrFail(reason)
    local delay = RETRY_AFTER[state.attempt]
    if delay == nil then
        settle("failed", reason)
        say("giving up for this session:", reason)
        return
    end
    state.retryAt = state.ticks + delay
    settle("retrying", reason)
    say(reason .. "; trying again in " .. math.floor(delay / 50) .. " seconds")
end

-- Sends the request. Only called from a tick.
local function beginFetch(plugin)
    state.attempt = state.attempt + 1
    state.generation = state.generation + 1
    local generation = state.generation
    local ok, err = pcall(function()
        local request = (Loader.http or HTTPRequest).new(plugin.urls.cards, PATH)
        state.request, state.finished, state.startedAt = request, nil, state.ticks
        request:Get(function(finished)
            -- only record it: no new request and no work in here. A late answer to a given-up request is ignored.
            if state.generation == generation then
                state.finished = finished
            end
        end)
    end)
    if not ok then
        retryOrFail("could not send the request (" .. tostring(err) .. ")")
        return
    end
    state.phase, state.message = "fetching", "fetching"
end

-- A finished request, read on a tick.
local function handleResponse(request)
    local code, successful, body = request.responseCode, request.successful, request.data
    if code ~= 200 or not successful then
        retryOrFail("the overlay could not be fetched (code " .. tostring(code) .. ")")
        return
    end
    local job, why = Overlay.begin(body)
    if job == nil then
        settle("ignored", why)
        say("not applied:", why)
        return
    end
    state.job = job
    state.phase, state.message, state.request, state.finished = "applying", "applying", nil, nil
end

-- Called every logic tick (the game's Event.Logic, 50 a second).
function Loader.tick()
    state.ticks = state.ticks + 1
    local phase = state.phase
    if phase == "waiting" then
        if state.ticks < state.nextCheck then
            return
        end
        state.nextCheck = state.ticks + CHECK_EVERY
        local plugin = Loader.plugin or Plugin
        if plugin.urls == nil or plugin.urls.cards == nil then
            settle("off", "no \"cards\" url in plugin.json")
            say("off:", state.message)
        elseif not plugin.HasPermission(PluginPermissions.httpAccess) then
            if not state.warned and state.ticks > WARN_AFTER then
                state.warned = true
                state.message = "waiting for the httpAccess permission"
                say("the httpAccess permission is not granted, so card updates are not fetched")
            end
        else
            beginFetch(plugin)
        end
    elseif phase == "fetching" then
        if state.finished ~= nil then
            handleResponse(state.finished)
        elseif state.ticks - state.startedAt > TIMEOUT then
            pcall(function() state.request:Cancel() end)
            state.generation = state.generation + 1                  -- a late answer is ignored
            retryOrFail("no response within " .. math.floor(TIMEOUT / 50) .. " seconds")
        end
    elseif phase == "applying" then
        if Overlay.step(state.job, LINES_PER_TICK) then
            local job = state.job
            settle("done", Overlay.summary(job))
            state.revision, state.job = job.revision, nil
            say(state.message)
            for _, problem in ipairs(job.problems) do
                say("skipped", problem)
            end
        end
    elseif phase == "retrying" then
        if state.ticks >= state.retryAt then
            state.phase, state.nextCheck = "waiting", 0
        end
    end
end

-- Gets ready to fetch (the first look for the permission is on the next tick). Tests call this and tick by hand.
function Loader.begin()
    reset()
    state.phase = "waiting"
end

-- Starts it for the running plugin: `devCopy` is true while the development tools are present.
function Loader.start(devCopy)
    if state.phase ~= "idle" then
        return
    end
    if devCopy and DEV_GRANTS_PERMISSION then
        local ok, err = pcall(function()
            ExecuteConsoleCommand("ppr CardCollector")
            ExecuteConsoleCommand("ppe CardCollector httpAccess")
        end)
        if not ok then
            log("could not ask for the httpAccess permission:", err)
        end
    end
    Loader.begin()
    if not subscribed then
        subscribed = true
        Event.Logic.Subscribe(SUBSCRIBER, function() Loader.tick() end)
    end
end

-- Fetches and applies it again (the Dev tools window's button): only once the last go has ended.
function Loader.refetch()
    local phase = state.phase
    if phase == "done" or phase == "ignored" or phase == "failed" or phase == "off" then
        local ticks = state.ticks
        Loader.begin()
        state.ticks = ticks
        return true
    end
    return false
end

function Loader.shutdown()
    if subscribed then
        subscribed = false
        pcall(function() Event.Logic.Unsubscribe(SUBSCRIBER) end)
    end
end

-- What it is doing: { phase, message, attempt, revision }.
function Loader.status()
    return { phase = state.phase, message = state.message, attempt = state.attempt, revision = state.revision }
end

return Loader
