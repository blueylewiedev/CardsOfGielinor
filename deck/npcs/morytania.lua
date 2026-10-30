local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "morytania" } }

Set.cards = {

    { id = "death_spawn", name = "Death spawn", rarity = "uncommon", desc = "An evil death spawn.", art = { npc = "RAND_DEATH_SPAWN", anim = 9462, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 280 } }, tags = { regions = { "wilderness" }, category = { "demon", "monster" }, membership = { "p2p" } } },
    { id = "infernal_mage", name = "Infernal Mage", rarity = "rare", desc = "An evil magic user.", art = { npc = "SLAYER_INFERNAL_MAGE_1", anim = 7188, cam = { pitch = 0.15, dist = 650, fov = 75, ty = 480 } }, tags = { regions = { "wilderness" }, skills = { "slayer" }, category = { "humanoid", "monster" }, membership = { "p2p" } } },
    { id = "pirate_impling", name = "Pirate impling", rarity = "rare", desc = "A pirate impling. Aarrrr!", art = { npc = "II_IMPLING_TYPE_11", anim = 6613, cam = { pitch = 0.15, dist = 324, ty = 860 } }, tags = { location = { "trouble_brewing", "puro_puro" }, skills = { "hunter" }, category = { "impling", "pirate" }, membership = { "p2p" } } },
    { id = "animated_spade", name = "Animated spade", rarity = "uncommon", desc = "How does it move of its own accord?", art = { npc = "LOTR_POSSESSED_SPADE", anim = 5594, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 380 } }, tags = { regions = { "wilderness" }, location = { "chaos_tunnels", "abandoned_mine" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "giant_crypt_rat", name = "Giant crypt rat", rarity = "uncommon", desc = "A nasty overgrown rodent.", art = { npc = "BARROWS_GIANTRAT", anim = 14857, cam = { yaw = -0.40, pitch = 0.30, dist = 1137, fov = 35, ty = 200 } }, tags = { regions = { "wilderness" }, location = { "barrows", "chaos_tunnels" }, category = { "animal", "monster" }, membership = { "p2p" } } },
    { id = "giant_crypt_spider", name = "Giant crypt spider", rarity = "uncommon", desc = "Not very incey wincey.", art = { npc = "BARROWS_GIANTSPIDER", anim = 5326, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 100 } }, tags = { regions = { "wilderness" }, location = { "chaos_tunnels", "barrows" }, category = { "insect", "monster" }, membership = { "p2p" } } },
    { id = "leech", name = "Leech", rarity = "uncommon", desc = "Yuck! It's all slimy!", art = { npc = "VAMPIRE_LEECH", anim = 1270, cam = { yaw = -0.60, pitch = 0.30, dist = 861, fov = 35, ty = 60, tx = 40 } }, tags = { regions = { "wilderness" }, location = { "haunted_woods", "chaos_tunnels" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "nechryael", name = "Nechryael", rarity = "rare", desc = "An evil death demon.", art = { npc = "SLAYER_NECHRYAEL", anim = 23832, cam = { pitch = 0.30, dist = 1137, fov = 45, ty = 400 } }, tags = { regions = { "wilderness" }, location = { "slayer_tower", "chaos_tunnels" }, skills = { "slayer" }, category = { "chthonian", "monster" }, membership = { "p2p" } } },
    { id = "vyrelady", name = "Vyrelady", rarity = "uncommon", desc = "A very high-ranking vampyre.", art = { npc = "MYQ5_DM_HIGH_FEMALE1", anim = 7733, cam = { pitch = 0.30, dist = 1137, fov = 45, ty = 460 } }, tags = { location = { "darkmeyer" }, category = { "undead", "monster" }, membership = { "p2p" } } },
    { id = "vyrelord", name = "Vyrelord", rarity = "uncommon", desc = "A very high-ranking vampyre.", art = { npc = "MYQ5_DM_HIGH_MALE1", anim = 7733, cam = { pitch = 0.30, dist = 1504, fov = 35, ty = 440 } }, tags = { location = { "darkmeyer" }, category = { "undead", "monster" }, membership = { "p2p" } } },
    { id = "zombie_pirate_head", name = "Zombie pirate head", rarity = "uncommon", desc = "If they go to the ball they'll have no body to go with.", art = { npc = "PIRATEFINALE_ZOMBIEHEAD", anim = 31618, cam = { pitch = 0.15, dist = 566, fov = 35, ty = 320 } }, tags = { regions = { "karamja" }, location = { "harpoon_joe_s_house_of_rum", "tai_bwo_wannai" }, category = { "undead", "pirate" }, membership = { "p2p" } } },
    



}

return Set
