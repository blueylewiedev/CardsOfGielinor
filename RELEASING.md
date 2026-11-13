# Releasing, versions and card updates

For the project owner. This is how a new version of the plugin goes to Jagex, and how cards reach players
**between** reviews through the card overlay. Contributors do not need any of it: they submit cards as described in
[CONTRIBUTING.md](CONTRIBUTING.md).

## Contents

1. [The idea in one page](#the-idea-in-one-page)
2. [Words used here](#words-used-here)
3. [Fixing or adding cards between reviews](#fixing-or-adding-cards-between-reviews)
4. [Submitting a new version to Jagex](#submitting-a-new-version-to-jagex)
5. [When Jagex approves a version](#when-jagex-approves-a-version)
6. [What the overlay can and cannot do](#what-the-overlay-can-and-cannot-do)
7. [Rules that keep it safe](#rules-that-keep-it-safe)
8. [What players see](#what-players-see)
9. [Checking and diagnosing it](#checking-and-diagnosing-it)
10. [Where everything is](#where-everything-is)
11. [If Jagex say no, or it has to be removed](#if-jagex-say-no-or-it-has-to-be-removed)
12. [Limits and things to know](#limits-and-things-to-know)

---

## The idea in one page

Jagex review each plugin version about every two weeks, and a new version is only submitted when there is a
reasonable batch of work. So a card fix or a new batch of cards would otherwise wait weeks for players. The plugin
therefore has two ways to get cards:

1. **Shipped with the version.** Every card is in the plugin itself (`deck/`). This is what Jagex review, and it is
   always there, whatever happens to the network.
2. **The overlay.** A small file, `docs/overlay.jsonl`, published on the project's GitHub Pages site. When the
   plugin starts it fetches the file and applies it: new cards are added, changed cards replace the shipped
   version, and retired cards are taken out. It holds only what is **different from the last version Jagex
   approved**, so once the next version is approved it is empty again.

```
 deck/*.lua (the source of truth)
     │  dev/export_overlay.lua      every card as one JSON line, as the game has it
     ▼
 dev/build_overlay.py              compares the deck now with the deck at the newest approved tag
     ▼
 docs/overlay.jsonl                committed; merging to main publishes it on GitHub Pages
     ▼
 https://blueylewiedev.github.io/CardsOfGielinor/overlay.jsonl
     ▼
 core/overlayloader.lua            fetches it at start-up, from game ticks only
     ▼
 core/overlay.lua                  checks it is for this version, applies it 50 lines a tick
```

Cards stay written in Lua in `deck/`. The overlay is only ever generated from them, never edited by hand.

## Words used here

| Word | Meaning |
|---|---|
| **Approved version** | The plugin version Jagex last approved and published. It is what players run. |
| **Tag** | A git tag `v<version>` (for example `v0.2.0`) on the commit that was submitted and approved. |
| **Overlay** | `docs/overlay.jsonl`: the cards that are new or different since the newest tag. |
| **`base`** | In the overlay's header: the plugin version it was built for (the version in `plugin.json` at the tag). The plugin applies the overlay only if its own version is `base`. Changes each time a new version is approved and tagged. |
| **`format`** | In the header: the layout of the file (header line, card lines, `{"deprecated": id}` lines). It is `1`. It changes only if the layout changes in a way an older plugin could not read. A plugin that does not understand the format ignores the overlay and uses the cards it shipped with. |
| **`revision`** | In the header: a counter that goes up each time the overlay's content changes, and starts again at 1 for a new `base`. For the log and for spotting a cached copy; the plugin does not need it. |
| **Retire / deprecate** | Take a card out of the game. Players keep their copies in their saves, and the card comes back if it is published again. |

The overlay file is JSON lines. The first line is the header; each later line is a whole card, or a retirement:

```
{"base":"0.1.0","format":1,"revision":3}
{"art":{"anim":808,"cam":{...},"npc":"HANS"},"desc":"...","id":"hans","name":"Hans","rarity":"common","tags":{...}}
{"deprecated":"old_card_id"}
```

## Fixing or adding cards between reviews

Once at least one version has been approved and tagged:

1. Make the change in `deck/` as usual (a new card, a corrected rarity, a camera fix).
2. Run the checks (`lua dev/check_cards.lua` and the rest listed in `CLAUDE.md`) and `python dev/build_site.py`.
3. Run `python dev/build_overlay.py`. It prints what is in the overlay (for example `12 cards (3 new, 9 changed), 0
   deprecated`). Commit `docs/overlay.jsonl` with the change.
4. Open the pull request and merge it. GitHub Pages publishes the file within a minute or two.
5. Players get it the next time the plugin starts. GitHub caches the file for up to 10 minutes, so a fix can take
   that long to be served.

`python dev/build_overlay.py --check` says whether the committed file matches the deck (and writes nothing).

Until the first tag exists there is nothing to compare against, so the overlay is empty (just a header). That is
correct, and it is what is committed.

## Submitting a new version to Jagex

Nothing needs its own branch: `main` carries on as normal while a version is in review.

1. All checks pass (see `CLAUDE.md`), and `docs/overlay.jsonl` is up to date.
2. **Bump the version in two places, together:** `plugin.json` (`"version"`) and `core/version.lua` (`number`). The
   plugin cannot read its own version from the API, so it keeps its own copy. `lua dev/check_version.lua` (and the
   Check cards workflow) fails if they differ.
3. Set a real `contactEmailAddress` in `plugin.json` (`dev/build_release.py` reminds you).
4. Build the package: `python dev/build_release.py <plugin folder> <output folder>` (leaves out `dev/`, `docs/`
   and the Markdown files).
5. **Write down the commit hash** the package was built from (`git rev-parse HEAD`). You tag that commit when the
   version is approved.
6. Upload it. The plugin asks for the optional `httpAccess` permission and declares one url,
   `https://blueylewiedev.github.io`. Both are in `plugin.json`, and they are what Jagex see for this feature.

While the version is in review, players still run the old one. The overlay stays built against the old tag, so it
carries everything the players' version lacks, including the cards that are in the submission, and any new
fixes.

## When Jagex approves a version

1. **Tag the submitted commit** (not `main`, which has probably moved on) and push the tag:
   ```
   git tag -a v0.2.0 <the hash you wrote down> -m "Approved by Jagex, <date>"
   git push origin v0.2.0
   ```
   Tag when it is **approved**, not when it is submitted. Tagging at submission would switch the overlay to a
   version nobody is running yet, and cards fixed during the review would reach nobody.
2. `python dev/build_overlay.py` (run `git fetch --tags` first if the tag was made on another machine). The overlay
   is now built against `v0.2.0`: `base` becomes `0.2.0`, `revision` restarts at 1, and it holds only what changed
   since that commit. Commit `docs/overlay.jsonl` in a pull request.

Players who have not yet updated from the previous version stop receiving the overlay (its `base` no longer matches
their version) until they update. Tag promptly once the version is live.

If you ever need to find the commit a version was built from and did not write it down, search for the
version bump: `git log -S'"version": "0.2.0"' -- plugin.json`.

## What the overlay can and cannot do

**It can** add a card, replace any field of an existing card (name, rarity, description, art, camera, tags) and
retire a card.

**It cannot** change code. It cannot fix a bug in the plugin, and a card that needs something only the newer
code understands will not work for players on the older version:

- A card that uses a tag word the older plugin does not have is **skipped** (and logged) by the older plugin, and
  appears when they update. This is safe and is the main case.
- A card with an extra field the old code ignores shows without that effect.

Because `main` moves ahead of the approved version, remember this when a card depends on new code.

## Rules that keep it safe

- **Ids are permanent.** An id that has been published, in an approved version or in the overlay, is never
  renamed or reused. Saves are keyed by `<card id>|<finish>`. Retire a card with a deprecation; do not delete the
  id and later give it to a different card. (A different version of a card gets a new id.)
- **The overlay is for one version.** The plugin applies it only when its version equals `base`.
- **The format must be understood.** An unknown `format` is ignored.
- **A bad line never breaks anything.** A line that is not JSON, or a card that fails the same checks the deck
  cards must pass (known rarity, known tag words, a sound id and name, and so on), is skipped and logged; the rest
  is applied. The deck itself works the same way at start-up: a bad card, file or pack is left out and logged
  (`DECK PROBLEM`), and only the dev copy and `dev/check_cards.lua` treat that as an error.
- **An overlay cannot empty the game.** It may retire at most 5% of the cards, or 50 cards if that is more; later
  retirements are skipped and logged. This guards against a wrongly built overlay.
- **No effect on saves.** The overlay never touches a player's collection, credits or settings. Cards it removes
  stay in their save.
- **Only data.** The plugin never runs anything it downloads; it decodes JSON (`core/json.lua`, written for this
  and checked against Python's decoder) and validates every card.

## What players see

- The overlay needs the optional **`httpAccess`** permission, which the player grants in the client, as they do for
  `trackingAccess`. Without it nothing is fetched and the plugin runs on the cards it shipped with.
- The **Settings** page (the cog on the main window, and the plugin's page in the client's settings) has a **Card
  updates** line:

  | Shows | Means |
  |---|---|
  | `Checking for card updates...` | Starting, fetching or applying. |
  | `On - the cards are up to date` | The overlay was fetched and had no changes for them. |
  | `On - 12 cards updated` | The overlay was applied; this many cards were added, changed or retired. |
  | `On - no updates for this version` | The overlay on the site is for a different version (for example this player is behind, or ahead of, the tag). |
  | `Could not reach the update server, trying again` | A fetch failed; it tries again after 1 minute and again after 5. |
  | `Could not reach the update server` | All three tries failed. Nothing more this session. |
  | `Off - allow the httpAccess permission to turn on` | The permission is not granted. |
  | `Off - not available` | The plugin has no `cards` url (a build without it). |

- The overlay is fetched once when the plugin starts. Jagex force a log-out after 6 hours, so a long session
  does not keep an old overlay indefinitely.

## Checking and diagnosing it

**In the client** (the dev copy asks for `httpAccess` itself on every start; the `prf` then `prl` console
commands refresh the plugin list and reload it):

- The Output window logs a `card updates:` line whenever something happens, for example
  `card updates: revision 3 of the overlay for version 0.1.0: 12 new cards, 4 changed, 1 retired, 0 lines skipped`.
  Each skipped line is logged after it with its line number and why.
- **Dev tools > Fetch updates** fetches and applies again, or says what the loader is doing if a fetch is under
  way.
- To check the "wrong version" path, set `core/version.lua` and `plugin.json` to another number: the log says
  `not applied: the overlay is for version 0.1.0, this is version 0.1.1`, and no card changes.
- Trying a **big** overlay: `python dev/build_overlay.py --base <an older commit> --out <a scratch file>` shows what
  an overlay would hold without touching `docs/overlay.jsonl`. (A one-off in-client test, a button that applied a
  made-up overlay of 900 new cards, took a longest frame of 28 ms against a normal 11 ms; that is why the loader
  applies 50 lines a tick.)

**Offline** (from the plugin folder; the Check cards workflow runs them all):

| Command | Checks |
|---|---|
| `lua dev/check_json.lua` | the JSON decoder, good and bad input, and `docs/cards.json` |
| `lua dev/check_registry.lua` | adding, replacing and retiring cards; a bad card is left out |
| `lua dev/check_overlay.lua` | the whole deck survives being exported, decoded and registered, field for field |
| `lua dev/check_loader.lua` | applying an overlay, and the loader against a pretend `HTTPRequest` (404s, timeouts, retries, wrong version) |
| `lua dev/check_version.lua` | `core/version.lua` equals the version in `plugin.json` |
| `python dev/test_build_overlay.py` | what goes in the overlay and when `revision` changes |

**Common messages**

| Log line | Meaning |
|---|---|
| `the httpAccess permission is not granted, so card updates are not fetched` | Grant the permission (dev copy: `prf`, `prl`). |
| `the overlay could not be fetched (code 404)` | The file is not on the site: not merged yet, or the wrong path. |
| `not applied: the overlay is for version X, this is version Y` | The tag, `plugin.json` and `core/version.lua` disagree, or the player's version is not the tagged one. |
| `skipped line N: ...` | One card line was refused; the reason follows. Fix the card and rebuild. |
| `more cards retired than an overlay may` | The overlay retires over 5% of the deck: it is almost certainly wrong. |
| `stopped for this session: an error in the loader` | A bug in the loader. It stops by itself and the plugin carries on with the shipped cards. Report it. |

## Where everything is

| File | What it is |
|---|---|
| `docs/overlay.jsonl` | The overlay (generated, committed). |
| `dev/build_overlay.py` | Builds it: diffs the deck at the newest `v*` tag against the deck now. `--check`, `--base`, `--out`, `--lua`. |
| `dev/export_overlay.lua`, `dev/overlay_lines.lua`, `dev/jsonencode.lua` | Write every card as one canonical JSON line. |
| `core/overlay.lua` | Applies an overlay text, a few lines at a time. |
| `core/overlayloader.lua` | Fetches it (from `Event.Logic` ticks only) and reports status. |
| `core/json.lua` | The JSON decoder. |
| `core/version.lua` | The plugin version the overlay is matched against. |
| `core/cards.lua` | `Cards.problem`, `register`, `deprecate`, `resort`, `revision`, `loadProblems`. |
| `plugin.json` | The optional `httpAccess` permission and the `cards` url. |
| `ui/settingspage.lua` | The "Card updates" line. |

## If Jagex say no, or it has to be removed

The feature is self-contained. Revert, in `plugin.json`, the `httpAccess` entry in `optionalPermissions` and the
`cards` entry in `urls`, and remove the `OverlayLoader` lines from `main.lua` and the "Card updates" lines from
`ui/settingspage.lua`. Nothing else depends on it: the shipped cards, saves and the rest of the plugin are
unchanged, and everything in `dev/` is left out of the release anyway. The rest (the decoder, the overlay build)
can stay for later.

## Limits and things to know

- **One fetch per start-up**, plus up to two retries after a failure. A fix reaches a player at their next start.
- **GitHub caches the file for up to 10 minutes.**
- **The client crashes on two things this code avoids:** coroutines, and starting a network request from inside
  another request's callback (and a POST with no data turns into a GET). Everything here runs from game ticks.
  Do not change this without testing in the client.
- **Pack sizes and the collection** are recalculated when an overlay applies (`Cards.revision`); an overlay that
  adds many cards makes them show up in packs and the viewer at once.
- **The viewer's order** is by rarity (`Cards.resort`), which the loader runs after applying.
- **No persistent cache.** Nothing is stored between sessions; if the site is unreachable the plugin has the cards
  it shipped with.
- **Unreviewed content is data only,** but it is content Jagex have not seen. Keep to cards and descriptions that
  would pass their review.
