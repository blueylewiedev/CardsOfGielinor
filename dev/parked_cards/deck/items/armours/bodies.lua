-- Parked: cards taken out of deck/items/armours/bodies.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "bathus_chainbody", name = "Bathus chainbody", kind = "item", rarity = "common",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_2", cam = { dist = 330, ty = -21, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_chainbody", name = "Kratonite chainbody", kind = "item", rarity = "common",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_4", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "marmaros_chainbody", name = "Marmaros chainbody", kind = "item", rarity = "common",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_3", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "novite_chainbody", name = "Novite chainbody", kind = "item", rarity = "common",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_1", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "argonite_chainbody", name = "Argonite chainbody", kind = "item", rarity = "uncommon",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_7", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "fractite_chainbody", name = "Fractite chainbody", kind = "item", rarity = "uncommon",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_5", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_chainbody", name = "Zephyrium chainbody", kind = "item", rarity = "uncommon",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_6", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "f2p" } },
    },
    {
        id = "gorgonite_chainbody", name = "Gorgonite chainbody", kind = "item", rarity = "rare",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_9", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "katagon_chainbody", name = "Katagon chainbody", kind = "item", rarity = "rare",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_8", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "promethium_chainbody", name = "Promethium chainbody", kind = "item", rarity = "epic",
        desc = "A series of connected metal rings.",
        art = { item = "RAND_CHAINBODY_10", cam = { dist = 363, ty = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "primal_platebody_dungeoneering", name = "Primal platebody (Dungeoneering)", kind = "item", rarity = "epic",
        title = "Primal platebody (Dg)",
        desc = "Provides excellent protection.",
        art = { item = "RAND_PLATEBODY_11", cam = { dist = 363, ty = 8, tx = 2 } },
        tags = { regions = { "daemonheim" }, skills = { "defence", "dungeoneering" }, category = { "armour", "body", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "paraleather_body", name = "Paraleather body", kind = "item", rarity = "common",
        desc = "Made from scaly hides.",
        art = { item = "RAND_LEATHER_BODY_3", cam = { dist = 399, ty = -40, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "body", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "subleather_body", name = "Subleather body", kind = "item", rarity = "common",
        desc = "Made from scaly hides.",
        art = { item = "RAND_LEATHER_BODY_2", cam = { dist = 399, ty = -40, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "body", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "gallileather_body", name = "Gallileather body", kind = "item", rarity = "uncommon",
        desc = "Made from scaly hides.",
        art = { item = "RAND_LEATHER_BODY_7", cam = { dist = 399, ty = -40, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "body", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "megaleather_body", name = "Megaleather body", kind = "item", rarity = "rare",
        desc = "Made from scaly hides.",
        art = { item = "RAND_LEATHER_BODY_9", cam = { dist = 399, ty = -40, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "body", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "sagittarian_body", name = "Sagittarian body", kind = "item", rarity = "epic",
        desc = "Made from scaly hides.",
        art = { item = "RAND_LEATHER_BODY_11", cam = { dist = 399, ty = -40, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "ranged", "defence", "dungeoneering" }, category = { "armour", "body", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "roseblood_robe_top", name = "Roseblood robe top", kind = "item", rarity = "common",
        desc = "The upper half of a magical robe.",
        art = { item = "RAND_ROBE_TOP_4", cam = { dist = 363, ty = -28, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "body", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "wildercress_robe_top", name = "Wildercress robe top", kind = "item", rarity = "common",
        desc = "The upper half of a magical robe.",
        art = { item = "RAND_ROBE_TOP_2", cam = { dist = 363, ty = -28, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "body", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "duskweed_robe_top", name = "Duskweed robe top", kind = "item", rarity = "uncommon",
        desc = "The upper half of a magical robe.",
        art = { item = "RAND_ROBE_TOP_6", cam = { dist = 363, ty = -28, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "body", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "runic_robe_top", name = "Runic robe top", kind = "item", rarity = "rare",
        desc = "The upper half of a magical robe.",
        art = { item = "RAND_ROBE_TOP_9", cam = { dist = 363, ty = -28, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "body", "magic_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathleaf_robe_top", name = "Deathleaf robe top", kind = "item", rarity = "common",
        desc = "The upper half of a magical robe, infused with the power of death.",
        art = { item = "RAND_NECRO_ROBE_TOP_3", cam = { yaw = -0.01, dist = 399, ty = 11, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "body", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "shadowblood_robe_top", name = "Shadowblood robe top", kind = "item", rarity = "common",
        desc = "The upper half of a magical robe, infused with the power of death.",
        art = { item = "RAND_NECRO_ROBE_TOP_4", cam = { yaw = -0.01, dist = 399, ty = 11, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "body", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathweed_robe_top", name = "Deathweed robe top", kind = "item", rarity = "uncommon",
        desc = "The upper half of a magical robe, infused with the power of death.",
        art = { item = "RAND_NECRO_ROBE_TOP_6", cam = { yaw = -0.01, dist = 399, ty = 11, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "body", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "soulrune_robe_top", name = "Soulrune robe top", kind = "item", rarity = "rare",
        desc = "The upper half of a magical robe, infused with the power of death.",
        art = { item = "RAND_NECRO_ROBE_TOP_9", cam = { yaw = -0.01, dist = 399, ty = 11, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "body", "necromancy_gear" }, membership = { "p2p" } },
    },
}

return Set
