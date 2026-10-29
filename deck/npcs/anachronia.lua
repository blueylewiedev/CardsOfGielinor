local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "anachronia" } }

Set.cards = {

    { id = "aquatic_jadinko", name = "Aquatic jadinko", rarity = "rare", desc = "A slimy plant creature.", art = { npc = "ECOSYSTEM_AQUATIC", anim = 3287, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 220 } }, tags = { regions = { "karamja" }, location = { "herblore_habitat" }, skills = { "farming", "herblore", "hunter" }, category = { "jadinko" }, membership = { "p2p" } } },
}

return Set
