-- Parked: cards taken out of deck/items/weapons/swords.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "argonite_rapier", name = "Argonite rapier", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_7", cam = { yaw = -2.20, dist = 525, fov = 40, ty = -20, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "bathus_rapier", name = "Bathus rapier", kind = "item", rarity = "common",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_2", cam = { yaw = -2.00, pitch = 1.55, dist = 301, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "fractite_rapier", name = "Fractite rapier", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_5", cam = { yaw = -7.00, dist = 525, fov = 35, ty = 20, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "gorgonite_rapier", name = "Gorgonite rapier", kind = "item", rarity = "rare",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_9", cam = { yaw = -7.00, dist = 525, fov = 35, tx = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "marmaros_rapier", name = "Marmaros rapier", kind = "item", rarity = "common",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_3", cam = { yaw = -3.84, dist = 359, fov = 45, ty = -6, tx = 8 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "novite_rapier", name = "Novite rapier", kind = "item", rarity = "common",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_1", cam = { yaw = -3.88, dist = 359, fov = 45, ty = -13, tx = 20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_bathus_longsword", name = "Off-hand bathus longsword", kind = "item", rarity = "common",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_2", cam = { yaw = -8.47, dist = 578, fov = 35, ty = -10, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_bathus_rapier", name = "Off-hand bathus rapier", kind = "item", rarity = "common",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_2", cam = { yaw = -8.29, dist = 434, fov = 35, ty = -5, tx = -9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_marmaros_longsword", name = "Off-hand marmaros longsword", kind = "item", rarity = "common",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_3", cam = { yaw = -8.48, dist = 578, fov = 35, ty = -12, tx = -7 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_marmaros_rapier", name = "Off-hand marmaros rapier", kind = "item", rarity = "common",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_3", cam = { yaw = -8.29, dist = 434, fov = 35, ty = -9, tx = -11 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_novite_longsword", name = "Off-hand novite longsword", kind = "item", rarity = "common",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_1", cam = { yaw = -8.49, dist = 578, fov = 35, ty = -10, tx = -7 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_novite_rapier", name = "Off-hand novite rapier", kind = "item", rarity = "common",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_1", cam = { yaw = -1.96, dist = 359, fov = 45 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_rapier", name = "Kratonite rapier", kind = "item", rarity = "common",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_4", cam = { yaw = -3.88, dist = 359, fov = 45, ty = -2, tx = 20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_fractite_longsword", name = "Off-hand fractite longsword", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_5", cam = { yaw = -8.50, dist = 578, fov = 35, ty = -14, tx = -17 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_fractite_rapier", name = "Off-hand fractite rapier", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_5", cam = { yaw = -8.25, dist = 477, fov = 35, ty = -22, tx = -30 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_kratonite_longsword", name = "Off-hand kratonite longsword", kind = "item", rarity = "common",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_4", cam = { yaw = -8.49, dist = 525, fov = 35, ty = -11, tx = -3 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_kratonite_rapier", name = "Off-hand kratonite rapier", kind = "item", rarity = "common",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_4", cam = { yaw = -8.24, dist = 477, fov = 35, ty = -5, tx = -11 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_argonite_longsword", name = "Off-hand argonite longsword", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_7", cam = { yaw = -8.47, dist = 578, fov = 35 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_argonite_rapier", name = "Off-hand argonite rapier", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_7", cam = { yaw = -8.22, dist = 477, fov = 35, ty = -20, tx = -27 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_gravite_longsword", name = "Off-hand gravite longsword", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp longsword.",
        art = { item = "RAND_LONGSWORD_45_REWARD_O", cam = { yaw = -8.49, dist = 578, fov = 35, ty = -11, tx = 3 } },
        tags = { regions = { "daemonheim" }, skills = { "attack" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_gravite_rapier", name = "Off-hand gravite rapier", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_RAPIER_45_REWARD_O", cam = { yaw = -8.25, dist = 477, fov = 35, ty = -22, tx = -30 } },
        tags = { regions = { "daemonheim" }, skills = { "attack" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_zephyrium_longsword", name = "Off-hand zephyrium longsword", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_6", cam = { yaw = -8.45, dist = 578, fov = 35 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "offhand_zephyrium_rapier", name = "Off-hand zephyrium rapier", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_6", cam = { yaw = -8.23, dist = 477, fov = 35, ty = -24, tx = -35 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_rapier", name = "Zephyrium rapier", kind = "item", rarity = "uncommon",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_6", cam = { yaw = -3.84, dist = 394, fov = 45, ty = -32, tx = 39 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "f2p" } },
    },
    {
        id = "katagon_rapier", name = "Katagon rapier", kind = "item", rarity = "rare",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_8", cam = { yaw = -3.83, dist = 394, fov = 45, ty = -26, tx = 39 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_chaotic_longsword", name = "Off-hand chaotic longsword", kind = "item", rarity = "rare",
        desc = "A razor-sharp longsword.",
        art = { item = "RAND_LONGSWORD_80_REWARD_O", cam = { yaw = -8.48, dist = 525, fov = 35, ty = -13, tx = -5 } },
        tags = { regions = { "daemonheim" }, skills = { "attack" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_chaotic_rapier", name = "Off-hand chaotic rapier", kind = "item", rarity = "rare",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_RAPIER_80_REWARD_O", cam = { yaw = -8.42, dist = 930, fov = 35, tx = 217 } },
        tags = { regions = { "daemonheim" }, skills = { "attack" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_gorgonite_longsword", name = "Off-hand gorgonite longsword", kind = "item", rarity = "rare",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_9", cam = { yaw = -8.47, dist = 578, fov = 35, ty = -19, tx = -11 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_gorgonite_rapier", name = "Off-hand gorgonite rapier", kind = "item", rarity = "rare",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_9", cam = { yaw = -8.23, dist = 477, fov = 35, ty = -31, tx = -38 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_katagon_longsword", name = "Off-hand katagon longsword", kind = "item", rarity = "rare",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_8", cam = { yaw = -8.49, dist = 578, fov = 35, ty = -11, tx = -3 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_katagon_rapier", name = "Off-hand katagon rapier", kind = "item", rarity = "rare",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_8", cam = { yaw = -8.25, dist = 477, fov = 35, ty = -27, tx = -39 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_primal_longsword", name = "Off-hand primal longsword", kind = "item", rarity = "epic",
        desc = "A razor-sharp off-hand longsword.",
        art = { item = "RAND_LONGSWORD_O_11", cam = { yaw = -2.22, dist = 578, fov = 35, ty = -5, tx = -8 } },
        tags = { regions = { "daemonheim" }, skills = { "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_primal_rapier", name = "Off-hand primal rapier", kind = "item", rarity = "epic",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_11", cam = { yaw = -8.25, dist = 477, fov = 35, ty = -37, tx = -42 } },
        tags = { regions = { "daemonheim" }, skills = { "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_promethium_rapier", name = "Off-hand promethium rapier", kind = "item", rarity = "epic",
        desc = "A razor-sharp off-hand rapier.",
        art = { item = "RAND_SWORD_O_10", cam = { yaw = -8.24, dist = 477, fov = 35, ty = -32, tx = -34 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "offhand_ruinous_rapier", name = "Off-hand ruinous rapier", kind = "item", rarity = "epic",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_RAPIER_90_REWARD_O", cam = { yaw = -5.31, dist = 578, fov = 35, ty = -30, tx = -11 } },
        tags = { regions = { "daemonheim" }, skills = { "dungeoneering", "attack" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
    {
        id = "promethium_rapier", name = "Promethium rapier", kind = "item", rarity = "epic",
        desc = "A razor-sharp rapier.",
        art = { item = "RAND_SWORD_10", cam = { yaw = -3.85, dist = 394, fov = 45, ty = -29, tx = 44 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "sword" }, membership = { "p2p" } },
    },
}

return Set
