-- Parked: cards taken out of deck/items/armours/legs.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "roseblood_robe_bottom", name = "Roseblood robe bottom", kind = "item", rarity = "common",
        desc = "The lower half of a magical robe.",
        art = { item = "RAND_ROBE_BOTTOM_4", cam = { dist = 531, ty = -27, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "legs", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "wildercress_robe_bottom", name = "Wildercress robe bottom", kind = "item", rarity = "common",
        desc = "The lower half of a magical robe.",
        art = { item = "RAND_ROBE_BOTTOM_2", cam = { dist = 531, ty = -27, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "legs", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "duskweed_robe_bottom", name = "Duskweed robe bottom", kind = "item", rarity = "uncommon",
        desc = "The lower half of a magical robe.",
        art = { item = "RAND_ROBE_BOTTOM_6", cam = { dist = 531, ty = -27, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "legs", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "runic_robe_bottom", name = "Runic robe bottom", kind = "item", rarity = "rare",
        desc = "The lower half of a magical robe.",
        art = { item = "RAND_ROBE_BOTTOM_9", cam = { dist = 531, ty = -27, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "legs", "magic_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathleaf_robe_bottom", name = "Deathleaf robe bottom", kind = "item", rarity = "common",
        desc = "The lower half of a magical robe, infused with the power of death.",
        art = { item = "RAND_NECRO_ROBE_BOTTOM_3", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "legs", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "shadowblood_robe_bottom", name = "Shadowblood robe bottom", kind = "item", rarity = "common",
        desc = "The lower half of a magical robe, infused with the power of death.",
        art = { item = "RAND_NECRO_ROBE_BOTTOM_4", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "legs", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathweed_robe_bottom", name = "Deathweed robe bottom", kind = "item", rarity = "uncommon",
        desc = "The lower half of a magical robe, infused with the power of death.",
        art = { item = "RAND_NECRO_ROBE_BOTTOM_6", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "legs", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "soulrune_robe_bottom", name = "Soulrune robe bottom", kind = "item", rarity = "rare",
        desc = "The lower half of a magical robe, infused with the power of death.",
        art = { item = "RAND_NECRO_ROBE_BOTTOM_9", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "legs", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "paraleather_chaps", name = "Paraleather chaps", kind = "item", rarity = "common",
        desc = "Made from scaly hides.",
        art = { item = "RAND_CHAPS_3", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "legs", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "subleather_chaps", name = "Subleather chaps", kind = "item", rarity = "common",
        desc = "Made from scaly hides.",
        art = { item = "RAND_CHAPS_2", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "legs", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "gallileather_chaps", name = "Gallileather chaps", kind = "item", rarity = "uncommon",
        desc = "Made from scaly hides.",
        art = { item = "RAND_CHAPS_7", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "legs", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "megaleather_chaps", name = "Megaleather chaps", kind = "item", rarity = "rare",
        desc = "Made from scaly hides.",
        art = { item = "RAND_CHAPS_9", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "legs", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "sagittarian_chaps", name = "Sagittarian chaps", kind = "item", rarity = "epic",
        desc = "Made from scaly hides.",
        art = { item = "RAND_CHAPS_11", cam = { yaw = -0.02, dist = 531, ty = -11, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "ranged", "defence", "dungeoneering" }, category = { "armour", "legs", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "bathus_plateskirt", name = "Bathus plateskirt", kind = "item", rarity = "common",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_2", cam = { yaw = -0.02, dist = 531, ty = -45, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_plateskirt", name = "Kratonite plateskirt", kind = "item", rarity = "common",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_4", cam = { yaw = -0.02, dist = 531, ty = -5, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "marmaros_plateskirt", name = "Marmaros plateskirt", kind = "item", rarity = "common",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_3", cam = { yaw = -0.02, dist = 531, ty = -45, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "novite_plateskirt", name = "Novite plateskirt", kind = "item", rarity = "common",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_1", cam = { yaw = -0.02, dist = 531, ty = -45, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "argonite_plateskirt", name = "Argonite plateskirt", kind = "item", rarity = "uncommon",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_7", cam = { yaw = -0.02, dist = 531, ty = -5, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "fractite_plateskirt", name = "Fractite plateskirt", kind = "item", rarity = "uncommon",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_5", cam = { yaw = -0.02, dist = 531, ty = -5, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_plateskirt", name = "Zephyrium plateskirt", kind = "item", rarity = "uncommon",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_6", cam = { yaw = -0.02, dist = 531, ty = -5, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "gorgonite_plateskirt", name = "Gorgonite plateskirt", kind = "item", rarity = "rare",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_9", cam = { yaw = -0.02, dist = 531, ty = -45, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "katagon_plateskirt", name = "Katagon plateskirt", kind = "item", rarity = "rare",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_8", cam = { yaw = -0.02, dist = 531, ty = -5, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "primal_platelegs_dungeoneering", name = "Primal platelegs (Dungeoneering)", kind = "item", rarity = "epic",
        title = "Primal platelegs (Dg)",
        desc = "These look pretty heavy.",
        art = { item = "RAND_PLATELEGS_11", cam = { yaw = -0.02, dist = 531, ty = -45, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "promethium_plateskirt", name = "Promethium plateskirt", kind = "item", rarity = "epic",
        desc = "Designer leg protection.",
        art = { item = "RAND_PLATESKIRT_10", cam = { yaw = -0.02, dist = 531, ty = -45, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "legs", "melee_gear" }, membership = { "p2p" } },
    },
}

return Set
