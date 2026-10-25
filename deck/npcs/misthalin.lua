-- deck/npcs/misthalin.lua
-- NPC cards for Lumbridge, Draynor, Varrock and the rest of the kingdom of Misthalin. Every card in this file is tagged `regions = { "misthalin" }`
-- automatically (see `defaults`), so each card only lists its own location, skills and category.
--
-- Only NPCs that belong to this region go here. NPCs found all over the game (guards, shop
-- keepers, animals) go in deck/npcs/general.lua instead, so a card for them counts for all of
-- them and region packs do not draw them.
--
-- Cards whose `art = { npc = "" }` is empty are drafts: the NPC's config name still has to be
-- found in the game (stand next to the NPC and use Nearby NPCs in the dev
-- tools). Until `npc` is filled in, a draft is left out of packs, the collection and the
-- totals, so an unfinished card never shows up as a blank card. Fill in the name, reload the
-- plugin, and the card goes live. NPC cards show the body model by default (add `body = false` to `art` for the head), and
-- tune the camera in the preview as usual.
--
-- The `id` is what gets saved, so do not change it once the card is live. It does not have to
-- match the NPC: the NPC comes from `art.npc`.
--
-- Tag words must be on the lists in Cards.tagWords (core/cards.lua), or the plugin refuses to load
-- and tells you which card has the typo.

local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "misthalin" } }

Set.cards = {
    -- Live cards (these are in the game)

    {
        id = "hans", name = "Hans", rarity = "uncommon",
        desc = "Has walked Lumbridge Castle forever.",
        art = { anim = 916, cam = { yaw = 0.20, dist = 1309, fov = 20, ty = 620 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },

    {
        id = "lumbridge_guide", name = "Lumbridge Guide", rarity = "uncommon",
        desc = "Happy to help new adventurers.",
        art = { npc = "LUMBRIDGE_GUIDE", anim = 12296, cam = { dist = 2281, fov = 20, ty = 600, tx = 60 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },

    {
        id = "cook", name = "Cook", rarity = "uncommon",
        desc = "Always one ingredient short of a cake.",
        art = { anim = 9870, cam = { yaw = 0.20, fov = 20, ty = 620 } },
        tags = { location = { "lumbridge" }, skills = { "cooking" }, category = { "humanoid" } },
    },

    {
        id = "bob", name = "Bob", rarity = "uncommon",
        desc = "Sells axes and strong opinions.",
        art = { anim = 23790, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, skills = { "woodcutting" }, category = { "shopkeeper" } },
    },

    {
        id = "fred", name = "Fred the Farmer", rarity = "uncommon",
        desc = "Very fond of his sheep.",
        art = { npc = "FRED_THE_FARMER", anim = 15, cam = { yaw = 0.20, pitch = 0.30, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, skills = { "farming" }, category = { "humanoid" } },
    },

    {
        id = "aereck", name = "Father Aereck", rarity = "uncommon",
        desc = "Keeps the chapel quiet and tidy.",
        art = { npc = "FATHER_AERECK", anim = 13773, cam = { yaw = -0.40, fov = 20, ty = 580, tx = 10 } },
        tags = { location = { "lumbridge" }, skills = { "prayer" }, category = { "humanoid" } },
    },

    {
        id = "duke_horacio", name = "Duke Horacio", rarity = "rare",
        desc = "Rules Lumbridge from the castle.",
        art = { npc = "DUKE_OF_LUMBRIDGE", anim = 9870, cam = { yaw = 0.20, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "royalty" } },
    },

    {
        id = "gertrude", name = "Gertrude", rarity = "rare",
        desc = "Lives with a great many cats.",
        art = { anim = 3, cam = { yaw = -0.40, fov = 20, ty = 600, tx = 10 } },
        tags = { location = { "varrock" }, category = { "humanoid" } },
    },

    {
        id = "aggie", name = "Aggie", rarity = "rare",
        desc = "Mixes dyes and asks for coins.",
        art = { anim = 5363, cam = { yaw = 0.60, pitch = -0.30, fov = 20, ty = 600, tx = 20 } },
        tags = { location = { "draynor" }, skills = { "herblore" }, category = { "humanoid" } },
    },

    {
        id = "WOM_CUTSCENE_4", name = "Wise Old Man", rarity = "epic",
        desc = "Claims to know a great deal about everything.",
        art = { anim = 813, cam = { yaw = 0.40, fov = 20, ty = 580, tx = 20 } },
        tags = { location = { "draynor" }, category = { "humanoid" } },
    },

    {
        id = "doomsayer", name = "Doomsayer", rarity = "uncommon",
        desc = "We are all DOOMED!",
        art = { npc = "CWS_DOOMSAYER", anim = 12292, cam = { yaw = 0.40, dist = 862, fov = 40, ty = 740 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },

    {
        id = "wizard_ilona", name = "Wizard Ilona", rarity = "uncommon",
        desc = "Almost sacrificed, now a dinosaur collector.",
        art = { npc = "ARIANE1_ILONA_APPEARANCE", anim = 18911, cam = { dist = 749, fov = 35, ty = 560 } },
        tags = { location = { "lumbridge", "ranch_out_of_time" }, skills = { "farming" }, category = { "humanoid" } },
    },

    {
        id = "swamp_frog", name = "Swamp frog", rarity = "uncommon",
        desc = "Can YOU lick your own eye? This little guy can!",
        art = { npc = "SMALL_FROG", anim = 37023, cam = { yaw = -0.40, pitch = 0.30, dist = 988, fov = 20, ty = 40 } },
        tags = { location = { "lumbridge", "lumbridge_swamp" }, skills = { "slayer"}, category = { "animal", "monster" } },
    },

    {
        id = "big_frog", name = "Big frog", rarity = "common",
        desc = "It's big, but not Giant!",
        art = { npc = "MEDIUM_FROG", anim = 1796, cam = { yaw = 0.60, pitch = 0.45, dist = 859, fov = 40, ty = 100, tx = 50 } },
        tags = { location = { "lumbridge", "dorgesh_kaan" }, skills = { "slayer"}, category = { "monster", "animal" } },
    },

    {
        id = "giant_frog", name = "Giant frog", rarity = "uncommon",
        desc = "Eats flies",
        art = { npc = "GIANT_FROG", anim = 1796, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 120 } },
        tags = { location = { "lumbridge", "dorgesh_kaan" }, skills = { "slayer"}, category = { "monster", "animal" } },
    },

    {
        id = "cave_slime", name = "Cave slime", rarity = "common",
        desc = "Animated... Slime?",
        art = { npc = "SWAMP_CAVE_SLIME", anim = 1788, cam = { yaw = 0.60, pitch = 0.30, dist = 859, fov = 35, ty = 80 } },
        tags = { location = { "lumbridge", "dorgesh_kaan" }, skills = { "slayer" }, category = { "monster" } },
    },

    {
        id = "hole_in_the", name = "Wall Beast", rarity = "rare",
        desc = "This is my wall, get yer own!",
        art = { npc = "SWAMP_WALLBEAST", anim = 1803, cam = { yaw = -0.40, dist = 1502, fov = 35, ty = 260, tx = -90 } },
        tags = { location = { "lumbridge", "dorgesh_kaan" }, skills = { "slayer" }, category = { "monster" } },
    },

    {
        id = "cave_goblin", name = "Cave goblin", rarity = "epic",
        desc = "One of the many citizens of Dorgesh-Kaan.",
        art = { npc = "CAVE_GOBLIN4", anim = 6047, cam = { dist = 988, fov = 30, ty = 400 } },
        tags = { location = { "dorgesh_kaan" }, skills = { "thieving" }, category = { "goblin" } },
    },
}

return Set
