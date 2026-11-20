-- dev/artoverride.lua
-- Two things the development tools do to how cards are drawn, done by wrapping CardView.create so the plugin has no hook for them:
--   * the camera (and body, and animation) settings saved from the Card Preview (dev/tuning.lua) replace the card's own art;
--   * opts.body (true or false, from the preview's Head/Body button) draws an NPC card with its body or its head model whatever the card says.
-- Both make a copy of the card with a changed `art` and draw that. Not in the release.

local Cards = require("core/cards")
local CardView = require("ui/cardview")
local Tuning = require("dev/tuning")

local ArtOverride = {}

local installed = false

local function copyOf(source)
    local copy = {}
    for key, value in pairs(source) do
        copy[key] = value
    end
    return copy
end

-- The card to draw: `card` itself if nothing changes it, otherwise a copy whose art is changed.
local function changed(card, opts)
    local isItem = Cards.kindOf(card) == "item"
    local saved = Tuning.get(card.id)
    local body = nil                      -- (true, false or nil: not `and ... or`, which turns false into nil)
    if not isItem and opts ~= nil then
        body = opts.body
    end
    if saved == nil and body == nil then
        return card
    end
    local art = copyOf(Cards.getArt(card))
    if saved ~= nil then
        -- (an item has no body/head choice and no animation: only its camera is replaced)
        if not isItem then
            art.body = saved.body
            art.anim = saved.anim
        end
        art.cam = saved.cam
    end
    if body ~= nil then
        -- the card's camera belongs to its own model type, so it is dropped when the other one is shown
        if (body == true) ~= (art.body == true) then
            art.cam = nil
        end
        art.body = body
    end
    local copy = copyOf(card)
    copy.art = art
    return copy
end

ArtOverride.changed = changed                 -- (for dev/check_artoverride.lua)

function ArtOverride.install()
    if installed then
        return
    end
    installed = true
    local create = CardView.create
    CardView.create = function(parent, card, opts)
        local view = create(parent, changed(card, opts), opts)
        if view ~= nil then
            view.card = card                  -- (the view's card is the real one, not the copy)
        end
        return view
    end
end

return ArtOverride
