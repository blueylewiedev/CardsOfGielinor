-- dev/anim_sets.lua
-- Made by dev/anim_sets.py from the RuneScape client's cache. Do not edit; run it again.
-- Every animation set (an NPC's `bas`: config.NPC.FromID(id).bas.id) and its animations:
-- stand, walk, run and their directions and turns, and `idles`, the animations it plays
-- now and then, as { id, weight }. The comment is the standing animation's name.
return {
    [0] = { stand = 738, walk = 737, turnLeft = 737, turnRight = 737, walkBack = 737, walkLeft = 737, walkRight = 737 },  -- HUMAN_CLIMBING_READY
    [1] = { stand = 808, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2] = { stand = 101, walk = 98 },  -- DWARF_READY
    [3] = { stand = 1386, walk = 1380, run = 1381, runBack = 1381, runLeft = 1381, runRight = 1381, walkBack = 1380, walkLeft = 1380, walkRight = 1380 },  -- M_MONKEY_READY
    [4] = { stand = 808, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [5] = { stand = 7575, walk = 8337 },  -- LORE_DOG_READY_1
    [6] = { stand = 5225, walk = 5226, run = 12823 },  -- HUNTER_BIG_CAT_READY
    [7] = { stand = 8271, walk = 8273, run = 1848 },  -- LORE_BAT_READY
    [8] = { stand = 8077, walk = 8076, run = 2391 },  -- LORE_PYREFIEND_READY
    [9] = { stand = 281, walk = 280 },  -- V02_CALF_UPDATE_READY
    [10] = { walk = 7719, crawl = 9951, run = 2176, idles = { { 9952, 80 }, { 9953, 20 } } },
    [11] = { stand = 544, walk = 543, run = 12827 },  -- V02_YAK_UPDATE_READY
    [12] = { stand = 8572, walk = 8575, run = 1762 },  -- JELLY_UPDATE_READY
    [13] = { stand = 17288, walk = 17289, run = 1478, turnLeft = 4923, turnRight = 4923, walkLeft = 17289, walkRight = 17289, walkTurnLeft = 17289, walkTurnRight = 17289 },  -- BEAR_UPDATE_READY
    [14] = { stand = 8008, walk = 8007, run = 3372 },  -- LORE_BIRD_READY
    [15] = { stand = 1008, walk = 1007 },  -- POG_TERROR_BIRD_READY
    [16] = { stand = 11092, walk = 11094, run = 906 },  -- PHOENIX_PHOENIX_FAMILIAR_READY
    [17] = { stand = 5326, walk = 5325, run = 905 },  -- SPIDER_UPDATE_READY
    [18] = { stand = 7760, walk = 7759, run = 12821 },  -- LORE_COCKATRICE_READY
    [19] = { stand = 8310, walk = 8312 },  -- LORE_CHICK_READY
    [20] = { stand = 7659, walk = 7658 },  -- LORE_VULTURE_READY
    [21] = { stand = 11083, walk = 11082 },  -- PHOENIX_EGGLING_READY
    [22] = { stand = 11138, walk = 11139 },  -- PHOENIX_EVIL_EGGLING_READY
    [23] = { stand = 8363, walk = 8365 },  -- LORE_CHAMELEON_READY
    [24] = { stand = 7728, walk = 10954 },  -- LORE_BOAR_READY_AND_EXTRA
    [25] = { stand = 663, walk = 663 },  -- BLAST_TRAVEL
    [26] = { stand = 5607, walk = 5606 },  -- LOTR_SHYLOC_READY
    [27] = { stand = 1662, walk = 1663, run = 1664, turnLeft = 823, turnRight = 823, walkBack = 1663, walkLeft = 1663, walkRight = 1663 },  -- SLAYER_GRANITE_MAUL_READY
    [28] = { stand = 813, walk = 1205, run = 1210, turnLeft = 1205, turnRight = 1205, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [29] = { stand = 813, walk = 1205, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [30] = { stand = 10898, walk = 10899 },  -- LUC2_HARRALAK_INJURED_READY
    [31] = { stand = 2561, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_DH_WEAPON_READY
    [32] = { stand = 112, walk = 106 },  -- FAIRY_READY
    [33] = { stand = 9469, walk = 9470 },  -- SPECTRE_UPDATE_READY
    [34] = { stand = 9452, walk = 9453 },  -- BANSHEE_UPDATE_READY
    [35] = { stand = 7188, walk = 7191, walkBack = 7192, walkLeft = 7193, walkRight = 7194 },  -- PIRATE_UPDATE_READY_AND_EXTRA
    [36] = { stand = 3169, walk = 3169 },  -- CLOUD_RAIN
    [37] = { stand = 1796, walk = 1797 },  -- GIANT_FROG_READY
    [38] = { stand = 5572, walk = 5570, walkBack = 5790, walkLeft = 5788, walkRight = 5789 },  -- ZOMBIE_UPDATE_READY_WEAPON
    [39] = { stand = 2561, walk = 2562 },  -- HUMAN_DH_WEAPON_READY
    [40] = { stand = 7188, walk = 7189, walkBack = 7190, walkLeft = 7193, walkRight = 7194 },  -- PIRATE_UPDATE_READY_AND_EXTRA
    [41] = { stand = 9158, walk = 9157 },  -- CAT_UPDATE_READY
    [42] = { stand = 286, walk = 283 },  -- TROLL_READY
    [43] = { stand = 456 },  -- WHIRLPOOL
    [44] = { stand = 96, walk = 93 },  -- DRYHAD_READY
    [45] = { stand = 3, walk = 7189, walkBack = 7190, walkLeft = 7193, walkRight = 7194 },  -- PIRATE_UPDATE_READY_AND_EXTRA_BOTTLE
    [46] = { stand = 155, walk = 152 },  -- GOLEM_READY
    [47] = { stand = 808 },  -- HUMAN_READY
    [48] = { walk = 21369, idles = { { 21368, 95 }, { 21373, 5 } } },
    [49] = { stand = 0, walk = 0 },  -- SWARM_WALK
    [50] = { stand = 2298, walk = 2297 },  -- ROOSTERREADY
    [51] = { stand = 4591, walk = 4226, walkBack = 4227, walkLeft = 821, walkRight = 822 },  -- XBOWS_HUMAN_READY
    [52] = { stand = 2770, walk = 2769 },  -- DRUNK_PLAYER_READY
    [53] = { stand = 813, walk = 1146, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_STAFFREADY
    [54] = { stand = 808, walk = 819 },  -- HUMAN_READY
    [55] = { stand = 4662, walk = 4660 },  -- GIANT_UPDATE_FIRE_READY
    [56] = { stand = 4663, walk = 4661 },  -- GIANT_UPDATE_FIRE_SWORD_READY
    [57] = { stand = 4656, walk = 4654 },  -- GIANT_UPDATE_MOSS_READY
    [58] = { stand = 4656, walk = 4655 },  -- GIANT_UPDATE_MOSS_READY
    [59] = { stand = 130, walk = 127 },  -- GIANT_READY
    [60] = { stand = 357, walk = 358 },  -- OGRE_READY
    [61] = { stand = 4650, walk = 4649 },  -- GIANT_UPDATE_BASIC_READY
    [62] = { stand = 5386, walk = 5385 },  -- LORE_CHICKEN_READY
    [63] = { stand = 5339, walk = 5340 },  -- GOAT_UPDATE_READY
    [64] = { stand = 5335, walk = 5334 },  -- SHEEP_UPDATE_READY
    [65] = { stand = 5345, walk = 5344 },  -- SHEEP_UPDATE_SHAGGY_READY
    [66] = { stand = 147, walk = 149 },  -- V02_COW_UPDATE_READY
    [67] = { stand = 5565, walk = 5566, walkBack = 5790, walkLeft = 5788, walkRight = 5789 },  -- ZOMBIE_UPDATE_READY_NORMAL
    [68] = { stand = 5576, walk = 5577, walkBack = 5793, walkLeft = 5792, walkRight = 5791 },  -- ZOMBIE_UPDATE_READY_DRAGGING
    [69] = { stand = 5565, walk = 5570, walkBack = 5790, walkLeft = 5788, walkRight = 5789 },  -- ZOMBIE_UPDATE_READY_NORMAL
    [70] = { stand = 5483, walk = 5481 },  -- SKELETON_UPDATE_READY
    [71] = { stand = 5483, walk = 5479 },  -- SKELETON_UPDATE_READY
    [72] = { stand = 5493, walk = 5497 },  -- SKELETON_UPDATE_GIANT_READY
    [73] = { stand = 5538, walk = 5539 },  -- GHOST_UPDATE_TENDRILL_READY
    [74] = { stand = 5530, walk = 5531 },  -- GHOST_UPDATE_NORMAL_READY
    [75] = { stand = 66, walk = 63 },  -- DEMON_READY
    [76] = { stand = 4914, walk = 4913 },  -- BAT_REWORK_READY
    [77] = { stand = 90, walk = 79 },  -- DRAGON_READY
    [78] = { stand = 7047, walk = 7046, walkBack = 7045, walkLeft = 7044, walkRight = 7043 },  -- DH_SWORD_UPDATE_READY
    [79] = { stand = 1322, walk = 1323, walkBack = 1324, walkLeft = 1325, walkRight = 1326 },  -- VIKING_DRINKING_READY
    [80] = { stand = 1137, walk = 1323, walkBack = 1324, walkLeft = 1325, walkRight = 1326 },  -- HUMAN_SITTING_CHAIR
    [81] = { stand = 2702, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- PRISONER_READY_CRYING
    [82] = { stand = 1310, walk = 1311 },  -- HORROR_CRAB_READY
    [83] = { stand = 6771, walk = 6773 },  -- BIRD_FLYING_UPDATE_READY_AND_EXTRA
    [84] = { stand = 5572, walk = 5570 },  -- ZOMBIE_UPDATE_READY_WEAPON
    [85] = { stand = 6772, walk = 6774 },  -- BIRD_FLYING_UPDATE_READY_AND_EXTRA_TOUCAN_AND_CORMARANT
    [86] = { stand = 6181, walk = 6180 },  -- SLICE_SURFACE_GOBLIN_SQUAT_READY
    [87] = { stand = 6186, walk = 6187 },  -- SLICE_SURFACE_GOBLIN_SQUAT_READY_SPEAR
    [88] = { stand = 166, walk = 162 },  -- HOBGOBLIN_READY
    [89] = { walk = 362, idles = { { 362, 150 }, { 31117, 150 } } },
    [90] = { stand = 5668, walk = 5666 },  -- PENG_GENTOO_READY
    [91] = { stand = 6793, walk = 6796 },  -- MOUNTED_TERRORBIRD_READY
    [92] = { stand = 808, walk = 808 },  -- HUMAN_READY
    [93] = { stand = 12454, walk = 5799 },  -- FAI_VARROCK_BROOMING_STILL
    [94] = { stand = 4777, walk = 4773 },  -- STRAYDOG_READY
    [95] = { stand = 6487, walk = 6486 },  -- FAI_VARROCK_GUARD_READY
    [96] = { stand = 6561, walk = 6583 },  -- DOG_UPDATE_SMALL_DOG_READY
    [97] = { stand = 6580, walk = 6556, turnLeft = 3967, turnRight = 3967, walkLeft = 6556, walkRight = 6556, walkTurnLeft = 6556, walkTurnRight = 6556 },  -- DOG_UPDATE_WOLF_READY
    [98] = { stand = 6561, walk = 37688 },  -- DOG_UPDATE_SMALL_DOG_READY
    [99] = { stand = 6247, walk = 6248 },  -- SMALL_SPIDER_UPDATE_READY
    [100] = { stand = 6252, walk = 6253 },  -- SCORPION_UPDATE_READY
    [101] = { stand = 2704, walk = 2703 },  -- MOUSE_READY
    [102] = { stand = 2065, walk = 2064 },  -- BARROW_DHAROK_READY
    [103] = { stand = 2561, walk = 2562, run = 16414, walkBack = 2562, walkLeft = 2562, walkRight = 2562 },  -- HUMAN_DH_WEAPON_READY
    [104] = { stand = 4318, walk = 4319 },  -- ORK_UPDATE_WEAPON_READY
    [105] = { stand = 7222, walk = 7223 },  -- SEERS_GUARD_READY_AND_EXTRA_NOSHIELD
    [106] = { stand = 7222, walk = 7224 },  -- SEERS_GUARD_READY_AND_EXTRA_NOSHIELD
    [107] = { stand = 7217, walk = 7216 },  -- SEERS_GUARD_READY_AND_EXTRA
    [108] = { stand = 190 },  -- HUMAN_ACTOR_REST_TOO_HOT_LOOP
    [109] = { walk = 9670, idles = { { 9669, 80 }, { 309, 20 } } },
    [110] = { stand = 6374, walk = 6373 },  -- UNICORN_REWORK_READY
    [111] = { stand = 842, walk = 841 },  -- HUMAN_TRANSREADY
    [112] = { stand = 187, walk = 181 },  -- MAGICAXE_READY
    [113] = { stand = 277, walk = 274 },  -- SNAKE_READY
    [114] = { stand = 257, walk = 254 },  -- SKAVID_READY
    [115] = { stand = 296, walk = 293 },  -- YETI_READY
    [116] = { stand = 222, walk = 219, run = 1419, runBack = 1419, runLeft = 1419, runRight = 1419, walkBack = 219, walkLeft = 219, walkRight = 219 },  -- MONKEY_READY
    [117] = { stand = 808, walk = 819 },  -- HUMAN_READY
    [118] = { stand = 808, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [119] = { stand = 813, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_STAFFREADY
    [120] = { stand = 2163, walk = 2164 },  -- SPADE_READY
    [121] = { stand = 4857, walk = 4858 },  -- FAI_LUMBRIDGE_GUIDE_READY
    [122] = { stand = 1275, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- GHOUL_READY
    [123] = { stand = 16005, walk = 16006 },  -- DRUID_READY_UPDATE
    [124] = { stand = 7047, walk = 7046, run = 7039, turnLeft = 7040, turnRight = 7040, walkBack = 7045, walkLeft = 7044, walkRight = 7043 },  -- DH_SWORD_UPDATE_READY
    [125] = { stand = 1261, walk = 1261 },  -- MISTY
    [126] = { stand = 2906, walk = 2907 },  -- ELID_WATERSPIRIT_READY
    [127] = { stand = 9158, walk = 9156 },  -- CAT_UPDATE_READY
    [128] = { stand = 9654 },  -- GAME_CASTLEWARS_UPDATE_BARRICADE_BURNING
    [129] = { stand = 6089, walk = 6088 },  -- RABBIT_UPDATE_READY
    [130] = { stand = 171, walk = 168, run = 4626 },  -- IMP_READY
    [131] = { stand = 1421, walk = 1422, run = 1427, turnLeft = 1426, turnRight = 1426, walkBack = 1423, walkLeft = 1424, walkRight = 1425 },  -- HUMAN_BANNERREADY
    [132] = { stand = 242, walk = 239 },  -- RAT_READY
    [133] = { stand = 4932, walk = 4931 },  -- GIANT_RAT_UPDATE_READY
    [134] = { stand = 2065, walk = 2064, run = 9721, turnLeft = 823, turnRight = 823, walkBack = 2064, walkLeft = 2064, walkRight = 2064 },  -- BARROW_DHAROK_READY
    [135] = { stand = 1947, walk = 1945 },  -- SCARAB_READY
    [136] = { stand = 17889, walk = 17889 },  -- ORNATEBOWL_LIGHT_CREATURE_IDLE_WALK
    [137] = { stand = 3926 },  -- PEST_VOID_KNIGHT_CASTING
    [138] = { stand = 3886, walk = 3887 },  -- SPLATTER_READY
    [139] = { stand = 3899, walk = 3898 },  -- SHIFTER_READY
    [140] = { stand = 3913, walk = 3914 },  -- RAVAGER_READY
    [141] = { stand = 3906, walk = 3907 },  -- SPINNER_READY
    [142] = { stand = 3878, walk = 3879 },  -- TORCHER_READY
    [143] = { stand = 3918, walk = 3919 },  -- DEFILER_READY
    [144] = { stand = 3893, walk = 3892 },  -- BRAWLER_READY
    [145] = { stand = 3933, walk = 3933 },  -- PEST_PORTAL_ON_ANIM_EAST
    [146] = { stand = 3936, walk = 3936 },  -- PEST_PORTAL_ON_ANIM_WEST
    [147] = { stand = 3928, walk = 3928 },  -- PEST_PORTAL_ON_ANIM
    [148] = { stand = 6879, walk = 6879 },  -- PEST_PORTAL_SHIELD_READY_EAST
    [149] = { stand = 6880, walk = 6880 },  -- PEST_PORTAL_SHIELD_READY_WEST
    [150] = { stand = 6878, walk = 6878 },  -- PEST_PORTAL_SHIELD_READY
    [151] = { stand = 10, walk = 10 },  -- SHARK_WALK
    [152] = { stand = 773, walk = 772, turnLeft = 772, turnRight = 772, walkBack = 772, walkLeft = 772, walkRight = 772 },  -- HUMAN_SWIM_READY
    [153] = { stand = 3396, walk = 3396 },  -- _100_SIT_READY_CHAIR
    [154] = { stand = 4753, walk = 4754 },  -- MYQ3_LEAVES_READY
    [155] = { stand = 763, walk = 762, turnLeft = 762, turnRight = 762, walkBack = 762, walkLeft = 762, walkRight = 762 },  -- HUMAN_WALK_LOGBALANCE_READY
    [156] = { stand = 755, walk = 754, turnLeft = 755, turnRight = 755, walkBack = 754, walkLeft = 754, walkRight = 754 },  -- HUMAN_READY_SIDESTEP
    [157] = { stand = 757, walk = 756, turnLeft = 757, turnRight = 757, walkBack = 756, walkLeft = 756, walkRight = 756 },  -- HUMAN_READY_SIDESTEPL
    [158] = { stand = 746, walk = 749, run = 748, turnLeft = 6611, turnRight = 6611, walkBack = 10577, walkLeft = 6610, walkRight = 6609 },  -- HUMAN_NET_READY_UPDATE
    [159] = { stand = 808, walk = 819, run = 15070, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [160] = { stand = 808, walk = 824, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [161] = { stand = 4689, walk = 4683 },  -- MYQ3_VAMPIRE_FLYING_READY
    [162] = { stand = 9117 },  -- MYQ4_FLYING_VYREWATCH_HELD
    [163] = { stand = 765, walk = 765, turnLeft = 765, turnRight = 765, walkBack = 765, walkLeft = 765, walkRight = 765 },  -- HUMAN_DROWNING
    [164] = { stand = 772, walk = 772, turnLeft = 772, turnRight = 772, walkBack = 772, walkLeft = 772, walkRight = 772 },  -- HUMAN_SWIM
    [165] = { stand = 7158, walk = 7160 },  -- CHILD_UPDATE_READY
    [166] = { stand = 808, walk = 1146 },  -- HUMAN_READY
    [167] = { stand = 1092, walk = 1091 },  -- INV_GHAST_READY
    [168] = { stand = 1086, walk = 1085 },  -- GHAST_READY
    [169] = { stand = 1282, walk = 1281 },  -- SHADE_READY
    [170] = { stand = 3551 },  -- BURGH_HUMAN_HOLDING_CAPTURE_LOOP
    [171] = { stand = 3617, walk = 3617 },  -- TENTACLE_MONSTER_READY
    [172] = { stand = 6613, walk = 6614 },  -- II_IMPLING_READY
    [173] = { stand = 8726, walk = 8723 },  -- RABBIT_FARMER_SPADE_PAT_READY
    [174] = { stand = 8721, walk = 8722 },  -- RABBIT_GNOME_WINKIN_READY
    [175] = { stand = 4591, walk = 4226, run = 4228, turnLeft = 823, turnRight = 823, walkBack = 4227, walkLeft = 821, walkRight = 822 },  -- XBOWS_HUMAN_READY
    [176] = { stand = 808, walk = 819, run = 9754, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [177] = { stand = 1386, walk = 1380 },  -- M_MONKEY_READY
    [178] = { stand = 9645, walk = 9645 },  -- FISHING_SPOT_UPDATE
    [179] = { stand = 7188, walk = 6531 },  -- PIRATE_UPDATE_READY_AND_EXTRA
    [180] = { stand = 3852, walk = 3851 },  -- EASTER07_EASTER_BUNNY_UPDATE_READY
    [181] = { stand = 5273, walk = 5272 },  -- HUNTINGBEAST_READY
    [182] = { stand = 1832, walk = 1830, run = 824, turnLeft = 823, turnRight = 823, walkBack = 1830, walkLeft = 821, walkRight = 822 },  -- HUMAN_RUBBER_CHICKEN_READY
    [183] = { stand = 1242, walk = 1243 },  -- RABBIT_READY
    [184] = { stand = 6518, walk = 6517 },  -- GRIM_GIANT_MOUSE_READY
    [185] = { stand = 8798, walk = 8794 },  -- SOPS_COCKROACH_READY_ONE_BY_ONE
    [186] = { stand = 5326, walk = 5325 },  -- SPIDER_UPDATE_READY
    [187] = { stand = 6580, walk = 6577 },  -- DOG_UPDATE_WOLF_READY
    [188] = { stand = 773, walk = 772, turnLeft = 773, turnRight = 773, walkBack = 772, walkLeft = 772, walkRight = 772 },  -- HUMAN_SWIM_READY
    [189] = { stand = 768, walk = 768, turnLeft = 768, turnRight = 768, walkBack = 768, walkLeft = 768, walkRight = 768 },  -- HUMAN_FALLING_4
    [190] = { stand = 6539, walk = 6541, turnLeft = 6539, turnRight = 6539, walkTurnLeft = 6541, walkTurnRight = 6541 },  -- WEREWOLF_UPDATE_READY
    [191] = { stand = 330, walk = 330, run = 330, turnLeft = 330, turnRight = 330, walkBack = 330, walkLeft = 330, walkRight = 330 },  -- MAGIC_CARPET_FLIGHT
    [192] = { stand = 1144 },  -- SITTING_READY
    [193] = { stand = 774 },  -- FAVOUR_SITTING_CHAIR_READY
    [194] = { stand = 27, walk = 21 },  -- BDRAG_READY
    [195] = { stand = 6218, walk = 6220 },  -- KALPHITE_UPDATE_READY
    [196] = { stand = 1338, walk = 1339 },  -- HORROR_DAGANNOTH_READY
    [197] = { stand = 9241, walk = 9240 },  -- TZHAAR_UPDATE_TOK_XIL_READY
    [198] = { stand = 12292, walk = 9680 },  -- FAI_LUMBRIDGE_DOOMSAYER_READY_UPDATE
    [199] = { stand = 6139, walk = 6138 },  -- SURFACE_GOBLIN_UPDATE_BANNER_READY
    [200] = { stand = 2931, walk = 2932 },  -- CHAMPIONS_JOGRE_READY
    [201] = { stand = 66, walk = 63 },  -- DEMON_READY
    [202] = { stand = 3424, walk = 3426 },  -- CRAB_READY
    [203] = { stand = 2395, walk = 2396 },  -- TBW_MOSQUITO_READY
    [204] = { stand = 9868, walk = 9869 },  -- FAI_LUMBRIDGE_MELEE_TUTOR_READY
    [205] = { stand = 9677, walk = 9869 },  -- FAI_LUMBRIDGE_RANGING_TUTOR_READY
    [206] = { stand = 9119, walk = 9676 },  -- FAI_LUMBRIDGE_MAGE_TUTOR_READY
    [207] = { stand = 9679 },  -- FAI_LUMBRIDGE_FISHING_TUTOR_READY
    [208] = { stand = 3461, walk = 9678 },  -- FAI_LUMBRIDGE_MINING_TUTOR_READY
    [209] = { stand = 9870, walk = 9870 },  -- FAI_LUMBRIDGE_GENERIC_READY
    [210] = { stand = 9735, walk = 9736, turnLeft = 9735, turnRight = 9735 },  -- FAI_AL_KHARID_GUARD_HALBERD_READY
    [211] = { stand = 2148, walk = 2148, run = 2148, turnLeft = 2148, turnRight = 2148, walkBack = 2148, walkLeft = 2148, walkRight = 2148 },  -- HUMAN_MINECART_ANIM
    [212] = { stand = 21719 },  -- SLISKE1_CUTSCENE1_S1_GROWING_SHADOW
    [213] = { stand = 21746 },  -- SLISKE1_MONK_SCARED_IDLE
    [214] = { stand = 6040, walk = 6041 },  -- DORGESH_GOBLIN_READY
    [215] = { stand = 6075, walk = 6076 },  -- DORGESH_MAGIC_SCAN_READY
    [216] = { stand = 813, walk = 1210, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [217] = { stand = 7167, walk = 7160 },  -- CHILD_READY_AND_EXTRA
    [218] = { stand = 3557, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- RAT_EAT_READY
    [219] = { stand = 8980, walk = 1205, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_UPDATE_READY_STAFF
    [220] = { stand = 7047, walk = 7039, walkBack = 7045, walkLeft = 7044, walkRight = 7043 },  -- DH_SWORD_UPDATE_READY
    [221] = { stand = 808, walk = 1661 },  -- HUMAN_READY
    [222] = { stand = 5225, walk = 5226 },  -- HUNTER_BIG_CAT_READY
    [223] = { stand = 1740, walk = 1739 },  -- CAPE_SELLER_READY
    [224] = { stand = 1183, walk = 1189 },  -- KALPHITE_READY
    [225] = { stand = 2364, walk = 2363 },  -- WALLASALKI_READY
    [226] = { stand = 813, walk = 1205, walkBack = 1205, walkLeft = 1205, walkRight = 1205 },  -- HUMAN_STAFFREADY
    [227] = { stand = 9281, walk = 9280 },  -- TZHAAR_UPDATE_TZHAAR_READY
    [228] = { stand = 9281, walk = 9296 },  -- TZHAAR_UPDATE_TZHAAR_READY
    [229] = { stand = 6580, walk = 6582 },  -- DOG_UPDATE_WOLF_READY
    [230] = { stand = 4299, walk = 4298 },  -- GORAK_READY
    [231] = { stand = 6153, walk = 6152 },  -- SLICE_SURFACE_GOBLIN_SERGENT_READY
    [232] = { stand = 6374, walk = 6373 },  -- UNICORN_REWORK_READY
    [233] = { stand = 4311, walk = 4310 },  -- FAIRY2_CENTAUR_READY
    [234] = { stand = 3175, walk = 3177, run = 3178, turnLeft = 3177, turnRight = 3177, walkBack = 3177, walkLeft = 3177, walkRight = 3177 },  -- HUMAN_CHINCHOMPA_READY
    [235] = { stand = 2257, walk = 2258, run = 2251, turnLeft = 2258, turnRight = 2258, walkBack = 2258, walkLeft = 2258, walkRight = 2258 },  -- RD_CARRY_FOX_READY
    [236] = { stand = 2256 },  -- RD_KNIGHT_CROSSED_ARMS
    [237] = { stand = 6927, walk = 6928 },  -- KR_KEEP_LE_FAYE_GUARD_READY
    [238] = { stand = 1412, walk = 37952 },  -- M_ASSASSIN_READY
    [239] = { stand = 4472, walk = 4473 },  -- EYEGLO_FLUFFIE_READY
    [240] = { stand = 808, walk = 6926 },  -- HUMAN_READY
    [241] = { stand = 1913, walk = 1912 },  -- CLAY_GOLEM_READY
    [242] = { stand = 7605, walk = 7606 },  -- SCAB_INSECTOID_READY_ARCHER
    [243] = { stand = 7610, walk = 7611 },  -- SCAB_INSECTOID_READY_LANCE
    [244] = { stand = 5548, walk = 5552 },  -- MUMMY_UPDATE_CIVILLIAN_READY
    [245] = { stand = 7618, walk = 7619 },  -- SCAB_INSECTOID_READY_MAGE
    [246] = { stand = 7583, walk = 7582 },  -- SCAB_LOCUST_READY
    [247] = { stand = 7589, walk = 7587 },  -- SCAB_CROCODILE_READY
    [248] = { stand = 7298, walk = 7297 },  -- CHILD_READY_UNHAPPY
    [249] = { stand = 1147, walk = 1147, walkBack = 1147, walkLeft = 1147, walkRight = 1147 },  -- WOUNDED_SITTING
    [250] = { stand = 1071, walk = 1071 },  -- WILLOWTHEWISP
    [251] = { stand = 6809, walk = 6808 },  -- FIREBIRD_UPDATE_READY
    [252] = { stand = 2334, walk = 2333 },  -- HUMAN_SECRET_GHOST_TRANSREADY
    [253] = { stand = 932, walk = 933 },  -- SEASLUG_READY
    [254] = { stand = 926, walk = 1139 },  -- TROLL_READY_SHIELD
    [255] = { stand = 6469, walk = 6468 },  -- FAI_VARROCK_IKOV_LUCIEN_READY
    [256] = { stand = 90, walk = 79 },  -- DRAGON_READY
    [257] = { stand = 2688, walk = 2689 },  -- DRAGONKIN_READY
    [258] = { stand = 927, walk = 1141 },  -- TROLL_READY_SWORDPLUSSHIELD
    [259] = { walk = 9670, walkBack = 9671, walkLeft = 9672, walkRight = 9673, idles = { { 9669, 80 }, { 309, 20 } } },
    [260] = { stand = 6239, walk = 6238 },  -- KALPHITE_UPDATE_QUEEN_READY
    [261] = { stand = 6236, walk = 6236 },  -- KALPHITE_UPDATE_FLYING_QUEEN_READY_WALK
    [262] = { stand = 5646, walk = 5645 },  -- BRAIN_ZOMBIE_PIRATE_WANDERERS_READY
    [263] = { stand = 5650, walk = 5652 },  -- BRAIN_ZOMBIE_PIRATE_DRAG_FEET_READY
    [264] = { stand = 1773, walk = 1773 },  -- GIANT_EAGLE_FLY
    [265] = { stand = 2126, walk = 2126 },  -- SWAMP_FISHING_POINT
    [266] = { stand = 1749, walk = 1748 },  -- ROCK_READY
    [267] = { stand = 3418, walk = 3415, turnLeft = 3415, turnRight = 3415, walkBack = 3415, walkLeft = 3415, walkRight = 3415 },  -- HUMAN_REAL_SWIMMING_READY
    [268] = { stand = 3535, walk = 3537, walkBack = 3537, walkLeft = 3537, walkRight = 3537, walkTurnLeft = 3537, walkTurnRight = 3537 },  -- ROYAL_SEA_SNAKE_READY
    [269] = { stand = 6803, walk = 6804 },  -- JUBBLY_UPDATE_READY_AND_EXTRA
    [270] = { stand = 5673 },  -- PENG_COWBELL_READY
    [271] = { stand = 6200, walk = 6201 },  -- SLICE_SURFACE_GOBLIN_SQUAT_SHIELD_SPEAR_READY
    [272] = { stand = 6258, walk = 6257 },  -- SMALL_SCORPION_UPDATE_READY
    [273] = { stand = 777, walk = 776, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_WADING_READY
    [274] = { stand = 1018, walk = 1021 },  -- CHOMPY_TOAD_READY
    [275] = { stand = 2028, walk = 2027 },  -- SPHINX_READY
    [276] = { stand = 4780 },  -- SLUG2_HUMAN_ROCKING
    [277] = { stand = 808, walk = 4779 },  -- HUMAN_READY
    [278] = { stand = 6263, walk = 6264 },  -- LOBSTER_UPDATE_READY
    [279] = { stand = 1321, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- VIKING_LYRE_PLAYING_LOOP
    [280] = { stand = 6935, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- MINING_UPDATE_LOOPED
    [281] = { stand = 1401, walk = 1399 },  -- M_GORILLA_READY
    [282] = { stand = 1386, walk = 1382 },  -- M_MONKEY_READY
    [283] = { stand = 5318, walk = 5317 },  -- SPIDER_UPDATE_READY_LARGE
    [284] = { stand = 2316, walk = 2317, run = 2322, turnLeft = 2321, turnRight = 2321, walkBack = 2318, walkLeft = 2319, walkRight = 2320 },  -- HUMAN_TOADCANNON_READY
    [285] = { stand = 5188, walk = 5187 },  -- FERRET_READY
    [286] = { stand = 5280, walk = 5279 },  -- GIANT_EAGLE_READY
    [287] = { walk = 2830, run = 2832, turnLeft = 2830, turnRight = 2830, walkBack = 2830, walkLeft = 2830, walkRight = 2830, walkTurnLeft = 2830, walkTurnRight = 2830, idles = { { 2822, 90 }, { 2828, 10 } } },
    [288] = { stand = 8574, walk = 8573 },  -- AFR_OGRESS_READY_NO_SKIRT
    [289] = { walk = 6 },
    [290] = { stand = 3040, walk = 3039, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- DRUNK_HOLDITEM_READY
    [291] = { stand = 10056, walk = 10055 },  -- SUM1_SPIRIT_BEAST_READY
    [292] = { stand = 809, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_DS_READY
    [293] = { stand = 6203, walk = 6202 },  -- SLICE_SURFACE_GOBLIN_SQUAT_GENERALS_READY
    [294] = { stand = 8682, walk = 8681, run = 8690, turnLeft = 8682, turnRight = 8682, walkBack = 8681, walkLeft = 8681, walkRight = 8681 },  -- AFR_PLAYER_SMOKE_READY
    [295] = { stand = 2338, walk = 844, turnLeft = 2338, turnRight = 2338, walkBack = 844 },  -- HUMAN_CRAWL_READY_FOR_FORGET
    [296] = { stand = 9442, walk = 9443 },  -- KURSK_UPDATE_READY
    [297] = { stand = 9416, walk = 9415 },  -- SMKI_CAVE_CRAWLER_BOSS_READY
    [298] = { stand = 262, walk = 263 },  -- BASILISK_UPDATE_READY
    [299] = { stand = 9410, walk = 9409 },  -- SMKI_TUROTH_READY
    [300] = { stand = 9535, walk = 7191, walkBack = 7192, walkLeft = 7193, walkRight = 7194 },  -- ROCKO_BRASS_HAND_READY
    [301] = { stand = 17294, walk = 17295 },  -- BEAR_CUB_UPDATE_READY
    [302] = { stand = 9208, walk = 9210 },  -- NPC_REWORK_CAT_KITTENS_NPC_READY
    [303] = { stand = 10020, walk = 10021, run = 10022, turnLeft = 10020, turnRight = 10020, walkBack = 10021, walkLeft = 10021, walkRight = 10021 },  -- HUMAN_READY_UPDATE_DARKBOW
    [304] = { stand = 7375 },  -- GRAVESTONE_FLAG_READY
    [305] = { stand = 1276, walk = 1274 },  -- SNAIL_READY
    [306] = { stand = 4257, walk = 4256 },  -- BREW_JIMMY_READY
    [307] = { stand = 4259 },  -- GAME_BREW_HELPER_PARROT_READY
    [308] = { stand = 5424 },  -- BARBASSAULT_EGG_CANNON_READY
    [309] = { stand = 5425 },  -- BARBASSAULT_EGG_CANNON_READY_N
    [310] = { stand = 5410, walk = 5409 },  -- BARBASSAULT_PENACNE_QUEEN_NEW_READY
    [311] = { stand = 24333, walk = 24332 },  -- GAME_BARBASSAULT_PENANCE_FIGHTER_IDLE
    [312] = { stand = 24366, walk = 24365, run = 24371 },  -- GAME_BARBASSAULT_PENANCE_HEALER_IDLE
    [313] = { stand = 5090, walk = 5089 },  -- BARBASSAULT_PENANCE_QUEEN_SPAWN_READY
    [314] = { stand = 24376, walk = 24377 },  -- GAME_BARBASSAULT_PENANCE_RANGER_READY
    [315] = { stand = 24329, walk = 24328 },  -- GAME_BARBASSAULT_PENANCE_RUNNER_IDLE
    [316] = { walk = 35086, run = 35085, turnLeft = 35086, turnRight = 35086, walkTurnLeft = 35086, walkTurnRight = 35086, idles = { { 3320, 90 }, { 35084, 10 } } },
    [317] = { stand = 35087, walk = 35088, run = 35089, walkBack = 35088, walkLeft = 35088, walkRight = 35088 },  -- TRH189_PLAYER_EQUINOX_IDLE_OVERRIDE
    [318] = { stand = 208, walk = 208 },  -- GNOME_HUMAN_TACKLE_FAIL_READY
    [319] = { stand = 205, walk = 205 },  -- GNOME_ONFLOOR
    [320] = { stand = 10594, walk = 10596, run = 3190 },  -- SC_SUMMONING_CREATURE_READY
    [321] = { stand = 10626, walk = 10625 },  -- OGRE_MALE_READY_CHEST
    [322] = { stand = 10587, walk = 10588 },  -- SC_HEAD_MYSTIC_BLINDFOLD_READY
    [323] = { stand = 5318, walk = 5317 },  -- SPIDER_UPDATE_READY_LARGE
    [324] = { stand = 9227, walk = 9226, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- PARTY_PETE_UPDATE_READY
    [325] = { stand = 784, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- PARTYROOM_DANCE
    [326] = { stand = 10266, walk = 7046, run = 7039, turnLeft = 7040, turnRight = 7040, walkBack = 7045, walkLeft = 7044, walkRight = 7043 },  -- CRCS_GIANT_HAND_READY
    [327] = { stand = 10270, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- CRCS_TAMBOURINE_READY
    [328] = { stand = 5719, walk = 5719 },  -- PENG_POW_POLAR_BEAR_SIT
    [329] = { stand = 10315, walk = 10316 },  -- CRCS_FAIRY_ASSISTANT_READY
    [330] = { stand = 10289, walk = 10288, turnLeft = 10288, turnRight = 10288, walkBack = 10288, walkLeft = 10288, walkRight = 10288 },  -- CRCS_TIGHTROPE_READY
    [331] = { stand = 10289, walk = 10288 },  -- CRCS_TIGHTROPE_READY
    [332] = { stand = 10318, walk = 10317 },  -- GAME_CRCS_RINGMASTER_READY
    [333] = { stand = 10321, walk = 10321 },  -- GAME_CRCS_TICKET_TENT_READY
    [334] = { stand = 5973, walk = 5969 },  -- RAMBLE_ZOMBIE_READY
    [335] = { stand = 5965, walk = 5965 },  -- RAMBLE_ZOMBIE_EMERGE_HEAD
    [336] = { stand = 5967, walk = 5967 },  -- RAMBLE_ZOMBIE_EMERGE_THIGHS
    [337] = { stand = 5966, walk = 5966 },  -- RAMBLE_ZOMBIE_EMERGE_TORSO
    [338] = { stand = 5986, walk = 5987 },  -- TREK_NAILBEAST_READY
    [339] = { stand = 3535, walk = 3537, walkBack = 3537, walkLeft = 3537, walkRight = 3537 },  -- ROYAL_SEA_SNAKE_READY
    [340] = { stand = 3535, walk = 3537, walkBack = 3537, walkLeft = 3537, walkRight = 3537 },  -- ROYAL_SEA_SNAKE_READY
    [341] = { stand = 3535, walk = 3537, walkBack = 3537, walkLeft = 3537, walkRight = 3537 },  -- ROYAL_SEA_SNAKE_READY
    [342] = { stand = 3535, walk = 3537 },  -- ROYAL_SEA_SNAKE_READY
    [343] = { stand = 3722, walk = 3721 },  -- TEMPLETREK_GIANT_SNAIL_READY
    [344] = { stand = 3738 },  -- TEMPLETREK_SWAMP_SNAKE_DEAD
    [345] = { stand = 3738 },  -- TEMPLETREK_SWAMP_SNAKE_DEAD
    [346] = { stand = 3738 },  -- TEMPLETREK_SWAMP_SNAKE_DEAD
    [347] = { stand = 3730, walk = 3730 },  -- TEMPLETREK_TENTACLE_HEAD_READY
    [348] = { stand = 3728, walk = 3728 },  -- TEMPLETREK_TENTACLE_HEAD_SPAWNING
    [349] = { stand = 3729, walk = 3729 },  -- TEMPLETREK_TENTACLE_SPAWNING
    [350] = { stand = 8737, walk = 6088 },  -- RABBIT_LARGE_READY
    [351] = { stand = 8737, walk = 6088 },  -- RABBIT_LARGE_READY
    [352] = { stand = 38085 },  -- STRINGING_ELDER_LONGBOW
    [353] = { stand = 2715, walk = 2715 },  -- MANDRITH_READY_SWORD_HILTED
    [354] = { stand = 3359, walk = 3359 },  -- _100_OSMAN_FROZE
    [355] = { stand = 5801, walk = 5802 },  -- _100_OSMAN_SEASONS_ELEMENTAL_READY
    [356] = { stand = 5803, walk = 5802 },  -- _100_OSMAN_SEASONS_ELEMENTAL_POINT
    [357] = { stand = 15555, walk = 15556, turnLeft = 15556, turnRight = 15556, walkTurnLeft = 15556, walkTurnRight = 15556 },  -- RDEN2_BENEDICT_READY
    [358] = { stand = 6320, walk = 6319, walkBack = 6319, walkLeft = 6319, walkRight = 6319 },  -- GODWARS2_ZAROS_READY
    [359] = { stand = 10188, walk = 10189 },  -- RCGUILD_ACANTHA_READY
    [360] = { stand = 10211, walk = 10210 },  -- RCGUILD_APPRENT_SPELLBOOK_READY
    [361] = { stand = 10207, walk = 10206 },  -- RCGUILD_ELRISS_READY
    [362] = { stand = 10205, walk = 10204 },  -- RCGUILD_KORVAC_READY
    [363] = { stand = 10136, walk = 10138 },  -- RCGUILD_ORB_READY
    [364] = { stand = 10176 },  -- RCGUILD_PORTAL_READY
    [365] = { stand = 10209, walk = 10208 },  -- RCGUILD_VIEF_READY
    [366] = { stand = 5558, walk = 5557 },  -- MUMMY_UPDATE_GUARDIAN_READY
    [367] = { stand = 10352 },  -- GAME_STAR_BULBO_STAR_SPRITE_READY
    [368] = { stand = 808, walk = 819 },  -- HUMAN_READY
    [369] = { stand = 9009 },  -- HVH_EARWIG_GUARDIAN_READY
    [370] = { stand = 8998, walk = 8997, run = 9004, turnLeft = 9000, turnRight = 9000, walkBack = 9001, walkLeft = 9002, walkRight = 9003 },  -- HVH_PLAYER_STONE_READY
    [371] = { stand = 2061, walk = 2060 },  -- BARROW_GUTHAN_READY
    [372] = { stand = 2074, walk = 2076, run = 2077, turnLeft = 823, turnRight = 823, walkBack = 2076, walkLeft = 2076, walkRight = 2076 },  -- BARROWS_REPEATING_CROSSBOW_READY
    [373] = { stand = 2061, walk = 2060, run = 10019, turnLeft = 823, turnRight = 823, walkBack = 2060, walkLeft = 2060, walkRight = 2060 },  -- BARROW_GUTHAN_READY
    [374] = { stand = 2071, walk = 2069 },  -- BLOODWORM_READY
    [375] = { stand = 12543, walk = 12542 },  -- MAH4_BARROWS_OLDMAN_FARMING_READY
    [376] = { stand = 10563, walk = 10357 },  -- SWEPT_PENGUIN_PUMPKIN_READY
    [377] = { stand = 10356, walk = 10357 },  -- PENG_SPY_BARREL_READY
    [378] = { stand = 10358, walk = 10359 },  -- PENG_SPY_BUSH_READY
    [379] = { stand = 10360, walk = 10361 },  -- PENG_SPY_CACTUS_READY
    [380] = { stand = 10362, walk = 10363 },  -- PENG_SPY_CRATE_READY
    [381] = { stand = 10364, walk = 10365 },  -- PENG_SPY_ROCK_READY
    [382] = { stand = 10366, walk = 10367 },  -- PENG_SPY_TOADSTOOL_READY
    [383] = { stand = 171, walk = 168, turnLeft = 168, turnRight = 168, walkBack = 168, walkLeft = 168, walkRight = 168 },  -- IMP_READY
    [384] = { stand = 6089, walk = 6088, turnLeft = 6088, turnRight = 6088, walkBack = 6088, walkLeft = 6088, walkRight = 6088 },  -- RABBIT_UPDATE_READY
    [385] = { stand = 5335, walk = 5334, turnLeft = 5334, turnRight = 5334, walkBack = 5334, walkLeft = 5334, walkRight = 5334 },  -- SHEEP_UPDATE_READY
    [386] = { stand = 3059, walk = 3059, turnLeft = 3059, turnRight = 3059, walkBack = 3059, walkLeft = 3059, walkRight = 3059 },  -- AGILITY_PYRAMID_LEDGE_WALK_LEFT
    [387] = { stand = 3060, walk = 3060, turnLeft = 3060, turnRight = 3060, walkBack = 3060, walkLeft = 3060, walkRight = 3060 },  -- AGILITY_PYRAMID_LEDGE_WALK_RIGHT
    [388] = { stand = 17360, walk = 6180 },  -- GOBLIN_ARCHER_BOW_READY
    [389] = { stand = 12460, walk = 12459 },  -- SMALL_BAT_REWORK_READY
    [390] = { stand = 6864, walk = 6867 },  -- TOWN_CRIER_READY
    [391] = { stand = 3948, walk = 3947 },  -- POSTIE_PETE_READY
    [392] = { stand = 3144, walk = 3145 },  -- CHAOSELEMENTAL_READY
    [393] = { stand = 808, walk = 1146, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [394] = { stand = 813 },  -- HUMAN_STAFFREADY
    [395] = { stand = 2170 },  -- WOM_BED_READY
    [396] = { stand = 808, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [397] = { stand = 8944 },  -- GC_GNOME_SCRUBBING
    [398] = { stand = 8977, walk = 8979, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- GLOMEM_READY_WITH_BEER
    [399] = { stand = 8977, walk = 8979, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- GLOMEM_READY_WITH_BEER
    [400] = { stand = 8958, walk = 8959 },  -- GLOMEM_MYTHICAL_BEAST_READY
    [401] = { stand = 8958, walk = 8960 },  -- GLOMEM_MYTHICAL_BEAST_READY
    [402] = { stand = 11036, walk = 8968 },  -- MOTWL_YETI_READY
    [403] = { stand = 11486, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- GLOMEM_VARGAS_CONFIDENT_READY
    [404] = { stand = 11488, walk = 8959 },  -- GLOMEM_MYTHICAL_BEAST_READY_AGGRESSIVE
    [405] = { stand = 11496, walk = 11496 },  -- MAH1_BURNING_RAFT
    [406] = { stand = 12231, walk = 12261 },  -- MAHJARRAT_2010_MAH1_JHALLAN_WEAK_READY
    [407] = { stand = 11499 },  -- MAH1_NIGHTMARE_CREATURE_READY
    [408] = { stand = 11502, walk = 31523, turnLeft = 11502, turnRight = 11502, walkBack = 31523, walkLeft = 31523, walkRight = 31523 },  -- EASTER09_EASTER_BUNNY_READY
    [409] = { stand = 11505, walk = 11503, turnLeft = 11502, turnRight = 11502, walkBack = 11503, walkLeft = 11503, walkRight = 11503 },  -- EASTER09_EASTER_BUNNY_DEJECTED_READY
    [410] = { stand = 11501, walk = 11503, turnLeft = 11501, turnRight = 11501, walkBack = 11503, walkLeft = 11503, walkRight = 11503 },  -- EASTER09_EASTER_BUNNY_DAD_READY
    [411] = { stand = 11502, walk = 11503, crawl = 11504, crawlBack = 11504, crawlLeft = 11504, crawlRight = 11504, turnLeft = 11502, turnRight = 11502, walkBack = 11503, walkLeft = 11503, walkRight = 11503 },  -- EASTER09_EASTER_BUNNY_READY
    [412] = { stand = 11510, walk = 11510, turnLeft = 11510, turnRight = 11510, walkBack = 11510, walkLeft = 11510, walkRight = 11510 },  -- EASTER09_EASTER_BUNNY_SON_CHAIR_READY
    [413] = { stand = 11511, walk = 11511 },  -- EASTER09_IMPLING_PAINTING_MACHINE
    [414] = { stand = 11515, walk = 11515 },  -- EASTER09_IMPLING_PUSHING_EGG_PAINTING_MACHINE_BUTTONS
    [415] = { stand = 11543, walk = 11545, run = 11544, turnLeft = 823, turnRight = 823, walkBack = 9052, walkLeft = 9053, walkRight = 9054 },  -- EASTER09_CARROT_READY
    [416] = { stand = 6518, walk = 11546 },  -- GRIM_GIANT_MOUSE_READY
    [417] = { stand = 11550, walk = 11551 },  -- EASTER_BIG_BIRD_READY
    [418] = { stand = 763, walk = 11578, turnLeft = 11578, turnRight = 11578, walkBack = 11578, walkLeft = 11578, walkRight = 11578 },  -- HUMAN_WALK_LOGBALANCE_READY
    [419] = { stand = 11586, walk = 11587 },  -- MAH1_NATURAL_HISTORIAN_READY
    [420] = { stand = 7158, walk = 11611, run = 11611 },  -- CHILD_UPDATE_READY
    [421] = { stand = 7158, walk = 11612, run = 11612 },  -- CHILD_UPDATE_READY
    [422] = { stand = 7158, walk = 11610, crawl = 11610 },  -- CHILD_UPDATE_READY
    [423] = { stand = 11613, walk = 11610, crawl = 11610 },  -- MAH1_ERJOLF_BUILD_RAFT
    [424] = { stand = 11631, walk = 11635 },  -- MOM2_SCARAB_READY
    [425] = { stand = 11641, walk = 11638 },  -- MOM2_STONE_GOLEM_READY
    [426] = { stand = 11626, walk = 11630 },  -- MOM2_TUMEKAN_SHADOW_READY
    [427] = { stand = 11668, walk = 11668 },  -- FIGHT_ARENA_LAZY_GUARD_BREATHING
    [428] = { stand = 10979, walk = 10979 },  -- FIGHT_ARENA_LAZY_GUARD_DRINKING
    [429] = { stand = 11669, walk = 11669 },  -- FIGHT_ARENA_LAZY_GUARD_OUT_COLD
    [430] = { stand = 11670, walk = 11670 },  -- FIGHT_ARENA_LAZY_GUARD_FULLY_OUT_COLD
    [431] = { stand = 11667, walk = 11662 },  -- FIGHT_ARENA_GENERAL_KHAZARD_GIANT_READY
    [432] = { stand = 11675 },  -- FIGHT_ARENA_GUARD_CHATTING_LFT
    [433] = { stand = 11682 },  -- FIGHT_ARENA_GUARD_CHATTING_LFT_NORTH
    [434] = { stand = 11676 },  -- FIGHT_ARENA_GUARD_CHATTING_RHT
    [435] = { stand = 9171 },  -- CAT_UPDATE_STOOL_READY
    [436] = { stand = 2157, walk = 2156 },  -- DWARF_READY_WOMAN
    [437] = { stand = 2150, walk = 2150, run = 21544 },  -- DWARF_MINECART_READY
    [438] = { stand = 101, walk = 101 },  -- DWARF_READY
    [439] = { stand = 2157, walk = 2157 },  -- DWARF_READY_WOMAN
    [440] = { stand = 2158 },  -- DWARF_SECRETARY_READY
    [441] = { stand = 825, walk = 826 },  -- HUMAN_READY_DH
    [442] = { walk = 17778, turnLeft = 17778, turnRight = 17778, idles = { { 17776, 245 }, { 17777, 10 } } },
    [443] = { stand = 1338, walk = 2361 },  -- HORROR_DAGANNOTH_READY
    [444] = { stand = 2362, walk = 2362 },  -- DAGGANOTH_EGG_OPEN
    [445] = { stand = 2351 },  -- WEAK_DOOR_FALL
    [446] = { stand = 2356 },  -- WEAK_DOOR_FALL_NORTH
    [447] = { stand = 2353 },  -- WEAK_DOOR_FALL_WEST
    [448] = { stand = 2352 },  -- WEAK_DOOR_FALLEN
    [449] = { stand = 2358 },  -- WEAK_DOOR_FALLEN_NORTH
    [450] = { stand = 2355 },  -- WEAK_DOOR_FALLEN_WEST
    [451] = { stand = 2357 },  -- WEAK_DOOR_NORTH
    [452] = { stand = 2354 },  -- WEAK_DOOR_WEST
    [453] = { stand = 2850, walk = 2849 },  -- DAGANNOTH_MEGANOTH_READY
    [454] = { stand = 2858, walk = 2857 },  -- DAGANNOTH_ROCK_LOBSTER_READY
    [455] = { stand = 2867, walk = 2863 },  -- DAGANNOTH_WATER_CREATURE_READY
    [456] = { stand = 1577, walk = 1578 },  -- SLAYER_LIZARD_READY
    [457] = { stand = 2180, walk = 2179 },  -- ABYSSAL_LEECH_READY
    [458] = { stand = 2185, walk = 2184 },  -- ABYSSAL_PYRAMID_READY
    [459] = { stand = 2191, walk = 2190 },  -- ABYSSAL_WALKER_READY
    [460] = { stand = 2149, walk = 2149 },  -- HUMAN_GENI_BOWING
    [461] = { stand = 4269, walk = 4268 },  -- CATPON_READY
    [462] = { stand = 4264, walk = 4263 },  -- MINO_READY
    [463] = { stand = 2263, walk = 2262 },  -- TUTORIAL2_PANICKED_READY
    [464] = { stand = 9917, walk = 4635 },  -- TUTORIAL2_DRAGON_READY
    [465] = { stand = 9966, walk = 6180 },  -- TUTORIAL2_GOBLIN_STUNNED
    [466] = { stand = 16005, walk = 16006 },  -- DRUID_READY_UPDATE
    [467] = { stand = 2836, walk = 4858 },  -- TERRIFIED_EMOTE
    [468] = { stand = 9917, walk = 9918 },  -- TUTORIAL2_DRAGON_READY
    [469] = { stand = 9930, walk = 9931 },  -- TUTORIAL2_DRAGON_READY_HEAD_ONE
    [470] = { stand = 9924, walk = 9925 },  -- TUTORIAL2_DRAGON_READY_HEAD_TWO
    [471] = { stand = 9927, walk = 9926 },  -- TUTORIAL2_DRAGON_READY_BACKWARDS
    [472] = { stand = 9958, walk = 9958 },  -- TUTORIAL2_KNIGHT_ON_STOOL
    [473] = { stand = 9940, walk = 9957, walkBack = 9957, walkLeft = 9957, walkRight = 9957 },  -- TUTORIAL2_WHITE_KNIGHT_COMBAT_READY
    [474] = { stand = 9956, walk = 9957, walkBack = 9957, walkLeft = 9957, walkRight = 9957 },  -- TUTORIAL2_WHITE_KNIGHT_READY
    [475] = { stand = 8763, walk = 8764 },  -- DSD_MINI_ORKS_READY
    [476] = { stand = 8753, walk = 8752 },  -- QUEST_DSD_ORK_BOSS_READY
    [477] = { stand = 9267, walk = 9264 },  -- TZHAAR_UPDATE_KET_ZEK_READY
    [478] = { stand = 9250, walk = 9251 },  -- TZHAAR_UPDATE_MEJ_KOT_READY
    [479] = { stand = 9255, walk = 9256 },  -- TZHAAR_UPDATE_MEJ_KOT_READY_SMALL
    [480] = { stand = 9298, walk = 9297 },  -- TZHAAR_UPDATE_RING_READY
    [481] = { stand = 9294, walk = 9295 },  -- TZHAAR_UPDATE_STAFF_READY
    [482] = { stand = 9236, walk = 9237 },  -- TZHAAR_UPDATE_TZ_KEK_READY
    [483] = { stand = 9236, walk = 9238 },  -- TZHAAR_UPDATE_TZ_KEK_READY
    [484] = { stand = 9228, walk = 9229 },  -- TZHAAR_UPDATE_TZ_KIH_READY
    [485] = { stand = 9274, walk = 9273 },  -- TZHAAR_UPDATE_TZTOK_JAD_BAK_READY
    [486] = { stand = 5589, walk = 5593 },  -- LOTR_PICKAXE_READY
    [487] = { stand = 5594, walk = 5595 },  -- LOTR_SPADE_READY
    [488] = { stand = 5616, walk = 5615 },  -- LOTR_TARN_RAZORLOR_MUTANT_READY
    [489] = { stand = 5623, walk = 5622 },  -- LOTR_TERROR_DOG_LOOK_READY
    [490] = { stand = 5576, walk = 5577 },  -- ZOMBIE_UPDATE_READY_DRAGGING
    [491] = { stand = 6058, walk = 6057 },  -- DORGESH_BABY_READY
    [492] = { stand = 6059, walk = 6057 },  -- DORGESH_BABY_SIT_READY
    [493] = { stand = 6043, walk = 6044 },  -- DORGESH_GOBLIN_READY_CRATE
    [494] = { stand = 6045, walk = 6046 },  -- DORGESH_GOBLIN_READY_SCRIBE
    [495] = { stand = 6040, walk = 6042 },  -- DORGESH_GOBLIN_READY
    [496] = { stand = 6060, walk = 6041 },  -- DORGESH_GOBLIN_FROGSPIT_ROTATE
    [497] = { stand = 6052, walk = 6053 },  -- DORGESH_GOBLIN_CHILD_BALL_READY
    [498] = { stand = 6062, walk = 6061 },  -- DORGESH_GOBLIN_FISH_READY
    [499] = { stand = 6036, walk = 6036 },  -- DORGESH_MOTHS
    [500] = { stand = 11449 },  -- HUMAN_URN_READY
    [501] = { stand = 38001 },  -- CONSTRUCTION_120_JEWELLERY_BOX_T3_SPARKLE
    [502] = { stand = 4457, walk = 4459 },  -- ELEM4_AUTOMOTON_READY
    [503] = { stand = 6798, walk = 6799, walkBack = 6799, walkLeft = 6799, walkRight = 6799, walkTurnLeft = 6799, walkTurnRight = 6799 },  -- MOUNTED_TERRORBIRD_READY_1X1
    [504] = { stand = 3952, walk = 3953, turnLeft = 15272, turnRight = 15273, walkLeft = 15272, walkRight = 15273, walkTurnLeft = 3953, walkTurnRight = 3953 },  -- BATTLE_TORTOISE_READY
    [505] = { stand = 3965, walk = 3963 },  -- GNOME_STAFF_READY
    [506] = { stand = 38005, walk = 38006, run = 38007 },  -- MAGIC_BROOM_IDLE
    [507] = { stand = 5290, walk = 15578, run = 15614, runLeft = 15616, runRight = 15615, turnLeft = 15578, turnRight = 15578, walkBack = 15578, walkLeft = 15578, walkRight = 15578 },  -- TT2_SNAKE_READY
    [508] = { stand = 6464, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- VM_OUTSIDE_GATE_GUARD_READY
    [509] = { stand = 7167, walk = 7165 },  -- CHILD_READY_AND_EXTRA
    [510] = { stand = 6389, walk = 6388 },  -- VM_ART_CRITIC_READY
    [511] = { stand = 6458 },  -- VM_CANAL_BARGE_FOREMEN_TALKING
    [512] = { stand = 6454 },  -- VM_CANAL_BARGE_WORKMAN_KNEELING_HAMMERING
    [513] = { stand = 6457 },  -- VM_CANAL_BARGE_WORKMAN_PAINTING_TAR
    [514] = { stand = 6455 },  -- VM_CANAL_BARGE_WORKMAN_SAWING
    [515] = { stand = 6456 },  -- VM_CANAL_BARGE_WORKMAN_SLEDGEHAMMERING
    [516] = { stand = 6413, walk = 6412 },  -- VM_FEMALE_TEACHER_CHILD_GIRL_READY_MULTI
    [517] = { stand = 6390 },  -- VM_MUSEUM_GUARD_READY
    [518] = { stand = 6393, walk = 6395 },  -- VM_NATURAL_HISTORIAN_READY
    [519] = { stand = 6449 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_BATTLE_TORTOISE_FIXED
    [520] = { stand = 6441 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_CAMEL_FIXED
    [521] = { stand = 6447 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_DRAGON_FIXED
    [522] = { stand = 6429 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_LEECH_FIXED
    [523] = { stand = 6437 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_LIZARD_FIXED
    [524] = { stand = 6451 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_MOLE_FIXED
    [525] = { stand = 6435 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_MONKEY_FIXED
    [526] = { stand = 6439 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_PENGUIN_FIXED
    [527] = { stand = 6433 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_SEASLUG_FIXED
    [528] = { stand = 6431 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_SNAIL_FIXED
    [529] = { stand = 6443 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_TERROR_BIRD_FIXED
    [530] = { stand = 6445 },  -- VM_NATURAL_HISTORY_DISPLAY_CASE_WYVERN_FIXED
    [531] = { stand = 6464 },  -- VM_OUTSIDE_GATE_GUARD_READY
    [532] = { stand = 6415, walk = 6414 },  -- VM_PATROL_ROUTE_WORKMEN_READY
    [533] = { walk = 6418 },
    [534] = { stand = 6422, walk = 6419 },  -- VM_PATROL_ROUTE_WORKMEN_WHEELBARROW_READY
    [535] = { stand = 6423, walk = 6420 },  -- VM_PATROL_ROUTE_WORKMEN_WHEELBARROW_EMPTY_READY
    [536] = { stand = 6411, walk = 6410 },  -- VM_SCHOOL_TEACHER_MALE_READY
    [537] = { stand = 6425 },  -- VM_WHEELBARROW_LOADER_READY
    [538] = { stand = 9432, walk = 9433 },  -- BLOODVELD_UPDATE_READY_CLAW
    [539] = { stand = 6949, walk = 6950 },  -- GODWARS_ARMADYL_READY
    [540] = { stand = 6972, walk = 6973 },  -- GODWARS_ARMADYL_AVATAR_READY
    [541] = { stand = 7059, walk = 7058 },  -- GODWARS_BANDOS_READY
    [542] = { stand = 7003 },  -- GODWARS_DYING_PALADIN_READY
    [543] = { stand = 7014, walk = 7015 },  -- GODWARS_LION_READY
    [544] = { stand = 6963, walk = 6962 },  -- GODWARS_SARADOMIN_READY
    [545] = { stand = 6943, walk = 6942 },  -- GODWARS_ZAMORAK_READY
    [546] = { walk = 2562, walkBack = 2562, walkLeft = 2562, walkRight = 2562 },
    [547] = { stand = 8800, walk = 7223 },  -- SOPS_EXAM_GUARD_READY
    [548] = { stand = 8797, walk = 8796 },  -- SOPS_COCKROACH_READY_TWO_AND_THREE
    [549] = { stand = 8797, walk = 8795 },  -- SOPS_COCKROACH_READY_TWO_AND_THREE
    [550] = { stand = 8771 },  -- SOPS_PRISONER_1_WORKING_OUT
    [551] = { stand = 8772 },  -- SOPS_PRISONER_2_SCARED
    [552] = { stand = 8773 },  -- SOPS_PRISONER_3_CLINKING_CUP
    [553] = { stand = 8774 },  -- SOPS_PRISONER_4_TRYING_TO_BREAK_BARS
    [554] = { stand = 8775 },  -- SOPS_PRISONER_5_CHARGING_AT_BARS
    [555] = { stand = 8776 },  -- SOPS_PRISONER_6_DIGGING_WITH_A_SPOON
    [556] = { stand = 8777 },  -- SOPS_PRISONER_7_SNOWBALL
    [557] = { stand = 8783 },  -- SOPS_WORKING_AT_A_DESK_OFFSET_FIVE
    [558] = { stand = 8782 },  -- SOPS_WORKING_AT_A_DESK_OFFSET_FOUR
    [559] = { stand = 8779 },  -- SOPS_WORKING_AT_A_DESK_OFFSET_ONE
    [560] = { stand = 8784 },  -- SOPS_WORKING_AT_A_DESK_OFFSET_SIX
    [561] = { stand = 8781 },  -- SOPS_WORKING_AT_A_DESK_OFFSET_THREE
    [562] = { stand = 8780 },  -- SOPS_WORKING_AT_A_DESK_OFFSET_TWO
    [563] = { stand = 8778 },  -- SOPS_WORKING_AT_A_DESK_REGULAR
    [564] = { stand = 7444, walk = 7445 },  -- SARADOMIN_KNIGHT1_GHOST_READY
    [565] = { stand = 7458, walk = 7459 },  -- WILDERNESS_CYCLOPS_GHOST_READY
    [566] = { stand = 7472, walk = 7473 },  -- WILDERNESS_DARK_BEAST_GHOST_READY
    [567] = { stand = 7451, walk = 7452 },  -- WILDERNESS_GOBLIN_GHOST_READY
    [568] = { stand = 7465, walk = 7466 },  -- WILDERNESS_HELLHOUND_GHOST_READY
    [569] = { stand = 7421, walk = 7422 },  -- WILDERNESS_HOBGOBLIN_GHOST_READY
    [570] = { stand = 7405, walk = 7406 },  -- WILDERNESS_IMP_GHOST_READY
    [571] = { stand = 7479, walk = 7480 },  -- WILDERNESS_LESSER_DEMON_GHOST_READY
    [572] = { stand = 7414, walk = 7415 },  -- WILDERNESS_ORK_GHOST_READY
    [573] = { stand = 7486, walk = 7487 },  -- WILDERNESS_PYREFIEND_GHOST_READY
    [574] = { stand = 7430, walk = 7431 },  -- WILDERNESS_VAMPIRE_GHOST_READY
    [575] = { stand = 7400, walk = 7401 },  -- WILDERNESS_WEREWOLF_READY
    [576] = { stand = 8589, walk = 8590 },  -- WRC_DRAGON_GHOST_READY
    [577] = { stand = 31512, walk = 31513 },  -- HORRORUPDATE_NPC_HORROR_IDLE
    [578] = { stand = 277, walk = 2392 },  -- SNAKE_READY
    [579] = { stand = 2400, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- TBW_CLEANUP_TRIBESMEN_SURPRISE
    [580] = { stand = 2401, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- TBW_BROODOO_DANCE
    [581] = { stand = 5326, walk = 5333 },  -- SPIDER_UPDATE_READY
    [582] = { stand = 3033, walk = 3034 },  -- MAGE_TRAINING_AREA_READY
    [583] = { stand = 3033, walk = 3035 },  -- MAGE_TRAINING_AREA_READY
    [584] = { stand = 3023, walk = 3023 },  -- MAGICTRAINING_FLYING_BOOK_READY
    [585] = { stand = 3026, walk = 3027 },  -- MAGICTRAINING_GHOST_READY
    [586] = { stand = 3244, walk = 3245 },  -- MAGICTRAINING_GHOST_BROOM_READY
    [587] = { stand = 6580, walk = 6556 },  -- DOG_UPDATE_WOLF_READY
    [588] = { stand = 1270, walk = 1269 },  -- LEECHREADY
    [589] = { stand = 2825, walk = 2823 },  -- HALF_ZOMBIE_READY
    [590] = { stand = 2826, walk = 2824 },  -- HALF_ZOMBIE_READY2
    [591] = { stand = 2818, walk = 2818 },  -- ZOMBIE_HEAD_WALK
    [592] = { stand = 2816, walk = 2815 },  -- ZOMBIE_TORSO_READY
    [593] = { stand = 8981, walk = 8982, run = 8986, turnLeft = 8987, turnRight = 8987, walkBack = 8985, walkLeft = 8983, walkRight = 8984 },  -- APRIL08_PLAYER_KITE_READY
    [594] = { stand = 1837, walk = 1836, run = 824, turnLeft = 823, turnRight = 823, walkBack = 1836, walkLeft = 821, walkRight = 822 },  -- HUMAN_SKIPPING_READY
    [595] = { stand = 11005, walk = 11004 },  -- TG08_TURKEY_BARREL_READY
    [596] = { stand = 11005, walk = 11002 },  -- TG08_TURKEY_BARREL_READY
    [597] = { stand = 11006, walk = 11003 },  -- TG08_TURKEY_CACTUS_READY
    [598] = { stand = 10997, walk = 10998 },  -- THKSGVG_TURKEY_READY
    [599] = { stand = 5070, walk = 5069 },  -- GUB_XMAS_GUBLINCH_READY
    [600] = { stand = 4738, walk = 4740 },  -- MYQ3_WEREWOLF_READY
    [601] = { stand = 808, walk = 11051, walkBack = 11051, walkLeft = 11052, walkRight = 11052 },  -- HUMAN_READY
    [602] = { stand = 11053, walk = 11052, walkBack = 11052, walkLeft = 11052, walkRight = 11052 },  -- XMAS08_JACK_FROST_FALLEN_READY
    [603] = { stand = 11046, walk = 11047 },  -- XMAS08_SANTA_READY
    [604] = { stand = 7543, walk = 7543 },  -- XMAS07_SNOW_IN_WIND
    [605] = { stand = 7557, walk = 7556, run = 7556 },  -- XMAS07_SNOWMAN_READY
    [606] = { stand = 7553, walk = 7553 },  -- XMAS_07_SNOW_WIND_READY
    [607] = { stand = 847, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY_SCYTHE
    [608] = { stand = 808, walk = 3865, walkBack = 3865, walkLeft = 3865, walkRight = 3865 },  -- HUMAN_READY
    [609] = { walk = 3853 },
    [610] = { stand = 1829, walk = 1828, turnLeft = 1829, turnRight = 1829, walkBack = 1828, walkLeft = 1828, walkRight = 1828 },  -- EASTER07_PLAYER_RABBIT_READY
    [611] = { stand = 1829, walk = 1828 },  -- EASTER07_PLAYER_RABBIT_READY
    [612] = { stand = 3008, walk = 3012 },  -- PIXIE_READY
    [613] = { stand = 8146, walk = 8145 },  -- LORE_SNAIL_READY_AND_EXTRA
    [614] = { stand = 3872, walk = 3871 },  -- RABBIT_EGG_READY
    [615] = { stand = 1242, walk = 1243, turnLeft = 1242, turnRight = 1242, walkBack = 1243, walkLeft = 1243, walkRight = 1243 },  -- RABBIT_READY
    [616] = { stand = 7266, walk = 7267, turnLeft = 7266, turnRight = 7266, walkBack = 7267, walkLeft = 7267, walkRight = 7267 },  -- HW07_PLAYER_WADING_THROUGH_GOO_READY
    [617] = { stand = 7295 },  -- HW07_REAPER_READY
    [618] = { stand = 2985, walk = 2987, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_FUNGICIDE_PUMP_READY
    [619] = { stand = 1536, walk = 1534 },  -- ABYSSAL_READY
    [620] = { stand = 10080, walk = 1660, run = 1661, turnLeft = 823, turnRight = 823, walkBack = 1660, walkLeft = 1660, walkRight = 1660 },  -- SLAYER_ABYSSAL_WHIP_READY
    [621] = { stand = 262, walk = 263 },  -- BASILISK_UPDATE_READY
    [622] = { stand = 262, walk = 263 },  -- BASILISK_UPDATE_READY
    [623] = { stand = 9133, walk = 9134 },  -- BLOODVELD_UPDATE_READY
    [624] = { stand = 9437, walk = 9438 },  -- BLOODVELD_UPDATE_READY_SMALL
    [625] = { stand = 268, walk = 298 },  -- CAVE_CRAWLER_UPDATE_READY
    [626] = { stand = 3168, walk = 3167 },  -- CLOUD_LIGHTNING_STRIKE
    [627] = { stand = 9462, walk = 9463 },  -- DEVIL_CREATURE_UPDATE_READY
    [628] = { stand = 1556, walk = 1554 },  -- DUSTDEVIL_READY
    [629] = { stand = 9456, walk = 9457 },  -- GARGOYLE_UPDATE_READY
    [630] = { stand = 9128, walk = 9129 },  -- GIANT_CRAWLING_HAND_UPDATE_READY_SMALL
    [631] = { stand = 9447, walk = 9448 },  -- GIANT_CRAWLING_HAND_UPDATE_READY
    [632] = { stand = 11940, walk = 11941 },  -- KILLERWATT_UPDATE_READY_NO_ARMS
    [633] = { stand = 11935, walk = 11936 },  -- KILLERWATT_UPDATE_READY
    [634] = { stand = 9442, walk = 9443 },  -- KURSK_UPDATE_READY
    [635] = { stand = 9490, walk = 9492 },  -- NECHRYEAL_UPDATE_READY
    [636] = { stand = 9509, walk = 9510 },  -- ROCKSLUG_UPDATE_READY
    [637] = { stand = 9509, walk = 9511 },  -- ROCKSLUG_UPDATE_READY
    [638] = { stand = 1582, walk = 1582 },  -- SLAYER_HARPIE_SWARM
    [639] = { stand = 1577, walk = 1578 },  -- SLAYER_LIZARD_READY
    [640] = { stand = 1577, walk = 1578 },  -- SLAYER_LIZARD_READY
    [641] = { stand = 1577, walk = 1578 },  -- SLAYER_LIZARD_READY
    [642] = { stand = 9484, walk = 9485 },  -- TUROTH_UPDATE_READY_MEDIUM
    [643] = { stand = 9474, walk = 9475 },  -- TUROTH_UPDATE_READY
    [644] = { stand = 9479, walk = 9480 },  -- TUROTH_UPDATE_READY_BABY
    [645] = { stand = 1588, walk = 1586 },  -- WYVERN_SKELETON_READY
    [646] = { stand = 2774, walk = 2310 },  -- ZYGOMITE_READY
    [647] = { stand = 2774, walk = 1597 },  -- ZYGOMITE_READY
    [648] = { stand = 2778, walk = 2778 },  -- ZYGOMITE_WIGGLE
    [649] = { stand = 1782, walk = 1781 },  -- CAVE_LITTLEBUG_READY
    [650] = { stand = 1790, walk = 1788 },  -- CAVE_SLIME_IDLE
    [651] = { stand = 6078, walk = 6077 },  -- MONALISK_CAVE_BUG_READY
    [652] = { stand = 6078, walk = 6077 },  -- MONALISK_CAVE_BUG_READY
    [653] = { stand = 6010, walk = 6011 },  -- MONALISK_CREATURE_READY
    [654] = { stand = 17907 },  -- ORNATEBOWL_WALL_CREATURE_READY
    [655] = { stand = 17903 },  -- ORNATEBOWL_WALL_CREATURE_NULL_POSE
    [656] = { stand = 7209, walk = 7210 },  -- RC_ZMI_LIZARD_READY
    [657] = { stand = 813, walk = 4226 },  -- HUMAN_STAFFREADY
    [658] = { stand = 2904, walk = 37952 },  -- FARMING_TOOLS_LEPRECHAUN_READY
    [659] = { stand = 15744 },  -- HATI2_BONFIRE_READY
    [660] = { stand = 1607, walk = 1608 },  -- WAA_SKULLBALL_READY
    [661] = { stand = 6539, walk = 6548 },  -- WEREWOLF_UPDATE_READY
    [662] = { stand = 745, walk = 744, turnLeft = 745, turnRight = 745, walkBack = 745, walkLeft = 745, walkRight = 745 },  -- HUMAN_MONKEYBARS_READY
    [663] = { stand = 15028, walk = 15028 },  -- ROCK_CRAB_RESIZE_ANIM
    [664] = { stand = 808, walk = 6531, walkBack = 6532, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [665] = { stand = 15, walk = 13 },  -- GHOSTHUMAN_READY
    [666] = { stand = 792, walk = 792 },  -- HUMAN_GENI_WALKANDREADY
    [667] = { stand = 351, walk = 335, run = 335 },  -- EVILTREE_LEPRECHAUN_PANIC_READY
    [668] = { stand = 1796, walk = 1797, turnLeft = 1797, turnRight = 1797, walkBack = 1797, walkLeft = 1797, walkRight = 1797 },  -- GIANT_FROG_READY
    [669] = { stand = 103, walk = 334 },  -- LEPRECHAUN_READY
    [670] = { stand = 1137 },  -- HUMAN_SITTING_CHAIR
    [671] = { stand = 1717, walk = 334 },  -- LEPRECHAUN_READY_PIPE
    [672] = { stand = 349, walk = 349 },  -- TRIFFID_READY
    [673] = { stand = 6825 },  -- PATTERN_DRAGON_TEACHER_READY
    [674] = { stand = 6857 },  -- PATTERN_GIANT_AT_DESK_READY
    [675] = { stand = 6858 },  -- PATTERN_GOBLIN1_AT_DESK_READY
    [676] = { stand = 6859 },  -- PATTERN_GOBLIN2_AT_DESK_READY
    [677] = { stand = 6826 },  -- PATTERN_IMP_ON_STOOL_READY
    [678] = { stand = 6856 },  -- PATTERN_MUMMY_AT_DESK_READY
    [679] = { stand = 6855 },  -- PATTERN_ZOMBIE_AT_DESK_READY
    [680] = { stand = 2370, walk = 2369 },  -- PHEASENT_READY
    [681] = { stand = 3043, walk = 3042 },  -- MACRO_SANDWICH_LADY_READY
    [682] = { stand = 3049, walk = 3048 },  -- BALLOON_READY
    [683] = { stand = 546, walk = 546 },  -- DHAT_DUELIST_HAT_VENDOR_READY
    [684] = { stand = 7199, walk = 7200, walkBack = 7201, walkLeft = 7202, walkRight = 7203 },  -- PIRATE_UPDATE_READY_AND_EXTRA_CROSSBOW
    [685] = { stand = 3999, walk = 3999 },  -- GRAB_EVIL_TWIN_IN_CLAW_READY
    [686] = { stand = 11289, walk = 6041 },  -- CHOSEN_UNDAK_BLINDED_READY_LOOP
    [687] = { stand = 6040, walk = 11362 },  -- DORGESH_GOBLIN_READY
    [688] = { stand = 808, walk = 11337, walkBack = 11337, walkLeft = 11337, walkRight = 11337 },  -- HUMAN_READY
    [689] = { stand = 552, walk = 552 },  -- DHAT_WILDERNESS_HAT_VENDOR_READY
    [690] = { stand = 808, walk = 5822 },  -- HUMAN_READY
    [691] = { stand = 5814, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- TOL_LAZY_BUILDER01
    [692] = { stand = 5817, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- TOL_LAZY_BUILDER03_NORTH
    [693] = { stand = 5815, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- TOL_LAZY_BUILDER02
    [694] = { stand = 5816, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- TOL_LAZY_BUILDER03
    [695] = { stand = 5818, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- TOL_LAZY_BUILDER04
    [696] = { stand = 145, walk = 142 },  -- GIANTSPIDER_READY
    [697] = { stand = 5839, walk = 5840 },  -- TOL_FROGEEL_READY
    [698] = { stand = 5831, walk = 5832 },  -- TOL_HOMONCULUS_READY
    [699] = { stand = 5831 },  -- TOL_HOMONCULUS_READY
    [700] = { stand = 5823, walk = 5822 },  -- TOL_MAGE_READY01
    [701] = { stand = 9591 },  -- DI2_PLAYER_IN_BOX
    [702] = { stand = 14023, walk = 14024 },  -- FAIRYKIT_ORC_UPDATE01_READY
    [703] = { stand = 13890, walk = 13889, turnLeft = 13889, turnRight = 13889 },  -- FAIRYKIT_GREEK_CHOIR_UPDATE_READY
    [704] = { stand = 2166, walk = 2165, turnLeft = 2166, turnRight = 2166, walkBack = 2165, walkLeft = 2165, walkRight = 2165 },  -- FARMING_PIG_READY
    [705] = { stand = 5386, walk = 5385, turnLeft = 5386, turnRight = 5386, walkBack = 5385, walkLeft = 5385, walkRight = 5385 },  -- LORE_CHICKEN_READY
    [706] = { stand = 14025, walk = 14026 },  -- FAIRYKIT_ORC_UPDATE02_READY
    [707] = { stand = 2618, walk = 2619 },  -- FIREBAT_READY
    [708] = { stand = 6127, walk = 6114 },  -- OLAF2_BRINE_RAT_READY
    [709] = { stand = 12921, walk = 12920 },  -- MASTER_FISHER_READY
    [710] = { stand = 6126 },  -- OLAF2_ULFRIC_RISE
    [711] = { stand = 6113, walk = 6112 },  -- OLAF2_UNDEAD_READY
    [712] = { stand = 9049, walk = 9051, run = 9050, turnLeft = 823, turnRight = 823, walkBack = 9052, walkLeft = 9053, walkRight = 9054 },  -- MYQ4_FLAIL_READY
    [713] = { stand = 9133, walk = 9134, walkBack = 9134, walkLeft = 9134, walkRight = 9134 },  -- BLOODVELD_UPDATE_READY
    [714] = { stand = 9128, walk = 9129 },  -- GIANT_CRAWLING_HAND_UPDATE_READY_SMALL
    [715] = { stand = 9028, walk = 9028 },  -- MYQ4_FLOATING_OUT_OF_PYRE
    [716] = { stand = 9037, walk = 9037 },  -- MYQ4_HAND_BURSTING_FROM_GROUND
    [717] = { stand = 9099 },  -- MYQ4_HUMAN_FALL_TO_KNEES_DEFEATED_READY
    [718] = { stand = 9093, walk = 9094 },  -- MYQ4_MUD_MOUND_READY
    [719] = { stand = 9069, walk = 9070, walkBack = 9070, walkLeft = 9070, walkRight = 9070 },  -- MYQ4_SAFALAN_HALO_WEAK_READY
    [720] = { stand = 9115, walk = 9114 },  -- MYQ4_VYREWATCH_WEAK_READY
    [721] = { stand = 9040, walk = 9039 },  -- MYQ4_WEAK_READY
    [722] = { stand = 6252, walk = 6257 },  -- SCORPION_UPDATE_READY
    [723] = { stand = 1387, walk = 1380 },  -- M_MONKEY_ACOLYTE_READY
    [724] = { stand = 1386, walk = 1385 },  -- M_MONKEY_READY
    [725] = { stand = 1388, walk = 1380 },  -- M_MONKEY_JAILOFFICER_READY
    [726] = { stand = 5517, walk = 5518 },  -- SKELETON_UPDATE_GORILLA_READY
    [727] = { stand = 277, walk = 274 },  -- SNAKE_READY
    [728] = { stand = 3385, walk = 3385 },  -- _100_GOB_FROZE
    [729] = { stand = 3387, walk = 3387 },  -- _100_GOB_SIT
    [730] = { stand = 3401, walk = 3401 },  -- _100_GOBLIN_ON_WALL
    [731] = { stand = 3388, walk = 3388 },  -- _100_GOBTWO_FROZE
    [732] = { stand = 3391, walk = 3391 },  -- _100_GOBTWO_SIT
    [733] = { stand = 3498, walk = 3499 },  -- AGRITH_NANA_READY
    [734] = { stand = 3846, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- BOOK_CHUCK_READY
    [735] = { stand = 3504, walk = 3506 },  -- DESSOURT_READY
    [736] = { stand = 3357, walk = 3357, walkBack = 3357, walkLeft = 3357, walkRight = 3357 },  -- INFLATE
    [737] = { stand = 3362, walk = 3362 },  -- _100_GUIDE_FROZE
    [738] = { stand = 3365, walk = 3365 },  -- _100_CUL_FROZE
    [739] = { stand = 3485, walk = 3485, turnLeft = 3485, turnRight = 3485, walkBack = 3485, walkLeft = 3485, walkRight = 3485 },  -- _100_ILM_CLIMB_SLOPE
    [740] = { stand = 3494, walk = 3494, turnLeft = 3494, turnRight = 3494, walkBack = 3494, walkLeft = 3494, walkRight = 3494 },  -- _100_ILM_MONKEY_DOWN_VINE
    [741] = { stand = 3490, walk = 3491, turnLeft = 3490, turnRight = 3490, walkBack = 3491, walkLeft = 3491, walkRight = 3491 },  -- _100_ILM_MONKEY_SWIM_READY
    [742] = { stand = 6818, walk = 6817, crawl = 6817, run = 6817 },  -- DUCK_REWORK_UNDERWATER_READY_AND_EXTRA
    [743] = { stand = 1386, walk = 1380, run = 1381, turnLeft = 1380, turnRight = 1380, walkBack = 1380, walkLeft = 1380, walkRight = 1380 },  -- M_MONKEY_READY
    [744] = { stand = 3523 },  -- HEAR_NO_EVIL_MONKEY_READY
    [745] = { stand = 3525 },  -- SEE_NO_EVIL_MONKEY_READY
    [746] = { stand = 3524 },  -- SPEAK_NO_EVIL_MONKEY_READY
    [747] = { stand = 3374, walk = 3374 },  -- _100_PIRATE_FROZE
    [748] = { stand = 3442, walk = 3441 },  -- FANTAIL_FISH_READY
    [749] = { stand = 3431, walk = 3432 },  -- MUDSKIPPER_READY
    [750] = { stand = 3436, walk = 3437 },  -- OGRE_SWIM_READY
    [751] = { stand = 3444, walk = 3443 },  -- SHOAL_READY
    [752] = { stand = 3379, walk = 3379 },  -- _100_DWARF_SIT
    [753] = { stand = 9650, walk = 9650 },  -- _100_GOBLIN_CHAIR_FIGHT_BENTNOZE
    [754] = { stand = 3395, walk = 3395 },  -- _100_GOBLIN_CHAIR_FIGHT_WARTFACE
    [755] = { stand = 9872, walk = 9872 },  -- _100_HUMAN_SITTING_UPDATE_01
    [756] = { stand = 9873, walk = 9873 },  -- _100_HUMAN_SITTING_UPDATE_02
    [757] = { stand = 9874, walk = 9874 },  -- _100_HUMAN_SITTING_UPDATE_03
    [758] = { stand = 9875, walk = 9875 },  -- _100_HUMAN_SITTING_UPDATE_04
    [759] = { stand = 9876, walk = 9876 },  -- _100_HUMAN_SITTING_UPDATE_05
    [760] = { stand = 3390, walk = 3390 },  -- _100_MONKEY_SIT
    [761] = { stand = 3383, walk = 3383 },  -- _100_OGRE_SIT
    [762] = { stand = 1386, walk = 1380, turnLeft = 1386, turnRight = 1386, walkBack = 1381 },  -- M_MONKEY_READY
    [763] = { stand = 3473, walk = 3474 },  -- _100_JUBBLY_TREADING_WATER
    [764] = { stand = 3460, walk = 3460 },  -- _100_JUBBLY_OGRE_BOW
    [765] = { stand = 3462, walk = 3462 },  -- _100_JUBBLY_OGRE_KICK
    [766] = { stand = 3472, walk = 3472 },  -- _100_JUBBLY_TOAD_BALLOON_DEFLATE
    [767] = { stand = 3469, walk = 3469 },  -- _100_JUBBLY_TOAD_BALLOON_READY
    [768] = { stand = 6807, walk = 6807 },  -- JUBBLY_UPDATE_PERMADEATH
    [769] = { stand = 3371, walk = 3371 },  -- _100_SIR_FROZE
    [770] = { stand = 3346 },  -- FAIRY_DRAGON_FLAME
    [771] = { stand = 12513, walk = 9724 },  -- PHOENIX_GUTHIX_PRIEST_READY
    [772] = { stand = 1993, walk = 1993, turnLeft = 1993, turnRight = 1993, walkBack = 1993, walkLeft = 1993, walkRight = 1993 },  -- IC_UP_ONS
    [773] = { stand = 2012, walk = 2011 },  -- LOCUST_READY
    [774] = { stand = 5551, walk = 5553 },  -- MUMMY_UPDATE_SOLDIER_READY
    [775] = { stand = 808, walk = 6531, walkBack = 6532, walkLeft = 6531, walkRight = 6531 },  -- HUMAN_READY
    [776] = { stand = 6511, walk = 6510 },  -- GRIM_EXPERIMENT_NO2_READY
    [777] = { stand = 6504, walk = 6505 },  -- GRIM_GIANT_READY
    [778] = { stand = 6533 },  -- GRIM_GNOME_READY1
    [779] = { stand = 6534 },  -- GRIM_GNOME_READY2
    [780] = { stand = 6535 },  -- GRIM_GNOME_READY3
    [781] = { stand = 6507 },  -- GRIM_GRIMNASH_READY
    [782] = { stand = 6006, walk = 6005 },  -- DORGESH_GOBLIN_READY_SPEAR
    [783] = { stand = 6004, walk = 6005 },  -- DORGESH_GOBLIN_READY_MINING
    [784] = { stand = 125, walk = 119 },  -- GHOST_READY
    [785] = { stand = 5563, walk = 5563 },  -- MUMMY_UPDATE_TURN_TO_ASH
    [786] = { stand = 1952 },  -- SITTING_READY_EAST
    [787] = { stand = 1953 },  -- SITTING_READY_NORTH
    [788] = { stand = 1955 },  -- SITTING_READY_SOUTH
    [789] = { stand = 1954 },  -- SITTING_READY_WEST
    [790] = { stand = 1476, walk = 283 },  -- TROLLROMANCE_CRY_LOOP
    [791] = { stand = 1318, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- VIKING_LYRE_READY
    [792] = { stand = 6657, walk = 6658, run = 6660, turnLeft = 6661, turnRight = 6661, walkBack = 6659, walkLeft = 6662, walkRight = 6663 },  -- PETROCK_HUMAN_READY
    [793] = { stand = 623, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_FISH_ONSPOT
    [794] = { stand = 11036, walk = 11037 },  -- MOTWL_YETI_READY
    [795] = { stand = 11027 },  -- MOTWL_YETI_PASSED_OUT
    [796] = { stand = 346, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- SITTING_THRONE
    [797] = { stand = 800, walk = 800 },  -- CAGED
    [798] = { stand = 2712, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- READY_DRINKING
    [799] = { stand = 2713 },  -- READY_PLAYING_CARDS
    [800] = { walk = 5809, idles = { { 5810, 80 }, { 21350, 20 } } },
    [801] = { stand = 7254, walk = 6560 },  -- ROOTS_DOG_BARKING
    [802] = { stand = 7258, walk = 7259 },  -- LORE_TOAD_READY
    [803] = { stand = 7236, walk = 7235 },  -- ROOTS_GIANT_ANTS_READY
    [804] = { stand = 7245 },  -- ROOTS_GIANT_VINE_READY
    [805] = { stand = 7241, walk = 7241 },  -- ROOTS_GIANT_WASP_READY_WALK
    [806] = { stand = 21774, walk = 21775, turnLeft = 21775, turnRight = 21775, walkLeft = 21775, walkRight = 21775, walkTurnLeft = 21775, walkTurnRight = 21775 },  -- SLISKE1_ICTHLARIN_IDLE
    [807] = { stand = 7718, walk = 7719 },  -- LORE_BEAVER_READY
    [808] = { stand = 3211, walk = 3210 },  -- SQUIRREL_READY
    [809] = { stand = 3212, walk = 3210, run = 8326 },  -- SQUIRREL_READY2
    [810] = { stand = 268, walk = 298 },  -- CAVE_CRAWLER_UPDATE_READY
    [811] = { stand = 9479, walk = 9480 },  -- TUROTH_UPDATE_READY_BABY
    [812] = { stand = 5551, walk = 5557 },  -- MUMMY_UPDATE_SOLDIER_READY
    [813] = { stand = 2995 },  -- DEVIOUS_DEAD
    [814] = { stand = 2993, walk = 2994 },  -- DEVIOUS_RELIC_READY
    [815] = { stand = 925, walk = 1140 },  -- TROLL_READY_SWORD
    [816] = { stand = 1159, walk = 283 },  -- TROLL_SLEEP
    [817] = { stand = 6106 },  -- FAI_VARROCK_BENCH_SIT
    [818] = { stand = 4208, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- DTTD_HAM_MEETING_READY
    [819] = { stand = 6040, walk = 6041, turnLeft = 6040, turnRight = 6040, walkBack = 6041, walkLeft = 6041, walkRight = 6041 },  -- DORGESH_GOBLIN_READY
    [820] = { stand = 6040 },  -- DORGESH_GOBLIN_READY
    [821] = { stand = 4210 },  -- DTTD_BONE_DEALER_READY
    [822] = { stand = 4193, walk = 4194, run = 4194, turnLeft = 4194, turnRight = 4194, walkBack = 4194, walkLeft = 4194, walkRight = 4194 },  -- DTTD_CARRYING_CRATE_READY
    [823] = { stand = 4193, walk = 4194 },  -- DTTD_CARRYING_CRATE_READY
    [824] = { stand = 4208 },  -- DTTD_HAM_MEETING_READY
    [825] = { stand = 5994, walk = 5995, turnLeft = 5994, turnRight = 5994, walkBack = 5995, walkLeft = 5995, walkRight = 5995 },  -- DTTD_ZANIK_TOG_READY
    [826] = { stand = 5994, walk = 5995 },  -- DTTD_ZANIK_TOG_READY
    [827] = { stand = 2253 },  -- RD_KNIGHT_RELAXED_READY
    [828] = { stand = 2255 },  -- RD_THRONE_SIT
    [829] = { stand = 816, walk = 815, turnLeft = 815, turnRight = 815 },  -- XMAS10_CRAWL_READY
    [830] = { stand = 1321 },  -- VIKING_LYRE_PLAYING_LOOP
    [831] = { stand = 5335 },  -- SHEEP_UPDATE_READY
    [832] = { stand = 3569, walk = 3568 },  -- THE_THING_READY
    [833] = { stand = 2730, walk = 2729 },  -- DARK_BEAST_UPDATE_READY
    [834] = { stand = 23756, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_MINING_FLOOR
    [835] = { stand = 22705, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- PLAYER_2014_SPADE_DIGGING
    [836] = { stand = 2740, walk = 2737 },  -- SHADOW_READY
    [837] = { stand = 1623, walk = 1622 },  -- FRANK_READY
    [838] = { stand = 1625, walk = 1624 },  -- HOMOLUPUS_READY
    [839] = { stand = 1614, walk = 1615 },  -- WAA_HOMO_ARACHNUS_READY
    [840] = { stand = 1609, walk = 1610 },  -- WAA_OVINOCANUS_READY
    [841] = { stand = 3185, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- GASMASK_APPLICATION
    [842] = { stand = 3186, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HANGOVER_DRINK
    [843] = { stand = 364, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_HERBING_GRIND
    [844] = { stand = 5455, walk = 5454 },  -- CONTACT_BOSS_READY
    [845] = { stand = 767, walk = 767, run = 767, turnLeft = 767, turnRight = 767, walkBack = 767, walkLeft = 767, walkRight = 767 },  -- HUMAN_FALLING_END
    [846] = { stand = 773, walk = 772, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_SWIM_READY
    [847] = { stand = 528, walk = 528, turnLeft = 528, turnRight = 528, walkBack = 528, walkLeft = 528, walkRight = 528 },  -- HUMAN_WHIRLPOOL
    [848] = { stand = 8705, walk = 2769 },  -- CATCON_DRUNKEN_SAILOR_STANDING
    [849] = { walk = 2769, idles = { { 16451, 80 }, { 16452, 20 } } },
    [850] = { idles = { { 16451, 80 }, { 16452, 20 } } },
    [851] = { stand = 8706 },  -- CATCON_DWARF_SITTING
    [852] = { stand = 10027 },  -- SUM1_SPIRIT_BARRIER_01
    [853] = { stand = 10028 },  -- SUM1_SPIRIT_BARRIER_02
    [854] = { stand = 10029 },  -- SUM1_SPIRIT_BARRIER_03
    [855] = { stand = 10030 },  -- SUM1_SPIRIT_BARRIER_04
    [856] = { stand = 10031 },  -- SUM1_SPIRIT_BARRIER_05
    [857] = { stand = 10064 },  -- SUM1_SPIRIT_BEAST_PRISON_READY
    [858] = { stand = 8077, walk = 9153 },  -- LORE_PYREFIEND_READY
    [859] = { stand = 9145, walk = 8076 },  -- ICEMT_ICE_PYREFIEND_READY
    [860] = { stand = 9145, walk = 9153 },  -- ICEMT_ICE_PYREFIEND_READY
    [861] = { stand = 9138 },  -- ICEMT_DWARF_WORKER_READY
    [862] = { stand = 332 },  -- ENTREADY
    [863] = { stand = 3563 },  -- BURGH_GADDERANKS_FALL_OVER
    [864] = { stand = 8501, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- WOLF_EADGAR_WASHING_CLOTHES
    [865] = { stand = 4303, walk = 4304 },  -- COSMIC_ENTITY_READY
    [866] = { stand = 4315 },  -- FAIRY2_STARFLOWER_FULLGROWN
    [867] = { stand = 4314 },  -- FAIRY2_STARFLOWER_SEED
    [868] = { stand = 736, walk = 736, turnLeft = 736, turnRight = 736, walkBack = 736, walkLeft = 736, walkRight = 736 },  -- HUMAN_BLOWN_END_GETUP
    [869] = { stand = 767, walk = 767, turnLeft = 767, turnRight = 767, walkBack = 767, walkLeft = 767, walkRight = 767 },  -- HUMAN_FALLING_END
    [870] = { stand = 796, walk = 796, run = 796, turnLeft = 796, turnRight = 796, walkBack = 796, walkLeft = 796, walkRight = 796 },  -- HUMAN_STUMBLE_AND_HANG_READY
    [871] = { stand = 4424, walk = 4426, walkBack = 4427, walkLeft = 4428, walkRight = 4429 },  -- HUMAN_MOONCLAN_READY
    [872] = { stand = 4424, walk = 4424 },  -- HUMAN_MOONCLAN_READY
    [873] = { stand = 4391, walk = 4390 },  -- LUNAR_MOONCLAN_BABA_YAGA_READY
    [874] = { stand = 4372, walk = 4372 },  -- QUEST_LUNAR_BROOM_SWEEP
    [875] = { stand = 4374, walk = 4374 },  -- QUEST_LUNAR_BUCKET_FULL_WALK
    [876] = { stand = 4386, walk = 4383 },  -- SUQKA_READY
    [877] = { stand = 808, walk = 35273 },  -- HUMAN_READY
    [878] = { stand = 1288, walk = 1289 },  -- SHADE_RISE
    [879] = { stand = 1308, walk = 1308 },  -- SHADE_HEAVEN
    [880] = { stand = 1290, walk = 1289 },  -- SHADESHADOW_READY
    [881] = { stand = 1292, walk = 1289 },  -- SHADESHADOW_RISE
    [882] = { stand = 10842, walk = 9869, walkBack = 9869, walkLeft = 9869, walkRight = 9869 },  -- LUC2_ELITE_GUARD_RANGER_READY
    [883] = { stand = 10869, walk = 9724, walkBack = 9724, walkLeft = 9724, walkRight = 9724 },  -- LUC2_ELITE_GUARD_MAGE_READY
    [884] = { stand = 10945, walk = 8723 },  -- LUC2_HAZELMERE_TELESCOPE_READY
    [885] = { stand = 10949, walk = 5479 },  -- LUC2_UNDEAD_MAGE_READY
    [886] = { stand = 813, walk = 9724, walkBack = 9724, walkLeft = 9724, walkRight = 9724 },  -- HUMAN_STAFFREADY
    [887] = { stand = 10763, walk = 10762 },  -- LUC2_LUCIEN_READY
    [888] = { stand = 10767, walk = 10767 },  -- LUC2_DRAGONORB_HEAD_FIRE_HIGH
    [889] = { stand = 10766, walk = 10766 },  -- LUC2_DRAGONORB_HEAD_FIRE_LOW
    [890] = { stand = 10853, walk = 10857, walkBack = 10857, walkLeft = 10857, walkRight = 10857 },  -- LUC2_ELITE_BLACK_KNIGHT_READY
    [891] = { stand = 10843, walk = 10858, walkBack = 10858, walkLeft = 10858, walkRight = 10858 },  -- LUC2_ELITE_GUARD_MELEE_READY
    [892] = { stand = 10672, walk = 10671 },  -- LUC2_EOB_FIREBOW_READY
    [893] = { stand = 10668, walk = 10667 },  -- LUC2_EOB_ROCK_READY
    [894] = { stand = 10665, walk = 10664 },  -- LUC2_EOB_WATER_READY
    [895] = { stand = 10639, walk = 10640 },  -- LUC2_FOUR_ARMED_SKELETON_READY
    [896] = { stand = 10633 },  -- LUC2_FOUR_ARMED_SKELETON_BREAK_OUT_OF_GROUND
    [897] = { stand = 10834, walk = 10834 },  -- LUC2_HAZELMERE_DEATH_WALK_READY
    [898] = { stand = 10970, walk = 10971 },  -- LUC2_HERO_HALBERD_READY
    [899] = { stand = 10968, walk = 10969 },  -- LUC2_HERO_SWORD_READY
    [900] = { stand = 10972, walk = 10973 },  -- LUC2_HERO_WHIP_READY
    [901] = { stand = 10974, walk = 10974 },  -- LUC2_HEROES_BLOWN_READY
    [902] = { stand = 10870, walk = 10871 },  -- LUC2_OLD_DRUID_READY
    [903] = { stand = 10873 },  -- LUC2_OLD_DRUID_DROP_READY
    [904] = { stand = 10881, walk = 10881 },  -- LUC2_SILIF_PRISON_INJURED
    [905] = { stand = 10635, walk = 10636 },  -- LUC2_SKELETON_READY
    [906] = { stand = 10632 },  -- LUC2_SKELETON_BREAK_OUT_OF_GROUND
    [907] = { stand = 10656, walk = 10657 },  -- LUC2_SKELETON_UNIQUE_READY
    [908] = { stand = 12380, walk = 12399 },  -- LUC2_SPY_READY_UPDATE
    [909] = { stand = 10813, walk = 10812 },  -- LUC2_TROLL_READY
    [910] = { stand = 10921, walk = 10920 },  -- LUC2_UNDEAD_DEMON_READY
    [911] = { stand = 10865, walk = 10866 },  -- LUC2_WASHERMAN_READY
    [912] = { stand = 10730, walk = 10729, turnLeft = 10729, turnRight = 10729 },  -- LUC2_CRAWL_READY
    [913] = { stand = 2048, walk = 2048, turnLeft = 2048, turnRight = 2048, walkBack = 2048, walkLeft = 2048, walkRight = 2048 },  -- TOG_PLAYER_FLOAT_ACROSS
    [914] = { stand = 1344, walk = 1344 },  -- HORROR_DAGANNOTH_EMERGE_A
    [915] = { stand = 1345, walk = 1345 },  -- HORROR_DAGANNOTH_EMERGE_B
    [916] = { stand = 1346, walk = 1346 },  -- HORROR_DAGANNOTH_EMERGE_C
    [917] = { stand = 1756, walk = 1757 },  -- BEARSUIT_READY
    [918] = { stand = 5656, walk = 5655 },  -- BRAIN_ZOMBIE_PIRATE_CAPTAIN_READY
    [919] = { stand = 5586, walk = 5585 },  -- HALF_WOOD_LUKE_READY
    [920] = { stand = 2803, walk = 2802 },  -- SPIRIT_READY
    [921] = { stand = 5584, walk = 5583 },  -- ZOMBIE_UPDATE_SIGN_READY
    [922] = { stand = 9608 },  -- BRAIN_BARREL_CHEST_IN_CRATE
    [923] = { stand = 479 },  -- CAULDRON
    [924] = { stand = 5021, walk = 5022 },  -- MYARM_ROC_READY
    [925] = { stand = 5029, walk = 5030 },  -- MYARM_ROC_BABY_READY
    [926] = { stand = 5002 },  -- MYARM_SUNBATHER_SIPPING_READY
    [927] = { stand = 9629 },  -- ZOMBIE_TORTURE_READY
    [928] = { stand = 1838, walk = 1839 },  -- ROCK_AVATAR_READY
    [929] = { stand = 6252, walk = 6262 },  -- SCORPION_UPDATE_READY
    [930] = { stand = 773, walk = 772, walkBack = 772, walkLeft = 772, walkRight = 772 },  -- HUMAN_SWIM_READY
    [931] = { stand = 5146, walk = 5150 },  -- ZEP_PEASANT_READY1
    [932] = { stand = 5147, walk = 5151 },  -- ZEP_PEASANT_READY2
    [933] = { stand = 5148, walk = 5152 },  -- ZEP_PEASANT_READY3
    [934] = { stand = 5149, walk = 5153 },  -- ZEP_PEASANT_READY4
    [935] = { stand = 2893 },  -- MAKINGHISTORY_GHOST_FADE
    [936] = { stand = 1753 },  -- ROCK_BIRTH
    [937] = { stand = 1754, walk = 1754 },  -- ROCK_HYBERNATE
    [938] = { stand = 6181, walk = 6180, run = 7332, turnLeft = 6180, turnRight = 6180, walkBack = 6180, walkLeft = 6180, walkRight = 6180 },  -- SLICE_SURFACE_GOBLIN_SQUAT_READY
    [939] = { stand = 7315, walk = 6180 },  -- LOTG_PREACHER_GESTICULATING
    [940] = { stand = 7329, walk = 6041 },  -- LOTG_OLDAK_LOOKING_AT_HACKING_MACHINE
    [941] = { stand = 7325, walk = 7325 },  -- LOTG_HIGH_PRIEST_GIVING_UP_READY
    [942] = { stand = 7333, walk = 7333 },  -- LOTG_HIGH_PRIEST_READY
    [943] = { stand = 7343, walk = 7342 },  -- LOTG_HOPESPEAR_READY
    [944] = { stand = 440, walk = 9738, walkBack = 9738, walkLeft = 9738, walkRight = 9738 },  -- HUMAN_SCYTHE_SWEEP
    [945] = { stand = 21189, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_WOODCUTTING_STEEL_AXE_2013_UPDATE
    [946] = { stand = 7261, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- FISHING_TWOXTWO
    [947] = { stand = 17251, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- MISC_HUMAN_RAKING_READY
    [948] = { stand = 7163 },  -- CHILD_PLAYING_WITH_TOY
    [949] = { stand = 7164 },  -- CHILD_PLAYING_WITH_TOY_OFFSET
    [950] = { stand = 3605, walk = 3606 },  -- WILL_READY_UPDATE
    [951] = { stand = 9198 },  -- QIP_GERTRUDES_CAT_CRATE_TIP_MULTI
    [952] = { stand = 9169, walk = 9157 },  -- CAT_UPDATE_SLEEP
    [953] = { stand = 21745, walk = 28835, turnLeft = 28835, turnRight = 28835, walkTurnLeft = 28835, walkTurnRight = 28835 },  -- SLISKE1_SLISKE_READY
    [954] = { stand = 2153, walk = 2156 },  -- DWARF_DIRECTOR_TABLE_WOMAN_READY_NOD
    [955] = { stand = 21748 },  -- SLISKE1_SLISKE_READY_IN_THRONE
    [956] = { stand = 4619, walk = 63 },  -- QIP_DS_DELRITH_WEAKENED_PORTAL
    [957] = { stand = 808, walk = 12611 },  -- HUMAN_READY
    [958] = { stand = 6841 },  -- ASTRONOMERS_ASSISTANT_WORKS_AT_DESK
    [959] = { stand = 6828, walk = 6187 },  -- QIP_OBSERVATORY_GOBLIN_SLEEPING
    [960] = { stand = 6831 },  -- QIP_OBSERVATORY_COOKING_GOBLIN_READY_AND_EXTRA
    [961] = { stand = 6834 },  -- QIP_OBSERVATORY_GOBLIN_CHATTER_ONE
    [962] = { stand = 6835 },  -- QIP_OBSERVATORY_GOBLIN_CHATTER_TWO
    [963] = { stand = 6829 },  -- QIP_OBSERVATORY_GOBLIN_DRUNK_READY_AND_EXTRA
    [964] = { stand = 6836 },  -- QIP_OBSERVATORY_HUCK_FIN_GOBLIN_READY_AND_EXTRA
    [965] = { stand = 6833 },  -- QIP_OBSERVATORY_SETTING_A_FIRE_READY_AND_EXTRA
    [966] = { stand = 1900, walk = 274 },  -- SNAKE_CHARMED
    [967] = { stand = 1879 },  -- SNAKECHARMER_CHARMING
    [968] = { stand = 1322 },  -- VIKING_DRINKING_READY
    [969] = { stand = 2341, walk = 2335 },  -- FORGETTABLE_EVIL_DWARF_LAUGH
    [970] = { stand = 2336, walk = 2335 },  -- DWARF_READY_WITHHELMET
    [971] = { stand = 21756 },  -- SLISKE1_SLISKE_READY_THEATRICAL
    [972] = { stand = 2337, walk = 98 },  -- DWARF_READY_SITTING_AND_DRINKING
    [973] = { stand = 2339, walk = 2339, turnLeft = 2339, turnRight = 2339, walkBack = 2339 },  -- HUMAN_SITTING_DRUNK_READY
    [974] = { stand = 8829, walk = 8832, run = 8831, turnLeft = 823, turnRight = 823, walkBack = 8832 },  -- KEN_PLAYER_SNEAK_READY
    [975] = { stand = 7158 },  -- CHILD_UPDATE_READY
    [976] = { stand = 808, walk = 819, walkBack = 820, walkLeft = 808, walkRight = 808 },  -- HUMAN_READY
    [977] = { stand = 8807, walk = 8808 },  -- KEN_KENNITH_EVIL_READY
    [978] = { stand = 8807 },  -- KEN_KENNITH_EVIL_READY
    [979] = { stand = 8811, walk = 8811 },  -- KEN_KENNITH_LEVITATE_NPC
    [980] = { stand = 8816 },  -- KEN_KIMBERLY_LEVITATE_SPOT
    [981] = { stand = 8852 },  -- KEN_PLAY_TOY_TRAIN
    [982] = { stand = 8863, walk = 8862 },  -- KEN_POSESSED_READY_A
    [983] = { stand = 8877, walk = 8862 },  -- KEN_POSESSED_OVERHEAT_POSE
    [984] = { stand = 8878, walk = 8875 },  -- KEN_POSESSED_LOADED_READY
    [985] = { stand = 5869, walk = 5867, run = 5868, turnLeft = 823, turnRight = 823, walkBack = 5867, walkLeft = 5867, walkRight = 5867 },  -- BRAIN_PLAYER_ANCHOR_READY
    [986] = { stand = 5875, walk = 5876 },  -- BRAIN_BROTHER_TRANQUILITY_SHIFTY_READY
    [987] = { stand = 5893, walk = 5892 },  -- BRAIN_BARRELCHEST_READY
    [988] = { stand = 5877, walk = 5876 },  -- BRAIN_HUMAN_BRAIN_MONK_READY
    [989] = { stand = 5859, walk = 5858 },  -- BRAIN_MI_GOR_READY
    [990] = { stand = 5873, walk = 5872 },  -- BRAIN_PUFFIN_READY
    [991] = { stand = 5873 },  -- BRAIN_PUFFIN_READY
    [992] = { stand = 5641, walk = 5642 },  -- BRAIN_SAWBONES_READY
    [993] = { stand = 5883, walk = 5882 },  -- BRAIN_ZOMBIE_PIRATE_BONEY_READY
    [994] = { stand = 5888, walk = 5887 },  -- BRAIN_ZOMBIE_PIRATE_CUTTERS_READY
    [995] = { stand = 5879, walk = 5878 },  -- BRAIN_ZOMBIE_PIRATE_LIMPERS_READY
    [996] = { stand = 2911, walk = 2912 },  -- ELID_CHOC_ICE_SELLER_READY
    [997] = { stand = 2908, walk = 2907 },  -- ELID_WATERSPIRIT_SITTING
    [998] = { stand = 792 },  -- HUMAN_GENI_WALKANDREADY
    [999] = { stand = 1144, walk = 1144, walkBack = 1144, walkLeft = 1144, walkRight = 1144 },  -- SITTING_READY
    [1000] = { stand = 23845 },  -- MAGIC_AXE_2012_FLOOR_POSE
    [1001] = { stand = 5543, walk = 5543 },  -- GHOST_UPDATE_MINE_BOSS_RUN
    [1002] = { stand = 777, walk = 776, turnLeft = 777, turnRight = 777, walkBack = 777, walkLeft = 777, walkRight = 777 },  -- HUMAN_WADING_READY
    [1003] = { stand = 1450, walk = 1451 },  -- POSSESSED_KEY_READY
    [1004] = { stand = 1442, walk = 5479 },  -- SKELETON_BEFORESUMMON
    [1005] = { stand = 3280, walk = 3280, turnLeft = 3280, turnRight = 3280, walkBack = 3280, walkLeft = 3280, walkRight = 3280 },  -- HUMAN_DEAD
    [1006] = { stand = 4711, walk = 4699 },  -- MYQ3_MALE_JUVINATE_POUCHTRAY_READY
    [1007] = { stand = 4755, walk = 4756 },  -- MYQ3_BOAT_READY
    [1008] = { stand = 4756, walk = 4756 },  -- MYQ3_BOAT_WALK
    [1009] = { stand = 25597 },  -- MYQ3_2014_CITIZEN_HUDDLED
    [1010] = { stand = 4768 },  -- MYQ3_JUVINATE_JUVENILE_HOLDING_CAPTURE_LOOP
    [1011] = { stand = 4690, walk = 4684 },  -- MYQ3_VAMPIRE_FLYING_READY_HEAD
    [1012] = { stand = 4696 },  -- MYQ3_VAMPIRE_FLYING_LANDING_HEAD
    [1013] = { stand = 4703, walk = 4700 },  -- MYQ3_VAMPIRE_GROUNDED_READY_FEMALE
    [1014] = { stand = 4702, walk = 4699 },  -- MYQ3_VAMPIRE_GROUNDED_READY_MALE
    [1015] = { stand = 4702, walk = 4700 },  -- MYQ3_VAMPIRE_GROUNDED_READY_MALE
    [1016] = { stand = 4703, walk = 4699 },  -- MYQ3_VAMPIRE_GROUNDED_READY_FEMALE
    [1017] = { stand = 4706 },  -- MYQ3_VAMPIRE_GROUNDED_TAKEOFF
    [1018] = { stand = 4707 },  -- MYQ3_VAMPIRE_HEAD_TAKEOFF
    [1019] = { stand = 9118 },  -- MYQ4_GROUNDED_VYREWATCH_HELD
    [1020] = { stand = 6545, walk = 6544 },  -- WEREWOLF_UPDATE_READY_WITH_HUMAN
    [1021] = { stand = 4772, walk = 4772, turnLeft = 4772, turnRight = 4772, walkBack = 4772, walkLeft = 4772, walkRight = 4772 },  -- MYQ3_HUMAN_TIGHTROPE
    [1022] = { stand = 10103, walk = 10102 },  -- HIST_LAURA_01_STANDARD_READY
    [1023] = { stand = 10104, walk = 10106 },  -- HIST_LAURA_02_READY
    [1024] = { stand = 10090 },  -- HIST_ROGER_ROCKING_CHAIR
    [1025] = { stand = 10107, walk = 10108 },  -- HIST_SARAH_RAKE_READY
    [1026] = { stand = 757, walk = 756, turnLeft = 757, turnRight = 757, walkBack = 756, walkLeft = 756, walkRight = 756 },  -- HUMAN_READY_SIDESTEPL
    [1027] = { stand = 766, walk = 766, turnLeft = 766, turnRight = 766, walkBack = 766, walkLeft = 766, walkRight = 766 },  -- HUMAN_FALLING
    [1028] = { stand = 764, walk = 764, turnLeft = 764, turnRight = 764, walkBack = 764, walkLeft = 764, walkRight = 764 },  -- HUMAN_WALK_LOGBALANCE_STUMBLE
    [1029] = { stand = 5505, walk = 5506 },  -- SKELETON_UPDATE_GIANT_VARY3_READY
    [1030] = { stand = 5572, walk = 5582 },  -- ZOMBIE_UPDATE_READY_WEAPON
    [1031] = { stand = 3281 },  -- ROMEO_JULIET_PEW_READY
    [1032] = { stand = 3282 },  -- ROMEO_JULIET_PEW_READY2
    [1033] = { stand = 3036, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HANDSAND_SANDY_LOOKREADY
    [1034] = { stand = 808, walk = 6919 },  -- HUMAN_READY
    [1035] = { stand = 6918 },  -- KR_KEEP_KNIGHT_POSING
    [1036] = { stand = 11085 },  -- PHOENIX_EGG_READY
    [1037] = { stand = 11114, walk = 11115 },  -- PHOENIX_GUARDIAN_MAGE_READY
    [1038] = { stand = 11130, walk = 11115 },  -- PHOENIX_GUARDIAN_MAGE_BLOCK_READY
    [1039] = { stand = 11118, walk = 11119 },  -- PHOENIX_GUARDIAN_MELEE_READY
    [1040] = { stand = 11131, walk = 11119 },  -- PHOENIX_GUARDIAN_MELEE_BLOCK_READY
    [1041] = { stand = 11072, walk = 11073 },  -- PHOENIX_PHOENIX_WOUNDED_READY
    [1042] = { stand = 11074, walk = 11075 },  -- PHOENIX_PHOENIX_BOSS_READY
    [1043] = { stand = 11450, walk = 11450 },  -- OGRE_MALE_100TH_QUEST_SAT_DOWN
    [1044] = { stand = 11452, walk = 11453 },  -- OGRE_AND_BOAT_READY
    [1045] = { stand = 11439, walk = 11439 },  -- OGRE_MALE_100TH_QUEST_BOW
    [1046] = { stand = 11446, walk = 11446 },  -- OGRE_MALE_100TH_QUEST_TREE_KICK
    [1047] = { stand = 11426, walk = 10625 },  -- OGRE_MALE_READY_BOW
    [1048] = { stand = 11422, walk = 11422 },  -- OGRE_MALE_DRUMMER
    [1049] = { stand = 5565, walk = 5566 },  -- ZOMBIE_UPDATE_READY_NORMAL
    [1050] = { stand = 3845 },  -- AIDE_FISHERMAN_READY
    [1051] = { stand = 1020, walk = 1020 },  -- BLOATED_TOAD_STAY
    [1052] = { stand = 6764, walk = 6765 },  -- CHOMPY_UPDATE_READY_AND_EXTRA
    [1053] = { stand = 6768, walk = 6768 },  -- CHOMPY_UPDATE_PERMADEATH
    [1054] = { walk = 2571 },
    [1055] = { stand = 9196, walk = 9197 },  -- CARPET_RIDE_LOOK_AT_EACH_OTHER_READY
    [1056] = { stand = 9165, walk = 9165 },  -- CAT_UPDATE_SIT_READY
    [1057] = { stand = 90, walk = 4635 },  -- DRAGON_READY
    [1058] = { stand = 38011 },  -- TUT7_PLAYER_SIT_ON_BENCH_IDLE_CENTRE_TILE
    [1059] = { stand = 2668, walk = 2667 },  -- PANTHER_READY
    [1060] = { stand = 2666, walk = 2666 },  -- PANTHER_GHOST_SITS
    [1061] = { stand = 9194 },  -- TITANIC_CATS
    [1062] = { stand = 5044 },  -- TOURTRAP_QIP_CAMEL_READY
    [1063] = { stand = 1953, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- SITTING_READY_NORTH
    [1064] = { stand = 766, walk = 766, run = 766, turnLeft = 766, turnRight = 766, walkBack = 766, walkLeft = 766, walkRight = 766 },  -- HUMAN_FALLING
    [1065] = { stand = 21758 },  -- SLISKE1_SARADOMIN_IDLE
    [1066] = { walk = 98 },
    [1067] = { stand = 4037, walk = 4037 },  -- ROYAL_SEA_SNAKE_MOTHER_READY
    [1068] = { stand = 5770, walk = 5770 },  -- FRIS_ICEBERG_MOVES
    [1069] = { stand = 5773, walk = 5773 },  -- FRIS_PINE_SWAY
    [1070] = { stand = 12455, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_MINING_STEEL_PICKAXE_NPC
    [1071] = { stand = 10558, walk = 10557 },  -- SWEPT_MULTI_NPC_READY
    [1072] = { stand = 813, walk = 10534, run = 1210, turnLeft = 10534, turnRight = 10534, walkBack = 10534, walkLeft = 10534, walkRight = 10534 },  -- HUMAN_STAFFREADY
    [1073] = { stand = 10570, walk = 10571 },  -- SWEPT_ASSISSTANT_READY
    [1074] = { stand = 10567, walk = 10566 },  -- SWEPT_GHOUL_READY
    [1075] = { stand = 10565, walk = 10564 },  -- SWEPT_MAGGIE_READY
    [1076] = { stand = 10569, walk = 10568 },  -- SWEPT_WENDY_READY
    [1077] = { stand = 10000, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- ENAKH_PENTYN_READY_UPDATE
    [1078] = { stand = 3073, walk = 3078 },  -- ENAKH_BONEGUARD_READY
    [1079] = { stand = 3073 },  -- ENAKH_BONEGUARD_READY
    [1080] = { stand = 10434, walk = 10436, walkBack = 10436, walkLeft = 10436, walkRight = 10436 },  -- DOV_ARRAV_READY
    [1081] = { stand = 6932, walk = 5570 },  -- ZEMO_ZOMBIE_READY_VARIATION
    [1082] = { stand = 10415, walk = 5570 },  -- ZEMO_ZOMBIE_READY_VARIATION_TWO
    [1083] = { stand = 10426, walk = 10426 },  -- ZEMO_JUMPING_FISH
    [1084] = { stand = 10427, walk = 10427 },  -- ZEMO_JUMPING_FISH_OFFSET
    [1085] = { stand = 10465, walk = 10464 },  -- ZEMO_RAMARNO_READY
    [1086] = { stand = 24664, walk = 24665 },  -- ZEMO_SHARATHTEERK_GARGOYLE_2013_IDLE
    [1087] = { stand = 10432, walk = 10433 },  -- ZEMO_ZEMOUREGAL_READY
    [1088] = { stand = 808, walk = 4824 },  -- HUMAN_READY
    [1089] = { stand = 2253, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- RD_KNIGHT_RELAXED_READY
    [1090] = { stand = 4819, walk = 4820 },  -- SLUG2_QUEEN_READY
    [1091] = { stand = 4828, walk = 4821 },  -- SLUG2_PRINCE_READY
    [1092] = { stand = 2728, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- WANTED_RANGER_READY
    [1093] = { stand = 2724, walk = 2724, walkBack = 2724, walkLeft = 2724, walkRight = 2724 },  -- WANTED_HUMAN_INJURED_CUTSCENE
    [1094] = { stand = 2727, walk = 2727, walkBack = 2727, walkLeft = 2727, walkRight = 2727 },  -- WANTED_INTERRUPT_TELEPORT
    [1095] = { stand = 2726, walk = 2726, walkBack = 2726, walkLeft = 2726, walkRight = 2726 },  -- WANTED_PRAYER_ANIM
    [1096] = { stand = 808, walk = 819, run = 10575, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [1097] = { stand = 10254, walk = 9869 },  -- FIREDUP_HUMAN_TENDING_FIRE
    [1098] = { stand = 10254, walk = 4858 },  -- FIREDUP_HUMAN_TENDING_FIRE
    [1099] = { stand = 10254, walk = 1205, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- FIREDUP_HUMAN_TENDING_FIRE
    [1100] = { stand = 10240, walk = 6180 },  -- FIREDUP_GOBLIN_TENDING_FIRE
    [1101] = { stand = 10241, walk = 9157 },  -- FIREDUP_CAT_TENDING_FIRE
    [1102] = { stand = 10243, walk = 1139 },  -- FIREDUP_TROLL_TENDING_FIRE
    [1103] = { stand = 10242, walk = 4923 },  -- FIREDUP_ARCTIC_BEAR_TENDING_FIRE
    [1104] = { stand = 737, walk = 737, turnLeft = 737, turnRight = 737, walkBack = 737, walkLeft = 737, walkRight = 737 },  -- HUMAN_CLIMBING
    [1105] = { stand = 7158, walk = 4789 },  -- CHILD_UPDATE_READY
    [1106] = { stand = 4788, walk = 1205, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- SEASLUG_WATER_READY
    [1107] = { stand = 7158, walk = 7166 },  -- CHILD_UPDATE_READY
    [1108] = { stand = 7166, walk = 7166 },  -- CHILD_CRAWL
    [1109] = { walk = 4787 },
    [1110] = { walk = 4790 },
    [1111] = { stand = 4825, walk = 4779 },  -- SLUG2_READY_STAGE_ONE
    [1112] = { stand = 3952, walk = 3953, turnLeft = 15272, turnRight = 15273, walkTurnLeft = 15272, walkTurnRight = 15273 },  -- BATTLE_TORTOISE_READY
    [1113] = { stand = 6140, walk = 6141 },  -- SURFACE_GOBLIN_UPDATE_EYEGLO_CRAZY_SCARED
    [1114] = { walk = 16006, idles = { { 16005, 80 }, { 16009, 20 } } },
    [1115] = { stand = 8497, walk = 8496 },  -- WOLF_DRUID_PICCUPSTIX_READY
    [1116] = { stand = 15931, walk = 8505 },  -- WOLF_WOLPERTINGER_2011_READY
    [1117] = { stand = 1474, walk = 283 },  -- TROLLROMANCE_CRY_TEST
    [1118] = { stand = 1480, walk = 283 },  -- TROLLROMANCE_EAT
    [1119] = { stand = 1461, walk = 1468, run = 1468, turnLeft = 1468, turnRight = 1468, walkBack = 1468, walkLeft = 1468, walkRight = 1468 },  -- TROLLROMANCE_TOBOGGAN_READY
    [1120] = { stand = 1461, walk = 1462, run = 1462, turnLeft = 1462, turnRight = 1462, walkBack = 1462, walkLeft = 1462, walkRight = 1462 },  -- TROLLROMANCE_TOBOGGAN_READY
    [1121] = { stand = 1464, walk = 1464, run = 1464, turnLeft = 1464, turnRight = 1464, walkBack = 1464, walkLeft = 1464, walkRight = 1464 },  -- TROLLROMANCE_TOBOGGAN_CRASHING
    [1122] = { stand = 1463, walk = 1463, run = 1463, turnLeft = 1463, turnRight = 1463, walkBack = 1463, walkLeft = 1463, walkRight = 1463 },  -- TROLLROMANCE_TOBOGGAN_FLYING
    [1123] = { stand = 1467, walk = 1467, run = 1467, turnLeft = 1467, turnRight = 1467, walkBack = 1467, walkLeft = 1467, walkRight = 1467 },  -- TROLLROMANCE_TOBOGGAN_STUNT
    [1124] = { stand = 7629, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- SCAB_MAISA_UNWELL_READY
    [1125] = { stand = 7629, walk = 819 },  -- SCAB_MAISA_UNWELL_READY
    [1126] = { stand = 7654, walk = 7653 },  -- LORE_BLOAT_LEECH_READY
    [1127] = { stand = 7579 },  -- SCAB_ARCHAEOLIGIST_WOMAN
    [1128] = { stand = 7578 },  -- SCAB_ARCHAEOLOGIST_MAN
    [1129] = { stand = 7593, walk = 7592 },  -- SCAB_SCARAB_BOSS_READY
    [1130] = { stand = 6263, walk = 6264 },  -- LOBSTER_UPDATE_READY
    [1131] = { stand = 9536, walk = 9537 },  -- ROCKO_FIFTY_SHIPS_MUFASSAH_READY
    [1132] = { stand = 9539, walk = 9538 },  -- ROCKO_KARAMTHULU_READY
    [1133] = { stand = 9541, walk = 9540 },  -- ROCKO_KARAMTHULU_KEY_READY
    [1134] = { stand = 7188, walk = 7191, turnLeft = 7191, turnRight = 7191, walkBack = 7191, walkLeft = 7191, walkRight = 7191 },  -- PIRATE_UPDATE_READY_AND_EXTRA
    [1135] = { stand = 9553, walk = 9551, walkBack = 9552, walkLeft = 9554, walkRight = 9555 },  -- ROCKO_HUMAN_READY_WITH_FILES
    [1136] = { stand = 9571, walk = 9570, turnLeft = 9570, turnRight = 9570, walkBack = 9570, walkLeft = 9570, walkRight = 9570 },  -- ROCKO_RABID_JACK_TREASURE_READY
    [1137] = { stand = 9571, walk = 9570 },  -- ROCKO_RABID_JACK_TREASURE_READY
    [1138] = { stand = 9546 },  -- ROCKO_RALPH_MULTINPC_ANIM
    [1139] = { stand = 8695, walk = 8699, turnLeft = 8695, turnRight = 8695, walkBack = 8699, walkLeft = 8699, walkRight = 8699 },  -- QUEST_AFR_PLAYER_READY_IN_POOL
    [1140] = { stand = 8667, walk = 8667 },  -- AFR_BUGS_SWARM
    [1141] = { stand = 8655 },  -- AFR_CHARGURR_READY
    [1142] = { stand = 8627, walk = 8573 },  -- AFR_OGRE_CHILD_READY
    [1143] = { stand = 8627, walk = 8626 },  -- AFR_OGRE_CHILD_READY
    [1144] = { stand = 8620, walk = 8573 },  -- AFR_OGRESS_FRAWD_READY_PELT
    [1145] = { stand = 8628, walk = 8573 },  -- AFR_OGRESS_READY_NO_SKIRT_VAR1
    [1146] = { stand = 8642, walk = 8573 },  -- AFR_OGRESS_CHAMPION_READY
    [1147] = { stand = 8635, walk = 8643 },  -- AFR_OGRESS_WARRIOR_READY_SPEAR
    [1148] = { stand = 8642, walk = 8643 },  -- AFR_OGRESS_CHAMPION_READY
    [1149] = { stand = 8619 },  -- AFR_OGRESS_MASSAGE
    [1150] = { stand = 8574 },  -- AFR_OGRESS_READY_NO_SKIRT
    [1151] = { stand = 8650 },  -- AFR_OGRESS_SEASONING
    [1152] = { stand = 8632, walk = 8633 },  -- AFR_OGRESS_SHAMEN_READY
    [1153] = { stand = 8630, walk = 8631 },  -- AFR_OGRESS_SNURGH_READY
    [1154] = { stand = 8634, walk = 8573 },  -- AFR_OGRESS_WARRIOR_READY_CLUB
    [1155] = { stand = 8671, walk = 8672 },  -- AFR_PLATYPUS_READY_AND_EXTRA
    [1156] = { stand = 8671, walk = 8670 },  -- AFR_PLATYPUS_READY_AND_EXTRA
    [1157] = { stand = 8683, walk = 8684, run = 8685, turnLeft = 823, turnRight = 823, walkBack = 8684, walkLeft = 8684, walkRight = 8684 },  -- AFR_OGRE_CLUB_READY
    [1158] = { stand = 3950, walk = 3997, turnLeft = 3997, turnRight = 3997, walkLeft = 3997, walkRight = 3997, walkTurnLeft = 3997, walkTurnRight = 3997 },  -- QIP_COOK_MILKMAID
    [1159] = { walk = 3220 },
    [1160] = { stand = 916, walk = 916, run = 916, turnLeft = 916, turnRight = 916, walkBack = 916, walkLeft = 916, walkRight = 916 },  -- HUMAN_LEAN_READY
    [1161] = { stand = 21761 },  -- SLISKE1_ARMADYL_GOD_SMALL_IDLE
    [1162] = { stand = 21765 },  -- SLISKE1_BANDOS_SMALL_IDLE
    [1163] = { stand = 21818 },  -- SLISKE1_DRAGONKIN_IN_CAGE_STRUGGLING_IDLE
    [1164] = { stand = 21816 },  -- SLISKE1_DEATH_IN_CAGE_IDLE
    [1165] = { stand = 6040, walk = 6215 },  -- DORGESH_GOBLIN_READY
    [1166] = { stand = 6151, walk = 6150 },  -- SLICE_HOSTAGE_READY
    [1167] = { stand = 6181, walk = 6193 },  -- SLICE_SURFACE_GOBLIN_SQUAT_READY
    [1168] = { stand = 6149 },  -- SLICE_ZANIK_PUBLIC_ADDRESS
    [1169] = { stand = 5370, walk = 5372 },  -- ANMA_GHOST_READY
    [1170] = { stand = 5371, walk = 5373 },  -- ANMA_GHOST_READY_SACK_EMPTY
    [1171] = { stand = 5363, walk = 5364, run = 824, turnLeft = 823, turnRight = 823, walkBack = 5438, walkLeft = 821, walkRight = 822 },  -- ANMA_HUMAN_READY_SACK
    [1172] = { walk = 5531 },
    [1173] = { stand = 2882, walk = 2882 },  -- SAND_STORM_NPC
    [1174] = { stand = 4866, walk = 4867 },  -- EARTH_ELEMENTAL_REWORK_READY
    [1175] = { stand = 4864, walk = 4864 },  -- EARTH_ELEMENTAL_REWORK_READY_ROCK
    [1176] = { stand = 1039, walk = 1039 },  -- ELEMENTAL_AIR_READY
    [1177] = { stand = 1027, walk = 1028 },  -- ELEMENTAL_FIRE_READY
    [1178] = { stand = 1045, walk = 1047 },  -- ELEMENTAL_WATER_READY
    [1179] = { stand = 813, walk = 1146, turnLeft = 813, turnRight = 813, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_STAFFREADY
    [1180] = { stand = 3978, walk = 3977 },  -- SWAN_GENERAL_READY
    [1181] = { stand = 3970 },  -- SWAN_INFINITEDEATH
    [1182] = { stand = 3989 },  -- SWAN_QUEEN_READY
    [1183] = { stand = 3987, walk = 3984 },  -- SWAN_SEATROLL_READY
    [1184] = { walk = 52, walkBack = 52, walkLeft = 52, walkRight = 52, idles = { { 51, 235 }, { 107, 20 } } },
    [1185] = { stand = 6282, walk = 6282 },  -- DREAM_CYRISUS_BARELY_CONSCIOUS
    [1186] = { stand = 6284, walk = 6284 },  -- DREAM_CYRISUS_SITTING_UP
    [1187] = { stand = 6280, walk = 6280 },  -- DREAM_CYRISUS_UNCONSCIOUS
    [1188] = { stand = 6343, walk = 6344 },  -- DREAM_EVERLASTING_READY
    [1189] = { stand = 6338, walk = 6339 },  -- DREAM_ILLUSIVE_READY
    [1190] = { stand = 6350, walk = 6339 },  -- DREAM_ILLUSIVE_DEATH_READY
    [1191] = { stand = 6317, walk = 6317 },  -- DREAM_INADEQUACY_READY
    [1192] = { stand = 6311, walk = 6312 },  -- DREAM_RAZORBEAST_READY
    [1193] = { stand = 6328, walk = 6328 },  -- DREAM_UNTOUCHABLE_READY_WALK
    [1194] = { stand = 1639, walk = 1640, turnLeft = 1640, turnRight = 1640, walkBack = 1640, walkLeft = 1640 },  -- AHOY_GHOST_DISGUISE_READY
    [1195] = { stand = 1639, walk = 1640 },  -- AHOY_GHOST_DISGUISE_READY
    [1196] = { stand = 1646, walk = 1647 },  -- GOOP_LAUNCH
    [1197] = { stand = 1644, walk = 1645 },  -- GOOPY_SNAKE
    [1198] = { stand = 1421, walk = 1422, walkBack = 1423, walkLeft = 1424, walkRight = 1425 },  -- HUMAN_BANNERREADY
    [1199] = { stand = 5752, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- WAKE_UP_READY
    [1200] = { stand = 3815, walk = 3819 },  -- CONFREADY
    [1201] = { stand = 3810, walk = 3809 },  -- FEAR_READY
    [1202] = { stand = 3822, walk = 3825 },  -- LESSREADY
    [1203] = { stand = 3828, walk = 3828 },  -- NECKREADY
    [1204] = { stand = 5668, walk = 5703, turnLeft = 5703, turnRight = 5703, walkBack = 5703, walkLeft = 5703, walkRight = 5667 },  -- PENG_GENTOO_READY
    [1205] = { stand = 5668, walk = 5666, run = 5667, runLeft = 5667, runRight = 5667, turnLeft = 5666, turnRight = 5666, walkBack = 5666, walkLeft = 5666, walkRight = 5666 },  -- PENG_GENTOO_READY
    [1206] = { stand = 5668, walk = 5666, turnLeft = 5666, turnRight = 5666, walkBack = 5666, walkLeft = 5666 },  -- PENG_GENTOO_READY
    [1207] = { stand = 5674 },  -- PENG_PLAYER_BONGO
    [1208] = { stand = 5705, walk = 5706, turnLeft = 5706, turnRight = 5706, walkBack = 5706, walkLeft = 5706, walkRight = 5707 },  -- PENG_SLIDE_READY
    [1209] = { stand = 5688, walk = 5689, turnLeft = 5689, turnRight = 5689, walkBack = 5689, walkLeft = 5689 },  -- PENG_SWIM_READY
    [1210] = { stand = 5675 },  -- PENG_BONGO_READY
    [1211] = { stand = 5677, walk = 5676 },  -- PENG_GENERAL_READY
    [1212] = { stand = 5685 },  -- PENG_GENTOO_PUSHUPS
    [1213] = { stand = 5668 },  -- PENG_GENTOO_READY
    [1214] = { stand = 5682 },  -- PENG_GENTOO_SITUPS_NORTH
    [1215] = { stand = 5680 },  -- PENG_GENTOO_STARJUMP_EAST
    [1216] = { stand = 5722, walk = 5721 },  -- PENG_ICELORD_READY
    [1217] = { stand = 5310, walk = 5309 },  -- EAGLEPEAK_DESERT_BOULDER_READY
    [1218] = { stand = 845, walk = 844, turnLeft = 844, turnRight = 844 },  -- HUMAN_CRAWLING_READY
    [1219] = { stand = 845, walk = 844 },  -- HUMAN_CRAWLING_READY
    [1220] = { stand = 5302, walk = 5301 },  -- UBER_KEBBIT_READY
    [1221] = { stand = 6218, walk = 6221 },  -- KALPHITE_UPDATE_READY
    [1222] = { stand = 6219, walk = 6222 },  -- KALPHITE_UPDATE_LORD_READY
    [1223] = { stand = 7099, walk = 7098 },  -- POG_ENGINEERED_TERROR_BIRD_READY
    [1224] = { stand = 7101, walk = 7098 },  -- POG_ENGINEERED_TERROR_BIRD_READY_REVERSED
    [1225] = { stand = 7111, walk = 7103 },  -- POG_ENGINEERED_TERROR_BIRD_PANIC_READY
    [1226] = { stand = 7105, walk = 7106 },  -- POG_MUTANT_TERROR_BIRD_READY
    [1227] = { stand = 7090, walk = 7089 },  -- POG_MUTATED_BATTLE_TORTOISE_READY
    [1228] = { stand = 9314, walk = 9281 },  -- DILLO_OLD_MEJ_KET_MINING
    [1229] = { stand = 9313, walk = 9281 },  -- DILLO_OLD_HUR_XIL_MINING
    [1230] = { stand = 9334, walk = 9333 },  -- DILLO_ARMADILLO_READY
    [1231] = { stand = 9343, walk = 9343 },  -- DILLO_FIRE_CREATURE_READY
    [1232] = { stand = 9326, walk = 9326 },  -- DILLO_OLD_MINING_READY
    [1233] = { stand = 9339, walk = 9339 },  -- DILLO_ROCK_CREATURE_READY
    [1234] = { stand = 9324, walk = 9321 },  -- DILLO_TZHAAR_HUR_BOOK_READY
    [1235] = { stand = 9311 },  -- DILLO_TZHAAR_LIBRARIAN_STAMPING
    [1236] = { stand = 9325, walk = 9320 },  -- DILLO_TZHAAR_MEJ_BOOK_READY
    [1237] = { stand = 9323, walk = 9322 },  -- DILLO_TZHAAR_XIL_BOOK_READY
    [1238] = { stand = 9282, walk = 9280 },  -- TZHAAR_UPDATE_TZHAAR_READY_2
    [1239] = { stand = 9283, walk = 9280 },  -- TZHAAR_UPDATE_TZHAAR_READY_3
    [1240] = { stand = 9284, walk = 9280 },  -- TZHAAR_UPDATE_TZHAAR_READY_4
    [1241] = { stand = 9285, walk = 9280 },  -- TZHAAR_UPDATE_TZHAAR_READY_5
    [1242] = { stand = 9281, walk = 9281 },  -- TZHAAR_UPDATE_TZHAAR_READY
    [1243] = { stand = 10392 },  -- SUM1_DARK_CORE_UPDATE_READY
    [1244] = { stand = 7384 },  -- SUM2_SUMMER_HIDING
    [1245] = { stand = 3840 },  -- TALKING_SACK
    [1246] = { stand = 2017, walk = 2016 },  -- VULTURE_GROUND_READY
    [1247] = { stand = 2024, walk = 2024 },  -- VULTURE_FLY
    [1248] = { stand = 4593 },  -- QIP_DIGSITE_PANNING_01
    [1249] = { stand = 4594 },  -- QIP_DIGSITE_PANNING_02
    [1250] = { stand = 6729, walk = 6730 },  -- BRUT_ANGRY_SPIRIT_READY
    [1251] = { stand = 302, walk = 1417 },  -- WATER_PYREFIEND_UPDATE_READY
    [1252] = { stand = 7366, walk = 7366 },  -- EXCHANGE_BOB_BARTER_READY
    [1253] = { stand = 7369, walk = 7369 },  -- EXCHANGE_BRUGSEN_BURSEN_READY
    [1254] = { stand = 7367, walk = 7367 },  -- EXCHANGE_FARID_READY
    [1255] = { stand = 7370, walk = 7370 },  -- EXCHANGE_HOFETHAND_READY
    [1256] = { stand = 7365, walk = 7365 },  -- EXCHANGE_MURKY_MATT_READY
    [1257] = { stand = 7364, walk = 7364 },  -- EXCHANGE_RELOBO_READY
    [1258] = { stand = 7368, walk = 7368 },  -- EXCHANGE_TUTOR_READY
    [1259] = { stand = 2939 },  -- CHAMPIONS_THRONE_SIT
    [1260] = { stand = 2943 },  -- GNOME_THRONE_SIT
    [1261] = { stand = 2940 },  -- ELF_THRONE_SIT
    [1262] = { stand = 12415, walk = 12415 },  -- BOOTH_WIZARD_READY
    [1263] = { stand = 21351 },  -- DWARF_2013_SIT_THRONE
    [1264] = { stand = 2945, walk = 2947, walkBack = 2948, walkLeft = 2949, walkRight = 2950 },  -- EARTHWARRIOR_READY
    [1265] = { stand = 6371, walk = 6372 },  -- GIANT_CHAMPION_READY
    [1266] = { stand = 5510, walk = 5511 },  -- SKELETON_UPDATE_CHAMPION_READY
    [1267] = { stand = 9299 },  -- TZHAAR_UPDATE_CHAMPION_READY
    [1268] = { stand = 6542 },  -- WEREWOLF_UPDATE_ON_THRONE
    [1269] = { stand = 5573, walk = 5582 },  -- ZOMBIE_UPDATE_READY_ARM_CHAMPION
    [1270] = { stand = 6815, walk = 32868 },  -- DUCK_REWORK_LAND_READY_AND_EXTRA
    [1271] = { stand = 847, walk = 9738, run = 9739, turnLeft = 9738, turnRight = 9738, walkBack = 9738, walkLeft = 9738, walkRight = 9738 },  -- HUMAN_READY_SCYTHE
    [1272] = { stand = 8980, walk = 9724, run = 1210, turnLeft = 1209, turnRight = 1209, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_UPDATE_READY_STAFF
    [1273] = { stand = 8609, walk = 8608 },  -- PAWYA_READY
    [1274] = { stand = 8609 },  -- PAWYA_READY
    [1275] = { stand = 8604, walk = 8606 },  -- GREN_READY
    [1276] = { stand = 8601, walk = 8606 },  -- GREN_BALL_READY
    [1277] = { stand = 5246, walk = 5245, run = 1368, turnLeft = 823, turnRight = 823, walkBack = 5245, walkLeft = 5245, walkRight = 5245 },  -- HUMAN_READY_SALAMANDER
    [1278] = { stand = 5182, walk = 5181 },  -- HUNTING_CHINCHOMPA_READY
    [1279] = { stand = 5254, walk = 5250, run = 5253, turnLeft = 5252, turnRight = 5252, walkBack = 5251, walkLeft = 1207, walkRight = 1208 },  -- HUNTING_NOOSE_READY
    [1280] = { stand = 5263, walk = 5262 },  -- SALAMANDER_READY
    [1281] = { stand = 5202, walk = 5284 },  -- FALCON_ON_PREY
    [1282] = { stand = 5203, walk = 5284 },  -- FALCON_READY
    [1283] = { walk = 18817, run = 18816, turnLeft = 18817, turnRight = 18817, walkBack = 18817, walkLeft = 18817, walkRight = 18817, idles = { { 18815, 90 }, { 37974, 10 } } },
    [1284] = { walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020, idles = { { 18815, 90 }, { 37974, 10 } } },
    [1285] = { stand = 8186, walk = 7847, run = 12818 },  -- LORE_STEEL_TITAN_READY
    [1286] = { stand = 7831, walk = 7828, run = 3368 },  -- LORE_FIRE_TITAN_READY
    [1287] = { stand = 7841, walk = 7838, run = 3360 },  -- LORE_MOSS_TITAN_READY
    [1288] = { stand = 7654, walk = 7653, run = 1770 },  -- LORE_BLOAT_LEECH_READY
    [1289] = { stand = 8301, walk = 8302, run = 1266 },  -- LORE_WOLPERTINGER_READY
    [1290] = { stand = 8089, walk = 8092, run = 3356 },  -- LORE_RAVAGER_READY
    [1291] = { stand = 8021, walk = 8022, run = 12826 },  -- LORE_MINOTAUR_READY
    [1292] = { stand = 8035, walk = 8038, run = 2801 },  -- LORE_MOSQUITO_READY
    [1293] = { stand = 8284, walk = 8281, run = 1471 },  -- LORE_TURTLE_READY
    [1294] = { stand = 7968, walk = 7961, run = 1849 },  -- LORE_KARAMTHULU_READY
    [1295] = { stand = 6374, walk = 6373, run = 2175 },  -- UNICORN_REWORK_READY
    [1296] = { stand = 7849, walk = 7848, run = 12825 },  -- LORE_ENT_READY
    [1297] = { stand = 6252, walk = 6253, run = 1260 },  -- SCORPION_UPDATE_READY
    [1298] = { stand = 7876, walk = 7877, run = 3193 },  -- LORE_GEYSER_TITAN_READY
    [1299] = { stand = 8047, walk = 8046, run = 2093 },  -- SKILL_LORE_OBSIDIAN_GOLEM_READY_PLUS_EXTRA
    [1300] = { stand = 7668, walk = 7667 },  -- LORE_ABYSS_LEECH_READY
    [1301] = { stand = 7815, walk = 7814, run = 1473 },  -- LORE_DUST_DEVIL_READY
    [1302] = { stand = 7893, walk = 7899, run = 2698 },  -- LORE_ANT_READY_AND_EXTRA
    [1303] = { stand = 7793, walk = 7792, run = 1502 },  -- LORE_WYRM_READY
    [1304] = { stand = 7677, walk = 7678, run = 1764 },  -- LORE_ABYSSAL_CRANE_READY
    [1305] = { stand = 7992, walk = 7991, run = 2172 },  -- LORE_LOCUST_READY
    [1306] = { stand = 8001 },  -- LORE_LOCUST_FLYING
    [1307] = { stand = 7738, walk = 7735 },  -- LORE_BUNYIP_READY
    [1308] = { stand = 5386, walk = 7808, run = 1268 },  -- LORE_CHICKEN_READY
    [1309] = { stand = 8518, walk = 6220, run = 2177 },  -- LORE_KALPHITE_READY
    [1310] = { stand = 7978, walk = 7977, run = 3363 },  -- LORE_LAVA_TYTN_READY
    [1311] = { stand = 8067, walk = 8072, run = 2809 },  -- LORE_MANTIS_READY_AND_EXTRA
    [1312] = { stand = 7949, walk = 7952 },  -- LORE_IRON_TITAN_READY
    [1313] = { stand = 8197, walk = 8198, run = 1769 },  -- LORE_STORK_READY
    [1314] = { stand = 8171, walk = 8175, run = 12819 },  -- LORE_SPINNER_READY
    [1315] = { stand = 8233, walk = 8234, run = 1771 },  -- LORE_TORCHER_READY
    [1316] = { stand = 7938, walk = 7941, run = 2092 },  -- HYDRA_READY_AND_EXTRA
    [1317] = { stand = 8129, walk = 8128, run = 2325 },  -- LORE_SHIFTER_READY
    [1318] = { stand = 8186, walk = 8189, run = 3358 },  -- LORE_STEEL_TITAN_READY
    [1319] = { stand = 8098, walk = 8100 },  -- LORE_CRAB_READY
    [1320] = { stand = 8255, walk = 8256, run = 2147 },  -- LORE_FIREBAT_READY
    [1321] = { stand = 8246, walk = 8245, run = 12820 },  -- LORE_TURNIP_READY
    [1322] = { stand = 7867, walk = 7868, run = 2095 },  -- FLAMING_PRINCE_READY
    [1323] = { stand = 7781, walk = 7784, run = 1472 },  -- LORE_DAGGANOTH_READY
    [1324] = { stand = 7690, walk = 7687 },  -- LORE_ABYSSAL_TITAN_READY
    [1325] = { stand = 7772, walk = 7768, run = 12817 },  -- LORE_COMPOST_MOUND_READY
    [1326] = { stand = 8297, walk = 8291 },  -- LORE_WOLF_READY
    [1327] = { stand = 8204, walk = 8207, run = 12824 },  -- LORE_STRANGER_PLANT_READY
    [1328] = { stand = 8155, walk = 8158, run = 1501 },  -- LORE_SNAKE_READY_AND_EXTRA
    [1329] = { stand = 8146, walk = 8145, run = 12816 },  -- LORE_SNAIL_READY_AND_EXTRA
    [1330] = { stand = 7751, walk = 7750, run = 12822 },  -- LORE_CHINCHOMPA_READY
    [1331] = { stand = 5986, walk = 5987, run = 1499 },  -- TREK_NAILBEAST_READY
    [1332] = { stand = 8116, walk = 8115, run = 1763 },  -- LORE_LOBSTER_READY_AND_EXTRA
    [1333] = { stand = 8220, walk = 8219, run = 3194 },  -- LORE_SWAMP_TITAN_READY
    [1334] = { stand = 8006 },  -- LORE_BIRD_RANGED_VIEWING
    [1335] = { stand = 7924, walk = 7923, run = 1011 },  -- LORE_HONEY_BADGER_READY
    [1336] = { stand = 7258, walk = 7259, run = 2812 },  -- LORE_TOAD_READY
    [1337] = { stand = 7575, walk = 8335 },  -- LORE_DOG_READY_1
    [1338] = { stand = 7575, walk = 7576 },  -- LORE_DOG_READY_1
    [1339] = { stand = 7575, walk = 8331 },  -- LORE_DOG_READY_1
    [1340] = { stand = 8344, walk = 8343 },  -- LORE_NEW_WORLD_MONKEY_READY
    [1341] = { stand = 8346, walk = 8348 },  -- LORE_NEW_WORLD_MONKEY_BABY_READY
    [1342] = { walk = 24306, run = 8326, walkLeft = 24306, walkRight = 24306, idles = { { 24307, 92 }, { 24308, 8 } } },
    [1343] = { stand = 27, walk = 21 },  -- BDRAG_READY
    [1344] = { stand = 27, walk = 21 },  -- BDRAG_READY
    [1345] = { stand = 8319, walk = 8318 },  -- LORE_PENGUIN_READY_BABY
    [1346] = { stand = 8315, walk = 8314 },  -- LORE_PENGUIN_READY_ADULT
    [1347] = { stand = 8315, walk = 8317 },  -- LORE_PENGUIN_READY_ADULT
    [1348] = { stand = 8098, walk = 8101 },  -- LORE_CRAB_READY
    [1349] = { stand = 7575, walk = 8332 },  -- LORE_DOG_READY_1
    [1350] = { stand = 7575, walk = 8333 },  -- LORE_DOG_READY_1
    [1351] = { stand = 8338, walk = 8332 },  -- LORE_DOG_READY_2
    [1352] = { stand = 8338, walk = 8333 },  -- LORE_DOG_READY_2
    [1353] = { stand = 8339, walk = 8332 },  -- LORE_DOG_READY_3
    [1354] = { stand = 8339, walk = 8333 },  -- LORE_DOG_READY_3
    [1355] = { stand = 7575, walk = 8334 },  -- LORE_DOG_READY_1
    [1356] = { stand = 7575, walk = 8335 },  -- LORE_DOG_READY_1
    [1357] = { stand = 8338, walk = 8334 },  -- LORE_DOG_READY_2
    [1358] = { stand = 8338, walk = 8335 },  -- LORE_DOG_READY_2
    [1359] = { stand = 8339, walk = 8334 },  -- LORE_DOG_READY_3
    [1360] = { stand = 8339, walk = 8335 },  -- LORE_DOG_READY_3
    [1361] = { stand = 7575, walk = 7576 },  -- LORE_DOG_READY_1
    [1362] = { stand = 8338, walk = 7576 },  -- LORE_DOG_READY_2
    [1363] = { stand = 8339, walk = 7576 },  -- LORE_DOG_READY_3
    [1364] = { stand = 7575, walk = 8329 },  -- LORE_DOG_READY_1
    [1365] = { stand = 8338, walk = 8329 },  -- LORE_DOG_READY_2
    [1366] = { stand = 8339, walk = 8329 },  -- LORE_DOG_READY_3
    [1367] = { stand = 7575, walk = 8336 },  -- LORE_DOG_READY_1
    [1368] = { stand = 7575, walk = 8337 },  -- LORE_DOG_READY_1
    [1369] = { stand = 8338, walk = 8336 },  -- LORE_DOG_READY_2
    [1370] = { stand = 8338, walk = 8337 },  -- LORE_DOG_READY_2
    [1371] = { stand = 8339, walk = 8336 },  -- LORE_DOG_READY_3
    [1372] = { stand = 8339, walk = 8337 },  -- LORE_DOG_READY_3
    [1373] = { stand = 7575, walk = 8330 },  -- LORE_DOG_READY_1
    [1374] = { stand = 7575, walk = 8331 },  -- LORE_DOG_READY_1
    [1375] = { stand = 8338, walk = 8330 },  -- LORE_DOG_READY_2
    [1376] = { stand = 8338, walk = 8331 },  -- LORE_DOG_READY_2
    [1377] = { stand = 8339, walk = 8330 },  -- LORE_DOG_READY_3
    [1378] = { stand = 8339, walk = 8331 },  -- LORE_DOG_READY_3
    [1379] = { stand = 8360, walk = 8358 },  -- LORE_GECKO_READY
    [1380] = { stand = 8360, walk = 8357 },  -- LORE_GECKO_READY
    [1381] = { stand = 813, walk = 1205, run = 824, turnLeft = 823, turnRight = 823, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [1382] = { stand = 3594, walk = 3600, turnLeft = 3594, turnRight = 3594 },  -- BALANCE_BEAM_READY
    [1383] = { stand = 847, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY_SCYTHE
    [1384] = { stand = 6496, walk = 79 },  -- DRAGON_UPDATE_READY_POH_FIX
    [1385] = { stand = 3584 },  -- ELEMENTAL_ORB_SPINS
    [1386] = { stand = 3677, walk = 3680, run = 824, turnLeft = 823, turnRight = 823, walkBack = 3680, walkLeft = 3680, walkRight = 3680 },  -- HUMAN_BOXING_READY
    [1387] = { stand = 3707, walk = 3708 },  -- OUB_MONSTER1_READY
    [1388] = { stand = 5318, walk = 5317 },  -- SPIDER_UPDATE_READY_LARGE
    [1389] = { stand = 3719 },  -- CHAIR_READY_HERALD
    [1390] = { stand = 3716, walk = 3717 },  -- POH_TOY_DOLL_READY
    [1391] = { stand = 3718, walk = 3718 },  -- POH_TOY_MOUSE_WALK
    [1392] = { stand = 3712, walk = 3713 },  -- POH_TOY_SOLDIER_READY
    [1393] = { stand = 12423, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- WTL_ELVEN_SCRIBE_READY
    [1394] = { stand = 5852, walk = 5856 },  -- COW_JUST_READY_UPDATE
    [1395] = { stand = 2701, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- PRISONER_READY_ANGRY
    [1396] = { stand = 2700, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- PRISON_GUARD_SLEEP
    [1397] = { stand = 5852, walk = 5856 },  -- COW_JUST_READY_UPDATE
    [1398] = { stand = 27, walk = 21 },  -- BDRAG_READY
    [1399] = { stand = 6772 },  -- BIRD_FLYING_UPDATE_READY_AND_EXTRA_TOUCAN_AND_CORMARANT
    [1400] = { stand = 1826, walk = 1824 },  -- CROW_READY_UPDATE
    [1401] = { stand = 1826, walk = 1825 },  -- CROW_READY_UPDATE
    [1402] = { stand = 1826, walk = 1824 },  -- CROW_READY_UPDATE
    [1403] = { stand = 90, walk = 4635 },  -- DRAGON_READY
    [1404] = { stand = 6815, walk = 6819 },  -- DUCK_REWORK_LAND_READY_AND_EXTRA
    [1405] = { stand = 6818, walk = 6817 },  -- DUCK_REWORK_UNDERWATER_READY_AND_EXTRA
    [1406] = { stand = 6813, walk = 6819 },  -- DUCK_REWORK_LAND_READY_EXTRA
    [1407] = { stand = 6821, walk = 6822 },  -- DUCKLINGS_REWORK_READY
    [1408] = { stand = 2166, walk = 2165 },  -- FARMING_PIG_READY
    [1409] = { stand = 4670, walk = 4669 },  -- GIANT_UPDATE_ICE_READY
    [1410] = { stand = 1315, walk = 1311 },  -- HORROR_CRAB_HIDE_READY
    [1411] = { stand = 179, walk = 176 },  -- LIZARDMAN_READY
    [1412] = { stand = 34, walk = 35, turnLeft = 35, turnRight = 35, walkLeft = 35, walkRight = 35, walkTurnLeft = 32, walkTurnRight = 32 },  -- VANSTROM_KLAUSE_HUMAN_READY
    [1413] = { stand = 232, walk = 229 },  -- ORK_READY
    [1414] = { stand = 6252, walk = 6253 },  -- SCORPION_UPDATE_READY
    [1415] = { stand = 10, walk = 10 },  -- SHARK_WALK
    [1416] = { stand = 2268 },  -- SITTINGDOG_READY
    [1417] = { stand = 5495, walk = 5497 },  -- SKELETON_UPDATE_GIANT_VARY2_READY
    [1418] = { stand = 6258, walk = 6257 },  -- SMALL_SCORPION_UPDATE_READY
    [1419] = { stand = 337, walk = 336 },  -- SOULESS_READY
    [1420] = { stand = 3242, walk = 3241 },  -- SWAN_READY
    [1421] = { stand = 6478 },  -- VARROCK_GRANNY_ROCKING
    [1422] = { stand = 222, walk = 219, run = 1419, runBack = 1419, runLeft = 1419, runRight = 1419, walkBack = 219, walkLeft = 219, walkRight = 219 },  -- MONKEY_READY
    [1423] = { stand = 1401, walk = 1399, run = 1400, runBack = 1400, runLeft = 1400, runRight = 1400, walkBack = 1399, walkLeft = 1399, walkRight = 1399 },  -- M_GORILLA_READY
    [1424] = { stand = 1386, walk = 1382, run = 1381, runBack = 1381, runLeft = 1381, runRight = 1381, walkBack = 1382, walkLeft = 1382, walkRight = 1382 },  -- M_MONKEY_READY
    [1425] = { stand = 3866, walk = 3865, walkBack = 3865, walkLeft = 3865, walkRight = 3865 },  -- EASTER_07_ANGRY_FARMER_READY
    [1426] = { stand = 808, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [1427] = { stand = 757, walk = 756, turnLeft = 757, turnRight = 757, walkBack = 756, walkLeft = 756, walkRight = 756 },  -- HUMAN_READY_SIDESTEPL
    [1428] = {  },
    [1429] = { stand = 11029, walk = 11029, run = 11030, turnLeft = 11029, turnRight = 11029, walkBack = 11029, walkLeft = 11029, walkRight = 11029 },  -- XMAS08_HUMAN_SLIPPERY_READY
    [1430] = { stand = 808, walk = 819, run = 1210, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [1431] = { stand = 262, walk = 11218 },  -- BASILISK_UPDATE_READY
    [1432] = { stand = 7760, walk = 7759 },  -- LORE_COCKATRICE_READY
    [1433] = { stand = 11215, walk = 11217 },  -- SNP_KURSK_READY
    [1434] = { stand = 11195, walk = 11196 },  -- SNP_FIRE_BOSS_READY
    [1435] = { stand = 11200, walk = 11201 },  -- SNP_NATURE_BOSS_READY
    [1436] = { stand = 5530, walk = 5531, turnLeft = 5531, turnRight = 5531, walkBack = 5531, walkLeft = 5531, walkRight = 5531 },  -- GHOST_UPDATE_NORMAL_READY
    [1437] = { stand = 4087, walk = 4087 },  -- CHAIR_SIT_READY_CHAIR7
    [1438] = { stand = 808, walk = 819, crawl = 844, crawlBack = 846, crawlLeft = 844, crawlRight = 844, run = 824, runBack = 824, runLeft = 824, runRight = 824, turnLeft = 915, turnRight = 915, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [1439] = { stand = 4010, walk = 1139 },  -- PINBALL_TROLL_EASE_LFT
    [1440] = { stand = 4009, walk = 1139 },  -- PINBALL_TROLL_EASE_RHT
    [1441] = { stand = 11259 },  -- CHOSEN_ZANIK_ROCK_READY_A
    [1442] = { stand = 11262 },  -- CHOSEN_ZANIK_ROCK_READY_B
    [1443] = { stand = 11264 },  -- CHOSEN_ZANIK_ROCK_READY_C
    [1444] = { stand = 11304 },  -- CHOSEN_ZANIK_UNCONSCIOUS
    [1445] = { stand = 11304, walk = 6041, run = 11267, turnLeft = 6041, turnRight = 6041, walkBack = 6041, walkLeft = 6041, walkRight = 6041 },  -- CHOSEN_ZANIK_UNCONSCIOUS
    [1446] = { stand = 6040, walk = 6041, run = 6041, turnLeft = 6041, turnRight = 6041, walkBack = 6041, walkLeft = 6041, walkRight = 6041 },  -- DORGESH_GOBLIN_READY
    [1447] = { stand = 11268, walk = 6041, run = 11267, turnLeft = 6041, turnRight = 6041, walkBack = 6041, walkLeft = 6041, walkRight = 6041 },  -- CHOSEN_ZANIK_BALANCE_READY
    [1448] = { stand = 6040, walk = 6041, run = 11267, runBack = 11267, runLeft = 11267, runRight = 11267, turnLeft = 6041, turnRight = 6041, walkBack = 6041, walkLeft = 6041, walkRight = 6041 },  -- DORGESH_GOBLIN_READY
    [1449] = { stand = 11390, walk = 11391, run = 11392, runBack = 11392, runLeft = 11392, runRight = 11392, turnLeft = 11391, turnRight = 11391, walkBack = 11391, walkLeft = 11391, walkRight = 11391 },  -- CHOSEN_GOBLIN_READY_CROSSBOW
    [1450] = { stand = 808, walk = 819, run = 824, runBack = 824, runLeft = 824, runRight = 824, turnLeft = 808, turnRight = 808, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [1451] = { stand = 6181, walk = 6180, run = 7332, runBack = 7332, runLeft = 7332, runRight = 7332, turnLeft = 6181, turnRight = 6181, walkBack = 6180, walkLeft = 6180, walkRight = 6180 },  -- SLICE_SURFACE_GOBLIN_SQUAT_READY
    [1452] = { stand = 11309, walk = 11309, walkBack = 11309, walkLeft = 11309, walkRight = 11309 },  -- CHOSEN_SIGMUND_IN_PAIN_READY
    [1453] = { stand = 11357, walk = 11399 },  -- CHOSEN_ORK_STATUE_READY
    [1454] = { stand = 11242, walk = 11255 },  -- CHOSEN_BANDOS_AVATAR_READY
    [1455] = { stand = 11241, walk = 11255 },  -- CHOSEN_BANDOS_AVATAR_DEPLETED_READY
    [1456] = { stand = 11395, walk = 11394 },  -- CHOSEN_STATUE_GOBLIN_SQUAT_READY
    [1457] = { stand = 11407, walk = 11406 },  -- CHOSEN_STATUE_GODWARS_BANDOS_READY
    [1458] = { stand = 5750, walk = 6042 },  -- CHOSEN_GOBLIN_CHILD_SICK_READY_A
    [1459] = { stand = 5751, walk = 6042 },  -- CHOSEN_GOBLIN_CHILD_SICK_READY_B
    [1460] = { stand = 11225, walk = 6042 },  -- CHOSEN_GOBLIN_CHILD_SICK_READY_C
    [1461] = { stand = 11226, walk = 6042 },  -- CHOSEN_GOBLIN_CHILD_SICK_READY_D
    [1462] = { stand = 6040, walk = 6041, run = 11267, turnLeft = 6041, turnRight = 6041, walkBack = 6041, walkLeft = 6041, walkRight = 6041 },  -- DORGESH_GOBLIN_READY
    [1463] = { stand = 11228, walk = 11228, run = 11228, turnLeft = 11228, turnRight = 11228, walkBack = 11228, walkLeft = 11228, walkRight = 11228 },  -- CHOSEN_PLAYER_BALANCE_READY
    [1464] = { stand = 11358, walk = 11413 },  -- CHOSEN_OGRE_STATUE_READY
    [1465] = { stand = 11423 },  -- OGRE_MALE_INJURED_A
    [1466] = { stand = 11424 },  -- OGRE_MALE_INJURED_B
    [1467] = { stand = 11460, walk = 11461 },  -- OGRE_MALE_ZOMBIE_BOSS_READY
    [1468] = { stand = 10626, walk = 8573 },  -- OGRE_MALE_READY_CHEST
    [1469] = { stand = 11451 },  -- MELTING_OGRE_REWORK
    [1470] = { stand = 11452 },  -- OGRE_AND_BOAT_READY
    [1471] = { stand = 11453 },  -- OGRE_AND_BOAT_WALK
    [1472] = { stand = 11422 },  -- OGRE_MALE_DRUMMER
    [1473] = { stand = 11467, walk = 11464 },  -- CHIEFTAN_OGRE_READY_STAFF
    [1474] = { stand = 11468, walk = 11465 },  -- CHIEFTAN_OGRE_READY_CLUB
    [1475] = { stand = 11469, walk = 11466 },  -- CHIEFTAN_OGRE_READY
    [1476] = { stand = 11426, walk = 11463 },  -- OGRE_MALE_READY_BOW
    [1477] = { stand = 11462, walk = 10625 },  -- OGRE_MALE_READY_CLUB
    [1478] = { stand = 11441, walk = 11442 },  -- MOGRE_MALE_READY
    [1479] = { stand = 11434, walk = 11433 },  -- ZOGRE_MALE_READY
    [1480] = { stand = 11436, walk = 11433 },  -- ZOGRE_MALE_DANCE
    [1481] = { stand = 11482, walk = 819, run = 11481 },  -- HUMAN_READY_MACE
    [1482] = { stand = 11683 },  -- FIGHT_ARENA_GUARD_CHATTING_RHT_NORTH
    [1483] = { stand = 11677 },  -- FIGHT_ARENA_GUARD_DEPRESSED
    [1484] = { stand = 11684 },  -- FIGHT_ARENA_GUARD_DEPRESSED_NORTH
    [1485] = { stand = 11672 },  -- FIGHT_ARENA_GUARD_SITTING_CHEERING
    [1486] = { stand = 11679 },  -- FIGHT_ARENA_GUARD_SITTING_CHEERING_NORTH
    [1487] = { stand = 11685 },  -- FIGHT_ARENA_GUARD_SITTING_CHEERING_WEST
    [1488] = { stand = 11671 },  -- FIGHT_ARENA_GUARD_SITTING_CHILLING
    [1489] = { stand = 11678 },  -- FIGHT_ARENA_GUARD_SITTING_CHILLING_NORTH
    [1490] = { stand = 11673 },  -- FIGHT_ARENA_GUARD_STANDING_CHEERING
    [1491] = { stand = 11674 },  -- FIGHT_ARENA_GUARD_STANDING_CHEERING_M
    [1492] = { stand = 11680 },  -- FIGHT_ARENA_GUARD_STANDING_CHEERING_NORTH
    [1493] = { stand = 11681 },  -- FIGHT_ARENA_GUARD_STANDING_CHEERING_NORTH_M
    [1494] = { stand = 11686 },  -- FIGHT_ARENA_GUARD_STANDING_CHEERING_WEST
    [1495] = { stand = 11687 },  -- FIGHT_ARENA_GUARD_STANDING_CHEERING_WEST_M
    [1496] = { stand = 2700 },  -- PRISON_GUARD_SLEEP
    [1497] = { stand = 11690 },  -- FIGHT_ARENA_SLEEPING_CITIZEN
    [1498] = { walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822, idles = { { 808, 2 }, { 11659, 1 } } },
    [1499] = { walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822, idles = { { 808, 2 }, { 11658, 1 } } },
    [1500] = { stand = 11660, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- FIGHT_ARENA_JUSTIN_LAUGHING
    [1501] = { stand = 11701, walk = 11700 },  -- LEPRECHAUN_UPDATE_READY_WINDMILL
    [1502] = { stand = 5804, walk = 11693, run = 11693 },  -- LEPRECHAUN_UPDATE_READY_BUTTERFLY
    [1503] = { stand = 11691, walk = 11698, run = 11694 },  -- LEPRECHAUN_UPDATE_READY_WAND
    [1504] = { stand = 11692, walk = 11695 },  -- LEPRECHAUN_UPDATE_READY_WREATH
    [1505] = { stand = 11699, walk = 11695 },  -- LEPRECHAUN_UPDATE_READY_PANPIPE
    [1506] = { stand = 5808, walk = 11697 },  -- LEPRECHAUN_UPDATE_READY_STAFF
    [1507] = { stand = 5808, walk = 11697 },  -- LEPRECHAUN_UPDATE_READY_STAFF
    [1508] = { stand = 5808, walk = 11697 },  -- LEPRECHAUN_UPDATE_READY_STAFF
    [1509] = { stand = 5808, walk = 11697 },  -- LEPRECHAUN_UPDATE_READY_STAFF
    [1510] = { stand = 6268, walk = 11695 },  -- LEPRECHAUN_UPDATE_READY_SUNBATHING
    [1511] = { stand = 5806, walk = 11696 },  -- LEPRECHAUN_UPDATE_READY_GROUCHY
    [1512] = { stand = 5807, walk = 11695 },  -- LEPRECHAUN_UPDATE_READY_SAT
    [1513] = { stand = 11736, walk = 98 },  -- PENG_RAK_DWARF_READY
    [1514] = { stand = 11750, walk = 5666 },  -- PENG_RAK_DISGUISED_DWARF_REVEALED_READY
    [1515] = { stand = 17214, walk = 17215 },  -- POLAR_BEAR_UPDATE_READY
    [1516] = { stand = 11737, walk = 11738 },  -- PENG_RAK_DWARF_CRATE_READY
    [1517] = { stand = 11756, walk = 11756 },  -- PENG_RAK_KGP_SLEEPING
    [1518] = { stand = 11740, walk = 11741 },  -- PENG_RAK_LARRY_STRAIGHT_JACKET_READY
    [1519] = { stand = 11747, walk = 11746 },  -- PENG_RAK_PENGUIN_FILE_CARRYING_READY
    [1520] = { stand = 11711 },  -- PENG_RAK_POLAR_BEAR_IN_SNOW_READY
    [1521] = { stand = 11714 },  -- PENG_RAK_POLAR_BEAR_PALM_LEAF_READY
    [1522] = { stand = 11744, walk = 11745, crawl = 11745, run = 11745 },  -- PENG_RAK_SUB_CAPTAIN_READY
    [1523] = { stand = 11743, walk = 11742, crawl = 11742, run = 11742 },  -- PENG_RAK_INTERROGATOR_READY
    [1524] = { stand = 11747, walk = 11746, crawl = 11746, run = 11746 },  -- PENG_RAK_PENGUIN_FILE_CARRYING_READY
    [1525] = { stand = 5675, walk = 5675 },  -- PENG_BONGO_READY
    [1526] = { stand = 5673, walk = 5673 },  -- PENG_COWBELL_READY
    [1527] = { stand = 11751, walk = 11752 },  -- PENG_LEADER_READY
    [1528] = { stand = 11893, walk = 9869 },  -- MOB_MAL_AGITATED_READY
    [1529] = { stand = 11848, walk = 6187 },  -- MOB_GOBLIN_WATCHING_TABLE_TOP_MAP
    [1530] = { stand = 24427, walk = 24427 },  -- MOB_2014_DWARF_BANKER
    [1531] = { stand = 24428, walk = 24428 },  -- MOB_2014_DWARF_RECRUITER
    [1532] = { stand = 11808, walk = 11808 },  -- REST_SNAKE_BASKET
    [1533] = { stand = 11810, walk = 11810 },  -- REST_FIDDLE_PLAYING_BASIC
    [1534] = { stand = 11811, walk = 11811 },  -- REST_FIDDLE_PLAYING_BASIC_ALT
    [1535] = { stand = 11812, walk = 11812 },  -- REST_FIDDLE_PLAYING_BASIC_FEMALE
    [1536] = { stand = 11813, walk = 11813 },  -- REST_FLUTE_PLAYING_BASIC
    [1537] = { stand = 11814, walk = 11814 },  -- REST_LYRE_PLAYING_BASIC
    [1538] = { stand = 11815, walk = 11815 },  -- REST_PIPES_PLAYING_BASIC
    [1539] = { stand = 11816, walk = 11816 },  -- REST_HORN_PLAYING_BASIC
    [1540] = { stand = 11817, walk = 11817 },  -- REST_OCARINA_PLAYING_BASIC
    [1541] = { stand = 11796, walk = 11796 },  -- REST_LUTE_PLAYING_BASIC
    [1542] = { stand = 11797, walk = 11797 },  -- REST_LUTE_PLAYING_BASIC_FEMALE
    [1543] = { stand = 11798, walk = 11798 },  -- REST_LUTE_PLAYING_BASIC_FEMALE_ALT
    [1544] = { stand = 11802, walk = 11802 },  -- REST_LUTE_PLAYING_DRUNK_BASIC
    [1545] = { stand = 11795, walk = 11795 },  -- REST_DRUM_PLAYING_BASIC
    [1546] = { stand = 11800, walk = 11800 },  -- REST_GOBLIN_DRUM_PLAYING_BASIC
    [1547] = { stand = 11799, walk = 11799 },  -- REST_BAGPIPE_PLAYING_BASIC
    [1548] = { stand = 11809, walk = 11809 },  -- REST_ACCORDION_PLAYING_BASIC
    [1549] = { stand = 5732, walk = 819 },  -- REST_PLAYER_SIT_RELAXED_MIDDLE
    [1550] = { stand = 11787, walk = 819 },  -- REST_PLAYER_SIT_RELAXED_MIDDLE_ALT
    [1551] = { stand = 2920, walk = 819 },  -- REST_PLAYER_SIT_STRAIGHT_MIDDLE
    [1552] = { stand = 11868, walk = 11868 },  -- MOB_RECRUITMENT_READY_ELF
    [1553] = { stand = 11867, walk = 11867 },  -- MOB_RECRUITMENT_READY_GNOME
    [1554] = { stand = 11866, walk = 11866 },  -- MOB_RECRUITMENT_READY_GOBLIN
    [1555] = { stand = 11865, walk = 11865 },  -- MOB_RECRUITMENT_READY_HUMAN
    [1556] = { stand = 11832, walk = 11837 },  -- MOB_TROOP_READY_HUMANS
    [1557] = { stand = 11836, walk = 11837 },  -- MOB_TROOP_READY_GNOMES
    [1558] = { stand = 7167, walk = 7160 },  -- CHILD_READY_AND_EXTRA
    [1559] = { stand = 11834, walk = 11837 },  -- MOB_TROOP_READY_DWARVES
    [1560] = { stand = 11833, walk = 11837 },  -- MOB_TROOP_READY_ELVES
    [1561] = { stand = 11835, walk = 11837 },  -- MOB_TROOP_READY_GOBLINS
    [1562] = { stand = 11831, walk = 11837 },  -- MOB_TROOP_READY
    [1563] = { stand = 11895, walk = 11896 },  -- SPHINX_UPDATE_READY
    [1564] = { stand = 2034, walk = 819 },  -- REST_PLAYER_SIT_RELAXED_MIDDLE_FEMALE_ALT
    [1565] = { stand = 2037, walk = 9869, walkBack = 9869, walkLeft = 9869, walkRight = 9869 },  -- EMRG_FARUQ_READY
    [1566] = { stand = 11912 },  -- EMRG_PLANT_GROW_NO_ARROW_READY
    [1567] = { stand = 11914 },  -- EMRG_PLANT_GROW_WITH_ARROW_SOUTH_READY
    [1568] = { stand = 11952, walk = 11952, turnLeft = 11952, turnRight = 11952, walkBack = 11952, walkLeft = 11952, walkRight = 11952 },  -- _100_ILM_MONKEYBAR_MOVE_LOW
    [1569] = { stand = 11950, walk = 11950, turnLeft = 11950, turnRight = 11950, walkBack = 11950, walkLeft = 11950, walkRight = 11950 },  -- AGILITY_UPDATE_WATER_SLIDE
    [1570] = { stand = 11951, walk = 11951, turnLeft = 11951, turnRight = 11951, walkBack = 11951, walkLeft = 11951, walkRight = 11951 },  -- AGILITY_UPDATE_WATER_SLIDE_REST
    [1571] = { stand = 6821, walk = 6822, crawl = 6822, run = 6822, walkBack = 16408 },  -- DUCKLINGS_REWORK_READY
    [1572] = { stand = 2163, walk = 2164, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- SPADE_READY
    [1573] = { stand = 3269, walk = 3270, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 3271, walkRight = 3272 },  -- SPADE_READY_ALT
    [1574] = { stand = 12106, walk = 819 },  -- REST_PLAYER_SIT_RELAXED_MIDDLE_FEMALE
    [1575] = { stand = 405, walk = 392, crawl = 392 },  -- PAP_SPARKY_SQUIRREL_READY
    [1576] = { stand = 11960, walk = 11960 },  -- PAP_SPITROAST
    [1577] = { stand = 11963, walk = 11965, walkBack = 11964, walkLeft = 11966, walkRight = 11967 },  -- PAP_MARIAN_READY
    [1578] = { stand = 11973, walk = 11975, run = 11976, turnLeft = 11977, turnRight = 11977, walkBack = 11975, walkLeft = 11975, walkRight = 11975 },  -- _7W_SLAYER_ABYSSAL_WHIP_READY
    [1579] = { stand = 11982, walk = 11983, run = 11984, turnLeft = 11988, turnRight = 11988, walkBack = 11987, walkLeft = 11986, walkRight = 11985 },  -- _7W_HUMAN_DH_WEAPON_READY
    [1580] = { stand = 12000, walk = 11999, run = 12001, turnLeft = 11999, turnRight = 11999, walkBack = 11999, walkLeft = 11999, walkRight = 11999 },  -- _7W_BARROW_DHAROK_READY
    [1581] = { stand = 12010, walk = 12012, run = 12016, turnLeft = 12011, turnRight = 12011, walkBack = 12013, walkLeft = 12014, walkRight = 12015 },  -- _7W_HUMAN_STAFFREADY
    [1582] = { stand = 15069, walk = 15073, run = 15070, turnLeft = 12024, turnRight = 12024, walkBack = 15075, walkLeft = 15076, walkRight = 15077 },  -- _7W_HUMAN_READY_2010_DRAGON_SCIMITAR
    [1583] = { stand = 12038, walk = 12037 },  -- SLAYER_AQUANITE_READY
    [1584] = { stand = 12048, walk = 12049 },  -- RAG2_OLD_MAN_BONE_SACK_READY
    [1585] = { stand = 12050, walk = 12051 },  -- RAG2_OLD_MAN_FURS_READY
    [1586] = { stand = 12089, walk = 12090, crawl = 12090 },  -- RAG2_LEFT_HAND_READY
    [1587] = { stand = 12094, walk = 12095, crawl = 12095 },  -- RAG2_RIGHT_HAND_READY
    [1588] = { stand = 12099, walk = 12100, crawl = 12100 },  -- RAG2_TAIL_READY
    [1589] = { stand = 12104, walk = 12078 },  -- RAG2_SKELETAL_BEAST_BREAKING_FREE_READY
    [1590] = { stand = 12074, walk = 12078 },  -- RAG2_SKELETAL_BEAST_READY_A
    [1591] = { stand = 12074, walk = 12079 },  -- RAG2_SKELETAL_BEAST_READY_A
    [1592] = { stand = 12076, walk = 12080 },  -- RAG2_SKELETAL_BEAST_READY_C
    [1593] = { stand = 12077, walk = 12081 },  -- RAG2_SKELETAL_BEAST_READY_D
    [1594] = { stand = 2772 },  -- FISHBOWL_SWIMS
    [1595] = { stand = 101, walk = 98, run = 12132 },  -- DWARF_READY
    [1596] = { stand = 12144, walk = 12145 },  -- RA3_PRISONER_TIED_READY
    [1597] = { stand = 12148, walk = 12149 },  -- RA3_DWOGRE_READY
    [1598] = { stand = 12139, walk = 12139 },  -- RA3_GUARD_CROUCHED_INJURED
    [1599] = { stand = 12140, walk = 12140 },  -- RA3_GUARD_SAT_INJURED
    [1600] = { stand = 12133, walk = 12131 },  -- RED_AXE3_DRUNK_READY
    [1601] = { stand = 12121, walk = 12128 },  -- RED_AXE3_WOUNDED_READY
    [1602] = { stand = 21399, walk = 21400, run = 21410, turnLeft = 21400, turnRight = 21400, walkLeft = 21400, walkRight = 21400, walkTurnLeft = 21400, walkTurnRight = 21400 },  -- RA3_DWARF_2013_BATTLEFIELD_ARQUEBUSTER_IDLE
    [1603] = { stand = 12155, walk = 12154, run = 12183, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- RED_AXE3_PLAYER_HOLDING_RIFLE_READY
    [1604] = { stand = 12186, walk = 2156 },  -- DWARF_DIRECTOR_TABLE_READY_TABLE_FIX
    [1605] = { stand = 12211, walk = 98 },  -- LRC_DWARF_EXPLORER_READY
    [1606] = { stand = 12193, walk = 12195 },  -- LRC_ROCK_CREATURE_MELEE_READY
    [1607] = { stand = 12170, walk = 12170 },  -- LRC_ROCK_CREATURE_MELEE_DEATH_READY
    [1608] = { stand = 12202, walk = 12203 },  -- LRC_ROCK_CREATURE_RANGED_READY
    [1609] = { stand = 12200, walk = 12200 },  -- LRC_ROCK_CREATURE_RANGED_DEATH_READY
    [1610] = { stand = 12210, walk = 12209 },  -- LRC_ROCK_3X3_CREATURE_MELEE_READY
    [1611] = { stand = 12207, walk = 12207 },  -- LRC_ROCK_3X3_CREATURE_MELEE_DEATH_READY
    [1612] = { stand = 12220, walk = 12221 },  -- LRC_ROCK_CRITTERS_READY
    [1613] = { stand = 9956, walk = 9957, run = 824, runBack = 824, runLeft = 824, runRight = 824, turnLeft = 9956, turnRight = 9956, walkBack = 9957, walkLeft = 9957, walkRight = 9957 },  -- TUTORIAL2_WHITE_KNIGHT_READY
    [1614] = { stand = 12235, walk = 9957, turnLeft = 12235, turnRight = 12235, walkBack = 9957, walkLeft = 9957, walkRight = 9957 },  -- TUT3_KNIGHT_READY_NEW_1ST
    [1615] = { stand = 12234, walk = 9957, turnLeft = 12234, turnRight = 12234, walkBack = 9957, walkLeft = 9957, walkRight = 9957 },  -- TUT3_KNIGHT_READY_NEW_2ND
    [1616] = { stand = 12233, walk = 9957, turnLeft = 12233, turnRight = 12233, walkBack = 9957, walkLeft = 9957, walkRight = 9957 },  -- TUT3_DISTRACT_DRAGON
    [1617] = { stand = 808, walk = 12280, run = 12280, runBack = 12280, runLeft = 12280, runRight = 12280, turnLeft = 808, turnRight = 808, walkBack = 12280, walkLeft = 12280, walkRight = 12280 },  -- HUMAN_READY
    [1618] = { stand = 12249, walk = 12247 },  -- TUTORIAL3_DRAGON_UPDATE_09_READY
    [1619] = { stand = 12253, walk = 12253 },  -- DRAGON_UPDATE_09_WALK_BACKWARDS
    [1620] = { stand = 12255, walk = 12255 },  -- TUTORIAL_3_DRAGON_SLEEPING
    [1621] = { stand = 12228, walk = 12227, turnLeft = 12228, turnRight = 12228, walkBack = 12227, walkLeft = 12227, walkRight = 12227 },  -- TUT3_SQUIRE_READY
    [1622] = { walk = 5739, turnLeft = 4641, turnRight = 4641, walkBack = 5739, walkLeft = 5739, walkRight = 5739, idles = { { 9946, 220 }, { 4641, 35 } } },
    [1623] = { stand = 12297 },  -- TUTORIAL_DOG_SLEEPING
    [1624] = {  },
    [1625] = { stand = 12290, walk = 12291, turnLeft = 12291, turnRight = 12291 },  -- FAI_LUMBRIDGE_SHOPKEEPER_READY
    [1626] = { stand = 12292, walk = 9680 },  -- FAI_LUMBRIDGE_DOOMSAYER_READY_UPDATE
    [1627] = { walk = 12294, idles = { { 12294, 60 }, { 12295, 25 }, { 12296, 15 } } },
    [1628] = { stand = 2704, walk = 2703, crawl = 2703, run = 2703 },  -- MOUSE_READY
    [1629] = { stand = 15069, walk = 15073, run = 15070, turnLeft = 12024, turnRight = 12024, walkBack = 15075, walkLeft = 15076, walkRight = 15077 },  -- _7W_HUMAN_READY_2010_DRAGON_SCIMITAR
    [1630] = { stand = 165, walk = 167 },  -- HOBGOBLIN_UPDATE_READY
    [1631] = { stand = 12403, walk = 12404 },  -- HOBGOBLIN_UPDATE_READY_UNARMED
    [1632] = { stand = 165, walk = 167 },  -- HOBGOBLIN_UPDATE_READY
    [1633] = { stand = 12427, walk = 12427, run = 12427, turnLeft = 12427, turnRight = 12427, walkBack = 12427, walkLeft = 12427, walkRight = 12427 },  -- WTL_CRYSTAL_REFLECTION_MIRROR
    [1634] = { stand = 17840, walk = 17840, run = 17840, runBack = 17840, runLeft = 17840, runRight = 17840, turnLeft = 17840, turnRight = 17840, walkBack = 17840, walkLeft = 17840, walkRight = 17840 },  -- PNR_DWARVEN_MINER_MINING
    [1635] = { stand = 4859, turnLeft = 4859, turnRight = 4859 },  -- GLASSBLOWING_READY
    [1636] = { stand = 12483, walk = 12483 },  -- HW09_REAPER_READY
    [1637] = { stand = 12478, walk = 12478 },  -- HW09_HUMAN_WALK_LOGBALANCE_LOOP
    [1638] = { stand = 20161, walk = 18016, run = 18017, turnLeft = 18016, turnRight = 18016 },  -- HW09_PLAYER_EEK_2013_IDLE
    [1639] = { stand = 12498 },  -- HW09_SPIDER_IN_BATH
    [1640] = { stand = 12499 },  -- HW09_SPIDER_QUEEN
    [1641] = { stand = 12486 },  -- HW09_SPIDER_HERALD_READY
    [1642] = { stand = 12479, walk = 12480, turnLeft = 12479, turnRight = 12479, walkBack = 12480, walkLeft = 12480, walkRight = 12480 },  -- HW09_HUMAN_READY_SIDESTEP
    [1643] = { stand = 12481, walk = 12482, turnLeft = 12481, turnRight = 12481, walkBack = 12482, walkLeft = 12482, walkRight = 12482 },  -- HW09_HUMAN_READY_SIDESTEPL
    [1644] = { stand = 12510, walk = 12511, run = 1988, turnLeft = 12511, turnRight = 12511, walkBack = 3177, walkLeft = 12511, walkRight = 12511 },  -- HUMAN_UPDATE_READY_MUD_PIE
    [1645] = { crawl = 5486, idles = { { 5482, 90 }, { 5484, 10 } } },
    [1646] = { stand = 5504, walk = 12514 },  -- CHAMPIONS2_MUMMY_READY
    [1647] = { stand = 37961, walk = 37952 },  -- GNOME_OLD_READY
    [1648] = { stand = 12523, walk = 12524, run = 12525 },  -- CHAMP_IMP_FOLLOWER_READY
    [1649] = { stand = 2978, walk = 2979 },  -- MAH4_ICE_DAEMON_READY
    [1650] = { stand = 7536, walk = 7536 },  -- MAH4_ORB_ALTAR_BROKEN
    [1651] = { stand = 1728, walk = 12542 },  -- HUMAN_FARMING
    [1652] = { stand = 12547, walk = 12547 },  -- MAH4_RCU_MAGE_FLOATING_READY
    [1653] = { stand = 12591, walk = 12592 },  -- SLAYGUILD_KURADAL_READY
    [1654] = { stand = 1338, walk = 1528 },  -- HORROR_DAGANNOTH_READY
    [1655] = { stand = 1338, walk = 1529 },  -- HORROR_DAGANNOTH_READY
    [1656] = { stand = 6733, crawl = 6733 },  -- BRUT_PYRE_BOAT_FIRE
    [1657] = { walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822, idles = { { 808, 2 }, { 860, 3 } } },
    [1658] = { stand = 808, walk = 819, turnLeft = 808, turnRight = 808, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [1659] = { stand = 1521, walk = 1521, crawl = 1521 },  -- EVQ_FIRE_ON_BOAT
    [1660] = { stand = 1525, walk = 1525, crawl = 1525 },  -- EVQ_FIRE_ON_BOAT_B
    [1661] = { stand = 226 },  -- EVQ_VARGAS_INJURED_LYING_DOWN
    [1662] = { stand = 227, walk = 228, walkLeft = 228, walkRight = 228 },  -- EVQ_VARGAS_INJURED_READY
    [1663] = { stand = 1514 },  -- EVQ_SILAS_INJURED_READY
    [1664] = { stand = 1516 },  -- EVQ_DEATH_POSE_B
    [1665] = { stand = 1517 },  -- EVQ_DEATH_POSE_C
    [1666] = { stand = 1507, walk = 1508 },  -- EVQ_BABA_YAGA_READY
    [1667] = { stand = 1530 },  -- EVQ_DAGANNOTH_MOTHER_DEATH_READY
    [1668] = { walk = 1339, idles = { { 1338, 90 }, { 1541, 10 } } },
    [1669] = { stand = 3330, walk = 3333 },  -- VAMPIRE_READY
    [1670] = { stand = 66, walk = 63 },  -- DEMON_READY
    [1671] = { stand = 71, walk = 70 },  -- QIP_DS_DARK_WIZARD_READY
    [1672] = { stand = 12610, walk = 12623, turnLeft = 12623, turnRight = 12623, walkTurnLeft = 12623, walkTurnRight = 12623 },  -- HLM_RIPPER_DEMON_PET_IDLE
    [1673] = { stand = 3040, walk = 3039 },  -- DRUNK_HOLDITEM_READY
    [1674] = { walk = 819, idles = { { 808, 60 }, { 12668, 10 }, { 12669, 10 }, { 12670, 5 }, { 12671, 15 } } },
    [1675] = { walk = 12673, idles = { { 12672, 60 }, { 12674, 15 }, { 12675, 10 }, { 12676, 5 }, { 12677, 10 } } },
    [1676] = { walk = 12689, idles = { { 3040, 90 }, { 12678, 10 } } },
    [1677] = { stand = 12679, walk = 12680 },  -- XMAS09_SCOURGE_READY
    [1678] = { stand = 12681, walk = 12680 },  -- XMAS09_SCOURGE_PYJAMAS_READY
    [1679] = { stand = 12684, walk = 12685 },  -- XMAS09_TINY_TOM_READY
    [1680] = { stand = 12633, walk = 819 },  -- XMAS09_PORTAL_PARTYGOER_READY
    [1681] = { stand = 12657, walk = 6531 },  -- XMAS09_SNOW_QUEEN_READY
    [1682] = { stand = 12661, walk = 12665, run = 12663 },  -- XMAS09_CANDY_CANE_READY
    [1683] = { stand = 4626 },  -- IMP_RUN
    [1684] = { walk = 9500, idles = { { 2287, 90 }, { 2723, 10 } } },
    [1685] = { stand = 9515, walk = 12692, run = 12692, turnLeft = 9515, turnRight = 9515, runTurnLeft = 12692, runTurnRight = 12692, walkTurnLeft = 12692, walkTurnRight = 12692 },  -- NOM_NOMAD_READY
    [1686] = { stand = 12721 },  -- NOM_NOMAD_MINE_READY
    [1687] = { stand = 12695, walk = 12695 },  -- NOM_NOMAD_DEATH_READY
    [1688] = { walk = 12747, idles = { { 12747, 90 }, { 12748, 10 } } },
    [1689] = { stand = 12745, walk = 12745 },  -- NOM_DEAD_KNIGHT_READY
    [1690] = { stand = 10842, walk = 9869, run = 9754, walkBack = 9869, walkLeft = 9869, walkRight = 9869 },  -- LUC2_ELITE_GUARD_RANGER_READY
    [1691] = { idles = { { 5429, 90 }, { 12764, 4 }, { 12765, 6 } } },
    [1692] = { idles = { { 12766, 85 }, { 12767, 10 }, { 12768, 5 } } },
    [1693] = { stand = 808 },  -- HUMAN_READY
    [1694] = { idles = { { 12772, 90 }, { 12773, 4 }, { 12774, 6 } } },
    [1695] = { stand = 12784, walk = 12785, run = 12786 },  -- HUMAN_READY_MACHINIMA_CAMERA
    [1696] = { walk = 12790, idles = { { 12790, 185 }, { 32175, 70 } } },
    [1697] = { stand = 12788, walk = 12789 },  -- STRYKEWYRM_NPC_MOUND_READY
    [1698] = { stand = 12810 },  -- SFA_DRUID_PICKENMIX_READY
    [1699] = { stand = 12815 },  -- SFA_SHARD_SPARKLE
    [1700] = { stand = 12834, walk = 12833 },  -- II_IMPLING_ZOMBIE_READY
    [1701] = { stand = 11482, walk = 15073, run = 11481 },  -- HUMAN_READY_MACE
    [1702] = { stand = 12861, walk = 12862 },  -- LUMBCAT_TOMB_WRAITHS_READY
    [1703] = { stand = 12883, walk = 12862 },  -- LUMBCAT_TOMB_WRAITHS_UNARMED_READY
    [1704] = { walk = 12860, idles = { { 12858, 150 }, { 12859, 40 } } },
    [1705] = { stand = 12871, walk = 12872 },  -- LUMBCAT_DRAGITH_NURN_READY
    [1706] = { walk = 12850, idles = { { 22537, 150 }, { 12849, 200 } } },
    [1707] = { walk = 12879, idles = { { 12879, 80 }, { 22538, 50 }, { 22538, 40 } } },
    [1708] = { stand = 12881, walk = 12881 },  -- LUMBCAT_SARA_DEFEATED_READY
    [1709] = { walk = 12877, idles = { { 12877, 90 }, { 22540, 50 } } },
    [1710] = { stand = 12876 },  -- LUMBCAT_REESE_CHANTING
    [1711] = { stand = 12889, walk = 12892 },  -- LUMBCAT_TOMB_WRAITHS_TORSO_READY
    [1712] = { stand = 12906, walk = 1205, run = 1210, turnLeft = 1209, turnRight = 1209, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- LUMBCAT_STAFF_READY
    [1713] = { stand = 12910, walk = 12912, run = 12911, turnLeft = 823, turnRight = 823, walkBack = 2064, walkLeft = 12912, walkRight = 12912 },  -- HUMAN_READY_MEAT_TENDERISER
    [1714] = { stand = 12907, walk = 9738, walkBack = 9738, walkLeft = 9738, walkRight = 9738 },  -- HUMAN_SCYTHE_FARMING_ANIM
    [1715] = { walk = 11411 },
    [1716] = { walk = 6120 },
    [1717] = { stand = 10814, walk = 10812 },  -- UPDATE_TROLL_READY
    [1718] = { stand = 13348 },  -- RAND_FROSTSHATTER_SHATTER_IMPACT_READY
    [1719] = { stand = 12984, walk = 12985, turnLeft = 12985, turnRight = 12985, walkLeft = 12985, walkRight = 12985, walkTurnLeft = 12985, walkTurnRight = 12985 },  -- RAND_HOBGOBLIN_MAGE_READY
    [1720] = { walk = 14379, turnLeft = 14381, turnRight = 14381, walkBack = 14379, walkLeft = 14379, walkRight = 14379, walkTurnLeft = 14379, walkTurnRight = 14379, idles = { { 14381, 90 }, { 14382, 10 } } },
    [1721] = { stand = 13015 },  -- RAND_IHLAKHIZAN_READY
    [1722] = { stand = 13395, walk = 13395 },  -- RAND_GHOST_READY
    [1723] = { walk = 13059, idles = { { 13057, 75 }, { 13058, 25 } } },
    [1724] = { stand = 13064 },  -- RAND_BOSS_GUARD_SLEEPING
    [1725] = { stand = 13299 },  -- RAND_NESTED_SEEKER_READY
    [1726] = { walk = 13293, idles = { { 13291, 205 }, { 13292, 50 } } },
    [1727] = { stand = 13295 },  -- RAND_SEEKER_BABY_STUNNED
    [1728] = { stand = 13068 },  -- RAND_FOLLOW_THE_LEADER_READY
    [1729] = { stand = 13072 },  -- RAND_FURN_PTM_MONOLITH_STATE_D
    [1730] = { stand = 13358 },  -- RAND_STATUE_RANGER_READY_LOOP
    [1731] = { stand = 13381 },  -- RAND_STATUE_RANGER_MELEE_COMBAT_READY_LOOP
    [1732] = { stand = 13357 },  -- RAND_STATUE_RANGER_COMBAT_READY_LOOP
    [1733] = { stand = 13376 },  -- RAND_STATUE_RANGER_MAGIC_COMBAT_READY_LOOP
    [1734] = { stand = 13361 },  -- RAND_STATUE_MELEE_READY_LOOP
    [1735] = { stand = 13358 },  -- RAND_STATUE_RANGER_READY_LOOP
    [1736] = { stand = 13364 },  -- RAND_STATUE_MAGIC_READY_LOOP
    [1737] = { stand = 13360 },  -- RAND_STATUE_MELEE_COMBAT_READY_LOOP
    [1738] = { stand = 13357 },  -- RAND_STATUE_RANGER_COMBAT_READY_LOOP
    [1739] = { stand = 13363 },  -- RAND_STATUE_MAGIC_COMBAT_READY_LOOP
    [1740] = { stand = 13257, walk = 13258, turnLeft = 13258, turnRight = 13258, walkLeft = 13258, walkRight = 13258, walkTurnLeft = 13258, walkTurnRight = 13258 },  -- BOVIMASTYX_READY
    [1741] = { stand = 13256, walk = 13256 },  -- BOVIMASTYX_DEATH_POSE
    [1742] = { stand = 13167, walk = 13168, turnLeft = 13168, turnRight = 13168, walkLeft = 13168, walkRight = 13168, walkTurnLeft = 13168, walkTurnRight = 13168 },  -- RAND_SKELETAL_ARCHMAGE_READY
    [1743] = { walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822, idles = { { 13179, 80 }, { 13180, 20 } } },
    [1744] = { walk = 13182, walkTurnLeft = 13182, walkTurnRight = 13182, idles = { { 13181, 80 } } },
    [1745] = { idles = { { 13183, 70 }, { 13184, 20 }, { 13185, 10 } } },
    [1746] = { walk = 13189, walkTurnLeft = 13189, walkTurnRight = 13189, idles = { { 13187, 80 }, { 13188, 20 } } },
    [1747] = { stand = 13217, walk = 13218, run = 13220, walkBack = 13219, walkLeft = 13222, walkRight = 13223 },  -- RAND_HUMAN_READY_MAUL
    [1748] = { idles = { { 13412, 80 }, { 13413, 20 } } },
    [1749] = { stand = 13672, walk = 13673, run = 13673, turnLeft = 13673, turnRight = 13673, walkLeft = 13673, walkRight = 13673, walkTurnLeft = 13673, walkTurnRight = 13673 },  -- RAND_HEALER_FAMILIAR_READY
    [1750] = { stand = 13672, walk = 13673, run = 13673, turnLeft = 13673, turnRight = 13673, walkLeft = 13673, walkRight = 13673, walkTurnLeft = 13673, walkTurnRight = 13673 },  -- RAND_HEALER_FAMILIAR_READY
    [1751] = { stand = 13613, walk = 13666, run = 13667, turnLeft = 13666, turnRight = 13666, walkLeft = 13666, walkRight = 13666, walkTurnLeft = 13666, walkTurnRight = 13666 },  -- RAND_RANGER_FAMILIAR_READY
    [1752] = { stand = 13679, walk = 13680, run = 13681, turnLeft = 13680, turnRight = 13680, walkLeft = 13680, walkRight = 13680, walkTurnLeft = 13680, walkTurnRight = 13680 },  -- RAND_MALE_FAMILIAR_READY
    [1753] = { stand = 13679, walk = 13680, run = 13681, turnLeft = 13680, turnRight = 13680, walkLeft = 13680, walkRight = 13680, walkTurnLeft = 13680, walkTurnRight = 13680 },  -- RAND_MALE_FAMILIAR_READY
    [1754] = { stand = 13679, walk = 13680, run = 13289, turnLeft = 13680, turnRight = 13680, walkLeft = 13680, walkRight = 13680, walkTurnLeft = 13680, walkTurnRight = 13680 },  -- RAND_MALE_FAMILIAR_READY
    [1755] = { stand = 13156, walk = 13157, turnLeft = 13157, turnRight = 13157, walkBack = 13157, walkLeft = 13157, walkRight = 13157 },  -- RAND_DRAGON_READY
    [1756] = { stand = 13161, walk = 13162, turnLeft = 13162, turnRight = 13162, walkBack = 13162, walkLeft = 13162, walkRight = 13162 },  -- RAND_METAL_DRAGON_READY
    [1757] = { stand = 13358, walk = 13358 },  -- RAND_STATUE_RANGER_READY_LOOP
    [1758] = { stand = 13361, walk = 13361 },  -- RAND_STATUE_MELEE_READY_LOOP
    [1759] = { stand = 13364, walk = 13364 },  -- RAND_STATUE_MAGIC_READY_LOOP
    [1760] = { stand = 13357, walk = 13357 },  -- RAND_STATUE_RANGER_COMBAT_READY_LOOP
    [1761] = { stand = 13360, walk = 13360 },  -- RAND_STATUE_MELEE_COMBAT_READY_LOOP
    [1762] = { stand = 13363, walk = 13363 },  -- RAND_STATUE_MAGIC_COMBAT_READY_LOOP
    [1763] = { stand = 13395, walk = 13405, walkTurnLeft = 13405, walkTurnRight = 13405 },  -- RAND_GHOST_READY
    [1764] = { stand = 13410, walk = 13410 },  -- RAND_SKILLCAPE_NPC_02_READY
    [1765] = { stand = 13417, walk = 841 },  -- RAND_ICE_WARRIOR_READY
    [1766] = { walk = 13293, run = 13294, turnLeft = 13293, turnRight = 13293, walkLeft = 13293, walkRight = 13293, walkTurnLeft = 13293, walkTurnRight = 13293, idles = { { 13291, 95 }, { 13292, 5 } } },
    [1767] = { stand = 13302, walk = 13303, run = 13304, runBack = 13305, runLeft = 13307, runRight = 13308, walkBack = 13306, walkLeft = 13309, walkRight = 13310 },  -- RAND_FERRET_READY
    [1768] = { stand = 13333, walk = 13334, turnLeft = 13334, turnRight = 13334, walkBack = 13334, walkLeft = 13334, walkRight = 13334, walkTurnLeft = 13334, walkTurnRight = 13334 },  -- RAND_ICEFIEND_READY
    [1769] = { stand = 13418, walk = 13419, turnLeft = 13419, turnRight = 13419, walkLeft = 13419, walkRight = 13419, walkTurnLeft = 13419, walkTurnRight = 13419 },  -- RAND_SEEKER_READY
    [1770] = { stand = 13421, walk = 13421, turnLeft = 13421, turnRight = 13421 },  -- RAND_SEEKER_NESTED_READY
    [1771] = { walk = 12999, turnLeft = 12999, turnRight = 12999, walkLeft = 12999, walkRight = 12999, walkTurnLeft = 12999, walkTurnRight = 12999, idles = { { 12998, 95 }, { 13002, 5 } } },
    [1772] = { stand = 13445, walk = 13445 },  -- RAND_BEHEMOTH_STOMP_READY
    [1773] = { walk = 13467, turnLeft = 13467, turnRight = 13467, walkLeft = 13467, walkRight = 13467, walkTurnLeft = 13467, walkTurnRight = 13467, idles = { { 13465, 95 }, { 13466, 5 } } },
    [1774] = { stand = 13476, walk = 13477 },  -- RAND_LIBRARIMANCER_BOOK_READY
    [1775] = { stand = 13487, walk = 13488 },  -- RAND_GUARDIAN_SPHERE_READY
    [1776] = { stand = 13516, walk = 13516 },  -- RAND_FURN_BARRELS_BARREL_NULL
    [1777] = { stand = 13767, walk = 13768, turnLeft = 13768, turnRight = 13768, walkLeft = 13768, walkRight = 13768, walkTurnLeft = 13768, walkTurnRight = 13768 },  -- RAND_COLDSTARE_READY
    [1778] = { stand = 13767, walk = 13769, turnLeft = 13769, turnRight = 13769, walkLeft = 13769, walkRight = 13769, walkTurnLeft = 13769, walkTurnRight = 13769 },  -- RAND_COLDSTARE_READY
    [1779] = { stand = 13646, walk = 13647, walkBack = 13648, walkLeft = 13649, walkRight = 13650 },  -- RAND_GHOST_DUNGEON_READY
    [1780] = { stand = 13651 },  -- RAND_COOK_READY
    [1781] = { walk = 13699, run = 13704, turnLeft = 13699, turnRight = 13699, walkLeft = 13699, walkRight = 13699, walkTurnLeft = 13699, walkTurnRight = 13699, idles = { { 13696, 60 }, { 13697, 10 }, { 13698, 30 } } },
    [1782] = { walk = 13714, turnLeft = 13714, turnRight = 13714, walkLeft = 13714, walkRight = 13714, walkTurnLeft = 13714, walkTurnRight = 13714, idles = { { 13712, 80 }, { 13713, 20 } } },
    [1783] = { stand = 13731, walk = 13739, run = 25128, runLeft = 25128, runRight = 25128, turnLeft = 13739, turnRight = 13739, walkLeft = 13739, walkRight = 13739, walkTurnLeft = 13739, walkTurnRight = 13739 },  -- RAND_EDIMMU_READY
    [1784] = { stand = 13763, walk = 13761, turnLeft = 13761, turnRight = 13761, walkLeft = 13761, walkRight = 13761, walkTurnLeft = 13761, walkTurnRight = 13761 },  -- RAND_DEMON_READY
    [1785] = { stand = 13794, walk = 13793 },  -- UPDATE_TROLL_READY_SWORD
    [1786] = { stand = 13795, walk = 13796 },  -- UPDATE_TROLL_READY_SWORDPLUSSHIELD
    [1787] = { stand = 13794, walk = 13793 },  -- UPDATE_TROLL_READY_SWORD
    [1788] = { stand = 13800, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- CHIEF_THIEF_ROBIN_READY
    [1789] = { stand = 13801, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- DARREN_VER1_READY
    [1790] = { stand = 13802, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- DARREN_VER2_READY
    [1791] = { stand = 13803, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- DARREN_VER3_READY
    [1792] = { stand = 13804, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- DARREN_VER4_READY
    [1793] = { stand = 13806, walk = 13807, turnLeft = 13807, turnRight = 13807, walkBack = 13807, walkLeft = 13807, walkRight = 13807 },  -- ELEGANT_REGISTRAR_READY
    [1794] = { stand = 808, walk = 13809, turnLeft = 13809, turnRight = 13809, walkBack = 13809, walkLeft = 13809, walkRight = 13809 },  -- HUMAN_READY
    [1795] = { stand = 13808, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- LOCKPICKER_READY
    [1796] = { stand = 13810, walk = 13811, turnLeft = 13811, turnRight = 13811, walkBack = 13811, walkLeft = 13811, walkRight = 13811 },  -- PICKPOCKET_READY
    [1797] = { stand = 13812, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- SAFECRACKER_READY
    [1798] = { stand = 13818, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY_VAR
    [1799] = { stand = 13820, walk = 13821, run = 13822, turnLeft = 13821, turnRight = 13821, walkBack = 13829, walkLeft = 13830, walkRight = 13831 },  -- HUMAN_RUNEFEST_BANNER_READY
    [1800] = { stand = 13826, walk = 13826 },  -- RUNEFEST_BANNER_IN_GROUND
    [1801] = { stand = 793, walk = 13847 },  -- FAIRYKIT_FAIRY_READY
    [1802] = { stand = 11012, walk = 13847 },  -- FAIRYKIT_FAIRY_READY_OFFSET
    [1803] = { stand = 13850, walk = 13852 },  -- FAIRYKIT_FAIRY_INJURED_READY
    [1804] = { stand = 13855, walk = 13856 },  -- FAIRYKIT_FAIRY_QUEEN_READY
    [1805] = { stand = 13853, walk = 13854 },  -- FAIRYKIT_FAIRY_HENCHMAN1_READY
    [1806] = { stand = 13857, walk = 13859 },  -- FAIRYKIT_FAIRY_HENCHMAN2_READY
    [1807] = { stand = 14017, walk = 13864 },  -- FAIRYKIT_FAIRY_GODFATHER_READY
    [1808] = { stand = 13900, walk = 13901 },  -- FT3_TOOTH_PET_READY
    [1809] = { stand = 13900, walk = 13902 },  -- FT3_TOOTH_PET_READY
    [1810] = { stand = 13932, walk = 13933 },  -- FT3_SHREDFLESH_GENERAL_READY
    [1811] = { stand = 13913, walk = 13914 },  -- FT3_GROMBLOOD_GENERAL_READY
    [1812] = { stand = 13924, walk = 13925 },  -- FT3_BREEGTH_GENERAL_READY
    [1813] = { stand = 13932, walk = 13952 },  -- FT3_SHREDFLESH_GENERAL_READY
    [1814] = { stand = 13913, walk = 13951 },  -- FT3_GROMBLOOD_GENERAL_READY
    [1815] = { stand = 13924, walk = 13950 },  -- FT3_BREEGTH_GENERAL_READY
    [1816] = { stand = 13917, walk = 13914 },  -- FT3_GROMBLOOD_GENERAL_BANGING_DRUMS
    [1817] = { stand = 13968, walk = 13864 },  -- FT3_GODFATHER_SPEECH
    [1818] = { stand = 13970, walk = 13971 },  -- FT3_GODFATHER_READY_WAND
    [1819] = { stand = 14060, walk = 14060 },  -- FAIRYKIT_FAIRY_GODFATHER_DEFEATED_READY
    [1820] = { stand = 13908, walk = 13909 },  -- FT3_EXILED_ORK_READY
    [1821] = { stand = 13906, walk = 13907 },  -- FAIRIES_WITH_EXTRACTORS_READY
    [1822] = { stand = 14089, walk = 14090 },  -- FAIRY2_CENTAUR_READY_NO_BOW
    [1823] = { stand = 13866, walk = 13869 },  -- FAIRYKIT_TANGLEFOOT_LARGE_READY
    [1824] = { stand = 13867, walk = 13870 },  -- FAIRYKIT_TANGLEFOOT_MID_READY
    [1825] = { stand = 13868, walk = 13871 },  -- FAIRYKIT_TANGLEFOOT_SMALL_READY
    [1826] = { stand = 13896, walk = 13895 },  -- FAIRYKIT_MINDSLAYER_READY
    [1827] = { stand = 14027, walk = 14028 },  -- FAIRYKIT_ORC_UPDATE03_READY
    [1828] = { stand = 14029, walk = 14030 },  -- FAIRYKIT_ORC_UPDATE04_READY
    [1829] = { stand = 13881, walk = 13882 },  -- FAIRYKIT_ORC_ANCIENT_ORC01_READY
    [1830] = { stand = 13883, walk = 13884 },  -- FAIRYKIT_ORC_ANCIENT_ORC02_READY
    [1831] = { stand = 13885, walk = 13886 },  -- FAIRYKIT_ORC_ANCIENT_ORC03_READY
    [1832] = { stand = 13887, walk = 13888 },  -- FAIRYKIT_ORC_ANCIENT_ORC04_READY
    [1833] = { stand = 14092, walk = 14093 },  -- OTHER_WORLDLY_BEING_READY
    [1834] = { stand = 4872, turnLeft = 4872, turnRight = 4872 },  -- CASTLEWARS_BALLISTA_READY
    [1835] = { walk = 14183, turnLeft = 14181, turnRight = 14181, walkTurnLeft = 14183, walkTurnRight = 14183, idles = { { 14181, 80 }, { 14182, 20 } } },
    [1836] = { stand = 808, walk = 819, crawl = 14186, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [1837] = { stand = 808, walk = 819, crawl = 819, run = 14207, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [1838] = { stand = 12021, walk = 14196, turnLeft = 12021, turnRight = 12021, walkLeft = 14196, walkRight = 14196 },  -- _7W_HUMAN_DS_READY
    [1839] = { stand = 14197, walk = 14197, turnLeft = 14197, turnRight = 14197 },  -- VKQ1_GHOST_SHIP_READY
    [1840] = { stand = 14240, walk = 14240, turnLeft = 14240, turnRight = 14240, walkBack = 14240, walkLeft = 14240, walkRight = 14240 },  -- LOVE_MABEL_CRYING
    [1841] = { stand = 14232, walk = 14232, turnLeft = 14232, turnRight = 14232, walkBack = 14232, walkLeft = 14232, walkRight = 14232 },  -- LOVE_WISE_OLD_WOMAN_DEFEATED
    [1842] = { stand = 808, walk = 821, walkBack = 821, walkLeft = 821, walkRight = 821 },  -- HUMAN_READY
    [1843] = { stand = 3710, walk = 3708 },  -- OUB_MONSTER1_BLOCK
    [1844] = { stand = 1641, walk = 14230 },  -- HW06_PUPPET_READY
    [1845] = { stand = 14253 },  -- DRAGON_UPDATE_09_VM_DRAGON_ANIMATRONIC_LOOP
    [1846] = { stand = 14255 },  -- DRAGON_UPDATE_09_TEACHER_DRAGON_UPDATE
    [1847] = { stand = 14267, walk = 14268 },  -- DRAGON_UPDATE_09_ADOLESCENT_DRAGON_READY
    [1848] = { stand = 14272, walk = 14273 },  -- DRAGON_UPDATE_09_BABY_DRAGON_READY
    [1849] = { stand = 14274, walk = 14275 },  -- DRAGON_UPDATE_09_HATCHLING_DRAGON_READY
    [1850] = { stand = 14256, walk = 14257, turnLeft = 14257, turnRight = 14257, walkBack = 14257, walkLeft = 14257, walkRight = 14257 },  -- DRAGON_UPDATE_09_ELVARG_READY
    [1851] = { stand = 14251, walk = 14250, turnLeft = 14250, turnRight = 14250, walkBack = 14250, walkLeft = 14250, walkRight = 14250 },  -- DRAGON_UPDATE_09_METAL_DRAGON_READY
    [1852] = { stand = 12248, walk = 12246, turnLeft = 12246, turnRight = 12246, walkBack = 12246, walkLeft = 12246, walkRight = 12246 },  -- DRAGON_UPDATE_09_READY
    [1853] = { stand = 14262, walk = 14263 },  -- DRAGON_UPDATE_09_GHOST_DRAGON_READY
    [1854] = { stand = 14276, walk = 3426 },  -- HARMLESS_CRAB_READY
    [1855] = { stand = 13295, walk = 13295, run = 13295, turnLeft = 13295, turnRight = 13295, walkLeft = 13295, walkRight = 13295, walkTurnLeft = 13295, walkTurnRight = 13295 },  -- RAND_SEEKER_BABY_STUNNED
    [1856] = { walk = 14312, run = 14313, idles = { { 14311, 90 }, { 14315, 30 } } },
    [1857] = { stand = 14350, walk = 14351, crawl = 14351 },  -- VKQ2_LADEN_WORKER_READY
    [1858] = { stand = 14518, walk = 14518, run = 14518, runBack = 14518, runLeft = 14518, runRight = 14518, walkBack = 14518, walkLeft = 14518, walkRight = 14518 },  -- RAND_FERRET_PRESSURE_PEN_TRAPPED_READY
    [1859] = { walk = 14397, turnLeft = 14381, turnRight = 14381, walkBack = 14397, walkLeft = 14397, walkRight = 14397, walkTurnLeft = 14397, walkTurnRight = 14397, idles = { { 14381, 90 }, { 14382, 10 } } },
    [1860] = { walk = 14372, turnLeft = 14381, turnRight = 14381, walkBack = 14372, walkLeft = 14372, walkRight = 14372, walkTurnLeft = 14372, walkTurnRight = 14372, idles = { { 14381, 90 }, { 14382, 10 } } },
    [1861] = { walk = 14377, turnLeft = 14381, turnRight = 14381, walkBack = 14377, walkLeft = 14377, walkRight = 14377, walkTurnLeft = 14377, walkTurnRight = 14377, idles = { { 14381, 90 }, { 14382, 10 } } },
    [1862] = { stand = 14420, walk = 14421, turnLeft = 14421, turnRight = 14421 },  -- RAND_BEHEMOTH_RUNE_READY
    [1863] = { stand = 14419, walk = 14419 },  -- RAND_RUNE_BEHEMOTH_MAGE_CHANT
    [1864] = { stand = 14454, walk = 14453 },  -- RAND_BEHEMOTH_DEVOURER_READY
    [1865] = { stand = 14499, walk = 14502 },  -- RAND_ARMOURED_ZOMBIE_READY
    [1866] = { stand = 14464, walk = 14465, walkTurnLeft = 14483, walkTurnRight = 14484 },  -- RAND_EYESPLOSION_READY
    [1867] = { stand = 14470 },  -- RAND_EYESPINE_READY
    [1868] = { stand = 14479, walk = 14480, walkTurnLeft = 14482, walkTurnRight = 14481 },  -- RAND_EYESQUID_READY
    [1869] = { stand = 14406, walk = 14407 },  -- RAND_PONDSKATER_READY
    [1870] = { stand = 14571, walk = 14571 },  -- VKQC_COMMANDER_READY
    [1871] = { stand = 14587, walk = 14587 },  -- VKQ3_OFFICER_READY
    [1872] = { stand = 14574, walk = 14575 },  -- VKQC_CHAMPION_READY
    [1873] = { stand = 14581, walk = 14577 },  -- VKQC_HALBERDIER_READY
    [1874] = { stand = 14585, walk = 14586 },  -- VKQC_MAGE_READY
    [1875] = { stand = 14592, walk = 14593 },  -- VKQ3_SCOUT_READY
    [1876] = { stand = 14597, walk = 14598 },  -- VKQ3_SWORDSMAN_READY
    [1877] = { stand = 14599, walk = 14603 },  -- VKQC_KNIGHT_READY
    [1878] = { stand = 14604, walk = 14605 },  -- VKQC_ARCHER_READY
    [1879] = {  },
    [1880] = { idles = { { 14728, 80 }, { 17517, 20 } } },
    [1881] = { idles = { { 14729, 70 }, { 14731, 20 }, { 17518, 10 } } },
    [1882] = { stand = 14727 },  -- ROMCOM_BARBARIAN_PLAY_GUITAR
    [1883] = { stand = 13818, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY_VAR
    [1884] = { stand = 14730, walk = 14732, walkBack = 14732, walkLeft = 14732, walkRight = 14732 },  -- GODWARS_SPIRITUAL_WARRIOR_READY
    [1885] = { stand = 5623, walk = 14742, turnLeft = 14742, turnRight = 14742, walkLeft = 14742, walkRight = 14742, walkTurnLeft = 14742, walkTurnRight = 14742 },  -- LOTR_TERROR_DOG_LOOK_READY
    [1886] = { stand = 23277, walk = 23263, run = 23287, walkBack = 23263, walkTurnLeft = 23263, walkTurnRight = 23263 },  -- _6AWE3_MONKEY_IDLE
    [1887] = { stand = 14778, walk = 14777, turnLeft = 14777, turnRight = 14777, walkBack = 14777, walkLeft = 14777, walkRight = 14777, walkTurnLeft = 14777, walkTurnRight = 14777 },  -- VKQ3_QUEEN_READY
    [1888] = { stand = 14810 },  -- VKQ3_TEMPLE_GUARDIAN_READY
    [1889] = { stand = 14752, walk = 14753, turnLeft = 14752, turnRight = 14752 },  -- VKQ3_VOID_DRONE_READY
    [1890] = { stand = 14775 },  -- VKQ3_KORASI_OR_JESSIKA_INJURED_READY
    [1891] = {  },
    [1892] = { stand = 12010, walk = 12012, walkBack = 12013, walkLeft = 12014, walkRight = 12015 },  -- _7W_HUMAN_STAFFREADY
    [1893] = { stand = 14831, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- VKQ3_JESSIKA_UPSET_READY
    [1894] = { stand = 14830, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- VKQ3_SIR_TIFFY_UPSET_READY
    [1895] = { stand = 14818, walk = 14819, run = 14823, turnLeft = 14819, turnRight = 14819, walkBack = 14820, walkLeft = 14821, walkRight = 14822 },  -- VKQ3_KORASI_DS_READY
    [1896] = { stand = 14763 },  -- VKQ3_KORASI_WITH_DRONE_STANDOFF
    [1897] = { stand = 14844, walk = 14844 },  -- HUNTER_CHARMS_YAKTWEE_READY
    [1898] = { stand = 14846, walk = 14847 },  -- HUNTER_CHARMS_SPRITE_READY
    [1899] = { stand = 14863, walk = 14864, run = 14865, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- F4HB3_PLAYER_SLING_READY
    [1900] = { walk = 14862, run = 3369, turnLeft = 16083, turnRight = 16082, walkLeft = 16083, walkRight = 16082, walkTurnLeft = 14862, walkTurnRight = 14862, idles = { { 14857, 80 }, { 14858, 20 } } },
    [1901] = { stand = 247, walk = 246, turnLeft = 246, turnRight = 246, walkBack = 246, walkLeft = 246 },  -- PIG_09_UPDATE_READY
    [1902] = { stand = 279, walk = 248, turnLeft = 248, turnRight = 248, walkBack = 248, walkLeft = 248 },  -- PIGLET_09_UPDATE_READY
    [1903] = { stand = 14872, walk = 14872 },  -- HW10_REAPER_READY
    [1904] = { stand = 14882 },  -- HW10_DJ_WEB_READY
    [1905] = { stand = 14875 },  -- HW10_WEREWOLF_DANCE_READY
    [1906] = { stand = 14881, walk = 14880 },  -- HW10_BLACK_ZABETH_READY
    [1907] = { walk = 14880, idles = { { 14879, 95 }, { 14881, 10 } } },
    [1908] = { walk = 14880, idles = { { 14879, 95 }, { 14881, 10 } } },
    [1909] = { stand = 2108 },  -- EMOTE_DANCE_HEADBANG
    [1910] = { stand = 866 },  -- EMOTE_DANCE
    [1911] = { idles = { { 866, 100 }, { 2107, 20 } } },
    [1912] = { idles = { { 2108, 100 }, { 2414, 30 } } },
    [1913] = { walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822, idles = { { 14885, 100 }, { 808, 50 } } },
    [1914] = { stand = 14948, walk = 14950, run = 14947, turnLeft = 823, turnRight = 823, walkBack = 820 },  -- RAND_BLINK_READY
    [1915] = { stand = 14967, walk = 14966 },  -- RAND_BOSS_DEMON_GHAN_KO_READY
    [1916] = { walk = 15017, run = 15018, runBack = 15022, runLeft = 15023, runRight = 15024, walkBack = 15019, walkLeft = 15020, walkRight = 15021, idles = { { 15016, 100 } } },
    [1917] = { walk = 14981, idles = { { 14977, 95 }, { 14978, 5 }, { 14979, 5 } } },
    [1918] = { stand = 14887, walk = 14888 },  -- RAND_SEEKER_TORN_READY
    [1919] = { stand = 14914 },  -- RAND_SEEKER_TORN_WALL_EYES_READY
    [1920] = { stand = 14918, walk = 14918 },  -- RAND_SEEKER_TORN_WALL_EYES_READY_LOOP
    [1921] = { stand = 15015, walk = 15002 },  -- RAND_GULEGA_WARPED_READY
    [1922] = { idles = { { 3289, 175 }, { 3290, 10 } } },
    [1923] = { walk = 3286, idles = { { 3287, 90 }, { 3288, 10 } } },
    [1924] = { crawl = 15039, turnLeft = 15039, turnRight = 15039, crawlTurnLeft = 15039, crawlTurnRight = 15039, walkTurnLeft = 15039, walkTurnRight = 15039, idles = { { 15038, 80 }, { 15040, 20 }, { 15040, 20 } } },
    [1925] = { walk = 15062, turnLeft = 15062, turnRight = 15062, walkTurnLeft = 15062, walkTurnRight = 15062, idles = { { 15038, 80 }, { 15040, 20 }, { 15040, 20 } } },
    [1926] = { walk = 15039, turnLeft = 15039, turnRight = 15039, walkTurnLeft = 15039, walkTurnRight = 15039, idles = { { 15038, 80 }, { 15040, 20 }, { 15040, 20 } } },
    [1927] = { stand = 15068, walk = 15067, walkBack = 15067, walkLeft = 15067, walkRight = 15067 },  -- APMEKEN_MONKEY_GHOST_READY
    [1928] = { stand = 15069, walk = 15073, run = 15070, turnLeft = 12024, turnRight = 12024, walkBack = 15075, walkLeft = 15076, walkRight = 15077 },  -- _7W_HUMAN_READY_2010_DRAGON_SCIMITAR
    [1929] = { stand = 15082, walk = 15081 },  -- CYCLOPS_READY
    [1930] = { stand = 4158 },  -- MYREQUE_VANSTROM_SITTING_READY
    [1931] = { idles = { { 4159, 80 }, { 4160, 10 }, { 4162, 10 } } },
    [1932] = { stand = 11030 },  -- XMAS08_HUMAN_SLIPPERY_RUN
    [1933] = { stand = 15109, walk = 15110, run = 15110 },  -- XMAS10_SEAL_READY
    [1934] = { stand = 15115 },  -- XMAS10_SANTA_SAD_READY
    [1935] = { walk = 21367, idles = { { 21367, 10 }, { 15119, 10 }, { 15119, 10 } } },
    [1936] = { stand = 15120, walk = 9869, walkBack = 9869, walkLeft = 9869, walkRight = 9869 },  -- ATLUM_EXPLORER_JACK_READY
    [1937] = { stand = 15208 },  -- RA4_MEIKE_READING_READY
    [1938] = { walk = 21319, idles = { { 21319, 90 }, { 21320, 10 } } },
    [1939] = { stand = 21334, walk = 21334 },  -- RA4_DWARF_2013_PLACARD_READY
    [1940] = { idles = { { 13795, 80 }, { 15165, 10 }, { 15166, 10 } } },
    [1941] = { stand = 15157, walk = 15157 },  -- RA4_DWARF_TRAPPED_UNDER_ROCK
    [1942] = { stand = 15167, walk = 15167 },  -- RA4_DWARF_INJURED_READY
    [1943] = { stand = 15212, walk = 15212 },  -- RA4_DWARF_INJURED_2_READY
    [1944] = { stand = 15213, walk = 15213 },  -- RA4_DWARF_INJURED_3_READY
    [1945] = { stand = 15214, walk = 15214 },  -- RA4_DWARF_INJURED_4_READY
    [1946] = { stand = 15216, walk = 15216 },  -- RA4_DWARF_INJURED_5_READY
    [1947] = { stand = 15215, walk = 15215 },  -- RA4_DWARF_INJURED_6_READY
    [1948] = { stand = 15211, walk = 98 },  -- RA4_DWARF_MINING_CRUST
    [1949] = { stand = 15205, walk = 15204, run = 15204 },  -- RA4_DWARF_PANICK_READY
    [1950] = { stand = 15230, walk = 15229, turnLeft = 9026, turnRight = 9026, walkTurnLeft = 15229, walkTurnRight = 15229 },  -- UPDATE_TROLL_MYARM_READY
    [1951] = { stand = 10814, walk = 15231 },  -- UPDATE_TROLL_READY
    [1952] = { stand = 15232, walk = 15233, walkBack = 15233, walkLeft = 15233, walkRight = 15233 },  -- FARMING_ELLENA_READY
    [1953] = { stand = 7008, walk = 7001, run = 28432 },  -- VAULTRAIDER_GUARDIAN_READY
    [1954] = { stand = 15240, walk = 6583 },  -- DOG_UPDATE_ALSATIAN_READY
    [1955] = { stand = 813, walk = 15073, run = 1210, turnLeft = 1209, turnRight = 1209, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [1956] = { stand = 15254, walk = 15256 },  -- FENRISWOLF_READY
    [1957] = { stand = 4326, walk = 1831, turnLeft = 1831, turnRight = 1831, walkBack = 1831, walkLeft = 1831, walkRight = 1831 },  -- TIGHTROPE_BALANCE_READY_UPDATE
    [1958] = { stand = 1493, walk = 1494 },  -- FAI_VARROCK_BROOMING_STILL_FEMALE
    [1959] = { stand = 5248, walk = 5442 },  -- ELEMENTAL_UPDATE_CHAOS_READY
    [1960] = { stand = 5471 },  -- GLO3_BOLRIE_SITTING_IN_PRISON_READY
    [1961] = { stand = 1214, walk = 8723, run = 1215 },  -- GNOME_SPADE_READY
    [1962] = { stand = 3959, walk = 3964, crawl = 3964, turnLeft = 3964, turnRight = 3964, walkLeft = 3964, walkRight = 3964 },  -- GNOME_ADULT_CLEANER_READY
    [1963] = { stand = 6793, walk = 6796, walkBack = 6796, walkLeft = 6796, walkRight = 6796, walkTurnLeft = 6796, walkTurnRight = 6796 },  -- MOUNTED_TERRORBIRD_READY
    [1964] = { stand = 202, walk = 781, walkBack = 781, walkLeft = 781, walkRight = 781, walkTurnLeft = 781, walkTurnRight = 781 },  -- MOUNTED_TERRORBIRD_READY_SPEAR
    [1965] = { stand = 25444, walk = 25443, turnLeft = 25443, turnRight = 25443, walkLeft = 25443, walkRight = 25443, walkTurnLeft = 25443, walkTurnRight = 25443 },  -- ATELF_MOD_ELFBOURNE_IDLE
    [1966] = { stand = 4536 },  -- ALUFT_GNOME_TALKING_ON_PHONE
    [1967] = { stand = 4538 },  -- ALUFT_GNOME_SITTING_FACING_SOUTH
    [1968] = { stand = 4537 },  -- ALUFT_GNOME_SITTING_FACING_WEST
    [1969] = { walk = 1226, idles = { { 37961, 50 }, { 3216, 50 } } },
    [1970] = { stand = 1009, walk = 1007 },  -- POG_TERROR_BIRD_READY_EXTRA
    [1971] = { walk = 15274, idles = { { 7122, 80 }, { 1391, 20 } } },
    [1972] = { walk = 37952, idles = { { 37961, 225 }, { 16369, 30 } } },
    [1973] = { stand = 15309, walk = 4458 },  -- ELEM4_AUTOMATON_HOLDING_BOX_READY
    [1974] = { stand = 11456, walk = 11456 },  -- ELEM4_AUTOMOTON_TRANSFORM_LOOP
    [1975] = { stand = 15321, walk = 15320 },  -- ELEM4_AUTOMOTON_HOLDING_TILE_READY
    [1976] = { stand = 32, walk = 32, turnLeft = 32, turnRight = 32, walkLeft = 32, walkRight = 32, walkTurnLeft = 32, walkTurnRight = 32 },  -- VANSTROM_KLAUSE_WINGS_READY
    [1977] = { stand = 78 },  -- QUEST_ELITEDUNGEONS_DEAD_DRAGON_BAS
    [1978] = { stand = 436, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- SWAMP_CANDELSELLER_READY
    [1979] = { stand = 850, walk = 849, run = 12827 },  -- V02_LORE_YAK_UPDATE_READY
    [1980] = { stand = 4331, walk = 4419 },  -- UPDATE_TROLL_READY_SHIELD
    [1981] = { stand = 5837, walk = 5838 },  -- UPDATE_TROLL_CHAMPION_READY
    [1982] = { stand = 5821, walk = 10812 },  -- UPDATE_TROLL_MYARM_SLEEP
    [1983] = { stand = 5826, walk = 5838 },  -- UPDATE_TROLL_WATER_GENERAL_READY
    [1984] = { walk = 10812 },
    [1985] = { stand = 1476, walk = 10812 },  -- TROLLROMANCE_CRY_LOOP
    [1986] = { stand = 5440, walk = 5440 },  -- UPDATE_PINBALL_TROLL_LEFT_READY
    [1987] = { stand = 5769, walk = 5769 },  -- UPDATE_PINBALL_TROLL_RIGHT_READY
    [1988] = { stand = 13794, walk = 5379 },  -- UPDATE_TROLL_READY_SWORD
    [1989] = { stand = 9026, walk = 15229, turnLeft = 9026, turnRight = 9026, walkTurnLeft = 15229, walkTurnRight = 15229 },  -- MYARM_READY_FOR_ITEMS
    [1990] = { stand = 9045, walk = 283 },  -- TROLL_UPDATE_CRY
    [1991] = { stand = 9627 },  -- ACS_DROWNED_BREWER
    [1992] = { stand = 9635, walk = 9635, run = 9635 },  -- ACS_BIRD_FLYING_WITH_CANNONBALL
    [1993] = { stand = 9725, walk = 9725, run = 9725 },  -- ACS_ZOMBIE_LAUGHING
    [1994] = { stand = 9726, walk = 9726, run = 9726 },  -- ACS_ZOMBIE_LAUGHING_HYSTERICALLY
    [1995] = { stand = 10862, walk = 10862, crawl = 10862, run = 10862 },  -- ACS_ZOMBIE_WALKING_ON_CONVEYORBELT
    [1996] = { stand = 9755, walk = 9755 },  -- ACS_PLAYER_SHIP_MOVE
    [1997] = { stand = 10084, walk = 10084 },  -- ACS_ZOMBIE_SHIP_MOVE
    [1998] = { stand = 3054 },  -- TUT4_SCARED_READY
    [1999] = { stand = 227, walk = 228, run = 3589, turnLeft = 227, turnRight = 227, walkLeft = 228, walkRight = 228 },  -- EVQ_VARGAS_INJURED_READY
    [2000] = { stand = 3609, walk = 3609 },  -- CLAN_NPC_GAMEMASTER_READY
    [2001] = { stand = 3608, walk = 3608 },  -- CLAN_NPC_HEAD_GUARD_READY
    [2002] = { stand = 3480, walk = 3480, turnLeft = 3480, turnRight = 3480, walkTurnLeft = 3480, walkTurnRight = 3480 },  -- LUNARFARM_PAULINE_READY
    [2003] = { stand = 3482, walk = 3482, turnLeft = 3482, turnRight = 3482, walkTurnLeft = 3482, walkTurnRight = 3482 },  -- LUNARFARM_PAULINE_TIRED_READY
    [2004] = { stand = 9653 },  -- GAME_CASTLEWARS_UPDATE_PORTAL
    [2005] = { stand = 8264, walk = 8232, run = 8227, walkBack = 8239, walkLeft = 8242, walkRight = 8263 },  -- CLAN_PLAYER_BANNER_READY
    [2006] = { stand = 8169 },  -- CLAN_FLAGSTAFF_READY
    [2007] = { stand = 10903, walk = 10903 },  -- CLAN_NPC_SCRIBE_READY
    [2008] = { stand = 15335, walk = 15335 },  -- EASTER11_SPIRIT_TALK_READY
    [2009] = { stand = 15345 },  -- EASTER11_ANTIPODEAN_SQUIRREL_READY
    [2010] = { stand = 15361, walk = 6531 },  -- EASTER11_QUEEN_OF_SNOW_READY
    [2011] = { stand = 15362 },  -- EASTER11_QUEEN_OF_SUNRISE_READY
    [2012] = { stand = 15355 },  -- EASTER11_JACK_FROST_FACE_OFF
    [2013] = { stand = 15346 },  -- EASTER11_BUNNY_INSULT
    [2014] = { stand = 15337 },  -- EASTER11_QUEEN_OF_SNOW_DEPRESSED_READY
    [2015] = { stand = 15368 },  -- EASTER11_RIVER_SPIRIT_TALK_READY
    [2016] = { stand = 1434 },  -- COD_MAX_SKILLCAPE_ROCK_CREATURE_INVISIBLE
    [2017] = {  },
    [2018] = {  },
    [2019] = { stand = 4644 },  -- CLAN_PLAYER_GENERIC_SIT_READY
    [2020] = { stand = 56, walk = 57, turnLeft = 56, turnRight = 56, walkBack = 57, walkLeft = 57, walkRight = 57, walkTurnLeft = 57, walkTurnRight = 57 },  -- LFM_DWARF_CHASING_PICKAXE_READY
    [2021] = { stand = 55, turnLeft = 55, turnRight = 55 },  -- LFM_NYMPH_READY
    [2022] = { stand = 22, turnLeft = 22, turnRight = 22 },  -- LFM_LAVA_MONSTER_READY
    [2023] = { stand = 62, turnLeft = 62, turnRight = 62 },  -- LFM_TZHAAR_HERO_READY
    [2024] = { stand = 311, walk = 312 },  -- LION_UPDATE_READY
    [2025] = { stand = 316, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- PVPW_NASTROTH_READY
    [2026] = { idles = { { 661, 95 }, { 691, 5 } } },
    [2027] = { idles = { { 661, 120 }, { 691, 5 } } },
    [2028] = { idles = { { 692, 95 }, { 727, 5 } } },
    [2029] = { idles = { { 692, 120 }, { 727, 5 } } },
    [2030] = { stand = 1329 },  -- FREMSAGA_PICCUPSTIX_SAT
    [2031] = { stand = 806, walk = 812 },  -- FREMSAGA_SKALDRUN_READY
    [2032] = { stand = 1032, walk = 1033, run = 1079, turnLeft = 1032, turnRight = 1032, walkBack = 1058, walkLeft = 1033, walkRight = 1033 },  -- FREMSAGA_EWAIN_READY
    [2033] = { stand = 1032, walk = 1064, run = 1079, turnLeft = 1032, turnRight = 1032, walkBack = 1078, walkLeft = 1064, walkRight = 1064 },  -- FREMSAGA_EWAIN_READY
    [2034] = { stand = 1080, walk = 1081, run = 1083, turnLeft = 1080, turnRight = 1080, walkBack = 1082, walkLeft = 1081, walkRight = 1081 },  -- FREMSAGA_OZAN_READY
    [2035] = { stand = 1142, walk = 1162, run = 1191, turnLeft = 1142, turnRight = 1142, walkBack = 1177, walkLeft = 1162, walkRight = 1162 },  -- FREMSAGA_ARIANE_READY
    [2036] = { stand = 1025 },  -- FREMSAGA_MARMAROS_UNCONCIOUS
    [2037] = { stand = 2995 },  -- DEVIOUS_DEAD
    [2038] = { stand = 12745 },  -- NOM_DEAD_KNIGHT_READY
    [2039] = { stand = 1225 },  -- FREMSAGA_CHILD_CORPSE
    [2040] = { stand = 12881, walk = 1033 },  -- LUMBCAT_SARA_DEFEATED_READY
    [2041] = { stand = 1540, walk = 1527, run = 1527, runBack = 1527, runLeft = 1515, runRight = 1526, turnLeft = 1540, turnRight = 1540, runTurnLeft = 1515, runTurnRight = 1526 },  -- DEADLY_BOAT_READY
    [2042] = { stand = 1654, walk = 1564, run = 1564, runBack = 1564, runLeft = 1634, runRight = 1566, turnLeft = 1654, turnRight = 1654, runTurnLeft = 1634, runTurnRight = 1566 },  -- DEADLY_BOAT_READY_WITHOUT_JONES
    [2043] = { stand = 1735, turnLeft = 1735, turnRight = 1735 },  -- DEADLY_GUNS_HUMAN_READY_EXTRA
    [2044] = { stand = 1551, turnLeft = 1551, turnRight = 1551 },  -- DEADLY_JONES_HUMAN_READY
    [2045] = { stand = 1376, walk = 1376, turnLeft = 1376, turnRight = 1376 },  -- DEADLY_LINZA_SMITHING
    [2046] = { stand = 1772, turnLeft = 1772, turnRight = 1772 },  -- DEADLY_LINZA_READY
    [2047] = { stand = 1369, walk = 1369, turnLeft = 1369, turnRight = 1369 },  -- DEADLY_MERMAID_TENTACLE_READY
    [2048] = { stand = 1370, walk = 1370, turnLeft = 1370, turnRight = 1370 },  -- DEADLY_MERMAID_ANEMONE_READY
    [2049] = { stand = 1371, walk = 1371, turnLeft = 1371, turnRight = 1371 },  -- DEADLY_MERMAID_URCHIN_READY
    [2050] = { stand = 1825, walk = 1824 },  -- CROW_FLY_UPDATE_VARIATION
    [2051] = { stand = 1826, walk = 1826 },  -- CROW_READY_UPDATE
    [2052] = { stand = 1880, walk = 1910, run = 1925, walkBack = 1911, walkLeft = 1917, walkRight = 1920 },  -- GAMECARD_PLAYER_KATANA_READY
    [2053] = { stand = 2155, walk = 1972 },  -- TROLL_SICK_READY
    [2054] = { stand = 2018, walk = 2018, run = 1991, walkLeft = 2018, walkRight = 2018 },  -- TROLL_DYNAMITE_WALK
    [2055] = { stand = 1928, walk = 1929, walkLeft = 1929, walkRight = 1929 },  -- TROLL_BOSS_READY
    [2056] = { stand = 10814, walk = 4415, run = 2038, walkLeft = 2035, walkRight = 2035 },  -- UPDATE_TROLL_READY
    [2057] = { stand = 10814, walk = 4415, run = 2038, walkLeft = 2035, walkRight = 2035 },  -- UPDATE_TROLL_READY
    [2058] = { stand = 10814, walk = 4415, run = 4990, walkLeft = 4415, walkRight = 4415 },  -- UPDATE_TROLL_READY
    [2059] = { stand = 2627 },  -- SLUG3_SLUG_QUEEN_AND_LUCY_READY
    [2060] = { stand = 2626 },  -- SLUG3_SLUG_QUEEN_READY
    [2061] = { stand = 2630 },  -- SLUG3_SLUG_QUEEN_AND_PLAYER_READY
    [2062] = { stand = 2663 },  -- SLUG3_SLUG_QUEEN_DEATH_SQUASHED_FINAL_FRAME
    [2063] = { stand = 2634 },  -- SLUG3_LUCY_AND_SLUG_QUEEN_READY
    [2064] = { stand = 2636 },  -- SLUG3_LUCY_DYING_READY
    [2065] = { stand = 2672 },  -- SLUG3_LUCY_DIES_LAST_FRAME
    [2066] = { stand = 2638 },  -- SLUG3_PLAYER_AND_QUEEN_READY
    [2067] = { stand = 2646 },  -- SLUG3_HOBB_GETS_KNOCKS_OUT_FINAL_LOOP
    [2068] = { stand = 2765, walk = 2766, run = 2773, turnLeft = 2766, turnRight = 2766, walkLeft = 2766, walkRight = 2766, walkTurnLeft = 2766, walkTurnRight = 2766 },  -- HOOKS1_DWARVEN_AXE_READY
    [2069] = { stand = 14863, walk = 3002, run = 3001, turnLeft = 14863, turnRight = 14863, walkBack = 3002, walkTurnLeft = 3002, walkTurnRight = 3002 },  -- F4HB3_PLAYER_SLING_READY
    [2070] = { stand = 3115, walk = 3119, run = 3116, turnLeft = 3115, turnRight = 3115, walkBack = 3119, walkTurnLeft = 3119, walkTurnRight = 3119 },  -- JARO_PLAYER_HOLDING_SAGAIE_READY
    [2071] = { stand = 3013, walk = 3015, run = 3015, turnLeft = 3013, turnRight = 3013, walkBack = 3015, walkTurnLeft = 3015, walkTurnRight = 3015 },  -- JARO_BABY_JARDINKO_READY
    [2072] = { stand = 3165, walk = 3213, run = 3213, turnLeft = 3165, turnRight = 3165, walkBack = 3213, walkTurnLeft = 3213, walkTurnRight = 3213 },  -- JARO_JARDINKO_ADULT_READY
    [2073] = { stand = 3165, walk = 3571, run = 3571, turnLeft = 3165, turnRight = 3165, walkBack = 3571, walkTurnLeft = 3571, walkTurnRight = 3571 },  -- JARO_JARDINKO_ADULT_READY
    [2074] = { crawl = 3830, idles = { { 3824, 80 }, { 3817, 20 } } },
    [2075] = { stand = 3831, walk = 3831 },  -- CLAN_TEASER_CHICKEN_WIZARD
    [2076] = { stand = 3839, walk = 3831 },  -- CLAN_ALAVALNI_READY
    [2077] = { stand = 3593, walk = 3868, run = 3869, walkBack = 3868, walkLeft = 3896, walkRight = 3900 },  -- CLAN_FIELD_BALL_READY
    [2078] = { stand = 3927, walk = 3929 },  -- CLAN_FIELD_BALL_BOUNCING_READY
    [2079] = { stand = 4607, walk = 4632 },  -- CLAN_BATTLEFIELD_MELEE_READY
    [2080] = { stand = 4642, walk = 4675 },  -- CLAN_BATTLEFIELD_RANGER_READY
    [2081] = { stand = 4688, walk = 4680 },  -- CLAN_BATTLEFIELD_MAGE_READY
    [2082] = { stand = 3925, walk = 3925, run = 3925 },  -- CLAN_FIELD_BALL_PROJ
    [2083] = { stand = 3983, walk = 3983 },  -- CLAN_BATTLEFIELD_BATTLEMASTER_READY
    [2084] = { stand = 6788 },  -- CLAN_CHAIR_SIT_READY
    [2085] = { stand = 6820 },  -- CLAN_PLAYER_BENCH_SITTING_READY
    [2086] = { stand = 6846 },  -- CLAN_PLAYER_CHAIR_SITTING_READY
    [2087] = { stand = 7071, walk = 7525, run = 7526 },  -- CLAN_FLYTHROUGH_PLAYER_EMOTE_DANCING
    [2088] = { stand = 7159, walk = 7161, run = 7162 },  -- CLAN_EMOTE_DANCING
    [2089] = { walk = 7643, idles = { { 7644, 95 }, { 7645, 5 } } },
    [2090] = { stand = 7646, walk = 7646 },  -- CLAN_NPC_SQUIRE_READY
    [2091] = { stand = 7648, walk = 7648 },  -- CLAN_NPC_QUARTERMASTER_READY
    [2092] = { stand = 7647, walk = 7647 },  -- CLAN_NPC_ARTISAN_READY
    [2093] = { stand = 7649, walk = 7649 },  -- CLAN_NPC_THEATRE_VENDOR_READY
    [2094] = { stand = 7731, walk = 7731 },  -- CLAN_HALBERD_GUARD_CLOSE_READY
    [2095] = { stand = 7666, walk = 7666 },  -- CLAN_HALBERD_GUARD_CLOSE_READY_OPPOSITE_SIDE
    [2096] = { stand = 7057 },  -- CLAN_SITTING_READY
    [2097] = { stand = 8817 },  -- HCAPE_HERALD_VARROCK_READY
    [2098] = { stand = 8827 },  -- HCAPE_HERALD_FALADOR_READY
    [2099] = { stand = 8828 },  -- HCAPE_HERALD_LUMBRIDGE_READY
    [2100] = { stand = 808, walk = 1065, turnLeft = 823, turnRight = 823, walkBack = 1138, walkLeft = 1198, walkRight = 1201 },  -- HUMAN_READY
    [2101] = { stand = 7047, walk = 1059, walkBack = 904, walkLeft = 903, walkRight = 902 },  -- DH_SWORD_UPDATE_READY
    [2102] = { stand = 10814, walk = 1211 },  -- UPDATE_TROLL_READY
    [2103] = { idles = { { 1217, 95 }, { 1233, 5 } } },
    [2104] = { stand = 3151, walk = 3151, turnLeft = 823, turnRight = 823 },  -- SIGHERO_LINZA_FAI_FURNACE
    [2105] = { stand = 3153, walk = 3153, turnLeft = 823, turnRight = 823 },  -- SIGHERO_LINZA_HAMMERING_DORGESH
    [2106] = { stand = 3158, walk = 3158, turnLeft = 823, turnRight = 823 },  -- SIGHERO_LINZA_HAMMERING_DRAGONFORGE
    [2107] = { stand = 3218, walk = 3218, turnLeft = 823, turnRight = 823 },  -- SIGHERO_LINZA_HAMMERING_THURGO_HUT
    [2108] = { stand = 1669, walk = 1673, turnLeft = 1673, turnRight = 1673 },  -- SIGHERO_ARIANE_CASUAL_READY
    [2109] = { stand = 1334, walk = 1479, turnLeft = 1479, turnRight = 1479 },  -- SIGHERO_ARIANE_ADVENTURER_READY
    [2110] = { stand = 1736 },  -- SIGHERO_ARIANE_CHAMP_GUILD_SEATED
    [2111] = { stand = 1873, walk = 1919, turnLeft = 823, turnRight = 823 },  -- SIGHERO_LINZA_CASUAL_READY
    [2112] = { stand = 2406, walk = 2407, turnLeft = 2407, turnRight = 2407 },  -- SIGHERO_OZAN_CASUAL_READY
    [2113] = { stand = 2617, walk = 2648, turnLeft = 2648, turnRight = 2648 },  -- SIGHERO_OZAN_CASUAL_READY_WITHLUTE
    [2114] = { stand = 1936, walk = 1968, run = 824, turnLeft = 1968, turnRight = 1968 },  -- SIGHERO_OZAN_ADVENTURER_READY
    [2115] = { stand = 2649, turnLeft = 2407, turnRight = 2407 },  -- SIGHERO_OZAN_CHAMP_GUILD_PLAYINGLUTE
    [2116] = { stand = 2934, walk = 2944, turnLeft = 2875, turnRight = 2875 },  -- SIGHERO_SIROWEN_CASUAL_READY
    [2117] = { stand = 2834, walk = 2875, run = 1079, turnLeft = 2875, turnRight = 2875 },  -- SIGHERO_SIROWEN_ADVENTURER_READY
    [2118] = { stand = 3000 },  -- SIGHERO_SIROWEN_CHAMP_GUILD_SEATED
    [2119] = { stand = 3084, walk = 3083, run = 824, turnLeft = 3083, turnRight = 3083 },  -- SIGHERO_XENIA_CASUAL_READY
    [2120] = { stand = 3085 },  -- SIGHERO_XENIA_CHAMP_GUILD_SEATED
    [2121] = { stand = 3086, turnLeft = 3083, turnRight = 3083 },  -- SIGHERO_XENIA_MOURNING_READY
    [2122] = { stand = 20817, walk = 20824, turnLeft = 20824, turnRight = 20824 },  -- SIGHERO_RAPTOR_CASUAL_READY
    [2123] = { stand = 5975, walk = 5975 },  -- RAMBLE_SICK_FOLK_STAGE_1_READY
    [2124] = { stand = 5976, walk = 5976 },  -- RAMBLE_SICK_FOLK_STAGE_2_READY
    [2125] = { stand = 5977, walk = 5977 },  -- RAMBLE_SICK_FOLK_STAGE_3_READY
    [2126] = { stand = 5974, walk = 5974 },  -- RAMBLE_SICK_FOLK_HEALTHY_READY
    [2127] = { stand = 14685, walk = 14685 },  -- PLAYERKIT_CHEF_MALE_READY
    [2128] = { stand = 4622, walk = 4622 },  -- TT2_JAYENE_READY
    [2129] = { stand = 14683, walk = 14683 },  -- PLAYERKIT_ADVENTURER_MALE_READY
    [2130] = { stand = 14690, walk = 14690 },  -- PLAYERKIT_MAGE_READY
    [2131] = { stand = 4648, walk = 4648 },  -- TT2_PAZUZU_READY
    [2132] = { stand = 14693, walk = 14693 },  -- PLAYERKIT_THIEF_MALE_READY
    [2133] = { stand = 5290, walk = 5291, walkBack = 5291, walkLeft = 5291, walkRight = 5291 },  -- TT2_SNAKE_READY
    [2134] = { stand = 5561, walk = 5561, walkBack = 5561, walkLeft = 5561, walkRight = 5561 },  -- TT2_SNAKE_DEATH_READY
    [2135] = { stand = 5836, walk = 5968, turnLeft = 5968, turnRight = 5968, walkBack = 5968 },  -- MYQ5_JUVENATE_READY
    [2136] = { stand = 6231, walk = 6226, turnLeft = 6226, turnRight = 6226, walkBack = 6226 },  -- MYQ5_JUVENATE_RAGE_READY
    [2137] = { stand = 7005, walk = 7054, walkBack = 7054 },  -- MYQ5_VYREWATCH_FLYING_READY
    [2138] = { stand = 7068, walk = 7068 },  -- SWAMP_IMP_FIREFLY_HOVER
    [2139] = { stand = 6721, walk = 6780, turnLeft = 6780, turnRight = 6780, walkBack = 6780 },  -- MYQ5_JUVENILE_READY
    [2140] = { stand = 7733, walk = 7749, run = 7734, turnLeft = 7749, turnRight = 7749, walkBack = 7749 },  -- MYQ5_VYREWATCH_GROUNDED_READY
    [2141] = { stand = 7357, walk = 7357 },  -- MYQ5_VANSTROM_VAPOUR_READY
    [2142] = { stand = 9216, walk = 9219 },  -- HLR4M_DRAGON_BABY_READY
    [2143] = { stand = 7077 },  -- MYQ5_JUVENILE_HELD_LOOP
    [2144] = { stand = 1975, walk = 1975, crawl = 1975 },  -- SPELL_SHADOW_BLITZ_TRAVEL
    [2145] = { stand = 7733, walk = 7749, run = 7734, walkBack = 7749 },  -- MYQ5_VYREWATCH_GROUNDED_READY
    [2146] = { stand = 9687, walk = 9688, turnLeft = 9688, turnRight = 9688 },  -- MYQ5_BLOODVELD_READY
    [2147] = { stand = 9702 },  -- MYQ5_ORB_READY
    [2148] = { stand = 8562, walk = 8592, turnLeft = 8592, turnRight = 8592, walkBack = 8592 },  -- MYQ5_HUMAN_VANSTROM_READY
    [2149] = { stand = 8593, walk = 819, turnLeft = 819, turnRight = 819, walkBack = 8842 },  -- MYQ5_HUMAN_VANESCULA_READY
    [2150] = {  },
    [2151] = { stand = 8354 },  -- MYQ5_VYREWATCH_GROUNDED_HELD
    [2152] = { stand = 9717 },  -- MYQ5_HUMAN_FAINT_READY
    [2153] = { stand = 12010, walk = 1205, run = 9882, walkBack = 1206 },  -- _7W_HUMAN_STAFFREADY
    [2154] = { stand = 9922 },  -- MYQ5_TITHER_CRY
    [2155] = { stand = 9923, walk = 819, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- MYQ5_RANIS_READY
    [2156] = { idles = { { 8860, 95 }, { 9663, 5 } } },
    [2157] = { idles = { { 9664, 95 }, { 9668, 5 } } },
    [2158] = { stand = 9945, walk = 9945 },  -- MERCENARY_TROLL_INVISIBLE
    [2159] = { walk = 9948, crawl = 9947, idles = { { 9949, 80 }, { 9950, 20 } } },
    [2160] = { stand = 11475, walk = 11455 },  -- MAH5_INJURED_READY
    [2161] = { stand = 11484, walk = 11455 },  -- MAH5_INJURED2_READY
    [2162] = { stand = 11910 },  -- MAH5_JHALLAN_IN_ICE_READY
    [2163] = { stand = 11663 },  -- MAH5_ARRAV_DYING_READY
    [2164] = { stand = 10769, walk = 11554 },  -- MAH5_ARCHIVE_KNIGHT_READ_MAP_READY
    [2165] = { stand = 11013, walk = 11125, turnLeft = 11125, turnRight = 11125 },  -- MAH5_MAHJARATT_READY
    [2166] = { stand = 11522, walk = 11125 },  -- MAH5_MAHJARATT_READY_VAR_A
    [2167] = { stand = 11523, walk = 11125 },  -- MAH5_MAHJARATT_READY_VAR_B
    [2168] = { stand = 11031, walk = 11125 },  -- MAH5_MAHJARATT_READY_NO_LEAN_VAR_A
    [2169] = { stand = 11124, walk = 11125 },  -- MAH5_MAHJARATT_READY_NO_LEAN_VAR_B
    [2170] = { stand = 11517, walk = 11516, turnLeft = 26768, turnRight = 26768, crawlTurnLeft = 11516, crawlTurnRight = 11516, walkTurnLeft = 11516, walkTurnRight = 11516 },  -- MAH5_DRAGONKIN_READY
    [2171] = { stand = 11431, walk = 11506 },  -- MAH5_DRAGONKIN_READY_FLYING
    [2172] = { stand = 11292, walk = 11317 },  -- MAHJARRAT_2010_LUC2_LUCIEN_READY
    [2173] = { stand = 11541, walk = 11541 },  -- MAH5_LUCIEN_CUTSCENE_DEATH_READY
    [2174] = { stand = 11995, walk = 11996 },  -- MAHJARRAT_2010_KHAZARD_READY
    [2175] = { stand = 12007, walk = 11997 },  -- MAHJARRAT_2010_KHAZARD_GIANT_READY
    [2176] = { stand = 11995, walk = 11996 },  -- MAHJARRAT_2010_KHAZARD_READY
    [2177] = { stand = 12025, walk = 12026 },  -- MAHJARRAT_2010_ZEMO_ZEMOUREGAL_READY
    [2178] = { stand = 10178, walk = 10178 },  -- MAH5_CUTSCENE_SARADOMIN_MAGE_FIGHT_A
    [2179] = { stand = 10197, walk = 10197 },  -- MAH5_CUTSCENE_SARADOMIN_MAGE_FIGHT_B
    [2180] = { stand = 10198, walk = 10198 },  -- MAH5_CUTSCENE_SARADOMIN_RANGER_FIGHT_A
    [2181] = { stand = 10216, walk = 10216 },  -- MAH5_CUTSCENE_SARADOMIN_WARRIOR_FIGHT_A
    [2182] = { stand = 10244, walk = 10244 },  -- MAH5_CUTSCENE_ZAMORAK_MAGE_FIGHT_A
    [2183] = { stand = 10245, walk = 10245 },  -- MAH5_CUTSCENE_ZAMORAK_MAGE_FIGHT_B
    [2184] = { stand = 10246, walk = 10246 },  -- MAH5_CUTSCENE_ZAMORAK_RANGER_FIGHT_A
    [2185] = { stand = 10248, walk = 10248 },  -- MAH5_CUTSCENE_ZAMORAK_WARRIOR_FIGHT_A
    [2186] = { stand = 10255 },  -- MAH5_CUTSCENE_DEMON_READY
    [2187] = { stand = 10476, walk = 10425 },  -- MAH5_CUTSCENE_SARADOMIN_READY
    [2188] = { stand = 10750, walk = 10750 },  -- LUC2_STONE_JAS_ENERGY
    [2189] = { stand = 12350, walk = 7191, walkBack = 7192, walkLeft = 7193, walkRight = 7194 },  -- MAH5_AKRISAE_READY
    [2190] = { stand = 10867, walk = 10901 },  -- ELEMENTAL_UPDATE_ICE_READY
    [2191] = { stand = 12393, walk = 12407 },  -- LUC2_SPY_READY_UPDATE_ALT
    [2192] = { stand = 12925 },  -- CLAN_EMOTE_DEATH_POSE
    [2193] = { crawl = 13216, crawlBack = 13216, crawlLeft = 13216, crawlRight = 13216, turnLeft = 13591, turnRight = 13591, crawlTurnLeft = 13216, crawlTurnRight = 13216, idles = { { 13202, 90 }, { 13215, 10 } } },
    [2194] = { stand = 13446, crawl = 13482, crawlBack = 13482, crawlLeft = 13482, crawlRight = 13482, turnLeft = 13592, turnRight = 13592, crawlTurnLeft = 13482, crawlTurnRight = 13482 },  -- AGIDAD_WEREWOLF_READY
    [2195] = { stand = 13290, walk = 13221, run = 13373, turnLeft = 13290, turnRight = 13290, walkBack = 13221, walkLeft = 13221, walkRight = 13221, walkTurnLeft = 13221, walkTurnRight = 13221 },  -- AGIDAD_PLAYER_HOLD_SHAPE_READY_FIRE
    [2196] = { stand = 13300, walk = 13268, run = 13387, turnLeft = 13300, turnRight = 13300, walkBack = 13268, walkLeft = 13268, walkRight = 13268, walkTurnLeft = 13268, walkTurnRight = 13268 },  -- AGIDAD_PLAYER_HOLD_SHAPE_READY_FOOT
    [2197] = { stand = 13311, walk = 13274, run = 13397, turnLeft = 13311, turnRight = 13311, walkBack = 13274, walkLeft = 13274, walkRight = 13274, walkTurnLeft = 13274, walkTurnRight = 13274 },  -- AGIDAD_PLAYER_HOLD_SHAPE_READY_LIGHTNING
    [2198] = { stand = 13318, walk = 13283, run = 13444, turnLeft = 13318, turnRight = 13318, walkBack = 13283, walkLeft = 13283, walkRight = 13283, walkTurnLeft = 13283, walkTurnRight = 13283 },  -- AGIDAD_PLAYER_HOLD_SHAPE_READY_SWORD
    [2199] = { stand = 13314, walk = 13278, run = 13415, turnLeft = 13314, turnRight = 13314, walkBack = 13278, walkLeft = 13278, walkRight = 13278, walkTurnLeft = 13278, walkTurnRight = 13278 },  -- AGIDAD_PLAYER_HOLD_SHAPE_READY_SKULL
    [2200] = { walk = 13589, turnLeft = 13589, turnRight = 13589, walkBack = 13589, walkLeft = 13589, walkRight = 13589, walkTurnLeft = 13589, walkTurnRight = 13589, idles = { { 13571, 90 }, { 13577, 10 } } },
    [2201] = { walk = 13590, turnLeft = 13590, turnRight = 13590, idles = { { 13517, 90 }, { 13518, 10 } } },
    [2202] = { stand = 13722 },  -- HW11_FRANK_VEXILLUM_READY
    [2203] = { stand = 13762 },  -- HW11_FRANK_READY
    [2204] = { stand = 3824, walk = 3830, turnLeft = 3824, turnRight = 3824, walkTurnLeft = 3830, walkTurnRight = 3830 },  -- CHICKEN_UPDATE_READY_VARIATION
    [2205] = { stand = 3817, walk = 3830, turnLeft = 3817, turnRight = 3817, walkTurnLeft = 3830, walkTurnRight = 3830 },  -- CHICKEN_UPDATE_READY_EXTRA
    [2206] = { stand = 3824, walk = 3830, turnLeft = 3824, turnRight = 3824, walkTurnLeft = 3830, walkTurnRight = 3830 },  -- CHICKEN_UPDATE_READY_VARIATION
    [2207] = { stand = 3817, walk = 3830, turnLeft = 3817, turnRight = 3817, walkTurnLeft = 3830, walkTurnRight = 3830 },  -- CHICKEN_UPDATE_READY_EXTRA
    [2208] = { stand = 13863 },  -- HW11_BEAUTY_STATUE_READY
    [2209] = { stand = 13858, turnLeft = 13858, turnRight = 13858, walkTurnLeft = 3967, walkTurnRight = 3967 },  -- HW11_MUNCHER_READY
    [2210] = { stand = 13980 },  -- HW11_DEATH_READY_SEATED
    [2211] = { stand = 13851, walk = 13846, walkTurnLeft = 13846, walkTurnRight = 13846 },  -- HW11_DEATH_READY
    [2212] = { stand = 13687 },  -- HW11_EMOTE_DEATH_HOURGLASS
    [2213] = { stand = 13773 },  -- HW11_AERECK_READY
    [2214] = { stand = 13899, walkTurnLeft = 13899, walkTurnRight = 13899 },  -- HW11_BLASIDAR_READY
    [2215] = { stand = 13774 },  -- HW11_DIANGO_READY
    [2216] = { stand = 13905 },  -- HW11_INFINITY_DJ_READY
    [2217] = { stand = 13813 },  -- HW11_FAME_READY
    [2218] = { stand = 13961 },  -- HW11_NPC_TALKING_01
    [2219] = { stand = 13958 },  -- HW11_NPC_TALKING_02
    [2220] = { stand = 14018, walk = 14055, run = 14056, turnLeft = 14055, turnRight = 14055, walkBack = 14057, walkLeft = 14055, walkRight = 14055 },  -- HW11_SCYTHE_READY
    [2221] = { stand = 14113, run = 14113 },  -- HOOKS3_LACHMACHAN_ZU_READY
    [2222] = { stand = 14437, walk = 14438, run = 14438, turnLeft = 14449, turnRight = 14449 },  -- DOM_DREADNIP_READY
    [2223] = { stand = 14530 },  -- DOM_MARKER_OPEN_AND_READY
    [2224] = { stand = 15170 },  -- POLYPORE_SHOPKEEPER_READY
    [2225] = { stand = 15407 },  -- OPN_SISTER_BENITA_SEATED_READY
    [2226] = { stand = 15405, walk = 15408 },  -- OPN_SISTER_BENITA_READY
    [2227] = { stand = 15404, walk = 15408 },  -- OPN_SISTER_BENITA_OUT_OF_BREATH
    [2228] = { stand = 15375 },  -- OPN_DEBORA_EMERGE_FROM_CLOCK
    [2229] = { stand = 15358, walk = 15354 },  -- OPN_SISTER_CATHERINA_READY
    [2230] = { stand = 15409 },  -- OPN_SISTER_ELENA_READY
    [2231] = { stand = 15236, walk = 15237, crawl = 15265, crawlLeft = 15265, crawlRight = 15265, run = 15255, runLeft = 15255, runRight = 15255, turnLeft = 15236, turnRight = 15236, walkLeft = 15237, walkRight = 15237, crawlTurnLeft = 15265, crawlTurnRight = 15265, walkTurnLeft = 15237, walkTurnRight = 15237 },  -- OPN_RIPPER_READY
    [2232] = { stand = 15236, walk = 15237, run = 15268, runLeft = 15268, runRight = 15268, turnLeft = 15236, turnRight = 15236, walkLeft = 15237, walkRight = 15237, walkTurnLeft = 15237, walkTurnRight = 15237 },  -- OPN_RIPPER_READY
    [2233] = { stand = 15277, walk = 15237 },  -- OPN_RIPPER_HOLDING_HOSTAGE_READY
    [2234] = { stand = 15284, walk = 15237 },  -- OPN_RIPPER_KNEELING_READY
    [2235] = { stand = 15342, walk = 15339, turnLeft = 15342, turnRight = 15342, walkLeft = 15339, walkRight = 15339, walkTurnLeft = 15339, walkTurnRight = 15339 },  -- OPN_SISTER_CECILIA_READY
    [2236] = { stand = 15344, walk = 15344 },  -- OPN_SISTER_CECILIA_SHOCKED_SEATED_READY
    [2237] = { stand = 15343, walk = 15351, turnLeft = 15343, turnRight = 15343, walkLeft = 15351, walkRight = 15351, walkTurnLeft = 15351, walkTurnRight = 15351 },  -- OPN_SISTER_CECILIA_SHOCKED_READY
    [2238] = { stand = 15340, walk = 15340 },  -- OPN_SISTER_CECILIA_CONDUCTING
    [2239] = { stand = 15383, walk = 15383 },  -- OPN_SISTER_CECILIA_TROUBADOUR_GUITAR_READY
    [2240] = { stand = 15352, walk = 15352 },  -- OPN_STRYKEWRYM_HUNTER_READY
    [2241] = { stand = 15358, walk = 15354, turnLeft = 15358, turnRight = 15358, walkLeft = 15354, walkRight = 15354, walkTurnLeft = 15354, walkTurnRight = 15354 },  -- OPN_SISTER_CATHERINA_READY
    [2242] = { stand = 15365, walk = 15339, turnLeft = 15365, turnRight = 15365, walkLeft = 15339, walkRight = 15339, walkTurnLeft = 15339, walkTurnRight = 15339 },  -- OPN_NUN_GENERIC_READY
    [2243] = { stand = 15372, walk = 15372 },  -- OPN_DANCER_MALE_SHOCKED_READY
    [2244] = { stand = 15374, walk = 15374 },  -- OPN_DANCER_FEMALE_SHOCKED_READY
    [2245] = { stand = 15390, walk = 15391, turnLeft = 15390, turnRight = 15390, walkLeft = 15391, walkRight = 15391, walkTurnLeft = 15391, walkTurnRight = 15391 },  -- OPN_NUN_CARRYING_WINE_READY
    [2246] = { stand = 15375, walk = 15375 },  -- OPN_DEBORA_EMERGE_FROM_CLOCK
    [2247] = { stand = 15403, walk = 15339, turnLeft = 15403, turnRight = 15403, walkLeft = 15339, walkRight = 15339, walkTurnLeft = 15339, walkTurnRight = 15339 },  -- OPN_DEBORA_READY
    [2248] = { stand = 15311 },  -- OPN_DEBORA_HELD_HOSTAGE
    [2249] = { stand = 15405, walk = 15408, turnLeft = 15405, turnRight = 15405, walkLeft = 15408, walkRight = 15408, walkTurnLeft = 15408, walkTurnRight = 15408 },  -- OPN_SISTER_BENITA_READY
    [2250] = { stand = 15423, walk = 15429 },  -- OPN_DANCER_DANCE_MALE_FEEDBACK
    [2251] = { stand = 15387, walk = 15428 },  -- OPN_DANCER_DANCE_FEMALE
    [2252] = { stand = 15422, walk = 15428 },  -- OPN_SISTER_CATHERINA_DANCE
    [2253] = { stand = 15426 },  -- OPN_NUN_PLAYING_ORGAN
    [2254] = { stand = 15411, walk = 15413, turnLeft = 15411, turnRight = 15411, walkBack = 15413, walkLeft = 15413, walkRight = 15413, walkTurnLeft = 15413, walkTurnRight = 15413 },  -- OPN_VALERIO_READY
    [2255] = { stand = 15412 },  -- OPN_VALERIO_SINGING_LOOP
    [2256] = { stand = 15414, walk = 15414 },  -- OPN_MALE_TROUBADOUR_PLAYING
    [2257] = { stand = 15415, walk = 15415 },  -- OPN_FEMALE_TROUBADOUR_PLAYING
    [2258] = { stand = 15409, walk = 15339, turnLeft = 15409, turnRight = 15409, walkLeft = 15339, walkRight = 15339, walkTurnLeft = 15339, walkTurnRight = 15339 },  -- OPN_SISTER_ELENA_READY
    [2259] = { stand = 15394, walk = 15429 },  -- OPN_DANCER_MALE_STAND_OFF
    [2260] = { stand = 15393, walk = 15428 },  -- OPN_DANCER_FEMALE_STAND_OFF
    [2261] = { stand = 15421, walk = 15421 },  -- OPN_SAINT_ELESPETH_SPIRIT_READY
    [2262] = { stand = 8828, walk = 15428 },  -- HCAPE_HERALD_LUMBRIDGE_READY
    [2263] = { stand = 15444, walk = 15445 },  -- TG11_TURKEY_WITH_PLACARD_IDLE
    [2264] = { stand = 15463 },  -- POLYPORE_SKINWEAVER_SEATED_READY
    [2265] = { stand = 15464, crawl = 15465, crawlBack = 15465, crawlLeft = 15465, crawlRight = 15465, turnLeft = 15464, turnRight = 15464, crawlTurnLeft = 15465, crawlTurnRight = 15465 },  -- POLYPORE_GANODERMIC_BEAST_READY
    [2266] = { stand = 15475, crawl = 15476, crawlBack = 15476, crawlLeft = 15476, crawlRight = 15476, turnLeft = 15475, turnRight = 15475, crawlTurnLeft = 15476, crawlTurnRight = 15476 },  -- POLYPORE_GANODERMIC_RUNT_READY
    [2267] = { stand = 15505, walk = 15506, turnLeft = 15505, turnRight = 15505, walkLeft = 15506, walkRight = 15506, walkTurnLeft = 15506, walkTurnRight = 15506 },  -- POLYPORE_FUNGAL_MAGE_READY
    [2268] = { stand = 15512, walk = 15513, turnLeft = 15512, turnRight = 15512, walkLeft = 15513, walkRight = 15513, walkTurnLeft = 15513, walkTurnRight = 15513 },  -- POLYPORE_FUNGAL_RODENT_READY
    [2269] = { stand = 15481, walk = 15482, run = 15483, runBack = 15483, runLeft = 15483, runRight = 15483, turnLeft = 15481, turnRight = 15481, walkLeft = 15482, walkRight = 15482, runTurnLeft = 15483, runTurnRight = 15483, walkTurnLeft = 15482, walkTurnRight = 15482 },  -- POLYPORE_GRIFOLAPINE_READY
    [2270] = { stand = 15500, walk = 15501, turnLeft = 15500, turnRight = 15500, walkLeft = 15501, walkRight = 15501, walkTurnLeft = 15501, walkTurnRight = 15501 },  -- POLYPORE_ENCHANTED_AXE_READY
    [2271] = { stand = 15489, walk = 15490, turnLeft = 15489, turnRight = 15489, walkBack = 15490, walkLeft = 15490, walkRight = 15490, walkTurnLeft = 15490, walkTurnRight = 15490 },  -- POLYPORE_GRIFOLAROO_READY
    [2272] = { stand = 2040, walk = 2041, turnLeft = 823, turnRight = 823, walkBack = 2041, walkLeft = 2041, walkRight = 2041 },  -- TOG_READY_BOWL
    [2273] = { stand = 15553, walk = 15553, turnLeft = 15553, turnRight = 15553, walkTurnLeft = 15554, walkTurnRight = 15554 },  -- RDEN2_BRIAN_READY
    [2274] = { stand = 15587, walk = 15586, turnLeft = 15586, turnRight = 15586, walkBack = 15586, walkLeft = 15586, walkRight = 15586 },  -- XMAS11_BAUBLE_READY
    [2275] = { stand = 793 },  -- FAIRYKIT_FAIRY_READY
    [2276] = { stand = 15589, walk = 15590 },  -- XMAS11_SIONCORN_BOX_WALK
    [2277] = { stand = 15594 },  -- XMAS11_SINTERKLAAS_READY
    [2278] = { stand = 15606 },  -- XMAS11_BANQUET_SIT_DOWN_READY
    [2279] = { stand = 15607 },  -- XMAS11_SIONCORN_SAT_DOWN_READY
    [2280] = { stand = 15608 },  -- XMAS11_DEMON_SAT_DOWN_READY
    [2281] = { stand = 15609 },  -- XMAS11_IMP_SAT_DOWN_READY
    [2282] = { stand = 15610 },  -- XMAS11_VIEF_SAT_DOWN_READY
    [2283] = { stand = 15611 },  -- XMAS11_KORVAC_SAT_DOWN_READY
    [2284] = { stand = 15612 },  -- XMAS11_OGRE_SAT_DOWN_READY
    [2285] = { stand = 15641 },  -- FMC_FIREMAKER_TIED_TO_PILLAR_READY
    [2286] = { stand = 15642 },  -- FMC_FIREMAKER_TIED_TO_PILLAR_DEAD_POSE
    [2287] = { stand = 15652 },  -- FMC_PHOENIX_DEAD
    [2288] = { stand = 15649 },  -- FMC_FLINT_DEAD
    [2289] = { stand = 15650 },  -- FMC_ISIS_DEAD
    [2290] = { stand = 15651 },  -- FMC_LINA_DEAD
    [2291] = { stand = 15653 },  -- FMC_TWIG_DEAD
    [2292] = { stand = 15699, walk = 15699 },  -- FMC_FIRE_WALL
    [2293] = { stand = 15723, walk = 15722, turnLeft = 15722, turnRight = 15722, walkLeft = 15722, walkRight = 15722, walkTurnLeft = 15722, walkTurnRight = 15722 },  -- FMC_SERA_READY
    [2294] = { stand = 15667, walk = 15669, turnLeft = 15669, turnRight = 15669, walkLeft = 15669, walkRight = 15669, walkTurnLeft = 15669, walkTurnRight = 15669 },  -- FMC_LINA_READY
    [2295] = { stand = 15665, walk = 15428, turnLeft = 15428, turnRight = 15428, walkLeft = 15428, walkRight = 15428, walkTurnLeft = 15428, walkTurnRight = 15428 },  -- FMC_ISIS_READY
    [2296] = { stand = 15662, walk = 15664, turnLeft = 15664, turnRight = 15664, walkLeft = 15664, walkRight = 15664, walkTurnLeft = 15664, walkTurnRight = 15664 },  -- FMC_FLINT_READY
    [2297] = { stand = 15659, walk = 15429, turnLeft = 15429, turnRight = 15429, walkLeft = 15429, walkRight = 15429, walkTurnLeft = 15429, walkTurnRight = 15429 },  -- FMC_EMMETT_READY
    [2298] = { stand = 15673, walk = 15675, turnLeft = 15675, turnRight = 15675, walkLeft = 15675, walkRight = 15675, walkTurnLeft = 15675, walkTurnRight = 15675 },  -- FMC_TWIG_READY
    [2299] = { stand = 15670, walk = 15672, turnLeft = 15672, turnRight = 15672, walkLeft = 15672, walkRight = 15672, walkTurnLeft = 15672, walkTurnRight = 15672 },  -- FMC_PHOENIX_READY
    [2300] = { stand = 15626, walk = 15626, crawl = 15626, run = 15626, runLeft = 15626, runRight = 15626, walkLeft = 15626, walkRight = 15626, crawlTurnLeft = 15626, crawlTurnRight = 15626, runTurnLeft = 15626, runTurnRight = 15626, walkTurnLeft = 15626, walkTurnRight = 15626 },  -- FMC_CREATURE_READY
    [2301] = { stand = 15633, walk = 15634, turnLeft = 15634, turnRight = 15634, walkLeft = 15634, walkRight = 15634, walkTurnLeft = 15634, walkTurnRight = 15634 },  -- FMC_PLAYER_TORCH_READY
    [2302] = { stand = 15711, walk = 15712, turnLeft = 15712, turnRight = 15712, walkLeft = 15712, walkRight = 15712, walkTurnLeft = 15712, walkTurnRight = 15712 },  -- FMC_CHAR_IDLE
    [2303] = { stand = 15707, walk = 15724, turnLeft = 15724, turnRight = 15724, walkLeft = 15724, walkRight = 15724, walkTurnLeft = 15724, walkTurnRight = 15724 },  -- FMC_CHAR_GIANT_IDLE
    [2304] = { stand = 15710, walk = 15709, turnLeft = 15709, turnRight = 15709, walkLeft = 15709, walkRight = 15709, walkTurnLeft = 15709, walkTurnRight = 15709 },  -- FMC_CHAR_GIANT_FURY_IDLE
    [2305] = { stand = 14750, walk = 15756, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- FACE_READY
    [2306] = { walk = 23593, run = 23586, turnLeft = 23593, turnRight = 23593, walkTurnLeft = 23593, walkTurnRight = 23593, idles = { { 23588, 90 }, { 23589, 10 } } },
    [2307] = { walk = 23594, run = 23595, turnLeft = 23594, turnRight = 23594, walkTurnLeft = 23594, walkTurnRight = 23594, idles = { { 23596, 90 }, { 23599, 10 } } },
    [2308] = { stand = 15855, walk = 15858, walkLeft = 15858, walkRight = 15858 },  -- OMGE_RANGED_TROLL_BOSS_READY
    [2309] = { stand = 15834, walk = 15818 },  -- OMGE_OZAN_TROLL_READY
    [2310] = { stand = 15761, walk = 15761 },  -- OMGE_COMBAT_MASTER_READY
    [2311] = { stand = 14689, walk = 14689 },  -- PLAYERKIT_ATHLETE_MALE_READY
    [2312] = { stand = 15762, walk = 15762 },  -- OMGE_DUNGEONEERING_MASTER_READY
    [2313] = { stand = 15763, walk = 15763 },  -- OMGE_FIREMAKING_MASTER_READY
    [2314] = { stand = 15764, walk = 15764 },  -- OMGE_HERBALIST_MASTER_READY
    [2315] = { stand = 15838, walk = 15838 },  -- OMGE_THIEVING_MASTER_READY
    [2316] = { stand = 2584, walk = 2584 },  -- OMGE_FEMALE_FLETCHER_INTERFACE_ANIM
    [2317] = { stand = 14677, walk = 14677 },  -- MALE_FARMER_INTERFACE_ANIM
    [2318] = { stand = 15946, walk = 15946 },  -- PLAYERKIT_MALE_BUILDER_READY
    [2319] = { stand = 14698, walk = 14698 },  -- PLAYERKIT_HUNTER_FEMALE_READY
    [2320] = { stand = 15874, walk = 15874 },  -- OMGE_SUMMONING_MASTER_READY
    [2321] = { stand = 14681, walk = 14681 },  -- PLAYERKIT_SLAYER_FEMALE_READY
    [2322] = { stand = 14647, walk = 14647 },  -- PLAYERKIT_MINER_FEMALE_READY
    [2323] = { stand = 14642, walk = 14642 },  -- FEMALE_RUNECASTER_INTERFACE_ANIM
    [2324] = { stand = 14635, walk = 14635 },  -- PLAYERKIT_SMITH_MALE_READY
    [2325] = { stand = 14695, walk = 14695 },  -- PLAYERKIT_CRAFTER_READY
    [2326] = { stand = 14687, walk = 14687 },  -- MALE_FISHERMAN_INTERFACE_ANIM
    [2327] = { stand = 14685, walk = 14685 },  -- PLAYERKIT_CHEF_MALE_READY
    [2328] = { stand = 14678, walk = 14678 },  -- MALE_WOODCUTTER_INTERFACE_ANIM
    [2329] = { stand = 14649, walk = 14649 },  -- PLAYERKIT_PREIST_FEMALE_READY
    [2330] = { stand = 15776, walk = 15777, walkBack = 15777, walkLeft = 15777, walkRight = 15777, walkTurnLeft = 15777, walkTurnRight = 15777 },  -- OMGE_HUMAN_MARKET_BROWSING_A
    [2331] = { stand = 15778, walk = 15777, walkBack = 15777, walkLeft = 15777, walkRight = 15777, walkTurnLeft = 15777, walkTurnRight = 15777 },  -- OMGE_HUMAN_MARKET_BROWSING_B
    [2332] = { stand = 15774, walk = 15774 },  -- OMGE_HUMAN_TRAPPED_IN_HOUSE_READY
    [2333] = { stand = 15775, walk = 15775 },  -- OMGE_COOKING_HUMAN_SITTING_AT_BENCH_READY
    [2334] = { stand = 15767, crawl = 15768, crawlBack = 15768, crawlLeft = 15768, crawlRight = 15768, turnLeft = 15767, turnRight = 15767, crawlTurnLeft = 15768, crawlTurnRight = 15768 },  -- OMGE_PLAYER_FIREMAN_CARRY_READY
    [2335] = { stand = 15781, walk = 15780 },  -- OMGE_SKILL_AGILITY_PLAYER_SIDESTEP_LEFT_READY
    [2336] = { stand = 15787, walk = 15788, crawl = 15788, crawlBack = 15788, crawlLeft = 15788, crawlRight = 15788, turnLeft = 15787, turnRight = 15787, walkBack = 15788, walkLeft = 15788, walkRight = 15788, crawlTurnLeft = 15788, crawlTurnRight = 15788, walkTurnLeft = 15788, walkTurnRight = 15788 },  -- OMGE_WANDERING_WYRMWOOD_READY
    [2337] = { stand = 15810, walk = 15810 },  -- OMGE_MARKET_SELLER_READY_A
    [2338] = { stand = 15795, walk = 15795 },  -- OMGE_MARKET_SELLER_READY_B
    [2339] = { stand = 15792, walk = 15792 },  -- OMGE_THEIF_SITTING_READY_A
    [2340] = { stand = 15793, walk = 15793 },  -- OMGE_THEIF_SITTING_READY_B
    [2341] = { stand = 15794, walk = 15794 },  -- OMGE_THEIF_SITTING_READY_C
    [2342] = { stand = 15791, walk = 819, turnLeft = 15791, turnRight = 15791, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- OMGE_NPC_NURSE_READY
    [2343] = { stand = 15809, walk = 15809 },  -- OMGE_SOLDIER_WOUNDED_READY
    [2344] = { stand = 15805, crawl = 15806, crawlBack = 15806, crawlLeft = 15806, crawlRight = 15806, turnLeft = 15805, turnRight = 15805, crawlTurnLeft = 15806, crawlTurnRight = 15806 },  -- OMGE_MEDIC_SOLDIER_ESCORT_READY
    [2345] = { stand = 15808, crawl = 15806, crawlBack = 15806, crawlLeft = 15806, crawlRight = 15806, turnLeft = 15808, turnRight = 15808, crawlTurnLeft = 15806, crawlTurnRight = 15806 },  -- OMGE_MEDIC_SOLDIER_ESCORT_TALKING
    [2346] = { stand = 15797, walk = 15797, turnLeft = 15797, turnRight = 15797, walkBack = 15797, walkLeft = 15797, walkRight = 15797, walkTurnLeft = 15797, walkTurnRight = 15797 },  -- OMGE_SKILL_COMBAT_DUMMY_IDLE
    [2347] = { stand = 15812, walk = 15811, turnLeft = 15812, turnRight = 15812, walkBack = 15811, walkLeft = 15811, walkRight = 15811, walkTurnLeft = 15811, walkTurnRight = 15811 },  -- OMGE_NPC_SOLDIER_READY
    [2348] = { stand = 808, walk = 15811, turnLeft = 808, turnRight = 808, walkBack = 15811, walkLeft = 15811, walkRight = 15811, walkTurnLeft = 15811, walkTurnRight = 15811 },  -- HUMAN_READY
    [2349] = { stand = 15781, walk = 15780 },  -- OMGE_SKILL_AGILITY_PLAYER_SIDESTEP_LEFT_READY
    [2350] = { stand = 15820, walk = 15820 },  -- OMGE_SOLDIER_BED_WOUNDED
    [2351] = { stand = 15826, walk = 15826 },  -- OMGE_SOLDIER_BED_WOUNDED_VAR2
    [2352] = { stand = 15821, walk = 15821 },  -- OMGE_SOLDIER_BED_SITTINGUP
    [2353] = { stand = 15828, walk = 15828 },  -- OMGE_NPC_HERBALIST_MIXING_HERB_A
    [2354] = { stand = 15827, walk = 15827 },  -- OMGE_NPC_HERBALIST_MIXING_HERB_B
    [2355] = { stand = 15829, walk = 15829 },  -- OMGE_BLACKSMITH_HAMMERING_READY_A
    [2356] = { stand = 15813, walk = 15815, run = 15814, runBack = 15814, runLeft = 15814, runRight = 15814, turnLeft = 15813, turnRight = 15813, walkBack = 15815, walkLeft = 15815, walkRight = 15815, runTurnLeft = 15814, runTurnRight = 15814, walkTurnLeft = 15815, walkTurnRight = 15815 },  -- OMGE_BABY_TROLL_READY
    [2357] = { stand = 15819, walk = 15819 },  -- OMGE_LINZA_MINING
    [2358] = { stand = 15834, walk = 15818 },  -- OMGE_OZAN_TROLL_READY
    [2359] = { stand = 15836, walk = 15836 },  -- OMGE_BUILDER_SITTING
    [2360] = { stand = 15837, walk = 15837 },  -- OMGE_BUILDER_LEANING
    [2361] = { stand = 15835, walk = 15835 },  -- OMGE_BUILDER_CHILLING
    [2362] = { stand = 15841, walk = 15842, turnLeft = 15841, turnRight = 15841, walkBack = 15842, walkLeft = 15842, walkRight = 15842, walkTurnLeft = 15842, walkTurnRight = 15842 },  -- OMGE_AMOEBA_READY
    [2363] = { stand = 15848, walk = 15777, walkBack = 15777, walkLeft = 15777, walkRight = 15777, walkTurnLeft = 15777, walkTurnRight = 15777 },  -- OMGE_NPC_TALKING_01
    [2364] = { stand = 15849, walk = 15777, walkBack = 15777, walkLeft = 15777, walkRight = 15777, walkTurnLeft = 15777, walkTurnRight = 15777 },  -- OMGE_NPC_TALKING_02
    [2365] = { stand = 15876, walk = 15876 },  -- OMGE_FISHERMAN_READY
    [2366] = { stand = 15847 },  -- OMGE_FARMER_WATERING_PLANTS
    [2367] = { stand = 15850, walk = 15850 },  -- OMGE_FARMER_RAKING
    [2368] = { stand = 15950, walk = 819, run = 824, turnLeft = 15950, turnRight = 15950, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- OMGE_CUTSCENE_SOLDIER_CAUTIOUS_READY
    [2369] = { stand = 15866, walk = 15866 },  -- OMGE_CHILD_IN_WATER_READY
    [2370] = { stand = 15867, walk = 15868, turnLeft = 15867, turnRight = 15867, walkLeft = 15868, walkRight = 15868 },  -- OMGE_CHILD_READY
    [2371] = { stand = 15883, walk = 15883 },  -- OMGE_REFUGEE_WITH_BOWL_ONE_HUNGRY_READY
    [2372] = { stand = 15884, walk = 15884 },  -- OMGE_REFUGEE_WITH_BOWL_TWO_HUNGRY_READY
    [2373] = { stand = 15885, walk = 15885 },  -- OMGE_REFUGEE_WITH_BOWL_THREE_HUNGRY_READY
    [2374] = { stand = 15886, walk = 15886 },  -- OMGE_REFUGEE_WITH_BOWL_FOUR_HUNGRY_READY
    [2375] = { stand = 15887, walk = 15887 },  -- OMGE_REFUGEE_WITH_BOWL_ONE_EATING_READY
    [2376] = { stand = 15888, walk = 15888 },  -- OMGE_REFUGEE_WITH_BOWL_TWO_EATING_READY
    [2377] = { stand = 15889, walk = 15889 },  -- OMGE_REFUGEE_WITH_BOWL_THREE_EATING_READY
    [2378] = { stand = 15890, walk = 15890 },  -- OMGE_REFUGEE_WITH_BOWL_FOUR_EATING_READY
    [2379] = { stand = 15892, walk = 15891, turnLeft = 15891, turnRight = 15891, walkBack = 15891, walkLeft = 15891, walkRight = 15891, walkTurnLeft = 15891, walkTurnRight = 15891 },  -- OMGE_DWARF_AUSTRI_READY
    [2380] = { stand = 16034 },  -- OMGE_SOLDIER_INJURED_A
    [2381] = { stand = 16035 },  -- OMGE_SOLDIER_INJURED_B
    [2382] = { stand = 16036 },  -- OMGE_SOLDIER_INJURED_C
    [2383] = { stand = 16037 },  -- OMGE_SOLDIER_INJURED_D
    [2384] = { stand = 16038 },  -- OMGE_SOLDIER_INJURED_E
    [2385] = { stand = 16039 },  -- OMGE_SOLDIER_INJURED_F
    [2386] = { stand = 16040 },  -- OMGE_SOLDIER_INJURED_G
    [2387] = { stand = 16041 },  -- OMGE_SOLDIER_INJURED_H
    [2388] = { stand = 16042 },  -- OMGE_SOLDIER_INJURED_I
    [2389] = { stand = 37685 },  -- HAVENHYTHE_SANGUINE_HEART_IDLE
    [2390] = { stand = 15987, walk = 15988, turnLeft = 15988, turnRight = 15988 },  -- OMGE_TRAPPED_MINER_FEMALE_READY
    [2391] = { stand = 15989, walk = 15990, turnLeft = 15990, turnRight = 15990 },  -- OMGE_TRAPPED_MINER_READY
    [2392] = { stand = 16051, walk = 16052, turnLeft = 16051, turnRight = 16052 },  -- OMGE_CUTSCENE_TROLL_AMBUSH_ARCHER_STAND_READY
    [2393] = { stand = 808, walk = 819, run = 824, turnLeft = 808, turnRight = 808, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2394] = { stand = 15915 },  -- WOLF_TROLL_TRY_TO_LIGHT_FIRE
    [2395] = { stand = 16005, walk = 16006, turnLeft = 16006, turnRight = 16006, walkLeft = 16006, walkRight = 16006, walkTurnLeft = 16006, walkTurnRight = 16006 },  -- DRUID_READY_UPDATE
    [2396] = { stand = 15919, walk = 15920 },  -- WOLF_TROLL_SCARED_READY
    [2397] = { stand = 15934, walk = 15934 },  -- LTEP_ROLO_READY
    [2398] = { stand = 15935, walk = 15429, turnLeft = 15429, turnRight = 15429, walkTurnLeft = 15429, walkTurnRight = 15429 },  -- LTEP_NAILS_NEWTON_READY
    [2399] = { stand = 16012 },  -- DEATH_SABBOT_MINING
    [2400] = { stand = 13818, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY_VAR
    [2401] = { stand = 16013, walk = 16011, turnLeft = 16011, turnRight = 16011, walkBack = 16011, walkLeft = 16011, walkRight = 16011, walkTurnLeft = 16011, walkTurnRight = 16011 },  -- DEATH_SABBOT_READY
    [2402] = { stand = 16014, walk = 16010, run = 16015, runBack = 16015, runLeft = 16015, runRight = 16015, walkBack = 16010, walkLeft = 16010, walkRight = 16010, runTurnLeft = 16015, runTurnRight = 16015, walkTurnLeft = 16010, walkTurnRight = 16010 },  -- DEATH_TROLL_THE_MAP_READY
    [2403] = { stand = 16027, walk = 16028, turnLeft = 16028, turnRight = 16028, walkBack = 16028, walkLeft = 16028, walkRight = 16028, walkTurnLeft = 16028, walkTurnRight = 16028 },  -- DEATH_FREDA_READY
    [2404] = { walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822, idles = { { 16033, 80 }, { 16032, 20 } } },
    [2405] = { stand = 745, walk = 16071, turnLeft = 745, turnRight = 745, walkBack = 745, walkLeft = 745, walkRight = 745 },  -- HUMAN_MONKEYBARS_READY
    [2406] = { stand = 16013, walk = 8545, turnLeft = 8545, turnRight = 8545, walkBack = 8545, walkLeft = 8545, walkRight = 8545 },  -- DEATH_SABBOT_READY
    [2407] = { stand = 16084, walk = 16085, turnLeft = 16085, turnRight = 16085, walkTurnLeft = 16085, walkTurnRight = 16085 },  -- TZHAAR_2011_YT_HURKOT_READY
    [2408] = { stand = 16155, walk = 16093, turnLeft = 16093, turnRight = 16093, walkTurnLeft = 16093, walkTurnRight = 16093 },  -- TZHAAR_2011_TZ_KIH_READY
    [2409] = { stand = 16156, walk = 16094, turnLeft = 16094, turnRight = 16094, walkTurnLeft = 16094, walkTurnRight = 16094 },  -- TZHAAR_2011_TZ_KIH_READY_NO_SOUND
    [2410] = { stand = 16099, walk = 16100, turnLeft = 16100, turnRight = 16100, walkTurnLeft = 16100, walkTurnRight = 16100 },  -- TZHAAR_2011_YT_MEJKOT_READY
    [2411] = { stand = 16128, walk = 16129, turnLeft = 16129, turnRight = 16129, walkTurnLeft = 16129, walkTurnRight = 16129 },  -- TZHAAR_2011_TOK_XIL_READY
    [2412] = { stand = 16137, walk = 16138, turnLeft = 16138, turnRight = 16138, walkTurnLeft = 16138, walkTurnRight = 16138 },  -- TZHAAR_2011_KET_ZEK_READY
    [2413] = { stand = 16150, walk = 16153, turnLeft = 16153, turnRight = 16153, walkTurnLeft = 16153, walkTurnRight = 16153 },  -- TZHAAR_2011_XIL_READY
    [2414] = { stand = 16166, walk = 16171, turnLeft = 16171, turnRight = 16171, walkTurnLeft = 16171, walkTurnRight = 16171 },  -- TZHAAR_2011_KEK_READY
    [2415] = { stand = 16166, walk = 16170, turnLeft = 16170, turnRight = 16170, walkTurnLeft = 16170, walkTurnRight = 16170 },  -- TZHAAR_2011_KEK_READY
    [2416] = { stand = 16139, walk = 16141, turnLeft = 16141, turnRight = 16141, walkTurnLeft = 16141, walkTurnRight = 16141 },  -- TZHAAR_2011_LAVA_MONSTER_READY
    [2417] = { stand = 16175 },  -- TZHAAR_2011_HURR_MINING_READY
    [2418] = { stand = 16194 },  -- TZHAAR_2011_MEJ_MINING
    [2419] = { stand = 16174 },  -- TZHAAR_2011_HURR_MINE_HEAD_READY
    [2420] = { stand = 16177 },  -- TZHAAR_2011_HURR_SHOPKEEPER_READY
    [2421] = { stand = 16183 },  -- TZHAAR_2011_KET_CHAMPION_THRONE_SITTING
    [2422] = { stand = 16107, walk = 16184, turnLeft = 16184, turnRight = 16184, walkTurnLeft = 16184, walkTurnRight = 16184 },  -- TZHAAR_2011_KET_READY_WITH_WEAPONS
    [2423] = { stand = 16106, walk = 16095, turnLeft = 16095, turnRight = 16095, walkTurnLeft = 16095, walkTurnRight = 16095 },  -- TZHAAR_2011_KET_READY_NO_WEAPONS
    [2424] = { stand = 16107, walk = 16095, turnLeft = 16095, turnRight = 16095, walkTurnLeft = 16095, walkTurnRight = 16095 },  -- TZHAAR_2011_KET_READY_WITH_WEAPONS
    [2425] = { stand = 16125, walk = 16126, turnLeft = 16126, turnRight = 16126, walkTurnLeft = 16126, walkTurnRight = 16126 },  -- TZHAAR_2011_MEJ_READY
    [2426] = { stand = 16176, walk = 16097, turnLeft = 16097, turnRight = 16097, walkTurnLeft = 16097, walkTurnRight = 16097 },  -- TZHAAR_2011_HURR_READY
    [2427] = { stand = 16161, walk = 16162, turnLeft = 16162, turnRight = 16162, walkTurnLeft = 16162, walkTurnRight = 16162 },  -- TZHAAR_2011_KET_DILL_READY
    [2428] = { stand = 16218, walk = 16219, run = 16223, turnLeft = 16219, turnRight = 16219, runTurnLeft = 16223, runTurnRight = 16223, walkTurnLeft = 16219, walkTurnRight = 16219 },  -- TZHAAR2_JALYT_GAAL_READY
    [2429] = { stand = 16224, walk = 16221, run = 16225, turnLeft = 16221, turnRight = 16221, runTurnLeft = 16225, runTurnRight = 16225, walkTurnLeft = 16221, walkTurnRight = 16221 },  -- TZHAAR2_JALYT_GAAL_KOT_IN_PAIN_IDLE
    [2430] = { stand = 16261, walk = 16263, run = 16262, turnLeft = 16263, turnRight = 16263, runTurnLeft = 16262, runTurnRight = 16262, walkTurnLeft = 16263, walkTurnRight = 16263 },  -- TZHAAR2_JALYT_GAAL_RING_READY
    [2431] = { stand = 16191, walk = 16192, turnLeft = 16192, turnRight = 16192, walkTurnLeft = 16192, walkTurnRight = 16192 },  -- TZHAAR_2011_MEJ_HOLDING_CRYSTAL_ORB_READY
    [2432] = { stand = 16190, walk = 16154, turnLeft = 16154, turnRight = 16154, walkTurnLeft = 16154, walkTurnRight = 16154 },  -- TZHAAR_2011_TOR_JAD_READY
    [2433] = { stand = 16207, walk = 16208, turnLeft = 16208, turnRight = 16208, walkTurnLeft = 16208, walkTurnRight = 16208 },  -- TZHAAR_2011_TOKHAAR_HOK_READY
    [2434] = { stand = 16233, walk = 16233, turnLeft = 16233, turnRight = 16233, walkTurnLeft = 16233, walkTurnRight = 16233 },  -- TZHAAR2_TOKHAAR_SQUID_BOSS_READY
    [2435] = { stand = 16237, walk = 16237, turnLeft = 16237, turnRight = 16237, walkTurnLeft = 16237, walkTurnRight = 16237 },  -- TZHAAR2_TOKHAAR_SQUID_BOSS_TENTACLE_READY
    [2436] = { stand = 16257, walk = 16257, turnLeft = 16257, turnRight = 16257, walkTurnLeft = 16257, walkTurnRight = 16257 },  -- TZHAAR2_TOKHAAR_SQUID_BOSS_MAGIC_TENTACLE_READY
    [2437] = { stand = 16310, walk = 16309, turnLeft = 16309, turnRight = 16309, walkLeft = 16309, walkRight = 16309, walkTurnLeft = 16309, walkTurnRight = 16309 },  -- DOM_RUNEFEST_BOSS_READY
    [2438] = { stand = 16327, walk = 16327, turnLeft = 16327, turnRight = 16327, walkLeft = 16327, walkRight = 16327, walkTurnLeft = 16327, walkTurnRight = 16327 },  -- DOM_RUNEFEST_BOSS_FLYING_NULL
    [2439] = { stand = 16336, walk = 16336 },  -- OMGE_MARKET_SELLER_READY_B_SILENT
    [2440] = { stand = 16335, walk = 15794 },  -- OMGE_THEIF_SITTING_READY_C_SILENT
    [2441] = { walk = 16338, run = 16341, turnLeft = 16338, turnRight = 16338, walkBack = 16342, walkLeft = 16338, walkRight = 16338, idles = { { 16343, 200 }, { 16344, 45 }, { 16345, 10 } } },
    [2442] = { walk = 16346, run = 16347, turnLeft = 16346, turnRight = 16346, walkBack = 16353, walkLeft = 16346, walkRight = 16346, idles = { { 16350, 200 }, { 16351, 45 }, { 16352, 10 } } },
    [2443] = { stand = 4472, walk = 4473 },  -- EYEGLO_FLUFFIE_READY
    [2444] = { stand = 16367, walk = 37952 },  -- GNOME_CL_READY
    [2445] = { walk = 16358, idles = { { 16367, 225 }, { 16368, 30 } } },
    [2446] = { walk = 16359, idles = { { 16367, 225 }, { 16368, 30 } } },
    [2447] = { stand = 16397 },  -- SNIPER_MAMI_RIMBA_READY
    [2448] = { stand = 16430, walk = 16427, turnLeft = 16427, turnRight = 16427, walkLeft = 16427, walkRight = 16427, walkTurnLeft = 16427, walkTurnRight = 16427 },  -- CHICKEN_UPDATE_READY
    [2449] = { stand = 16430, walk = 16427, turnLeft = 16427, turnRight = 16427, walkLeft = 16427, walkRight = 16427, walkTurnLeft = 16427, walkTurnRight = 16427 },  -- CHICKEN_UPDATE_READY
    [2450] = { stand = 16430 },  -- CHICKEN_UPDATE_READY
    [2451] = { stand = 7760 },  -- LORE_COCKATRICE_READY
    [2452] = { walk = 16454, idles = { { 16453, 80 }, { 8707, 20 } } },
    [2453] = { stand = 16547 },  -- FREMSAGA_UNHOLY_CURSEBEARER_UNCONSCIOUS
    [2454] = { stand = 16489 },  -- FREMSAGA_SLAVE_SCARED
    [2455] = { stand = 16477 },  -- FREMSAGA_MOIA_DYING_POSE
    [2456] = { stand = 16479, walk = 16479 },  -- FREMSAGA_MOIA_LEVITATING
    [2457] = { stand = 16546 },  -- HUMAN_DEATH_HOLD
    [2458] = { stand = 16555 },  -- FREMSAGA_MOIA_YOUNG_SPEAKING_TO_DEVICE_MIDDLE
    [2459] = { stand = 16558 },  -- FREMSAGA_MOIA_OLD_SPEAKING_TO_DEVICE_MIDDLE
    [2460] = { stand = 16561 },  -- FREMSAGA_NECROLORD_SPEAKING_TO_DEVICE_MIDDLE
    [2461] = { stand = 16520 },  -- FREMSAGA_MOIA_AS_MERCHANT_TELEPORT_MIDDLE_READY
    [2462] = { stand = 16524 },  -- FREMSAGA_MOIA_TELEPORT_MIDDLE_READY
    [2463] = { stand = 16513 },  -- FREMSAGA_FORGOTTEN_WARRIOR_TELEPORT_MIDDLE_READY
    [2464] = { stand = 16517 },  -- FREMSAGA_MERCHANT_BEING_TELEPORT_ATTACK_MIDDLE_READY
    [2465] = { stand = 16510 },  -- FREMSAGA_FORGOTTEN_WARRIOR_BEING_TELEPORT_ATTACK_READY
    [2466] = { stand = 16529 },  -- FREMSAGA_NECROLORD_BEING_TELEPORT_ATTACK_MIDDLE_READY
    [2467] = { stand = 16480, walk = 16482, run = 824, turnLeft = 16482, turnRight = 16482, walkBack = 16482, walkLeft = 16482, walkRight = 16482, walkTurnLeft = 16482, walkTurnRight = 16482 },  -- FREMSAGA_MOIA_READY
    [2468] = { stand = 16480, walk = 16483, turnLeft = 16483, turnRight = 16483, walkBack = 16483, walkLeft = 16483, walkRight = 16483, walkTurnLeft = 16483, walkTurnRight = 16483 },  -- FREMSAGA_MOIA_READY
    [2469] = { stand = 16473, walk = 16474, turnLeft = 16474, turnRight = 16474, walkBack = 16474, walkLeft = 16474, walkRight = 16474, walkTurnLeft = 16474, walkTurnRight = 16474 },  -- FREMSAGA_MERCHANT_READY
    [2470] = { stand = 16499, walk = 16500, turnLeft = 16500, turnRight = 16500, walkBack = 16500, walkLeft = 16500, walkRight = 16500, walkTurnLeft = 16500, walkTurnRight = 16500 },  -- FREMSAGA_MAH_BILRACH_FRAIL_READY
    [2471] = { stand = 10432, walk = 16588, turnLeft = 16588, turnRight = 16588, walkBack = 16588, walkLeft = 16588, walkRight = 16588, walkTurnLeft = 16588, walkTurnRight = 16588 },  -- ZEMO_ZEMOUREGAL_READY
    [2472] = { stand = 11292, walk = 16586, walkBack = 16586, walkLeft = 16586, walkRight = 16586, walkTurnLeft = 16586, walkTurnRight = 16586 },  -- MAHJARRAT_2010_LUC2_LUCIEN_READY
    [2473] = { stand = 26551, walk = 26551, turnLeft = 26551, turnRight = 26551 },  -- MTXBEACH_PLAYER_DUMBELL_IDLE
    [2474] = { stand = 813, walk = 16456, run = 16457, turnLeft = 16456, turnRight = 16456, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [2475] = { stand = 15069, walk = 16464, run = 16462, turnLeft = 16460, turnRight = 16460, walkBack = 15075, walkLeft = 15076, walkRight = 15077 },  -- _7W_HUMAN_READY_2010_DRAGON_SCIMITAR
    [2476] = { stand = 15069, walk = 16465, run = 16463, turnLeft = 16461, turnRight = 16461, walkBack = 15075, walkLeft = 15076, walkRight = 15077 },  -- _7W_HUMAN_READY_2010_DRAGON_SCIMITAR
    [2477] = { walk = 16569, run = 16570, turnLeft = 16083, turnRight = 16082, walkLeft = 16083, walkRight = 16082, walkTurnLeft = 16569, walkTurnRight = 16569, idles = { { 16567, 80 }, { 16568, 20 } } },
    [2478] = { stand = 16572, walk = 16572 },  -- RCSIPHONXP_RUNESPHERE_LVL_1_READY
    [2479] = { stand = 16573, walk = 16573 },  -- RCSIPHONXP_RUNESPHERE_LVL_2_READY
    [2480] = { stand = 16574, walk = 16574 },  -- RCSIPHONXP_RUNESPHERE_LVL_3_READY
    [2481] = { stand = 16575, walk = 16575 },  -- RCSIPHONXP_RUNESPHERE_LVL_4_READY
    [2482] = { stand = 16576, walk = 16576 },  -- RCSIPHONXP_RUNESPHERE_LVL_5_READY
    [2483] = { stand = 16577, walk = 16577 },  -- RCSIPHONXP_RUNESPHERE_LVL_6_READY
    [2484] = { stand = 16578, walk = 16578 },  -- RCSIPHONXP_RUNESPHERE_LVL_7_READY
    [2485] = { stand = 16579, walk = 16579 },  -- RCSIPHONXP_RUNESPHERE_LVL_8_READY
    [2486] = { stand = 16580, walk = 16580 },  -- RCSIPHONXP_RUNESPHERE_LVL_9_READY
    [2487] = { stand = 16581, walk = 16581 },  -- RCSIPHONXP_RUNESPHERE_LVL_10_READY
    [2488] = { stand = 16582, walk = 16582 },  -- RCSIPHONXP_RUNESPHERE_LVL_11_READY
    [2489] = { stand = 16583, walk = 16583 },  -- RCSIPHONXP_RUNESPHERE_LVL_12_READY
    [2490] = { stand = 16584, walk = 16584 },  -- RCSIPHONXP_RUNESPHERE_LVL_13_READY
    [2491] = { stand = 16585, walk = 16585 },  -- RCSIPHONXP_RUNESPHERE_LVL_14_READY
    [2492] = { stand = 808, walk = 16458, run = 16459, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2493] = { stand = 16595, walk = 16595 },  -- RCSIPHONXP_RUNESPHERE_BEAM_LIGHTBALL_READY
    [2494] = { stand = 16642, walk = 16643, turnLeft = 16643, turnRight = 16643, walkTurnLeft = 16643, walkTurnRight = 16643 },  -- RCSIPHONXP_ESSWRAITH_READY
    [2495] = { stand = 16659, walk = 16660, turnLeft = 16660, turnRight = 16660, walkTurnLeft = 16660, walkTurnRight = 16660 },  -- RCSIPHONXP_ESSHOUND_READY
    [2496] = { stand = 16652, walk = 16652 },  -- RCSIPHONXP_PLAYER_AIR_READY
    [2497] = { stand = 16679, walk = 16679, turnLeft = 16679, turnRight = 16679, walkTurnLeft = 16679, walkTurnRight = 16679 },  -- RCSIPHONXP_FLOATING_RUNE_ESSENCE_WALK
    [2498] = { stand = 16701 },  -- BONFIRE_PLAYER_WARMING_HANDS
    [2499] = { stand = 16780, crawl = 16781, turnLeft = 16781, turnRight = 16781, crawlTurnLeft = 16781, crawlTurnRight = 16781 },  -- QBD1_PARASITE_TIER1_READY
    [2500] = { stand = 16786, crawl = 16787, turnLeft = 16787, turnRight = 16787, crawlTurnLeft = 16787, crawlTurnRight = 16787 },  -- QBD1_PARASITE_TIER2_READY
    [2501] = { stand = 16791, crawl = 16792, turnLeft = 16792, turnRight = 16792, crawlTurnLeft = 16792, crawlTurnRight = 16792 },  -- QBD1_PARASITE_TIER3_READY
    [2502] = { stand = 16715 },  -- QBD2_QBD_READY
    [2503] = { stand = 16716 },  -- QBD2_QBD_SLEEPING_IDLE
    [2504] = { stand = 16857 },  -- DJUB_GUARD_READY
    [2505] = { idles = { { 16772, 90 }, { 16773, 10 } } },
    [2506] = { stand = 16808 },  -- QBD1_SIREN_IN_BLISTER_IDLE
    [2507] = { stand = 16807 },  -- QBD1_SIREN_IDLE
    [2508] = { stand = 16819, walk = 16819, turnLeft = 16819, turnRight = 16819, walkTurnLeft = 16819, walkTurnRight = 16819 },  -- QBD1_MYNOCKS_IDLE
    [2509] = { idles = { { 16830, 90 }, { 16831, 10 } } },
    [2510] = { idles = { { 16832, 90 }, { 16833, 10 } } },
    [2511] = { stand = 16834, walk = 15428, turnLeft = 15428, turnRight = 15428, walkBack = 15428, walkLeft = 15428, walkRight = 15428 },  -- QBD1_LUCILLE_READY
    [2512] = { stand = 13517, walk = 15429, turnLeft = 15429, turnRight = 15429, walkBack = 15429, walkLeft = 15429, walkRight = 15429 },  -- AGIDAD_SCOUT_READY
    [2513] = { stand = 808, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2514] = { stand = 16883, walk = 16884 },  -- CRUC_SOUL_READY
    [2515] = { idles = { { 16872, 95 }, { 16875, 5 } } },
    [2516] = { idles = { { 16873, 120 }, { 16875, 5 } } },
    [2517] = { idles = { { 16874, 120 }, { 1233, 5 } } },
    [2518] = { idles = { { 16888, 90 }, { 16889, 10 } } },
    [2519] = { idles = { { 16909, 90 }, { 16910, 10 } } },
    [2520] = { idles = { { 16924, 20 }, { 16911, 80 } } },
    [2521] = { idles = { { 16907, 90 }, { 16908, 10 } } },
    [2522] = { idles = { { 16905, 90 }, { 16906, 10 } } },
    [2523] = { stand = 16897, walk = 16899, run = 16898 },  -- DJUB_CORGI_READY
    [2524] = { stand = 16885, walk = 16887, crawl = 16886 },  -- DJUB_CARRIAGE_READY
    [2525] = { stand = 16895, crawl = 16895 },  -- DJUB_HORSE_CARRIAGE_CRAWL
    [2526] = { stand = 16895, crawl = 16896 },  -- DJUB_HORSE_CARRIAGE_CRAWL
    [2527] = { stand = 16906 },  -- DJUB_SHAKENSPEARE_READY_EXTRA_A
    [2528] = { stand = 16902 },  -- DJUB_MINNI_COOP_CORGI_CUDDLE
    [2529] = { stand = 16901, walk = 16901 },  -- DJUB_CORGI_CUDDLE
    [2530] = { stand = 16900, walk = 16900, run = 16900 },  -- DJUB_DRAGON_A_FLYPAST
    [2531] = { stand = 16903, walk = 16903, run = 16903 },  -- DJUB_DRAGON_B_FLYPAST
    [2532] = { stand = 16904, walk = 16904, run = 16904 },  -- DJUB_DRAGON_C_FLYPAST
    [2533] = { stand = 16925 },  -- CLAN_TRAILER_CLAPPING_AND_CHEERING_A
    [2534] = { stand = 16926 },  -- CLAN_TRAILER_CLAPPING_AND_CHEERING_B
    [2535] = { stand = 16927 },  -- CLAN_TRAILER_CLAPPING_AND_CHEERING_C
    [2536] = { stand = 16928 },  -- CLAN_TRAILER_CLAPPING_AND_CHEERING_D
    [2537] = { stand = 16881 },  -- CLAN_PARTY_ROOM_STOOL_SITTING_READY
    [2538] = { turnLeft = 16938, turnRight = 16938, idles = { { 16936, 90 }, { 16937, 10 } } },
    [2539] = { stand = 16883, walk = 16884 },  -- CRUC_SOUL_READY
    [2540] = { stand = 16948, walk = 16949 },  -- CRUC_SOUL_READY_WEAKEN
    [2541] = { stand = 16991, walk = 16992, run = 28434, turnLeft = 16992, turnRight = 16992, walkLeft = 16992, walkRight = 16992, walkTurnLeft = 16992, walkTurnRight = 16992 },  -- GREATER_DEMON_2011_READY
    [2542] = { stand = 16993, crawl = 16994, crawlLeft = 16994, crawlRight = 16994, turnLeft = 16993, turnRight = 16993, crawlTurnLeft = 16994, crawlTurnRight = 16994 },  -- CARNI_LADY_CARNILLEAN_IDLE
    [2543] = { stand = 16995, walk = 16996, turnLeft = 16995, turnRight = 16995, walkLeft = 16996, walkRight = 16996, walkTurnLeft = 16996, walkTurnRight = 16996 },  -- CARNI_LORD_CARNILLEAN_IDLE
    [2544] = { stand = 16997, walk = 16998, run = 17008, turnLeft = 16998, turnRight = 16998, walkLeft = 16998, walkRight = 16998, walkTurnLeft = 16998, walkTurnRight = 16998 },  -- CARNI_ADOLESCENT_WOLF_READY
    [2545] = { stand = 17011, walk = 17012, turnLeft = 17012, turnRight = 17012, walkLeft = 16998, walkRight = 16998, walkTurnLeft = 16998, walkTurnRight = 16998 },  -- CARNI_ADULT_WOLF_READY
    [2546] = { stand = 17036, walk = 17037, run = 17038 },  -- CARNI_CHILD_READY
    [2547] = { stand = 17051, walk = 17037, run = 17038, turnLeft = 17037, turnRight = 17037, walkLeft = 17037, walkRight = 17037, walkTurnLeft = 17037, walkTurnRight = 17037 },  -- CARNI_PHILIPE_SWORD_READY
    [2548] = { stand = 17052, walk = 17053, run = 17054, turnLeft = 17053, turnRight = 17053, walkLeft = 17053, walkRight = 17053, walkTurnLeft = 17053, walkTurnRight = 17053 },  -- CARNI_CLAUS_READY
    [2549] = { stand = 17060, walk = 17060 },  -- CARNI_CLAUS_PASSED_OUT_READY
    [2550] = { stand = 17062, walk = 17063, run = 17069, turnLeft = 17063, turnRight = 17063, walkTurnLeft = 17063, walkTurnRight = 17063 },  -- CARNI_SARSAPARILLA_IDLE
    [2551] = { stand = 17066, walk = 17066 },  -- CARNI_SARSAPARILLA_TIED_READY
    [2552] = { stand = 17107, walk = 17107 },  -- MTX_PEGASUS_HOME_TELEPORT
    [2553] = { stand = 813, walk = 1205, run = 1210, turnLeft = 1205, turnRight = 1205, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [2554] = { stand = 15069, walk = 15073, run = 15070, turnLeft = 12024, turnRight = 12024, walkBack = 15075, walkLeft = 15076, walkRight = 15077 },  -- _7W_HUMAN_READY_2010_DRAGON_SCIMITAR
    [2555] = { stand = 15069, walk = 15073, run = 15070, turnLeft = 12024, turnRight = 12024, walkBack = 15075, walkLeft = 15076, walkRight = 15077 },  -- _7W_HUMAN_READY_2010_DRAGON_SCIMITAR
    [2556] = { stand = 4591, walk = 4226, run = 4228, turnLeft = 823, turnRight = 823, walkBack = 4227, walkLeft = 821, walkRight = 822 },  -- XBOWS_HUMAN_READY
    [2557] = { stand = 17120, walk = 17120 },  -- MTX_ACHIEVEMENT_BANNER_2012_READY
    [2574] = { stand = 7047, walk = 7046, run = 7039, turnLeft = 7040, turnRight = 7040, walkBack = 7045, walkLeft = 7044, walkRight = 7043 },  -- DH_SWORD_UPDATE_READY
    [2575] = { stand = 17205, walk = 17207, run = 17206, turnLeft = 17207, turnRight = 17207, walkBack = 17207, walkLeft = 17207, walkRight = 17207 },  -- WOF13_PLAYER_WATER_BALLOON_READY
    [2576] = { walk = 17197, crawl = 17197, crawlBack = 17197, crawlLeft = 17197, crawlRight = 17197, run = 17197, runBack = 17197, runLeft = 17197, runRight = 17197, turnLeft = 17197, turnRight = 17197, walkBack = 17197, walkLeft = 17197, walkRight = 17197 },
    [2577] = { stand = 17216, walk = 17217, turnLeft = 17217, turnRight = 17217, walkTurnLeft = 17217, walkTurnRight = 17217 },  -- PENG_POW_WALRUS_READY
    [2578] = { stand = 808, walk = 17226, turnLeft = 17226, turnRight = 17226, walkTurnLeft = 17226, walkTurnRight = 17226 },  -- HUMAN_READY
    [2579] = { stand = 17233, walk = 17234, turnLeft = 17234, turnRight = 17234, walkTurnLeft = 17234, walkTurnRight = 17234 },  -- PENG_POW_LARRY_WITH_EGG_READY
    [2580] = { stand = 15109, walk = 17228, turnLeft = 17228, turnRight = 17228, walkTurnLeft = 17228, walkTurnRight = 17228 },  -- XMAS10_SEAL_READY
    [2581] = { stand = 17220, walk = 17220 },  -- PENG_POW_SEAL_SLEEPING_A
    [2582] = { stand = 17221, walk = 17221 },  -- PENG_POW_SEAL_SLEEPING_B
    [2583] = { stand = 808, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2584] = { stand = 808, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2585] = { stand = 813, walk = 1205, run = 1210, turnLeft = 1205, turnRight = 1205, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [2586] = { stand = 813, walk = 1205, run = 1210, turnLeft = 1205, turnRight = 1205, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [2587] = { stand = 813, walk = 15073, run = 1210, turnLeft = 1209, turnRight = 1209, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [2588] = { stand = 808, walk = 819, run = 9754, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2589] = { stand = 17252, walk = 17260, run = 17258, runBack = 17258, runLeft = 17258, runRight = 17258, turnLeft = 17252, turnRight = 17252, walkBack = 17260, walkLeft = 17260, walkRight = 17260, runTurnLeft = 17258, runTurnRight = 17258, walkTurnLeft = 17260, walkTurnRight = 17260 },  -- CLAV_AVATAR_READY
    [2590] = { stand = 5720, walk = 19738, run = 1478, turnLeft = 19738, turnRight = 19738, walkBack = 19738, walkLeft = 19738, walkRight = 19738, walkTurnLeft = 19738, walkTurnRight = 19738 },  -- PENG_POLAR_BEAR_READY
    [2591] = { stand = 17302, walk = 819 },  -- MTX_BATCH6_PLAYER_ON_HANDED_HANDSTAND_REST_LOOP
    [2592] = { idles = { { 17326, 10 }, { 17325, 90 } } },
    [2593] = { walk = 17337, turnLeft = 17337, turnRight = 17337, walkLeft = 17337, walkRight = 17337, walkTurnLeft = 17337, walkTurnRight = 17337, idles = { { 17335, 90 }, { 17336, 10 } } },
    [2594] = { stand = 17339, walk = 17339 },  -- BIGCHINCHOMPA_GIANT_CHINCHOMPA_SLEEPING
    [2595] = { stand = 12914, walk = 17724, turnLeft = 17724, turnRight = 17724, walkBack = 17724, walkLeft = 17724, walkRight = 17724 },  -- OZAN1_HASSAN_READY
    [2596] = { stand = 17508, walk = 17510, turnLeft = 17510, turnRight = 17510, walkTurnLeft = 17510, walkTurnRight = 17510 },  -- OGRE_2012_READY
    [2597] = { stand = 17509, walk = 17510, turnLeft = 17510, turnRight = 17510, walkTurnLeft = 17510, walkTurnRight = 17510 },  -- OGRE_2012_READY_VAR
    [2598] = { stand = 17469, walk = 17470, turnLeft = 17470, turnRight = 17470, walkTurnLeft = 17470, walkTurnRight = 17470 },  -- CYCLOPS_2012_READY
    [2599] = { stand = 17474, walk = 17475, turnLeft = 17475, turnRight = 17475, walkTurnLeft = 17475, walkTurnRight = 17475 },  -- ORK_2012_READY
    [2600] = { stand = 17479, walk = 17480, turnLeft = 17480, turnRight = 17480, walkTurnLeft = 17480, walkTurnRight = 17480 },  -- GORAK_2012_READY
    [2601] = { stand = 17484, walk = 17485, turnLeft = 17485, turnRight = 17485, walkTurnLeft = 17485, walkTurnRight = 17485 },  -- CENTAUR_2012_READY
    [2602] = { stand = 17489, walk = 17490, run = 24479, turnLeft = 17490, turnRight = 17490, walkTurnLeft = 17490, walkTurnRight = 17490 },  -- FIEND_2012_READY
    [2603] = { stand = 17497, walk = 17495, turnLeft = 17495, turnRight = 17495, walkTurnLeft = 17495, walkTurnRight = 17495 },  -- UNICORN_2012_READY
    [2604] = { stand = 17502, walk = 17503, turnLeft = 17503, turnRight = 17503, walkTurnLeft = 17503, walkTurnRight = 17503 },  -- HOBGOBLIN_2012_READY
    [2605] = { stand = 17458, walk = 17457, turnLeft = 17457, turnRight = 17457, walkTurnLeft = 17457, walkTurnRight = 17457 },  -- BLACK_DEMON_2011_READY
    [2606] = { stand = 17466, walk = 17467, turnLeft = 17467, turnRight = 17467, walkTurnLeft = 17467, walkTurnRight = 17467 },  -- RED_DEMON_2011_READY
    [2607] = { stand = 17387, walk = 17388, turnLeft = 17388, turnRight = 17388, walkTurnLeft = 17388, walkTurnRight = 17388 },  -- GODWARS_GENERAL_GRAARDOR_2012_READY
    [2608] = { stand = 17393, walk = 17394, turnLeft = 17394, turnRight = 17394, walkTurnLeft = 17394, walkTurnRight = 17394 },  -- GODWARS_KREE_ARRA_2012_READY
    [2609] = { stand = 17399, turnLeft = 17399, turnRight = 17399 },  -- GODWARS_NEX_MAGE_2012_READY
    [2610] = { stand = 17404, walk = 17405, run = 17405, turnLeft = 17404, turnRight = 17404, runTurnLeft = 17405, runTurnRight = 17405, walkTurnLeft = 17405, walkTurnRight = 17405 },  -- GODWARS_NEX_2012_READY
    [2611] = { stand = 17416, walk = 17417, turnLeft = 17417, turnRight = 17417, walkTurnLeft = 17417, walkTurnRight = 17417 },  -- GODWARS_GROWLER_2012_READY
    [2612] = { stand = 17422, walk = 17423, turnLeft = 17423, turnRight = 17423, walkTurnLeft = 17423, walkTurnRight = 17423 },  -- GODWARS_SPIRITUAL_ORK_RANGED_2012_READY
    [2613] = { stand = 17426, walk = 17427, turnLeft = 17427, turnRight = 17427, walkTurnLeft = 17427, walkTurnRight = 17427 },  -- GODWARS_SPIRITUAL_ORK_MAGE_2012_READY
    [2614] = { stand = 17432, walk = 17433, run = 28439, turnLeft = 17433, turnRight = 17433, walkTurnLeft = 17433, walkTurnRight = 17433 },  -- GODWARS_BLOODVELD_2012_READY
    [2615] = { stand = 17437, walk = 17438, turnLeft = 17438, turnRight = 17438, walkTurnLeft = 17438, walkTurnRight = 17438 },  -- GODWARS_ZAKLN_GRITCH_2012_READY
    [2616] = { stand = 17442, walk = 17442, turnLeft = 17442, turnRight = 17442, walkTurnLeft = 17442, walkTurnRight = 17442 },  -- GODWARS_AVIANSIE_2012_READY
    [2617] = { stand = 17455, walk = 17455, crawl = 17455 },  -- GODWARS_NATURE_SPIRIT_2012_READY
    [2618] = { stand = 6539, walk = 17456, turnLeft = 17456, turnRight = 17456, walkTurnLeft = 17456, walkTurnRight = 17456 },  -- WEREWOLF_UPDATE_READY
    [2619] = { stand = 17349, walk = 17350, run = 28437, turnLeft = 17350, turnRight = 17350, walkBack = 17350, walkLeft = 17350, walkRight = 17350 },  -- HELLHOUND_2011_UPDATE_READY
    [2620] = { idles = { { 14725, 80 }, { 17516, 20 } } },
    [2621] = { stand = 17515 },  -- ROMCOM_DORORAN_NORMAL_READY
    [2622] = { stand = 813, walk = 1205, run = 824, turnLeft = 823, turnRight = 823, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [2623] = { stand = 17535 },  -- BOTOFF_BOTFINDER_GENERAL_READY
    [2624] = { stand = 17534 },  -- BOTOFF_CRYER_READY
    [2625] = { stand = 17546 },  -- BOTOFF_CRYER_READY_EXTRA
    [2626] = { stand = 17522 },  -- BOTOFF_PLAYER_PUNISHMENT_READY
    [2627] = { stand = 17542 },  -- BOTOFF_DRAGON_CRUSHES_BOT
    [2628] = { stand = 17544 },  -- DRAGON_PICKS_UP_BOT
    [2629] = { stand = 4591, walk = 4226, run = 4228, walkBack = 4227, walkLeft = 4226, walkRight = 4226 },  -- XBOWS_HUMAN_READY
    [2630] = { stand = 17572, walk = 17570 },  -- OZAN2_KALPHITE_LARVAE_DUNG_BALL_READY
    [2631] = { stand = 17572, walk = 17570 },  -- OZAN2_KALPHITE_LARVAE_DUNG_BALL_READY
    [2632] = { stand = 17714, walk = 17650, turnLeft = 17650, turnRight = 17650, walkBack = 17650, walkLeft = 17650, walkRight = 17650 },  -- OZAN1_HERU_COMBAT_READY
    [2633] = { stand = 17708, walk = 17656, turnLeft = 17656, turnRight = 17656, walkBack = 17656, walkLeft = 17656, walkRight = 17656 },  -- OZAN1_APEP_COMBAT_READY
    [2634] = { stand = 17703 },  -- OZAN2_ALI_READY_KNEELING_READY
    [2635] = { stand = 1017, walk = 1017 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_A
    [2636] = { stand = 17550, walk = 17550 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_B
    [2637] = { stand = 17551, walk = 17551 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_C
    [2638] = { stand = 17552, walk = 17552 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_D
    [2639] = { stand = 17553, walk = 17553 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_E
    [2640] = { stand = 17554, walk = 17554 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_F
    [2641] = { stand = 17555, walk = 17555 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_G
    [2642] = { stand = 17556, walk = 17556 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_H
    [2643] = { stand = 17557, walk = 17557 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_I
    [2644] = { stand = 17558, walk = 17558 },  -- OZAN2_PLAYER_SINK_IN_QUICKSAND_J
    [2645] = { stand = 17623, walk = 17624, turnLeft = 17624, turnRight = 17624, walkBack = 17624, walkLeft = 17624, walkRight = 17624 },  -- OZAN1_PLAYER_HOLD_DIAMOND_READY
    [2646] = { stand = 17649, walk = 17650, turnLeft = 17650, turnRight = 17650, walkBack = 17650, walkLeft = 17650, walkRight = 17650 },  -- OZAN1_HERU_READY
    [2647] = { stand = 17657, walk = 17656, turnLeft = 17656, turnRight = 17656, walkBack = 17656, walkLeft = 17656, walkRight = 17656 },  -- OZAN1_APEP_READY
    [2648] = { stand = 17662, walk = 17663, turnLeft = 17663, turnRight = 17663, walkBack = 17663, walkLeft = 17663, walkRight = 17663 },  -- OZAN1_ALI_READY_TORN_CLOTHING
    [2649] = { stand = 17664, walk = 17663, turnLeft = 17663, turnRight = 17663, walkBack = 17663, walkLeft = 17663, walkRight = 17663 },  -- OZAN2_ALI_READY_OPULENT_CLOTHING
    [2650] = { stand = 17665 },  -- OZAN2_ALI_READY_KNEELING
    [2651] = { stand = 17654, walk = 17655, turnLeft = 17655, turnRight = 17655, walkBack = 17655, walkLeft = 17655, walkRight = 17655 },  -- OZAN1_LEELA_READY
    [2652] = { stand = 17647 },  -- OZAN1_MEXICAN_STANDOFF
    [2653] = { stand = 17630 },  -- OZAN1_LEELA_MEXICAN_STANDOFF
    [2654] = { stand = 17666, walk = 17723, turnLeft = 17723, turnRight = 17723, walkBack = 17723, walkLeft = 17723, walkRight = 17723 },  -- OZAN1_JABARI_READY
    [2655] = { stand = 17667, walk = 17668, turnLeft = 17668, turnRight = 17668, walkBack = 17668, walkLeft = 17668, walkRight = 17668 },  -- OZAN1_OSMAN_READY
    [2656] = { stand = 17678 },  -- OZAN1_EMIR_IDLE
    [2657] = { stand = 17722 },  -- OZAN1_EMIR_DEATH_POSE
    [2658] = { stand = 17687 },  -- OZAN1_KHUNM_READY
    [2659] = { stand = 808, walk = 17688, run = 824, turnLeft = 823, turnRight = 823, walkBack = 17688, walkLeft = 17688, walkRight = 17688 },  -- HUMAN_READY
    [2660] = { stand = 808, walk = 17689, run = 824, turnLeft = 823, turnRight = 823, walkBack = 17689, walkLeft = 17689, walkRight = 17689 },  -- HUMAN_READY
    [2661] = { stand = 17686 },  -- OZAN2_OZAN_SNEAKY_READY
    [2662] = { stand = 17682 },  -- OZAN1_APEP_READY_HOLDING_ALI
    [2663] = { stand = 17683 },  -- OZAN1_ALI_READY_HELD_BY_APEP
    [2664] = { stand = 17702 },  -- OZAN1_ALI_READY_HELD_BY_APEP_B
    [2665] = { stand = 17697 },  -- OZAN2_POPINJAY_PARROT_READY
    [2666] = { stand = 17698 },  -- OZAN1_MERC_BAR_BODYGUARD_READY
    [2667] = { stand = 17718 },  -- OZAN1_MERC_BAR_VAR1_READY
    [2668] = { stand = 17719 },  -- OZAN1_MERC_BAR_VAR2_READY
    [2669] = { stand = 17720 },  -- OZAN1_MERC_BAR_VAR3_READY
    [2670] = { stand = 17635 },  -- OZAN1_KHNUM_PINNED_TO_WALL_READY
    [2671] = { stand = 4179, walk = 4178, turnLeft = 823, turnRight = 823 },  -- BALANCE_READY
    [2672] = { stand = 17837, crawl = 17838, crawlLeft = 17838, crawlRight = 17838, turnLeft = 17838, turnRight = 17838, crawlTurnLeft = 17838, crawlTurnRight = 17838 },  -- PNR_DORIC_IDLE
    [2673] = { stand = 17835, walk = 17836, turnLeft = 17836, turnRight = 17836, walkLeft = 17836, walkRight = 17836, walkTurnLeft = 17836, walkTurnRight = 17836 },  -- PNR_BORIC_IDLE
    [2674] = { stand = 16027, walk = 16028, turnLeft = 16028, turnRight = 16028, walkLeft = 16028, walkRight = 16028, walkTurnLeft = 16028, walkTurnRight = 16028 },  -- DEATH_FREDA_READY
    [2675] = { stand = 17844, walk = 21346, run = 21337, turnLeft = 21346, turnRight = 21346, walkLeft = 21346, walkRight = 21346, walkTurnLeft = 21346, walkTurnRight = 21346 },  -- PNR_GENERIC_DWARF_IDLE
    [2676] = { idles = { { 17844, 30 }, { 17847, 70 } } },
    [2677] = { idles = { { 17844, 40 }, { 17847, 60 } } },
    [2678] = { idles = { { 17844, 50 }, { 17847, 50 } } },
    [2679] = { stand = 17814, walk = 17838 },  -- PNR_CUTSCENE_DORIC_ESTABLISHING
    [2680] = { stand = 17856, walk = 17855, turnLeft = 17855, turnRight = 17855, walkLeft = 17855, walkRight = 17855, walkTurnLeft = 17855, walkTurnRight = 17855 },  -- PNR_LRC_IDLE
    [2681] = { stand = 17867, walk = 17869 },  -- SLICE_2012_UPDATE_SERGEANT_GOBLIN_READY
    [2682] = { stand = 17878, walk = 17878 },  -- WOF21_GHOUL_TRANSFORM
    [2683] = { stand = 17890, walk = 17890, run = 17890 },  -- ORNATEBOWL_LIGHT_CREATURE_IDLE_WALK_ABSORBED
    [2684] = { stand = 12913, walk = 12913, turnLeft = 12913, turnRight = 12913, walkBack = 12913, walkLeft = 12913, walkRight = 12913 },  -- REGICIDE_PLAYER_INVISIBLE
    [2685] = { stand = 17926 },  -- TWOCATS_DRAGONKIN_DEAD
    [2686] = { stand = 17934, walk = 17936, turnLeft = 17936, turnRight = 17936, walkLeft = 17936, walkRight = 17936, walkTurnLeft = 17936, walkTurnRight = 17936 },  -- OMGE_SKILL_COMBAT_SKELETON_2012_READY
    [2687] = { stand = 37632, walk = 37646, run = 37636, turnLeft = 37646, turnRight = 37646 },  -- HUMAN_ACTOR_COMBAT_ARMED_IDLE
    [2688] = { stand = 37652, walk = 37651, run = 37650, turnLeft = 37651, turnRight = 37651 },  -- HUMAN_ACTOR_COMBAT_UNARMED_IDLE
    [2689] = { stand = 37633, walk = 37635, run = 37634, turnLeft = 37635, turnRight = 37635 },  -- HUMAN_ACTOR_COMBAT_ARMED_MAUL_IDLE
    [2690] = { stand = 37640, walk = 37642, run = 37641, turnLeft = 37642, turnRight = 37642 },  -- HUMAN_ACTOR_COMBAT_ARMED_TWO_HANDED_SPEAR_IDLE
    [2691] = { stand = 37629, walk = 37631, run = 37630, turnLeft = 37631, turnRight = 37631 },  -- HUMAN_ACTOR_COMBAT_ARMED_BOW_IDLE
    [2692] = { stand = 37643, walk = 37645, run = 37644, turnLeft = 37645, turnRight = 37645 },  -- HUMAN_ACTOR_COMBAT_ARMED_TWO_HANDED_SWORD_IDLE
    [2693] = { stand = 37637, walk = 37639, run = 37638, turnLeft = 37639, turnRight = 37639 },  -- HUMAN_ACTOR_COMBAT_ARMED_TWO_HANDED_CROSSBOW_IDLE
    [2694] = { stand = 37647, walk = 37649, run = 37648, turnLeft = 37649, turnRight = 37649 },  -- HUMAN_ACTOR_COMBAT_ARMED_WHIP_IDLE
    [2695] = { walk = 17997, run = 17998, turnLeft = 17996, turnRight = 17996, idles = { { 17996, 80 }, { 37972, 20 } } },
    [2696] = { walk = 18024, run = 18017, turnLeft = 18024, turnRight = 18024, idles = { { 18023, 80 }, { 37968, 20 } } },
    [2697] = { walk = 18044, run = 18017, turnLeft = 18044, turnRight = 18044, idles = { { 18022, 80 }, { 28084, 20 } } },
    [2698] = { walk = 18016, run = 18017, turnLeft = 18016, turnRight = 18016, idles = { { 18015, 80 }, { 2691, 20 } } },
    [2699] = { walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020, idles = { { 18019, 80 }, { 196, 20 } } },
    [2700] = { walk = 18053, run = 18051, turnLeft = 18053, turnRight = 18053, idles = { { 18049, 80 }, { 37970, 20 } } },
    [2701] = { walk = 18057, run = 18059, turnLeft = 18057, turnRight = 18057, idles = { { 18055, 80 }, { 37966, 20 } } },
    [2702] = { walk = 18040, run = 18039, turnLeft = 18040, turnRight = 18040, idles = { { 18038, 80 }, { 197, 20 } } },
    [2703] = { walk = 18043, run = 18042, turnLeft = 18043, turnRight = 18043, idles = { { 18041, 80 }, { 3803, 20 } } },
    [2704] = { walk = 18037, run = 18036, turnLeft = 18037, turnRight = 18037, idles = { { 18035, 80 }, { 37973, 20 } } },
    [2705] = { walk = 18045, run = 18042, turnLeft = 18045, turnRight = 18045, idles = { { 18046, 80 }, { 37969, 20 } } },
    [2706] = { walk = 18047, run = 18042, turnLeft = 18047, turnRight = 18047, idles = { { 18048, 80 }, { 28085, 20 } } },
    [2707] = { walk = 18054, run = 18052, turnLeft = 18054, turnRight = 18054, idles = { { 18050, 80 }, { 37971, 20 } } },
    [2708] = { walk = 18058, run = 18060, turnLeft = 18058, turnRight = 18058, idles = { { 18056, 80 }, { 37967, 20 } } },
    [2709] = { walk = 18063, run = 18065, turnLeft = 18063, turnRight = 18063, idles = { { 18061, 80 }, { 15266, 20 } } },
    [2710] = { walk = 18064, run = 18066, turnLeft = 18064, turnRight = 18064, idles = { { 18062, 80 }, { 15263, 20 } } },
    [2711] = { stand = 808, walk = 15811, turnLeft = 15812, turnRight = 15812, walkBack = 15811, walkLeft = 15811, walkRight = 15811, walkTurnLeft = 15811, walkTurnRight = 15811 },  -- HUMAN_READY
    [2712] = { stand = 18801 },  -- OMGE_BABY_TROLL_IN_CANNON_READY
    [2713] = { stand = 808, walk = 18812, run = 18814, turnLeft = 823, turnRight = 823, walkBack = 18813, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2714] = { stand = 808, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [2715] = { stand = 18895, walk = 18895 },  -- ARIANE1_ARIANE_CASTS_SPELL_START
    [2716] = { stand = 18846, walk = 18846 },  -- ARIANE2_ARIANE_POSSESSED_READY
    [2717] = { stand = 18858, walk = 18858 },  -- ARIANE2_ARIANE_COMA_READY
    [2718] = { stand = 18910, walk = 18910 },  -- ARIANE1_HUMAN_WRAITH_SITTING
    [2719] = { stand = 18838, walk = 18911, turnLeft = 18911, turnRight = 18911 },  -- ARIANE2_HUMAN_WRAITH_READY
    [2720] = { stand = 1669, walk = 1673, run = 824, turnLeft = 1673, turnRight = 1673 },  -- SIGHERO_ARIANE_CASUAL_READY
    [2721] = { stand = 1669, walk = 824, run = 824, turnLeft = 824, turnRight = 824 },  -- SIGHERO_ARIANE_CASUAL_READY
    [2722] = { stand = 18894 },  -- ARIANE1_ARIANE_BEING_HIT_READY
    [2723] = { stand = 18898, walk = 1673, run = 824, turnLeft = 1673, turnRight = 1673 },  -- ARIANE1_ARIANE_DEJECTED_READY
    [2724] = { stand = 18920, walk = 18920 },  -- ARIANE1_RUNE_GUARDIAN_READY
    [2725] = { stand = 15389, walk = 18972, run = 18972 },  -- OPN_SHOCKED_BEHIND_PORTCULLIS
    [2726] = { stand = 15389, walk = 18973, run = 18973 },  -- OPN_SHOCKED_BEHIND_PORTCULLIS
    [2727] = { stand = 15338, walk = 18972, run = 18972, turnLeft = 15338, turnRight = 15338 },  -- OPN_PLAYER_HOLDING_EARS
    [2728] = { stand = 19003 },  -- ARIANE1_SEDRIDOR_ICYENIC_PURGE
    [2729] = { stand = 18981 },  -- WIZTOWER2012_SEDRIDOR_SITTING
    [2730] = { stand = 18985 },  -- WIZTOWER2012_WIZARD_FOYER_PODIUM
    [2731] = { idles = { { 18983, 60 }, { 18982, 40 } } },
    [2732] = { stand = 18986 },  -- WIZTOWER2012_WIZARD_ROTATING_BOOKCASE
    [2733] = { stand = 18984 },  -- WIZTOWER2012_WIZARD_EXAMINING_TABLE
    [2734] = { stand = 18993, walk = 18993 },  -- WIZTOWER2012_WIZARD_EXPERIMENT_TABLE
    [2735] = { stand = 18991 },  -- WIZTOWER2012_LESSERDEMON_FORCEFIELD
    [2736] = { stand = 18913, walk = 18852 },  -- ARIANE1_WRAITH_READY
    [2737] = { stand = 16631, walk = 16631 },  -- RCSIPHONXP_ELEMENTAL_NODE_CHAOS_READY
    [2738] = { stand = 18987 },  -- WIZTOWER2012_WIZARD_SLEEPING
    [2739] = { stand = 18988 },  -- WIZTOWER2012_WIZARD_SLEEPING_ALT
    [2740] = { stand = 19012 },  -- TZHAAR3_JALYT_GAAL_VALVE_STRAIN
    [2741] = { stand = 19079 },  -- TZHAAR3_TOKHAAR_HOK_DEATH_B
    [2742] = { stand = 19125 },  -- POP_CAPTAIN_IDLE_VAR_A
    [2743] = { stand = 19126 },  -- POP_CAPTAIN_IDLE_VAR_B
    [2744] = { stand = 19127 },  -- POP_CAPTAIN_IDLE_VAR_C
    [2745] = { stand = 19140 },  -- POP_CAPTAIN_IDLE_VAR_D
    [2746] = { stand = 19227 },  -- POP_SOLDIER_DEAD_POSE_A
    [2747] = { stand = 19228 },  -- POP_SOLDIER_DEAD_POSE_B
    [2748] = { stand = 19229 },  -- POP_SOLDIER_DEAD_POSE_C
    [2749] = { stand = 19230 },  -- POP_SOLDIER_DEAD_POSE_D
    [2750] = { stand = 19182 },  -- POP_PLAYER_SITTING_READY
    [2751] = { stand = 19128 },  -- POP_GENERIC_CREW_FIXING_MAST
    [2752] = { stand = 19129 },  -- POP_GENERIC_CREW_HAMMERING_ON_MAST
    [2753] = { stand = 19130 },  -- POP_GENERIC_CREW_HAMMERING_ON_MAST_B
    [2754] = { stand = 19131 },  -- POP_GENERIC_CREW_SCRUBBING_FLOOR
    [2755] = { stand = 19132 },  -- POP_GENERIC_CREW_SITTING_ON_DECK
    [2756] = { stand = 19133 },  -- POP_GENERIC_CREW_WORKING_ON_MAST_NET
    [2757] = { stand = 19152, walk = 19179, run = 19203 },  -- POP_PRIEST_IDLE
    [2758] = { stand = 19141, walk = 19142, turnLeft = 19142, turnRight = 19142, walkLeft = 19142, walkRight = 19142, walkTurnLeft = 19142, walkTurnRight = 19142 },  -- POP_MERCHANT_CREW_IDLE
    [2759] = { stand = 19143, walk = 19144, turnLeft = 19144, turnRight = 19144, walkLeft = 19144, walkRight = 19144, walkTurnLeft = 19144, walkTurnRight = 19144 },  -- POP_NAVY_CREW_IDLE
    [2760] = { stand = 19145, walk = 19146, turnLeft = 19146, turnRight = 19146, walkLeft = 19146, walkRight = 19146, walkTurnLeft = 19146, walkTurnRight = 19146 },  -- POP_PIRATE_IDLE
    [2761] = { stand = 22529, walk = 19147, run = 22530, turnLeft = 19147, turnRight = 19147, walkLeft = 19147, walkRight = 19147, walkTurnLeft = 19147, walkTurnRight = 19147 },  -- POP_SIREN_IDLE
    [2762] = { stand = 19214, walk = 6819 },  -- POP_CUTSCENE_SEAGULL_READY
    [2763] = { walk = 6819, idles = { { 19214, 80 }, { 19215, 20 } } },
    [2764] = { stand = 19189, walk = 19191 },  -- POP_CUTSCENE_CO_OWNER_READY
    [2765] = { stand = 19150 },  -- POP_BARMAID_IDLE
    [2766] = { stand = 19178, walk = 19177, run = 19176, turnLeft = 19177, turnRight = 19177, walkBack = 19177, walkLeft = 19177, walkRight = 19177 },  -- POP_BARMAID_READY
    [2767] = { idles = { { 19152, 90 }, { 19148, 10 } } },
    [2768] = { stand = 19153 },  -- POP_ASSASSIN_IDLE
    [2769] = { idles = { { 19155, 90 }, { 19156, 10 } } },
    [2770] = { stand = 19161 },  -- POP_WHALER_IDLE
    [2771] = { stand = 19157 },  -- POP_CONVICT_IDLE
    [2772] = { stand = 19158 },  -- POP_MEG_IDLE
    [2773] = { stand = 19159 },  -- POP_NAVIGATOR_IDLE
    [2774] = { stand = 19160 },  -- POP_OCCULTIST_IDLE
    [2775] = { stand = 19165 },  -- POP_NPC_BAR_BALCONY_READY_A
    [2776] = { stand = 19166 },  -- POP_NPC_BAR_BALCONY_READY_B
    [2777] = { stand = 19167 },  -- POP_NPC_SITTING_BY_STEPS
    [2778] = { stand = 19168 },  -- POP_NPC_SITTING_ON_CRATE
    [2779] = { stand = 19169 },  -- POP_NPC_WALL_LEAN
    [2780] = { stand = 19170 },  -- POP_NPC_LEAN_AGAINST_LOW_WALL
    [2781] = { stand = 17973, walk = 17974, walkBack = 17974, walkLeft = 17974, walkRight = 17974, walkTurnLeft = 17974, walkTurnRight = 17974 },  -- COMBAT_2012_CASUAL_IDLE
    [2782] = { stand = 15778, walk = 17974, walkBack = 17974, walkLeft = 17974, walkRight = 17974, walkTurnLeft = 17974, walkTurnRight = 17974 },  -- OMGE_HUMAN_MARKET_BROWSING_B
    [2783] = { stand = 19172 },  -- POP_NPC_CONVERSATION_A
    [2784] = { stand = 19171 },  -- POP_NPC_CONVERSATION_B
    [2785] = { stand = 19173, walk = 19174, walkBack = 19174, walkLeft = 19174, walkRight = 19174, walkTurnLeft = 19174, walkTurnRight = 19174 },  -- POP_NPC_CARRY_BARREL_READY
    [2786] = { stand = 19245, walk = 19245 },  -- XMAS_2012_IMP_SLEIGH_TAKEOFF
    [2787] = { stand = 19266, walk = 19265 },  -- XMAS_2012_DOG_IDLE_A
    [2788] = { stand = 19267, walk = 19265 },  -- XMAS_2012_DOG_IDLE_B
    [2789] = { stand = 19268, walk = 168 },  -- XMAS_2012_IMP_READY
    [2790] = { stand = 19269, walk = 19270, run = 19271, turnLeft = 19269, turnRight = 19269, walkBack = 19270, walkLeft = 19270, walkRight = 19270 },  -- MTX_PET_WINGED_LION_BABY_IDLE
    [2791] = { stand = 19283, walk = 19284, run = 19285, turnLeft = 19283, turnRight = 19283, walkBack = 19284, walkLeft = 19284, walkRight = 19284 },  -- MTX_PET_WINGED_LION_JUVENILE_IDLE
    [2792] = { stand = 19297, walk = 19298, run = 19299, turnLeft = 19297, turnRight = 19297, walkBack = 19298, walkLeft = 19298, walkRight = 19298 },  -- MTX_PET_WINGED_LION_ADULT_IDLE
    [2793] = { stand = 19311, walk = 19312, run = 19313, turnLeft = 19311, turnRight = 19311, walkBack = 19312, walkLeft = 19312, walkRight = 19312 },  -- MTX_PET_HELLHOUND_BABY_IDLE
    [2794] = { stand = 19325, walk = 19326, run = 19327, turnLeft = 19325, turnRight = 19325, walkBack = 19326, walkLeft = 19326, walkRight = 19326 },  -- MTX_PET_HELLHOUND_JUVENILE_IDLE
    [2795] = { stand = 19339, walk = 19340, run = 19341, turnLeft = 19339, turnRight = 19339, walkBack = 19340, walkLeft = 19340, walkRight = 19340 },  -- MTX_PET_HELLHOUND_ADULT_IDLE
    [2796] = { stand = 19269, walk = 19270, run = 19271, turnLeft = 19269, turnRight = 19269, walkBack = 19270, walkLeft = 19270, walkRight = 19270 },  -- MTX_PET_WINGED_LION_BABY_IDLE
    [2797] = { stand = 19375, walk = 19377, run = 19285, turnLeft = 19375, turnRight = 19375, walkBack = 19377, walkLeft = 19377, walkRight = 19377 },  -- MTX_PET_DARK_LION_JUVENILE_IDLE
    [2798] = { stand = 19386, walk = 19388, run = 19389, turnLeft = 19386, turnRight = 19386, walkBack = 19388, walkLeft = 19388, walkRight = 19388 },  -- MTX_PET_DARK_LION_ADULT_IDLE
    [2799] = { stand = 19428, walk = 19431, turnLeft = 19431, turnRight = 19431, walkTurnLeft = 19431, walkTurnRight = 19431 },  -- GODSS_GNOME_SCULPTOR_READY
    [2800] = { stand = 19437, walk = 19489, run = 19438, turnLeft = 19437, turnRight = 19437, walkBack = 19489, walkLeft = 19489, walkRight = 19489 },  -- KK_KALPHITE_READY
    [2801] = { stand = 19476, walk = 19490, run = 19477, turnLeft = 19476, turnRight = 19476, walkBack = 19490, walkLeft = 19490, walkRight = 19490 },  -- KK_KALPHITE_WORKER_READY
    [2802] = { stand = 19469 },  -- KK_KALPHITE_WORKER_DIGGING_EXTRA_TUNNELS
    [2803] = { stand = 19478, walk = 19488, run = 19474, turnLeft = 19478, turnRight = 19478, walkBack = 19488, walkLeft = 19488, walkRight = 19488 },  -- KK_KALPHITE_GUARDIAN_READY
    [2804] = { stand = 19445, walk = 19491, run = 19446, turnLeft = 19445, turnRight = 19445, walkBack = 19491, walkLeft = 19491, walkRight = 19491 },  -- KK_KALPHITE_KING_READY
    [2805] = { stand = 19521 },  -- ATDES_ADIL_IDLE
    [2806] = { stand = 19522 },  -- ATDES_CAMEL_IDLE
    [2807] = { stand = 18829, walk = 19620, run = 28440, walkLeft = 19620, walkRight = 19620 },  -- LESSER_DEMON_2011_READY
    [2808] = { stand = 19611, walk = 19611, walkLeft = 19611, walkRight = 19611 },  -- RED_DEMON_2011_INVISIBLE
    [2809] = { stand = 19597, walk = 19594, walkLeft = 19594, walkRight = 19594 },  -- RED_DEMON_2011_DELRITH_READY
    [2810] = { stand = 19603, walk = 19602, walkLeft = 19602, walkRight = 19602 },  -- RED_DEMON_2011_AGRITH_NAAR_READY
    [2811] = { stand = 19593 },  -- RED_DEMON_2011_DELRITH_WEAKENED_PORTAL
    [2812] = { stand = 19570, walk = 16992, turnLeft = 16992, turnRight = 16992, walkLeft = 16992, walkRight = 16992, walkTurnLeft = 16992, walkTurnRight = 16992 },  -- GREATER_DEMON_2011_READY_RANGED
    [2813] = { stand = 19577, walk = 19578, turnLeft = 16992, turnRight = 16992, walkLeft = 19578, walkRight = 19578, walkTurnLeft = 16992, walkTurnRight = 16992 },  -- GREATER_DEMON_2011_WAR_READY
    [2814] = { stand = 19625, walk = 19625 },  -- DSLAY_SKELETON_PILE_OF_BONE
    [2815] = { stand = 23777, walk = 23778, turnLeft = 23778, turnRight = 23778, walkTurnLeft = 23778, walkTurnRight = 23778 },  -- ELF_CITY_2014_ELF_CHILDREN_IDLE
    [2816] = { stand = 19597, walk = 19594, turnLeft = 19594, turnRight = 19594, walkLeft = 19594, walkRight = 19594, walkTurnLeft = 19594, walkTurnRight = 19594 },  -- RED_DEMON_2011_DELRITH_READY
    [2817] = { walk = 19640, run = 19637, turnLeft = 2393, turnRight = 2393, walkBack = 19640, walkLeft = 19640, walkRight = 19640, idles = { { 2393, 90 }, { 19636, 10 } } },
    [2818] = { walk = 19638, run = 19635, turnLeft = 19648, turnRight = 19648, walkBack = 19638, walkLeft = 19638, walkRight = 19638, idles = { { 19648, 90 }, { 19649, 10 } } },
    [2819] = { walk = 19669, run = 7138, turnLeft = 19667, turnRight = 19667, walkBack = 19669, walkLeft = 19669, walkRight = 19669, idles = { { 19667, 90 }, { 19668, 10 } } },
    [2820] = { stand = 19687 },  -- RAND_DND_HOARDSTALKER_IDLE
    [2821] = { stand = 19689 },  -- RAND_DND_SHEER_IDLE
    [2822] = { stand = 19716 },  -- RAME_MR_MORDAUT_READY
    [2823] = { idles = { { 808, 200 }, { 1129, 48 }, { 1130, 48 }, { 1131, 48 }, { 1128, 48 }, { 14165, 16 }, { 860, 32 }, { 866, 16 }, { 861, 32 }, { 857, 32 } } },
    [2824] = { stand = 17393, walk = 17394 },  -- GODWARS_KREE_ARRA_2012_READY
    [2825] = { stand = 19938, walk = 19938 },  -- TSD_TORNADO_SPIN
    [2826] = { stand = 14967, walk = 14966, run = 14966 },  -- RAND_BOSS_DEMON_GHAN_KO_READY
    [2827] = { stand = 14967, walk = 19851, run = 19851 },  -- RAND_BOSS_DEMON_GHAN_KO_READY
    [2828] = { stand = 14967, walk = 19862, run = 19862 },  -- RAND_BOSS_DEMON_GHAN_KO_READY
    [2829] = { stand = 19850, walk = 19848 },  -- TSD_GUTHIX_HUMANOID_IDLE_DYING
    [2830] = { stand = 19835 },  -- TSD_ZEMOUREGAL_CASTING_SPELL
    [2831] = { stand = 19809, walk = 19807, run = 19816 },  -- TSD_MECHANICAL_GUARDIAN_IDLE
    [2832] = { walk = 19903, run = 19903 },
    [2833] = { walk = 19894, run = 19893, idles = { { 19891, 70 }, { 19892, 30 } } },
    [2834] = { walk = 19824, run = 19929, idles = { { 19823, 80 }, { 19827, 20 } } },
    [2835] = { stand = 19898, walk = 19899 },  -- TSD_FIARA_IDLE
    [2836] = { walk = 19907, run = 19908, idles = { { 19906, 30 }, { 19926, 60 }, { 19925, 10 } } },
    [2837] = { stand = 19870, walk = 19871, walkTurnLeft = 19872, walkTurnRight = 19873 },  -- TSD_JUNA_READY
    [2838] = { stand = 17393, walk = 19890, turnLeft = 19890, turnRight = 19890, walkTurnLeft = 19890, walkTurnRight = 19890 },  -- GODWARS_KREE_ARRA_2012_READY
    [2839] = { stand = 14810, walk = 19933, walkTurnLeft = 19933, walkTurnRight = 19933 },  -- VKQ3_TEMPLE_GUARDIAN_READY
    [2840] = { stand = 19939 },  -- TSD_TOMB_PROP_ZEMO_PORTAL
    [2841] = { stand = 362, walk = 362, run = 362 },  -- BUTTERFLY_HOVER
    [2842] = { stand = 19965 },  -- TSD_PLAYER_COMBAT_DEATH_POSE
    [2843] = { stand = 10432, walk = 19976 },  -- ZEMO_ZEMOUREGAL_READY
    [2844] = { stand = 19978, walk = 2164, turnLeft = 2164, turnRight = 2164, walkBack = 2164, walkLeft = 2164, walkRight = 2164 },  -- HUMAN_UPDATE_SPADE_IDLE_NO_EXTRA
    [2845] = { stand = 20008 },  -- EASTER13_BUTTERFLY_CLUSTER
    [2846] = { idles = { { 20051, 90 }, { 20052, 10 } } },
    [2847] = { stand = 20100, walk = 20101, run = 20102 },  -- WOF34_RARES_PARROT_PET_IDLE
    [2848] = { stand = 20099, walk = 20106, run = 20107 },  -- WOF34_RARES_TUMBLEWEED_PET_IDLE
    [2849] = { stand = 20104, walk = 20110, run = 20111 },  -- WOF34_RARES_SKULL_IDLE
    [2850] = { stand = 19949, walk = 19949, turnLeft = 19949, turnRight = 19949, walkTurnLeft = 19949, walkTurnRight = 19949 },  -- TSD_TORNADO_SPIN_LIGHTNING_SPOTANIM
    [2851] = { stand = 10419, walk = 10419, turnLeft = 10419, turnRight = 10419, walkTurnLeft = 10419, walkTurnRight = 10419 },  -- MAH5_CUTSCENE_ZILYANA_LIE_ON_GROUND_POSE
    [2852] = { stand = 20159, walk = 20159 },  -- MTX33_MUSIC_BOX_IDLE
    [2853] = { stand = 20170 },  -- NEXUS_GROTESQUE_IDLE
    [2854] = { stand = 20188 },  -- NEXUS_GROTESQUE_ARMS_FADE_OUT
    [2855] = { stand = 20216 },  -- GODEM_ARMADYL_IDLE
    [2856] = { stand = 20209 },  -- GODEM_BANDOS_IDLE
    [2857] = { stand = 20213 },  -- GODEM_SARADOMIN_IDLE
    [2858] = { stand = 20214 },  -- GODEM_SEREN_IDLE
    [2859] = { stand = 20210 },  -- GODEM_SLISKE_IDLE
    [2860] = { stand = 20211 },  -- GODEM_ZAMORAK_IDLE
    [2861] = { stand = 20215 },  -- GODEM_ZAROS_IDLE
    [2862] = { stand = 20212 },  -- GODEM_GODLESS_IDLE
    [2863] = { stand = 20242, walk = 20243, turnLeft = 20243, turnRight = 20243, walkLeft = 20243, walkRight = 20243, walkTurnLeft = 20243, walkTurnRight = 20243 },  -- ASC_GLADIUS_IDLE
    [2864] = { stand = 20236, walk = 20239, turnLeft = 20239, turnRight = 20239, walkLeft = 20239, walkRight = 20239, walkTurnLeft = 20239, walkTurnRight = 20239 },  -- ASC_CAPSARIUS_IDLE
    [2865] = { stand = 20235, walk = 20237, turnLeft = 20237, turnRight = 20237, walkLeft = 20237, walkRight = 20237, walkTurnLeft = 20237, walkTurnRight = 20237 },  -- ASC_LEGIO_IDLE
    [2866] = { stand = 20245, walk = 20251, turnLeft = 20251, turnRight = 20251, walkLeft = 20251, walkRight = 20251, walkTurnLeft = 20251, walkTurnRight = 20251 },  -- ASC_SCUTARIUS_IDLE
    [2867] = { stand = 20244, walk = 20272, turnLeft = 20272, turnRight = 20272, walkLeft = 20272, walkRight = 20272, walkTurnLeft = 20272, walkTurnRight = 20272 },  -- ASC_RORARIUS_IDLE
    [2868] = { stand = 20238 },  -- ASC_OCELLUS_IDLE
    [2869] = { stand = 20305, walk = 819 },  -- MTX36_PLAYER_STRONGARM_RESTING_LOOP
    [2870] = { stand = 20287, walk = 819 },  -- MTX36_PLAYER_MAGIC_RESTING_LOOP
    [2871] = { stand = 20316, walk = 20317, run = 20337, runBack = 20337, runLeft = 20337, runRight = 20337, turnLeft = 20316, turnRight = 20316, walkBack = 20317, runTurnLeft = 20337, runTurnRight = 20337, walkTurnLeft = 20317, walkTurnRight = 20317 },  -- BOSS2_BOSS_IDLE
    [2872] = { stand = 20339, walk = 20340, turnLeft = 20339, turnRight = 20339, walkBack = 20340, walkTurnLeft = 20340, walkTurnRight = 20340 },  -- BOSS2_STONEADD_IDLE
    [2873] = { stand = 20378, walk = 20380, run = 20380, runBack = 20380, runLeft = 20380, runRight = 20380, turnLeft = 20378, turnRight = 20378, walkBack = 20380, runTurnLeft = 20380, runTurnRight = 20380, walkTurnLeft = 20380, walkTurnRight = 20380 },  -- BOSS2_NORMALADD_IDLE
    [2874] = { stand = 20361 },  -- BOSS2_BOSS_FALLING_LOOP
    [2875] = { stand = 20333 },  -- BOSS2_BOSS_HEAD_IDLE
    [2876] = {  },
    [2877] = { stand = 20409, walk = 20408, walkTurnLeft = 20408, walkTurnRight = 20408 },  -- QUEST_BACON_CULTIST_IDLE
    [2878] = { stand = 15405, walk = 15408, turnLeft = 15408, turnRight = 15408, walkTurnLeft = 15408, walkTurnRight = 15408 },  -- OPN_SISTER_BENITA_READY
    [2879] = { stand = 247, walk = 20404, turnLeft = 20404, turnRight = 20404, walkTurnLeft = 20404, walkTurnRight = 20404 },  -- PIG_09_UPDATE_READY
    [2880] = { stand = 247, walk = 20403, turnLeft = 20403, turnRight = 20403, walkTurnLeft = 20403, walkTurnRight = 20403 },  -- PIG_09_UPDATE_READY
    [2881] = { stand = 279, walk = 20405, turnLeft = 20405, turnRight = 20405, walkTurnLeft = 20405, walkTurnRight = 20405 },  -- PIGLET_09_UPDATE_READY
    [2882] = { stand = 20415, walk = 20404, turnLeft = 20404, turnRight = 20404, walkTurnLeft = 20404, walkTurnRight = 20404 },  -- QUEST_BACON_COMBAT_PIG_1X1_IDLE
    [2883] = { stand = 20422 },  -- QUEST_BACON_PIG_MACHINE_IDLE
    [2884] = { stand = 20426, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- QUEST_BACON_ELI_IDLE
    [2885] = { stand = 20432, walk = 20431, walkLeft = 20431, walkRight = 20431, walkTurnLeft = 20431, walkTurnRight = 20431 },  -- MTX_PET_BOSS2_IDLE
    [2886] = { stand = 20678, walk = 20678 },  -- _6AWE1_HERALD_DAUGHTER
    [2887] = { stand = 20679, walk = 20679, turnLeft = 20679, turnRight = 20679 },  -- _6AWE1_HERALD_ZAMORAK_BROTHER
    [2888] = { stand = 20680, walk = 20680, turnLeft = 20680, turnRight = 20680 },  -- _6AWE1_HERALD_SARADOMIN_BROTHER
    [2889] = { stand = 20725, walk = 20727, turnLeft = 20727, turnRight = 20727, walkTurnLeft = 20727, walkTurnRight = 20727 },  -- _6AWE1_BATTLEFIELD_SARADOMIN_HERO_READY
    [2890] = { stand = 20730, walk = 20746, turnLeft = 20746, turnRight = 20746, walkTurnLeft = 20746, walkTurnRight = 20746 },  -- _6AWE1_SARADOMIN_UBER_IDLE
    [2891] = { stand = 20803, walk = 20802, turnLeft = 20802, turnRight = 20802, walkTurnLeft = 20802, walkTurnRight = 20802 },  -- _6AWE1_SARADOMIN_SIEGE_IDLE
    [2892] = { stand = 20681, walk = 20781, run = 28433, turnLeft = 20781, turnRight = 20781, walkTurnLeft = 20781, walkTurnRight = 20781 },  -- _6AWE1_ZAMORAK_SIEGE_IDLE
    [2893] = { stand = 20752, walk = 20690, run = 28434, turnLeft = 20690, turnRight = 20690, walkTurnLeft = 20690, walkTurnRight = 20690 },  -- _6AWE1_ZAMORAK_UBER_IDLE
    [2894] = { stand = 20736, walk = 20736, turnLeft = 20736, turnRight = 20736, walkTurnLeft = 20736, walkTurnRight = 20736 },  -- _6AWE1_SARADOMIN_GENERAL_IDLE
    [2895] = { stand = 20694, walk = 20694, turnLeft = 20694, turnRight = 20694, walkTurnLeft = 20694, walkTurnRight = 20694 },  -- _6AWE1_ZAMORAK_GENERAL_IDLE
    [2896] = { stand = 20794, turnLeft = 20794, turnRight = 20794 },  -- _6AWE1_SARADOMIN_RECRUITER_IDLE
    [2897] = { stand = 20792, turnLeft = 20792, turnRight = 20792 },  -- _6AWE1_CRATER_RESOURCE_POINT_FISH
    [2898] = { stand = 20793, turnLeft = 20793, turnRight = 20793 },  -- _6AWE1_CRATER_RESOURCE_POINT_FISH_DEPLETED
    [2899] = { stand = 20778 },  -- _6AWE1_KARA_MEIR_IDLE
    [2900] = { stand = 20780 },  -- _6AWE1_DM_WEEK5_LUMBRIDGE_PROTECTOR_IDLE
    [2901] = { stand = 20585 },  -- _6AWE1_CLOSING_CUTSCENE_KNIGHT_DEATH_POSE_A
    [2902] = { stand = 20586 },  -- _6AWE1_CLOSING_CUTSCENE_KNIGHT_DEATH_POSE_B
    [2903] = { stand = 20587 },  -- _6AWE1_CLOSING_CUTSCENE_KNIGHT_DEATH_POSE_C
    [2904] = { stand = 20588 },  -- _6AWE1_CLOSING_CUTSCENE_KNIGHT_DEATH_POSE_D
    [2905] = { stand = 20884, walk = 20882, run = 20883, turnLeft = 20884, turnRight = 20884, walkBack = 20882, walkLeft = 20882, walkRight = 20882 },  -- MTX_PET_ZAMORAK_SIEGE_BABY_IDLE
    [2906] = { stand = 20901, walk = 20899, run = 20900, turnLeft = 20901, turnRight = 20901, walkBack = 20899, walkLeft = 20899, walkRight = 20899 },  -- MTX_PET_ZAMORAK_SIEGE_JUVENILE_IDLE
    [2907] = { stand = 20918, walk = 20916, run = 20917, turnLeft = 20918, turnRight = 20918, walkBack = 20916, walkLeft = 20916, walkRight = 20916 },  -- MTX_PET_ZAMORAK_SIEGE_ADULT_IDLE
    [2908] = { stand = 20833, walk = 20834, run = 20835, turnLeft = 20833, turnRight = 20833, walkBack = 20834, walkLeft = 20834, walkRight = 20834 },  -- MTX_PET_SARADOMIN_SIEGE_BABY_IDLE
    [2909] = { stand = 20848, walk = 20849, run = 20850, turnLeft = 20848, turnRight = 20848, walkBack = 20849, walkLeft = 20849, walkRight = 20849 },  -- MTX_PET_SARADOMIN_SIEGE_JUVENILE_IDLE
    [2910] = { stand = 20862, walk = 20863, run = 20865, turnLeft = 20862, turnRight = 20862, walkBack = 20863, walkLeft = 20863, walkRight = 20863 },  -- MTX_PET_SARADOMIN_SIEGE_ADULT_IDLE
    [2911] = { stand = 37632, walk = 37655, run = 37655, turnLeft = 37655, turnRight = 37655 },  -- HUMAN_ACTOR_COMBAT_ARMED_IDLE
    [2912] = { walk = 20972, run = 20973, turnLeft = 20972, turnRight = 20972, idles = { { 18015, 80 }, { 2691, 20 } } },
    [2913] = { walk = 20974, run = 20975, turnLeft = 20974, turnRight = 20974, idles = { { 18019, 80 }, { 196, 20 } } },
    [2914] = { stand = 17484, walk = 21134, run = 21134 },  -- CENTAUR_2012_READY
    [2915] = { stand = 21106, walk = 21117, walkTurnLeft = 21117, walkTurnRight = 21117 },  -- OWEN1_BLACK_KNIGHT_DEATH_VAR_A_NULL
    [2916] = { stand = 21108, walk = 21117, walkTurnLeft = 21117, walkTurnRight = 21117 },  -- OWEN1_BLACK_KNIGHT_DEATH_VAR_B_NULL
    [2917] = { stand = 21106, walk = 21106, walkTurnLeft = 21106, walkTurnRight = 21106 },  -- OWEN1_BLACK_KNIGHT_DEATH_VAR_A_NULL
    [2918] = { stand = 21108, walk = 21108, walkTurnLeft = 21108, walkTurnRight = 21108 },  -- OWEN1_BLACK_KNIGHT_DEATH_VAR_B_NULL
    [2919] = { stand = 21110, walk = 21110, walkTurnLeft = 21110, walkTurnRight = 21110 },  -- OWEN1_BLACK_KNIGHT_DEATH_VAR_C_NULL
    [2920] = { stand = 21149, walk = 21149, walkTurnLeft = 21149, walkTurnRight = 21149 },  -- OWEN1_DAWN_DEATH_NULL
    [2921] = { stand = 21019 },  -- OWEN1_CUTSCENE2_DAWN_COWERING_NO_SWING
    [2922] = { stand = 15403, walk = 15339, turnLeft = 15403, turnRight = 15403, walkLeft = 15339, walkRight = 15339, walkTurnLeft = 15339, walkTurnRight = 15339 },  -- OPN_DEBORA_READY
    [2923] = { stand = 21118, walk = 21119, turnLeft = 21119, turnRight = 21119, walkTurnLeft = 21119, walkTurnRight = 21119 },  -- OWEN1_DAWN_IDLE
    [2924] = { stand = 21118, walk = 21119, turnLeft = 21118, turnRight = 21118, walkTurnLeft = 21119, walkTurnRight = 21119 },  -- OWEN1_DAWN_IDLE
    [2925] = { stand = 21019 },  -- OWEN1_CUTSCENE2_DAWN_COWERING_NO_SWING
    [2926] = { stand = 21116, walk = 21117, turnLeft = 21117, turnRight = 21117, walkTurnLeft = 21117, walkTurnRight = 21117 },  -- OWEN1_ZOMBIE_BLACK_KNIGHT_IDLE
    [2927] = { stand = 21154 },  -- OWEN1_SLAVE_COOK_IDLE
    [2928] = { stand = 21153 },  -- OWEN1_SLAVE_WASH_DISHES_IDLE
    [2929] = { stand = 21103 },  -- OWEN1_PLAYER_KNEEL_STARTANDLOOP
    [2930] = { stand = 21159 },  -- OWEN1_BLACK_KNIGHT_EATING
    [2931] = { stand = 21160 },  -- OWEN1_BLACK_KNIGHT_EATING_B
    [2932] = { stand = 30285, walk = 30290, run = 30291, turnLeft = 30285, turnRight = 30285, walkBack = 30290, walkLeft = 30290, walkRight = 30290 },  -- BPETS_WATERBOSS_IDLE
    [2933] = { stand = 30277, walk = 30283, run = 30284, turnLeft = 30277, turnRight = 30277, walkBack = 30283, walkLeft = 30283, walkRight = 30283 },  -- BPETS_BEASTMASTER_IDLE
    [2934] = { stand = 21164, walk = 21165, run = 21166 },  -- OWEN1_SIROWEN_HANDS_TIED_IDLE
    [2935] = { stand = 21197, walk = 21198 },  -- JAILER_READY
    [2936] = { stand = 21199, walk = 21199, turnLeft = 21199, turnRight = 21199, walkTurnLeft = 21199, walkTurnRight = 21199 },  -- DIV_WISP_READY_WALK
    [2937] = { stand = 21200, turnLeft = 21200, turnRight = 21200 },  -- DIV_WISP_BECOME_FOUNTAIN
    [2938] = { stand = 21206, walk = 21206, turnLeft = 21206, turnRight = 21206, walkTurnLeft = 21206, walkTurnRight = 21206 },  -- DIV_SUPER_WISP_READY_WALK
    [2939] = { stand = 21207, turnLeft = 21207, turnRight = 21207 },  -- DIV_SUPER_WISP_BECOME_FOUNTAIN
    [2940] = { stand = 21219, turnLeft = 21219, turnRight = 21219 },  -- DIV_BEN_IDLE
    [2941] = { stand = 21222, turnLeft = 21222, turnRight = 21222 },  -- DIV_ORLA_IDLE
    [2942] = { stand = 21238, turnLeft = 21238, turnRight = 21238 },  -- DIV_MAY_IDLE
    [2943] = { stand = 21228, turnLeft = 21228, turnRight = 21228 },  -- DIV_PLAYER_DRAIN_ENERGY
    [2944] = { stand = 21260, walk = 21264, run = 21264, turnLeft = 21260, turnRight = 21260, walkBack = 21264, walkLeft = 21264, walkRight = 21264 },  -- WOF_52_GOLDEN_CHINCHOMPA_BABY_IDLE
    [2945] = { stand = 21261, walk = 21265, run = 21265, turnLeft = 21261, turnRight = 21261, walkBack = 21265, walkLeft = 21265, walkRight = 21265 },  -- WOF_52_GOLDEN_CHINCHOMPA_ADOLESCENT_IDLE
    [2946] = { stand = 21262, walk = 21266, run = 21266, turnLeft = 21262, turnRight = 21262, walkBack = 21266, walkLeft = 21266, walkRight = 21266 },  -- WOF_52_GOLDEN_CHINCHOMPA_ADULT_IDLE
    [2947] = { stand = 21355, walk = 21356 },  -- DWARF_2013_READY_WALKINGSTICK
    [2948] = { stand = 3208, walk = 3207 },  -- FAI_DWARF_READY_CRATE
    [2949] = { stand = 2337, walk = 104 },  -- DWARF_READY_SITTING_AND_DRINKING
    [2950] = { stand = 21415, walk = 21415 },  -- RA4_DWARF_MEIKE_HOLDINGPILLOW
    [2951] = { stand = 21462, walk = 21462 },  -- RA5_MEMORY_VOID_IDLE
    [2952] = { stand = 21465, walk = 21465 },  -- RA5_MEMORY_FRAGMENT_DANGEROUS_IDLE
    [2953] = { stand = 21536, walk = 21467, turnLeft = 21467, turnRight = 21467, walkTurnLeft = 21467, walkTurnRight = 21467 },  -- RA5_CHAOS_GIANT_IDLE
    [2954] = { stand = 21551, walk = 21346, turnLeft = 21346, turnRight = 21346, walkTurnLeft = 21346, walkTurnRight = 21346 },  -- RA5_HREIDMAR_STAFF_READY
    [2955] = { stand = 21434, walk = 21543, turnLeft = 21543, turnRight = 21543, walkTurnLeft = 21543, walkTurnRight = 21543 },  -- RA5_HREIDMAR_IDLE
    [2956] = { stand = 2150, walk = 2150, run = 21544 },  -- DWARF_MINECART_READY
    [2957] = { stand = 21482, walk = 21482 },  -- RA5_GRIMSSON_HOLD_HOSTAGE_READY
    [2958] = { stand = 21483, walk = 21483 },  -- RA5_DWARF_HOSTAGE_HELD_READY
    [2959] = { stand = 21450, walk = 21451, run = 21451 },  -- RA5_GRIMSSON_CHARGE_ATTACK_POWER_UP
    [2960] = { stand = 21430, walk = 21430 },  -- RA5_CUTSCENE_2_VELDABAN_TURNING_CHAOS_LOOP
    [2961] = { stand = 21548 },  -- RA5_TROLL_COWERING
    [2962] = { stand = 21458 },  -- RA5_DWARF_FRIGHTENED_IDLE
    [2963] = { stand = 21537 },  -- RA5_LAVA_GEYSER_APPEARS
    [2964] = { stand = 21642 },  -- RA5_COMMANDER_SITTING_IDLE
    [2965] = { stand = 21468 },  -- SLISKE1_ZAMORAK_IDLE
    [2966] = { stand = 2151, walk = 98 },  -- DWARF_DIRECTOR_TABLE_READY
    [2967] = { walk = 98, idles = { { 2152, 20 }, { 2151, 80 } } },
    [2968] = { stand = 21353, walk = 98 },  -- SLICE_DWARF_2013_1_IDLE
    [2969] = { stand = 21377, walk = 98 },  -- SLICE_DWARF_2013_2_READY
    [2970] = { stand = 21378, walk = 98 },  -- SLICE_DWARF_2013_3_READY
    [2971] = { stand = 21379, walk = 98 },  -- SLICE_DWARF_2013_4_READY
    [2972] = { stand = 4021, walk = 98 },  -- ROYAL_DWARF_MINING
    [2973] = { stand = 21408, walk = 21408 },  -- RA3_DWARF_2013_VELDABAN_IN_PUB
    [2974] = { stand = 21409, walk = 21409 },  -- RA3_DWARF_2013_VELDABAN_IN_PUB_COMMON
    [2975] = { stand = 17844, walk = 21347, run = 21337, turnLeft = 21347, turnRight = 21347, walkLeft = 21347, walkRight = 21347, walkTurnLeft = 21347, walkTurnRight = 21347 },  -- PNR_GENERIC_DWARF_IDLE
    [2976] = { stand = 21359 },  -- DWARF_2013_DIRECTOR_TABLE_READY
    [2977] = { stand = 21772 },  -- SLISKE1_RELOMIA_SLISKE_EMISSARY_IDLE
    [2978] = { stand = 21809 },  -- SLISKE1_RIFT
    [2979] = { stand = 21831, turnLeft = 21831, turnRight = 21831 },  -- OCT2013_FOREMAN_IDLE
    [2980] = { stand = 808, turnLeft = 808, turnRight = 808 },  -- HUMAN_READY
    [2981] = { stand = 21848, walk = 21848 },  -- MTX44_HALLOWEEN_ZOMBIE_MUSIC_BOX_IDLE
    [2982] = { stand = 21913, walk = 21913, turnLeft = 21913, turnRight = 21913, walkBack = 21913, walkTurnLeft = 21913, walkTurnRight = 21913 },  -- BARROWS2_BROTHER_STASIS_MODE_LOOP
    [2983] = { stand = 21962 },  -- BARROWS2_CENTRAL_PORTAL_IDLE
    [2984] = { stand = 21935, walk = 21935, turnLeft = 21935, turnRight = 21935, walkBack = 21935, walkTurnLeft = 21935, walkTurnRight = 21935 },  -- BARROWS2_TORAG_ATTACK_B
    [2985] = { stand = 21937, walk = 21937, turnLeft = 21937, turnRight = 21937, walkBack = 21937, walkTurnLeft = 21937, walkTurnRight = 21937 },  -- BARROWS2_PLAYER_GROUNDED_B
    [2986] = { stand = 21949, walk = 21949, turnLeft = 21949, turnRight = 21949, walkBack = 21949, walkTurnLeft = 21949, walkTurnRight = 21949 },  -- GAME_BARROWS2_KARIL_PORTAL_SPOTANIM
    [2987] = { stand = 21931, walk = 21931, run = 21931, runBack = 21931, runLeft = 21931, runRight = 21931, turnLeft = 21931, turnRight = 21931, walkBack = 21931, runTurnLeft = 21931, runTurnRight = 21931, walkTurnLeft = 21931, walkTurnRight = 21931 },  -- BARROWS2_FLYING_READY
    [2988] = { stand = 21942, walk = 21942, run = 21942, runBack = 21942, runLeft = 21942, runRight = 21942, turnLeft = 21942, turnRight = 21942, walkBack = 21942, runTurnLeft = 21942, runTurnRight = 21942, walkTurnLeft = 21942, walkTurnRight = 21942 },  -- BARROWS2_VERAC_HELICOPTER
    [2989] = { stand = 21941, walk = 21941, run = 21941, runBack = 21941, runLeft = 21941, runRight = 21941, turnLeft = 21941, turnRight = 21941, walkBack = 21941, runTurnLeft = 21941, runTurnRight = 21941, walkTurnLeft = 21941, walkTurnRight = 21941 },  -- BARROWS2_BROTHER_HURRICANE_SPIN
    [2990] = { stand = 21911, walk = 21911, run = 21911, runBack = 21911, runLeft = 21911, runRight = 21911, turnLeft = 21911, turnRight = 21911, walkBack = 21911, runTurnLeft = 21911, runTurnRight = 21911, walkTurnLeft = 21911, walkTurnRight = 21911 },  -- BARROWS2_BROTHERS_TURRET_OF_DOOM_LOOP
    [2991] = { stand = 21964, walk = 21965, run = 21966, runBack = 21966, runLeft = 21966, runRight = 21966, turnLeft = 21964, turnRight = 21964, walkBack = 21965, runTurnLeft = 21966, runTurnRight = 21966, walkTurnLeft = 21965, walkTurnRight = 21965 },  -- BARROWS2_BOBBLEHEAD_BROTHER_IDLE
    [2992] = { stand = 21968, walk = 21968, run = 21968, runBack = 21968, runLeft = 21968, runRight = 21968, turnLeft = 21968, turnRight = 21968, walkBack = 21968, runTurnLeft = 21968, runTurnRight = 21968, walkTurnLeft = 21968, walkTurnRight = 21968 },  -- BARROWS2_BOBBLEHEAD_BROTHER_LINEDANCE
    [2993] = { stand = 21971 },  -- RA5_FLOATING_APPARITIONS_IDLE
    [2994] = { stand = 21972 },  -- RA5_FLOATING_APPARITIONS_IDLE_RAND
    [2995] = { walk = 22003, run = 22004, turnLeft = 22003, turnRight = 22003, walkLeft = 22003, walkRight = 22003, walkTurnLeft = 22003, walkTurnRight = 22003, idles = { { 22001, 90 }, { 22002, 10 } } },
    [2996] = { walk = 22012, run = 22013, turnLeft = 22012, turnRight = 22012, walkLeft = 22012, walkRight = 22012, walkTurnLeft = 22012, walkTurnRight = 22012, idles = { { 22010, 90 }, { 22011, 10 } } },
    [2997] = { walk = 22020, run = 22021, turnLeft = 22020, turnRight = 22020, walkLeft = 22020, walkRight = 22020, walkTurnLeft = 22020, walkTurnRight = 22020, idles = { { 22018, 90 }, { 22019, 10 } } },
    [2998] = { stand = 22025, walk = 22026, run = 22032, runBack = 22032, runLeft = 22032, runRight = 22032, turnLeft = 22026, turnRight = 22026, walkBack = 22026, walkLeft = 22026, walkRight = 22026 },  -- TUT5_GUDRIK_IDLE
    [2999] = { stand = 21338, walk = 22072, run = 22073, runBack = 22073, runLeft = 22073, runRight = 22073, turnLeft = 22072, turnRight = 22072, walkBack = 22072, walkLeft = 22072, walkRight = 22072 },  -- DWARF_2013_READY
    [3000] = { stand = 22074, walk = 22026, run = 22032, runBack = 22032, runLeft = 22032, runRight = 22032, turnLeft = 22026, turnRight = 22026, walkBack = 22026, walkLeft = 22026, walkRight = 22026 },  -- TUT5_GUDRIK_IDLE_W_EXTRA
    [3001] = { stand = 22029, walk = 22030, turnLeft = 22030, turnRight = 22030, walkBack = 22030, walkLeft = 22030, walkRight = 22030 },  -- TUT5_MORWENNA_IDLE
    [3002] = { stand = 22106, walk = 22106, turnLeft = 22106, turnRight = 22106, walkBack = 22106, walkLeft = 22106, walkRight = 22106 },  -- TUT5_MORWENNA_INVISIBLE
    [3003] = { stand = 22033, walk = 22034, crawl = 22035, crawlBack = 22035, crawlLeft = 22035, crawlRight = 22035, turnLeft = 22034, turnRight = 22034, walkBack = 22034, walkLeft = 22034, walkRight = 22034 },  -- ZOMBIE_2013_IDLE
    [3004] = { stand = 22050, turnLeft = 22050, turnRight = 22050 },  -- TUT5_DIGORY_IDLE
    [3005] = { stand = 22047, turnLeft = 22047, turnRight = 22047 },  -- TUT5_HENDRIK_IDLE
    [3006] = { stand = 22061, turnLeft = 22061, turnRight = 22061 },  -- TUT5_OLD_SEA_DOG_IDLE
    [3007] = { stand = 22059, turnLeft = 22059, turnRight = 22059 },  -- TUT5_NED_IDLE
    [3008] = { stand = 22066, turnLeft = 22066, turnRight = 22066 },  -- TUT5_QUARRY_OVERSEER_IDLE
    [3009] = { stand = 22060, turnLeft = 22060, turnRight = 22060 },  -- TUT5_SARAH_IDLE
    [3010] = { stand = 22119, turnLeft = 22119, turnRight = 22119 },  -- TUT5_MAGDA_IDLE
    [3011] = { stand = 22122, walk = 26147, crawl = 26147, crawlBack = 26147, crawlLeft = 22141, crawlRight = 22140, turnLeft = 22141, turnRight = 22140, walkBack = 26147, walkLeft = 22141, walkRight = 22140, walkTurnLeft = 22141, walkTurnRight = 22140 },  -- TUT5_ZOMBIE_COW_IDLE
    [3012] = { stand = 22124, walk = 22124, crawl = 22124, crawlBack = 22124, crawlLeft = 22124, crawlRight = 22124, turnLeft = 22124, turnRight = 22124, walkBack = 22124, walkLeft = 22124, walkRight = 22124 },  -- TUT5_ZOMBIE_COW_DEAD
    [3013] = { stand = 22128, turnLeft = 22128, turnRight = 22128 },  -- TUT5_SMITH_IDLE
    [3014] = { stand = 22129, turnLeft = 22135, turnRight = 22135 },  -- TUT5_DIGORY_CHURCH_CHEER
    [3015] = { stand = 22130, turnLeft = 22136, turnRight = 22136 },  -- TUT5_SARAH_CHURCH_CHEER
    [3016] = { stand = 22166, walk = 22167, turnLeft = 22167, turnRight = 22167, walkBack = 22167, walkLeft = 22167, walkRight = 22167, walkTurnLeft = 22167, walkTurnRight = 22167 },  -- HOTM_TUSKA_HARBINGER_STANDING_IDLE
    [3017] = { stand = 22151, walk = 22152, turnLeft = 22152, turnRight = 22152, walkBack = 22152, walkLeft = 22152, walkRight = 22152, walkTurnLeft = 22152, walkTurnRight = 22152 },  -- HOTM_TUSKA_HARBINGER_KNUCKLES_IDLE
    [3018] = { walk = 22180, run = 22181, turnLeft = 22180, turnRight = 22180, walkTurnLeft = 22180, walkTurnRight = 22180, idles = { { 22071, 90 }, { 22186, 10 } } },
    [3019] = { stand = 22291 },  -- _6AWE2_ARMADYL_HEAD_MAGE_READY
    [3020] = { stand = 22292 },  -- _6AWE2_ARMADYL_GOLEM_MASTER_READY
    [3021] = { stand = 22295, walk = 22296, turnLeft = 22295, turnRight = 22295, walkBack = 22296, walkLeft = 22296, walkRight = 22296 },  -- _6AWE2_ARMADYL_CARAVAN_READY
    [3022] = { stand = 22285, walk = 22286, turnLeft = 22285, turnRight = 22285, walkBack = 22286, walkLeft = 22286, walkRight = 22286 },  -- _6AWE2_BANDOS_CARAVAN_IDLE
    [3023] = { stand = 22297 },  -- _6AWE2_BANDOS_HIGH_SHAMAN_READY
    [3024] = { stand = 22394 },  -- _6AWE2_GARLANDIA_IDLE
    [3025] = { stand = 22280, walk = 22281, run = 22282, runBack = 22282, turnLeft = 22281, turnRight = 22281, walkBack = 22281, walkLeft = 22281, walkRight = 22281 },  -- _6AWE2_BANDOS_GOLEM_IDLE
    [3026] = { stand = 22371, walk = 22372, run = 22374, runBack = 22374, turnLeft = 22372, turnRight = 22372, walkBack = 22372, walkLeft = 22372, walkRight = 22372 },  -- _6AWE2_ARMADYL_GOLEM_IDLE
    [3027] = { stand = 22300, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- _6AWE2_CONVOY_DIVINER_IDLE
    [3028] = { idles = { { 22297, 200 }, { 22305, 50 } } },
    [3029] = { stand = 22400 },  -- _6AWE2_ARMADYL_HEAD_DIVINER_IDLE
    [3030] = { stand = 22399 },  -- _6AWE2_BANDOS_HEAD_DIVINER_IDLE
    [3031] = { idles = { { 22313, 200 }, { 22312, 20 } } },
    [3032] = { stand = 22317, walk = 17510, turnLeft = 17510, turnRight = 17510, walkTurnLeft = 17510, walkTurnRight = 17510 },  -- _6AWE2_BODYGUARD_BANDOS_OGRE_READY
    [3033] = { stand = 22250, walk = 22603, run = 22604, turnLeft = 22603, turnRight = 22603, walkBack = 22603, walkLeft = 22603, walkRight = 22603 },  -- NJSLAY_PET_RUNT_IDLE
    [3034] = { walk = 22448, run = 22449, turnLeft = 22448, turnRight = 22448, walkLeft = 22448, walkRight = 22448, walkTurnLeft = 22448, walkTurnRight = 22448, idles = { { 22446, 90 }, { 22447, 10 } } },
    [3035] = { walk = 22460, run = 22461, turnLeft = 22460, turnRight = 22460, walkLeft = 22460, walkRight = 22460, walkTurnLeft = 22460, walkTurnRight = 22460, idles = { { 22458, 90 }, { 22459, 10 } } },
    [3036] = { walk = 22472, run = 22473, turnLeft = 22472, turnRight = 22472, walkLeft = 22472, walkRight = 22472, walkTurnLeft = 22472, walkTurnRight = 22472, idles = { { 22470, 90 }, { 22471, 10 } } },
    [3037] = { stand = 22441, walk = 22440, run = 22442, turnLeft = 22440, turnRight = 22440, walkLeft = 22440, walkRight = 22440, walkTurnLeft = 22440, walkTurnRight = 22440 },  -- MTX45_XMAS_PET_PRESENT_IDLE
    [3038] = { stand = 22491, walk = 22492, walkLeft = 22492, walkRight = 22492, walkTurnLeft = 22492, walkTurnRight = 22492 },  -- XMAS13_SANTA_READY
    [3039] = { stand = 22490, walk = 22490 },  -- XMAS13_SANTA_IN_CAGE
    [3040] = { stand = 22505, walk = 22506, run = 22506, walkLeft = 22506, walkRight = 22506, walkTurnLeft = 22506, walkTurnRight = 22506 },  -- XMAS13_PET_READY
    [3041] = { walk = 22487, run = 22488, walkLeft = 22487, walkRight = 22487, walkTurnLeft = 22487, walkTurnRight = 22487, idles = { { 22485, 90 }, { 22485, 10 } } },
    [3042] = { stand = 16878 },  -- CLAN_PLAYER_STOOL_SITTING_READY
    [3043] = { idles = { { 22525, 90 }, { 22526, 10 } } },
    [3044] = { stand = 22527 },  -- POP_CHEF_IDLE
    [3045] = { stand = 22531 },  -- POP_ARCHITECT_IDLE
    [3046] = { stand = 22524 },  -- POP_TRADER_IDLE
    [3047] = { stand = 22550, walk = 22551, run = 22551, turnLeft = 22552, turnRight = 22553 },  -- LUMBCAT_CS_CASUAL_IDLE_NO_WEAPON
    [3048] = { walk = 22551, run = 22551, turnLeft = 22552, turnRight = 22553, idles = { { 22550, 180 } } },
    [3049] = { walk = 22556, run = 22556, turnLeft = 22552, turnRight = 22553, idles = { { 22554, 200 } } },
    [3050] = { stand = 22416, walk = 22417, turnLeft = 22417, turnRight = 22417, walkTurnLeft = 22417, walkTurnRight = 22417 },  -- CANINE_DOG_MEDIUM_IDLE
    [3051] = { idles = { { 18015, 250 }, { 18015, 200 }, { 22564, 10 }, { 22565, 10 }, { 22566, 10 }, { 22567, 10 }, { 22568, 10 } } },
    [3052] = { stand = 22605, walk = 22606 },  -- MOLE2_GIANT_MOLE_IDLE
    [3053] = { stand = 22607, walk = 22608 },  -- MOLE2_BABY_MOLE_IDLE
    [3054] = { stand = 22638, walk = 22638 },  -- REST_PLAYER_SIT_RELAXED_MIDDLE_2013_UPDATE
    [3055] = { stand = 22635, walk = 22635 },  -- REST_PLAYER_SIT_RELAXED_ALT_MIDDLE_2013_UPDATE
    [3056] = { stand = 22641, walk = 22641 },  -- REST_PLAYER_SIT_STRAIGHT_MIDDLE_2013_UPDATE
    [3057] = { walk = 22673, run = 22674, idles = { { 22676, 95 }, { 22675, 5 } } },
    [3058] = { stand = 22697, walk = 22697, turnLeft = 22697, turnRight = 22697, walkBack = 22697, walkTurnLeft = 22697, walkTurnRight = 22697 },  -- TOWN_PLAYER_CLIMB_TREE_IDLE
    [3059] = { stand = 22690, walk = 22688, run = 22689, runBack = 22689, runLeft = 22689, runRight = 22689, turnLeft = 22690, turnRight = 22690, walkBack = 22688, walkLeft = 22688, walkRight = 22688, runTurnLeft = 22689, runTurnRight = 22689, walkTurnLeft = 22688, walkTurnRight = 22688 },  -- TOWNS_PLAYER_SWIMMING_IDLE
    [3060] = { stand = 15399, walk = 15399 },  -- OPN_PLAYER_FEMALE_DANCE
    [3061] = { stand = 15419, walk = 15419 },  -- OPN_PLAYER_MALE_DANCE
    [3062] = { stand = 6539, walk = 6541, run = 6541, runBack = 6541, runLeft = 6541, runRight = 6541, turnLeft = 6539, turnRight = 6539, runTurnLeft = 6541, runTurnRight = 6541, walkTurnLeft = 6541, walkTurnRight = 6541 },  -- WEREWOLF_UPDATE_READY
    [3063] = { stand = 5836, walk = 5968, run = 5968, runBack = 5968, runLeft = 5968, runRight = 5968, turnLeft = 5968, turnRight = 5968, walkBack = 5968, runTurnLeft = 5968, runTurnRight = 5968 },  -- MYQ5_JUVENATE_READY
    [3064] = { stand = 8593, walk = 819, run = 18017, runBack = 18017, runLeft = 18017, runRight = 18017, turnLeft = 819, turnRight = 819, walkBack = 8842, runTurnLeft = 18017, runTurnRight = 18017 },  -- MYQ5_HUMAN_VANESCULA_READY
    [3065] = { stand = 7005, walk = 7054, run = 7054, runBack = 7054, runLeft = 7054, runRight = 7054, walkBack = 7054, runTurnLeft = 7054, runTurnRight = 7054 },  -- MYQ5_VYREWATCH_FLYING_READY
    [3066] = { stand = 22702, walk = 22704, run = 22703, turnLeft = 22702, turnRight = 22702, walkBack = 22704, walkLeft = 22704, walkRight = 22704, walkTurnLeft = 22704, walkTurnRight = 22704 },  -- TOWN_PLAYER_RUN_AWAY_READY
    [3067] = { stand = 22706, walk = 22707, run = 22708, turnLeft = 22706, turnRight = 22706, walkBack = 22707, walkLeft = 22707, walkRight = 22707, walkTurnLeft = 22707, walkTurnRight = 22707 },  -- TOWN_VYREWATCH_RUN_AWAY_READY
    [3068] = { stand = 22711, walk = 22712, run = 22713, turnLeft = 22711, turnRight = 22711, walkBack = 22712, walkLeft = 22712, walkRight = 22712, walkTurnLeft = 22712, walkTurnRight = 22712 },  -- TOWN_PLAYER_HANDS_TIED_READY
    [3069] = { idles = { { 22714, 110 }, { 22715, 80 }, { 22716, 65 } } },
    [3070] = { walk = 22440, run = 22442, walkLeft = 22440, walkRight = 22440 },
    [3071] = { walk = 22787, run = 22788, turnLeft = 22787, turnRight = 22787, walkLeft = 22787, walkRight = 22787, walkTurnLeft = 22787, walkTurnRight = 22787, idles = { { 22786, 90 }, { 22786, 10 } } },
    [3072] = { stand = 22804, walk = 22804 },  -- OOAK_DRAGON_RIDER_INJURED_IDLE
    [3073] = { stand = 22802, walk = 22803, run = 22819, turnLeft = 22803, turnRight = 22803, walkLeft = 22803, walkRight = 22803, walkTurnLeft = 22803, walkTurnRight = 22803 },  -- OOAK_DRAGON_RIDER_IDLE
    [3074] = { stand = 22799, walk = 22799 },  -- OOAK_QBD_SLEEPING_IDLE
    [3075] = { stand = 22820 },  -- OOAK_WHITE_DRAGON_COWER
    [3076] = { stand = 22813, walk = 22813 },  -- OOAK_SOJ_FALL_TO_KNEE
    [3077] = { stand = 22817, walk = 22818, turnLeft = 22818, turnRight = 22818, walkLeft = 22818, walkRight = 22818, walkTurnLeft = 22818, walkTurnRight = 22818 },  -- OOAK_DRAGON_RIDER_B_IDLE
    [3078] = { stand = 22802, walk = 22803, run = 22819, turnLeft = 22803, turnRight = 22803, walkLeft = 22803, walkRight = 22803, walkTurnLeft = 22803, walkTurnRight = 22803 },  -- OOAK_DRAGON_RIDER_IDLE
    [3079] = { stand = 18723 },  -- TPR_PLAYER_WORLD_GATE_IDLE
    [3080] = { stand = 23173 },  -- TPR_CS_SHOT_1_EFFIGY_IDLE
    [3081] = { stand = 23159 },  -- TPR_CS_CRYSTAL_ZAROS
    [3082] = { stand = 22993, walk = 22994 },  -- TPR_ZAROS_SMOKE_IDLE
    [3083] = { stand = 23059 },  -- TPR_ZAROS_SMOKE_CHATHEAD_IDLE
    [3084] = { stand = 23012, walk = 23014, run = 23015, turnLeft = 23014, turnRight = 23014, runTurnLeft = 23015, runTurnRight = 23015, walkTurnLeft = 23014, walkTurnRight = 23014 },  -- TPR_NIHIL_IDLE
    [3085] = { walk = 22975, turnLeft = 22975, turnRight = 22975, walkTurnLeft = 22975, walkTurnRight = 22975, idles = { { 22976, 70 }, { 22977, 30 } } },
    [3086] = { stand = 22989, turnLeft = 22989, turnRight = 22989 },  -- TPR_ZAROS_ARMOUR_IDLE
    [3087] = { stand = 23053 },  -- TPR_DRAGON_RIDER_HOLOGRAPHIC_IDLE
    [3088] = { stand = 23006 },  -- TPR_CRYSTAL_SEREN_HOLOGRAPHIC_IDLE
    [3089] = { stand = 22942 },  -- TPR_SARADOMIN_HOLOGRAPHIC_IDLE
    [3090] = { stand = 22939 },  -- TPR_BANDOS_HOLOGRAPHIC_IDLE
    [3091] = { stand = 22934 },  -- TPR_ZAMORAK_HOLOGRAPHIC_IDLE
    [3092] = { stand = 22945 },  -- TPR_GUTHIX_HOLOGRAPHIC_IDLE
    [3093] = { stand = 22951 },  -- TPR_AZZANDRA_HOLOGRAPHIC_IDLE
    [3094] = { stand = 22954 },  -- TPR_SLISKE_HOLOGRAPHIC_IDLE
    [3095] = { stand = 22963 },  -- TPR_NEX_HOLOGRAPHIC_IDLE
    [3096] = { stand = 22969 },  -- TPR_CHAR_HOLOGRAPHIC_IDLE
    [3097] = { stand = 22960 },  -- TPR_DRAGONKIN_HOLOGRAPHIC_IDLE
    [3098] = { stand = 22972 },  -- TPR_ARMADYL_HOLOGRAPHIC_IDLE
    [3099] = { stand = 22951 },  -- TPR_AZZANDRA_HOLOGRAPHIC_IDLE
    [3100] = { stand = 22951 },  -- TPR_AZZANDRA_HOLOGRAPHIC_IDLE
    [3101] = { stand = 22957 },  -- TPR_LUCIEN_HOLOGRAPHIC_IDLE
    [3102] = { stand = 22948 },  -- TPR_ICTHLARIN_HOLOGRAPHIC_IDLE
    [3103] = { stand = 22966 },  -- TPR_KRILL_HOLOGRAPHIC_IDLE
    [3104] = { stand = 23000 },  -- TPR_LESSER_DEMON_HOLOGRAPHIC_IDLE
    [3105] = { stand = 23003 },  -- TPR_VYREWATCH_HOLOGRAPHIC_IDLE
    [3106] = { stand = 22997 },  -- TPR_OCELLUS_HOLOGRAPHIC_IDLE
    [3107] = { stand = 23079 },  -- TPR_ZAROS_CRYSTAL_HOLOGRAPHIC_IDLE
    [3108] = { stand = 23082 },  -- TPR_MUSPAH_HOLOGRAPHIC_IDLE
    [3109] = { stand = 23085 },  -- TPR_NIHIL_HOLOGRAPHIC_IDLE
    [3110] = { stand = 23088 },  -- TPR_FINAL_ZAROS_HOLOGRAPHIC_IDLE
    [3111] = { stand = 23091 },  -- TPR_WOODELF_HOLOGRAPHIC_IDLE
    [3112] = { stand = 23093 },  -- TPR_VAULTRAIDER_GUARDIAN_HOLOGRAPHIC_IDLE
    [3113] = { stand = 22924 },  -- TPR_DRAGON_RIDER_IDLE
    [3114] = { stand = 22992 },  -- TPR_CRYSTAL_SEREN_IDLE
    [3115] = { stand = 23105 },  -- TPR_SARADOMIN_IDLE
    [3116] = { stand = 23108 },  -- TPR_BANDOS_SMALL_IDLE
    [3117] = { stand = 23111 },  -- TPR_ZAMORAK_SMALL_IDLE
    [3118] = { stand = 19850 },  -- TSD_GUTHIX_HUMANOID_IDLE_DYING
    [3119] = { stand = 21774 },  -- SLISKE1_ICTHLARIN_IDLE
    [3120] = { stand = 17404 },  -- GODWARS_NEX_2012_READY
    [3121] = { stand = 15711 },  -- FMC_CHAR_IDLE
    [3122] = { stand = 11517 },  -- MAH5_DRAGONKIN_READY
    [3123] = { stand = 23134 },  -- TPR_ARMADYL_GOD_SMALL_IDLE
    [3124] = { stand = 11013 },  -- MAH5_MAHJARATT_READY
    [3125] = { stand = 11124 },  -- MAH5_MAHJARATT_READY_NO_LEAN_VAR_B
    [3126] = { stand = 11292 },  -- MAHJARRAT_2010_LUC2_LUCIEN_READY
    [3127] = { stand = 11013 },  -- MAH5_MAHJARATT_READY
    [3128] = { stand = 21745 },  -- SLISKE1_SLISKE_READY
    [3129] = { stand = 14967 },  -- RAND_BOSS_DEMON_GHAN_KO_READY
    [3130] = { stand = 23144 },  -- TPR_LESSER_DEMON_IDLE
    [3131] = { stand = 23147 },  -- TPR_VYREWATCH_IDLE
    [3132] = { stand = 20238 },  -- ASC_OCELLUS_IDLE
    [3133] = { stand = 7008, walk = 28432, run = 28432 },  -- VAULTRAIDER_GUARDIAN_READY
    [3134] = { stand = 23269, walk = 23272, run = 23273, walkBack = 23272, walkTurnLeft = 23272, walkTurnRight = 23272 },  -- _6AWE3_GORILLA_IDLE
    [3135] = { stand = 479 },  -- CAULDRON
    [3136] = { stand = 23277, walk = 23263, walkBack = 23263, walkTurnLeft = 23263, walkTurnRight = 23263 },  -- _6AWE3_MONKEY_IDLE
    [3137] = { stand = 23281 },  -- _6AWE3_MARIMBO_IDLE
    [3138] = { walk = 12860, idles = { { 23319, 120 }, { 23320, 60 } } },
    [3139] = { stand = 23449 },  -- ASH1_2014_CUTSCENE2_S3_AGOROTH_BREAKING_PLANKS
    [3140] = { stand = 23408 },  -- ASH1_2014_LUCY_SITTING_IDLE
    [3141] = { stand = 23434 },  -- ASH1_2014_LUCY_HAPPY_IDLE
    [3142] = { idles = { { 23415, 160 }, { 23416, 80 }, { 23396, 40 } } },
    [3143] = { walk = 23339, idles = { { 23340, 120 }, { 23342, 60 } } },
    [3144] = { walk = 23326, idles = { { 23327, 120 }, { 23328, 60 }, { 23329, 60 } } },
    [3145] = { stand = 23362 },  -- ASH1_2014_AGOROTH_BOSS_TENTACLE_RIGHT_A_IDLE
    [3146] = { stand = 23356 },  -- ASH1_2014_AGOROTH_BOSS_TENTACLE_LEFT_A_IDLE
    [3147] = { stand = 23374 },  -- ASH1_2014_AGOROTH_BOSS_TENTACLE_RIGHT_B_IDLE
    [3148] = { stand = 23368 },  -- ASH1_2014_AGOROTH_BOSS_TENTACLE_LEFT_B_IDLE
    [3149] = { stand = 23387 },  -- ASH1_2014_AGOROTH_BOSS_BODY_IDLE
    [3150] = { stand = 23382 },  -- ASH1_2014_AGOROTH_BOSS_HEAD_IDLE
    [3151] = { stand = 23431 },  -- ASH1_2014_HENDRIK_IN_PRISON
    [3152] = { stand = 23430 },  -- ASH1_2014_NED_IN_PRISON
    [3153] = { stand = 23432 },  -- ASH1_2014_MINER_IN_PRISON
    [3154] = { stand = 23428 },  -- ASH1_2014_AGOROTH_BOSS_HEAD_ANGERED
    [3155] = { idles = { { 23471, 130 }, { 23472, 60 }, { 23473, 90 } } },
    [3156] = { idles = { { 23474, 130 }, { 23475, 120 }, { 23476, 60 } } },
    [3157] = { stand = 23565, walk = 23573 },  -- OGE_2014_COW_UPDATE_READY
    [3158] = { stand = 23569, walk = 23574 },  -- OGE_2014_COW_CALF_UPDATE_READY
    [3159] = { stand = 22122, walk = 23575, turnLeft = 22141, turnRight = 22140, walkBack = 23575, walkLeft = 23575, walkRight = 23575 },  -- TUT5_ZOMBIE_COW_IDLE
    [3160] = { walk = 23576, run = 28436, turnLeft = 23581, turnRight = 23581, walkLeft = 23576, walkRight = 23576, walkTurnLeft = 23576, walkTurnRight = 23576, idles = { { 23577, 100 }, { 23583, 60 } } },
    [3161] = { stand = 22976, walk = 22975, run = 23605, turnLeft = 22975, turnRight = 22975, runTurnLeft = 23605, runTurnRight = 23605, walkTurnLeft = 22975, walkTurnRight = 22975 },  -- TPR_MUSPAH_IDLE
    [3162] = { stand = 23621, walk = 23622 },  -- MINOTAUR_2013_IDLE
    [3163] = { stand = 23634, walk = 23635, run = 23636 },  -- BAT_2013_IDLE
    [3164] = { stand = 23630, walk = 23632, run = 24020, turnLeft = 23632, turnRight = 23632, walkTurnLeft = 23632, walkTurnRight = 23632 },  -- SCORPION_READY
    [3165] = { idles = { { 23643, 100 } } },
    [3166] = { stand = 23655, walk = 819 },  -- MTX66_PLAYER_SINISTER_SLUMBER_REST_LOOP
    [3167] = { stand = 23661, walk = 819 },  -- MTX66_PLAYER_GOBLIN_RESTING_LOOP
    [3168] = { stand = 23670, walk = 819 },  -- MTX66_PLAYER_CHAIR_RESTING_LOOP
    [3169] = { stand = 23676, walk = 23677, run = 23678, turnLeft = 23677, turnRight = 23677, walkBack = 23677, walkLeft = 23677, walkRight = 23677 },  -- NJDUNG_HOPE_DEVOURER_PET_IDLE
    [3170] = { stand = 23679, walk = 23680, run = 23681, turnLeft = 23680, turnRight = 23680, walkBack = 23680, walkLeft = 23680, walkRight = 23680 },  -- NJDUNG_DRAGON_PET_IDLE
    [3171] = { stand = 23682, walk = 23683, run = 23684, turnLeft = 23683, turnRight = 23683, walkBack = 23683, walkLeft = 23683, walkRight = 23683 },  -- NJDUNG_BLINK_PET_IDLE
    [3172] = { stand = 23694, walk = 23695, turnLeft = 17388, turnRight = 23695, walkTurnLeft = 23695, walkTurnRight = 23695 },  -- QUEST_BANDOS_GRAARDOR_IDLE
    [3173] = { stand = 23704, walk = 23712, turnLeft = 23712, turnRight = 23712, walkTurnLeft = 23712, walkTurnRight = 23712 },  -- QUEST_BANDOS_YELPS_IDLE
    [3174] = { stand = 23703, walk = 23705, turnLeft = 23705, turnRight = 23705, walkTurnLeft = 23705, walkTurnRight = 23705 },  -- QUEST_BANDOS_ZANIK_IDLE
    [3175] = { stand = 23708 },  -- QUEST_BANDOS_TROLL_STAYDEAD
    [3176] = { stand = 23709 },  -- QUEST_BANDOS_YELPS_STAYDEAD
    [3177] = { walk = 23773, crawl = 23773, crawlBack = 23773, crawlLeft = 23773, crawlRight = 23773, run = 23773, runBack = 23773, runLeft = 23773, runRight = 23773, turnLeft = 23773, turnRight = 23773, walkBack = 23773, walkLeft = 23773, walkRight = 23773 },
    [3178] = { stand = 23776, walk = 23773, crawl = 23773, crawlBack = 23773, crawlLeft = 23773, crawlRight = 23773, run = 23773, runBack = 23773, runLeft = 23773, runRight = 23773, turnLeft = 23773, turnRight = 23773, walkBack = 23773, walkLeft = 23773, walkRight = 23773 },  -- TRH17_JAS_BALL_IDLE
    [3179] = { stand = 23780, walk = 23782, turnLeft = 23780, turnRight = 23780, walkLeft = 23782, walkRight = 23782, walkTurnLeft = 23782, walkTurnRight = 23782 },  -- HUMAN_2013_SHOPKEEPER_IDLE
    [3180] = { stand = 23781, walk = 23789, turnLeft = 23781, turnRight = 23781, walkLeft = 23789, walkRight = 23789, walkTurnLeft = 23789, walkTurnRight = 23789 },  -- HUMAN_2013_BANKER_IDLE
    [3181] = { stand = 23785, walk = 23788, turnLeft = 23785, turnRight = 23785, walkLeft = 23788, walkRight = 23788, walkTurnLeft = 23788, walkTurnRight = 23788 },  -- HUMAN_2013_SHOP_ASSISTANT_IDLE
    [3182] = { stand = 23786, walk = 23787, turnLeft = 23786, turnRight = 23786, walkLeft = 23787, walkRight = 23787, walkTurnLeft = 23787, walkTurnRight = 23787 },  -- HUMAN_2013_SHOP_OWNER_FEMALE
    [3183] = { stand = 23790, walk = 23791, turnLeft = 23790, turnRight = 23790, walkLeft = 23791, walkRight = 23791, walkTurnLeft = 23791, walkTurnRight = 23791 },  -- HUMAN_2013_SHOP_OWNER_MALE_IDLE
    [3184] = { stand = 23832, walk = 23831 },  -- NECHRYAEL_2012_READY
    [3185] = { stand = 23852, walk = 23854 },  -- ROCKSLUG_2012_READY
    [3186] = { stand = 23841, walk = 23843 },  -- MAGIC_AXE_2012_READY
    [3187] = { stand = 23838, walk = 23837 },  -- EARTHWARRIOR_2012_READY
    [3188] = { stand = 23874, walk = 23872 },  -- BASILISK_2012_READY
    [3189] = { stand = 23874, walk = 23880, run = 23881 },  -- BASILISK_2012_READY
    [3190] = { walk = 23900, run = 23901, turnLeft = 23900, turnRight = 23900, walkTurnLeft = 23900, walkTurnRight = 23900, idles = { { 23896, 90 }, { 23899, 10 } } },
    [3191] = { walk = 23908, run = 23909, turnLeft = 23908, turnRight = 23908, walkBack = 23908, walkLeft = 23908, walkRight = 23908, idles = { { 23906, 80 }, { 23907, 20 } } },
    [3192] = { stand = 24026, walk = 24025 },  -- _2013_DUST_DEVIL_IDLE
    [3193] = { stand = 23630, walk = 24020, run = 24024, turnLeft = 24020, turnRight = 24020, walkTurnLeft = 24020, walkTurnRight = 24020 },  -- SCORPION_READY
    [3194] = { stand = 23630, walk = 24024, run = 24024 },  -- SCORPION_READY
    [3195] = { stand = 24041, walk = 24042, run = 24043, runBack = 24052, walkBack = 24051, walkLeft = 24045, walkRight = 24045, walkTurnLeft = 24045, walkTurnRight = 24045 },  -- SB_SPIDER_BOSS_01_READY
    [3196] = { stand = 24063, walk = 24064, run = 24065, runBack = 24068, walkBack = 24067, walkLeft = 24066, walkRight = 24066, walkTurnLeft = 24066, walkTurnRight = 24066 },  -- SB_SPIDER_MINION_READY
    [3197] = { idles = { { 24058, 100 }, { 24059, 20 } } },
    [3198] = { stand = 24089, walk = 24090, run = 24091, runBack = 24098, walkBack = 24097, walkLeft = 24093, walkRight = 24093, walkTurnLeft = 24093, walkTurnRight = 24093 },  -- SB_SPIDER_BOSS_02_READY
    [3199] = { stand = 24116, walk = 24116, walkBack = 24116 },  -- SB_PLAYER_SPIDER_BOSS_COCOON_IDLE
    [3200] = { stand = 24157, walk = 24158, turnLeft = 24158, turnRight = 24158 },  -- OGE_2014_LUMBCAT_WRAITH_SPIDER_READY
    [3201] = { stand = 24174, walk = 24174 },  -- DSLAY_GIDEON_BEDE_EXHAUSTED_READY
    [3202] = { stand = 24169 },  -- DSLAY_2014_SPIRIT_BODY_READY
    [3203] = { stand = 24170 },  -- DSLAY_2014_SPIRIT_MIND_READY
    [3204] = { stand = 24171 },  -- DSLAY_2014_SPIRIT_FAITH_READY
    [3205] = { stand = 24182, walk = 7191, walkBack = 7192, walkLeft = 7193, walkRight = 7194 },  -- LUC2_2014_UPDATE_THAERISK_CEMPHIER_READY
    [3206] = { crawl = 24183, idles = { { 3824, 80 }, { 3817, 20 } } },
    [3207] = { idles = { { 24187, 120 }, { 24188, 50 } } },
    [3208] = { stand = 24164, walk = 24163, turnLeft = 24163, turnRight = 24163 },  -- OGE_2014_COCKROACH_READY_ONE_BY_ONE
    [3209] = { walk = 24191, turnLeft = 24194, turnRight = 24194, idles = { { 24192, 100 }, { 24193, 20 } } },
    [3210] = { stand = 24156, walk = 3083, run = 824, turnLeft = 3083, turnRight = 3083 },  -- LUMBCAT_2014_XENIA_UNINJURED_READY
    [3211] = { stand = 24196, walk = 23778, turnLeft = 23778, turnRight = 23778, walkTurnLeft = 23778, walkTurnRight = 23778 },  -- ELF_CITY_2014_ELF_CHILDREN_IDLE_GIRL
    [3212] = { stand = 24198 },  -- ELF_CITY_2014_ELF_CHILDREN_SITTING_ON_ROCK_LOW
    [3213] = { stand = 813, walk = 24204, walkBack = 1206, walkLeft = 1207, walkRight = 1208 },  -- HUMAN_STAFFREADY
    [3214] = { stand = 24217, walk = 24217 },  -- QUEST_ELF_FINALE_LADY_TRAHAEARN_SLEEPING
    [3215] = { stand = 24221, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- QUEST_ELF_FINALE_LADY_ITHELL_SINGING
    [3216] = { stand = 24219, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- QUEST_ELF_FINALE_LORD_AMLODD_SINGING
    [3217] = { stand = 24222, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- QUEST_ELF_FINALE_LORD_CADARN_SINGING
    [3218] = { stand = 24225, walk = 24225 },  -- QUEST_ELF_FINALE_DARK_LORD_IDLE
    [3219] = { stand = 24231, walk = 24231 },  -- QUEST_ELF_FINALE_DARK_LORD_WEAKEN_IDLE
    [3220] = { stand = 24260, walk = 24260 },  -- QUEST_ELF_FINALE_GREATER_SHADOW_IDLE
    [3221] = { stand = 24260, walk = 24260 },  -- QUEST_ELF_FINALE_GREATER_SHADOW_IDLE
    [3222] = { stand = 19628, walk = 17974, turnLeft = 17974, turnRight = 17974 },  -- QUEST_ELF_FINALE_LORD_CRWYS_IDLE_EXTRA
    [3223] = { stand = 24211, walk = 17974, turnLeft = 17974, turnRight = 17974 },  -- QUEST_ELF_FINALE_LORD_AMLODD_IDLE
    [3224] = { stand = 24213, walk = 17974, turnLeft = 17974, turnRight = 17974 },  -- QUEST_ELF_FINALE_LORD_CADARN_IDLE
    [3225] = { stand = 24265, walk = 17974, turnLeft = 17974, turnRight = 17974 },  -- QUEST_ELF_FINALE_LORD_IORWORTH_IDLE
    [3226] = { stand = 24214, walk = 18040, turnLeft = 18040, turnRight = 18040 },  -- QUEST_ELF_FINALE_LADY_ITHELL_IDLE
    [3227] = { stand = 24212, walk = 18040, turnLeft = 18040, turnRight = 18040 },  -- QUEST_ELF_FINALE_LADY_HEFIN_IDLE
    [3228] = { stand = 24216, walk = 18040, turnLeft = 18040, turnRight = 18040 },  -- QUEST_ELF_FINALE_LADY_TRAHAEARN_IDLE
    [3229] = { stand = 24267, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- QUEST_ELF_FINALE_GWIR_IDLE
    [3230] = { stand = 24268, walk = 24268 },  -- QUEST_ELF_FINALE_ELF_MOURNER_DEFEATED_IDLE
    [3231] = { stand = 23790, walk = 18020, turnLeft = 23790, turnRight = 23790, walkLeft = 18020, walkRight = 18020, walkTurnLeft = 18020, walkTurnRight = 18020 },  -- HUMAN_2013_SHOP_OWNER_MALE_IDLE
    [3232] = { stand = 24269, walk = 24269 },  -- ELF_SEREN_ORB_IDLE
    [3233] = { stand = 24206, walk = 24271 },  -- KALPHITE_QUEEN_2014_READY
    [3234] = { stand = 24272, walk = 24273 },  -- KALPHITE_QUEEN_2_2014_READY
    [3235] = { stand = 24321, walk = 24321 },  -- BSLAY_2014_MUNCHER_ASLEEP
    [3236] = { stand = 17432, walk = 24322, turnLeft = 24322, turnRight = 24322, walkTurnLeft = 24322, walkTurnRight = 24322 },  -- GODWARS_BLOODVELD_2012_READY
    [3237] = { stand = 24302 },  -- TRH26_GENIE_IDLE
    [3238] = { stand = 24335, walk = 24336, turnLeft = 24363, turnRight = 24364 },  -- GAME_BARBASSAULT_PENANCE_KING_IDLE
    [3239] = { stand = 24386, walk = 24387, turnLeft = 24387, turnRight = 24387 },  -- GAME_BARBASSAULT_PENANCE_QUEEN_READY
    [3240] = { stand = 24340, walk = 24340, turnLeft = 24340, turnRight = 24340 },  -- GAME_BARBASSAULT_PENANCE_KING_MODE_TWO_READY
    [3241] = { stand = 24324, walk = 24323, turnLeft = 24324, turnRight = 24324 },  -- GAME_BARBASSAULT_PENANCE_SPAWN_IDLE
    [3242] = { stand = 24352, walk = 24352, turnLeft = 24352, turnRight = 24352 },  -- GAME_BARBASSAULT_PLAYER_FLAMETHROWER_ATTACK_LOOP
    [3243] = { stand = 24335, walk = 24332, turnLeft = 24332, turnRight = 24332 },  -- GAME_BARBASSAULT_PENANCE_KING_IDLE
    [3244] = { stand = 24366, walk = 24365, run = 24371, turnLeft = 24365, turnRight = 24365 },  -- GAME_BARBASSAULT_PENANCE_HEALER_IDLE
    [3245] = { walk = 24403, run = 24410, turnLeft = 24403, turnRight = 24403, walkTurnLeft = 24403, walkTurnRight = 24403, idles = { { 24409, 90 }, { 24408, 10 } } },
    [3246] = { walk = 24419, run = 24421, turnLeft = 24419, turnRight = 24419, walkTurnLeft = 24419, walkTurnRight = 24419, idles = { { 24420, 90 }, { 24424, 10 } } },
    [3247] = { walk = 24412, run = 24413, turnLeft = 24412, turnRight = 24412, walkTurnLeft = 24412, walkTurnRight = 24412, idles = { { 24411, 90 }, { 24416, 10 } } },
    [3248] = { stand = 24439, walk = 24446, run = 24447 },  -- _2013_KURASK_IDLE
    [3249] = { stand = 24429, walk = 24430, run = 24437 },  -- DT14_ABYSSAL_DEMON_READY
    [3250] = { stand = 24439, walk = 24440, run = 24446 },  -- _2013_KURASK_IDLE
    [3251] = { stand = 24483, walk = 24480 },  -- FIEND_2014_BABY_READY
    [3252] = { stand = 24506 },  -- RUNEMACH_GOLDBERG_IDLE
    [3253] = { stand = 24509, walk = 24510, turnLeft = 24510, turnRight = 24510, walkLeft = 24510, walkRight = 24510, walkTurnLeft = 24510, walkTurnRight = 24510 },  -- TRH29_PIRATE_SHEEP_IDLE
    [3254] = { stand = 24516, walk = 24517 },  -- CAVE_CRAWLER_2013_IDLE
    [3255] = { stand = 24549 },  -- ELF_2014_PLAYER_SIT_ON_THRONE_IDLE
    [3256] = { stand = 24561, walk = 24561 },  -- ELF_2014_LIGHT_CREATURE_FAMILIAR_IDLE_WALK
    [3257] = { stand = 24574, walk = 24574 },  -- ELF_2014_SLAYER_MASTER_IDLE
    [3258] = { stand = 17973, walk = 17974, turnLeft = 17974, turnRight = 17974, walkLeft = 18020, walkRight = 18020, walkTurnLeft = 18020, walkTurnRight = 18020 },  -- COMBAT_2012_CASUAL_IDLE
    [3259] = { stand = 12476 },  -- CLAN_EMOTE_POINTING
    [3260] = { stand = 15812 },  -- OMGE_NPC_SOLDIER_READY
    [3261] = { stand = 20058 },  -- MTX30_PLAYER_GESTICULATING
    [3262] = { stand = 20078 },  -- MTX30_PLAYER_WHAT_ME_EMOTE
    [3263] = { stand = 22146 },  -- TUT5_VILLAGER_MALE_ARGUING
    [3264] = { stand = 22112 },  -- TUT5_VILLAGER_FEMALE_3_CHEER
    [3265] = { stand = 20071 },  -- MTX30_PLAYER_TALKING_A
    [3266] = { stand = 20072 },  -- MTX30_PLAYER_TALKING_B
    [3267] = { stand = 20062 },  -- MTX30_PLAYER_THINKING_GENTLE
    [3268] = { stand = 35809 },  -- EMOTION_MTX30_PLAYER_WORRIED
    [3269] = { stand = 20069 },  -- MTX30_PLAYER_SOBBING_GENTLE
    [3270] = { stand = 20059 },  -- MTX30_PLAYER_NOD
    [3271] = { idles = { { 24603, 90 }, { 24604, 10 } } },
    [3272] = { stand = 24223, walk = 18040, run = 18040, turnLeft = 18040, turnRight = 18040 },  -- QUEST_ELF_FINALE_FEMALE_IDLE
    [3273] = { stand = 24215, walk = 17974, run = 17974, turnLeft = 17974, turnRight = 17974 },  -- QUEST_ELF_FINALE_MALE_IDLE
    [3274] = { stand = 24655, walk = 24656 },  -- GARGOYLE_2013_IDLE
    [3275] = { stand = 24688, walk = 819 },  -- MTX_RESTING_EMOTE_RECHARGE_LOOP
    [3276] = { stand = 24682, walk = 819 },  -- MTX73_PRACTISE_MAKES_PERFECT
    [3277] = { stand = 24649, walk = 819 },  -- MTX74_PLAYER_ELF_CITY_REST_LOOP
    [3278] = { stand = 24352, walk = 24746, turnLeft = 24746, turnRight = 24746 },  -- GAME_BARBASSAULT_PLAYER_FLAMETHROWER_ATTACK_LOOP
    [3279] = { stand = 24707, walk = 24702 },  -- HW14_MIRROR_IDLE
    [3280] = { stand = 12298, walk = 24703 },  -- DRAYNOR_CANDLES
    [3281] = { stand = 24709, walk = 24704 },  -- HW14_CHAIR_IDLE
    [3282] = { stand = 24710, walk = 24705 },  -- HW14_WARDROBE_IDLE
    [3283] = { stand = 24711, walk = 24706 },  -- HW14_POSH_STOOL_IDLE
    [3284] = { stand = 24718, walk = 24721, turnLeft = 24718, turnRight = 24718, walkLeft = 24721, walkRight = 24721, walkTurnLeft = 24721, walkTurnRight = 24721 },  -- HW14_BASIC_GHOST_IDLE
    [3285] = { stand = 24720, walk = 24723, turnLeft = 24720, turnRight = 24720, walkLeft = 24723, walkRight = 24723, walkTurnLeft = 24723, walkTurnRight = 24723 },  -- HW14_TINY_GHOST_IDLE
    [3286] = { stand = 24719, walk = 24722, turnLeft = 24719, turnRight = 24719, walkLeft = 24722, walkRight = 24722, walkTurnLeft = 24722, walkTurnRight = 24722 },  -- HW14_WAILING_GHOST_IDLE
    [3287] = { stand = 24739, walk = 24740, turnLeft = 24739, turnRight = 24739, walkLeft = 24740, walkRight = 24740, walkTurnLeft = 24740, walkTurnRight = 24740 },  -- HW14_DEMONIC_GHOST_IDLE
    [3288] = { stand = 24764, walk = 24765, run = 24766, walkBack = 24765, walkLeft = 24765, walkRight = 24765, walkTurnLeft = 24765, walkTurnRight = 24765 },  -- DIVDND_PLAYER_CARRY_JAR_MEDIUM_IDLE
    [3289] = { stand = 24763, walk = 24767, run = 24768, walkBack = 24767, walkLeft = 24767, walkRight = 24767, walkTurnLeft = 24767, walkTurnRight = 24767 },  -- DIVDND_PLAYER_CARRY_JAR_LARGE_IDLE
    [3290] = { walk = 19824, run = 19929, walkBack = 19824, walkLeft = 19824, walkRight = 19824, walkTurnLeft = 19824, walkTurnRight = 19824, idles = { { 19823, 80 }, { 19827, 20 } } },
    [3291] = { stand = 24753 },  -- DIVDND_GUARDIAN_DEACTIVATED_NULL
    [3292] = { stand = 24797, walk = 24796, turnLeft = 24796, turnRight = 24796, walkLeft = 24796, walkRight = 24796, walkTurnLeft = 24796, walkTurnRight = 24796 },  -- HOUSE_2014_ORMOD_GULVAS_IDLE
    [3293] = { idles = { { 24806, 90 }, { 24806, 10 } } },
    [3294] = { stand = 24802 },  -- HOUSE_2014_MOTIONLESS_SERVANT_IDLE
    [3295] = { stand = 24844 },  -- HOUSE_2014_MOTIONLESS_SERVANT_COLLAPSING_DEAD
    [3296] = { stand = 24856 },  -- HOUSE_2014_DEAD_SERVANT_AGAINST_DOOR
    [3297] = { stand = 24804 },  -- HOUSE_2014_SCARED_SERVANT_IDLE
    [3298] = { stand = 24860 },  -- HOUSE_2014_SERVANT_NO_FACE_IDLE
    [3299] = { stand = 24807, walk = 24808 },  -- HOUSE_2014_SENECIANUS_IDLE
    [3300] = { walk = 24841, run = 24822, turnLeft = 24841, turnRight = 24841, walkLeft = 24841, walkRight = 24841, walkTurnLeft = 24841, walkTurnRight = 24841, idles = { { 24820, 95 }, { 24821, 5 } } },
    [3301] = { walk = 24814, run = 24815, turnLeft = 24814, turnRight = 24814, walkLeft = 24814, walkRight = 24814, walkTurnLeft = 24814, walkTurnRight = 24814, idles = { { 24811, 97 }, { 24812, 2 }, { 24813, 1 } } },
    [3302] = { stand = 24817, walk = 24816, turnLeft = 24816, turnRight = 24816, walkLeft = 24816, walkRight = 24816, walkTurnLeft = 24816, walkTurnRight = 24816 },  -- HOUSE_2014_LENIAN_IDLE_ENDING
    [3303] = { stand = 24850, walk = 24851, turnLeft = 24851, turnRight = 24851, walkLeft = 24851, walkRight = 24851, walkTurnLeft = 24851, walkTurnRight = 24851 },  -- HOUSE_2014_LENIAN_IDLE_NON_TRANSPARENT
    [3304] = { stand = 23679, walk = 23680, run = 23681, turnLeft = 23680, turnRight = 23680, walkBack = 23680, walkLeft = 23680, walkRight = 23680 },  -- NJDUNG_DRAGON_PET_IDLE
    [3305] = { stand = 23679, walk = 24990, run = 23680, turnLeft = 24990, turnRight = 24990, walkBack = 24990, walkLeft = 24990, walkRight = 24990 },  -- NJDUNG_DRAGON_PET_IDLE
    [3306] = { stand = 24979, walk = 24980, run = 24986 },  -- JELLY_2013_IDLE
    [3307] = { stand = 24533, walk = 24533, turnLeft = 24533, turnRight = 24533 },  -- ELF_2014_PLAYER_DEFAULT_BALANCE_IDLE
    [3308] = { stand = 24533, walk = 24533, turnLeft = 24533, turnRight = 24533 },  -- ELF_2014_PLAYER_DEFAULT_BALANCE_IDLE
    [3309] = { stand = 25035 },  -- ELF_CITY_PART2_MUSICIAN_PLAYING_HARP
    [3310] = { stand = 25029, walk = 17974, turnLeft = 17974, turnRight = 17974, walkBack = 17974, walkLeft = 17974, walkRight = 17974 },  -- ELF_CITY_PART2_IMPLING_COLLECTOR
    [3311] = { stand = 25030 },  -- ELF_2014_CRWYS_SPIRIT_TREE_IDLE
    [3312] = { stand = 25075, walk = 25076, run = 25076 },  -- ELF_CITY_PART2_DARK_LORD_PET_IDLE
    [3313] = { stand = 25033, walk = 25032, turnLeft = 25032, turnRight = 25032 },  -- ELF_CITY_PART2_WATERINGCAN_IDLE
    [3314] = { stand = 25132, walk = 25133, run = 25128, turnLeft = 25133, turnRight = 25133, walkBack = 25133, walkLeft = 25133, walkRight = 25133 },  -- ELF_CITY_PART2_EDIMMU_PET_IDLE
    [3315] = { stand = 25129, walk = 25130, turnLeft = 25130, turnRight = 25130, walkBack = 25130, walkLeft = 25130, walkRight = 25130 },  -- ELF_CITY_PART2_EDIMMU_IDLE
    [3316] = { stand = 25129, walk = 25135, turnLeft = 25135, turnRight = 25135, walkBack = 25135, walkLeft = 25135, walkRight = 25135 },  -- ELF_CITY_PART2_EDIMMU_IDLE
    [3317] = { stand = 25043 },  -- ELF_CITY_PART2_IMPLING_A_IDLE
    [3318] = { stand = 25044 },  -- ELF_CITY_PART2_IMPLING_B_IDLE
    [3319] = { stand = 25045 },  -- ELF_CITY_PART2_IMPLING_C_IDLE
    [3320] = { stand = 25046 },  -- ELF_CITY_PART2_IMPLING_D_IDLE
    [3321] = { stand = 25047 },  -- ELF_CITY_PART2_IMPLING_E_IDLE
    [3322] = { walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020, idles = { { 18019, 80 }, { 196, 20 } } },
    [3323] = { stand = 25249, walk = 25250, run = 25251, runBack = 25253, walkBack = 25252, walkTurnLeft = 25250, walkTurnRight = 25250 },  -- QUEST_ELDER_GOLEM_READY
    [3324] = { stand = 25268, walk = 25269, run = 25270, walkTurnLeft = 25269, walkTurnRight = 25269 },  -- QUEST_ELDER_GOLEM_EXPLODER_MINION_READY
    [3325] = { stand = 25254, walk = 25258, walkBack = 25309, walkTurnLeft = 25258, walkTurnRight = 25258 },  -- QUEST_ELDER_ABYSSAL_READY
    [3326] = { stand = 25314, walk = 25312, run = 25313, walkTurnLeft = 25312, walkTurnRight = 25312 },  -- QUEST_ELDER_ELDERGOD_GOLEM_PET_IDLE
    [3327] = { walk = 25338, run = 25339, turnLeft = 25334, turnRight = 25334, walkBack = 25338, walkLeft = 25338, walkRight = 25338, idles = { { 25334, 80 }, { 25335, 20 } } },
    [3328] = { stand = 25343, walk = 25342, run = 25341, walkBack = 25342, walkLeft = 25342, walkRight = 25342 },  -- MTX_PAYPAL_KATANA_IDLE
    [3329] = { walk = 25347, run = 25346, turnLeft = 25347, turnRight = 25347, walkTurnLeft = 25347, walkTurnRight = 25347, idles = { { 25344, 90 }, { 25345, 10 } } },
    [3330] = { stand = 22675 },  -- TRH_PET_CHEST_IDLE_EXTRA
    [3331] = { walk = 25359, run = 25360, runBack = 25357, turnLeft = 25357, turnRight = 25357, walkBack = 25357, walkTurnLeft = 25359, walkTurnRight = 25359, idles = { { 25357, 80 }, { 25358, 20 } } },
    [3332] = { stand = 15112, walk = 15112 },  -- XMAS10_TREE_READY
    [3333] = { stand = 25321, walk = 25320, turnLeft = 25321, turnRight = 25321, walkBack = 25320, walkLeft = 25320, walkRight = 25320 },  -- XMAS2014_SANTA_IDLE
    [3334] = { stand = 25406, walk = 25402, run = 25403, turnLeft = 25406, turnRight = 25406, walkBack = 25402, walkLeft = 25402, walkRight = 25402 },  -- XMAS14_BAUBLES_IDLE
    [3335] = { stand = 25409, walk = 25407, run = 25408, turnLeft = 25409, turnRight = 25409, walkBack = 25407, walkLeft = 25407, walkRight = 25407 },  -- XMAS14_STOCKING_IDLE
    [3336] = { stand = 25374, walk = 25374, run = 25374, turnLeft = 25374, turnRight = 25374, walkBack = 25374, walkLeft = 25374, walkRight = 25374 },  -- XMAS14_SNOWMAN_BOSS_SMALL_IDLE
    [3337] = { stand = 25376, walk = 25376, run = 25376, turnLeft = 25376, turnRight = 25376, walkBack = 25376, walkLeft = 25376, walkRight = 25376 },  -- XMAS14_SNOWMAN_BOSS_MEDIUM_IDLE
    [3338] = { stand = 25378, walk = 25378, run = 25378, turnLeft = 25378, turnRight = 25378, walkBack = 25378, walkLeft = 25378, walkRight = 25378 },  -- XMAS14_SNOWMAN_BOSS_LARGE_IDLE
    [3339] = { stand = 25369, walk = 25370, run = 25371, turnLeft = 25370, turnRight = 25370, walkBack = 25370, walkLeft = 25370, walkRight = 25371 },  -- XMAS14_SNOWMAN_BOSS_SMALLEST_IDLE
    [3340] = { stand = 25383, walk = 25383, run = 25383, turnLeft = 25383, turnRight = 25383, walkBack = 25383, walkLeft = 25383, walkRight = 25383 },  -- XMAS14_SNOWMAN_BOSS_LARGE_TURRET_ATTACK
    [3341] = { stand = 20358, walk = 20358, run = 20358, runBack = 20358, runLeft = 20358, runRight = 20358, turnLeft = 20358, turnRight = 20358, walkBack = 20358, runTurnLeft = 20358, runTurnRight = 20358, walkTurnLeft = 20358, walkTurnRight = 20358 },  -- BOSS2_BOSS_ATTACK_MAGIC_PROJ
    [3342] = { stand = 25435 },  -- XMAS2014_TEST_BOSS2_A_IDLE
    [3343] = { stand = 25437 },  -- XMAS2014_TEST_BOSS2_B_IDLE
    [3344] = { stand = 25439 },  -- XMAS2014_TEST_BOSS2_C_IDLE
    [3345] = { stand = 25410, walk = 25415, run = 25446, turnLeft = 25410, turnRight = 25410, walkBack = 25415, walkLeft = 25415, walkRight = 25415 },  -- XMAS14_PLAYER_SNOWBOARD_IDLE
    [3346] = { stand = 25442 },  -- ATELF_ELF_HOLD_WISP_IDLE
    [3347] = { stand = 38099, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- PLAYER_COMBAT_ABILITY_NECROMANCY_SPECTRAL_SCYTHE_RECAST_1_CORRUPTED
    [3348] = { stand = 25445 },  -- ATELF_CHILD_ELF_IDLE
    [3349] = { stand = 25410, walk = 25412, run = 25413, turnLeft = 25410, turnRight = 25410, walkBack = 25412, walkLeft = 25412, walkRight = 25412 },  -- XMAS14_PLAYER_SNOWBOARD_IDLE
    [3350] = { stand = 25453, walk = 25453, run = 25453, turnLeft = 25456, turnRight = 25455, walkLeft = 25456, walkRight = 25455 },  -- XMAS14_PLAYER_SNOWBOARD_GRIND
    [3351] = { stand = 25461 },  -- MTX76_COMBAT_DUMMY_DWARF_HIDDEN_IDLE
    [3352] = { stand = 25466 },  -- MTX76_COMBAT_DUMMY_DWARF_IDLE
    [3353] = { stand = 25469, walk = 25470, run = 25471 },  -- TRH40_BATTLESHIPS_IDLE
    [3354] = { stand = 25473, walk = 25470, run = 25471 },  -- TRH40_BATTLESHIPS_IDLE_COMBAT
    [3355] = { stand = 25483, walk = 25484, run = 25485, walkBack = 25484, walkLeft = 25484, walkRight = 25484, walkTurnLeft = 25484, walkTurnRight = 25484 },  -- BOSSPETS_ZILYANA_IDLE
    [3356] = { stand = 25488, walk = 25489, run = 25490, walkBack = 25489, walkLeft = 25489, walkRight = 25489, walkTurnLeft = 25489, walkTurnRight = 25489 },  -- BOSSPETS_GRAARDOR_IDLE
    [3357] = { stand = 25493, walk = 25494, run = 25495, walkBack = 25494, walkLeft = 25494, walkRight = 25494, walkTurnLeft = 25494, walkTurnRight = 25494 },  -- BOSSPETS_KREE_ARRA_IDLE
    [3358] = { stand = 25498, walk = 25499, run = 25500, walkBack = 25499, walkLeft = 25499, walkRight = 25499, walkTurnLeft = 25499, walkTurnRight = 25499 },  -- BOSSPETS_NEX_IDLE
    [3359] = { stand = 25503, walk = 25504, run = 25505, walkBack = 25504, walkLeft = 25504, walkRight = 25504, walkTurnLeft = 25504, walkTurnRight = 25504 },  -- BOSSPETS_KRIL_IDLE
    [3360] = { stand = 5248, walk = 25508, run = 25508, walkBack = 25508, walkLeft = 25508, walkRight = 25508, walkTurnLeft = 25508, walkTurnRight = 25508 },  -- ELEMENTAL_UPDATE_CHAOS_READY
    [3361] = { stand = 25511, walk = 25512, run = 25513, walkBack = 25512, walkLeft = 25512, walkRight = 25512, walkTurnLeft = 25512, walkTurnRight = 25512 },  -- BOSSPETS_LEGIO_IDLE
    [3362] = { stand = 25516, walk = 25517, run = 25518, walkBack = 25517, walkLeft = 25517, walkRight = 25517, walkTurnLeft = 25517, walkTurnRight = 25517 },  -- BOSSPETS_KALPHITE_KING_IDLE
    [3363] = { stand = 25521, walk = 25522, run = 25523, walkBack = 25522, walkLeft = 25522, walkRight = 25522, walkTurnLeft = 25522, walkTurnRight = 25522 },  -- BOSSPETS_KALPHITE_QUEEN_1_IDLE
    [3364] = { stand = 25526, walk = 25527, run = 25527, walkBack = 25527, walkLeft = 25527, walkRight = 25527, walkTurnLeft = 25527, walkTurnRight = 25527 },  -- BOSSPETS_KALPHITE_QUEEN_2_IDLE
    [3365] = { stand = 25530, walk = 25531, run = 25532, walkBack = 25531, walkLeft = 25531, walkRight = 25531, walkTurnLeft = 25531, walkTurnRight = 25531 },  -- BOSSPETS_CORPBEAST_IDLE
    [3366] = { stand = 25535, walk = 25536, run = 25537, walkBack = 25536, walkLeft = 25536, walkRight = 25536, walkTurnLeft = 25536, walkTurnRight = 25536 },  -- BOSSPETS_MOLE_IDLE
    [3367] = { stand = 25538, walk = 25539, run = 25540, turnLeft = 25539, turnRight = 25539, walkBack = 25539, walkLeft = 25539, walkRight = 25539, walkTurnLeft = 25539, walkTurnRight = 25539 },  -- BOSSPETS_ARAXXOR_IDLE
    [3368] = { stand = 25541, walk = 25542, run = 25543, walkBack = 25542, walkLeft = 25542, walkRight = 25542, walkTurnLeft = 25542, walkTurnRight = 25542 },  -- BOSSPETS_KBD_IDLE
    [3369] = { stand = 25546, walk = 25547, run = 25548, walkBack = 25547, walkLeft = 25547, walkRight = 25547, walkTurnLeft = 25547, walkTurnRight = 25547 },  -- BOSSPETS_HARAKEN_IDLE
    [3370] = { stand = 25549, walk = 25565, run = 25566, walkBack = 25565, walkLeft = 25565, walkRight = 25565, walkTurnLeft = 25565, walkTurnRight = 25565 },  -- BOSSPETS_QBD_IDLE
    [3371] = { stand = 25550, walk = 25551, run = 25552, walkBack = 25551, walkLeft = 25551, walkRight = 25551, walkTurnLeft = 25551, walkTurnRight = 25551 },  -- BOSSPETS_DAGANNOTH_IDLE
    [3372] = { stand = 25569, walk = 25570, run = 25576, runBack = 25573, runLeft = 25574, runRight = 25575, turnLeft = 25571, turnRight = 25572, walkBack = 25573, walkLeft = 25574, walkRight = 25575, walkTurnLeft = 25571, walkTurnRight = 25572 },  -- BOSSPETS_DUCK_IDLE
    [3373] = { stand = 25580, walk = 25584, run = 25585, turnLeft = 15272, turnRight = 15273, walkLeft = 15272, walkRight = 15273 },  -- LORE_WAR_TORTOISE_2014_IDLE
    [3374] = { walk = 25592, idles = { { 25591, 85 }, { 25590, 170 } } },
    [3375] = { stand = 25593 },  -- WOM_HUMAN_2014_STOOL_SITTING
    [3376] = { stand = 25621, walk = 25622, run = 25611 },  -- POP3_TENGU_CUTSCENE_BAS_IDLE
    [3377] = { stand = 25609 },  -- POP3_TENGU_NPC_IDLE_EDIT
    [3378] = { stand = 25623, walk = 25624, run = 25625 },  -- POP3_2014_CUTSCENE_EXILE_IDLE
    [3379] = { stand = 25635 },  -- POP3_2014_IDLE_EXILE_EXTRA
    [3380] = { stand = 25636, walk = 25637, run = 25638 },  -- POP3_2014_CUTSCENE_MEMORY_IDLE
    [3381] = { stand = 25647 },  -- POP3_2014_MEMORY_IDLE
    [3382] = { stand = 25666, walk = 25665, run = 25667, turnLeft = 25668, turnRight = 25668, walkBack = 25669, walkLeft = 25670, walkRight = 25671 },  -- TRH46_PLAYER_SWAG_CANE_IDLE
    [3383] = { stand = 25672, walk = 25674, run = 25675, turnLeft = 25674, turnRight = 25674 },  -- TRH46_PLAYER_SILVERHAWK_IDLE
    [3384] = { stand = 25677, walk = 25697, run = 25682, runBack = 25687, turnLeft = 25692, turnRight = 25692, walkBack = 25702, walkLeft = 25692, walkRight = 25692 },  -- MTX83_PLAYER_NOMAD_OUTFIT_IDLE_STAFF
    [3385] = { stand = 25678, walk = 25698, run = 25683, runBack = 25688, turnLeft = 25693, turnRight = 25693, walkBack = 25703, walkLeft = 25693, walkRight = 25693 },  -- MTX83_PLAYER_NOMAD_OUTFIT_IDLE_SHIELD
    [3386] = { stand = 25679, walk = 25699, run = 25684, runBack = 25689, turnLeft = 25694, turnRight = 25694, walkBack = 25704, walkLeft = 25694, walkRight = 25694 },  -- MTX83_PLAYER_NOMAD_OUTFIT_IDLE_2H_SWORD
    [3387] = { stand = 25680, walk = 25700, run = 25685, runBack = 25690, turnLeft = 25695, turnRight = 25695, walkBack = 25705, walkLeft = 25695, walkRight = 25695 },  -- MTX83_PLAYER_NOMAD_OUTFIT_IDLE_BOW
    [3388] = { stand = 25681, walk = 25701, run = 25686, runBack = 25691, turnLeft = 25696, turnRight = 25696, walkBack = 25706, walkLeft = 25696, walkRight = 25696 },  -- MTX83_PLAYER_NOMAD_OUTFIT_IDLE_UNARMED
    [3389] = { stand = 25717, walk = 25716, turnLeft = 25716, turnRight = 25716, walkLeft = 25716, walkRight = 25716, walkTurnLeft = 25716, walkTurnRight = 25716 },  -- DEMON_RAID_UPDATE_IDLE
    [3390] = { stand = 25767, walk = 16482, turnLeft = 16482, turnRight = 16482, walkBack = 16482, walkLeft = 16482, walkRight = 16482, walkTurnLeft = 16482, walkTurnRight = 16482 },  -- SLISKE2_MOIA_IDLE
    [3391] = { stand = 25769, walk = 25770, run = 18021, turnLeft = 25770, turnRight = 25770, walkBack = 25770, walkLeft = 25770, walkRight = 25770, walkTurnLeft = 25770, walkTurnRight = 25770 },  -- SLISKE2_ZAMORAK_IDLE
    [3392] = { stand = 25772, walk = 25773, run = 25773, runBack = 25773, runLeft = 25773, runRight = 25773, turnLeft = 25773, turnRight = 25773, walkBack = 25773, walkLeft = 25773, walkRight = 25773, runTurnLeft = 25773, runTurnRight = 25773, walkTurnLeft = 25773, walkTurnRight = 25773 },  -- SLISKE2_PLAYER_STEALTH_IDLE
    [3393] = { stand = 25772, walk = 25775, turnLeft = 25775, turnRight = 25775, walkBack = 25775, walkLeft = 25775, walkRight = 25775, walkTurnLeft = 25775, walkTurnRight = 25775 },  -- SLISKE2_PLAYER_STEALTH_IDLE
    [3394] = { stand = 25830, walk = 25830 },  -- SLISKE2_LORD_DAQUARIUS_DECODING_IDLE
    [3395] = { stand = 25845, walk = 25846, run = 25847, turnLeft = 25846, turnRight = 25846, walkBack = 25846, walkLeft = 25846, walkRight = 25846, walkTurnLeft = 25846, walkTurnRight = 25846 },  -- SLISKE2_JERROD_IDLE
    [3396] = { stand = 25875, walk = 25876, turnLeft = 25876, turnRight = 25876, walkBack = 25876, walkLeft = 25876, walkRight = 25876, walkTurnLeft = 25876, walkTurnRight = 25876 },  -- SLISKE2_VIGGORA_TRANSPARENT_IDLE
    [3397] = { stand = 25975, walk = 25872, run = 25872, turnLeft = 25975, turnRight = 25975, runTurnLeft = 25872, runTurnRight = 25872, walkTurnLeft = 25872, walkTurnRight = 25872 },  -- SLISKE2_CUTSCENE_NOMAD_NO_STAFF_IDLE
    [3398] = { stand = 25868 },  -- SLISKE2_ZAMORAK_PAT_SIEGE_PET_IDLE
    [3399] = { stand = 25869 },  -- SLISKE2_ZAMORAK_PAT_IDLE
    [3400] = { stand = 17975, walk = 25961, run = 17977, turnLeft = 25961, turnRight = 25961 },  -- COMBAT_2012_COMBAT_TWO_HANDED_MAUL_READY
    [3401] = { stand = 25993, walk = 25992, turnLeft = 25992, turnRight = 25992, walkTurnLeft = 25992, walkTurnRight = 25992 },  -- Q200_ZEMOUREGAL_IDLE
    [3402] = { stand = 25994 },  -- Q200_ZEMOUREGAL_SIT_ON_THRONE_IDLE
    [3403] = { stand = 26004, walk = 26005, run = 26006, turnLeft = 26005, turnRight = 26005 },  -- DOM_KAMIL_TRANSPARENT_IDLE
    [3404] = { stand = 26010, walk = 26009, run = 26006, turnLeft = 26009, turnRight = 26009 },  -- DOM_KAMIL_TRANSPARENT_COMBAT_READY
    [3405] = { stand = 26012, walk = 26014, run = 26015, turnLeft = 26014, turnRight = 26014 },  -- TRH46_PLAYER_SILVERHAWK_COMBAT_READY
    [3406] = { stand = 17934, walk = 17936, run = 28438, turnLeft = 17936, turnRight = 17936, walkLeft = 17936, walkRight = 17936, walkTurnLeft = 17936, walkTurnRight = 17936 },  -- OMGE_SKILL_COMBAT_SKELETON_2012_READY
    [3407] = { stand = 17934, walk = 26044, run = 28438, turnLeft = 26044, turnRight = 26044, walkLeft = 26044, walkRight = 26044, walkTurnLeft = 26044, walkTurnRight = 26044 },  -- OMGE_SKILL_COMBAT_SKELETON_2012_READY
    [3408] = { stand = 26046, walk = 26047, turnLeft = 26047, turnRight = 26047, walkLeft = 26047, walkRight = 26047, walkTurnLeft = 26047, walkTurnRight = 26047 },  -- SKELETON_2014_GIANT_IDLE
    [3409] = { stand = 26045, walk = 26062, turnLeft = 26062, turnRight = 26062, walkLeft = 26062, walkRight = 26062, walkTurnLeft = 26062, walkTurnRight = 26062 },  -- SKELETON_2014_GORILLA_IDLE
    [3410] = { stand = 26052 },  -- SKELETON_2014_BEFORE_SUMMON
    [3411] = { stand = 26072, walk = 26073 },  -- POSTIE_PETE_2015_IDLE
    [3412] = { stand = 26068 },  -- SKELETON_2014_ULFRIC_SPAWN
    [3413] = { stand = 26082, walk = 26083, run = 26084, runBack = 26084, walkBack = 26083, walkLeft = 26083, walkRight = 26083, walkTurnLeft = 26083, walkTurnRight = 26083 },  -- BOSS_PRACTICE_MODE_OWL_PET_IDLE
    [3414] = { stand = 26082, walk = 26083, run = 26084, turnLeft = 26082, turnRight = 26082, walkLeft = 26083, walkRight = 26083 },  -- BOSS_PRACTICE_MODE_OWL_PET_IDLE
    [3415] = { stand = 26106, walk = 26107 },  -- MUMMY_2013_READY
    [3416] = { stand = 26099, turnLeft = 26100, turnRight = 26100, walkTurnLeft = 26100, walkTurnRight = 26100 },  -- PYRAMID_PLUNDER_2014_MUMMY_GUARDIAN_IDLE
    [3417] = { stand = 26094, walk = 26095 },  -- PYRAMID_PLUNDER_2014_SCARAB_IDLE
    [3418] = { stand = 26121, walk = 26119, crawl = 26119, turnLeft = 26119, turnRight = 26119, crawlTurnLeft = 26119, crawlTurnRight = 26119 },  -- Q200_CITIZEN_ZOMBIE_SAD_IDLE
    [3419] = { stand = 26128, walk = 26120, crawl = 26120, turnLeft = 26120, turnRight = 26120, crawlTurnLeft = 26120, crawlTurnRight = 26120 },  -- Q200_CITIZEN_ZOMBIE_SAD_IDLE_VARIENT
    [3420] = { stand = 26122, walk = 26119, crawl = 26119, turnLeft = 26119, turnRight = 26119, crawlTurnLeft = 26119, crawlTurnRight = 26119 },  -- Q200_CITIZEN_ZOMBIE_SCARED_IDLE
    [3421] = { stand = 26123, walk = 26119, crawl = 26119, turnLeft = 26119, turnRight = 26119, crawlTurnLeft = 26119, crawlTurnRight = 26119 },  -- Q200_CITIZEN_ZOMBIE_SUSPICIOUS_IDLE
    [3422] = { stand = 26124, walk = 26119, crawl = 26119, turnLeft = 26119, turnRight = 26119, crawlTurnLeft = 26119, crawlTurnRight = 26119 },  -- Q200_CITIZEN_ZOMBIE_INSANE_A_IDLE
    [3423] = { stand = 26169, walk = 26119, crawl = 26119, turnLeft = 26119, turnRight = 26119, crawlTurnLeft = 26119, crawlTurnRight = 26119 },  -- Q200_CITIZEN_ZOMBIE_INSANE_B_IDLE
    [3424] = { stand = 17546 },  -- BOTOFF_CRYER_READY_EXTRA
    [3425] = { stand = 26126, walk = 26125, turnLeft = 26125, turnRight = 26125, walkLeft = 26125, walkRight = 26125, walkTurnLeft = 26125, walkTurnRight = 26125 },  -- Q200_PLAYER_BOT_IDLE
    [3426] = { stand = 26173 },  -- Q200_PLAYER_BOT_LYING_DOWN_POSE
    [3427] = { stand = 26132 },  -- Q200_MOIRA_SITTING
    [3428] = { stand = 26168 },  -- Q200_MOLLY_SITTING
    [3429] = { stand = 18015, walk = 18016, run = 18017, turnLeft = 18016, turnRight = 18016, walkTurnLeft = 18016, walkTurnRight = 18016 },  -- COMBAT_2012_CASUAL_ARMED_IDLE
    [3430] = { stand = 26610, walk = 26611, run = 26612, turnLeft = 26611, turnRight = 26611, walkTurnLeft = 26611, walkTurnRight = 26611 },  -- MTXBEACH_JELLYFISH_IDLE
    [3431] = { stand = 26605, walk = 26606, run = 26607, turnLeft = 26606, turnRight = 26606, walkTurnLeft = 26606, walkTurnRight = 26606 },  -- MTXBEACH_PET_FISH_IDLE
    [3432] = { stand = 10424 },  -- RED_MIST
    [3433] = { stand = 26150, walk = 26149, run = 17972, turnLeft = 26149, turnRight = 26149 },  -- Q200_ARRAV_COMBAT_IDLE
    [3434] = { stand = 26145, walk = 26144, run = 26152, turnLeft = 26144, turnRight = 26144 },  -- Q200_ARRAV_IDLE
    [3435] = { stand = 26202 },  -- Q200_ARRAV_WATERING_CAN_IDLE
    [3436] = { stand = 26198, walk = 26199, turnLeft = 26199, turnRight = 26199 },  -- Q200_ARRAV_WEAKENED_ARMED_IDLE
    [3437] = { stand = 26218, walk = 26218, turnLeft = 26218, turnRight = 26218 },  -- Q200_ARRAV_DEAD_POSE
    [3438] = { stand = 26196 },  -- Q200_ARRAV_CAUSAL_IDLE_ARMED
    [3439] = { stand = 26156 },  -- Q200_MEG_IN_CAGE_IDLE
    [3440] = { stand = 26157 },  -- Q200_HAZELMERE_IN_CAGE_IDLE
    [3441] = { stand = 26204 },  -- Q200_DR_HARLOW_SAD_IDLE
    [3442] = { stand = 26211 },  -- Q200_MINI_ZEMOUREGAL_SIT_ON_THRONE_IDLE
    [3443] = { stand = 26233, walk = 168, turnLeft = 168, turnRight = 168, walkBack = 168, walkLeft = 168, walkRight = 168 },  -- EASTER15_IMP_IDLE
    [3444] = { stand = 26234, walk = 26235, turnLeft = 26235, turnRight = 26235, walkBack = 26235, walkLeft = 26235, walkRight = 26235 },  -- EASTER15_IMP_CARRY_EGG_IDLE
    [3445] = { stand = 26320, walk = 26319 },  -- POH_AQUA_PLAYER_DIVING_SUIT_IDLE
    [3446] = { stand = 26313, walk = 26314, turnLeft = 26314, turnRight = 26314, walkTurnLeft = 26314, walkTurnRight = 26314 },  -- POH_AQUA_SHARK_PET_IDLE
    [3447] = { stand = 8116, crawl = 26333, crawlLeft = 26333, crawlRight = 26333, turnLeft = 26333, turnRight = 26333, crawlTurnRight = 26333 },  -- LORE_LOBSTER_READY_AND_EXTRA
    [3448] = { stand = 21949 },  -- GAME_BARROWS2_KARIL_PORTAL_SPOTANIM
    [3449] = { stand = 22901 },  -- TRH7_SKILLING_LOCATION_FISHING_LOC_LOOP
    [3450] = { stand = 26354, walk = 26362, run = 26363, turnLeft = 26362, turnRight = 26362, walkLeft = 26362, walkRight = 26362, walkTurnLeft = 26362, walkTurnRight = 26362 },  -- MTX88_DRAGON_PET_BABY_IDLE
    [3451] = { stand = 26368, walk = 26369, run = 26370, turnLeft = 26369, turnRight = 26369, walkLeft = 26369, walkRight = 26369, walkTurnLeft = 26369, walkTurnRight = 26369 },  -- MTX88_DRAGON_PET_JUVENILE_IDLE
    [3452] = { stand = 26337, walk = 26336, run = 26338, turnLeft = 26337, turnRight = 26337, walkBack = 26338, walkTurnLeft = 26337, walkTurnRight = 26337 },  -- MTX88_DRAGON_PET_ADULT_IDLE
    [3453] = { stand = 19476, walk = 19490, run = 19477, turnLeft = 19476, turnRight = 19476, walkBack = 19490, walkLeft = 19490, walkRight = 19490 },  -- KK_KALPHITE_WORKER_READY
    [3454] = { stand = 15633, walk = 15634, run = 18017, runLeft = 18017, runRight = 18017, turnLeft = 15634, turnRight = 15634, walkLeft = 15634, walkRight = 15634, runTurnLeft = 18017, runTurnRight = 18017, walkTurnLeft = 15634, walkTurnRight = 15634 },  -- FMC_PLAYER_TORCH_READY
    [3455] = { stand = 26456, walk = 26459, run = 26460, turnLeft = 26456, turnRight = 26456, walkBack = 26459, walkLeft = 26459, walkRight = 26459 },  -- TUSKA_LIGHTNING_SPRITE_IDLE
    [3456] = { walk = 26448, turnLeft = 26448, turnRight = 26448, idles = { { 26448, 50 }, { 26469, 5 }, { 26470, 5 } } },
    [3457] = { stand = 26452, walk = 26452, run = 26452, turnLeft = 26452, turnRight = 26452, walkBack = 26452, walkLeft = 26452, walkRight = 26452 },  -- TUSKA_EMISSARY_PLANNING_TABLE_STONEADD_IDLE
    [3458] = { stand = 26453, walk = 26453, run = 26453, turnLeft = 26453, turnRight = 26453, walkBack = 26453, walkLeft = 26453, walkRight = 26453 },  -- TUSKA_EMISSARY_PLANNING_TABLE_MOIA_IDLE
    [3459] = { stand = 26451, walk = 26451, run = 26451, turnLeft = 26451, turnRight = 26451, walkBack = 26451, walkLeft = 26451, walkRight = 26451 },  -- TUSKA_EMISSARY_PLANNING_TABLE_BREE_IDLE
    [3460] = { stand = 26450, walk = 26450, run = 26450, turnLeft = 26450, turnRight = 26450, walkBack = 26450, walkLeft = 26450, walkRight = 26450 },  -- TUSKA_EMISSARY_PLANNING_TABLE_DIVINER_IDLE
    [3461] = { stand = 26483, walk = 26435, run = 26482, turnLeft = 26483, turnRight = 26483, walkBack = 26435, walkLeft = 26435, walkRight = 26435 },  -- TUSKA_RAID_PLAYER_MOON_IDLE
    [3462] = { stand = 26465, walk = 26465, run = 26465, turnLeft = 26465, turnRight = 26465, walkBack = 26465, walkLeft = 26465, walkRight = 26465 },  -- TUSKA_VINE_IDLE
    [3463] = { stand = 26500, walk = 26501, run = 26502 },  -- TRH55_GOD_BANNER_IDLE
    [3464] = { stand = 26513, crawl = 26512, turnLeft = 26512, turnRight = 26512 },  -- TRH61_PET_TORTOISE_IDLE
    [3465] = { stand = 26516 },  -- TRH61_CRAB_HAT_TRANSFORM
    [3466] = { stand = 26527, walk = 26529, walkTurnLeft = 26529, walkTurnRight = 26529 },  -- ARDRAGON_DRAGON_FLYING_IDLE
    [3467] = { stand = 26582, walk = 819 },  -- MTXBEACH_PLAYER_REST_SANDCASTLE_LOOP
    [3468] = { stand = 26565, walk = 26565, run = 26565, turnLeft = 26565, turnRight = 26565, walkBack = 26565, walkLeft = 26565, walkRight = 26565 },  -- MTXBEACH_BOSS_SOAK
    [3469] = { stand = 26555 },  -- MTXBEACH_BOSS_IDLE
    [3470] = { stand = 26620 },  -- MTXBEACH_LIFEGUARD_IDLE
    [3471] = { stand = 26622 },  -- MTXBEACH_LIFEGUARD_IDLE_FEMALE
    [3472] = { stand = 26623 },  -- MTXBEACH_REYNA_IDLE
    [3473] = { stand = 26599 },  -- MTXBEACH_PLAYER_DECKCHAIR_IDLE
    [3474] = { stand = 26602 },  -- MTXBEACH_PLAYER_DECKCHAIR_IDLE_DIAGONAL
    [3475] = { stand = 26605, walk = 26606, run = 26607 },  -- MTXBEACH_PET_FISH_IDLE
    [3476] = { stand = 26625, walk = 26626, turnLeft = 26626, turnRight = 26626, walkLeft = 26626, walkRight = 26626, walkTurnLeft = 26626, walkTurnRight = 26626 },  -- TUSKA_RAIDS_JELLYFISH_IDLE
    [3477] = { stand = 26682 },  -- DOV_TARSHAK_IN_CAGE_IDLE
    [3478] = { stand = 26693, walk = 26694, turnLeft = 26694, turnRight = 26694, walkLeft = 26694, walkRight = 26694, walkTurnLeft = 26694, walkTurnRight = 26694 },  -- DOV_V_IDLE
    [3479] = { walk = 26694, turnLeft = 26694, turnRight = 26694, walkLeft = 26694, walkRight = 26694, walkTurnLeft = 26694, walkTurnRight = 26694, idles = { { 26693, 80 }, { 26677, 20 } } },
    [3480] = { stand = 26742, turnLeft = 26742, turnRight = 26742 },  -- DOV_V_NO_ENERGY_IDLE
    [3481] = { stand = 26707, walk = 26708, turnLeft = 26708, turnRight = 26708 },  -- DOV_TARSHAK_STAGE_2_IDLE
    [3482] = { stand = 26726, turnLeft = 26728, turnRight = 26727 },  -- DOV_TARSHAK_STAGE_5_IDLE
    [3483] = { stand = 26743, walk = 26745, run = 26746, turnLeft = 26745, turnRight = 26745 },  -- DOV_TARSHAK_STAGE_6_IDLE
    [3484] = { stand = 26722 },  -- DOV_DRAGONKIN_INJURED_A
    [3485] = { stand = 26723 },  -- DOV_DRAGONKIN_INJURED_B
    [3486] = { stand = 26737, walk = 26738, turnLeft = 26738, turnRight = 26738, walkLeft = 26738, walkRight = 26738, walkTurnLeft = 26738, walkTurnRight = 26738 },  -- DOV_DRAGONKIN_INJURED_IDLE
    [3487] = { stand = 10432, walk = 16587, walkBack = 16587, walkLeft = 16587, walkRight = 16587, walkTurnLeft = 16587, walkTurnRight = 16587 },  -- ZEMO_ZEMOUREGAL_READY
    [3488] = { stand = 25993, walk = 26806, turnLeft = 26806, turnRight = 26806, walkTurnLeft = 26806, walkTurnRight = 26806 },  -- Q200_ZEMOUREGAL_IDLE
    [3489] = { stand = 26134, walk = 26174, crawl = 26174, turnLeft = 26174, turnRight = 26174, crawlTurnLeft = 26174, crawlTurnRight = 26174, walkTurnLeft = 26174, walkTurnRight = 26174 },  -- Q200_ARMOURED_ZOMBIE_IDLE
    [3490] = { stand = 26138, walk = 26175, crawl = 26175, turnLeft = 26175, turnRight = 26175, crawlTurnLeft = 26175, crawlTurnRight = 26175, walkTurnLeft = 26175, walkTurnRight = 26175 },  -- Q200_ARMOURED_ZOMBIE_SHIELD_IDLE
    [3491] = { stand = 26134, walk = 26133, crawl = 26133, turnLeft = 26133, turnRight = 26133, crawlTurnLeft = 26133, crawlTurnRight = 26133, walkTurnLeft = 26133, walkTurnRight = 26133 },  -- Q200_ARMOURED_ZOMBIE_IDLE
    [3492] = { stand = 26138, walk = 26137, crawl = 26137, turnLeft = 26137, turnRight = 26137, crawlTurnLeft = 26137, crawlTurnRight = 26137, walkTurnLeft = 26137, walkTurnRight = 26137 },  -- Q200_ARMOURED_ZOMBIE_SHIELD_IDLE
    [3493] = { stand = 26836 },  -- MTXBEACH_PLAYER_REST_DECKCHAIR_LOOP
    [3494] = { stand = 26841, walk = 26842, run = 26856, runBack = 26856, runLeft = 26856, runRight = 26856, turnLeft = 26842, turnRight = 26842, walkLeft = 26842, walkRight = 26842, walkTurnLeft = 26842, walkTurnRight = 26842 },  -- TUSKA_RAIDS_BEASTMASTER_IDLE
    [3495] = { stand = 26846, walk = 26846, run = 26846, runBack = 26846, runLeft = 26846, runRight = 26846, turnLeft = 26846, turnRight = 26846, walkLeft = 26846, walkRight = 26846, walkTurnLeft = 26846, walkTurnRight = 26846 },  -- TUSKA_RAIDS_BEASTMASTER_DEAD_POSE
    [3496] = { stand = 26853, walk = 26854, run = 26855, runBack = 26855, runLeft = 26855, runRight = 26855, turnLeft = 26854, turnRight = 26854, walkLeft = 26854, walkRight = 26854, walkTurnLeft = 26854, walkTurnRight = 26854 },  -- TUSKA_RAIDS_BEASTMASTER_DOG_IDLE
    [3497] = { stand = 26890, walk = 26891, run = 26892, runBack = 26892, runLeft = 26892, runRight = 26892, turnLeft = 26891, turnRight = 26891, walkLeft = 26891, walkRight = 26891, walkTurnLeft = 26891, walkTurnRight = 26891 },  -- TUSKA_RAIDS_BEASTMASTER_DOG_PET_IDLE
    [3498] = { stand = 26880, walk = 26881, turnLeft = 26881, turnRight = 26881, walkLeft = 26881, walkRight = 26881, walkTurnLeft = 26881, walkTurnRight = 26881 },  -- TUSKA_RAIDS_BEASTMASTER_BOMB_IDLE
    [3499] = { stand = 19667, walk = 19669, run = 7138, turnLeft = 19667, turnRight = 19667, walkBack = 19669, walkLeft = 19669, walkRight = 19669 },  -- MTX_PETS_WOLFDRAGON_ADULT_IDLE
    [3500] = { stand = 26897, turnLeft = 26897, turnRight = 26897 },  -- TUSKA_RAIDS_WATERBOSS_IDLE
    [3501] = { stand = 26939, turnLeft = 26939, turnRight = 26939 },  -- TUSKA_RAIDS_WATERBOSS_WEAKENED_IDLE
    [3502] = { stand = 26914, walk = 26914, run = 26914, turnLeft = 26914, turnRight = 26914, walkBack = 26914, walkLeft = 26914, walkRight = 26914 },  -- TUSKA_RAIDS_PLAYER_QUICKSAND_ANKLES
    [3503] = { stand = 26915, walk = 26915, run = 26915, turnLeft = 26915, turnRight = 26915, walkBack = 26915, walkLeft = 26915, walkRight = 26915 },  -- TUSKA_RAIDS_PLAYER_QUICKSAND_WAIST
    [3504] = { stand = 26916, walk = 26916, run = 26916, turnLeft = 26916, turnRight = 26916, walkBack = 26916, walkLeft = 26916, walkRight = 26916 },  -- TUSKA_RAIDS_PLAYER_QUICKSAND_CHEST
    [3505] = { stand = 26930, walk = 26930, run = 26930, turnLeft = 26930, turnRight = 26930, walkBack = 26930, walkLeft = 26930, walkRight = 26930 },  -- TUSKA_RAIDS_PLAYER_STRANGLED
    [3506] = { stand = 26954, turnLeft = 26954, turnRight = 26954 },  -- TUSKA_RAIDS_WATERBOSS_DEAD_POSE
    [3507] = { stand = 26442, walk = 26443, run = 26444, runBack = 26444, runLeft = 26444, runRight = 26444, turnLeft = 26442, turnRight = 26442, walkBack = 26443, runTurnLeft = 26444, runTurnRight = 26444, walkTurnLeft = 26443, walkTurnRight = 26443 },  -- TUSKA_RAIDS_GOEBIE_IDLE
    [3508] = { stand = 26442, walk = 26444, run = 26444, runBack = 26444, runLeft = 27018, runRight = 27018, turnLeft = 26442, turnRight = 26442, walkBack = 26444, runTurnLeft = 27018, runTurnRight = 27018, walkTurnLeft = 26444, walkTurnRight = 26444 },  -- TUSKA_RAIDS_GOEBIE_IDLE
    [3509] = { stand = 26997, walk = 26443, run = 26444, runBack = 26444, runLeft = 26444, runRight = 26444, turnLeft = 26997, turnRight = 26997, walkBack = 26443, runTurnLeft = 26444, runTurnRight = 26444, walkTurnLeft = 26443, walkTurnRight = 26443 },  -- TUSKA_RAIDS_GOEBIE_CRY
    [3510] = { stand = 27003, walk = 26443, run = 26444, runBack = 26444, runLeft = 26444, runRight = 26444, turnLeft = 27003, turnRight = 27003, walkBack = 26443, runTurnLeft = 26444, runTurnRight = 26444, walkTurnLeft = 26443, walkTurnRight = 26443 },  -- TUSKA_RAIDS_GOEBIE_BANKER_IDLE
    [3511] = { stand = 27004, walk = 26443, run = 26444, runBack = 26444, runLeft = 26444, runRight = 26444, turnLeft = 27004, turnRight = 27004, walkBack = 26443, runTurnLeft = 26444, runTurnRight = 26444, walkTurnLeft = 26443, walkTurnRight = 26443 },  -- TUSKA_RAIDS_GOEBIE_SHOPKEEPER_IDLE
    [3512] = { stand = 27022, walk = 27023, run = 19271, turnLeft = 27022, turnRight = 27022, walkBack = 27023, walkLeft = 27023, walkRight = 27023 },  -- BIGCATS_SNOW_LEOPARD_IDLE
    [3513] = { walk = 27017, run = 26444, runBack = 26444, runLeft = 26444, runRight = 26444, turnLeft = 27006, turnRight = 27006, walkBack = 27017, runTurnLeft = 26444, runTurnRight = 26444, walkTurnLeft = 27017, walkTurnRight = 27017, idles = { { 27006, 225 }, { 27007, 30 } } },
    [3514] = { stand = 19269, walk = 27023, run = 19271, turnLeft = 19269, turnRight = 19269, walkBack = 27023, walkLeft = 27023, walkRight = 27023 },  -- MTX_PET_WINGED_LION_BABY_IDLE
    [3515] = { stand = 27024, walk = 27023, run = 19271, turnLeft = 27024, turnRight = 27024, walkBack = 27023, walkLeft = 27023, walkRight = 27023 },  -- BIGCATS_IDLE_B
    [3516] = { stand = 27025, walk = 27023, run = 19271, turnLeft = 27025, turnRight = 27025, walkBack = 27023, walkLeft = 27023, walkRight = 27023 },  -- BIGCATS_IDLE_C
    [3517] = { stand = 27026, walk = 27023, run = 19271, turnLeft = 27026, turnRight = 27026, walkBack = 27023, walkLeft = 27023, walkRight = 27023 },  -- BIGCATS_IDLE_D
    [3518] = { stand = 17197, walk = 17197, crawl = 17197, crawlBack = 17197, crawlLeft = 17197, crawlRight = 17197, run = 17197, runBack = 17197, runLeft = 17197, runRight = 17197, turnLeft = 17197, turnRight = 17197, walkBack = 17197, walkLeft = 17197, walkRight = 17197 },  -- WOF13_PLAYER_KICK_BEACHBALL_RUN
    [3519] = { stand = 27037 },  -- MTX_ATS_PLAYER_REST_MEDITATE
    [3520] = { stand = 27072, walk = 27073 },  -- MYQ6_SANG_BASE_RESEARCHER_IDLE
    [3521] = { stand = 27074, walk = 27075, run = 27076, runBack = 27090, turnLeft = 27075, turnRight = 27075, walkBack = 27089 },  -- MTX93_ZOLTAN_SHOWCASE_PLAYER_BARBARIAN_IDLE
    [3522] = { stand = 27077, walk = 27078, run = 27079, runBack = 27092, turnLeft = 27078, turnRight = 27078, walkBack = 27091 },  -- MTX93_ZOLTAN_SHOWCASE_PLAYER_BARBARIAN_MAUL_IDLE
    [3523] = { stand = 27080, walk = 27081, run = 27082, runBack = 27094, turnLeft = 27081, turnRight = 27081, walkBack = 27093 },  -- MTX93_ZOLTAN_SHOWCASE_PLAYER_BARBARIAN_TWO_HANDED_SWORD_IDLE
    [3524] = { stand = 27083, walk = 27084, run = 27085, runBack = 27096, turnLeft = 27084, turnRight = 27084, walkBack = 27095 },  -- MTX93_ZOLTAN_SHOWCASE_PLAYER_BARBARIAN_STAFF_IDLE
    [3525] = { stand = 27086, walk = 27087, run = 27088, runBack = 27097, turnLeft = 27087, turnRight = 27087, walkBack = 27098 },  -- MTX93_ZOLTAN_SHOWCASE_PLAYER_BARBARIAN_BOW_IDLE
    [3526] = { stand = 27100, walk = 27099, run = 27101, runBack = 27106, turnLeft = 27099, turnRight = 27099, walkBack = 27105 },  -- MTX_ATS_PLAYER_SAD_IDLE
    [3527] = { stand = 27111, walk = 27109, run = 27110 },  -- MTX_ATS_PLAYER_HAPPY_IDLE
    [3528] = { stand = 27114, walk = 27112, run = 27113 },  -- MTX_ATS_PLAYER_PROUD_IDLE
    [3529] = { stand = 27102, walk = 27103, run = 27104, runBack = 27108, turnLeft = 27103, turnRight = 27103, walkBack = 27107 },  -- MTX_ATS_PLAYER_ANGRY_IDLE
    [3530] = { stand = 27117, walk = 27115, run = 27116 },  -- MTX_ATS_PLAYER_EXCITED_IDLE
    [3531] = { stand = 27100, walk = 27099, run = 27101 },  -- MTX_ATS_PLAYER_SAD_IDLE
    [3532] = { stand = 27136, walk = 27147, turnLeft = 27147, turnRight = 27147, walkBack = 27147, walkLeft = 27147, walkRight = 27147, walkTurnLeft = 27147, walkTurnRight = 27147 },  -- SEREN_MAGIC_SHAPESHIFTER_IDLE
    [3533] = { stand = 27137, walk = 27148, turnLeft = 27148, turnRight = 27148, walkBack = 27148, walkLeft = 27148, walkRight = 27148, walkTurnLeft = 27148, walkTurnRight = 27148 },  -- SEREN_MELEE_SHAPESHIFTER_IDLE
    [3534] = { stand = 27138, walk = 27149, turnLeft = 27149, turnRight = 27149, walkBack = 27149, walkLeft = 27149, walkRight = 27149, walkTurnLeft = 27149, walkTurnRight = 27149 },  -- SEREN_RANGE_SHAPESHIFTER_IDLE
    [3535] = { stand = 27181 },  -- SEREN_CRYSTAL_ELF_FEMALE_IDLE
    [3536] = { stand = 27185, walk = 27197, walkBack = 27197, walkLeft = 27197, walkRight = 27197, walkTurnLeft = 27197, walkTurnRight = 27197 },  -- SEREN_SEREN_IDLE
    [3537] = { stand = 27187 },  -- SEREN_SEREN_HUSK_IDLE
    [3538] = { stand = 27186 },  -- SEREN_SEREN_LIGHT_PUZZLE_FLOAT_IDLE
    [3539] = { stand = 27189, walk = 27193, crawl = 27193, crawlBack = 27193, crawlLeft = 27193, crawlRight = 27193, turnLeft = 27193, turnRight = 27193, walkBack = 27193, walkLeft = 27193, walkRight = 27193, crawlTurnLeft = 27193, crawlTurnRight = 27193, walkTurnLeft = 27193, walkTurnRight = 27193 },  -- SEREN_PLAYER_CARRY_SEREN_IDLE
    [3540] = { stand = 27188, walk = 27194, turnLeft = 27194, turnRight = 27194, walkBack = 27194, walkLeft = 27194, walkRight = 27194, walkTurnLeft = 27194, walkTurnRight = 27194 },  -- SEREN_SEREN_CARRIED_BY_PLAYER_IDLE
    [3541] = { stand = 27239 },  -- SEREN_COMBAT_SPELL_TOTEM_DECOY_LOOP_SPOTANIM
    [3542] = { stand = 27236 },  -- SEREN_COMBAT_SPELL_TOTEM_STOCKPILE_LOOP_SPOTANIM
    [3543] = { stand = 27234 },  -- SEREN_COMBAT_SPELL_TOTEM_LOOP_SPOTANIM
    [3544] = { stand = 27234 },  -- SEREN_COMBAT_SPELL_TOTEM_LOOP_SPOTANIM
    [3545] = { stand = 27241 },  -- SEREN_SKILLING_SPELL_ENRICHMENT_LOOP_SPOTANIM
    [3546] = { stand = 27199, turnLeft = 27199, turnRight = 27199 },  -- SEREN_TARDDIAD_FISHING_SPOT
    [3547] = { stand = 17975, walk = 27245, run = 17977, turnLeft = 27245, turnRight = 27245 },  -- COMBAT_2012_COMBAT_TWO_HANDED_MAUL_READY
    [3548] = { stand = 27248, walk = 27248, turnLeft = 27248, turnRight = 27248, walkBack = 27248, walkLeft = 27248, walkRight = 27248 },  -- _100_ILM_MONKEYBAR_MOVE_LOW_MEDIUM_MONKEY
    [3549] = { stand = 27259, walk = 27258, run = 27301, turnLeft = 27258, turnRight = 27258, walkLeft = 27258, walkRight = 27258, walkTurnLeft = 27258, walkTurnRight = 27258 },  -- MYQ6_DRAKAN_IDLE
    [3550] = { stand = 27340, walk = 27341, turnLeft = 27341, turnRight = 27341, walkLeft = 27341, walkRight = 27341, walkTurnLeft = 27341, walkTurnRight = 27341 },  -- MYQ6_DRAKAN_INJURED_IDLE
    [3551] = { stand = 27275, walk = 27275, run = 27298, runLeft = 27298, runRight = 27298, turnLeft = 27275, turnRight = 27275, walkLeft = 27275, walkRight = 27275, runTurnLeft = 27298, runTurnRight = 27298, walkTurnLeft = 27275, walkTurnRight = 27275 },  -- MYQ6_DRAKAN_FLYING_IDLE
    [3552] = { stand = 27298, walk = 27298, run = 27298, runLeft = 27298, runRight = 27298, turnLeft = 27298, turnRight = 27298, walkLeft = 27298, walkRight = 27298, runTurnLeft = 27298, runTurnRight = 27298, walkTurnLeft = 27298, walkTurnRight = 27298 },  -- MYQ6_DRAKAN_DIVE_BOMBING
    [3553] = { stand = 27361 },  -- MYQ6_DRAKAN_ONE_KNEE_PANTING_LOOP
    [3554] = { stand = 27283 },  -- MYQ6_SAFALAAN_GRABBED_BY_DRAKAN
    [3555] = { stand = 27282 },  -- MYQ6_DRAKAN_PICK_UP_SAFALAAN
    [3556] = { stand = 27290 },  -- MYQ6_DRAKAN_SPEAKING
    [3557] = { stand = 27267, walk = 27295, run = 27296, turnLeft = 27295, turnRight = 27295, walkLeft = 27295, walkRight = 27295, walkTurnLeft = 27295, walkTurnRight = 27295 },  -- MYQ6_VENATOR_IDLE
    [3558] = { stand = 27369, walk = 27370, turnLeft = 27370, turnRight = 27370, walkLeft = 27370, walkRight = 27370, walkTurnLeft = 27370, walkTurnRight = 27370 },  -- MYQ6_VENATOR_DINING_TABLE_IDLE
    [3559] = { stand = 27308, walk = 27308 },  -- MYQ6_DRAKAN_MIST_FORM_IDLE
    [3560] = { stand = 27291, walk = 27291 },  -- MYQ6_DRAKAN_ONE_KNEE_PANTING
    [3561] = { stand = 27329 },  -- MYQ6_VANESCULA_IN_BLOODLETTING_DEVICE
    [3562] = { stand = 27348 },  -- MYQ6_SAFALAAN_KNOCKED_OVER_IDLE
    [3563] = { stand = 27444, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- PLAYER_FLETCHING_2013_UPDATE_NPC
    [3564] = { stand = 21110 },  -- OWEN1_BLACK_KNIGHT_DEATH_VAR_C_NULL
    [3565] = { stand = 27351 },  -- MYQ6_VANESCULA_HIT_BY_SPEAR_STILL
    [3566] = { stand = 27360 },  -- MYQ6_VANESCULA_HIT_BY_DRAKAN_PRONE
    [3567] = { stand = 27362 },  -- MYQ6_DRAKAN_DIE_LOOP
    [3568] = { stand = 27363 },  -- MYQ6_PLAYER_KILL_DRAKAN_LOOP
    [3569] = { stand = 27364 },  -- MYQ6_DRAKAN_DEAD_POSE
    [3570] = { stand = 27388, walk = 27387, crawl = 27387, crawlLeft = 27387, crawlRight = 27387, walkLeft = 27387, walkRight = 27387 },  -- MYQ6_IVAN_WOUNDED_IDLE
    [3571] = { stand = 27385 },  -- MYQ6_BLOOD_DONOR_CHILD_IDLE
    [3572] = { stand = 27384 },  -- MYQ6_PLAYER_FALL_UNCONSCIOUS_STILL
    [3573] = { stand = 27393 },  -- MYQ6_POLMAFI_FIXING_PYLON_LOOP
    [3574] = { stand = 27397 },  -- MYQ6_SAFALAAN_DEAD_POSE
    [3575] = { stand = 7604 },  -- MYQ5_VYREWATCH_GROUNDED_DEATH_NO_FADE
    [3576] = { stand = 27408 },  -- MYQ6_NPC_BRACING_DOOR_LOOP
    [3577] = { stand = 27412 },  -- MYQ6_NPC_BRACING_DOOR_SHOULDER_LOOP
    [3578] = { stand = 27419 },  -- MYQ6_NPC_LIFTING_TABLE_B_LOOP
    [3579] = { stand = 27415 },  -- MYQ6_NPC_LIFTING_TABLE_LOOP
    [3580] = { stand = 27422 },  -- MYQ6_VELIAF_SLUMP_AGAINST_WALL_LOOP
    [3581] = { stand = 27423 },  -- MYQ6_VYREWATCH_GROUND_READY_VARIENT_A
    [3582] = { stand = 27424 },  -- MYQ6_VYREWATCH_GROUND_READY_VARIENT_B
    [3583] = { stand = 27425 },  -- MYQ6_VYREWATCH_GROUND_READY_VARIENT_C
    [3584] = { stand = 27430 },  -- MYQ6_DONOR_MAN_SCARED_IDLE
    [3585] = { stand = 27431 },  -- MYQ6_DONOR_WOMAN_IDLE
    [3586] = { stand = 808, walk = 819, run = 18814, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_READY
    [3587] = { stand = 26323, walk = 26323 },  -- POH_AQUA_SEAWEED_BUNCH_LOOP
    [3588] = { stand = 27460, walk = 27460, turnLeft = 27460, turnRight = 27460 },  -- ECWF_URCHIN_BIG_IDLE
    [3589] = { walk = 27470, run = 27471, turnLeft = 27470, turnRight = 27470, walkLeft = 27470, walkRight = 27470, walkTurnLeft = 27470, walkTurnRight = 27470, idles = { { 27469, 200 }, { 27474, 100 } } },
    [3590] = { stand = 27475, walk = 15777, walkBack = 15777, walkLeft = 15777, walkRight = 15777, walkTurnLeft = 15777, walkTurnRight = 15777 },  -- OMGE_NPC_TALKING_01_NOVO
    [3591] = { stand = 27476, walk = 15777, walkBack = 15777, walkLeft = 15777, walkRight = 15777, walkTurnLeft = 15777, walkTurnRight = 15777 },  -- OMGE_NPC_TALKING_02_NOVO
    [3592] = { stand = 27477, walk = 27478, run = 27479, runBack = 27481, turnLeft = 27478, turnRight = 27478, walkBack = 27480 },  -- TRH71_PET_OF_SEASONS_IDLE
    [3593] = { stand = 27485, walk = 27486, run = 27488, runBack = 27489, turnLeft = 27486, turnRight = 27486, walkBack = 27487, walkLeft = 27486, walkRight = 27486 },  -- MTX93_ALEC_SHOWCASE_PLAYER_HUNTER_IDLE
    [3594] = { stand = 27490, walk = 27491, run = 27493, runBack = 27494, turnLeft = 27491, turnRight = 27491, walkBack = 27492, walkLeft = 27491, walkRight = 27491 },  -- MTX93_ALEC_SHOWCASE_PLAYER_HUNTER_IDLE_TWO_HANDED
    [3595] = { stand = 27495, walk = 27496, run = 27497, runBack = 27499, turnLeft = 27496, turnRight = 27496, walkBack = 27498, walkLeft = 27496, walkRight = 27496 },  -- MTX93_ALEC_SHOWCASE_PLAYER_HUNTER_MAUL_IDLE
    [3596] = { stand = 27505, walk = 27506, run = 27508, runBack = 27509, turnLeft = 27506, turnRight = 27506, walkBack = 27507, walkLeft = 27506, walkRight = 27506 },  -- MTX93_ALEC_SHOWCASE_PLAYER_HUNTER_TWO_HANDED_CROSSBOW_IDLE
    [3597] = { stand = 27500, walk = 27502, run = 27501, runBack = 27504, turnLeft = 27502, turnRight = 27502, walkBack = 27503, walkLeft = 27502, walkRight = 27502 },  -- MTX93_ALEC_SHOWCASE_PLAYER_HUNTER_IDLE_DUAL
    [3598] = { stand = 27510, walk = 27511, run = 27512, runBack = 27512, turnLeft = 27511, turnRight = 27511, walkBack = 27511 },  -- MTX93_ZOLTAN_SHOWCASE_PLAYER_REVENANT_IDLE
    [3599] = { stand = 27513, walk = 27514, run = 27515, runBack = 27515, turnLeft = 27514, turnRight = 27514, walkBack = 27514 },  -- MTX93_ZOLTAN_SHOWCASE_PLAYER_REVENANT_MAUL_IDLE
    [3600] = { stand = 27516, walk = 27517, run = 27518, runBack = 27518, turnLeft = 27517, turnRight = 27517, walkBack = 27517 },  -- MTX93_ZOLTAN_SHOWCASE_PLAYER_REVENANT_STAFF_IDLE
    [3601] = { stand = 27519, walk = 27521, run = 27522, turnLeft = 27519, turnRight = 27519 },  -- MTX_DRAGONLING_IDLE
    [3602] = { stand = 27547, walk = 27546, run = 27546 },  -- GOEBIE1_GOEBIE_PICKAXE_IDLE
    [3603] = { stand = 26995 },  -- TUSKA_RAIDS_GOEBIE_SCARED_IDLE
    [3604] = { stand = 27548 },  -- GOEBIE1_METHUSELAH_IDLE
    [3605] = { stand = 27564 },  -- GOEBIE1_GUARDIAN_DRAINING_IDLE
    [3606] = { stand = 27575, walk = 27576 },  -- GOEBIE1_GUARDIAN_IDLE
    [3607] = { stand = 27533, walk = 27532, run = 27532 },  -- GOEBIE1_CRITTER_1_IDLE
    [3608] = { crawl = 27535, turnLeft = 27534, turnRight = 27534, idles = { { 27534, 220 }, { 27537, 25 } } },
    [3609] = { stand = 27538, walk = 27536, run = 27536, turnLeft = 27538, turnRight = 27538 },  -- GOEBIE1_CRITTER_2_IDLE_FROM_ROLL
    [3610] = { stand = 27540, walk = 27539 },  -- GOEBIE1_CRITTER_3_IDLE
    [3611] = { walk = 27542, idles = { { 27541, 220 }, { 27543, 25 } } },
    [3612] = { stand = 26442, walk = 27582, run = 27585, runBack = 27585, runLeft = 27585, runRight = 27585, turnLeft = 26442, turnRight = 26442, walkBack = 27582, runTurnLeft = 27585, runTurnRight = 27585, walkTurnLeft = 27582, walkTurnRight = 27582 },  -- TUSKA_RAIDS_GOEBIE_IDLE
    [3613] = { stand = 26442, walk = 27583, run = 27586, runBack = 27586, runLeft = 27586, runRight = 27586, turnLeft = 26442, turnRight = 26442, walkBack = 27583, runTurnLeft = 27586, runTurnRight = 27586, walkTurnLeft = 27583, walkTurnRight = 27583 },  -- TUSKA_RAIDS_GOEBIE_IDLE
    [3614] = { stand = 26442, walk = 27584, run = 27587, runBack = 27587, runLeft = 27587, runRight = 27587, turnLeft = 26442, turnRight = 26442, walkBack = 27584, runTurnLeft = 27587, runTurnRight = 27587, walkTurnLeft = 27584, walkTurnRight = 27584 },  -- TUSKA_RAIDS_GOEBIE_IDLE
    [3615] = { stand = 27578 },  -- GOEBIE1_GOEBIE_MEDITATE_IDLE
    [3616] = { stand = 27592, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- FALSIEGE_PARTY_PETE_DANCE_IDLE
    [3617] = { stand = 27599 },  -- FALSIEGE_HERALD_OF_FALADOR_IDLE
    [3618] = { stand = 27596, walk = 27595, run = 28435, turnLeft = 27595, turnRight = 27595, walkLeft = 27595, walkRight = 27595, walkTurnLeft = 27595, walkTurnRight = 27595 },  -- FALSIEGE_CHAMPION_BLACK_KNIGHT_IDLE
    [3619] = { stand = 27597, walk = 27594, turnLeft = 27594, turnRight = 27594, walkLeft = 27594, walkRight = 27594, walkTurnLeft = 27594, walkTurnRight = 27594 },  -- FALSIEGE_CHAMPION_WHITE_KNIGHT_IDLE
    [3620] = { stand = 27612 },  -- FALSIEGE_NURSE_BECKONING
    [3621] = { stand = 27613 },  -- FALSIEGE_NURSE_BECKONING_B
    [3622] = { stand = 27615, walk = 27614, turnLeft = 27615, turnRight = 27615, walkLeft = 27614, walkRight = 27614, walkTurnLeft = 27614, walkTurnRight = 27614 },  -- FALSIEGE_HAIRDRESSER_IDLE
    [3623] = { stand = 27616, walk = 27617, turnLeft = 823, turnRight = 823, walkBack = 27618, walkLeft = 27619, walkRight = 27620 },  -- FALSIEGE_SIRTIFFY_COMORB_IDLE
    [3624] = { stand = 27621, walk = 27622, run = 27622, runBack = 27625, runLeft = 27623, runRight = 27624, turnLeft = 27623, turnRight = 27624, walkBack = 27625, walkLeft = 27623, walkRight = 27624, runTurnLeft = 27622, runTurnRight = 27622, walkTurnLeft = 27622, walkTurnRight = 27622 },  -- HW15_PLAYER_BOAT_IDLE
    [3625] = { stand = 27639, walk = 27634, walkBack = 27634, walkTurnLeft = 27634, walkTurnRight = 27634 },  -- HW15_DEVOURER_IDLE
    [3626] = { stand = 27684, walk = 27683, walkBack = 27683, walkTurnLeft = 27683, walkTurnRight = 27683 },  -- HW15_GORILLA_DEVOURER_IDLE
    [3627] = { stand = 27640 },  -- HW15_CHEST_FLOAT
    [3628] = { stand = 27651 },  -- HW15_DOOR_BOSS_IDLE
    [3629] = { stand = 27644, walk = 27644 },  -- HW15_WISP_IDLE
    [3630] = { stand = 27648, walk = 27648 },  -- HW15_BRIDGE_SOULS_IDLE
    [3631] = { stand = 27661, walk = 27664 },  -- HW15_ICTHLARIN_IDLE
    [3632] = { stand = 27661, walk = 27665 },  -- HW15_ICTHLARIN_IDLE
    [3633] = { idles = { { 27680, 85 }, { 27681, 85 }, { 27682, 85 } } },
    [3634] = { stand = 27675 },  -- HW15_AMASCUT_BOSS_STAGE_IDLE
    [3635] = { stand = 27692 },  -- HW15_CAT_PRIESTESS_IDLE
    [3636] = { stand = 27722, walk = 27723, run = 27724, walkBack = 27723, walkLeft = 27723, walkRight = 27723 },  -- TRH72_PLAYER_LOST_SWORD_IDLE
    [3637] = { stand = 27725, walk = 27726, run = 27727, runBack = 27727, runLeft = 27727, runRight = 27727, walkBack = 27726, walkLeft = 27726, walkRight = 27726 },  -- TRH73_SCARECROW_PET_IDLE
    [3638] = { stand = 10541, walk = 10541 },  -- SWEPT_CAULDRON
    [3639] = { stand = 27744 },  -- TRH74_BONFIRE_NIGHT_NPC_IDLE
    [3640] = { stand = 27747, walk = 27749, turnLeft = 27749, turnRight = 27749, walkTurnLeft = 27749, walkTurnRight = 27749 },  -- HLM_LIVING_WYVERN_IDLE
    [3641] = { stand = 27764 },  -- LFM_TZHAAR_2015_HERO_READY
    [3642] = { stand = 27766, walk = 27771, turnLeft = 27771, turnRight = 27771, walkTurnLeft = 27771, walkTurnRight = 27771 },  -- HLM_RIPPER_DEMON_IDLE
    [3643] = { stand = 27768 },  -- HLM_RIPPER_DEMON_CRYING_IDLE
    [3644] = { stand = 27785, walk = 27786, turnLeft = 27786, turnRight = 27786, walkTurnLeft = 27786, walkTurnRight = 27786 },  -- HLM_CAMELTAUR_IDLE
    [3645] = { stand = 27814, walk = 27815, turnLeft = 27815, turnRight = 27815, walkTurnLeft = 27815, walkTurnRight = 27815 },  -- HLM_MAMMOTH_IDLE
    [3646] = { stand = 27831, walk = 27834, run = 27835, turnLeft = 27834, turnRight = 27834, walkTurnLeft = 27834, walkTurnRight = 27834 },  -- HLM_MAMMOTH_PET_IDLE
    [3647] = { stand = 27845, walk = 27845, turnLeft = 27845, turnRight = 27845, walkBack = 27845, walkLeft = 27845, walkRight = 27845 },  -- XMAS15_PLAYER_ICESKATING
    [3648] = { stand = 27850 },  -- XMAS15_PLAYER_HIDE_IN_PRESENT_BAS
    [3649] = { stand = 27859, walk = 27861, run = 27863, turnLeft = 27861, turnRight = 27861 },  -- TRH78_PLUSHES_PLAYER_IDLE_BIG
    [3650] = { stand = 27858, walk = 27860, run = 27862, turnLeft = 27860, turnRight = 27860 },  -- TRH78_PLUSHES_PLAYER_IDLE_SMALL
    [3651] = { stand = 27870, walk = 27871, run = 27872 },  -- MTX_PREM15_POSTIE_PETE_IDLE
    [3652] = { stand = 27888 },  -- TRH79_LOOT_PINATA_IDLE
    [3653] = { stand = 27893, walk = 27892, run = 27894, turnLeft = 27893, turnRight = 27893, walkLeft = 27892, walkRight = 27892, walkTurnLeft = 27892, walkTurnRight = 27892 },  -- TUTISLAND_PLAYER_UNDERWATER_IDLE
    [3654] = { stand = 27899, walk = 18040, run = 18039, walkBack = 18040, walkTurnLeft = 18040, walkTurnRight = 18040 },  -- TUTISLAND_AQUAMANCER_IDLE
    [3655] = { stand = 27906 },  -- TUTISLAND_CURSED_ISLANDER_IDLE
    [3656] = { stand = 27907, walk = 27908, walkBack = 27908, walkTurnLeft = 27908, walkTurnRight = 27908 },  -- TUTISLAND_CURSED_ISLANDER_IDLE_FROM_WALK
    [3657] = { stand = 18015, walk = 27904, run = 27909, turnLeft = 18015, turnRight = 18015, walkLeft = 27904, walkRight = 27904, walkTurnLeft = 27904, walkTurnRight = 27904 },  -- COMBAT_2012_CASUAL_ARMED_IDLE
    [3658] = { stand = 27916, walk = 27916 },  -- TUTISLAND_SHRIMP_NPC
    [3659] = { stand = 27944, walk = 27944 },  -- TUTISLAND_RAINBOW_FISH_IDLE
    [3660] = { stand = 27923 },  -- TUTISLAND_RAT_DROWNED_IDLE
    [3661] = { stand = 27926, walk = 27926 },  -- TUTISLAND_HUMAN_TRAPPED_IN_BUBBLE
    [3662] = { stand = 27935 },  -- TUTISLAND_DARKWIZARD_DEFEATED_IDLE
    [3663] = { stand = 27929 },  -- TUTISLAND_TERROVA_ATTACK
    [3664] = { walk = 27930, idles = { { 23327, 120 }, { 23328, 60 }, { 23329, 60 } } },
    [3665] = { crawl = 24183, idles = { { 3824, 80 }, { 27953, 20 } } },
    [3666] = { stand = 27998, walk = 27999, run = 28000, turnLeft = 27999, walkLeft = 27999, walkRight = 27999 },  -- INVENT_POGOSTICK_IDLE
    [3667] = { stand = 28040, walk = 28041, run = 28042, turnLeft = 28041, turnRight = 28041, walkLeft = 28041, walkRight = 28041 },  -- INVENT_PLAYER_DWARF_CANNON_IDLE
    [3668] = { stand = 28047 },  -- INVENT_DOC_IDLE
    [3669] = { stand = 28048 },  -- TRH81_SNAKE_IDLE
    [3670] = { stand = 28051, walk = 28052, run = 28053, runBack = 28055, turnLeft = 28052, turnRight = 28052, walkBack = 28054 },  -- TRH82_PLAYER_VALENTINES_MASK_IDLE
    [3671] = { stand = 28056, walk = 28057, run = 28058, runBack = 28058, turnLeft = 28057, turnRight = 28057, walkBack = 28057 },  -- TRH82_VALENTINES_GOBLIN_BUTLER_IDLE
    [3672] = { stand = 28072, walk = 28073 },  -- TRH83_MIMIC_CHEST_IDLE
    [3673] = { stand = 6181, walk = 6180, run = 6180 },  -- SLICE_SURFACE_GOBLIN_SQUAT_READY
    [3674] = { stand = 17360, walk = 6180, run = 6180 },  -- GOBLIN_ARCHER_BOW_READY
    [3675] = { stand = 13794, walk = 13793, run = 13793 },  -- UPDATE_TROLL_READY_SWORD
    [3676] = { stand = 21774, walk = 21775, run = 21775, turnLeft = 21775, turnRight = 21775, walkLeft = 21775, walkRight = 21775, walkTurnLeft = 21775, walkTurnRight = 21775 },  -- SLISKE1_ICTHLARIN_IDLE
    [3677] = { stand = 28086, turnLeft = 28086, turnRight = 28086 },  -- NOMEL_CONSTRUCT_IDLE
    [3678] = { stand = 28094, walk = 28095, turnLeft = 28095, turnRight = 28095, walkLeft = 28095, walkRight = 28095, walkTurnLeft = 28095, walkTurnRight = 28095 },  -- NOMEL_ZANIK_CROSSBOW_IDLE
    [3679] = { stand = 28099 },  -- NOMEL_ZANIK_DEATH
    [3680] = { stand = 28151 },  -- NOMEL_FINAL_KILL_CUTSCENE_SHOT_2_NOMAD_INJURED_IDLE
    [3681] = { stand = 28113, walk = 28111, walkBack = 28112 },  -- NOMEL_BATTERING_RAM_IDLE
    [3682] = { stand = 28180, walk = 28181, run = 28182, runBack = 28184, turnLeft = 28181, turnRight = 28181, walkBack = 28183 },  -- MTX97_PLAYER_GAMEBLAST_BALLOON_IDLE
    [3683] = { stand = 28186, walk = 28188, run = 28189, turnLeft = 28188, turnRight = 28188 },  -- MTX97_PLAYER_GAMEBLAST_BALLOON_COMBAT_IDLE
    [3684] = { stand = 28252, walk = 28254, run = 28261, runLeft = 28261, runRight = 28261, turnLeft = 28254, turnRight = 28254, walkLeft = 28254, walkRight = 28254, runTurnLeft = 28261, runTurnRight = 28261, walkTurnLeft = 28254, walkTurnRight = 28254 },  -- GWD2_ZAROS_GENERAL_GROUNDED_IDLE
    [3685] = { stand = 28267, walk = 28269, run = 28270, runLeft = 28270, runRight = 28270, turnLeft = 28269, turnRight = 28269, walkLeft = 28269, walkRight = 28269, runTurnLeft = 28270, runTurnRight = 28270, walkTurnLeft = 28269, walkTurnRight = 28269 },  -- GWD2_ZAROS_GENERAL_DRAGON_IDLE
    [3686] = { stand = 28199, walk = 28201, run = 28202, runLeft = 28202, runRight = 28202, turnLeft = 28201, turnRight = 28201, walkLeft = 28201, walkRight = 28201, runTurnLeft = 28202, runTurnRight = 28202, walkTurnLeft = 28201, walkTurnRight = 28201 },  -- GWD2_SEREN_GENERAL_IDLE
    [3687] = { stand = 28219, walk = 28220, run = 28227, runLeft = 28227, runRight = 28227, turnLeft = 28220, turnRight = 28220, walkLeft = 28220, walkRight = 28220, runTurnLeft = 28227, runTurnRight = 28227, walkTurnLeft = 28220, walkTurnRight = 28220 },  -- GWD2_SLISKE_GENERAL_IDLE
    [3688] = { stand = 28224 },  -- GWD2_SLISKE_GENERAL_SPAWN_POSE
    [3689] = { stand = 28237, walk = 28240, run = 28238, runLeft = 28238, runRight = 28238, turnLeft = 28240, turnRight = 28240, walkLeft = 28240, walkRight = 28240, runTurnLeft = 28238, runTurnRight = 28238, walkTurnLeft = 28240, walkTurnRight = 28240 },  -- GWD2_ZAMORAK_GENERAL_IDLE
    [3690] = { stand = 28244, walk = 28246, run = 28245, runLeft = 28245, runRight = 28245, turnLeft = 28246, turnRight = 28246, walkLeft = 28246, walkRight = 28246, runTurnLeft = 28245, runTurnRight = 28245, walkTurnLeft = 28246, walkTurnRight = 28246 },  -- GWD2_ZAMORAK_GENERAL_BLACK_IDLE
    [3691] = { stand = 11982, walk = 11983, run = 28197, turnLeft = 11988, turnRight = 11988, walkBack = 11987, walkLeft = 11986, walkRight = 11985 },  -- _7W_HUMAN_DH_WEAPON_READY
    [3692] = { stand = 28321, walk = 28322, run = 28323, runBack = 28325, turnLeft = 28322, turnRight = 28322, walkBack = 28324, walkLeft = 28322, walkRight = 28322 },  -- TRH86_PLAYER_CANNON_IDLE
    [3693] = { walk = 28358, run = 28360, turnLeft = 28358, turnRight = 28358, walkLeft = 28358, walkRight = 28358, idles = { { 28359, 80 }, { 37976, 20 } } },
    [3694] = { idles = { { 28399, 50 }, { 28408, 50 } } },
    [3695] = { stand = 28401, walk = 28402, run = 28402 },  -- CHRONICLE_PET_BOOK_IDLE
    [3696] = { stand = 808, walk = 18812, turnLeft = 823, turnRight = 823, walkBack = 18813, walkLeft = 1198, walkRight = 1201 },  -- HUMAN_READY
    [3697] = { stand = 28500 },  -- GWD2_SLISKE_GENERAL_HEALING
    [3698] = { stand = 18012, walk = 28562, run = 28562, turnLeft = 28562, turnRight = 28562 },  -- COMBAT_2012_COMBAT_UNARMED_READY
    [3699] = { stand = 28441, walk = 28442, run = 28443, runLeft = 28443, runRight = 28443, turnLeft = 28442, turnRight = 28442, walkLeft = 28442, walkRight = 28442, runTurnLeft = 28443, runTurnRight = 28443, walkTurnLeft = 28442, walkTurnRight = 28442 },  -- GWD2_SLISKE_PET_IDLE
    [3700] = { stand = 28449, walk = 28450, run = 28451, runLeft = 28451, runRight = 28451, turnLeft = 28450, turnRight = 28450, walkLeft = 28450, walkRight = 28450, runTurnLeft = 28451, runTurnRight = 28451, walkTurnLeft = 28450, walkTurnRight = 28450 },  -- GWD2_ZAMORAK_PET_IDLE
    [3701] = { stand = 28454, walk = 28455, run = 28456, runLeft = 28456, runRight = 28456, turnLeft = 28455, turnRight = 28455, walkLeft = 28455, walkRight = 28455, runTurnLeft = 28456, runTurnRight = 28456, walkTurnLeft = 28455, walkTurnRight = 28455 },  -- GWD2_ZAMORAK_BLACK_PET_IDLE
    [3702] = { stand = 28459, walk = 28460, run = 28461, runLeft = 28461, runRight = 28461, turnLeft = 28460, turnRight = 28460, walkLeft = 28460, walkRight = 28460, runTurnLeft = 28461, runTurnRight = 28461, walkTurnLeft = 28460, walkTurnRight = 28460 },  -- GWD2_SEREN_PET_IDLE
    [3703] = { stand = 28464, walk = 28465, run = 28473, runLeft = 28473, runRight = 28473, turnLeft = 28465, turnRight = 28465, walkLeft = 28465, walkRight = 28465, runTurnLeft = 28473, runTurnRight = 28473, walkTurnLeft = 28465, walkTurnRight = 28465 },  -- GWD2_ZAROS_PET_IDLE
    [3704] = { stand = 28466, walk = 28467, run = 28472, runLeft = 28472, runRight = 28472, turnLeft = 28467, turnRight = 28467, walkLeft = 28467, walkRight = 28467, runTurnLeft = 28472, runTurnRight = 28472, walkTurnLeft = 28467, walkTurnRight = 28467 },  -- GWD2_ZAROS_DRAGON_PET_IDLE
    [3705] = { stand = 28526, walk = 28527, run = 28528, runBack = 28528, turnLeft = 28527, turnRight = 28527, walkBack = 28527 },  -- TRH88_HYPE_TRAIN_IDLE
    [3706] = { stand = 28529, walk = 28530, run = 28531, runBack = 28531, turnLeft = 28530, turnRight = 28530, walkBack = 28530 },  -- TRH88_HYPE_TRAIN_RELEASE_IDLE
    [3707] = { stand = 28535, walk = 28536, run = 28537, runBack = 28539, turnLeft = 28536, turnRight = 28536, walkBack = 28538 },  -- TRH88_PLAYER_WAND_IDLE
    [3708] = { stand = 28534, walk = 28542, run = 28543, runBack = 28545, turnLeft = 28542, turnRight = 28542, walkBack = 28544 },  -- TRH88_PLAYER_COIN_TOSS_IDLE
    [3709] = { stand = 28549, walk = 28550, run = 28551, runBack = 28553, turnLeft = 28550, turnRight = 28550, walkBack = 28552 },  -- MTX99_TERRORBIRD_MOUNT_IDLE
    [3710] = { stand = 37632, walk = 37653, run = 37654, turnLeft = 37653, turnRight = 37653 },  -- HUMAN_ACTOR_COMBAT_ARMED_IDLE
    [3711] = { stand = 37652, walk = 37659, run = 37660, turnLeft = 37659, turnRight = 37659 },  -- HUMAN_ACTOR_COMBAT_UNARMED_IDLE
    [3712] = { stand = 37629, walk = 37665, run = 37666, turnLeft = 37665, turnRight = 37665 },  -- HUMAN_ACTOR_COMBAT_ARMED_BOW_IDLE
    [3713] = { stand = 37629, walk = 37667, run = 37668, turnLeft = 37667, turnRight = 37667 },  -- HUMAN_ACTOR_COMBAT_ARMED_BOW_IDLE
    [3714] = { walk = 28564, run = 28565, turnLeft = 28564, turnRight = 28564, idles = { { 18015, 80 }, { 2691, 20 } } },
    [3715] = { walk = 28567, run = 28566, turnLeft = 28567, turnRight = 28567, idles = { { 18041, 80 }, { 3803, 20 } } },
    [3716] = { walk = 28568, run = 28566, turnLeft = 28568, turnRight = 28568, idles = { { 18048, 80 }, { 28085, 20 } } },
    [3717] = { stand = 28573, walk = 28574, turnLeft = 28574, turnRight = 28574, walkLeft = 28574, walkRight = 28574, walkTurnLeft = 28574, walkTurnRight = 28574 },  -- MYQ7_GHOUL_IDLE
    [3718] = { stand = 28579, walk = 28574, turnLeft = 28574, turnRight = 28574, walkLeft = 28574, walkRight = 28574, walkTurnLeft = 28574, walkTurnRight = 28574 },  -- MYQ7_GHOUL_IDLE_VERSION_B
    [3719] = { stand = 28581, walk = 28582, turnLeft = 28582, turnRight = 28582, walkLeft = 28582, walkRight = 28582, walkTurnLeft = 28582, walkTurnRight = 28582 },  -- MYQ7_GHOUL_DEVOURER_IDLE
    [3720] = { stand = 28587, walk = 28588, turnLeft = 28588, turnRight = 28588, walkLeft = 28588, walkRight = 28588, walkTurnLeft = 28588, walkTurnRight = 28588 },  -- MYQ7_CHAMPION_GHOUL_IDLE
    [3721] = { stand = 23756, walk = 819, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_MINING_FLOOR
    [3722] = { stand = 28601 },  -- NXT_LAUNCH_YAK_IDLE
    [3723] = { stand = 28602, walk = 6577 },  -- DOG_UPDATE_WOLF_READY_SILENT
    [3724] = { stand = 28608, walk = 28609, run = 28610, turnLeft = 28609, turnRight = 28609, walkLeft = 28609, walkRight = 28609, walkTurnLeft = 28609, walkTurnRight = 28609 },  -- MYQ7_VENATOR_GHRAZI_IDLE
    [3725] = { stand = 28616, walk = 28615, run = 28617, turnLeft = 28615, turnRight = 28615, walkLeft = 28615, walkRight = 28615, walkTurnLeft = 28615, walkTurnRight = 28615 },  -- MYQ7_VENATOR_SHADUM_IDLE
    [3726] = { stand = 28627, walk = 28628, turnLeft = 28628, turnRight = 28628, walkLeft = 28628, walkRight = 28628, walkTurnLeft = 28628, walkTurnRight = 28628 },  -- MYQ7_EFARITAY_IDLE
    [3727] = { stand = 28633, walk = 28634, run = 28636, turnLeft = 28634, turnRight = 28634, walkLeft = 28634, walkRight = 28634, walkTurnLeft = 28634, walkTurnRight = 28634 },  -- MYQ7_SAFALAAN_WYRD_IDLE
    [3728] = { stand = 28663, walk = 28663, run = 28663, turnLeft = 28663, turnRight = 28663, walkLeft = 28663, walkRight = 28663, walkTurnLeft = 28663, walkTurnRight = 28663 },  -- MYQ7_SAFALAAN_WRYD_CHAMBER_IDLE
    [3729] = { stand = 28660, walk = 28660 },  -- MYQ7_REFINERY_GIBBET_IDLE
    [3730] = { stand = 28661, walk = 28661 },  -- MYQ7_JUVENILE_IN_CAGE_IDLE
    [3731] = { stand = 28653 },  -- MYQ7_JUVENILE_ARMY_IDLE
    [3732] = { stand = 28654 },  -- MYQ7_JUVENILE_ARMY_IDLE_B
    [3733] = { stand = 28655 },  -- MYQ7_VYREWATCH_ARMY_IDLE
    [3734] = { stand = 28656 },  -- MYQ7_VYREWATCH_ARMY_IDLE_B
    [3735] = { stand = 28665 },  -- MYQ7_BLOODVELD_ARMY_IDLE_B
    [3736] = { stand = 28664 },  -- MYQ7_BLOODVELD_ARMY_IDLE_A
    [3737] = { stand = 28666 },  -- MYQ7_WEREWOLF_ARMY_IDLE_A
    [3738] = { stand = 28667 },  -- MYQ7_WEREWOLF_ARMY_IDLE_B
    [3739] = { stand = 28668, walk = 28669, turnLeft = 28669, turnRight = 28669, walkLeft = 28669, walkRight = 28669, walkTurnLeft = 28669, walkTurnRight = 28669 },  -- MYQ7_EFARITAY_IDLE_UPRIGHT
    [3740] = { stand = 37640, walk = 37663, run = 37664, turnLeft = 37663, turnRight = 37663 },  -- HUMAN_ACTOR_COMBAT_ARMED_TWO_HANDED_SPEAR_IDLE
    [3741] = { stand = 28747, walk = 28748, turnLeft = 28748, turnRight = 28748, walkTurnLeft = 28748, walkTurnRight = 28748 },  -- QUEST_SISTER_MARIMBO_DRUNK_IDLE
    [3742] = { stand = 28758, walk = 28759, turnLeft = 28759, turnRight = 28759, walkTurnLeft = 28759, walkTurnRight = 28759 },  -- QUEST_SISTER_AHRIM_BLIND_IDLE
    [3743] = { stand = 28764, walk = 28823, turnLeft = 28823, turnRight = 28823, walkTurnLeft = 28823, walkTurnRight = 28823 },  -- QUEST_SISTER_STAFF_IDLE
    [3744] = { stand = 19158, walk = 15428, run = 17069 },  -- POP_MEG_IDLE
    [3745] = { stand = 28813, walk = 1919, turnLeft = 823, turnRight = 823 },  -- QUEST_SISTER_LINZA_IDLE
    [3746] = { stand = 28819 },  -- QUEST_SISTER_GUTHAN_ROOM_BROTHER_HANG
    [3747] = { stand = 28822 },  -- QUEST_SISTER_GUTHAN_ROOM_BROTHER_HANG_ALT
    [3748] = { stand = 28820 },  -- QUEST_SISTER_GUTHAN_BALANCING
    [3749] = { stand = 28756 },  -- QUEST_SISTER_BROTHER_SAMWELL_DEAD
    [3750] = { walk = 28887, idles = { { 28887, 150 }, { 31118, 150 } } },
    [3751] = { stand = 28888, walk = 28889, run = 28890, turnLeft = 28889, turnRight = 28889, walkBack = 28889, walkLeft = 28889, walkRight = 28889, walkTurnLeft = 28889, walkTurnRight = 28889 },  -- GOWER_IDLE
    [3752] = { stand = 28903 },  -- GOWER_PLAYER_ROCKING_HORSE_IDLE
    [3753] = { stand = 28896, walk = 28897, turnLeft = 28897, turnRight = 28897, walkBack = 28897, walkLeft = 28897, walkRight = 28897, walkTurnLeft = 28897, walkTurnRight = 28897 },  -- QUEST_GOWER_BLACK_KNIGHT_TITAN_IDLE
    [3754] = { stand = 28905 },  -- QUEST_GOWER_BLACK_KNIGHT_TITAN_DEATH_POSE
    [3755] = { idles = { { 28888, 25 } } },
    [3756] = { stand = 28903, walk = 28908, run = 28910, turnLeft = 28912, turnRight = 28912, walkBack = 28908, walkLeft = 28912, walkRight = 28912, walkTurnLeft = 28908, walkTurnRight = 28908 },  -- GOWER_PLAYER_ROCKING_HORSE_IDLE
    [3757] = { stand = 28920 },  -- GWD2_SOLO_SEER_IDLE
    [3758] = { stand = 28925, walk = 28927, run = 28926, runLeft = 28926, runRight = 28926, turnLeft = 28927, turnRight = 28927, walkLeft = 28927, walkRight = 28927, runTurnLeft = 28926, runTurnRight = 28926, walkTurnLeft = 28927, walkTurnRight = 28927 },  -- GWD2_SOLO_BOSS_IDLE
    [3759] = { stand = 28925, walk = 28944, run = 28943, runLeft = 28943, runRight = 28943, turnLeft = 28944, turnRight = 28944, walkLeft = 28944, walkRight = 28944, runTurnLeft = 28943, runTurnRight = 28943, walkTurnLeft = 28944, walkTurnRight = 28944 },  -- GWD2_SOLO_BOSS_IDLE
    [3760] = { stand = 28933 },  -- GWD2_SOLO_BOSS_TENTACLES_ATTACK
    [3761] = { stand = 28940, turnLeft = 28948, turnRight = 28949 },  -- GWD2_SOLO_BOSS_LARGE_IDLE
    [3762] = { stand = 29003 },  -- GWD2_SOLO_MINION_DEATH_POSE
    [3763] = { stand = 28996, walk = 29002, run = 28999, runLeft = 28999, runRight = 28999, turnLeft = 29002, turnRight = 29002, walkLeft = 29002, walkRight = 29002, runTurnLeft = 28999, runTurnRight = 28999, walkTurnLeft = 29002, walkTurnRight = 29002 },  -- GWD2_SOLO_MINION_IDLE
    [3764] = { stand = 28961 },  -- GWD2_SOLO_BOSS_DEACTIVATED
    [3765] = { stand = 28988 },  -- GWD2_SOLO_FONT
    [3766] = { stand = 28989 },  -- GWD2_SOLO_FONT_END
    [3767] = { stand = 28970, walk = 28971, run = 28977, runLeft = 28977, runRight = 28977, turnLeft = 28971, turnRight = 28971, walkLeft = 28971, walkRight = 28971, runTurnLeft = 28977, runTurnRight = 28977, walkTurnLeft = 28971, walkTurnRight = 28971 },  -- GWD2_SOLO_BOSSPET_IDLE
    [3768] = { stand = 29023 },  -- GWD2_SOLO_BOUNTY_HUNTER_IDLE
    [3769] = { stand = 29052 },  -- ELR1_PRISON_GUARD_CALLING
    [3770] = { stand = 29045 },  -- ELR0_STAN_IDLE
    [3771] = { stand = 29048 },  -- ELR0_PLAYER_LIGHT_CANNON
    [3772] = { stand = 27441 },  -- PLAYER_REPAIR_TEMPLE_HIGH_HAMMER_WOOD
    [3773] = { stand = 13657 },  -- RAND_PLAYER_SMELTING
    [3774] = { stand = 22757 },  -- PLAYER_2014_HERBLORE_PESTLE_MORTAR
    [3775] = { stand = 29056 },  -- ELR1_QUARTERMASTER_IDLE
    [3776] = { stand = 29057 },  -- ELR0_AHAB_PUB_SITTING_IDLE
    [3777] = { stand = 29064 },  -- ELR1_SHARK_FISHERMAN_NPC_IDLE
    [3778] = { stand = 29058, walk = 29059, crawl = 29062, crawlLeft = 29062, crawlRight = 29062, turnLeft = 29058, turnRight = 29058, walkBack = 29059, walkLeft = 29059, walkRight = 29059 },  -- ELR1_TURTLE_IDLE
    [3779] = { stand = 29063, walk = 29061 },  -- ELR1_CRAB_WALK_TO_IDLE
    [3780] = { stand = 29069, walk = 29069 },  -- ELR1_FISHING_SPOT
    [3781] = { stand = 29070, walk = 29071, turnLeft = 29071, turnRight = 29071, walkTurnLeft = 29071, walkTurnRight = 29071 },  -- ELR1_CYCLOPS_IDLE
    [3782] = { stand = 29077, walk = 29071, turnLeft = 29071, turnRight = 29071, walkTurnLeft = 29071, walkTurnRight = 29071 },  -- ELR1_CYCLOPS_PARROT_IDLE
    [3783] = { stand = 29076 },  -- ELR1_CYCLOPS_DEFEATED
    [3784] = { stand = 29078, walk = 29072, turnLeft = 29072, turnRight = 29072, walkTurnLeft = 29072, walkTurnRight = 29072 },  -- ELR1_SPIRIT_DRAGON_IDLE
    [3785] = { stand = 29120, walk = 29120, turnLeft = 29120, turnRight = 29120, walkTurnLeft = 29120, walkTurnRight = 29120 },  -- ELR1_SPIRIT_DRAGON_PET_WALK
    [3786] = { stand = 29088 },  -- ELR1_REWARDS_MERCHANT_IDLE
    [3787] = { stand = 29094 },  -- ELR1_REWARDS_VENDOR_IDLE
    [3788] = { stand = 29096 },  -- ELR1_ARCHITECT_IDLE
    [3789] = { stand = 29100, walk = 29099, run = 29099, turnLeft = 29099, turnRight = 29099 },  -- ELR1_SLAYER_ELEMENTAL_COMBAT_IDLE
    [3790] = { stand = 18019, walk = 29098, run = 29098, turnLeft = 29098, turnRight = 29098 },  -- COMBAT_2012_CASUAL_UNARMED_IDLE
    [3791] = { stand = 29097 },  -- ELR1_FISH_MERCHANT_IDLE
    [3792] = { stand = 29109 },  -- ELR1_SALT_MERCHANT_IDLE
    [3793] = { stand = 29101 },  -- ELR1_SHIP_CHANDLER_IDLE
    [3794] = { stand = 29110 },  -- ELR1_BAMBOO_MERCHANT_IDLE
    [3795] = { stand = 29117, walk = 29118, run = 29119 },  -- ELR1_PLAYER_PROUD_IDLE
    [3796] = { stand = 24928 },  -- PLAYER_2014_FISHING_ROD_CAST
    [3797] = { stand = 29130, walk = 29131, run = 29132, runBack = 29140, turnLeft = 29131, turnRight = 29131, walkBack = 29139 },  -- GAMECARD_CRYSTAL_PEACOCK_IDLE
    [3798] = { stand = 29142, walk = 29143, run = 29144, runBack = 29146, turnLeft = 29143, turnRight = 29143, walkBack = 29145 },  -- MTXBEACH_PLAYER_UMBRELLA_IDLE
    [3799] = { stand = 29157, walk = 29158, run = 29159, runBack = 29161, turnLeft = 29158, turnRight = 29158, walkBack = 29160 },  -- MTXBEACH16_PLAYER_KITE_IDLE
    [3800] = { stand = 29163, walk = 29164, run = 29165, turnLeft = 29164, turnRight = 29164 },  -- MTXBEACH16_PLAYER_KITE_COMBAT_IDLE
    [3801] = { walk = 27470, run = 27471, turnLeft = 27470, turnRight = 27470, walkLeft = 27470, walkRight = 27470, walkTurnLeft = 27470, walkTurnRight = 27470, idles = { { 27469, 200 }, { 27474, 100 } } },
    [3802] = { stand = 29180 },  -- MTXBEACH_PLAYER_REST_SAND_DUNK_LOOP
    [3803] = { stand = 29201 },  -- MTXBEACH_PLAYER_REST_HACKEYSACK_LOOP
    [3804] = { walk = 29184, run = 29185, idles = { { 29182, 95 }, { 29186, 5 } } },
    [3805] = { stand = 29188, walk = 29189, run = 29190 },  -- MTXBEACH_SEAHORSE_IDLE
    [3806] = { stand = 29193, walk = 29194, run = 29195, turnLeft = 29198, turnRight = 29198 },  -- MTXBEACH_STARFISH_IDLE
    [3807] = { stand = 29214 },  -- MTXBEACH_PLAYER_HOOK_A_DUCK_IDLE
    [3808] = { stand = 29215, walk = 29216, run = 29219, walkBack = 29216, walkLeft = 29216, walkRight = 29216, walkTurnLeft = 29216, walkTurnRight = 29216 },  -- SKILLPETS_RUNECRAFT_IDLE
    [3809] = { stand = 29224, walk = 29223, run = 29223, walkBack = 29223, walkLeft = 29223, walkRight = 29223, walkTurnLeft = 29223, walkTurnRight = 29223 },  -- SKILLPETS_FISHING_IDLE
    [3810] = { stand = 29230, walk = 29235, run = 29236, walkBack = 29235, walkLeft = 29235, walkRight = 29235, walkTurnLeft = 29235, walkTurnRight = 29235 },  -- SKILLPETS_AGILITY_IDLE
    [3811] = { stand = 29238, walk = 29239, run = 29241, walkBack = 29239, walkLeft = 29239, walkRight = 29239, walkTurnLeft = 29239, walkTurnRight = 29239 },  -- SKILLPETS_CONSTRUCTION_IDLE
    [3812] = { stand = 29248, walk = 29253, run = 29254, walkBack = 29253, walkLeft = 29253, walkRight = 29253, walkTurnLeft = 29253, walkTurnRight = 29253 },  -- SKILLPETS_HERBLORE_IDLE
    [3813] = { stand = 29256, walk = 29261, run = 29260, walkBack = 29261, walkLeft = 29261, walkRight = 29261, walkTurnLeft = 29261, walkTurnRight = 29261 },  -- SKILLPETS_THIEVING_IDLE
    [3814] = { stand = 29264, walk = 29265, run = 29268, walkBack = 29265, walkLeft = 29265, walkRight = 29265, walkTurnLeft = 29265, walkTurnRight = 29265 },  -- SKILLPETS_FLETCHING_IDLE
    [3815] = { stand = 29272, walk = 29277, run = 29279, walkBack = 29277, walkLeft = 29277, walkRight = 29277, walkTurnLeft = 29277, walkTurnRight = 29277 },  -- SKILLPETS_COOKING_IDLE
    [3816] = { stand = 29280, walk = 29283, run = 29284, walkBack = 29283, walkLeft = 29283, walkRight = 29283, walkTurnLeft = 29283, walkTurnRight = 29283 },  -- SKILLPETS_WOODCUTTING_IDLE
    [3817] = { walk = 29283, run = 29290, walkBack = 29283, walkLeft = 29283, walkRight = 29283, walkTurnLeft = 29283, walkTurnRight = 29283, idles = { { 29280, 200 }, { 29324, 55 } } },
    [3818] = { stand = 29330, walk = 29331, run = 29332, walkBack = 29331, walkLeft = 29331, walkRight = 29331, walkTurnLeft = 29331, walkTurnRight = 29331 },  -- SKILLPETS_DUNGEONEERING_HOARDSTALKER_IDLE
    [3819] = { stand = 29291, walk = 29291, run = 29291, walkBack = 29291, walkLeft = 29291, walkRight = 29291, walkTurnLeft = 29291, walkTurnRight = 29291 },  -- SKILLPETS_DIVINATION_IDLE
    [3820] = { stand = 29297, walk = 29300, run = 29301, walkBack = 29300, walkLeft = 29300, walkRight = 29300, walkTurnLeft = 29300, walkTurnRight = 29300 },  -- SKILLPETS_MINING_IDLE
    [3821] = { walk = 29308, run = 29309, walkBack = 29308, walkLeft = 29308, walkRight = 29308, walkTurnLeft = 29308, walkTurnRight = 29308, idles = { { 29307, 230 }, { 29312, 15 } } },
    [3822] = { stand = 29316, walk = 29317, run = 29318, walkBack = 29317, walkLeft = 29317, walkRight = 29317, walkTurnLeft = 29317, walkTurnRight = 29317 },  -- SKILLPETS_FARMING_IDLE
    [3823] = { stand = 29325, walk = 29326, run = 29326, walkBack = 29326, walkLeft = 29326, walkRight = 29326, walkTurnLeft = 29326, walkTurnRight = 29326 },  -- SKILLPETS_SLAYER_IDLE
    [3824] = { stand = 842, walk = 29354 },  -- HUMAN_TRANSREADY
    [3825] = { stand = 29364, walk = 29365, turnLeft = 29365, turnRight = 29365, walkLeft = 29365, walkRight = 29365, walkTurnLeft = 29365, walkTurnRight = 29365 },  -- DAGANNOTH_KINGS_2016_UPDATE_MELEE_IDLE
    [3826] = { stand = 29369, walk = 29370, turnLeft = 29370, turnRight = 29370, walkLeft = 29370, walkRight = 29370, walkTurnLeft = 29370, walkTurnRight = 29370 },  -- DAGANNOTH_KINGS_2016_UPDATE_RANGE_IDLE
    [3827] = { stand = 29376, walk = 29377, turnLeft = 29377, turnRight = 29377, walkLeft = 29377, walkRight = 29377, walkTurnLeft = 29377, walkTurnRight = 29377 },  -- DAGANNOTH_KINGS_2016_UPDATE_MAGIC_IDLE
    [3828] = { stand = 29384 },  -- QUEST_NOMEL_PQ_MEMORY_01_TEMPLE_KNIGHT_STAB_ZAMORAKIAN
    [3829] = { stand = 29385 },  -- QUEST_NOMEL_PQ_MEMORY_01_ZAMORAKIAN_STABBED
    [3830] = { stand = 29386 },  -- QUEST_NOMEL_PQ_MEMORY_01_ZAMORAKIAN_CAST_SPELL
    [3831] = { stand = 29387 },  -- QUEST_NOMEL_PQ_MEMORY_01_TEMPLE_KNIGHT_ATTACK_A
    [3832] = { stand = 29388 },  -- QUEST_NOMEL_PQ_MEMORY_01_TEMPLE_KNIGHT_ATTACK_B
    [3833] = { stand = 29389 },  -- QUEST_NOMEL_PQ_MEMORY_01_NOMAD_SCARED
    [3834] = { stand = 29391 },  -- QUEST_NOMEL_PQ_MEMORY_02_NOMAD_PICKPOCKET
    [3835] = { stand = 29392 },  -- QUEST_NOMEL_PQ_MEMORY_02_GENTLEMAN
    [3836] = { stand = 29393 },  -- QUEST_NOMEL_PQ_MEMORY_02_NOMAD_MUGGED
    [3837] = { stand = 29394 },  -- QUEST_NOMEL_PQ_MEMORY_02_MUGGER_A
    [3838] = { stand = 29395 },  -- QUEST_NOMEL_PQ_MEMORY_02_MUGGER_B
    [3839] = { stand = 29396 },  -- QUEST_NOMEL_PQ_MEMORY_02_NOMAD_SLEEP_ROUGH
    [3840] = { stand = 29397 },  -- QUEST_NOMEL_PQ_MEMORY_02_NOMAD_BEAT_MUGGERS
    [3841] = { stand = 29398 },  -- QUEST_NOMEL_PQ_MEMORY_02_MUGGER_A_BEATEN
    [3842] = { stand = 29399 },  -- QUEST_NOMEL_PQ_MEMORY_02_MUGGER_B_BEATEN
    [3843] = { stand = 29400 },  -- QUEST_NOMEL_PQ_MEMORY_03_FRIGHTENED_MAN
    [3844] = { stand = 29403 },  -- QUEST_NOMEL_PQ_MEMORY_03_FRIGHTENED_MAN_SPOTANIM
    [3845] = { stand = 29401 },  -- QUEST_NOMEL_PQ_MEMORY_03_HOODED_MAN_DRAW_ENERGY
    [3846] = { stand = 29404 },  -- QUEST_NOMEL_PQ_MEMORY_03_NOMAD_STAND
    [3847] = { stand = 29405 },  -- QUEST_NOMEL_PQ_MEMORY_04_NOMAD_STAB_OREB
    [3848] = { stand = 29406 },  -- QUEST_NOMEL_PQ_MEMORY_04_OREB_STABBED
    [3849] = { stand = 29407 },  -- QUEST_NOMEL_PQ_MEMORY_05_NOMAD_CAST_SPELL
    [3850] = { stand = 29408 },  -- QUEST_NOMEL_PQ_MEMORY_05_DRAGITH_NURN_IN_AIR
    [3851] = { stand = 29411 },  -- QUEST_NOMEL_PQ_MEMORY_06_NOMAD_MAGICAL_POSE
    [3852] = { stand = 29413 },  -- QUEST_NOMEL_PQ_MEMORY_07_NOMAD_WELCOME_SOUL_WARS
    [3853] = { stand = 29414 },  -- QUEST_NOMEL_PQ_MEMORY_08_NOMAD_ON_THRONE
    [3854] = { stand = 29415 },  -- QUEST_NOMEL_PQ_MEMORY_08_NOMAD_JUMP
    [3855] = { stand = 29416 },  -- QUEST_NOMEL_PQ_MEMORY_08_NOMAD_DEFEATED
    [3856] = { stand = 29417 },  -- QUEST_NOMEL_PQ_MEMORY_09_NOMAD_CONVERSATION
    [3857] = { stand = 29418 },  -- QUEST_NOMEL_PQ_MEMORY_09_WHITE_KNIGHT_CONVERSATION
    [3858] = { stand = 29419 },  -- QUEST_NOMEL_PQ_MEMORY_10_NOMAD_THROW_WHITE_KNIGHT
    [3859] = { stand = 29420 },  -- QUEST_NOMEL_PQ_MEMORY_10_WHITE_KNIGHT_THROWN_OFF_CLIFF
    [3860] = { stand = 29421 },  -- QUEST_NOMEL_PQ_MEMORY_11_NOMAD_DRAINED_BY_DEATH
    [3861] = { stand = 29422 },  -- QUEST_NOMEL_PQ_MEMORY_11_DEATH_DRAIN_NOMAD
    [3862] = { stand = 29438 },  -- TRH100_PET_OF_SEASONS_LARGE_IDLE
    [3863] = { stand = 29439, walk = 27478, run = 27479, runBack = 27481, turnLeft = 27478, turnRight = 27478, walkBack = 27480 },  -- TRH100_PET_OF_SEASONS_IDLE_ZOMBIE
    [3864] = { stand = 29440 },  -- ELR1_SITTING_DEAD
    [3865] = { stand = 28978 },  -- GWD2_SOLO_ANIMA_STREAMS
    [3866] = { stand = 29453, walk = 29482 },  -- ELR2_BIRD_COCKATIEL_IDLE
    [3867] = { stand = 29454, walk = 29482 },  -- ELR2_BIRD_LIMPKIN_IDLE
    [3868] = { stand = 29455, walk = 29482 },  -- ELR2_BIRD_KAKAPO_IDLE
    [3869] = { stand = 29456, walk = 29482 },  -- ELR2_BIRD_PLOVER_IDLE
    [3870] = { stand = 29457, walk = 29482 },  -- ELR2_BIRD_WIGGLEBILL_IDLE
    [3871] = { stand = 29458, walk = 29482 },  -- ELR2_BIRD_TINAMOU_IDLE
    [3872] = { stand = 29462, walk = 29483 },  -- ELR2_BIRD_PARROT_IDLE
    [3873] = { stand = 29463, walk = 29483 },  -- ELR2_BIRD_GUAN_IDLE
    [3874] = { stand = 29464, walk = 29483 },  -- ELR2_BIRD_PECKER_IDLE
    [3875] = { stand = 29465, walk = 29483 },  -- ELR2_BIRD_TOUCAN_IDLE
    [3876] = { stand = 29466, walk = 29483 },  -- ELR2_BIRD_WARBLER_IDLE
    [3877] = { stand = 29467, walk = 29483 },  -- ELR2_BIRD_JUBLET_IDLE
    [3878] = { stand = 29468, walk = 29483 },  -- ELR2_BIRD_MACAW_IDLE
    [3879] = { stand = 29472, walk = 29484 },  -- ELR2_BIRD_PELIGORN_IDLE
    [3880] = { stand = 29473, walk = 29484 },  -- ELR2_BIRD_SNATCHER_IDLE
    [3881] = { walk = 25359, run = 25360, runBack = 25357, turnLeft = 25357, turnRight = 25357, walkBack = 25357, walkTurnLeft = 25359, walkTurnRight = 25359, idles = { { 25357, 80 }, { 29474, 20 } } },
    [3882] = { stand = 29447, walk = 29449, turnLeft = 29449, turnRight = 29449, walkTurnLeft = 29449, walkTurnRight = 29449 },  -- ELR2_ZOMBIE_CYCLOPS_IDLE
    [3883] = { stand = 29448, walk = 29450, turnLeft = 29450, turnRight = 29450, walkTurnLeft = 29450, walkTurnRight = 29450 },  -- ELR2_ZOMBIE_CYCLOPS_IDLE_WITH_MOAN_SOUNDS
    [3884] = { stand = 29485 },  -- ELR2_FISH_MERCHANT_SISTER_IDLE
    [3885] = { stand = 29498 },  -- ELR2_BIRD_COLLECTOR_IDLE
    [3886] = { stand = 29499, walk = 29500 },  -- ELR2_BAKAMI_IDLE
    [3887] = { stand = 29514, crawl = 29515 },  -- ELR2_JIANGSHI_IDLE
    [3888] = { stand = 29531, walk = 29531 },  -- ELR2_JIANGSHI_AOE
    [3889] = { stand = 29525 },  -- ELR2_SUN_PRIEST_CYCLOPS_IDLE
    [3890] = { stand = 29524 },  -- ELR2_MOON_PRIEST_CYCLOPS_IDLE
    [3891] = { stand = 29526 },  -- ELR2_ICHI_CYCLOPS_IDLE
    [3892] = { stand = 29527 },  -- ELR2_CHEF_CYCLOPS_IDLE
    [3893] = { stand = 29528 },  -- ELR2_BLACKSMITH_CYCLOPS_IDLE
    [3894] = { stand = 29529, walk = 29071, turnLeft = 29071, turnRight = 29071, walkTurnLeft = 29071, walkTurnRight = 29071 },  -- ELR2_FEMALE_VILLAGER_CYCLOPS_IDLE_A
    [3895] = { stand = 29530, walk = 29071, turnLeft = 29071, turnRight = 29071, walkTurnLeft = 29071, walkTurnRight = 29071 },  -- ELR2_MALE_VILLAGER_CYCLOPS_IDLE_A
    [3896] = { stand = 29545, walk = 29546, turnLeft = 29546, turnRight = 29546, walkTurnLeft = 29546, walkTurnRight = 29546 },  -- ELR2_SIREN_GENERIC_FEMALE1_IDLE
    [3897] = { stand = 29556 },  -- HW16_DOC_IDLE
    [3898] = { stand = 18019, walk = 29567 },  -- COMBAT_2012_CASUAL_UNARMED_IDLE
    [3899] = { stand = 29565, walk = 29561, crawl = 29560, crawlBack = 29560, run = 29562, runBack = 29562, turnLeft = 29565, turnRight = 29565, walkBack = 29561, walkLeft = 29565, walkRight = 29565, walkTurnLeft = 29565, walkTurnRight = 29565 },  -- HW16_PLAYER_ON_FURNACE_BIKE_IDLE
    [3900] = { stand = 24063, walk = 29573, run = 29576, runBack = 29577, walkBack = 29574, walkLeft = 29575, walkRight = 29575, walkTurnLeft = 29575, walkTurnRight = 29575 },  -- SB_SPIDER_MINION_READY
    [3901] = { stand = 29571 },  -- HW16_FENKENBRAINS_MONSTER_IDLE
    [3902] = { stand = 29587 },  -- HW16_FENKENBRAINS_MONSTER_DEFEATED_POSE
    [3903] = { stand = 29588, walk = 29595, run = 29589, runBack = 29593, turnLeft = 29595, turnRight = 29595, walkBack = 29594 },  -- TRH107_PLAYER_ZOMBIE_IDLE
    [3904] = { stand = 2150, walk = 21544, run = 21544 },  -- DWARF_MINECART_READY
    [3905] = { stand = 29609 },  -- FOTG2_PLAYER_RIDE_FURNACE_BIKE_FAST
    [3906] = { stand = 29610 },  -- FOTG2_PLAYER_RIDE_FURNACE_BIKE_FAST_NPC
    [3907] = { stand = 29623, walk = 29623 },  -- EVENT1_MANTICORE_BOSS_IDLE_VAR
    [3908] = { stand = 14442, walk = 14442 },  -- RAND_BOSS_DEMON_HELD_DOWN_READY
    [3909] = { stand = 29643, walk = 29643 },  -- DARK_BOSS_STORY_NPC_IDLE
    [3910] = { stand = 29644, walk = 29645, run = 29646, walkBack = 29645, walkLeft = 29645, walkRight = 29645, walkTurnLeft = 29645, walkTurnRight = 29645 },  -- DIVDND_PLAYER_CARRY_JAR_ELDER_IDLE
    [3911] = { stand = 29715, walk = 29715, run = 29708, turnLeft = 29710, turnRight = 29711, walkLeft = 29710, walkRight = 29711, walkTurnLeft = 29710, walkTurnRight = 29711 },  -- FOTG2_PLAYER_LAVA_WALK
    [3912] = { stand = 29708, walk = 29708, run = 29708, turnLeft = 29708, turnRight = 29708, walkLeft = 29708, walkRight = 29708, walkTurnLeft = 29708, walkTurnRight = 29708 },  -- FOTG2_PLAYER_LAVA_RUN
    [3913] = { stand = 29806 },  -- FOTG2_MAHJARRAT_KNEELING
    [3914] = { stand = 29819 },  -- FOTG2_MAHZAM_KNEELING
    [3915] = { stand = 25839 },  -- SLISKE2_HAZEEL_CHANNELING_TO_REVEAL_ORB
    [3916] = { stand = 29738 },  -- FOTG2_ZAROS_RITUAL_CHANNELLING
    [3917] = { stand = 29737 },  -- FOTG2_ZAMORAK_CHANNEL_ENERGY
    [3918] = { stand = 29823 },  -- FOTG2_ZEMOURGEAL_RESTRAINING_IDLE
    [3919] = { stand = 29658 },  -- FOTG2_CS2_ZAROS_COLLAPSE_IDLE
    [3920] = { stand = 29712, walk = 29722, run = 29723 },  -- FOTG2_MAHZAM_IDLE
    [3921] = { stand = 19565 },  -- GREATER_DEMON_2011_HELD_DOWN_READY
    [3922] = { stand = 29684 },  -- FOTG2_CS1_GUARDIAN_HITBYZAM
    [3923] = { stand = 29681 },  -- FOTG2_CS1_AZZ_HIT_BY_ZAM
    [3924] = { stand = 29682 },  -- FOTG2_CS1_MAHZAM_LEAP
    [3925] = { stand = 29683 },  -- FOTG2_CS1_MAHZAM_GRABBED_BY_ZAROS
    [3926] = { stand = 29712, walk = 29722, run = 29723 },  -- FOTG2_MAHZAM_IDLE
    [3927] = { stand = 11013, walk = 29706, run = 29723, turnLeft = 11013, turnRight = 11013, walkLeft = 29706, walkRight = 29706, walkTurnLeft = 29706, walkTurnRight = 29706 },  -- MAH5_MAHJARATT_READY
    [3928] = { walk = 29725, run = 29726, turnLeft = 29724, turnRight = 29724, walkTurnLeft = 29725, walkTurnRight = 29725, idles = { { 29724, 220 }, { 29731, 35 } } },
    [3929] = { stand = 29816 },  -- FOTG2_CHAR_LAYING_DOWN_IDLE
    [3930] = { stand = 29748 },  -- FOTG2_NIGHTMARE_SHADOW_CREEP_FORWARD
    [3931] = { stand = 29757 },  -- FOTG2_NIGHTMARE_SHADOW_CREEP_DIAGONAL
    [3932] = { walk = 18020, walkBack = 820, walkLeft = 821, walkRight = 822, idles = { { 18019, 2 }, { 29752, 3 } } },
    [3933] = { stand = 29753 },  -- FOTG2_ACCUSED_WHIMPER_2
    [3934] = { stand = 29755 },  -- FOTG2_ZAROS_GIANT_IDLE
    [3935] = { stand = 29768 },  -- FOTG2_MAH_CORE
    [3936] = { stand = 29769 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE1
    [3937] = { stand = 29770 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE2
    [3938] = { stand = 29771 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE3
    [3939] = { stand = 29772 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE4
    [3940] = { stand = 29773 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE5
    [3941] = { stand = 29774 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE6
    [3942] = { stand = 29775 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE7
    [3943] = { stand = 29776 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE8
    [3944] = { stand = 29777 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE9
    [3945] = { stand = 29778 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE10
    [3946] = { stand = 29779 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE11
    [3947] = { stand = 29780 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE12
    [3948] = { stand = 29781 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE13
    [3949] = { stand = 29782 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE14
    [3950] = { stand = 29783 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE15
    [3951] = { stand = 29784 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE16
    [3952] = { stand = 29785 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE17
    [3953] = { stand = 29786 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE18
    [3954] = { stand = 29787 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE19
    [3955] = { stand = 29788 },  -- FOTG2_NIGHTMARE_CREATURE_STATUE20
    [3956] = { stand = 29852, walk = 29853, run = 29854 },  -- XMAS_2016_PUPPET_PET_IDLE
    [3957] = { stand = 29868 },  -- QUEST_ENDGAME_SARADOMIN_SIT_IDLE
    [3958] = { walk = 29877, run = 29878, turnLeft = 29877, turnRight = 29877, idles = { { 29879, 190 }, { 29880, 65 } } },
    [3959] = { stand = 23105, walk = 29891, turnLeft = 29891, turnRight = 29891 },  -- TPR_SARADOMIN_IDLE
    [3960] = { stand = 23134, walk = 29895, run = 29951, turnLeft = 29895, turnRight = 29895 },  -- TPR_ARMADYL_GOD_SMALL_IDLE
    [3961] = { stand = 29957, walk = 29900, turnLeft = 29900, turnRight = 29900 },  -- QUEST_ENDGAME_MARIMBO_IDLE_NO_WALK_BLEND
    [3962] = { stand = 29916 },  -- QUEST_ENDGAME_JAS_IDLE
    [3963] = { stand = 29959 },  -- QUEST_ENDGAME_JAS_CLOSED_IDLE
    [3964] = { stand = 29935 },  -- QUEST_ENDGAME_SLISKE_READY_INJURED
    [3965] = { walk = 29937, turnLeft = 29937, turnRight = 29937, idles = { { 29936, 70 }, { 29941, 30 } } },
    [3966] = { stand = 37633, walk = 37661, run = 37662, turnLeft = 37661, turnRight = 37661 },  -- HUMAN_ACTOR_COMBAT_ARMED_MAUL_IDLE
    [3967] = { stand = 30015, walk = 30016, run = 30016 },  -- HOG_PET_BUTTERFLY_IDLE
    [3968] = { stand = 19850 },  -- TSD_GUTHIX_HUMANOID_IDLE_DYING
    [3969] = { stand = 30029 },  -- HOG_ELDER_SWORD_ECHO_IDLE
    [3970] = { stand = 793 },  -- FAIRYKIT_FAIRY_READY
    [3971] = { stand = 3965 },  -- GNOME_STAFF_READY
    [3972] = { stand = 30032 },  -- HOG_WORLD_GATE_ECHO_IDLE
    [3973] = { stand = 30035 },  -- HOG_DRUID_ECHO_IDLE
    [3974] = { stand = 30030 },  -- HOG_STONE_OF_JAS_ECHO_IDLE
    [3975] = { stand = 3569 },  -- THE_THING_READY
    [3976] = { stand = 18038 },  -- COMBAT_2012_CASUAL_UNARMED_IDLE_FEMALE
    [3977] = { stand = 30031 },  -- HOG_EDICTS_SWORD_ECHO_IDLE
    [3978] = { stand = 30026 },  -- HOG_JUNA_ECHO_IDLE
    [3979] = { stand = 10665 },  -- LUC2_EOB_WATER_READY
    [3980] = { stand = 30027 },  -- HOG_FIARA_ECHO_IDLE
    [3981] = { stand = 30028 },  -- HOG_VALLUTA_ECHO_IDLE
    [3982] = { stand = 30038 },  -- EVENT2_PLAYER_PIRATE_IDLE
    [3983] = { stand = 30040 },  -- EVENT2_PLAYER_PIRATE_ZOMBIE_IDLE
    [3984] = { stand = 30046, walk = 30047, run = 30048, turnLeft = 30047, turnRight = 30047 },  -- MTX111_PIRATE_CANNON_PET_IDLE
    [3985] = { stand = 30065, walk = 30066, run = 30067, turnLeft = 30066, turnRight = 30066, walkLeft = 30066, walkRight = 30066, walkTurnLeft = 30066, walkTurnRight = 30066 },  -- MTX104_BABY_GORILLA_IDLE
    [3986] = { stand = 30077, walk = 30078, run = 30080, turnLeft = 30078, turnRight = 30078, walkLeft = 30078, walkRight = 30078, walkTurnLeft = 30078, walkTurnRight = 30078 },  -- MTX104_JUVENILE_GORILLA_IDLE
    [3987] = { stand = 30098, walk = 30100, run = 30102, turnLeft = 30100, turnRight = 30100, walkBack = 30100, walkTurnLeft = 30100, walkTurnRight = 30100 },  -- MTX104_PET_GORILLA_ADULT_IDLE
    [3988] = { stand = 30077, walk = 30079, run = 30081, turnLeft = 30079, turnRight = 30079, walkLeft = 30079, walkRight = 30079, walkTurnLeft = 30079, walkTurnRight = 30079 },  -- MTX104_JUVENILE_GORILLA_IDLE
    [3989] = { stand = 30099, walk = 30101, run = 30103, turnLeft = 30101, turnRight = 30101, walkBack = 30101, walkTurnLeft = 30101, walkTurnRight = 30101 },  -- MTX104_PET_SHADOWGORILLA_ADULT_IDLE
    [3990] = { stand = 30179, walk = 30180, run = 30181, turnLeft = 30180, turnRight = 30180 },  -- TRH116_VALENTINES17_PLAYER_FLOWERS_IDLE
    [3991] = { stand = 30175, walk = 30176, run = 30178, turnLeft = 30176, turnRight = 30176 },  -- TRH116_VALENTINES17_SPRITE_IDLE
    [3992] = { stand = 30174, walk = 30162, run = 30163, turnLeft = 30162, turnRight = 30162 },  -- TRH116_VALENTINES17_PLAYER_IDLE
    [3993] = { stand = 30266, walk = 30268, turnLeft = 30268, turnRight = 30268, walkTurnLeft = 30268, walkTurnRight = 30268 },  -- WARGUILD_2017_UPDATE_CYCLOPS_IDLE
    [3994] = { stand = 23105, walk = 29891, run = 18021, turnLeft = 29891, turnRight = 29891 },  -- TPR_SARADOMIN_IDLE
    [3995] = { stand = 5668, walk = 30293 },  -- PENG_GENTOO_READY
    [3996] = { stand = 26169 },  -- Q200_CITIZEN_ZOMBIE_INSANE_B_IDLE
    [3997] = { stand = 25767 },  -- SLISKE2_MOIA_IDLE
    [3998] = { stand = 24213, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- QUEST_ELF_FINALE_LORD_CADARN_IDLE
    [3999] = { stand = 24214, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- QUEST_ELF_FINALE_LADY_ITHELL_IDLE
    [4000] = { stand = 30309, walk = 168, run = 4626 },  -- IMP_READY_ENERGETIC
    [4001] = { stand = 30314 },  -- TRH117_FAIR_HOST_IDLE
    [4002] = { stand = 30365, walk = 30366, run = 30367 },  -- MTXFAIR17_ZOLTAN_STALL_PET_IDLE
    [4003] = { stand = 30377, walk = 819 },  -- MTXFAIR17_PLAYER_REST_LOOP
    [4004] = { stand = 30597, turnLeft = 30597, turnRight = 30597 },  -- SWORLDS_ENTRANCE_NPC_IDLE
    [4005] = { stand = 30599, walk = 30598, turnLeft = 30599, turnRight = 30599, walkBack = 30598, walkLeft = 30598, walkRight = 30598, walkTurnLeft = 30598, walkTurnRight = 30598 },  -- SWORLDS_ENTRANCE_SOLDIER_IDLE
    [4006] = { stand = 22280, walk = 30618, run = 22282, runBack = 22282, turnLeft = 30618, turnRight = 30618, walkBack = 30618, walkLeft = 30618, walkRight = 30618 },  -- _6AWE2_BANDOS_GOLEM_IDLE
    [4007] = { stand = 17975, walk = 30600, run = 30600, turnLeft = 30600, turnRight = 30600 },  -- COMBAT_2012_COMBAT_TWO_HANDED_MAUL_READY
    [4008] = { stand = 22371, walk = 30601, run = 22374, runBack = 22374, turnLeft = 22372, turnRight = 22372, walkBack = 30601, walkLeft = 22372, walkRight = 22372 },  -- _6AWE2_ARMADYL_GOLEM_IDLE
    [4009] = { stand = 14444 },  -- RAND_DEMON_HELD_DOWN_SPOTANIM
    [4010] = { stand = 30465, walk = 30465, run = 30465, walkBack = 30465 },  -- SWORLDS_ANIMA_PET_RANK_1_IDLE
    [4011] = { stand = 30473, walk = 30474, run = 30475, walkBack = 30474, walkLeft = 30474, walkRight = 30474, walkTurnLeft = 30474, walkTurnRight = 30474 },  -- SWORLDS_ANIMA_PET_RANK_2_IDLE
    [4012] = { stand = 30482, walk = 30483, run = 30484, walkBack = 30483, walkLeft = 30483, walkRight = 30483, walkTurnLeft = 30483, walkTurnRight = 30483 },  -- SWORLDS_ANIMA_PET_RANK_3_IDLE
    [4013] = { stand = 30491, walk = 30492, run = 30493, walkBack = 30492, walkLeft = 30492, walkRight = 30492, walkTurnLeft = 30492, walkTurnRight = 30492 },  -- SWORLDS_ANIMA_PET_RANK_4_IDLE
    [4014] = { stand = 30499, walk = 30506, run = 30500, walkBack = 30505, walkLeft = 30506, walkRight = 30506, walkTurnLeft = 30506, walkTurnRight = 30506 },  -- SWORLDS_ANIMA_PET_RANK_5_IDLE
    [4015] = { stand = 30509, walk = 30516, run = 30510, walkBack = 30515, walkLeft = 30516, walkRight = 30516, walkTurnLeft = 30516, walkTurnRight = 30516 },  -- SWORLDS_ANIMA_PET_RANK_6_IDLE
    [4016] = { stand = 30519, walk = 30526, run = 30520, walkBack = 30525, walkLeft = 30526, walkRight = 30526, walkTurnLeft = 30526, walkTurnRight = 30526 },  -- SWORLDS_ANIMA_PET_RANK_7_IDLE
    [4017] = { stand = 30529, walk = 30530, run = 30531, walkBack = 30537, walkLeft = 30530, walkRight = 30530, walkTurnLeft = 30530, walkTurnRight = 30530 },  -- SWORLDS_ANIMA_PET_RANK_8_IDLE
    [4018] = { stand = 30539, walk = 30545, run = 30540, walkBack = 30544, walkLeft = 30545, walkRight = 30545, walkTurnLeft = 30545, walkTurnRight = 30545 },  -- SWORLDS_ANIMA_PET_RANK_9_IDLE
    [4019] = { stand = 30610, walk = 30608, run = 30609, walkTurnLeft = 30615, walkTurnRight = 30615 },  -- SWORLDS_WOLF_PET_READY
    [4020] = { stand = 30621, walk = 30622, run = 30623, runBack = 30625, turnLeft = 30622, turnRight = 30622, walkBack = 30624 },  -- TRH119_PLAYER_TREASURE_MAP_IDLE
    [4021] = { stand = 30620 },  -- TRH116_VALENTINES17_PLAYER_REST_LOOP
    [4022] = { stand = 30634 },  -- TRH119_PLAYER_TREASURE_MAP_REST_LOOP
    [4023] = { stand = 30620 },  -- TRH116_VALENTINES17_PLAYER_REST_LOOP
    [4024] = { stand = 30637, walk = 30638 },  -- MENAPHOS_CROC_IDLE
    [4025] = { idles = { { 30781, 100 } } },
    [4026] = { idles = { { 30779, 100 } } },
    [4027] = { idles = { { 30777, 100 } } },
    [4028] = { idles = { { 30783, 100 } } },
    [4029] = { walk = 30654, run = 30658, turnLeft = 30654, turnRight = 30654, walkBack = 30654, walkTurnLeft = 30654, walkTurnRight = 30654, idles = { { 30646, 90 }, { 30650, 10 } } },
    [4030] = { walk = 30655, run = 30659, turnLeft = 30655, turnRight = 30655, walkBack = 30655, walkTurnLeft = 30655, walkTurnRight = 30655, idles = { { 30647, 70 }, { 30651, 30 } } },
    [4031] = { walk = 30656, run = 30660, turnLeft = 30656, turnRight = 30656, walkBack = 30656, walkTurnLeft = 30656, walkTurnRight = 30656, idles = { { 30648, 90 }, { 30652, 10 } } },
    [4032] = { walk = 30657, run = 30661, turnLeft = 30657, turnRight = 30657, walkBack = 30657, walkTurnLeft = 30657, walkTurnRight = 30657, idles = { { 30649, 90 }, { 30653, 10 } } },
    [4033] = { stand = 30643, walk = 30670, turnLeft = 30670, turnRight = 30670, walkBack = 30670, walkTurnLeft = 30670, walkTurnRight = 30670 },  -- MENAPHOS_JACKAL_IDLE
    [4034] = { stand = 30772, walk = 30773, turnLeft = 30773, turnRight = 30773, walkBack = 30773, walkTurnLeft = 30773, walkTurnRight = 30773 },  -- MENAPHOS_LOCUST_IDLE
    [4035] = { stand = 30643, walk = 30764, turnLeft = 30764, turnRight = 30764, walkBack = 30764, walkTurnLeft = 30764, walkTurnRight = 30764 },  -- MENAPHOS_JACKAL_IDLE
    [4036] = { stand = 30676, walk = 30676, run = 30676, turnLeft = 30676, turnRight = 30676, walkBack = 30676, walkTurnLeft = 30676, walkTurnRight = 30676 },  -- MENAPHOS_PLAYER_ON_CARPET_IDLE
    [4037] = { stand = 30692, walk = 30692, run = 30692, turnLeft = 30692, turnRight = 30692, walkBack = 30692, walkTurnLeft = 30692, walkTurnRight = 30692 },  -- MENAPHOS_HASSAN_MAGIC_CARPET_IDLE
    [4038] = { stand = 30680, walk = 30686, turnLeft = 30686, turnRight = 30686, walkBack = 30686, walkTurnLeft = 30686, walkTurnRight = 30686 },  -- MENAPHOS_WORKERS_IDLE
    [4039] = { stand = 30682, walk = 30687, turnLeft = 30687, turnRight = 30687, walkBack = 30687, walkTurnLeft = 30687, walkTurnRight = 30687 },  -- MENAPHOS_IMPERIAL_IDLE
    [4040] = { stand = 30683, walk = 30693, turnLeft = 30693, turnRight = 30693, walkBack = 30693, walkTurnLeft = 30693, walkTurnRight = 30693 },  -- MENAPHOS_PORTS_IDLE
    [4041] = { stand = 30685, walk = 30694, turnLeft = 30694, turnRight = 30694, walkBack = 30694, walkTurnLeft = 30694, walkTurnRight = 30694 },  -- MENAPHOS_MERCHANTS_IDLE
    [4042] = { stand = 30695, walk = 30696, turnLeft = 30696, turnRight = 30696, walkBack = 30696, walkTurnLeft = 30696, walkTurnRight = 30696 },  -- MENAPHOS_SCARAB_BEETLE_IDLE
    [4043] = { stand = 30695, walk = 30696, run = 30819, turnLeft = 30696, turnRight = 30696, walkBack = 30696, walkTurnLeft = 30696, walkTurnRight = 30696 },  -- MENAPHOS_SCARAB_BEETLE_IDLE
    [4044] = { stand = 30701 },  -- MENAPHOS_CRONDIS_IDLE
    [4045] = { stand = 30675, walk = 30675, run = 30675, turnLeft = 30675, turnRight = 30675, walkBack = 30675, walkTurnLeft = 30675, walkTurnRight = 30675 },  -- MENAPHOS_PLAYER_ON_CARPET_IDLE_SPOTANIM
    [4046] = { stand = 30705, walk = 30706, turnLeft = 30706, turnRight = 30706, walkBack = 30706, walkTurnLeft = 30706, walkTurnRight = 30706 },  -- MENAPHOS_GIANT_LIZARD_IDLE
    [4047] = { stand = 30713, walk = 30714, turnLeft = 30714, turnRight = 30714, walkBack = 30714, walkTurnLeft = 30714, walkTurnRight = 30714 },  -- MENAPHOS_PHARAOH_IDLE
    [4048] = { stand = 30810 },  -- MENAPHOS_PHARAOH_DEFEATED_LOOP
    [4049] = { stand = 30765 },  -- MENAPHOS_PHARAOH_DEATH_POSE
    [4050] = { stand = 30712 },  -- MENAPHOS_PHARAOH_THRONE_IDLE
    [4051] = { stand = 30711 },  -- MENAPHOS_KING_OSMAN_IDLE
    [4052] = { stand = 30766, walk = 30767, turnLeft = 30767, turnRight = 30767, walkBack = 30767, walkTurnLeft = 30767, walkTurnRight = 30767 },  -- MENAPHOS_OSMAN_KNIFE_IDLE
    [4053] = { stand = 30785, walk = 30786, turnLeft = 30786, turnRight = 30786, walkBack = 30786, walkTurnLeft = 30786, walkTurnRight = 30786 },  -- MENAPHOS_OREB_IDLE
    [4054] = { stand = 23408 },  -- ASH1_2014_LUCY_SITTING_IDLE
    [4055] = { stand = 7057 },  -- CLAN_SITTING_READY
    [4056] = { stand = 12500 },  -- CLAN_EMOTE_SITTING_CHEERING
    [4057] = { stand = 12509 },  -- CLAN_EMOTE_SITTING_WHISTLE
    [4058] = { stand = 15836 },  -- OMGE_BUILDER_SITTING
    [4059] = { stand = 22050 },  -- TUT5_DIGORY_IDLE
    [4060] = { stand = 22060 },  -- TUT5_SARAH_IDLE
    [4061] = { stand = 19182 },  -- POP_PLAYER_SITTING_READY
    [4062] = { stand = 22068 },  -- TUT5_SARAH_LOOP
    [4063] = { stand = 22069 },  -- TUT5_SARAH_END
    [4064] = { stand = 22426 },  -- TUT5_VILLAGER_MALE_6_IDLE_VAR
    [4065] = { stand = 22146 },  -- TUT5_VILLAGER_MALE_ARGUING
    [4066] = { stand = 22147 },  -- TUT5_VILLAGER_FEMALE_ARGUING
    [4067] = { stand = 19125 },  -- POP_CAPTAIN_IDLE_VAR_A
    [4068] = { stand = 19126 },  -- POP_CAPTAIN_IDLE_VAR_B
    [4069] = { stand = 19127 },  -- POP_CAPTAIN_IDLE_VAR_C
    [4070] = { stand = 22061 },  -- TUT5_OLD_SEA_DOG_IDLE
    [4071] = { stand = 22062 },  -- TUT5_OLD_SEA_DOG_LOOP
    [4072] = { stand = 29117 },  -- ELR1_PLAYER_PROUD_IDLE
    [4073] = { stand = 23780 },  -- HUMAN_2013_SHOPKEEPER_IDLE
    [4074] = { stand = 23790 },  -- HUMAN_2013_SHOP_OWNER_MALE_IDLE
    [4075] = { stand = 22110 },  -- TUT5_VILLAGER_MALE_5_CHEER
    [4076] = { stand = 28747, walk = 28748 },  -- QUEST_SISTER_MARIMBO_DRUNK_IDLE
    [4077] = { stand = 28749 },  -- QUEST_SISTER_MARIMBO_VOMIT
    [4078] = { stand = 22765 },  -- PLAYER_2014_POH_BUILD_FLOOR_SC_REWARD_HAMMER
    [4079] = { stand = 22768 },  -- PLAYER_2014_POH_BUILD_WALL
    [4080] = { stand = 7159 },  -- CLAN_EMOTE_DANCING
    [4081] = { stand = 15399 },  -- OPN_PLAYER_FEMALE_DANCE
    [4082] = { stand = 21847 },  -- MTX44_PLAYER_EGYPTIAN_DANCE_EMOTE
    [4083] = { stand = 30644, walk = 30768, turnLeft = 30768, turnRight = 30768, walkBack = 30768, walkTurnLeft = 30768, walkTurnRight = 30768 },  -- MENAPHOS_VULTURE_IDLE
    [4084] = { stand = 30839, walk = 30837, run = 30838, runBack = 30838, turnLeft = 30837, turnRight = 30837, walkBack = 30837, walkTurnLeft = 30837, walkTurnRight = 30837 },  -- MENAPHOS_PLAYER_ON_CARPET_IDLE_OVERRIDE
    [4085] = { stand = 30817 },  -- MENAPHOS_JABARI_STATUE_POSE
    [4086] = { stand = 30828 },  -- MENAPHOS_CAMELTAUR_GUIDE_IDLE
    [4087] = { stand = 30846 },  -- HET_COMBAT_2012_COMBAT_UNARMED_READY_STATUE
    [4088] = { stand = 88, walk = 88, run = 88, turnLeft = 88, turnRight = 88 },  -- ADVISOR_AL_KHARID_GUARD_OPEN
    [4089] = { walk = 30848, run = 20973, turnLeft = 30848, turnRight = 30848, idles = { { 18023, 80 }, { 37968, 20 } } },
    [4090] = { stand = 30861, walk = 30905, run = 30905, runBack = 30905, turnLeft = 30905, turnRight = 30905, walkBack = 30905, walkTurnLeft = 30905, walkTurnRight = 30905 },  -- MENAPHOS_SPHINX_IDLE
    [4091] = { stand = 30862 },  -- MENAPHOS_NPC_SITTING_BY_STEPS
    [4092] = { stand = 30876, crawl = 30875, crawlBack = 30879 },  -- TRH122_PURPLES_SLINKY_PET_IDLE
    [4093] = { stand = 30880, walk = 30881, run = 30882, turnLeft = 30881, turnRight = 30881 },  -- TRH122_PURPLES_PERISCOPE_PLAYER_IDLE
    [4094] = { stand = 30892, walk = 30893, run = 30894, turnLeft = 30893, turnRight = 30893 },  -- TRH122_PURPLES_BALOONS_IDLE
    [4095] = { stand = 30883, walk = 30884, run = 30885, turnRight = 30884 },  -- TRH122_PURPLES_FAN_PLAYER_IDLE
    [4096] = { stand = 30889, walk = 30890, run = 30891, turnLeft = 30890, turnRight = 30890 },  -- TRH122_PURPLES_GLOWWORM_JAR_PLAYER_IDLE
    [4097] = { stand = 30886, walk = 30887, run = 30888, turnRight = 30887 },  -- TRH122_PURPLES_BAD_WEATHER_UMBRELLA_PLAYER_IDLE
    [4098] = { stand = 30900 },  -- TRH122_PURPLES_BALLOON_REST_LOOP
    [4099] = { stand = 30841 },  -- MENAPHOS_PLAYER_ON_CARPET_REST_LOOP
    [4100] = { stand = 30928, walk = 30927, run = 30927 },  -- GROWTH_TWITCH_PET_NPC_IDLE
    [4101] = { stand = 30934 },  -- GROWTH_TWITCH_PET_NPC_WATCHING
    [4102] = { stand = 30938, crawl = 30938 },  -- TRH123_SANDERING_RIFTS_RIFT_IDLE
    [4103] = { stand = 30989, walk = 30990, run = 30991, runBack = 30993, walkBack = 30992 },  -- MTXBEACH17_SANDCASTLE_PET_IDLE
    [4104] = { stand = 31000, walk = 31007, run = 31008, runBack = 31008, walkBack = 31007 },  -- MTXBEACH17_OCTOPUS_IDLE
    [4105] = { stand = 31004, walk = 31005, run = 31006, runBack = 31019, turnLeft = 31005, turnRight = 31005, walkBack = 31018, walkLeft = 31005, walkRight = 31005, walkTurnLeft = 31005, walkTurnRight = 31005 },  -- MTXBEACH17_PLAYER_BUBBLE_PIPE_IDLE
    [4106] = { stand = 31012, walk = 31013, run = 31014, turnLeft = 31013, turnRight = 31013 },  -- MTXBEACH17_PLAYER_BUBBLE_PIPE_COMBAT_IDLE
    [4107] = { stand = 31027, walk = 819 },  -- MTXBEACH17_PLAYER_HAMMOCK_REST_CYCLE
    [4108] = { walk = 31003, run = 31003, turnLeft = 31003, turnRight = 31003, idles = { { 31031, 90 }, { 37977, 10 } } },
    [4109] = { stand = 31035, walk = 31036, run = 31037, runBack = 31037, runLeft = 31037, runRight = 31037, turnLeft = 31035, turnRight = 31035, walkBack = 31036, runTurnLeft = 31037, runTurnRight = 31037, walkTurnLeft = 31036, walkTurnRight = 31036 },  -- MAW_DRAGONKIN_PET_IDLE
    [4110] = { stand = 31045 },  -- WITCHESHOUSE_BOY_CRYING_IDLE
    [4111] = { stand = 31046 },  -- WITCHESHOUSE_BOY_WITH_BALL_IDLE
    [4112] = { stand = 31047, walk = 2703 },  -- WITCHESHOUSE_MOUSE_READY
    [4113] = { walk = 31048, idles = { { 3824, 80 }, { 3817, 20 } } },
    [4114] = { walk = 31056, run = 31058, turnLeft = 31056, turnRight = 31056, walkLeft = 31056, walkRight = 31056, idles = { { 31057, 80 }, { 37975, 20 } } },
    [4115] = { stand = 31077 },  -- NATURE_BEINGS_FAIRY_TOADSTOOL_IDLE
    [4116] = { stand = 31081, walk = 31082, run = 31087, walkLeft = 31082, walkRight = 31082 },  -- NATURE_BEINGS_ROCKY_IDLE
    [4117] = { stand = 31093 },  -- NATURE_BEINGS_ROCKY_SPECIAL_ATTACK_HEAD_LANDED
    [4118] = { stand = 31096, walk = 31095, run = 31099, walkLeft = 31095, walkRight = 31095 },  -- NATURE_BEINGS_MAGIC_MUSHY_IDLE
    [4119] = { stand = 31105, walk = 31106, run = 31106, walkLeft = 31106, walkRight = 31106 },  -- NATURE_BEINGS_RANGED_LEAFY_IDLE
    [4120] = { stand = 31115, walk = 31115, turnLeft = 31115, turnRight = 31115, walkTurnLeft = 31115, walkTurnRight = 31115 },  -- NATURE_BEINGS_WISP_READY_WALK
    [4121] = { stand = 31081, walk = 31084, run = 31089, walkLeft = 31084, walkRight = 31084 },  -- NATURE_BEINGS_ROCKY_IDLE
    [4122] = { stand = 31081, walk = 31083, run = 31088, walkLeft = 31083, walkRight = 31083 },  -- NATURE_BEINGS_ROCKY_IDLE
    [4123] = { stand = 31146, walk = 31147, run = 31148, runBack = 31148, turnLeft = 31147, turnRight = 31147, walkBack = 31147 },  -- MTXFEST17_KEG_PET_IDLE
    [4124] = { stand = 31126, walk = 31125, run = 31154, runBack = 31154, turnLeft = 31125, turnRight = 31125, walkBack = 31125 },  -- MTXFEST17_PLAYER_DRUNK_IDLE
    [4125] = { stand = 31119 },  -- MTXFEST17_PLAYER_DANCE_TABLE_IDLE
    [4126] = { stand = 31126, walk = 31125, run = 31154, runBack = 31154, turnLeft = 31125, turnRight = 31125, walkBack = 31125 },  -- MTXFEST17_PLAYER_DRUNK_IDLE
    [4127] = { stand = 31158, walk = 31159, run = 31160, runBack = 31158, turnLeft = 31159, turnRight = 31159, walkBack = 31159 },  -- MTXFEST17_PLAYER_STIEN_IDLE
    [4128] = { stand = 31161 },  -- MTXFEST17_PLAYER_MULTIPLE_STIEN_REST
    [4129] = { stand = 31165 },  -- MTXFEST17_HOST_IDLE
    [4130] = { stand = 31132, walk = 31133, run = 31134, runBack = 31134, turnLeft = 31133, turnRight = 31133, walkBack = 31133 },  -- MTX17FEST_PET_WOLPERTINGER_IDLE
    [4131] = { stand = 31172, crawl = 16895 },  -- MTXFEST17_UNICORNS_IDLE
    [4132] = { stand = 31176, walk = 31175, run = 31175 },  -- MTXFEST17_KEG_ROLL_IDLE
    [4133] = { stand = 31128, crawl = 31128 },  -- MTXFEST17_PLAYER_RIDE_CAROUSEL_HORSE
    [4134] = { stand = 31128, walk = 31128 },  -- MTXFEST17_PLAYER_RIDE_CAROUSEL_HORSE
    [4135] = { stand = 31128, run = 31128 },  -- MTXFEST17_PLAYER_RIDE_CAROUSEL_HORSE
    [4136] = { stand = 31189 },  -- HW17_DEAD_POSE_A
    [4137] = { stand = 31190 },  -- HW17_DEAD_POSE_B
    [4138] = { stand = 31193 },  -- HW17_DEAD_POSE_C
    [4139] = { walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020, idles = { { 31191, 90 }, { 31192, 10 } } },
    [4140] = { stand = 31194, walk = 31195, run = 31196, runBack = 31196, walkBack = 31195, walkLeft = 31195, walkRight = 31195 },  -- EVENT9_CLOCKWORK_GNOME_READY
    [4141] = { walk = 24183, crawl = 24183, run = 24183, idles = { { 3824, 80 }, { 3817, 20 } } },
    [4142] = { stand = 31206, walk = 31207, run = 31208, turnLeft = 31207, turnRight = 31207, walkTurnLeft = 31207, walkTurnRight = 31207 },  -- SKILLPETS_2017_CONSTITUTION_MORTY_IDLE
    [4143] = { stand = 31255, walk = 31256, run = 31258, turnLeft = 31256, turnRight = 31256, walkTurnLeft = 31256, walkTurnRight = 31256 },  -- SKILLPETS_ATTACK_DRAGON_IDLE
    [4144] = { stand = 31215, walk = 31216, run = 31217, turnLeft = 31216, turnRight = 31216, walkTurnLeft = 31216, walkTurnRight = 31216 },  -- SKILLPETS_2017_DEFENCE_GRENWALL_IDLE
    [4145] = { stand = 31263, walk = 31264, run = 31265, turnLeft = 31264, turnRight = 31264, walkTurnLeft = 31264, walkTurnRight = 31264 },  -- COMBAT_SKILL_PET_MAGIC_NEWTON_IDLE
    [4146] = { stand = 31223, walk = 31224, run = 31225, turnLeft = 31224, turnRight = 31224, walkTurnLeft = 31224, walkTurnRight = 31224 },  -- SKILLPET_2017_KANGAROO_IDLE
    [4147] = { stand = 31231, walk = 31232, run = 31233, turnLeft = 31232, turnRight = 31232, walkTurnLeft = 31232, walkTurnRight = 31232 },  -- SKILLPET_2017_SUMMONING_SHAMINI_IDLE
    [4148] = { stand = 31239, walk = 31240, run = 31241, turnLeft = 31240, turnRight = 31240, walkTurnLeft = 31240, walkTurnRight = 31240 },  -- SKILLPET_2017_RANGED_SQUIRREL_IDLE
    [4149] = { stand = 31247, walk = 31248, run = 31249, turnLeft = 31248, turnRight = 31248, walkTurnLeft = 31248, walkTurnRight = 31248 },  -- SKILLPET_2017_PRAYER_GHOSTLY_IDLE
    [4150] = { stand = 31271, walk = 2703 },  -- HELLRAT_READY
    [4151] = { stand = 31272, walk = 31273, turnLeft = 31273, turnRight = 31273, walkTurnLeft = 31273, walkTurnRight = 31273 },  -- DAVE_BARREL_ROLL_IDLE
    [4152] = { stand = 31292, walk = 31293, run = 31294, turnLeft = 31293, turnRight = 31293 },  -- XMAS_2017_PLAYER_PRESENTS_STACK_IDLE
    [4153] = { stand = 31286, walk = 31295, run = 31296, runBack = 31296, turnLeft = 31295, turnRight = 31295, walkBack = 31295 },  -- TRH110_SNOWMAN_PET_IDLE
    [4154] = { stand = 31302, walk = 31312, walkLeft = 31312, walkRight = 31312 },  -- ZOMBIESCAPE_LARGE_BOSS_IDLE
    [4155] = { stand = 22317, walk = 17510, turnLeft = 17510, turnRight = 17510, walkTurnLeft = 17510, walkTurnRight = 17510 },  -- _6AWE2_BODYGUARD_BANDOS_OGRE_READY
    [4156] = { stand = 31318, walk = 31319, run = 31309, walkLeft = 31319, walkRight = 31319 },  -- ZOMBIESCAPE_LARGE_BOSS_PET_IDLE
    [4157] = { walk = 31327, run = 31328, turnLeft = 31327, turnRight = 31327, walkLeft = 31327, walkRight = 31327, walkTurnLeft = 31327, walkTurnRight = 31327, idles = { { 31333, 90 }, { 22002, 10 } } },
    [4158] = { stand = 7215, walk = 7215 },  -- CLAN_WELCOME_AREA_PORTAL_READY
    [4159] = { stand = 31343, walk = 31344, run = 31345, turnLeft = 31344, turnRight = 31344 },  -- TRH132_FACELESS_ASSASSIN_IDLE
    [4160] = { stand = 31349, walk = 31350, run = 31351, turnLeft = 31350, turnRight = 31350 },  -- TRH132_FACELESS_ASSASSIN_IDLE_2H_SWORD
    [4161] = { stand = 31346, walk = 31347, run = 31348, turnLeft = 31347, turnRight = 31347 },  -- TRH132_FACELESS_ASSASSIN_IDLE_BOW
    [4162] = { stand = 31352, walk = 31353, run = 31354, turnLeft = 31353, turnRight = 31353 },  -- TRH132_FACELESS_ASSASSIN_IDLE_STAFF
    [4163] = { stand = 31358, walk = 31359, run = 31360, turnLeft = 31359, turnRight = 31359 },  -- TRH132_FACELESS_ASSASSIN_IDLE_MAUL
    [4164] = { stand = 31355, walk = 31356, run = 31357, turnLeft = 31356, turnRight = 31356 },  -- TRH132_FACELESS_ASSASSIN_IDLE_2H_CROSSBOW
    [4165] = { stand = 31368, walk = 31369, run = 31370, runBack = 31370, walkBack = 31369, walkLeft = 31369, walkRight = 31369 },  -- EVENT10_CHINESE_LION_PET_IDLE
    [4166] = { stand = 31363, walk = 819 },  -- EVENT10_CHINESE_NY_TEA_REST
    [4167] = { stand = 31364, walk = 31365, run = 31378, turnLeft = 31365, turnRight = 31365, walkLeft = 31365, walkRight = 31365, walkTurnLeft = 31365, walkTurnRight = 31365 },  -- MTXFEB18_GAMEBLAST_PET_IDLE
    [4168] = { idles = { { 31389, 90 }, { 31390, 10 } } },
    [4169] = { stand = 31393, walk = 31391, run = 31392, runBack = 31392, walkBack = 31391 },  -- TRAIL17_PLAYER_UNICORN_STICK_IDLE
    [4170] = { stand = 31396, walk = 31394, run = 31395, runBack = 31395, walkBack = 31394 },  -- TRAIL17_PLAYER_HEAVY_CHEST_IDLE
    [4171] = { stand = 31397, walk = 31398, run = 31399, turnLeft = 31398, turnRight = 31398, walkBack = 31398, walkLeft = 31398, walkRight = 31398 },  -- TRAIL17_SHEEPDOG_PET_IDLE
    [4172] = { stand = 31435 },  -- DSF_MANTA_RAY_IDLE
    [4173] = { stand = 31450 },  -- DSF_TURTLE_IDLE
    [4174] = { stand = 31444 },  -- DSF_SHARK_IDLE
    [4175] = { stand = 31448 },  -- DSF_JELLYFISH_SWIM_VAR_A
    [4176] = { stand = 31471 },  -- DSF_JELLYFISH_LAND_IDLE
    [4177] = { stand = 31478 },  -- DSF_JELLYFISH_SWIM_IDLE_RAISED
    [4178] = { stand = 31437 },  -- DSF_NPC_DRUNK_CROWS_NEST_PLATFORM
    [4179] = { stand = 31475 },  -- DSF_MERCHANT_SHIP_IDLE
    [4180] = { stand = 31492 },  -- DSF_SAILFISH_ANCIENT_ONE_SWIM_A
    [4181] = { stand = 31493 },  -- DSF_SAILFISH_ANCIENT_ONE_SWIM_B
    [4182] = { idles = { { 31455, 90 }, { 31505, 10 } } },
    [4183] = { stand = 31456 },  -- DSF_NPC_TELESCOPE_IDLE_PLATFORM
    [4184] = { stand = 31458 },  -- DSF_1X1_FISHING_SPOT_FISH_CALM
    [4185] = { stand = 31459 },  -- DSF_1X1_FISHING_SPOT_FISH_MEDIUM
    [4186] = { stand = 31460 },  -- DSF_1X1_FISHING_SPOT_FISH_FRENZY
    [4187] = { stand = 31461 },  -- DSF_2X2_FISHING_SPOT_FISH_CALM
    [4188] = { stand = 31462 },  -- DSF_2X2_FISHING_SPOT_FISH_MEDIUM
    [4189] = { stand = 31463 },  -- DSF_2X2_FISHING_SPOT_FISH_FRENZY
    [4190] = { stand = 31465 },  -- DSF_DEADLY_DEVOURER_IDLE
    [4191] = { stand = 31464 },  -- DSF_WHALE_MOUTH_OPEN_IDLE
    [4192] = { stand = 31484 },  -- DSF_PLAYER_SIT_ON_PLATFORM_IDLE
    [4193] = { stand = 31504 },  -- DSF_FISHERMAN_FISHING_ROD_CAST
    [4194] = { stand = 22076 },  -- TUT5_SEAGULL_IDLE
    [4195] = { stand = 21745, walk = 28835, run = 29723, turnLeft = 21745, turnRight = 21745, walkLeft = 28835, walkRight = 28835, walkTurnLeft = 28835, walkTurnRight = 28835 },  -- SLISKE1_SLISKE_READY
    [4196] = { stand = 21756, walk = 28835, run = 29723, turnLeft = 21756, turnRight = 21756, walkLeft = 28835, walkRight = 28835, walkTurnLeft = 28835, walkTurnRight = 28835 },  -- SLISKE1_SLISKE_READY_THEATRICAL
    [4197] = { stand = 29935, walk = 28835, run = 29723, turnLeft = 29935, turnRight = 29935, walkLeft = 28835, walkRight = 28835, walkTurnLeft = 28835, walkTurnRight = 28835 },  -- QUEST_ENDGAME_SLISKE_READY_INJURED
    [4198] = { stand = 31511 },  -- QUEST_SISTER_SLISKE_SIPHON_PLAYER_SOUL_LOOP
    [4199] = { stand = 31574 },  -- QUEST_PIRATEFINALE_BARRELCHEST_IN_CRATE
    [4200] = { stand = 31528, walk = 31531, turnLeft = 31531, turnRight = 31531, walkBack = 31532, walkLeft = 31531, walkRight = 31531 },  -- PIRATE_UPDATE_2017_READY_AND_EXTRA
    [4201] = { stand = 31528, walk = 31529, turnLeft = 31529, turnRight = 31529, walkBack = 31530, walkLeft = 31529, walkRight = 31529 },  -- PIRATE_UPDATE_2017_READY_AND_EXTRA
    [4202] = { stand = 31542, walk = 31543, turnLeft = 31543, turnRight = 31543 },  -- QUEST_PIRATEFINALE_RABIDJACK_IDLE
    [4203] = { stand = 31557, walk = 31558, turnLeft = 31558, turnRight = 31558 },  -- QUEST_PIRATEFINALE_MIGOR_IDLE
    [4204] = { stand = 31559, walk = 31560, turnLeft = 31560, turnRight = 31560 },  -- QUEST_PIRATEFINALE_MADAME_SHIH_IDLE
    [4205] = { stand = 31563, walk = 31564, turnLeft = 31564, turnRight = 31564 },  -- QUEST_PIRATEFINALE_BILL_TEACH_IDLE
    [4206] = { stand = 31565, walk = 31566, turnLeft = 31566, turnRight = 31566 },  -- QUEST_PIRATEFINALE_BARRELCHEST_IDLE
    [4207] = { stand = 31615 },  -- QUEST_PIRATEFINALE_HANDOFXAUTAK_IDLE
    [4208] = { stand = 31619, walk = 31620, turnLeft = 31620, turnRight = 31620 },  -- QUEST_PIRATEFINALE_BRASSHANDHARRY_IDLE
    [4209] = { stand = 31618 },  -- QUEST_PIRATEFINALE_ZOMBIEHEAD_IDLE
    [4210] = { stand = 21994 },  -- EMOTE_2013_PANIC
    [4211] = { stand = 31592 },  -- QUEST_PIRATEFINALE_HUMAN_TENTACLE_RIGHT_A_HOLDING_PIRATE
    [4212] = { stand = 31624 },  -- QUEST_PIRATEFINALE_HUMAN_TENTACLE_RIGHT_B_HOLDING_PIRATE
    [4213] = { stand = 31584 },  -- QUEST_PIRATEFINALE_HUMAN_TENTACLE_LEFT_A_HOLDING_PIRATE
    [4214] = { stand = 31588 },  -- QUEST_PIRATEFINALE_HUMAN_TENTACLE_LEFT_B_HOLDING_PIRATE
    [4215] = { stand = 31591 },  -- QUEST_PIRATEFINALE_AGOROTH_BOSS_TENTACLE_RIGHT_A_HOLDING_PIRATE
    [4216] = { stand = 31595 },  -- QUEST_PIRATEFINALE_AGOROTH_BOSS_TENTACLE_RIGHT_B_HOLDING_PIRATE
    [4217] = { stand = 31583 },  -- QUEST_PIRATEFINALE_AGOROTH_BOSS_TENTACLE_LEFT_A_HOLDING_PIRATE
    [4218] = { stand = 31587 },  -- QUEST_PIRATEFINALE_AGOROTH_BOSS_TENTACLE_LEFT_B_HOLDING_PIRATE
    [4219] = { stand = 31626 },  -- QUEST_PIRATEFINALE_MADAME_SHIH_BEING_HELD_LOOP
    [4220] = { stand = 31628, walk = 31629, run = 31630, turnLeft = 31629, turnRight = 31629 },  -- MTXFAIR18_PLAYER_FISHBAG_IDLE
    [4221] = { stand = 31634, walk = 31635, run = 31636, runBack = 31636, turnLeft = 31635, turnRight = 31635, walkBack = 31635 },  -- MTXFAIR18_PLAYER_DIZZY_STICK_IDLE
    [4222] = { stand = 31637, walk = 31638, run = 31639, runBack = 31639, walkBack = 31638 },  -- MTXFAIR18_EGGPET_IDLE
    [4223] = { stand = 31651, walk = 31651, run = 31652 },  -- EFFIGY_PET_IDLE
    [4224] = { stand = 31655, walk = 31658, run = 31657, turnLeft = 31658, turnRight = 31658, walkLeft = 31658, walkRight = 31658, walkTurnLeft = 31658, walkTurnRight = 31658 },  -- TRH140_TIKI_PET_IDLE
    [4225] = { stand = 31678, walk = 31679, run = 31680 },  -- GRAAHK_IDLE
    [4226] = { stand = 4073 },  -- CHAIR_SIT_READY_CHAIR1
    [4227] = { stand = 31705, walk = 31706, run = 31707, runBack = 31707, turnLeft = 31706, turnRight = 31706, walkBack = 31706 },  -- MTXMAY18_MHAW_PET_IDLE_ARMOURED
    [4228] = { stand = 31704, walk = 31706, run = 31707, runBack = 31707, turnLeft = 31706, turnRight = 31706, walkBack = 31706 },  -- MTXMAY18_MHAW_PET_IDLE
    [4229] = { stand = 31722 },  -- MTXRCB_PLAYER_CHERRY_BLOSSOM_REST
    [4230] = { stand = 31717, walk = 31718, run = 31719, turnLeft = 31718, turnRight = 31718 },  -- MTXMAY18_DARUMA_PET_IDLE
    [4231] = { stand = 31732, walk = 31733, run = 31734, turnLeft = 31733, turnRight = 31733 },  -- MTXRCB_PLAYER_LANTERN_IDLE
    [4232] = { stand = 31737, walk = 31739, run = 31739, turnLeft = 31738, turnRight = 31738, walkTurnLeft = 31738, walkTurnRight = 31738 },  -- NATURE_BOSS_SOLAK_IDLE
    [4233] = { stand = 31741, walk = 31740, run = 31742, turnLeft = 31740, turnRight = 31740, walkTurnLeft = 31740, walkTurnRight = 31740 },  -- NATURE_BOSS_MERETHIEL_IDLE
    [4234] = { stand = 31744, walk = 31740, run = 31742, turnLeft = 31740, turnRight = 31740, walkTurnLeft = 31740, walkTurnRight = 31740 },  -- NATURE_BOSS_MERETHIEL_IDLE_STAFF
    [4235] = { stand = 31743, walk = 31743 },  -- NATURE_BOSS_SOLAK_DEATH_LOOP
    [4236] = { stand = 31746 },  -- NATURE_BOSS_PLAYER_SUMMON_SHIELD_LOOP
    [4237] = { stand = 31749 },  -- NATURE_BOSS_ROOTS_SPAWN_IDLE
    [4238] = { stand = 31759 },  -- NATURE_BOSS_ORB_GOOD_IN_AIR_IDLE
    [4239] = { stand = 31768 },  -- NATURE_BOSS_SOLAK_IN_PAIN_IDLE
    [4240] = { stand = 31774 },  -- NATURE_BOSS_SOLAK_LOCKDOWN_WITH_MERETHIEL
    [4241] = { stand = 31781 },  -- NATURE_BOSS_SOLAK_CORE_IDLE
    [4242] = { stand = 31793, walk = 31793 },  -- NATURE_BOSS_MAZE_BEAM_SPOTANIM
    [4243] = { stand = 31803, walk = 31804, run = 31805, turnLeft = 31804, turnRight = 31804, walkTurnLeft = 31804, walkTurnRight = 31804 },  -- NATURE_BOSS_PET_SOLAK_IDLE
    [4244] = { stand = 31780, walk = 31864, run = 31865, turnLeft = 31864, turnRight = 31864, walkLeft = 31864, walkRight = 31864, walkTurnLeft = 31864, walkTurnRight = 31864 },  -- MTX116_JOKER_IDLE
    [4245] = { walk = 34064, run = 34065, walkLeft = 34064, walkRight = 34064, idles = { { 34063, 191 }, { 34163, 64 } } },
    [4246] = { stand = 31870, walk = 31875, run = 31880, turnLeft = 31875, turnRight = 31875, walkLeft = 31875, walkRight = 31875, walkTurnLeft = 31875, walkTurnRight = 31875 },  -- MTX116_JOKER_IDLE_2H_SWORD
    [4247] = { stand = 31871, walk = 31876, run = 31881, turnLeft = 31876, turnRight = 31876, walkLeft = 31876, walkRight = 31876, walkTurnLeft = 31876, walkTurnRight = 31876 },  -- MTX116_JOKER_IDLE_STAFF
    [4248] = { stand = 34039, walk = 34040, run = 34041, walkLeft = 34040, walkRight = 34040 },  -- TROLL_2021_IDLE
    [4249] = { stand = 31872, walk = 31877, run = 31882, turnLeft = 31877, turnRight = 31877, walkLeft = 31877, walkRight = 31877, walkTurnLeft = 31877, walkTurnRight = 31877 },  -- MTX116_JOKER_IDLE_2H_CROSSBOW
    [4250] = { stand = 31873, walk = 31878, run = 31883, turnLeft = 31878, turnRight = 31878, walkLeft = 31878, walkRight = 31878, walkTurnLeft = 31878, walkTurnRight = 31878 },  -- MTX116_JOKER_IDLE_2H_MAUL
    [4251] = { stand = 31874, walk = 31879, run = 31884, turnLeft = 31879, turnRight = 31879, walkLeft = 31879, walkRight = 31879, walkTurnLeft = 31879, walkTurnRight = 31879 },  -- MTX116_JOKER_IDLE_BOW
    [4252] = { stand = 31894 },  -- DIVCHAMBER_CENTER_PLINTH_FLOWER_OPENED_LOOP
    [4253] = { stand = 31929 },  -- DUNGEON_AMINISHI_NPC_PLAY_INSTRUMENT
    [4254] = { stand = 31933 },  -- DUNGEON_AMINISHI_EVIL_SEIRYU_HEAD_IDLE
    [4255] = { stand = 31938 },  -- DUNGEON_AMINISHI_SEIRYU_HEAD_IDLE
    [4256] = { stand = 31966 },  -- DUNGEON_AMINISHI_EVIL_SEIRYU_HEAD_ON_GROUND_IDLE
    [4257] = { stand = 31952, walk = 31952 },  -- DUNGEON_AMINISHI_SHADOW_GROUND_VORTEX_IDLE
    [4258] = { stand = 31964 },  -- DUNGEON_AMINISHI_ENERGY_PYLON_CRYSTAL_IDLE
    [4259] = { stand = 32018 },  -- MTX117_TELEPATHIC_SKILLING_WARMING_HANDS
    [4260] = { stand = 32028, walk = 32029, run = 32030, turnLeft = 32029, turnRight = 32029 },  -- MTXJULY18_SANDCASTLE_CRAB_IDLE
    [4261] = { stand = 32048 },  -- MTXBEACH18_COCKTAIL_FLARING_REST_LOOP
    [4262] = { stand = 32043 },  -- MTXBEACH18_PLAYER_SANDWICH_REST
    [4263] = { stand = 32038, walk = 32039, run = 32040, turnLeft = 32039, turnRight = 32039 },  -- MTXBEACH18_SANDCASTLE_CRAB_IDLE
    [4264] = { stand = 32067, walk = 32068, run = 32069, runBack = 32069, runLeft = 32069, runRight = 32069, turnLeft = 32067, turnRight = 32067, walkBack = 32068, runTurnLeft = 32069, runTurnRight = 32069, walkTurnLeft = 32068, walkTurnRight = 32068 },  -- MTXBEACH18_GOEBIE_PET_IDLE
    [4265] = { stand = 32057, walk = 32058, run = 32059, turnLeft = 32058, turnRight = 32058 },  -- MTXBEACH18_HOT_SAND_IDLE
    [4266] = { stand = 32060, walk = 32061, run = 32062, turnLeft = 32061, turnRight = 32061 },  -- MTXBEACH18_HOT_SAND_IDLE_2H_CROSSBOW
    [4267] = { stand = 32077, walk = 32078, run = 32079, turnLeft = 32078, turnRight = 32078 },  -- MTXBEACH18_HOT_SAND_IDLE_MAUL
    [4268] = { stand = 32057, walk = 32063, run = 32059, turnLeft = 32063, turnRight = 32063 },  -- MTXBEACH18_HOT_SAND_IDLE
    [4269] = { stand = 32086 },  -- MTX_TRADER_XIC_IDLE
    [4270] = { stand = 32084 },  -- TRH119_BURIED_TREASURE_MYSTERY_REST_LOOP
    [4271] = { stand = 32089, walk = 32089 },  -- DUNGEON_WILDERNESS_ASTELLARN_BLACK_HOLE_NPC_IDLE
    [4272] = { stand = 32093, walk = 32093 },  -- DUNGEON_WILDERNESS_ASTELLARN_PULSAR_NPC_IDLE
    [4273] = { stand = 32096, walk = 32097, turnLeft = 32097, turnRight = 32097, walkBack = 32097, walkTurnLeft = 32097, walkTurnRight = 32097 },  -- DUNGEON_WILDERNESS_ASTELLARN_IDLE
    [4274] = { stand = 32096, walk = 32097, crawl = 32158, crawlBack = 32158, turnLeft = 32097, turnRight = 32097, walkBack = 32097, crawlTurnLeft = 32158, crawlTurnRight = 32158, walkTurnLeft = 32097, walkTurnRight = 32097 },  -- DUNGEON_WILDERNESS_ASTELLARN_IDLE
    [4275] = { walk = 32103, turnLeft = 32103, turnRight = 32103, idles = { { 32102, 245 }, { 32104, 10 } } },
    [4276] = { stand = 32148, walk = 32149, turnLeft = 32149, turnRight = 32149, walkBack = 32149, walkLeft = 32149, walkRight = 32149 },  -- DRAGONFORT_DRAGON_UPDATE_09_READY_BLACK_DRAGON
    [4277] = { stand = 32150, walk = 32151, turnLeft = 32151, turnRight = 32151, walkBack = 32151, walkLeft = 32151, walkRight = 32151 },  -- DRAGONFORT_DRAGON_UPDATE_09_READY_CELESTIAL_DRAGON
    [4278] = { stand = 32152, walk = 32153, turnLeft = 32153, turnRight = 32153, walkBack = 32153, walkLeft = 32153, walkRight = 32153 },  -- DRAGONFORT_DRAGON_UPDATE_09_READY_HYDRIX_DRAGON
    [4279] = { stand = 32154, walk = 32155, turnLeft = 32155, turnRight = 32155, walkBack = 32155, walkLeft = 32155, walkRight = 32155 },  -- DRAGONFORT_DRAGON_UPDATE_09_READY_DRAGONSTONE_DRAGON
    [4280] = { stand = 32156, walk = 32157, turnLeft = 32157, turnRight = 32157, walkBack = 32157, walkLeft = 32157, walkRight = 32157 },  -- DRAGONFORT_DRAGON_UPDATE_09_READY_ONYX_DRAGON
    [4281] = { stand = 32166 },  -- DUNGEON_WILDERNESS_HANDOFXAUTAK_IDLE
    [4282] = { stand = 23213 },  -- TPR_COMBAT_ABILITY_PLAYER_TENDRIL_SPOTANIM
    [4283] = { stand = 32182, walk = 819 },  -- EVENT11_HUMAN_CAPE_SHOWCASE_IDLE
    [4284] = { stand = 32181 },  -- EVENT11_GOBLIN_BUTLER_CAPE_SHOWCASE_IDLE
    [4285] = { stand = 32185, walk = 32187, run = 34095, turnLeft = 32187, turnRight = 32187, walkBack = 32187, walkLeft = 32187, walkRight = 32187 },  -- POF_RABBIT_IDLE
    [4286] = { walk = 32188, idles = { { 32189, 80 }, { 3817, 20 } } },
    [4287] = { stand = 32190, walk = 32191, turnLeft = 32191, turnRight = 32191 },  -- POF_SHEEP_IDLE
    [4288] = { stand = 32194, walk = 32193, run = 32195, turnLeft = 32193, turnRight = 32193 },  -- POF_CHINCHOMPA_IDLE
    [4289] = { stand = 32197, walk = 32204, turnLeft = 32204, turnRight = 32204 },  -- POF_COW_IDLE
    [4290] = { stand = 32209, walk = 32212, run = 32210, turnLeft = 32212, turnRight = 32212, walkBack = 32212, walkLeft = 32212, walkRight = 32212 },  -- POF_YAK_IDLE
    [4291] = { walk = 32213, idles = { { 32215, 15 }, { 32216, 240 } } },
    [4292] = { stand = 24132 },  -- SB_SPIDER_EGG_IDLE
    [4293] = { stand = 32264, walk = 32265 },  -- POF_CHICK_IDLE
    [4294] = { stand = 32238, walk = 32237, run = 32239, turnLeft = 32237, turnRight = 32237 },  -- POF_YAK_BABY_IDLE
    [4295] = { walk = 32224, idles = { { 32220, 15 }, { 32221, 240 } } },
    [4296] = { walk = 32213, run = 32214, turnLeft = 32213, turnRight = 32213, walkBack = 32213, walkLeft = 32213, walkRight = 32213, idles = { { 32215, 15 }, { 32216, 240 } } },
    [4297] = { stand = 32268 },  -- POF_GRANNY_IDLE
    [4298] = { stand = 32233, walk = 32234, turnLeft = 32234, turnRight = 32234 },  -- POF_RABBIT_BABY_IDLE
    [4299] = { walk = 32247, turnLeft = 32247, turnRight = 32247, idles = { { 32242, 15 }, { 32243, 240 } } },
    [4300] = { stand = 32255, walk = 32256, turnLeft = 32256, turnRight = 32256 },  -- POF_SHEEP_BABY_IDLE
    [4301] = { stand = 32261, walk = 32262, turnLeft = 32262, turnRight = 32262 },  -- POF_CHINCHOMPA_BABY_IDLE
    [4302] = { walk = 32188, idles = { { 32270, 80 }, { 32219, 20 } } },
    [4303] = { stand = 32271, walk = 32272, run = 32273, turnLeft = 32272, turnRight = 32272 },  -- MTXSEPT18_RAINBOW_LIZZARD_PET_IDLE
    [4304] = { walk = 32282, run = 32283, turnLeft = 32282, turnRight = 32282, walkBack = 32282, walkTurnLeft = 32282, walkTurnRight = 32282, idles = { { 32307, 90 }, { 32308, 5 }, { 32309, 5 } } },
    [4305] = { stand = 32293 },  -- QPS_HUB_HOST_MAY_IDLE
    [4306] = { stand = 32296, walk = 32297, run = 32298, turnLeft = 32297, turnRight = 32297, walkLeft = 32297, walkRight = 32297, walkTurnLeft = 32297, walkTurnRight = 32297 },  -- MTXOCT18_LIGHTING_BEAR_PET_IDLE
    [4307] = { stand = 32310, walk = 35750, run = 32311 },  -- RUNEFEST_2018_PLAYER_HORN_IDLE
    [4308] = { stand = 32314, walk = 32315 },  -- BTW_LUCIEN_2017_READY
    [4309] = { stand = 32322 },  -- OCTOBER_2018_MOIA_FLOATING_IN_RIFT
    [4310] = { stand = 32323 },  -- OCTOBER_2018_MOIA_FLOATING_IN_RIFT_SILENT
    [4311] = { stand = 32324 },  -- OCT18_URN_BLACK_HAND_01_IDLE
    [4312] = { stand = 32325 },  -- OCT18_URN_BLACK_HAND_02_IDLE
    [4313] = { stand = 32326 },  -- OCT18_URN_BLACK_HAND_03_IDLE
    [4314] = { stand = 32327 },  -- OCT18_URN_BLACK_HAND_04_IDLE
    [4315] = { stand = 32339 },  -- OCT18_RIFT_KALGERION_DEMON_IDLE
    [4316] = { stand = 32361 },  -- OCT18_SEEKER_IDLE
    [4317] = { idles = { { 32381, 85 }, { 32382, 10 }, { 32383, 5 } } },
    [4318] = { idles = { { 32390, 50 }, { 32391, 35 }, { 32392, 15 } } },
    [4319] = { idles = { { 32385, 180 }, { 32386, 35 } } },
    [4320] = { stand = 32396, walk = 32395, walkLeft = 32395, walkRight = 32395 },  -- OCT18_LARGE_BOSS_IDLE
    [4321] = { stand = 32389 },  -- OCT18_LUCIEN_ATTACK_SPECIAL_PILLAR_A_LOOP
    [4322] = { stand = 32388 },  -- OCT18_LUCIEN_DEATH_A_LOOP
    [4323] = { stand = 31343, walk = 31344, run = 31345, turnLeft = 31344, turnRight = 31344 },  -- TRH132_FACELESS_ASSASSIN_IDLE
    [4324] = { stand = 32398, walk = 32399, run = 32400, turnLeft = 32399, turnRight = 32399 },  -- MTXAUG18_PLAGUE_DOCTOR_IDLE
    [4325] = { stand = 32401, walk = 32406, run = 32411, turnLeft = 32406, turnRight = 32406 },  -- MTXAUG18_PLAGUE_DOCTOR_IDLE_2H_SWORD
    [4326] = { stand = 32402, walk = 32407, run = 32412, turnLeft = 32407, turnRight = 32407 },  -- MTXAUG18_PLAGUE_DOCTOR_IDLE_2H_MAUL
    [4327] = { stand = 32403, walk = 32408, run = 32413, turnLeft = 32408, turnRight = 32408 },  -- MTXAUG18_PLAGUE_DOCTOR_IDLE_2H_CROSSBOW
    [4328] = { stand = 32404, walk = 32409, run = 32414, turnLeft = 32409, turnRight = 32409 },  -- MTXAUG18_PLAGUE_DOCTOR_IDLE_STAFF
    [4329] = { stand = 32405, walk = 32410, run = 32415, turnLeft = 32410, turnRight = 32410 },  -- MTXAUG18_PLAGUE_DOCTOR_IDLE_BOW
    [4330] = { stand = 32422, walk = 32423, run = 32424, turnLeft = 32423, turnRight = 32423 },  -- MTXAUG18_PLAGUE_DOCTOR_IDLE_PISTOL_CROSSBOW
    [4331] = { stand = 32418 },  -- MTXAUG18_PLAGUE_DOCTOR_REST_LOOP
    [4332] = { stand = 32434 },  -- QUEST_TNS_GAIL_IDLE
    [4333] = { stand = 32435 },  -- QUEST_TNS_GAIL_DEAD_POSE
    [4334] = { stand = 32442 },  -- QUEST_TNS_PRIMROSE_FAINTED_ON_FLOOR
    [4335] = { stand = 32440 },  -- QUEST_TNS_PRIMROSE_IN_BED_IDLE
    [4336] = { stand = 32438 },  -- QUEST_TNS_MEGAN_IDLE
    [4337] = { stand = 32444 },  -- QUEST_TNS_MEGAN_ALTERNATIVE_IDLE
    [4338] = { stand = 32450 },  -- MTXNOV18_PLAYER_SLIME_REST_LOOP
    [4339] = { stand = 32456 },  -- MTXNOV18_KING_SLIME_IDLE
    [4340] = { stand = 32467 },  -- MTXNOV18_KING_SLIME_IDLE_RESIZE_5X5_3X3
    [4341] = { stand = 32457, walk = 32458, run = 32459, turnLeft = 32458, turnRight = 32458 },  -- MTXNOV18_SLIME_PET_IDLE
    [4342] = { stand = 32481, walk = 32480, run = 32482, turnRight = 32480 },  -- XMAS2018_ADVENT_SNOWY_UMBRELLA_PLAYER_IDLE
    [4343] = { stand = 32476 },  -- XMAS2018_ADVENT_PLAYER_BUILDING_SNOWMAN_LOOP
    [4344] = { stand = 32484 },  -- PREM18_PLAYER_WARM_BY_FIRE_REST_LOOP
    [4345] = { stand = 32484 },  -- PREM18_PLAYER_WARM_BY_FIRE_REST_LOOP
    [4346] = { walk = 32492, run = 32493, idles = { { 32490, 90 }, { 32491, 10 } } },
    [4347] = { stand = 32497, walk = 32496 },  -- XMAS_2018_SNOWBALL_IDLE
    [4348] = { stand = 32501, walk = 32500 },  -- XMAS2018_VIOLET_IN_BARREL_IDLE
    [4349] = { stand = 32502, walk = 32503, run = 32504, turnLeft = 32503, turnRight = 32503, walkLeft = 32503, walkRight = 32503, walkTurnLeft = 32503, walkTurnRight = 32503 },  -- XMAS18_FIREFLY_IDLE
    [4350] = { stand = 32508, walk = 31706, turnLeft = 31706, turnRight = 31706, walkBack = 31706 },  -- XMAS2018_YETI_CHILD_IDLE
    [4351] = { walk = 32509, turnLeft = 32509, turnRight = 32509, walkLeft = 32509, walkRight = 32509, walkTurnLeft = 32509, walkTurnRight = 32509, idles = { { 32510, 95 }, { 32513, 5 } } },
    [4352] = { stand = 32495 },  -- XMAS2018_VIOLET_ON_SLED_IDLE
    [4353] = { walk = 234, run = 235, turnLeft = 148, turnRight = 148, walkLeft = 234, walkRight = 234, walkTurnLeft = 234, walkTurnRight = 234, idles = { { 148, 70 }, { 157, 30 } } },
    [4354] = { stand = 252, walk = 252, run = 252, turnLeft = 252, turnRight = 252, walkLeft = 252, walkRight = 252, walkTurnLeft = 252, walkTurnRight = 252 },  -- DUNGEON_ULTHVEN_AMBASSADOR_BEAM_ROTATE_ATTACK
    [4355] = { stand = 29017 },  -- GWD2_SOLO_PLAYER_SWORD_SPECIAL_ATTACK_SPOTANIM
    [4356] = { stand = 23387, walk = 23387, run = 23387, turnLeft = 23387, turnRight = 23387, walkLeft = 23387, walkRight = 23387, walkTurnLeft = 23387, walkTurnRight = 23387 },  -- ASH1_2014_AGOROTH_BOSS_BODY_IDLE
    [4357] = { idles = { { 297, 70 }, { 297, 30 } } },
    [4358] = { idles = { { 308, 70 }, { 308, 30 } } },
    [4359] = { walk = 21646, run = 21647, turnLeft = 20967, turnRight = 20967, walkLeft = 21646, walkRight = 21646, walkTurnLeft = 21646, walkTurnRight = 21646, idles = { { 20967, 90 }, { 20968, 10 } } },
    [4360] = { walk = 28362, run = 28363, turnLeft = 28173, turnRight = 28173, walkLeft = 28362, walkRight = 28362, walkTurnLeft = 28362, walkTurnRight = 28362, idles = { { 28173, 90 }, { 28361, 10 } } },
    [4361] = { stand = 7215 },  -- CLAN_WELCOME_AREA_PORTAL_READY
    [4362] = { stand = 32637 },  -- MTXAPR19_PLAYER_LICH_KING_TWO_HANDED_SWORD_WALK
    [4363] = { stand = 32635, walk = 32637, run = 32638, runBack = 32638, turnLeft = 32637, turnRight = 32637, walkBack = 32637, walkLeft = 32637, walkRight = 32637 },  -- MTXAPR19_PLAYER_LICH_KING_TWO_HANDED_SWORD_IDLE
    [4364] = { stand = 32639, walk = 32641, run = 32642, runBack = 32642, turnLeft = 32641, turnRight = 32641, walkBack = 32641, walkLeft = 32641, walkRight = 32641 },  -- MTXAPR19_PLAYER_LICH_KING_STAFF_IDLE
    [4365] = { stand = 32643, walk = 32645, run = 32646, runBack = 32646, turnLeft = 32645, turnRight = 32645, walkBack = 32645, walkLeft = 32645, walkRight = 32645 },  -- MTXAPR19_PLAYER_LICH_KING_BOW_IDLE
    [4366] = { stand = 32647, walk = 32648, run = 32649, runBack = 32649, turnLeft = 32648, turnRight = 32648, walkBack = 32648, walkLeft = 32648, walkRight = 32648 },  -- MTXAPR19_PLAYER_LICH_KING_UNARMED_IDLE
    [4367] = { stand = 32657 },  -- EASTER2019_PLAYER_PICK_DAISY_REST_LOOP
    [4368] = { stand = 32662, walk = 31718, run = 31719, turnLeft = 31718, turnRight = 31718 },  -- EASTER2019_MYSTERIOUS_PET_IDLE
    [4369] = { stand = 32664, walk = 32665, turnLeft = 32665, turnRight = 32665, walkLeft = 32665, walkRight = 32665, walkTurnLeft = 32665, walkTurnRight = 32665 },  -- QUEST_CHAROS_KERAPAC_IDLE
    [4370] = { stand = 24929 },  -- PLAYER_2014_FISHING_LOBSTER
    [4371] = { walk = 32669, run = 32668, turnLeft = 32669, turnRight = 32669, walkLeft = 32669, walkRight = 32669, walkTurnLeft = 32669, walkTurnRight = 32669, idles = { { 32666, 90 }, { 32667, 10 } } },
    [4372] = { stand = 32677 },  -- MTXBARGE_PLAYER_PLANT_FLAG_LOOP
    [4373] = { walk = 31048, run = 32682, turnLeft = 31048, turnRight = 31048, walkLeft = 31048, walkRight = 31048, walkTurnLeft = 31048, walkTurnRight = 31048, idles = { { 16430, 60 }, { 3824, 20 }, { 3817, 20 } } },
    [4374] = { walk = 32934, run = 32694, runLeft = 32694, runRight = 32694, turnLeft = 32694, turnRight = 32694, walkLeft = 32934, walkRight = 32934, runTurnLeft = 32694, runTurnRight = 32694, walkTurnLeft = 32934, walkTurnRight = 32934, idles = { { 32691, 90 }, { 32692, 10 } } },
    [4375] = { stand = 32700 },  -- DINOSAUR_TYRANNOSAUR_DEATH_POSE
    [4376] = { walk = 32935, run = 32705, runLeft = 32705, runRight = 32705, turnLeft = 32705, turnRight = 32705, walkLeft = 32935, walkRight = 32935, runTurnLeft = 32705, runTurnRight = 32705, walkTurnLeft = 32935, walkTurnRight = 32935, idles = { { 32702, 90 }, { 32703, 10 } } },
    [4377] = { walk = 32729, turnLeft = 32729, turnRight = 32729, walkLeft = 32729, walkRight = 32729, walkTurnLeft = 32729, walkTurnRight = 32729, idles = { { 32724, 90 }, { 32725, 10 } } },
    [4378] = { walk = 32715, turnLeft = 32715, turnRight = 32715, walkLeft = 32715, walkRight = 32715, walkTurnLeft = 32715, walkTurnRight = 32715, idles = { { 32713, 90 }, { 32714, 10 } } },
    [4379] = { walk = 32729, turnLeft = 32729, turnRight = 32729, walkLeft = 32729, walkRight = 32729, walkTurnLeft = 32729, walkTurnRight = 32729, idles = { { 32724, 90 }, { 32726, 10 } } },
    [4380] = { walk = 32729, turnLeft = 32729, turnRight = 32729, walkLeft = 32729, walkRight = 32729, walkTurnLeft = 32729, walkTurnRight = 32729, idles = { { 32724, 90 }, { 32727, 10 } } },
    [4381] = { walk = 32729, turnLeft = 32729, turnRight = 32729, walkLeft = 32729, walkRight = 32729, walkTurnLeft = 32729, walkTurnRight = 32729, idles = { { 32724, 90 }, { 32728, 10 } } },
    [4382] = { stand = 32847 },  -- DINO_ISLAND_ZYGOMITE_ADULT_IN_GROUND_IDLE
    [4383] = { stand = 32849, walk = 32848, turnLeft = 32848, turnRight = 32848, walkBack = 32848, walkLeft = 32848, walkRight = 32848 },  -- DINO_ISLAND_ZYGOMITE_ADULT_HOLDING_HERB_IDLE
    [4384] = { stand = 32747 },  -- PLANT_CARNIVOROUS_WHIP_IDLE
    [4385] = { stand = 32755 },  -- PLANT_CARNIVOROUS_SPOTTYSPITTER_IDLE
    [4386] = { stand = 32762 },  -- PLANT_CARNIVOROUS_PURPLE_IDLE
    [4387] = { stand = 32767 },  -- PLANT_CARNIVOROUS_SPINY_IDLE
    [4388] = { walk = 32776, turnLeft = 32776, turnRight = 32776, walkLeft = 32776, walkRight = 32776, walkTurnLeft = 32776, walkTurnRight = 32776, idles = { { 32774, 90 }, { 32775, 10 } } },
    [4389] = { walk = 32792, turnLeft = 32792, turnRight = 32792, walkLeft = 32792, walkRight = 32792, walkTurnLeft = 32792, walkTurnRight = 32792, idles = { { 32790, 90 }, { 32791, 10 } } },
    [4390] = { walk = 32784, turnLeft = 32784, turnRight = 32784, walkLeft = 32784, walkRight = 32784, walkTurnLeft = 32784, walkTurnRight = 32784, idles = { { 32782, 90 }, { 32783, 10 } } },
    [4391] = { walk = 32801, turnLeft = 32801, turnRight = 32801, walkLeft = 32801, walkRight = 32801, walkTurnLeft = 32801, walkTurnRight = 32801, idles = { { 32798, 90 }, { 32799, 10 } } },
    [4392] = { stand = 32808, walk = 29143, run = 29144, runBack = 29146, turnLeft = 29143, turnRight = 29143, walkBack = 29145 },  -- DINO_SLAYER_MASTER_IDLE
    [4393] = { stand = 31744, walk = 32814, run = 32815, turnLeft = 32814, turnRight = 32814, walkTurnLeft = 32814, walkTurnRight = 32814 },  -- NATURE_BOSS_MERETHIEL_IDLE_STAFF
    [4394] = { stand = 17970, walk = 17971, run = 17972, turnLeft = 17971, turnRight = 17971 },  -- COMBAT_2012_COMBAT_READY
    [4395] = { walk = 32839, run = 32840, turnLeft = 32839, turnRight = 32839, idles = { { 18019, 80 }, { 196, 20 } } },
    [4396] = { walk = 32841, run = 32842, turnLeft = 32841, turnRight = 32841, idles = { { 18055, 80 }, { 37966, 20 } } },
    [4397] = { stand = 18015, walk = 18016, run = 18017, turnLeft = 18016, turnRight = 18016 },  -- COMBAT_2012_CASUAL_ARMED_IDLE
    [4398] = { walk = 32213, idles = { { 32843, 15 }, { 32844, 240 } } },
    [4399] = { stand = 32853, walk = 32854, run = 32855, turnLeft = 32854, turnRight = 32854, walkLeft = 32854, walkRight = 32854, walkTurnLeft = 32854, walkTurnRight = 32854 },  -- TWITCH_OCT18_SALAWA_IDLE
    [4400] = { stand = 26469 },  -- TUSKA_RAID_ASTRO_WIZARD_IDLE_EXTRA
    [4401] = { stand = 21988 },  -- EMOTE_2013_BECKON
    [4402] = { stand = 32866 },  -- OMGE_MELEE_TROLL_BOSS_ANGRY_ROAR_SILENT
    [4403] = { walk = 32870, run = 32871, turnLeft = 32870, turnRight = 32870, runTurnLeft = 32871, runTurnRight = 32871, walkTurnLeft = 32870, walkTurnRight = 32870, idles = { { 32872, 90 }, { 32869, 10 } } },
    [4404] = { walk = 32881, run = 32882, turnLeft = 32881, turnRight = 32881, runTurnLeft = 32882, runTurnRight = 32882, walkTurnLeft = 32881, walkTurnRight = 32881, idles = { { 32883, 90 }, { 32880, 10 } } },
    [4405] = { stand = 32892 },  -- MOBILE_FOUNDERS_PLAYER_REST_LOOP
    [4406] = { walk = 32896, run = 32897, turnLeft = 32897, turnRight = 32896, runTurnRight = 32897, walkTurnLeft = 32896, walkTurnRight = 32896, idles = { { 32894, 90 }, { 32895, 10 } } },
    [4407] = { stand = 32912, walk = 32913, turnLeft = 32913, turnRight = 32913 },  -- POF_TYRANNOSAUR_BABY_IDLE
    [4408] = { stand = 32914, walk = 32915, turnLeft = 32915, turnRight = 32915 },  -- POF_TYRANNOSAUR_BABY_CORBICULA_IDLE
    [4409] = { stand = 32916, walk = 32917, turnLeft = 32917, turnRight = 32917 },  -- POF_TYRANNOSAUR_BABY_PAVOSAUR_IDLE
    [4410] = { stand = 32918, walk = 32919, turnLeft = 32919, turnRight = 32919 },  -- POF_STEGOSAURUS_BABY_IDLE
    [4411] = { stand = 32920, walk = 32921, turnLeft = 32921, turnRight = 32921 },  -- POF_STEGOSAURUS_BABY_BRUTISH_IDLE
    [4412] = { stand = 32922, walk = 32923, turnLeft = 32923, turnRight = 32923 },  -- POF_STEGOSAURUS_BABY_ASCIATOPS_IDLE
    [4413] = { stand = 32924, walk = 32925, turnLeft = 32925, turnRight = 32925 },  -- POF_STEGOSAURUS_BABY_SCIMITOPS_IDLE
    [4414] = { stand = 32926, walk = 32927, turnLeft = 32927, turnRight = 32927 },  -- POF_PTEROSAUR_BABY_IDLE
    [4415] = { stand = 32928, walk = 32929, turnLeft = 32929, turnRight = 32929 },  -- POF_PTEROSAUR_BABY_ARCANE_IDLE
    [4416] = { stand = 32930, walk = 32931, turnLeft = 32931, turnRight = 32931 },  -- POF_PTEROSAUR_BABY_SPICATI_IDLE
    [4417] = { stand = 32932, walk = 32933, turnLeft = 32933, turnRight = 32933 },  -- POF_DINO_LIZARD_BABY_IDLE
    [4418] = { stand = 32936, walk = 32938, turnLeft = 32938, turnRight = 32938, walkLeft = 32938, walkRight = 32938, walkTurnLeft = 32938, walkTurnRight = 32938 },  -- POF_FROG_BABY_IDLE
    [4419] = { stand = 3288, walk = 32939, turnLeft = 32939, turnRight = 32939 },  -- ECO_VINE_CREATURES_READY
    [4420] = { stand = 32963 },  -- MTXPASS_GHOST_RESTING_POSSESSION_REST
    [4421] = { stand = 32967 },  -- MTXPASS_PLAYER_RESTING_INVISIBLE_POSSESSION_REST
    [4422] = { stand = 32959 },  -- MTXPASS_PLAYER_FEMALE_THRONE_RESTING
    [4423] = { stand = 32955 },  -- MTXPASS_PLAYER_MALE_THRONE_RESTING
    [4424] = { stand = 32959 },  -- MTXPASS_PLAYER_FEMALE_THRONE_RESTING
    [4425] = { walk = 32975, run = 32974, idles = { { 32972, 90 }, { 32973, 10 } } },
    [4426] = { stand = 32985, walk = 32984 },  -- TEST_PET_FLY_IN_CIRCLE_IDLE
    [4427] = { stand = 32989 },  -- TRH167_CRYSTAL_IDLE
    [4428] = { idles = { { 32992, 90 }, { 32993, 10 } } },
    [4429] = { stand = 32995, walk = 32994, run = 21966, runBack = 21966, runLeft = 21966, runRight = 21966, turnLeft = 32995, turnRight = 32995, walkBack = 32994, runTurnLeft = 21966, runTurnRight = 21966, walkTurnLeft = 32994, walkTurnRight = 32994 },  -- MTXWINTERCHILL_MINIMORN_IDLE
    [4430] = { stand = 32998, walk = 33002 },  -- MTXFEB20_KING_SLIME_IDLE
    [4431] = { stand = 33003, walk = 7650 },  -- QIP_DS_ARIS_FIGHTING_READY
    [4432] = { stand = 33009, walk = 33009 },  -- OMGE_MARKET_SELLER_READY_A_SILENT
    [4433] = { stand = 3295, walk = 3295 },  -- WOOD_SPIRIT_SPOTANIM
    [4434] = { walk = 33012, run = 33013, turnLeft = 33012, turnRight = 33012, walkLeft = 33012, walkRight = 33012, walkTurnLeft = 33012, walkTurnRight = 33012, idles = { { 33010, 95 }, { 33011, 5 } } },
    [4435] = { walk = 33038, run = 33039, turnLeft = 33038, turnRight = 33038, runTurnLeft = 33039, runTurnRight = 33039, walkTurnLeft = 33038, walkTurnRight = 33038, idles = { { 33036, 90 }, { 33037, 10 } } },
    [4436] = { stand = 33050 },  -- ZODIYAK_PLAYER_COSMIC_TRANCE_RESTING_LOOP
    [4437] = { walk = 33069, run = 33068, turnLeft = 33069, turnRight = 33069, walkLeft = 33069, walkRight = 33069, walkTurnLeft = 33069, walkTurnRight = 33069, idles = { { 33065, 90 }, { 33066, 10 } } },
    [4438] = { walk = 33072, run = 33078, turnLeft = 33072, turnRight = 33072, walkLeft = 33072, walkRight = 33072, walkTurnLeft = 33072, walkTurnRight = 33072, idles = { { 33070, 90 }, { 33071, 10 } } },
    [4439] = { stand = 33242, walk = 33240, run = 33241, turnLeft = 33242, turnRight = 33242, walkLeft = 33240, walkRight = 33240, walkTurnLeft = 33240, walkTurnRight = 33240 },  -- ARCH_PLAYER_UNDERWATER_IDLE_NO_PARTICLES
    [4440] = { stand = 33118, walk = 33119, run = 33120 },  -- ARCH_PLAYER_FLY_IDLE
    [4441] = { stand = 33233 },  -- ARCH_EXCAVATE_LOW_LOOP_FLAVOUR
    [4442] = { idles = { { 33233, 95 }, { 33234, 5 } } },
    [4443] = { stand = 23780, turnLeft = 23782, turnRight = 23782 },  -- HUMAN_2013_SHOPKEEPER_IDLE
    [4444] = { stand = 33239, walk = 33239 },  -- ARCH_TIME_SPRITE_IDLE
    [4445] = { walk = 33394, run = 32882, turnLeft = 33394, turnRight = 33394, runTurnLeft = 32882, runTurnRight = 32882, walkTurnLeft = 33394, walkTurnRight = 33394, idles = { { 33392, 90 }, { 33393, 10 } } },
    [4446] = { walk = 33408, run = 33409, turnLeft = 33408, turnRight = 33408, runTurnLeft = 33409, runTurnRight = 33409, walkTurnLeft = 33408, walkTurnRight = 33408, idles = { { 33405, 90 }, { 33407, 10 } } },
    [4447] = { stand = 25717, walk = 25716, run = 33416, turnLeft = 25716, turnRight = 25716, walkLeft = 25716, walkRight = 25716, walkTurnLeft = 25716, walkTurnRight = 25716 },  -- DEMON_RAID_UPDATE_IDLE
    [4448] = { stand = 33431 },  -- SHADOW_YAK_PLAYER_PRAYING_RESTING
    [4449] = { stand = 33423, walk = 33421, run = 33422, turnLeft = 33421, turnRight = 33421, walkLeft = 33421, walkRight = 33421, walkTurnLeft = 33421, walkTurnRight = 33421 },  -- SHADOW_YAK_PLAYER_ZAROS_IDLE
    [4450] = { walk = 33440, run = 33441, turnLeft = 33440, turnRight = 33440, walkLeft = 33440, walkRight = 33440, walkTurnLeft = 33440, walkTurnRight = 33440, idles = { { 33438, 90 }, { 33439, 10 } } },
    [4451] = { walk = 33459, run = 33458, turnLeft = 33459, turnRight = 33459, walkLeft = 33459, walkRight = 33459, walkTurnLeft = 33459, walkTurnRight = 33459, idles = { { 33452, 90 }, { 33453, 10 } } },
    [4452] = { stand = 33466 },  -- MTXBEACH_20_PLAYER_PARASOL_REST_LOOP
    [4453] = { stand = 33478, walk = 33479 },  -- CRITTER_BAT_IDLE
    [4454] = { stand = 33478, walk = 33479 },  -- CRITTER_BAT_IDLE
    [4455] = { stand = 33474, walk = 33475 },  -- BIRD_STANDARD_IDLE
    [4456] = { stand = 33474, walk = 33474 },  -- BIRD_STANDARD_IDLE
    [4457] = { stand = 33482, walk = 33481 },  -- CRITTER_BUTTERFLY_IDLE
    [4458] = { stand = 33482, walk = 33482 },  -- CRITTER_BUTTERFLY_IDLE
    [4459] = { stand = 33506, walk = 33521, turnLeft = 33521, turnRight = 33521, walkLeft = 33521, walkRight = 33521, walkTurnLeft = 33521, walkTurnRight = 33521 },  -- QUEST_DM_DRAGONKIN_NODON_IDLE
    [4460] = { stand = 33485, walk = 33486, turnLeft = 33485, turnRight = 33485, walkLeft = 33486, walkRight = 33486, walkTurnLeft = 33486, walkTurnRight = 33486 },  -- QUEST_DM_DRAGONKIN_FLYING_IDLE
    [4461] = { stand = 32691, walk = 32934, run = 32694, runLeft = 32694, runRight = 32694, turnLeft = 32694, turnRight = 32694, walkLeft = 32934, walkRight = 32934, runTurnLeft = 32694, runTurnRight = 32694, walkTurnLeft = 32934, walkTurnRight = 32934 },  -- BIG_GAME_TYRANNOSAUR_IDLE
    [4462] = { walk = 33517, run = 33519, turnLeft = 33517, turnRight = 33517, walkLeft = 33517, walkRight = 33517, walkTurnLeft = 33517, walkTurnRight = 33517, idles = { { 33515, 90 }, { 33516, 10 } } },
    [4463] = { stand = 18022, walk = 33504, run = 33505, turnLeft = 33504, turnRight = 33504 },  -- COMBAT_2012_CASUAL_MAUL_IDLE
    [4464] = { stand = 22111 },  -- TUT5_VILLAGER_FEMALE_3_SCARED
    [4465] = { stand = 22113 },  -- TUT5_VILLAGER_FEMALE_4_SCARED
    [4466] = { stand = 33507 },  -- QUEST_DM_ARCHAEOLOGIST_SCARED
    [4467] = { stand = 37652, walk = 37657, run = 37658, turnLeft = 37657, turnRight = 37657 },  -- HUMAN_ACTOR_COMBAT_UNARMED_IDLE
    [4468] = { walk = 32784, turnLeft = 32784, turnRight = 32784, walkLeft = 32784, walkRight = 32784, walkTurnLeft = 32784, walkTurnRight = 32784, idles = { { 32782, 90 }, { 32783, 10 } } },
    [4469] = { walk = 32801, turnLeft = 32801, turnRight = 32801, walkLeft = 32801, walkRight = 32801, walkTurnLeft = 32801, walkTurnRight = 32801, idles = { { 32798, 90 }, { 32799, 10 } } },
    [4470] = { walk = 32776, turnLeft = 32776, turnRight = 32776, walkLeft = 32776, walkRight = 32776, walkTurnLeft = 32776, walkTurnRight = 32776, idles = { { 32774, 90 }, { 32775, 10 } } },
    [4471] = { walk = 32792, turnLeft = 32792, turnRight = 32792, walkLeft = 32792, walkRight = 32792, walkTurnLeft = 32792, walkTurnRight = 32792, idles = { { 32790, 90 }, { 32791, 10 } } },
    [4472] = { walk = 33547, run = 33548, turnLeft = 33547, turnRight = 33547, walkLeft = 33547, walkRight = 33547, walkTurnLeft = 33547, walkTurnRight = 33547, idles = { { 33545, 90 }, { 33546, 10 } } },
    [4473] = { stand = 33550, walk = 33553, turnLeft = 33553, turnRight = 33553, walkLeft = 33553, walkRight = 33553, walkTurnLeft = 33553, walkTurnRight = 33553 },  -- PENGUIN_DISGUISE_ROCK_IDLE
    [4474] = { stand = 33551, walk = 33553, turnLeft = 33553, turnRight = 33553, walkLeft = 33553, walkRight = 33553, walkTurnLeft = 33553, walkTurnRight = 33553 },  -- PENGUIN_DISGUISE_BARREL_CRATE_IDLE
    [4475] = { stand = 33552, walk = 33553, turnLeft = 33553, turnRight = 33553, walkLeft = 33553, walkRight = 33553, walkTurnLeft = 33553, walkTurnRight = 33553 },  -- PENGUIN_DISGUISE_CRATE_ONLY_IDLE
    [4476] = { stand = 33554, walk = 33555, turnLeft = 33555, turnRight = 33555, walkLeft = 33555, walkRight = 33555, walkTurnLeft = 33555, walkTurnRight = 33555 },  -- PENGUIN_DISGUISE_BRIEFCASE_IDLE
    [4477] = { stand = 33556, walk = 33557, turnLeft = 33557, turnRight = 33557, walkLeft = 33557, walkRight = 33557, walkTurnLeft = 33557, walkTurnRight = 33557 },  -- PENGUIN_DISGUISE_CACTUS_IDLE
    [4478] = { stand = 33558, walk = 33559, turnLeft = 33559, turnRight = 33559, walkLeft = 33559, walkRight = 33559, walkTurnLeft = 33559, walkTurnRight = 33559 },  -- PENGUIN_DISGUISE_BUSH_IDLE
    [4479] = { stand = 33560, walk = 33561, turnLeft = 33561, turnRight = 33561, walkLeft = 33561, walkRight = 33561, walkTurnLeft = 33561, walkTurnRight = 33561 },  -- PENGUIN_DISGUISE_MUSHROOM_IDLE
    [4480] = { walk = 33564, run = 33565, turnLeft = 33564, turnRight = 33564, walkLeft = 33564, walkRight = 33564, walkTurnLeft = 33564, walkTurnRight = 33564, idles = { { 33562, 90 }, { 33563, 10 } } },
    [4481] = { stand = 33576, walk = 33578, run = 33577, turnLeft = 33578, turnRight = 33578, walkBack = 33578, walkLeft = 33578, walkRight = 33578 },  -- POF_MECHANICAL_YAK_IDLE
    [4482] = { stand = 33590 },  -- KERAPAC_YAK_PLAYER_CHAROS_REST_LOOP
    [4483] = { walk = 33603, run = 33600, turnLeft = 33603, turnRight = 33603, walkLeft = 33603, walkRight = 33603, walkTurnLeft = 33603, walkTurnRight = 33603, idles = { { 33598, 90 }, { 33599, 10 } } },
    [4484] = { walk = 33607, run = 33608, turnLeft = 33607, turnRight = 33607, walkLeft = 33607, walkRight = 33607, walkTurnLeft = 33607, walkTurnRight = 33607, idles = { { 33609, 90 }, { 33610, 10 } } },
    [4485] = { walk = 33627, run = 33626, turnLeft = 33627, turnRight = 33627, walkLeft = 33627, walkRight = 33627, walkTurnLeft = 33627, walkTurnRight = 33627, idles = { { 33623, 90 }, { 33624, 10 } } },
    [4486] = { walk = 33633, run = 33634, turnLeft = 33633, turnRight = 33633, walkLeft = 33633, walkRight = 33633, walkTurnLeft = 33633, walkTurnRight = 33633, idles = { { 33631, 90 }, { 33632, 10 } } },
    [4487] = { walk = 33656, run = 33655, turnLeft = 33656, turnRight = 33656, walkLeft = 33656, walkRight = 33656, walkTurnLeft = 33656, walkTurnRight = 33656, idles = { { 33653, 90 }, { 33654, 10 } } },
    [4488] = { stand = 33661 },  -- DEATH_2020_IDLE
    [4489] = { stand = 33662 },  -- DEATH_2020_SITTING_IDLE
    [4490] = { walk = 33667, run = 33666, turnLeft = 33667, turnRight = 33667, walkLeft = 33667, walkRight = 33667, walkTurnLeft = 33667, walkTurnRight = 33667, idles = { { 33665, 95 }, { 33668, 5 } } },
    [4491] = { stand = 33675 },  -- HALLOWEEN2020_MUNCHER_SLEEPING_IDLE
    [4492] = { walk = 33684, run = 33685, turnLeft = 33684, turnRight = 33684, walkTurnLeft = 33684, walkTurnRight = 33684, idles = { { 33680, 90 }, { 33681, 10 } } },
    [4493] = { stand = 33686, walk = 33687, turnLeft = 33687, turnRight = 33687, walkLeft = 33687, walkRight = 33687, walkTurnLeft = 33687, walkTurnRight = 33687 },  -- PENGUIN_DISGUISE_SNOWMAN_IDLE
    [4494] = { stand = 33697, walk = 33698, run = 33699, runLeft = 33699, runRight = 33699, turnLeft = 33698, turnRight = 33698, walkLeft = 33698, walkRight = 33698, runTurnLeft = 33699, runTurnRight = 33699, walkTurnLeft = 33698, walkTurnRight = 33698 },  -- DINO_BOSS_IDLE
    [4495] = { stand = 33721 },  -- DINO_BOSS_CHAINED_UP_IDLE
    [4496] = { stand = 33701 },  -- DINO_BOSS_DEATH_IDLE
    [4497] = { stand = 33739 },  -- DINO_BOSS_ANIMA_POOL_IDLE
    [4498] = { stand = 33688, walk = 33689, run = 33690, runLeft = 33690, runRight = 33690, turnLeft = 33689, turnRight = 33689, walkLeft = 33689, walkRight = 33689, runTurnLeft = 33690, runTurnRight = 33690, walkTurnLeft = 33689, walkTurnRight = 33689 },  -- DINO_BOSS_PET_IDLE
    [4499] = { idles = { { 33750, 90 }, { 33751, 10 } } },
    [4500] = { stand = 33753 },  -- DINO_BOSS_ANIMA_CONTAINER_IDLE
    [4501] = { stand = 32490, walk = 32492, run = 32493 },  -- XMAS2018_VIOLET_IDLE
    [4502] = { walk = 33762, run = 33840, turnLeft = 33762, turnRight = 33762, walkBack = 33762, walkLeft = 33762, walkRight = 33762, walkTurnLeft = 33762, walkTurnRight = 33762, idles = { { 33760, 90 }, { 33761, 10 } } },
    [4503] = { walk = 33765, run = 33766, turnLeft = 33765, turnRight = 33765, walkBack = 33765, walkLeft = 33765, walkRight = 33765, walkTurnLeft = 33765, walkTurnRight = 33765, idles = { { 33763, 90 }, { 33764, 10 } } },
    [4504] = { stand = 31717, walk = 33786, run = 33785, turnLeft = 33786, turnRight = 33786 },  -- MTXMAY18_DARUMA_PET_IDLE
    [4505] = { stand = 33794 },  -- SANTA_YAK_PLAYER_MATRYOSHKA_DOLL_REST_LOOP
    [4506] = { walk = 33797, run = 33798, turnLeft = 33797, turnRight = 33797, walkTurnLeft = 33797, walkTurnRight = 33797, idles = { { 33795, 90 }, { 33796, 10 } } },
    [4507] = { walk = 33809, run = 33807, turnLeft = 33809, turnRight = 33809, walkTurnLeft = 33809, walkTurnRight = 33809, idles = { { 33806, 90 }, { 33808, 10 } } },
    [4508] = { walk = 33819, run = 33820, turnLeft = 33819, turnRight = 33819, walkTurnLeft = 33819, walkTurnRight = 33819, idles = { { 33821, 90 }, { 33822, 10 } } },
    [4509] = { stand = 33832, walk = 33833, run = 33834 },  -- QUEST_VIB2_VIOLET_IDLE_HAND_ITEMS_SCALED_OUT
    [4510] = { walk = 33848, run = 33849, turnLeft = 33848, turnRight = 33848, walkLeft = 33848, walkRight = 33848, walkTurnLeft = 33848, walkTurnRight = 33848, idles = { { 33846, 90 }, { 33847, 10 } } },
    [4511] = { stand = 33857, walk = 33858, run = 33859, turnLeft = 33858, turnRight = 33858, walkLeft = 33858, walkRight = 33858, walkTurnLeft = 33858, walkTurnRight = 33858 },  -- PET_MUNE_IDLE
    [4512] = { walk = 33875, run = 33876, turnLeft = 33875, turnRight = 33875, walkBack = 33875, walkLeft = 33875, walkRight = 33875, walkTurnLeft = 33875, walkTurnRight = 33875, idles = { { 33873, 90 }, { 33874, 10 } } },
    [4513] = { walk = 33887, run = 33888, turnLeft = 33887, turnRight = 33887, walkLeft = 33887, walkRight = 33887, walkTurnLeft = 33887, walkTurnRight = 33887, idles = { { 33885, 90 }, { 33886, 10 } } },
    [4514] = { stand = 32197, walk = 33901, turnLeft = 33901, turnRight = 33901 },  -- POF_COW_IDLE
    [4515] = {  },
    [4516] = { stand = 33908 },  -- YAK_BASICS_PLAYER_SLEEPINGBAG_REST_LOOP
    [4517] = { stand = 33911 },  -- YAK_BASICS_PLAYER_READING_HANDBOOK_LOOP
    [4518] = { stand = 17970, walk = 33918, run = 33919, turnLeft = 33918, turnRight = 33918 },  -- COMBAT_2012_COMBAT_READY
    [4519] = { walk = 33925, run = 33924, turnLeft = 33925, turnRight = 33925, walkLeft = 33925, walkRight = 33925, walkTurnLeft = 33925, walkTurnRight = 33925, idles = { { 33921, 90 }, { 33922, 10 } } },
    [4520] = { stand = 33952, walk = 33952, run = 33952 },  -- APRIL_FOOLS_2021_BALLOON_IDLE
    [4521] = { walk = 33935, run = 33936, turnLeft = 33935, turnRight = 33935, walkLeft = 33935, walkRight = 33935, walkTurnLeft = 33935, walkTurnRight = 33935, idles = { { 33938, 90 }, { 33939, 10 } } },
    [4522] = { stand = 33951, walk = 33951, run = 33951 },  -- APRIL_FOOLS_2021_BALLOON_BOSS_IDLE
    [4523] = { idles = { { 18019, 80 }, { 196, 20 } } },
    [4524] = { walk = 33971, run = 33972, runLeft = 33972, runRight = 33972, turnLeft = 33971, turnRight = 33971, walkLeft = 33971, walkRight = 33971, runTurnLeft = 33972, runTurnRight = 33972, walkTurnLeft = 33971, walkTurnRight = 33971, idles = { { 33966, 90 }, { 33967, 10 } } },
    [4525] = { stand = 33994 },  -- REX_KINGS_TYRANNOSAUR_RANGE_ATTACK_POISON_SPLAT_1X1_IDLE
    [4526] = { stand = 33995 },  -- REX_KINGS_TYRANNOSAUR_RANGE_ATTACK_POISON_SPLAT_3X3_IDLE
    [4527] = { stand = 33996 },  -- REX_KINGS_TYRANNOSAUR_RANGE_ATTACK_POISON_SPLAT_5X5_IDLE
    [4528] = { stand = 33997 },  -- REX_KINGS_TYRANNOSAUR_RANGE_ATTACK_POISON_SPLAT_7X7_IDLE
    [4529] = { idles = { { 18041, 100 }, { 18235, 40 } } },
    [4530] = { stand = 31866, walk = 31868, run = 31867, turnLeft = 31868, turnRight = 31868, walkLeft = 31868, walkRight = 31868, walkTurnLeft = 31868, walkTurnRight = 31868 },  -- MTX116_JOKER_IDLE_1H_SWORD
    [4531] = { stand = 31866, walk = 31868, run = 31869, turnLeft = 31868, turnRight = 31868, walkLeft = 31868, walkRight = 31868, walkTurnLeft = 31868, walkTurnRight = 31868 },  -- MTX116_JOKER_IDLE_1H_SWORD
    [4532] = { walk = 34050, run = 34051, walkLeft = 34050, walkRight = 34050, idles = { { 34048, 191 }, { 34049, 64 } } },
    [4533] = { stand = 34057 },  -- TUT7_VILLAGER_CHURN_MILK
    [4534] = { stand = 34058, walk = 34058 },  -- QUEST_SENNTISTEN_GARGOYLE_STATUE_POSE_IDLE
    [4535] = { stand = 34059 },  -- TUT7_VILLAGER_WATERING
    [4536] = { stand = 34167 },  -- TUT7_VILLAGER_PRUNING
    [4537] = { walk = 33627, run = 33626, turnLeft = 33627, turnRight = 33627, walkLeft = 33627, walkRight = 33627, walkTurnLeft = 33627, walkTurnRight = 33627, idles = { { 34181, 90 }, { 34182, 10 } } },
    [4538] = { stand = 34184, walk = 34185, turnLeft = 34185, turnRight = 34185, walkLeft = 34185, walkRight = 34185, walkTurnLeft = 34185, walkTurnRight = 34185 },  -- EGWD_JAS_BOSS_KERAPAC_IDLE_STAFF
    [4539] = { idles = { { 18022, 100 }, { 18236, 40 } } },
    [4540] = { idles = { { 17981, 100 }, { 18245, 40 } } },
    [4541] = { idles = { { 17970, 100 }, { 18221, 40 } } },
    [4542] = { idles = { { 24429, 100 }, { 24431, 40 } } },
    [4543] = { idles = { { 16107, 100 }, { 34074, 40 } } },
    [4544] = { stand = 34086 },  -- SEREN_YAK_PLAYER_REST_LOOP
    [4545] = { walk = 33684, run = 33685, turnLeft = 33684, turnRight = 33684, walkTurnLeft = 33684, walkTurnRight = 33684, idles = { { 33680, 90 }, { 34078, 10 } } },
    [4546] = { walk = 33875, run = 33876, turnLeft = 33875, turnRight = 33875, walkBack = 33875, walkLeft = 33875, walkRight = 33875, walkTurnLeft = 33875, walkTurnRight = 33875, idles = { { 33873, 90 }, { 34092, 10 } } },
    [4547] = { walk = 34110, run = 34109, turnLeft = 34110, turnRight = 34110, walkLeft = 34110, walkRight = 34110, walkTurnLeft = 34110, walkTurnRight = 34110, idles = { { 34102, 90 }, { 34103, 10 } } },
    [4548] = { walk = 34119, run = 34120, turnLeft = 34119, turnRight = 34119, walkLeft = 34119, walkRight = 34119, walkTurnLeft = 34119, walkTurnRight = 34119, idles = { { 34117, 90 }, { 34118, 10 } } },
    [4549] = { walk = 32933, run = 34130, turnLeft = 32933, turnRight = 32933, walkLeft = 32933, walkRight = 32933, walkTurnLeft = 32933, walkTurnRight = 32933, idles = { { 32932, 90 }, { 34135, 10 } } },
    [4550] = { walk = 34147, run = 34146, turnLeft = 34147, turnRight = 34147, walkLeft = 34147, walkRight = 34147, walkTurnLeft = 34147, walkTurnRight = 34147, idles = { { 34144, 90 }, { 34145, 10 } } },
    [4551] = { stand = 34165 },  -- TUT7_PLAYER_SIT_ON_BENCH_IDLE
    [4552] = { stand = 34187, walk = 34188, turnLeft = 34188, turnRight = 34188, walkLeft = 34188, walkRight = 34188, walkTurnLeft = 34188, walkTurnRight = 34188 },  -- EGWD_JAS_BOSS_KERAPAC_FLYING_IDLE_STAFF
    [4553] = { walk = 34208, run = 34209, turnLeft = 34208, turnRight = 34208, walkLeft = 34208, walkRight = 34208, walkTurnLeft = 34208, walkTurnRight = 34208, idles = { { 34206, 90 }, { 34207, 10 } } },
    [4554] = { stand = 34224, walk = 34225, run = 34226, turnLeft = 34225, turnRight = 34225, walkLeft = 34225, walkRight = 34225, walkTurnLeft = 34225, walkTurnRight = 34225 },  -- EGWD_NODON_SLAYER_NODON_IDLE_STAFF
    [4555] = { stand = 34228, walk = 34229, turnLeft = 34229, turnRight = 34229, walkLeft = 34229, walkRight = 34229, walkTurnLeft = 34229, walkTurnRight = 34229 },  -- EGWD_NODON_SLAYER_NODON_FLYING_IDLE_STAFF
    [4556] = { stand = 34240 },  -- EGWD_NODON_SLAYER_CANNON_IDLE_DOWNED
    [4557] = { stand = 34241 },  -- EGWD_NODON_SLAYER_CANNON_IDLE
    [4558] = { stand = 34242, walk = 819, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- EGWD_PLAYER_LOOK_AROUND
    [4559] = { walk = 34253, run = 34252, turnLeft = 34253, turnRight = 34253, walkTurnLeft = 34253, walkTurnRight = 34253, idles = { { 34254, 90 }, { 34255, 10 } } },
    [4560] = { stand = 34271 },  -- EGWD_WEN_BOSS_GLACOR_IDLE
    [4561] = { stand = 34283 },  -- EGWD_WEN_BOSS_GLACOR_COLLAPSE_HEART_IDLE
    [4562] = { stand = 34284 },  -- EGWD_WEN_BOSS_GLACOR_CLAW_COLLAPSE_IDLE
    [4563] = { stand = 34285 },  -- EGWD_WEN_BOSS_GLACOR_CLAW_COLLAPSE_IDLE_GROUNDED
    [4564] = { stand = 34310, walk = 34310 },  -- EGWD_WEN_BOSS_GLACOR_ICE_BEAM_LOOP
    [4565] = { stand = 34324, walk = 34325, run = 34326, turnLeft = 34325, turnRight = 34325, walkLeft = 34325, walkRight = 34325, walkTurnLeft = 34325, walkTurnRight = 34325 },  -- EGWD_WEN_BOSS_PET_GLACOR_IDLE
    [4566] = { stand = 18038 },  -- COMBAT_2012_CASUAL_UNARMED_IDLE_FEMALE
    [4567] = { stand = 18019 },  -- COMBAT_2012_CASUAL_UNARMED_IDLE
    [4568] = { stand = 34337 },  -- EGWD_WEN_BOSS_HUMAN_MAGES_CHANNELING
    [4569] = { stand = 11013 },  -- MAH5_MAHJARATT_READY
    [4570] = { stand = 34336 },  -- EGWD_WEN_BOSS_MAHA_MAGES_CHANNELING
    [4571] = { stand = 34338, walk = 34339, run = 34340, turnLeft = 34339, turnRight = 34339, walkLeft = 34339, walkRight = 34339, walkTurnLeft = 34339, walkTurnRight = 34339 },  -- EGWD_WEN_SLAYER_GLACOR_IDLE
    [4572] = { stand = 34350, walk = 34351, run = 34351, turnLeft = 34351, turnRight = 34351, walkLeft = 34351, walkRight = 34351, walkTurnLeft = 34351, walkTurnRight = 34351 },  -- EGWD_WEN_SLAYER_GLACYTE_IDLE
    [4573] = { walk = 34414, run = 34415, turnLeft = 34412, turnRight = 34412, runTurnLeft = 34415, runTurnRight = 34415, walkTurnLeft = 34414, walkTurnRight = 34414, idles = { { 34412, 90 }, { 34413, 10 } } },
    [4574] = { stand = 34222 },  -- EGWD_JAS_BOSS_LIGHTNING_STRIKE_SPOTANIM_LOOPED
    [4575] = { idles = { { 34421, 77 }, { 34422, 10 }, { 34423, 13 } } },
    [4576] = { stand = 34435 },  -- EGWD_BIK_BOSS_CROESUS_SLIME_TRAP_IDLE
    [4577] = { stand = 34428 },  -- EGWD_BIK_BOSS_CROESUS_PRE_AWAKEN_IDLE
    [4578] = { walk = 34447, run = 34447, turnLeft = 34447, turnRight = 34447, walkLeft = 34447, walkRight = 34447, walkTurnLeft = 34447, walkTurnRight = 34447, idles = { { 34447, 90 }, { 34447, 10 } } },
    [4579] = { stand = 34444, walk = 34442, run = 34442, turnLeft = 34442, turnRight = 34442, walkLeft = 34442, walkRight = 34442, walkTurnLeft = 34442, walkTurnRight = 34442 },  -- EGWD_BIK_BOSS_SLIME_FUNGAL_IDLE
    [4580] = { walk = 25004, run = 10006, turnLeft = 10004, turnRight = 10004, walkLeft = 25004, walkRight = 25004, walkTurnLeft = 25004, walkTurnRight = 25004, idles = { { 10004, 90 }, { 10005, 10 } } },
    [4581] = { stand = 30146, walk = 30146 },  -- DRAGONRIDER_INJURED_IDLE_ABOVE_GROUND
    [4582] = { stand = 28291, walk = 28291 },  -- DRAGONRIDER_INJURED_IDLE
    [4583] = { stand = 34461 },  -- DRAGONRIDER_IDLE_HOLOGRAPHIC
    [4584] = { walk = 34478, run = 34479, turnLeft = 34478, turnRight = 34478, walkTurnLeft = 34478, walkTurnRight = 34478, idles = { { 34476, 90 }, { 34477, 10 } } },
    [4585] = { walk = 34489, turnLeft = 34489, turnRight = 34489, walkLeft = 34489, walkRight = 34489, walkTurnLeft = 34489, walkTurnRight = 34489, idles = { { 34487, 90 }, { 34488, 10 } } },
    [4586] = { idles = { { 34510, 90 }, { 34511, 5 }, { 34512, 5 } } },
    [4587] = { stand = 34491, run = 34492, runLeft = 34492, runRight = 34492, turnLeft = 34492, turnRight = 34492, runTurnLeft = 34492, runTurnRight = 34492 },  -- EGWD_FUL_BOSS_IDLE
    [4588] = { stand = 34509 },  -- EGWD_FUL_BOSS_DEFEATED_LOOP
    [4589] = { stand = 34519, walk = 34520, run = 34521, turnLeft = 34520, turnRight = 34520, walkLeft = 34520, walkRight = 34520, walkTurnLeft = 34520, walkTurnRight = 34520 },  -- EGWD_FUL_BOSS_PET_IDLE
    [4590] = { stand = 34547, walk = 29595, run = 29589, runBack = 29593, turnLeft = 29595, turnRight = 29595, walkBack = 29594 },  -- EGWD_ZOMBIE_IDLE_VAR_A
    [4591] = { stand = 34548, walk = 29595, run = 29589, runBack = 29593, turnLeft = 29595, turnRight = 29595, walkBack = 29594 },  -- EGWD_ZOMBIE_IDLE_VAR_B
    [4592] = { stand = 34549, walk = 29595, run = 29589, runBack = 29593, turnLeft = 29595, turnRight = 29595, walkBack = 29594 },  -- EGWD_ZOMBIE_IDLE_VAR_C
    [4593] = { stand = 23724 },  -- QUEST_BANDOS_CUTSCENE_GRAARDOR_DEFEATED_IDLE
    [4594] = { stand = 34564 },  -- XMAS_YAK_PLAYER_FEASTING_REST_NO_BEER_LOOP
    [4595] = { walk = 34574, run = 34573, turnLeft = 34574, turnRight = 34574, walkTurnLeft = 34574, walkTurnRight = 34574, idles = { { 34566, 90 }, { 34567, 10 } } },
    [4596] = { walk = 34584, run = 34583, turnLeft = 34584, turnRight = 34584, walkTurnLeft = 34584, walkTurnRight = 34584, idles = { { 34581, 90 }, { 34582, 10 } } },
    [4597] = { walk = 34590, run = 34589, turnLeft = 34590, turnRight = 34590, walkTurnLeft = 34590, walkTurnRight = 34590, idles = { { 34587, 90 }, { 34588, 10 } } },
    [4598] = { stand = 34266 },  -- MTX_AUG21_PLAYER_STORYTELLER_REST_LOOP
    [4599] = { stand = 34599, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- DUEL_ARENA_REMOVAL_WATER_FILTRATION_WATER_POURER_IDLE
    [4600] = { walk = 34603, turnLeft = 34602, turnRight = 34602, walkTurnLeft = 34603, walkTurnRight = 34603, idles = { { 34602, 90 }, { 34602, 10 } } },
    [4601] = { walk = 34607, turnLeft = 34606, turnRight = 34606, walkTurnLeft = 34607, walkTurnRight = 34607, idles = { { 34606, 90 }, { 34606, 10 } } },
    [4602] = { walk = 34611, run = 34612, turnLeft = 34611, turnRight = 34611, walkBack = 34611, walkLeft = 34611, walkRight = 34611, walkTurnLeft = 34611, walkTurnRight = 34611, idles = { { 34608, 90 }, { 34610, 10 } } },
    [4603] = { walk = 34611, run = 34612, turnLeft = 34611, turnRight = 34611, walkBack = 34611, walkLeft = 34611, walkRight = 34611, walkTurnLeft = 34611, walkTurnRight = 34611, idles = { { 34608, 90 }, { 34609, 10 } } },
    [4604] = { walk = 34622, run = 34622, turnLeft = 34622, turnRight = 34622, walkBack = 34622, walkLeft = 34622, walkRight = 34622, walkTurnLeft = 34622, walkTurnRight = 34622, idles = { { 34620, 90 }, { 34621, 10 } } },
    [4605] = { walk = 34630, turnLeft = 34630, turnRight = 34630, walkBack = 34630, walkLeft = 34630, walkRight = 34630, walkTurnLeft = 34630, walkTurnRight = 34630, idles = { { 34628, 90 }, { 34629, 10 } } },
    [4606] = { walk = 34642, turnLeft = 34642, turnRight = 34642, walkBack = 34642, walkLeft = 34642, walkRight = 34642, walkTurnLeft = 34642, walkTurnRight = 34642, idles = { { 34640, 90 }, { 34641, 10 } } },
    [4607] = { stand = 34657 },  -- ABYSSAL_LORD_MINION_IDLE
    [4608] = { walk = 34667, turnLeft = 34667, turnRight = 34667, walkBack = 34667, walkLeft = 34667, walkRight = 34667, walkTurnLeft = 34667, walkTurnRight = 34667, idles = { { 34665, 90 }, { 34666, 10 } } },
    [4609] = { walk = 34679, run = 34678, turnLeft = 34679, turnRight = 34679, walkLeft = 34679, walkRight = 34679, walkTurnLeft = 34679, walkTurnRight = 34679, idles = { { 34676, 90 }, { 34677, 10 } } },
    [4610] = { walk = 34688, run = 34689, turnLeft = 34688, turnRight = 34688, walkTurnLeft = 34688, walkTurnRight = 34688, idles = { { 34687, 90 }, { 34686, 10 } } },
    [4611] = { stand = 34697, walk = 34639, run = 34698, turnLeft = 34639, turnRight = 34639 },  -- TRH178_RICH_IDLE
    [4612] = { walk = 34701, run = 34702, turnLeft = 34701, turnRight = 34701, walkTurnLeft = 34701, walkTurnRight = 34701, idles = { { 34699, 90 }, { 34700, 10 } } },
    [4613] = { walk = 34719, run = 34718, turnLeft = 34719, turnRight = 34719, walkTurnLeft = 34719, walkTurnRight = 34719, idles = { { 34715, 90 }, { 34716, 10 } } },
    [4614] = { walk = 34726, run = 34725, turnLeft = 34726, turnRight = 34726, walkTurnLeft = 34726, walkTurnRight = 34726, idles = { { 34723, 90 }, { 34724, 10 } } },
    [4615] = { stand = 34736, walk = 34737, run = 34738, turnLeft = 34737, turnRight = 34737, walkLeft = 34737, walkRight = 34737, walkTurnLeft = 34737, walkTurnRight = 34737 },  -- ADRASTEIA_IDLE
    [4616] = { stand = 34739, walk = 34740, run = 34741, turnLeft = 34740, turnRight = 34740, walkLeft = 34740, walkRight = 34740, walkTurnLeft = 34740, walkTurnRight = 34740 },  -- MOIA_IDLE
    [4617] = { stand = 34745 },  -- QUEST_EGW_FINALE_MAH_PUPPET_IDLE
    [4618] = { stand = 34753 },  -- QUEST_EGW_FINALE_MAH_SLEEP_POSE
    [4619] = { stand = 34756 },  -- QUEST_EGW_FINALE_ELDER_GOD_EGGS_IDLE_OFFSET
    [4620] = { stand = 34742 },  -- QUEST_EGW_FINALE_SEREN_PUPPETEER_IDLE
    [4621] = { stand = 34743 },  -- QUEST_EGW_FINALE_SEREN_PUPPETEER_FRANTIC_IDLE
    [4622] = { stand = 34744 },  -- QUEST_EGW_FINALE_SEREN_SUMMONING
    [4623] = { stand = 34758 },  -- QUEST_EGW_FINALE_DRAGONRIDER_CHILLING_IN_TUB
    [4624] = { stand = 34759 },  -- QUEST_EGW_FINALE_DRAGONRIDER_MEDITATION_LOOP
    [4625] = { stand = 34762, walk = 34763, run = 34764, turnLeft = 34763, turnRight = 34763 },  -- EASTER22_PLAYER_HAMMER_OVERRIDE_IDLE
    [4626] = { walk = 34772, run = 34771, turnLeft = 34772, turnRight = 34772, walkTurnLeft = 34772, walkTurnRight = 34772, idles = { { 34769, 90 }, { 34770, 10 } } },
    [4627] = { stand = 34791 },  -- IAIA_TRACK_PLAYER_HOTSPRING_REST_LOOP
    [4628] = { walk = 34603, run = 34807, turnLeft = 34602, turnRight = 34602, walkTurnLeft = 34603, walkTurnRight = 34603, idles = { { 34602, 90 }, { 34806, 10 } } },
    [4629] = { walk = 34810, run = 34811, turnLeft = 34810, turnRight = 34810, walkBack = 34810, walkLeft = 34810, walkRight = 34810, walkTurnLeft = 34810, walkTurnRight = 34810, idles = { { 34808, 90 }, { 34809, 10 } } },
    [4630] = { stand = 29876, walk = 34821, run = 34822, turnLeft = 34821, turnRight = 34821, walkBack = 34821, walkLeft = 34821, walkRight = 34821, walkTurnLeft = 34821, walkTurnRight = 34821 },  -- DEMON_AVERNIC_IDLE
    [4631] = { stand = 34834 },  -- PRIDE_HOST_IDLE
    [4632] = { stand = 34894 },  -- ZAMORAK_CASTING_HEX_LOOP
    [4633] = { stand = 34911, walk = 34911, run = 34911, turnLeft = 34911, turnRight = 34911, walkBack = 34911, walkLeft = 34911, walkRight = 34911, walkTurnLeft = 34911, walkTurnRight = 34911 },  -- ZAMORAK_ATTACK_SPECIAL_DECIMATE_LOOP
    [4634] = { stand = 35562, walk = 35563, run = 35564, walkBack = 35563, walkLeft = 35563, walkRight = 35563 },  -- TRH189_PLAYER_BOULDER_IDLE_OVERRIDE
    [4635] = { stand = 34850, walk = 34851, turnLeft = 34851, turnRight = 34851, walkTurnLeft = 34851, walkTurnRight = 34851 },  -- FIEND_WATER_2022_IDLE
    [4636] = { stand = 34858, walk = 34859, turnLeft = 34859, turnRight = 34859, walkTurnLeft = 34859, walkTurnRight = 34859 },  -- FIEND_PYRE_ICE_2022_IDLE
    [4637] = { stand = 34869, walk = 34870, run = 34871, turnLeft = 34870, turnRight = 34870, walkBack = 34870, walkLeft = 34870, walkRight = 34870, walkTurnLeft = 34870, walkTurnRight = 34870 },  -- DEMON_AVERNIC_BOSS_PET_IDLE
    [4638] = { walk = 34887, run = 34886, turnLeft = 34887, turnRight = 34887, walkLeft = 34887, walkRight = 34887, walkTurnLeft = 34887, walkTurnRight = 34887, idles = { { 34881, 90 }, { 34882, 10 } } },
    [4639] = { stand = 34891, walk = 34892, run = 34893, turnLeft = 34892, turnRight = 34892, walkBack = 34892, walkLeft = 34892, walkRight = 34892, walkTurnLeft = 34892, walkTurnRight = 34892 },  -- ZAMORAK_IDLE
    [4640] = { walk = 34967, run = 34966, turnLeft = 34967, turnRight = 34967, walkLeft = 34967, walkRight = 34967, walkTurnLeft = 34967, walkTurnRight = 34967, idles = { { 34961, 90 }, { 34962, 10 } } },
    [4641] = { stand = 34981, walk = 21199, turnLeft = 21199, turnRight = 21199, walkTurnLeft = 21199, walkTurnRight = 21199 },  -- QUEST_DAUGHTER_DIV_WISP_IDLE
    [4642] = { stand = 34979, walk = 34740, run = 34741, turnLeft = 34740, turnRight = 34740, walkLeft = 34740, walkRight = 34740, walkTurnLeft = 34740, walkTurnRight = 34740 },  -- MOIA_COMBAT_IDLE
    [4643] = { stand = 34989, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- _300M_ACCOUNTS_PARTY_PETE_DANCE_IDLE
    [4644] = { walk = 35007, run = 35006, turnLeft = 35007, turnRight = 35007, walkBack = 35007, walkLeft = 35007, walkRight = 35007, walkTurnLeft = 35007, walkTurnRight = 35007, idles = { { 35005, 90 }, { 35004, 10 } } },
    [4645] = { walk = 35009, run = 35010, turnLeft = 35009, turnRight = 35009, walkBack = 35009, walkLeft = 35009, walkRight = 35009, walkTurnLeft = 35009, walkTurnRight = 35009, idles = { { 35013, 90 }, { 35014, 10 } } },
    [4646] = { walk = 35023, run = 35024, runLeft = 35024, runRight = 35024, turnLeft = 35023, turnRight = 35023, walkLeft = 35023, walkRight = 35023, walkTurnLeft = 35023, walkTurnRight = 35023, idles = { { 35025, 90 }, { 35026, 10 } } },
    [4647] = { walk = 35035, run = 35036, runLeft = 35036, runRight = 35036, turnLeft = 35035, turnRight = 35035, walkLeft = 35035, walkRight = 35035, walkTurnLeft = 35035, walkTurnRight = 35035, idles = { { 35037, 90 }, { 35038, 10 } } },
    [4648] = { walk = 35052, run = 35049, runLeft = 35049, runRight = 35049, turnLeft = 35052, turnRight = 35052, walkLeft = 35052, walkRight = 35052, walkTurnLeft = 35052, walkTurnRight = 35052, idles = { { 35046, 90 }, { 35047, 10 } } },
    [4649] = { walk = 35063, run = 35064, turnLeft = 35063, turnRight = 35063, walkBack = 35063, walkLeft = 35063, walkRight = 35063, walkTurnLeft = 35063, walkTurnRight = 35063, idles = { { 35058, 90 }, { 35059, 10 } } },
    [4650] = { stand = 35080, walk = 35081, run = 35082, turnLeft = 35081, turnRight = 35081, walkBack = 35081, walkLeft = 35081, walkRight = 35081, walkTurnLeft = 35081, walkTurnRight = 35081 },  -- HALLOWEEN22_PLAYER_GRIM_HARVEST_IDLE_OVERRIDE
    [4651] = { walk = 35093, run = 35092, turnLeft = 35093, turnRight = 35093, walkBack = 35093, walkLeft = 35093, walkRight = 35093, walkTurnLeft = 35093, walkTurnRight = 35093, idles = { { 35090, 90 }, { 35091, 10 } } },
    [4652] = { stand = 35105, walk = 35106, run = 35107 },  -- MTXDEC22_PLAYER_SNOWING_IDLE_OVERRIDE
    [4653] = { stand = 35109 },  -- ADRASTEIA_SINGING_IDLE
    [4654] = { stand = 35111 },  -- ADRASTEIA_STUDYING
    [4655] = { stand = 26122, walk = 26119, turnLeft = 26119, turnRight = 26119 },  -- Q200_CITIZEN_ZOMBIE_SCARED_IDLE
    [4656] = { stand = 21746, walk = 27099, turnLeft = 27099, turnRight = 27099 },  -- SLISKE1_MONK_SCARED_IDLE
    [4657] = { stand = 27100, walk = 27099, turnLeft = 27099, turnRight = 27099 },  -- MTX_ATS_PLAYER_SAD_IDLE
    [4658] = { stand = 25993, walk = 29706, run = 29723, turnLeft = 25993, turnRight = 25993, walkLeft = 29706, walkRight = 29706, walkTurnLeft = 29706, walkTurnRight = 29706 },  -- Q200_ZEMOUREGAL_IDLE
    [4659] = { walk = 35118, run = 35119, turnLeft = 35118, turnRight = 35118, walkBack = 35118, walkLeft = 35118, walkRight = 35118, walkTurnLeft = 35118, walkTurnRight = 35118, idles = { { 35120, 90 }, { 35121, 10 } } },
    [4660] = { stand = 35136, walk = 35137, run = 35138 },  -- TRH177_PLAYER_ROSE_PETAL_IDLE_OVERRIDE
    [4661] = { stand = 35565, walk = 35567, run = 35566, turnLeft = 35567, turnRight = 35567, walkBack = 35567, walkLeft = 35567, walkRight = 35567, walkTurnLeft = 35567, walkTurnRight = 35567 },  -- BOULDER_PET_IDLE
    [4662] = { walk = 35150, run = 35147, turnLeft = 35145, turnRight = 35145, walkBack = 35150, walkLeft = 35150, walkRight = 35150, idles = { { 35145, 90 }, { 35146, 10 } } },
    [4663] = { stand = 35163, walk = 35158, run = 35159, turnLeft = 35158, turnRight = 35158, walkBack = 35158, walkLeft = 35158, walkRight = 35158 },  -- CONSTRUCTION_YAK_IDLE
    [4664] = { stand = 35165, walk = 35165 },  -- DARK_BEAST_2022_DEATH_POSE
    [4665] = { stand = 25942 },  -- SLISKE2_PLAYER_KNEEL_AND_LOOP
    [4666] = { stand = 6788 },  -- CLAN_CHAIR_SIT_READY
    [4667] = { stand = 6788 },  -- CLAN_CHAIR_SIT_READY
    [4668] = { stand = 6788 },  -- CLAN_CHAIR_SIT_READY
    [4669] = { stand = 6788 },  -- CLAN_CHAIR_SIT_READY
    [4670] = { stand = 6788 },  -- CLAN_CHAIR_SIT_READY
    [4671] = { stand = 6788 },  -- CLAN_CHAIR_SIT_READY
    [4672] = { stand = 6788 },  -- CLAN_CHAIR_SIT_READY
    [4673] = { walk = 27109, run = 27110, idles = { { 27111, 10 }, { 18038, 90 } } },
    [4674] = { stand = 23434, walk = 27109, run = 27110 },  -- ASH1_2014_LUCY_HAPPY_IDLE
    [4675] = { stand = 6813, walk = 6819, run = 6819 },  -- DUCK_REWORK_LAND_READY_EXTRA
    [4676] = { stand = 35168, walk = 18016, run = 18017, turnLeft = 18016, turnRight = 18016 },  -- COMBAT_2023_CASUAL_WHIP_ANIMATED_IDLE
    [4677] = { stand = 35194, walk = 35195, run = 35196, turnLeft = 35195, turnRight = 35195 },  -- FORT_SLAYER_PHANTOM_HALBERD_READY
    [4678] = { stand = 35198, walk = 35199, run = 35200, turnLeft = 35199, turnRight = 35199 },  -- FORT_SLAYER_PHANTOM_TWO_HANDED_SWORD_READY
    [4679] = { stand = 17996, walk = 35201, run = 35202, turnLeft = 17996, turnRight = 17996 },  -- COMBAT_2012_CASUAL_TWO_HANDED_SWORD_IDLE
    [4680] = { stand = 35194, walk = 35195, run = 35197, turnLeft = 35195, turnRight = 35195 },  -- FORT_SLAYER_PHANTOM_HALBERD_READY
    [4681] = { walk = 35220, run = 35215, turnLeft = 35220, turnRight = 35220, walkLeft = 35220, walkRight = 35220, walkTurnLeft = 35220, walkTurnRight = 35220, idles = { { 35213, 90 }, { 35214, 10 } } },
    [4682] = { walk = 35244, run = 35239, turnLeft = 35244, turnRight = 35244, walkLeft = 35244, walkRight = 35244, walkTurnLeft = 35244, walkTurnRight = 35244, idles = { { 35237, 90 }, { 35238, 10 } } },
    [4683] = { walk = 35226, run = 35225, turnLeft = 35226, turnRight = 35226, walkLeft = 35226, walkRight = 35226, walkTurnLeft = 35226, walkTurnRight = 35226, idles = { { 35237, 90 }, { 35238, 10 } } },
    [4684] = { walk = 35226, run = 35225, turnLeft = 35226, turnRight = 35226, walkLeft = 35226, walkRight = 35226, walkTurnLeft = 35226, walkTurnRight = 35226, idles = { { 35237, 90 }, { 35238, 10 } } },
    [4685] = { walk = 1306, run = 35255, turnLeft = 1306, turnRight = 1306, walkLeft = 1306, walkRight = 1306, walkTurnLeft = 1306, walkTurnRight = 1306, idles = { { 35252, 90 }, { 35253, 10 } } },
    [4686] = { walk = 35270, run = 35267, turnLeft = 35270, turnRight = 35270, walkLeft = 35270, walkRight = 35270, walkTurnLeft = 35270, walkTurnRight = 35270, idles = { { 35264, 90 }, { 35265, 10 } } },
    [4687] = { walk = 35277, run = 35278, turnLeft = 35277, turnRight = 35277, runTurnLeft = 35278, runTurnRight = 35278, walkTurnLeft = 35277, walkTurnRight = 35277, idles = { { 33036, 90 }, { 33037, 10 } } },
    [4688] = { stand = 35288, walk = 35289, run = 35290, turnLeft = 35289, turnRight = 35289 },  -- TRH192_LOOTING_RANGE_IDLE
    [4689] = { stand = 4330, walk = 4343, run = 4362, turnLeft = 4343, turnRight = 4343, walkLeft = 4343, walkRight = 4343, walkTurnLeft = 4343, walkTurnRight = 4343 },  -- QUEEN_ELLAMARIA_IDLE
    [4690] = { stand = 4376, walk = 15868, turnLeft = 4376, turnRight = 4376, walkLeft = 15868, walkRight = 15868 },  -- OMGE_CHILD_READY_NO_IDLE_EXTRA
    [4691] = { walk = 23891, walkTurnLeft = 23891, walkTurnRight = 23891, idles = { { 23891, 200 }, { 23893, 100 }, { 23894, 50 } } },
    [4692] = { stand = 21106, walk = 21106, walkTurnLeft = 21106, walkTurnRight = 21106 },  -- OWEN1_BLACK_KNIGHT_DEATH_VAR_A_NULL
    [4693] = { stand = 20168 },  -- MTX32_PLAYER_DEATH_FIRE
    [4694] = { stand = 18019, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- COMBAT_2012_CASUAL_UNARMED_IDLE
    [4695] = { stand = 18038, walk = 18040, run = 18039, turnLeft = 18040, turnRight = 18040 },  -- COMBAT_2012_CASUAL_UNARMED_IDLE_FEMALE
    [4696] = { walk = 20828, run = 20829, turnLeft = 20828, turnRight = 20828, walkTurnLeft = 20828, walkTurnRight = 20828, idles = { { 20827, 90 }, { 34078, 10 } } },
    [4697] = { walk = 20937, run = 20942, turnLeft = 20937, turnRight = 20937, walkLeft = 20937, walkRight = 20937, walkTurnLeft = 20937, walkTurnRight = 20937, idles = { { 20830, 95 }, { 20831, 5 } } },
    [4698] = { stand = 20830, walk = 20937, run = 20942, turnLeft = 20937, turnRight = 20937, walkLeft = 20937, walkRight = 20937, walkTurnLeft = 20937, walkTurnRight = 20937 },  -- HERMOD_IDLE
    [4699] = { stand = 21659 },  -- HERMOD_SWORD_IDLE
    [4700] = { idles = { { 21659, 155 }, { 21660, 100 } } },
    [4701] = { walk = 25166, run = 25171, turnLeft = 25166, turnRight = 25166, walkLeft = 25166, walkRight = 25166, walkTurnLeft = 25166, walkTurnRight = 25166, idles = { { 21661, 95 }, { 25060, 5 } } },
    [4702] = { walk = 35220, run = 35215, turnLeft = 35220, turnRight = 35220, walkLeft = 35220, walkRight = 35220, walkTurnLeft = 35220, walkTurnRight = 35220, idles = { { 35213, 90 }, { 28347, 10 } } },
    [4703] = { stand = 35213, walk = 35220, run = 35215, turnLeft = 35220, turnRight = 35220, walkLeft = 35220, walkRight = 35220, walkTurnLeft = 35220, walkTurnRight = 35220 },  -- HUMAN_SKELETON_IDLE
    [4704] = { stand = 28371, walk = 28371 },  -- HUMAN_SKELETON_PLAYING_TRUMPET
    [4705] = { stand = 28372, walk = 28372 },  -- HUMAN_SKELETON_PLAYING_TRUMPET_SOMBRE
    [4706] = { walk = 28371, idles = { { 28371, 128 }, { 28372, 127 } } },
    [4707] = { stand = 35252, walk = 1306, run = 35255, turnLeft = 1306, turnRight = 1306, walkLeft = 1306, walkRight = 1306, walkTurnLeft = 1306, walkTurnRight = 1306 },  -- HUMAN_ZOMBIE_IDLE
    [4708] = { stand = 35406, walk = 35406 },  -- HUMAN_ZOMBIE_PLAYING_PIANO
    [4709] = { stand = 35407, walk = 35407 },  -- HUMAN_ZOMBIE_PLAYING_PIANO_SOMBRE
    [4710] = { walk = 35406, idles = { { 35406, 128 }, { 35407, 127 } } },
    [4711] = { stand = 35409, walk = 35411, turnLeft = 35411, turnRight = 35411, walkBack = 35411, walkLeft = 35411, walkRight = 35411, walkTurnLeft = 35411, walkTurnRight = 35411 },  -- RAT_CRITTER_IDLE
    [4712] = { stand = 9804 },  -- HUMAN_UPDATE_CHATHEAD_NEUTRAL_IDLE
    [4713] = { idles = { { 9807, 25 }, { 9808, 25 }, { 9809, 25 }, { 9810, 25 } } },
    [4714] = { idles = { { 9785, 25 }, { 9786, 25 }, { 9787, 25 }, { 9788, 25 } } },
    [4715] = { idles = { { 9746, 25 }, { 9747, 25 }, { 9748, 25 }, { 9749, 25 } } },
    [4716] = { idles = { { 9811, 25 }, { 9812, 25 }, { 9813, 25 }, { 9814, 25 } } },
    [4717] = { stand = 9840 },  -- HUMAN_UPDATE_CHATHEAD_LAUGH_SUBTLE_LEN_ALL
    [4718] = { stand = 9842 },  -- HUMAN_UPDATE_CHATHEAD_EVIL_LAUGH_LEN_ALL
    [4719] = { idles = { { 9836, 25 }, { 9837, 25 }, { 9838, 25 }, { 9839, 25 } } },
    [4720] = { stand = 30007 },  -- QUEST_ENDGAME_MAZE_FLOATING_OBELISK
    [4721] = { stand = 25815 },  -- SLISKE2_LORD_DAQUARIUS_TAKEN_DOWN_BY_SLISKE
    [4722] = { stand = 32056 },  -- MTXBEACH18_COCKTAIL_FLARING_REST_LOOP_SPOTANIM
    [4723] = { walk = 35435, run = 35435, turnLeft = 35435, turnRight = 35435, walkTurnLeft = 35435, walkTurnRight = 35435, idles = { { 35435, 90 }, { 35436, 10 }, { 35437, 5 } } },
    [4724] = { stand = 35441, walk = 35441 },  -- DRUM_PLAYING_IDLE
    [4725] = { stand = 35442, walk = 35442 },  -- DRUM_PLAYING_SOMBRE_IDLE
    [4726] = { stand = 35525 },  -- NECRO_RITUALS_RANDOM_EVENTS_SPARKLING_GLYPH_SPOTANIM
    [4727] = { stand = 35526 },  -- NECRO_RITUALS_RANDOM_EVENTS_SOUL_STORM_SPOTANIM
    [4728] = { stand = 34039, walk = 35559, run = 35560, walkLeft = 35559, walkRight = 35559 },  -- TROLL_2021_IDLE
    [4729] = { stand = 35566 },  -- BOULDER_PET_RUN
    [4730] = { stand = 35574, walk = 35575, run = 35576, turnLeft = 35575, turnRight = 35575 },  -- MTXAUG23_ASSASSINS_RETURN_UNARMED_IDLE
    [4731] = { stand = 35579, walk = 35578, run = 35577, turnLeft = 35578, turnRight = 35578 },  -- MTXAUG23_ASSASSINS_RETURN_ARMED_IDLE
    [4732] = { stand = 35611 },  -- DRAGON_BOSS_VORKATH_FROZEN_DEATH_IDLE
    [4733] = { idles = { { 35609, 90 }, { 35610, 10 } } },
    [4734] = { walk = 35622, turnLeft = 35622, turnRight = 35622, walkLeft = 35622, walkRight = 35622, walkTurnLeft = 35622, walkTurnRight = 35622, idles = { { 35619, 90 }, { 35620, 10 } } },
    [4735] = { stand = 35719 },  -- PLAYER_2014_POH_BUILD_FLOOR_SC_REWARD_HAMMER_RANGED_SFX
    [4736] = { stand = 35720 },  -- PLAYER_2014_POH_BUILD_WALL_RANGED_SFX
    [4737] = { walk = 35688, run = 35686, turnLeft = 35688, turnRight = 35688, walkBack = 35688, walkLeft = 35688, walkRight = 35688, walkTurnLeft = 35688, walkTurnRight = 35688, idles = { { 35684, 90 }, { 35685, 10 } } },
    [4738] = { stand = 35609, walk = 35691, crawl = 35690, run = 35692, turnLeft = 35691, turnRight = 35691, walkBack = 35691, walkLeft = 35691, walkRight = 35691, walkTurnLeft = 35691, walkTurnRight = 35691 },  -- DRAGON_BOSS_VORKATH_IDLE
    [4739] = { walk = 35730, run = 35727, turnLeft = 35730, turnRight = 35730, runTurnLeft = 35727, runTurnRight = 35727, walkTurnLeft = 35730, walkTurnRight = 35730, idles = { { 35731, 90 }, { 35725, 10 } } },
    [4740] = { walk = 35734, run = 35735, turnLeft = 35734, turnRight = 35734, walkBack = 35734, walkLeft = 35734, walkRight = 35734, walkTurnLeft = 35734, walkTurnRight = 35734, idles = { { 33763, 90 }, { 35733, 10 } } },
    [4741] = { stand = 33795, walk = 33797, run = 33798 },  -- COAL_PET_IDLE
    [4742] = { stand = 11502, walk = 31523, turnLeft = 11502, turnRight = 11502, walkBack = 31523, walkLeft = 31523, walkRight = 31523 },  -- EASTER09_EASTER_BUNNY_READY
    [4743] = { walk = 35799, run = 35800, walkBack = 35799, walkLeft = 35799, walkRight = 35799, idles = { { 35801, 90 }, { 35802, 10 } } },
    [4744] = { idles = { { 35812, 90 }, { 35813, 5 }, { 35814, 10 }, { 35815, 10 } } },
    [4745] = { stand = 35811 },  -- DRAGON_BOSS_VORKATH_DEATH_IDLE
    [4746] = { stand = 35820 },  -- QUEST_VORKATH_XAUTAK_FOCUS_IDLE
    [4747] = { walk = 35839, run = 35822, runLeft = 35822, runRight = 35822, turnLeft = 35822, turnRight = 35822, walkLeft = 35839, walkRight = 35839, runTurnLeft = 35822, runTurnRight = 35822, walkTurnLeft = 35839, walkTurnRight = 35839, idles = { { 20093, 90 }, { 20095, 10 } } },
    [4748] = { walk = 35825, run = 35826, runLeft = 35826, runRight = 35826, turnLeft = 35825, turnRight = 35825, walkLeft = 35825, walkRight = 35825, runTurnLeft = 35826, runTurnRight = 35826, walkTurnLeft = 35825, walkTurnRight = 35825, idles = { { 33966, 90 }, { 35824, 10 } } },
    [4749] = { stand = 21765, walk = 18020 },  -- SLISKE1_BANDOS_SMALL_IDLE
    [4750] = { walk = 35852, run = 35853, turnLeft = 35852, turnRight = 35852, walkLeft = 35852, walkRight = 35852, walkTurnLeft = 35852, walkTurnRight = 35852, idles = { { 35850, 90 }, { 35851, 10 } } },
    [4751] = { walk = 35865, run = 35864, turnLeft = 35865, turnRight = 35865, walkLeft = 35865, walkRight = 35865, walkTurnLeft = 35865, walkTurnRight = 35865, idles = { { 35866, 90 }, { 35867, 10 } } },
    [4752] = { stand = 35979, walk = 35979, run = 35979, turnLeft = 35979, turnRight = 35979 },  -- BEACH24_BOSS_PET_IDLE
    [4753] = { stand = 18860 },  -- ARIANE2_ARIANE_FLOATING_IN_THE_BEAM_LOOP
    [4754] = { stand = 35988 },  -- RAID_REBIRTH1_SLAYER_MASTER_BOSS_IDLE
    [4755] = { stand = 35993 },  -- RAID_REBIRTH1_OBELISK_IDLE
    [4756] = { idles = { { 36019, 70 }, { 36019, 30 } } },
    [4757] = { walk = 33684, run = 33685, turnLeft = 33684, turnRight = 33684, walkTurnLeft = 33684, walkTurnRight = 33684, idles = { { 36061, 90 }, { 36062, 10 } } },
    [4758] = { stand = 36047, run = 36041, turnLeft = 36041, turnRight = 36041 },  -- RAID_REBIRTH1_HELLHOUND_MINION_IDLE
    [4759] = { stand = 36088, walk = 36086, run = 36087, turnLeft = 36087, turnRight = 36087, walkLeft = 36086, walkRight = 36086, walkTurnLeft = 36086, walkTurnRight = 36086 },  -- HELLHOUND_REVENANT_BOSS_PET_IDLE
    [4760] = { stand = 36025, walk = 36026, run = 36027, turnLeft = 36026, turnRight = 36026, walkBack = 36026, walkLeft = 36026, walkRight = 36026, walkTurnLeft = 36026, walkTurnRight = 36026 },  -- RAID_REBIRTH1_DARK_BEAST_BOSS_IDLE
    [4761] = { stand = 24192, walk = 24191, turnLeft = 24194, turnRight = 24194 },  -- OGE_2014_LUMBRIDGE_GUARD_IDLE
    [4762] = { stand = 36204, walk = 36205, run = 36207, turnLeft = 36205, turnRight = 36205, walkBack = 36206, walkLeft = 36205, walkRight = 36205 },  -- HUMAN_ACTOR_COMBAT_SWORD_SHIELD_IDLE
    [4763] = { stand = 36204, walk = 36210, run = 36212, turnLeft = 36210, turnRight = 36210, walkBack = 36211, walkLeft = 36210, walkRight = 36210 },  -- HUMAN_ACTOR_COMBAT_SWORD_SHIELD_IDLE
    [4764] = { stand = 36227, walk = 36227, run = 36227, turnLeft = 36227, turnRight = 36227, walkLeft = 36227, walkRight = 36227, walkTurnLeft = 36227, walkTurnRight = 36227 },  -- ELIDINIS_BOSS_PLAYER_AGILITY_SLAM_PILLAR_WOBBLE
    [4765] = { stand = 36228, walk = 36228, run = 36228, turnLeft = 36228, turnRight = 36228, walkLeft = 36228, walkRight = 36228, walkTurnLeft = 36228, walkTurnRight = 36228 },  -- ELIDINIS_BOSS_IDLE
    [4766] = { stand = 36234, walk = 36234, run = 36234, turnLeft = 36234, turnRight = 36234, walkLeft = 36234, walkRight = 36234, walkTurnLeft = 36234, walkTurnRight = 36234 },  -- ELIDINIS_BOSS_SPECIAL_ATTACK_RAISING_THE_ROCK_LOOP
    [4767] = { stand = 36237, walk = 36237, run = 36237, turnLeft = 36237, turnRight = 36237, walkLeft = 36237, walkRight = 36237, walkTurnLeft = 36237, walkTurnRight = 36237 },  -- ELIDINIS_BOSS_REPAIRED_STATE
    [4768] = { stand = 36238, walk = 36239, run = 36240, turnLeft = 36239, turnRight = 36239, walkLeft = 36239, walkRight = 36239, walkTurnLeft = 36239, walkTurnRight = 36239 },  -- ELIDINIS_BOSS_PET_IDLE
    [4769] = { stand = 31189 },  -- HW17_DEAD_POSE_A
    [4770] = { stand = 36251, walk = 36252, run = 36253, turnLeft = 36252, turnRight = 36252, walkTurnLeft = 36252, walkTurnRight = 36252 },  -- QUEST_AMASCUT_ZEMOUREGAL_CUFFED_IDLE
    [4771] = { crawl = 36287, idles = { { 36294, 80 }, { 36293, 20 } } },
    [4772] = { walk = 36285, run = 36286, turnLeft = 36285, turnRight = 36285, walkLeft = 36285, walkRight = 36285, walkTurnLeft = 36285, walkTurnRight = 36285, idles = { { 16430, 60 }, { 36294, 20 }, { 36293, 20 } } },
    [4773] = { walk = 36301, run = 36302, turnLeft = 36301, turnRight = 36301, walkBack = 36301, walkLeft = 36301, walkRight = 36301, walkTurnLeft = 36301, walkTurnRight = 36301, idles = { { 36297, 90 }, { 36298, 10 } } },
    [4774] = { walk = 36358, run = 36359, runBack = 36359, runLeft = 36359, runRight = 36359, turnLeft = 36358, turnRight = 36358, walkBack = 36358, walkLeft = 36358, walkRight = 36358, idles = { { 36360, 70 }, { 36361, 30 } } },
    [4775] = { walk = 36375, run = 36376, turnLeft = 36375, turnRight = 36375, walkBack = 36375, walkLeft = 36375, walkRight = 36375, walkTurnLeft = 36375, walkTurnRight = 36375, idles = { { 36370, 90 }, { 36371, 10 } } },
    [4776] = { stand = 36404 },  -- VARROCK_GRANNY_ROCKING_UPDATE_24
    [4777] = { idles = { { 36397, 185 }, { 36398, 70 } } },
    [4778] = { idles = { { 36397, 185 }, { 36398, 70 } } },
    [4779] = { walk = 6689, crawl = 6688, crawlBack = 6688, crawlLeft = 6688, crawlRight = 6688, run = 21673, runBack = 21673, runLeft = 21673, runRight = 21673, walkBack = 6689, walkLeft = 6689, walkRight = 6689, idles = { { 6686, 90 }, { 6687, 10 } } },
    [4780] = { stand = 36573, walk = 36575, run = 36574, turnLeft = 36575, turnRight = 36575, walkBack = 36575, walkLeft = 36575, walkRight = 36575, walkTurnLeft = 36575, walkTurnRight = 36575 },  -- XMAS24_SNOWBALL_PET_IDLE
    [4781] = { stand = 36582, walk = 36582, run = 36583, turnLeft = 36582, turnRight = 36582, walkTurnLeft = 36582, walkTurnRight = 36582 },  -- BEETLE_FLYING_IDLE
    [4782] = { idles = { { 36586, 95 }, { 36587, 5 } } },
    [4783] = { walk = 36591, turnLeft = 36591, turnRight = 36591, walkBack = 36591, walkLeft = 36591, walkRight = 36591, idles = { { 36588, 90 }, { 36589, 5 }, { 36589, 10 } } },
    [4784] = { walk = 36596, run = 36597, runBack = 36597, runLeft = 36597, runRight = 36597, turnLeft = 36596, turnRight = 36596, walkBack = 36596, walkLeft = 36596, walkRight = 36596, idles = { { 36360, 70 }, { 36361, 30 } } },
    [4785] = { stand = 36686, walk = 36688, run = 36690, turnLeft = 36692, turnRight = 36692, walkBack = 36688, walkLeft = 36692, walkRight = 36692, walkTurnLeft = 36688, walkTurnRight = 36688 },  -- APRIL_FOOLS25_ROCKING_HORSE_IDLE
    [4786] = { stand = 808, walk = 17689, turnLeft = 823, turnRight = 823, walkBack = 17689, walkLeft = 17689, walkRight = 17689 },  -- HUMAN_READY
    [4787] = { stand = 808, walk = 17688, turnLeft = 823, turnRight = 823, walkBack = 17688, walkLeft = 17688, walkRight = 17688 },  -- HUMAN_READY
    [4788] = { stand = 34762, walk = 36697, run = 36697 },  -- EASTER22_PLAYER_HAMMER_OVERRIDE_IDLE
    [4789] = { stand = 34762, walk = 36698, run = 36698 },  -- EASTER22_PLAYER_HAMMER_OVERRIDE_IDLE
    [4790] = { stand = 18023, walk = 36701, run = 36702, turnLeft = 36701, turnRight = 36701 },  -- COMBAT_2012_CASUAL_SPEAR_IDLE
    [4791] = { stand = 36723, walk = 36724, run = 36725 },  -- INSECT_FLYING_WASP_IDLE
    [4792] = { walk = 32729, turnLeft = 32729, turnRight = 32729, walkLeft = 32729, walkRight = 32729, walkTurnLeft = 32729, walkTurnRight = 32729, idles = { { 36730, 90 }, { 32725, 10 } } },
    [4793] = { walk = 36733, run = 36734, turnLeft = 36733, turnRight = 36733, walkBack = 36733, walkLeft = 36733, walkRight = 36733, walkTurnLeft = 36733, walkTurnRight = 36733, idles = { { 36731, 90 }, { 36732, 10 } } },
    [4794] = { stand = 36735, walk = 36736, turnLeft = 36736, turnRight = 36736, walkBack = 36736, walkLeft = 36736, walkRight = 36736, walkTurnLeft = 36736, walkTurnRight = 36736 },  -- BIRD_DUCKLING_SWIMMING_IDLE
    [4795] = { walk = 36744, crawl = 36743, crawlLeft = 36743, crawlRight = 36743, run = 36745, runBack = 36745, runLeft = 36745, runRight = 36745, turnLeft = 36743, turnRight = 36743, walkLeft = 36744, walkRight = 36744, crawlTurnLeft = 36743, crawlTurnRight = 36743, walkTurnLeft = 36744, walkTurnRight = 36744, idles = { { 36741, 70 }, { 36742, 30 } } },
    [4796] = { stand = 36772, walk = 36773, run = 36774 },  -- HUMAN_ACTOR_CASUAL_SIDE_SADDLE_STAFF_IDLE
    [4797] = { stand = 36775, walk = 36776, run = 36777 },  -- HUMAN_ACTOR_CASUAL_SIDE_SADDLE_STAFF_IDLE_REPLACEHELD
    [4798] = { stand = 5839, walk = 36766 },  -- TOL_FROGEEL_READY
    [4799] = { stand = 36767, walk = 7259, run = 2812 },  -- INVIGILATOAD_TOAD_READY
    [4800] = { walk = 36758, turnLeft = 36758, turnRight = 36758, walkLeft = 36758, walkRight = 36758, walkTurnLeft = 36758, walkTurnRight = 36758, idles = { { 36759, 90 }, { 36760, 10 } } },
    [4801] = { walk = 36755, walkLeft = 36755, walkRight = 36755, walkTurnLeft = 36755, walkTurnRight = 36755, idles = { { 36756, 90 }, { 36757, 10 } } },
    [4802] = { stand = 36844 },  -- TUMEKEN_IDLE
    [4803] = { stand = 36845, walk = 36849, crawl = 36847, crawlBack = 36847, crawlLeft = 36847, crawlRight = 36847, run = 36848, runBack = 36848, runLeft = 36848, runRight = 36848, turnLeft = 36849, turnRight = 36849, walkBack = 36849, walkLeft = 36849, walkRight = 36849 },  -- AMASCUT_IDLE
    [4804] = { stand = 36845, walk = 36849, crawl = 36847, crawlBack = 36847, crawlLeft = 36847, crawlRight = 36847, run = 36848, runBack = 36848, runLeft = 36848, runRight = 36848, walkBack = 36849, walkLeft = 36849, walkRight = 36849 },  -- AMASCUT_IDLE
    [4805] = { stand = 36850, turnLeft = 36850, turnRight = 36850 },  -- AMASCUT_COMBAT_IDLE
    [4806] = { stand = 36846 },  -- AMASCUT_FROZEN_POSE
    [4807] = { stand = 36857, turnLeft = 36857, turnRight = 36857 },  -- AMASCUT_BOSS_IDLE
    [4808] = { stand = 36879, turnLeft = 36879, turnRight = 36879 },  -- AMASCUT_BOSS_DEATH_IDLE
    [4809] = { stand = 36881, walk = 36882, run = 36883, turnLeft = 36882, turnRight = 36882, walkBack = 36882, walkLeft = 36882, walkRight = 36882, walkTurnLeft = 36882, walkTurnRight = 36882 },  -- AMASCUT_PET_IDLE
    [4810] = { stand = 36888, walk = 36890, run = 36891, turnLeft = 36890, turnRight = 36890, walkBack = 36890, walkLeft = 36890, walkRight = 36890, walkTurnLeft = 36890, walkTurnRight = 36890 },  -- APMEKEN_IDLE
    [4811] = { stand = 36889 },  -- APMEKEN_FROZEN_POSE
    [4812] = { stand = 36892, walk = 36893, run = 36894, turnLeft = 36893, turnRight = 36893, walkBack = 36893, walkLeft = 36893, walkRight = 36893, walkTurnLeft = 36893, walkTurnRight = 36893 },  -- APMEKEN_COMBAT_IDLE
    [4813] = { stand = 36898 },  -- SCABARITE_SCABARAS_FROZEN_POSE
    [4814] = { stand = 36900, walk = 36900 },  -- QUEST_DESERT_FINALE_ICTHLARIN_DEATH_LOOP
    [4815] = { stand = 18015, walk = 36909, run = 36910, turnLeft = 36909, turnRight = 36909 },  -- COMBAT_2012_CASUAL_ARMED_IDLE
    [4816] = { stand = 18023, walk = 30848, run = 20973, turnLeft = 30848, turnRight = 30848 },  -- COMBAT_2012_CASUAL_SPEAR_IDLE
    [4817] = { stand = 29936 },  -- QUEST_ENDGAME_ICTHLARIN_BEAST_IDLE
    [4818] = { stand = 36905 },  -- DQ3_ICTHLARIN_FROZEN_POSE
    [4819] = { stand = 36906 },  -- DQ3_CRONDIS_FROZEN_POSE
    [4820] = { stand = 36907 },  -- DQ3_LEELA_FROZEN_POSE
    [4821] = { stand = 36908 },  -- DQ3_HET_FROZEN_POSE
    [4822] = { walk = 36955, run = 36953, turnLeft = 36955, turnRight = 36955, walkBack = 36955, walkLeft = 36955, walkRight = 36955, walkTurnLeft = 36955, walkTurnRight = 36955, idles = { { 36950, 90 }, { 36949, 10 } } },
    [4823] = { idles = { { 36964, 90 }, { 36965, 10 } } },
    [4824] = { walk = 37024, run = 37025, turnLeft = 37021, turnRight = 37021, walkTurnLeft = 37024, walkTurnRight = 37024, idles = { { 37021, 90 }, { 37023, 10 } } },
    [4825] = { walk = 37052, run = 37049, turnLeft = 37052, turnRight = 37052, walkLeft = 37052, walkRight = 37052, walkTurnLeft = 37052, walkTurnRight = 37052, idles = { { 37047, 90 }, { 37048, 10 } } },
    [4826] = { stand = 37053, walk = 37054, run = 37055 },  -- HUMAN_ACTOR_CASUAL_GRIM_HARVEST_IDLE
    [4827] = { walk = 37082, run = 37079, turnLeft = 37077, turnRight = 37077, walkTurnLeft = 37082, walkTurnRight = 37082, idles = { { 37077, 90 }, { 37078, 10 } } },
    [4828] = { stand = 37111, walk = 819 },  -- HUMAN_ACTOR_REST_RELIC_MEDITATE_LOOP
    [4829] = { walk = 37116, run = 37117, turnLeft = 37116, turnRight = 37116, walkLeft = 37116, walkRight = 37116, walkTurnLeft = 37116, walkTurnRight = 37116, idles = { { 37113, 90 }, { 37114, 10 } } },
    [4830] = { stand = 37135, walk = 37136, run = 37137, walkBack = 37136, walkLeft = 37136, walkRight = 37136, walkTurnLeft = 37136, walkTurnRight = 37136 },  -- HEIST_DRAGONKIN_CARRY_TABLET_IDLE
    [4831] = { stand = 18055, walk = 37147, run = 37148, turnLeft = 37147, turnRight = 37147 },  -- COMBAT_2012_CASUAL_SHIELD_IDLE
    [4832] = { stand = 18019, walk = 37149, run = 37150, turnLeft = 37149, turnRight = 37149 },  -- COMBAT_2012_CASUAL_UNARMED_IDLE
    [4833] = { walk = 37178, run = 37179, turnLeft = 37178, turnRight = 37178, walkTurnLeft = 37178, walkTurnRight = 37178, idles = { { 37171, 90 }, { 37172, 10 } } },
    [4834] = { walk = 35086, run = 35085, turnLeft = 35086, turnRight = 35086, walkTurnLeft = 35086, walkTurnRight = 35086, idles = { { 3320, 90 } } },
    [4835] = { stand = 37207, walk = 37207 },  -- STALKER_BOSS_DEATH_IDLE
    [4836] = { stand = 37540, walk = 37541, run = 37543, turnLeft = 37541, turnRight = 37541, walkBack = 37541, walkLeft = 37541, walkRight = 37541 },  -- HUMAN_ACTOR_CASUAL_UNARMED_VANILLA_IDLE
    [4837] = { stand = 37540, walk = 37542, run = 37543, turnLeft = 37542, turnRight = 37542, walkBack = 37542, walkLeft = 37542, walkRight = 37542 },  -- HUMAN_ACTOR_CASUAL_UNARMED_VANILLA_IDLE
    [4838] = { stand = 37586, walk = 37587, run = 37588, turnLeft = 37587, turnRight = 37587, walkBack = 37587, walkLeft = 37587, walkRight = 37587 },  -- HUMAN_ACTOR_CASUAL_UNARMED_HEROIC_IDLE
    [4839] = { stand = 37589, walk = 37590, run = 37588, turnLeft = 37590, turnRight = 37590, walkBack = 37590, walkLeft = 37590, walkRight = 37590 },  -- HUMAN_ACTOR_CASUAL_UNARMED_FEMALE_HEROIC_IDLE
    [4840] = { stand = 37584, walk = 37587, run = 37588, turnLeft = 37587, turnRight = 37587, walkBack = 37587, walkLeft = 37587, walkRight = 37587 },  -- HUMAN_ACTOR_CASUAL_UNARMED_HEROIC_LEGACY_BLEND_IDLE
    [4841] = { stand = 37585, walk = 37590, run = 37588, turnLeft = 37590, turnRight = 37590, walkBack = 37590, walkLeft = 37590, walkRight = 37590 },  -- HUMAN_ACTOR_CASUAL_UNARMED_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4842] = { stand = 37598, walk = 37600, run = 37599, turnLeft = 37600, turnRight = 37600, walkBack = 37600, walkLeft = 37600, walkRight = 37600 },  -- HUMAN_ACTOR_CASUAL_ARMED_HEROIC_LEGACY_BLEND_IDLE
    [4843] = { stand = 37621, walk = 37623, run = 37622, turnLeft = 37623, turnRight = 37623, walkBack = 37623, walkLeft = 37623, walkRight = 37623 },  -- HUMAN_ACTOR_CASUAL_ARMED_TWO_HANDED_SWORD_HEROIC_LEGACY_BLEND_IDLE
    [4844] = { stand = 37603, walk = 37605, run = 37604, turnLeft = 37605, turnRight = 37605, walkBack = 37605, walkLeft = 37605, walkRight = 37605 },  -- HUMAN_ACTOR_CASUAL_ARMED_MAUL_HEROIC_LEGACY_BLEND_IDLE
    [4845] = { stand = 37611, walk = 37613, run = 37612, turnLeft = 37613, turnRight = 37613, walkBack = 37613, walkLeft = 37613, walkRight = 37613 },  -- HUMAN_ACTOR_CASUAL_ARMED_SPEAR_HEROIC_LEGACY_BLEND_IDLE
    [4846] = { stand = 37616, walk = 37618, run = 37617, turnLeft = 37618, turnRight = 37618, walkBack = 37618, walkLeft = 37618, walkRight = 37618 },  -- HUMAN_ACTOR_CASUAL_ARMED_TWO_HANDED_CROSSBOW_HEROIC_LEGACY_BLEND_IDLE
    [4847] = { stand = 37593, walk = 37595, run = 37594, turnLeft = 37595, turnRight = 37595, walkBack = 37595, walkLeft = 37595, walkRight = 37595 },  -- HUMAN_ACTOR_CASUAL_ARMED_BOW_HEROIC_LEGACY_BLEND_IDLE
    [4848] = { stand = 37593, walk = 37608, run = 37607, turnLeft = 37608, turnRight = 37608, walkBack = 37608, walkLeft = 37608, walkRight = 37608 },  -- HUMAN_ACTOR_CASUAL_ARMED_BOW_HEROIC_LEGACY_BLEND_IDLE
    [4849] = { stand = 37626, walk = 37628, run = 37627, turnLeft = 37628, turnRight = 37628, walkBack = 37628, walkLeft = 37628, walkRight = 37628 },  -- HUMAN_ACTOR_CASUAL_ARMED_WHIP_HEROIC_LEGACY_BLEND_IDLE
    [4850] = { stand = 37597, walk = 37596, run = 37599, turnLeft = 37596, turnRight = 37596, walkBack = 37596, walkLeft = 37596, walkRight = 37596 },  -- HUMAN_ACTOR_CASUAL_ARMED_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4851] = { stand = 37602, walk = 37601, run = 37604, turnLeft = 37601, turnRight = 37601, walkBack = 37601, walkLeft = 37601, walkRight = 37601 },  -- HUMAN_ACTOR_CASUAL_ARMED_MAUL_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4852] = { stand = 37620, walk = 37619, run = 37622, turnLeft = 37619, turnRight = 37619, walkBack = 37619, walkLeft = 37619, walkRight = 37619 },  -- HUMAN_ACTOR_CASUAL_ARMED_TWO_HANDED_SWORD_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4853] = { stand = 37610, walk = 37609, run = 37612, turnLeft = 37609, turnRight = 37609, walkBack = 37609, walkLeft = 37609, walkRight = 37609 },  -- HUMAN_ACTOR_CASUAL_ARMED_SPEAR_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4854] = { stand = 37615, walk = 37614, run = 37617, turnLeft = 37614, turnRight = 37614, walkBack = 37614, walkLeft = 37614, walkRight = 37614 },  -- HUMAN_ACTOR_CASUAL_ARMED_TWO_HANDED_CROSSBOW_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4855] = { stand = 37592, walk = 37591, run = 37594, turnLeft = 37591, turnRight = 37591, walkBack = 37591, walkLeft = 37591, walkRight = 37591 },  -- HUMAN_ACTOR_CASUAL_ARMED_BOW_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4856] = { stand = 37592, walk = 37606, run = 37607, turnLeft = 37606, turnRight = 37606, walkBack = 37606, walkLeft = 37606, walkRight = 37606 },  -- HUMAN_ACTOR_CASUAL_ARMED_BOW_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4857] = { stand = 37625, walk = 37624, run = 37627, turnLeft = 37624, turnRight = 37624, walkBack = 37624, walkLeft = 37624, walkRight = 37624 },  -- HUMAN_ACTOR_CASUAL_ARMED_WHIP_HEROIC_LEGACY_BLEND_FEMALE_IDLE
    [4858] = { stand = 37652, walk = 37651, run = 37650, turnLeft = 37651, turnRight = 37651, walkBack = 37651, walkLeft = 37651, walkRight = 37651 },  -- HUMAN_ACTOR_COMBAT_UNARMED_IDLE
    [4859] = { stand = 37632, walk = 37646, run = 37636, turnLeft = 37646, turnRight = 37646, walkBack = 37646, walkLeft = 37646, walkRight = 37646 },  -- HUMAN_ACTOR_COMBAT_ARMED_IDLE
    [4860] = { stand = 37629, walk = 37631, run = 37630, turnLeft = 37631, turnRight = 37631, walkBack = 37631, walkLeft = 37631, walkRight = 37631 },  -- HUMAN_ACTOR_COMBAT_ARMED_BOW_IDLE
    [4861] = { stand = 37633, walk = 37635, run = 37634, turnLeft = 37635, turnRight = 37635, walkBack = 37635, walkLeft = 37635, walkRight = 37635 },  -- HUMAN_ACTOR_COMBAT_ARMED_MAUL_IDLE
    [4862] = { stand = 37637, walk = 37639, run = 37638, turnLeft = 37639, turnRight = 37639, walkBack = 37639, walkLeft = 37639, walkRight = 37639 },  -- HUMAN_ACTOR_COMBAT_ARMED_TWO_HANDED_CROSSBOW_IDLE
    [4863] = { stand = 37640, walk = 37642, run = 37641, turnLeft = 37642, turnRight = 37642, walkBack = 37642, walkLeft = 37642, walkRight = 37642 },  -- HUMAN_ACTOR_COMBAT_ARMED_TWO_HANDED_SPEAR_IDLE
    [4864] = { stand = 37643, walk = 37645, run = 37644, turnLeft = 37645, turnRight = 37645, walkBack = 37645, walkLeft = 37645, walkRight = 37645 },  -- HUMAN_ACTOR_COMBAT_ARMED_TWO_HANDED_SWORD_IDLE
    [4865] = { stand = 37647, walk = 37649, run = 37648, turnLeft = 37649, turnRight = 37649, walkBack = 37649, walkLeft = 37649, walkRight = 37649 },  -- HUMAN_ACTOR_COMBAT_ARMED_WHIP_IDLE
    [4866] = { walk = 37671, run = 37672, idles = { { 37669, 90 }, { 37670, 10 } } },
    [4867] = { stand = 37704 },  -- HUMAN_ACTOR_PUB_LEANING_ON_BAR_IDLE_DRUNK
    [4868] = { stand = 37705 },  -- HUMAN_ACTOR_PUB_LEANING_ON_BAR_DRINK_DRUNK
    [4869] = { stand = 37706 },  -- HUMAN_ACTOR_PUB_LEANING_ON_BAR_DRINK_SOBER
    [4870] = { stand = 37707 },  -- HUMAN_ACTOR_PUB_LEANING_ON_BAR_IDLE_SOBER
    [4871] = { stand = 37708 },  -- HUMAN_ACTOR_PUB_LEANING_ON_BAR_IDLE_SOBER_PLAYING_WITH_GLASS
    [4872] = { stand = 37709 },  -- HUMAN_ACTOR_PUB_LEANING_ON_BAR_IDLE_SOBER_VARIATION_01
    [4873] = { stand = 37710 },  -- HUMAN_ACTOR_PUB_PLAYING_CHESS_IDLE
    [4874] = { stand = 37711 },  -- HUMAN_ACTOR_PUB_PLAYING_CHESS_INTERACT
    [4875] = { stand = 37712 },  -- HUMAN_ACTOR_PUB_PLAYING_DARTS
    [4876] = { stand = 37713 },  -- HUMAN_ACTOR_PUB_SITTING_DRUNK_DRINK
    [4877] = { stand = 37714 },  -- HUMAN_ACTOR_PUB_SITTING_IDLE_DRUNK
    [4878] = { idles = { { 37714, 60 }, { 37713, 40 } } },
    [4879] = { stand = 37715 },  -- HUMAN_ACTOR_PUB_SITTING_IDLE_SOBER
    [4880] = { stand = 37716 },  -- HUMAN_ACTOR_PUB_SITTING_SOBER_DRINK
    [4881] = { idles = { { 37715, 60 }, { 37717, 40 } } },
    [4882] = { walk = 37755, idles = { { 37755, 150 }, { 37756, 150 }, { 37757, 150 } } },
    [4883] = { stand = 37807, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- PLAYER_2014_STONE_CUTTING_LIMESTONE_AREA_SFX
    [4884] = { stand = 37806, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- PLAYER_2014_POH_BUILD_FLOOR_INVENT_HAMMER_AREA_SFX
    [4885] = { stand = 37812, walk = 18020, run = 18021, turnLeft = 18020, turnRight = 18020 },  -- STRINGING_YEW_LONGBOW_2013_UPDATE_AREA_SFX
    [4886] = { stand = 37701, walk = 37703, run = 37702, turnLeft = 37703, turnRight = 37703, walkBack = 37703, walkLeft = 37703, walkRight = 37703 },  -- HUMAN_MALE_SCARED_IDLE
    [4887] = { stand = 17335, walk = 17337, turnLeft = 17337, turnRight = 17337, walkLeft = 17337, walkRight = 17337, walkTurnLeft = 17337, walkTurnRight = 17337 },  -- BIGCHINCHOMPA_GIANT_CHINCHOMPA_IDLE
    [4888] = { stand = 37726, walk = 37729, run = 37730, turnLeft = 37729, turnRight = 37729, walkLeft = 37729, walkRight = 37729, walkTurnLeft = 37729, walkTurnRight = 37729 },  -- GIANT_HILL_PET_IDLE
    [4889] = { walk = 37736, turnLeft = 37736, turnRight = 37736, walkLeft = 37736, walkRight = 37736, walkTurnLeft = 37736, walkTurnRight = 37736, idles = { { 37737, 90 }, { 37738, 10 } } },
    [4890] = { stand = 37737, walk = 37736, turnLeft = 37736, turnRight = 37736, walkLeft = 37736, walkRight = 37736, walkTurnLeft = 37736, walkTurnRight = 37736 },  -- GIANT_STANDARD_IDLE
    [4891] = { walk = 37694, run = 37695, turnLeft = 37694, turnRight = 37694, runTurnLeft = 37695, runTurnRight = 37695, walkTurnLeft = 37694, walkTurnRight = 37694, idles = { { 37692, 70 }, { 37693, 30 } } },
    [4892] = { stand = 32057, walk = 37754, run = 32040, turnLeft = 37754, turnRight = 37754 },  -- MTXBEACH18_HOT_SAND_IDLE
    [4893] = { stand = 37758, walk = 37760, run = 37761, turnLeft = 37758, turnRight = 37758, runTurnLeft = 37761, runTurnRight = 37761, walkTurnLeft = 37760, walkTurnRight = 37760 },  -- GIANT_KEBBIT_IDLE
    [4894] = { stand = 37758, walk = 37763, run = 37763, turnLeft = 37763, turnRight = 37763, runTurnLeft = 37763, runTurnRight = 37763, walkTurnLeft = 37763, walkTurnRight = 37763 },  -- GIANT_KEBBIT_IDLE
    [4895] = { stand = 37772, walk = 37773, run = 37774, turnLeft = 37773, turnRight = 37773, walkLeft = 37773, walkRight = 37773, walkTurnLeft = 37773, walkTurnRight = 37773 },  -- LADY_JOVKAI_IDLE
    [4896] = { stand = 4376, walk = 15428, run = 17069, turnLeft = 4376, turnRight = 4376, walkLeft = 15428, walkRight = 15428 },  -- OMGE_CHILD_READY_NO_IDLE_EXTRA
    [4897] = { stand = 4376, walk = 15429, run = 17069, turnLeft = 4376, turnRight = 4376, walkLeft = 15429, walkRight = 15429 },  -- OMGE_CHILD_READY_NO_IDLE_EXTRA
    [4898] = { stand = 15867, walk = 15428, run = 17069, turnLeft = 15867, turnRight = 15867, walkLeft = 15428, walkRight = 15428 },  -- OMGE_CHILD_READY
    [4899] = { stand = 15867, walk = 15429, run = 17069, turnLeft = 15867, turnRight = 15867, walkLeft = 15429, walkRight = 15429 },  -- OMGE_CHILD_READY
    [4900] = { stand = 37778, crawl = 36743, crawlLeft = 36743, crawlRight = 36743, run = 38179, runBack = 38179, runLeft = 38179, runRight = 38179, turnLeft = 36743, turnRight = 36743, walkLeft = 36744, walkRight = 36744, crawlTurnLeft = 36743, crawlTurnRight = 36743, walkTurnLeft = 36744, walkTurnRight = 36744 },  -- WENDLE_HEDGEHOG_BOSS_IDLE
    [4901] = { stand = 37784 },  -- WENDLE_HEDGEHOG_BOSS_SPIKE_SHIELD_IDLE
    [4902] = { stand = 37797 },  -- BEAR_UPDATE_DEAD_IDLE
    [4903] = { stand = 37801, walk = 37802, run = 37803, turnLeft = 37802, turnRight = 37802, walkBack = 37802, walkLeft = 37802, walkRight = 37802 },  -- LORE_JACKELOPE_IDLE
    [4904] = { stand = 31434 },  -- DSF_DEPOSIT_FISHING_NET_BOBBING
    [4905] = { stand = 37833, walk = 37834, run = 37834, walkLeft = 37834, walkRight = 37834 },  -- SANGUINE_CRAWLER_RANGED_IDLE
    [4906] = { idles = { { 37844, 70 }, { 37845, 30 } } },
    [4907] = { stand = 13302, walk = 13303, run = 13304, runLeft = 13307, runRight = 13308, walkLeft = 13309, walkRight = 13310 },  -- RAND_FERRET_READY
    [4908] = { stand = 37891, walk = 37892, run = 37893, turnLeft = 37892, turnRight = 37892, walkLeft = 37892, walkRight = 37892, walkTurnLeft = 37892, walkTurnRight = 37892 },  -- INANNA_IDLE
    [4909] = { idles = { { 37897, 70 }, { 37898, 30 } } },
    [4910] = { stand = 37944, walk = 37944 },  -- HUMAN_ACTOR_RELAXING_LYING_ON_CHAISE
    [4911] = { idles = { { 37946, 80 }, { 37947, 20 } } },
    [4912] = { walk = 34478, run = 34479, turnLeft = 34478, turnRight = 34478, walkTurnLeft = 34478, walkTurnRight = 34478, idles = { { 37949, 90 }, { 37950, 10 } } },
    [4913] = { walk = 37952, run = 37953, idles = { { 37961, 225 }, { 16369, 30 } } },
    [4914] = { stand = 37961 },  -- GNOME_OLD_READY
    [4915] = { stand = 15269, walk = 15270 },  -- GRANDTREE_GLOUGH_SABATEUR_READY
    [4916] = { stand = 37961, walk = 37961 },  -- GNOME_OLD_READY
    [4917] = { stand = 37965, walk = 37952 },  -- GNOME_OLD_TAKES_PHOTOGRAPHS
    [4918] = { stand = 38119 },  -- BRUT_HUMAN_CANOEING_CARVE_LEAGUE_2_AXE
    [4919] = { stand = 38129, walk = 38130 },  -- HH2_BOGOLIN_SANGUINE_SQUAT_READY_SPEAR
    [4920] = { stand = 38127, walk = 38128 },  -- VFX_SPOTANIM_510_FRAMES
    [4921] = { stand = 38134, walk = 38135 },  -- HH2_BOGOLIN_UNARMED_IDLE
    [4922] = { stand = 38151, run = 38152 },  -- CHAMPIONSHIPS_PLAYER_TORCH_EMOTE_SILVER
    [4923] = { stand = 38163, walk = 38164 },  -- CHAMPIONSHIPS_GNOME_RUNNER_INJURED_GET_UP
    [4924] = { stand = 38190, walk = 38191, run = 38192, turnLeft = 38191, turnRight = 38191, walkBack = 38191, walkLeft = 38191, walkRight = 38191, walkTurnLeft = 38191, walkTurnRight = 38191 },  -- CHAMPIONSHIPS_ATHLETICS_TRACK_LANE_5
    [4925] = { stand = 38202 },  -- HUMAN_ACTOR_COMBAT_ABILITY_RUNIC_CHARGE_SOUL_PLAYER_GROUND
    [4926] = { stand = 38190, walk = 38193, run = 38194, turnLeft = 38193, turnRight = 38193, walkBack = 38193, walkLeft = 38193, walkRight = 38193, walkTurnLeft = 38193, walkTurnRight = 38193 },  -- CHAMPIONSHIPS_ATHLETICS_TRACK_LANE_5
    [4927] = { stand = 38205, walk = 38215, run = 38204, turnLeft = 38215, turnRight = 38215, walkLeft = 38215, walkRight = 38215, walkTurnLeft = 38215, walkTurnRight = 38215 },  -- HUMAN_ACTOR_COMBAT_ABILITY_MAGIC_THRESHOLD_ASPHYXIATE_SOUL_STAFF
    [4928] = { walk = 38215, run = 38216, turnLeft = 38215, turnRight = 38215, walkLeft = 38215, walkRight = 38215, walkTurnLeft = 38215, walkTurnRight = 38215, idles = { { 38217, 90 }, { 38219, 10 } } },
    [4929] = { walk = 38223, run = 38224, turnLeft = 38223, turnRight = 38223, walkLeft = 38223, walkRight = 38223, walkTurnLeft = 38223, walkTurnRight = 38223, idles = { { 38217, 90 }, { 38219, 10 } } },
    [4930] = { stand = 37766 },
    [4931] = { stand = 38177 },  -- CHAMPIONSHIPS_PLAYER_LOSE
    [4932] = { walk = 38256, run = 38257, turnLeft = 38256, turnRight = 38256, walkBack = 38256, walkLeft = 38256, walkRight = 38256, walkTurnLeft = 38256, walkTurnRight = 38256, idles = { { 38254, 90 }, { 38255, 10 } } },
    [4933] = { stand = 38281 },  -- LADY_JOVKAI_CHAT_TEMP_SHOCK_SUBTLE
    [4934] = { walk = 38286, run = 38285, turnLeft = 38286, turnRight = 38286, walkLeft = 38286, walkRight = 38286, walkTurnLeft = 38286, walkTurnRight = 38286, idles = { { 38283, 90 }, { 38284, 10 } } },
    [4935] = { stand = 38315, walk = 38315 },  -- WEREWOLF_2021_COMBAT_DESPAWN
    [4936] = { stand = 38333, walk = 38333 },  -- PLAYER_FLETCHING_2013_UPDATE_FENMOOR_FLETCHING_KNIFE
    [4937] = { stand = 37953, walk = 37953 },  -- GNOME_OLD_RUN
    [4938] = { stand = 7332, walk = 7332 },  -- LOTG_GOBLIN_RUN
    [4939] = { stand = 13774, walk = 15428 },  -- HW11_DIANGO_READY
    [4940] = { stand = 824, walk = 824, run = 824, turnLeft = 823, turnRight = 823, walkBack = 820, walkLeft = 821, walkRight = 822 },  -- HUMAN_RUNNING
    [4941] = { stand = 38321, walk = 38321 },  -- WEREWOLF_SANGUINE_IDLE_COMBAT
    [4942] = { stand = 38314 },  -- WEREWOLF_2021_COMBAT_IDLE_EXTRA
    [4943] = { stand = 38320 },  -- WEREWOLF_SANGUINE_RUN
    [4944] = { stand = 38323 },  -- WEREWOLF_SANGUINE_COMBAT_IDLE_EXTRA
    [4945] = { stand = 3965, walk = 3963 },  -- GNOME_STAFF_READY
    [4946] = { stand = 6181, run = 7332 },  -- SLICE_SURFACE_GOBLIN_SQUAT_READY
    [4947] = { stand = 37961, run = 37953 },  -- GNOME_OLD_READY
    [4948] = { stand = 38315, run = 38315 },  -- WEREWOLF_2021_COMBAT_DESPAWN
    [4949] = { stand = 15659, run = 38333 },  -- FMC_EMMETT_READY
    [4950] = { stand = 38334 },  -- PLAYER_HUNTINGBOLTS_FLETCHING_2013_UPDATE_FENMOOR_FLETCHING_KNIFE
}
