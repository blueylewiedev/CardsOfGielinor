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
    { id = "dagannoth_sentinel", name = "Dagannoth sentinel", rarity = "rare", desc = "The greatest of the Dagannoth Mother's guardians.", art = { npc = "EVQ_SENTINEL", anim = 1338, cam = { yaw = 0.40, dist = 4003, fov = 20, ty = 640, tx = 10 } }, tags = { category = { "dagannoth", "boss", "monster" }, membership = { "p2p" } } },
    { id = "acheron_mammoth", name = "Acheron mammoth", rarity = "uncommon", desc = "Large, noble and wooly. He's still going to smush you into paste.", art = { npc = "HLM_MAMMOTH", anim = 27814, cam = { yaw = -0.60, pitch = 0.30, dist = 2630, fov = 70, ty = 960, tx = 80 } }, tags = { regions = { "wilderness" }, location = { "mammoth_iceberg", "frozen_waste_plateau" }, skills = { "slayer" }, category = { "animal", "monster" }, membership = { "p2p" } } },
    { id = "aquanite", name = "Aquanite", rarity = "rare", desc = "It has a light on its forehead. What a pretty light... So shiny!", art = { npc = "SLAYER_AQUANITE", anim = 12038, cam = { yaw = 0.60, pitch = 0.30, dist = 1137, fov = 70, ty = 420 } }, tags = { location = { "fremennik_slayer_dungeon" }, skills = { "slayer" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "basilisk", name = "Basilisk", rarity = "uncommon", desc = "The eyes of evil.", art = { npc = "SLAYER_BASILISK", anim = 23874, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 80 } }, tags = { regions = { "kharidian_desert" }, location = { "fremennik_slayer_dungeon", "pollnivneach_slayer_dungeon" }, skills = { "slayer" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "dagannoth", name = "Dagannoth", rarity = "uncommon", desc = "A horror from the ocean depths...", art = { npc = "HORROR_DAGGANOTH_JR", anim = 1338, cam = { yaw = -0.60, pitch = 0.30, dist = 1137, fov = 35, ty = 260, tx = 30 } }, tags = { location = { "lighthouse_dungeon" }, category = { "dagannoth", "monster" }, membership = { "p2p" } } },
    { id = "dagannoth_guardian", name = "Dagannoth guardian", rarity = "uncommon", desc = "The Dagannoth Mother's guardians.", art = { npc = "EVQ_GUARDIAN", anim = 1338, cam = { yaw = 0.40, pitch = 0.15, dist = 988, fov = 80, ty = 480, tx = -60 } }, tags = { location = { "dagannoth_guardian_dungeon" }, category = { "dagannoth", "guard", "monster" }, membership = { "p2p" } } },
    { id = "ice_strykewyrm", name = "Ice strykewyrm", rarity = "rare", desc = "Now that's just cold.", art = { npc = "STRYKEWYRM_ICE", anim = 12790, cam = { pitch = 0.30, dist = 1308, fov = 65, ty = 920 } }, tags = { regions = { "wilderness" }, skills = { "slayer" }, category = { "strykewyrm", "monster" }, membership = { "p2p" } } },
    { id = "jelly", name = "Jelly", rarity = "uncommon", desc = "Looks scared to see me.", art = { npc = "SLAYER_JELLY_1", anim = 24979, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } }, tags = { regions = { "wilderness" }, location = { "fremennik_slayer_dungeon", "jhallan_s_resting_place", "chaos_tunnels" }, skills = { "slayer" }, category = { "jelly", "monster" }, membership = { "p2p" } } },
    { id = "kurask", name = "Kurask", rarity = "uncommon", desc = "Large, heavy, with sharp things attached to its head.", art = { npc = "SLAYER_KURSK_1", anim = 24439, cam = { yaw = -0.40, pitch = 0.30, dist = 1137, fov = 45, ty = 280, tx = 70 } }, tags = { regions = { "kharidian_desert" }, location = { "fremennik_slayer_dungeon", "pollnivneach_slayer_dungeon" }, skills = { "slayer" }, category = { "monster" }, membership = { "p2p" } } },
    { id = "penguin", name = "Penguin", rarity = "common", desc = "An inhabitant of icy regions.", art = { npc = "PENGUIN", anim = 5668, cam = { yaw = 0.20, pitch = 0.30, dist = 861, fov = 35, ty = 180 } }, tags = { regions = { "kandarin" }, location = { "here_be_penguins", "ardougne" }, category = { "animal", "monster" }, membership = { "p2p" } } },
    { id = "polar_kebbit", name = "Polar kebbit", rarity = "common", desc = "It looks clean, but it smells disgusting.", art = { npc = "HUNTING_POLAR_KEBBIT", anim = 5272, cam = { yaw = 1.00, pitch = 0.30, dist = 989, fov = 35, ty = 180, tx = 40 } }, tags = { regions = { "asgarnia" }, location = { "rellekka", "taverley" }, skills = { "hunter" }, category = { "kebbit" }, membership = { "f2p" } } },
    { id = "pyrefiend", name = "Pyrefiend", rarity = "uncommon", desc = "A small fire demon.", art = { npc = "SLAYER_PYREFIEND_1", anim = 34858, cam = { pitch = 0.30, dist = 1137, ty = 420 } }, tags = { regions = { "kharidian_desert" }, location = { "fremennik_slayer_dungeon", "smoke_dungeon" }, skills = { "slayer" }, category = { "elemental", "monster" }, membership = { "p2p" } } },
    



}

return Set
