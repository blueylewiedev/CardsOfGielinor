-- Parked: cards taken out of deck/items/weapons/mauls.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "argonite_maul", name = "Argonite maul", kind = "item", rarity = "uncommon",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_7", cam = { yaw = -5.20, pitch = 1.25, dist = 525, fov = 45, ty = -20, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "f2p" } },
    },
    {
        id = "bathus_maul", name = "Bathus maul", kind = "item", rarity = "common",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_2", cam = { yaw = -1.80, dist = 525, fov = 35, tx = 40 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "f2p" } },
    },
    {
        id = "gorgonite_maul", name = "Gorgonite maul", kind = "item", rarity = "rare",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_9", cam = { yaw = -7.00, dist = 525, fov = 35, ty = -20, tx = 30 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
    {
        id = "novite_maul", name = "Novite maul", kind = "item", rarity = "common",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_1", cam = { yaw = -6.91, dist = 525, fov = 35, ty = -18, tx = 27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_maul", name = "Kratonite maul", kind = "item", rarity = "common",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_4", cam = { yaw = -6.99, dist = 477, fov = 35, ty = -18, tx = 28 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "f2p" } },
    },
    {
        id = "marmaros_maul", name = "Marmaros maul", kind = "item", rarity = "common",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_3", cam = { yaw = -6.96, dist = 477, fov = 35, ty = -11, tx = 20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_maul", name = "Zephyrium maul", kind = "item", rarity = "uncommon",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_6", cam = { yaw = -6.90, dist = 525, fov = 35, ty = -5, tx = 25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "f2p" } },
    },
    {
        id = "katagon_maul", name = "Katagon maul", kind = "item", rarity = "rare",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_8", cam = { yaw = -6.92, dist = 525, fov = 35, ty = -13, tx = 25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
    {
        id = "fractite_maul", name = "Fractite maul", kind = "item", rarity = "uncommon",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_5", cam = { yaw = -6.80, dist = 525, fov = 40 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "f2p" } },
    },
    {
        id = "promethium_maul", name = "Promethium maul", kind = "item", rarity = "epic",
        desc = "A maul used to claim life from those who don't deserve it.",
        art = { item = "RAND_MAUL_10", cam = { yaw = -6.92, dist = 477, fov = 35, ty = -8, tx = 19 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "strength", "dungeoneering" }, category = { "weapon", "melee_gear", "maul" }, membership = { "p2p" } },
    },
}

return Set
