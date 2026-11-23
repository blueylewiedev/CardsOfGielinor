-- core/tagwords.lua
-- The words cards may use as tags, and the rules between them. Nothing here touches the game or needs another file.
--
-- dev/card_queue.py, dev/add_tag_words.lua, dev/wiki_cards.py and dev/make_pack_art.py read this file as text, and the first two add
-- words to it. Keep the three tables below laid out as they are: each starts at the beginning of a line, and its words are in
-- quoted lists. Do not write the tables' own names followed by an equals sign anywhere else, such as in a comment.

local TagWords = {}

-- The words allowed for the closed-list tag kinds. A card with any other word is left out and named in Cards.loadProblems (and
-- the pull request check fails). Add a word here before using it; tag kinds not listed are not checked.
TagWords.words = {
    regions  = { "misthalin", "asgarnia", "kandarin", "karamja", "kharidian_desert", "morytania",
                "tirannwn", "fremennik_province", "wilderness", "anachronia", "havenhythe", "daemonheim",
                "the_arc" },
    location = { "lumbridge", "falador", "ardougne", "draynor", "varrock", "ranch_out_of_time", "lumbridge_swamp",
                 "dorgesh_kaan", "burthorpe", "chaos_tunnels", "fremennik_slayer_dungeon", "catherby",
                 "vinesweeper", "enchanted_valley", "artisans_workshop", "white_knights_castle", "mining_guild",
                 "puro_puro", "guthixian_cache", "feldip_hunter_area", "taverley", "tree_gnome_stronghold",
                 "fishing_guild", "fisher_realm", "river_lum","uzer_hunter_area","makeover_mage",
                 "soul_rune_temple", "prifddinas",
                 "v_s_island", "balthazar_beauregard_s_big_top_bonanza", "sinkholes", "gorajo_hoardstalker_dungeon", "grenwall_portal", "hollow_hill", "isafdar", "castle_drakan", "river_of_blood",
                 "exam_centre", "canifis", "gu_tanoth", "black_knights_catacombs", "kal_gerion_dungeon", "east_ardougne", "rimmington", "seers_village", "brimhaven", "oo_glog", "port_tyras", "yanille", "air_rune_temple", "fire_rune_temple", "nature_rune_temple",
                 "piscatoris_hunter_area", "herblore_habitat", "trouble_brewing", "big_chinchompa",
                 "rellekka", "chamber_of_guthix", "empyrean_citadel", "zemouregal_s_fort", "zamorak_s_hide",
                 "daemonheim", "garden_of_kharid", "sunlight_sands", "wendlewick", "pawya_portal",
                 "party_room", "runefest_treasure_island", "thalmund_s_forge",
                 "player_owned_port", "piscatoris_fishing_colony", "goebie_camp",
                 "ape_atoll", "crash_island", "life_altar", "monastery_of_ascension", "kuradal_s_dungeon", "piscatoris_peninsula", "mazcab", "al_kharid", "exiled_kalphite_hive", "jaldraocht_pyramid", "mammoth_iceberg", "frozen_waste_plateau", "pollnivneach_slayer_dungeon", "lighthouse_dungeon", "dagannoth_guardian_dungeon", "jhallan_s_resting_place", "here_be_penguins", "smoke_dungeon", "highweald_forest", "amberfell", "deserted_mine",
                 "handelmort_mansion", "mcgrubor_s_wood", "temple_of_ikov_dungeon", "ice_queen_s_lair", "ancient_cavern", "shadow_dungeon", "waterfall_dungeon", "white_wolf_mountain", "dragonkin_lair", "adamant_dragon_dungeon", "gemstone_cavern", "deep_wilderness_dungeon", "wilderness_level_47_lava_maze_mine", "crandor", "dwarven_mines", "jadinko_lair", "red_dragon_isle",
                 "tzhaar_city",
                 "abandoned_mine", "barrows", "haunted_woods", "slayer_tower", "darkmeyer",
                 "harpoon_joe_s_house_of_rum", "tai_bwo_wannai", "arandar", "the_lost_grove", "evil_chicken_s_lair", "magic_axe_hut", "stalker_dungeon",
                 "marketplace", "solomon_s_general_store",
                 "nung", "baby_squirrel_hunter", "unconscious_broav", "hunting_expert", "crafting_table_3", "2013_christmas_event", "char_s_training_cave", "calling_beads",
                 "baby_platypus_hunter", "golden_gnome_awards", "slayer_points", "tooth_fairy",
                 "guthixian_ruins", "the_north",
                 "dancing_donkey_inn", "grand_exchange", "paterdomus", "blue_moon_inn", "tunnel_of_chaos",
                 "champions_guild", "fort_forinthry", "the_raptor", "jolly_boar_inn", "cooks_guild", "rat_pits",
                 "combat_academy", "behind_the_scenes_location", "chaos_temple_dungeon", "southern_wilderness_mining_site", "temple_of_zamorak", "rogues_castle",
                 "seren_s_garden",
                 "edgeville", "edgeville_dungeon", "edgeville_general_store", "dungeon_of_disorder", "edgeville_monastery", "christmas_village", "morgan", "mogre_camp", "maze", "port_sarim", "dragon_slayer",
                 "senntisten", "dark_wizards_tower", "stone_circle", "goblin_village", "land_of_snow", "shattered_worlds",
                 "city_of_um", "archaeology_campus", "bandos_tower", "yu_biusk",
                 "lunar_isle", "camelot", "premier_club",
                 "the_rusty_anchor", "sarim_s_revenge", "black_knights_fortress", "grand_tree",
                 "hazelmere_s_island",
                 "warforge_dig_site", "freneskae", "temple_of_isolation", "kharid_et_dig_site", "temple_of_amascut", "heart_of_gielinor", "fight_arena_location",
                 "armadyl_s_tower", "sliske_s_endgame", "new_varrock", "harvest_hollow",
                 "archaeology_guild",
                 "thieves_guild", "runespan", "basement_of_doom", "tzekhaar_front",
                 "gower_farm", "tolna_s_rift", "wizards_tower", "aqueduct_portal", "glacor_front", "wizards_tower_2011_christmas_event",
                 "entrana", "yeti_town", "town_hall_fort_forinthry", "cathedral_senntisten", "the_empty_throne_room", "clan_camp", "clan_citadel", "soul_wars", "the_last_call",
                 "maggie", "shady_grove", "zanaris",
                 "silvarea", "star_lodge_cellar", "tutorial_island", "tutorial_island_beneath_cursed_tides", "mudskipper_point", "dig_site", "mage_training_arena", "sliske_s_lair", "stronghold_of_security", "gunnarsgrunn", "war_s_retreat", "death_s_office", "closure_s_study", "stronghold_of_player_safety", "paddlington", "croesus_front", "trollweiss",
                 "alice_s_farm", "tzhaar_fight_pits", "grim_reaper_s_citadel", "infernal_source_dig_site", "dorgeshuun_mines", "zamorakian_crypt", "thammaron_s_throne_room", "nodon_front", "het_s_oasis", "may_s_quest_caravan", "psychiatry_clinic", "barbarian_village", "seth_groats", "ancient_guthix_temple", "gulvas_mansion",
                 "fairy_resistance_hideout", "ork_s_rift", "chapel_fort_forinthry", "crypt_wilderness", "prison_fort_forinthry",
                 "polypore_dungeon", "polypore_dungeon_resource_dungeon", "elder_god_wars_dungeon", "gorak_plane", "h_a_m", "h_a_m_hideout", "rasial_s_citadel", "h_a_m_dungeon", "sanctum_of_rebirth", "the_skulls_headquarters", "killerwatt_plane", "wizard_s_tower", "wanderer", "soul_altar", "runecrafting_guild", "uzer_mastaba", "chasm_of_tears", "guthixian_temple", "hefin_clan", "king_s_road", "black_arm_gang",
                 "courthouse", "priest_in_peril", "death_s_mansion", "eastfold_farm", "nomad_s_temple", "memorial_to_guthix", "outlaw_camp", "gunnarsgrun", "command_centre", "kitchen", "misthalin_training_centre_of_excellence", "richie_npc", "owlery", "air_ruins",
                 "um_ritual_site", "ungael_ritual_site", "lost_city", "the_skullery", "tuska", "silverlight_crypt",
                 "everlight", "the_zamorakian_undercity",
                 "ectofuntus", "river_noumenon",
                 "baby_monkey_hunter",
                 "burnt_lobster_tavern",
                 "heroes_guild", "troll_kitchen", "troll_stronghold_area", "ashdale_caves",
                 "warriors_guild",
                 "uncharted_isles", "tuai_leit", "crafting_guild", "fist_of_guthix", "death_plateau_location", "aminishi", "the_arc",
                 "ancient_prison",
                 "death_plateau", "troll_invasion", "conquest", "power_station", "ice_mountain", "cyclosis", "eisetes_cretor", "zamorak_s_fortress", "the_other_inn", "grum_s_gold_exchange", "freda", "death_plateau_area", "dwarven_mine", "black_knight_workshop", "god_wars_dungeon", "waiko", "doric_s_cave", "doric_s_hut", "saradomin_s_encampment", "rogues_den",
                 "lady_lumbridge", "clan_wars", "cannonball_run",
                 "the_harbinger", "goshima", "void_knights_outpost", "black_knights_base", "whale_s_maw",
                 "troll_arena", "tomb_of_the_fallen", "anachronia_dinosaur_farm", "ashdale", "invention_guild", "song_from_the_depths", "keldagrim", "troll_stronghold", "dwarven_shopping_store", "trollheim", "storm_cellar", "nora_t_hagg", "anniversary_island",
                 "living_rock_caverns", "armadyl_s_eyrie", "asgarnian_ice_dungeon_resource_dungeon", "bandos_s_stronghold",
                 "mudknuckles_kitchen",
                 "coal_truck_mine", "the_islands_that_once_were_turtles",
                 "mystic_s_camp",
                 "troll_tunnels", "ice_path", "guthix_s_cave", "the_pick_and_lute", "barbarian_outpost",
                 "bandos_arena_yu_biusk", "betty_s_basement",
                 "temple_of_aminishi", "melzar_s_maze",
                 "miazrqa_s_tower", "milky_bay", "grotworm_lair", "slug_citadel", "dwarven_tunnel", "sabbot_s_cave", "tunnel_death_plateau", "agar_atoll", "player_owned_ports", "port_district", "menaphos", "white_knight_camp", "asgarnian_ice_dungeon", "chaos_temple_hut", "christmas_event",
                 "void_knight_archery_store", "void_knight_general_store", "void_knight_magic_store", "void_knights", "astram_farm", "kami_shima", "thurgo_s_peninsula", "borehole", "legends_guild_south_west_mine", "forester_s_arms", "sinclair_mansion" },
    skills   = { "attack", "defence", "strength", "constitution", "ranged", "prayer", "magic",
                "cooking", "woodcutting", "fletching", "fishing", "firemaking", "crafting",
                "smithing", "mining", "herblore", "agility", "thieving", "slayer", "farming",
                "runecrafting", "hunter", "construction", "summoning", "dungeoneering",
                "divination", "invention", "archaeology", "necromancy" },
    category = {},        -- filled in below from TagWords.groups.category
    -- Whether the card's NPC or item is free to play or members only: one word, or none if unknown.
    membership = { "f2p", "p2p" },
}

-- Tag words that are shown in groups when they are picked in the Card Builder. The groups are
-- only for display; the allowed words are the ones in all the groups together. A new category
-- word goes in the group that fits it best.
TagWords.groups = {
    category = {
        { title = "What it is", words = { "humanoid", "animal", "dragon", "undead", "demon", "giant", "goblin",
            "troll", "spirit", "elemental", "insect", "construct", "titan", "minotaur", "impling", "fairy",
            "dagannoth", "kalphite", "pet", "plant", "god",
            "chthonian",
            "dragonkin", "gorajo", "grenwall", "hellhound",
            "jadinko",
            "jelly", "mahjarrat",
            "pawya", "tzhaar", "volcanic_creature", "wolpertinger",
            "chameleon",
            "virius", "siren",
            "phoenix", "kebbit",
            "tokhaar",
            "behemoth", "blazehound", "bloodpouncer", "dragon_wolf", "drake", "gorilla",
            "broav", "clockwork", "fire_creature", "imp",
            "platypus", "rune_guardian", "sprout", "statue", "strykewyrm", "tooth_creature", "vulture",
            "yak",
            "humans",
            "ourg",
            "human_skull",
            "creation_of_mah", "avernic",
            "tortle",
            "essling", "hell_rat",
            "phantom",
            "yeti", "esshound", "avatar",
            "skeleton_cow",
            "snow_imp", "esswraith", "cabbage", "ilujanka", "catablepon", "cave_goblin", "cerberus", "cockroach", "soul_devourer", "frogeel",
            "fungus", "infernal", "moth", "avernic_disguised_as_human", "gnome_ghost",
            "tzekhaar", "fleshcrawler",
            "fungal_mage", "ganodermic", "mindslayer", "cat_ghost", "troll_ghost", "ghoul", "gorak", "grifolapine", "grifolaroo", "gublinch", "mahjarrat_formerly_mahserrat", "otherworldly_being", "imcando_dwarf_ghost", "killerwatt", "god_disguised_as_human", "leprechaun", "light_creature", "mimic", "molanisk",
            "zygomite", "honey_badger", "leprechaun_zombie", "magpie",
            "shade", "soul",
            "hedgehog", "tree_spirit", "zombie_elf", "undead_cow", "scarab", "undead_dragon", "wall_beast", "wight",
            "crassian",
            "crablet", "serpent", "kami",
            "nature_spirit", "parrot", "gecko", "bloodveld", "void_pest",
            "cyclops",
            "dwarves", "sacred_clay", "icyene",
            "dwarf_spirit",
            "centaur_ghost", "earwig", "beast", "foo_lion",
            "human_disguised_as_goblin",
            "griffin", "lion",
            "cyclops_skull",
            "ice_sprite",
            "living_rock_creature",
            "coconut", "mogre", "nihil", "crocodile", "cyclops_and_parrot", "ork", "ibis",
            "sea_orphan", "sky_orphan_tengu_mask", "imcando_dwarf", "void_familiar", "anima_being", "wyrmwood" } },
        { title = "What it does", words = { "shopkeeper", "stallholder", "guard", "knight", "royalty", "adventurer",
            "wizard", "priest", "quest_giver", "banker", "farmer", "pirate", "thief", "skill_trainer", "cook", "emissary",
            "archaeology_collector" } },
        { title = "Whether it can be fought", words = { "monster", "boss" } },
    },
}
for _, group in ipairs(TagWords.groups.category) do
    for _, word in ipairs(group.words) do
        TagWords.words.category[#TagWords.words.category + 1] = word
    end
end

-- The category words for item cards, in groups (`requires`: the word, or list of words of which one will do, a group needs on the
-- card). An NPC cannot be "food", an item cannot be a "dragon", but a pack filter can use any
-- word. A word must not also be an NPC word.
TagWords.itemGroups = {
    category = {
        { title = "What it is", words = { "raw_material", "processed_material", "food", "drink", "potion",
            "tool", "container", "rune", "seed", "quest_item", "currency", "decoration", "craftable", "weapon", "consumable",
            "armour", "skill_outfit", "jewellery", "pocket", "ammunition", "fashion", "novelty", "treasure_trail", "slayer_drop", "minigame", "discontinued",
            "junk" } },
        { title = "What kind of weapon", requires = "weapon",
            words = { "dagger", "defender", "sword", "scimitar", "two_handed_sword", "axe", "mace", "maul", "spear", "halberd",
                "whip", "claw", "shortbow", "longbow", "crossbow", "thrown", "staff", "wand", "lantern", "siphon", "orb", "book" } },
        { title = "Which armour slot", requires = { "armour", "skill_outfit" },
            words = { "helmet", "body", "legs", "gloves", "boots", "off_hand", "back" } },
        { title = "Which jewellery slot", requires = "jewellery",
            words = { "ring", "neck" } },
        { title = "What type of ammo", requires = "ammunition",
            words = { "arrow", "bolt", "spike" } },
        { title = "Combat style", requires = { "weapon", "armour", "jewellery", "ammunition" },
            words = { "melee_gear", "ranged_gear", "magic_gear", "necromancy_gear", "hybrid_gear" } },
        { title = "What kind of food", requires = "food",
            words = { "meal", "baked_goods", "fruit_veg", "raw_food" } },
        { title = "What kind of raw material", requires = "raw_material",
            words = { "log", "ore", "bone", "hide" } },
        { title = "What kind of potion", requires = "potion",
            words = { "flask" } },
        { title = "What kind of processed material", requires = "processed_material",
            words = { "bar", "plank", "clay" } },
        { title = "What kind of seed", requires = "seed",
            words = { "allotment", "flower", "herb_patch", "hop", "bush", "tree", "fruit_tree", "cacti",
                "mushroom", "special", "vine_flower", "vine_herb", "vine_bush", "fertile_soil",
                "dungeoneering_patch", "berry_planter" } },
        { title = "Gems", requires = { "raw_material", "processed_material" },
            words = { "gem" } },
        { title = "Herbs", requires = { "raw_material", "processed_material" },
            words = { "herb" } },
        { title = "Ingredients", requires = { "raw_material", "processed_material" },
            words = { "ingredient" } },
        { title = "Fish and meat", requires = { "raw_material", "food" },
            words = { "fish", "meat" } },
    },
}
local npcCategoryWords = {}
for _, word in ipairs(TagWords.words.category) do
    npcCategoryWords[word] = true
end
for _, group in ipairs(TagWords.itemGroups.category) do
    for _, word in ipairs(group.words) do
        assert(not npcCategoryWords[word], "The category word \"" .. word .. "\" is in both the NPC and the item lists")
        TagWords.words.category[#TagWords.words.category + 1] = word
    end
end

-- The groups the words of a tag kind are shown in for this kind of card, or nil if the words
-- are not in groups.
function TagWords.groupsFor(cardKind, tagKind)
    local groups = cardKind == "item" and TagWords.itemGroups or TagWords.groups
    return groups[tagKind]
end

-- The words a card of this kind may use under a tag kind, or nil if the tag kind has no list.
-- With no card kind, every word that any pack filter may use.
function TagWords.wordsFor(cardKind, tagKind)
    local groups = cardKind ~= nil and TagWords.groupsFor(cardKind, tagKind) or nil
    if groups == nil then
        return TagWords.words[tagKind]
    end
    local words = {}
    for _, group in ipairs(groups) do
        for _, word in ipairs(group.words) do
            words[#words + 1] = word
        end
    end
    return words
end

-- A group's `requires` as a list of words: it is one word ("weapon") or a list of words, any one
-- of which will do ({ "raw_material", "food" }), or nil if the group needs nothing.
local function requiredList(group)
    if group.requires == nil then
        return nil
    end
    if type(group.requires) == "table" then
        return group.requires
    end
    return { group.requires }
end

-- The words a tag word needs one of on the same card, from the `requires` of the group it is in
-- (a scimitar needs a weapon), as a list, or nil if it needs nothing.
function TagWords.requiredWords(cardKind, tagKind, word)
    for _, group in ipairs(TagWords.groupsFor(cardKind, tagKind) or {}) do
        local list = requiredList(group)
        if list ~= nil then
            for _, groupWord in ipairs(group.words) do
                if groupWord == word then
                    return list
                end
            end
        end
    end
    return nil
end

-- The words in a list whose required words are not in it too, as { word, needs }. A chain is checked a link at a time.
function TagWords.missingRequired(cardKind, tagKind, words)
    local have = {}
    for _, word in ipairs(words) do
        have[word] = true
    end
    local missing = {}
    for _, word in ipairs(words) do
        local needs = TagWords.requiredWords(cardKind, tagKind, word)
        if needs ~= nil then
            local found = false
            for _, parent in ipairs(needs) do
                found = found or have[parent] == true
            end
            if not found then
                missing[#missing + 1] = { word = word, needs = table.concat(needs, " or ") }
            end
        end
    end
    return missing
end

-- True if `word` may be used for this tag kind: it is on the kind's list, or the kind has no list. With a card kind ("npc" or
-- "item"), the category words are the ones for that kind of card only. The lists are made into sets the first time they are asked.
local knownSets = {}
function TagWords.isKnown(tagKind, word, cardKind)
    local key = (cardKind or "") .. "|" .. tagKind
    local set = knownSets[key]
    if set == nil then
        local allowed = TagWords.wordsFor(cardKind, tagKind)
        if allowed == nil then
            set = false
        else
            set = {}
            for _, listed in ipairs(allowed) do
                set[listed] = true
            end
        end
        knownSets[key] = set
    end
    return set == false or set[word] == true
end

return TagWords
