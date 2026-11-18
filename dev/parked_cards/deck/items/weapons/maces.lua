-- Parked: cards taken out of deck/items/weapons/maces.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "argonite_warhammer", name = "Argonite warhammer", kind = "item", rarity = "uncommon",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_7", cam = { yaw = -1.80, dist = 525, fov = 25, ty = -40, tx = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "bathus_warhammer", name = "Bathus warhammer", kind = "item", rarity = "common",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_2", cam = { yaw = -1.80, dist = 456, fov = 25, ty = -40, tx = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "fractite_warhammer", name = "Fractite warhammer", kind = "item", rarity = "uncommon",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_5", cam = { yaw = -6.80, dist = 525, fov = 30, ty = 20, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "marmaros_warhammer", name = "Marmaros warhammer", kind = "item", rarity = "common",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_3", cam = { yaw = -6.97, dist = 359, fov = 35, ty = 8, tx = -16 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "novite_warhammer", name = "Novite warhammer", kind = "item", rarity = "common",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_1", cam = { yaw = -7.02, dist = 359, fov = 35, ty = 14, tx = -18 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "offhand_bathus_warhammer", name = "Off-hand bathus warhammer", kind = "item", rarity = "common",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_2", cam = { yaw = -4.90, dist = 394, fov = 30, ty = 31, tx = 26 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "offhand_marmaros_warhammer", name = "Off-hand marmaros warhammer", kind = "item", rarity = "common",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_3", cam = { yaw = -4.89, dist = 394, fov = 30, ty = 30, tx = 24 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "offhand_novite_warhammer", name = "Off-hand novite warhammer", kind = "item", rarity = "common",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_1", cam = { yaw = -4.89, dist = 394, fov = 30, ty = 30, tx = 24 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "kratonite_warhammer", name = "Kratonite warhammer", kind = "item", rarity = "common",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_4", cam = { yaw = -0.78, dist = 456, fov = 25, ty = 11, tx = -26 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "offhand_fractite_warhammer", name = "Off-hand fractite warhammer", kind = "item", rarity = "uncommon",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_5", cam = { yaw = -4.89, dist = 394, fov = 30, ty = 30, tx = 24 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "offhand_kratonite_warhammer", name = "Off-hand kratonite warhammer", kind = "item", rarity = "common",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_4", cam = { yaw = -4.89, dist = 394, fov = 30, ty = 30, tx = 24 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "offhand_argonite_warhammer", name = "Off-hand argonite warhammer", kind = "item", rarity = "uncommon",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_7", cam = { yaw = -4.89, dist = 394, fov = 30, ty = 30, tx = 24 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "offhand_zephyrium_warhammer", name = "Off-hand zephyrium warhammer", kind = "item", rarity = "uncommon",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_6", cam = { yaw = -4.89, dist = 394, fov = 30, ty = 30, tx = 24 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_warhammer", name = "Zephyrium warhammer", kind = "item", rarity = "uncommon",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_6", cam = { yaw = -6.92, dist = 394, fov = 35, ty = 14, tx = -17 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "f2p" } },
    },
    {
        id = "katagon_warhammer", name = "Katagon warhammer", kind = "item", rarity = "rare",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_8", cam = { yaw = -6.92, dist = 394, fov = 35, ty = 14, tx = -17 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "p2p" } },
    },
    {
        id = "offhand_gorgonite_warhammer", name = "Off-hand gorgonite warhammer", kind = "item", rarity = "rare",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_9", cam = { yaw = -4.99, dist = 434, fov = 30, ty = 22, tx = 11 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "p2p" } },
    },
    {
        id = "offhand_katagon_warhammer", name = "Off-hand katagon warhammer", kind = "item", rarity = "rare",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_8", cam = { yaw = -4.90, dist = 394, fov = 30, ty = 31, tx = 26 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "p2p" } },
    },
    {
        id = "offhand_promethium_warhammer", name = "Off-hand promethium warhammer", kind = "item", rarity = "epic",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_O_10", cam = { yaw = -5.04, dist = 433, fov = 30, ty = 29, tx = 17 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "p2p" } },
    },
    {
        id = "promethium_warhammer", name = "Promethium warhammer", kind = "item", rarity = "epic",
        desc = "I don't think it's intended for joinery.",
        art = { item = "RAND_WARHAMMER_10", cam = { yaw = -7.02, dist = 394, fov = 35, ty = 20, tx = -15 } },
        tags = { regions = { "daemonheim" }, skills = { "smithing", "attack", "dungeoneering" }, category = { "weapon", "melee_gear", "mace" }, membership = { "p2p" } },
    },
}

return Set
