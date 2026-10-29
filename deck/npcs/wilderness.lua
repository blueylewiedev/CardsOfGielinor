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
    { id = "wyvern", name = "Wyvern", rarity = "rare", desc = "A very dangerous wyvern.", art = { npc = "HLM_WYVERN", anim = 27747, cam = { yaw = 0.40, pitch = 0.30, dist = 1137, fov = 70, ty = 200, tx = -70 } }, tags = { regions = { "asgarnia" }, skills = { "slayer" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "baby_black_dragon", name = "Baby black dragon", rarity = "uncommon", desc = "Young but still dangerous.", art = { npc = "CHICKENQUEST_BABY_BLACK_DRAGON", anim = 14267, cam = { pitch = 0.30, dist = 1308, fov = 45, ty = 380 } }, tags = { regions = { "misthalin" }, location = { "chaos_tunnels", "evil_chicken_s_lair" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "bloodworm", name = "Bloodworm", rarity = "uncommon", desc = "I think I should keep my distance...", art = { npc = "BARROWS_BLOODWORM", anim = 2071, cam = { yaw = 1.00, pitch = 0.30, dist = 990, fov = 30, ty = 120 } }, tags = { regions = { "morytania" }, location = { "chaos_tunnels", "barrows" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "crypt_spider", name = "Crypt spider", rarity = "uncommon", desc = "Incey wincey.", art = { npc = "BARROWS_SPIDER", anim = 6247, cam = { pitch = 0.30, dist = 1137, fov = 25, ty = 120 } }, tags = { regions = { "morytania" }, location = { "chaos_tunnels", "barrows" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "dust_devil", name = "Dust devil", rarity = "uncommon", desc = "The vacuumed face of evil.", art = { npc = "SLAYER_DUSTDEVIL", anim = 24026, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 260 } }, tags = { regions = { "kharidian_desert" }, location = { "chaos_tunnels", "smoke_dungeon" }, skills = { "slayer" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "magic_axe", name = "Magic axe", rarity = "uncommon", desc = "A magic axe with a mind of its own.", art = { npc = "MAGICAXE", anim = 23841, cam = { yaw = 1.00, pitch = 0.30, dist = 1137, fov = 35, ty = 460 } }, tags = { regions = { "asgarnia" }, location = { "magic_axe_hut", "taverley" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "soulgazer", name = "Soulgazer", rarity = "rare", desc = "A floating eye of some sort.", art = { npc = "STALKER_SOULGAZER", anim = 13767, cam = { pitch = 0.15, dist = 1308, fov = 45, ty = 420 } }, tags = { regions = { "misthalin" }, location = { "stalker_dungeon" }, skills = { "slayer" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "veilripper_ozharakha", name = "Veil-ripper Ozharakha", rarity = "epic", desc = "It's got a hot stare.", art = { npc = "STALKER_SOULGAZER_SPECIAL", anim = 13767, cam = { dist = 1137, fov = 65, ty = 660 } }, tags = { regions = { "misthalin" }, location = { "stalker_dungeon" }, skills = { "slayer" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "arrav", name = "Arrav", rarity = "uncommon", desc = "He has seen better, happier days.", art = { npc = "ZEMO_ARRAV_VARROK", anim = 26150, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 600 } }, tags = { location = { "chaos_temple_dungeon", "varrock" }, category = { "undead" }, membership = { "p2p" } } },
    



}

return Set
