local Set = {}

Set.cards = {
    {
        id = "fishing_hat", name = "Fishing hat", kind = "item", rarity = "rare",
        desc = "A wide-brimmed leather hat adorned with spare hooks and feathers.",
        art = { item = "FISHCOMP_FISHING_OUTFIT_HAT", cam = { yaw = -0.22, pitch = 0.34, dist = 205, fov = 65, ty = 17, tx = 6 } },
        tags = { regions = { "kandarin" }, skills = { "fishing" }, category = { "helmet", "minigame", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "archaeologists_hat", name = "Archaeologist's hat", kind = "item", rarity = "rare",
        desc = "Increases Archaeology experience gained by 1% when worn.",
        art = { item = "ARCH_SKILLING_HAT", cam = { yaw = -6.87, pitch = 0.56, dist = 225, ty = 11, tx = 6 } },
        tags = { regions = { "misthalin" }, skills = { "archaeology" }, category = { "helmet", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "artisans_bandana", name = "Artisan's bandana", kind = "item", rarity = "rare",
        desc = "Increases Crafting experience gained by 1% when worn.",
        art = { item = "WOF19_SKILL_CRAFTING_HEAD", cam = { yaw = -7.30, pitch = 0.59, dist = 140, ty = -6, tx = 13 } },
        tags = { regions = { "asgarnia" }, skills = { "crafting" }, category = { "helmet", "minigame", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "black_ibis_mask", name = "Black ibis mask", kind = "item", rarity = "rare",
        desc = "Keeps your identity secret.",
        art = { item = "HLR4M_SHADOWWRAP_HEAD", cam = { yaw = -6.29, pitch = 0.77, dist = 248, ty = -13, tx = 6 } },
        tags = { regions = { "kharidian_desert" }, skills = { "thieving" }, category = { "helmet", "skill_outfit", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "blacksmiths_helmet", name = "Blacksmith's helmet", kind = "item", rarity = "rare",
        desc = "Increases Smithing experience gained by 1% when worn.",
        art = { item = "WOF19_SKILL_SMITHING_HEAD", cam = { yaw = -6.78, pitch = 0.73, dist = 273, ty = 22, tx = 10 } },
        tags = { regions = { "asgarnia" }, skills = { "smithing" }, category = { "helmet", "minigame", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "botanists_mask", name = "Botanist's mask", kind = "item", rarity = "rare",
        desc = "Increases Herblore experience gained by 1% when worn.",
        art = { item = "WOF19_SKILL_HERBLORE_HEAD", cam = { yaw = -6.33, pitch = 1.47, dist = 140, ty = -3, tx = 4 } },
        tags = { regions = { "asgarnia" }, skills = { "herblore" }, category = { "helmet", "skill_outfit", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "first_age_tiara", name = "First age tiara", kind = "item", rarity = "rare",
        desc = "Increases Prayer experience gained by 1% when worn.",
        art = { item = "WOF36_SKILL_PRAYER_TIARA", cam = { yaw = -6.29, pitch = 0.75, dist = 127, ty = 1, tx = 4 } },
        tags = { regions = { "morytania" }, skills = { "prayer" }, category = { "helmet", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "diviners_headwear", name = "Diviner's headwear", kind = "item", rarity = "rare",
        desc = "Increases Divination experience gained by 1% when worn.",
        art = { item = "WOF55_SKILL_DIVINATION_HEAD", cam = { yaw = -6.76, pitch = 0.44, dist = 186, ty = 31, tx = -5 } },
        tags = { skills = { "divination" }, category = { "helmet", "minigame", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "exoskeleton_headband", name = "Exoskeleton headband", kind = "item", rarity = "rare",
        desc = "Part of the Trahaearn exoskeleton.",
        art = { item = "ME3_EXO_HEAD", cam = { yaw = -5.76, pitch = 0.79, dist = 116, ty = 2, tx = -2 } },
        tags = { regions = { "tirannwn" }, category = { "helmet", "quest_item", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "factory_mask", name = "Factory mask", kind = "item", rarity = "rare",
        desc = "Wearing this makes your voice sound harsh and menacing.",
        art = { item = "RDEN2_HELM", cam = { yaw = -6.48, dist = 186, ty = -1, tx = -15 } },
        tags = { regions = { "asgarnia" }, skills = { "herblore" }, category = { "helmet", "minigame", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "fletchers_headwear", name = "Fletcher's headwear", kind = "item", rarity = "rare",
        desc = "Increases Fletching experience gained by 1% when worn.",
        art = { item = "TRH85_FLETCHING_HEAD", cam = { yaw = -6.71, pitch = 0.03, dist = 225, ty = 754, tx = -4 } },
        tags = { regions = { "asgarnia" }, skills = { "fletching" }, category = { "helmet", "skill_outfit", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "golden_mining_helmet", name = "Golden mining helmet", kind = "item", rarity = "rare",
        desc = "This helmet gives me a small boost to Mining XP.",
        art = { item = "LFM_GOLD_HELMET", cam = { yaw = -5.35, pitch = 0.33, dist = 273, ty = 41, tx = -6 } },
        tags = { regions = { "fremennik_province" }, skills = { "mining" }, category = { "helmet", "skill_outfit", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "hunters_headwear", name = "Hunter's headwear", kind = "item", rarity = "rare",
        desc = "Increases Hunter experience gained by 1% when worn.",
        art = { item = "ELR2_HUNTER_HEAD", cam = { yaw = -6.78, pitch = 0.25, ty = 61, tx = 12 } },
        tags = { regions = { "the_arc" }, skills = { "hunter" }, category = { "helmet", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "nimble_headwear", name = "Nimble headwear", kind = "item", rarity = "rare",
        desc = "Increases Agility experience gained by 1% when worn.",
        art = { item = "TRH85_AGILITY_HEAD", cam = { yaw = -6.85, pitch = 0.26, dist = 399, ty = 708, tx = 1 } },
        tags = { skills = { "agility" }, category = { "helmet", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "ritualists_mask", name = "Ritualist's mask", kind = "item", rarity = "rare",
        desc = "Increases Necromancy experience gained by 1% when worn.",
        art = { item = "NECRO_SKILLING_HEAD", cam = { yaw = -7.98, dist = 116, fov = 45, ty = -1, tx = 3 } },
        tags = { regions = { "misthalin" }, skills = { "necromancy" }, category = { "helmet", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "constructors_hat", name = "Constructor's hat", kind = "item", rarity = "rare",
        desc = "Recommended on building sites.",
        art = { item = "TT2_CONSTRUCTION_HAT", cam = { yaw = -12.68, dist = 105, ty = 36, tx = -8 } },
        tags = { regions = { "morytania" }, skills = { "construction" }, category = { "minigame", "skill_outfit", "helmet" }, membership = { "p2p" } },
    },
    {
        id = "lumberjack_hat", name = "Lumberjack hat", kind = "item", rarity = "rare",
        desc = "You'll certainly be alright wearing this.",
        art = { item = "RAMBLE_LUMBERJACK_HAT", cam = { yaw = -6.94, pitch = 0.16, dist = 205, ty = 34, tx = 20 } },
        tags = { regions = { "morytania" }, skills = { "woodcutting" }, category = { "helmet", "minigame", "skill_outfit" }, membership = { "p2p" } },
    },
    {
        id = "master_runecrafter_hat", name = "Master runecrafter hat", kind = "item", rarity = "rare",
        desc = "Comes with goggles, for extra safety while Runecrafting.",
        art = { item = "HLR4M_RUNECRAFTER_HAT", cam = { yaw = -7.05, pitch = 0.32, dist = 205, ty = 15, tx = 7 } },
        tags = { regions = { "misthalin" }, skills = { "runecrafting" }, category = { "helmet", "skill_outfit", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "witchdoctor_mask", name = "Witchdoctor mask", kind = "item", rarity = "rare",
        desc = "Camouflage for the herblore habitat.",
        art = { item = "ECO_SHAMAN_MASK", cam = { yaw = -6.56, pitch = 1.28, dist = 273, ty = 34, tx = -6 } },
        tags = { regions = { "karamja" }, skills = { "hunter", "herblore", "farming", "agility" }, category = { "helmet", "minigame", "skill_outfit" }, membership = { "p2p" } },
    },
}

return Set
