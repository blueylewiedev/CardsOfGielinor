local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "kharidian_desert" } }

Set.cards = {

    {
        id = "golden_warbler", name = "Golden warbler", rarity = "common",
        desc = "Actually, golden screecher might be a more appropriate name.",
        art = { npc = "HUNTING_BIRD_DESERT", anim = 6773, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 900 } },
        tags = { regions = { "anachronia" }, location = { "uzer_hunter_area" }, skills = { "hunter" }, category = { "animal" }, membership = { "p2p" } },
    },
    { id = "tefimhet", name = "Tefimhet", rarity = "common", desc = "Found a place where he can breathe easy.", art = { npc = "MENAPHOS_COLLECTIONS_CAT13", anim = 19269, cam = { yaw = -0.60, pitch = 0.30, dist = 989, fov = 35, ty = 160, tx = 10 } }, tags = { regions = { "wilderness" }, location = { "soul_rune_temple" }, category = { "animal" }, membership = { "p2p" } } },
}

return Set
