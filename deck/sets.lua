-- deck/sets.lua
-- Sets: groups of cards to collect together, such as every shopkeeper or every musician. The Sets window
-- (ui/setsviewer.lua) lists them with how many of each the player has, and shows a set's cards with the
-- missing ones as dark silhouettes.
--
-- (Not to be confused with Cards.deckFiles in core/cards.lua, which is the list of deck files.)
--
-- A set is written as its own block:
--   {
--       id = "musicians", name = "Musicians",
--       names = { "Musician" },
--   },
--
-- Fields:
--   id     : unique among the sets, lower case. Nothing is saved under it, so it can be renamed.
--   name   : what the Sets window calls it.
--   names  : optional. Card names the set takes in, with every variant of each: "Musician" takes the card called
--            "Musician" and every "Musician (...)", such as "Musician (Lumbridge)", but not "Musicianship".
--            New variants join the set by themselves when they are added to the deck.
--   filter : optional. Only cards that also match this are taken in, written as a pack filter (see core/packtypes.lua
--            in core/cards.lua), e.g. { kind = "npc" } or { category = "shopkeeper" }. On its own (no `names`)
--            it takes in every card that matches. A set of NPCs by job (guards, cooks, bankers...) filters on that
--            category word: dev/wiki_cards.py tags new cards with it from the wiki, so they join by themselves.
--   add    : optional. Card ids to put in the set although the rules above leave them out.
--   leave  : optional. Card ids to keep out of the set although the rules above take them in.
-- A set needs at least one of names, filter or add. The cards are shown in the deck's order (lowest rarity first).
--
-- `lua dev/check_sets.lua` checks every set: that the ids in add and leave are cards in the deck and that no set ends
-- up empty. It also runs on every pull request.

return {
    {
        id = "shopkeepers", name = "Shopkeepers",
        names = { "Shopkeeper" },
        add = { "fairy_shopkeeper" },
    },
    {
        id = "shop_assistants", name = "Shop assistants",
        names = { "Shop assistant" },
        add = { "fairy_shop_assistant" },
    },
    {
        id = "musicians", name = "Musicians",
        names = { "Musician" },
    },
    {
        id = "bartenders", name = "Bartenders",
        names = { "Bartender" },
        add = { "cheri" },
    },
    -- (left out: guardians, and people the wiki files with guards who only stand guard in a story)
    {
        id = "guards", name = "Guards",
        filter = { kind = "npc", category = "guard" },
        leave = { "ashuelot_reis", "berry", "dad", "laidee_gnonock", "treznor", "achietties", "captain_rovin",
            "captain_undak", "dartog", "cave_monk", "rune_guardian", "guardian_of_armadyl", "dagannoth_guardian" },
    },
    -- (the wiki's goblin race: cave goblins and hobgoblins too)
    {
        id = "goblins", name = "Goblins",
        filter = { kind = "npc", category = "goblin" },
    },
    -- (left out: a sheep and the Spellwisp, which the wiki files with the wizards)
    {
        id = "wizards", name = "Wizards",
        filter = { kind = "npc", category = "wizard" },
        leave = { "sheep_2", "spellwisp" },
    },
    {
        id = "cooks", name = "Cooks",
        filter = { kind = "npc", category = "cook" },
    },
    {
        id = "bankers", name = "Bankers",
        filter = { kind = "npc", category = "banker" },
    },
    -- The skill masters: the NPCs who sell a skill's cape, from the wiki's Skillcape page (and the Spirit of Mastery,
    -- who sells the 120 Necromancy cape). The ones not carded yet join by themselves when they are.
    {
        id = "skill_masters", name = "Skill masters",
        names = { "Cap'n Izzy No-Beard", "Acting Guildmaster Reiniger", "Ajjat", "Surgeon General Tafani", "Estate agent",
            "Head chef", "Master Crafter", "Captain Harlan", "Orla Fairweather", "Thok of Daemonheim",
            "Martin the Master Gardener", "Ignatius Vulcan", "Master fisher", "Hickton", "Kaqemeex", "Hunting expert",
            "Doc", "Robe Store owner", "Gadrin", "The Spirit of Accomplishment", "The Spirit of Mastery", "Brother Jered",
            "Armour salesman", "Larriar", "Kuradal", "Thurgo", "Sloane", "Yadech Strongarm", "Pikkupstix",
            "Martin Thwait", "Wilfred" },
        filter = { kind = "npc" },
    },
    -- (the skill masters of Burthorpe and Taverley and the tutorial's instructors, tagged by their NPC; Vannaka, Sani
    -- and Bryll, shown as other NPCs, were tagged by hand)
    {
        id = "skill_trainers", name = "Skill trainers",
        filter = { kind = "npc", category = "skill_trainer" },
    },
    -- The Slayer masters. The ones not carded yet join by themselves when they are.
    {
        id = "slayer_masters", name = "Slayer masters",
        names = { "Turael", "Spria", "Mazchna", "Achtryn", "Vannaka", "Chaeldar", "Sumona", "Duradel", "Lapalok",
            "Kuradal", "Morvran", "Laniakea", "Mandrith", "Jacquelyn" },
        filter = { kind = "npc" },
    },
    {
        id = "god_emissaries", name = "God emissaries",
        filter = { kind = "npc", category = "emissary" },
    },
    {
        id = "archaeology_collectors", name = "Archaeology collectors",
        filter = { kind = "npc", category = "archaeology_collector" },
    },

    -- Items. These are hand-picked: the tags (category = "bar", "ore"...) also take in quest, minigame and
    -- Dungeoneering versions, which would bury the set people actually work through.
    {
        id = "swords", name = "Swords",
        add = { "bronze_sword", "iron_sword", "steel_sword", "black_sword", "white_sword", "mithril_sword",
            "adamant_sword", "rune_sword" },
    },
    {
        id = "metal_bars", name = "Metal bars",
        add = { "bronze_bar", "iron_bar", "silver_bar", "steel_bar", "gold_bar", "mithril_bar", "adamant_bar",
            "rune_bar", "orikalkum_bar", "necronium_bar", "bane_bar", "elder_rune_bar" },
    },
    {
        id = "ores", name = "Ores",
        add = { "copper_ore", "tin_ore", "iron_ore", "coal", "silver_ore", "mithril_ore", "adamantite_ore",
            "luminite", "gold_ore", "runite_ore", "orichalcite_ore", "drakolith", "necrite_ore", "phasmatite",
            "banite_ore", "light_animica", "dark_animica" },
    },
    {
        id = "grimy_herbs", name = "Grimy herbs",
        add = { "grimy_guam", "grimy_tarromin", "grimy_marrentill", "grimy_harralander", "grimy_ranarr",
            "grimy_toadflax", "grimy_spirit_weed", "grimy_irit", "grimy_wergali", "grimy_avantoe", "grimy_kwuarm",
            "grimy_bloodweed", "grimy_snapdragon", "grimy_cadantine", "grimy_lantadyme", "grimy_dwarf_weed",
            "grimy_torstol", "grimy_fellstalk", "grimy_arbuck" },
    },
}
