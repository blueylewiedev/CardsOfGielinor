local Set = {}

Set.cards = {
    {
        id = "incomplete_hydrix", name = "Incomplete hydrix", kind = "item", rarity = "epic",
        desc = "Use an onyx on this to complete it.",
        art = { item = "BSLAY_INCOMPLETE_HYDRIX", cam = { yaw = 0.80, pitch = -1.55, dist = 525, fov = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "onyx_dust", name = "Onyx dust", kind = "item", rarity = "rare",
        desc = "Fine dust of an onyx gem, can be transmuted into an uncut onyx.",
        art = { item = "ONYX_DUST", cam = { yaw = 1.20, pitch = 1.40, dist = 525, fov = 20 } },
        tags = { category = { "raw_material" }, membership = { "p2p" } },
    },
    {
        id = "oyster_pearl", name = "Oyster pearl", kind = "item", rarity = "common",
        desc = "I could work wonders with a chisel on this pearl.",
        art = { item = "SMALLOYSTERPEARLS", cam = { yaw = 0.40, pitch = 1.05, dist = 525, fov = 35, ty = 60, tx = 20 } },
        tags = { skills = { "fletching" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "uncut_diamond", name = "Uncut diamond", kind = "item", rarity = "uncommon",
        desc = "An uncut diamond. Used in Crafting.",
        art = { item = "UNCUT_DIAMOND", cam = { yaw = -0.80, pitch = 1.00, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "uncut_dragonstone", name = "Uncut dragonstone", kind = "item", rarity = "rare",
        desc = "An uncut dragonstone. Used in Crafting.",
        art = { item = "UNCUT_DRAGONSTONE", cam = { yaw = 7.00, pitch = 1.55, dist = 918, fov = 15 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "uncut_emerald", name = "Uncut emerald", kind = "item", rarity = "uncommon",
        desc = "An uncut emerald. Used in Crafting.",
        art = { item = "UNCUT_EMERALD", cam = { yaw = 0.60, pitch = -1.55, dist = 603, fov = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "uncut_hydrix", name = "Uncut hydrix", kind = "item", rarity = "epic",
        desc = "An uncut hydrix. Used in Crafting.",
        art = { item = "UNCUT_HYDRIX", cam = { yaw = -0.80, pitch = 1.30, dist = 525, fov = 30 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "uncut_jade", name = "Uncut jade", kind = "item", rarity = "common",
        desc = "An uncut jade. Used in Crafting.",
        art = { item = "UNCUT_JADE", cam = { yaw = -0.80, pitch = 1.00, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "uncut_lapis_lazuli", name = "Uncut lapis lazuli", kind = "item", rarity = "common",
        desc = "You could cut and polish this using a chisel or your Army Axe.",
        art = { item = "HOOKS1_GEM", cam = { yaw = -1.40, pitch = 1.55, dist = 525, fov = 30, ty = 20, tx = 10 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "uncut_moonstone", name = "Uncut moonstone", kind = "item", rarity = "epic",
        desc = "An uncut moonstone. Used in Crafting.",
        art = { item = "UNCUT_MOONSTONE", cam = { yaw = -0.80, pitch = 1.15, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "uncut_onyx", name = "Uncut onyx", kind = "item", rarity = "epic",
        desc = "An uncut onyx. Used in Crafting.",
        art = { item = "UNCUT_ONYX", cam = { yaw = 0.80, pitch = -1.55, dist = 525, fov = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "p2p" } },
    },
    {
        id = "uncut_opal", name = "Uncut opal", kind = "item", rarity = "common",
        desc = "An uncut opal. Used in Crafting.",
        art = { item = "UNCUT_OPAL", cam = { yaw = -0.80, pitch = 1.00, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "uncut_red_topaz", name = "Uncut red topaz", kind = "item", rarity = "common",
        desc = "An uncut red topaz. Used in Crafting.",
        art = { item = "UNCUT_RED_TOPAZ", cam = { yaw = -0.80, pitch = 1.30, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "uncut_ruby", name = "Uncut ruby", kind = "item", rarity = "uncommon",
        desc = "An uncut ruby. Used in Crafting.",
        art = { item = "UNCUT_RUBY", cam = { yaw = 0.80, pitch = -1.55, dist = 525, fov = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
    {
        id = "uncut_sapphire", name = "Uncut sapphire", kind = "item", rarity = "common",
        desc = "An uncut sapphire. Used in Crafting.",
        art = { item = "UNCUT_SAPPHIRE", cam = { yaw = -0.80, pitch = 1.00, dist = 525, fov = 30, ty = 20 } },
        tags = { skills = { "crafting" }, category = { "raw_material", "gem" }, membership = { "f2p" } },
    },
}

return Set