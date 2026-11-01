local Set = {}

Set.cards = {
    {
        id = "abyssal_scourge", name = "Abyssal scourge", kind = "item", rarity = "legendary",
        desc = "Favoured by Abyssal lords, this whip infects its victims with parasites.",
        art = { item = "ABYSSALS_ABYSSAL_WHIP_NEW", cam = { pitch = 1.20, fov = 45, ty = 20, tx = 10 } },
        tags = { regions = { "misthalin", "wilderness" }, skills = { "attack" }, category = { "weapon", "melee_gear", "whip" }, membership = { "p2p" } },
    },
    {
        id = "abyssal_vine_whip", name = "Abyssal vine whip", kind = "item", rarity = "epic",
        desc = "A weapon from the Abyss, interlaced with a vicious jade vine.",
        art = { item = "JARO_VINE_WHIP_ABYSSAL", cam = { yaw = 0.80, dist = 300, ty = 20, tx = -40 } },
        tags = { skills = { "slayer", "attack" }, category = { "weapon", "melee_gear", "whip" }, membership = { "p2p" } },
    },
    {
        id = "abyssal_whip", name = "Abyssal whip", kind = "item", rarity = "epic",
        desc = "A weapon from the Abyss.",
        art = { item = "ABYSSAL_WHIP" },
        tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "whip" }, membership = { "p2p" } },
    },
    {
        id = "mouse_toy", name = "Mouse toy", kind = "item", rarity = "common",
        desc = "An Advanced Combat Training Device.",
        art = { item = "TWOCATS_MOUSE_TOY", cam = { yaw = -7.20, pitch = 1.23, dist = 477, fov = 35, ty = 2, tx = -16 } },
        tags = { category = { "weapon", "melee_gear", "whip", "quest_item" }, membership = { "p2p" } },
    },
    {
        id = "lava_whip", name = "Lava whip", kind = "item", rarity = "epic",
        desc = "A fiery whip that deals out lashings of pain!",
        art = { item = "SLAYER_CORRUPT_WHIP_CHARGED", cam = { yaw = -4.61, dist = 394, fov = 30, ty = -10, tx = -45 } },
        tags = { regions = { "wilderness" }, skills = { "attack" }, category = { "weapon", "melee_gear", "whip" }, membership = { "p2p" } },
    },
}

return Set
