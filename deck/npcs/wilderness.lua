local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "wilderness" } }

Set.cards = {

    {
        id = "king_dragon", name = "King Black Dragon", rarity = "legendary",
        desc = "Three heads, all of them hungry.",
        art = { anim = 17777, cam = { yaw = 0.20, pitch = 0.15, dist = 2626, fov = 65, ty = 1260, tx = 120 } },
        tags = { category = { "dragon", "boss", "monster" } },
    },
    {
        id = "foal", name = "Foal", rarity = "common",
        desc = "Cute but evil.",
        art = { npc = "BLACK_UNICORN_FOAL", anim = 33036, cam = { yaw = 0.60, pitch = 0.30, dist = 1137, fov = 35, ty = 220 } },
        tags = { regions = { "fremennik_province" }, category = { "animal", "monster" }, membership = { "p2p" } },
    },
    { id = "dark_squall", name = "Dark Squall", rarity = "uncommon", desc = "A mage of incredible power and awesome presence.", art = { npc = "DSD_DARKSQUALL2", anim = 7188, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } }, tags = { regions = { "asgarnia" }, location = { "chaos_tunnels", "black_knights_catacombs", "kal_gerion_dungeon" }, category = { "humanoid", "wizard" }, membership = { "p2p" } } },
    { id = "zamorak_ranger", name = "Zamorak ranger", rarity = "uncommon", desc = "A ranger of Zamorak.", art = { npc = "RC_ZMI_RANGER2", anim = 10246, cam = { pitch = 0.15, dist = 859, ty = 480 } }, tags = { regions = { "kandarin" }, category = { "humanoid", "monster" }, membership = { "p2p" } } },
    { id = "giant_ant_soldier", name = "Giant ant soldier", rarity = "uncommon", desc = "Gi-ant-ant-ant-ant...", art = { npc = "ROOTS_GIANT_ANT_SOLDIER", anim = 7236, cam = { yaw = 0.60, pitch = 0.30, dist = 1137, fov = 35, ty = 220 } }, tags = { regions = { "karamja" }, category = { "insect", "monster" }, membership = { "p2p" } } },
    { id = "giant_ant_worker", name = "Giant ant worker", rarity = "uncommon", desc = "I wonder how much he can lift.", art = { npc = "ROOTS_GIANT_ANT_WORKER", anim = 7236, cam = { yaw = -0.60, pitch = 0.30, dist = 861, fov = 35, ty = 140 } }, tags = { regions = { "karamja" }, category = { "insect", "monster" }, membership = { "p2p" } } },
}

return Set
