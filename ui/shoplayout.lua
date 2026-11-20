-- ui/shoplayout.lua
-- Where the Shop's pack tiles, section titles and dividers go in its scrolling grid. No drawing and no client calls
-- (dev/check_shop_layout.lua); ui/shopwindow.lua draws what it says. Packs are in two sections: the general ones (a
-- pack type with `featured`; Packs.offered puts them first) and the region packs. With both there is a title over
-- each and a divider; with only one there is no title.

local ShopLayout = {}

-- The metrics `m` (in the grid's units, from its top left): columns, tileW, gapX, left (the first column's x), top
-- (room above the first thing; a tile's gold outline sticks out), titleH and titleGap, rowH (one row to the next),
-- lastRowH (how far a row goes down from its y), dividerGap (above and below a divider, which is 1 thick) and bottom.
-- Returns tiles ({ [index in `offered`] = { x, y } }), headings ({ { id, x, y } }, none when there is one section),
-- dividers ({ y }), width (of the columns) and height (of everything).
function ShopLayout.place(offered, m)
    local general, regions = {}, {}
    for index, packType in ipairs(offered) do
        if packType.featured ~= nil then
            general[#general + 1] = index
        else
            regions[#regions + 1] = index
        end
    end
    local sections = {}
    if #general > 0 then
        sections[#sections + 1] = { id = "general", indices = general }
    end
    if #regions > 0 then
        sections[#sections + 1] = { id = "regions", indices = regions }
    end

    local result = { tiles = {}, headings = {}, dividers = {}, width = m.columns * m.tileW + (m.columns - 1) * m.gapX }
    local titled = #sections > 1
    local y = m.top
    for number, section in ipairs(sections) do
        if number > 1 then
            y = y + m.dividerGap
            result.dividers[#result.dividers + 1] = y
            y = y + 1 + m.dividerGap
        end
        if titled then
            result.headings[#result.headings + 1] = { id = section.id, x = m.left, y = y }
            y = y + m.titleH + m.titleGap
        end
        for place, index in ipairs(section.indices) do
            local cell = place - 1
            result.tiles[index] = { x = m.left + (cell % m.columns) * (m.tileW + m.gapX),
                y = y + (cell // m.columns) * m.rowH }
        end
        local rows = (#section.indices + m.columns - 1) // m.columns
        y = y + (rows - 1) * m.rowH + m.lastRowH
    end
    result.height = y + m.bottom
    return result
end

return ShopLayout
