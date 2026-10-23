-- deck/retag.lua
-- Tags for the cards that are still written in cards.lua. Keys are card ids; the tags are added
-- to any the card already has. An id that is not in cards.lua is ignored (and logged), so
-- renamed cards never stop the plugin from loading.
--
-- Only cards that belong to one place get region and town tags. Creatures and people found all
-- over the game (chickens, cows, sheep, goblins, giant rats, men, dogs) only get a category,
-- so region packs do not draw them. This file goes away once these cards move into the files
-- in deck/npcs/.

return {
    ["chicken"]                  = { category = { "animal" } },
    ["POF_ANIMAL_COW_COW"]       = { category = { "animal" } },
    ["sheep"]                    = { category = { "animal" } },
    ["GOBLIN_UNARMED_MELEE_1"]   = { category = { "monster" } },
    ["LUMBRIDGE_GIANTRAT_BROWN"] = { category = { "animal" } },
    ["LUMBRIDGE_MARKET_MAN1"]    = { category = { "humanoid" } },
    ["dog_stray"]                = { category = { "animal" } },
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
