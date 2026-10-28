-- itemfacts.lua
-- Developer-only: what the game's own item config says about an item, as suggestions for a card:
-- free to play or members, the level and skill it needs, its kind of gear, and a rarity from the
-- level. The Card Builder uses it when an item is chosen (it only fills in what is still empty).
--
-- What is read (found with the Item probe's parameter list, so the names are the game's own):
--   isMembers                    -> membership
--   WEAR_REQUIRES_STAT<n> / _LEVEL<n>   what wearing or wielding it needs
--   USE_REQUIRES_STAT<n> / _LEVEL<n>    what using it needs (a pickaxe, an ore, a seed...)
--     (the stat is the number of a skill, in the order of SkillType in the client API)
--   COMBATV2_<MELEE|RANGED|MAGIC|NECROMANCY>_<WEAPON|ITEM> and <STYLE>_STRENGTH -> combat style
--   WEAPON_CATEGORY             -> the kind of weapon (whip, mace...)
--   interfaceOpNames, FOOD_HEAL, POTION_TYPE, GE_CATEGORY -> food, drink, potion and some materials
-- It cannot know the Grand Exchange price or a drop rate, or an armour or jewellery slot, so the
-- notes say to check those. The recipe of a made item is not read either: the game numbers the
-- skills of recipes differently, and some items (the runes) have no recipe in their config.

local Cards = require("core/cards")

local ItemFacts = {}

-- The skill words by the game's skill number (SkillType in the client API).
ItemFacts.SKILLS = { [0] = "attack", "defence", "strength", "constitution", "ranged", "prayer", "magic",
    "cooking", "woodcutting", "fletching", "fishing", "firemaking", "crafting", "smithing", "mining",
    "herblore", "agility", "thieving", "slayer", "farming", "runecrafting", "hunter", "construction",
    "summoning", "dungeoneering", "divination", "invention", "archaeology", "necromancy" }

-- The level bands of the item rarity rules (CONTRIBUTING, "Guidelines for items").
ItemFacts.LEVEL_BANDS = { { 90, "legendary" }, { 70, "epic" }, { 50, "rare" }, { 25, "uncommon" } }

function ItemFacts.levelRarity(level)
    for _, band in ipairs(ItemFacts.LEVEL_BANDS) do
        if level >= band[1] then
            return band[2]
        end
    end
    return "common"
end

-- The kind of weapon by the end of its WEAPON_CATEGORY (COMBATV2_WEAPON_<this>). The first group
-- was seen in the game (a rune sword is SHORTSWORD, a crossbow is XBOW); the rest are guesses.
local WEAPON_KINDS = {
    WHIP = "whip", ["2HSWORD"] = "two_handed_sword", MACE = "mace", SPEAR = "spear", HALBERD = "halberd",
    CLAW = "claw", THROWNDART = "thrown", DAGGER = "dagger", SCIMITAR = "scimitar", SHORTSWORD = "sword",
    BATTLEAXE = "axe", XBOW = "crossbow", STAFF = "staff", WAND = "wand",
    LONGSWORD = "sword", AXE = "axe", CROSSBOW = "crossbow",
    THROWNKNIFE = "thrown", THROWNAXE = "thrown",
}
local TOOL_WEAPONS = { PICKAXE = true, HATCHET = true }

-- Materials and the like by GE_CATEGORY (one item seen for each, so they are good guesses).
local GE_KINDS = {
    [36] = { "raw_material", "log" }, [8] = { "raw_material", "gem" }, [13] = { "raw_material", "herb" },
    [28] = { "raw_material", "bone" }, [26] = { "potion" }, [33] = { "seed" }, [12] = { "food" },
}

-- Combat style families: the flags and the strength parameter that show it.
local STYLES = {
    { word = "melee_gear", names = { "COMBATV2_MELEE_WEAPON", "COMBATV2_MELEE_ITEM", "MELEE_STRENGTH" } },
    { word = "ranged_gear", names = { "COMBATV2_RANGED_WEAPON", "COMBATV2_RANGED_ITEM", "RANGED_STRENGTH" } },
    { word = "magic_gear", names = { "COMBATV2_MAGIC_WEAPON", "COMBATV2_MAGIC_ITEM", "MAGIC_STRENGTH" } },
    { word = "necromancy_gear", names = { "COMBATV2_NECROMANCY_WEAPON", "COMBATV2_NECROMANCY_ITEM", "NECROMANCY_STRENGTH" } },
}

local function numberOf(value)
    return type(value) == "number" and value or nil
end

-- The skills and the highest level a kind of requirement ("WEAR_REQUIRES_STAT") asks for.
local function requirements(params, prefix)
    local skills, level = {}, nil
    for n = 1, 8 do
        local stat, needed = numberOf(params[prefix .. n]), numberOf(params[prefix .. "_LEVEL" .. n])
        local skill = stat and ItemFacts.SKILLS[stat]
        if skill ~= nil and needed ~= nil then
            skills[#skills + 1] = skill
            level = math.max(level or 0, needed)
        end
    end
    return skills, level
end

local function hasOp(ops, name)
    for _, op in ipairs(ops or {}) do
        if op == name then
            return true
        end
    end
    return false
end

-- Suggestions for an item from what its config says. `raw` is
--   { configName, name, isMembers (1/0 or true/false), ops = { interface option names },
--     params = { PARAM_NAME = value } }
-- Returns { members = "f2p"/"p2p"/nil, skills = { words }, level = n/nil, category = { words },
-- rarity = word/nil, notes = { text }, found = true if the config had anything useful }.
function ItemFacts.interpret(raw)
    local params = raw.params or {}
    local result = { skills = {}, category = {}, notes = {} }
    local function note(text)
        result.notes[#result.notes + 1] = text
    end

    if raw.isMembers == 1 or raw.isMembers == true then
        result.members = "p2p"
    elseif raw.isMembers == 0 or raw.isMembers == false then
        result.members = "f2p"
    end
    if string.sub(tostring(raw.configName or ""), 1, 5) == "CERT_" then
        note("This is the noted version of an item, with no data of its own: use the normal item")
    end

    -- Levels and skills.
    local wearSkills, wearLevel = requirements(params, "WEAR_REQUIRES_STAT")
    local useSkills, useLevel = requirements(params, "USE_REQUIRES_STAT")
    for _, list in ipairs({ wearSkills, useSkills }) do
        for _, skill in ipairs(list) do
            local have = false
            for _, other in ipairs(result.skills) do
                have = have or other == skill
            end
            if not have then
                result.skills[#result.skills + 1] = skill
            end
        end
    end
    if wearLevel ~= nil or useLevel ~= nil then
        result.level = math.max(wearLevel or 0, useLevel or 0)
        result.rarity = ItemFacts.levelRarity(result.level)
        local parts = {}
        for _, skill in ipairs(result.skills) do
            parts[#parts + 1] = skill
        end
        note("Needs " .. table.concat(parts, " and ") .. " level " .. result.level .. " (" .. result.rarity
            .. " by level); check the price and drop rate on the wiki, the rarity is the highest of them")
    end

    -- What kind of item.
    local category = result.category
    local function add(...)
        for _, word in ipairs({ ... }) do
            category[#category + 1] = word
        end
    end
    local weapon = type(params.WEAPON_CATEGORY) == "string" and string.match(params.WEAPON_CATEGORY, "^COMBATV2_WEAPON_(.+)$")
    local ops = raw.ops or {}
    local gear = nil                    -- weapon, armour, jewellery or ammunition: it can have a combat style
    if (weapon and TOOL_WEAPONS[weapon]) or params.MINING_PICKAXE_STAT_DATA ~= nil or params.WOODCUTTING_AXE ~= nil then
        add("tool")
    elseif weapon then
        gear = "weapon"
        add("weapon")
        if WEAPON_KINDS[weapon] then
            add(WEAPON_KINDS[weapon])
        elseif weapon == "BOW" then
            local name = string.lower(tostring(raw.name or ""))
            if string.find(name, "shortbow", 1, true) then
                add("shortbow")
            elseif string.find(name, "longbow", 1, true) then
                add("longbow")
            else
                note("A bow: choose shortbow or longbow")
            end
        else
            note("Weapon category " .. params.WEAPON_CATEGORY .. " is not known yet: choose the kind of weapon")
        end
    elseif numberOf(params.GE_CATEGORY) == 2 then
        gear = "ammunition"
        add("ammunition")
        local kind = numberOf(raw.category)
        if kind == 62 then
            add("arrow")
        elseif kind == 63 then
            add("bolt")
        end
    elseif params.COMBATV2_PLAYER_ARMOUR ~= nil then
        gear = "armour"
        add("armour")
        note("Choose the armour slot (helmet, body, legs...): the game config does not say")
    elseif numberOf(params.GE_CATEGORY) == 16 then
        gear = "jewellery"
        add("jewellery")
        note("Choose the jewellery slot (ring or neck): the game config does not say")
    elseif hasOp(ops, "Eat") or (params.FOOD_HEAL ~= nil and not hasOp(ops, "Drink")) then
        add("food")
    elseif hasOp(ops, "Drink") then
        add(params.POTION_TYPE ~= nil and "potion" or "drink")
    elseif hasOp(ops, "Bury") then
        add("raw_material", "bone")
    elseif GE_KINDS[numberOf(params.GE_CATEGORY)] then
        add(table.unpack(GE_KINDS[numberOf(params.GE_CATEGORY)]))
    end

    -- Combat style, for gear.
    if gear ~= nil then
        local found = {}
        for _, style in ipairs(STYLES) do
            for _, name in ipairs(style.names) do
                local value = numberOf(params[name])
                if value ~= nil and value > 0 then
                    found[#found + 1] = style.word
                    break
                end
            end
        end
        if #found > 1 then
            add("hybrid_gear")
        elseif #found == 1 then
            add(found[1])
        end
    end

    if #category == 0 then
        note("The game config does not say what kind of item this is: choose the category")
    end
    note("The game does not give the Grand Exchange price or a drop rate: check them on the wiki")
    result.found = result.members ~= nil or #result.skills > 0 or #category > 0
    return result
end

-- A property of a config, or nil if it cannot be read.
local function prop(target, name)
    if target == nil then
        return nil
    end
    local ok, value = pcall(function() return target[name] end)
    if ok then
        return value
    end
    return nil
end

-- A parameter's value as a number or text: a config shows as its config name.
local function plainValue(value)
    local kind = type(value)
    if kind == "number" or kind == "string" or kind == "boolean" then
        return value
    end
    local name = prop(value, "configName")
    return type(name) == "string" and name or nil
end

-- What the game's config says about an item (by its numeric id): the same table as `interpret`,
-- or nil if the item cannot be read.
function ItemFacts.read(objId)
    local ok, cfg = pcall(function() return config.Obj.FromID(objId) end)
    if not ok or cfg == nil then
        return nil
    end
    local raw = { configName = prop(cfg, "configName"), name = prop(cfg, "name"), isMembers = prop(cfg, "isMembers"),
        category = prop(cfg, "category"), ops = {}, params = {} }
    local ops = prop(cfg, "interfaceOpNames")
    local count = ops ~= nil and select(2, pcall(function() return #ops end)) or 0
    for i = 1, type(count) == "number" and count or 0 do
        raw.ops[#raw.ops + 1] = prop(ops, i)
    end
    local list = prop(cfg, "params")
    local size = list ~= nil and select(2, pcall(function() return #list end)) or 0
    for i = 1, type(size) == "number" and size or 0 do
        local param = prop(list, i)
        local name = prop(param, "configName")
        local okValue, value = pcall(function() return cfg:GetParamValue(param) end)
        if type(name) == "string" and okValue then
            raw.params[name] = plainValue(value)
        end
    end
    return ItemFacts.interpret(raw)
end

-- Keeps only the words a card may use (and adds the word a kind needs: scimitar needs weapon, which
-- interpret already adds first). Returns the words that are valid category words for an item.
function ItemFacts.validCategory(words)
    local allowed = {}
    for _, word in ipairs(Cards.wordsFor("item", "category") or {}) do
        allowed[word] = true
    end
    local out = {}
    for _, word in ipairs(words) do
        if allowed[word] then
            out[#out + 1] = word
        end
    end
    return out
end

return ItemFacts
