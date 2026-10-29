local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "karamja" } }

Set.cards = {

    {
        id = "elvarg", name = "Elvarg", rarity = "epic",
        desc = "A dragon who prefers to be left alone.",
        art = { anim = 14256, cam = { yaw = 0.40, pitch = -0.15, dist = 3998, fov = 20, ty = 500, tx = 40 } },
        tags = { category = { "dragon", "boss", "monster" } },
    },
    { id = "amphibious_jadinko", name = "Amphibious jadinko", rarity = "rare", desc = "A froggish plant creature.", art = { npc = "ECOSYSTEM_AMPHIBIAN", anim = 3287, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } }, tags = { regions = { "anachronia" }, location = { "herblore_habitat" }, skills = { "farming", "herblore", "hunter" }, category = { "jadinko" }, membership = { "p2p" } } },
    { id = "carrion_jadinko", name = "Carrion jadinko", rarity = "rare", desc = "A plant creature that smells unpleasant.", art = { npc = "ECOSYSTEM_CARRION", anim = 3287, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } }, tags = { regions = { "anachronia" }, location = { "herblore_habitat" }, skills = { "farming", "herblore", "hunter" }, category = { "jadinko" }, membership = { "p2p" } } },
    { id = "common_jadinko", name = "Common jadinko", rarity = "rare", desc = "A strange plant beast.", art = { npc = "ECOSYSTEM_BASIC", anim = 3287, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } }, tags = { regions = { "anachronia" }, location = { "herblore_habitat" }, skills = { "farming", "herblore", "hunter" }, category = { "jadinko" }, membership = { "p2p" } } },
}

return Set
