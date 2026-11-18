-- Parked: cards taken out of deck/items/raw_materials/fish.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "raw_dusk_eel", name = "Raw dusk eel", kind = "item", rarity = "common",
        desc = "I should try cooking this.",
        art = { item = "RAND_RAW_FISH_3", cam = { pitch = 1.55, dist = 397, fov = 60, ty = -11, tx = 25 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "raw_material", "fish" }, membership = { "f2p" } },
    },
    {
        id = "raw_giant_flatfish", name = "Raw giant flatfish", kind = "item", rarity = "common",
        desc = "I should try cooking this.",
        art = { item = "RAND_RAW_FISH_4", cam = { pitch = 1.55, dist = 397, fov = 60, ty = 1, tx = 13 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "raw_material", "fish" }, membership = { "f2p" } },
    },
    {
        id = "raw_bouldabass", name = "Raw bouldabass", kind = "item", rarity = "uncommon",
        desc = "I should try cooking this. Used in Cooking.",
        art = { item = "RAND_RAW_FISH_7", cam = { pitch = 1.55, dist = 361, fov = 60, ty = 2, tx = 19 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "raw_material", "fish" }, membership = { "p2p" } },
    },
    {
        id = "raw_shortfinned_eel", name = "Raw short-finned eel", kind = "item", rarity = "uncommon",
        desc = "I should try cooking this.",
        art = { item = "RAND_RAW_FISH_5", cam = { yaw = -0.75, pitch = 1.55, dist = 361, fov = 60, ty = 27, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "fish", "raw_material" }, membership = { "f2p" } },
    },
    {
        id = "raw_web_snipper", name = "Raw web snipper", kind = "item", rarity = "uncommon",
        desc = "I should try cooking this.",
        art = { item = "RAND_RAW_FISH_6", cam = { pitch = 1.55, dist = 361, fov = 60, ty = 5, tx = 16 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "fish", "raw_material" }, membership = { "f2p" } },
    },
    {
        id = "raw_blue_crab", name = "Raw blue crab", kind = "item", rarity = "rare",
        desc = "I should try cooking this.",
        art = { item = "RAND_RAW_FISH_9", cam = { pitch = 1.55, dist = 361, fov = 60, ty = 7, tx = 24 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "fish", "raw_material" }, membership = { "p2p" } },
    },
    {
        id = "raw_salve_eel", name = "Raw salve eel", kind = "item", rarity = "rare",
        desc = "I should try cooking this.",
        art = { item = "RAND_RAW_FISH_8", cam = { pitch = 1.55, dist = 361, fov = 60, ty = 34, tx = 17 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "fish", "raw_material" }, membership = { "p2p" } },
    },
    {
        id = "raw_cave_moray", name = "Raw cave moray", kind = "item", rarity = "epic",
        desc = "I should try cooking this. Used in Cooking.",
        art = { item = "RAND_RAW_FISH_10", cam = { pitch = 1.55, dist = 361, fov = 60, ty = -1, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "fish", "raw_material" }, membership = { "p2p" } },
    },
}

return Set