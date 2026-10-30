local Set = {}

Set.cards = {
    {
        id = "enchanted_gem", name = "Enchanted gem", kind = "item", rarity = "common",
        desc = "I can contact the Slayer Masters with this.",
        art = { item = "SLAYER_GEM", cam = { yaw = -0.40, pitch = 1.30, dist = 525, fov = 25 } },
        tags = { skills = { "slayer" }, category = { "pocket", "tool" }, membership = { "f2p" } },
    },
    { id = "grim_gem", name = "Grim gem", kind = "item", rarity = "common", desc = "I can contact Death with this.", art = { item = "BSLAY_GEM", cam = { pitch = 1.55, dist = 525, fov = 30 } }, tags = { regions = { "misthalin" }, skills = { "slayer" }, category = { "pocket", "tool" }, membership = { "p2p" } } },
}

return Set