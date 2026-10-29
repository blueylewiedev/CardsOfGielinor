local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "morytania" } }

Set.cards = {

    { id = "death_spawn", name = "Death spawn", rarity = "uncommon", desc = "An evil death spawn.", art = { npc = "RAND_DEATH_SPAWN", anim = 9462, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 280 } }, tags = { regions = { "wilderness" }, category = { "demon", "monster" }, membership = { "p2p" } } },
    { id = "infernal_mage", name = "Infernal Mage", rarity = "rare", desc = "An evil magic user.", art = { npc = "SLAYER_INFERNAL_MAGE_1", anim = 7188, cam = { pitch = 0.15, dist = 650, fov = 75, ty = 480 } }, tags = { regions = { "wilderness" }, skills = { "slayer" }, category = { "humanoid", "monster" }, membership = { "p2p" } } },
    { id = "pirate_impling", name = "Pirate impling", rarity = "rare", desc = "A pirate impling. Aarrrr!", art = { npc = "II_IMPLING_TYPE_11", anim = 6613, cam = { pitch = 0.15, dist = 324, ty = 860 } }, tags = { location = { "trouble_brewing", "puro_puro" }, skills = { "hunter" }, category = { "impling", "pirate" }, membership = { "p2p" } } },
}

return Set
