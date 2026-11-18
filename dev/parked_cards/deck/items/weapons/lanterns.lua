-- Parked: cards taken out of deck/items/weapons/lanterns.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "bathus_lantern", name = "Bathus lantern", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_2", cam = { yaw = -0.02, dist = 330, ty = -16, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_lantern", name = "Kratonite lantern", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_4", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "marmaros_lantern", name = "Marmaros lantern", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_3", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "novite_lantern", name = "Novite lantern", kind = "item", rarity = "common",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_1", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "f2p" } },
    },
    {
        id = "argonite_lantern", name = "Argonite lantern", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_7", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "fractite_lantern", name = "Fractite lantern", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_5", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "zephyrium_lantern", name = "Zephyrium lantern", kind = "item", rarity = "uncommon",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_6", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "gorgonite_lantern", name = "Gorgonite lantern", kind = "item", rarity = "rare",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_9", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "katagon_lantern", name = "Katagon lantern", kind = "item", rarity = "rare",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_8", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
    {
        id = "promethium_lantern", name = "Promethium lantern", kind = "item", rarity = "epic",
        desc = "A conduit to the Underworld.",
        art = { item = "RAND_NECRO_LANTERN_10", cam = { yaw = -0.03, dist = 330, ty = -21 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "necromancy", "dungeoneering" }, category = { "weapon", "necromancy_gear", "lantern" }, membership = { "p2p" } },
    },
}

return Set
