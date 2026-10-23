-- deck/index.lua
-- The list of card files. The plugin cannot look inside folders, so every new file has to be
-- added here, one line each. A card whose `art.npc` is empty ("") is a draft and stays out of
-- the game until it is filled in (see deck/npcs/misthalin.lua).
--
-- Each card is written as its own block, one field group per line, with no column alignment, so
-- adding or changing a card only changes that card's lines:
--   {
--       id = "wayne", name = "Wayne", rarity = "uncommon",
--       desc = "Chainmail for every budget.",
--       art = { npc = "" },
--       tags = { towns = { "falador" }, skills = { "smithing" }, category = { "shopkeeper" } },
--   },
--
-- Layout:
--   deck/npcs/    NPC cards, one file for each region (misthalin.lua, asgarnia.lua, ...), plus
--                 general.lua for NPCs found all over the game (guards, shop keepers, animals)
--   deck/items/   item cards, one file for each kind of item (herbs.lua, logs.lua, weapons.lua...)
--                 -- none yet

return {
    -- NPCs
    "deck/npcs/misthalin",
    "deck/npcs/asgarnia",
    "deck/npcs/kandarin",
    "deck/npcs/general",

    -- Items (none yet)
}
