local Set = {}

Set.cards = {
    {
        id = "lemon_sole_rune", name = "Lemon sole rune", kind = "item", rarity = "common",
        desc = "Infused with the power of lemon.",
        art = { item = "PENG_BTTF_RUNE", cam = { pitch = 1.55 } },
        tags = { category = { "quest_item", "rune" }, membership = { "p2p" } },
    },
    {
        id = "life_rune", name = "Life rune", kind = "item", rarity = "common",
        desc = "The legendary rune appears to be true. But how did it end up here?",
        art = { item = "GOWER_LIFE_RUNE", cam = { tx = 10 } },
        tags = { category = { "rune", "quest_item" }, membership = { "f2p" } },
    },
    {
        id = "thok_rune", name = "Thok rune", kind = "item", rarity = "common",
        desc = "The most powerful rune there is.",
        art = { item = "FREMSAGA_THOKRUNE", cam = { tx = 10 } },
        tags = { category = { "quest_item", "rune" }, membership = { "p2p" } },
    },
    {
        id = "unfinished_astral_rune", name = "Unfinished astral rune", kind = "item", rarity = "common",
        desc = "It definitely doesn't belong to anyone you know about.",
        art = { item = "GLOMEM_RUNE", cam = { tx = 10 } },
        tags = { category = { "quest_item", "rune" }, membership = { "p2p" } },
    },
    {
        id = "air_rune", name = "Air rune", kind = "item", rarity = "common",
        desc = "One of the four basic elemental runes. Used in Magic.",
        art = { item = "AIRRUNE", cam = { tx = 10 } },
        tags = { regions = { "asgarnia" }, skills = { "magic", "runecrafting" }, category = { "rune" }, membership = { "f2p" } },
    },
    {
        id = "air_rune_dungeoneering", name = "Air rune (Dungeoneering)", kind = "item", rarity = "common",
        desc = "One of the four basic elemental runes.",
        art = { item = "RAND_AIRRUNE", cam = { tx = 10 } },
        tags = { regions = { "daemonheim" }, skills = { "magic", "dungeoneering" }, category = { "rune" }, membership = { "f2p" } },
    },






























}

return Set