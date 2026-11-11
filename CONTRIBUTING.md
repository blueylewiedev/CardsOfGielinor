# Contributing to Card Collector

Thank you for wanting to help! Card Collector is a plugin for the RuneScape 3 Client API (Lua)
where you earn credits from XP, open packs and collect cards of NPCs from the game.

This guide covers the two kinds of contribution that are welcome:

- **New cards** for the deck (the most useful thing you can do), and
- **Alternative artwork** for the card frames, card back and packs.

The plugin's code is maintained by the project owner. If you would like to change something
outside `deck/` and `resources/`, please open an issue and talk about it first (see
[Code changes](#code-changes)).

---

## Contents

1. [Setting up](#setting-up)
2. [Adding a card](#adding-a-card)
3. [Card rules](#card-rules)
4. [Submitting your cards](#submitting-your-cards)
5. [Artwork](#artwork)
6. [Code changes](#code-changes)
7. [Licence and ownership](#licence-and-ownership)

---

## Setting up

1. **Fork and clone** this repository.
2. **Put the plugin where the client can find it.** Follow the
   [RS3 plugin setup](https://developer.runescape.com/) for the plugin BETA world: join the BETA
   world, then put the plugin's folder (the one containing `main.lua` and `plugin.json`) in the
   BETA folder's `dev_plugins/` directory. The simplest way is to clone the repository straight
   into `dev_plugins/` (or link the folder there).
3. **Make sure PrettyUI is installed and enabled.** Card Collector needs the PrettyUI plugin
   (mod.io id 6398181) for its windows.
4. **Load the plugin.** Open the developer console and run `prf` (refresh the plugin list) and
   then `prl` (reload the plugin). Run `prl` again every time you change a file.
   Syntax errors are printed to the console with the file and line number.

The `dev/` folder holds the developer tools. They load automatically when the folder is present
(it is left out of the released plugin), and their buttons appear on the plugin's **Home window**.

---

## Adding a card

The **Card Builder** (the *Card Builder* button on the Home window) makes a new card for you and
checks it as you go. You do not need to know how the code works to be able to contribute :).
It makes NPC cards. For an item card, press **Item** at the top of the window: the NPC search is
replaced by an item search (and a list of your Grand Exchange offers), and the animation and
location boxes go away, because items have neither. Item cards go in `deck/items/`.
When you pick an item, the builder reads the game's own item data and fills in the boxes that are still
empty: free to play or members, the skill and level it needs to wear it (for a tool, to use it), what kind of
item it is (weapon and its kind, armour, jewellery, ammunition, tool, food, potion, logs, gems...), its combat
style, and a rarity from the level. The skill tag is the skill that gets or makes the item, not what it is used
with, so ore is not tagged smithing; the game does not say which skill gets an item, so for materials that is
yours to add (bones, herbs and seeds are the exception: they get prayer, herblore and farming). The game does not give the
Grand Exchange price, a drop rate, or an armour or jewellery slot, so the notes under the checks say to look
those up. Choose the normal item, not its noted version.

<img width="1351" height="990" alt="image" src="https://github.com/user-attachments/assets/d5a79373-37b0-4ad4-8a0e-435572f1eebe" />

**Starting from the wiki (optional).** Instead of filling every box in by hand, you can have
candidates made from the [RuneScape Wiki](https://runescape.wiki) and review them:

1. Open **Wiki Review** from the Home window and press its search button: **Wiki Fetch** lets you
   pick wiki categories (places, for NPC cards, and kinds of item, for item cards) or type pages,
   and gives you the command, for example
   `python dev/wiki_cards.py --category "Lumbridge" --category "Logs"`. Copy it and run it in the
   plugin's folder. It writes `dev/wiki_candidates.lua`: for each NPC or item page, the NPC or item,
   the name, the examine text, tags, a suggested rarity and notes on what to check. Categories
   asked for before are remembered, so the list grows.
2. In the game, `prf`, then open **Wiki Review**. **Load into Card Builder** fills the builder in;
   check and change anything that is wrong (the tags and rarity are only guesses), try the other
   models with **Next model**, frame the art, and copy the block as below. Then press **Done**, or
   **Skip** for one that shouldn't be a card, or **Later** for one that should be but can't be
   made yet (a tag or deck file it needs doesn't exist). The **Later** button in the header
   brings back only those, and the **Skipped** button only the skipped ones. Cards already in
   the deck are left out.
   **Next model** only offers models that look different: `dev/wiki_cards.py` compares their parts
   and colours in the client's cache (`dev/npc_looks.py`), and keeps every model if there's no cache.

   Instead of copying each block by hand, you can let **Done** queue it: the Wiki Review saves
   the card in the Card Builder (the one you loaded, with no problems showing in its checks) in the
   plugin's database, and `dev/card_queue.py` (run on the computer the client runs on) adds each
   queued card to the end of its deck file. If the card can't be queued, a line under the buttons
   says why and the candidate stays on the list. The script only reads the database; what it has
   done is kept in `dev/.card_queue_state.json`. A new location or NPC category word on an added
   card goes into `core/cards.lua` too; any other unlisted word is only reported. The wiki page
   each added card came from goes into `dev/wiki_pages.json`, which the card site uses to pick the
   picture of the card's own NPC version (see `dev/wiki_pages.py`; give an entry an `"image"` to
   override it). Check the result with `lua dev/check_cards.lua`. Commands (`DB` is the client's
   `PluginData.db`):

   ```
   python dev/card_queue.py --db DB                   keep watching, adding each card as it is queued
   python dev/card_queue.py --db DB --once            add everything queued now (and retry failed ones)
   python dev/card_queue.py --db DB --dry-run         say what would be added, change nothing
   python dev/card_queue.py --db DB --list            queued cards not added yet, why, and their blocks
   python dev/card_queue.py --db DB --list --all      the added ones too
   python dev/card_queue.py --db DB --rename 7 new_id give a failed card another id, then run --once
   ```

   Once the script has added cards and you have reloaded the plugin, press **Clear added cards**
   in the Wiki Review: it deletes the queued cards that are now in the deck from the database
   (a card that only shares an id with an existing one, and ones not added yet, stay).

   A card whose id is already in the deck, or whose deck file is missing, is reported as failed
   and kept; `--list` shows it with the wiki page it came from. To change it in the builder, type
   that page into the Wiki Review's **Reopen** box, load it, fix it and press **Done** again. Reload
   the plugin afterwards, and add any new tag words the script lists to `core/cards.lua`.

For **weapons**, `--weapons melee` (or `ranged`, `magic`, `necromancy`, `hybrid`) lists every weapon
of that combat style from the wiki's structured data (Bucket:Infobox_bonuses): main-hand,
two-handed and off-hand weapons, without cosmetic recolours or upgrades (the plain weapon has the
card: Adamant scimitar, not Adamant scimitar + 1). Skilling tools (pickaxes, hatchets, mattocks),
augmented, Golden and Lucky weapons and pages with a bracketed suffix ("Scimitar (class 3)", "(passive)", "(dyed)",
"(Dominion Tower)"), which are variants of another page, are left out (`WEAPON_SKIP`), and so are off-hand thrown weapons (an off-hand dart is the same item), Abyssal crossbows and "Mk. 5" upgrades. Try `--weapons melee --count` first to see how
many pages that is, and `--weapons melee --list` to see them (with tier and damage type, lowest tier
first) before fetching any. The kind (scimitar, dagger...) comes from each page as usual.

For **tools and containers**, use `--category Tools`, `--category Containers` and `--links-from "Skilling main hands"`. The wiki files a pickaxe under Melee weapons and a watering can under Containers, so the tool decides by itself: a page in Tools, Pickaxes, Hatchets, Mattocks or Tool belt, or linked from Skilling main hands, is `tool` only (no weapon words); an empty vessel (vial, bucket, jug, flask) is `container` only; a filled one (a cup of tea, a bucket of water) is tagged by what it holds. Stealing Creation tools ("(class 3)", Marker seeds, Proto-tool) are skipped as minigame variants.

For **armour**, `--armour SLOT` (head, body, legs, hands, feet, shield or cape) with `--style STYLE` (melee, ranged, magic, necromancy, hybrid, or other for any class that is none of those) lists the pieces from the wiki's structured data (Bucket:Infobox_bonuses): `--armour head --style melee --count` first, then `--list`, then the same without them to fetch. Without `--style` every style is listed. Cosmetic recolours, `+ N` upgrades, augmented, golden and lucky versions and the `(charged)`, `(e)`, `(broken)` and `(class N)` copies are left out (`ARMOUR_SKIP`). Every slot goes in one deck file whatever the style, in `deck/items/armours/` (helmets, bodies, legs, gloves, boots, off_hands, back); the style is the `melee_gear`, `ranged_gear`, `magic_gear`, `necromancy_gear` or `hybrid_gear` tag. Skill outfits and skill capes are `skill_outfit` with a slot word and no style, in `deck/items/skill_outfits/` by slot. The trimmed, gold, heraldic and god-themed pieces (the wiki's "Treasure Trails rewards") are tagged `treasure_trail` as well and go in `deck/items/treasure_trails.lua`, whatever they are.

For a kind of item the wiki has no category for, `--links-from "Bars"` takes every page a list page links to (as if each
was given with `--page`, and remembered the same way): the metal bars, whose list is the tables on the Bars page.
`--list` shows what it would take before anything is fetched, and `--until HEADING` stops at a heading. A name that ends in
"bar" and is filed under Metals or Smithing is suggested as `processed_material, bar`, in
`deck/items/processed_materials/bars.lua`; one that ends in "plank" or "planks" and is filed under Construction
(the Sawmill page lists them: `--links-from "Sawmill"`) as `processed_material, plank`, in
`deck/items/processed_materials/planks.lua`.

Please be gentle with the wiki: the script only uses its API, makes one request every two seconds
at most, stops after 30 requests a run (`--max-requests`), and keeps every answer in
`dev/wiki_cache/` so running it again asks the wiki for nothing it already has. Don't lower those
limits or delete the cache to fetch again; use `--refresh` only for pages that have changed. Give
a contact so the wiki's admins can reach you if anything goes wrong (see
[their API guidelines](https://runescape.wiki/w/Help:APIs)): `--contact`, or put it once in
`dev/wiki_contact.txt` (for example `@yourname on Discord`). The cache, the candidates and your
contact file are not committed.

To find NPCs that still need a card, open **Uncarded NPCs** on the Home window. While the developer tools
are in use, NPCs near you that have no card get a yellow box round them in the game world (the window
switches the boxes off and sets how many tiles to look). Use **Ignore** in that window for NPCs that will
not get a card, or that have one with a different model (it ignores every version of that name, and is
remembered). **Card** on a row opens the Card Builder with the NPC, its name, a card id and a guess at its standing
animation filled in. Each row also shows the NPC's animation set, and so does the Builder, as a clue when searching for an animation.

1. **Choose the NPC.**
   - Stand near the NPC in the game and press the **Nearby NPCs** button (the eye icon beside the NPC box), then **Scan**, then **Use** on the
     NPC you want. This picks the exact NPC (many NPCs have several versions with different
     models, and the one standing in front of you is the one to use),

   <img width="1070" height="576" alt="image" src="https://github.com/user-attachments/assets/a2ca367c-35ec-4251-888e-b8b1f27efdf5" />

   - or press the **Search NPCs** button (the magnifying glass beside the NPC box), type part of the name and press **Use**,

   <img width="711" height="579" alt="image" src="https://github.com/user-attachments/assets/7040bd1b-614e-4b6e-890a-2c63ed4f11aa" />

   - or type the NPC's *config name* (for example `FATHER_AERECK`) into the box. In the developer
     console, `pan NPC` lists the config names.

   <img width="1344" height="988" alt="image" src="https://github.com/user-attachments/assets/1084552a-c8a3-4e45-84ba-3185022cf06c" />

   The box says **Found** when the client knows the NPC. The name and the id are filled in for
   you, and the card appears in the preview.
3. **Check the name and id.** The name is what is printed on the card. The id follows the name
   (see [Ids](#ids)). Change either if you need to.

   If the generated Card Id automatically defaults to the name of the npc followed by "_2" check to make sure a card for that NPC doesn't
   already exist.

   <img width="580" height="194" alt="image" src="https://github.com/user-attachments/assets/fcc4bdba-e57d-4238-bbb9-3b84cf04e73d" />

5. **Write a description** (up to 80 letters, shorter is better).

   <img width="913" height="423" alt="image" src="https://github.com/user-attachments/assets/e3493df2-0ad3-4876-9709-f38269f5bb6f" />

6. **Suggest a rarity** from the drop-down. This is only a suggestion; see [Rarity](#rarity).
   We may not agree with the rarity you choose for your submitted cards, in this case we will open a discussion with you to reach an agreement.

   <img width="417" height="247" alt="image" src="https://github.com/user-attachments/assets/435df749-9a57-47fc-9128-8287b677fb12" />

8. **Add tags**, if they apply (see [Tags](#tags)). Press **Pick tags** to choose from the words
   that are allowed: there is a page for each kind of tag, and clicking a word adds it to the card
   (click it again to remove it). The Filter box narrows the words. You can also type them. Press **Pick tags** to choose from the words
   that are allowed: there is a page for each kind of tag, and clicking a word adds it to the card
   (click it again to remove it). The Filter box narrows the words. You can also type them.

   <img width="711" height="318" alt="image" src="https://github.com/user-attachments/assets/ce56db55-d3a5-42af-8ed8-fe5cba3b90ec" />
   <img width="709" height="519" alt="image" src="https://github.com/user-attachments/assets/9f111aba-2b31-42f1-83f9-44d59d4473e6" />
   <img width="708" height="641" alt="image" src="https://github.com/user-attachments/assets/7cc345e4-ecc7-4061-9845-52139bbddbb1" />

For this example, we will select no tags for location, as the Woman NPC can be found in many places across Gielinor.
We will select the Thieving tag for Skills as Women are a common early Thieving NPC.
For the Category tags we will select Humanoid and Monster (Monster signifies that this NPC is attackable)

You may add new tags should you wish, just type the tag manually into the text field, separated by commas.
*If you do create new tags, make sure you also add them to the relevant list in the Cards file.
If you don't know or are unsure on how to do that, make a note of the tags that need adding in your PR.

<img width="1331" height="371" alt="image" src="https://github.com/user-attachments/assets/b0a76167-5038-4253-9d78-263e4d17c2b3" />

10. **Choose the deck file** the card belongs in (see [Which deck file](#which-deck-file)).

<img width="571" height="231" alt="image" src="https://github.com/user-attachments/assets/b1ae1091-bcf3-446e-a540-616815358fa2" />

11. **Tune the art.**
   - **Model** switches between the NPC's whole body (the default) and its head.
   - The **camera controls** (each has a label and a pair of buttons) zoom, move and turn the camera, and the
     arrow icon at the top right of the section puts the camera back to where it started. Aim to fill the picture window with
     the NPC, with the face visible. A look through the existing cards gives a good idea.

<img width="736" height="379" alt="image" src="https://github.com/user-attachments/assets/260b93a7-7885-4100-abea-7537df0bb1f9" />

     
   - **Animation** is optional. Type a sequence id, step through ids with the -100 to +100 buttons, or
     press the magnifying glass beside the box (**Search anims**) to look for an animation by name and **Use** to try it. Pick an idle
     or other animation that loops smoothly.
   - On the Nearby NPC's window, you can see the animation sequence being used by the NPC in the game world.
     While the specific animation you need might not be named exactly the same, it will likely be similar.

     <img width="595" height="175" alt="image" src="https://github.com/user-attachments/assets/937f213f-4f48-4ead-b68a-99b9160181c0" />
     <img width="707" height="368" alt="image" src="https://github.com/user-attachments/assets/214aa0db-a9ef-4bb5-a3bf-9804666e272b" />
     <img width="731" height="608" alt="Selecting_Animation" src="https://github.com/user-attachments/assets/b6342b75-d511-4237-b034-2c62b1a9b0ea" />

     
11. **Read the checks** at the bottom left. Anything marked **Fix** has to be sorted out before
   the block is ready. **Note** lines are worth a look but will not stop you.

<img width="318" height="159" alt="image" src="https://github.com/user-attachments/assets/a75d2842-b0d2-4da7-8595-7e1b555121a7" />

13. **Copy the card block.** Click the box under *Your card block*, press **Ctrl+A** then
   **Ctrl+C**.

   <img width="735" height="74" alt="image" src="https://github.com/user-attachments/assets/d25a5483-fb0b-43e7-bb43-12c2c543e6e3" />

15. **Paste it** into the deck file you chose (see below), inside the `Set.cards` list. One card
    goes on one line, which is fine; I can reformat the files myself and there will soon be a script that runs when merging that reformats the code automatically.

   <img width="1177" height="1043" alt="adding_line" src="https://github.com/user-attachments/assets/ae83e7b9-f7cd-4db3-8610-678eca9223b7" />
    
17. **Reload the plugin** (`prl`) and check that the card loads and looks right. The plugin
    checks every card when it loads, and stops with a message naming the card if something is
    wrong.

The **Reset** button (the bin icon at the top right of the card details) clears the window ready for the next card. What you type
is kept while the plugin is running, so closing the window does not lose it.

### Which deck file

The cards are in `deck/npcs/`, one file for each region (`misthalin.lua`, `asgarnia.lua`,
`kandarin.lua`, `karamja.lua`, `kharidian_desert.lua`, `morytania.lua`, `tirannwn.lua`,
`fremennik_province.lua`, `wilderness.lua`, `anachronia.lua` and `havenhythe.lua`), plus
`general.lua` for NPCs that are not tied to one place (guards, shop keepers, animals). Put a card
in the file for the region where the NPC is found. Every card in a region's
file gets that region's tag automatically.

As with items, an NPC found in **two** regions goes in the first region's file and lists the
second in its own `regions` tag (`regions = { "asgarnia" }` on a card in `kandarin.lua`), so both
regional packs give it; the Card Builder's **also in** box is for that second region. An NPC found
in **three or more** regions, or all over the world (Global), goes in `general.lua` with no
region. A region that is only listed because of somewhere the NPC is fought again (the Dominion
Tower in the desert, Rush of Blood in Tirannwn) or reached through (the player-owned port's
portals) does not count; the Wiki Review leaves those out for you. Every version of the NPC on its
wiki page counts (the Mage of Zamorak in the Wilderness and in Varrock), except a version that is
only its part in a quest (Reldo in Falador for Succession).

If your NPC lives in a region that has no file yet, say so in your pull request; a new file has to
be created and listed in `deck/index.lua`.

Item cards go in `deck/items/`. There is one file, `general.lua`, for now. As item cards are added
they are grouped in a folder for each item category, with a file for each sub-type, for example
`deck/items/raw_materials/logs.lua` or `deck/items/weapons/scimitars.lua`. The folder is the plural
of the category word (`raw_materials`, `weapons`) and the file is named for the kind of item, in the
plural (`logs`, `herbs`, `scimitars`). The Wiki Review window looks for the folder and file this way
when it loads a candidate, and falls back to `general.lua`. There is no limit on the number of cards in a file; split a file when it
gets hard to work with or when two people keep editing the same one.

**Every deck file has to be listed in `deck/index.lua`**, including the ones in folders, because
the plugin cannot look inside folders. A file that is not listed is never loaded. Run
`python dev/check_deck_index.py` to check that the files and the list agree. It also runs on every
pull request, and the pull request cannot be merged while it fails.

**Every card has to load.** A tag word that is not in `core/cards.lua` (a new location, a typo)
stops the whole plugin loading. Run `lua dev/check_cards.lua` (from the plugin's folder) to load
every card the way the plugin does: it names the card that would stop it. It also runs on every
pull request. After adding cards with new locations or categories, `lua dev/add_tag_words.lua`
adds the words your cards use to `core/cards.lua` for you (a new category goes in the "What it is"
group: move it if another fits better), then runs the same check. Add `--dry-run` to only see what
it would add. It does not add item categories, or fix typos in regions, skills or membership; it
lists those for you to fix.

---

## Card rules

### Ids

An id is lower case, with spaces turned into underscores and anything that is not a letter or
digit left out. "Sir Amik Varze" becomes `sir_amik_varze`. If an id is already used, add a number
(`guard_2`); the Card Builder suggests this for you.

**An id never changes once a card is in the game**, because people's collections are saved
against it. Choose it carefully.

### Names and descriptions

- The name is the NPC's name as it appears in the game.
- The description is one short, friendly line in the style of the existing cards ("Sells axes
  and strong opinions."). Keep it to 80 letters at most.
- Keep everything suitable for all ages. No real people, no references to real-world events or
  accounts, no copying text from elsewhere.

### Rarity

Rarity is the card's chance of turning up in a pack: common, uncommon, rare, epic and legendary.
Every card in a pack is drawn at random: first NPC or item (equal chances, set by `Packs.kindWeights`
in `core/packs.lua`), then a rarity, then a card. No slot is reserved for a kind of card.
Your choice is a **suggestion**. The maintainer decides the final rarity so the deck stays
balanced, and will either change it or leave a comment on your pull request explaining what is
wanted. Looking at where similar NPCs sit in the existing files is the best guide.

#### Guidelines for NPCs

These describe where the existing NPC cards sit, and the Wiki Review's suggested rarities follow
them. Go down the list and stop at the first one that fits:

| # | The NPC is... | Rarity | For example |
|---|---|---|---|
| 1 | A god (filed under the wiki's Gods, such as Zamorak, Saradomin or Azzanadra) | **Legendary** | Zamorak, Saradomin |
| 2 | A pet | **Common** to **legendary**, by how it is got (see below) | Rocky, Trevor, terrier |
| 3 | A Summoning familiar | **Common** to **epic**, by level and charm (see below) | Spirit wolf, Steel titan |
| 4 | A Guthixian Cache automaton, a Runespan creature (essling, esshound, esswraith) or a Divination wisp or spring | **Common** to **epic**, by the Divination level to subdue or harvest it or the Runecrafting level to siphon it, on the familiars' bands (see below) | Confused automaton, Soul esswraith, Brilliant wisp, Ancestral energy |
| 5 | A boss, or a quest boss (one fought in the Dominion Tower) | **Rare** below combat level 100 (most quest and minigame bosses), **epic** from 100, **legendary** from 1000 (the end-game bosses: Nex, Telos, the Rise of the Six). A Mahjarrat or dragonkin boss is never below epic | Delrith, Evil Chicken (rare); Giant mole, General Graardor (epic); Nex, Telos (legendary) |
| 6 | A Mahjarrat, or a dragonkin with a name or fought as a boss (not their Nodon soldiers) | **Epic** | Lucien, Hazeel, Kerapac, Strisath |
| 7 | A Slayer monster from Slayer level 10 that is scarce (fewer than 20 spawns) | **Rare** | Wall beast |
| 8 | A named character, skill master or Slayer master | See the next table | |
| 9 | A role (a cook, a guardsman) in 2 or more quests | **Uncommon** | Cook (Lumbridge) |
| 10 | A Slayer monster from Slayer level 5 | **Uncommon** | Cave crawler, Cave bug |
| 11 | Found almost everywhere (60 or more spawns), whatever its level | **Common** | Goblin, Giant rat, Chicken |
| 12 | A Hunter creature, an NPC to pickpocket or one mined like a rock (the Arc's crablets), with no combat level | **Common** to **epic**, by the Hunter, Thieving or Mining level it needs, on the familiars' bands (see below) | Crimson swift, Kingly impling, Man, Alaea crablet |
| 13 | Combat level 100 or more | **Rare** | |
| 14 | Combat level 30 or more | **Uncommon** | |
| 15 | A named quest NPC the wiki gives no gender (not an animal) | **Uncommon** | Angurvadal |
| 16 | Anyone else | **Common** | Man, animals |

A few NPCs are set by hand, where the rules can't see what makes them matter: Sliske is
**legendary** for his weight in the story, and Nomad for his Memory of Nomad fight (combat level
1001). The other Mahjarrat are epic, and those who became gods, like Zamorak and Azzanadra, are
legendary as gods. A skill master, who sells a skillcape, is at least rare, so the sellers of the
capes above it are **epic**: Max and Elen Anterth (max cape), Curator Haig Halen (master quest
cape) and Minerva (master max cape).

Shattered Worlds is set by what each NPC is, because the wiki files none of its bosses as bosses
and their combat levels scale with the world. Its copies of other monsters (Abnormal, Fabricated,
False, Imitation, Malignant and Unnatural ones) get no cards. The God Wars parodies (Generally
Graardor, Kree'arranged, K'ril Too'tsaroth, Commandeered Zilyana) are **epic**. Its other bosses,
the Barrows and Dagannoth Kings parodies and Chaos Experimental, are **rare**. The anima creature
pets go by their reward-shop tier: **uncommon** for tiers 1 to 3, **rare** for 4 to 6 and **epic**
for 7 to 9. The Abyssal hound is **legendary**. The hub's NPCs follow the rules above.

The gods' emissaries (the wiki's God Emissaries, such as Julienne, Emissary of Saradomin) are at
least **uncommon**: one the rules rate common is raised to uncommon, and one rated higher keeps
its rarity (Relomia, Emissary of Sliske, in 7 quests, is rare).

The Horsemen of the Apocalypse (Death and War so far) are **epic**. The holidays' figureheads
(Santa Claus, the Queen of Snow, Jack Frost and the Easter Bunny) are **rare**. Other characters who
came with a holiday event (first released in a Halloween, Christmas, Easter, Thanksgiving or
Valentine's update, and filed under a holiday event, such as Fame, Muncher and Norman) are at least
**uncommon**, raised like the emissaries. Regulars who only took part in an event (Hans, Reldo) and
holiday pets follow the rules above.

Summoning familiars: add a bonus for what the pouch takes to the familiar's Summoning level,
then read the rarity off the total. Familiars never go above epic.

| The pouch takes... | Bonus |
|---|---|
| A gold charm | +0 |
| A green charm | +5 |
| A crimson charm | +10 |
| An elder charm | +12 |
| A blue charm, or it is a binding contract | +15 |

| Level + bonus | Rarity | For example |
|---|---|---|
| Under 35 | **Common** | Spirit wolf, Granite crab |
| 35 to 64 | **Uncommon** | Albino rat, Bull ant |
| 65 to 89 | **Rare** | Arctic bear, Smoke devil |
| 90 or more | **Epic** | Fire titan, Steel titan |

Two are set by hand: Meerkats are **rare** (they only come from Treasure Trails) and the Ghast
is **epic**.

Hunter creatures, NPCs to pickpocket and NPCs mined like rocks read it too, with the level they
need (no bonus): an impling caught at level 17 is **common**, at 91 **epic**; an alaea crablet,
mined at 97, is **epic**.

Automatons read the same table with the Divination level needed to subdue them (no bonus): the
ancient automaton (none needed) is **common**, the confused (45) **uncommon**, the enraged (85) **rare**.
Runespan creatures read it with the Runecrafting level to siphon them, from their examine: the
esslings and the body and cosmic esshounds are **common**, the chaos (35) to law (54) esshounds
**uncommon**, the death (65) and blood (77) esswraiths **rare** and the soul esswraith (90) **epic**.
Wisps read it with the Divination level to harvest them, from their examine (an enriched wisp the
same as its plain one): the pale (1) and bright (20) wisps are **common**, the brilliant (80) **rare**.

Pets (the first that fits):

| The pet is... | Rarity | For example |
|---|---|---|
| The Golden Gnome (awarded at RuneFest) | **Legendary** | |
| A skilling or boss pet | **Legendary** | Rocky, Bubbles |
| One of the wiki's "Legendary pets" | **Epic** | |
| Got with a skill level or after a quest | The familiars' bands for the level (the highest it needs), or the quest's difficulty: Novice **common**, Intermediate **uncommon**, Experienced **rare**, Master or Grandmaster **epic** (the higher of the two) | Terrier (4 Summoning, common), Baby pavosaurus rex (Osseous Rex, rare) |
| Unlocked with a token | **Rare** | Arthur, Boulder |
| Sold in a shop | **Uncommon** | Trevor |
| A drop, or unlocked with a rare item | **Epic** | Mimic, Ishhara (corrupted egg) |
| From a league | **Rare** | Bria, Hexi |
| From an event or a promotion (or no longer available) | **Uncommon** | Marketplace and RuneFest pets |
| Given by an NPC | **Common** | Mune, Richie |
| From another place or activity | **Rare** | Chomper (Oasis Restoration), Perdita (The Lost Grove) |
| Anything else | **Common** | Cats |

Named characters, skill masters and Slayer masters (again, the first that fits):

| The character is... | Rarity | For example |
|---|---|---|
| In 12 or more quests, or in 5 or more and found in 5 or more places | **Epic** | King Roald, Wise Old Man |
| A skill master (sells a skillcape) | **Rare** | Captain Harlan |
| In 5 or more quests, or royalty | **Rare** | Duke Horacio, Aggie |
| In 3 or more quests and found in 5 or more places | **Rare** | Evil Dave, Sir Owen |
| A Slayer master in no quests | **Uncommon** | Jacquelyn |
| In 1 to 4 quests | **Uncommon** | Gillie Groats |
| In no quests (a local) and under combat level 30 | **Common** | Donie, Barfy Bill |

A named character in no quests who is fought at combat level 30 or more goes by the combat level rows of the first table instead (Glophren, 119, is rare).

What the words mean:

- **Named character**: a person with a name, not a job. "Hans" and "Wise Old Man" are names;
  "Lumbridge guard" and "Cook (Lumbridge)" are roles.
- **Quests**: the quests the RuneScape Wiki lists the NPC in.
- **Spawns**: how many places the NPC stands in the world, from the wiki's maps and location
  tables. The number of spawn points, not the number of areas it is found in.

Locals with no quests are common on purpose. Region packs do not include the general cards,
where most commons live, so a region's commons have to come from its own locals.

The rules cannot see everything. An NPC that is famous for other reasons can go up a step (the
Doomsayer is uncommon), and so can a joke or a secret (the penguins disguised as sheep). Say why
in your pull request.

#### Guidelines for items

An item gets a rarity from each of the signals below that applies to it, and **the highest one wins**.
These are guides, not laws: the maintainer can change a rarity that does not feel right.

| Signal | Common | Uncommon | Rare | Epic | Legendary |
| --- | --- | --- | --- | --- | --- |
| **Level needed** (a skill level, or a combat level for gear) | 1-39 | 40-69 | 70-89 | 90+ | never |
| **Grand Exchange price** (the infobox's Exchange line, for one item) | under 50k | 50k+ | 1M+ | 10M+ | 50M+ |
| **Most common drop rate** (of the monster it is easiest to get from, 1 in N) | under 1 in 25 | 1 in 25 to 99 | 1 in 100 to 999 | 1 in 1,000 to 2,499 | 1 in 2,500 or rarer |

Also:

- **A level alone never makes a card legendary**, only epic at most: how hard an item is to use says little
  about how rare it is. Legendary comes from the price, the drop rate, pets and discontinued items.
- **The level needed** is the level to make the item, to plant its seed, to gather it (logs, fish and ore) or to
  clean it (a grimy herb), or the level to wear or wield it.
- **A drop rate only counts as far as the price supports it.** The rarity it gives is held to the rarity of
  the item's price, plus one step once the price is 50k or more, so an item nobody wants stays low however
  rarely it drops (the corrupt dragon weapons drop at 1 in 28,672 and sell for a few thousand coins). An item
  with no Grand Exchange price is not held.
- **An item a shop sells ignores its drop rate**: mind runes, ores and basic staves drop from monsters, but
  anyone can buy them. The shops are in `dev/shop_items.json` (`python dev/wiki_cards.py --shops`).
- **An item with no level and no shop is rated by where it drops.** If nothing gives a level (no recipe,
  gathering, planting or wearing) and no shop sells it, it is only got from what drops it, so the easiest
  live source decides (the one that is least trouble to reach). The monster's **combat level** gives
  uncommon from 70, rare from 100 and epic from 150, and a level the source asks for (Slayer to kill it,
  Hunter to catch it, Thieving to steal from it) uses the level table above. The higher of the two counts,
  epic at most. Fury shark drops only from the Lava strykewyrm (combat 115, Slayer 94), so it is **epic**.
  Historical sources, and rewards, shop stock and prizes that hand an item over indirectly, are left out.
- **Pets** are legendary, however they are obtained. They are very hard to get.
- **Discontinued or unobtainable items** (party hats, holiday rares) are legendary.
- **Variants take the rarity of the item they come from**: a grimy herb is the same as the clean herb, and
  pyre logs the same as the logs.
- An item with none of these (cheap, no level, no drops) is **common**.
- Members-only does not change rarity.
- Being the rarest drop of a boss does not matter by itself, only the actual drop rate. Use the rate from the
  wiki's drop table, and the most common of them if several monsters drop the item: the easiest way to get it
  is what counts.

Examples: clean lantadyme costs about 3k (common) but needs level 73 (rare), so it is **rare**. An Armadyl
chestplate drops at 1 in 384 (rare) and costs about 4.8M (rare), so it is **rare**. A godsword shard drops at
1 in 768 (rare) and costs about 118k (uncommon), so it is **rare**.

The wiki tool suggests a rarity from the level needed, the Grand Exchange price, the drop rate, pets and
discontinued items, and lists what it used in the notes.
- **Level:** from the Recipe infobox (only recipes that make the item; the easiest one if there are
  several) and, for gear, from the Bonuses box's wear requirement. The highest wins. An item no recipe makes
  gets the level to plant it (a seed), to gather it (the logs, fishing and ore infoboxes; an ore's infobox
  only names its rock, so the sentence "requires level 90 Mining" beside it is read) or to grow it (a grimy
  herb: its Farming level). Only how an item is **obtained** counts, never what it is used for: the Smithing
  level to smelt corrupted ore, or the Herblore level to clean a herb, is not read. The skills they name go
  in the `skills` tag.
- **Price:** the wiki's own Grand Exchange price (`{{GEP}}`).
- **Drop rate:** the table of drop sources on an item's page is not in the page's text, so
  `python dev/wiki_cards.py --item-drops` reads it from the wiki's dropsline bucket for every item card (the most
  common and the rarest rate of each, kept in `dev/drop_items.json`). Without that, give the tool the monster pages with
  `--drops "Kree'arra"`. It keeps the most common rate it has read for each item (`dev/wiki_cache/drops.json`)
  and uses it for any item that drops there. An item that drops from a page you have not given it has
  no drop rate, so check those by hand.
  `--all-bosses` does this for every boss named in the tables of the wiki's Bosses page before its Quest bosses
  section (`--drops-from "Bosses" --until "Quest bosses"` does the same, and works for other list pages).
  It fetches many pages (25 a request, cached), so raise `--max-requests` if it stops early and run it again.
The thresholds are at the top of the rarity section in `dev/wiki_cards.py`.

### Tags

Tags group cards so that themed packs can draw from them. Each tag kind holds words separated by
commas. A tag is never required, but a card with a good `category` and `location` is much more
useful to the packs.

| Kind | Meaning | Example |
|------|---------|---------|
| `location` | where the NPC is found: its town, or its dungeon or general area if it is not in a town | `lumbridge`, `lumbridge_swamp`, `dorgesh_kaan` |
| `skills` | skills it is linked to | `cooking`, `prayer`, `slayer` |
| `category` | what kind of character it is, what it does, or whether it can be fought (for an item: what it is used for, or what it is worn or wielded as) | `humanoid`, `shopkeeper`, `monster` (items: `raw_material`, `food`, `weapon`) |
| `membership` | whether it is free to play or members only: `f2p` or `p2p`, one word | `f2p`, `p2p` |

For an NPC the region comes from the deck file, so it is not asked for. Item cards are tagged with
`regions`, `skills`, `category` and `membership`: an item has no `location`, and its region is chosen by hand (see
"Choosing regions for an item"). The category words are not the NPC ones (an item cannot be a
`dragon`, and an NPC cannot be `food`). The Card Builder and the tag picker show the words for the
kind of card you are making. Some words only appear after another is picked (see "Choosing a
category for an item").

**Membership.** Tag every new card `f2p` or `p2p`, for an NPC or an item. It is one word, from the wiki's
"Members" line (Yes is `p2p`, No is `f2p`): the wiki tool suggests it, and the Card Builder has **F2P** and **P2P**
buttons beside the rarity. Pressing the one that is on turns it off. A card with neither is left as it is
(older cards are not tagged yet).

**Rules for words**

- Tag words are **lower case letters, digits and underscores**, starting with a letter. Use an
  underscore for a space (`lumbridge_swamp`). The Card Builder will not accept anything else.
- Use the full name of a place as the wiki writes it, in the singular, with no abbreviations or
  plurals (`monster`, not `monsters`; `lumbridge_swamp`, not `lum_swamp`).
- **Every word must be on the lists below.** The plugin refuses to load a card with a word that
  is not on its list, so a typo cannot slip through. Choose a word from the list when one fits.

**Adding a new word.** A new word is allowed. Add it to the right list in `Cards.tagWords` in
`core/cards.lua` (for `category`, to the group that fits it in `Cards.tagGroups.category`), in the
same pull request as the card that uses it. The Card Builder shows a note saying exactly where.
Keep the list tidy: do not add a word that means the same as one already there. Please also add
it to the lists in this guide. The **Pick tags** window shows the new word as soon as the plugin
is reloaded (`prl`).

**Choosing a location**

- Tag where the NPC *you picked* is found: a card is one version of an NPC, with its own model,
  so tag the places where players would expect to meet that version.
- If it is found in a town, use the town. If it is in a dungeon or a general area, use that.
- If it is found in several places, tag the **one to three best-known places**. Tagging every
  place makes the card turn up in too many themed packs. For example, a giant spider might be
  tagged `lumbridge_swamp` and one or two other well-known caves, not every dungeon where one
  appears.
- If it is found all over the game, leave `location` empty and put the card in `general.lua`.
  Chickens, rats and goblins are examples.
- A creature found in several regions belongs in `general.lua`; it can still have a `location` or
  two there.

**Choosing a category.** Use one or more words. Say what it is (`humanoid`, `animal`, `dragon`),
what it does (`shopkeeper`, `guard`, `knight`) and, for anything you can attack, add `monster`
(or `boss` for a boss). A card can have several, for example `{ "humanoid", "monster" }`. If
nothing says what it is, `monster` alone is fine; a new word is worth adding once several cards
need it.

**Choosing a category for an item.** Say what it is used for: `raw_material` for something that is
gathered and then made into something else (logs, a herb), `processed_material` for something made
from that (planks, bars), `craftable` for weapons and armour that can be crafted and are not only dropped, 
`ingredient` (with `raw_material`, or `processed_material` for one made from something) for what is
cooked with and not eaten (yeast, butter, cream: the wiki's category Cooking), and `food`, `drink`, `potion`,
`tool`, `container`, `rune`, `seed`, `quest_item`, `currency` or `decoration`, and `skill_outfit` for a skilling outfit or skill cape (with its slot word). 
A `tool` is a reusable implement you work with (a hammer, a pickaxe, a fishing rod); a `container` holds or stores things: a vessel you get back empty (vial, bucket, jug, bowl, pot, flask, waterskin) or storage (ore box, log basket, rune pouch). An item is one or the other, not both.
Something that is worn, wielded or fired is tagged with what it is: `weapon`, `armour`, `jewellery`,
`pocket` (the pocket slot) or `ammunition`. Each of those opens a last choice in the tag picker: the kind 
of weapon (`sword`, `longbow`, `staff`...), the armour slot (`helmet`, `legs`...), the jewellery slot (`ring` or `neck`) or
the type of ammunition (`arrow`, `bolt` or `spike`). These only show once the word above them is on
the card, and taking that word off takes them off too. A card that has one of them also needs the
word above it, so a rune scimitar is `{ "weapon", "scimitar" }`. Throwing knives and darts are
`thrown` weapons, and the magic off-hands that cast spells (a mystic orb, a wizard book) are
`orb` and `book` weapons. Items that are only worn or wielded for their looks (hats, masks)
are `fashion` and are not given `weapon`, `armour` or a slot, so a pack of helmets or weapons never
contains them. Joke and prop items nobody uses to fight (a rubber chicken, a tambourine, a frying pan)
are `novelty` and are not given `weapon` or a weapon kind either; one that is also a cosmetic override
keeps `fashion` too. They go in `deck/items/novelties.lua`. An item can have several words, for example `{ "raw_material" }` for logs.

Some words have more to say about the kind, and open their own choice once the word above is on the card:
- `weapon`, `armour`, `jewellery` or `ammunition` open the **combat style**: `melee_gear`, `ranged_gear`,
  `magic_gear`, `necromancy_gear` or `hybrid_gear` (the wiki's "class" of the item). The words end in
  `_gear` so they are not mistaken for the skills of the same names.
- `food` opens `meal`, `baked_goods`, `fruit_veg` and `raw_food`; `raw_material` opens `log`, `ore`, `bone`,
  `hide`, `herb`, `gem` and `ingredient`; `processed_material` opens `bar`, `plank`, `herb` (a clean herb: the
  grimy one is the raw material, cleaning it with Herblore makes it a processed one), `gem` (a cut gem) and
  `ingredient`. An ingredient goes in `deck/items/raw_materials/ingredients.lua`, or
  `deck/items/processed_materials/ingredients.lua` if it is made from something (butter, flour). The wiki tool also
  suggests it for an intermediate: an item no category classifies that a recipe makes and other recipes use (a
  dry rabbit sandwich, made of bread and rabbit and used to make a rabbit sandwich). Food goes in
  `deck/items/food/` by kind: `meals.lua` (soups, pizzas, dishes), `baked_goods.lua` (pies, bread),
  `fruit_veg.lua`, `meat.lua`, `raw_food.lua` and `cooked_fish.lua`; drinks go in `deck/items/drinks.lua`.
  The wiki's Produce category makes a food a fruit or vegetable. Sandwiches, wraps, stews and soups are meals and
  pies are baked goods, whatever is in them. A food nothing says the kind of is suggested as a meal (the note
  says it is a guess). Dough is a processed ingredient, and bait and swamp paste are consumable. Any other food
  named raw or uncooked that is not an ingredient (a raw pie, soup or potato, or a pie only part made) is
  `food, raw_food`. A raw meat or fish (named raw or uncooked, or in the wiki's
  Uncooked food) is `raw_material, meat` or `raw_material, fish`, not food, and goes in
  `deck/items/raw_materials/meat.lua` or `fish.lua`; the cooked one is `food, meat` or `food, fish`. Junk, an
  item with no use in the game (a jug of bad wine, burnt food, what the wiki calls useless), is `junk` alone
  and goes in `deck/items/junk.lua`. Urns (cooking, mining and the rest) are `consumable`, and a quest item with no file of its kind goes in
  `deck/items/quest_items.lua`. A potion is `potion` (`deck/items/potions.lua`), and one in a flask is `potion, flask`
  (`deck/items/potions/flasks.lua`); the Potion flask itself is a `container`. A potion's card is its full version: 4 doses,
  or 6 for a flask, or the most there are if it has no such version; the tool uses that version's id and examine text, names the card
  without the dose, and leaves out the 2-dose mixes (Barbarian mixes) and the unfinished potions (add one by hand if it has a use of its own).
- `fish` and `meat` open under either `raw_material` or `food`, so raw and cooked fish both use `fish`.
  (A group in `core/cards.lua` can need one word, `requires = "food"`, or any one of a list,
  `requires = { "raw_material", "food" }`.)

**Choosing regions for an item.** A region tag says that an item belongs to a region's story or
loot. It does not say that the item can be found there. Anything that can be had almost anywhere is
left without a region, and is still given out by the Gielinor pack, which has every card. Work down
this list and use the first rule that fits:

1. **One clear source.** A boss drop, a dungeon, a quest reward, a shop found in one region, or a
   named set (Barrows, Noxious weaponry, God Wars drops). Tag that region. Barrows items are
   `morytania`; items dropped in God Wars Dungeon are `asgarnia`.
2. **A few sources.** If it comes from two regions, tag both. Never tag more than **two**.
3. **Everywhere, or three or more regions.** Leave `regions` empty. A bronze longsword is sold in
   three regions and can be made almost anywhere, so it has no region. This keeps the regional packs
   for items that belong to their region.
4. **Can only be crafted.** Look at the item's one distinctive ingredient and tag the region(s) it
   comes from, going back **one step only**. Do not follow the ingredients back to the raw
   materials. If that ingredient comes from more than two regions, leave `regions` empty. A necronium
   greataxe is made from necronium bars, so it takes the region(s) where necronium ore is found.

Where an item is made does not matter: crafting is not a source on its own. Common materials such
as copper, tin or iron do not give a bronze or iron item a region, because those items are not
craft-only. If you cannot tell the answer within a few seconds, leave `regions` empty; it is easy
to add a region later, and an empty one never puts a card in the wrong pack.

**Choosing skills.** Only add a skill when the link is clear: a skill trainer or shop for that
skill (`cooking`), or a creature you train a skill on (`slayer`). Leave it out if you would have
to guess.

**The words you can use now**

- `location`: `lumbridge`, `falador`, `ardougne`, `draynor`, `varrock`, `ranch_out_of_time`, `lumbridge_swamp`, `dorgesh_kaan`, `burthorpe`, `chaos_tunnels`, `fremennik_slayer_dungeon`
- `skills`: `attack`, `defence`, `strength`, `constitution`, `ranged`, `prayer`, `magic`, `cooking`, `woodcutting`, `fletching`, `fishing`, `firemaking`, `crafting`, `smithing`, `mining`, `herblore`, `agility`, `thieving`, `slayer`, `farming`, `runecrafting`, `hunter`, `construction`, `summoning`, `dungeoneering`, `divination`, `invention`, `archaeology`, `necromancy`
- `category` for NPC cards: `humanoid`, `animal`, `dragon`, `undead`, `demon`, `giant`, `goblin`, `troll`, `spirit`, `elemental`, `insect`, `construct`, `shopkeeper`, `stallholder`, `guard`, `knight`, `royalty`, `adventurer`, `wizard`, `priest`, `quest_giver`, `banker`, `farmer`, `pirate`, `thief`, `monster`, `boss`
- `category` for item cards: `raw_material`, `processed_material`, `food`, `drink`, `potion`, `tool`, `container`, `rune`, `seed`, `quest_item`, `currency`, `decoration`, `craftable`, `skill_outfit`, `weapon`, `armour`, `jewellery`, `pocket`, `ammunition`, `fashion`, `novelty`, `consumable`, `treasure_trail`, `slayer_drop`, `minigame`, `discontinued` (no longer obtainable), `junk`; with `raw_material`: `log`, `ore`, `bone`, `hide`, `herb`, `gem`, `ingredient`; with `weapon`: `dagger`, `defender`, `sword`, `scimitar`, `two_handed_sword`, `axe`, `mace`, `maul`, `spear`, `halberd`, `whip`, `claw`, `shortbow`, `longbow`, `crossbow`, `thrown`, `staff`, `wand`, `lantern`, `siphon`, `orb`, `book`; with `armour`: `helmet`, `body`, `legs`, `gloves`, `boots`, `off_hand`, `back`; with `potion`: `flask`; with `jewellery`: `ring`, `neck`; with `ammunition`: `arrow`, `bolt`, `spike`; with `weapon`, `armour`, `jewellery` or `ammunition`: `melee_gear`, `ranged_gear`, `magic_gear`, `necromancy_gear`, `hybrid_gear`; with `food`: `meal`, `baked_goods`, `fruit_veg`, `raw_food`; with `raw_material`: `herb`, `log`, `ore`, `bone`, `hide`; with `raw_material` or `processed_material`: `gem`; with `processed_material`: `bar`, `plank`, `clay`; with `seed`: `allotment`, `flower`, `herb_patch`, `hop`, `bush`, `tree`, `fruit_tree`, `cacti`, `mushroom`, `special`, `vine_flower`, `vine_herb`, `vine_bush`, `fertile_soil`, `dungeoneering_patch`, `berry_planter`; with `raw_material` or `food`: `fish`, `meat`

For reference, the regions (set by the deck file for an NPC, chosen by hand for an item) are `misthalin`, `asgarnia`, `kandarin`, `karamja`, `kharidian_desert`, `morytania`, `tirannwn`, `fremennik_province`, `wilderness`, `anachronia`, `havenhythe`.

### Art

- NPC cards show the NPC's body model by default. Use the head (`body = false`) only if the body
  does not work, for example for an NPC with no useful body.
- The camera settings are saved in the card's `art` entry. You do not need to write them by hand.
- Do not use an animation that is distracting or very fast; the card is small, and zoomed in.
- To find an NPC's own standing animation, look up its animation set (the Card Builder shows its
  name; `config.NPC.FromID(id).bas.id` is its number) in `dev/anim_sets.lua`. That file lists
  every set's stand, walk, run and turns, and the idles it plays now and then, read from the
  game's cache by `python dev/anim_sets.py` (run it again after a game update). An NPC with an
  older model can still clip with its own standing animation; frame the clipping out.

### Duplicates

Before starting, search the deck for the NPC (look for its name in `deck/npcs/`). The Card
Builder will not let you reuse an id, but it cannot tell that two different ids show the same
NPC.

---

## Submitting your cards

1. Create a branch for your cards (for example `cards-lumbridge`).
2. Keep each pull request focused: a handful of related cards is easy to review, a hundred is not.
3. Before you push, check that:
   - [ ] the plugin loads without errors after `prl`,
   - [ ] each card appears correctly in the Card Builder preview,
   - [ ] the checks in the Card Builder show no **Fix** lines,
   - [ ] you used the Card Builder's block as it is (and added any new tag words to
         `Cards.tagWords` (or `Cards.tagGroups`) and to the lists in this guide),
   - [ ] you only changed files in `deck/` (and `core/cards.lua` for new tag words).
4. Open the pull request and **include a screenshot of each card**. A screenshot of the Card
   Builder window with the finished card is ideal.
5. Be ready for feedback. The maintainer may change a rarity, or ask for the camera or the
   animation to be adjusted, either by editing your branch or with a comment.

---

## Artwork

Alternative artwork for the **card frames, the card back and the pack** is welcome. Artwork lives in
`resources/images/`. A new look is submitted as replacement files, so please open an issue
first to agree what you are making before spending time on it.

| File | Size | Notes |
|------|------|-------|
| `frame_<rarity>.png` | 320 x 448 | One for each of common, uncommon, rare, epic, legendary. The window for the NPC must be **transparent**. Its position is set in `CardView.FRAME_ZONES` in `ui/cardview.lua`, so a frame with a window in a different place needs a code change as well |
| `card_back.png` | 320 x 448 | The back of a card, with transparent rounded corners |
| `pack.png` | 320 x 512 | The sealed pack |
| `glow_<rarity>.png` | 456 x 616 | The glow behind a card in the pack opening |

Rules for artwork:

- It must be **your own original work**. Do not submit anything copied or traced from the game,
  from Jagex, or from anywhere else, and do not use RuneScape logos, fonts or screenshots.
- Use PNG with transparency (RGBA), at exactly the sizes above.
- Keep the files small; the plugin has size limits for its resources.
- Check it in the game, on every rarity, using the Card Builder's preview.
- By submitting artwork you agree to the terms in [Licence and ownership](#licence-and-ownership) below.

### Themed pack art

Each region has a themed pack (listed in `deck/packs.lua`) that is designed in the **Pack Maker**,
one of the developer tools. The wrapper is built from the game's own login screen, banner and logo
sprites at runtime, with a shading overlay and a region title from `resources/images/`. The shading
(`pack_shading*.png`) and title (`title_*.png`) images are generated by `dev/make_pack_art.py`, so
please don't submit them by hand. A new themed pack should be agreed in an issue first. It needs a
region word that cards already use, and a pack with no cards in its region is not offered to players.

---

## Code changes

The code is looked after by the project owner. If you have found a bug or have an idea:

1. Open an **issue** describing it (what you saw, or what you would like).
2. Wait for a reply before writing code. A pull request that changes code outside `deck/` and
   `resources/` without a discussion first may be closed.

### Working together

Regular contributors are given access to the repository so they can work on branches in it; everyone
else works from a fork. Either way:

- Work on a branch and open a pull request. `main` is protected, and a pull request needs the
  project owner's approval (see `.github/CODEOWNERS`) before it is merged.
- Keep pull requests small and about one thing. Large ones are hard to review and hard to rebase.
- Say in the issue or the pull request when you are about to start something large. Several files
  (`core/cards.lua`, `ui/kit.lua` and the pack code) are often changed by more than one piece of
  work at once.
- Before asking for a review, bring your branch up to date with `main` and run the plugin: open the
  windows you changed (and the Card Builder, if you touched `ui/` or `core/`) and check them in the
  game. Run `prf` then `prl` in the developer console after adding new files such as images.
- Releases are made by the project owner.

---

## Licence and ownership

**The code.** The plugin's code, including the card files in `deck/`, is under the
[PolyForm Strict License 1.0.0](LICENSE). It is source-available: it may be read and used for
noncommercial purposes, but not distributed or modified, except as set out below.

**Permission to contribute.** You may copy this repository and change your copy on your own
computer, only to prepare a contribution to this project and to send it as a pull request. This
is the only change to the code the licence allows.

**Game data.** `dev/anim_sets.lua`, `dev/npc_tiles.lua`, `dev/seq.txt` and `dev/npc.txt` hold data from the RuneScape client (animation sets, NPC sizes, animation names and NPC names), which belongs to Jagex and is not covered by the licence above. The developer tools read them, and they are left out of the released plugin.

**Cards.** By sending a card (its id, name, description, tags and art settings) you confirm that
the text is your own writing, and you give the project owner a non-exclusive, perpetual,
worldwide, royalty-free right to use, change and distribute it as part of Card Collector.

**Artwork.** You keep ownership of any artwork you create. By sending it you give the project owner
a non-exclusive, worldwide, royalty-free licence to include it in Card Collector, to resize or
adjust it so that it fits, and to distribute it as part of the plugin, and for no other purpose.
It will not be sold. You are free to use your artwork anywhere else.

- You can ask for your artwork to be removed from future versions of the plugin. Versions that
  have already been released are not affected.
- You confirm that you made it, that it is not copied from the game, from other artists or from
  anywhere else.
- You will be credited in `resources/images/CREDITS.md`.

**What is not covered.** RuneScape and its characters, names and models belong to Jagex. Card
Collector uses them through the official plugin API.

Thank you for helping to make the deck bigger and better!
