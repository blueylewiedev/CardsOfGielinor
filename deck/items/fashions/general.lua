local Set = {}

Set.cards = {
    {
        id = "giants_hand", name = "Giant's hand", kind = "item", rarity = "common",
        desc = "Let's give them a big hand!",
        art = { item = "CRCS_GIANT_HAND", cam = { yaw = 2.00, dist = 456, ty = 20, tx = 10 } },
        tags = { category = { "fashion", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "banner_of_armadyl", name = "Banner of Armadyl", kind = "item", rarity = "common",
        desc = "A banner showing your support of Armadyl.",
        art = { item = "GODEM_BANNER_ARMADYL_TIER4", cam = { yaw = -1.60, dist = 525, fov = 55, tx = 10 } },
        tags = { regions = { "asgarnia" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "banner_of_bandos", name = "Banner of Bandos", kind = "item", rarity = "common",
        desc = "A banner showing your support of Bandos.",
        art = { item = "GODEM_BANNER_BANDOS_TIER4", cam = { yaw = -1.80, dist = 525 } },
        tags = { regions = { "asgarnia" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "banner_of_saradomin", name = "Banner of Saradomin", kind = "item", rarity = "common",
        desc = "A banner showing your support of Saradomin.",
        art = { item = "GODEM_BANNER_SARADOMIN_TIER4", cam = { yaw = -1.80, pitch = 1.55, dist = 525 } },
        tags = { regions = { "asgarnia" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "banner_of_seren", name = "Banner of Seren", kind = "item", rarity = "common",
        desc = "A banner showing your support of Seren.",
        art = { item = "GODEM_BANNER_SEREN_TIER4", cam = { yaw = -1.80, dist = 525 } },
        tags = { regions = { "tirannwn" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "banner_of_sliske", name = "Banner of Sliske", kind = "item", rarity = "common",
        desc = "A banner showing your support of Sliske.",
        art = { item = "GODEM_BANNER_SLISKE_TIER4", cam = { yaw = -1.80, dist = 525 } },
        tags = { regions = { "misthalin" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "banner_of_v", name = "Banner of V", kind = "item", rarity = "common",
        desc = "A banner showing your support of V.",
        art = { item = "GODEM_BANNER_V_TIER4", cam = { yaw = -1.60, pitch = 1.40, dist = 263, fov = 90, ty = -20, tx = 30 } },
        tags = { regions = { "fremennik_province" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "banner_of_zamorak", name = "Banner of Zamorak", kind = "item", rarity = "common",
        desc = "A banner showing your support of Zamorak.",
        art = { item = "GODEM_BANNER_ZAMORAK_TIER4", cam = { yaw = -1.80, pitch = 1.55, dist = 228, fov = 100 } },
        tags = { regions = { "misthalin" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "banner_of_zaros", name = "Banner of Zaros", kind = "item", rarity = "common",
        desc = "A banner showing your support of Zaros.",
        art = { item = "GODEM_BANNER_ZAROS_TIER4", cam = { yaw = -1.80, pitch = 1.35, dist = 262, fov = 90, ty = -20, tx = 40 } },
        tags = { regions = { "misthalin" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "banner_of_the_godless", name = "Banner of the Godless", kind = "item", rarity = "common",
        desc = "A banner showing your support of the Godless.",
        art = { item = "GODEM_BANNER_GODLESS_TIER4", cam = { yaw = -1.80, dist = 150, fov = 120, tx = 20 } },
        tags = { regions = { "asgarnia" }, category = { "weapon", "melee_gear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "bronze_fist_flag", name = "Bronze fist flag", kind = "item", rarity = "common",
        desc = "The flag of The Bronze Fist.",
        art = { item = "BREW_FLAG_3", cam = { yaw = -0.60, dist = 457, fov = 65, ty = -60, tx = 50 } },
        tags = { regions = { "morytania" }, category = { "fashion", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "broomstick", name = "Broomstick", kind = "item", rarity = "common",
        desc = "A threat to dusty corners everywhere.",
        art = { item = "SWEPT_BROOM", cam = { yaw = -7.80, dist = 603 } },
        tags = { regions = { "kharidian_desert" }, category = { "quest_item", "fashion", "weapon" }, membership = { "f2p" } },
    },
    {
        id = "candy_floss_maul", name = "Candy floss maul", kind = "item", rarity = "common",
        desc = "A memento from Party Pete, during the Invasion of Falador.",
        art = { item = "FALSIEGE_CANDYFLOSS", cam = { yaw = -7.80, dist = 525, fov = 70, ty = 20, tx = -40 } },
        tags = { category = { "weapon", "melee_gear", "discontinued", "fashion", "maul" }, membership = { "f2p" } },
    },
    {
        id = "christmas_scythe", name = "Christmas scythe", kind = "item", rarity = "legendary",
        desc = "Looks like if you tried to eat this it would hurt.",
        art = { item = "XMAS_SCYTHE", cam = { yaw = -5.80, dist = 1214, fov = 35, ty = 40, tx = 20 } },
        tags = { category = { "weapon", "melee_gear", "discontinued", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "cutthroat_flag", name = "Cutthroat flag", kind = "item", rarity = "common",
        desc = "The flag of The Cutthroat.",
        art = { item = "BREW_FLAG_1", cam = { yaw = -6.80, dist = 694, fov = 45, ty = -20, tx = 20 } },
        tags = { regions = { "morytania" }, category = { "minigame", "fashion", "weapon" }, membership = { "p2p" } },
    },
    {
        id = "fairylight_whip", name = "Fairylight whip", kind = "item", rarity = "common",
        desc = "A set of fairylights.",
        art = { item = "VIB2_FAIRYLIGHT_WHIP", cam = { yaw = -5.60, dist = 525, fov = 30, ty = -20 } },
        tags = { category = { "weapon", "melee_gear", "whip", "quest_item", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "full_easter_basket", name = "Full Easter basket", kind = "item", rarity = "epic",
        desc = "An Easter basket full with eggs.",
        art = { item = "EASTER23_EGG_BASKET_FULL", cam = { yaw = -7.20, pitch = 0.75, dist = 397, fov = 35, ty = 60 } },
        tags = { category = { "fashion", "weapon", "discontinued" }, membership = { "f2p" } },
    },
    {
        id = "guilded_smile_flag", name = "Guilded smile flag", kind = "item", rarity = "common",
        desc = "The flag of The Guilded Smile.",
        art = { item = "BREW_FLAG_2", cam = { yaw = -6.80, dist = 603, ty = -20, tx = 20 } },
        tags = { regions = { "morytania" }, category = { "minigame", "fashion" }, membership = { "p2p" } },
    },
    {
        id = "royal_sceptre", name = "Royal sceptre", kind = "item", rarity = "uncommon",
        desc = "The sceptre of royalty!",
        art = { item = "II_ROYAL_SCEPTRE", cam = { yaw = -6.49, pitch = 0.80, dist = 578, fov = 35, ty = 4, tx = 22 } },
        tags = { category = { "weapon", "melee_gear", "mace", "fashion" }, membership = { "p2p" } },
    },
    {
        id = "toy_kite", name = "Toy kite", kind = "item", rarity = "common",
        desc = "A kite with a dragon on it.",
        art = { item = "APR08_DRAGON_KITE", cam = { yaw = -7.20, dist = 525, fov = 35 } },
        tags = { category = { "fashion" }, membership = { "f2p" } },
    },
    {
        id = "scythe", name = "Scythe", kind = "item", rarity = "legendary",
        desc = "It's a Scythe.",
        art = { item = "SCYTHE", cam = { yaw = -6.55, dist = 768, fov = 35 } },
        tags = { category = { "weapon", "melee_gear", "fashion", "discontinued" }, membership = { "f2p" } },
    },
    {
        id = "pitchfork_of_justice", name = "Pitchfork of justice", kind = "item", rarity = "common",
        desc = "Sweet, golden, stabby justice.",
        art = { item = "BOTOFF_TRIAL_PITCHFORK_2", cam = { yaw = -3.28, dist = 603, ty = 4, tx = 29 } },
        tags = { category = { "weapon", "melee_gear", "spear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "pitchfork_of_vigilantism", name = "Pitchfork of vigilantism", kind = "item", rarity = "common",
        desc = "Good for waving angrily.",
        art = { item = "BOTOFF_TRIAL_PITCHFORK", cam = { yaw = -3.27, dist = 498, ty = 12, tx = 17 } },
        tags = { category = { "weapon", "melee_gear", "spear", "fashion" }, membership = { "f2p" } },
    },
    {
        id = "phasmatys_flag", name = "Phasmatys flag", kind = "item", rarity = "common",
        desc = "The flag of The Phasmatys Pride.",
        art = { item = "BREW_FLAG_6", cam = { yaw = -0.72, dist = 699, fov = 45, ty = -26, tx = 75 } },
        tags = { category = { "weapon", "melee_gear", "sword", "minigame", "fashion" }, membership = { "p2p" } },
    },
    {
        id = "treasure_flag", name = "Treasure flag", kind = "item", rarity = "common",
        desc = "The flag of The Treasure Trove.",
        art = { item = "BREW_FLAG_5", cam = { yaw = -0.79, dist = 699, fov = 45, ty = -39, tx = 63 } },
        tags = { category = { "weapon", "melee_gear", "sword", "minigame", "fashion" }, membership = { "p2p" } },
    },
    {
        id = "shadow_sword", name = "Shadow sword", kind = "item", rarity = "common",
        desc = "A shadow sword.",
        art = { item = "SHADOW_MAJ_SHADOW_SWORD", cam = { yaw = -3.31, dist = 525, fov = 45, ty = 75, tx = 27 } },
        tags = { category = { "weapon", "melee_gear", "sword", "quest_item", "two_handed_sword", "fashion" }, membership = { "p2p" } },
    },
}

return Set
