# Handover: website card pictures

Written for the agent (or person) picking this up on another machine. Delete this file when the work is done.

Read `CLAUDE.md` first; its rules apply (never merge PRs, no Claude attribution in commits or PRs, wiki access only through the scripts, British spelling).

## What this branch is

Branch `site-pictures`, from `origin/main` (which already has PR #78, the weapon tidy and `novelty` tag). It adds the card browser website and the picture pipeline for it:

- `docs/index.html`, `app.js`, `style.css`, `cards.json`, `.nojekyll`: the site. `python dev/build_site.py --check` says whether `cards.json` is current.
- `dev/build_site.py`: builds `cards.json` from the deck and fetches picture files from the wiki. Its docstring explains the flags.
- `dev/site_images.py`: turns the wiki pictures into uniform ones (needs Pillow: `pip install pillow`).
- `.gitignore`: now ignores only `docs/img/`, not all of `docs/`.

There is an older unmerged remote branch, `card-browser-site`, with an earlier version of the same site (before the picture work). This branch supersedes it; if its PR is open, the owner should close it rather than merge both, as the files would clash.

## What is NOT in Git, and why

- `docs/img/` (about 78 MB of processed PNGs, plus `images.json`, which maps each card to its wiki file and credit). It is big, every rebuild rewrites it, and the pictures are wiki images (CC BY-NC-SA).
- `dev/wiki_cache/` (about 100 MB), including `img_raw/`, the full-size originals as the wiki has them. Already ignored before this work.
- `dev/wiki_contact.txt`: each person keeps their own. Create it with the single line `Wiki contact: @blueylewie on Discord`.

On a fresh clone there are therefore no pictures and the site shows placeholders. The owner can copy `docs/img/` and `dev/wiki_cache/` across by USB or cloud drive; with both in place nothing needs downloading and `python dev/build_site.py --process` rebuilds the pictures offline. Without them, redoing it from the wiki is about 1,000 requests at 2 seconds each (about 35 minutes): `python dev/build_site.py --images --max-requests 200`, run repeatedly until it says nothing is left. Do not do this unless the owner says so; it is the wiki's bandwidth.

**Unresolved: how the pictures get published.** The site is meant for GitHub Pages serving `docs/`, which needs the images in the repo or elsewhere. Options put to the owner: convert to WebP (about 40 MB) and commit once, or host the images separately and point `app.js` at that. The owner has not chosen. Do not commit `docs/img/` without asking.

## What has been done

- Diagnosed the inconsistent pictures: CSS percentage `max-height` clipped them in the grid, small wiki thumbnails were never enlarged, and some wiki file names differ from the card names.
- `docs/style.css` line 96: `.c-art img` now fills 86% of the box with `object-fit: contain`.
- Full-size item pictures downloaded once (owner approved), saved in `dev/wiki_cache/img_raw/`.
- `dev/site_images.py` processes every item picture onto a 320x272 transparent canvas: trimmed, scaled (enlarged at most 4x), centred. Long thin weapons are rotated to the top-right diagonal, tip (pointed kinds) or head (others) upward. 1,059 item pictures processed, 43 weapons turned. `TURN_AROUND = {"argonite_battleaxe", "black_defender"}` fixes two the heuristic got backwards. All checked by eye on contact sheets; the owner has not yet looked at the live site.
- Spelling retries in `build_site.py` (`spellings()`): "OH" and "off hand" become "off-hand", the off-hand word moves after the metal, and the main-hand picture is the last resort. Three cards currently borrow the main-hand picture (Iron off hand claws, Off-hand bathus longsword, Rune off hand dagger).

## Known gaps and open questions for the owner

1. Still no picture (placeholder): `offhand_iron_ceremonial_sword`, `oh_adamant_ceremonial_sword`, `oh_mithril_ceremonial_sword`, `oh_rune_ceremonial_sword`, `primal_off_hand_warhammer`, and about 67 other items, mostly seeds, whose wiki file naming has not been checked. 143 cards are in `images.json`'s `missing` list in total (NPCs included).
2. About 41 small-source pictures (seeds, locators, jewels, superior dragon weapons) are enlarged 4x and look soft. That is the wiki's own resolution.
3. NPC pictures are still 160px thumbnails and are not processed. Offered, not requested.
4. Should off-hand cards show a borrowed main-hand picture, or a placeholder?
5. WebP conversion (see above).

Do not start any of these without the owner's go-ahead.

## Practical notes

- Run Python that reads downloaded images with `-I`; keep scripts and downloads in separate directories.
- `python -I dev/site_images.py --sheet out.png id1 id2 ...` makes a before/after contact sheet without touching the site (reads `docs/img` and `docs/cards.json`).
- Tuning rotation or the canvas is cheap: edit `dev/site_images.py`, run `python dev/build_site.py --process`. No internet.
- `lua dev/check_cards.lua` and `python dev/check_deck_index.py` are unaffected by this branch (no deck files change).
