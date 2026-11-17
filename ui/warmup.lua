-- ui/warmup.lua
-- Loads the pack pictures ahead of time, a little each tick, so the Shop does not stall the first time it is opened.
--
-- The first time the client draws a game picture (a login screen's tiles, which the packs are made from) it has to load
-- it, and the Shop shows all twelve packs' pictures at once: about two seconds. Opening it a second time is quick, so it
-- is the loading, not the drawing, that is slow. This draws each pack type's tiles one pixel big for one tick and
-- takes them away again; the client keeps them once it has loaded them. One pack type per tick spreads the cost out.

local Logger = require("core/logger")
local Packs = require("core/packs")
local PackArt = require("ui/packart")

local Warmup = {}

local queue = nil          -- the pack type ids still to do (made on the first step)
local parts = {}           -- what the last step drew, taken away by the next one
local layer = nil
local finished = false

local function clear()
    PackArt.destroyAll(parts)
    if layer ~= nil then
        pcall(function() layer:Destroy() end)
        layer = nil
    end
end

-- Does one pack type's worth, or takes away what the last step drew. Called every tick; does nothing once all are done.
function Warmup.step()
    if finished then
        return
    end
    clear()
    if queue == nil then
        queue = {}
        for _, packType in ipairs(Packs.offered()) do
            queue[#queue + 1] = packType.id
        end
        PackArt.image("pack")              -- the plain image and the shading load without being drawn
        PackArt.image("pack_shading")
        PackArt.image("pack_shading_back")
        return
    end
    local packTypeId = table.remove(queue, 1)
    if packTypeId == nil then
        finished = true
        return
    end
    local ok, err = pcall(function()
        local art = PackArt.designFor(packTypeId)
        if art == nil then
            return
        end
        local title = art.name ~= nil and PackArt.titleById(art.name.title) or nil
        if title ~= nil then
            PackArt.image("title_" .. title.id)
        end
        local gameWindow = ui.Interfaces:GetComponent(id.Component.TOPLEVEL_V2__PLUGIN_BUILD_LAYER_TOP)
        layer = ui.Layer.new(gameWindow)
        layer:SetPos(0, 0)
        layer:SetSize(1, 1)
        layer.clickthrough = true
        for _, tileId in ipairs(PackArt.tiles(art.screen) or {}) do
            local sprite = ui.Sprite.new(layer)
            parts[#parts + 1] = sprite
            sprite.spriteID = tileId
            sprite:SetPos(0, 0)
            sprite:SetSize(1, 1)
        end
    end)
    if not ok then
        Logger.error("warmup: could not load the pictures of", packTypeId, "-", tostring(err))
        clear()
    end
end

-- Takes away anything still drawn (the plugin is shutting down).
function Warmup.shutdown()
    finished = true
    clear()
end

return Warmup
