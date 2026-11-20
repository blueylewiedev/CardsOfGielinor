-- core/slayertasks.lua
-- Which monsters count for which Slayer task, as data for core/slayer.lua. Every monster carries one Slayer category
-- (its SLAYER_CATEGORY parameter), a key of the game's task list (enum 1563), and the player's task (VarPlayer 185)
-- is another key of it. A narrow task counts the monsters with that category; a broad one (Dragons, Demons,
-- Undead...) also counts narrower categories, which the client cannot say, so they are listed here by the task names
-- in lower case. Source: the RuneScape Wiki's Slayer assignment pages, reduced to the surface versions and checked
-- with kills in the game; reviewed 2026-11-15.

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
