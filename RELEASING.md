# Releasing, versions and card updates

For the project owner. This is how a new version of the plugin goes to Jagex, and how cards reach players
**between** reviews through the card overlay, and how its numbers and switches are adjusted the same way (tuning). Contributors do not need any of it: they submit cards as described in
[CONTRIBUTING.md](CONTRIBUTING.md).

## Contents

1. [The idea in one page](#the-idea-in-one-page)
2. [Words used here](#words-used-here)
3. [Fixing or adding cards between reviews](#fixing-or-adding-cards-between-reviews)
4. [Tuning numbers and switches between reviews](#tuning-numbers-and-switches-between-reviews)
5. [Submitting a new version to Jagex](#submitting-a-new-version-to-jagex)
6. [When Jagex approves a version](#when-jagex-approves-a-version)
7. [What the overlay can and cannot do](#what-the-overlay-can-and-cannot-do)
8. [Rules that keep it safe](#rules-that-keep-it-safe)
9. [What players see](#what-players-see)
10. [Checking and diagnosing it](#checking-and-diagnosing-it)
11. [Where everything is](#where-everything-is)
12. [If Jagex say no, or it has to be removed](#if-jagex-say-no-or-it-has-to-be-removed)
13. [Limits and things to know](#limits-and-things-to-know)

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
| **Tuning** | `docs/tuning.json`: numbers, lists and switches (`core/config.lua`) that the overlay carries as one line, within limits fixed in the plugin. |
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

## Tuning numbers and switches between reviews

The overlay file can also carry one **tuning line**: numbers, short lists and on/off switches that the plugin reads from
`core/config.lua`. A number that turns out wrong (a credit amount, a pull rate) or a feature that misbehaves can then be
fixed without waiting for a review. The line is built from `docs/tuning.json`, a JSON object that is committed as `{}` (no
line) and holds only what is to be changed. `dev/build_overlay.py` writes it as the overlay's first line:

```
{"base":"0.1.0","format":1,"revision":4}
{"tuning":{"packs":{"price":3000},"bosses":{"overrides":{"24":1800}}}}
{"art":{...},"id":"hans",...}
```

### What can be set

Only the keys below. Each has a default (what the plugin ships with) and limits that are written in `core/config.lua`, in
reviewed code: a key outside its limits, of the wrong type or not in this table is **ignored and logged**, and the rest of
the line still applies. A key left out keeps its default.

| Key | Default | Limits | What it does |
|---|---|---|---|
| `earning.enabled` | `true` | `false` turns it off | Switch for all XP credits |
| `earning.xpPerCredit` | 10 | whole number 5 to 20 | XP that adds up to one credit |
| `earning.combatSkills` | the 10 combat skills and Slayer | up to 30 `SkillType` names, at least one valid | Skills whose XP earns nothing |
| `starterCredits` | 8,000 | whole number 0 to 20,000 | Credits a new collection starts with |
| `packs.price` | 4,000 | whole number 2,000 to 8,000 | Price of a standard pack |
| `packs.themedPriceFactor` | 1.25 | 1 to 2 | Themed packs cost this times the price (unless a pack sets its own) |
| (a pack's own `priceFactor`) | Free to Play 0.75 | set in `deck/packs.lua`, not tunable | The Free to Play pack costs 0.75 times `packs.price` (3,000 at the default), whatever `packs.themedPriceFactor` is, and follows `packs.price` when that changes. Changing the 0.75 needs a new version |
| `odds.rarity.<rarity>` | 63, 25, 9.4, 2, 0.6 | 0 to 100; `common` above 0 | Relative weight of each rarity in a pack |
| `odds.finish.normal` / `.foil` / `.holo` | 17 / 2 / 1 | normal 1 to 1,000; foil and holo 0 to 1,000 | Relative weight of each finish, so foil is 1 in 10 and holo 1 in 20 at the defaults (0 means none of that finish are pulled) |
| `slayer.enabled` | `true` | `false` turns it off | Switch for all Slayer credits |
| `slayer.creditsPerLevel` | 1 | 0.5 to 2 | Credits for each combat level of a kill |
| `slayer.bonusMultiplier` | 5 | 0 to 10 | The task bonus, as a multiple of the kill credits at the average level |
| `slayer.levelCap` | none | whole number 10 to 14,000 | The highest level paid for |
| `slayer.vars.count` / `.task` / `.streak` | 183 / 185 / 10077 | whole number 1 to 60,000 | The game variables Slayer is read from (a game update can move them) |
| `bosses.enabled` | `true` | `false` turns it off | Switch for all boss credits |
| `bosses.tiers` | 5 tiers: 9,000 gives 8,000; 5,000 gives 4,000; 1,000 gives 1,800; 500 gives 800; 0 gives 400 | 1 to 8 pairs `[level, credits]`, levels falling, each 0 to 20,000 | Credits by the boss's combat level; valid only as a whole list |
| `bosses.activities` | the Barrows chest, 1,800 | up to 20 entries: a `BSLAY_BOSS_KILLS<n>` variable, a rise that is a power of two, a name, credits 0 to 20,000 | Counts that rise for something other than a kill. Added to the shipped ones; credits 0 stops one paying |
| `bosses.overrides` | none | up to 60: boss id 1 to 200, credits 0 to 20,000 | Credits for one boss, whatever its level |
| `bosses.ignore` | none | up to 60 boss ids, 1 to 200 | Bosses that pay nothing |
| `shine.enabled` | `true` | `false` turns it off | Switch for the foil shine (the pastel shine over the whole card) |
| `holo.enabled` | `true` | `false` turns it off | Switch for the holo rainbow (behind the picture); holo cards then look like normal ones |
| `revision` | none | whole number | Optional number for your own bookkeeping |

`earning.combatSkills` is a name list, so a wrong name is the same mistake that once let Hitpoints XP earn credits (the game's
member is `HITPOINTS`): names that are not `SkillType` members are dropped and logged. `slayer.vars` and `bosses.activities`
are the risky keys: a wrong id points detection at the wrong variable, so try them in the dev copy first.

### Rules

- **Data only.** Numbers, short lists and switches. It never carries code or text shown to players.
- **Off only.** A switch can turn a feature off. It can never turn on something the build does not already do, and nothing
  here adds a new way to earn credits.
- **Limits are in the code.** They cannot be changed from outside. Adding a key, or widening a limit, needs a new version
  (it goes through `core/config.lua`, `dev/check_config.lua` and Jagex's review).
- **One bad key never costs the rest.** Each key is checked alone.
- **Memory only.** Nothing is saved: the tuning is fetched at each start, applied once and forgotten at the end of the session.
- **For one version.** It rides in the overlay, so it reaches only the version in the overlay's `base`.

### Changing it

1. Edit `docs/tuning.json`: put in only what you want to change.
2. `lua dev/check_tuning.lua docs/tuning.json` says whether the plugin would ignore any key (it also runs in the Check cards
   workflow, so a bad file cannot be merged).
3. Try it in the dev copy: `python dev/build_overlay.py --local` writes `dev/local_overlay.lua` (not committed; it leaves
   `docs/overlay.jsonl` alone), `prl` reloads the plugin, and **Dev tools > Local overlay** applies it as if it had been
   fetched. The log says `card updates: tuning differs from the shipped numbers in: ...` and any key it ignored. Check the
   thing you changed in the game.
4. Publish: `python dev/build_overlay.py`, then commit `docs/tuning.json` and `docs/overlay.jsonl` in a pull request and merge
   it, as for cards.
5. Players get it at their next start (GitHub caches the file for up to 10 minutes). `revision` in the header goes up, and
   their Settings line says `On - settings updated`.

### Rolling back

Put `{}` back in `docs/tuning.json` (or revert the pull request), run `python dev/build_overlay.py` and merge. Every player is
back on the shipped numbers at their next start, because nothing is saved. A player who does not restart keeps the old
numbers until they do (Jagex force a log-out after 6 hours).

### When Jagex approve a version

Tuning rides in the overlay, which is rebuilt against the new tag: `docs/tuning.json` stays and goes into the new overlay.
If a tuned value should become permanent, change its default in `core/config.lua` in the next version and take the key out of
the file; otherwise the file keeps overriding the default. Players who have not updated yet stop receiving the overlay, tuning
included, as for cards.

### Things to know

- **Not everyone gets it.** `httpAccess` is optional, so players without it run the shipped numbers. Bug reports and
  credits-per-hour figures should say the `revision` (the log line has it).
- **A typo inside the limits still reaches everyone within a session.** The limits are tight on purpose; `dev/check_tuning.lua`
  catches the rest.
- **The listing says so.** The mod.io description says the plugin reads credit amounts, pull odds and switches from the same
  file, within limits fixed in the reviewed code.

## Submitting a new version to Jagex

Make a release branch from the commit you build the package from (`git branch release/<major.minor> <hash>`, for example
`release/1.0`) and push it. Jagex review the exact files you upload, so anything they ask you to change goes on that
branch (a pull request into it), the package is rebuilt from it, and the branch is merged back into `main` afterwards.
`main` carries on as normal (new cards, features) without any of that reaching the version in review.

1. All checks pass (see `CLAUDE.md`), and `docs/overlay.jsonl` is up to date.
2. **Bump the version in two places, together:** `plugin.json` (`"version"`) and `core/version.lua` (`number`). The
   plugin cannot read its own version from the API, so it keeps its own copy. `lua dev/check_version.lua` (and the
   Check cards workflow) fails if they differ.
   Add the version to `CHANGELOG.md` (newest first); its lines go in mod.io's changelog box when you upload.
3. Set a real `contactEmailAddress` in `plugin.json` (`dev/build_release.py` reminds you).
4. Build the package: `python dev/build_release.py <plugin folder> <output folder>` (copies only `main.lua`, `plugin.json`,
   `LICENSE` and the `core`, `ui`, `deck` and `resources` folders, leaving out hidden files, Markdown files and
   everything else, and stops with a message if the result is wrong).
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
retire a card. Its tuning line can also change the numbers and switches listed under *Tuning numbers and switches between
reviews*, and nothing else.

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
- **No effect on saves.** The overlay never touches what a player has: their collection, credits and settings. Cards it
  removes stay in their save. (Tuning changes what they earn and pay from then on, not what they already hold.)
- **Only data.** The plugin never runs anything it downloads; it decodes JSON (`core/json.lua`, written for this
  and checked against Python's decoder), validates every card and keeps every tuning key inside the limits in
  `core/config.lua`.

## What players see

- The overlay needs the optional **`httpAccess`** permission, which the player grants in the client, as they do for
  `trackingAccess`. Without it nothing is fetched and the plugin runs on the cards it shipped with.
- The **Settings** page (the cog on the main window, and the plugin's page in the client's settings) has a **Card
  updates** line: a short text with an info icon beside it, and hovering the icon shows the explanation. The
  permission is called **HTTP Access** there, as in the client's own permission window.

  | Shows | Means |
  |---|---|
  | `Checking...` | Starting, fetching or applying. |
  | `On - up to date` | The overlay was fetched and had no changes for them. |
  | `On - 12 cards updated` | The overlay was applied; this many cards were added, changed or retired. |
  | `On - settings updated` | The overlay was applied and its tuning line changed some numbers or switches (the tooltip says how many); with card changes too, the line names the cards and the tooltip the settings. |
  | `On - no updates` | The overlay on the site is for a different version (for example this player is behind, or ahead of, the tag). |
  | `Unreachable, will retry` | A fetch failed; it tries again after 1 minute and again after 5. |
  | `Update server unreachable` | All three tries failed. Nothing more this session. |
  | `Off` | The permission is not granted (the tooltip says to turn on HTTP Access). It follows the permission live: switching it off after the overlay was applied shows `Off` too. |
  | `Off - not available` | The plugin has no `cards` url (a build without it). |

  The line is `Loader.playerLine()` in `core/overlayloader.lua`; every short line is checked to fit beside the icon
  (28 letters, `dev/check_loader.lua`). The page's "Your collection" line (how the collection is saved, and what the
  Tracking permission does) is built the same way, from `Format.collectionLine` in `core/format.lua`.

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
- **Dev tools > Local overlay** applies `dev/local_overlay.lua` instead, so a tuning change or new cards can be tried without
  publishing: `python dev/build_overlay.py --local`, `prl`, then the button. The log shows `card updates: tuning differs
  from the shipped numbers in: ...` and `card updates: tuning ignored ...` for each key refused.
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
| `lua dev/check_logger.lua` | detail is only logged when asked for, a failure is logged once, and no shipped file bypasses the logger |
| `lua dev/check_viewer.lua` | the collection viewer's search, filters and sorts, compared with a plain loop over the real deck |
| `lua dev/check_viewer_ui.lua` | the viewer's controls (search, drop-downs, rows, grid, paging) against a stand-in client; no looks |
| `lua dev/check_tuning.lua` | `docs/tuning.json` (the overlay's tuning line) is JSON and every key in it passes `core/config.lua`'s own checks: a key the plugin would ignore fails here, before it is published |
| `lua dev/check_config.lua` | the tunable numbers, lists and switches (`core/config.lua`): their defaults are what shipped, each limit holds, one bad key never costs the others, and that earning, pack prices and odds, Slayer and boss credits follow a change |
| `lua dev/check_bosses.lua` | the boss kill credits against the events recorded in the game (K'ril, Corporeal Beast, Rasial, Zemouregal), and the cases around them: no boss in view, the first moments after login, a count rising by other than one kill, the Barrows chest |
| `lua dev/check_slayer.lua` | the Slayer credits against recorded game events (kills, AOE, completion, cancel, skip), and that combat XP earns nothing |
| `python dev/test_build_overlay.py` | what goes in the overlay and when `revision` changes |
| `lua dev/check_format.lua` | the credits text the overlay shows (`19 249`) and the settings page's collection line |
| `lua dev/check_framestats.lua` | the numbers the performance probe (`dev/perfprobe.lua`, dev copy only) writes to the log |

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
| `dev/build_overlay.py` | Builds it: diffs the deck at the newest `v*` tag against the deck now, and adds the tuning line. `--check`, `--base`, `--out`, `--lua`, `--tuning`, `--local`. |
| `dev/export_overlay.lua`, `dev/overlay_lines.lua`, `dev/jsonencode.lua` | Write every card as one canonical JSON line. |
| `core/overlay.lua` | Applies an overlay text, a few lines at a time. |
| `core/overlayloader.lua` | Fetches it (from `Event.Logic` ticks only) and reports status. |
| `core/json.lua` | The JSON decoder. |
| `core/version.lua` | The plugin version the overlay is matched against. |
| `core/cards.lua` | `Cards.problem`, `register`, `deprecate`, `resort`, `revision`, `loadProblems`. |
| `core/tagwords.lua`, `core/packtypes.lua` | The tag word lists and `isKnown`; the pack types (`PackTypes.byId`) and their checks. |
| `plugin.json` | The optional `httpAccess` permission and the `cards` url. |
| `ui/settingspage.lua` | The "Card updates" line. |
| `docs/tuning.json` | The numbers and switches to change (committed as `{}`). |
| `core/config.lua` | Every tunable key with its default and its limits, `Config.get` and `Config.apply`. |
| `dev/check_tuning.lua`, `dev/check_config.lua` | Check the file and the keys (both in the Check cards workflow). |
| `dev/local_overlay.lua` | Made by `build_overlay.py --local` for the Local overlay button (not committed). |

## If Jagex say no, or it has to be removed

The feature is self-contained. Revert, in `plugin.json`, the `httpAccess` entry in `optionalPermissions` and the
`cards` entry in `urls`, and remove the `OverlayLoader` lines from `main.lua` and the "Card updates" lines from
`ui/settingspage.lua`. Nothing else depends on it: the shipped cards, saves and the rest of the plugin are
unchanged, and everything in `dev/` is left out of the release anyway. The rest (the decoder, the overlay build)
can stay for later. The tuning line goes with it: `core/config.lua` keeps the numbers as plain defaults, so nothing else changes.

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
