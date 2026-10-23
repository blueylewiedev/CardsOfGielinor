-- deck/index.lua
-- The list of card files. The plugin cannot look inside folders, so every new file has to be
-- added here, one line each. Cards in these files stay drafts until their `art.npc` is filled
-- in (see deck/npcs/misthalin.lua for how).
--
-- Layout:
--   deck/npcs/    NPC cards, one file for each region (misthalin.lua, asgarnia.lua, ...), plus
--                 general.lua for NPCs found all over the game (guards, shop keepers, animals)
--   deck/items/   item cards, one file for each kind of item (herbs.lua, logs.lua, weapons.lua...)
--                 -- none yet
--   deck/retag.lua tags for the older cards that are still written in cards.lua

return {
    -- NPCs
    "deck/npcs/misthalin",
    "deck/npcs/asgarnia",
    "deck/npcs/kandarin",
    "deck/npcs/general",

    -- Items (none yet)
}
