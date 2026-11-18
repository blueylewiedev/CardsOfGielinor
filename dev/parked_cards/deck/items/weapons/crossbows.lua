-- Parked: cards taken out of deck/items/weapons/crossbows.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "offhand_chaotic_crossbow", name = "Off-hand chaotic crossbow", kind = "item", rarity = "rare",
        desc = "A small crossbow, only effective at short distance.",
        art = { item = "RAND_XBOW_80_REWARD_O", cam = { yaw = -0.42, pitch = -0.96, dist = 87, ty = 219, tx = -91 } },
        tags = { regions = { "daemonheim" }, skills = { "ranged" }, category = { "weapon", "ranged_gear", "crossbow" }, membership = { "p2p" } },
    },
    {
        id = "offhand_ruinous_crossbow", name = "Off-hand ruinous crossbow", kind = "item", rarity = "epic",
        desc = "A small crossbow, only effective at short distance.",
        art = { item = "RAND_XBOW_90_REWARD_O", cam = { yaw = -2.56, pitch = 0.64, dist = 300, ty = 28, tx = 4 } },
        tags = { regions = { "daemonheim" }, skills = { "ranged" }, category = { "weapon", "ranged_gear", "crossbow" }, membership = { "p2p" } },
    },
}

return Set
