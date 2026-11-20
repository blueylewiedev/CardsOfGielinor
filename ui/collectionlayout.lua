-- ui/collectionlayout.lua
-- What the collection viewer (ui/viewer.lua) and the Sets window (ui/setsviewer.lua) have in common: the four equal columns they
-- sit on, the room a screen leaves for the cards, the panel and the bar of page buttons under the body.

local CardView = require("ui/cardview")
local Kit = require("ui/kit")
local Theme = require("ui/theme")
local GREY, PANEL_BACK, PANEL_BORDER = Theme.GREY, Theme.PANEL_BACK, Theme.PANEL_BORDER

local CollectionLayout = {}

CollectionLayout.COLUMNS, CollectionLayout.COLUMN_W, CollectionLayout.GAP = 4, 216, 12
local COLUMN_W, GAP = CollectionLayout.COLUMN_W, CollectionLayout.GAP
CollectionLayout.CONTENT_W = CollectionLayout.COLUMNS * COLUMN_W + (CollectionLayout.COLUMNS - 1) * GAP
CollectionLayout.CAPTION_H = 44                   -- under a card in the grid: the gap and the bar with its count
CollectionLayout.FOOTER_GAP, CollectionLayout.FOOTER_H = 8, 42     -- under the body: the gap, then the counts and the page buttons
CollectionLayout.FRAME = 16
local CAPTION_H, FOOTER_GAP, FOOTER_H, FRAME = CollectionLayout.CAPTION_H, CollectionLayout.FOOTER_GAP, CollectionLayout.FOOTER_H,
    CollectionLayout.FRAME
local FOOTER_SHIFT = 22                -- Prev and Next sit this far left of their column, or Next is clipped by the frame
local GRID_MIN_SCALE = 1.1             -- the smallest a card in the grid is made to keep two rows of them
local SCREEN_USED = 0.97               -- the window may take this much of the screen's height

-- Where column `number` (1 to 4) starts, in a window whose content has its first column `left` from the edge.
function CollectionLayout.columnX(left, number)
    return left + (number - 1) * (COLUMN_W + GAP)
end

-- A dark box with a thin border, as a layer to put texts in. Returns the layer, the background and the border.
function CollectionLayout.panel(parent, x, y, w, h)
    local layer = ui.Layer.new(parent)
    layer:SetPos(x, y)
    layer:SetSize(w, h, 0, 0)
    local back = ui.Rectangle.new(layer)
    back:SetPos(0, 0)
    back:SetSize(w, h, 0, 0)
    back.fill = true
    back.colour = PANEL_BACK
    local border = ui.Rectangle.new(layer)
    border:SetPos(0, 0)
    border:SetSize(w, h, 0, 0)
    border.fill = false
    border.outlineThickness = 1
    border.colour = PANEL_BORDER
    return layer, back, border
end

-- The height the body (what is between the filters or header and the footer) may have on a screen `screenHeight` units
-- tall: the window takes at most SCREEN_USED of it, less its title bar and frame, `bodyY` for what is above the body and
-- the footer.
function CollectionLayout.bodyBudget(screenHeight, bodyY)
    return math.floor(screenHeight * SCREEN_USED) - Kit.titleBarHeight() - FRAME // 2 - bodyY - FOOTER_GAP - FOOTER_H
end

-- The card scale and rows of cards for a body `budget` tall that cannot take two rows at the full size: two rows of smaller
-- cards down to GRID_MIN_SCALE (where the text on a card still fits), else one row at the full size.
function CollectionLayout.fitCards(budget)
    local fit = math.floor((budget // 2 - CAPTION_H) / CardView.BASE_H * 100) / 100     -- the card scale two rows allow
    if fit >= GRID_MIN_SCALE then
        return math.min(CardView.SCALE, fit), 2
    end
    return CardView.SCALE, 1
end

-- The page after turning `step` (1 or -1) from `page` of `count`, wrapping round (the Prev and Next buttons).
function CollectionLayout.turn(page, count, step)
    page = page + step
    if page < 1 then
        return count
    elseif page > count then
        return 1
    end
    return page
end

-- The page after one turn of the mouse wheel (`delta` down is positive: the next page), stopping at the first and the last.
function CollectionLayout.wheel(page, count, delta)
    return math.max(1, math.min(count, page + (delta > 0 and 1 or -1)))
end

-- The bar under the body, `y` from the top of the content: `left` text at the first two columns (the counts), the page
-- text at the third, and Prev and Next at the fourth. onPrev and onNext are what the buttons do. Returns the left text and
-- the page text.
function CollectionLayout.footer(parent, left, y, onPrev, onNext)
    local function columnX(number)
        return CollectionLayout.columnX(left, number)
    end
    local half = (COLUMN_W - GAP) // 2
    local leftText = Kit.text(parent, columnX(1), y + 4, 2 * COLUMN_W + GAP, 28, "", GREY, ui.AlignMode.TOPLEFT)
    local pageText = Kit.text(parent, columnX(3), y + 4, COLUMN_W, 28, "", GREY)
    Kit.buttonAt(parent, "Prev", columnX(4) - FOOTER_SHIFT, y, half, 32, onPrev)
    Kit.buttonAt(parent, "Next", columnX(4) + half + GAP - FOOTER_SHIFT, y, half, 32, onNext)
    return leftText, pageText
end

return CollectionLayout
