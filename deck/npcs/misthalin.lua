-- deck/npcs/misthalin.lua
-- NPC cards for Lumbridge, Draynor, Varrock and the rest of the kingdom of Misthalin. Every card in this file is tagged `regions = { "misthalin" }`
-- automatically (see `defaults`), so each card only lists its own town, skills and category.
--
-- Only NPCs that belong to this region go here. NPCs found all over the game (guards, shop
-- keepers, animals) go in deck/npcs/general.lua instead, so a card for them counts for all of
-- them and region packs do not draw them.
--
-- Every card below is a draft: its `art = { npc = "" }` is empty, because the NPC's config
-- name has to be found in the game (stand next to the NPC and use Nearby NPCs in the dev
-- tools). Until `npc` has a name in it, the card is left out of packs, the collection and the
-- totals, so an unfinished card never shows up as a blank card. Fill in the name, reload the
-- plugin, and the card goes live. Add `body = true` to `art` for an NPC with no chathead, and
-- tune the camera in the preview as usual.
--
-- The `id` is what gets saved, so do not change it once the card is live. It does not have to
-- match the NPC: the NPC comes from `art.npc`.
--
-- Tag words must be on the lists in Cards.tagWords (cards.lua), or the plugin refuses to load
-- and tells you which card has the typo.

local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "misthalin" } }

Set.cards = {
    { id = "hatius",       name = "Hatius Cosaintus", rarity = "uncommon", desc = "Knows every story about Lumbridge.",   art = { npc = "" }, tags = { towns = { "lumbridge" }, category = { "humanoid" } } },
    { id = "doomsayer",    name = "Doomsayer",        rarity = "uncommon", desc = "Always certain the end is near.",       art = { npc = "" }, tags = { towns = { "lumbridge" }, category = { "humanoid" } } },
    { id = "restless_ghost", name = "Restless ghost", rarity = "rare",     desc = "Just wants its skull back.",            art = { npc = "" }, tags = { towns = { "lumbridge" }, category = { "undead" } } },
}

return Set
