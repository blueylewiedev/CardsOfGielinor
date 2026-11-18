-- Parked: cards taken out of deck/items/weapons/siphons.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "kratonite_guard", name = "Kratonite guard", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_4", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "marmaros_guard", name = "Marmaros guard", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_3", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "novite_guard", name = "Novite guard", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_1", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "f2p" } },
    },
    {
        id = "argonite_guard", name = "Argonite guard", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_7", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "fractite_guard", name = "Fractite guard", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_5", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "zephyrium_guard", name = "Zephyrium guard", kind = "item", rarity = "uncommon",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_6", cam = { yaw = -0.61, dist = 186, ty = -8, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "gorgonite_guard", name = "Gorgonite guard", kind = "item", rarity = "rare",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_9", cam = { yaw = -0.61, dist = 205, ty = 9, tx = 7 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "katagon_guard", name = "Katagon guard", kind = "item", rarity = "rare",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_8", cam = { yaw = -0.61, dist = 205, ty = -11, tx = -16 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "promethium_guard", name = "Promethium guard", kind = "item", rarity = "epic",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_10", cam = { yaw = -0.61, dist = 205, ty = 9, tx = 7 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "p2p" } },
    },
    {
        id = "bathus_guard", name = "Bathus guard", kind = "item", rarity = "common",
        desc = "A necromancer armguard.",
        art = { item = "RAND_NECRO_ARMGUARD_2", cam = { yaw = -0.61, dist = 205, ty = -8, tx = -12 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "siphon" }, membership = { "f2p" } },
    },
}

return Set
