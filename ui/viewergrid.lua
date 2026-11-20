-- ui/viewergrid.lua
-- The grid view of the collection viewer (ui/viewer.lua): the cards themselves, 8 a page (4 on a short screen), each with a
-- caption bar under it in its rarity's colour holding its count; clicking a card opens it in the list. A card owned in more than
-- one finish has a toggle for each instead of the count ("Foil x1 | Normal x2"), the one shown lit; clicking one shows the card in
-- it. Every function takes `V`, the viewer's state (see ui/viewer.lua).

local Cards = require("core/cards")
local Browse = require("core/browse")
local CardView = require("ui/cardview")
local Kit = require("ui/kit")
local Theme = require("ui/theme")
local GREY, GOLD, DIM = Theme.GREY, Theme.GOLD, Theme.DIM
local Util = require("ui/util")
local toVec4 = Util.toVec4
local CollectionLayout = require("ui/collectionlayout")
local panel = CollectionLayout.panel
local ViewerLayout = require("ui/viewerlayout")
local LEFT, BODY_Y, GRID_COLS, COLUMN_W, CONTENT_W, columnX, tint = ViewerLayout.LEFT, ViewerLayout.BODY_Y, ViewerLayout.GRID_COLS,
    ViewerLayout.COLUMN_W, ViewerLayout.CONTENT_W, ViewerLayout.columnX, ViewerLayout.tint

local ViewerGrid = {}

-- Draws the current page of cards (and clears the grid when the list is showing).
function ViewerGrid.show(V)
    local o, kept = V.open, V.kept
    local layout = o.layout
    V.destroyAll(o.gridParts)
    if not kept.gridView then
        return
    end
    local gridParts, content = o.gridParts, o.content
    local first = (kept.page - 1) * layout.gridPerPage
    for slot = 1, layout.gridPerPage do
        local entry = o.entries[first + slot]
        if entry == nil then
            break
        end
        local x = columnX((slot - 1) % GRID_COLS + 1) + (COLUMN_W - layout.cardW) // 2
        local y = BODY_Y + ((slot - 1) // GRID_COLS) * layout.tileH
        local shown = V.shownFinish(entry)
        local view = CardView.create(content, entry.card, { locked = entry.locked, finish = shown, scale = layout.gridScale })
        view.root:SetPos(x, y)
        gridParts[#gridParts + 1] = view.root
        local key = entry.card.id

        -- the caption: a bar under the card in the rarity's own colour. A card owned in more than one finish has a
        -- toggle for each instead ("Foil x1 | Normal x2"), the one shown lit; clicking one shows the card in it.
        -- Otherwise a click on the caption opens the card in the list, as a click on the card does.
        local rarity = Cards.rarities[entry.card.rarity]
        local captionY = y + layout.cardH + 6
        local caption, back, border = panel(content, x, captionY, layout.cardW, 30)
        back.colour = tint(rarity.colour, entry.locked and 0.08 or 0.22, 0.92)
        border.colour = toVec4(rarity.colour, entry.locked and 0.35 or 0.8)
        gridParts[#gridParts + 1] = caption
        local finishes = Browse.ownedFinishes(entry)
        local function captionGrip(cx, cw, onClick)
            local grip = ui.Layer.new(content)
            grip.clickthrough = false
            grip:SetPos(x + cx, captionY)
            grip:SetSize(cw, 30, 0, 0)
            Kit.onWheel(grip, V.wheelPage)
            grip:Subscribe(ui.Hook.ONCLICK, onClick)
            gridParts[#gridParts + 1] = grip
        end
        if #finishes > 1 then
            local segment = layout.cardW / #finishes
            for index, owned in ipairs(finishes) do
                local cx = math.floor((index - 1) * segment)
                local cw = math.floor(index * segment) - cx
                local lit = owned.finish == shown
                -- (three toggles do not fit the finishes' names in a small card: their short names, "H x1")
                local info = Cards.finishes[owned.finish]
                local name = #finishes > 2 and info.short or info.name
                Kit.text(caption, cx, 0, cw, 30, name .. " x" .. owned.count, lit and GOLD or DIM)
                local finish = owned.finish
                captionGrip(cx, cw, function() V.chooseFinish(entry, finish) end)
            end
        else
            local text = entry.locked and "Not collected" or ("Owned: " .. entry.count)
            if shown ~= "normal" and not entry.locked then
                text = Cards.finishes[shown].name .. "  |  " .. text
            end
            Kit.text(caption, 0, 0, layout.cardW, 30, text, entry.locked and DIM or GOLD)
            captionGrip(0, layout.cardW, function() V.showInList(key) end)
        end

        -- a click on the card opens it in the list
        local grip = ui.Layer.new(content)
        grip.clickthrough = false
        grip:SetPos(x, y)
        grip:SetSize(layout.cardW, layout.cardH, 0, 0)
        Kit.onWheel(grip, V.wheelPage)
        grip:Subscribe(ui.Hook.ONCLICK, function()
            V.showInList(key)
        end)
        gridParts[#gridParts + 1] = grip
    end
    if #o.entries == 0 then
        gridParts[#gridParts + 1] = Kit.text(content, LEFT, BODY_Y + 20, CONTENT_W, 24, "No card matches.", GREY)
    end
end

return ViewerGrid
