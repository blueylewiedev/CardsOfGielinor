-- deck/npcs/kandarin.lua
-- NPC cards for Ardougne, Seers' Village, Yanille and the rest of Kandarin. Every card in this file is tagged `regions = { "kandarin" }`
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
-- plugin, and the card goes live. NPC cards show the body model by default (add `body = false` to `art` for the head), and
-- tune the camera in the preview as usual.
--
-- The `id` is what gets saved, so do not change it once the card is live. It does not have to
-- match the NPC: the NPC comes from `art.npc`.
--
-- Tag words must be on the lists in Cards.tagWords (core/cards.lua), or the plugin refuses to load
-- and tells you which card has the typo.

local Set = {}

-- Tags every card in this file gets.
Set.defaults = { regions = { "kandarin" } }

Set.cards = {
    -- Drafts (waiting for an NPC name)

    {
        id = "king_lathas", name = "King Lathas", rarity = "epic",
        desc = "Rules Ardougne with a firm hand.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, category = { "royalty" } },
    },

    {
        id = "edmond", name = "Edmond", rarity = "uncommon",
        desc = "Worries about his daughter Elena.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, category = { "humanoid" } },
    },

    {
        id = "elena", name = "Elena", rarity = "uncommon",
        desc = "Came to help against the plague.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, category = { "humanoid" } },
    },

    {
        id = "mourner", name = "Mourner", rarity = "common",
        desc = "Hides behind a mask and a cloak.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, category = { "humanoid" } },
    },

    {
        id = "head_mourner", name = "Head mourner", rarity = "rare",
        desc = "Keeps the plague wall closed.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, category = { "humanoid" } },
    },

    {
        id = "ardougne_knight", name = "Knight of Ardougne", rarity = "common",
        desc = "Guards the city and carries coin.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, skills = { "thieving" }, category = { "knight" } },
    },

    {
        id = "paladin", name = "Paladin", rarity = "rare",
        desc = "A holy warrior with full pockets.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, skills = { "thieving" }, category = { "knight" } },
    },

    {
        id = "hero", name = "Hero", rarity = "epic",
        desc = "Rarely seen without a full pack.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, skills = { "thieving" }, category = { "adventurer" } },
    },

    {
        id = "baker", name = "Baker", rarity = "common",
        desc = "Sells fresh bread from a stall.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },

    {
        id = "silk_merchant", name = "Silk merchant", rarity = "uncommon",
        desc = "Haggles over every roll of silk.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },

    {
        id = "fur_trader", name = "Fur trader", rarity = "uncommon",
        desc = "Keeps warm and prices high.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },

    {
        id = "spice_seller", name = "Spice seller", rarity = "uncommon",
        desc = "Smells of cinnamon and bargains.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },

    {
        id = "gem_merchant", name = "Gem merchant", rarity = "rare",
        desc = "Keeps the best gems under glass.",
        art = { npc = "" },
        tags = { towns = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },
}

return Set
