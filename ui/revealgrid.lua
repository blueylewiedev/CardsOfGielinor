-- ui/revealgrid.lua
-- Where the cards of the pack opening go: how big to draw them for the screen, how many make a page, and the places of a
-- page's cards in a grid above the bottom bar (and of the stack they are dealt from). Only sums; ui/revealscreen.lua uses them.

local CardView = require("ui/cardview")
local RevealCards = require("ui/revealcards")

local RevealGrid = {}

local GAP = 20                          -- between cards
local LABEL_H = RevealCards.LABEL_H
local SIDE_MARGIN = 60
local PAGE_COLS, PAGE_SIZE = 5, 10
local MIN_FIT = 0.5                     -- cards are shrunk at most to this fraction to fit a small screen
local PACK_H_MIN, PACK_H_MAX = 240, 480

RevealGrid.BAR_H = 130                  -- the bottom bar (the line of text and the button) and the space above it
local BAR_H = RevealGrid.BAR_H

-- How big to draw the cards: CardView.SCALE if a page fits on the screen, smaller (down to MIN_FIT of it) if not.
local function chooseScale(SW, SH, total)
    local cols = math.min(PAGE_COLS, total)
    local rows = math.min(2, math.ceil(math.min(total, PAGE_SIZE) / PAGE_COLS))
    local cw, ch = CardView.sizeAt(CardView.SCALE)
    local needW = cols * cw + (cols - 1) * GAP
    local needH = rows * (ch + LABEL_H) + (rows - 1) * GAP
    local fit = math.min(1, (SW - 2 * SIDE_MARGIN) / needW, (SH - BAR_H - 20) / needH)
    if fit < 1 then
        fit = fit * 0.97                  -- (the card's size is whole pixels, so leave a little to spare)
    end
    return CardView.SCALE * math.max(MIN_FIT, fit)
end

-- What fits on a screen `SW` x `SH` for `total` cards: { scale, cw, ch (card size), cols, pageSize, pages, packH }.
function RevealGrid.fit(SW, SH, total)
    local fit = { scale = chooseScale(SW, SH, total) }
    fit.cw, fit.ch = CardView.sizeAt(fit.scale)
    fit.cols = math.max(1, math.min(PAGE_COLS, (SW - 2 * SIDE_MARGIN + GAP) // (fit.cw + GAP)))
    local maxRows = math.max(1, (SH - BAR_H - 20 + GAP) // (fit.ch + LABEL_H + GAP))
    fit.pageSize = math.max(1, math.min(PAGE_SIZE, fit.cols * maxRows))
    fit.pages = math.ceil(total / fit.pageSize)
    fit.packH = math.max(PACK_H_MIN, math.min(PACK_H_MAX, math.floor(SH * 0.45)))
    return fit
end

-- The sizes of the rows of `count` cards, as even as can be: 10 is 5 and 5, 7 is 4 and 3.
local function rowSizes(count, maxCols)
    local rows = math.ceil(count / maxCols)
    local base, extra = count // rows, count % rows
    local sizes = {}
    for r = 1, rows do
        sizes[r] = base + ((r <= extra) and 1 or 0)
    end
    return sizes
end

-- Where a page of `count` cards goes, for the reveal `R`: slots (the { x, y } top left corners, each row centred, the whole
-- grid centred above the bar), and the stack's place (stackX, stackY): centred, level with the middle of the grid.
function RevealGrid.page(R, count)
    local sizes = rowSizes(count, R.cols)
    local rows = #sizes
    local gridH = rows * (R.ch + LABEL_H) + (rows - 1) * GAP
    local top = math.floor((R.areaH - gridH) / 2)
    local slots, i = {}, 0
    for r, n in ipairs(sizes) do
        local rowW = n * R.cw + (n - 1) * GAP
        local x0 = math.floor((R.SW - rowW) / 2)
        for k = 1, n do
            i = i + 1
            slots[i] = { x = x0 + (k - 1) * (R.cw + GAP), y = top + (r - 1) * (R.ch + LABEL_H + GAP) }
        end
    end
    return slots, math.floor((R.SW - R.cw) / 2), top + (gridH - LABEL_H - R.ch) // 2
end

return RevealGrid
