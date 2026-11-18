-- Parked: cards taken out of deck/items/weapons/daggers.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "offhand_bathus_dagger", name = "Off-hand bathus dagger", kind = "item", rarity = "common",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_2", cam = { yaw = 0.86, dist = 394, fov = 30, ty = -11, tx = -26 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "f2p" } },
    },
    {
        id = "offhand_marmaros_dagger", name = "Off-hand marmaros dagger", kind = "item", rarity = "common",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_3", cam = { yaw = -5.43, pitch = 1.20, dist = 326, fov = 40, ty = -10, tx = -31 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "f2p" } },
    },
    {
        id = "offhand_novite_dagger", name = "Off-hand novite dagger", kind = "item", rarity = "common",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_1", cam = { yaw = -5.36, dist = 394, fov = 30, ty = -4, tx = -14 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "f2p" } },
    },
    {
        id = "offhand_fractite_dagger", name = "Off-hand fractite dagger", kind = "item", rarity = "uncommon",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_5", cam = { yaw = -5.32, dist = 394, fov = 30, ty = -19, tx = -24 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "f2p" } },
    },
    {
        id = "offhand_kratonite_dagger", name = "Off-hand kratonite dagger", kind = "item", rarity = "common",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_4", cam = { yaw = -5.40, dist = 359, fov = 30, ty = -12, tx = -23 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "f2p" } },
    },
    {
        id = "offhand_argonite_dagger", name = "Off-hand argonite dagger", kind = "item", rarity = "uncommon",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_7", cam = { yaw = -5.40, dist = 359, fov = 30, ty = -12, tx = -23 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "f2p" } },
    },
    {
        id = "offhand_zephyrium_dagger", name = "Off-hand zephyrium dagger", kind = "item", rarity = "uncommon",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_6", cam = { yaw = -5.40, dist = 359, fov = 30, ty = -12, tx = -23 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "f2p" } },
    },
    {
        id = "offhand_gorgonite_dagger", name = "Off-hand gorgonite dagger", kind = "item", rarity = "rare",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_9", cam = { yaw = -5.29, dist = 359, fov = 30, ty = -10, tx = -34 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "p2p" } },
    },
    {
        id = "offhand_katagon_dagger", name = "Off-hand katagon dagger", kind = "item", rarity = "rare",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_8", cam = { yaw = -5.40, dist = 359, fov = 30, ty = -12, tx = -23 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "p2p" } },
    },
    {
        id = "offhand_primal_dagger", name = "Off-hand primal dagger", kind = "item", rarity = "epic",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_11", cam = { yaw = -5.40, dist = 434, fov = 30, ty = -17, tx = -46 } },
        tags = { regions = { "daemonheim" }, skills = { "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "p2p" } },
    },
    {
        id = "offhand_promethium_dagger", name = "Off-hand promethium dagger", kind = "item", rarity = "epic",
        desc = "Short but pointy.",
        art = { item = "RAND_DAGGER_O_10", cam = { yaw = -5.40, dist = 394, fov = 30, ty = -12, tx = -24 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "dagger" }, membership = { "p2p" } },
    },
}

return Set
