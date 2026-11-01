local Set = {}

Set.cards = {
    {
        id = "adamant_off_hand_scimitar", name = "Adamant off hand scimitar", kind = "item", rarity = "uncommon",
        desc = "An adamant off hand scimitar.",
        art = { item = "ADAMANT_SCIMITAR_O", cam = { yaw = -4.40, pitch = 1.55, dist = 525, fov = 45, tx = -10 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "adamant_scimitar", name = "Adamant scimitar", kind = "item", rarity = "uncommon",
        desc = "An adamant scimitar.",
        art = { item = "ADAMANT_SCIMITAR", cam = { yaw = -2.20, dist = 525, fov = 40, tx = 20 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "black_scimitar", name = "Black scimitar", kind = "item", rarity = "uncommon",
        desc = "A vicious, curved sword.",
        art = { item = "BLACK_SCIMITAR", cam = { yaw = -0.80, dist = 525, fov = 30 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "blisterwood_sickle", name = "Blisterwood sickle", kind = "item", rarity = "epic",
        desc = "A sickle with a handle carved from the blisterwood tree.",
        art = { item = "MYQ6_BLISTERWOOD_SICKLE", cam = { yaw = -0.20, dist = 525, fov = 35 } },
        tags = { regions = { "morytania" }, skills = { "fletching", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "brine_sabre", name = "Brine sabre", kind = "item", rarity = "uncommon",
        desc = "A salty sword.",
        art = { item = "OLAF2_BRINE_SABRE", cam = { yaw = -1.60, dist = 525, fov = 40, tx = -10 } },
        tags = { regions = { "fremennik_province" }, skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "bronze_off_hand_scimitar", name = "Bronze off hand scimitar", kind = "item", rarity = "common",
        desc = "A vicious, curved off-hand sword.",
        art = { item = "BRONZE_SCIMITAR_O", cam = { yaw = -2.20, dist = 456, fov = 40, tx = 20 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "bronze_scimitar", name = "Bronze scimitar", kind = "item", rarity = "common",
        desc = "A vicious, curved sword.",
        art = { item = "BRONZE_SCIMITAR", cam = { yaw = -0.80, dist = 525, fov = 35 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "corrupt_dragon_scimitar", name = "Corrupt dragon scimitar", kind = "item", rarity = "epic",
        desc = "This item degrades while worn, and will turn to dust.",
        art = { item = "PVPW_DRAGON_SCIMITAR", cam = { yaw = -7.20, dist = 525, fov = 40, ty = 20 } },
        tags = { regions = { "wilderness" }, skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "dragon_scimitar", name = "Dragon scimitar", kind = "item", rarity = "rare",
        desc = "A vicious, curved sword",
        art = { item = "DRAGON_SCIMITAR", cam = { yaw = -7.20, dist = 603, fov = 35, ty = 20 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "iron_off_hand_scimitar", name = "Iron off hand scimitar", kind = "item", rarity = "common",
        desc = "A vicious, curved off-hand sword.",
        art = { item = "IRON_SCIMITAR_O", cam = { yaw = -5.30, dist = 377, fov = 40, ty = 11, tx = -2 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "iron_scimitar", name = "Iron scimitar", kind = "item", rarity = "common",
        desc = "A vicious, curved sword.",
        art = { item = "IRON_SCIMITAR", cam = { yaw = -0.92, dist = 477, fov = 35 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "iron_sickle", name = "Iron sickle", kind = "item", rarity = "common",
        desc = "Not as good as a pet frog.",
        art = { item = "IRON_SICKLE", cam = { yaw = -3.42, dist = 434, fov = 35, ty = -9, tx = 30 } },
        tags = { category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "silver_sickle", name = "Silver sickle", kind = "item", rarity = "common",
        desc = "It's a silver sickle.",
        art = { item = "SILVER_SICKLE", cam = { yaw = -3.46, dist = 394, fov = 35, tx = 22 } },
        tags = { regions = { "morytania" }, skills = { "crafting" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "steel_off_hand_scimitar", name = "Steel off hand scimitar", kind = "item", rarity = "common",
        desc = "A steel off hand scimitar.",
        art = { item = "STEEL_SCIMITAR_O", cam = { yaw = -5.68, dist = 456, fov = 40, ty = 15, tx = 2 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "steel_scimitar", name = "Steel scimitar", kind = "item", rarity = "common",
        desc = "A steel scimitar.",
        art = { item = "STEEL_SCIMITAR", cam = { yaw = -1.26, dist = 525, fov = 35, tx = -18 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "mithril_off_hand_scimitar", name = "Mithril off hand scimitar", kind = "item", rarity = "uncommon",
        desc = "A mithril off hand scimitar.",
        art = { item = "MITHRIL_SCIMITAR_O", cam = { yaw = -5.35, dist = 377, fov = 40, ty = -10, tx = 16 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "mithril_scimitar", name = "Mithril scimitar", kind = "item", rarity = "uncommon",
        desc = "A mithril scimitar.",
        art = { item = "MITHRIL_SCIMITAR", cam = { yaw = -1.01, dist = 394, fov = 35, ty = 17, tx = 8 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "offhand_black_scimitar", name = "Off-hand black scimitar", kind = "item", rarity = "uncommon",
        desc = "A vicious, curved off-hand sword.",
        art = { item = "BLACK_SCIMITAR_O", cam = { yaw = -5.27, dist = 377, fov = 40, ty = 2, tx = -5 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "white_scimitar", name = "White scimitar", kind = "item", rarity = "uncommon",
        desc = "A vicious, curved sword.",
        art = { item = "WHITE_SCIMITAR", cam = { yaw = -1.67, dist = 525, fov = 35 } },
        tags = { skills = { "attack", "prayer" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "offhand_dragon_scimitar", name = "Off-hand dragon scimitar", kind = "item", rarity = "rare",
        desc = "A vicious, curved off-hand sword.",
        art = { item = "DRAGON_SCIMITAR_O", cam = { yaw = -5.48, dist = 456, fov = 40, tx = 20 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "rune_off_hand_scimitar", name = "Rune off hand scimitar", kind = "item", rarity = "rare",
        desc = "A rune off hand scimitar.",
        art = { item = "RUNE_SCIMITAR_O", cam = { yaw = -4.62, dist = 456, fov = 40, ty = -17, tx = 3 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "rune_scimitar", name = "Rune scimitar", kind = "item", rarity = "rare",
        desc = "A rune scimitar.",
        art = { item = "RUNE_SCIMITAR", cam = { yaw = -0.25, dist = 525, fov = 35, tx = 20 } },
        tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "f2p" } },
    },
    {
        id = "sacred_clay_scimitar", name = "Sacred clay scimitar", kind = "item", rarity = "rare",
        desc = "The sacred clay weapon has transformed into a sharp scimitar.",
        art = { item = "SC_REWARD_SWORD", cam = { yaw = -0.74, dist = 578, fov = 35, ty = -32, tx = -11 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "superior_dragon_scimitar", name = "Superior dragon scimitar", kind = "item", rarity = "epic",
        desc = "A very, very powerful scimitar.",
        art = { item = "DMBH_DRAGON_SCIMITAR", cam = { yaw = -1.16, dist = 525, fov = 35, ty = 7, tx = -5 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "superior_offhand_dragon_scimitar", name = "Superior off-hand dragon scimitar", kind = "item", rarity = "epic",
        desc = "A very, very powerful off-hand scimitar.",
        art = { item = "DMBH_DRAGON_SCIMITAR_O", cam = { yaw = -5.44, dist = 456, fov = 40, ty = -17, tx = 15 } },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
    {
        id = "offhand_blisterwood_sickle", name = "Off-hand blisterwood sickle", kind = "item", rarity = "epic",
        desc = "A sickle with a handle carved from the blisterwood tree.",
        art = { item = "MYQ6_BLISTERWOOD_SICKLE_O", cam = { yaw = -4.77, dist = 434, fov = 35, ty = 6, tx = 6 } },
        tags = { regions = { "morytania" }, skills = { "fletching", "crafting", "attack" }, category = { "weapon", "melee_gear", "scimitar" }, membership = { "p2p" } },
    },
}

return Set
