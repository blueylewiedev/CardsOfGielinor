-- ui/wiggle.lua
-- Picking a card up: pressing on a card and dragging tilts it towards the mouse in perspective, and letting go springs
-- it back flat with a wobble (CardView.newWiggle and CardView.tilt; the card must be made with opts.tilt). A press
-- without a drag is still a click. The collection, the Sets window, the pack window's revealed card and the preview
-- use it.
--
-- Wiggle.attach lays a see-through grip over the card that takes the mouse. While the mouse is held the grip stretches
-- over its whole parent, so the hold and the release reach it wherever the mouse goes
-- (the pattern the tear and the Card Builder use), and goes back when let go. If the holds stop coming the release was
-- missed (the mouse let go outside the client, or the card was rebuilt under it), and the card is let go.
-- Every wiggling card is moved each frame here, until it is flat and still again.

local CardView = require("ui/cardview")
local Kit = require("ui/kit")
local Anim = require("ui/anim")
local Logger = require("core/logger")

local Wiggle = {}

-- (the pack window's drag of the sealed pack uses the same two)
Wiggle.DRAG_PX = 3          -- how far the mouse moves before a press is a drag, not a click
Wiggle.IDLE_SECONDS = 1.5   -- no hold for this long: the release was missed
local DRAG_PX, IDLE_SECONDS = Wiggle.DRAG_PX, Wiggle.IDLE_SECONDS

local moving = {}          -- the wiggles held or still settling: { [entry] = true }

-- Lets go of a held card. A press that never became a drag is a click, unless the release was missed (`missed`):
-- then nothing was clicked.
local function letGo(entry, missed)
    if not entry.wig.held then
        return
    end
    entry.wig:release()
    pcall(entry.place)
    if not entry.moved and not missed and entry.onClick ~= nil then
        local ok, err = pcall(entry.onClick)
        if not ok then
            Logger.error("wiggle: the card's click failed:", tostring(err))
        end
    end
end

-- Lays a grip in `parent` over `rect` = { x, y, w, h } (the card, or the card and its caption) that picks up `view`.
-- `onClick` (optional) runs for a press without a drag, on letting go. Returns the grip (for a mouse wheel, and for
-- whoever destroys the card to destroy it too).
function Wiggle.attach(parent, view, rect, onClick)
    local grip = ui.Layer.new(parent)
    grip.clickthrough = false
    local entry = { grip = grip, wig = CardView.newWiggle(view), onClick = onClick, idle = 0 }
    function entry.place()
        grip:SetPos(rect.x, rect.y)
        grip:SetSize(rect.w, rect.h)
    end
    entry.place()
    grip:Subscribe(ui.Hook.ONCLICK, function()
        if entry.wig.held then
            return
        end
        local x, y = Kit.mousePosition()
        if x == nil then
            -- (no mouse position: it can only be a click)
            if onClick ~= nil then
                onClick()
            end
            return
        end
        entry.wig:press(x, y)
        entry.fromX, entry.fromY, entry.moved, entry.idle = x, y, false, 0
        grip:SetPos(0, 0)
        grip:SetSize(0, 0, 1, 1)
        pcall(function() grip:MoveToFront() end)
        moving[entry] = true
    end)
    grip:Subscribe(ui.Hook.ONHOLD, function() entry.idle = 0 end)
    grip:Subscribe(ui.Hook.ONRELEASE, function() letGo(entry) end)
    return grip
end

Event.Draw.Subscribe("cardcollector_wiggle", function(e)
    if next(moving) == nil then
        return
    end
    local dt = Anim.frameSeconds(e)
    local x, y = Kit.mousePosition()
    for entry in pairs(moving) do
        local ok, err = pcall(function()
            local wig = entry.wig
            if wig.held then
                entry.idle = entry.idle + dt
                if x ~= nil and not entry.moved then
                    entry.moved = math.abs(x - entry.fromX) > DRAG_PX or math.abs(y - entry.fromY) > DRAG_PX
                end
                if entry.idle > IDLE_SECONDS then
                    letGo(entry, true)
                end
            end
            wig:step(dt, x, y)
            if not wig.held and wig.x == 0 and wig.y == 0 then
                moving[entry] = nil          -- (flat and still)
            end
        end)
        if not ok then
            moving[entry] = nil              -- (its card was destroyed)
            Logger.debug("wiggle: stopped a card:", tostring(err))
        end
    end
end)

return Wiggle
