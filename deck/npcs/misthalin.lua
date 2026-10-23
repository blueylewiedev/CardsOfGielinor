-- deck/npcs/misthalin.lua
-- NPC cards for Lumbridge, Draynor, Varrock and the rest of the kingdom of Misthalin. Every card in this file is tagged `regions = { "misthalin" }`
-- automatically (see `defaults`), so each card only lists its own town, skills and category.
--
-- Only NPCs that belong to this region go here. NPCs found all over the game (guards, shop
-- keepers, animals) go in deck/npcs/general.lua instead, so a card for them counts for all of
-- them and region packs do not draw them.
--
-- Cards whose `art = { npc = "" }` is empty are drafts: the NPC's config name still has to be
-- found in the game (stand next to the NPC and use Nearby NPCs in the dev
-- tools). Until `npc` is filled in, a draft is left out of packs, the collection and the
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
    -- Live cards (these are in the game)
    { id = "hans",       name = "Hans",        rarity = "uncommon",  desc = "Has walked Lumbridge Castle forever.", tags = { towns = { "lumbridge" }, category = { "humanoid" } } },
    { id = "guide",      name = "Lumbridge Guide", rarity = "uncommon", desc = "Happy to help new adventurers.", art = { npc = "LUMBRIDGE_GUIDE" }, tags = { towns = { "lumbridge" }, category = { "humanoid" } } },
    { id = "cook",       name = "Cook",        rarity = "uncommon",  desc = "Always one ingredient short of a cake.", tags = { towns = { "lumbridge" }, skills = { "cooking" }, category = { "humanoid" } } },
    { id = "bob",        name = "Bob",         rarity = "uncommon",  desc = "Sells axes and strong opinions.", tags = { towns = { "lumbridge" }, skills = { "woodcutting" }, category = { "shopkeeper" } } },
    { id = "fred",       name = "Fred the Farmer", rarity = "uncommon", desc = "Very fond of his sheep.", art = { npc = "FRED_THE_FARMER" }, tags = { towns = { "lumbridge" }, skills = { "farming" }, category = { "humanoid" } } },
    { id = "aereck",     name = "Father Aereck", rarity = "uncommon", desc = "Keeps the chapel quiet and tidy.", art = { npc = "FATHER_AERECK" }, tags = { towns = { "lumbridge" }, skills = { "prayer" }, category = { "humanoid" } } },
    { id = "horacio",    name = "Duke Horacio", rarity = "rare",     desc = "Rules Lumbridge from the castle.", tags = { towns = { "lumbridge" }, category = { "royalty" } } },
    { id = "gertrude",   name = "Gertrude",    rarity = "rare",      desc = "Lives with a great many cats.", tags = { towns = { "varrock" }, category = { "humanoid" } } },
    { id = "aggie",      name = "Aggie",       rarity = "rare",      desc = "Mixes dyes and asks for coins.", tags = { towns = { "draynor" }, skills = { "herblore" }, category = { "humanoid" } } },
    { id = "wise_old_man", name = "Wise Old Man", rarity = "epic",   desc = "Claims to know a great deal about everything.", tags = { towns = { "draynor" }, category = { "humanoid" } } },

    -- Drafts (waiting for an NPC name)
    { id = "hatius",       name = "Hatius Cosaintus", rarity = "uncommon", desc = "Knows every story about Lumbridge.",   art = { npc = "" }, tags = { towns = { "lumbridge" }, category = { "humanoid" } } },
    { id = "doomsayer",    name = "Doomsayer",        rarity = "uncommon", desc = "Always certain the end is near.",       art = { npc = "" }, tags = { towns = { "lumbridge" }, category = { "humanoid" } } },
    { id = "restless_ghost", name = "Restless ghost", rarity = "rare",     desc = "Just wants its skull back.",            art = { npc = "" }, tags = { towns = { "lumbridge" }, category = { "undead" } } },
}

return Set
