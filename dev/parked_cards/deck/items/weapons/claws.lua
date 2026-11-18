-- Parked: cards taken out of deck/items/weapons/claws.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "offhand_chaotic_claw", name = "Off-hand chaotic claw", kind = "item", rarity = "rare",
        desc = "An off-hand chaotic slashing claw.",
        art = { item = "RAND_CLAW_80_REWARD_O", cam = { yaw = 2.23, dist = 635, fov = 30, ty = 15, tx = -10 } },
        tags = { regions = { "daemonheim" }, skills = { "attack" }, category = { "weapon", "melee_gear", "claw" }, membership = { "p2p" } },
    },
}

return Set
