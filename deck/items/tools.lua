local Set = {}

Set.cards = {
    {
        id = "enchanted_gem", name = "Enchanted gem", kind = "item", rarity = "common",
        desc = "I can contact the Slayer Masters with this.",
        art = { item = "SLAYER_GEM", cam = { yaw = -0.40, pitch = 1.30, dist = 525, fov = 25 } },
        tags = { skills = { "slayer" }, category = { "pocket", "tool" }, membership = { "f2p" } },
    },
    {
        id = "grim_gem", name = "Grim gem", kind = "item", rarity = "common",
        desc = "I can contact Death with this.",
        art = { item = "BSLAY_GEM", cam = { pitch = 1.55, dist = 525, fov = 30 } },
        tags = { regions = { "misthalin" }, skills = { "slayer" }, category = { "pocket", "tool" }, membership = { "p2p" } },
    },
    {
        id = "dragon_harpoon", name = "Dragon harpoon", kind = "item", rarity = "rare",
        desc = "A very powerful harpoon.",
        art = { item = "DRAGON_HARPOON", cam = { yaw = -8.00, dist = 525, fov = 35 } },
        tags = { regions = { "wilderness" }, skills = { "attack", "fishing" }, category = { "weapon", "melee_gear", "sword", "tool" }, membership = { "p2p" } },
    },
    {
        id = "dwarven_army_axe", name = "Dwarven army axe", kind = "item", rarity = "common",
        desc = "A highly useful modular tool.",
        art = { item = "HOOKS1_AXE", cam = { yaw = -5.00, dist = 525, fov = 35 } },
        tags = { category = { "weapon", "melee_gear", "tool", "axe" }, membership = { "f2p" } },
    },
    {
        id = "enhanced_yaktwee_stick", name = "Enhanced yaktwee stick", kind = "item", rarity = "common",
        desc = "An improved tool used to hunt charm sprites.",
        art = { item = "HUNTCHARM_STAVE_ENHANCED", cam = { yaw = -8.80, dist = 525, fov = 45, ty = -20, tx = 60 } },
        tags = { regions = { "kandarin" }, category = { "weapon", "melee_gear", "minigame", "tool" }, membership = { "p2p" } },
    },
    {
        id = "good_locator", name = "Good locator", kind = "item", rarity = "rare",
        desc = "Helps me to get to useful resources.",
        art = { item = "MOB_REWARD_LOCATOR3", cam = { yaw = -7.80, dist = 525, fov = 25, ty = -20, tx = 20 } },
        tags = { skills = { "divination" }, category = { "tool" }, membership = { "p2p" } },
    },
    {
        id = "inferior_locator", name = "Inferior locator", kind = "item", rarity = "common",
        desc = "Helps me to get to useful resources.",
        art = { item = "MOB_REWARD_LOCATOR1", cam = { yaw = -8.41, dist = 326, fov = 35, ty = 6, tx = 17 } },
        tags = { skills = { "divination" }, category = { "tool" }, membership = { "p2p" } },
    },
    {
        id = "poor_locator", name = "Poor locator", kind = "item", rarity = "uncommon",
        desc = "Helps me to get to useful resources.",
        art = { item = "MOB_REWARD_LOCATOR2", cam = { yaw = -8.13, pitch = 0.96, dist = 326, fov = 35, ty = -4, tx = 20 } },
        tags = { skills = { "divination" }, category = { "tool" }, membership = { "p2p" } },
    },
    {
        id = "superior_locator", name = "Superior locator", kind = "item", rarity = "epic",
        desc = "Helps me to get to useful resources.",
        art = { item = "MOB_REWARD_LOCATOR4", cam = { yaw = -7.68, pitch = 1.04, dist = 359, fov = 35, ty = -10, tx = 18 } },
        tags = { skills = { "divination" }, category = { "tool" }, membership = { "p2p" } },
    },
    {
        id = "yaktwee_stick", name = "Yaktwee stick", kind = "item", rarity = "common",
        desc = "A rudimentary tool used to hunt charm sprites.",
        art = { item = "HUNTCHARM_STAVE", cam = { yaw = -4.34, dist = 525, fov = 35, ty = 53, tx = 29 } },
        tags = { regions = { "kandarin" }, category = { "tool" }, membership = { "p2p" } },
    },
    {
        id = "sacred_clay_butterfly_net", name = "Sacred clay butterfly net", kind = "item", rarity = "rare",
        desc = "Your sacred clay tool has transformed into a butterfly net.",
        art = { item = "SC_REWARD_BUTTERFLY_NET", cam = { yaw = -8.02, dist = 698, fov = 35, ty = 39, tx = 10 } },
        tags = { skills = { "hunter" }, category = { "minigame", "tool" }, membership = { "p2p" } },
    },
    {
        id = "volatile_clay_butterfly_net", name = "Volatile clay butterfly net", kind = "item", rarity = "rare",
        desc = "Your volatile tool wants to catch some butterflies.",
        art = { item = "SC_REWARD_VOLATILE_BUTTERFLY_NET", cam = { yaw = -6.06, dist = 768, fov = 35, ty = 4, tx = 14 } },
        tags = { skills = { "hunter" }, category = { "tool", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "inferno_adze", name = "Inferno adze", kind = "item", rarity = "legendary",
        desc = "Danger: risk of fire.",
        art = { item = "FIREDUP_ADZE", cam = { yaw = -7.36, dist = 577, fov = 35, ty = 32, tx = -3 } },
        tags = { skills = { "firemaking", "mining" }, category = { "tool", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "noose_wand", name = "Noose wand", kind = "item", rarity = "common",
        desc = "A noose on a stick.",
        art = { item = "NOOSE_WAND", cam = { yaw = -1.70, dist = 498, ty = -19, tx = 14 } },
        tags = { skills = { "hunter" }, category = { "tool" }, membership = { "f2p" } },
    },
    {
        id = "jade_machete", name = "Jade machete", kind = "item", rarity = "common",
        desc = "A jungle specific slashing device.",
        art = { item = "MACHETTE_JADE", cam = { yaw = -1.15, dist = 296, fov = 45, tx = 11 } },
        tags = { skills = { "woodcutting" }, category = { "weapon", "melee_gear", "sword", "tool" }, membership = { "p2p" } },
    },
    {
        id = "magic_secateurs", name = "Magic secateurs", kind = "item", rarity = "common",
        desc = "The only way to kill a Tanglefoot.",
        art = { item = "FAIRY_ENCHANTED_SECATEURS", cam = { yaw = 0.32, dist = 245, fov = 45 } },
        tags = { skills = { "farming" }, category = { "weapon", "melee_gear", "sword", "quest_item", "tool" }, membership = { "p2p" } },
    },
    {
        id = "opal_machete", name = "Opal machete", kind = "item", rarity = "common",
        desc = "A jungle specific slashing device.",
        art = { item = "MACHETTE_OPAL", cam = { yaw = -1.13, dist = 296, fov = 45 } },
        tags = { skills = { "woodcutting" }, category = { "weapon", "melee_gear", "sword", "tool" }, membership = { "p2p" } },
    },
    {
        id = "red_topaz_machete", name = "Red topaz machete", kind = "item", rarity = "uncommon",
        desc = "A jungle specific slashing device.",
        art = { item = "MACHETTE_REDTOPAZ", cam = { yaw = -2.20, dist = 296, fov = 45 } },
        tags = { regions = { "karamja" }, skills = { "woodcutting" }, category = { "weapon", "melee_gear", "sword", "tool" }, membership = { "p2p" } },
    },
    {
        id = "protea_flower", name = "Protea flower", kind = "item", rarity = "common",
        desc = "Its nectar makes it attractive to moths.",
        art = { item = "BIGCHINCHOMPA_FLOWER", cam = { yaw = -1.80, dist = 525, fov = 45, tx = 10 } },
        tags = { skills = { "hunter" }, category = { "tool" }, membership = { "p2p" } },
    },
}

return Set