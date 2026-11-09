local Set = {}

Set.cards = {
    {
        id = "skewered_beast", name = "Skewered beast", kind = "item", rarity = "common",
        desc = "Beast meat on a spit.",
        art = { item = "SPIT_SKEWERED_BEAST_MEAT", cam = { yaw = 0.30, pitch = -0.08, dist = 273, fov = 60, ty = 64, tx = 26 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "wrapped_oomlie", name = "Wrapped oomlie", kind = "item", rarity = "uncommon",
        desc = "Oomlie meat in a palm leaf pouch. It just needs to be cooked.",
        art = { item = "WRAPPED_OOMLIE", cam = { yaw = 1.38, pitch = 0.58, dist = 248, fov = 60, ty = -9, tx = -20 } },
        tags = { skills = { "cooking" }, category = { "food", "quest_item", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_cave_potato", name = "Raw cave potato", kind = "item", rarity = "common",
        desc = "Not very tasty raw.",
        art = { item = "RAND_RAW_POTATO", cam = { yaw = 0.30, pitch = 0.47, dist = 170, fov = 60, ty = 18, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "farming", "dungeoneering" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_potato", name = "Raw potato", kind = "item", rarity = "common",
        desc = "This could be used to make a good stew.",
        art = { item = "POTATO", cam = { yaw = 0.30, pitch = 0.12, dist = 186, fov = 60, ty = 41, tx = 10 } },
        tags = { skills = { "cooking", "farming" }, category = { "food", "raw_food" }, membership = { "f2p" } },
    },
    {
        id = "uncooked_egg", name = "Uncooked egg", kind = "item", rarity = "common",
        desc = "A bowl of uncooked egg.",
        art = { item = "BOWL_EGG_RAW", cam = { yaw = 0.23, pitch = 0.70, dist = 273, fov = 60, ty = 35, tx = 7 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "uncooked_pizza", name = "Uncooked pizza", kind = "item", rarity = "common",
        desc = "This needs cooking.",
        art = { item = "UNCOOKED_PIZZA", cam = { yaw = 0.34, pitch = 0.78, dist = 300, fov = 60, ty = 3, tx = 8 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "f2p" } },
    },
    {
        id = "uncooked_stew", name = "Uncooked stew", kind = "item", rarity = "common",
        desc = "I need to cook this.",
        art = { item = "UNCOOKED_STEW", cam = { yaw = 0.30, pitch = 0.74, dist = 300, fov = 60, ty = 40, tx = 7 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "f2p" } },
    },
    {
        id = "uncooked_curry", name = "Uncooked curry", kind = "item", rarity = "uncommon",
        desc = "I need to cook this.",
        art = { item = "UNCOOKED_CURRY", cam = { yaw = 0.30, pitch = 0.63, dist = 273, fov = 60, ty = 44, tx = 1 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "uncooked_bog_n_hog_stew", name = "Uncooked Bog 'n' Hog stew", kind = "item", rarity = "rare",
        desc = "I need to cook this.",
        art = { item = "UNCOOKED_FENMOOR_STEW", cam = { yaw = -3.27, pitch = 0.59, dist = 330, fov = 60, ty = 67, tx = 3 } },
        tags = { regions = { "havenhythe" }, skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "uncooked_arc_gumbo", name = "Uncooked arc gumbo", kind = "item", rarity = "epic",
        desc = "A bowl of ingredients with the potential to be stew, if you cook it.",
        art = { item = "ELR1_UNCOOKED_STEW", cam = { yaw = 0.30, pitch = 0.63, dist = 226, fov = 60, ty = 32, tx = -2 } },
        tags = { regions = { "the_arc" }, skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "uncooked_shark_soup", name = "Uncooked shark soup", kind = "item", rarity = "epic",
        desc = "A bowl of ingredients with the potential to be soup, if you cook it.",
        art = { item = "ELR1_UNCOOKED_SOUP", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 31, tx = 7 } },
        tags = { regions = { "the_arc" }, skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "uncooked_cake", name = "Uncooked cake", kind = "item", rarity = "uncommon",
        desc = "Now all I need to do is cook it.",
        art = { item = "UNCOOKED_CAKE", cam = { yaw = 0.45, pitch = 0.64, dist = 273, ty = 9, tx = 2 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "f2p" } },
    },
    {
        id = "raw_batta", name = "Raw batta", kind = "item", rarity = "common",
        desc = "This gnome batta needs cooking.",
        art = { item = "RAW_BATTA", cam = { yaw = 0.99, pitch = 0.73, dist = 205, fov = 60, ty = 9, tx = -4 } },
        tags = { regions = { "kandarin" }, skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_admiral_pie", name = "Raw admiral pie", kind = "item", rarity = "rare",
        desc = "This would taste a lot better cooked.",
        art = { item = "UNCOOKED_ADMIRAL_PIE", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 31, tx = 7 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_fish_pie", name = "Raw fish pie", kind = "item", rarity = "uncommon",
        desc = "Raw fish is risky, better cook it.",
        art = { item = "UNCOOKED_FISH_PIE", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 31, tx = 7 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_garden_pie", name = "Raw garden pie", kind = "item", rarity = "common",
        desc = "Needs cooking before I eat it.",
        art = { item = "UNCOOKED_GARDEN_PIE", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 21, tx = -3 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_mud_pie", name = "Raw mud pie", kind = "item", rarity = "common",
        desc = "Needs to be baked before I can use it.",
        art = { item = "UNCOOKED_MUD_PIE", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 20, tx = 3 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_summer_pie", name = "Raw summer pie", kind = "item", rarity = "epic",
        desc = "Fresh fruit may be good for you, but I should really cook this.",
        art = { item = "UNCOOKED_SUMMER_PIE", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 25, tx = -4 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_wild_pie", name = "Raw wild pie", kind = "item", rarity = "rare",
        desc = "Good as it looks, I'd better cook it.",
        art = { item = "UNCOOKED_WILD_PIE", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 27, tx = -1 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "raw_wilder_pie", name = "Raw wilder pie", kind = "item", rarity = "epic",
        desc = "Good as it looks, I'd better cook it.",
        art = { item = "UNCOOKED_WILDER_PIE", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 27, tx = 5 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "uncooked_apple_pie", name = "Uncooked apple pie", kind = "item", rarity = "common",
        desc = "This would be much tastier cooked.",
        art = { item = "UNCOOKED_APPLE_PIE", cam = { yaw = 0.30, pitch = 0.76, dist = 248, fov = 60, ty = 20, tx = -8 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "f2p" } },
    },
    {
        id = "uncooked_berry_pie", name = "Uncooked berry pie", kind = "item", rarity = "common",
        desc = "This would be much more appetising cooked.",
        art = { item = "UNCOOKED_REDBERRY_PIE", cam = { yaw = 0.30, pitch = 0.79, dist = 248, fov = 60, ty = 21, tx = -3 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "f2p" } },
    },
    {
        id = "uncooked_blueberry_pie", name = "Uncooked blueberry pie", kind = "item", rarity = "common",
        desc = "A mixture of raw pie dough and some blueberries.",
        art = { item = "NECRO_HUB_SMITH_UNDERWORLD_EQUIPMENT_UPGRADE_UNCOOKED_BLUEBERRY_PIE", cam = { yaw = 0.30, pitch = 0.85, dist = 248, fov = 60, ty = 20, tx = -3 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
    {
        id = "uncooked_meat_pie", name = "Uncooked meat pie", kind = "item", rarity = "common",
        desc = "This would be much healthier cooked.",
        art = { item = "UNCOOKED_MEAT_PIE", cam = { yaw = 0.30, pitch = 0.75, dist = 248, fov = 60, ty = 18, tx = -4 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "f2p" } },
    },
    {
        id = "uncooked_pork_pie", name = "Uncooked pork pie", kind = "item", rarity = "rare",
        desc = "A potential porky treat.",
        art = { item = "QUEST_BACON_PORK_PIE_UNCOOKED", cam = { yaw = -0.20, pitch = 0.85, dist = 140, fov = 55, ty = 25, tx = 14 } },
        tags = { skills = { "cooking" }, category = { "food", "raw_food" }, membership = { "p2p" } },
    },
}

return Set
