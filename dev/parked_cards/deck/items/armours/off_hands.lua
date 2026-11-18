-- Parked: cards taken out of deck/items/armours/off_hands.lua on 2026-11-18 (the Dungeoneering trim, commit a6b6b3a).
-- Not loaded by the plugin and not in the release. To bring one back, move its block into the file named above
-- (see dev/parked_cards/README.md). dev/check_parked.lua checks that every card here is still sound.
local Set = {}

Set.cards = {
    {
        id = "antidragon_shield_dungeoneering", name = "Anti-dragon shield (Dungeoneering)", kind = "item", rarity = "common",
        title = "Anti-dragon shield (Dg)",
        desc = "This provides partial protection from dragonbreath attacks.",
        art = { item = "RAND_ANTIDRAGONBREATHSHIELD", cam = { yaw = -0.10, dist = 439 } },
        tags = { regions = { "daemonheim" }, skills = { "dungeoneering" }, category = { "armour", "off_hand", "hybrid_gear" }, membership = { "f2p" } },
    },
    {
        id = "roseblood_shield", name = "Roseblood shield", kind = "item", rarity = "common",
        desc = "An enchanted shield.",
        art = { item = "RAND_MAGIC_SHIELD_4", cam = { yaw = -0.46, dist = 439, ty = -48, tx = 32 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "defence", "dungeoneering" }, category = { "armour", "off_hand", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "wildercress_shield", name = "Wildercress shield", kind = "item", rarity = "common",
        desc = "An enchanted shield.",
        art = { item = "RAND_MAGIC_SHIELD_2", cam = { yaw = -0.46, dist = 439, ty = -48, tx = 32 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "defence", "dungeoneering" }, category = { "armour", "off_hand", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "duskweed_shield", name = "Duskweed shield", kind = "item", rarity = "uncommon",
        desc = "An enchanted shield.",
        art = { item = "RAND_MAGIC_SHIELD_6", cam = { yaw = -0.46, dist = 439, ty = -48, tx = 32 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "defence", "dungeoneering" }, category = { "armour", "off_hand", "magic_gear" }, membership = { "f2p" } },
    },
    {
        id = "runic_shield", name = "Runic shield", kind = "item", rarity = "rare",
        desc = "An enchanted shield.",
        art = { item = "RAND_MAGIC_SHIELD_9", cam = { yaw = -0.46, dist = 439, ty = -48, tx = 32 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "defence", "dungeoneering" }, category = { "armour", "off_hand", "magic_gear" }, membership = { "p2p" } },
    },
    {
        id = "paraleather_shield", name = "Paraleather shield", kind = "item", rarity = "common",
        desc = "A tough hide shield.",
        art = { item = "RAND_HIDE_SHIELD_3", cam = { yaw = -2.66, dist = 399, ty = -26, tx = -0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "defence", "dungeoneering" }, category = { "armour", "off_hand", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "subleather_shield", name = "Subleather shield", kind = "item", rarity = "common",
        desc = "A tough hide shield.",
        art = { item = "RAND_HIDE_SHIELD_2", cam = { yaw = -2.66, dist = 399, ty = -26, tx = -0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "defence", "dungeoneering" }, category = { "armour", "off_hand", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "gallileather_shield", name = "Gallileather shield", kind = "item", rarity = "uncommon",
        desc = "A tough hide shield.",
        art = { item = "RAND_HIDE_SHIELD_7", cam = { yaw = -2.66, dist = 399, ty = -26, tx = -0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "defence", "dungeoneering" }, category = { "armour", "off_hand", "ranged_gear" }, membership = { "f2p" } },
    },
    {
        id = "megaleather_shield", name = "Megaleather shield", kind = "item", rarity = "rare",
        desc = "A tough hide shield.",
        art = { item = "RAND_HIDE_SHIELD_9", cam = { yaw = -2.66, dist = 399, ty = -26, tx = -0 } },
        tags = { regions = { "daemonheim" }, skills = { "crafting", "defence", "dungeoneering" }, category = { "armour", "off_hand", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "sagittarian_shield", name = "Sagittarian shield", kind = "item", rarity = "epic",
        desc = "A tough hide shield.",
        art = { item = "RAND_HIDE_SHIELD_11", cam = { yaw = -2.66, dist = 399, ty = -26, tx = -0 } },
        tags = { regions = { "daemonheim" }, skills = { "defence", "dungeoneering" }, category = { "armour", "off_hand", "ranged_gear" }, membership = { "p2p" } },
    },
    {
        id = "primal_kiteshield_dungeoneering", name = "Primal kiteshield (Dungeoneering)", kind = "item", rarity = "epic",
        title = "Primal kiteshield (Dg)",
        desc = "A large metal shield.",
        art = { item = "RAND_KITESHIELD_11", cam = { yaw = 0.02, dist = 585, ty = -0, tx = -11 } },
        tags = { regions = { "daemonheim" }, skills = { "defence", "dungeoneering" }, category = { "armour", "off_hand", "melee_gear" }, membership = { "p2p" } },
    },
}

return Set
