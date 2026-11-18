-- Parked: cards taken out of deck/items/weapons/axes.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "argonite_battleaxe", name = "Argonite battleaxe", kind = "item", rarity = "uncommon",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_7", cam = { yaw = -2.20, dist = 525, fov = 30, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "bathus_battleaxe", name = "Bathus battleaxe", kind = "item", rarity = "common",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_2", cam = { yaw = -1.00, dist = 525, fov = 35, tx = 20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "fractite_battleaxe", name = "Fractite battleaxe", kind = "item", rarity = "uncommon",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_5", cam = { yaw = -7.40, dist = 525, fov = 35, tx = 20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "gorgonite_battleaxe", name = "Gorgonite battleaxe", kind = "item", rarity = "rare",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_9", cam = { yaw = -7.40, dist = 525, fov = 35, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "p2p" } },
    },
    {
        id = "novite_battleaxe", name = "Novite battleaxe", kind = "item", rarity = "common",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_1", cam = { yaw = -1.00, dist = 525, fov = 35, tx = 20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "offhand_bathus_battleaxe", name = "Off-hand bathus battleaxe", kind = "item", rarity = "common",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_2", cam = { yaw = 0.70, dist = 477, fov = 35, ty = -1, tx = 3 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "offhand_novite_battleaxe", name = "Off-hand novite battleaxe", kind = "item", rarity = "common",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_1", cam = { yaw = 0.77, dist = 477, fov = 35, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_battleaxe", name = "Kratonite battleaxe", kind = "item", rarity = "common",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_4", cam = { yaw = -1.00, dist = 525, fov = 35, tx = 20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "marmaros_battleaxe", name = "Marmaros battleaxe", kind = "item", rarity = "common",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_3", cam = { yaw = -1.00, dist = 525, fov = 35, tx = 20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "offhand_fractite_battleaxe", name = "Off-hand fractite battleaxe", kind = "item", rarity = "uncommon",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_5", cam = { yaw = 0.79, dist = 477, fov = 35, ty = -3, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "offhand_kratonite_battleaxe", name = "Off-hand kratonite battleaxe", kind = "item", rarity = "common",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_4", cam = { yaw = 0.74, dist = 477, fov = 35, ty = 3, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "offhand_marmaros_battleaxe", name = "Off-hand marmaros battleaxe", kind = "item", rarity = "common",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_3", cam = { yaw = 0.78, dist = 394, fov = 45, ty = 7, tx = -3 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "offhand_argonite_battleaxe", name = "Off-hand argonite battleaxe", kind = "item", rarity = "uncommon",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_7", cam = { yaw = 0.88, dist = 477, fov = 35, ty = 1, tx = -9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "offhand_zephyrium_battleaxe", name = "Off-hand zephyrium battleaxe", kind = "item", rarity = "uncommon",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_6", cam = { yaw = 0.88, dist = 477, fov = 35, ty = 1, tx = -13 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_battleaxe", name = "Zephyrium battleaxe", kind = "item", rarity = "uncommon",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_6", cam = { yaw = -1.01, dist = 477, fov = 35, ty = -12, tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "f2p" } },
    },
    {
        id = "katagon_battleaxe", name = "Katagon battleaxe", kind = "item", rarity = "rare",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_8", cam = { yaw = -1.14, dist = 477, fov = 35, ty = -13, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "p2p" } },
    },
    {
        id = "offhand_gorgonite_battleaxe", name = "Off-hand gorgonite battleaxe", kind = "item", rarity = "rare",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_9", cam = { yaw = 0.82, dist = 434, fov = 35, ty = 5, tx = -15 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "p2p" } },
    },
    {
        id = "offhand_katagon_battleaxe", name = "Off-hand katagon battleaxe", kind = "item", rarity = "rare",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_8", cam = { yaw = 0.91, dist = 434, fov = 35, ty = 6, tx = -11 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "p2p" } },
    },
    {
        id = "offhand_primal_battleaxe", name = "Off-hand primal battleaxe", kind = "item", rarity = "epic",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_11", cam = { yaw = 0.76, dist = 525, fov = 35, ty = -5, tx = -7 } },
        tags = { regions = { "daemonheim" }, skills = { "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "p2p" } },
    },
    {
        id = "offhand_promethium_battleaxe", name = "Off-hand promethium battleaxe", kind = "item", rarity = "epic",
        desc = "A vicious-looking off-hand axe.",
        art = { item = "RAND_BATTLEAXE_O_10", cam = { yaw = 0.87, dist = 434, fov = 35, ty = 7, tx = -2 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "p2p" } },
    },
    {
        id = "promethium_battleaxe", name = "Promethium battleaxe", kind = "item", rarity = "epic",
        desc = "A vicious-looking axe.",
        art = { item = "RAND_BATTLEAXE_10", cam = { yaw = -1.12, dist = 477, fov = 35, ty = -5, tx = 9 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "axe" }, membership = { "p2p" } },
    },
}

return Set
