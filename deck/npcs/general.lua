-- deck/npcs/general.lua
-- NPCs that are not tied to one region: guards, shop keepers and animals that turn up all over
-- the game. A card here counts for every NPC with that title ("Guard" covers all the guards;
-- "Market Guard" would be its own card), and it has no region or town tags, so region packs
-- never draw it. See deck/npcs/misthalin.lua for how a file like this works.
--
-- Elvarg and the King Black Dragon are here until there are files for their regions.

local Set = {}

Set.cards = {
    -- Live cards (these are in the game)

    {
        id = "chicken", name = "Chicken", rarity = "common",
        desc = "Forever crossing roads for no reason.",
        art = { body = true },
        tags = { category = { "animal" } },
    },

    {
        id = "POF_ANIMAL_COW_COW", name = "Cow", rarity = "common",
        desc = "Content to stand in a field all day.",
        art = { npc = "POF_ANIMAL_COW_COW" },
        tags = { category = { "animal" } },
    },

    {
        id = "sheep", name = "Sheep", rarity = "common",
        desc = "Gives wool and little else.",
        tags = { category = { "animal" } },
    },

    {
        id = "GOBLIN_UNARMED_MELEE_1", name = "Goblin", rarity = "common",
        desc = "Squabbles over the colour of its armour.",
        tags = { category = { "monster" } },
    },

    {
        id = "LUMBRIDGE_GIANTRAT_BROWN", name = "Giant rat", rarity = "common",
        desc = "Larger than a rat should be.",
        art = { body = true },
        tags = { category = { "animal" } },
    },

    {
        id = "LUMBRIDGE_MARKET_MAN1", name = "Man", rarity = "common",
        desc = "Just a man, going about his day.",
        tags = { skills = { "thieving" }, category = { "humanoid" } },
    },

    {
        id = "dog_stray", name = "Stray dog", rarity = "common",
        desc = "Follows anyone who might have snacks.",
        tags = { category = { "animal" } },
    },

    {
        id = "elvarg", name = "Elvarg", rarity = "epic",
        desc = "A dragon who prefers to be left alone.",
        tags = { category = { "dragon" } },
    },

    {
        id = "king_dragon", name = "King Black Dragon", rarity = "legendary",
        desc = "Three heads, all of them hungry.",
        tags = { category = { "dragon" } },
    },

    -- Drafts (waiting for an NPC name)

    {
        id = "guard", name = "Guard", rarity = "common",
        desc = "Keeps the peace, wherever they stand.",
        art = { npc = "" },
        tags = { skills = { "thieving" }, category = { "guard" } },
    },

    {
        id = "shop_keeper", name = "Shop keeper", rarity = "common",
        desc = "Sells a little bit of everything.",
        art = { npc = "" },
        tags = { category = { "humanoid" } },
    },

    {
        id = "giant_frog", name = "Giant frog", rarity = "common",
        desc = "Croaks all day in the swamp.",
        art = { npc = "" },
        tags = { category = { "animal" } },
    },
}

return Set
