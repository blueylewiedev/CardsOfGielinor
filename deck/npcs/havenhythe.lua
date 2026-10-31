local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "havenhythe" } }

Set.cards = {
    { id = "bear_cub", name = "Bear cub", rarity = "common", desc = "Cute. But deadly.", art = { npc = "BROWNBEAR_CUB_1", anim = 17294, cam = { yaw = 0.60, pitch = 0.30, dist = 1137, ty = 220 } }, tags = { regions = { "fremennik_province" }, location = { "highweald_forest", "rellekka" }, category = { "animal", "monster" }, membership = { "f2p" } } },
    { id = "fox", name = "Fox", rarity = "uncommon", desc = "A cunning animal.", art = { npc = "VIKING_FOX", anim = 6561, cam = { yaw = 0.80, pitch = 0.30, dist = 861, fov = 30, ty = 120 } }, tags = { regions = { "fremennik_province" }, location = { "amberfell", "deserted_mine", "rellekka" }, category = { "monster" }, membership = { "p2p" } } },
    

}

return Set
