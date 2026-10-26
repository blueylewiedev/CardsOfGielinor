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

}

return Set
