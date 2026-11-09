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
    {
        id = "beer_glass", name = "Beer glass", kind = "item", rarity = "common",
        desc = "I need to fill this with beer.",
        art = { item = "BEER_GLASS", cam = { yaw = 0.52, pitch = 0.37, dist = 225, ty = 47, tx = 21 } },
        tags = { skills = { "crafting" }, category = { "container" }, membership = { "f2p" } },
    },
    {
        id = "beer_glass_new_varrock", name = "Beer glass (New Varrock)", kind = "item", rarity = "common",
        desc = "Once contained beer.",
        art = { item = "Q200_BEER_GLASS", cam = { yaw = 0.52, pitch = 0.37, dist = 225, ty = 47, tx = 21 } },
        tags = { category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "bucket", name = "Bucket", kind = "item", rarity = "common",
        desc = "It's a wooden bucket.",
        art = { item = "BUCKET_EMPTY", cam = { yaw = 0.52, pitch = 0.37, dist = 362, ty = 97, tx = -8 } },
        tags = { category = { "container" }, membership = { "f2p" } },
    },
    {
        id = "calquat_keg", name = "Calquat keg", kind = "item", rarity = "common",
        desc = "Sliced and hollowed out to form a keg.",
        art = { item = "CALQUAT_FRUIT_KEG_EMPTY", cam = { yaw = 4.97, pitch = 0.57, dist = 399, ty = 109, tx = 2 } },
        tags = { skills = { "farming" }, category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "cornucopia", name = "Cornucopia", kind = "item", rarity = "common",
        desc = "An empty horn of plenty.",
        art = { item = "TG08_CORNUCOPIA_EMPTY", cam = { yaw = 0.81, pitch = 0.37, dist = 299, ty = 103, tx = 41 } },
        tags = { category = { "container" }, membership = { "f2p" } },
    },
    {
        id = "empty_cup", name = "Empty cup", kind = "item", rarity = "common",
        desc = "An empty cup.",
        art = { item = "CUP_EMPTY", cam = { yaw = 0.31, pitch = 0.52, dist = 205, ty = 29, tx = 3 } },
        tags = { category = { "container" }, membership = { "f2p" } },
    },
    {
        id = "enchanted_vial", name = "Enchanted vial", kind = "item", rarity = "common",
        desc = "An enchanted empty glass vial.",
        art = { item = "VIAL_ENCHANTED", cam = { yaw = 0.52, pitch = 0.37, dist = 272, ty = 54, tx = 1 } },
        tags = { category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "impling_jar", name = "Impling jar", kind = "item", rarity = "common",
        desc = "It's got little holes in the top.",
        art = { item = "II_IMPLING_JAR", cam = { yaw = -0.23, pitch = 0.48, dist = 299, ty = 71, tx = -40 } },
        tags = { skills = { "hunter" }, category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "jug", name = "Jug", kind = "item", rarity = "common",
        desc = "This jug is empty.",
        art = { item = "JUG_EMPTY", cam = { yaw = 0.52, pitch = 0.35, dist = 299, ty = 71, tx = 2 } },
        tags = { category = { "container" }, membership = { "f2p" } },
    },
    {
        id = "juju_vial", name = "Juju vial", kind = "item", rarity = "common",
        desc = "An empty, glass juju vial.",
        art = { item = "ECO_VIAL_EMPTY", cam = { yaw = -0.55, pitch = 0.37, dist = 329, ty = 86, tx = 5 } },
        tags = { skills = { "herblore", "farming", "hunter" }, category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "kettle", name = "Kettle", kind = "item", rarity = "common",
        desc = "The kettle is empty.",
        art = { item = "POH_KETTLE_EMPTY", cam = { yaw = 0.52, pitch = 0.37, dist = 329, ty = 86, tx = -4 } },
        tags = { category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "vial", name = "Vial", kind = "item", rarity = "common",
        desc = "An empty glass vial.",
        art = { item = "VIAL_EMPTY", cam = { yaw = 0.01, pitch = 0.37, dist = 225, ty = 50 } },
        tags = { skills = { "crafting", "herblore" }, category = { "container" }, membership = { "f2p" } },
    },
    {
        id = "powerburst_vial", name = "Powerburst vial", kind = "item", rarity = "uncommon",
        desc = "An empty glass vial with a top-heavy shape.",
        art = { item = "POW_VIAL_EMPTY", cam = { yaw = -0.04, pitch = 0.37, dist = 272, ty = 81, tx = -0 } },
        tags = { skills = { "crafting", "herblore" }, category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "crystal_flask", name = "Crystal flask", kind = "item", rarity = "rare",
        desc = "A large, robust flask crafted from crystal glass.",
        art = { item = "CRYSTAL_FLASK", cam = { yaw = -6.38, pitch = 0.37, dist = 248, ty = 79, tx = -2 } },
        tags = { skills = { "crafting", "herblore" }, category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "ogre_flask_empty", name = "Ogre flask (empty)", kind = "item", rarity = "rare",
        desc = "A large flask, it can be filled at the pools in Oo'glog.",
        art = { item = "CRUC_DM_FLASK_EMPTY", cam = { yaw = -1.15, pitch = 0.37, dist = 186, ty = 52, tx = -5 } },
        tags = { skills = { "crafting" }, category = { "container" }, membership = { "p2p" } },
    },
    {
        id = "potion_flask", name = "Potion flask", kind = "item", rarity = "rare",
        desc = "A large, robust flask.",
        art = { item = "BIGPOT_EMPTY", cam = { yaw = 0.32, pitch = 0.48, dist = 248, ty = 66, tx = -1 } },
        tags = { skills = { "crafting" }, category = { "container" }, membership = { "p2p" } },
    },
}

return Set
