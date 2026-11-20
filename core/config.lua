-- core/config.lua
-- Every number, list and switch that can be tuned after release, with its default, limits and checks; the rest of the plugin reads
-- them with Config.get at the moment it needs them. No networking and no client calls (dev/check_config.lua tests it offline).
--
-- The limits are fixed here, in reviewed code. A tuning table (the overlay's "tuning" line) goes through Config.apply, which keeps
-- what passes and reports what does not: data only, every key checked alone, a switch can only be turned off, nothing is saved
-- (Config.reset() puts the defaults back). Keys are dotted paths such as "packs.price"; a table a key holds belongs to Config: read
-- it, never change it.

local Cards = require("core/cards")

local Config = {}


local MAX_REPORTED = 20          -- how many ignored keys a report lists
local MAX_NAME = 40              -- the longest name of a boss activity

-- The checks. Each takes a value and returns the clean value, or nil and why it is not accepted. ---------------------------

local function wholeNumber(low, high)
    return function(value)
        local whole = type(value) == "number" and math.tointeger(value) or nil
        if whole == nil or whole < low or whole > high then
            return nil, "must be a whole number from " .. low .. " to " .. high
        end
        return whole
    end
end

local function anyNumber(low, high)
    return function(value)
        if type(value) ~= "number" or value ~= value or value < low or value > high then
            return nil, "must be a number from " .. low .. " to " .. high
        end
        return value
    end
end

local function switch(value)
    if type(value) ~= "boolean" then
        return nil, "must be true or false"
    end
    return value
end

-- A list that must keep at least one entry; `entry(value)` cleans one, returning nil and why to drop it.
-- Returns the clean list and the entries dropped.
local function cleanList(value, most, entry)
    if type(value) ~= "table" or #value == 0 and next(value) ~= nil then
        return nil, "must be a list"
    end
    if #value > most then
        return nil, "has more than " .. most .. " entries"
    end
    local clean, dropped = {}, {}
    for index, item in ipairs(value) do
        local kept, why = entry(item)
        if kept ~= nil then
            clean[#clean + 1] = kept
        else
            dropped[#dropped + 1] = "entry " .. index .. " " .. tostring(why)
        end
    end
    return clean, nil, dropped
end

-- A SkillType member's name.
local function skillName(value)
    if type(value) ~= "string" or string.find(value, "^[A-Z][A-Z_]*$") == nil then
        return nil, "is not a skill name"
    end
    if SkillType ~= nil then
        local ok, member = pcall(function() return SkillType[value] end)
        if not ok or member == nil then
            return nil, value .. " is not a skill the game has"
        end
    end
    return value
end

local function combatSkills(value)
    local list, why, dropped = cleanList(value, 30, skillName)
    if list == nil then
        return nil, why
    end
    if #list == 0 then
        return nil, "would be empty (every skill would earn credits)"      -- a list with nothing left in it is not a fix
    end
    return list, nil, dropped
end

-- The boss tiers: 1 to 8 pairs { level, credits }, the levels strictly falling. Valid only as a whole.
local function tiers(value)
    if type(value) ~= "table" or #value < 1 or #value > 8 then
        return nil, "must be 1 to 8 pairs of { level, credits }"
    end
    local level, credits = wholeNumber(0, 20000), wholeNumber(0, 20000)
    local clean, last = {}, nil
    for index, pair in ipairs(value) do
        if type(pair) ~= "table" then
            return nil, "tier " .. index .. " is not a pair"
        end
        local l, c = level(pair[1]), credits(pair[2])
        if l == nil or c == nil then
            return nil, "tier " .. index .. " needs a level and credits, each a whole number from 0 to 20,000"
        end
        if last ~= nil and l >= last then
            return nil, "the levels must fall from one tier to the next"
        end
        last = l
        clean[#clean + 1] = { l, c }
    end
    return clean
end

-- A power of two from 1 up to 2^30 (what a boss kill count rises by).
local function risePower(value)
    local number = tonumber(value)
    local whole = number ~= nil and math.tointeger(number) or nil
    if whole == nil or whole < 1 or whole > 1 << 30 or whole & (whole - 1) ~= 0 then
        return nil
    end
    return whole
end

-- Boss counts that rise for something other than a kill (the Barrows chest): { [variable name] = { [rise] = { name, credits } } }.
-- Each entry is checked alone and added to the shipped ones (an entry with the same variable and rise replaces it; credits 0
-- stops it paying). `current` is what is there now.
local function activities(value, current)
    if type(value) ~= "table" then
        return nil, "must be a table of variable names"
    end
    local merged = {}
    for variable, rises in pairs(current) do
        merged[variable] = {}
        for rise, entry in pairs(rises) do
            merged[variable][rise] = entry
        end
    end
    local dropped, count = {}, 0
    local credits = wholeNumber(0, 20000)
    for variable, rises in pairs(value) do
        if type(variable) ~= "string" or string.find(variable, "^BSLAY_BOSS_KILLS%d+$") == nil or type(rises) ~= "table" then
            dropped[#dropped + 1] = tostring(variable) .. " is not a BSLAY_BOSS_KILLS<n> count with its rises"
        else
            for riseKey, entry in pairs(rises) do
                local rise = risePower(riseKey)
                local paid = type(entry) == "table" and credits(entry.credits) or nil
                local name = type(entry) == "table" and entry.name or nil
                count = count + 1
                if count > 20 then
                    dropped[#dropped + 1] = "more than 20 entries: the rest are ignored"
                    break
                elseif rise == nil or paid == nil or type(name) ~= "string" or #name > MAX_NAME then
                    dropped[#dropped + 1] = variable .. " " .. tostring(riseKey) .. " needs a rise that is a power of two, "
                        .. "a name of at most " .. MAX_NAME .. " letters and credits from 0 to 20,000"
                else
                    merged[variable] = merged[variable] or {}
                    merged[variable][rise] = { name = name, credits = paid }
                end
            end
        end
    end
    return merged, nil, dropped
end

-- Credits for one boss by its BSLAY_ID: { [id] = credits }, up to 60.
local function overrides(value)
    if type(value) ~= "table" then
        return nil, "must be a table of boss ids and credits"
    end
    local clean, dropped, count = {}, {}, 0
    local credits = wholeNumber(0, 20000)
    for key, paid in pairs(value) do
        local id = tonumber(key)
        id = id ~= nil and math.tointeger(id) or nil
        local amount = credits(paid)
        count = count + 1
        if count > 60 then
            return nil, "has more than 60 entries"
        elseif id == nil or id < 1 or id > 200 or amount == nil then
            dropped[#dropped + 1] = tostring(key) .. " needs a boss id from 1 to 200 and credits from 0 to 20,000"
        else
            clean[id] = amount
        end
    end
    return clean, nil, dropped
end

-- The keys -----------------------------------------------------------------------------------------------------------------
-- { default, check } for each. `merge` (a check that takes the current value too) is for a table that adds to the shipped one.

local SCHEMA = {
    ["earning.enabled"]         = { true, switch },
    ["earning.xpPerCredit"]     = { 10, wholeNumber(5, 20) },
    ["earning.combatSkills"]    = { { "ATTACK", "STRENGTH", "DEFENCE", "HITPOINTS", "RANGED", "PRAYER", "MAGIC", "SUMMONING",
        "NECROMANCY", "SLAYER" }, combatSkills },
    ["starterCredits"]          = { 8000, wholeNumber(0, 20000) },
    ["packs.price"]             = { 4000, wholeNumber(2000, 8000) },
    ["packs.themedPriceFactor"] = { 1.25, anyNumber(1, 2) },
    ["odds.finish.normal"]      = { 17, wholeNumber(1, 1000) },
    ["odds.finish.foil"]        = { 2, wholeNumber(0, 1000) },       -- (the pastel shine over the card)
    ["odds.finish.holo"]        = { 1, wholeNumber(0, 1000) },       -- (the rainbow behind the picture)
    ["slayer.enabled"]          = { true, switch },
    ["slayer.creditsPerLevel"]  = { 1, anyNumber(0.5, 2) },
    ["slayer.bonusMultiplier"]  = { 5, anyNumber(0, 10) },
    ["slayer.levelCap"]         = { nil, wholeNumber(10, 14000) },
    ["slayer.vars.count"]       = { 183, wholeNumber(1, 60000) },
    ["slayer.vars.task"]        = { 185, wholeNumber(1, 60000) },
    ["slayer.vars.streak"]      = { 10077, wholeNumber(1, 60000) },
    ["bosses.enabled"]          = { true, switch },
    ["bosses.tiers"]            = { { { 9000, 8000 }, { 5000, 4000 }, { 1000, 1800 }, { 500, 800 }, { 0, 400 } }, tiers },
    ["bosses.activities"]       = { { BSLAY_BOSS_KILLS2 = { [65536] = { name = "Barrows chest", credits = 1800 } } }, activities,
        merge = true },
    ["bosses.overrides"]        = { {}, overrides },
    ["shine.enabled"]           = { true, switch },               -- (a foil card's shine)
    ["holo.enabled"]            = { true, switch },               -- (a holo card's rainbow)
}
local RARITY_DEFAULTS = { common = 63, uncommon = 25, rare = 9.4, epic = 2, legendary = 0.6 }
for _, rarity in ipairs(Cards.rarityOrder) do
    SCHEMA["odds.rarity." .. rarity] = { RARITY_DEFAULTS[rarity], anyNumber(0, 100) }
end

-- The places a key can sit under (a key's path up to each dot), so unknown keys can be told from groups.
local GROUPS = {}
for path in pairs(SCHEMA) do
    for at in string.gmatch(path, "()%.") do
        GROUPS[string.sub(path, 1, at - 1)] = true
    end
end

Config.SCHEMA = SCHEMA

local function copy(value)
    if type(value) ~= "table" then
        return value
    end
    local out = {}
    for key, item in pairs(value) do
        out[key] = copy(item)
    end
    return out
end

local values = {}
Config.revision = nil            -- the tuning's own number, if it gave one

-- Puts every default back.
function Config.reset()
    values = {}
    for path, entry in pairs(SCHEMA) do
        values[path] = copy(entry[1])
    end
    Config.revision = nil
end
Config.reset()

-- The default of a key (a copy).
function Config.default(path)
    local entry = SCHEMA[path]
    assert(entry ~= nil, "unknown config key " .. tostring(path))
    return copy(entry[1])
end

-- The value of a key now. An unknown key is a mistake in the code, so it raises.
function Config.get(path)
    if SCHEMA[path] == nil then
        error("unknown config key " .. tostring(path), 2)
    end
    return values[path]
end

-- Applies a tuning table (the overlay's "tuning" line). Never raises. Returns a report: applied (keys set), ignored
-- ("key: why", at most MAX_REPORTED; `more` counts the rest) and changed (keys that now differ from their default).
function Config.apply(raw)
    local report = { applied = {}, ignored = {}, changed = {}, more = 0 }
    local function ignore(path, why)
        if #report.ignored < MAX_REPORTED then
            report.ignored[#report.ignored + 1] = path .. ": " .. why
        else
            report.more = report.more + 1
        end
    end
    local function set(path, value)
        local entry = SCHEMA[path]
        local ok, clean, why, dropped = pcall(entry[2], value, entry.merge and values[path] or nil)
        if not ok then
            ignore(path, "could not be read")
            return
        end
        if clean == nil then
            ignore(path, why or "is not accepted")
            return
        end
        for _, note in ipairs(dropped or {}) do
            ignore(path, note)
        end
        values[path] = clean
        report.applied[#report.applied + 1] = path
    end
    local function walk(prefix, group)
        for key, value in pairs(group) do
            local path = prefix .. tostring(key)
            if SCHEMA[path] ~= nil then
                set(path, value)
            elseif GROUPS[path] and type(value) == "table" then
                walk(path .. ".", value)
            elseif prefix == "" and key == "revision" then
                local whole = type(value) == "number" and math.tointeger(value) or nil
                if whole ~= nil and whole >= 0 then
                    Config.revision = whole
                else
                    ignore("revision", "must be a whole number from 0")
                end
            else
                ignore(path, "is not a key this plugin has")
            end
        end
    end
    local ok = pcall(function()
        if type(raw) ~= "table" then
            ignore("tuning", "is not a table")
            return
        end
        walk("", raw)
        -- one rarity left at 0 is allowed, but common cannot be: a pack must always have something it can give
        if values["odds.rarity.common"] <= 0 then
            values["odds.rarity.common"] = Config.default("odds.rarity.common")
            ignore("odds.rarity.common", "must be above 0")
        end
    end)
    if not ok then
        ignore("tuning", "could not be read")
    end
    for path, entry in pairs(SCHEMA) do
        local now, default = values[path], entry[1]
        local same = now == default
        if not same and type(now) == "table" then
            same = Config.sameTable(now, default)
        end
        if not same then
            report.changed[#report.changed + 1] = path
        end
    end
    table.sort(report.changed)
    table.sort(report.applied)
    return report
end

-- True if two tables hold the same keys and values, to any depth.
function Config.sameTable(a, b)
    if type(a) ~= "table" or type(b) ~= "table" then
        return a == b
    end
    for key, value in pairs(a) do
        if not Config.sameTable(value, b[key]) then
            return false
        end
    end
    for key in pairs(b) do
        if a[key] == nil then
            return false
        end
    end
    return true
end

return Config
