local Set = {}

Set.cards = {
    {
        id = "alchemical_hydrix_dust", name = "Alchemical hydrix dust", kind = "item", rarity = "epic",
        desc = "Fine dust of an alchemical hydrix gem.",
        art = { item = "INVENT_ALCHEMICAL_HYDRIX_DUST", cam = { yaw = 1.20, pitch = 1.05, fov = 40, tx = 10 } },
        tags = { skills = { "crafting" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "moonstone_dust", name = "Moonstone dust", kind = "item", rarity = "epic",
        desc = "Fine dust of a moonstone gem, can be transmuted into an uncut moonstone.",
        art = { item = "MOONSTONE_DUST", cam = { yaw = -0.40, dist = 525, fov = 20, tx = 10 } },
        tags = { skills = { "thieving" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "poison_karambwan", name = "Poison karambwan", kind = "item", rarity = "common",
        desc = "Cooked octopus. It looks poorly cooked and quite dangerous.",
        art = { item = "TBWT_POORLY_COOKED_KARAMBWAN", cam = { pitch = 1.05, dist = 525, ty = -40 } },
        tags = { regions = { "karamja" }, skills = { "cooking" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "cracked_cooking_urn_empty", name = "Cracked cooking urn (empty)", kind = "item", rarity = "common",
        desc = "Collects scraps when I cook food requiring level 10 or below.",
        art = { item = "URNS_COOKING1_RUNE", cam = { pitch = 0.45, dist = 330, ty = 59, tx = 1 } },
        tags = { skills = { "crafting", "cooking" }, category = { "consumable" }, membership = { "f2p" } },
    },
    {
        id = "fish_offcuts", name = "Fish offcuts", kind = "item", rarity = "common",
        desc = "Slices of inedible fish.",
        art = { item = "BRUT_FISH_CUTS", cam = { ty = 4, tx = -28 } },
        tags = { regions = { "kandarin" }, skills = { "cooking", "fishing" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "fragile_cooking_urn_empty", name = "Fragile cooking urn (empty)", kind = "item", rarity = "common",
        desc = "Collects scraps when I cook food requiring level 25 or below.",
        art = { item = "URNS_COOKING2_RUNE", cam = { pitch = 0.48, dist = 330, ty = 65, tx = 1 } },
        tags = { skills = { "crafting", "cooking" }, category = { "consumable" }, membership = { "f2p" } },
    },
    {
        id = "plain_cooking_urn_empty", name = "Plain cooking urn (empty)", kind = "item", rarity = "common",
        desc = "This will collect scraps when I cook food requiring Cooking level 40 or below.",
        art = { item = "URNS_COOKING3_RUNE", cam = { pitch = 0.55, ty = 50, tx = 2 } },
        tags = { skills = { "crafting", "cooking" }, category = { "consumable" }, membership = { "f2p" } },
    },
    {
        id = "sea_turtle_bait", name = "Sea turtle bait", kind = "item", rarity = "common",
        desc = "Scattering this in the deep sea should attract some sea turtles.",
        art = { item = "DSF_SEATURTLE_BAIT", cam = { pitch = 1.20, dist = 205, ty = -18, tx = -1 } },
        tags = { regions = { "kandarin" }, skills = { "cooking" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "swamp_paste", name = "Swamp paste", kind = "item", rarity = "common",
        desc = "A tar-like substance mixed with flour and warmed.",
        art = { item = "SWAMPPASTE", cam = { yaw = -1.05, pitch = 1.45, dist = 225, ty = -15, tx = 10 } },
        tags = { skills = { "cooking" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "manta_ray_bait", name = "Manta ray bait", kind = "item", rarity = "uncommon",
        desc = "Scattering this in the deep sea should attract some manta rays.",
        art = { item = "DSF_MANTARAY_BAIT", cam = { pitch = 1.14, dist = 186, ty = -13, tx = -2 } },
        tags = { regions = { "kandarin" }, skills = { "cooking" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "strong_cooking_urn_empty", name = "Strong cooking urn (empty)", kind = "item", rarity = "uncommon",
        desc = "Collects scraps when I cook food requiring level 55 or below.",
        art = { item = "URNS_COOKING4_RUNE", cam = { yaw = 0.02, pitch = 0.50, dist = 330, ty = 63, tx = -3 } },
        tags = { skills = { "crafting", "cooking" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "decorated_cooking_urn_empty", name = "Decorated cooking urn (empty)", kind = "item", rarity = "rare",
        desc = "This will collect scraps when I cook food.",
        art = { item = "URNS_COOKING5_RUNE", cam = { pitch = 0.53, dist = 330, ty = 58, tx = 2 } },
        tags = { skills = { "crafting", "cooking" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "exquisite_cooking_urn_empty", name = "Exquisite cooking urn (empty)", kind = "item", rarity = "epic",
        desc = "This will collect scraps when you cook food.",
        art = { item = "URNS_COOKING6_RUNE", cam = { pitch = 0.52, dist = 330, ty = 58, tx = 2 } },
        tags = { skills = { "crafting", "cooking" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "numbing_root", name = "Numbing root", kind = "item", rarity = "epic",
        desc = "This could numb my wounds.",
        art = { item = "MOLE2_ROOTS_CONSUMABLE", cam = { yaw = 0.80, pitch = 0.89, dist = 273, fov = 60, ty = 12, tx = 5 } },
        tags = { regions = { "asgarnia" }, category = { "consumable" }, membership = { "f2p" } },
    },
}

return Set