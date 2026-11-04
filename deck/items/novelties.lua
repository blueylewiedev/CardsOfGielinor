local Set = {}

Set.cards = {
    {
        id = "rubber_chicken", name = "Rubber chicken", kind = "item", rarity = "legendary",
        desc = "Perhaps not the most powerful weapon in Gielinor.",
        art = { item = "RUBBER_CHICKEN", cam = { yaw = -6.33, dist = 635, fov = 35, ty = -15, tx = 12 } },
        tags = { category = { "novelty" }, membership = { "f2p" } },
    },
    {
        id = "offhand_rubber_chicken", name = "Off-hand rubber chicken", kind = "item", rarity = "common",
        desc = "Perhaps not the most powerful weapon in Gielinor.",
        art = { item = "RUBBER_CHICKEN_O", cam = { yaw = -4.34, dist = 577, fov = 35, ty = -12, tx = -7 } },
        tags = { category = { "novelty" }, membership = { "f2p" } },
    },
    {
        id = "tambourine", name = "Tambourine", kind = "item", rarity = "common",
        desc = "For making a happy noise.",
        art = { item = "CRCS_TAMBOURINE", cam = { yaw = -6.91, pitch = 0.76, dist = 326, fov = 35, ty = 11 } },
        tags = { category = { "novelty", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "megaphonus", name = "Mega-phonus", kind = "item", rarity = "common",
        desc = "For shouting at people.",
        art = { item = "CRCS_RINGMASTER_MEGAPHONE", cam = { yaw = -11.37, dist = 477, fov = 35, tx = 18 } },
        tags = { category = { "novelty", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "rubber_turkey", name = "Rubber turkey", kind = "item", rarity = "common",
        desc = "Perhaps not the most powerful weapon in Gielinor.",
        art = { item = "RUBBER_TURKEY", cam = { yaw = -4.15, dist = 434, fov = 35, ty = -12, tx = -0 } },
        tags = { category = { "novelty" }, membership = { "f2p" } },
    },
    {
        id = "offhand_rubber_turkey", name = "Off-hand rubber turkey", kind = "item", rarity = "common",
        desc = "Perhaps not the most powerful weapon in Gielinor.",
        art = { item = "RUBBER_TURKEY_O", cam = { yaw = -2.26, dist = 525, fov = 30, ty = 3, tx = 9 } },
        tags = { category = { "novelty" }, membership = { "f2p" } },
    },
    {
        id = "rubber_blackjack", name = "Rubber blackjack", kind = "item", rarity = "common",
        desc = "A training cosh.",
        art = { item = "BLACKJACK_RUBBER", cam = { yaw = -5.26, dist = 326, fov = 35, ty = -9, tx = -19 } },
        tags = { category = { "novelty" }, membership = { "p2p" } },
    },
    {
        id = "pogo_stick", name = "Pogo stick", kind = "item", rarity = "epic",
        desc = "Four times the bouncy, five times the fun!",
        art = { item = "INVENT_POGO_STICK", cam = { yaw = -8.10, dist = 845, fov = 35, ty = -24, tx = 12 } },
        tags = { skills = { "invention", "smithing" }, category = { "novelty", "fashion" }, membership = { "p2p" } },
    },
    {
        id = "walking_stick", name = "Walking stick", kind = "item", rarity = "common",
        desc = "Stroll through the Myre in style.",
        art = { item = "TT2_WALKINGSTICK", cam = { yaw = -7.63, dist = 635, fov = 35, ty = 0, tx = 10 } },
        tags = { category = { "novelty", "fashion", "minigame" }, membership = { "p2p" } },
    },
    {
        id = "gavel", name = "Gavel", kind = "item", rarity = "rare",
        desc = "For pounding justice into delinquents!",
        art = { item = "CSI_GAVEL_HAMMER", cam = { yaw = -7.20, dist = 525, fov = 25 } },
        tags = { regions = { "kandarin" }, category = { "novelty", "minigame", "fashion" }, membership = { "p2p" } },
    },
    {
        id = "spork", name = "Spork", kind = "item", rarity = "common",
        desc = "Use the spork.",
        art = { item = "HUNDRED_SPORK", cam = { yaw = -5.32, dist = 296, fov = 45 } },
        tags = { category = { "novelty", "fashion" }, membership = { "p2p" } },
    },
    {
        id = "wooden_spoon", name = "Wooden spoon", kind = "item", rarity = "common",
        desc = "Spoooooon!",
        art = { item = "HUNDRED_SPOON", cam = { yaw = -5.34, dist = 359, fov = 45 } },
        tags = { category = { "novelty", "fashion" }, membership = { "p2p" } },
    },
    {
        id = "frying_pan", name = "Frying pan", kind = "item", rarity = "common",
        desc = "Looks like it's non-stick too!",
        art = { item = "HUNDRED_FRYING_PAN", cam = { yaw = -7.20, dist = 525, fov = 30, ty = -20, tx = 30 } },
        tags = { regions = { "misthalin" }, category = { "novelty" }, membership = { "p2p" } },
    },
    {
        id = "rolling_pin", name = "Rolling pin", kind = "item", rarity = "common",
        desc = "That's how I roll!",
        art = { item = "HUNDRED_ROLLINGPIN", cam = { yaw = -7.20, dist = 525, fov = 35 } },
        tags = { category = { "novelty" }, membership = { "p2p" } },
    },
    {
        id = "meat_tenderiser", name = "Meat tenderiser", kind = "item", rarity = "common",
        desc = "Often used to soften tough meat up.",
        art = { item = "HUNDRED_HAMMER", cam = { yaw = -8.44, pitch = 0.95, dist = 769, fov = 35, ty = 55, tx = 13 } },
        tags = { category = { "novelty" }, membership = { "p2p" } },
    },
    {
        id = "kitchen_knife", name = "Kitchen knife", kind = "item", rarity = "common",
        desc = "A sharp, dependable knife, for filleting meat.",
        art = { item = "HUNDRED_KNIFE", cam = { yaw = -1.14, dist = 326, fov = 45, ty = -23, tx = 49 } },
        tags = { category = { "novelty" }, membership = { "p2p" } },
    },
    {
        id = "mud_pie", name = "Mud pie", kind = "item", rarity = "common",
        desc = "All the good of the earth.",
        art = { item = "MUD_PIE", cam = { yaw = -4.90, pitch = 0.54, dist = 296, fov = 45, ty = 22, tx = 11 } },
        tags = { skills = { "cooking", "magic" }, category = { "novelty" }, membership = { "p2p" } },
    },
    {
        id = "eggsterminator", name = "Eggsterminator", kind = "item", rarity = "common",
        desc = "This modified handcannon fires scotch eggs or marshmallows.",
        art = { item = "EASTER12_HANDCANNON_PERM", cam = { yaw = 0.89, pitch = 0.17, dist = 330, ty = 64, tx = -21 } },
        tags = { skills = { "ranged" }, category = { "novelty" }, membership = { "p2p" } },
    },
    {
        id = "snowball", name = "Snowball", kind = "item", rarity = "common",
        desc = "Yep - it's a ball made of snow.",
        art = { item = "XMAS2014_SNOWBALL", cam = { yaw = 0.74, pitch = 0.96, dist = 273, ty = 36, tx = 25 } },
        tags = { category = { "novelty" }, membership = { "f2p" } },
    },
    { id = "draccles", name = "Draccles", kind = "item", rarity = "common", desc = "I'll hug him, and pet him, and squeeze him!", art = { item = "MYQ7_LOST_TOYS_PLAYER_PLUSH", cam = { yaw = 0.32, pitch = 0.29, dist = 205, ty = 80, tx = 3 } }, tags = { category = { "novelty" }, membership = { "p2p" } } },
}

return Set
