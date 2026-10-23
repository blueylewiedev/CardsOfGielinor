-- deck/npcs/general.lua
-- NPCs that are not tied to one region: guards, shop keepers and animals that turn up all over
-- the game. A card here counts for every NPC with that title ("Guard" covers all the guards;
-- "Market Guard" would be its own card), and it has no region or town tags, so region packs
-- never draw it. See deck/npcs/misthalin.lua for how a file like this works.

local Set = {}

Set.cards = {
    { id = "guard", name = "Guard",           rarity = "common",   desc = "Keeps the peace, wherever they stand.", art = { npc = "" }, tags = { skills = { "thieving" }, category = { "guard" } } },
    { id = "shop_keeper",  name = "Shop keeper",      rarity = "common",   desc = "Sells a little bit of everything.",     art = { npc = "" }, tags = { category = { "humanoid" } } },
    { id = "giant_frog",   name = "Giant frog",       rarity = "common",   desc = "Croaks all day in the swamp.",          art = { npc = "" }, tags = { category = { "animal" } } },
}

return Set
