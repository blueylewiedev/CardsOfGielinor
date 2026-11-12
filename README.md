# Card Collector

A plugin for the RuneScape 3 Client API: earn credits from XP, open packs and collect cards.

## Contributing

New cards and artwork are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md).

# Card progress

Which parts of the game have cards. **Not started**, **In progress** or **Complete**. Update a row
when you start or finish a section. Cards that are still drafts are listed in the TODO.

## NPC cards (by region)

Common NPCs that appear everywhere (Shopkeeper, Guard and the like) get a card for each region, so
each region's set has its own version.

| Region | Status | Notes |
| --- | --- | --- |
| Misthalin | In progress | |
| Asgarnia | In progress | |
| Kandarin | In progress | |
| Karamja | In progress | |
| Kharidian Desert | In progress | |
| Morytania | In progress | |
| Tirannwn | In progress | |
| Fremennik Province | In progress | |
| Wilderness | In progress | |
| Anachronia | In progress | |
| Havenhythe | In progress | |
| Daemonheim | Not started | |
| The Arc | Not started | |
| General (no one region) | In progress | |

## Item cards (by type)

| Type | Section | Status | Notes |
| --- | --- | --- | --- |
| **Food** | Fish (cooked) | Complete | |
| | Meat | Complete | |
| | Meals | Complete | |
| | Baked goods | Complete | |
| | Fruit and vegetables | Complete | |
| | Drinks | Complete | |
| **Potions** | | Complete | |
| **Flasks** | | Complete | |
| **Raw materials** | Fish | Complete | |
| | Meat | Complete | |
| | Herbs | Complete | |
| | Logs | Complete | |
| | Ores | Complete | |
| | Bones | Complete | |
| | Hides | Complete | |
| | Gems | Complete | |
| **Processed materials** | Bars | Complete | |
| | Planks | Complete | |
| **Seeds** | | Complete | |
| **Runes** | | Complete | |
| **Tools** | | Complete | Pickaxes, hatchets, spades and the like |
| **Containers** | | Complete | Vials, buckets, flasks, pouches, ore boxes and the like |
| **Weapons** | Melee | Complete | One row per kind below if you want to track them separately |
| | Ranged | Complete | |
| | Magic | Complete | |
| | Necromancy | Complete | |
| **Armour: melee** | Helmet | Complete | Includes the treasure trail versions, filed in the treasure trail file |
| | Body | Complete | Includes the treasure trail versions. Masterwork: only the plain (epic) and trimmed (legendary), no custom-fit |
| | Legs | Complete | Includes the treasure trail versions. Tetsu gear: superior only. Masterwork: plain and trimmed only, no custom-fit |
| | Gloves | Complete | Includes the treasure trail versions. Tetsu gear: superior only. Masterwork: plain and trimmed only, no custom-fit |
| | Boots | Complete | Includes the treasure trail versions. Tetsu gear: superior only. Masterwork: plain and trimmed only, no custom-fit |
| | Off-hand | Complete | Includes the treasure trail versions, the heraldic shields and the Dungeoneering shields |
| | Back | Complete | |
| **Armour: ranged** | Helmet | Complete | Includes the treasure trail versions, filed in the treasure trail file. Masterwork: plain only, no custom-fit |
| | Body | Complete | Includes the treasure trail versions. Masterwork: plain only, no custom-fit |
| | Legs | Complete | Includes the treasure trail versions. Death Lotus gear: superior only. Masterwork: plain only, no custom-fit |
| | Gloves | Complete | Includes the treasure trail versions. Death Lotus gear: superior only. Masterwork: plain only, no custom-fit |
| | Boots | Complete | Includes the treasure trail versions. Death Lotus gear: superior only. Masterwork: plain only, no custom-fit |
| | Off-hand | Complete | Includes the treasure trail versions |
| | Back | Complete | |
| **Armour: magic** | Helmet | Complete | Includes the treasure trail versions, filed in the treasure trail file. Masterwork: plain only, no custom-fit |
| | Body | Complete | Includes the treasure trail versions. Masterwork: plain only, no custom-fit |
| | Legs | Complete | Includes the treasure trail versions. Seasinger gear: superior only. Masterwork: plain only, no custom-fit |
| | Gloves | Complete | Includes the treasure trail versions. Seasinger gear: superior only. Masterwork: plain only, no custom-fit |
| | Boots | Complete | Includes the treasure trail versions. Seasinger gear: superior only. Masterwork: plain only, no custom-fit |
| | Off-hand | Complete | Includes the treasure trail versions |
| | Back | Complete | |
| **Armour: necromancy** | Helmet | Complete | Same slots as melee |
| | Body | Complete | Includes the treasure trail versions |
| | Legs | Complete | |
| | Gloves | Complete | |
| | Boots | Complete | |
| | Off-hand | Complete | |
| | Back | Complete | |
| **Armour: hybrid** | Helmet | Complete | Pieces with no single combat style (`hybrid_gear`) |
| | Body | Complete |  |
| | Legs | Complete | |
| | Gloves | Complete | |
| | Boots | Complete | |
| | Off-hand | Complete | |
| | Back | Complete | Max, completionist and quest capes (one card for each version, hooded art), the achievement diary cloaks (one card for all tiers) and the clan, Warpriest and treasure trail capes. Not carded: milestone capes, the plain master capes (the skill cape cards cover the 99 and master cape), Soul Wars and tutorial capes |
| **Skill outfits** | Helmet | Complete | Skill outfits and skill capes: `skill_outfit`, no combat style. All carded; Farmer's hat and Shaman's headdress are Treasure Hunter items now obtainable in game (the tool lets them through) |
| | Body | Complete | Includes the Treasure Hunter pieces now obtainable in game; the First age and a few other outfits' pieces are not carded yet |
| | Legs | Not started |  |
| | Gloves | Not started |  |
| | Boots | Not started |  |
| | Back | Complete | The 29 skill capes: one card for the 99 cape and the master cape, with the master cape art |
| **Treasure trail armour** | | Not started | Trimmed, gold, heraldic and god-themed pieces: added with each armour batch, filed in the treasure trail file |
| **Jewellery** | Rings | Not started | |
| | Necklaces | Not started | |
| **Ammunition** | Arrows | Not started | |
| | Bolts | Not started | |
| | Other (spikes) | Not started | |
| **Decoration** | | In progress | |
| **Currency** | | In Progress | |
| **Quest items** | | In Progress | |
| **Pocket items** | | Not started | |
| **Fashion** | | In Progress | |
| **Treasure Trails** | | In Progress | |
| **Slayer drops** | | In Progress | |
| **Minigame items** | | In Progress | |
| **General (other)** | | In progress | Cards that fit none of the above |

## Licence

The code (including the card files in `deck/`) is licensed under the
[PolyForm Strict License 1.0.0](LICENSE). It is source-available, not open source: you may read it and
use it for noncommercial purposes, but you may not distribute it or modify it, except as described in
[CONTRIBUTING.md](CONTRIBUTING.md).

The artwork in `resources/images/` is not covered by that licence. It is used with the permission of
the creator. See [resources/images/CREDITS.md](resources/images/CREDITS.md).

RuneScape and its characters, names and models belong to Jagex.

Three developer files hold data taken from the RuneScape client: `dev/anim_sets.lua` (animation sets,
read from the game's cache by `dev/anim_sets.py`), `dev/seq.txt` (animation names) and `dev/npc.txt`
(NPC names). That data belongs to Jagex and is not covered by the licence above. The files are only
used by the developer tools in `dev/`, which are left out of the released plugin.
