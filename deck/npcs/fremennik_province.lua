local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "fremennik_province" } }

Set.cards = {

    {
        id = "black_unicorn", name = "Black unicorn", rarity = "uncommon",
        desc = "A unicorn with a blackened heart.",
        art = { npc = "BLACK_UNICORN", anim = 33036, cam = { yaw = -0.60, pitch = 0.30, dist = 1730, fov = 35, ty = 340, tx = 40 } },
        tags = { regions = { "wilderness" }, category = { "animal", "monster" }, membership = { "p2p" } },
    },
    {
        id = "giant_rock_crab", name = "Giant Rock Crab", rarity = "uncommon",
        desc = "No one likes crabs... especially really big ones!",
        art = { npc = "GIANT_ROCKCRAB_DEEPER", anim = 1311, cam = { yaw = -1.40, pitch = 0.30, dist = 2287, fov = 35, ty = 320 } },
        tags = { regions = { "wilderness" }, category = { "animal", "monster" }, membership = { "p2p" } },
    },
    { id = "dagannoth_sentinel", name = "Dagannoth sentinel", rarity = "rare", desc = "The greatest of the Dagannoth Mother's guardians.", art = { npc = "EVQ_SENTINEL", anim = 1338, cam = { yaw = 0.40, dist = 4003, fov = 20, ty = 640, tx = 10 } }, tags = { category = { "boss", "monster" }, membership = { "p2p" } } },
}

return Set
