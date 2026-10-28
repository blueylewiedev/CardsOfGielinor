local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "karamja" } }

Set.cards = {

    {
        id = "elvarg", name = "Elvarg", rarity = "epic",
        desc = "A dragon who prefers to be left alone.",
        art = { anim = 14256, cam = { yaw = 0.40, pitch = -0.15, dist = 3998, fov = 20, ty = 500, tx = 40 } },
        tags = { category = { "dragon", "boss", "monster" } },
    },
}

return Set
