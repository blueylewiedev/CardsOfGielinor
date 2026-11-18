-- Parked: cards taken out of deck/items/armours/gloves.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "roseblood_gloves", name = "Roseblood gloves", kind = "item", rarity = "common",
        desc = "A pair of finely crafted gloves.",
        art = { item = "RAND_GLOVES_4", cam = { yaw = -2.62, pitch = 1.01, dist = 186, ty = 16, tx = 0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "gloves", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "wildercress_gloves", name = "Wildercress gloves", kind = "item", rarity = "common",
        desc = "A pair of finely crafted gloves.",
        art = { item = "RAND_GLOVES_2", cam = { yaw = -2.62, pitch = 1.01, dist = 186, ty = 16, tx = 0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "gloves", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "duskweed_gloves", name = "Duskweed gloves", kind = "item", rarity = "uncommon",
        desc = "A pair of finely crafted gloves.",
        art = { item = "RAND_GLOVES_6", cam = { yaw = -2.62, pitch = 1.01, dist = 186, ty = 16, tx = 0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "gloves", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "runic_gloves", name = "Runic gloves", kind = "item", rarity = "rare",
        desc = "A pair of finely crafted gloves.",
        art = { item = "RAND_GLOVES_9", cam = { yaw = -2.62, pitch = 1.01, dist = 186, ty = 16, tx = 0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "gloves", "magic_gear" }, membership = { "p2p" } },
    },
    {
        id = "primal_gauntlets_dungeoneering", name = "Primal gauntlets (Dungeoneering)", kind = "item", rarity = "epic",
        title = "Primal gauntlets (Dg)",
        desc = "A pair of heavy gauntlets.",
        art = { item = "RAND_GAUNTLETS_11", cam = { yaw = 2.63, dist = 127, ty = -2, tx = 4 } },
        tags = { regions = { "daemonheim" }, skills = { "defence", "dungeoneering" }, category = { "armour", "gloves", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathleaf_gloves", name = "Deathleaf gloves", kind = "item", rarity = "common",
        desc = "Gloves infused with the power of death.",
        art = { item = "RAND_NECRO_GLOVES_3", cam = { yaw = -0.14, pitch = 1.04, dist = 127, ty = 1, tx = 6 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "gloves", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "shadowblood_gloves", name = "Shadowblood gloves", kind = "item", rarity = "common",
        desc = "Gloves infused with the power of death.",
        art = { item = "RAND_NECRO_GLOVES_4", cam = { yaw = -0.14, pitch = 1.04, dist = 127, ty = 1, tx = 6 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "gloves", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathweed_gloves", name = "Deathweed gloves", kind = "item", rarity = "uncommon",
        desc = "Gloves infused with the power of death.",
        art = { item = "RAND_NECRO_GLOVES_6", cam = { yaw = -0.14, pitch = 1.04, dist = 127, ty = 1, tx = 6 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "gloves", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "soulrune_gloves", name = "Soulrune gloves", kind = "item", rarity = "rare",
        desc = "Gloves infused with the power of death.",
        art = { item = "RAND_NECRO_GLOVES_9", cam = { yaw = -0.14, pitch = 1.04, dist = 127, ty = 1, tx = 6 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "gloves", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "paraleather_vambraces", name = "Paraleather vambraces", kind = "item", rarity = "common",
        desc = "Wrist protection made from scaly hides.",
        art = { item = "RAND_VAMBRACES_3", cam = { yaw = -0.14, pitch = 1.43, dist = 225, ty = -5, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "gloves", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "subleather_vambraces", name = "Subleather vambraces", kind = "item", rarity = "common",
        desc = "Wrist protection made from scaly hides.",
        art = { item = "RAND_VAMBRACES_2", cam = { yaw = -0.14, pitch = 1.43, dist = 225, ty = -5, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "gloves", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "gallileather_vambraces", name = "Gallileather vambraces", kind = "item", rarity = "uncommon",
        desc = "Wrist protection made from scaly hides.",
        art = { item = "RAND_VAMBRACES_7", cam = { yaw = -0.14, pitch = 1.43, dist = 225, ty = -5, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "gloves", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "megaleather_vambraces", name = "Megaleather vambraces", kind = "item", rarity = "rare",
        desc = "Wrist protection made from scaly hides.",
        art = { item = "RAND_VAMBRACES_9", cam = { yaw = -0.14, pitch = 1.43, dist = 225, ty = -5, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "gloves", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "sagittarian_vambraces", name = "Sagittarian vambraces", kind = "item", rarity = "epic",
        desc = "Wrist protection made from scaly hides.",
        art = { item = "RAND_VAMBRACES_11", cam = { yaw = -0.14, pitch = 1.43, dist = 225, ty = -5, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "ranged", "defence", "dungeoneering" }, category = { "armour", "gloves", "ranged_gear" }, membership = { "p2p" } },
    },
}

return Set
