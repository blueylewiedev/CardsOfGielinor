-- ui/setslayout.lua
-- Where everything sits in the Sets window (ui/setsviewer.lua), on the same four columns as the collection viewer: the set list
-- takes the first, the picked set's cards the other three. How tall the window is depends on the screen, as the collection
-- viewer's does (see layoutFor): two rows of cards at the full card size where the screen allows, else the cards are made
-- smaller (down to where the text on a card still fits), else one row of them.

local CardView = require("ui/cardview")
local CollectionLayout = require("ui/collectionlayout")

local SetsLayout = {}

local COLUMNS, COLUMN_W, GAP = CollectionLayout.COLUMNS, CollectionLayout.COLUMN_W, CollectionLayout.GAP
local CAPTION_H, FOOTER_GAP, FOOTER_H = CollectionLayout.CAPTION_H, CollectionLayout.FOOTER_GAP, CollectionLayout.FOOTER_H

SetsLayout.COLUMN_W, SetsLayout.GAP, SetsLayout.CONTENT_W = COLUMN_W, GAP, CollectionLayout.CONTENT_W
SetsLayout.WINDOW_SLACK = 30           -- the window's frame takes this much of the width it is made with
local LEFT = 4
local TOP = 4
SetsLayout.LEFT, SetsLayout.TOP = LEFT, TOP
local HEADER_H = 52                    -- the set's name, its progress and the bar over the cards
local BODY_Y = TOP + HEADER_H
SetsLayout.BODY_Y = BODY_Y
SetsLayout.GRID_COLS = COLUMNS - 1
local ROW_H, ROW_STEP = 46, 50         -- a set's tile, and the distance from one to the next
SetsLayout.ROW_H, SetsLayout.ROW_STEP = ROW_H, ROW_STEP
SetsLayout.FILTER_H, SetsLayout.FILTER_STEP = 28, 34   -- the search box and the drop-down over the list
local LIST_TOP = TOP + 2 * SetsLayout.FILTER_STEP      -- the set list runs from under them to the footer
SetsLayout.LIST_TOP = LIST_TOP
SetsLayout.SCROLL_W = 8                -- the scroll bar at the right of the list
SetsLayout.TILE_W = COLUMN_W - SetsLayout.SCROLL_W - 4 -- a set's tile, leaving room for it

function SetsLayout.columnX(number)
    return CollectionLayout.columnX(LEFT, number)
end
SetsLayout.GRID_X = SetsLayout.columnX(2)
SetsLayout.GRID_W = SetsLayout.GRID_COLS * COLUMN_W + (SetsLayout.GRID_COLS - 1) * GAP

-- The sizes that fit a screen `screenHeight` units tall (nil if unknown: then the full size). The window takes at most
-- SCREEN_USED of the height, less its title bar and frame; what is left after the header and the footer is the body's.
-- Returns a table of the numbers the window is built from: gridRows, gridPerPage, scale, cardW and cardH, tileH, bodyH,
-- listRows (how many sets the list shows), trackH (the scroll bar's), footerY and height; `budget` is the body's height the
-- screen allows.
function SetsLayout.layoutFor(screenHeight)
    local layout = { gridRows = 2, scale = CardView.SCALE }
    if screenHeight ~= nil then
        local budget = CollectionLayout.bodyBudget(screenHeight, BODY_Y)
        layout.budget = budget
        if budget < 2 * (CardView.HEIGHT + CAPTION_H) then
            layout.scale, layout.gridRows = CollectionLayout.fitCards(budget)
        end
    end
    layout.gridPerPage = SetsLayout.GRID_COLS * layout.gridRows
    layout.cardW, layout.cardH = CardView.sizeAt(layout.scale)
    layout.tileH = layout.cardH + CAPTION_H
    layout.bodyH = layout.gridRows * layout.tileH
    -- the set list runs from under the search box and drop-down to the footer
    layout.listRows = math.floor((HEADER_H + layout.bodyH - (LIST_TOP - TOP) + ROW_STEP - ROW_H) / ROW_STEP)
    layout.trackH = layout.listRows * ROW_STEP - (ROW_STEP - ROW_H)
    layout.footerY = BODY_Y + layout.bodyH + FOOTER_GAP
    layout.height = BODY_Y + layout.bodyH + FOOTER_GAP + FOOTER_H
    return layout
end

return SetsLayout
