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
--       tags = { location = { "falador" }, skills = { "smithing" }, category = { "shopkeeper" } },
--   },
--
-- Layout:
--   deck/npcs/    NPC cards, one file for each region (misthalin.lua, asgarnia.lua, ...), plus
--                 general.lua for NPCs found all over the game (guards, shop keepers, animals)
--   deck/items/   item cards. general.lua for now; as cards are added they go in a folder for each
--                 item category (the word in the plural) with a file for each kind of item, also
--                 in the plural (deck/items/raw_materials/logs.lua, deck/items/weapons/scimitars.lua).
--                 The card builder shows these as "Raw Materials: Logs", "Weapons: Scimitars".
--
-- Every file has to be listed below, including the ones in folders. Run
-- `python dev/check_deck_index.py` to check; it also runs on every pull request.

return {
    -- NPCs
    "deck/npcs/misthalin",
    "deck/npcs/asgarnia",
    "deck/npcs/kandarin",
    "deck/npcs/karamja",
    "deck/npcs/kharidian_desert",
    "deck/npcs/morytania",
    "deck/npcs/tirannwn",
    "deck/npcs/fremennik_province",
    "deck/npcs/wilderness",
    "deck/npcs/anachronia",
    "deck/npcs/havenhythe",
    "deck/npcs/general",

    -- Items
    "deck/items/general",
    "deck/items/raw_materials/herbs",
    "deck/items/raw_materials/logs",
    "deck/items/runes",
    "deck/items/raw_materials/fish",
    "deck/items/food/cooked_fish",
    "deck/items/decoration",
    "deck/items/raw_materials/ores",
    "deck/items/raw_materials/gems",
    "deck/items/processed_materials/gems",
    "deck/items/consumable",
}
