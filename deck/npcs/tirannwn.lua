local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "tirannwn" } }

Set.cards = {
    
    { id = "war_tortoise", name = "War tortoise", rarity = "rare", desc = "Definitely not teenaged, although the jury is out on its skills.", art = { npc = "LORE_WAR_TURTLE", anim = 25580, cam = { pitch = 0.30, dist = 1504, fov = 35, ty = 220 } }, tags = { regions = { "kandarin" }, skills = { "summoning" }, category = { "animal", "monster" }, membership = { "p2p" } } },
    { id = "dire_wolf", name = "Dire Wolf", rarity = "uncommon", desc = "What big teeth you have.", art = { npc = "DIREWOLF", anim = 6580, cam = { yaw = -0.60, pitch = 0.30, dist = 1505, fov = 35, ty = 200, tx = 60 } }, tags = { regions = { "wilderness" }, location = { "arandar", "chaos_tunnels" }, category = { "animal", "monster" }, membership = { "p2p" } } },
    { id = "firefly_the_lost_grove", name = "Firefly (The Lost Grove)", rarity = "common", desc = "Mysterious lights.", art = { npc = "NATURE_BEINGS_FIREFLY_BLUE", anim = 7068, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 800 } }, tags = { location = { "the_lost_grove", "piscatoris_hunter_area" }, category = { "insect" }, membership = { "f2p" } } },
    


}

return Set
