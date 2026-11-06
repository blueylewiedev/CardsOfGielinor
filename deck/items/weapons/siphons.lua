local Set = {}

Set.cards = {
    {
        id = "kratonite_guard", name = "Kratonite guard", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_4", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "marmaros_guard", name = "Marmaros guard", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_3", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "novite_guard", name = "Novite guard", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_1", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "f2p" } },
    },
    {
        id = "argonite_guard", name = "Argonite guard", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_7", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "fractite_guard", name = "Fractite guard", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_5", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "gravite_guard", name = "Gravite guard", kind = "item", rarity = "uncommon",
        desc = "A stone-cold siphon.",
        art = { item = "RAND_ARMGUARD_45_REWARD", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "zephyrium_guard", name = "Zephyrium guard", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_6", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "chaotic_guard", name = "Chaotic guard", kind = "item", rarity = "rare",
        desc = "A stone-cold siphon.",
        art = { item = "RAND_ARMGUARD_80_REWARD", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "gorgonite_guard", name = "Gorgonite guard", kind = "item", rarity = "rare",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_9", cam = { yaw = -0.61, dist = 205, ty = 9, tx = 7 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "katagon_guard", name = "Katagon guard", kind = "item", rarity = "rare",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_8", cam = { yaw = -0.61, dist = 205, ty = -11, tx = -16 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "promethium_guard", name = "Promethium guard", kind = "item", rarity = "epic",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_10", cam = { yaw = -0.61, dist = 205, ty = 9, tx = 7 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "entropic_guard", name = "Entropic guard", kind = "item", rarity = "epic",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_11", cam = { yaw = -0.61, dist = 205, ty = 9, tx = 7 } },
        tags = { regions = { "daemonheim" }, skills = { "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "ruinous_guard", name = "Ruinous guard", kind = "item", rarity = "epic",
        desc = "A stone-cold siphon.",
        art = { item = "RAND_ARMGUARD_90_REWARD", cam = { yaw = -0.61, dist = 205, ty = 9, tx = 7 } },
        tags = { regions = { "daemonheim" }, skills = { "dungeoneering", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "devourers_guard", name = "Devourer's Guard", kind = "item", rarity = "legendary",
        desc = "Amascut, the Devourer's armguard.",
        art = { item = "NECRO_DEVOURER_ARMGUARD_T95", cam = { yaw = -0.85, pitch = 1.15, dist = 186, ty = 6, tx = -6 } },
        tags = { regions = { "kharidian_desert" }, skills = { "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "omni_guard", name = "Omni guard", kind = "item", rarity = "legendary",
        desc = "Rasial, the First Necromancer's armguard.",
        art = { item = "NECRO_RASIAL_ARMGUARD_T95", cam = { yaw = -0.85, dist = 186, ty = 10, tx = -9 } },
        tags = { regions = { "misthalin" }, skills = { "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "bathus_guard", name = "Bathus guard", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_2", cam = { yaw = -0.61, dist = 205, ty = -8, tx = -12 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "f2p" } },
    },
    {
        id = "death_guard_tier_10", name = "Death guard (tier 10)", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T1", cam = { yaw = -0.98, dist = 205, ty = 7, tx = -21 } },
        tags = { skills = { "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "f2p" } },
    },
    {
        id = "death_guard_tier_20", name = "Death guard (tier 20)", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T20", cam = { yaw = -0.98, dist = 205, ty = 7, tx = -21 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "death_guard_tier_30", name = "Death guard (tier 30)", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T30", cam = { yaw = -0.98, dist = 205, ty = 7, tx = -21 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "death_guard_tier_40", name = "Death guard (tier 40)", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T40", cam = { yaw = -0.98, dist = 205, ty = 7, tx = -21 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "death_guard_tier_50", name = "Death guard (tier 50)", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T50", cam = { yaw = -0.98, dist = 205, ty = 7, tx = -21 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "death_guard_tier_60", name = "Death guard (tier 60)", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T60", cam = { yaw = -0.98, dist = 205, ty = -0, tx = -1 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "death_guard_tier_70", name = "Death guard (tier 70)", kind = "item", rarity = "rare",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T70", cam = { yaw = -0.98, dist = 205, ty = -0, tx = -1 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "death_guard_tier_80", name = "Death guard (tier 80)", kind = "item", rarity = "rare",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T80", cam = { yaw = -0.98, dist = 225, ty = -2, tx = 9 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "death_guard_tier_90", name = "Death guard (tier 90)", kind = "item", rarity = "epic",
        desc = "A necromancer armguard.",
        art = { item = "NECRO_UNDERWORLD_ARMGUARD_T90", cam = { yaw = -0.98, dist = 225, ty = -6, tx = 11 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
}

return Set
