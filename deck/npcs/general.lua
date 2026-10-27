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
        art = { npc = "POF_ANIMAL_COW_COW", anim = 32197, cam = { yaw = 0.40, dist = 1306, ty = 300 } },
        tags = { category = { "animal" } },
    },

    {
        id = "sheep", name = "Sheep", rarity = "common",
        desc = "Gives wool and little else.",
        art = { anim = 32190, cam = { yaw = -0.60, dist = 988, ty = 220 } },
        tags = { category = { "animal" } },
    },

    {
        id = "GOBLIN_UNARMED_MELEE_1", name = "Goblin", rarity = "common",
        desc = "Squabbles over the colour of its armour.",
        art = { anim = 6180, cam = { yaw = -0.20, dist = 859, ty = 280 } },
        tags = { category = { "monster" } },
    },

    {
        id = "LUMBRIDGE_GIANTRAT_BROWN", name = "Giant rat", rarity = "common",
        desc = "Larger than a rat should be.",
        art = { anim = 33921, cam = { pitch = 0.15, dist = 859, ty = 100, tx = -70 } },
        tags = { category = { "animal" } },
    },

    {
        id = "woman", name = "Woman", rarity = "common",
        desc = "One of Gielinor's many citizens",
        art = { npc = "LUMBRIDGE_MARKET_WOMAN3", anim = 37589, cam = { dist = 988, fov = 40, ty = 500, tx = 30 } },
        tags = { skills = { "thieving" }, category = { "humanoid" } },
    },
    
    {
        id = "LUMBRIDGE_MARKET_MAN1", name = "Man", rarity = "common",
        desc = "Just a man, going about his day.",
        art = { anim = 808, cam = { yaw = -0.20, pitch = 0.15, dist = 748, ty = 500 } },
        tags = { skills = { "thieving" }, category = { "humanoid" } },
    },

    {
        id = "dog_stray", name = "Stray dog", rarity = "common",
        desc = "Follows anyone who might have snacks.",
        art = { anim = 22417, cam = { yaw = 0.60, dist = 748, fov = 35, ty = 180, tx = -20 } },
        tags = { category = { "animal" } },
    },

    {

        id = "shopkeeper", name = "Shopkeeper", rarity = "common",
        desc = "Sells stuff",
        art = { npc = "GENERALSHOPKEEPER1", anim = 23783, cam = { yaw = 0.40, dist = 750, fov = 35, ty = 620, tx = 10 } },
        tags = { category = { "humanoid", "shopkeeper" } },
    },

    {
        id = "giant_spider", name = "Giant spider", rarity = "common",
        desc = "Aaaaargh! It's Huge!",
        art = { npc = "LUMBRIDGE_GIANTSPIDER", anim = 5326, cam = { pitch = 0.30, dist = 748, fov = 40, ty = 40 } },
        tags = { skills = { "slayer"}, category = { "monster", "insect" } },
    },

    {
        id = "cave_bug", name = "Cave bug", rarity = "uncommon",
        desc = "A nasty crawling critter",
        art = { npc = "SWAMP_CAVE_BUG", anim = 6077, cam = { yaw = 0.40, pitch = 0.15, dist = 650, fov = 40, ty = 120 } },
        tags = { location = { "lumbridge", "dorgesh_kaan", "burthorpe", "chaos_tunnels" }, skills = { "slayer" }, category = { "insect", "monster" } },
    },

    {
        id = "cave_crawler", name = "Cave crawler", rarity = "rare",
        desc = "A spiky crawling critter.",
        art = { npc = "SLAYER_CAVE_CRAWLER_4", anim = 24517, cam = { yaw = -0.40, pitch = 0.30, dist = 1306, fov = 40, ty = 100, tx = 110 } },
        tags = { location = { "lumbridge", "dorgesh_kaan", "fremennik_slayer_dungeon" }, skills = { "slayer" }, category = { "animal", "monster" } },
    },

    {
        id = "rock_slug", name = "Rock slug", rarity = "rare",
        desc = "The slime of evil.",
        art = { npc = "SLAYER_ROCKSLUG", anim = 23852, cam = { yaw = -0.20, pitch = -0.15, dist = 748, fov = 30, ty = 120, tx = 40 } },
        tags = { location = { "lumbridge", "dorgesh_kaan", "fremennik_slayer_dungeon" }, skills = { "slayer" }, category = { "animal", "monster" } },
    },

    
}

return Set
