local Set = {}

Set.cards = {
    {
        id = "enchanted_gem", name = "Enchanted gem", kind = "item", rarity = "common",
        desc = "I can contact the Slayer Masters with this.",
        art = { item = "SLAYER_GEM", cam = { yaw = -0.40, pitch = 1.30, dist = 525, fov = 25 } },
        tags = { skills = { "slayer" }, category = { "pocket", "tool" }, membership = { "f2p" } },
    },
    { id = "grim_gem", name = "Grim gem", kind = "item", rarity = "common", desc = "I can contact Death with this.", art = { item = "BSLAY_GEM", cam = { pitch = 1.55, dist = 525, fov = 30 } }, tags = { regions = { "misthalin" }, skills = { "slayer" }, category = { "pocket", "tool" }, membership = { "p2p" } } },
    { id = "dragon_harpoon", name = "Dragon harpoon", kind = "item", rarity = "rare", desc = "A very powerful harpoon.", art = { item = "DRAGON_HARPOON", cam = { yaw = -8.00, dist = 525, fov = 35 } }, tags = { regions = { "wilderness" }, skills = { "attack", "fishing" }, category = { "weapon", "melee_gear", "sword", "tool" }, membership = { "p2p" } } },
    { id = "dwarven_army_axe", name = "Dwarven army axe", kind = "item", rarity = "common", desc = "A highly useful modular tool.", art = { item = "HOOKS1_AXE", cam = { yaw = -5.00, dist = 525, fov = 35 } }, tags = { category = { "weapon", "melee_gear", "tool", "axe" }, membership = { "f2p" } } },
    { id = "enhanced_yaktwee_stick", name = "Enhanced yaktwee stick", kind = "item", rarity = "common", desc = "An improved tool used to hunt charm sprites.", art = { item = "HUNTCHARM_STAVE_ENHANCED", cam = { yaw = -8.80, dist = 525, fov = 45, ty = -20, tx = 60 } }, tags = { regions = { "kandarin" }, category = { "weapon", "melee_gear", "minigame", "tool" }, membership = { "p2p" } } },
    { id = "good_locator", name = "Good locator", kind = "item", rarity = "rare", desc = "Helps me to get to useful resources.", art = { item = "MOB_REWARD_LOCATOR3", cam = { yaw = -7.80, dist = 525, fov = 25, ty = -20, tx = 20 } }, tags = { skills = { "divination" }, category = { "tool" }, membership = { "p2p" } } },
}

return Set