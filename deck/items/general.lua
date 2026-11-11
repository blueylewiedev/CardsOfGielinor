-- deck/items/general.lua
-- Item cards. This is the file the Card Builder points item cards at until there are enough of
-- them to split into files for each kind of item (herbs.lua, logs.lua, weapons.lua...). An item
-- card is written like an NPC card but has `kind = "item"` and names the object in `art.item`:
--
--   {
--       id = "ranarr_weed", name = "Ranarr weed", kind = "item", rarity = "uncommon",
--       desc = "...",
--       art = { item = "RANARR_WEED" },
--       tags = { skills = { "herblore" }, category = { "raw_material" } },
--   },
--
-- Item cards share their ids with the NPC cards, so an id cannot be used twice. Use the Card
-- Builder (Item button) to make one. Items are not tagged with a region or a location.

local Set = {}

Set.cards = {
    {
        id = "coins", name = "coins", kind = "item", rarity = "common",
        desc = "Lovely money!",
        art = { item = "COINS_1000", cam = { pitch = 0.52, ty = 45, tx = -39 } },
        tags = { category = { "currency" }, membership = { "f2p" } },
    },
    {
        id = "great_white_shark_bait", name = "Great white shark bait", kind = "item", rarity = "common",
        desc = "Scattering this in the deep sea should attract some great white sharks.",
        art = { item = "DSF_GREATWHITESHARK_BAIT", cam = { pitch = 1.21, dist = 186, ty = -16, tx = -1 } },
        tags = { regions = { "kandarin" }, skills = { "cooking" }, category = { "consumable" }, membership = { "p2p" } },
    },
    {
        id = "the_infernal_sauce", name = "The Infernal Sauce", kind = "item", rarity = "uncommon",
        desc = "A REALLY spicy sauce.",
        art = { item = "DUNGEON_EGWD_ZAMORAK_CHEEVO_HOTSAUCE", cam = { yaw = 0.19, pitch = 0.29, dist = 273, ty = 42, tx = 2 } },
        tags = { skills = { "cooking" }, category = { "processed_material", "ingredient" }, membership = { "p2p" } },
    },
    {
        id = "half_full_wine_jug", name = "Half full wine jug", kind = "item", rarity = "legendary",
        desc = "An optimist would say it's half full.",
        art = { item = "HALF_FULL_WINE_JUG", cam = { yaw = 0.05, pitch = 0.65, dist = 248, ty = 55, tx = 7 } },
        tags = { category = { "discontinued" }, membership = { "f2p" } },
    },
    {
        id = "extra_spicy_crunchies", name = "Extra spicy crunchies", kind = "item", rarity = "common",
        desc = "Fiery-hot, spicy crunchies, made with tender loving care.",
        art = { item = "DUEL_ARENA_REMOVAL_EXTRA_SPICY_CRUNCHIES", cam = { yaw = 1.03, pitch = 0.89, dist = 186, fov = 60, ty = -4, tx = 8 } },
        tags = { skills = { "cooking" }, membership = { "p2p" } },
    },
}

return Set
