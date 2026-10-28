local Set = {}

Set.cards = {
    {
        id = "adamantite_ore", name = "Adamantite ore", kind = "item", rarity = "uncommon",
        desc = "Used for Smithing.",
        art = { item = "ADAMANTITE_ORE", cam = { pitch = 1.20, dist = 345, fov = 65, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "banite_ore", name = "Banite ore", kind = "item", rarity = "epic",
        desc = "This mystical ore could do with some magical input.",
        art = { item = "MAH5_BANE_ORE", cam = { fov = 75 } },
        tags = { skills = { "divination", "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "bathus_ore", name = "Bathus ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing.",
        art = { item = "PRIMAL_BATHUS_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "bathus_ore_dungeoneering", name = "Bathus ore (Dungeoneering)", kind = "item", rarity = "common",
        desc = "It's a rock now, but there's potential for so much more!",
        art = { item = "RAND_ORE_2", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "blurite_ore", name = "Blurite ore", kind = "item", rarity = "common",
        desc = "Definitely blue.",
        art = { item = "BLURITE_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "asgarnia" }, skills = { "mining" }, category = { "raw_material", "ore", "quest_item" }, membership = { "f2p" } },
    },
    {
        id = "coal", name = "Coal", kind = "item", rarity = "common",
        desc = "Used in Smithing.",
        art = { item = "COAL", cam = { dist = 345, fov = 70, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "copper_ore", name = "Copper ore", kind = "item", rarity = "uncommon",
        desc = "Used in Smithing.",
        art = { item = "COPPER_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "corrupted_ore", name = "Corrupted ore", kind = "item", rarity = "legendary",
        desc = "This needs destroying.",
        art = { item = "ELF_CORRUPTED_ORE", cam = { dist = 345, fov = 70, ty = -20 } },
        tags = { regions = { "tirannwn" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "daeyalt_ore", name = "Daeyalt ore", kind = "item", rarity = "common",
        desc = "This needs refining.",
        art = { item = "SANG_JAS_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "morytania" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "drakolith", name = "Drakolith", kind = "item", rarity = "rare",
        desc = "Used in Smithing.",
        art = { item = "DRAKOLITH", cam = { pitch = 1.20, dist = 345, fov = 65, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "elemental_ore", name = "Elemental ore", kind = "item", rarity = "common",
        desc = "This needs refining.",
        art = { item = "ELEMENTAL_WORKSHOP_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "kandarin" }, skills = { "mining" }, category = { "raw_material", "ore", "quest_item" }, membership = { "p2p" } },
    },
    {
        id = "fractite_ore", name = "Fractite ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing.",
        art = { item = "PRIMAL_FRACTITE_ORE", cam = { dist = 397, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "fractite_ore_dungeoneering", name = "Fractite ore (Dungeoneering)", kind = "item", rarity = "uncommon",
        desc = "It's a rock now, but there's potential for so much more!",
        art = { item = "RAND_ORE_5", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "gold_ore", name = "Gold ore", kind = "item", rarity = "uncommon",
        desc = "This needs refining.",
        art = { item = "GOLD_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "gorgonite_ore", name = "Gorgonite ore", kind = "item", rarity = "epic",
        desc = "Used in Smithing.",
        art = { item = "PRIMAL_GORGONITE_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "gorgonite_ore_dungeoneering", name = "Gorgonite ore (Dungeoneering)", kind = "item", rarity = "epic",
        desc = "It's a rock now, but there's potential for so much more!",
        art = { item = "RAND_ORE_9", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "havensilver_ore", name = "Havensilver ore", kind = "item", rarity = "common",
        desc = "This needs refining.",
        art = { item = "HAVENSILVER_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "havenhythe" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "iron_ore", name = "Iron ore", kind = "item", rarity = "common",
        desc = "Used in Smithing (10,20).",
        art = { item = "IRON_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "divination", "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "katagon_ore", name = "Katagon ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing (100).",
        art = { item = "PRIMAL_KATAGON_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "katagon_ore_dungeoneering", name = "Katagon ore (Dungeoneering)", kind = "item", rarity = "epic",
        desc = "It's a rock now, but there's potential for so much more!",
        art = { item = "RAND_ORE_8", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "kratonium_ore", name = "Kratonium ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing.",
        art = { item = "PRIMAL_KRATONIUM_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "kratonium_ore_dungeoneering", name = "Kratonium ore (Dungeoneering)", kind = "item", rarity = "uncommon",
        desc = "It's a rock now, but there's potential for so much more!",
        art = { item = "RAND_ORE_4", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "luminite", name = "Luminite", kind = "item", rarity = "uncommon",
        desc = "Used in Smithing.",
        art = { item = "LUMINITE", cam = { pitch = 1.20, dist = 345, fov = 65, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "lunar_ore", name = "Lunar ore", kind = "item", rarity = "rare",
        desc = "This needs refining.",
        art = { item = "QUEST_LUNAR_MAGIC_ORE", cam = { pitch = 1.20, dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "fremennik_province" }, skills = { "mining" }, category = { "raw_material", "ore", "quest_item" }, membership = { "p2p" } },
    },
    {
        id = "marmaros_ore", name = "Marmaros ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing (100).",
        art = { item = "PRIMAL_MARMAROS_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "marmaros_ore_dungeoneering", name = "Marmaros ore (Dungeoneering)", kind = "item", rarity = "common",
        desc = "It's a rock now, but there's potential for so much more!",
        art = { item = "RAND_ORE_3", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "mithril_ore", name = "Mithril ore", kind = "item", rarity = "uncommon",
        desc = "Used in Smithing (30).",
        art = { item = "MITHRIL_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "divination", "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "necrite_ore", name = "Necrite ore", kind = "item", rarity = "epic",
        desc = "Used in Smithing (70).",
        art = { item = "NECRITE_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "divination", "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "novite_ore", name = "Novite ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing (100).",
        art = { item = "PRIMAL_NOVITE_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "novite_ore_dungeoneering", name = "Novite ore (Dungeoneering)", kind = "item", rarity = "common",
        desc = "It's a rock now, but there's potential for so much more!",
        art = { item = "RAND_ORE_1", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "orichalcite_ore", name = "Orichalcite ore", kind = "item", rarity = "rare",
        desc = "Used in Smithing.",
        art = { item = "ORICHALCITE_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "divination", "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "phasmatite", name = "Phasmatite", kind = "item", rarity = "epic",
        desc = "Used in Smithing",
        art = { item = "PHASMATITE", cam = { pitch = 1.20, dist = 345, fov = 65, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "platinum_ore", name = "Platinum ore", kind = "item", rarity = "legendary",
        desc = "This needs refining.",
        art = { item = "PLATINUM_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "promethium_ore", name = "Promethium ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing (100).",
        art = { item = "PRIMAL_PROMETHIUM_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "promethium_ore_dungeoneering", name = "Promethium ore (Dungeoneering)", kind = "item", rarity = "legendary",
        desc = "It's a rock now, but there's potential for so much more! (Tier 10)",
        art = { item = "RAND_ORE_10", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "punishment_rock_ore", name = "Punishment rock (ore)", kind = "item", rarity = "common",
        desc = "Looks like a plain rock, must have some ore in it?",
        art = { item = "THPUNISHROCK", cam = { yaw = -4.00, pitch = 0.80, dist = 527, fov = 35, ty = 80, tx = 30 } },
        tags = { regions = { "kharidian_desert" }, skills = { "mining" }, category = { "raw_material", "ore", "quest_item" }, membership = { "p2p" } },
    },
    {
        id = "rock_ore", name = "Rock (ore)", kind = "item", rarity = "common",
        desc = "A chunk of rock.",
        art = { item = "SWAMPROCKS1", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "runite_ore", name = "Runite ore", kind = "item", rarity = "rare",
        desc = "Used in Smithing (50).",
        art = { item = "RUNITE_ORE", cam = { dist = 345, fov = 70, ty = -20 } },
        tags = { skills = { "divination", "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "silver_ore", name = "Silver ore", kind = "item", rarity = "common",
        desc = "This needs refining.",
        art = { item = "SILVER_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "divination", "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "soggy_copper_ore", name = "Soggy copper ore", kind = "item", rarity = "common",
        desc = "Can be combined with tin ore to make a Bronze bar. Used in Smithing.",
        art = { item = "TUTISLAND_SMITHING_COPPER", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "misthalin" }, skills = { "mining" }, category = { "raw_material", "ore", "quest_item" }, membership = { "f2p" } },
    },
    {
        id = "soggy_tin_ore", name = "Soggy tin ore", kind = "item", rarity = "common",
        desc = "Can be combined with copper ore to make a bronze bar. Used in Smithing.",
        art = { item = "TUTISLAND_SMITHING_TIN", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "misthalin" }, skills = { "mining" }, category = { "raw_material", "ore", "quest_item" }, membership = { "f2p" } },
    },
    {
        id = "tin_ore", name = "Tin ore", kind = "item", rarity = "common",
        desc = "Used in Smithing.",
        art = { item = "TIN_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "zephyrium_ore", name = "Zephyrium ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing.",
        art = { item = "PRIMAL_ZEPHYRIUM_ORE", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "zephyrium_ore_dungeoneering", name = "Zephyrium ore (Dungeoneering)", kind = "item", rarity = "rare",
        desc = "It's a rock now, but there's potential for so much more! (Tier 6)",
        art = { item = "RAND_ORE_6", cam = { dist = 345, fov = 75, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "f2p" } },
    },
    {
        id = "perfect_gold_ore", name = "'Perfect' gold ore", kind = "item", rarity = "uncommon",
        desc = "This needs refining.",
        art = { item = "PERFECT_GOLD_ORE", cam = { pitch = 1.20, dist = 345, fov = 65, ty = -20 } },
        tags = { regions = { "kandarin" }, skills = { "mining" }, category = { "raw_material", "ore", "quest_item" }, membership = { "p2p" } },
    },
    {
        id = "argonite_ore", name = "Argonite ore", kind = "item", rarity = "legendary",
        desc = "Used in Smithing.",
        art = { item = "PRIMAL_ARGONITE_ORE", cam = { pitch = 1.20, dist = 397, fov = 65, ty = -20 } },
        tags = { regions = { "daemonheim" }, skills = { "mining" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "argonite_ore_dungeoneering", name = "Argonite ore (Dungeoneering)", kind = "item", rarity = "rare",
        desc = "It's a rock now, but there's potential for so much more!",
        art = { item = "RAND_ORE_7", cam = { pitch = 1.20, dist = 397, fov = 65, ty = -40 } },
        tags = { regions = { "daemonheim" }, skills = { "mining", "dungeoneering" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "argonlike_ore", name = "Argonlike ore", kind = "item", rarity = "rare",
        desc = "Almost unlike argonite ore normally found in Daemonheim.",
        art = { item = "QUEST_DAUGHTER2_ORE", cam = { pitch = 1.20, dist = 397, fov = 65, ty = -40 } },
        tags = { regions = { "wilderness" }, skills = { "mining" }, category = { "raw_material", "ore", "quest_item" }, membership = { "p2p" } },
    },
    {
        id = "light_animica", name = "Light animica", kind = "item", rarity = "legendary",
        desc = "Used in Smithing.",
        art = { item = "LIGHT_ANIMICA", cam = { pitch = 1.05, dist = 456 } },
        tags = { skills = { "smithing" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    {
        id = "dark_animica", name = "Dark animica", kind = "item", rarity = "legendary",
        desc = "Used in Smithing.",
        art = { item = "DARK_ANIMICA", cam = { pitch = 1.20, dist = 345, fov = 65, ty = -20 } },
        tags = { regions = { "misthalin", "anachronia" }, skills = { "smithing" }, category = { "raw_material", "ore" }, membership = { "p2p" } },
    },
    --stone slab
    --rubium
    --stardust
    --clay
    --rune essence
    --limestone
    --pure essence
    --sandstone
    --granite
    --living minerals
    --red sanstone
    --crystal flecked sandstone
    --calcified fungus
    --sea salt
    --enriched calcified fungus
    --alaea sea salt
    --golden idol
    --porcelain clay

    --ores or processed? Soft-clay / soft porcelain clay
}

    return Set