local Set = {}

Set.cards = {
    {
        id = "alchemical_hydrix_dust", name = "Alchemical hydrix dust", kind = "item", rarity = "legendary",
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
    { id = "poison_karambwan", name = "Poison karambwan", kind = "item", rarity = "common", desc = "Cooked octopus. It looks poorly cooked and quite dangerous.", art = { item = "TBWT_POORLY_COOKED_KARAMBWAN", cam = { pitch = 1.05, dist = 525, ty = -40 } }, tags = { regions = { "karamja" }, skills = { "cooking" }, category = { "consumable" }, membership = { "p2p" } } },
}

return Set