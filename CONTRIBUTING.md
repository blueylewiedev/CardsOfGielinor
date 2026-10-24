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
checks it as you go. You do not need to know how the code works.

1. **Choose the NPC.**
   - Stand near the NPC in the game and press **Nearby NPCs**, then **Scan**, then **Use** on the
     NPC you want. This picks the exact NPC (many NPCs have several versions with different
     models, and the one standing in front of you is the one to use), or
   - press **Search NPCs**, type part of the name and press **Use**, or
   - type the NPC's *config name* (for example `FATHER_AERECK`) into the box. In the developer
     console, `pan NPC` lists the config names.

   The box says **Found** when the client knows the NPC. The name and the id are filled in for
   you, and the card appears in the preview.
2. **Check the name and id.** The name is what is printed on the card. The id follows the name
   (see [Ids](#ids)). Change either if you need to.
3. **Write a description** (up to 60 letters, shorter is better).
4. **Suggest a rarity** from the drop-down. This is only a suggestion; see [Rarity](#rarity).
5. **Add tags**, if they apply (see [Tags](#tags)).
6. **Choose the deck file** the card belongs in (see [Which deck file](#which-deck-file)).
7. **Tune the art.**
   - **Model** switches between the NPC's whole body (the default) and its head.
   - The **camera buttons** zoom, move and turn the camera. Aim to fill the picture window with
     the NPC, with the face visible. A look through the existing cards gives a good idea.
   - **Finish** shows the card as a normal, reverse holo and holo card. Check all three.
   - **Animation** is optional. Type a sequence id, step through ids with the +/- buttons, or
     press **Search anims** to look for an animation by name and **Use** to try it. Pick an idle
     or other animation that loops smoothly.
8. **Read the checks** at the bottom left. Anything marked **Fix** has to be sorted out before
   the block is ready. **Note** lines are worth a look but will not stop you.
9. **Copy the card block.** Click the box under *Your card block*, press **Ctrl+A** then
   **Ctrl+C**.
10. **Paste it** into the deck file you chose (see below), inside the `Set.cards` list. One card
    goes on one line, which is fine; the maintainer may tidy the layout when merging.
11. **Reload the plugin** (`prl`) and check that the card loads and looks right. The plugin
    checks every card when it loads, and stops with a message naming the card if something is
    wrong.

**Reset** at the top of the Card Builder clears the window ready for the next card. What you type
is kept while the plugin is running, so closing the window does not lose it.

### Which deck file

The cards are in `deck/npcs/`, one file for each region (`misthalin.lua`, `asgarnia.lua`,
`kandarin.lua`), plus `general.lua` for NPCs that are not tied to one place (guards, shop keepers,
animals). Put a card in the file for the region where the NPC is found. Every card in a region's
file gets that region's tag automatically.

If your NPC lives in a region that has no file yet, say so in your pull request; a new file has to
be created and listed in `deck/index.lua`.

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
  and strong opinions."). Keep it to 60 letters at most.
- Keep everything suitable for all ages. No real people, no references to real-world events or
  accounts, no copying text from elsewhere.

### Rarity

Rarity is the card's chance of turning up in a pack: common, uncommon, rare, epic and legendary.
Your choice is a **suggestion**. The maintainer decides the final rarity so the deck stays
balanced, and will either change it or leave a comment on your pull request explaining what is
wanted. Looking at where similar NPCs sit in the existing files is the best guide.

### Tags

Tags group cards so that themed packs can draw from them. Each tag kind holds words separated by
commas:

| Kind | Meaning | Example |
|------|---------|---------|
| `locations` | where the NPC is found | `lumbridge`, `varrock sewers`, `feldip hills` |
| `skills` | skills it is linked to | `cooking`, `prayer` |
| `category` | what kind of character | `humanoid`, `beast`, `demon`, `tradeable` |

The region comes from the deck file, so it is not asked for.

- Tag words are **lower case letters, digits and underscores**, starting with a letter. The
  Card Builder will not accept anything else.
- Use an existing word if one fits. The checks tell you when a word is new.
- **A new word is allowed.** For `towns` and `skills`, new words must also be added to the list in
  `Cards.tagWords` in `core/cards.lua` (the Card Builder shows a note saying exactly which). For
  `category`, there is no list yet; a new word just needs to be a sensible one that others can
  reuse.

### Art

- NPC cards show the NPC's body model by default. Use the head (`body = false`) only if the body
  does not work, for example for an NPC with no useful body.
- The camera settings are saved in the card's `art` entry. You do not need to write them by hand.
- Do not use an animation that is distracting or very fast; the card is small, and zoomed in.

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
   - [ ] each card appears correctly in the Card Builder preview in **normal, reverse holo and
         holo**,
   - [ ] the checks in the Card Builder show no **Fix** lines,
   - [ ] you used the Card Builder's block as it is (and added any new tag words to
         `Cards.tagWords`),
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
| `reverse_<rarity>_a.png`, `_b.png` | 320 x 448 | Shine for reverse holo cards, shaped like the frame |
| `holo_a.png`, `holo_b.png` | 256 x 192 | Shine over the art window of holo cards |
| `card_back.png` | 320 x 448 | The back of a card, with transparent rounded corners |
| `pack.png` | 320 x 512 | The sealed pack |
| `glow_<rarity>.png` | 456 x 616 | The glow behind a card in the pack opening |

Rules for artwork:

- It must be **your own original work**. Do not submit anything copied or traced from the game,
  from Jagex, or from anywhere else, and do not use RuneScape logos, fonts or screenshots.
- Use PNG with transparency (RGBA), at exactly the sizes above.
- Keep the files small; the plugin has size limits for its resources.
- Check it in the game, on every rarity and finish, using the Card Builder's preview.
- By submitting artwork you agree to the terms in [Licence and ownership](#licence-and-ownership) below.

---

## Code changes

The code is looked after by the project owner, and contributions to it are not expected. If you
have found a bug or have an idea:

1. Open an **issue** describing it (what you saw, or what you would like).
2. Wait for a reply before writing code. A pull request that changes code outside `deck/` and
   `resources/` without a discussion first may be closed.

---

## Licence and ownership

**The code.** The plugin's code, including the card files in `deck/`, is under the
[PolyForm Strict License 1.0.0](LICENSE). It is source-available: it may be read and used for
noncommercial purposes, but not distributed or modified, except as set out below.

**Permission to contribute.** You may copy this repository and change your copy on your own
computer, only to prepare a contribution to this project and to send it as a pull request. This
is the only change to the code the licence allows.

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
