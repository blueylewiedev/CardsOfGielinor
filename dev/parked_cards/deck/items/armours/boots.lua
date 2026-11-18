-- Parked: cards taken out of deck/items/armours/boots.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "roseblood_shoes", name = "Roseblood shoes", kind = "item", rarity = "common",
        desc = "Magically charged shoes.",
        art = { item = "RAND_CLOTH_BOOTS_4", cam = { yaw = -0.82, pitch = 0.45, dist = 225, ty = 10, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "boots", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "wildercress_shoes", name = "Wildercress shoes", kind = "item", rarity = "common",
        desc = "Magically charged shoes.",
        art = { item = "RAND_CLOTH_BOOTS_2", cam = { yaw = -0.82, pitch = 0.45, dist = 225, ty = 10, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "boots", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "duskweed_shoes", name = "Duskweed shoes", kind = "item", rarity = "uncommon",
        desc = "Magically charged shoes.",
        art = { item = "RAND_CLOTH_BOOTS_6", cam = { yaw = -0.82, pitch = 0.45, dist = 225, ty = 10, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "boots", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "runic_shoes", name = "Runic shoes", kind = "item", rarity = "rare",
        desc = "Magically charged shoes.",
        art = { item = "RAND_CLOTH_BOOTS_9", cam = { yaw = -0.82, pitch = 0.45, dist = 225, ty = 10, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "boots", "magic_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathleaf_shoes", name = "Deathleaf shoes", kind = "item", rarity = "common",
        desc = "Shoes infused with the power of death.",
        art = { item = "RAND_NECRO_BOOTS_3", cam = { yaw = -0.35, pitch = 0.50, dist = 186, ty = 9, tx = 12 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "boots", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "shadowblood_shoes", name = "Shadowblood shoes", kind = "item", rarity = "common",
        desc = "Shoes infused with the power of death.",
        art = { item = "RAND_NECRO_BOOTS_4", cam = { yaw = -0.35, pitch = 0.50, dist = 186, ty = 9, tx = 12 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "boots", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathweed_shoes", name = "Deathweed shoes", kind = "item", rarity = "uncommon",
        desc = "Shoes infused with the power of death.",
        art = { item = "RAND_NECRO_BOOTS_6", cam = { yaw = -0.35, pitch = 0.50, dist = 186, ty = 9, tx = 12 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "boots", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "soulrune_shoes", name = "Soulrune shoes", kind = "item", rarity = "rare",
        desc = "Shoes infused with the power of death.",
        art = { item = "RAND_NECRO_BOOTS_9", cam = { yaw = -0.35, pitch = 0.50, dist = 186, ty = 9, tx = 12 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "boots", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "paraleather_boots", name = "Paraleather boots", kind = "item", rarity = "common",
        desc = "Boots crafted out of thick lizard hides.",
        art = { item = "RAND_LEATHER_BOOTS_3", cam = { yaw = -0.63, pitch = 0.50, dist = 248, ty = 8, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "boots", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "subleather_boots", name = "Subleather boots", kind = "item", rarity = "common",
        desc = "Boots crafted out of thick lizard hides.",
        art = { item = "RAND_LEATHER_BOOTS_2", cam = { yaw = -0.63, pitch = 0.50, dist = 248, ty = 8, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "boots", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "gallileather_boots", name = "Gallileather boots", kind = "item", rarity = "uncommon",
        desc = "Boots crafted out of thick lizard hides.",
        art = { item = "RAND_LEATHER_BOOTS_7", cam = { yaw = -0.63, pitch = 0.50, dist = 248, ty = 8, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "boots", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "megaleather_boots", name = "Megaleather boots", kind = "item", rarity = "rare",
        desc = "Boots crafted out of thick lizard hides.",
        art = { item = "RAND_LEATHER_BOOTS_9", cam = { yaw = -0.63, pitch = 0.50, dist = 248, ty = 8, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "boots", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "sagittarian_boots", name = "Sagittarian boots", kind = "item", rarity = "epic",
        desc = "Boots crafted out of thick lizard hides.",
        art = { item = "RAND_LEATHER_BOOTS_11", cam = { yaw = -0.63, pitch = 0.50, dist = 248, ty = 8, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "ranged", "defence", "dungeoneering" }, category = { "armour", "boots", "ranged_gear" }, membership = { "p2p" } },
    },
}

return Set
