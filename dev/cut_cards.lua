-- dev/cut_cards.lua
-- NPC cards cut from the deck by the stricter NPC rules of November 2026 (see dev/wiki_cards.py; the
-- Wiki Review queue skips them too). Kept to put one back: move its block into the deck file named
-- above it, and its line into dev/wiki_pages.json. The plugin never loads this file.
return {
    -- Can only be examined (SKIPPED_EXAMINE_ONLY in dev/wiki_cards.py)
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "abel": {"page": "Abel", "resolved": "File:Abel.png"}
    {
        id = "abel", name = "Abel", rarity = "common",
        desc = "A particularly neat dwarf.",
        art = { npc = "ARTISAN_ABEL_SCORER", anim = 17844, cam = { yaw = 0.40, dist = 566, ty = 340 } },
        tags = { location = { "thalmund_s_forge", "falador" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "adventurer": {"page": "Adventurer", "resolved": "File:Adventurer.png"}
    {
        id = "adventurer", name = "Adventurer", rarity = "uncommon",
        desc = "He's in a pretty nasty spot, in a pretty nasty pot.",
        art = { npc = "MYARM_MAN_IN_POT", anim = 479, cam = { yaw = 0.42, pitch = 0.30, dist = 1504, fov = 35, ty = 400 } },
        tags = { location = { "troll_kitchen" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "alfonso": {"page": "Alfonso", "resolved": "File:Alfonso.png"}
    {
        id = "alfonso", name = "Alfonso", rarity = "common",
        desc = "Went down doing what he loved. Delivering barrels.",
        art = { npc = "EGWD_CITY_DRUID_SUPPLIER_WOUNDED", anim = 15809, cam = { yaw = -0.19, pitch = 0.07, dist = 345, ty = 261, tx = 16 } },
        tags = { location = { "tzekhaar_front" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "apollo": {"page": "Apollo", "resolved": "File:Apollo.png"}
    {
        id = "apollo", name = "Apollo", rarity = "common",
        desc = "To go where no monkey has gone before.",
        art = { npc = "TUSKA_PRERELEASE_MONKEY", anim = 26402, cam = { yaw = 0.40, pitch = 0.30, dist = 1137, fov = 35, ty = 260 } },
        tags = { location = { "wizards_tower" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "ash": {"page": "Ash", "resolved": "File:Ash.png"}
    {
        id = "ash", name = "Ash", rarity = "uncommon",
        desc = "Human is his specialty.",
        art = { npc = "DEATH_TROLL_COOK2", anim = 13794, cam = { pitch = 0.30, dist = 1504, fov = 35, ty = 465 } },
        tags = { location = { "death_plateau_location" }, category = { "troll" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "assistant_power_station": {"page": "Assistant (Power Station)", "resolved": "File:Assistant (Power Station).png"}
    {
        id = "assistant_power_station", name = "Assistant (Power Station)", rarity = "common",
        desc = "He works in the power station.",
        art = { npc = "ICEMT_DWARF_WORKER", anim = 9138, cam = { yaw = 1.67, dist = 912, fov = 45, ty = 340, near = 0.25 } },
        tags = { location = { "power_station", "ice_mountain" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "assistant_professor": {"page": "Assistant Professor", "resolved": "File:Assistant Professor.png"}
    {
        id = "assistant_professor", name = "Assistant Professor", rarity = "common",
        desc = "An assistant professor of the Archaeology guild.",
        art = { npc = "ARCH_ASSISTANT_ROAMING_1_F", anim = 18019, cam = { yaw = 0.20, dist = 860, fov = 30, ty = 600, near = 0.25 } },
        tags = { location = { "archaeology_campus" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "associate_professor": {"page": "Associate Professor", "resolved": "File:Associate Professor.png"}
    {
        id = "associate_professor", name = "Associate Professor", rarity = "common",
        desc = "An associate professor of the Archaeology Guild.",
        art = { npc = "ARCH_ASSOCIATE_ROAMING_1_F", anim = 18019, cam = { yaw = -0.25, dist = 860, fov = 30, ty = 597, tx = 25, near = 0.25 } },
        tags = { location = { "archaeology_campus" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "avatar_of_amascut": {"page": "Avatar of Amascut", "first": "File:Avatar of Amascut.png"}
    {
        id = "avatar_of_amascut", name = "Avatar of Amascut", rarity = "rare",
        desc = "The goddess of destruction, acting through her avatar.",
        art = { npc = "HW15_AMASCUT_AVATAR_BOSS", anim = 27651, cam = { dist = 14775, fov = 14, ty = 2152, tx = -23, near = 0.25 } },
        tags = { category = { "avatar", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "aya_city_of_um": {"page": "Aya (City of Um)", "resolved": "File:Aya (City of Um).png"}
    {
        id = "aya_city_of_um", name = "Aya (City of Um)", rarity = "common",
        desc = "Living her best death.",
        art = { npc = "NECRO_HUB_SKELETON_DRUNK_2", anim = 31126, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 430, tx = 43 } },
        tags = { location = { "city_of_um", "the_last_call" }, category = { "undead" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "azris_the_green": {"page": "Azris the Green", "resolved": "File:Azris the Green.png"}
    {
        id = "azris_the_green", name = "Azris the Green", rarity = "uncommon",
        desc = "Master of the Green Order.",
        art = { npc = "ARIANE2_AZRIS_SHRINE_ROOM_WITH_NOTE", anim = 18838, cam = { yaw = 0.29, dist = 860, fov = 36, ty = 572, tx = -17, near = 0.25 } },
        tags = { location = { "wizards_tower" }, category = { "humanoid", "wizard" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "bacon_addict": {"page": "Bacon addict", "first": "File:Bacon addict.png"}
    {
        id = "bacon_addict", name = "Bacon addict", rarity = "common",
        desc = "Crazed by the smell of bacon!",
        art = { npc = "QUEST_BACON_BACON_CULTIST_3_NOOP", anim = 20409, cam = { yaw = 0.12, pitch = 0.15, dist = 859, ty = 507, near = 0.25 } },
        tags = { location = { "falador" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "bell": {"page": "Bell (Flashback)", "resolved": "File:Bell (Flashback).png"}
    {
        id = "bell", name = "Bell", rarity = "uncommon",
        desc = "A cheeky little demon who is apparently good friends with Ava.",
        art = { npc = "MINIQUEST_OUT2_MEMORY_2_IMP", anim = 171, cam = { pitch = 0.30, dist = 1137, fov = 26, ty = 148, tx = 8 } },
        tags = { location = { "draynor" }, category = { "imp" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "billy": {"page": "Billy (goat)", "resolved": "File:Billy.png"}
    {
        id = "billy", name = "Billy", rarity = "common",
        desc = "Billy is a baa-a-a-d goat.",
        art = { npc = "DEATH_MOUNTAIN_GOAT", anim = 5339, cam = { yaw = -0.62, pitch = 0.30, dist = 1137, fov = 35, ty = 222, tx = 48 } },
        tags = { location = { "freda", "death_plateau_area" }, category = { "animal" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "black_knight_doorkeeper": {"page": "Black Knight doorkeeper", "first": "File:Black knight doorkeeper.png"}
    {
        id = "black_knight_doorkeeper", name = "Black Knight doorkeeper", rarity = "common",
        desc = "He didn't do his job well enough.",
        art = { npc = "VKQ2_DOORKEEPER_NPC", anim = 813, cam = { yaw = 0.34, pitch = 0.15, dist = 1383, fov = 31, ty = 480, near = 0.25 } },
        tags = { location = { "ice_mountain" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "black_knight_guard": {"page": "Black Knight guard", "resolved": "File:Black Knight guard.png"}
    {
        id = "black_knight_guard", name = "Black Knight guard", rarity = "common",
        desc = "An ever-vigilant Black Knight on watch for intruders.",
        art = { npc = "VKQ2_GUARD", anim = 813, cam = { yaw = 0.40, pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "black_knight_workshop" }, category = { "humanoid", "guard" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "black_lamb": {"page": "Black lamb", "resolved": "File:Lamb.png"}
    {
        id = "black_lamb", name = "Black Lamb", rarity = "common",
        desc = "The black sheep of the family.",
        art = { npc = "LAMB_BLACK", anim = 32255, cam = { yaw = 0.40, pitch = 0.15, dist = 566, ty = 120 } },
        tags = { location = { "lumbridge" }, category = { "animal" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "butterfly": {"page": "Butterfly", "resolved": "File:Butterfly (grey).png"}
    {
        id = "butterfly", name = "Butterfly", rarity = "common",
        desc = "These look much better in the wild.",
        art = { npc = "BUTTERFLY", anim = 362, cam = { pitch = 0.30, dist = 2297, fov = 35, ty = 940, tx = -70 } },
        tags = { category = { "insect" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "cabbage": {"page": "Cabbage (NPC)", "resolved": "File:Cabbage (NPC).png"}
    {
        id = "cabbage", name = "Cabbage", rarity = "uncommon",
        desc = "Cabbage... yuck! Fighting for the right to paaaaaaaaarty...hats.",
        art = { npc = "GOWER_CABBAGE_RECRUIT_MULTI", anim = 28888, cam = { yaw = 0.01, pitch = 0.30, dist = 1137, fov = 35, ty = 260 } },
        tags = { location = { "gower_farm", "behind_the_scenes_location" }, category = { "cabbage" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "cardinal": {"page": "Cardinal", "resolved": "File:Cardinal (blue).png"}
    {
        id = "cardinal", name = "Cardinal", rarity = "uncommon",
        desc = "A cardinal of the Church of Zaros.",
        art = { npc = "FOTG2_BETRAYAL_CARDINAL", anim = 18019, cam = { yaw = 0.20, dist = 860, fov = 30, ty = 642, tx = -14, near = 0.25 } },
        tags = { location = { "the_empty_throne_room" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "cave_bug_larva": {"page": "Cave bug larva", "resolved": "File:Cave bug larva.png"}
    {
        id = "cave_bug_larva", name = "Cave bug larva", rarity = "common",
        desc = "A little, slimy-beetle thing.",
        art = { npc = "CAVE_LITTLEBUG", anim = 1782, cam = { yaw = -0.75, pitch = 0.30, dist = 1137, fov = 24, ty = 93, tx = 1 } },
        tags = { location = { "lumbridge_swamp", "dorgesh_kaan" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "cleaner": {"page": "Cleaner", "resolved": "File:Cleaner.png"}
    {
        id = "cleaner", name = "Cleaner", rarity = "common",
        desc = "Does what too many people aren't interested in doing.",
        art = { npc = "FAI_VARROCK_CLEANER", anim = 12454, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "varrock" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "cleric_of_zamorak": {"page": "Cleric of Zamorak", "resolved": "File:Cleric of Zamorak.png"}
    {
        id = "cleric_of_zamorak", name = "Cleric of Zamorak", rarity = "common",
        desc = "An imposing cloaked figure flanks the altar.",
        art = { npc = "OWEN1_BKF_ZAMORAK_CLERIC_SOUTH", anim = 808, cam = { yaw = -0.31, pitch = 0.15, dist = 859, ty = 485, tx = 43, near = 0.50 } },
        tags = { location = { "black_knights_fortress" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "cook_troll": {"page": "Cook (troll)", "resolved": "File:Cook (troll).png"}
    {
        id = "cook_troll", name = "Cook (troll)", rarity = "common",
        desc = "Human is his speciality.",
        art = { npc = "TROLL_COOK", anim = 13794, cam = { pitch = 0.30, dist = 1504, fov = 35, ty = 465 } },
        tags = { location = { "troll_stronghold_area" }, category = { "troll" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "crablet": {"page": "Crablet", "resolved": "File:Crablet.png"}
    {
        id = "crablet", name = "Crablet", rarity = "common",
        desc = "A crab, native to the Wushanko Isles.",
        art = { npc = "ELR1_CRABLET_DEPLETED", anim = 29063, cam = { yaw = -0.26, pitch = 0.30, dist = 1137, fov = 51, ty = 256, tx = 20 } },
        tags = { location = { "uncharted_isles" }, category = { "animal" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "crow": {"page": "Crow", "resolved": "File:Crow (flying).png"}
    {
        id = "crow", name = "Crow", rarity = "common",
        desc = "A farmer's enemy.",
        art = { npc = "CROW", anim = 1825, cam = { yaw = -0.29, pitch = 0.30, dist = 2216, fov = 15, ty = 662, tx = -13 } },
        tags = { location = { "lumbridge", "draynor", "grim_reaper_s_citadel" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "crux_eqal_knight_senntisten": {"page": "Crux Eqal knight (Senntisten)", "resolved": "File:Crux Eqal knight (Senntisten, 12).png", "first": "File:Crux Eqal knight (Senntisten, 1).png"}
    {
        id = "crux_eqal_knight_senntisten", name = "Crux Eqal knight (Senntisten)", rarity = "common",
        desc = "A knight of the Crux Eqal.",
        art = { npc = "EGWD_CITY_GUTHIX_IDLE_DEFENDER_M_W", anim = 18019, cam = { yaw = 0.40, pitch = 0.15, dist = 1136, ty = 420, near = 0.25 } },
        tags = { location = { "senntisten" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dark_wizard_elijah": {"page": "Dark Wizard Elijah", "resolved": "File:Elijah.png"}
    {
        id = "dark_wizard_elijah", name = "Dark Wizard Elijah", rarity = "uncommon",
        desc = "A suspicious-looking fellow.",
        art = { npc = "PNR_WIZARD", anim = 808, cam = { yaw = 0.20, dist = 860, fov = 30, ty = 600, near = 0.50 } },
        tags = { category = { "humanoid", "wizard" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "dead_archaeologist": {"page": "Dead archaeologist", "resolved": "File:Dead archaeologist (3).png", "first": "File:Dead archaeologist (1).png"}
    {
        id = "dead_archaeologist", name = "Dead archaeologist", rarity = "common",
        desc = "A former archaeologist of the Archaeology Guild.",
        art = { npc = "QUEST_ZAMORAK_DEAD_ARCHAEOLOGIST_3", anim = 12745, cam = { yaw = 0.33, pitch = 1.19, dist = 859, ty = 53, tx = 27, near = 0.25 } },
        tags = { location = { "dungeon_of_disorder" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "didymus_the_lorehound": {"page": "Didymus the Lorehound (NPC)", "resolved": "File:Didymus the Lorehound.png"}
    {
        id = "didymus_the_lorehound", name = "Didymus the Lorehound", rarity = "common",
        desc = "A very good Lorehound.",
        art = { npc = "QPS_HUB_LOREHOUND", anim = 32307, cam = { yaw = -0.65, pitch = 0.30, dist = 1831, fov = 22, ty = 228, tx = 47, near = 0.25 } },
        tags = { location = { "varrock", "may_s_quest_caravan" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "dig_site_worker": {"page": "Dig Site worker", "resolved": "File:Manual Auto-cycle (worker).png"}
    {
        id = "dig_site_worker", name = "Dig Site worker", rarity = "common",
        desc = "He alternates between leg day and transmute day.",
        art = { npc = "FOTG2_DIGSITE_AGILITOR", anim = 29610, cam = { yaw = -0.84, pitch = 0.15, dist = 859, ty = 1105, tx = -112, near = 0.25 } },
        tags = { location = { "the_empty_throne_room" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dog": {"page": "Dog (NPC)", "resolved": "File:Dog (NPC).png"}
    {
        id = "dog", name = "Dog", rarity = "common",
        desc = "Bow wow.",
        art = { npc = "DOG", anim = 15240, cam = { yaw = 0.60, pitch = 0.18, dist = 1458, fov = 29, ty = 167, tx = 4 } },
        tags = { location = { "falador" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "duck_on_a_cart": {"page": "Duck on a Cart", "resolved": "File:Duck on a Cart.png"}
    {
        id = "duck_on_a_cart", name = "Duck on a Cart", rarity = "uncommon",
        desc = "This duck has conquered this cart.",
        art = { npc = "QUEST_GOWER_DUCK_ON_A_CART", anim = 6818, cam = { yaw = -0.86, pitch = 0.30, dist = 1137, fov = 20, ty = 62, tx = -30 } },
        tags = { location = { "behind_the_scenes_location" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dung": {"page": "Dung", "resolved": "File:Dung.png"}
    {
        id = "dung", name = "Dung", rarity = "uncommon",
        desc = "Human is his specialty.",
        art = { npc = "DEATH_TROLL_COOK1", anim = 13794, cam = { pitch = 0.30, dist = 1504, fov = 42, ty = 465 } },
        tags = { location = { "death_plateau_location" }, category = { "troll" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "dwarve_miner_empty_throne": {"page": "Dwarven miner (The Empty Throne Room)", "resolved": "File:Dwarven miner (The Empty Throne Room, south).png", "first": "File:Dwarven miner (The Empty Throne Room, north).png"}
    {
        id = "dwarve_miner_empty_throne", name = "Dwarve miner (Empty Throne)", rarity = "common",
        desc = "They've been sent by Doric & Son to help with clearing the site.",
        art = { npc = "FOTG2_DIGSITE_MINER_2", anim = 101, cam = { yaw = -0.20, dist = 859, fov = 40, ty = 240 } },
        tags = { location = { "the_empty_throne_room" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dwarven_ancestor": {"page": "Dwarven ancestor", "resolved": "File:Dwarven ancestor.png"}
    {
        id = "dwarven_ancestor", name = "Dwarven ancestor", rarity = "common",
        desc = "An ancient dwarven spirit has risen to animate your burial.",
        art = { npc = "ARTISAN_BURIAL_GHOST", anim = 51, cam = { yaw = -0.20, pitch = 0.19, dist = 1469, fov = 28, ty = 320, tx = 10, near = 0.25 } },
        tags = { location = { "artisans_workshop" }, category = { "dwarf_spirit" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "elven_knight": {"page": "Elven Knight", "resolved": "File:Elven Knight (standing, 1).png", "first": "File:Elven knight (sitting, 1).png"}
    {
        id = "elven_knight", name = "Elven knight", rarity = "common",
        desc = "A knight of Seren.",
        art = { npc = "EGWD_CITY_IORWERTH_DEFENDER_M_S", anim = 37643, cam = { yaw = -0.69, pitch = 0.15, dist = 1136, ty = 420 } },
        tags = { location = { "senntisten", "glacor_front" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "engineer": {"page": "Engineer", "resolved": "File:Engineer.png"}
    {
        id = "engineer", name = "Engineer", rarity = "common",
        desc = "He's building a cannon.",
        art = { npc = "FAI_DWARF_WORKER_HAMMER", anim = 17844, cam = { yaw = -0.20, dist = 566, ty = 340, near = 0.25 } },
        tags = { location = { "dwarven_mine" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "engineering_assistant": {"page": "Engineering assistant", "resolved": "File:Engineering assistant.png"}
    {
        id = "engineering_assistant", name = "Engineering assistant", rarity = "common",
        desc = "He's wandering around aimlessly with a box of spare parts.",
        art = { npc = "FAI_DWARF_WORKER_PATROL_01", anim = 3207, cam = { yaw = -0.75, dist = 1469, fov = 28, ty = 325, tx = -18, near = 0.25 } },
        tags = { location = { "dwarven_mine" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "fairy_doctor": {"page": "Fairy doctor", "resolved": "File:Fairy Nuff.png"}
    {
        id = "fairy_doctor", name = "Fairy doctor", rarity = "common",
        desc = "A fairy trained in the healing arts.",
        art = { npc = "FT3_FAIRY_DOCTOR", anim = 793, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 604 } },
        tags = { location = { "zanaris" }, category = { "fairy" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "fairy_stitcher": {"page": "Fairy stitcher", "resolved": "File:Fairy stitcher.png"}
    {
        id = "fairy_stitcher", name = "Fairy stitcher", rarity = "common",
        desc = "Rather then weaving or casting magic, she stitches it.",
        art = { npc = "FT3_FAIRY_STITCHER_1", anim = 793, cam = { yaw = -0.28, pitch = 0.30, dist = 1137, fov = 35, ty = 599, tx = 48 } },
        tags = { location = { "ork_s_rift" }, category = { "fairy" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "fairy_tooth_farmer": {"page": "Fairy tooth farmer", "resolved": "File:Fairy tooth farmer.png"}
    {
        id = "fairy_tooth_farmer", name = "Fairy tooth farmer", rarity = "common",
        desc = "A fairy focused on farming teeth.",
        art = { npc = "FT3_TOOTH_FARMER", anim = 793, cam = { yaw = 0.37, pitch = 0.30, dist = 1376, fov = 35, ty = 628, tx = -57 } },
        tags = { location = { "zanaris" }, category = { "fairy" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "farmer_taverley": {"page": "Farmer (Taverley)", "resolved": "File:Farmer (Taverley, rake).png"}
    {
        id = "farmer_taverley", name = "Farmer (Taverley)", rarity = "common",
        desc = "He's a cider drinker.",
        art = { npc = "OMGE_FARMER01", anim = 15850, cam = { yaw = 0.05, pitch = 0.15, dist = 5254, fov = 10, ty = 480, near = 0.25 } },
        tags = { location = { "taverley" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "farmer_varrock": {"page": "Farmer (Varrock)", "resolved": "File:Farmer (Varrock).png"}
    {
        id = "farmer_varrock", name = "Farmer (Varrock)", rarity = "common",
        desc = "Farming.",
        art = { npc = "FARMER_FARMING", anim = 3269, cam = { yaw = -0.46, pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "varrock" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "farmer_vinesweeper": {"page": "Farmer (Vinesweeper)", "resolved": "File:Farmer (Vinesweeper, 1).png"}
    {
        id = "farmer_vinesweeper", name = "Farmer (Vinesweeper)", rarity = "common",
        desc = "A gnome farmer.",
        art = { npc = "RABBIT_NPC_FARMER01", anim = 1214, cam = { yaw = -0.20, dist = 566, ty = 340 } },
        tags = { location = { "vinesweeper" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "fenton": {"page": "Fenton", "resolved": "File:Fenton.png"}
    {
        id = "fenton", name = "Fenton", rarity = "common",
        desc = "A very good boy. A good dog. 14/10.",
        art = { npc = "QPS_HUB_DOG_FENTON", anim = 32307, cam = { yaw = -0.67, pitch = 0.30, dist = 1137, fov = 35, ty = 191, tx = 24, near = 0.25 } },
        tags = { location = { "varrock", "may_s_quest_caravan" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "fermit": {"page": "Fermit", "resolved": "File:Fermit.png"}
    {
        id = "fermit", name = "Fermit", rarity = "common",
        desc = "Just hop hop hopping around Paddlington.",
        art = { npc = "QUEST_DUCK_INHABITANT_FROG_3", anim = 32936, cam = { pitch = 0.30, dist = 3568, fov = 5, ty = 81, tx = 5, near = 0.25 } },
        tags = { location = { "paddlington" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/tirannwn.lua; wiki_pages.json: "firefly_the_lost_grove": {"page": "Firefly (The Lost Grove)"}
    {
        id = "firefly_the_lost_grove", name = "Firefly (The Lost Grove)", rarity = "common",
        desc = "Mysterious lights.",
        art = { npc = "NATURE_BEINGS_FIREFLY_BLUE", anim = 7068, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 800 } },
        tags = { location = { "the_lost_grove", "piscatoris_hunter_area" }, category = { "insect" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "foo_lion": {"page": "Foo lion", "resolved": "File:Foo lion.png"}
    {
        id = "foo_lion", name = "Foo lion", rarity = "common",
        desc = "A guardian lion native to the Eastern Lands.",
        art = { npc = "ELR1_INTERACT_SUMMONING", anim = 19297, cam = { yaw = -0.67, pitch = 0.17, dist = 1137, fov = 35, ty = 260, near = 0.25 } },
        tags = { location = { "uncharted_isles", "the_arc" }, category = { "foo_lion" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "frog_makeover_mage": {"page": "Frog (Makeover Mage)", "resolved": "File:Frog (Makeover Mage).png"}
    {
        id = "frog_makeover_mage", name = "Frog (Makeover Mage)", rarity = "common",
        desc = "Didn't the mage say this procedure was totally safe?",
        art = { npc = "MAKEOVER_MAGE_FROG", anim = 1796, cam = { yaw = -0.40, pitch = 0.30, dist = 988, fov = 20, ty = 40 } },
        tags = { location = { "makeover_mage" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "giant_spider_closures_study": {"page": "Giant spider (Closure's study)", "resolved": "File:Giant spider (Closure's study).png"}
    {
        id = "giant_spider_closures_study", name = "Giant spider (Closure's study)", rarity = "common",
        desc = "I think this spider has been magically modified.",
        art = { npc = "MINIQUEST_OUT1_SPIDER_CRITTER", anim = 5326, cam = { yaw = -0.22, pitch = 0.30, dist = 748, fov = 48, ty = 40 } },
        tags = { location = { "closure_s_study" }, category = { "insect" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "goblin_fish": {"page": "Goblin fish", "resolved": "File:Goblin fish.png"}
    {
        id = "goblin_fish", name = "Goblin fish", rarity = "common",
        desc = "A bug-eyed little goblin fish. How cute.",
        art = { npc = "DORGESH_GOBLIN_FISH", anim = 6062, cam = { yaw = -0.27, pitch = 0.30, dist = 1137, fov = 35, ty = 220 } },
        tags = { location = { "dorgesh_kaan" }, category = { "animal" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "grant": {"page": "Grant", "resolved": "File:Grant.png"}
    {
        id = "grant", name = "Grant", rarity = "common",
        desc = "Looks like he's had one too many.",
        art = { npc = "NECRO_HUB_SKELETON_DRUNK_1", anim = 3040, cam = { yaw = -0.02, pitch = 0.30, dist = 1831, fov = 26, ty = 368, tx = 5 } },
        tags = { location = { "the_last_call", "city_of_um" }, category = { "undead" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "grapefruit": {"page": "Grapefruit", "resolved": "File:Grapefruit.png"}
    {
        id = "grapefruit", name = "Grapefruit", rarity = "rare",
        desc = "Also known as Grawnffrwyth to his friends.",
        art = { npc = "SLAYER_ABYSSAL_GRAPEFRUIT", anim = 24429, cam = { pitch = 0.30, dist = 1308, fov = 35, ty = 320 } },
        tags = { location = { "prifddinas" }, category = { "chthonian" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "gublinch_jailmate": {"page": "Gublinch jailmate", "resolved": "File:Gublinch jailmate (tackling door).png"}
    {
        id = "gublinch_jailmate", name = "Gublinch jailmate", rarity = "common",
        desc = "An imprisoned gublinch.",
        art = { npc = "SOPS_PRISONER_5_CHARGING_AT_BARS", anim = 8775, cam = { yaw = -1.37, pitch = 0.30, dist = 2971, fov = 19, ty = 224, tx = 41, near = 0.25 } },
        tags = { location = { "stronghold_of_player_safety" }, category = { "gublinch" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "gublinchette_jailmate": {"page": "Gublinchette jailmate", "resolved": "File:Gublinchette jailmate (rattling cup).png", "first": "File:Gublinchette jailmate (sitting).png"}
    {
        id = "gublinchette_jailmate", name = "Gublinchette jailmate", rarity = "common",
        desc = "An imprisoned gublinch.",
        art = { npc = "SOPS_PRISONER_3_CLINKING_CUP", anim = 8773, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 196, tx = -148 } },
        tags = { location = { "stronghold_of_player_safety" }, category = { "gublinch" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "ham_deacon": {"page": "H.A.M. Deacon", "resolved": "File:H.A.M. Deacon.png"}
    {
        id = "ham_deacon", name = "H.A.M. Deacon", rarity = "uncommon",
        desc = "A deacon in the Humans Against Monsters group.",
        art = { npc = "FAVOUR_DEACON", anim = 1670, cam = { yaw = -0.21, dist = 860, fov = 30, ty = 600, near = 0.25 } },
        tags = { location = { "h_a_m_hideout" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "jeremy_clerksin": {"page": "Jeremy Clerksin", "resolved": "File:Jeremy Clerksin.png"}
    {
        id = "jeremy_clerksin", name = "Jeremy Clerksin", rarity = "common",
        desc = "Rather more tired than most.",
        art = { npc = "ROMEO_JULIET_PEW_SLEEPING_MAN", anim = 3282, cam = { yaw = 2.00, dist = 1306, fov = 20, ty = 440, tx = -30 } },
        tags = { location = { "varrock" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "kelavan_the_red": {"page": "Kelavan the Red", "resolved": "File:Kelavan the Red.png"}
    {
        id = "kelavan_the_red", name = "Kelavan the Red", rarity = "uncommon",
        desc = "An apprentice of the Red Order.",
        art = { npc = "ARIANE2_KELAVAN_LIBRARY", anim = 18910, cam = { yaw = -0.43, dist = 860, fov = 30, ty = 488, tx = 28, near = 0.50 } },
        tags = { location = { "wizards_tower" }, category = { "humanoid", "wizard" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "lieutenant_sutcliffe": {"page": "Lieutenant Sutcliffe", "resolved": "File:Lieutenant Sutcliffe.png"}
    {
        id = "lieutenant_sutcliffe", name = "Lieutenant Sutcliffe", rarity = "uncommon",
        desc = "A Black Knight with lots of combat experience.",
        art = { npc = "MINIQUEST_OUT4_ELITE_BLACK_KNIGHT", anim = 18019, cam = { yaw = 0.20, dist = 860, fov = 30, ty = 642, tx = 17, near = 0.25 } },
        tags = { location = { "black_knights_fortress" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "lil_lamb": {"page": "Li'l lamb", "resolved": "File:Li'l lamb.png"}
    {
        id = "lil_lamb", name = "Li'l lamb", rarity = "common",
        desc = "How cute!",
        art = { npc = "LAMB", anim = 32255, cam = { pitch = 0.30, dist = 861, fov = 35, ty = 160 } },
        tags = { regions = { "asgarnia" }, location = { "lumbridge", "makeover_mage" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "lumbridge_captain": {"page": "Lumbridge Captain", "resolved": "File:Lumbridge Captain.png"}
    {
        id = "lumbridge_captain", name = "Lumbridge Captain", rarity = "uncommon",
        desc = "Captain of the Lumbridge Guards",
        art = { npc = "EGWD_CITY_LUMBRIDGE_CAPTAIN", anim = 19171, cam = { yaw = -2.01, dist = 1676, fov = 20, ty = 595, tx = -44, near = 0.25 } },
        tags = { location = { "senntisten", "croesus_front" }, category = { "humanoid", "guard" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "lumbridge_guard_dog": {"page": "Lumbridge guard dog", "resolved": "File:Lumbridge guard dog.png"}
    {
        id = "lumbridge_guard_dog", name = "Lumbridge guard dog", rarity = "common",
        desc = "A guard dog trained to protect Lumbridge.",
        art = { npc = "FAI_LUMBRIDGE_GUARD_DOG_IDLE", anim = 24187, cam = { yaw = 0.60, dist = 905, fov = 35, ty = 225, tx = 73 } },
        tags = { category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "lumbridge_guard_senntisten": {"page": "Lumbridge Guard (Senntisten)", "resolved": "File:Lumbridge Guard (Senntisten, 6).png", "first": "File:Lumbridge Guard (Senntisten, 1).png"}
    {
        id = "lumbridge_guard_senntisten", name = "Lumbridge Guard (Senntisten)", rarity = "common",
        desc = "Defenders representing Lumbridge.",
        art = { npc = "EGWD_CITY_LUMBRIDGE_DEFENDER_M_E", anim = 37643, cam = { yaw = -0.49, pitch = 0.15, dist = 859, ty = 480, near = 0.25 } },
        tags = { location = { "senntisten", "croesus_front" }, category = { "humanoid", "guard" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "man_lumbridge_market": {"page": "Man (Lumbridge Market)", "resolved": "File:Man (Lumbridge Market, Talking).png"}
    {
        id = "man_lumbridge_market", name = "Man (Lumbridge Market)", rarity = "common",
        desc = "Deep in conversation.",
        art = { npc = "LUMBRIDGE_MARKET_MAN1", anim = 27476, cam = { yaw = 2.40, dist = 1130, fov = 30, ty = 600, near = 0.25 } },
        tags = { location = { "lumbridge" }, skills = { "thieving" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "martina_scorsby": {"page": "Martina Scorsby", "resolved": "File:Martina Scorsby.png"}
    {
        id = "martina_scorsby", name = "Martina Scorsby", rarity = "common",
        desc = "A less enthusiastic ecclesiastic woman, she seems slightly tired.",
        art = { npc = "ROMEO_JULIET_PEW_SLEEPING_WOMAN", anim = 3281, cam = { yaw = 4.60, dist = 494, fov = 40, ty = 500, tx = 30 } },
        tags = { location = { "varrock" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "mei_the_grey": {"page": "Mei the Grey", "resolved": "File:Mei the Grey.png"}
    {
        id = "mei_the_grey", name = "Mei the Grey", rarity = "uncommon",
        desc = "An apprentice of the Grey Order.",
        art = { npc = "ARIANE2_MEI_LIBRARY", anim = 18910, cam = { yaw = 0.32, dist = 860, fov = 30, ty = 488, tx = -7, near = 0.25 } },
        tags = { location = { "wizards_tower" }, category = { "humanoid", "wizard" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "merchant": {"page": "Merchant (Lumbridge Market)", "resolved": "File:Merchant (Lumbridge Market) (Vegetable Stalls).png"}
    {
        id = "merchant", name = "Merchant (Lumbridge Market)", rarity = "common",
        desc = "An opportunistic merchant.",
        art = { npc = "OMGE_MARKET_SELLER01", anim = 808, cam = { yaw = -0.20, pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "moths_dorgeshkaan": {"page": "Moths (Dorgesh-Kaan)", "resolved": "File:Moths (Dorgesh-Kaan).png"}
    {
        id = "moths_dorgeshkaan", name = "Moths (Dorgesh-Kaan)", rarity = "common",
        desc = "Annoying little flappy things.",
        art = { npc = "DORGESH_MOTHS", anim = 6036, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } },
        tags = { location = { "dorgesh_kaan" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "neds_wife": {"page": "Ned's wife", "resolved": "File:Ned's wife.png"}
    {
        id = "neds_wife", name = "Ned's wife", rarity = "common",
        desc = "She looks weary.",
        art = { npc = "BUILD_IMP_DRAYNOR_NEDS_WIFE", anim = 808, cam = { pitch = 0.15, dist = 548, ty = 580 } },
        tags = { location = { "draynor" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "nilrem": {"page": "Nilrem", "resolved": "File:Nilrem.png"}
    {
        id = "nilrem", name = "Nilrem", rarity = "uncommon",
        desc = "A powerful Draziw.",
        art = { npc = "MINIQUEST_OUT2_MEMORY_1_NILREM", anim = 813, cam = { pitch = 0.30, dist = 1504, fov = 35, ty = 487, tx = 50 } },
        tags = { location = { "camelot" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "nodon_commander": {"page": "Nodon commander", "resolved": "File:Nodon commander.png"}
    {
        id = "nodon_commander", name = "Nodon commander", rarity = "rare",
        desc = "A heavily armoured dragonkin.",
        art = { npc = "EGWD_CITY_NODON_ATTACKER_COMMANDER", anim = 34224, cam = { pitch = 0.30, dist = 2014, fov = 35, ty = 648, tx = -38, near = 0.25 } },
        tags = { location = { "senntisten", "elder_god_wars_dungeon", "nodon_front" }, category = { "dragonkin" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "nodon_grunt": {"page": "Nodon grunt", "resolved": "File:Nodon grunt.png"}
    {
        id = "nodon_grunt", name = "Nodon grunt", rarity = "common",
        desc = "Deep in the focus of battle.",
        art = { npc = "EGWD_JAS_SLAYER_NODON_GRUNT", anim = 34224, cam = { yaw = 0.20, pitch = 0.30, dist = 1665, fov = 42, ty = 537, tx = 77 } },
        tags = { location = { "senntisten", "elder_god_wars_dungeon", "nodon_front" }, category = { "dragonkin" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "panning_archaeologist": {"page": "Panning archaeologist (female)", "resolved": "File:Panning archaeologist (female).png"}
    {
        id = "panning_archaeologist", name = "Panning archaeologist", rarity = "common",
        desc = "Taking a break from panning.",
        art = { npc = "QIP_DIGSITE_PANNING_WOMAN_01", anim = 18019, cam = { yaw = 0.40, pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "archaeology_campus" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "perien_the_blue": {"page": "Perien the Blue", "resolved": "File:Perian the Blue.png"}
    {
        id = "perien_the_blue", name = "Perien the Blue", rarity = "uncommon",
        desc = "An apprentice of the Blue Order.",
        art = { npc = "ARIANE2_PERIEN_LIBRARY", anim = 18910, cam = { yaw = 0.47, dist = 860, fov = 30, ty = 502, tx = -17, near = 0.25 } },
        tags = { location = { "wizards_tower" }, category = { "humanoid", "wizard" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "phantom_cocktail": {"page": "Phantom cocktail", "resolved": "File:Phantom cocktail.png"}
    {
        id = "phantom_cocktail", name = "Phantom cocktail", rarity = "common",
        desc = "Show-off.",
        art = { npc = "NECRO_HUB_PHANTOM_COCKTAIL", anim = 32056, cam = { yaw = 0.31, pitch = 0.30, dist = 1665, fov = 35, ty = 508, tx = 6 } },
        tags = { location = { "the_last_call", "city_of_um" }, category = { "undead" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "piglet": {"page": "Piglet", "resolved": "File:Piglet.png"}
    {
        id = "piglet", name = "Piglet", rarity = "common",
        desc = " I shall name him, Mini Pig.",
        art = { npc = "PIGLET_2", anim = 279, cam = { yaw = 0.59, pitch = 0.30, dist = 1137, fov = 35, ty = 139, tx = -33 } },
        tags = { location = { "draynor" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "pigzilla": {"page": "Pigzilla", "resolved": "File:Pigzilla.png"}
    {
        id = "pigzilla", name = "Pigzilla", rarity = "uncommon",
        desc = "Known in the eastern lands as the legendary Butakujira.",
        art = { npc = "PIGZILLA", anim = 247, cam = { yaw = -0.40, pitch = 0.30, dist = 1504, fov = 35, ty = 300 } },
        tags = { location = { "draynor" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "plutonial_chinchompa": {"page": "Plutonial chinchompa", "resolved": "File:Plutonial chinchompa.png"}
    {
        id = "plutonial_chinchompa", name = "Plutonial chinchompa", rarity = "common",
        desc = "A very large chinchompa.",
        art = { npc = "BIGCHINCHOMPA", anim = 17336, cam = { yaw = -0.60, pitch = 0.30, dist = 3478, fov = 35, ty = 640 } },
        tags = { category = { "animal" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "potter": {"page": "Potter", "resolved": "File:Potter.png"}
    {
        id = "potter", name = "Potter", rarity = "common",
        desc = "He makes pots.",
        art = { npc = "BUILD_IMP_DRAYNOR_POTTER", anim = 8652, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "draynor" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "professor_archaeology_campus": {"page": "Professor (Archaeology Campus)", "resolved": "File:Professor (Archaeology).png"}
    {
        id = "professor_archaeology_campus", name = "Professor (Archaeology Campus)", rarity = "common",
        desc = "A professor of the Archaeology Guild.",
        art = { npc = "ARCH_PROFESSOR_ROAMING_1_M", anim = 18019, cam = { yaw = 0.20, dist = 860, fov = 30, ty = 600, near = 0.25 } },
        tags = { location = { "archaeology_campus" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "robbo": {"page": "Robbo"}
    {
        id = "robbo", name = "Robbo", rarity = "common",
        desc = "A ghostly impling.",
        art = { npc = "NECRO_HUB_GHOST_IMPLING", anim = 6613, cam = { pitch = 0.30, dist = 1137, fov = 24, ty = 808, tx = 26 } },
        tags = { location = { "city_of_um" }, category = { "impling" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "rowley": {"page": "Rowley"}
    {
        id = "rowley", name = "Rowley", rarity = "common",
        desc = "A friend of the owls.",
        art = { npc = "NECRO_HUB_OWL_RAT", anim = 35409, cam = { yaw = -0.61, pitch = 0.30, dist = 1137, fov = 35, ty = 220 } },
        tags = { location = { "owlery", "city_of_um" }, category = { "undead" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "seth": {"page": "Seth", "resolved": "File:Seth.png"}
    {
        id = "seth", name = "Seth", rarity = "common",
        desc = "Happily retired.",
        art = { npc = "NECRO_HUB_SKELETON_SEATED_1", anim = 34165, cam = { yaw = -0.33, pitch = 0.30, dist = 1137, fov = 35, ty = 383, tx = -38, near = 0.25 } },
        tags = { location = { "city_of_um" }, category = { "undead" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "skeleton_city_of_um": {"page": "Skeleton (City of Um)", "resolved": "File:Skeleton (City of Um, fishing).png"}
    {
        id = "skeleton_city_of_um", name = "Skeleton (City of Um)", rarity = "common",
        desc = "The life and soul of the City of Um.",
        art = { npc = "NECRO_HUB_SKELETON_1", anim = 31504, cam = { yaw = 0.44, pitch = 0.30, dist = 1513, fov = 35, ty = 445, tx = -105 } },
        tags = { location = { "city_of_um" }, category = { "undead" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "slime_mould": {"page": "Slime mould", "resolved": "File:Slime mould.png"}
    {
        id = "slime_mould", name = "Slime mould", rarity = "common",
        desc = "A clump of toxic slime.",
        art = { npc = "EGWD_BIK_BOSS_SLIME_CREATURE", anim = 34444, cam = { yaw = -0.74, pitch = 0.30, dist = 1137, fov = 35, ty = 220 } },
        tags = { location = { "croesus_front", "elder_god_wars_dungeon" }, category = { "fungus" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "swan": {"page": "Swan", "resolved": "File:Swan.png"}
    {
        id = "swan", name = "Swan", rarity = "common",
        desc = "A graceful bird.",
        art = { npc = "SWAN", anim = 3242, cam = { yaw = 1.00, pitch = 0.30, dist = 1137, fov = 35, ty = 160 } },
        tags = { location = { "falador" }, category = { "animal" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "thomas": {"page": "Thomas", "resolved": "File:Thomas.png"}
    {
        id = "thomas", name = "Thomas", rarity = "common",
        desc = "A retired adventurer.",
        art = { npc = "VARROCK_THOMAS_MEMORY", anim = 19169, cam = { yaw = 0.40, dist = 860, fov = 25, ty = 600, tx = -50 } },
        tags = { location = { "blue_moon_inn", "varrock" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "trainee": {"page": "Trainee", "resolved": "File:Trainee.png"}
    {
        id = "trainee", name = "Trainee", rarity = "common",
        desc = "An aspiring archaeologist.",
        art = { npc = "ARCH_TRAINEE_ROAMING_1_F", anim = 18019, cam = { yaw = -0.31, pitch = 0.15, dist = 859, ty = 480, near = 0.25 } },
        tags = { regions = { "morytania" }, location = { "archaeology_campus", "everlight" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "trainee_guard": {"page": "Trainee Guard", "resolved": "File:Trainee Guard.png"}
    {
        id = "trainee_guard", name = "Trainee Guard", rarity = "common",
        desc = "He's studying to be a guard.",
        art = { npc = "FAI_VARROCK_GUARD_TRAINING", anim = 37632, cam = { pitch = 0.15, dist = 859, ty = 440, tx = 50 } },
        tags = { location = { "varrock" }, category = { "humanoid", "guard" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "undead_cow": {"page": "Undead cow (Flashback)", "resolved": "File:Undead cow (Flashback).png"}
    {
        id = "undead_cow", name = "Undead cow", rarity = "common",
        desc = "It's an undead cow.",
        art = { npc = "MINIQUEST_OUT2_MEMORY_2_COW", anim = 22122, cam = { yaw = -0.80, pitch = 0.30, dist = 1665, fov = 36, ty = 260, tx = 128, near = 0.25 } },
        tags = { location = { "draynor" }, category = { "undead_cow" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "undead_crux_eqal_knight": {"page": "Undead Crux Eqal knight", "resolved": "File:Undead Crux Eqal knight (1).png"}
    {
        id = "undead_crux_eqal_knight", name = "Undead Crux Eqal knight", rarity = "common",
        desc = "Unsettling.",
        art = { npc = "EGWD_CITY_ZOMBIE_GUTHIX_DEFENDER_M_N", anim = 34548, cam = { pitch = 0.30, dist = 1137, fov = 42, ty = 378, tx = -5, near = 0.25 } },
        tags = { location = { "tzekhaar_front", "elder_god_wars_dungeon" }, category = { "undead" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "undead_elven_knight": {"page": "Undead Elven Knight", "resolved": "File:Undead Elven Knight (1).png"}
    {
        id = "undead_elven_knight", name = "Undead Elven Knight", rarity = "common",
        desc = "He's dead!",
        art = { npc = "EGWD_CITY_ZOMBIE_CADARN_DEFENDER_M_N", anim = 29588, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 426, tx = -53, near = 0.25 } },
        tags = { location = { "tzekhaar_front", "elder_god_wars_dungeon" }, category = { "zombie_elf" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "undead_temple_knight": {"page": "Undead Temple Knight", "resolved": "File:Undead Temple Knight (1).png"}
    {
        id = "undead_temple_knight", name = "Undead Temple Knight", rarity = "common",
        desc = "Not great at small talk.",
        art = { npc = "EGWD_CITY_ZOMBIE_ZAROS_DEFENDER_M_N", anim = 34549, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 454, tx = 19, near = 0.25 } },
        tags = { location = { "tzekhaar_front", "elder_god_wars_dungeon" }, category = { "undead" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "varrock_captain": {"page": "Varrock Captain", "resolved": "File:Varrock Captain.png"}
    {
        id = "varrock_captain", name = "Varrock Captain", rarity = "uncommon",
        desc = "Captain of the Varrock Guards.",
        art = { npc = "EGWD_CITY_VARROCK_CAPTAIN", anim = 19172, cam = { yaw = 0.20, dist = 1306, fov = 25, ty = 600, near = 0.25 } },
        tags = { location = { "senntisten", "croesus_front", "elder_god_wars_dungeon" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "varrock_guard_senntisten": {"page": "Varrock Guard (Senntisten)", "resolved": "File:Varrock Guard (Senntisten, 6).png", "first": "File:Varrock Guard (Senntisten, 1).png"}
    {
        id = "varrock_guard_senntisten", name = "Varrock Guard (Senntisten)", rarity = "common",
        desc = "Defenders representing Varrock.",
        art = { npc = "EGWD_CITY_VARROCK_DEFENDER_F_E", anim = 37633, cam = { yaw = -0.31, pitch = 0.15, dist = 859, ty = 480, near = 0.25 } },
        tags = { location = { "senntisten", "croesus_front", "elder_god_wars_dungeon" }, category = { "humanoid", "guard" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "zombie_city_of_um": {"page": "Zombie (City of Um)", "resolved": "File:Zombie (City of Um, female).png"}
    {
        id = "zombie_city_of_um", name = "Zombie (City of Um)", rarity = "common",
        desc = "The life and soul of the City of Um.",
        art = { npc = "NECRO_HUB_ZOMBIE_1", anim = 35252, cam = { yaw = -0.18, pitch = 0.30, dist = 744, fov = 55, ty = 420 } },
        tags = { location = { "city_of_um" }, category = { "undead" }, membership = { "f2p" } },
    },
    -- Only in a quest, or its own version for a quest (SKIPPED_QUEST_ONLY)
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "alan": {"page": "Alan (Evil Dave's Big Day Out)", "resolved": "File:Hell-Rat.png"}
    {
        id = "alan", name = "Alan", rarity = "uncommon",
        desc = "Usually found shouting and angry at everything he comes across.",
        art = { npc = "DAVE_HELLRAT_TASKFORCE_ALAN", anim = 31271, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 108, tx = -22 } },
        tags = { location = { "basement_of_doom" }, category = { "hell_rat" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "apropos": {"page": "Apropos (Gower Quest)", "resolved": "File:Apropos (Gower Quest).png"}
    {
        id = "apropos", name = "Apropos", rarity = "uncommon",
        desc = "An ancient Dragon Rider.",
        art = { npc = "GOWER_APROPOS", anim = 22802, cam = { yaw = 0.42, pitch = 0.30, dist = 1137, fov = 35, ty = 352, near = 0.25 } },
        tags = { location = { "behind_the_scenes_location" }, category = { "ilujanka" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "archer": {"page": "Archer (Lost City)", "resolved": "File:Archer (Lost City).png"}
    {
        id = "archer", name = "Archer", rarity = "uncommon",
        desc = "She looks quite experienced.",
        art = { npc = "LOST_CITY_ARCHER_ADVENTURERPG", anim = 18061, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600, near = 0.25 } },
        tags = { location = { "lumbridge_swamp" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "assassin_fort": {"page": "Assassin (Murder on the Border)", "resolved": "File:Assassin (Murder on the Border).png"}
    {
        id = "assassin_fort", name = "Assassin (Fort)", rarity = "uncommon",
        desc = "Entered the fort disguised as part of King Roald's entourage.",
        art = { npc = "QUEST_FORT_ASSASSIN", anim = 37632, cam = { yaw = -0.49, dist = 860, fov = 40, ty = 457, tx = 6 } },
        tags = { category = { "humanoid", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "bandosian_golem": {"page": "Bandosian golem (Nomad's Elegy)", "resolved": "File:Bandosian golem (Nomad's Elegy).png"}
    {
        id = "bandosian_golem", name = "Bandosian golem", rarity = "common",
        desc = "A huge construct built to smite the foes of Bandos.",
        art = { npc = "QUEST_NOMEL_BH_WAVE12", anim = 22280, cam = { yaw = -0.56, pitch = 0.30, dist = 2516, fov = 35, ty = 595, tx = 10, near = 0.25 } },
        tags = { category = { "construct", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "black_knight_death_of_chivalry": {"page": "Black Knight (The Death of Chivalry)", "resolved": "File:Black Knight.png"}
    {
        id = "black_knight_death_of_chivalry", name = "Black Knight (Death of Chivalry)", rarity = "common",
        desc = "A dark-hearted knight.",
        art = { npc = "OWEN1_CAMPSITE_BLACK_KNIGHT_1A", anim = 37632, cam = { yaw = -0.29, pitch = 0.15, dist = 1136, ty = 420 } },
        tags = { category = { "humanoid", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "brana": {"page": "Brana", "resolved": "File:Brana.png"}
    {
        id = "brana", name = "Brana", rarity = "uncommon",
        desc = "An old man.",
        art = { npc = "SOULBANE_BRANA", anim = 813, cam = { yaw = -0.24, dist = 860, fov = 30, ty = 600, near = 0.25 } },
        tags = { location = { "tolna_s_rift" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "charlie": {"page": "Charlie (Violet is Blue)", "resolved": "File:Charlie (Violet is Blue).png"}
    {
        id = "charlie", name = "Charlie", rarity = "uncommon",
        desc = "He's ready to save the day!",
        art = { npc = "XMAS18_QUEST_YETI_CHILD_1", anim = 32508, cam = { yaw = -0.26, pitch = 0.30, dist = 1513, fov = 26, ty = 327, tx = 5, near = 0.25 } },
        tags = { location = { "land_of_snow" }, category = { "yeti" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "chris": {"page": "Chris (Evil Dave's Big Day Out)", "resolved": "File:Chris (Evil Dave's Big Day Out).png"}
    {
        id = "chris", name = "Chris", rarity = "uncommon",
        desc = "He's been standing there for a long time.",
        art = { npc = "DAVE_EXCHANGE_BANKER_MALE_SOUTH", anim = 9664, cam = { yaw = 0.20, dist = 860, fov = 30, ty = 600, near = 0.25 } },
        tags = { location = { "grand_exchange" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "crassian_scout": {"page": "Crassian scout (Curse of the Black Stone)", "resolved": "File:Crassian scout (Curse of the Black Stone).png"}
    {
        id = "crassian_scout", name = "Crassian scout", rarity = "uncommon",
        desc = "A hideous crab-like creature.",
        art = { npc = "QUEST_ELITEDUNGEONS_GOSHIMA_CRASSIAN_SCOUT", anim = 23340, cam = { yaw = -0.40, pitch = 0.30, dist = 1137, fov = 55, ty = 300 } },
        tags = { regions = { "wilderness" }, category = { "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "crassian_warrior": {"page": "Crassian warrior (Curse of the Black Stone)", "resolved": "File:Crassian warrior (Curse of the Black Stone).png"}
    {
        id = "crassian_warrior", name = "Crassian warrior", rarity = "uncommon",
        desc = "A powerful crab-like creature.",
        art = { npc = "QUEST_ELITEDUNGEONS_GOSHIMA_CRASSIAN_WARRIOR", anim = 23327, cam = { pitch = 0.30, dist = 2226, fov = 30, ty = 380, near = 0.25 } },
        tags = { regions = { "wilderness" }, category = { "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "customs_officer": {"page": "Customs Officer (Rocking Out)", "resolved": "File:Customs Officer (Rocking Out).png"}
    {
        id = "customs_officer", name = "Customs Officer", rarity = "uncommon",
        desc = "Inspects people's packages.",
        art = { npc = "ROCKO_CUSTOMS_OFFICER_FEMALE", anim = 808, cam = { yaw = 0.20, dist = 860, fov = 30, ty = 600, near = 0.25 } },
        tags = { category = { "humanoid", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "darren": {"page": "Darren (Evil Dave's Big Day Out)", "resolved": "File:Hell-Rat.png"}
    {
        id = "darren", name = "Darren", rarity = "uncommon",
        desc = "Darren, a brave and determined rat. ",
        art = { npc = "DAVE_HELLRAT_TASKFORCE_DARREN", anim = 31271, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } },
        tags = { location = { "basement_of_doom" }, category = { "hell_rat" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "darve": {"page": "Darve", "resolved": "File:Darve.png"}
    {
        id = "darve", name = "Darve", rarity = "uncommon",
        desc = "He's here to guard the wizard. ",
        art = { npc = "DORGESH_KHAZARD_BODYGUARD_THERE", anim = 808, cam = { yaw = 0.20, dist = 1843, fov = 17, ty = 529, tx = 17, near = 0.25 } },
        tags = { location = { "dorgesh_kaan", "lumbridge_swamp" }, category = { "humanoid", "guard" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dreaming_soul": {"page": "Dreaming soul", "resolved": "File:Dreaming soul.png"}
    {
        id = "dreaming_soul", name = "Dreaming soul", rarity = "common",
        desc = "The soul of one of Rimmington's inhabitants.",
        art = { npc = "QBD1_DREAMING_SOUL1", anim = 808, cam = { yaw = 0.48, pitch = 0.30, dist = 1513, fov = 35, ty = 481, tx = 20, near = 0.25 } },
        tags = { location = { "song_from_the_depths" }, category = { "spirit" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "druid_while_guthix_sleeps": {"page": "Druid (While Guthix Sleeps)", "resolved": "File:Druid (While Guthix Sleeps, truth serum).png"}
    {
        id = "druid_while_guthix_sleeps", name = "Druid (While Guthix Sleeps)", rarity = "common",
        desc = "A nature lover.",
        art = { npc = "LUC2_OLD_DRUID_UPRIGHT", anim = 10870, cam = { yaw = -0.39, pitch = 0.15, dist = 859, ty = 560, tx = -5, near = 0.25 } },
        tags = { location = { "white_knights_castle" }, category = { "humanoid" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "drunken_dwarfs_leg": {"page": "Drunken dwarf's leg", "resolved": "File:Drunken dwarf's leg.png"}
    {
        id = "drunken_dwarfs_leg", name = "Drunken dwarf's leg", rarity = "common",
        desc = "Named after the first thing he tried to eat...",
        art = { npc = "MYARM_TROLL_DEADDWARF", anim = 10814, cam = { yaw = -0.35, pitch = 0.30, dist = 1504, fov = 29, ty = 270, tx = 24 } },
        tags = { location = { "troll_stronghold" }, category = { "troll" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "eliza": {"page": "Eliza (Violet is Blue)", "resolved": "File:Eliza (Violet is Blue).png"}
    {
        id = "eliza", name = "Eliza", rarity = "uncommon",
        desc = "Her eyes are full of wonder.",
        art = { npc = "XMAS18_QUEST_YETI_CHILD_3", anim = 32508, cam = { yaw = -0.26, pitch = 0.30, dist = 1513, fov = 26, ty = 327, tx = 5, near = 0.25 } },
        tags = { location = { "land_of_snow" }, category = { "yeti" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "elizabeth": {"page": "Elizabeth (Violet is Blue Too)", "resolved": "File:Elizabeth (Violet is Blue Too).png"}
    {
        id = "elizabeth", name = "Elizabeth", rarity = "uncommon",
        desc = "Small, blue and hairy.",
        art = { npc = "VIB2_YETI_TOWN_LIST_NPC_1", anim = 32508, cam = { yaw = 0.19, pitch = 0.30, dist = 1513, fov = 26, ty = 327, tx = 5, near = 0.25 } },
        tags = { location = { "yeti_town" }, category = { "yeti" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "felicity": {"page": "Felicity (Evil Dave's Big Day Out)", "resolved": "File:Hell-Rat.png"}
    {
        id = "felicity", name = "Felicity", rarity = "uncommon",
        desc = "Felicity, a tired looking rat mum.",
        art = { npc = "DAVE_HELLRAT_TASKFORCE_FELICITY", anim = 31271, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } },
        tags = { location = { "basement_of_doom" }, category = { "hell_rat" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "monk": {"page": "Monk (Lost City)", "resolved": "File:Monk (Lost City).png"}
    {
        id = "monk", name = "Monk", rarity = "common",
        desc = "He looks holy.",
        art = { npc = "LOST_CITY_MONK_ADVENTURERPG", anim = 18019, cam = { yaw = 0.52, pitch = 0.15, dist = 859, ty = 480, near = 0.25 } },
        tags = { location = { "lumbridge_swamp" }, category = { "humanoid", "priest" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "phantom_sorcerer": {"page": "Phantom sorcerer (Battle of Forinthry)", "resolved": "File:Phantom sorcerer.png"}
    {
        id = "phantom_sorcerer", name = "Phantom sorcerer", rarity = "uncommon",
        desc = "Possessive about their equipment.",
        art = { npc = "FORT_BOSS_STRONG_MAGIC_ENEMY_FIRE_STAFF", anim = 18022, cam = { yaw = 0.36, pitch = 0.30, dist = 1831, fov = 35, ty = 369, tx = -17 } },
        tags = { category = { "phantom", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "phantom_wizard": {"page": "Phantom wizard (Battle of Forinthry)", "resolved": "File:Phantom wizard.png"}
    {
        id = "phantom_wizard", name = "Phantom wizard", rarity = "uncommon",
        desc = "Animated dead.",
        art = { npc = "FORT_BOSS_WEAK_MAGIC_ENEMY_WATER_STAFF", anim = 18022, cam = { yaw = -0.35, pitch = 0.30, dist = 1665, fov = 35, ty = 403, tx = 40 } },
        tags = { category = { "phantom", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "skeleton_archer": {"page": "Skeleton archer (Battle of Forinthry)", "resolved": "File:Skeleton archer (Ancient Awakening, 1).png"}
    {
        id = "skeleton_archer", name = "Skeleton archer", rarity = "uncommon",
        desc = "A bone-a fide skeleton.",
        art = { npc = "FORT_BOSS_WEAK_RANGED_ENEMY", anim = 35213, cam = { yaw = 0.10, pitch = 0.30, dist = 1251, fov = 42, ty = 264, tx = 22 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "skeleton_knight_forinthry": {"page": "Skeleton knight (Battle of Forinthry)", "resolved": "File:Skeleton knight.png"}
    {
        id = "skeleton_knight_forinthry", name = "Skeleton knight (Forinthry)", rarity = "uncommon",
        desc = "You can see right through him.",
        art = { npc = "FORT_BOSS_STRONG_MELEE_ENEMY_2", anim = 35213, cam = { yaw = -0.46, pitch = 0.30, dist = 1137, fov = 35, ty = 350, tx = 27 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "skeleton_ranger": {"page": "Skeleton ranger (Battle of Forinthry)", "resolved": "File:Skeleton ranger.png"}
    {
        id = "skeleton_ranger", name = "Skeleton ranger", rarity = "uncommon",
        desc = "Ex-guard, current skeleton.",
        art = { npc = "FORT_BOSS_STRONG_RANGED_ENEMY", anim = 35213, cam = { yaw = 0.26, pitch = 0.30, dist = 1513, fov = 32, ty = 307, tx = -14 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "skeleton_warrior": {"page": "Skeleton warrior (Battle of Forinthry)"}
    {
        id = "skeleton_warrior", name = "Skeleton warrior", rarity = "uncommon",
        desc = "You can see right through him.",
        art = { npc = "FORT_BOSS_WEAK_MELEE_ENEMY_3", anim = 35213, cam = { pitch = 0.30, dist = 2226, fov = 20, ty = 293, tx = -97, near = 0.25 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "temple_knight_monolith": {"page": "Temple Knight (Battle of the Monolith)", "resolved": "File:Temple Knight (Battle of the Monolith, male).png"}
    {
        id = "temple_knight_monolith", name = "Temple Knight (Monolith)", rarity = "common",
        desc = "Now follows the will of Zaros.",
        art = { npc = "MINIQUEST_EGWD_PRERELEASE_COMBAT_ZAROSIAN_BACKGROUND_1", anim = 37643, cam = { yaw = -0.57, pitch = 0.15, dist = 1136, ty = 420 } },
        tags = { category = { "humanoid", "knight", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "undead_giant": {"page": "Undead giant (Battle of Forinthry)", "resolved": "File:Undead giant.png"}
    {
        id = "undead_giant", name = "Undead giant", rarity = "rare",
        desc = "Will protect the place of power even if he dies trying...again",
        art = { npc = "FORT_BOSS_MINIBOSS_1", anim = 35619, cam = { yaw = 0.64, pitch = 0.30, dist = 3382, fov = 23, ty = 545, tx = -40, near = 0.50 } },
        tags = { category = { "giant", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "warrior": {"page": "Warrior (Lost City)", "resolved": "File:Warrior (Lost City).png"}
    {
        id = "warrior", name = "Warrior", rarity = "uncommon",
        desc = "He looks big and dumb.",
        art = { npc = "LOST_CITY_WARRIOR_ADVENTURERPG", anim = 18015, cam = { yaw = 0.20, dist = 946, fov = 30, ty = 600, near = 0.25 } },
        tags = { location = { "lumbridge_swamp" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "wight": {"page": "Wight (Missing, Presumed Death)", "resolved": "File:Wight.png"}
    {
        id = "wight", name = "Wight", rarity = "uncommon",
        desc = "Armed, and nowhere near as dead as it should be.",
        art = { npc = "SLISKE1_DELIVERY_WIGHT", anim = 18015, cam = { yaw = -0.02, dist = 860, fov = 30, ty = 600, near = 0.25 } },
        tags = { category = { "undead", "thief", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "wight_footsoldier": {"page": "Wight footsoldier (Missing, Presumed Death)", "resolved": "File:Wight footsoldier.png"}
    {
        id = "wight_footsoldier", name = "Wight footsoldier", rarity = "common",
        desc = "One of Sliske's wights.",
        art = { npc = "SLISKE1_MELEE_WIGHT", anim = 18015, cam = { yaw = -0.44, pitch = 0.15, dist = 859, ty = 480, tx = 37, near = 0.25 } },
        tags = { category = { "wight", "thief", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "wight_ranger": {"page": "Wight ranger (Missing, Presumed Death)", "resolved": "File:Wight ranger.png"}
    {
        id = "wight_ranger", name = "Wight ranger", rarity = "common",
        desc = "One of Sliske's wights.",
        art = { npc = "SLISKE1_RANGED_WIGHT", anim = 37629, cam = { yaw = 0.59, pitch = 0.15, dist = 859, ty = 480, near = 0.25 } },
        tags = { category = { "wight", "thief", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "wizard_lost_city": {"page": "Wizard (Lost City)", "resolved": "File:Wizard (Lost City).png"}
    {
        id = "wizard_lost_city", name = "Wizard (Lost City)", rarity = "uncommon",
        desc = "He looks kind of puny.",
        art = { npc = "LOST_CITY_WIZARD_ADVENTURERPG", anim = 18022, cam = { yaw = 0.20, dist = 2970, fov = 13, ty = 536, tx = -42, near = 0.25 } },
        tags = { location = { "lost_city", "lumbridge_swamp" }, category = { "humanoid", "wizard" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "yeti": {"page": "Yeti (Myths of the White Lands)", "resolved": "File:Yeti.png"}
    {
        id = "yeti", name = "Yeti", rarity = "uncommon",
        desc = "An impressively hairy ape-like creature. ",
        art = { npc = "MOTWL_YETI", anim = 11036, cam = { yaw = -0.16, pitch = 0.30, dist = 2971, fov = 30, ty = 575, tx = -12, near = 0.25 } },
        tags = { location = { "land_of_snow" }, category = { "yeti" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "zombie_knight_forinthry": {"page": "Zombie knight (Battle of Forinthry)", "resolved": "File:Zombie knight (Battle of Forinthry).png"}
    {
        id = "zombie_knight_forinthry", name = "Zombie knight (Forinthry)", rarity = "uncommon",
        desc = "The walking dead.",
        art = { npc = "FORT_BOSS_STRONG_MELEE_ENEMY", anim = 35252, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 432, tx = -5, near = 0.25 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "zombie_warrior": {"page": "Zombie warrior (Battle of Forinthry)", "resolved": "File:Zombie warrior (Battle of Forinthry).png"}
    {
        id = "zombie_warrior", name = "Zombie warrior", rarity = "uncommon",
        desc = "The walking dead.",
        art = { npc = "FORT_BOSS_WEAK_MELEE_ENEMY", anim = 35252, cam = { yaw = -0.21, pitch = 0.30, dist = 2226, fov = 19, ty = 330, tx = 6, near = 0.25 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- Only in a cut minigame: Shattered Worlds, Stealing Creation, Soul Wars, Conquest, Fist of Guthix (CUT_MINIGAMES)
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "ahrntim_the_blighted": {"page": "Ahrntim the Blighted", "resolved": "File:Ahrntim the Blighted.png"}
    {
        id = "ahrntim_the_blighted", name = "Ahrntim the Blighted", rarity = "rare",
        desc = "Should two lots of corruption cancel out?",
        art = { npc = "SWORLDS_AHRIM", anim = 813, cam = { yaw = 0.32, pitch = 0.30, dist = 1137, fov = 35, ty = 557, tx = -11, near = 0.25 } },
        tags = { location = { "shattered_worlds" }, category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "alran": {"page": "Alran", "resolved": "File:Alran.png"}
    {
        id = "alran", name = "Alran", rarity = "common",
        desc = "A druid of Guthix.",
        art = { npc = "HVH_DRUID3", anim = 16005, cam = { yaw = -0.39, dist = 860, fov = 30, ty = 661, tx = 12, near = 0.25 } },
        tags = { location = { "fist_of_guthix" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "archer_conquest": {"page": "Archer (Conquest)", "resolved": "File:Archer (Conquest).png"}
    {
        id = "archer_conquest", name = "Archer (Conquest)", rarity = "common",
        desc = "Deadly at long range.",
        art = { npc = "CONQ_ARCHER_LIGHT_FRIENDLY", anim = 14604, cam = { yaw = -0.37, dist = 860, fov = 40, ty = 558, tx = 62, near = 0.25 } },
        tags = { location = { "conquest" }, category = { "humanoid", "knight" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "avatar_of_creation": {"page": "Avatar of Creation", "resolved": "File:Avatar of Creation.png"}
    {
        id = "avatar_of_creation", name = "Avatar of Creation", rarity = "rare",
        desc = "A being of unsurpassed vitality.",
        art = { npc = "SNP_BLUE_BOSS", anim = 11200, cam = { yaw = -0.28, pitch = 0.30, dist = 7908, fov = 25, ty = 1352, tx = 10, near = 0.25 } },
        tags = { location = { "soul_wars" }, category = { "boss", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "avatar_of_destruction": {"page": "Avatar of Destruction", "resolved": "File:Avatar of Destruction.png"}
    {
        id = "avatar_of_destruction", name = "Avatar of Destruction", rarity = "rare",
        desc = "The essence of ruination.",
        art = { npc = "SNP_RED_BOSS", anim = 11195, cam = { yaw = 0.34, pitch = 0.30, dist = 7908, fov = 25, ty = 1092, tx = -94, near = 0.25 } },
        tags = { location = { "soul_wars" }, category = { "boss", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "banker_fist_of_guthix": {"page": "Banker (Fist of Guthix)", "resolved": "File:Banker (Fist of Guthix).png"}
    {
        id = "banker_fist_of_guthix", name = "Banker (Fist of Guthix)", rarity = "common",
        desc = "He has unbelievable strength!",
        art = { npc = "HVH_BANKER", anim = 5607, cam = { yaw = -0.55, pitch = 0.15, dist = 1674, fov = 28, ty = 373, tx = 62, near = 0.25 } },
        tags = { location = { "fist_of_guthix" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "banker_shattered_worlds": {"page": "Banker (Shattered Worlds)", "resolved": "File:Banker (Shattered Worlds).png"}
    {
        id = "banker_shattered_worlds", name = "Banker (Shattered Worlds)", rarity = "common",
        desc = "Part time banker, part time knight.",
        art = { npc = "SWORLDS_HUB_BANKER", anim = 23781, cam = { yaw = 0.36, pitch = 0.15, dist = 859, ty = 480, near = 0.25 } },
        tags = { location = { "shattered_worlds" }, category = { "humanoid", "knight" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "champion": {"page": "Champion", "resolved": "File:Champion (Conquest).png"}
    {
        id = "champion", name = "Champion", rarity = "common",
        desc = "The Void Knight elite; none can stand before them.",
        art = { npc = "CONQ_CHAMPION_LIGHT_FRIENDLY", anim = 14574, cam = { yaw = -0.24, dist = 1145, fov = 33, ty = 600, near = 0.50 } },
        tags = { location = { "conquest" }, category = { "humanoid", "knight" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "chaos_experimental": {"page": "Chaos Experimental", "resolved": "File:Chaos Experimental.png"}
    {
        id = "chaos_experimental", name = "Chaos Experimental", rarity = "rare",
        desc = "A mIrRoReD, cOnFuSeD sHoElAcE.",
        art = { npc = "SWORLDS_CHAOSELEMENTAL", anim = 5248, cam = { pitch = 0.30, dist = 3268, fov = 23, ty = 638, tx = -12, near = 0.50 } },
        tags = { location = { "shattered_worlds" }, category = { "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "clay_familiar_class_1": {"page": "Clay familiar (class 1)", "resolved": "File:Clay familiar (Class 1).png"}
    {
        id = "clay_familiar_class_1", name = "Clay familiar (class 1)", rarity = "common",
        desc = "A sacred familiar made of very low quality clay.",
        art = { npc = "SC_LORE_BEAST", anim = 10594, cam = { yaw = -0.67, pitch = 0.30, dist = 1504, fov = 35, ty = 300 } },
        tags = { skills = { "summoning" }, category = { "sacred_clay", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "clay_familiar_class_2": {"page": "Clay familiar (class 2)", "resolved": "File:Clay familiar (Class 2).png"}
    {
        id = "clay_familiar_class_2", name = "Clay familiar (class 2)", rarity = "common",
        desc = "A sacred familiar made of low quality clay.",
        art = { npc = "SC_LORE_BEAST_2", anim = 10594, cam = { yaw = 0.81, pitch = 0.30, dist = 1504, fov = 35, ty = 300 } },
        tags = { skills = { "summoning" }, category = { "sacred_clay", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "clay_familiar_class_3": {"page": "Clay familiar (class 3)", "resolved": "File:Clay familiar (Class 3).png"}
    {
        id = "clay_familiar_class_3", name = "Clay familiar (class 3)", rarity = "uncommon",
        desc = "A sacred familiar made of medium quality clay.",
        art = { npc = "SC_LORE_BEAST_3", anim = 10594, cam = { yaw = -0.76, pitch = 0.30, dist = 1504, fov = 35, ty = 300 } },
        tags = { skills = { "summoning" }, category = { "sacred_clay", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "clay_familiar_class_4": {"page": "Clay familiar (class 4)", "resolved": "File:Clay familiar (class 4).png"}
    {
        id = "clay_familiar_class_4", name = "Clay familiar (class 4)", rarity = "uncommon",
        desc = "A sacred familiar made of high quality clay.",
        art = { npc = "SC_LORE_BEAST_4", anim = 10594, cam = { yaw = 0.84, pitch = 0.30, dist = 1504, fov = 35, ty = 300 } },
        tags = { skills = { "summoning" }, category = { "sacred_clay", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "clay_familiar_class_5": {"page": "Clay familiar (class 5)", "resolved": "File:Clay familiar (class 5).png"}
    {
        id = "clay_familiar_class_5", name = "Clay familiar (class 5)", rarity = "rare",
        desc = "A sacred familiar made of very high quality clay.",
        art = { npc = "SC_LORE_BEAST_5_COMBAT", anim = 10594, cam = { yaw = -0.62, pitch = 0.30, dist = 1504, fov = 35, ty = 300 } },
        tags = { skills = { "summoning" }, category = { "sacred_clay", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "commandeered_zilyana": {"page": "Commandeered Zilyana", "resolved": "File:Commandeered Zilyana.png"}
    {
        id = "commandeered_zilyana", name = "Commandeered Zilyana", rarity = "epic",
        desc = "Director of the god of order's troops.",
        art = { npc = "SWORLDS_ZILYANA", anim = 6963, cam = { yaw = -0.30, pitch = 0.30, dist = 1654, fov = 35, ty = 625, tx = 8, near = 0.25 } },
        tags = { location = { "shattered_worlds" }, category = { "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dagannot_prime": {"page": "Dagannot Prime", "resolved": "File:Dagannot Prime.png"}
    {
        id = "dagannot_prime", name = "Dagannot Prime", rarity = "rare",
        desc = "Prime by name, derivative by nature.",
        art = { npc = "SWORLDS_PRIME", anim = 29376, cam = { yaw = -0.60, pitch = 0.30, dist = 9255, fov = 12, ty = 1127, tx = 225, near = 0.25 } },
        tags = { location = { "shattered_worlds" }, category = { "dagannoth", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dagannot_rex": {"page": "Dagannot Rex", "resolved": "File:Dagannot Rex.png"}
    {
        id = "dagannot_rex", name = "Dagannot Rex", rarity = "rare",
        desc = "Definitely not short but can be quite pointy.",
        art = { npc = "SWORLDS_REX", anim = 29364, cam = { yaw = -0.60, pitch = 0.30, dist = 6322, fov = 20, ty = 994, tx = 129 } },
        tags = { location = { "shattered_worlds" }, category = { "dagannoth", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dagannot_supreme": {"page": "Dagannot Supreme", "resolved": "File:Dagannot Supreme.png"}
    {
        id = "dagannot_supreme", name = "Dagannot Supreme", rarity = "rare",
        desc = "a dagganoth.",
        art = { npc = "SWORLDS_SUPREME", anim = 29369, cam = { yaw = 0.44, pitch = 0.30, dist = 4318, fov = 35, ty = 563, tx = 91, near = 0.25 } },
        tags = { location = { "shattered_worlds" }, category = { "dagannoth", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "dharok_the_retconned": {"page": "Dharok the Retconned", "resolved": "File:Dharok the Retconned.png"}
    {
        id = "dharok_the_retconned", name = "Dharok the Retconned", rarity = "rare",
        desc = "Should two lots of corruption cancel out?",
        art = { npc = "SWORLDS_DHAROK", anim = 2065, cam = { yaw = 0.21, pitch = 0.30, dist = 1137, fov = 35, ty = 536, tx = 5, near = 0.25 } },
        tags = { location = { "shattered_worlds" }, category = { "undead", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "generally_graardor": {"page": "Generally Graardor", "resolved": "File:Generally Graardor.png"}
    {
        id = "generally_graardor", name = "Generally Graardor", rarity = "epic",
        desc = "A large combat leader.",
        art = { npc = "SWORLDS_GRAARDOR", anim = 17387, cam = { pitch = 0.30, dist = 2971, fov = 30, ty = 1087, tx = 24, near = 0.50 } },
        tags = { location = { "shattered_worlds" }, category = { "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "getorix": {"page": "Getorix", "resolved": "File:Getorix.png"}
    {
        id = "getorix", name = "Getorix", rarity = "common",
        desc = "A druid of Guthix.",
        art = { npc = "HVH_DRUID1", anim = 16005, cam = { yaw = 0.20, dist = 946, fov = 30, ty = 661, tx = 7, near = 0.50 } },
        tags = { location = { "fist_of_guthix" }, category = { "humanoid" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "jelly_soul_wars": {"page": "Jelly (Soul Wars)", "resolved": "File:Jelly.png"}
    {
        id = "jelly_soul_wars", name = "Jelly (Soul Wars)", rarity = "rare",
        desc = "There's always room for jelly.",
        art = { npc = "SNP_JELLY", anim = 24979, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } },
        tags = { location = { "soul_wars" }, category = { "jelly", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/fremennik_province.lua; wiki_pages.json: "pyrefiend": {"page": "Pyrefiend", "resolved": "File:Pyrefiend.png"}
    {
        id = "pyrefiend", name = "Pyrefiend", rarity = "uncommon",
        desc = "A small fire demon.",
        art = { npc = "SLAYER_PYREFIEND_1", anim = 34858, cam = { pitch = 0.30, dist = 1137, ty = 420 } },
        tags = { regions = { "kharidian_desert" }, location = { "fremennik_slayer_dungeon", "smoke_dungeon" }, skills = { "slayer" }, category = { "elemental", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "pyrefiend_soul_wars": {"page": "Pyrefiend (Soul Wars)", "resolved": "File:Pyrefiend (Soul Wars).png"}
    {
        id = "pyrefiend_soul_wars", name = "Pyrefiend (Soul Wars)", rarity = "rare",
        desc = "A small fire demon.",
        art = { npc = "SNP_PYREFIEND", anim = 34858, cam = { pitch = 0.30, dist = 1376, fov = 35, ty = 429, tx = -18 } },
        tags = { location = { "soul_wars" }, category = { "elemental", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua; wiki_pages.json: "verac_the_redefined": {"page": "Verac the Redefined", "resolved": "File:Verac the Redefined.png"}
    {
        id = "verac_the_redefined", name = "Verac the Redefined", rarity = "rare",
        desc = "Should two lots of corruption cancel out?",
        art = { npc = "SWORLDS_VERAC", anim = 2061, cam = { yaw = -0.56, pitch = 0.30, dist = 1137, fov = 35, ty = 519, tx = 54 } },
        tags = { location = { "shattered_worlds" }, category = { "undead", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua; wiki_pages.json: "zimberfizz": {"page": "Zimberfizz", "resolved": "File:Zimberfizz (freed).png", "first": "File:Zimberfizz.png"}
    {
        id = "zimberfizz", name = "Zimberfizz", rarity = "uncommon",
        desc = "Nomad's unfortunate minion.",
        art = { npc = "SNP_IMP_POST_NOM", anim = 171, cam = { yaw = 0.12, dist = 1259, fov = 25, ty = 194, tx = -19, near = 0.25 } },
        tags = { location = { "soul_wars" }, category = { "imp", "shopkeeper" }, membership = { "p2p" } },
    },
    -- Bought with real money or given in a promotion (SKIPPED_PAID_PET in dev/wiki_cards.py)
    -- from deck/npcs/general.lua; wiki_pages.json: "blazehound": {"page": "Blazehound", "resolved": "File:Blazehound adult.png", "first": "File:Baby-blazehound.png"}
    {
        id = "blazehound", name = "Blazehound", rarity = "epic",
        desc = "Brings you the remains of the paper in the morning.",
        art = { npc = "MTX_PET_HELLHOUND_ADULT", anim = 19339, cam = { yaw = -0.60, pitch = 0.30, dist = 1137, fov = 35, ty = 260, tx = 30 } },
        tags = { location = { "solomon_s_general_store" }, category = { "blazehound", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "bloodpouncer": {"page": "Bloodpouncer", "resolved": "File:Adult bloodpouncer.png", "first": "File:Baby bloodpouncer.png"}
    {
        id = "bloodpouncer", name = "Bloodpouncer", rarity = "epic",
        desc = "Leaves puncture wounds that you're unlikely to recover from.",
        art = { npc = "MTX_PET_VAMPIRE_LIONESS_ADULT", anim = 19386, cam = { yaw = 0.60, pitch = 0.30, dist = 1137, fov = 35, ty = 220, tx = -50 } },
        tags = { location = { "solomon_s_general_store" }, category = { "bloodpouncer", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "dragon_wolf": {"page": "Dragon Wolf", "resolved": "File:Dragon Wolf.png", "first": "File:Dragon Wolf Pup.png"}
    {
        id = "dragon_wolf", name = "Dragon Wolf", rarity = "epic",
        desc = "A ruler of the wilderness with fire in its belly.",
        art = { npc = "MTX_PET_DRAGONWOLF_ADULT", anim = 19667, cam = { yaw = -0.60, pitch = 0.30, dist = 1505, fov = 35, ty = 200 } },
        tags = { location = { "marketplace" }, category = { "dragon_wolf", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "fire_drake": {"page": "Fire Drake", "resolved": "File:Fire Drake adult.png", "first": "File:Fire Drake baby.png"}
    {
        id = "fire_drake", name = "Fire Drake", rarity = "epic",
        desc = "And they say size doesn't matter.",
        art = { npc = "MTX_PET_DRAKE_ADULT", anim = 26337, cam = { yaw = -0.40, pitch = 0.30, dist = 1504, ty = 1080, tx = -20 } },
        tags = { location = { "solomon_s_general_store" }, category = { "drake", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "golden_gnome": {"page": "Golden Gnome", "resolved": "File:Golden gnome pet.png"}
    {
        id = "golden_gnome", name = "Golden Gnome", rarity = "legendary",
        desc = "Awarded to winners of a Golden Gnome award at RuneFest.",
        art = { npc = "GOLDEN_GNOME_PET", anim = 22440, cam = { pitch = 0.30, dist = 989, fov = 25, ty = 260 } },
        tags = { location = { "golden_gnome_awards" }, category = { "statue", "pet" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "jungle_gorilla": {"page": "Jungle Gorilla", "resolved": "File:Jungle gorilla (adult).png", "first": "File:Jungle gorilla (baby).png"}
    {
        id = "jungle_gorilla", name = "Jungle gorilla", rarity = "epic",
        desc = "A legendary gorilla.",
        art = { npc = "MTX_PET_GORILLA_ADULT", anim = 30098, cam = { pitch = 0.30, dist = 1137, fov = 45, ty = 300 } },
        tags = { location = { "solomon_s_general_store" }, category = { "gorilla", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "pet_of_autumn": {"page": "Pet of Autumn", "resolved": "File:Pet of Autumn pet.png"}
    {
        id = "pet_of_autumn", name = "Pet of Autumn", rarity = "uncommon",
        desc = "Made from fallen leaves.",
        art = { npc = "TRH71_PET_OF_AUTUMN", anim = 27477, cam = { pitch = 0.30, dist = 989, fov = 35, ty = 260 } },
        tags = { category = { "sprout", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "pet_of_spring": {"page": "Pet of Spring", "resolved": "File:Pet of Spring pet.png"}
    {
        id = "pet_of_spring", name = "Pet of Spring", rarity = "uncommon",
        desc = "Made from flourishing seeds.",
        art = { npc = "TRH71_PET_OF_SPRING", anim = 27477, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 260 } },
        tags = { category = { "sprout", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "pet_of_summer": {"page": "Pet of Summer", "resolved": "File:Pet of Summer pet.png"}
    {
        id = "pet_of_summer", name = "Pet of Summer", rarity = "uncommon",
        desc = "Made from lush blossoms.",
        art = { npc = "TRH71_PET_OF_SUMMER", anim = 27477, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 260 } },
        tags = { category = { "sprout", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "pet_of_winter": {"page": "Pet of Winter", "resolved": "File:Pet of Winter pet.png"}
    {
        id = "pet_of_winter", name = "Pet of Winter", rarity = "uncommon",
        desc = "Made from charred branches.",
        art = { npc = "TRH71_PET_OF_WINTER", anim = 27477, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 260 } },
        tags = { category = { "sprout", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "prime_colossus": {"page": "Prime colossus", "resolved": "File:Prime Colossus Mk III.png", "first": "File:Prime Colossus Mk I.png"}
    {
        id = "prime_colossus", name = "Prime Colossus", rarity = "epic",
        desc = "A power-house follower, and one of your biggest fans.",
        art = { npc = "TWITCH_APR17_PET_ADULT", anim = 20862, cam = { pitch = 0.30, dist = 1137, ty = 400 } },
        tags = { category = { "construct", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "prototype_colossus": {"page": "Prototype colossus", "resolved": "File:Prototype colossus mk III.png", "first": "File:Prototype colossus mk I.png"}
    {
        id = "prototype_colossus", name = "Prototype colossus", rarity = "epic",
        desc = "Built for smashing enemies and inspiring awe.",
        art = { npc = "MTX_PET_SARADOMIN_SIEGE_GOLEM_ADULT", anim = 20862, cam = { pitch = 0.30, dist = 1137, fov = 45, ty = 400 } },
        tags = { location = { "solomon_s_general_store" }, category = { "construct", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "shadow_drake": {"page": "Shadow Drake", "resolved": "File:Shadow Drake adult.png", "first": "File:Shadow Drake baby.png"}
    {
        id = "shadow_drake", name = "Shadow Drake", rarity = "epic",
        desc = "And they say size doesn't matter.",
        art = { npc = "MTX_PET_SHADOW_DRAKE_ADULT", anim = 26337, cam = { yaw = 0.40, pitch = 0.30, dist = 1504, fov = 45, ty = 1260 } },
        tags = { location = { "solomon_s_general_store" }, category = { "drake", "pet" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua; wiki_pages.json: "warborn_behemoth": {"page": "Warborn behemoth", "resolved": "File:Warborn behemoth adult.png", "first": "File:Warborn behemoth baby.png"}
    {
        id = "warborn_behemoth", name = "Warborn behemoth", rarity = "epic",
        desc = "A huge beast carefully mutated for war and parties.",
        art = { npc = "MTX_PET_ZAMORAK_SIEGE_BEAST_ADULT", anim = 20918, cam = { yaw = -0.20, pitch = 0.30, dist = 1137, ty = 320, tx = 10 } },
        tags = { location = { "marketplace" }, category = { "behemoth", "pet" }, membership = { "f2p" } },
    },
    -- Only in a cut Distraction and Diversion: God Statues, Champion's Challenge, Troll Invasion, Goblin Raids, Big Chinchompa, Guthixian Cache, Treasure Trails, Court Cases, Big Top Bonanza (CUT_MINIGAMES)
    -- from deck/npcs/general.lua (Balthazar Beauregard's Big Top Bonanza); wiki_pages.json: "magic_assistant": {"page": "Magic assistant", "resolved": "File:Magic assistant.png"}
    {
        id = "magic_assistant", name = "Magic assistant", rarity = "common",
        desc = "Here to help.",
        art = { npc = "CRCS_MAGIC_ASSISTANT", anim = 793, cam = { pitch = 0.30, dist = 1138, fov = 35, ty = 640 } },
        tags = { location = { "balthazar_beauregard_s_big_top_bonanza" }, category = { "fairy" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Balthazar Beauregard's Big Top Bonanza); wiki_pages.json: "ranged_assistant": {"page": "Ranged assistant", "resolved": "File:Ranged assistant.png"}
    {
        id = "ranged_assistant", name = "Ranged assistant", rarity = "common",
        desc = "Here to help.",
        art = { npc = "CRCS_RANGED_ASSISTANT", anim = 793, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 640 } },
        tags = { location = { "balthazar_beauregard_s_big_top_bonanza" }, category = { "fairy" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Big Chinchompa); wiki_pages.json: "black_soporith_moth": {"page": "Black soporith moth", "resolved": "File:Black soporith moth detail.png"}
    {
        id = "black_soporith_moth", name = "Black soporith moth", rarity = "epic",
        desc = "A moth that secretes soporific chemicals.",
        art = { npc = "BIGCHINCHOMPA_MOTH_8", anim = 37757, cam = { pitch = -1.50, dist = 1844, fov = 30, ty = 960, tx = 80, near = 0.50 } },
        tags = { location = { "big_chinchompa" }, skills = { "hunter" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Big Chinchompa); wiki_pages.json: "blue_soporith_moth": {"page": "Blue soporith moth", "resolved": "File:Blue soporith moth detail.png"}
    {
        id = "blue_soporith_moth", name = "Blue soporith moth", rarity = "uncommon",
        desc = "A moth that secretes soporific chemicals.",
        art = { npc = "BIGCHINCHOMPA_MOTH_5", anim = 362, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 800 } },
        tags = { location = { "big_chinchompa" }, skills = { "hunter" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Big Chinchompa); wiki_pages.json: "green_soporith_moth": {"page": "Green soporith moth", "resolved": "File:Green soporith moth detail.png"}
    {
        id = "green_soporith_moth", name = "Green soporith moth", rarity = "uncommon",
        desc = "A moth that secretes soporific chemicals.",
        art = { npc = "BIGCHINCHOMPA_MOTH_4", anim = 362, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 740 } },
        tags = { location = { "big_chinchompa" }, skills = { "hunter" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Big Chinchompa); wiki_pages.json: "grey_soporith_moth": {"page": "Grey soporith moth", "resolved": "File:Grey soporith moth detail.png"}
    {
        id = "grey_soporith_moth", name = "Grey soporith moth", rarity = "rare",
        desc = "A moth that secretes soporific chemicals.",
        art = { npc = "BIGCHINCHOMPA_MOTH_7", anim = 362, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 740 } },
        tags = { location = { "big_chinchompa" }, skills = { "hunter" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Big Chinchompa); wiki_pages.json: "orange_soporith_moth": {"page": "Orange soporith moth", "resolved": "File:Orange soporith moth detail.png"}
    {
        id = "orange_soporith_moth", name = "Orange soporith moth", rarity = "common",
        desc = "A moth that secretes soporific chemicals.",
        art = { npc = "BIGCHINCHOMPA_MOTH_2", anim = 362, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 740 } },
        tags = { location = { "big_chinchompa" }, skills = { "hunter" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Big Chinchompa); wiki_pages.json: "purple_soporith_moth": {"page": "Purple soporith moth", "resolved": "File:Purple soporith moth detail.png"}
    {
        id = "purple_soporith_moth", name = "Purple soporith moth", rarity = "rare",
        desc = "A moth that secretes soporific chemicals.",
        art = { npc = "BIGCHINCHOMPA_MOTH_6", anim = 362, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 760 } },
        tags = { location = { "big_chinchompa" }, skills = { "hunter" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Big Chinchompa); wiki_pages.json: "red_soporith_moth": {"page": "Red soporith moth", "resolved": "File:Red soporith moth detail.png"}
    {
        id = "red_soporith_moth", name = "Red soporith moth", rarity = "common",
        desc = "A moth that secretes soporific chemicals.",
        art = { npc = "BIGCHINCHOMPA_MOTH_1", anim = 362, cam = { pitch = 0.30, dist = 2466, fov = 30, ty = 760, near = 0.25 } },
        tags = { location = { "big_chinchompa" }, skills = { "hunter" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Big Chinchompa); wiki_pages.json: "yellow_soporith_moth": {"page": "Yellow soporith moth", "resolved": "File:Yellow soporith moth detail.png"}
    {
        id = "yellow_soporith_moth", name = "Yellow soporith moth", rarity = "common",
        desc = "A moth that secretes soporific chemicals.",
        art = { npc = "BIGCHINCHOMPA_MOTH_3", anim = 362, cam = { pitch = 0.30, dist = 1137, ty = 740 } },
        tags = { location = { "big_chinchompa" }, skills = { "hunter" }, category = { "insect" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "aberrant_spectre_champion": {"page": "Aberrant Spectre Champion", "resolved": "File:Aberrant Spectre Champion.png"}
    {
        id = "aberrant_spectre_champion", name = "Aberrant Spectre Champion", rarity = "rare",
        desc = "Champion of the aberrant spectres.",
        art = { npc = "CHAMPIONS_ABERRANTSPECTRE", anim = 9469, cam = { pitch = 0.30, dist = 1990, fov = 35, ty = 460 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "banshee_champion": {"page": "Banshee Champion", "resolved": "File:Banshee Champion.png"}
    {
        id = "banshee_champion", name = "Banshee Champion", rarity = "rare",
        desc = "Champion of the banshees.",
        art = { npc = "CHAMPIONS_BANSHEE", anim = 9452, cam = { pitch = 0.30, dist = 1990, fov = 35, ty = 581, tx = 9, near = 0.25 } },
        tags = { skills = { "slayer" }, category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "earth_warrior_champion": {"page": "Earth Warrior Champion", "resolved": "File:Earth Warrior Champion.png"}
    {
        id = "earth_warrior_champion", name = "Earth Warrior Champion", rarity = "uncommon",
        desc = "Champion of the earth warriors.",
        art = { npc = "CHAMPIONS_EARTHWARRIOR", anim = 23838, cam = { yaw = 0.34, pitch = 0.30, dist = 1990, fov = 35, ty = 581, tx = 9, near = 0.50 } },
        tags = { category = { "elemental", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "ghoul_champion": {"page": "Ghoul Champion", "resolved": "File:Ghoul Champion.png"}
    {
        id = "ghoul_champion", name = "Ghoul Champion", rarity = "uncommon",
        desc = "Champion of the ghouls.",
        art = { npc = "CHAMPIONS_GHOUL", anim = 28587, cam = { yaw = -0.25, pitch = 0.30, dist = 1990, fov = 20, ty = 376, tx = 25, near = 0.25 } },
        tags = { category = { "ghoul", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "giant_champion": {"page": "Giant Champion", "resolved": "File:Giant Champion.png"}
    {
        id = "giant_champion", name = "Giant Champion", rarity = "uncommon",
        desc = "Champion of the giants.",
        art = { npc = "CHAMPIONS_GIANT", anim = 6371, cam = { yaw = 0.18, pitch = 0.30, dist = 4291, fov = 20, ty = 771, tx = -1, near = 0.25 } },
        tags = { category = { "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "goblin_champion": {"page": "Goblin Champion", "resolved": "File:Goblin Champion.png"}
    {
        id = "goblin_champion", name = "Goblin Champion", rarity = "common",
        desc = "Champion of the goblins.",
        art = { npc = "CHAMPIONS_GOBLIN", anim = 6139, cam = { yaw = 0.38, dist = 1143, fov = 44, ty = 352, tx = -4, near = 0.25 } },
        tags = { category = { "goblin", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "hobgoblin_champion": {"page": "Hobgoblin Champion", "resolved": "File:Hobgoblin Champion.png"}
    {
        id = "hobgoblin_champion", name = "Hobgoblin Champion", rarity = "uncommon",
        desc = "Champion of the hobgoblins.",
        art = { npc = "CHAMPIONS_HOBGOBLIN", anim = 17502, cam = { yaw = -0.57, dist = 859, fov = 40, ty = 420, tx = 14, near = 0.25 } },
        tags = { category = { "goblin", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "imp_champion": {"page": "Imp Champion", "resolved": "File:Imp Champion.png"}
    {
        id = "imp_champion", name = "Imp Champion", rarity = "common",
        desc = "Champion of the imps.",
        art = { npc = "CHAMPIONS_IMP", anim = 171, cam = { pitch = 0.30, dist = 1990, fov = 22, ty = 255, tx = 1, near = 0.25 } },
        tags = { category = { "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "leprechaun_champion": {"page": "Leprechaun Champion", "resolved": "File:Leprechaun Champion.png"}
    {
        id = "leprechaun_champion", name = "Leprechaun Champion", rarity = "common",
        desc = "Captain Joycey, champion of the leprechauns.",
        art = { npc = "CHAMPIONS_LEPRECHAUN", anim = 5482, cam = { yaw = -0.31, pitch = 0.30, dist = 1359, fov = 35, ty = 288, tx = 21, near = 0.25 } },
        tags = { category = { "leprechaun", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "lesser_demon_champion": {"page": "Lesser Demon Champion", "resolved": "File:Lesser Demon Champion.png"}
    {
        id = "lesser_demon_champion", name = "Lesser Demon Champion", rarity = "rare",
        desc = "Champion of the lesser demons.",
        art = { npc = "CHAMPIONS_LESSERDEMON", anim = 18829, cam = { yaw = 0.59, pitch = 0.30, dist = 3224, fov = 29, ty = 615, tx = -40 } },
        tags = { category = { "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "skeleton_champion": {"page": "Skeleton Champion", "resolved": "File:Skeleton Champion.png"}
    {
        id = "skeleton_champion", name = "Skeleton Champion", rarity = "uncommon",
        desc = "Champion of the skeletons.",
        art = { npc = "CHAMPIONS_SKELETON", anim = 37629, cam = { pitch = 0.30, dist = 1990, fov = 20, ty = 410, tx = 47, near = 0.50 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Champion's Challenge); wiki_pages.json: "zombie_champion": {"page": "Zombie Champion", "resolved": "File:Zombie Champion.png"}
    {
        id = "zombie_champion", name = "Zombie Champion", rarity = "uncommon",
        desc = "Champion of the zombies.",
        art = { npc = "CHAMPIONS_ZOMBIE", anim = 5573, cam = { pitch = 0.30, dist = 1990, fov = 35, ty = 495, tx = -20, near = 0.25 } },
        tags = { category = { "undead", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/kandarin.lua (Court Cases); wiki_pages.json: "barbarian": {"page": "Barbarian", "resolved": "File:Barbarian (Alberich).png"}
    {
        id = "barbarian", name = "Barbarian", rarity = "common",
        desc = "Alberich, a fierce barbarian warrior.",
        art = { npc = "FAI_BARBARIAN_1", anim = 2561, cam = { yaw = -0.20, pitch = 0.15, dist = 859, ty = 480 } },
        tags = { regions = { "misthalin" }, category = { "humanoid", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua (Court Cases); wiki_pages.json: "wizard": {"page": "Wizard", "resolved": "File:Wizard.png"}
    {
        id = "wizard", name = "Wizard", rarity = "common",
        desc = "Slightly magical.",
        art = { npc = "WIZARD", anim = 18986, cam = { pitch = 0.30, dist = 1407, fov = 30, ty = 520, tx = 240, near = 0.25 } },
        tags = { location = { "air_rune_temple", "fire_rune_temple", "nature_rune_temple" }, category = { "humanoid", "wizard", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/misthalin.lua (Goblin Raids); wiki_pages.json: "goblin_raider": {"page": "Goblin Raider", "resolved": "File:Goblin Raider.png"}
    {
        id = "goblin_raider", name = "Goblin Raider", rarity = "uncommon",
        desc = "He's committing smash and grab!",
        art = { npc = "DND_RAID_GOBLIN_RAIDER", anim = 6181, cam = { yaw = -0.20, dist = 859, fov = 40, ty = 240 } },
        tags = { regions = { "asgarnia" }, category = { "goblin", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/misthalin.lua (Goblin Raids); wiki_pages.json: "hollowtoof": {"page": "Hollowtoof", "resolved": "File:Hollowtoof.png"}
    {
        id = "hollowtoof", name = "Hollowtoof", rarity = "rare",
        desc = "Overseeing the raid. Oh no, now he's angry!",
        art = { npc = "DND_RAID_GOBLIN_BOSS_COMBAT", anim = 6180, cam = { yaw = 0.40, dist = 1988, fov = 20, ty = 280, tx = 10 } },
        tags = { regions = { "asgarnia" }, category = { "goblin", "boss", "monster" }, membership = { "f2p" } },
    },
    -- from deck/npcs/general.lua (Guthixian Cache); wiki_pages.json: "ancient_automaton": {"page": "Ancient automaton", "resolved": "File:Ancient automaton.png"}
    {
        id = "ancient_automaton", name = "Ancient automaton", rarity = "common",
        desc = "This automaton will defend Guthix's memories at all costs!",
        art = { npc = "DIVDND_ENEMY_NOOPS", anim = 19809, cam = { pitch = 0.30, dist = 2289, fov = 35, ty = 540 } },
        tags = { skills = { "divination" }, location = { "guthixian_cache" }, category = { "construct" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Guthixian Cache); wiki_pages.json: "confused_automaton": {"page": "Confused automaton", "resolved": "File:Confused automaton.png"}
    {
        id = "confused_automaton", name = "Confused automaton", rarity = "uncommon",
        desc = "This automaton will defend Guthix's memories at all costs!",
        art = { npc = "DIVDND_ENEMY_NOOPS2", anim = 19809, cam = { pitch = 0.30, dist = 1729, fov = 45, ty = 520 } },
        tags = { skills = { "divination" }, location = { "guthixian_cache" }, category = { "construct" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Guthixian Cache); wiki_pages.json: "enraged_automaton": {"page": "Enraged automaton", "resolved": "File:Enraged automaton.png"}
    {
        id = "enraged_automaton", name = "Enraged automaton", rarity = "rare",
        desc = "This automaton will defend Guthix's memories at all costs!",
        art = { npc = "DIVDND_ENEMY_NOOPS3", anim = 19809, cam = { pitch = 0.30, dist = 2287, fov = 35, ty = 500 } },
        tags = { skills = { "divination" }, location = { "guthixian_cache" }, category = { "construct" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Treasure Trails); wiki_pages.json: "armadylean_shaman": {"page": "Armadylean shaman (Treasure Trails)", "resolved": "File:Armadylean shaman (Treasure Trails).png"}
    {
        id = "armadylean_shaman", name = "Armadylean shaman", rarity = "rare",
        desc = "A follower of Armadyl.",
        art = { npc = "TRAIL_MASTER2", anim = 17975, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { category = { "humanoid", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Treasure Trails); wiki_pages.json: "bandosian_wild_mage": {"page": "Bandosian wild mage (Treasure Trails)", "resolved": "File:Bandosian wild mage (Treasure Trails).png"}
    {
        id = "bandosian_wild_mage", name = "Bandosian wild mage", rarity = "rare",
        desc = "A follower of Bandos",
        art = { npc = "TRAIL_MASTER3", anim = 17975, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { category = { "humanoid", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Treasure Trails); wiki_pages.json: "cabbagemancer": {"page": "Cabbagemancer", "resolved": "File:Cabbagemancer.png"}
    {
        id = "cabbagemancer", name = "Cabbagemancer", rarity = "rare",
        desc = "A follower of Brassica Prime.",
        art = { npc = "TRAIL_MASTER", anim = 17975, cam = { yaw = -0.40, pitch = 0.15, dist = 859, ty = 480 } },
        tags = { category = { "humanoid", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Treasure Trails); wiki_pages.json: "saradomin_wizard": {"page": "Saradomin wizard", "resolved": "File:Saradomin wizard.png"}
    {
        id = "saradomin_wizard", name = "Saradomin wizard", rarity = "uncommon",
        desc = "A follower of Saradomin.",
        art = { npc = "TRAIL_HARD2", anim = 37633, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { category = { "humanoid", "wizard", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/general.lua (Treasure Trails); wiki_pages.json: "zamorak_wizard": {"page": "Zamorak wizard", "resolved": "File:Zamorak wizard.png"}
    {
        id = "zamorak_wizard", name = "Zamorak wizard", rarity = "uncommon",
        desc = "A servant of Zamorak.",
        art = { npc = "TRAIL_HARD", anim = 17975, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { category = { "humanoid", "wizard", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua (Troll Invasion); wiki_pages.json: "cliff": {"page": "Cliff", "resolved": "File:Cliff.png"}
    {
        id = "cliff", name = "Cliff", rarity = "rare",
        desc = "An unusually large troll.",
        art = { npc = "LOY_TROLL_BOSS_1", anim = 1928, cam = { yaw = -0.20, pitch = 0.30, dist = 3478, fov = 35, ty = 750, tx = 49 } },
        tags = { location = { "troll_invasion" }, category = { "troll", "boss", "monster" }, membership = { "p2p" } },
    },
    -- from deck/npcs/asgarnia.lua (Troll Invasion); wiki_pages.json: "dynamite": {"page": "Dynamite", "resolved": "File:Dynamite.png"}
    {
        id = "dynamite", name = "Dynamite", rarity = "common",
        desc = "It looks like he's swallowed a fuse...",
        art = { npc = "LOY_TROLL_DYNAMITE_1", anim = 2018, cam = { pitch = 0.30, dist = 1820, fov = 35, ty = 465, near = 0.25 } },
        tags = { location = { "troll_invasion" }, category = { "troll", "monster" }, membership = { "p2p" } },
    },
}
