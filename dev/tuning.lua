-- tuning.lua
-- Developer-only: camera settings saved from the preview window, so tuning a card survives a
-- reload and does not have to be typed into cards.lua straight away.
--
-- Saved settings are stored in PersistentDB and applied on top of a card's own `art` entry
-- (see addArt in cardview.lua). They only apply while `Tuning.enabled` is true, which main.lua
-- sets from DEBUG, so a released plugin ignores anything saved here.
-- Once a card's values are in cards.lua, use Reset in the preview to remove its saved entry.

local Tuning = {}

local DB_KEY = "dev_card_tuning"

Tuning.enabled = false

local data = nil     -- { [card id] = { body = true/false, cam = { yaw, pitch, dist, fov, ty, tx }, anim = number or nil } }

local FIELDS = { "yaw", "pitch", "dist", "fov", "ty", "tx" }

-- Reads the saved settings the first time they are needed. Anything damaged is skipped.
local function load()
    if data ~= nil then
        return
    end
    data = {}
    local ok, saved = pcall(function() return PersistentDB:GetStructuredData(DB_KEY) end)
    if not ok or type(saved) ~= "table" then
        return
    end
    for cardId, entry in pairs(saved) do
        if type(cardId) == "string" and type(entry) == "table" and type(entry.cam) == "table" then
            local cam = {}
            for _, field in ipairs(FIELDS) do
                if type(entry.cam[field]) == "number" then
                    cam[field] = entry.cam[field]
                end
            end
            data[cardId] = { body = entry.body == true, cam = cam,
                anim = type(entry.anim) == "number" and entry.anim or nil }
        end
    end
end

local function save()
    local ok = PersistentDB:SetStructuredData(DB_KEY, data)
    if not ok then
        log("tuning: save FAILED")
    end
    return ok
end

-- The saved settings for a card, or nil (also nil whenever tuning is not enabled).
function Tuning.get(cardId)
    if not Tuning.enabled then
        return nil
    end
    load()
    return data[cardId]
end

-- Saves a card's settings. `cam` needs yaw, pitch, dist, fov, ty and tx; `body` is whether
-- the body model is used; `anim` is the animation id, or nil for none.
function Tuning.set(cardId, body, cam, anim)
    load()
    local entry = { body = body == true, cam = {}, anim = anim }
    for _, field in ipairs(FIELDS) do
        entry.cam[field] = cam[field]
    end
    data[cardId] = entry
    return save()
end

-- Removes a card's saved settings.
function Tuning.clear(cardId)
    load()
    data[cardId] = nil
    return save()
end

-- Every saved card id, sorted.
function Tuning.ids()
    load()
    local ids = {}
    for cardId in pairs(data) do
        ids[#ids + 1] = cardId
    end
    table.sort(ids)
    return ids
end

-- Direct access for the preview's list (read only, by convention).
function Tuning.entry(cardId)
    load()
    return data[cardId]
end

return Tuning
