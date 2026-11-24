-- deck/sets.lua
-- Sets: groups of cards to collect together, such as every shopkeeper or every musician. The Sets window
-- (ui/setsviewer.lua) lists them with how many of each the player has, and shows a set's cards with the
-- missing ones as dark silhouettes.
--
-- (Not to be confused with Cards.deckFiles in core/cards.lua, which is the list of deck files.)
--
-- A set is written as its own block:
--   {
--       id = "musicians", name = "Musicians",
--       names = { "Musician" },
--   },
--
-- Fields:
--   id     : unique among the sets, lower case. Nothing is saved under it, so it can be renamed.
--   name   : what the Sets window calls it.
--   names  : optional. Card names the set takes in, with every variant of each: "Musician" takes the card called
--            "Musician" and every "Musician (...)", such as "Musician (Lumbridge)", but not "Musicianship".
--            New variants join the set by themselves when they are added to the deck.
--   filter : optional. Only cards that also match this are taken in, written as a pack filter (see core/packtypes.lua
--            in core/cards.lua), e.g. { kind = "npc" } or { category = "shopkeeper" }: every key must match, and
--            one word of a list is enough. `name` matches part of the card's name, in any case: { name = "wizard" }
--            takes in "Wizard Mizgog" and "Dark wizard". A list of filters takes in a card that matches any one:
--            { { category = "cook" }, { kind = "npc", name = { "chef", "baker" } } }. On its own (no `names`)
--            it takes in every card that matches. A set of NPCs by job (guards, cooks, bankers...) filters on that
--            category word: dev/wiki_cards.py tags new cards with it from the wiki, so they join by themselves.
--   except : optional. Cards that match this (written like filter, `name` and lists of filters too) are kept out,
--            e.g. { location = "dorgesh_kaan" } or { name = "(God Wars Dungeon)" }:
--            a rule for a whole group of cards that `leave` would have to list one by one.
--   add    : optional. Card ids to put in the set although the rules above leave them out.
--   leave  : optional. Card ids to keep out of the set although the rules above take them in.
--   group  : optional. A heading the Sets window lists the set under, e.g. "Metal armour": the sets of a group fold
--            away under it, and open with a click on it. The group sits where its first set is in this file.
-- A set needs at least one of names, filter or add. The cards are shown in the deck's order (lowest rarity first).
--
-- A set is a spread of a kind of card, not every card of that kind: keep it to about 30 cards (a soft limit,
-- Sets.SOFT_LIMIT in core/sets.lua). When a kind outgrows that, narrow it with except or leave, split it into sets of its own (by place,
-- say), or pick the cards by hand with add.
--
-- `lua dev/check_sets.lua` checks every set: that the ids in add and leave are cards in the deck and that no set ends
-- up empty, and warns about a set over the soft limit. It also runs on every pull request.

return {
    {
        id = "shopkeepers", name = "Shopkeepers", group = "Everyday jobs",
        names = { "Shopkeeper" },
        add = { "fairy_shopkeeper" },
    },
    {
        id = "shop_assistants", name = "Shop assistants", group = "Everyday jobs",
        names = { "Shop assistant" },
        add = { "fairy_shop_assistant" },
    },
    {
        id = "musicians", name = "Musicians", group = "Everyday jobs",
        names = { "Musician" },
    },
    {
        id = "bartenders", name = "Bartenders", group = "Everyday jobs",
        names = { "Bartender" },
        add = { "cheri" },
    },
    -- (the cards tagged guard with "guard" in their name; left out: captains, guardsmen and guardians)
    {
        id = "guards", name = "Guards", group = "Everyday jobs",
        filter = { kind = "npc", category = "guard", name = "guard" },
        except = { { name = "captain" }, { name = "guardsman" }, { name = "guardian" } },
    },
    -- (the wiki's goblin race, hobgoblins too; left out: the cave goblins of Dorgesh-Kaan, Kazgar, and the pet Ramsay)
    {
        id = "goblins", name = "Goblins",
        filter = { kind = "npc", category = "goblin" },
        except = { location = { "dorgesh_kaan", "dorgeshuun_mines" } },
        leave = { "kazgar", "ramsay" },
    },
    -- (by name: the Wizards' Tower mage and master mage are in this set and the mages)
    {
        id = "wizards", name = "Wizards", group = "Magic users",
        filter = { kind = "npc", name = "wizard" },
    },
    -- (by name; left out: Magestix, whose name only starts with "Mage")
    {
        id = "mages", name = "Mages", group = "Magic users",
        filter = { kind = "npc", name = "mage" },
        leave = { "magestix" },
    },
    {
        id = "cooks", name = "Cooks", group = "Everyday jobs",
        filter = { kind = "npc", category = "cook" },
    },
    {
        id = "bankers", name = "Bankers", group = "Everyday jobs",
        filter = { kind = "npc", category = "banker" },
    },
    -- The skill masters: the NPCs who sell a skill's cape, from the wiki's Skillcape page (and the Spirit of Mastery,
    -- who sells the 120 Necromancy cape). The ones not carded yet join by themselves when they are.
    {
        id = "skill_masters", name = "Skill masters",
        names = { "Cap'n Izzy No-Beard", "Acting Guildmaster Reiniger", "Ajjat", "Surgeon General Tafani", "Estate agent",
            "Head chef", "Master Crafter", "Captain Harlan", "Orla Fairweather", "Thok of Daemonheim",
            "Martin the Master Gardener", "Ignatius Vulcan", "Master fisher", "Hickton", "Kaqemeex", "Hunting expert",
            "Doc", "Robe Store owner", "Gadrin", "The Spirit of Accomplishment", "The Spirit of Mastery", "Brother Jered",
            "Armour salesman", "Larriar", "Kuradal", "Thurgo", "Sloane", "Yadech Strongarm", "Pikkupstix",
            "Martin Thwait", "Wilfred" },
        filter = { kind = "npc" },
    },
    -- (the skill masters of Burthorpe and Taverley and the tutorial's instructors, tagged by their NPC; Vannaka, Sani
    -- and Bryll, shown as other NPCs, were tagged by hand)
    {
        id = "skill_trainers", name = "Skill trainers",
        filter = { kind = "npc", category = "skill_trainer" },
    },
    -- The Slayer masters. The ones not carded yet join by themselves when they are.
    {
        id = "slayer_masters", name = "Slayer masters",
        names = { "Turael", "Spria", "Mazchna", "Achtryn", "Vannaka", "Chaeldar", "Sumona", "Duradel", "Lapalok",
            "Kuradal", "Morvran", "Laniakea", "Mandrith", "Jacquelyn" },
        filter = { kind = "npc" },
    },
    {
        id = "god_emissaries", name = "God emissaries",
        filter = { kind = "npc", category = "emissary" },
    },
    {
        id = "archaeology_collectors", name = "Archaeology collectors",
        filter = { kind = "npc", category = "archaeology_collector" },
    },
    {
        id = "witches", name = "Witches", group = "Magic users",
        filter = { kind = "npc", category = "witch" },
    },

    -- Items. These are hand-picked: the tags (category = "bar", "ore"...) also take in quest, minigame and
    -- Dungeoneering versions, which would bury the set people actually work through.
    {
        id = "swords", name = "Swords", group = "Weapons",
        add = { "bronze_sword", "iron_sword", "steel_sword", "black_sword", "white_sword", "mithril_sword",
            "adamant_sword", "rune_sword" },
    },
    {
        id = "metal_bars", name = "Metal bars", group = "Crafted resources",
        add = { "bronze_bar", "iron_bar", "silver_bar", "steel_bar", "gold_bar", "mithril_bar", "adamant_bar",
            "rune_bar", "orikalkum_bar", "necronium_bar", "bane_bar", "elder_rune_bar" },
    },
    {
        id = "ores", name = "Ores", group = "Raw resources",
        add = { "copper_ore", "tin_ore", "iron_ore", "coal", "silver_ore", "mithril_ore", "adamantite_ore",
            "luminite", "gold_ore", "runite_ore", "orichalcite_ore", "drakolith", "necrite_ore", "phasmatite",
            "banite_ore", "light_animica", "dark_animica" },
    },
    {
        id = "grimy_herbs", name = "Grimy herbs", group = "Raw resources",
        add = { "grimy_guam", "grimy_tarromin", "grimy_marrentill", "grimy_harralander", "grimy_ranarr",
            "grimy_toadflax", "grimy_spirit_weed", "grimy_irit", "grimy_wergali", "grimy_avantoe", "grimy_kwuarm",
            "grimy_bloodweed", "grimy_snapdragon", "grimy_cadantine", "grimy_lantadyme", "grimy_dwarf_weed",
            "grimy_torstol", "grimy_fellstalk", "grimy_arbuck" },
    },

    -- Weapons
    {
        id = "scimitars", name = "Scimitars", group = "Weapons",
        add = { "bronze_scimitar", "iron_scimitar", "steel_scimitar", "black_scimitar", "white_scimitar",
            "mithril_scimitar", "adamant_scimitar", "rune_scimitar", "dragon_scimitar" },
    },
    {
        id = "daggers", name = "Daggers", group = "Weapons",
        add = { "bronze_dagger", "iron_dagger", "steel_dagger", "black_dagger", "white_dagger", "mithril_dagger",
            "adamant_dagger", "rune_dagger", "dragon_dagger" },
    },
    {
        id = "longswords", name = "Longswords", group = "Weapons",
        add = { "bronze_longsword", "iron_longsword", "steel_longsword", "black_longsword", "white_longsword",
            "mithril_longsword", "adamant_longsword", "rune_longsword", "dragon_longsword" },
    },
    {
        id = "two_handed_swords", name = "Two-handed swords", group = "Weapons",
        add = { "bronze_2h_sword", "iron_2h_sword", "steel_2h_sword", "black_2h_sword", "white_2h_sword",
            "mithril_2h_sword", "adamant_2h_sword", "rune_2h_sword", "dragon_2h_sword" },
    },
    {
        id = "battleaxes", name = "Battleaxes", group = "Weapons",
        add = { "bronze_battleaxe", "iron_battleaxe", "steel_battleaxe", "black_battleaxe", "white_battleaxe",
            "mithril_battleaxe", "adamant_battleaxe", "rune_battleaxe", "dragon_battleaxe" },
    },
    {
        id = "maces", name = "Maces", group = "Weapons",
        add = { "bronze_mace", "iron_mace", "steel_mace", "black_mace", "white_mace", "mithril_mace", "adamant_mace",
            "rune_mace", "dragon_mace" },
    },
    {
        id = "warhammers", name = "Warhammers", group = "Weapons",
        add = { "bronze_warhammer", "iron_warhammer", "steel_warhammer", "black_warhammer", "white_warhammer",
            "mithril_warhammer", "adamant_warhammer", "rune_warhammer", "dragon_warhammer" },
    },
    {
        id = "spears", name = "Spears", group = "Weapons",
        add = { "bronze_spear", "iron_spear", "steel_spear", "black_spear", "mithril_spear", "adamant_spear",
            "rune_spear", "dragon_spear" },
    },
    {
        id = "halberds", name = "Halberds", group = "Weapons",
        add = { "bronze_halberd", "iron_halberd", "steel_halberd", "black_halberd", "white_halberd",
            "mithril_halberd", "adamant_halberd", "rune_halberd", "dragon_halberd" },
    },
    {
        id = "claws", name = "Claws", group = "Weapons",
        add = { "bronze_claws", "iron_claws", "steel_claws", "black_claw", "white_claw", "mithril_claws",
            "adamant_claws", "rune_claws", "dragon_claw" },
    },
    {
        id = "shortbows", name = "Shortbows", group = "Weapons",
        add = { "shortbow", "oak_shortbow", "willow_shortbow", "maple_shortbow", "acadia_shortbow", "yew_shortbow",
            "magic_shortbow", "elder_shortbow", "eternal_magic_shortbow" },
    },
    {
        id = "longbows", name = "Longbows", group = "Weapons",
        add = { "longbow", "oak_longbow", "willow_longbow", "maple_longbow", "acadia_longbow", "yew_longbow",
            "magic_longbow", "elder_longbow", "eternal_magic_longbow" },
    },
    {
        id = "elemental_staves", name = "Elemental staves", group = "Weapons",
        add = { "air_battlestaff", "water_battlestaff", "earth_battlestaff", "fire_battlestaff", "lava_battlestaff",
            "mud_battlestaff", "steam_battlestaff", "mystic_air_staff", "mystic_water_staff", "mystic_earth_staff",
            "mystic_fire_staff", "mystic_lava_staff", "mystic_mud_staff", "mystic_steam_staff" },
    },

    -- Raw resources
    {
        id = "logs", name = "Logs", group = "Raw resources",
        add = { "logs", "oak_logs", "willow_logs", "teak_logs", "maple_logs", "acadia_logs", "mahogany_logs",
            "yew_logs", "magic_logs", "elder_logs", "eternal_magic_logs" },
    },
    {
        id = "uncut_gems", name = "Uncut gems", group = "Raw resources",
        add = { "uncut_opal", "uncut_jade", "uncut_red_topaz", "uncut_sapphire", "uncut_emerald", "uncut_ruby",
            "uncut_diamond", "uncut_dragonstone", "uncut_onyx", "uncut_hydrix" },
    },
    {
        id = "raw_fish", name = "Raw fish", group = "Raw resources",
        add = { "raw_shrimps", "raw_sardine", "raw_herring", "raw_anchovies", "raw_mackerel", "raw_trout", "raw_cod",
            "raw_pike", "raw_salmon", "raw_tuna", "raw_lobster", "raw_bass", "raw_swordfish", "raw_monkfish",
            "raw_shark", "raw_sea_turtle", "raw_manta_ray", "raw_cavefish", "raw_rocktail", "raw_sailfish" },
    },
    {
        id = "bones_and_ashes", name = "Bones and ashes", group = "Raw resources",
        add = { "bones", "big_bones", "baby_dragon_bones", "wyvern_bones", "dragon_bones", "dagannoth_bones",
            "frost_dragon_bones", "ourg_bones", "airut_bones", "reinforced_dragon_bones", "hardened_dragon_bones",
            "dinosaur_bones", "impious_ashes", "accursed_ashes", "infernal_ashes", "tortured_ashes", "searing_ashes" },
    },

    -- Crafted resources
    {
        id = "planks", name = "Planks", group = "Crafted resources",
        add = { "plank", "oak_plank", "willow_plank", "teak_plank", "maple_plank", "acadia_plank", "mahogany_plank",
            "yew_plank", "magic_plank", "elder_plank", "eternal_plank" },
    },
    {
        id = "cut_gems", name = "Cut gems", group = "Crafted resources",
        add = { "opal", "jade", "red_topaz", "sapphire", "emerald", "ruby", "diamond", "dragonstone", "onyx",
            "hydrix" },
    },
    {
        id = "clean_herbs", name = "Clean herbs", group = "Crafted resources",
        add = { "clean_guam", "clean_tarromin", "clean_marrentill", "clean_harralander", "clean_ranarr",
            "clean_toadflax", "clean_spirit_weed", "clean_irit", "clean_wergali", "clean_avantoe", "clean_kwuarm",
            "clean_bloodweed", "clean_snapdragon", "clean_cadantine", "clean_lantadyme", "clean_dwarf_weed",
            "clean_torstol", "clean_fellstalk", "clean_arbuck" },
    },
    {
        id = "runes", name = "Runes", group = "Crafted resources",
        add = { "air_rune", "water_rune", "earth_rune", "fire_rune", "mind_rune", "body_rune", "cosmic_rune",
            "chaos_rune", "nature_rune", "law_rune", "death_rune", "blood_rune", "soul_rune", "astral_rune",
            "armadyl_rune", "time_rune", "spirit_rune", "bone_rune", "flesh_rune", "miasma_rune" },
    },
    {
        id = "combination_runes", name = "Combination runes", group = "Crafted resources",
        add = { "dust_rune", "lava_rune", "mist_rune", "mud_rune", "smoke_rune", "steam_rune" },
    },

    -- Metal armour
    {
        id = "bronze_armour", name = "Bronze armour", group = "Metal armour",
        add = { "bronze_chainbody", "bronze_platebody", "bronze_armoured_boots", "bronze_gauntlets",
            "bronze_full_helm", "bronze_med_helm", "bronze_platelegs", "bronze_plateskirt", "bronze_kiteshield",
            "bronze_square_shield", "bronze_defender" },
    },
    {
        id = "iron_armour", name = "Iron armour", group = "Metal armour",
        add = { "iron_chainbody", "iron_platebody", "iron_armoured_boots", "iron_gauntlets", "iron_full_helm",
            "iron_med_helm", "iron_platelegs", "iron_plateskirt", "iron_kiteshield", "iron_square_shield",
            "iron_defender" },
    },
    {
        id = "steel_armour", name = "Steel armour", group = "Metal armour",
        add = { "steel_chainbody", "steel_platebody", "steel_armoured_boots", "steel_gauntlets", "steel_full_helm",
            "steel_med_helm", "steel_platelegs", "steel_plateskirt", "steel_kiteshield", "steel_square_shield",
            "steel_defender" },
    },
    {
        id = "black_armour", name = "Black armour", group = "Metal armour",
        add = { "black_chainbody", "black_platebody", "black_boots", "black_gauntlets", "black_full_helm",
            "black_helm", "black_platelegs", "black_plateskirt", "black_kiteshield", "black_sq_shield",
            "black_defender" },
    },
    {
        id = "white_armour", name = "White armour", group = "Metal armour",
        add = { "white_chainbody", "white_platebody", "white_boots", "white_gauntlets", "white_full_helm",
            "white_helm", "white_platelegs", "white_plateskirt", "white_kiteshield", "white_sq_shield" },
    },
    {
        id = "mithril_armour", name = "Mithril armour", group = "Metal armour",
        add = { "mithril_chainbody", "mithril_platebody", "mithril_armoured_boots", "mithril_gauntlets",
            "mithril_full_helm", "mithril_med_helm", "mithril_platelegs", "mithril_plateskirt", "mithril_kiteshield",
            "mithril_square_shield", "mithril_defender" },
    },
    {
        id = "adamant_armour", name = "Adamant armour", group = "Metal armour",
        add = { "adamant_chainbody", "adamant_platebody", "adamant_armoured_boots", "adamant_gauntlets",
            "adamant_full_helm", "adamant_med_helm", "adamant_platelegs", "adamant_plateskirt", "adamant_kiteshield",
            "adamant_square_shield", "adamant_defender" },
    },
    {
        id = "rune_armour", name = "Rune armour", group = "Metal armour",
        add = { "rune_chainbody", "rune_platebody", "rune_armoured_boots", "rune_gauntlets", "rune_full_helm",
            "rune_med_helm", "rune_platelegs", "rune_plateskirt", "rune_kiteshield", "rune_square_shield",
            "rune_defender" },
    },
    {
        id = "dragon_armour", name = "Dragon armour", group = "Metal armour",
        add = { "dragon_chainbody", "dragon_platebody", "dragon_boots", "dragon_gauntlets", "dragon_helm",
            "dragon_full_helm", "dragon_platelegs", "dragon_plateskirt", "dragon_sq_shield", "dragon_kiteshield",
            "dragon_defender" },
    },
    {
        id = "orikalkum_armour", name = "Orikalkum armour", group = "Metal armour",
        add = { "orikalkum_platebody", "orikalkum_armoured_boots", "orikalkum_gauntlets", "orikalkum_full_helm",
            "orikalkum_platelegs", "orikalkum_kiteshield" },
    },
    {
        id = "necronium_armour", name = "Necronium armour", group = "Metal armour",
        add = { "necronium_platebody", "necronium_armoured_boots", "necronium_gauntlets", "necronium_full_helm",
            "necronium_platelegs", "necronium_kiteshield" },
    },
    {
        id = "bane_armour", name = "Bane armour", group = "Metal armour",
        add = { "bane_platebody", "bane_armoured_boots", "bane_gauntlets", "bane_full_helm", "bane_platelegs",
            "bane_square_shield" },
    },
    {
        id = "elder_rune_armour", name = "Elder rune armour", group = "Metal armour",
        add = { "elder_rune_platebody", "elder_rune_armoured_boots", "elder_rune_gauntlets", "elder_rune_full_helm",
            "elder_rune_platelegs" },
    },
    {
        id = "primal_armour", name = "Primal armour", group = "Metal armour",
        add = { "primal_chainbody", "primal_platebody", "primal_boots", "primal_armoured_boots", "primal_gauntlets",
            "primal_full_helm", "primal_plateskirt", "primal_platelegs", "primal_kiteshield" },
    },
    {
        id = "granite_armour", name = "Granite armour", group = "Metal armour",
        add = { "granite_helm", "granite_shield" },
    },

    -- Dragonhide armour
    {
        id = "green_dragonhide", name = "Green dragonhide", group = "Dragonhide armour",
        add = { "green_dragonhide_body", "green_dragonhide_boots", "green_dragonhide_vambraces",
            "green_dragonhide_coif", "green_dragonhide_chaps", "green_dragonhide_shield", "green_spiky_vambraces" },
    },
    {
        id = "blue_dragonhide", name = "Blue dragonhide", group = "Dragonhide armour",
        add = { "blue_dragonhide_body", "blue_dragonhide_boots", "blue_dragonhide_vambraces", "blue_dragonhide_coif",
            "blue_dragonhide_chaps", "blue_dragonhide_shield", "blue_spiky_vambraces" },
    },
    {
        id = "red_dragonhide", name = "Red dragonhide", group = "Dragonhide armour",
        add = { "red_dragonhide_body", "red_dragonhide_boots", "red_dragonhide_vambraces", "red_dragonhide_coif",
            "red_dragonhide_chaps", "red_dragonhide_shield", "red_spiky_vambraces" },
    },
    {
        id = "black_dragonhide", name = "Black dragonhide", group = "Dragonhide armour",
        add = { "black_dragonhide_body", "black_dragonhide_boots", "black_dragonhide_vambraces",
            "black_dragonhide_coif", "black_dragonhide_chaps", "black_dragonhide_shield", "black_spiky_vambraces" },
    },
    {
        id = "royal_dragonhide", name = "Royal dragonhide", group = "Dragonhide armour",
        add = { "royal_dragonhide_body", "royal_dragonhide_boots", "royal_dragonhide_vambraces",
            "royal_dragonhide_coif", "royal_dragonhide_chaps", "royal_spiky_vambraces" },
    },
    {
        id = "undead_dragonhide", name = "Undead dragonhide", group = "Dragonhide armour",
        add = { "undead_dragonhide_body", "undead_dragonhide_boots", "undead_dragonhide_vambraces",
            "undead_dragonhide_coif", "undead_dragonhide_chaps" },
    },

    -- Leather armour
    {
        id = "leather_armour", name = "Leather armour", group = "Leather armour",
        add = { "leather_body", "leather_boots", "leather_gloves", "leather_vambraces", "leather_cowl",
            "leather_chaps", "leather_shield", "spiky_vambraces" },
    },
    {
        id = "hard_leather_armour", name = "Hard leather armour", group = "Leather armour",
        add = { "hard_leather_body", "hard_leather_boots", "hard_leather_gloves", "hard_leather_cowl",
            "hard_leather_chaps", "hard_leather_shield" },
    },
    {
        id = "studded_leather_armour", name = "Studded leather armour", group = "Leather armour",
        add = { "studded_body", "studded_chaps", "studded_leather_boots", "studded_leather_gloves",
            "studded_leather_coif", "studded_leather_shield" },
    },
    {
        id = "snakeskin_armour", name = "Snakeskin armour", group = "Leather armour",
        add = { "snakeskin_body", "snakeskin_boots", "snakeskin_vambraces", "snakeskin_bandana", "snakeskin_chaps" },
    },
    {
        id = "carapace_armour", name = "Carapace armour", group = "Leather armour",
        add = { "carapace_torso", "carapace_boots", "carapace_gloves", "carapace_helm", "carapace_legs",
            "carapace_shield" },
    },

    -- Cloth armour
    {
        id = "spider_silk_armour", name = "Spider silk armour", group = "Cloth armour",
        add = { "spider_silk_robe_top", "spider_silk_boots", "spider_silk_gloves", "spider_silk_hood",
            "spider_silk_robe_bottom", "spider_silk_shield" },
    },
    {
        id = "splitbark_armour", name = "Splitbark armour", group = "Cloth armour",
        add = { "splitbark_body", "splitbark_boots", "splitbark_gauntlets", "splitbark_helm", "splitbark_legs",
            "splitbark_shield", "splitbark_orb", "splitbark_wand" },
    },
    {
        id = "batwing_armour", name = "Batwing armour", group = "Cloth armour",
        add = { "batwing_torso", "batwing_boots", "batwing_gloves", "batwing_hood", "batwing_legs", "batwing_shield",
            "batwing_book", "batwing_wand" },
    },

    -- God items
    {
        id = "god_vestments", name = "God vestments", group = "God items",
        add = { "saradomin_mitre", "zamorak_mitre", "guthix_mitre", "armadyl_mitre", "bandos_mitre", "ancient_mitre",
            "armadyl_robe_top", "armadyl_robe_legs", "bandos_robe_top", "bandos_robe_legs", "ancient_robe_top",
            "ancient_robe_legs", "armadyl_cloak", "bandos_cloak", "ancient_cloak" },
    },
    {
        id = "god_weapons", name = "God weapons", group = "God items",
        add = { "armadyl_godsword", "bandos_godsword", "saradomin_godsword", "zamorak_godsword", "zaros_godsword",
            "saradomin_sword", "zamorakian_spear" },
    },
}
