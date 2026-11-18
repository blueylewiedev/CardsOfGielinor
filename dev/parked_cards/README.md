# Parked cards

Cards that were taken out of the game but are kept so one can be brought back. This folder is not loaded by the plugin and
is not in the release (`dev/` is left out of it). It mirrors `deck/`: a parked card is in the file with the same path as the
deck file it came from, with that file's header (and `defaults`) kept, so restoring it is a copy and paste.

`python dev/check_deck_index.py` checks that every file here is listed in `index.lua`, and `lua dev/check_parked.lua` (in the
Check cards workflow) checks that every parked card is still a sound card and that none has the id of a card in the deck.
A tag word that is renamed, or a change to the card format, shows up there instead of when someone tries to restore a card.

## What is parked

| Date | Why | Cards | List |
|---|---|---|---|
| 2026-11-18 | The Dungeoneering trim (commit `a6b6b3a`): Dungeoneering is a skill, so its items stay, but the Daemonheim region held 711 cards, 12.7% of the deck. Five levers: twins that exist outside the dungeons (6), off-hand twins of main-hand weapons (61), grimy herbs and raw food whose clean or cooked version is a card (19), the ten metal tiers cut to a signature set (99), every other ranged, magic and necromancy armour set (74) | 259 | [dungeoneering_2026-11-18.txt](dungeoneering_2026-11-18.txt): `lever|id|name|rarity` |

## Bringing a card back

1. Cut its block (the `{` ... `},` with its `id`) from the file here, and paste it into the deck file with the same path, e.g.
   `dev/parked_cards/deck/items/weapons/daggers.lua` goes back into `deck/items/weapons/daggers.lua`. If it was the last card in
   its parked file, delete that file and its line in `index.lua`.
2. `lua dev/check_cards.lua` and `lua dev/check_parked.lua`.
3. To put it in the game between releases rather than waiting for a version, publish it through the overlay: see
   [RELEASING.md](../../RELEASING.md) (`python dev/build_overlay.py`). A card that is not in the deck at the newest tag
   appears there as an added card.

A player who already owned a parked card still has it in their save (unknown card ids are kept), so it comes back with the card.

## Parking more cards

Do the same in reverse: move the block into the mirrored file here (copy the deck file's header first if the file is new, and
add it to `index.lua`), then run the two checks. The card has to be taken out of `deck/` in the same pull request, or
`check_parked.lua` fails because the id is in both.
