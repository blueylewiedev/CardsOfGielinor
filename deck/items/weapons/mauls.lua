local Set = {}

Set.cards = {
    {
        id = "annihilation", name = "Annihilation", kind = "item", rarity = "rare",
        desc = "A melee weapon of incredible power.",
        art = { item = "DMBH_WEAPON_MELEE_NEW", cam = { yaw = -0.60, dist = 525, fov = 35, ty = -20, tx = 10 } },
        tags = { regions = { "wilderness" }, skills = { "attack" }, category = { "weapon", "melee_gear", "maul", "slayer_drop" }, membership = { "p2p" } },
    },
    {
        id = "barrelchest_anchor", name = "Barrelchest anchor", kind = "item", rarity = "uncommon",
        desc = "This is likely to put my back out...",
        art = { item = "BRAIN_ANCHOR", cam = { pitch = 1.55, dist = 198, fov = 75, ty = 20, tx = 30 } },
        tags = { regions = { "morytania" }, skills = { "attack", "strength" }, category = { "weapon", "melee_gear", "quest_item", "maul" }, membership = { "p2p" } },
    },
    {
        id = "bonecrusher_maul", name = "Bonecrusher maul", kind = "item", rarity = "uncommon",
        desc = "A big bone that crushes smaller bones.",
        art = { item = "WENDLE_GIANT_BOSS_BONE_CLUB", cam = { yaw = 1.40, dist = 301, fov = 80, ty = 40, tx = -30 } },
        tags = { regions = { "havenhythe" }, skills = { "attack", "strength" }, category = { "weapon", "melee_gear", "maul" }, membership = { "f2p" } },
    },
    {
        id = "chaotic_maul", name = "Chaotic maul", kind = "item", rarity = "rare",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_80_REWARD", cam = { yaw = -8.40, dist = 918, fov = 55, ty = -140, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "attack" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
    {
        id = "gadderhammer", name = "Gadderhammer", kind = "item", rarity = "common",
        desc = "A specially crafted hammer with strange markings on it.",
        art = { item = "GADDERANKS_WARHAMMER", cam = { yaw = -8.00, dist = 694, fov = 45, ty = 20 } },
        tags = { regions = { "morytania" }, category = { "weapon", "melee_gear", "quest_item", "maul" }, membership = { "p2p" } },
    },
    {
        id = "granite_maul", name = "Granite maul", kind = "item", rarity = "rare",
        desc = "Simplicity is the best weapon.",
        art = { item = "GRANITE_MAUL", cam = { yaw = -6.40, dist = 603, tx = 10 } },
        tags = { skills = { "attack", "strength" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
    {
        id = "torags_hammer", name = "Torag's hammer", kind = "item", rarity = "rare",
        desc = "Torag the Corrupted's twin hammer.",
        art = { item = "BARROWS_TORAG_WEAPON", cam = { yaw = -9.64, dist = 930, fov = 35, ty = 9, tx = 22 } },
        tags = { regions = { "morytania" }, skills = { "attack", "strength" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
    {
        id = "primal_maul", name = "Primal maul", kind = "item", rarity = "epic",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_11", cam = { yaw = -6.92, dist = 578, fov = 35, ty = -10, tx = 7 } },
        tags = { regions = { "daemonheim" }, skills = { "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
    {
        id = "ruinous_maul", name = "Ruinous maul", kind = "item", rarity = "epic",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_90_REWARD", cam = { yaw = -7.32, dist = 846, fov = 35, ty = 54, tx = -17 } },
        tags = { regions = { "daemonheim" }, skills = { "dungeoneering", "attack" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
    {
        id = "terrasaur_maul", name = "Terrasaur maul", kind = "item", rarity = "legendary",
        desc = "It is stronger against targets with ranged powers.",
        art = { item = "DINO_GAME_REWARD_WEAPON_NEW", cam = { yaw = -10.40, dist = 1023, fov = 35, ty = 95, tx = 116 } },
        tags = { skills = { "crafting", "smithing", "strength" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
    {
        id = "tzhaarketom", name = "TzHaar-Ket-Om", kind = "item", rarity = "uncommon",
        desc = "A maul of obsidian.",
        art = { item = "TZHAAR_MAUL", cam = { yaw = -9.58, dist = 525, fov = 35, ty = 3, tx = 10 } },
        tags = { regions = { "karamja" }, skills = { "strength" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
}

return Set
