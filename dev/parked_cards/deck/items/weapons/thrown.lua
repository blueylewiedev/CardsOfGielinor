-- Parked: cards taken out of deck/items/weapons/thrown.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "bathus_knife", name = "Bathus knife", kind = "item", rarity = "common",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_2", cam = { yaw = 0.74, dist = 248, ty = -26, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "f2p" } },
    },
    {
        id = "marmaros_knife", name = "Marmaros knife", kind = "item", rarity = "common",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_3", cam = { yaw = 0.74, dist = 248, ty = -26, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "f2p" } },
    },
    {
        id = "novite_knife", name = "Novite knife", kind = "item", rarity = "common",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_1", cam = { yaw = 0.74, dist = 248, ty = -26, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "f2p" } },
    },
    {
        id = "fractite_knife", name = "Fractite knife", kind = "item", rarity = "uncommon",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_5", cam = { yaw = 0.77, dist = 226, ty = -22, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_knife", name = "Kratonite knife", kind = "item", rarity = "common",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_4", cam = { yaw = 0.74, dist = 248, ty = -26, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "f2p" } },
    },
    {
        id = "argonite_knife", name = "Argonite knife", kind = "item", rarity = "uncommon",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_7", cam = { yaw = 0.74, dist = 248, ty = -26, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_knife", name = "Zephyrium knife", kind = "item", rarity = "uncommon",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_6", cam = { yaw = 0.74, dist = 248, ty = -26, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "f2p" } },
    },
    {
        id = "gorgonite_knife", name = "Gorgonite knife", kind = "item", rarity = "rare",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_9", cam = { yaw = 0.74, dist = 248, ty = -23, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "p2p" } },
    },
    {
        id = "katagon_knife", name = "Katagon knife", kind = "item", rarity = "rare",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_8", cam = { yaw = 0.74, dist = 248, ty = -26, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "p2p" } },
    },
    {
        id = "promethium_knife", name = "Promethium knife", kind = "item", rarity = "epic",
        desc = "A small knife balanced for throwing.",
        art = { item = "RAND_THROWN_KNIFE_10", cam = { yaw = 0.74, dist = 248, ty = -26, tx = -25 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "ranged", "dungeoneering" }, category = { "weapon", "ranged_gear", "thrown" }, membership = { "p2p" } },
    },
}

return Set
