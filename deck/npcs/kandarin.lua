-- deck/npcs/kandarin.lua
-- NPC cards for Ardougne, Seers' Village, Yanille and the rest of Kandarin. Every card in this file is tagged `regions = { "kandarin" }`
-- automatically (see `defaults`), so each card only lists its own location, skills and category.
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
        tags = { location = { "ardougne" }, category = { "royalty" } },
    },

    {
        id = "edmond", name = "Edmond", rarity = "uncommon",
        desc = "Worries about his daughter Elena.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, category = { "humanoid" } },
    },

    {
        id = "elena", name = "Elena", rarity = "uncommon",
        desc = "Came to help against the plague.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, category = { "humanoid" } },
    },

    {
        id = "mourner", name = "Mourner", rarity = "common",
        desc = "Hides behind a mask and a cloak.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, category = { "humanoid" } },
    },

    {
        id = "head_mourner", name = "Head mourner", rarity = "rare",
        desc = "Keeps the plague wall closed.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, category = { "humanoid" } },
    },

    {
        id = "ardougne_knight", name = "Knight of Ardougne", rarity = "common",
        desc = "Guards the city and carries coin.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, skills = { "thieving" }, category = { "knight" } },
    },

    {
        id = "paladin", name = "Paladin", rarity = "rare",
        desc = "A holy warrior with full pockets.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, skills = { "thieving" }, category = { "knight" } },
    },

    {
        id = "hero", name = "Hero", rarity = "epic",
        desc = "Rarely seen without a full pack.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, skills = { "thieving" }, category = { "adventurer" } },
    },

    {
        id = "baker", name = "Baker", rarity = "common",
        desc = "Sells fresh bread from a stall.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },

    {
        id = "silk_merchant", name = "Silk merchant", rarity = "uncommon",
        desc = "Haggles over every roll of silk.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },

    {
        id = "fur_trader", name = "Fur trader", rarity = "uncommon",
        desc = "Keeps warm and prices high.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },

    {
        id = "spice_seller", name = "Spice seller", rarity = "uncommon",
        desc = "Smells of cinnamon and bargains.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },

    {
        id = "gem_merchant", name = "Gem merchant", rarity = "rare",
        desc = "Keeps the best gems under glass.",
        art = { npc = "" },
        tags = { location = { "ardougne" }, skills = { "thieving" }, category = { "stallholder" } },
    },
    {
        id = "guard", name = "Guard (Catherby)", rarity = "common",
        desc = "Maintaining order in the market",
        art = { npc = "OMGE_MARKET_GUARD", anim = 808, cam = { pitch = 0.15, dist = 859, ty = 480 } },
        tags = { location = { "catherby" }, category = { "humanoid", "guard", "monster" } },
    },
    
    {
        id = "crimson_swift", name = "Crimson swift", rarity = "common",
        desc = "This bird obviously doesn't believe in subtlety.",
        art = { npc = "HUNTING_BIRD_JUNGLE", anim = 6773, cam = { yaw = -0.40, pitch = 0.30, dist = 989, fov = 35, ty = 920 } },
        tags = { regions = { "asgarnia" }, location = { "feldip_hunter_area", "taverley" }, skills = { "hunter" }, category = { "animal" }, membership = { "f2p" } },
    },
    { id = "monkey", name = "Monkey", rarity = "common", desc = "Perhaps our oldest relatives?", art = { npc = "MONKEY", anim = 219, cam = { yaw = -0.60, dist = 989, fov = 35, ty = 220, tx = 50 } }, tags = { regions = { "karamja" }, category = { "animal", "monster" }, membership = { "f2p" } } },
    { id = "snake", name = "Snake", rarity = "common", desc = "A slithering serpent.", art = { npc = "SNAKE", anim = 277, cam = { pitch = 0.30, dist = 749, fov = 35, ty = 100 } }, tags = { regions = { "karamja" }, category = { "animal", "monster" }, membership = { "f2p" } } },
    { id = "barbarian", name = "Barbarian", rarity = "common", desc = "Alberich, a fierce barbarian warrior.", art = { npc = "FAI_BARBARIAN_1", anim = 2561, cam = { yaw = -0.20, pitch = 0.15, dist = 859, ty = 480 } }, tags = { regions = { "misthalin" }, category = { "humanoid", "monster" }, membership = { "f2p" } } },
    { id = "highwayman", name = "Highwayman", rarity = "common", desc = "They hold up passers by.", art = { npc = "HIGHWAYMAN", anim = 18015, cam = { yaw = 0.20, pitch = 0.30, dist = 428, fov = 105, ty = 480 } }, tags = { regions = { "asgarnia" }, category = { "humanoid", "monster" }, membership = { "f2p" } } },
    { id = "zamorak_mage", name = "Zamorak mage", rarity = "uncommon", desc = "A mage of Zamorak.", art = { npc = "RC_ZMI_MAGE", anim = 20211, cam = { pitch = 0.15, dist = 859, ty = 480 } }, tags = { regions = { "wilderness" }, category = { "humanoid", "monster" }, membership = { "p2p" } } },
    { id = "zamorak_warrior", name = "Zamorak warrior", rarity = "uncommon", desc = "A warrior of Zamorak.", art = { npc = "RC_ZMI_MELEE2", anim = 14730, cam = { pitch = 0.15, dist = 859, ty = 480 } }, tags = { regions = { "wilderness" }, category = { "humanoid", "monster" }, membership = { "p2p" } } },
    { id = "black_warlock", name = "Black warlock", rarity = "uncommon", desc = "A black warlock. The air seems to distort wherever it passes.", art = { npc = "BUTTERFLY_WARLOCK", anim = 362, cam = { pitch = 0.30, dist = 1137, fov = 35, ty = 800 } }, tags = { regions = { "anachronia" }, location = { "feldip_hunter_area" }, skills = { "agility", "hunter" }, category = { "insect" }, membership = { "p2p" } } },
    { id = "ruby_harvest", name = "Ruby harvest", rarity = "common", desc = "It's a ruby harvest butterfly.", art = { npc = "BUTTERFLY_RUBY", anim = 362, cam = { pitch = 0.30, dist = 1137, ty = 720 } }, tags = { regions = { "anachronia" }, location = { "piscatoris_hunter_area" }, skills = { "agility", "hunter" }, category = { "insect" }, membership = { "p2p" } } },
}

return Set
