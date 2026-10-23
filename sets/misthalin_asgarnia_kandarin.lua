-- sets/misthalin_asgarnia_kandarin.lua
-- A set of cards for Lumbridge (Misthalin), Falador (Asgarnia) and Ardougne (Kandarin), plus
-- the region, town and skill tags for the cards in cards.lua.
--
-- HOW THE CARDS IN HERE BECOME REAL
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

local MISTHALIN_LUMBRIDGE = { regions = { "misthalin" }, towns = { "lumbridge" } }
local ASGARNIA_FALADOR = { regions = { "asgarnia" }, towns = { "falador" } }
local KANDARIN_ARDOUGNE = { regions = { "kandarin" }, towns = { "ardougne" } }

-- Makes a copy of a tag table with more tags added, e.g. with(KANDARIN_ARDOUGNE, "skills", "thieving").
local function with(base, tagKind, word, category)
    local copy = {}
    for kind, words in pairs(base) do
        copy[kind] = { table.unpack(words) }
    end
    if tagKind then
        copy[tagKind] = { word }
    end
    if category then
        copy.category = { category }
    end
    return copy
end

Set.cards = {
    -- Lumbridge, Misthalin
    { id = "hatius",       name = "Hatius Cosaintus", rarity = "uncommon", desc = "Knows every story about Lumbridge.",   art = { npc = "" }, tags = with(MISTHALIN_LUMBRIDGE, nil, nil, "humanoid") },
    { id = "doomsayer",    name = "Doomsayer",        rarity = "uncommon", desc = "Always certain the end is near.",       art = { npc = "" }, tags = with(MISTHALIN_LUMBRIDGE, nil, nil, "humanoid") },
    { id = "giant_frog",   name = "Giant frog",       rarity = "common",   desc = "Croaks all day in the swamp.",          art = { npc = "" }, tags = with(MISTHALIN_LUMBRIDGE, nil, nil, "animal") },
    { id = "restless_ghost", name = "Restless ghost", rarity = "rare",     desc = "Just wants its skull back.",            art = { npc = "" }, tags = with(MISTHALIN_LUMBRIDGE, nil, nil, "undead") },
    { id = "shop_keeper",  name = "Shop keeper",      rarity = "common",   desc = "Sells a little bit of everything.",     art = { npc = "" }, tags = with(MISTHALIN_LUMBRIDGE, nil, nil, "humanoid") },

    -- Falador, Asgarnia
    { id = "sir_amik_varze", name = "Sir Amik Varze", rarity = "rare",     desc = "Leads the White Knights proudly.",      art = { npc = "" }, tags = with(ASGARNIA_FALADOR, nil, nil, "knight") },
    { id = "sir_vyvin",    name = "Sir Vyvin",        rarity = "rare",     desc = "Guards the castle and a secret.",       art = { npc = "" }, tags = with(ASGARNIA_FALADOR, nil, nil, "knight") },
    { id = "sir_tiffy",    name = "Sir Tiffy Cashien", rarity = "uncommon", desc = "Recruits new knights in the park.",     art = { npc = "" }, tags = with(ASGARNIA_FALADOR, nil, nil, "knight") },
    { id = "wayne",        name = "Wayne",            rarity = "uncommon", desc = "Chainmail for every budget.",           art = { npc = "" }, tags = with(ASGARNIA_FALADOR, "skills", "smithing", "shopkeeper") },
    { id = "flynn",        name = "Flynn",            rarity = "uncommon", desc = "Sells maces with a smile.",             art = { npc = "" }, tags = with(ASGARNIA_FALADOR, nil, nil, "shopkeeper") },
    { id = "cassie",       name = "Cassie",           rarity = "uncommon", desc = "Sells shields to the knights.",         art = { npc = "" }, tags = with(ASGARNIA_FALADOR, nil, nil, "shopkeeper") },
    { id = "herquin",      name = "Herquin",          rarity = "uncommon", desc = "Buys and sells gems.",                  art = { npc = "" }, tags = with(ASGARNIA_FALADOR, nil, nil, "shopkeeper") },
    { id = "hairdresser",  name = "Hairdresser",      rarity = "common",   desc = "Offers a fresh new look.",              art = { npc = "" }, tags = with(ASGARNIA_FALADOR, nil, nil, "humanoid") },
    { id = "white_knight", name = "White Knight",     rarity = "common",   desc = "Sworn to defend Falador.",              art = { npc = "" }, tags = with(ASGARNIA_FALADOR, nil, nil, "knight") },
    { id = "falador_guard", name = "Guard",           rarity = "common",   desc = "Keeps the streets of Falador safe.",    art = { npc = "" }, tags = with(ASGARNIA_FALADOR, "skills", "thieving", "guard") },

    -- Ardougne, Kandarin
    { id = "king_lathas",  name = "King Lathas",      rarity = "epic",     desc = "Rules Ardougne with a firm hand.",      art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, nil, nil, "royalty") },
    { id = "edmond",       name = "Edmond",           rarity = "uncommon", desc = "Worries about his daughter Elena.",     art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, nil, nil, "humanoid") },
    { id = "elena",        name = "Elena",            rarity = "uncommon", desc = "Came to help against the plague.",      art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, nil, nil, "humanoid") },
    { id = "mourner",      name = "Mourner",          rarity = "common",   desc = "Hides behind a mask and a cloak.",      art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, nil, nil, "humanoid") },
    { id = "head_mourner", name = "Head mourner",     rarity = "rare",     desc = "Keeps the plague wall closed.",         art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, nil, nil, "humanoid") },
    { id = "ardougne_knight", name = "Knight of Ardougne", rarity = "common", desc = "Guards the city and carries coin.",  art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, "skills", "thieving", "knight") },
    { id = "paladin",      name = "Paladin",          rarity = "rare",     desc = "A holy warrior with full pockets.",     art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, "skills", "thieving", "knight") },
    { id = "hero",         name = "Hero",             rarity = "epic",     desc = "Rarely seen without a full pack.",      art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, "skills", "thieving", "adventurer") },
    { id = "baker",        name = "Baker",            rarity = "common",   desc = "Sells fresh bread from a stall.",       art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, "skills", "thieving", "stallholder") },
    { id = "silk_merchant", name = "Silk merchant",   rarity = "uncommon", desc = "Haggles over every roll of silk.",      art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, "skills", "thieving", "stallholder") },
    { id = "fur_trader",   name = "Fur trader",       rarity = "uncommon", desc = "Keeps warm and prices high.",           art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, "skills", "thieving", "stallholder") },
    { id = "spice_seller", name = "Spice seller",     rarity = "uncommon", desc = "Smells of cinnamon and bargains.",      art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, "skills", "thieving", "stallholder") },
    { id = "gem_merchant", name = "Gem merchant",     rarity = "rare",     desc = "Keeps the best gems under glass.",      art = { npc = "" }, tags = with(KANDARIN_ARDOUGNE, "skills", "thieving", "stallholder") },
}

-- Tags for cards that live in cards.lua. Keys are card ids; the tags are added to any the card
-- already has. An id that is not in cards.lua is ignored (and logged), so renamed cards never
-- stop the plugin from loading.
Set.retag = {
    ["chicken"]                  = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "animal" } },
    ["POF_ANIMAL_COW_COW"]       = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "animal" } },
    ["sheep"]                    = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "animal" } },
    ["GOBLIN_UNARMED_MELEE_1"]   = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "monster" } },
    ["LUMBRIDGE_GIANTRAT_BROWN"] = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "animal" } },
    ["LUMBRIDGE_MARKET_MAN1"]    = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "humanoid" } },
    ["dog_stray"]                = { regions = { "misthalin" }, category = { "animal" } },
    ["hans"]                     = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "humanoid" } },
    ["guide"]                    = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "humanoid" } },
    ["cook"]                     = { regions = { "misthalin" }, towns = { "lumbridge" }, skills = { "cooking" }, category = { "humanoid" } },
    ["bob"]                      = { regions = { "misthalin" }, towns = { "lumbridge" }, skills = { "woodcutting" }, category = { "shopkeeper" } },
    ["fred"]                     = { regions = { "misthalin" }, towns = { "lumbridge" }, skills = { "farming" }, category = { "humanoid" } },
    ["aereck"]                   = { regions = { "misthalin" }, towns = { "lumbridge" }, skills = { "prayer" }, category = { "humanoid" } },
    ["horacio"]                  = { regions = { "misthalin" }, towns = { "lumbridge" }, category = { "royalty" } },
    ["doric"]                    = { regions = { "asgarnia" }, skills = { "smithing" }, category = { "shopkeeper" } },
    ["gertrude"]                 = { regions = { "misthalin" }, towns = { "varrock" }, category = { "humanoid" } },
    ["aggie"]                    = { regions = { "misthalin" }, towns = { "draynor" }, skills = { "herblore" }, category = { "humanoid" } },
    ["wise_old_man"]             = { regions = { "misthalin" }, towns = { "draynor" }, category = { "humanoid" } },
}

return Set
