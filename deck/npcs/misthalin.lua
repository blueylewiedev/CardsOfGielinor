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
        tags = { location = { "lumbridge" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "lumbridge_guide", name = "Lumbridge Guide", rarity = "uncommon",
        desc = "Happy to help new adventurers.",
        art = { npc = "LUMBRIDGE_GUIDE", anim = 12296, cam = { dist = 2281, fov = 20, ty = 600, tx = 60 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "cook", name = "Cook (Lumbridge)", rarity = "uncommon",
        desc = "Always one ingredient short of a cake.",
        art = { anim = 9870, cam = { yaw = 0.20, fov = 20, ty = 620 } },
        tags = { location = { "lumbridge" }, skills = { "cooking" }, category = { "humanoid" } },
    },
    {
        id = "bob", name = "Bob", rarity = "uncommon",
        desc = "Sells axes and strong opinions.",
        art = { anim = 23790, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { skills = { "woodcutting" }, location = { "lumbridge" }, category = { "shopkeeper", "humanoid" } },
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
        tags = { skills = { "prayer" }, location = { "lumbridge" }, category = { "humanoid", "shopkeeper", "priest" } },
    },
    {
        id = "duke_horacio", name = "Duke Horacio", rarity = "rare",
        desc = "Rules Lumbridge from the castle.",
        art = { npc = "DUKE_OF_LUMBRIDGE", anim = 9870, cam = { yaw = 0.20, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "royalty", "humanoid" } },
    },
    {
        id = "gertrude", name = "Gertrude", rarity = "rare",
        desc = "Lives with a great many cats.",
        art = { anim = 3, cam = { yaw = -0.40, fov = 20, ty = 600, tx = 10 } },
        tags = { location = { "varrock" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "aggie", name = "Aggie", rarity = "rare",
        desc = "Mixes dyes and asks for coins.",
        art = { anim = 5363, cam = { yaw = 0.60, pitch = -0.30, fov = 20, ty = 600, tx = 20 } },
        tags = { skills = { "herblore" }, location = { "draynor" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "WOM_CUTSCENE_4", name = "Wise Old Man", rarity = "epic",
        desc = "Claims to know a great deal about everything.",
        art = { anim = 813, cam = { yaw = 0.40, fov = 20, ty = 580, tx = 20 } },
        tags = { location = { "draynor" }, category = { "humanoid", "shopkeeper", "wizard" } },
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
        tags = { skills = { "farming" }, location = { "lumbridge", "ranch_out_of_time" }, category = { "humanoid", "wizard" } },
    },
    {
        id = "swamp_frog", name = "Swamp frog", rarity = "common",
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
        id = "cave_slime", name = "Cave slime", rarity = "uncommon",
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
        id = "cave_goblin", name = "Cave goblin (Dorgesh-Kaan)", rarity = "common",
        desc = "One of the many citizens of Dorgesh-Kaan.",
        art = { npc = "CAVE_GOBLIN4", anim = 6047, cam = { dist = 988, fov = 30, ty = 400 } },
        tags = { location = { "dorgesh_kaan" }, skills = { "thieving" }, category = { "goblin" } },
    },
    {
        id = "king_roald", name = "King Roald", rarity = "epic",
        desc = "The King of Varrock",
        art = { npc = "KING_ROALD", anim = 5363, cam = { dist = 650, fov = 40, ty = 620 } },
        tags = { location = { "varrock" }, category = { "humanoid", "royalty" } },
    },
    {
        id = "barfy_bill", name = "Barfy Bill", rarity = "common",
        desc = "Looks a little green around the gills.",
        art = { npc = "CANOEING_BILL", anim = 35320, cam = { pitch = 0.15, dist = 1135, ty = 460 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "pirate" } },
    },
    {
        id = "black_lamb", name = "Black Lamb", rarity = "common",
        desc = "The black sheep of the family.",
        art = { npc = "LAMB_BLACK", anim = 32255, cam = { yaw = 0.40, pitch = 0.15, dist = 566, ty = 120 } },
        tags = { location = { "lumbridge" }, category = { "animal" } },
    },
    {
        id = "captain_harlan", name = "Captain Harlan", rarity = "rare",
        desc = "Harlan, captain of the Lumbridge Guard and master of defence",
        art = { npc = "AIDE_TUTOR_MELEE", anim = 18130, cam = { pitch = 0.15, dist = 859, ty = 460 } },
        tags = { skills = { "defence" }, location = { "lumbridge" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "donie", name = "Donie", rarity = "common",
        desc = "A local farmer. She might be able to provide some useful information.",
        art = { npc = "LUMBRIDGE_GUIDE2_WOMAN", anim = 14676, cam = { yaw = 0.60, dist = 748, ty = 560 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "explorer_jack", name = "Explorer Jack", rarity = "uncommon",
        desc = "He looks like a professional explorer.",
        art = { npc = "ATLUM_EXPLORER_JACK", anim = 15120, cam = { pitch = 0.15, dist = 748, ty = 540 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "lumbridge_guard", name = "Lumbridge guard", rarity = "common",
        desc = "He tries to keep order around Lumbridge by killing goblins.",
        art = { npc = "FAI_LUMBRIDGE_GUARD_ATTACKABLE", anim = 18015, cam = { yaw = 0.40, pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "guard", "monster" } },
    },
    {
        id = "fayeth", name = "Fayeth", rarity = "common",
        desc = "Perhaps this gardener might look after your crops for you.",
        art = { npc = "FARMING_GARDENER_TREE_4", anim = 808, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "gillie_groats", name = "Gillie Groats", rarity = "uncommon",
        desc = "Gillie milks cows. She's udderly fantastic at it.",
        art = { npc = "GILLIE_THE_MILKMAID", anim = 808, cam = { yaw = -0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "guardsman_brawn", name = "Guardsman Brawn", rarity = "common",
        desc = "He tries to keep order around Lumbridge.",
        art = { npc = "FAI_LUMBRIDGE_GUARD_BRAWN", anim = 24192, cam = { yaw = 0.20, pitch = 0.45, dist = 1306, fov = 20, ty = 600, tx = -20 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "guard" } },
    },
    {
        id = "guardsman_dante", name = "Guardsman Dante", rarity = "uncommon",
        desc = "He tries to keep order around Lumbridge.",
        art = { npc = "FAI_LUMBRIDGE_GUARD_DANTE", anim = 24192, cam = { yaw = 0.20, pitch = 0.45, dist = 1306, fov = 20, ty = 600, tx = -20 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "guard" } },
    },
    {
        id = "guardsman_deshawn", name = "Guardsman DeShawn", rarity = "uncommon",
        desc = "He tries to keep order around Lumbridge.",
        art = { npc = "FAI_LUMBRIDGE_GUARD_DESHAWN", anim = 24192, cam = { pitch = 0.45, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "guard" } },
    },
    {
        id = "guardsman_pazel", name = "Guardsman Pazel", rarity = "common",
        desc = "He tries to keep order around Lumbridge.",
        art = { npc = "FAI_LUMBRIDGE_GUARD_PAZEL", anim = 24192, cam = { yaw = 0.20, pitch = 0.45, dist = 1306, fov = 20, ty = 600, tx = -20 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "guard" } },
    },
    {
        id = "guardsman_peale", name = "Guardsman Peale", rarity = "uncommon",
        desc = "He tries to keep order around Lumbridge.",
        art = { npc = "FAI_LUMBRIDGE_GUARD_PEALE", anim = 24192, cam = { yaw = 0.20, pitch = 0.45, dist = 1306, fov = 20, ty = 600, tx = -20 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "guard" } },
    },
    {
        id = "ham_agent_william", name = "H.A.M. agent William", rarity = "uncommon",
        desc = "A member of Sigmund's H.A.M. splinter group.",
        art = { npc = "CHOSEN_HAM_INTERROGATOR_2", anim = 808, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { skills = { "thieving" }, location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "hank", name = "Hank", rarity = "common",
        desc = "A product of a consumerist society.",
        art = { npc = "LUM_FISH_SHOPKEEPER", anim = 23780, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "herald_of_lumbridge", name = "Herald of Lumbridge", rarity = "common",
        desc = "She seems to be enjoying herself.",
        art = { npc = "HCAPE_MUTE_LUM_SAY", anim = 8828, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "jacquelyn", name = "Jacquelyn", rarity = "uncommon",
        desc = "An apprentice slayer master under the tutelage of Turael.",
        art = { npc = "SLAYER_MASTER_1A_JACQUELYN", anim = 808, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "lachtopher", name = "Lachtopher", rarity = "common",
        desc = "He has the aura of a lazy-bones about him.",
        art = { npc = "FAI_LUMBRIDGE_LACHTOPHER", anim = 808, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "merchant", name = "Merchant", rarity = "common",
        desc = "An opportunistic merchant.",
        art = { npc = "OMGE_MARKET_SELLER01", anim = 808, cam = { yaw = -0.20, pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "millie_miller", name = "Millie Miller", rarity = "uncommon",
        desc = "Miss Millicent Miller the Miller of Mill Lane Mill.",
        art = { npc = "MILLIE_THE_MILLER", anim = 808, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "musician_lumbridge", name = "Musician (Lumbridge)", rarity = "common",
        desc = "What restful music!",
        art = { npc = "REST_MUSICIAN_LUMBRIDGE_CASTLE", anim = 11796, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "nastroth", name = "Nastroth", rarity = "uncommon",
        desc = "A collector of ancient artefacts.",
        art = { npc = "PVPW_NASTROTH", anim = 316, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 720 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "roddeck", name = "Roddeck", rarity = "uncommon",
        desc = "A helpful soul who loves dispensing advice.",
        art = { npc = "ADVISOR_RODDECK", anim = 4641, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "saradominist_preacher", name = "Saradominist preacher", rarity = "common",
        desc = "He's preaching about Saradomin's victory in the Battle of Lumbridge.",
        art = { npc = "_6AWE1_CUTSCENE_REPLAYER", anim = 15188, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "seth_groats", name = "Seth Groats", rarity = "uncommon",
        desc = "A large well built farmer.",
        art = { npc = "FAVOUR_SETH_GROATS", anim = 14677, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 660 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    {
        id = "sheep_thing", name = "Sheep", rarity = "uncommon",
        desc = "Is it a sheep?",
        art = { npc = "SHEEP_SHEARER_THE_THING", anim = 3570, cam = { yaw = -0.80, dist = 1137, fov = 35, ty = 260 } },
        tags = { location = { "lumbridge" }, category = { "animal" } },
    },
    {
        id = "shop_assistant_lumbridge", name = "Shop assistant (Lumbridge)", rarity = "common",
        desc = "Helps Sell stuff.",
        art = { npc = "GENERALASSISTANT1", anim = 23785, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "sigmund", name = "Sigmund", rarity = "rare",
        desc = "Advisor to the Duke of Lumbridge.",
        art = { npc = "LOST_TRIBE_SIGMUND_THERE", anim = 808, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { skills = { "thieving" }, location = { "lumbridge" }, category = { "humanoid", "boss" } },
    },
    {
        id = "vasquen", name = "Vasquen", rarity = "common",
        desc = "Perhaps this farmer might look after your crops for you.",
        art = { npc = "FARMING_GARDENER_HOPS_3", anim = 2163, cam = { yaw = 0.20, dist = 1502, fov = 20, ty = 640, tx = -30 } },
        tags = { location = { "lumbridge" }, category = { "humanoid", "shopkeeper" } },
    },
    {
        id = "victoria", name = "Victoria", rarity = "common",
        desc = "She seems to be stressed.",
        art = { npc = "FAI_LUMBRIDGE_VICTORIA", anim = 9870, cam = { yaw = 0.20, dist = 1306, fov = 20, ty = 600 } },
        tags = { location = { "lumbridge" }, category = { "humanoid" } },
    },
    { id = "fairy_very_wise", name = "Fairy Very Wise", rarity = "uncommon", desc = "No question is so difficult to answer than when answer is obvious", art = { npc = "FAIRY2_ADVISOR", anim = 793, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 600 } }, tags = { category = { "fairy" }, membership = { "p2p" } } },
    { id = "evil_chicken", name = "Evil Chicken", rarity = "rare", desc = "A fowl beast.", art = { npc = "CHICKENQUEST_EVIL_CHICKEN", anim = 16430, cam = { yaw = 0.40, dist = 1988, fov = 20, ty = 280, tx = 10 } }, tags = { category = { "animal", "boss", "monster" }, membership = { "p2p" } } },
    
    {
        id = "cave_crawler", name = "Cave crawler", rarity = "rare",
        desc = "A spiky crawling critter.",
        art = { npc = "SLAYER_CAVE_CRAWLER_4", anim = 24517, cam = { yaw = -0.40, pitch = 0.30, dist = 1306, fov = 40, ty = 100, tx = 110 } },
        tags = { regions = { "fremennik_province" }, location = { "lumbridge", "dorgesh_kaan", "fremennik_slayer_dungeon" }, skills = { "slayer" }, category = { "animal", "monster" } },
    },
    {
        id = "rock_slug", name = "Rock slug", rarity = "rare",
        desc = "The slime of evil.",
        art = { npc = "SLAYER_ROCKSLUG", anim = 23852, cam = { yaw = -0.20, pitch = -0.15, dist = 748, fov = 30, ty = 120, tx = 40 } },
        tags = { regions = { "fremennik_province" }, location = { "lumbridge", "dorgesh_kaan", "fremennik_slayer_dungeon" }, skills = { "slayer" }, category = { "animal", "monster" } },
    },
    {
        id = "lil_lamb", name = "Li'l lamb", rarity = "common",
        desc = "How cute!",
        art = { npc = "LAMB", anim = 32255, cam = { pitch = 0.30, dist = 861, fov = 35, ty = 160 } },
        tags = { regions = { "asgarnia" }, location = { "lumbridge", "makeover_mage" }, category = { "animal" }, membership = { "f2p" } },
    },
    { id = "stag", name = "Stag", rarity = "common", desc = "A majestic looking stag.", art = { npc = "CRITTER_DEER_STAG", anim = 33760, cam = { yaw = -0.80, pitch = 0.30, dist = 2288, fov = 35, ty = 620, tx = 140 } }, tags = { regions = { "asgarnia" }, category = { "animal", "monster" }, membership = { "f2p" } } },
    { id = "hollowtoof", name = "Hollowtoof", rarity = "rare", desc = "Overseeing the raid. Oh no, now he's angry!", art = { npc = "DND_RAID_GOBLIN_BOSS_COMBAT", anim = 6180, cam = { yaw = 0.40, dist = 1988, fov = 20, ty = 280, tx = 10 } }, tags = { regions = { "asgarnia" }, category = { "boss", "monster" }, membership = { "f2p" } } },
    { id = "abyssal_tentacle", name = "Abyssal tentacle", rarity = "uncommon", desc = "Servants of the lord, very fierce little things.", art = { npc = "ABYSSALS_ABYSSAL_SPAWN", anim = 34657, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 280 } }, tags = { regions = { "wilderness" }, category = { "chthonian", "monster" }, membership = { "p2p" } } },
    { id = "aeonisig_raispher", name = "Aeonisig Raispher", rarity = "rare", desc = "Roald's advisor - he seems to be a follower of Saradomin.", art = { npc = "MYQ3_AEONISIG_ROALDS_ADVISOR", anim = 808, cam = { yaw = 0.20, pitch = 0.15, dist = 431, fov = 60, ty = 600 } }, tags = { regions = { "morytania" }, location = { "varrock", "castle_drakan", "river_of_blood" }, category = { "humanoid", "priest" }, membership = { "p2p" } } },
    { id = "tramp", name = "Tramp", rarity = "common", desc = "A man down on his luck.", art = { npc = "TRAMP", anim = 808, cam = { yaw = 0.20, pitch = 0.15, dist = 429, fov = 85, ty = 500 } }, tags = { regions = { "kandarin" }, location = { "varrock", "yanille", "seers_village" }, category = { "humanoid", "shopkeeper" }, membership = { "f2p" } } },
    { id = "crystal_impling", name = "Crystal impling", rarity = "epic", desc = "An impling that thinks itself an elf.", art = { npc = "II_IMPLING_TYPE_15", anim = 6613, cam = { pitch = 0.30, dist = 493, fov = 35, ty = 820 } }, tags = { regions = { "tirannwn" }, location = { "prifddinas" }, skills = { "hunter" }, category = { "impling" }, membership = { "p2p" } } },
}

return Set
