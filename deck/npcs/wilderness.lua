local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "wilderness" } }

Set.cards = {

    {
        id = "king_dragon", name = "King Black Dragon", rarity = "legendary",
        desc = "Three heads, all of them hungry.",
        art = { anim = 17777, cam = { yaw = 0.20, pitch = 0.15, dist = 2626, fov = 65, ty = 1260, tx = 120 } },
        tags = { category = { "dragon" } },
    },
}

return Set
