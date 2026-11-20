-- core/clientreads.lua
-- Guarded reads from the game's data that the Slayer and boss credits share: a value the client cannot give is nil, never an error.

local ClientReads = {}

-- A property of anything, or nil if it cannot be read.
function ClientReads.prop(thing, name)
    if thing == nil then
        return nil
    end
    local ok, value = pcall(function() return thing[name] end)
    if ok then
        return value
    end
    return nil
end

local params = {}               -- parameter name -> config.Param.<name>, once found

-- The number an NPC config holds under a parameter (config.Param.<name>), or nil if it has none or it is not a number.
function ClientReads.numberParam(cfg, name)
    if cfg == nil then
        return nil
    end
    local param = params[name]
    if param == nil then
        local ok, found = pcall(function() return config.Param[name] end)
        if not ok or found == nil then
            return nil
        end
        param = found
        params[name] = param
    end
    local okHas, has = pcall(function() return cfg:HasParam(param) end)
    if not okHas or not has then
        return nil
    end
    local okValue, value = pcall(function() return cfg:GetParamValue(param) end)
    if okValue and type(value) == "number" then
        return value
    end
    return nil
end

-- The combat level an NPC shows: its config's, or its parent config's if that has none; nil if neither does.
function ClientReads.combatLevel(cfg, parent)
    local level = ClientReads.prop(cfg, "visibleCombatLevel")
    if type(level) ~= "number" or level < 1 then
        level = ClientReads.prop(parent, "visibleCombatLevel")
    end
    return type(level) == "number" and level or nil
end

-- Which boss an NPC is, read once per config: NPCs in view are looked at every couple of ticks, and nearly all are not bosses.
-- "<configID>:<parentConfigID>" -> { id, level, name } for a boss, or false for an NPC that is not one. A config the client
-- could not give, or a parameter that is not found yet, is not remembered, so a later look tries again.
local bosses = {}

-- Forgets what has been learned (a new character's collection has loaded).
function ClientReads.forgetBosses()
    bosses = {}
end

-- A boss's BSLAY_ID, combat level and name for an NPC entity, or nil if it is not a boss.
function ClientReads.bossOf(entity)
    local configID, parentID = ClientReads.prop(entity, "configID"), ClientReads.prop(entity, "parentConfigID")
    local key = type(configID) == "number" and (configID .. ":" .. tostring(parentID)) or nil
    local known = key and bosses[key]
    if known == nil then
        local cfg, parent = ClientReads.prop(entity, "config"), ClientReads.prop(entity, "parentConfig")
        local id = ClientReads.numberParam(cfg, "BSLAY_ID") or ClientReads.numberParam(parent, "BSLAY_ID")
        if id ~= nil then
            known = { id = id, level = ClientReads.combatLevel(cfg, parent), name = ClientReads.prop(cfg, "name") }
        elseif cfg ~= nil and params.BSLAY_ID ~= nil then
            known = false
        end
        if key and known ~= nil then
            bosses[key] = known
        end
    end
    if not known then
        return nil
    end
    return known.id, known.level, known.name
end

return ClientReads
