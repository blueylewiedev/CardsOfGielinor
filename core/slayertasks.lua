-- core/slayertasks.lua
-- Which monsters count for which Slayer task, as data. Used by core/slayer.lua.
--
-- Every monster in the game carries one Slayer category (its SLAYER_CATEGORY parameter), a number that is a key of
-- the game's Slayer task list (enum 1563, SMKI_CRITTER_NAMES), and the player's task (VarPlayer 185) is another key
-- of the same list. A narrow task (Green dragons) counts the monsters with that category. A broad task (Dragons,
-- Demons, Undead...) also counts the monsters of narrower categories, and the game does not say which in any data
-- the client can read, so they are listed here. Names are the task names in lower case, as the game's list spells
-- them, so an entry works for every number that has that name.
--
-- Where this came from: the RuneScape Wiki's Slayer assignment pages (the monsters each one lists), reduced to the
-- surface versions of the monsters and checked with kills in the game (an Imp, Lesser demons and Black demons count for
-- Demons; Blue and Bronze dragons for Dragons). The owner reviewed it on 2026-11-15: Greater demons are in Demons,
-- Hellhounds are not (only the Zamorakian Undercity ones count) and Rune dragons are in Dragons.

local SlayerTasks = {}

-- broad task name -> the narrower task names whose monsters also count for it.
SlayerTasks.includes = {
    ["dragons"] = {
        "black dragons", "nodon dragonkin", "gemstone dragons", "blue dragons", "celestial dragons", "green dragons",
        "red dragons", "rune dragons", "adamant dragons", "bronze dragons", "hydrix dragons", "iron dragons",
        "mithril dragons", "onyx dragons", "steel dragons",
    },
    ["demons"] = {
        "lesser demons", "greater demons", "black demons", "abyssal demons", "gargoyles", "tormented demons",
        "greater demon berserkers and ash lords", "kal'gerion demons", "abyssal beasts", "abyssal lords",
        "abyssal savages",
    },
    ["undead"] = {
        "ghosts", "zombies", "skeletons", "revenants", "shades", "phantoms", "banshees", "zemouregal's undead",
        "crawling hands", "aberrant spectres", "ankou", "armoured phantoms", "bound skeletons", "edimmu",
        "fetid zombies", "risen ghosts", "shadow warriors", "skeletal wyverns", "spiritual mages", "spiritual rangers",
        "spiritual warriors",
    },
    ["ghosts"] = {
        "revenants", "shades", "banshees", "aberrant spectres", "ankou", "edimmu", "risen ghosts", "shadow warriors",
        "spiritual mages", "spiritual rangers", "spiritual warriors",
    },
    ["zombies"] = { "crawling hands", "edimmu", "fetid zombies" },
    ["skeletons"] = { "ankou", "bound skeletons", "skeletal wyverns" },
    ["creatures of daemonheim"] = { "stalker creatures", "kal'gerion demons", "edimmu", "soulgazers" },
    ["strykewyrms"] = { "lava strykewyrms", "desert strykewyrms", "ice strykewyrms", "jungle strykewyrms" },
    ["aviansies"] = { "spiritual mages", "spiritual rangers", "spiritual warriors" },
    ["polypore creatures"] = { "ganodermic creatures", "grifolapines", "grifolaroos" },
    ["gemstone dragons"] = { "hydrix dragons", "onyx dragons" },
    ["abyssal demons"] = { "abyssal beasts", "abyssal lords", "abyssal savages" },
    ["zemouregal's undead"] = { "armoured phantoms", "bound skeletons", "fetid zombies", "risen ghosts" },
}

-- How many kills of a task one of these monsters counts as (the wiki's Demons page: "abyssal beasts and abyssal
-- lords ... count as two and five respectively"). One of them drops the task's kill count by that much, but it is one
-- kill for credits. Any other monster is one.
SlayerTasks.units = {
    ["abyssal beasts"] = 2,
    ["abyssal lords"] = 5,
}

return SlayerTasks
