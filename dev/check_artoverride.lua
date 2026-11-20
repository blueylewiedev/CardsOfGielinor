-- dev/check_artoverride.lua
-- Checks dev/artoverride.lua: the saved camera settings and the preview's Head/Body choice change the card that is drawn, without
-- touching the real card. The card view is a stand-in that records the card it is given.
--
-- Run from the plugin's folder:  lua dev/check_artoverride.lua

package.path = "./?.lua;" .. package.path
function log() end

local drawn = {}
package.loaded["ui/cardview"] = {
    CAMERA_FIELDS = { "yaw", "pitch", "dist", "fov", "ty", "tx", "near" },
    create = function(_, card, opts)
        drawn[#drawn + 1] = { card = card, opts = opts }
        return { card = card }
    end,
}
PersistentDB = {
    GetStructuredData = function()
        return { hans = { body = false, anim = 5, cam = { yaw = 1, pitch = 2, dist = 3, fov = 4, ty = 5, tx = 6 } },
                 abyssal_whip = { body = false, anim = 9, cam = { yaw = 7, pitch = 7, dist = 7, fov = 7, ty = 7, tx = 7 } } }
    end,
    SetStructuredData = function() return true end,
}

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        print("FAIL: " .. what)
    end
end

local Cards = require("core/cards")
local CardView = require("ui/cardview")
local ArtOverride = require("dev/artoverride")
ArtOverride.install()
ArtOverride.install()                                        -- (once only)

local npc = { id = "hans", name = "Hans", kind = nil, rarity = "common", art = { cam = { yaw = 0.5 } } }
local item = { id = "abyssal_whip", name = "Abyssal whip", kind = "item", rarity = "rare", art = { cam = { yaw = 0.1 } } }

-- nothing saved and no choice: the real card is drawn
local view = CardView.create({}, { id = "nobody", name = "Nobody", rarity = "common" }, {})
check(#drawn == 1 and drawn[1].card.id == "nobody" and drawn[1].card.art == nil, "a card with nothing saved is drawn as it is")

-- the saved camera, body and animation replace the card's own
view = CardView.create({}, npc, {})
local art = drawn[#drawn].card.art
check(art.cam.yaw == 1 and art.cam.tx == 6 and art.body == false and art.anim == 5, "saved camera, body and animation replace the card's")
check(npc.art.cam.yaw == 0.5 and npc.art.body == nil, "the real card is not changed")
check(view.card == npc, "the view's card is the real one")

-- an item takes only the camera
view = CardView.create({}, item, { body = true })
art = drawn[#drawn].card.art
check(art.cam.yaw == 7 and art.body == nil and art.anim == nil, "an item takes only the saved camera, and ignores a Head/Body choice")

-- the Head/Body choice: the card's camera is dropped when the other model type is shown
local plain = { id = "guard", name = "Guard", rarity = "common", art = { cam = { yaw = 0.3 } } }
CardView.create({}, plain, { body = false })
art = drawn[#drawn].card.art
check(art.body == false and art.cam == nil, "showing the head of a body card drops its camera")
CardView.create({}, plain, { body = true })
art = drawn[#drawn].card.art
check(art.body == true and art.cam ~= nil and art.cam.yaw == 0.3, "showing the body of a body card keeps its camera")
check(plain.art.cam.yaw == 0.3 and plain.art.body == nil, "and the real card is not changed")

if failures > 0 then
    os.exit(1)
end
print("OK: the saved camera settings and the Head/Body choice change a copy of the card, not the card")
