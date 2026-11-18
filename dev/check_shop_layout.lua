-- dev/check_shop_layout.lua
-- Checks where the Shop's tiles, section titles and dividers go (ui/shoplayout.lua): the general packs and the region packs
-- in two sections with a title over each and a divider between, rows that do not overlap, and one section with no title. The
-- layout has no client calls, so this needs none. The real deck's packs are used for the last check.
--
-- Run from the plugin's folder:  lua dev/check_shop_layout.lua

package.path = "./?.lua;./dev/?.lua;" .. package.path

function log() end          -- the client's log function

local ShopLayout = require("ui/shoplayout")

local failures = 0
local function check(ok, what)
    if not ok then
        failures = failures + 1
        io.stderr:write("FAIL: " .. what .. "\n")
    end
end

local M = { columns = 4, tileW = 100, gapX = 28, left = 10, top = 6, titleH = 20, titleGap = 12, rowH = 190, lastRowH = 170,
    dividerGap = 14, bottom = 10 }

local function packs(general, regions)
    local list = {}
    for i = 1, general do list[#list + 1] = { id = "g" .. i, featured = i } end
    for i = 1, regions do list[#list + 1] = { id = "r" .. i } end
    return list
end

-- both sections
do
    local layout = ShopLayout.place(packs(3, 11), M)
    check(#layout.headings == 2 and layout.headings[1].id == "general" and layout.headings[2].id == "regions",
        "a title over each section, general first")
    check(#layout.dividers == 1, "one divider, between the sections")
    local g1, r1 = layout.tiles[1], layout.tiles[4]
    check(g1.y == layout.headings[1].y + M.titleH + M.titleGap, "the general tiles start under their title")
    check(layout.headings[1].y == M.top, "the first title is at the top")
    check(layout.dividers[1] > g1.y + M.lastRowH and layout.dividers[1] < layout.headings[2].y,
        "the divider is under the last general row and over the second title")
    check(r1.y == layout.headings[2].y + M.titleH + M.titleGap, "the region tiles start under their title")
    check(layout.tiles[1].x == M.left and layout.tiles[2].x == M.left + M.tileW + M.gapX, "tiles go across in columns from the left")
    check(layout.tiles[3].y == g1.y and layout.tiles[4].y > layout.tiles[3].y, "3 general packs are one row and the regions start fresh")
    check(r1.x == M.left, "the regions start at the first column, not after the general packs")
    -- 11 region packs: 3 rows (4, 4, 3)
    check(layout.tiles[4 + 4].y == r1.y + M.rowH and layout.tiles[4 + 8].y == r1.y + 2 * M.rowH, "rows are rowH apart")
    check(layout.tiles[4 + 8].x == M.left and layout.tiles[4 + 10].x == M.left + 2 * (M.tileW + M.gapX), "the last row is filled from the left")
    check(layout.height == layout.tiles[4 + 8].y + M.lastRowH + M.bottom, "the height ends under the last row's names")
    check(layout.width == 4 * M.tileW + 3 * M.gapX, "the width is the columns' (a divider's)")
    -- no two tiles in the same cell, and none above the first title
    local seen = {}
    for index = 1, 14 do
        local t = layout.tiles[index]
        local key = t.x .. "," .. t.y
        check(not seen[key], "tile " .. index .. " has a cell of its own")
        seen[key] = true
        check(t.y >= M.top, "tile " .. index .. " is not above the top")
    end
end

-- a full general row, and more than a row
do
    local layout = ShopLayout.place(packs(4, 1), M)
    check(layout.tiles[5].y > layout.tiles[4].y and layout.tiles[5].x == M.left, "a full general row, then the regions on the next")
    layout = ShopLayout.place(packs(5, 1), M)
    check(layout.tiles[5].y == layout.tiles[1].y + M.rowH and layout.tiles[5].x == M.left, "five general packs make a second row")
end

-- one section: no title and no divider
for _, case in ipairs({ { 0, 12 }, { 5, 0 } }) do
    local layout = ShopLayout.place(packs(case[1], case[2]), M)
    check(#layout.headings == 0 and #layout.dividers == 0, case[1] .. " general and " .. case[2] .. " region packs: no titles, no divider")
    check(layout.tiles[1].y == M.top, "and the tiles start at the top")
end

-- nothing
do
    local layout = ShopLayout.place({}, M)
    check(next(layout.tiles) == nil and #layout.headings == 0 and layout.height == M.top + M.bottom, "no packs: nothing placed")
end

-- the real deck's packs: every pack is placed, the general ones first
do
    local Cards = require("core/cards")
    local Packs = require("core/packs")
    local offered = Packs.offered()
    local layout = ShopLayout.place(offered, M)
    local placed = 0
    for index = 1, #offered do
        if layout.tiles[index] ~= nil then placed = placed + 1 end
    end
    check(placed == #offered, "every pack in the deck gets a place (" .. placed .. " of " .. #offered .. ")")
    check(#layout.headings == 2, "the deck has both sections")
    local seenRegion = false
    for _, packType in ipairs(offered) do
        if packType.featured == nil then
            seenRegion = true
        else
            check(not seenRegion, "a general pack (" .. packType.id .. ") comes before every region pack")
        end
    end
    check(offered[1].id == "standard", "the standard pack is first")
end

if failures > 0 then
    io.stderr:write(failures .. " shop layout check(s) failed\n")
    os.exit(1)
end
print("OK: the Shop's sections, titles, divider and tiles are laid out as intended")
