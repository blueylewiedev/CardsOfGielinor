-- ui/shoplayout.lua
-- Where the Shop's pack tiles, section titles and dividers go inside its scrolling grid. No drawing and no client calls, so
-- it is tested on its own (dev/check_shop_layout.lua); ui/shopwindow.lua draws what it says.
--
-- The packs are in two sections: the general ones (a pack type with a `featured` number, see Cards.packTypes; Packs.offered
-- puts them first, in that order) and the rest, the region packs. With both there is a title over each and a divider between
-- them; with only one there is no title, as there is nothing to tell apart.

local ShopLayout = {}

-- The metrics `m` (all in the grid's own units, from its top left):
--   columns, tileW, gapX   the tiles' columns
--   left                   the first column's x
--   top                    room above whatever comes first (a tile's gold outline sticks out above it)
--   titleH, titleGap       a section title's height, and the space between it and its tiles
--   rowH                   the distance from one row of tiles to the next
--   lastRowH               how far a row goes down from its y (the tile and its name)
--   dividerGap             the space above and below a divider (which is 1 thick)
--   bottom                 room under the last row
-- Returns
--   tiles     { [index in `offered`] = { x, y } }
--   headings  { { id = "general" or "regions", x, y } ... } in order (none when there is only one section)
--   dividers  { y ... }
--   width     how wide the columns are (a divider is this wide, from `left`)
--   height    how tall everything is
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
