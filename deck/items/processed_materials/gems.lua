local Set = {}

Set.cards = {
    {
        id = "alchemical_hydrix", name = "Alchemical hydrix", kind = "item", rarity = "legendary",
        desc = "A hydrix charged with energy and materials, outshining any gem.",
        art = { item = "INVENT_ALCHEMICAL_HYDRIX" },
        tags = { skills = { "invention", "crafting" }, category = { "processed_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "alchemical_onyx", name = "Alchemical onyx", kind = "item", rarity = "legendary",
        desc = "An Onyx, charged with energy and materials, outshining a regular Onyx.",
        art = { item = "INVENT_ALCHEMICAL_ONYX", cam = { yaw = -0.40, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "invention", "crafting" }, category = { "processed_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "crushed_gem", name = "Crushed gem", kind = "item", rarity = "common",
        desc = "This gem is crushed and broken.",
        art = { item = "CRUSHED_GEMSTONE", cam = { yaw = -0.40, dist = 525, fov = 25, tx = 10 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "diamond", name = "Diamond", kind = "item", rarity = "uncommon",
        desc = "This looks valuable.",
        art = { item = "DIAMOND", cam = { yaw = -0.40, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "dragonstone", name = "Dragonstone", kind = "item", rarity = "rare",
        desc = "This looks valuable.",
        art = { item = "DRAGONSTONE", cam = { yaw = -0.40, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "emerald", name = "Emerald", kind = "item", rarity = "uncommon",
        desc = "This looks valuable.",
        art = { item = "EMERALD", cam = { yaw = -0.40, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "hydrix", name = "Hydrix", kind = "item", rarity = "epic",
        desc = "This looks valuable.",
        art = { item = "HYDRIX", cam = { yaw = -0.40, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "jade", name = "Jade", kind = "item", rarity = "common",
        desc = "A semi precious stone.",
        art = { item = "JADE", cam = { yaw = -0.40, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "lapis_lazuli_gem", name = "Lapis lazuli gem", kind = "item", rarity = "common",
        desc = "Combine this with a setting or have it inlaid with silver at a furnace.",
        art = { item = "HOOKS1_GEM_CUT", cam = { yaw = -0.40, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "moonstone", name = "Moonstone", kind = "item", rarity = "rare",
        desc = "I don't think gold is gonna cut it with this one.",
        art = { item = "MOONSTONE", cam = { yaw = 0.20, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "onyx", name = "Onyx", kind = "item", rarity = "epic",
        desc = "This looks valuable.",
        art = { item = "ONYX", cam = { yaw = 0.60, pitch = 1.55, dist = 525, fov = 30 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "opal", name = "Opal", kind = "item", rarity = "common",
        desc = "A semi precious stone.",
        art = { item = "OPAL", cam = { yaw = 0.40, pitch = 1.25, dist = 603, fov = 25, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "red_topaz", name = "Red topaz", kind = "item", rarity = "common",
        desc = "A semi precious stone.",
        art = { item = "RED_TOPAZ", cam = { yaw = -0.40, pitch = 1.05, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "ruby", name = "Ruby", kind = "item", rarity = "uncommon",
        desc = "This looks valuable.",
        art = { item = "RUBY", cam = { yaw = -0.40, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "sapphire", name = "Sapphire", kind = "item", rarity = "common",
        desc = "This looks valuable.",
        art = { item = "SAPPHIRE", cam = { yaw = -0.40, pitch = 1.20, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "processed_material", "gem" }, membership = { "f2p" } },
    },
}

return Set