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
}

return Set
