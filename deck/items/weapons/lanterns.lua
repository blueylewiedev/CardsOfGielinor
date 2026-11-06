local Set = {}

Set.cards = {
    {
        id = "bathus_lantern", name = "Bathus lantern", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_2", cam = { yaw = -0.02, dist = 330, ty = -16, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_lantern", name = "Kratonite lantern", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_4", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "marmaros_lantern", name = "Marmaros lantern", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_3", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "novite_lantern", name = "Novite lantern", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_1", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "f2p" } },
    },
    {
        id = "argonite_lantern", name = "Argonite lantern", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_7", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "fractite_lantern", name = "Fractite lantern", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_5", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "gravite_lantern", name = "Gravite lantern", kind = "item", rarity = "uncommon",
        desc = "A stone-cold conduit to the undead.",
        art = { item = "RAND_LANTERN_45_REWARD", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "zephyrium_lantern", name = "Zephyrium lantern", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_6", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "chaotic_lantern", name = "Chaotic lantern", kind = "item", rarity = "rare",
        desc = "A stone-cold conduit to the undead.",
        art = { item = "RAND_LANTERN_80_REWARD", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "gorgonite_lantern", name = "Gorgonite lantern", kind = "item", rarity = "rare",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_9", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "katagon_lantern", name = "Katagon lantern", kind = "item", rarity = "rare",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_8", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "entropic_lantern", name = "Entropic lantern", kind = "item", rarity = "epic",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_11", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "promethium_lantern", name = "Promethium lantern", kind = "item", rarity = "epic",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_10", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "ruinous_lantern", name = "Ruinous lantern", kind = "item", rarity = "epic",
        desc = "A stone-cold conduit to the undead.",
        art = { item = "RAND_LANTERN_90_REWARD", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "soulbound_lantern", name = "Soulbound lantern", kind = "item", rarity = "legendary",
        desc = "Rasial, the First Necromancer's conduit to the Underworld.",
        art = { item = "NECRO_RASIAL_LANTERN_T95", cam = { yaw = -0.04, dist = 399, ty = -41, tx = -0 } },
        tags = { regions = { "misthalin" }, skills = { "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "skull_lantern_tier_10", name = "Skull lantern (tier 10)", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T1", cam = { yaw = -0.03, dist = 248, ty = -13, tx = 5 } },
        tags = { skills = { "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "f2p" } },
    },
    {
        id = "skull_lantern_tier_20", name = "Skull lantern (tier 20)", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T20", cam = { yaw = -0.03, dist = 248, ty = -13, tx = 5 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "skull_lantern_tier_30", name = "Skull lantern (tier 30)", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T30", cam = { yaw = -0.03, dist = 248, ty = -13, tx = 5 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "skull_lantern_tier_40", name = "Skull lantern (tier 40)", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T40", cam = { yaw = -0.03, ty = -21, tx = 5 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "skull_lantern_tier_50", name = "Skull lantern (tier 50)", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T50", cam = { yaw = -0.03, dist = 330, ty = -28, tx = -0 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "skull_lantern_tier_60", name = "Skull lantern (tier 60)", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T60", cam = { yaw = -0.03, dist = 363, ty = -39, tx = 4 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "skull_lantern_tier_70", name = "Skull lantern (tier 70)", kind = "item", rarity = "rare",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T70", cam = { yaw = -0.03, dist = 363, ty = -43, tx = 2 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "skull_lantern_tier_80", name = "Skull lantern (tier 80)", kind = "item", rarity = "rare",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T80", cam = { yaw = -0.03, dist = 439, ty = -47, tx = 2 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "skull_lantern_tier_90", name = "Skull lantern (tier 90)", kind = "item", rarity = "epic",
        desc = "A conduit to the Underworld.",
        art = { item = "NECRO_UNDERWORLD_LANTERN_T90", cam = { yaw = -0.03, dist = 399, ty = -47, tx = 2 } },
        tags = { skills = { "smithing", "necromancy" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
}

return Set
