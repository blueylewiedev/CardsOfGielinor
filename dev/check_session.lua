-- dev/check_session.lua
-- Checks core/session.lua against stand-ins for the client and for the parts it drives (storage, identity, the Slayer and boss
-- listeners): nothing happens before a character is known, an unreadable save is tried again every tick and never saved over,
-- a loaded collection saves at its pace and counts play time, XP is credited only while one is loaded, and reaching the login
-- screen saves and forgets it.
--
-- Run from the plugin's folder:  lua dev/check_session.lua

package.path = "./?.lua;" .. package.path

function log() end

local failures = 0
local function check(ok, what)
    if not ok then failures = failures + 1; print("FAIL: " .. what) end
end

-- The client's events: handlers by name.
local handlers = {}
Event = setmetatable({}, { __index = function(_, event)
    return {
        Subscribe = function(name, fn) handlers[event .. "|" .. name] = fn end,
        Unsubscribe = function(name) handlers[event .. "|" .. name] = nil end,
    }
end })
GameState = { LOGINSCREEN = 1, LOBBY = 2, INGAME = 3 }

local character = nil                      -- the logged-in character's name, or nil
Player = {
    IsAvailable = function() return character ~= nil end,
    GetEntity = function() return { displayName = character } end,
}

-- Stand-ins for what the session drives; each records what it was asked.
local calls = {}
local function record(name) calls[#calls + 1] = name end
local function count(name)
    local n = 0
    for _, c in ipairs(calls) do if c == name then n = n + 1 end end
    return n
end

local readable = false                     -- whether the save can be read
local lastOpts = nil
local saves, saveWorks = 0, true
local playTicks = {}
package.loaded["core/storage"] = {
    loadOrAdopt = function(_, _, opts)
        lastOpts = opts
        if not readable then return nil, false, "unreadable" end
        return { credits = 5, dirty = false }, false
    end,
    save = function() saves = saves + 1; return saveWorks end,
    addPlayTicks = function(_, ticks) playTicks[#playTicks + 1] = ticks end,
    countUniqueOwned = function() return 0 end,
    countVariantsOwned = function() return 0 end,
}
package.loaded["core/identity"] = {
    profile = function(name)
        return name and { name = name, key = "key-" .. name, kind = "tracking", how = "test" } or nil
    end,
    reset = function() record("identity.reset") end,
}
package.loaded["core/slayerevents"] = { begin = function() record("slayer.begin") end, finish = function() record("slayer.finish") end }
package.loaded["core/bossevents"] = { begin = function() record("boss.begin") end, finish = function() record("boss.finish") end }
package.loaded["core/rate"] = { TICKS_PER_MINUTE = 100, tick = function() record("rate.tick") end, reset = function() record("rate.reset") end }
local credited = 0
package.loaded["core/earning"] = {
    xpGainFromEvent = function(e) return e.gain end,
    addXP = function(_, gain) credited = credited + gain end,
}

local Session = require("core/session")
Session.start()
local tick = handlers["SkillTransmit|cardcollector_xp"]
local xp = tick
local state = handlers["GameStateChanged|cardcollector_state"]
check(xp ~= nil and state ~= nil, "starting listens for XP and for the game state")

-- No character yet: nothing loads
for _ = 1, 5 do Session.tick() end
check(Session.getState() == nil and Session.keyKind() == nil, "no character: no collection")
xp({ gain = 50 })
check(credited == 0, "XP before a collection has loaded is ignored")

-- A character whose save cannot be read: tried every tick, never saved over
character = "Tester"
for _ = 1, 19 do Session.tick() end
check(Session.getState() == nil and saves == 0, "an unreadable save is not loaded, and nothing is saved")
check(lastOpts ~= nil and lastOpts.acceptMissingMain == false, "it is not accepted as missing yet")
Session.tick()                                   -- the 20th try
Session.tick()
check(lastOpts.acceptMissingMain == true, "after 20 tries a save with no main entry is accepted")

-- It becomes readable
readable = true
Session.tick()
local collection = Session.getState()
check(collection ~= nil and collection.credits == 5, "the collection loads once it can be read")
check(Session.keyKind() == "tracking", "the key kind is known")
check(count("slayer.begin") == 1 and count("boss.begin") == 1, "Slayer and boss kills start from where the character stands")
xp({ gain = 30 })
check(credited == 30, "XP is credited once loaded")
xp({ gain = 0 })
check(credited == 30, "no gain, no credit")

-- Saving at a steady pace
collection.dirty = true
for _ = 1, 9 do Session.tick() end
check(saves == 0, "no save in the first ticks")
Session.tick()                                   -- the 10th since the load
check(saves == 1 and collection.dirty == false, "a pending change is saved every 10 ticks")
saveWorks = false
collection.dirty = true
for _ = 1, 10 do Session.tick() end
check(saves == 2 and collection.dirty == true, "a refused save leaves the change pending")
saveWorks = true
for _ = 1, 10 do Session.tick() end
check(saves == 3 and collection.dirty == false, "and it is tried again")
for _ = 1, 20 do Session.tick() end
check(saves == 3, "nothing pending, nothing saved")

-- Play time, a minute at a time (100 ticks here)
check(#playTicks == 0, "no minute of play yet")
for _ = 1, 60 do Session.tick() end              -- 110 ticks since the load
check(#playTicks == 1 and playTicks[1] == 100, "play time is counted a minute at a time")

-- Logout: saved, forgotten, identity reset
collection.dirty = true
state({ newState = GameState.LOGINSCREEN })
check(Session.getState() == nil, "reaching the login screen forgets the collection")
check(saves == 4, "and saves it first")
check(playTicks[2] == 10, "and counts the part of a minute since the last count (" .. tostring(playTicks[2]) .. ")")
check(count("slayer.finish") >= 1 and count("boss.finish") >= 1 and count("identity.reset") == 1, "the listeners finish and identity resets")
xp({ gain = 10 })
check(credited == 30, "XP after logout is ignored")
state({ newState = GameState.INGAME })
check(count("identity.reset") == 1, "other game states change nothing")

-- Logging in again loads again
Session.tick()
check(Session.getState() ~= nil and count("slayer.begin") == 2, "the next login loads the collection again")

-- Shutdown saves
Session.getState().dirty = true
Session.finish()
check(saves == 5 and Session.getState() == nil, "finish saves and forgets")
Session.finish()                                 -- harmless when nothing is loaded
check(saves == 5, "finish with nothing loaded saves nothing")

if failures == 0 then
    print("OK: the session loads, saves, credits XP and unloads as it should")
else
    print(failures .. " check(s) failed")
    os.exit(1)
end
