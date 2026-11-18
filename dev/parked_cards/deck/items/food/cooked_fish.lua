-- Parked: cards taken out of deck/items/food/cooked_fish.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "raw_heim_crab", name = "Raw heim crab", kind = "item", rarity = "common",
        desc = "I should try cooking this.",
        art = { item = "RAND_RAW_FISH_1", cam = { pitch = 1.55, dist = 397, fov = 60, ty = 11, tx = 25 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "fish", "raw_material" }, membership = { "f2p" } },
    },
    {
        id = "raw_redeye", name = "Raw red-eye", kind = "item", rarity = "common",
        desc = "I should try cooking this.",
        art = { item = "RAND_RAW_FISH_2", cam = { yaw = 0.12, pitch = 1.55, dist = 361, fov = 60, ty = -14, tx = 16 } },
        tags = { regions = { "daemonheim" }, skills = { "fishing", "dungeoneering" }, category = { "raw_material", "fish" }, membership = { "f2p" } },
    },
}

return Set