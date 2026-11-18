-- Parked: cards taken out of deck/items/weapons/spears.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "argonite_spear", name = "Argonite spear", kind = "item", rarity = "uncommon",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_7", cam = { yaw = -1.80, pitch = 1.25, dist = 525, fov = 45, ty = -40 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "f2p" } },
    },
    {
        id = "bathus_spear", name = "Bathus spear", kind = "item", rarity = "common",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_2", cam = { yaw = -1.80, dist = 525, fov = 45, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "f2p" } },
    },
    {
        id = "fractite_spear", name = "Fractite spear", kind = "item", rarity = "uncommon",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_5", cam = { yaw = -6.80, dist = 525, fov = 40, tx = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "f2p" } },
    },
    {
        id = "gorgonite_spear", name = "Gorgonite spear", kind = "item", rarity = "rare",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_9", cam = { yaw = -6.80, dist = 694, fov = 35, ty = -20, tx = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "p2p" } },
    },
    {
        id = "novite_spear", name = "Novite spear", kind = "item", rarity = "common",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_1", cam = { yaw = -0.48, dist = 453, ty = -16, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_spear", name = "Kratonite spear", kind = "item", rarity = "common",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_4", cam = { yaw = -0.50, dist = 453, ty = -19, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "f2p" } },
    },
    {
        id = "marmaros_spear", name = "Marmaros spear", kind = "item", rarity = "common",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_3", cam = { yaw = -0.50, dist = 453, ty = -19, tx = -18 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_spear", name = "Zephyrium spear", kind = "item", rarity = "uncommon",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_6", cam = { yaw = -3.66, dist = 412, ty = 3, tx = 30 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "f2p" } },
    },
    {
        id = "katagon_spear", name = "Katagon spear", kind = "item", rarity = "rare",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_8", cam = { yaw = -3.67, dist = 412, ty = 12, tx = 36 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "p2p" } },
    },
    {
        id = "promethium_spear", name = "Promethium spear", kind = "item", rarity = "epic",
        desc = "A stick made for poking - violent poking.",
        art = { item = "RAND_SPEAR_10", cam = { yaw = -0.50, dist = 412, ty = -16, tx = -19 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "spear" }, membership = { "p2p" } },
    },
}

return Set
