local Set = {}

Set.cards = {
    {
        id = "tea_flask", name = "Tea flask", kind = "item", rarity = "common",
        desc = "You can put nice, hot tea in it.",
        art = { item = "TOL_TEA", cam = { yaw = 0.03, pitch = 0.29, dist = 225, ty = 50, tx = -21 } },
        tags = { regions = { "kandarin" }, category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "bowl", name = "Bowl", kind = "item", rarity = "common",
        desc = "Useful for mixing things.",
        art = { item = "BOWL_EMPTY", cam = { yaw = -5.31, pitch = 0.65, dist = 330, ty = 53 } },
        tags = { skills = { "crafting" }, category = { "container" }, membership = { "f2p" } },
    },
    {
        id = "empty_pot", name = "Empty pot", kind = "item", rarity = "common",
        desc = "This pot is empty.",
        art = { item = "POT_EMPTY", cam = { yaw = 0.70, pitch = 0.56, dist = 483, ty = 90, tx = 7 } },
        tags = { skills = { "crafting", "cooking" }, category = { "container" }, membership = { "f2p" } },
    },
    {
        id = "waterskin_0", name = "Waterskin (0)", kind = "item", rarity = "common",
        desc = "A completely empty waterskin - you'll need to fill it up.",
        art = { item = "WATER_SKIN0", cam = { yaw = 0.45, pitch = 0.42, dist = 225, ty = 47 } },
        tags = { category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "cocktail_glass", name = "Cocktail glass", kind = "item", rarity = "common",
        desc = "For sipping cocktails.",
        art = { item = "COCKTAIL_GLASS_EMPTY", cam = { yaw = 0.87, pitch = 0.60, dist = 205, fov = 60, ty = 53, tx = -2 } },
        tags = { category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "blessed_flask", name = "Blessed flask", kind = "item", rarity = "legendary",
        desc = "An extraordinarily holy prayer flask for extreme prayer potions.",
        art = { item = "BLESSED_FLASK", cam = { yaw = -3.57, pitch = 0.16, dist = 205, ty = 69, tx = -4 } },
        tags = { skills = { "crafting" }, category = { "container" }, membership = { "p2p" } },
    },
}

return Set
