local Set = {}

Set.cards = {
    { id = "adamant_claws", name = "Adamant claws", kind = "item", rarity = "uncommon", desc = "A pair of adamant claws.", art = { item = "ADAMANT_CLAWS", cam = { yaw = -2.20, dist = 525, fov = 30 } }, tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "claw" }, membership = { "f2p" } } },
    { id = "adamant_off_hand_claws", name = "Adamant off hand claws", kind = "item", rarity = "uncommon", desc = "A pair of adamant off hand claws.", art = { item = "ADAMANT_CLAWS_O", cam = { yaw = -4.00, dist = 525, fov = 30 } }, tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "claw" }, membership = { "f2p" } } },
    { id = "black_claw", name = "Black claw", kind = "item", rarity = "uncommon", desc = "A right-hand fighting claw.", art = { item = "BLACK_CLAWS", cam = { yaw = -2.00, dist = 456, fov = 35 } }, tags = { skills = { "attack" }, category = { "weapon", "melee_gear", "claw" }, membership = { "f2p" } } },
    { id = "bronze_claws", name = "Bronze claws", kind = "item", rarity = "common", desc = "A right-hand fighting claw. Melee weapon, requires Attack.", art = { item = "BRONZE_CLAWS", cam = { yaw = -2.20, dist = 525, fov = 30 } }, tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "claw" }, membership = { "f2p" } } },
    { id = "bronze_off_hand_claws", name = "Bronze off hand claws", kind = "item", rarity = "common", desc = "A left-hand fighting claw. Melee weapon, requires Attack.", art = { item = "BRONZE_CLAWS_O", cam = { yaw = 2.40, dist = 525, fov = 30 } }, tags = { skills = { "smithing", "attack" }, category = { "weapon", "melee_gear", "claw" }, membership = { "f2p" } } },
    { id = "chaotic_claw", name = "Chaotic claw", kind = "item", rarity = "epic", desc = "A chaotic slashing claw.", art = { item = "RAND_CLAW_80_REWARD", cam = { yaw = -7.20, dist = 525, fov = 35, ty = -20, tx = 20 } }, tags = { regions = { "daemonheim" }, skills = { "attack" }, category = { "weapon", "melee_gear", "claw" }, membership = { "p2p" } } },
    { id = "dragon_claw", name = "Dragon claw", kind = "item", rarity = "rare", desc = "A right-hand fighting claw.", art = { item = "LUC2_DRAGON_CLAWS", cam = { yaw = -7.20, dist = 525, fov = 30 } }, tags = { regions = { "misthalin" }, skills = { "attack" }, category = { "weapon", "melee_gear", "claw" }, membership = { "p2p" } } },
}

return Set
