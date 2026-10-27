-- deck/npcs/asgarnia.lua
-- NPC cards for Falador, Port Sarim, Taverley, Burthorpe and the rest of Asgarnia. Every card in this file is tagged `regions = { "asgarnia" }`
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
Set.defaults = { regions = { "asgarnia" } }

Set.cards = {
    -- Live cards (these are in the game)

    {
        id = "doric", name = "Doric", rarity = "rare",
        desc = "A dwarf serious about his anvil.",
        art = { anim = 17846, cam = { yaw = -0.40, dist = 859, ty = 280, tx = 50 } },
        tags = { skills = { "smithing" }, category = { "shopkeeper" } },
    },
    { id = "aksel", name = "Aksel", rarity = "common", desc = "* An excited dwarf. * A worried looking dwarf.", art = { npc = "ARTISAN_AKSEL", anim = 17844, cam = { yaw = -0.20, dist = 566, ty = 340 } }, tags = { category = { "humanoid" } } },
    { id = "ambassador_spanfipple", name = "Ambassador Spanfipple", rarity = "uncommon", desc = "Peaceful man!", art = { npc = "ALUFT_GNOME_DIPLOMAT_FALADOR", anim = 37961, cam = { yaw = -0.20, dist = 566, ty = 320 } }, tags = { category = { "humanoid" } } },
    { id = "apprentice_workman", name = "Apprentice workman", rarity = "common", desc = "He's learning a trade.", art = { npc = "FALADOR_WORKMAN_YOUNG", anim = 808, cam = { pitch = 0.15, dist = 859, ty = 480 } }, tags = { location = { "falador" }, category = { "humanoid" } } },
    { id = "drunken_man", name = "Drunken man", rarity = "common", desc = "One of Gielinor's many citizens, currently incapacitated by alcohol.", art = { npc = "FALADOR_MAN1", anim = 2770, cam = { pitch = 0.15, dist = 859, ty = 480 } }, tags = { category = { "humanoid", "monster" } } },
    { id = "dwarf", name = "Dwarf", rarity = "uncommon", desc = "A dwarf who looks after the mining guild.", art = { npc = "GUILDDWARF", anim = 17844, cam = { yaw = -0.20, dist = 566, ty = 340 } }, tags = { category = { "humanoid" } } },
    { id = "egil", name = "Egil", rarity = "uncommon", desc = "A particularly neat dwarf.", art = { npc = "ARTISAN_EGIL_SCORER", anim = 17844, cam = { yaw = -0.20, dist = 566, ty = 340 } }, tags = { category = { "humanoid", "shopkeeper" } } },
    { id = "elof", name = "Elof", rarity = "common", desc = "A pen-pushing sort of fellow.", art = { npc = "ARTISAN_ELOF", anim = 17844, cam = { yaw = 0.40, dist = 566, ty = 340 } }, tags = { category = { "humanoid", "shopkeeper" } } },
    { id = "emily", name = "Emily", rarity = "uncommon", desc = "Works in the Rising Sun.", art = { npc = "QUEST_DAUGHTER2_MUSICAL_EMILY", anim = 12456, cam = { yaw = 6.40, dist = 1306, fov = 20, ty = 600 } }, tags = { location = { "falador" }, category = { "humanoid", "shopkeeper" } } },

    -- Drafts (waiting for an NPC name)

    {
        id = "sir_amik_varze", name = "Sir Amik Varze", rarity = "rare",
        desc = "Leads the White Knights proudly.",
        art = { npc = "" },
        tags = { location = { "falador" }, category = { "knight" } },
    },

    {
        id = "sir_vyvin", name = "Sir Vyvin", rarity = "rare",
        desc = "Guards the castle and a secret.",
        art = { npc = "" },
        tags = { location = { "falador" }, category = { "knight" } },
    },

    {
        id = "sir_tiffy", name = "Sir Tiffy Cashien", rarity = "uncommon",
        desc = "Recruits new knights in the park.",
        art = { npc = "" },
        tags = { location = { "falador" }, category = { "knight" } },
    },

    {
        id = "wayne", name = "Wayne", rarity = "uncommon",
        desc = "Chainmail for every budget.",
        art = { npc = "" },
        tags = { location = { "falador" }, skills = { "smithing" }, category = { "shopkeeper" } },
    },

    {
        id = "flynn", name = "Flynn", rarity = "uncommon",
        desc = "Sells maces with a smile.",
        art = { npc = "" },
        tags = { location = { "falador" }, category = { "shopkeeper" } },
    },

    {
        id = "cassie", name = "Cassie", rarity = "uncommon",
        desc = "Sells shields to the knights.",
        art = { npc = "" },
        tags = { location = { "falador" }, category = { "shopkeeper" } },
    },

    {
        id = "herquin", name = "Herquin", rarity = "uncommon",
        desc = "Buys and sells gems.",
        art = { npc = "" },
        tags = { location = { "falador" }, category = { "shopkeeper" } },
    },

    {
        id = "hairdresser", name = "Hairdresser", rarity = "common",
        desc = "Offers a fresh new look.",
        art = { npc = "" },
        tags = { location = { "falador" }, category = { "humanoid" } },
    },

    {
        id = "white_knight", name = "White Knight", rarity = "common",
        desc = "Sworn to defend Falador.",
        art = { npc = "" },
        tags = { location = { "falador" }, category = { "knight" } },
    },
}

return Set
