local Set = {}

Set.cards = {
    {
        id = "adamant_defender", name = "Adamant defender", kind = "item", rarity = "uncommon",
        desc = "A defensive weapon, reduces damage and increases accuracy.",
        art = { item = "ADAMANT_PARRYINGDAGGER", cam = { yaw = -1.60, pitch = 1.20, dist = 525, fov = 30 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "f2p" } },
    },
    {
        id = "ancient_defender", name = "Ancient defender", kind = "item", rarity = "epic",
        desc = "A defensive weapon, reduces damage and increases accuracy.",
        art = { item = "T80_MELEE_PARRYINGDAGGER", cam = { yaw = -2.20, pitch = 1.25, dist = 525, fov = 30, tx = 20 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "p2p" } },
    },
    {
        id = "black_defender", name = "Black defender", kind = "item", rarity = "uncommon",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "BLACK_PARRYINGDAGGER", cam = { yaw = -0.80, dist = 262, fov = 45, ty = -20 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "f2p" } },
    },
    {
        id = "bronze_defender", name = "Bronze defender", kind = "item", rarity = "common",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "BRONZE_PARRYINGDAGGER", cam = { yaw = -1.00, dist = 525, fov = 30 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "f2p" } },
    },
    {
        id = "corrupted_defender", name = "Corrupted defender", kind = "item", rarity = "epic",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "T70_MELEE_PARRYINGDAGGER", cam = { yaw = -7.20, dist = 525, fov = 25, ty = -20, tx = 10 } },
        tags = { regions = { "morytania" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "p2p" } },
    },
    {
        id = "dragon_defender", name = "Dragon defender", kind = "item", rarity = "rare",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "DRAGON_PARRYINGDAGGER", cam = { yaw = -7.20, dist = 525, fov = 30 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "p2p" } },
    },
    {
        id = "flameburst_defender", name = "Flameburst defender", kind = "item", rarity = "uncommon",
        desc = "A fiery off-hand dagger.",
        art = { item = "RAND_FLAME_DEFENDER", cam = { yaw = -6.80, dist = 397, fov = 30, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "defence", "magic", "dungeoneering" }, category = { "weapon", "melee_gear", "defender" }, membership = { "p2p" } },
    },
    {
        id = "iron_defender", name = "Iron defender", kind = "item", rarity = "common",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "IRON_PARRYINGDAGGER", cam = { yaw = -7.20, dist = 245, fov = 35, ty = 5, tx = -8 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "f2p" } },
    },
    {
        id = "steel_defender", name = "Steel defender", kind = "item", rarity = "common",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "STEEL_PARRYINGDAGGER", cam = { yaw = -7.20, dist = 358, fov = 35, ty = -6, tx = 6 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "f2p" } },
    },
    {
        id = "mithril_defender", name = "Mithril defender", kind = "item", rarity = "uncommon",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "MITHRIL_PARRYINGDAGGER", cam = { yaw = -7.34, dist = 223, fov = 35, ty = 8, tx = -6 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "f2p" } },
    },
    {
        id = "rune_defender", name = "Rune defender", kind = "item", rarity = "rare",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "RUNE_PARRYINGDAGGER", cam = { yaw = -6.63, dist = 326, fov = 35, tx = -12 } },
        tags = { regions = { "asgarnia" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "f2p" } },
    },
    {
        id = "kalphite_defender", name = "Kalphite defender", kind = "item", rarity = "legendary",
        desc = "A defensive weapon that can parry attacks, reducing damage and increases the accuracy of your next hit.",
        art = { item = "T90_MELEE_PARRYINGDAGGER", cam = { yaw = -1.05, dist = 394, fov = 35, ty = 4, tx = -11 } },
        tags = { regions = { "kharidian_desert" }, skills = { "attack", "defence" }, category = { "weapon", "melee_gear", "defender" }, membership = { "p2p" } },
    },
}

return Set
