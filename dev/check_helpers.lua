-- dev/check_helpers.lua
-- Checks the helpers several files share: core/clientreads.lua, ui/util.lua, Browse.visibleState and Browse.stamp, Sets.ownedIds,
-- Storage.ownsCard, Settings.get on an unknown option and Earning.isCombatSkill following a tuning change. The "Check cards"
-- workflow runs it.
--
-- Run from the plugin's folder:  lua dev/check_helpers.lua

package.path = "./?.lua;" .. package.path
function log() end
Vector4 = { new = function(x, y, z, w) return { x = x, y = y, z = z, w = w } end }
PersistentDB = { GetStructuredData = function() return nil end, SetStructuredData = function() return true end }

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        print("FAIL: " .. what)
    end
end

-- core/clientreads.lua ----------------------------------------------------------------------------------------------------------
local calls = 0
config = { Param = { BSLAY_ID = "idparam", GONE = nil } }
local function npcConfig(values, level)
    return setmetatable({ visibleCombatLevel = level }, { __index = {
        HasParam = function(_, param) return values[param] ~= nil end,
        GetParamValue = function(_, param) calls = calls + 1 return values[param] end,
    } })
end
local ClientReads = require("core/clientreads")
check(ClientReads.prop(nil, "x") == nil and ClientReads.prop({ x = 3 }, "x") == 3, "prop reads a property, and nil for nothing")
check(ClientReads.prop(setmetatable({}, { __index = function() error("boom") end }), "x") == nil, "prop never raises")
check(ClientReads.numberParam(npcConfig({ idparam = 12 }), "BSLAY_ID") == 12, "numberParam reads a number parameter")
check(ClientReads.numberParam(npcConfig({}), "BSLAY_ID") == nil, "an NPC without the parameter gives nil")
check(ClientReads.numberParam(npcConfig({ idparam = "text" }), "BSLAY_ID") == nil, "a parameter that is not a number gives nil")
check(ClientReads.numberParam(nil, "BSLAY_ID") == nil and ClientReads.numberParam(npcConfig({}), "NOT_A_PARAM") == nil,
    "no config, or a parameter the client does not have, gives nil")
check(ClientReads.combatLevel(npcConfig({}, 50), npcConfig({}, 70)) == 50, "the combat level is the config's")
check(ClientReads.combatLevel(npcConfig({}, 0), npcConfig({}, 70)) == 70, "or the parent's when the config's is not a level")
check(ClientReads.combatLevel(npcConfig({}, nil), nil) == nil, "or nil")

-- ui/util.lua ---------------------------------------------------------------------------------------------------------------------
local Util = require("ui/util")
local text = { content = "a" }
Util.setText(text, "a")
Util.setText(text, "b")
Util.setText(nil, "c")
check(text.content == "b", "setText changes the words, and ignores a nil widget")
local hidden = {}
Util.setHidden(hidden, true)
check(hidden.hidden == true, "setHidden hides")
Util.setHidden(setmetatable({}, { __newindex = function() error("gone") end }), true)
local destroyed = {}
local list = {}
for i = 1, 3 do list[i] = { Destroy = function() destroyed[#destroyed + 1] = i end } end
Util.destroyAll(list)
check(#list == 0 and destroyed[1] == 3 and destroyed[3] == 1, "destroyAll destroys last first and empties the list")
local colour = Util.toVec4(0x9AA0A6FF)
check(math.abs(colour.x - 0x9A / 255) < 1e-9 and colour.w == 1, "toVec4 takes the colour's own alpha")
check(Util.toVec4(0x9AA0A6FF, 0.35).w == 0.35, "or an alpha of your own")
check(Util.clamp(5, 1, 3) == 3 and Util.clamp(-1, 1, 3) == 1 and Util.clamp(2, 1, 3) == 2, "clamp")
check(Util.readNumber(function() return 5 end) == 5 and Util.readNumber(function() return 0 end) == nil
    and Util.readNumber(function() error("x") end) == nil and Util.readNumber(function() return "5" end) == nil, "readNumber")

-- Browse.visibleState, Browse.stamp, Sets.ownedIds, Storage.ownsCard --------------------------------------------------------------------
local Cards = require("core/cards")
local Browse = require("core/browse")
local Sets = require("core/sets")
local Storage = require("core/storage")
local first, second = Cards.list[1].id, Cards.list[2].id
local state = { owned = { [first .. "|normal"] = 2, [first .. "|foil"] = 1, [second .. "|holo"] = 1, ["gone_card|normal"] = 4 } }
check(Browse.visibleState(state, nil) == state and Browse.visibleState(state, {}) == state, "with nothing hidden the state itself is shown")
local view = Browse.visibleState(state, { [first .. "|normal"] = 1, [second .. "|holo"] = 1 })
check(view.owned[first .. "|normal"] == 1 and view.owned[second .. "|holo"] == nil and view.owned[first .. "|foil"] == 1,
    "copies still unseen are left out, and a card with none left goes")
check(state.owned[second .. "|holo"] == 1, "and the real collection is not changed")
check(Browse.stamp(state) ~= Browse.stamp(view) and Browse.stamp(state) == Browse.stamp(state), "the stamp changes with what is owned")
local ids = Sets.ownedIds(state)
check(ids[first] and ids[second] and not ids["gone_card"], "Sets.ownedIds lists the deck's cards the player has")
check(next(Sets.ownedIds(nil)) == nil, "and nothing for no collection")
check(Storage.ownsCard(state, first) and Storage.ownsCard(state, second) and not Storage.ownsCard(state, Cards.list[3].id),
    "ownsCard finds a card in any finish")

-- core/settings.lua ----------------------------------------------------------------------------------------------------------------
local Settings = require("core/settings")
check(Settings.get("glow") == true, "a known option reads")
check(not pcall(Settings.get, "no_such_option"), "an unknown option raises")

-- core/earning.lua: the combat skills follow a tuning change ------------------------------------------------------------------------
SkillType = { ATTACK = 1, MAGIC = 2, COOKING = 3 }
local Config = require("core/config")
local Earning = require("core/earning")
check(Earning.isCombatSkill(1) and Earning.isCombatSkill(2) and not Earning.isCombatSkill(3), "attack and magic earn nothing, cooking does")
Config.apply({ earning = { combatSkills = { "COOKING" } } })
check(Earning.isCombatSkill(3) and not Earning.isCombatSkill(1), "a tuned list replaces the cached one")
Config.reset()
check(Earning.isCombatSkill(1) and not Earning.isCombatSkill(3), "and the defaults come back")
check(not Earning.isCombatSkill(nil), "no skill earns something")

if failures > 0 then
    os.exit(1)
end
print("OK: the shared helpers behave")
