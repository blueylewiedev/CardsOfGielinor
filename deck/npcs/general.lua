-- deck/npcs/general.lua
-- NPCs that are not tied to one region: guards, shop keepers and animals that turn up all over
-- the game. A card here counts for every NPC with that title ("Guard" covers all the guards;
-- "Market Guard" would be its own card), and it has no region or location tags, so region packs
-- never draw it. See deck/npcs/misthalin.lua for how a file like this works.

local Set = {}

Set.cards = {
    -- Live cards (these are in the game)

    {
        id = "chicken", name = "Chicken", rarity = "common",
        desc = "Forever crossing roads for no reason.",
        art = { anim = 27953, cam = { yaw = -0.60, dist = 859, fov = 25, ty = 140, tx = 40 } },
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
        art = { anim = 22417, cam = { yaw = 0.60, dist = 748, fov = 35, ty = 180, tx = -20 } },
        tags = { category = { "animal" } },
    },

    {
        id = "king_roald", name = "King Roald", rarity = "epic",
        desc = "The King of Varrock",
        art = { npc = "KING_ROALD", anim = 5363, cam = { dist = 650, fov = 40, ty = 620 } },
        tags = { location = { "varrock" }, category = { "humanoid", "royalty" } },
    },
}

return Set
