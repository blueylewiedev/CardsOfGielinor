local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "tirannwn" } }

Set.cards = {
    
    { id = "war_tortoise", name = "War tortoise", rarity = "rare", desc = "Definitely not teenaged, although the jury is out on its skills.", art = { npc = "LORE_WAR_TURTLE", anim = 25580, cam = { pitch = 0.30, dist = 1504, fov = 35, ty = 220 } }, tags = { regions = { "kandarin" }, skills = { "summoning" }, category = { "animal", "monster" }, membership = { "p2p" } } },
}

return Set
