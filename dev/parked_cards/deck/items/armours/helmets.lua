-- Parked: cards taken out of deck/items/armours/helmets.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "primal_full_helm_dungeoneering", name = "Primal full helm (Dungeoneering)", kind = "item", rarity = "epic",
        title = "Primal full helm (Dg)",
        desc = "A full face helmet.",
        art = { item = "RAND_FULL_HELM_11", cam = { yaw = -6.76, pitch = 0.48, dist = 248, ty = 57, tx = -6 } },
        tags = { regions = { "daemonheim" }, skills = { "defence", "dungeoneering" }, category = { "armour", "helmet", "melee_gear" }, membership = { "p2p" } },
    },
    {
        id = "paraleather_coif", name = "Paraleather coif", kind = "item", rarity = "common",
        desc = "Crafted out of thick lizard hides.",
        art = { item = "RAND_COIF_3", cam = { yaw = -6.92, pitch = 0.32, dist = 273, ty = 65, tx = 5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "helmet", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "subleather_coif", name = "Subleather coif", kind = "item", rarity = "common",
        desc = "Crafted out of thick lizard hides.",
        art = { item = "RAND_COIF_2", cam = { yaw = -6.92, pitch = 0.32, dist = 273, ty = 65, tx = 5 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "helmet", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "gallileather_coif", name = "Gallileather coif", kind = "item", rarity = "uncommon",
        desc = "Crafted out of thick lizard hides.",
        art = { item = "RAND_COIF_7", cam = { yaw = -6.67, pitch = 0.36, dist = 248, ty = 67, tx = -1 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "helmet", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "megaleather_coif", name = "Megaleather coif", kind = "item", rarity = "rare",
        desc = "Crafted out of thick lizard hides.",
        art = { item = "RAND_COIF_9", cam = { yaw = -6.87, pitch = 0.36, dist = 273, ty = 76, tx = 1 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "ranged", "defence", "dungeoneering" }, category = { "armour", "helmet", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "sagittarian_coif", name = "Sagittarian coif", kind = "item", rarity = "epic",
        desc = "Crafted out of thick lizard hides.",
        art = { item = "RAND_COIF_11", cam = { yaw = -6.79, pitch = 0.23, dist = 273, ty = 80, tx = 1 } },
        tags = { regions = { "daemonheim" }, skills = { "ranged", "defence", "dungeoneering" }, category = { "armour", "helmet", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "roseblood_hood", name = "Roseblood hood", kind = "item", rarity = "common",
        desc = "A hood worn by mages.",
        art = { item = "RAND_HOOD_4", cam = { yaw = -7.05, pitch = 0.23, ty = 66, tx = 25 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "helmet", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "wildercress_hood", name = "Wildercress hood", kind = "item", rarity = "common",
        desc = "A hood worn by mages.",
        art = { item = "RAND_HOOD_2", cam = { yaw = -7.05, pitch = 0.23, ty = 66, tx = 25 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "helmet", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "duskweed_hood", name = "Duskweed hood", kind = "item", rarity = "uncommon",
        desc = "A hood worn by mages.",
        art = { item = "RAND_HOOD_6", cam = { yaw = -7.05, pitch = 0.23, ty = 66, tx = 25 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "helmet", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "runic_hood", name = "Runic hood", kind = "item", rarity = "rare",
        desc = "A hood worn by mages.",
        art = { item = "RAND_HOOD_9", cam = { yaw = -7.05, pitch = 0.23, ty = 66, tx = 25 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "magic", "defence", "dungeoneering" }, category = { "armour", "helmet", "magic_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathleaf_hood", name = "Deathleaf hood", kind = "item", rarity = "common",
        desc = "A hood infused with the power of death.",
        art = { item = "RAND_NECRO_HOOD_3", cam = { yaw = -6.30, dist = 186, ty = -8, tx = -1 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "helmet", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "shadowblood_hood", name = "Shadowblood hood", kind = "item", rarity = "common",
        desc = "A hood infused with the power of death.",
        art = { item = "RAND_NECRO_HOOD_4", cam = { yaw = -6.30, dist = 186, ty = -8, tx = -1 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "helmet", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "deathweed_hood", name = "Deathweed hood", kind = "item", rarity = "uncommon",
        desc = "A hood infused with the power of death.",
        art = { item = "RAND_NECRO_HOOD_6", cam = { yaw = -6.30, dist = 186, ty = -8, tx = -1 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "helmet", "necromancy_gear" }, membership = { "p2p" } },
    },
    {
        id = "soulrune_hood", name = "Soulrune hood", kind = "item", rarity = "rare",
        desc = "A hood infused with the power of death.",
        art = { item = "RAND_NECRO_HOOD_9", cam = { yaw = -6.30, dist = 186, ty = -8, tx = -1 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "necromancy", "defence", "dungeoneering" }, category = { "armour", "helmet", "necromancy_gear" }, membership = { "p2p" } },
    },
}

return Set
