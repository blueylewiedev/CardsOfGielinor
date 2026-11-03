local Set = {}

Set.cards = {
    {
        id = "adamant_cane", name = "Adamant cane", kind = "item", rarity = "uncommon",
        desc = "A ruby-topped cane.",
        art = { item = "TRAIL_ADAMANT_CANE", cam = { yaw = -6.40, dist = 525, fov = 45 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "mace", "treasure_trail" }, membership = { "f2p" } },
    },
    {
        id = "black_cane", name = "Black cane", kind = "item", rarity = "uncommon",
        desc = "A sapphire-topped cane.",
        art = { item = "TRAIL_BLACK_CANE", cam = { yaw = -1.60, dist = 525, fov = 40 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "mace", "treasure_trail" }, membership = { "f2p" } },
    },
    {
        id = "blue_logs", name = "Blue logs", kind = "item", rarity = "rare",
        desc = "A number of chemical covered wooden logs.",
        art = { item = "BLUE_LOGS", cam = { yaw = 0.60, pitch = 0.20, dist = 300, fov = 60, ty = 60, tx = 10 } },
        tags = { skills = { "firemaking" }, category = { "raw_material", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "briefcase", name = "Briefcase", kind = "item", rarity = "rare",
        desc = "A suitable container for secret documents.",
        art = { item = "TT14_BRIEFCASE_WEAPON", cam = { yaw = 0.40, dist = 346, fov = 45, tx = 40 } },
        tags = { category = { "weapon", "melee_gear", "treasure_trail", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "dragon_cane", name = "Dragon cane", kind = "item", rarity = "rare",
        desc = "A diamond-topped cane.",
        art = { item = "TRAIL17_DRAGON_CANE", cam = { yaw = -8.00, dist = 525, fov = 45 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "mace", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "green_logs", name = "Green logs", kind = "item", rarity = "rare",
        desc = "A number of chemical covered wooden logs.",
        art = { item = "GREEN_LOGS", cam = { yaw = 0.60, pitch = 0.20, dist = 300, fov = 60, ty = 60, tx = 10 } },
        tags = { skills = { "firemaking" }, category = { "raw_material", "treasure_trail", "log" }, membership = { "p2p" } },
    },
    {
        id = "offhand_briefcase", name = "Off-hand briefcase", kind = "item", rarity = "uncommon",
        desc = "A suitable container for secret documents.",
        art = { item = "TT14_BRIEFCASE_WEAPON_O", cam = { yaw = -5.03, dist = 477, fov = 30, ty = -1, tx = 24 } },
        tags = { category = { "weapon", "melee_gear", "mace", "treasure_trail" }, membership = { "f2p" } },
    },
    {
        id = "offhand_suitcase", name = "Off-hand suitcase", kind = "item", rarity = "uncommon",
        desc = "A suitcase for traveling the world.",
        art = { item = "TT14_SUITCASE_WEAPON_O", cam = { yaw = -4.89, dist = 699, fov = 30, ty = -1, tx = 7 } },
        tags = { category = { "weapon", "melee_gear", "mace", "treasure_trail" }, membership = { "f2p" } },
    },
    {
        id = "purple_logs", name = "Purple logs", kind = "item", rarity = "rare",
        desc = "A number of chemical- covered wooden logs.",
        art = { item = "TRAIL_LOGS_PURPLE", cam = { yaw = 0.60, pitch = 0.20, dist = 300, fov = 60, ty = 60, tx = 10 } },
        tags = { skills = { "firemaking" }, category = { "raw_material", "treasure_trail", "log" }, membership = { "p2p" } },
    },
    {
        id = "red_logs", name = "Red logs", kind = "item", rarity = "rare",
        desc = "A number of chemical covered wooden logs.",
        art = { item = "RED_LOGS", cam = { yaw = 0.60, pitch = 0.20, dist = 300, fov = 60, ty = 60, tx = 10 } },
        tags = { skills = { "firemaking" }, category = { "raw_material", "treasure_trail", "log" }, membership = { "p2p" } },
    },
    {
        id = "rune_cane", name = "Rune cane", kind = "item", rarity = "uncommon",
        desc = "A diamond-topped cane.",
        art = { item = "TRAIL_RUNE_CANE", cam = { yaw = -7.90, dist = 525, fov = 35, ty = 5, tx = -3 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "mace", "treasure_trail" }, membership = { "f2p" } },
    },
    {
        id = "secondage_sword", name = "Second-Age sword", kind = "item", rarity = "legendary",
        desc = "An ancient weapon forged from a magical gold.",
        art = { item = "TRAIL17_SECONDAGE_MELEE_WEAPON", cam = { yaw = -1.58, dist = 394, fov = 45, ty = 10, tx = 10 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "sword", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "suitcase", name = "Suitcase", kind = "item", rarity = "uncommon",
        desc = "A suitcase for traveling the world.",
        art = { item = "TT14_SUITCASE_WEAPON", cam = { yaw = -5.73, dist = 525, fov = 35, ty = 2, tx = 18 } },
        tags = { category = { "weapon", "melee_gear", "mace", "treasure_trail" }, membership = { "f2p" } },
    },
    {
        id = "white_logs", name = "White logs", kind = "item", rarity = "rare",
        desc = "A number of chemical-covered wooden logs.",
        art = { item = "TRAIL_LOGS_WHITE", cam = { yaw = 0.60, pitch = 0.20, dist = 300, fov = 60, ty = 60, tx = 10 } },
        tags = { skills = { "firemaking" }, category = { "raw_material", "treasure_trail", "log" }, membership = { "p2p" } },
    },
    {
        id = "black_2h_crossbow", name = "Black 2h crossbow", kind = "item", rarity = "uncommon",
        desc = "A black two-handed crossbow.",
        art = { item = "TT14_BLACK_2H_XBOW", cam = { yaw = -2.82, pitch = 0.28, dist = 363, ty = 16, tx = -42 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "crossbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "black_crossbow", name = "Black crossbow", kind = "item", rarity = "uncommon",
        desc = "A black crossbow.",
        art = { item = "TRAIL_BLACK_CROSSBOW", cam = { yaw = -5.93, pitch = 0.96, dist = 225, ty = 6, tx = 21 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "crossbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "offhand_black_crossbow", name = "Off-hand black crossbow", kind = "item", rarity = "uncommon",
        desc = "An off-hand black crossbow.",
        art = { item = "TRAIL_BLACK_CROSSBOW_O", cam = { yaw = -2.56, pitch = 0.08, dist = 205, ty = 9, tx = -6 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "crossbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "willow_composite_bow", name = "Willow composite bow", kind = "item", rarity = "uncommon",
        desc = "A powerful bow made from willow.",
        art = { item = "TRAIL_COMPOSITE_BOW_WILLOW", cam = { yaw = -1.61, pitch = 0.98, dist = 532, ty = -51, tx = -5 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "longbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "guthix_bow", name = "Guthix bow", kind = "item", rarity = "rare",
        desc = "A bow imbued with the power of Guthix.",
        art = { item = "TRAIL_GUTHIX_GODBOW", cam = { yaw = -1.60, pitch = 0.86, dist = 400, ty = -28, tx = -40 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "longbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "saradomin_bow", name = "Saradomin bow", kind = "item", rarity = "rare",
        desc = "A bow imbued with the power of Saradomin.",
        art = { item = "TRAIL_SARADOMIN_GODBOW", cam = { yaw = -1.60, pitch = 0.86, dist = 400, ty = -28, tx = -40 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "longbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "zamorak_bow", name = "Zamorak bow", kind = "item", rarity = "rare",
        desc = "A bow imbued with the power of Zamorak.",
        art = { item = "TRAIL_ZAMORAK_GODBOW", cam = { yaw = -1.60, pitch = 0.86, dist = 400, ty = -28, tx = -40 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "longbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "magic_composite_bow", name = "Magic composite bow", kind = "item", rarity = "epic",
        desc = "A powerful bow made from magic logs.",
        art = { item = "TRAIL_COMPOSITE_BOW_MAGIC", cam = { yaw = -1.61, pitch = 0.98, dist = 532, ty = -51, tx = -5 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "longbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "yew_composite_bow", name = "Yew composite bow", kind = "item", rarity = "epic",
        desc = "A powerful bow made from yew.",
        art = { item = "TRAIL_COMPOSITE_BOW_YEW", cam = { yaw = -1.61, pitch = 0.98, dist = 532, ty = -51, tx = -5 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "longbow", "treasure_trail" }, membership = { "p2p" } },
    },
    {
        id = "secondage_bow", name = "Second-Age bow", kind = "item", rarity = "legendary",
        desc = "An exquisite bow created in the Second-Age.",
        art = { item = "TRAIL17_SECONDAGE_RANGE_WEAPON", cam = { yaw = -0.25, pitch = 1.12, dist = 532, ty = -8, tx = 68 } },
        tags = { skills = { "ranged" }, category = { "weapon", "ranged_gear", "shortbow", "treasure_trail" }, membership = { "p2p" } },
    },
}

return Set
