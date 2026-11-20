-- ui/viewerlayout.lua
-- Where everything sits in the collection viewer (ui/viewer.lua): filters across the top, then the list and the picked card or the
-- grid of cards, then the counts and page buttons. Everything sits on four equal columns (COLUMN_W): the filters, the list (two
-- columns), the picked card (two) and the grid (one card to a column). The window's content is its width less the frame (8 at each
-- side); what is in it keeps MARGIN from all four edges (the same at both sides and the same above as below), as in the settings
-- window. How tall the body is depends on the screen: see layoutFor.

local CardView = require("ui/cardview")
local CollectionLayout = require("ui/collectionlayout")
local Util = require("ui/util")
local clamp = Util.clamp

local ViewerLayout = {}

local COLUMNS, COLUMN_W, GAP = CollectionLayout.COLUMNS, CollectionLayout.COLUMN_W, CollectionLayout.GAP
local CAPTION_H, FOOTER_GAP, FOOTER_H = CollectionLayout.CAPTION_H, CollectionLayout.FOOTER_GAP, CollectionLayout.FOOTER_H

ViewerLayout.COLUMN_W, ViewerLayout.GAP = COLUMN_W, GAP
local DARK = { 0.07, 0.07, 0.09 }          -- what a tile's rarity colour is mixed into

-- A rarity's colour mixed into the dark background: `amount` 0 is all dark, 1 is all the rarity colour.
function ViewerLayout.tint(hex, amount, alpha)
    local r, g, b = ((hex >> 24) & 0xFF) / 255, ((hex >> 16) & 0xFF) / 255, ((hex >> 8) & 0xFF) / 255
    return Vector4.new(DARK[1] + (r - DARK[1]) * amount, DARK[2] + (g - DARK[2]) * amount,
        DARK[3] + (b - DARK[3]) * amount, alpha)
end

local MARGIN = 10
local LEFT = MARGIN
ViewerLayout.MARGIN, ViewerLayout.LEFT, ViewerLayout.CONTENT_W = MARGIN, LEFT, CollectionLayout.CONTENT_W
ViewerLayout.FILTER_Y = { MARGIN, MARGIN + 36, MARGIN + 72 }   -- the three rows of filters
ViewerLayout.FILTER_H = 28
local BODY_Y = MARGIN + 114             -- where the list or grid starts
ViewerLayout.BODY_Y = BODY_Y
local ROW_H, ROW_STEP = 46, 50         -- a tile in the list, and the distance from one to the next
ViewerLayout.ROW_H, ViewerLayout.ROW_STEP = ROW_H, ROW_STEP
ViewerLayout.LIST_W = 2 * COLUMN_W + GAP      -- the list takes the first two columns
ViewerLayout.GRID_COLS = COLUMNS

-- How tall the body (the list, the grid, the picked card) is depends on the screen: see layoutFor. The most that is shown
-- is 13 list rows, or 2 rows of cards in the grid, and the picked card drawn at DETAIL_MAX; on a short screen there are fewer
-- rows, smaller cards, and a smaller picked card, down to the limits below.
local LIST_ROWS_MAX, LIST_ROWS_MIN = 13, 10
local DETAIL_MAX, DETAIL_MIN = 2.0, 1.25     -- the picked card's size (a card in the grid is CardView.SCALE at most)
local INFO_RESERVE = 190                     -- the room the picked card's info panel may need under the card

-- Where column `number` (1 to 4) starts.
function ViewerLayout.columnX(number)
    return CollectionLayout.columnX(LEFT, number)
end
ViewerLayout.DETAIL_X = ViewerLayout.columnX(3)            -- the picked card is over the last two columns
ViewerLayout.DETAIL_W = 2 * COLUMN_W + GAP

-- The sizes that fit a screen `screenHeight` units tall (nil: the full size). The window takes at most SCREEN_USED of
-- the height, less its title bar and frame; what is left after the filters and footer is the body's: list rows from
-- LIST_ROWS_MAX down to LIST_ROWS_MIN, two grid rows shrunk down to GRID_MIN_SCALE (else one row at full size) and
-- the picked card as big as fits, DETAIL_MAX down to DETAIL_MIN. Below that the window is taller than the screen.
-- Returns the numbers the window is built from: listRows, gridRows, gridPerPage, gridScale, cardW and cardH (a card in the
-- grid), tileH, detailScale, detailCardW and detailCardH, bodyH, footerY and height; `budget` is the body height the
-- screen allows.
function ViewerLayout.layoutFor(screenHeight)
    local fullTile = CardView.HEIGHT + CAPTION_H
    local layout = { listRows = LIST_ROWS_MAX, gridRows = 2, gridScale = CardView.SCALE }
    if screenHeight ~= nil then
        local budget = CollectionLayout.bodyBudget(screenHeight, BODY_Y)
        layout.budget = budget
        if budget < math.max(LIST_ROWS_MAX * ROW_STEP, 2 * fullTile) then
            layout.listRows = clamp(budget // ROW_STEP, LIST_ROWS_MIN, LIST_ROWS_MAX)
            layout.gridScale, layout.gridRows = CollectionLayout.fitCards(budget)
        end
    end
    layout.gridPerPage = ViewerLayout.GRID_COLS * layout.gridRows
    layout.cardW, layout.cardH = CardView.sizeAt(layout.gridScale)
    layout.tileH = layout.cardH + CAPTION_H
    layout.bodyH = math.max(layout.listRows * ROW_STEP, layout.gridRows * layout.tileH,
        select(2, CardView.sizeAt(DETAIL_MIN)) + 10 + INFO_RESERVE)
    layout.detailScale = clamp(math.floor((layout.bodyH - 10 - INFO_RESERVE) / CardView.BASE_H * 100) / 100, DETAIL_MIN, DETAIL_MAX)
    layout.detailCardW, layout.detailCardH = CardView.sizeAt(layout.detailScale)
    layout.footerY = BODY_Y + layout.bodyH + FOOTER_GAP
    layout.height = BODY_Y + layout.bodyH + FOOTER_GAP + FOOTER_H
    return layout
end

return ViewerLayout
