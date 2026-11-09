local Set = {}

Set.cards = {
    {
        id = "ectosphere", name = "Ectosphere", kind = "item", rarity = "rare",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_8", cam = { yaw = -3.92, pitch = 0.12, dist = 225, ty = 56, tx = 4 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "elite_seasinger_makigai", name = "Elite seasinger makigai", kind = "item", rarity = "epic",
        desc = "An upgraded magical orb fashioned from a fossilised nautilus kami.",
        art = { item = "DUNGEON_AMINISHI_POP3_MAGIC_WEAPON_O_NEW", cam = { yaw = -0.98, dist = 248, ty = -9, tx = 9 } },
        tags = { regions = { "asgarnia" }, skills = { "runecrafting", "crafting", "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "imperium_core", name = "Imperium core", kind = "item", rarity = "epic",
        desc = "Four augmented elemental shards, forged into a core of power.",
        art = { item = "NEX2_MAGIC_OFFHAND_NEW", cam = { pitch = 0.67, dist = 205, ty = 44, tx = 1 } },
        tags = { regions = { "asgarnia" }, skills = { "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "ode_to_deceit", name = "Ode to Deceit", kind = "item", rarity = "legendary",
        desc = "Nakatra, Devourer Eternal's magic off-hand.",
        art = { item = "MAGIC_DEVOURER_ORB_T95", cam = { yaw = 0.12, pitch = 1.31, dist = 169 } },
        tags = { regions = { "misthalin" }, skills = { "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "seasinger_makigai", name = "Seasinger makigai", kind = "item", rarity = "epic",
        desc = "A magical orb fashioned from a fossilised nautilus kami.",
        art = { item = "POP3_MAGIC_WEAPON_O_NEW", cam = { dist = 205, ty = -4, tx = 6 } },
        tags = { regions = { "asgarnia" }, skills = { "runecrafting", "crafting", "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "seismic_singularity", name = "Seismic singularity", kind = "item", rarity = "legendary",
        desc = "A powerful magical weapon from the depths - held in the off-hand.",
        art = { item = "LRC2_MAGIC_OFFHAND_NEW", cam = { dist = 169 } },
        tags = { regions = { "asgarnia" }, skills = { "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "salve_orb", name = "Salve orb", kind = "item", rarity = "common",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_1", cam = { pitch = 0.10, dist = 225, ty = 48, tx = -3 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "wildercress_orb", name = "Wildercress orb", kind = "item", rarity = "common",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_2", cam = { pitch = 0.10, dist = 225, ty = 48, tx = -3 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "blightleaf_orb", name = "Blightleaf orb", kind = "item", rarity = "common",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_3", cam = { pitch = 0.10, dist = 225, ty = 48, tx = -3 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "bryll_orb", name = "Bryll orb", kind = "item", rarity = "uncommon",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_5", cam = { pitch = -0.00, dist = 225, ty = 68, tx = 0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "roseblood_orb", name = "Roseblood orb", kind = "item", rarity = "common",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_4", cam = { pitch = 0.10, dist = 225, ty = 48, tx = -3 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "spider_orb", name = "Spider orb", kind = "item", rarity = "common",
        desc = "Warning: may contain hundreds of baby spiders that will eat you in your sleep.",
        art = { item = "SPIDER_ORB", cam = { yaw = -0.42, pitch = 0.76, dist = 186, ty = 29, tx = -6 } },
        tags = { regions = { "misthalin", "asgarnia" }, skills = { "crafting", "runecrafting", "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "splitbark_orb", name = "Splitbark orb", kind = "item", rarity = "uncommon",
        desc = "A powerful, magical orb.",
        art = { item = "SPLITBARK_ORB", cam = { yaw = 0.86, pitch = 0.25, dist = 225, ty = 60, tx = -3 } },
        tags = { regions = { "morytania" }, skills = { "crafting", "runecrafting", "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "catalytic_orb", name = "Catalytic orb", kind = "item", rarity = "uncommon",
        desc = "An enchanted globe that shines with power.",
        art = { item = "RAND_CATALYTIC_ORB_1", cam = { yaw = -0.24, pitch = 0.03, dist = 205, ty = 66, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "runecrafting", "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "duskweed_orb", name = "Duskweed orb", kind = "item", rarity = "uncommon",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_6", cam = { pitch = 0.10, dist = 225, ty = 62, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "gravite_orb", name = "Gravite orb", kind = "item", rarity = "uncommon",
        desc = "It's a ball of gravite imbued with a magical essence.",
        art = { item = "RAND_ORB_45_REWARD", cam = { pitch = 0.10, dist = 225, ty = 63, tx = 0 } },
        tags = { regions = { "daemonheim" }, skills = { "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "grifolic_orb", name = "Grifolic orb", kind = "item", rarity = "uncommon",
        desc = "A powerful, magical, smelly orb.",
        art = { item = "GRIFOLIC_ORB", cam = { yaw = -1.06, pitch = 1.02, dist = 205, ty = 18, tx = 5 } },
        tags = { regions = { "misthalin" }, skills = { "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "mystic_orb", name = "Mystic orb", kind = "item", rarity = "uncommon",
        desc = "A powerful, magical orb.",
        art = { item = "MYSTIC_ORB", cam = { yaw = 0.14, pitch = 0.60, dist = 169, ty = 38, tx = -2 } },
        tags = { regions = { "misthalin", "kandarin" }, skills = { "crafting", "runecrafting", "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "soulbell_orb", name = "Soulbell orb", kind = "item", rarity = "uncommon",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_7", cam = { pitch = 0.10, dist = 225, ty = 60, tx = 3 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "f2p" } },
    },
    {
        id = "abyssal_orb", name = "Abyssal orb", kind = "item", rarity = "rare",
        desc = "Did that orb just wink?",
        art = { item = "DT14_ABYSSAL_ORB", cam = { yaw = 0.04, pitch = 0.08, dist = 169, ty = 48, tx = -3 } },
        tags = { skills = { "magic", "slayer" }, category = { "weapon", "magic_gear", "orb", "slayer_drop" }, membership = { "p2p" } },
    },
    {
        id = "blisterwood_orb", name = "Blisterwood orb", kind = "item", rarity = "rare",
        desc = "A knot from the blisterwood tree.",
        art = { item = "MYQ6_BLISTERWOOD_ORB", cam = { yaw = -0.02, dist = 140, ty = -2, tx = 2 } },
        tags = { regions = { "morytania" }, skills = { "fletching", "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "crystal_orb", name = "Crystal orb", kind = "item", rarity = "rare",
        desc = "An orb fashioned from crystal.",
        art = { item = "ELFCITY_CRYSTAL_ORB_100", cam = { dist = 186, ty = -4, tx = 0 } },
        tags = { regions = { "tirannwn" }, skills = { "smithing", "magic", "agility" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "orb_of_the_cywir_elders", name = "Orb of the Cywir elders", kind = "item", rarity = "epic",
        desc = "An orb formed from the antler of Helwyr.",
        art = { item = "GWD2_ANTLER_ORB_100", cam = { yaw = 1.82, pitch = -1.12, dist = 169, ty = 24, tx = -7 } },
        tags = { regions = { "kharidian_desert" }, skills = { "magic" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "runic_orb", name = "Runic orb", kind = "item", rarity = "rare",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_9", cam = { pitch = 0.10, dist = 225, ty = 68, tx = 3 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "attuned_crystal_orb", name = "Attuned crystal orb", kind = "item", rarity = "epic",
        desc = "An orb fashioned from crystal.",
        art = { item = "ELFCITY_CRYSTAL_ORB_ATTUNED_100", cam = { yaw = 0.03, dist = 205, ty = -3, tx = -3 } },
        tags = { regions = { "tirannwn" }, skills = { "smithing", "magic", "agility" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "celestial_catalytic_orb", name = "Celestial catalytic orb", kind = "item", rarity = "epic",
        desc = "An enchanted globe that shines with power.",
        art = { item = "RAND_CATALYTIC_ORB_3", cam = { yaw = -0.39, pitch = 0.10, dist = 225, ty = 65, tx = 5 } },
        tags = { regions = { "daemonheim" }, skills = { "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "empowered_catalytic_orb", name = "Empowered catalytic orb", kind = "item", rarity = "epic",
        desc = "An enchanted globe that shines with power.",
        art = { item = "RAND_CATALYTIC_ORB_2", cam = { yaw = -0.38, pitch = 0.10, dist = 225, ty = 60, tx = 5 } },
        tags = { regions = { "daemonheim" }, skills = { "runecrafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
    {
        id = "spiritbloom_orb", name = "Spiritbloom orb", kind = "item", rarity = "epic",
        desc = "A globe that glows with magical power.",
        art = { item = "RAND_BASIC_ORB_10", cam = { pitch = 0.10, dist = 225, ty = 70, tx = 5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "dungeoneering" }, category = { "weapon", "magic_gear", "orb" }, membership = { "p2p" } },
    },
}

return Set
