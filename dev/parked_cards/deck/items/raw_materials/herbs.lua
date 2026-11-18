-- Parked: cards taken out of deck/items/raw_materials/herbs.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "grimy_aloe", name = "Grimy aloe", kind = "item", rarity = "common",
        desc = "A fresh herb.",
        art = { item = "RAND_GRIMY_HERB_3", cam = { yaw = -0.20, pitch = 0.90, dist = 397, fov = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
    {
        id = "grimy_buckthorn", name = "Grimy buckthorn", kind = "item", rarity = "epic",
        desc = "A fresh herb.",
        art = { item = "RAND_GRIMY_HERB_9", cam = { yaw = 0.80, pitch = 1.05, dist = 397, fov = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
    {
        id = "grimy_featherfoil", name = "Grimy featherfoil", kind = "item", rarity = "uncommon",
        desc = "A fresh herb.",
        art = { item = "RAND_GRIMY_HERB_6", cam = { yaw = 0.20, pitch = 1.05, dist = 397, fov = 35, ty = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
    {
        id = "grimy_lycopus", name = "Grimy lycopus", kind = "item", rarity = "rare",
        desc = "A fresh herb.",
        art = { item = "RAND_GRIMY_HERB_8", cam = { yaw = 0.80, pitch = 1.05, dist = 397, fov = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
    {
        id = "grimy_magebane", name = "Grimy magebane", kind = "item", rarity = "uncommon",
        desc = "A fresh herb.",
        art = { item = "RAND_GRIMY_HERB_5", cam = { yaw = 0.80, pitch = 1.05, dist = 397, fov = 35, ty = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
    {
        id = "grimy_sagewort", name = "Grimy sagewort", kind = "item", rarity = "common",
        desc = "A fresh herb.",
        art = { item = "RAND_GRIMY_HERB_1", cam = { yaw = 0.20, pitch = 1.05, dist = 397, fov = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
    {
        id = "grimy_valerian", name = "Grimy valerian", kind = "item", rarity = "common",
        desc = "A fresh herb.",
        art = { item = "RAND_GRIMY_HERB_2", cam = { pitch = 1.05, dist = 397, fov = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
    {
        id = "grimy_winters_grip", name = "Grimy winter's grip", kind = "item", rarity = "rare",
        desc = "A fresh herb.",
        art = { item = "RAND_GRIMY_HERB_7", cam = { yaw = 0.80, pitch = 1.05, dist = 397, fov = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
    {
        id = "grimy_wormwood_leaf", name = "Grimy wormwood leaf", kind = "item", rarity = "uncommon",
        desc = "A fresh herb. Used in Herblore.",
        art = { item = "RAND_GRIMY_HERB_4", cam = { yaw = 0.80, pitch = 1.05, dist = 397, fov = 30, ty = 40, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "herblore", "dungeoneering" }, category = { "raw_material", "herb" }, membership = { "p2p" } },
    },
}

return Set