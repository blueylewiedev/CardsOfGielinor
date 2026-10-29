#!/usr/bin/env python3
"""Makes card candidates from the RuneScape Wiki, for review in the plugin's Wiki Review window
(dev/wikireview.lua), which loads each one into the Card Builder to check, frame and copy. The
Wiki Fetch window (dev/wikifetch.lua) puts the command together for you.

Usage:  python dev/wiki_cards.py [--category NAME ...] [--page TITLE ...] [options]
  e.g.  python dev/wiki_cards.py --category Lumbridge --category Logs

  --category NAME   the pages in a wiki category (without "Category:"): places for NPCs, such as
                    Lumbridge, or kinds of item, such as Logs or Scimitars
  --page TITLE      one page, e.g. "Duke Horacio" (both can be given, and more than once)
  --region NAME     the NPCs and monsters of a league region, e.g. Global (found all over the
                    world: rats) or Misthalin: every NPC or monster page whose infobox gives it,
                    from the wiki's structured data (two requests). Big regions have hundreds of
                    pages, fetched over several runs. "Multiple" is every NPC or monster found
                    in two or more regions (Imp, Chicken): general cards, like Global's. "None"
                    is every one the wiki gives no region (Lucien): each takes its places'
                    regions where it can, and is filed under them
  --race NAME       only NPCs of this race (as the wiki's infobox names it, e.g. Dog, Dwarf, Demon)
                    from this run's categories and regions; more than once for several
  --members f2p|p2p only the free to play (f2p) or members (p2p) pages of this run's categories
                    and regions
  --npcs            only the NPCs of this run's categories and regions, no items (the wiki files
                    a place's items under it too: Varrock armour in Varrock)
  --within REGION   only the NPCs of this run's categories whose own league region is this one
                    (Varrock within Misthalin: not Chancy, filed under Varrock for a quest but
                    living in Rimmington, Asgarnia)
                    --race and --members narrow what is fetched: the wiki is asked which pages of the
                    category or region match (a search, or for a region's membership its
                    structured data), and only those are fetched. They belong to the categories and
                    regions they are given with, which are remembered with them ("Lumbridge
                    (dog)"); other sources are not narrowed.
  --contact TEXT    how the wiki's admins can reach you; added to the User-Agent (recommended).
                    Without it, the first line of dev/wiki_contact.txt is used (a file on your
                    own computer, not committed), e.g.  @yourname on Discord
  --max-requests N  the most requests this run may make (default 30). Anything not fetched yet
                    is fetched next run; what was fetched is kept.
  --refresh         fetch again even what is in the cache (only for pages changed on the wiki)
  --count           a preview: how many pages this run's categories, regions and pages would
                    fetch, and how many requests that takes. Only lists them (a request or two
                    each, cached, so the real run doesn't ask again); fetches no pages, writes no
                    candidates and remembers nothing
  --only            candidates from this run's categories and pages only (see below)
  --forget          forget the categories and pages asked for before (see below)
  --drops TITLE     a page with a drop table, e.g. "Kree'arra" (more than once is fine): the drop
                    rates in it are kept (dev/wiki_cache/drops.json), and an item that drops there
                    gets a rarity from its rarest drop rate. Only items from the pages asked for
                    are known, so give it the bosses and monsters whose drops you are carding
  --drops-from TITLE
                    the same for every page linked from a list page, e.g. "Bosses" (see --until)
  --until HEADING   with --drops-from: stop at this heading, leaving out it and everything after
  --all-bosses      short for --drops-from Bosses --until "Quest bosses": the drop rates of every
                    boss on the wiki's Bosses page before its Quest bosses section
  --subcategories NAME
                    list the subcategories of a wiki category with how many pages each has, to find
                    category names to use with --category (one request, cached). Makes no candidates
                    and does not change the remembered categories. e.g.
                    python dev/wiki_cards.py --subcategories "Equipment Slots"

The categories, regions and pages asked for are remembered (dev/wiki_cache/sources.json), and the
candidates are made from all of them each run, from the cache, so asking for more adds to the
list. It writes dev/wiki_candidates.lua: for each NPC page, the NPC's config name (the wiki gives
the NPC ids; dev/npc.txt turns them into names), and for each item page, the item's ids (the
plugin turns them into config names); with each, the card name, the examine text as the
description, tags, a suggested rarity, and notes on anything to check. Cards already in the
deck are left out by the review window, not here.

Being a good guest of the wiki (https://runescape.wiki/w/Help:APIs, and MediaWiki's
https://www.mediawiki.org/wiki/API:Etiquette):
  * only the API (api.php) is used, never the pages themselves
  * one request at a time, at least MIN_GAP seconds apart, gzip-compressed, with maxlag so the
    wiki can ask us to wait while it is busy; a request to wait (maxlag, 429, 503) is honoured
  * a descriptive User-Agent (the wiki blocks the default ones of HTTP libraries)
  * pages are asked for in batches, and every answer is cached in dev/wiki_cache/ (not committed),
    so running it again asks the wiki for nothing it has already given; --refresh is the only
    way to ask again
  * a hard limit on requests per run

The wiki's own writing is CC BY-NC-SA; nothing from it is copied onto cards except facts (names,
ids, places) and the examine text, which is the game's own text.
"""
import argparse
import gzip
import json
import math
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from collections import Counter, defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
CACHE = ROOT / "dev" / "wiki_cache"
OUTPUT = ROOT / "dev" / "wiki_candidates.lua"
NPC_LIST = ROOT / "dev" / "npc.txt"
CONTACT_FILE = ROOT / "dev" / "wiki_contact.txt"
CARDS = ROOT / "core" / "cards.lua"

API = "https://runescape.wiki/api.php"
USER_AGENT = "CardsOfGielinor-card-candidates/1.0 (dev tool for a RuneScape plugin; https://github.com/blueylewiedev/CardsOfGielinor)"
MIN_GAP = 2.0           # seconds between requests
MAXLAG = 5              # seconds of database lag at which the wiki asks us to wait
BATCH = 25              # pages per request (their categories fit in one answer at this size)
RETRIES = 3             # times to wait and try again when the wiki asks us to wait

# ---------------------------------------------------------------------------------------------
# The wiki, politely
# ---------------------------------------------------------------------------------------------


class Wiki:
    def __init__(self, contact, max_requests):
        self.agent = USER_AGENT if not contact else USER_AGENT[:-1] + "; contact: " + contact + ")"
        self.left = max_requests
        self.last = 0.0

    def get(self, params):
        """One API request (a dict of parameters). Returns the decoded JSON, or None once this
        run's request limit is used up."""
        params = dict(params, format="json", formatversion="2", maxlag=str(MAXLAG))
        url = API + "?" + urllib.parse.urlencode(params)
        for attempt in range(RETRIES + 1):
            if self.left <= 0:
                return None
            wait = self.last + MIN_GAP - time.monotonic()
            if wait > 0:
                time.sleep(wait)
            self.left -= 1
            self.last = time.monotonic()
            request = urllib.request.Request(url, headers={"User-Agent": self.agent, "Accept-Encoding": "gzip"})
            try:
                with urllib.request.urlopen(request, timeout=60) as response:
                    body = response.read()
                    if response.headers.get("Content-Encoding") == "gzip":
                        body = gzip.decompress(body)
                data = json.loads(body)
            except urllib.error.HTTPError as error:
                if error.code in (429, 503) and attempt < RETRIES:
                    delay = int(error.headers.get("Retry-After") or 30)
                    print(f"  the wiki asked us to wait ({error.code}); waiting {delay}s")
                    time.sleep(delay)
                    continue
                raise
            if data.get("error", {}).get("code") == "maxlag" and attempt < RETRIES:
                delay = int(data["error"].get("lag", 5)) + 5
                print(f"  the wiki is busy (maxlag); waiting {delay}s")
                time.sleep(delay)
                continue
            if "error" in data:
                raise RuntimeError(f"wiki error: {data['error']}")
            return data
        return None

    def get_all(self, params):
        """A request and its continuations (the API's "continue"), as a list of answers. Stops
        early (returning None) if the request limit runs out part way."""
        answers, extra = [], {}
        while True:
            data = self.get(dict(params, **extra))
            if data is None:
                return None
            answers.append(data)
            if "continue" not in data:
                return answers
            extra = data["continue"]


def cache_path(kind, name):
    safe = re.sub(r"[^A-Za-z0-9_.-]+", "_", name)
    return CACHE / kind / (safe + ".json")


def read_cache(kind, name):
    path = cache_path(kind, name)
    return json.loads(path.read_text(encoding="utf-8")) if path.exists() else None


def write_cache(kind, name, value):
    path = cache_path(kind, name)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=1), encoding="utf-8")


def category_pages(wiki, category, refresh):
    """The article titles in a category (cached)."""
    cached = None if refresh else read_cache("categories", category)
    if cached is not None:
        return cached
    answers = wiki.get_all({"action": "query", "list": "categorymembers", "cmtitle": "Category:" + category,
                            "cmnamespace": "0", "cmtype": "page", "cmlimit": "500"})
    if answers is None:
        print(f"  request limit reached before the category {category} was listed")
        return []
    titles = [m["title"] for a in answers for m in a["query"]["categorymembers"]]
    write_cache("categories", category, titles)
    return titles


# The wiki's structured data (Bucket:Infobox npc and Bucket:Infobox monster) holds each NPC
# page's league region, so a region's NPCs can be asked for directly.
NPC_BUCKETS = ("infobox_npc", "infobox_monster")
BUCKET_LIMIT = 5000     # rows per request
MULTIPLE = "Multiple"   # the --region for pages found in several regions ("Karamja,Misthalin,...")
NO_REGION = "None"      # the --region for pages that give no league region (Lucien)


def league_regions(value):
    """The places a league region value lists, as slugs ("Misthalin, Asgarnia" -> misthalin,
    asgarnia). One that needs both ("Kandarin&Desert") is a single place, in the first; values that
    are not places (league relics and perks, "Golden touch") are left out, and so is one named twice."""
    places = (slug(part.split("&")[0]) for part in (value or "").split(","))
    return list(dict.fromkeys(r for r in places if r in LEAGUE_REGIONS))


def version_regions(fields, n):
    """The regions an NPC infobox's version n gives (0: the plain fields), as region words. The
    field also takes league relics and perks ("Golden touch"), which are not places, and
    "Kandarin&Desert" for somewhere that needs both: one place, in the one its location is in
    (PLACE_REGIONS: the rogue in Varrock, "Wilderness & Misthalin", is in Misthalin), else the first."""
    suffix = str(n) if n else ""
    value = plain(fields.get("leagueregion" + suffix) or fields.get("leagueregion", ""))
    places = links(fields.get("location" + suffix) or fields.get("location", ""))
    homes = {PLACE_REGIONS.get(place.lower()) for place in places}
    regions = []
    for part in value.split(","):
        options = [REGION_ALIASES.get(slug(o), slug(o)) for o in part.split("&")]
        options = [o for o in options if o in LEAGUE_REGIONS or o in REGION_ALIASES.values()]
        region = next((o for o in options if o in homes), options[0] if options else None)
        if region and region not in regions:
            regions.append(region)
    return regions


def several_regions(value):
    """True if a league region value lists two or more places ("Asgarnia,Misthalin")."""
    return len(league_regions(value)) > 1


def region_pages(wiki, region, refresh, members=None):
    """The NPC and monster pages whose infobox gives this league region (cached), only the free
    to play or members ones if `members` is f2p or p2p: one query of the wiki's buckets for each
    kind of infobox (more for a very big region). The region MULTIPLE has no value of its own to
    ask for, so every infobox's region is read and the pages kept whose every version that gives
    one lists several (Imp; not Wise Old Man, in Misthalin but for one quest's version);
    NO_REGION's are the pages none of whose versions gives one.
    Returns None if the request limit ran out before the region was listed (it is asked for again
    next run: a part of it would be wrong for MULTIPLE, which needs every row)."""
    key = region + ("|" + members if members else "")
    cached = None if refresh else read_cache("regions", key)
    if cached is not None:
        return cached
    where = "" if region in (MULTIPLE, NO_REGION) else f".where('league_region', {json.dumps(region)})"
    if members:
        where += f".where('is_members_only', {'true' if members == 'p2p' else 'false'})"
    titles, values = [], {}
    for bucket in NPC_BUCKETS:
        offset = 0
        while True:
            query = (f"bucket('{bucket}').select('page_name', 'league_region'){where}"
                     f".limit({BUCKET_LIMIT}).offset({offset}).run()")
            answer = wiki.get({"action": "bucket", "query": query})
            if answer is None:
                print(f"  request limit reached before the region {region} was listed")
                return None
            rows = answer.get("bucket", [])
            for row in rows:
                if row.get("page_name"):
                    titles.append(row["page_name"])
                    if row.get("league_region") not in (None, "", "No"):
                        values.setdefault(row["page_name"], []).append(row["league_region"])
            if len(rows) < BUCKET_LIMIT:
                break
            offset += BUCKET_LIMIT
    titles = list(dict.fromkeys(titles))      # (a row for each version of a page)
    if region == MULTIPLE:
        titles = [t for t in titles if values.get(t) and all(several_regions(v) for v in values[t])]
    if region == NO_REGION:
        titles = [t for t in titles if not values.get(t)]
    write_cache("regions", key, titles)
    return titles


def search_titles(wiki, query, refresh):
    """The article titles a wiki search finds (cached), or None if the request limit ran out."""
    cached = None if refresh else read_cache("searches", query)
    if cached is not None:
        return cached
    answers = wiki.get_all({"action": "query", "list": "search", "srnamespace": "0", "srlimit": "500",
                            "srprop": "", "srsearch": query})
    if answers is None:
        return None
    titles = [r["title"] for a in answers for r in a["query"]["search"]]
    write_cache("searches", query, titles)
    return titles


def narrowed(wiki, titles, scope, races, members, refresh):
    """The titles of a category or region that the wiki's search says have one of the races and
    the membership asked for, so only those are fetched. `scope` keeps the search to the category
    or region (incategory:"Lumbridge", insource:"leagueRegion = Misthalin"); each search is cached.
    A field can be the page's only one (race = Dog) or its first version's (race1 = Dog), so both
    are asked for. `members` here is only for a category (a region's is asked of its buckets).
    Returns None if the request limit ran out before it was known."""
    keep = set(titles)
    wanted = []
    if races:
        wanted.append([f'insource:"{field} = {r.replace("_", " ")}"' for r in races for field in ("race", "race1")])
    if members:
        answer = "No" if members == "f2p" else "Yes"
        wanted.append([f'insource:"{field} = {answer}"' for field in ("members", "members1")])
    for terms in wanted:
        found = set()
        for term in terms:
            result = search_titles(wiki, f"{scope} {term}", refresh)
            if result is None:
                return None
            found |= set(result)
        keep &= found
    return [t for t in titles if t in keep]


def list_subcategories(wiki, category, refresh):
    """The subcategories of a category with their page counts, as [(name, pages, subcategories)]
    (cached). One request: a generator over the category's members with their category info."""
    cached = None if refresh else read_cache("subcategories", category)
    if cached is not None:
        return [tuple(row) for row in cached]
    answers = wiki.get_all({"action": "query", "generator": "categorymembers", "gcmtitle": "Category:" + category,
                            "gcmtype": "subcat", "gcmlimit": "500", "prop": "categoryinfo"})
    if answers is None:
        print("  request limit reached before the subcategories were listed")
        return []
    rows = []
    for answer in answers:
        for page in answer.get("query", {}).get("pages", []):
            info = page.get("categoryinfo", {})
            rows.append((page["title"].removeprefix("Category:"), info.get("pages", 0), info.get("subcats", 0)))
    rows.sort()
    write_cache("subcategories", category, rows)
    return rows


def fetch_pages(wiki, titles, refresh):
    """Each title's wikitext and categories, from the cache or the wiki in batches. Returns
    { title: page } for the pages it has (some may be left for the next run)."""
    pages, wanted = {}, []
    for title in titles:
        cached = None if refresh else read_cache("pages", title)
        if cached is not None:
            pages[title] = cached
        else:
            wanted.append(title)
    for start in range(0, len(wanted), BATCH):
        batch = wanted[start:start + BATCH]
        answers = wiki.get_all({"action": "query", "titles": "|".join(batch), "redirects": "1",
                                "prop": "revisions|categories", "rvprop": "content|ids", "rvslots": "main",
                                "cllimit": "max", "clshow": "!hidden"})
        if answers is None:
            print(f"  request limit reached; {len(wanted) - start} pages left for next time")
            break
        found, asked = {}, {}
        for answer in answers:
            query = answer.get("query", {})
            # A title asked for may come back under its normalised or redirected name.
            for hop in query.get("normalized", []) + query.get("redirects", []):
                asked[hop["to"]] = hop["from"]
            for page in query.get("pages", []):
                entry = found.setdefault(page["title"], {"title": page["title"], "categories": []})
                if page.get("missing"):
                    entry["missing"] = True
                for revision in page.get("revisions", []):
                    entry["revid"] = revision["revid"]
                    entry["text"] = revision["slots"]["main"]["content"]
                entry["categories"] += [c["title"].removeprefix("Category:") for c in page.get("categories", [])]
        for title, entry in found.items():
            entry["fetched"] = time.strftime("%Y-%m-%d")
            original = title
            while original in asked:
                original = asked[original]
            write_cache("pages", original, entry)
            pages[original] = entry
    return pages


# ---------------------------------------------------------------------------------------------
# Reading the infobox
# ---------------------------------------------------------------------------------------------


def find_template(text, names):
    """The first {{...}} template with one of these names, as its inside text, or None."""
    match = re.search(r"\{\{\s*(" + "|".join(re.escape(n) for n in names) + r")\s*\|", text)
    if not match:
        return None, None
    depth, i = 0, match.start()
    while i < len(text):
        if text.startswith("{{", i):
            depth, i = depth + 1, i + 2
        elif text.startswith("}}", i):
            depth, i = depth - 1, i + 2
            if depth == 0:
                return match.group(1), text[match.end():i - 2]
        else:
            i += 1
    return None, None


def npc_infobox(page):
    """A page's NPC or monster infobox, as (kind, fields), or (None, None). A page with several
    whose first is named for something else uses the one named as the page, with the first one's
    fields for what it leaves out: Leon d'Cour sits watching as a "Mystery figure", then is fought
    (his location is the first's); the Cat page starts with the Kitten. (A boss talked to, then
    fought, keeps its first: both have its name, or the first has none.)"""
    title = page.get("title", "").lower()
    named = lambda fields: plain(first_version(fields, "name")).lower() in ("", title)
    found = [(kind, template_fields(inside))
             for kind, inside in find_templates(page.get("text", ""), ["Infobox NPC", "Infobox Monster"], kinds=True)]
    if not found:
        return None, None
    kind, fields = found[0]
    for other_kind, other in found[1:]:
        if not named(fields) and plain(first_version(other, "name")).lower() == title:
            return other_kind, {**fields, **other}
    return kind, fields


def find_templates(text, names, kinds=False):
    """Every {{...}} template with one of these names, as a list of inside texts (with kinds, of
    (name, inside text) pairs)."""
    found, start = [], 0
    while True:
        kind, inside = find_template(text[start:], names)
        if inside is None:
            return found
        found.append((kind, inside) if kinds else inside)
        start += text[start:].find(inside) + len(inside)


def template_fields(inside):
    """The named fields of a template's inside text: { name: value }."""
    fields, depth, part = {}, 0, []
    for i, ch in enumerate(inside + "|"):
        two = inside[i:i + 2]
        if two in ("{{", "[["):
            depth += 1
        elif two in ("}}", "]]"):
            depth -= 1
        if ch == "|" and depth == 0:
            piece = "".join(part)
            if "=" in piece:
                key, value = piece.split("=", 1)
                fields[key.strip().lower()] = value.strip()
            part = []
        else:
            part.append(ch)
    return fields


def plain(value):
    """Wikitext as plain text: links to their words, templates and markup dropped."""
    value = re.sub(r"<!--.*?-->|<ref.*?(/>|</ref>)", "", value or "", flags=re.S)
    value = re.sub(r"\[\[(?:[^|\]]*\|)?([^\]]*)\]\]", r"\1", value)
    value = re.sub(r"\{\{[^{}]*\}\}", "", value)
    value = re.sub(r"<[^>]+>|'{2,}", "", value)
    return re.sub(r"\s+", " ", value).strip()


def links(value):
    """The pages a wikitext value links to."""
    return [m.strip() for m in re.findall(r"\[\[([^|\]#]+)", value or "")]


def first_version(fields, key):
    """A field of the infobox's first version: key1, or the plain key."""
    for name in (key + "1", key):
        if fields.get(name, "").strip() not in ("", "No", "no"):
            return fields[name]
    return ""


def numbered_fields(fields, key):
    """The values of a field and its numbered versions (location, location1, location2...)."""
    return [v for k, v in fields.items() if re.fullmatch(key + r"\d*", k)]


def all_ids(fields):
    """Every NPC id the infobox lists, first version first."""
    ids = []
    keys = sorted((k for k in fields if re.fullmatch(r"id\d*", k)), key=lambda k: int(k[2:] or 0))
    for key in keys:
        for part in re.split(r"[,\s]+", plain(fields[key])):
            if part.isdigit() and int(part) not in ids:
                ids.append(int(part))
    return ids


# ---------------------------------------------------------------------------------------------
# The plugin's own lists
# ---------------------------------------------------------------------------------------------


def npc_names():
    """{ npc id: config name } from dev/npc.txt."""
    names = {}
    for line in NPC_LIST.read_text(encoding="utf-8").splitlines():
        parts = line.split(None, 1)
        if len(parts) == 2 and parts[0].isdigit():
            names[int(parts[0])] = parts[1].strip()
    return names


def allowed_words():
    """The words cards may use, from core/cards.lua: regions, location, skills, the NPC category
    words (category), the item category words (item_category) and, for the item words that need
    another, a list of the words one of which it needs (item_requires: scimitar -> [weapon])."""
    text = CARDS.read_text(encoding="utf-8")

    def quoted(block):
        return re.findall(r'"([a-z0-9_]+)"', block)

    words = {}
    for kind in ("regions", "location", "skills"):
        match = re.search(r"Cards\.tagWords\s*=\s*\{.*?" + kind + r"\s*=\s*\{([^}]*)\}", text, re.S)
        words[kind] = quoted(match.group(1)) if match else []
    groups = re.search(r"Cards\.tagGroups\s*=\s*\{(.*?)\n\}", text, re.S)
    words["category"] = quoted(groups.group(1)) if groups else []
    words["item_category"], words["item_requires"] = [], {}
    item_groups = re.search(r"Cards\.itemTagGroups\s*=\s*\{(.*?)\n\}", text, re.S)
    # (`requires` is one word, or a list of words of which any one will do)
    for single, several, block in re.findall(
            r'\{\s*title\s*=\s*"[^"]*",\s*(?:requires\s*=\s*(?:"(\w+)"|\{([^}]*)\}),\s*)?'
            r'words\s*=\s*\{([^}]*)\}', item_groups.group(1) if item_groups else ""):
        requires = [single] if single else quoted(several)
        for word in quoted(block):
            words["item_category"].append(word)
            if requires:
                words["item_requires"][word] = requires
    return words


# The places among the league region field's values (Module:LeagueRegion), as slugs.
LEAGUE_REGIONS = {"global", "anachronia", "asgarnia", "desert", "fremennik", "havenhythe", "kandarin", "karamja",
                  "misthalin", "morytania", "tirannwn", "wilderness"}
# The wiki's region names that differ from the plugin's region words.
REGION_ALIASES = {"desert": "kharidian_desert", "kharidian_desert": "kharidian_desert",
                  "fremennik": "fremennik_province", "fremennik_provinces": "fremennik_province"}

# Places that don't count among an NPC's when it has another (as its location tags, its versions'
# regions, or a region its league regions name for them), and the region each is in:
# - minigames that bring back monsters from elsewhere: the Dominion Tower in the desert (the Evil
#   Chicken, "Misthalin&Kandarin,Desert"; its fighters are filed under it) and Rush of Blood in
#   Prifddinas (the Dagannoth guardian, "Fremennik,Tirannwn"; its fighters are RUSH_OF_BLOOD), and
#   the Dominion Tower's Rumble Mode (a version of its fighters, Damis's);
# - New Varrock, met in another time (Sigmund lives in Lumbridge; the Stone face, only in the
#   Dominion Tower, keeps it);
# - Manor Farm, which the Artisans' Workshop dwarves only visit with farming requests.
SECONDARY_PLACES = {"Dominion Tower": "kharidian_desert", "Rumble Mode": "kharidian_desert", "Rush of Blood": "tirannwn",
                    "New Varrock": None, "New Varrock Museum": None, "Manor Farm": None}
# The monsters of Rush of Blood's waves (the monster pages its wiki page links, October 2026).
RUSH_OF_BLOOD = {
    "Aviansie", "Tormented demon", "Ice strykewyrm", "Airut", "Steel titan", "Kal'gerion demon", "Automaton Guardian",
    "Dagannoth", "Vyrewatch", "Abyssal demon", "Baby black dragon", "Dagannoth (Lighthouse)", "Exiled kalphite paragon",
    "Exiled kalphite soldier", "Exiled kalphite worker", "Greater demon", "Grotworm", "Ket-Zek", "Rorarius", "Tok-Xil",
    "TzHaar-Hur", "TzHaar-Ket", "TzHaar-Mej", "TzHaar-Xil", "Yt-MejKot", "Aquanite", "Black demon", "Capsarius",
    "Gladius", "Dagannoth sentinel", "Death spawn", "Nechryael", "Exiled kalphite guardian", "Exiled kalphite marauder",
    "Iron dragon", "Mutated jadinko baby", "Vyrelady", "Vyrelord", "Black dragon", "Dagannoth guardian", "Dark beast",
    "Desert strykewyrm", "Mature grotworm", "Mithril dragon", "Mutated jadinko guard", "Steel dragon", "TokHaar-Hur",
    "TokHaar-Ket", "TokHaar-Mej", "TokHaar-Xil", "TokHaar-Ket Champion", "TokHaar-Ket-Zek", "TokHaar-Tok-Xil",
    "TokHaar-Yt-MejKot", "Waterfiend", "Adamant dragon", "Bladed muspah", "Force muspah", "Throwing muspah",
    "Celestial dragon", "Ganodermic beast", "Ganodermic runt", "Mutated jadinko male", "Glacor",
}

# The longest description that fits on a card, and the most regions an NPC card is in (its deck
# file's and one more: one found in more is a general card), as core/cards.lua sets them.
MAX_DESC = int(re.search(r"Cards\.MAX_DESC\s*=\s*(\d+)", CARDS.read_text(encoding="utf-8")).group(1))
MAX_NPC_REGIONS = int(re.search(r"Cards\.MAX_NPC_REGIONS\s*=\s*(\d+)", CARDS.read_text(encoding="utf-8")).group(1))

# NPC configs that show nothing: stand-ins a cutscene or quest uses.
BLANK_CONFIG = re.compile(r"BLANK|INVISIBLE|DUMMY")

# The most places an NPC's versions may name together for them all to become its location tags.
VERSION_PLACES = 4
# A link that is a date or a year ("21 May", "2017"), not a place.
DATE_LINK = re.compile(r"^\d+( (January|February|March|April|May|June|July|August|September|October|November|December))?$"
                       r"|^(January|February|March|April|May|June|July|August|September|October|November|December) \d+$")

# The most places a monster's location table may name for them to become its location tags.
LOCATION_TABLE_PLACES = 3

# Places whose NPCs belong to one region, although the wiki lists more (the regions the place's
# portals reach): a page filed under the place gets that region only. The player-owned port is in
# Port Sarim, though its NPCs are "Desert,Asgarnia,Tirannwn".
HOME_REGIONS = {"Player-owned port": "asgarnia"}

# Category words suggested by the infobox's race.
RACE_WORDS = {
    "human": "humanoid", "dwarf": "humanoid", "elf": "humanoid", "gnome": "humanoid", "halfling": "humanoid",
    "werewolf": "humanoid", "vampyre": "undead", "goblin": "goblin", "hobgoblin": "goblin", "dragon": "dragon",
    "demon": "demon", "giant": "giant", "ogre": "giant", "troll": "troll", "undead": "undead", "skeleton": "undead",
    "zombie": "undead", "ghost": "undead", "spirit": "spirit", "elemental": "elemental", "spider": "insect",
    "insect": "insect", "golem": "construct", "construct": "construct", "cow": "animal", "chicken": "animal",
    "dog": "animal", "cat": "animal", "rat": "animal", "bird": "animal", "bear": "animal", "wolf": "animal",
    "sheep": "animal", "goat": "animal", "horse": "animal", "unicorn": "animal",
    "penguin": "animal", "frog": "animal", "bat": "animal", "duck": "animal", "owl": "animal", "rabbit": "animal",
    "squirrel": "animal", "raccoon": "animal", "deer": "animal", "snake": "animal", "tortoise": "animal",
    "beaver": "animal", "mole": "animal", "polar_bear": "animal", "chinchompa": "animal", "meerkats": "animal",
    "crab": "animal", "rock_crab": "animal", "lobster": "animal", "leech": "animal", "monkey": "animal", "fish": "animal",
    "ant": "insect", "butterfly": "insect", "soporith_moth": "insect", "firefly": "insect",
    "automaton": "construct", "dorgeshuun": "goblin", "mummy": "undead",
}
# Races that say nothing worth a category word of their own.
RACE_NOT_WORDS = {"unknown", "other", "none", "n_a"}

# Skills from the page's wiki categories (a whole category name).
CATEGORY_SKILLS = {
    "Thievable entities": "thieving", "Thievable quest entities": "thieving", "Slayer monsters": "slayer",
    "Familiars": "summoning", "Guthixian Cache": "divination", "Hunter creatures": "hunter",
}

# Category words suggested by the page's wiki categories (a category name containing the key).
CATEGORY_WORDS = {
    "merchants": "shopkeeper", "shopkeepers": "shopkeeper", "stall": "stallholder", "monarchs": "royalty",
    "royalty": "royalty", "bankers": "banker", "guards": "guard", "knights": "knight", "wizards": "wizard",
    "priests": "priest", "monks": "priest", "pirates": "pirate", "farmers": "farmer", "thieves": "thief",
    "bosses": "boss", "dominion tower": "boss", "adventurers": "adventurer",
    "pets": "pet",                      # (every pet category: skilling, boss, companion pets...)
}


# Item category words suggested by the equipment slot (Infobox Bonuses' slot).
SLOT_WORDS = {
    "weapon": ["weapon"], "2h": ["weapon"], "main-hand": ["weapon"], "off-hand": ["armour", "off_hand"],
    "shield": ["armour", "off_hand"], "head": ["armour", "helmet"], "torso": ["armour", "body"],
    "body": ["armour", "body"], "legs": ["armour", "legs"], "hands": ["armour", "gloves"],
    "feet": ["armour", "boots"], "cape": ["armour", "back"], "back": ["armour", "back"],
    "neck": ["jewellery", "neck"], "ring": ["jewellery", "ring"], "ammo": ["ammunition"], "pocket": ["pocket"],
}

# Item category words suggested by the page's wiki categories: a whole word of a category's name
# (the "Disassemble category/..." ones name the kind of item well). Words that need another
# (scimitar needs weapon) get it added.
ITEM_CATEGORY_WORDS = {
    "logs": ["raw_material", "log"], "ores": ["raw_material", "ore"], "ore": ["raw_material", "ore"],
    "hides": ["raw_material", "hide"], "bones": ["raw_material", "bone"],
    "bars": ["processed_material", "bar"], "bar": ["processed_material", "bar"],
    "planks": ["processed_material", "plank"],
    "runes": ["rune"], "food": ["food"], "fish": ["food", "fish"], "meat": ["food", "meat"], "drinks": ["drink"], "potions": ["potion"],
    "potion": ["potion"], "seeds": ["seed"], "jewellery": ["jewellery"], "quest items": ["quest_item"],
    "arrows": ["ammunition", "arrow"], "bolts": ["ammunition", "bolt"], "dagger": ["dagger"], "daggers": ["dagger"],
    "scimitar": ["scimitar"], "scimitars": ["scimitar"], "longsword": ["sword"], "sword": ["sword"],
    "2h sword": ["two_handed_sword"], "two-handed swords": ["two_handed_sword"], "battleaxe": ["axe"],
    "battleaxes": ["axe"], "mace": ["mace"], "maces": ["mace"], "spear": ["spear"], "spears": ["spear"],
    "halberd": ["halberd"], "halberds": ["halberd"], "whip": ["whip"], "claws": ["claw"], "shortbow": ["shortbow"],
    "longbow": ["longbow"], "longbows": ["longbow"], "crossbow": ["crossbow"], "crossbows": ["crossbow"],
    "thrown": ["thrown"], "staff": ["staff"], "staves": ["staff"], "wand": ["wand"], "wands": ["wand"],
    "lantern": ["lantern"], "siphon": ["siphon"],
    # Herbs, gems and tools.
    "herbs": ["raw_material", "herb"], "herb": ["raw_material", "herb"],
    "gems": ["raw_material", "gem"], "gem": ["raw_material", "gem"],
    "tools": ["tool"], "pickaxes": ["tool"], "hatchets": ["tool"],
    # Equipment categories by slot (the names are a best guess: check them with --subcategories).
    # The slot in the page's Infobox Bonuses gives the same words; these help when it is missing.
    "head slot items": ["armour", "helmet"], "body slot items": ["armour", "body"],
    "legs slot items": ["armour", "legs"], "hands slot items": ["armour", "gloves"],
    "feet slot items": ["armour", "boots"], "cape slot items": ["armour", "back"],
    "shield slot items": ["armour", "off_hand"], "neck slot items": ["jewellery", "neck"],
    "ring slot items": ["jewellery", "ring"], "ammunition slot items": ["ammunition"],
    "pocket slot items": ["pocket"],
}

# A wiki category that says an item is a cosmetic (an override, only worn for its looks): it is
# tagged fashion, and nothing else, as the Contributing guide says.
COSMETIC_CATEGORY = re.compile(r"\bcosmetic|\boverride")


def slug(text):
    return re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")


# ---------------------------------------------------------------------------------------------
# Candidates
# ---------------------------------------------------------------------------------------------


# Categories whose pages never become cards, and why (the Sinkholes D&D's own versions of monsters
# and familiars, "Giant rat (Sinkholes)").
SKIPPED_CATEGORIES = {"Removed content": "removed from the game", "Historical article": "removed from the game",
                      "Sinkholes": "only in the Sinkholes"}

# Pages that never become cards, by title without its bracket, and why.
SKIPPED_PAGES = {"Mystery figure": "the disguised champions: Leon d'Cour and Glophren have their own pages"}


def secondary_places(page, fields):
    """The SECONDARY_PLACES an NPC is in: filed under, named as a location, or (Rush of Blood) one
    of the monsters of its waves."""
    locations = links(" ".join(numbered_fields(fields, "location")))
    found = {place for place in SECONDARY_PLACES if place in page.get("categories", []) or place in locations}
    if page["title"] in RUSH_OF_BLOOD:
        found.add("Rush of Blood")
    return found


def configs_named(name, names):
    """The NPC configs with a name (without its bracket) as a whole word, ending with it first:
    "Eek" is HW09_EEK, then POH_HW09_EEK_THE_SPIDER."""
    word = slug(strip_bracket(name)).upper()
    found = [n for n in names.values() if f"_{word}_" in f"_{n}_"]
    return sorted(found, key=lambda n: not (n == word or n.endswith("_" + word)))


def only_in_cutscenes(page, fields):
    """True if the NPC is only seen in cutscenes (the guards Billy and Bob, in Falador's cutscene):
    the wiki files it under cutscene characters, and every location it gives says "(cutscene)".
    One filed there that can also be met in the world (a location without it) is kept."""
    if "Cutscene characters" not in page.get("categories", []):
        return False
    locations = [v for v in numbered_fields(fields, "location") if v.strip()]
    return all("cutscene" in v.lower() for v in locations)


def candidate(page, names, words, price=None, drop=None):
    """A card candidate from a page (an NPC or an item), or (None, reason) if it isn't one.
    `price` is the item's Grand Exchange price, if it was fetched."""
    for category in page.get("categories", []):
        if category in SKIPPED_CATEGORIES:
            return None, SKIPPED_CATEGORIES[category]
    skipped = SKIPPED_PAGES.get(strip_bracket(page.get("title", "")))
    if skipped:
        return None, skipped
    text = page.get("text", "")
    # An NPC's infobox; a pet with only a pet infobox (the terrier, the Golden gnome) has that one;
    # an object pet whose page only has an item infobox (Eek) is the NPC named like it, with that
    # one (one with none, a pet rock, has no card).
    kind, fields = npc_infobox(page)
    pet_kind, pet = find_template(text, ["Infobox Pet"])
    _, inside = find_template(text, ["Infobox Item"])
    if fields is None and pet is not None:
        kind, fields = pet_kind, template_fields(pet)
    if fields is None and "Object pets" in page.get("categories", []):
        ids = [i for config in configs_named(page["title"], names) for i, n in names.items() if n == config]
        if not ids or inside is None:
            return None, "an object pet with no NPC model"
        kind, fields = "Infobox Pet", dict(template_fields(inside), id=", ".join(str(i) for i in ids))
    if fields is not None:
        if PET_CATEGORIES & set(page.get("categories", [])):
            fields = grown_up(page, fields)
        # (a pet's NPC infobox can be empty, with the ids in its pet infobox: Baby Troll)
        if pet is not None and not all_ids(fields):
            fields["id"] = template_fields(pet).get("npcid", "")
        if only_in_cutscenes(page, fields):
            return None, "only seen in cutscenes"
        return npc_candidate(page, kind, fields, names, words)
    if inside is not None:
        _, bonuses = find_template(text, ["Infobox Bonuses"])
        return item_candidate(page, template_fields(inside), template_fields(bonuses or ""), words, price, drop)
    return None, "no NPC or item infobox"


def grown_up(page, fields):
    """A pet's infobox with its first adult version first (the card shows the grown pet, with its
    examine text): a version named "Adult..." ("Baby, Adolescent, Adult"; "Puppy (black), Adult
    (black)"; "Kitten, Adult, Overgrown"). A pet without one is left as it is. A legendary pet
    keeps the pet's own name from its pet infobox ("Blazehound", not "Blazehound adult")."""
    versions = {int(k[len("version"):]): plain(v) for k, v in fields.items() if re.fullmatch(r"version\d+", k)}
    adult = min((n for n, name in versions.items() if name.lower().startswith("adult")), default=None)
    if adult is None or adult == 1:
        return fields
    swapped = {}
    for key, value in fields.items():
        found = re.fullmatch(r"(.+?)(\d+)", key)
        if found and int(found.group(2)) in (1, adult):
            key = found.group(1) + str(adult if int(found.group(2)) == 1 else 1)
        swapped[key] = value
    _, details = find_template(page.get("text", ""), ["Infobox Pet details"])
    pet_name = plain(template_fields(details or "").get("name", "")).strip()
    if pet_name and "Legendary pets" in page.get("categories", []):
        swapped = {k: v for k, v in swapped.items() if not re.fullmatch(r"name\d*", k)}
        swapped["name"] = pet_name
    return swapped


def membership_tag(fields, notes):
    """The membership tag word for an infobox's `members` field: ["p2p"] for Yes, ["f2p"] for No,
    and [] (with a note) when the wiki does not say. The wiki lists several versions of some pages
    with different answers; the first version's is used."""
    # (not first_version: that skips "No", which is an answer here)
    value = next((plain(fields[k]).lower() for k in ("members1", "members") if plain(fields.get(k, ""))), "")
    if value.startswith("yes"):
        return ["p2p"]
    if value.startswith("no"):
        return ["f2p"]
    notes.append("members only or free to play is not on the page: choose F2P or P2P")
    return []


def title_bracket(title):
    """The text in brackets at the end of a title or name ("Cook (Lumbridge)" -> Lumbridge), or None."""
    bracket = re.search(r"\(([^)]+)\)$", title)
    return bracket.group(1) if bracket else None


def strip_bracket(name):
    """A title or name without its bracket ("Guard (Catherby)" -> Guard)."""
    return re.sub(r"\s*\(.*\)$", "", name)


def place_in_brackets(page, fields):
    """The place in a page title's brackets ("Cook (Lumbridge)" -> Lumbridge), if the page is
    filed under it and its locations name it (the infobox's, or a monster's spawn table: |loc=);
    None for other brackets, which only say which version it is ("(attackable)") or what it is
    part of ("(Treasure Trails)", a quest)."""
    bracket = title_bracket(page["title"])
    if bracket is None:
        return None
    spawn_rows = re.findall(r"\|\s*loc\s*=\s*([^\n|]*)", page.get("text", ""))
    locations = " ".join(numbered_fields(fields, "location") + spawn_rows)
    # (a place with no category of its own, an inn, counts when the location links to it by name:
    # "Bartender (Dancing Donkey Inn)" at [[Dancing Donkey Inn]]; so does the NPC's shop:
    # "Shopkeeper (Varrock Sword Shop)" runs [[Varrock Sword Shop]])
    shops = " ".join(numbered_fields(fields, "shop"))
    if bracket.lower() in (place.lower() for place in links(locations) + links(shops)):
        return bracket
    if bracket not in page.get("categories", []):
        return None
    return bracket if bracket.lower() in locations.lower() else None


def name_and_desc(page, fields, notes, versions_merge=False):
    """The card name and description (the examine text), with a note if the description needs
    work. The name is the page title when it has brackets, as the wiki uses those to tell NPCs of
    the same name apart ("Cook (Lumbridge)", "Cook (Blue Moon Inn)"), and the deck names cards
    the same way; otherwise the infobox's name, or the title. With versions_merge (NPCs, whose
    version pages become one card: see merge_versions), only a place is kept in brackets."""
    infobox_name = plain(first_version(fields, "name"))
    if title_bracket(page["title"]) and (not versions_merge or place_in_brackets(page, fields)):
        name = page["title"]
    else:
        name = infobox_name or strip_bracket(page["title"])
    desc = plain(first_version(fields, "examine"))
    if not desc:
        notes.append("no examine text: write a description")
    elif len(desc) > MAX_DESC:
        notes.append(f"description is {len(desc)} letters; cards show about {MAX_DESC}")
    return name, desc


# ---------------------------------------------------------------------------------------------
# Item rarity (CONTRIBUTING, "Guidelines for items"). Each signal gives a rarity and the highest wins.
# The thresholds are all here so they are easy to tune.
# ---------------------------------------------------------------------------------------------

RARITIES = ["common", "uncommon", "rare", "epic", "legendary"]
LEVEL_BANDS = [(90, "legendary"), (70, "epic"), (50, "rare"), (25, "uncommon")]    # level needed
PRICE_BANDS = [(100_000_000, "legendary"), (10_000_000, "epic"), (1_000_000, "rare"), (50_000, "uncommon")]
DROP_BANDS = [(2500, "legendary"), (1000, "epic"), (100, "rare"), (25, "uncommon")]  # 1 in N or rarer
PET_CATEGORY = re.compile(r"\bpets?$")
DISCONTINUED_CATEGORY = re.compile(r"discontinued|unobtainable")


def band(value, bands):
    """The rarity for a value: that of the first (highest) threshold it reaches, else common."""
    for threshold, rarity in bands:
        if value >= threshold:
            return rarity
    return "common"


def item_rarity(level=None, price=None, drop=None, discontinued=False, pet=False):
    """The suggested rarity of an item and why, as (rarity, reasons). `level` is the level needed
    (skill, or combat for gear), `price` the Grand Exchange price, `drop` N for its rarest drop
    rate of 1 in N; any can be None when not known. Pets and discontinued items are legendary.
    Otherwise the highest rarity any known signal gives wins."""
    given = []
    if pet:
        given.append(("legendary", "a pet"))
    if discontinued:
        given.append(("legendary", "discontinued or unobtainable"))
    if level is not None:
        given.append((band(level, LEVEL_BANDS), f"level {level}"))
    if price is not None:
        given.append((band(price, PRICE_BANDS), f"GE price {price:,}"))
    if drop is not None:
        given.append((band(drop, DROP_BANDS), f"drop rate 1/{drop:,}"))
    if not given:
        return "common", ["no signal"]
    best = max(RARITIES.index(r) for r, _ in given)
    return RARITIES[best], [f"{why} ({rarity})" for rarity, why in given]


# The patch an Infobox Seed names -> the seed word for it (anything else is "special").
SEED_PATCH_WORDS = {
    "allotment": "allotment", "flower": "flower", "herb": "herb_patch", "hop": "hop", "hops": "hop",
    "bush": "bush", "tree": "tree", "fruit tree": "fruit_tree", "cactus": "cacti", "cacti": "cacti",
    "mushroom": "mushroom", "special": "special", "vine flower": "vine_flower", "vine herb": "vine_herb",
    "vine bush": "vine_bush", "fertile soil": "fertile_soil", "farming patch": "dungeoneering_patch",
    "dungeoneering": "dungeoneering_patch", "farming patch (dungeoneering)": "dungeoneering_patch",
    "berry planter": "berry_planter", "arc": "berry_planter",
}


def seed_patch(text, allowed):
    """The seed word for the patch in the page's Infobox Seed ("herb" -> herb_patch), "special" if
    it is none of the known patches, or None if the page has no Infobox Seed."""
    _, inside = find_template(text or "", ["Infobox Seed"])
    if not inside:
        return None
    patch = re.sub(r"\s+", " ", plain(template_fields(inside).get("patch", "")).lower().replace("_", " ")).strip()
    word = SEED_PATCH_WORDS.get(patch, "special")
    return word if word in allowed else None


def seed_requirements(text, skill_words):
    """What planting a seed takes, from the Infobox Seed on its page: (skills, level). The skill is
    the one in brackets after what it grows ("Arbuck (Farming)"), Farming if there is none."""
    _, inside = find_template(text or "", ["Infobox Seed"])
    if not inside:
        return [], None
    fields = template_fields(inside)
    found = re.search(r"\d+", plain(fields.get("level", "")))
    skill = re.search(r"\(([A-Za-z]+)\)", plain(fields.get("grown", "")))
    word = (skill.group(1) if skill else "farming").lower()
    return ([word] if word in skill_words else []), (int(found.group()) if found else None)


def recipe_requirements(text, titles, skill_words):
    """What making an item takes, from the Infobox Recipe templates on its page: (skills, level).
    Only recipes with the item among their outputs count (not the ones that use it). `skills` are
    the allowed skill words of those recipes, in order; `level` is the level of the easiest recipe
    (the highest skill level it asks for), or None if the page has none."""
    wanted = {t.lower() for t in titles if t}
    skills, levels = [], []
    for inside in find_templates(text or "", ["Infobox Recipe"]):
        fields = template_fields(inside)
        # (also without a bracket: a recipe making "Prayer potion (3)" is for the "Prayer potion" page)
        made = [plain(v) for k, v in fields.items() if re.fullmatch(r"output\d*", k)]
        outputs = {m.lower() for m in made} | {strip_bracket(m).lower() for m in made}
        if not outputs & wanted:
            continue
        needed = []
        for key, value in fields.items():
            number = re.fullmatch(r"skill(\d+)", key)
            word = plain(value).lower()
            if number and word in skill_words:
                if word not in skills:
                    skills.append(word)
                level = re.search(r"\d+", plain(fields.get("skill" + number.group(1) + "lvl", "")))
                if level:
                    needed.append(int(level.group()))
        if needed:
            levels.append(max(needed))
    return skills, (min(levels) if levels else None)


DROPS = CACHE / "drops.json"


def drop_n(value):
    """The N of a drop rate "1 in N" from a DropsLine `rarity` ("1/384", "8/128", "44.5/128",
    "5%"), or None for "Always", "Unknown" and anything else that is not a number."""
    value = plain(value).replace(",", "").lstrip("~≈ ")
    found = re.fullmatch(r"([\d.]+)\s*/\s*([\d.]+)", value)
    try:
        if found:
            n = float(found.group(2)) / float(found.group(1))
        else:
            found = re.fullmatch(r"([\d.]+)\s*%", value)
            n = 100 / float(found.group(1)) if found else None
    except (ValueError, ZeroDivisionError):
        return None
    return n if n else None


def drop_rates(text):
    """{ item name (lower case): N } from the DropsLine templates of a page, N the rarest (largest)
    of its rates there. Quantities, notes and the lines with no rate are ignored."""
    rates = {}
    for match in re.finditer(r"\{\{\s*DropsLine\s*\|", text or ""):
        _, inside = find_template(text[match.start():], ["DropsLine"])
        fields = template_fields(inside or "")
        name, n = plain(fields.get("name", "")).lower(), drop_n(fields.get("rarity", ""))
        if name and n:
            rates[name] = max(rates.get(name, 0), n)
    return rates


def remember_drops(pages):
    """Adds the drop rates of these pages to dev/wiki_cache/drops.json (keeping the rarest rate of
    each item over everything read) and returns all of it, { name: N }."""
    known = json.loads(DROPS.read_text(encoding="utf-8")) if DROPS.exists() else {}
    for page in pages.values():
        for name, n in drop_rates(page.get("text", "")).items():
            known[name] = max(known.get(name, 0), round(n, 1))
    DROPS.parent.mkdir(parents=True, exist_ok=True)
    DROPS.write_text(json.dumps(known, indent=1, sort_keys=True), encoding="utf-8")
    return known


def linked_pages(text, until=None):
    """The titles of the pages a list page names, in order and without repeats. With `until`, only
    the text before the heading of that name counts (ValueError if there is no such heading).
    On a page of tables (like Bosses), a row's name is its second cell, after the picture, so the
    pages linked from descriptions, drops and the like are not taken. Without tables, every
    link counts. Links to files, categories and other namespaces are left out."""
    if until:
        heading = re.search(r"^(=+)[ \t]*" + re.escape(until) + r"[ \t]*\1[ \t]*$", text, re.M | re.I)
        if heading is None:
            raise ValueError(f'no "{until}" heading found')
        text = text[:heading.start()]
    targets = []
    if re.search(r"^\{\|", text, re.M):
        for row in re.split(r"^\|-.*$", text, flags=re.M)[1:]:
            cells = [line[1:].strip() for line in row.splitlines() if re.match(r"\|(?![-}+])", line)]
            link = re.fullmatch(r"\[\[([^\[\]|]+)(?:\|[^\[\]]*)?\]\]", cells[1]) if len(cells) > 1 else None
            if link:
                targets.append(link.group(1))
    else:
        targets = re.findall(r"\[\[([^\[\]|]+)", text)
    titles = []
    for target in targets:
        title = target.split("#")[0].replace("_", " ").strip()
        if title and ":" not in title and title not in titles:
            titles.append(title)
    return titles


GEP_BATCH = 25       # prices asked for in one request
GEP_MARK = "@@"      # put round each answer so they can be told apart


def price_name(fields, title):
    """The name to ask the Grand Exchange price of: the infobox's default version, else its first
    name, else the page title. None if the name can't go in a template call."""
    default = plain(fields.get("defver", ""))
    name = (plain(fields.get("name" + default, "")) if default else "") or plain(first_version(fields, "name")) or title
    return None if re.search(r"[|={}]", name) else name


def read_price(text):
    """A price from the wiki's {{GEP|item}} answer ("390", "1,234"), or None if it is not a plain
    number (an item that is not on the Grand Exchange gives words or nothing)."""
    text = (text or "").strip()
    return int(text.replace(",", "")) if re.fullmatch(r"\d[\d,]*", text) else None


def fetch_prices(wiki, names, refresh):
    """The Grand Exchange price of each item name, as { name: price or None }, by asking the wiki
    to expand {{GEP|name}}. Answers are kept in dev/wiki_cache; names not asked yet when the
    run's request limit is used up are left out."""
    prices, wanted = {}, []
    for name in dict.fromkeys(names):
        cached = None if refresh else read_cache("prices", name)
        if cached is not None:
            prices[name] = cached["price"]
        else:
            wanted.append(name)
    for start in range(0, len(wanted), GEP_BATCH):
        batch = wanted[start:start + GEP_BATCH]
        text = "".join(f"{GEP_MARK}{{{{GEP|{n}}}}}{GEP_MARK}" for n in batch)
        answer = wiki.get({"action": "expandtemplates", "prop": "wikitext", "text": text})
        if answer is None:
            print(f"  request limit reached; {len(wanted) - start} prices left for next time")
            break
        found = re.findall(re.escape(GEP_MARK) + "(.*?)" + re.escape(GEP_MARK),
                           answer.get("expandtemplates", {}).get("wikitext", ""), re.S)
        if len(found) != len(batch):
            print(f"  asked for {len(batch)} prices and got {len(found)} answers; skipping this batch")
            continue
        for name, value in zip(batch, found):
            prices[name] = read_price(value)
            write_cache("prices", name, {"price": prices[name], "fetched": time.strftime("%Y-%m-%d")})
    return prices


# The combat style of gear, from the "class" of its Infobox Bonuses.
COMBAT_STYLE_WORDS = {"melee": "melee_gear", "ranged": "ranged_gear", "magic": "magic_gear",
                      "necromancy": "necromancy_gear", "hybrid": "hybrid_gear"}


def gear_requirements(bonuses, skill_words):
    """What wearing an item takes, from its Infobox Bonuses `requirements` ({{sc|attack|70}}):
    (skills, level). The level is the highest one asked for, None if there is none."""
    skills, levels = [], []
    for skill, level in re.findall(r"\{\{\s*sc\s*\|\s*([A-Za-z]+)\s*\|\s*(\d+)", bonuses.get("requirements", "")):
        if skill.lower() in skill_words:
            if skill.lower() not in skills:
                skills.append(skill.lower())
            levels.append(int(level))
    return skills, (max(levels) if levels else None)


def item_candidate(page, fields, bonuses, words, price=None, drop=None):
    """A candidate from an item page. The ids go to the plugin, which knows the items' config
    names. Tags: the item category words from its equipment slot and its wiki categories, and the
    skills whose categories it is in."""
    notes = []
    ids = all_ids(fields)
    if not ids:
        return None, "no item id on the page"
    if len(ids) > 1:
        notes.append(f"{len(ids)} item ids listed; using the first")
    name, desc = name_and_desc(page, fields, notes)

    found = list(SLOT_WORDS.get(plain(bonuses.get("slot", "")).lower(), []))
    style = plain(bonuses.get("style", "")).lower()
    if "ammunition" in found:
        found += ["arrow"] if "arrow" in style else ["bolt"] if "bolt" in style else []
    combat = COMBAT_STYLE_WORDS.get(re.split(r"\W+", plain(bonuses.get("class", "")).lower())[0])
    if combat and combat in words["item_category"]:
        found.append(combat)
    if plain(fields.get("edible", "")).lower().startswith("yes"):
        found.append("food")
    patch = seed_patch(page.get("text", ""), set(words["item_category"]))
    if patch:
        found += ["seed", patch]
    cosmetic = [c for c in page.get("categories", []) if COSMETIC_CATEGORY.search(c.lower())]
    if cosmetic:
        found = ["fashion"]
        notes.append(f"looks like a cosmetic ({cosmetic[0]}): tagged fashion only")
    else:
        # (the kind of item the page's Disassembly box says it is, "Potions" or "food", counts like a category)
        _, disassembly = find_template(page.get("text", ""), ["Disassembly"])
        kinds = [plain(template_fields(disassembly or "").get("category", ""))]
        for category in page.get("categories", []) + [k for k in kinds if k]:
            name_part = category.lower().removeprefix("disassemble category/")
            for key, keyed in ITEM_CATEGORY_WORDS.items():
                if re.search(r"\b" + re.escape(key) + r"\b", name_part):
                    found += keyed
    category = []
    for word in found:
        parents = words["item_requires"].get(word, [])
        # (a word that needs one of several gets one already found, else the first)
        if parents and not any(p in category or p in found for p in parents):
            parents = parents[:1]
        else:
            parents = []
        for needed in parents + [word]:
            if needed in words["item_category"] and needed not in category:
                category.append(needed)
    tags = {"category": category} if category else {}
    if not category:
        notes.append("no category found: choose what kind of item it is")

    # Skills: from the recipes that make the item (the most reliable), then from its categories.
    # (an item with versions, like a potion's doses, has a name for each: name1, name2...)
    item_names = [plain(v) for k, v in fields.items() if re.fullmatch(r"name\d*", k)]
    made_with, level = recipe_requirements(page.get("text", ""), [page["title"], name, strip_bracket(name)] + item_names,
                                           set(words["skills"]))
    worn_with, worn_level = gear_requirements(bonuses, set(words["skills"]))
    grown_with, grown_level = seed_requirements(page.get("text", ""), set(words["skills"]))
    if grown_with and not made_with:
        made_with, level = grown_with, grown_level
    skills = list(made_with) + [w for w in worn_with if w not in made_with]
    for s in words["skills"]:
        if s not in skills and any(c.lower() in (s, s + " items") for c in page.get("categories", [])):
            skills.append(s)
    if grown_with and made_with == grown_with:
        notes.append("planted with " + ", ".join(made_with) + (f" (level {level})" if level else ""))
    elif made_with:
        notes.append("made with " + ", ".join(made_with) + (f" (level {level})" if level else ""))
    elif not worn_with:
        notes.append("no recipe or wear requirement found on the page: check which skills it needs")
    if worn_with:
        notes.append("needs " + ", ".join(f"{w}" for w in worn_with) + f" level {worn_level} to wear")
    levels = [x for x in (level, worn_level) if x is not None]
    level = max(levels) if levels else None
    if skills:
        tags["skills"] = skills
    if "berry_planter" in category and "the_arc" in words["regions"]:
        tags["regions"] = ["the_arc"]       # (berry planters are on the Arc)
    membership = membership_tag(fields, notes)
    if membership:
        tags["membership"] = membership

    categories = [c.lower() for c in page.get("categories", [])]
    rarity, why = item_rarity(
        level=level, price=price, drop=round(drop) if drop else None,
        pet=any(PET_CATEGORY.search(c) for c in categories),
        discontinued=any(DISCONTINUED_CATEGORY.search(c) for c in categories))
    notes.append("rarity is a guess: " + ", ".join(why))
    if price is None:
        notes.append("no Grand Exchange price found (not tradeable?)")
    if rarity != "legendary":
        missing = [x for x, known in (("the drop rate", drop), ("the level needed", level)) if not known]
        if missing:
            notes.append("check " + " and ".join(missing) + ": the rarity is the highest of them")

    return {"page": page["title"], "kind": "item", "ids": ids[:6], "name": name, "desc": desc,
            "rarity": rarity, "tags": tags, "notes": notes}, None


# Config names of an NPC's special copies (events, quests, tutorials, cutscenes, internal ones
# starting with "_"): an NPC's models are listed with these last, so its everyday look is first.
SPECIAL_MODEL = re.compile(r"^_|XMAS|EASTER|HALLOWEEN|^HW\d|ANNIVERSARY|TUTORIAL|CUTSCENE|^QUEST_|HEIST|MTX|TRANSMOG")


def everyday_first(models):
    """The models in order with the special copies (SPECIAL_MODEL) moved to the end."""
    return sorted(models, key=lambda m: bool(SPECIAL_MODEL.search(m)))


# NPCs the wiki names differently that the deck has as one card: name -> the card's name.
SAME_CARD = {
    "Lumbridge guardsman": "Lumbridge guard",      # both are members of the Lumbridge Guard
}


PLACE_REGIONS = {}          # place (a link target, lower case) -> its region, see place_regions


def place_regions(pages):
    """{ place: region } from NPC pages whose versions each give one region: a place (a link in a
    version's location) is in the region most of the NPCs found there give, if they agree (at least
    three in four). For the NPCs the wiki gives no region."""
    votes = defaultdict(Counter)
    for page in pages:
        _, fields = npc_infobox(page)
        if fields is None:
            continue
        numbers = sorted({int(k[len("location"):]) for k in fields if re.fullmatch(r"location\d+", k)}) or [0]
        for n in numbers:
            suffix = str(n) if n else ""
            regions = league_regions(plain(fields.get("leagueregion" + suffix) or fields.get("leagueregion", "")))
            if len(regions) != 1 or regions == ["global"]:
                continue
            region = REGION_ALIASES.get(regions[0], regions[0])
            for place in links(fields.get("location" + suffix, "")):
                votes[place.lower()][region] += 1
    found = {}
    for place, counts in votes.items():
        region, top = counts.most_common(1)[0]
        if top * 4 >= sum(counts.values()) * 3:
            found[place] = region
    return found


def places_without_region(pages):
    """The places (link targets) of the NPC pages that give no league region, whose region isn't
    known yet (PLACE_REGIONS): their own pages are read for it."""
    wanted = []
    for page in pages:
        _, fields = npc_infobox(page)
        if fields is None:
            continue
        if any(plain(v).strip() for v in numbered_fields(fields, "leagueregion")):
            continue
        for place in links(" ".join(numbered_fields(fields, "location"))):
            if place.lower() not in PLACE_REGIONS and place not in wanted:
                wanted.append(place)
    return wanted


def region_tag(regions, words):
    """An NPC's regions tag and a note about it, from its league regions: one region, or two (like
    an item from two regions: the card goes in the first's deck file and is tagged with the second
    too, so both regional packs give it); Global or three or more is a general card (no tag)."""
    if 1 <= len(regions) <= MAX_NPC_REGIONS and all(r in words["regions"] for r in regions):
        return regions, (None if len(regions) == 1
                         else f"in 2 league regions: goes in the {regions[0]} deck file, tagged {regions[1]} too")
    if regions == ["global"]:
        return None, "league region Global: a general card"
    if len(regions) > 1:
        return None, f"in {len(regions)} league regions: a general card"
    return None, "region unknown: choose the deck file"


def merge_versions(found, words):
    """One NPC candidate per card. The wiki often has a page for each version of an NPC ("Lumbridge
    guard (attackable)", "Lumbridge guardsman (bridge)"): candidates with the same card name (see
    name_and_desc and SAME_CARD) become one, with every page's models to choose from (in order,
    without repeats, everyday looks first: see everyday_first). Its other details come from the
    page named like the card if there is one, otherwise the first; a note lists the pages. Its
    regions are every page's together (see region_tag)."""
    merged, order = {}, []
    for c in found:
        if c["kind"] != "npc":
            order.append(c)
            continue
        group = merged.get(c["name"])
        if group is None:
            merged[c["name"]] = [c]
            order.append(c["name"])
        else:
            group.append(c)
    out = []
    for entry in order:
        if isinstance(entry, dict):
            out.append(entry)
            continue
        group = sorted(merged[entry], key=lambda c: (c["page"] != entry, c["page"]))
        first = dict(group[0])
        models = everyday_first(list(dict.fromkeys(m for c in group for m in [c["npc"]] + c["others"])))
        first["npc"], first["others"] = models[0], models[1:8]
        first["sources"] = sorted({s for c in group for s in c["sources"]})
        places = list(dict.fromkeys(p for c in group for p in c["tags"].get("location", [])))
        if places:
            first["tags"] = dict(first["tags"], location=places)
        # The regions of every page (the seagull is Asgarnia and Morytania on one page, and the
        # Wilderness, Desert and Havenhythe on its decorative one: a general card). A page found
        # all over the world doesn't make the others' regions general.
        regions = list(dict.fromkeys(r for c in group for r in c["league_regions"]))
        if len(group) > 1 and "global" in regions and len(regions) > 1:
            regions.remove("global")
        tag, note = region_tag(regions, words)
        if tag:
            first["tags"] = {"regions": tag, **first["tags"]}
        if note:
            first["notes"] = first["notes"] + [note]
        if len(group) > 1:
            first["notes"] = [f"{len(group)} wiki pages: " + ", ".join(c["page"] for c in group)] + first["notes"]
        if len(models) > 1:
            first["notes"] = [f"{len(models)} models (Next model); first is {models[0]}"] + first["notes"]
        out.append(first)
    for c in out:
        c.pop("league_regions", None)       # (only for the merge)
    return out


# The races of animals: an animal with a name and a gender on the wiki is still not a character.
ANIMAL_RACES = {"sheep", "cow", "chicken", "dog", "cat", "rat", "bird", "bear", "wolf", "goat", "horse", "frog", "spider"}

# Words for a job rather than a person: an NPC whose name ends in one is a role ("Cooking Tutor").
ROLE_WORDS = {"tutor", "instructor", "guard", "guardsman", "guardswoman", "priest", "priestess", "herbalist",
              "shopkeeper", "assistant", "banker", "merchant", "musician", "citizen", "villager", "monk", "nun",
              "sailor", "worker", "cleaner", "trader", "soldier", "knight", "cook", "chef"}
# (Not "man" or "woman": the plain Man and Woman aren't filed as characters anyway, and the Wise
# Old Man is one.)
NAME_LINKS = {"the", "of", "de", "von", "van", "du", "la", "le"}     # small words in real names


def is_role(name):
    """True if a name is a role, not a person's: the wiki ends those in a word in lower case
    ("Lumbridge guardsman") or a job ("Cooking Tutor"). A name ending in a capitalised name is a
    person, whatever comes before ("H.A.M. agent William", Explorer Jack, Fred the Farmer). A
    part in brackets ("Guard (Catherby)") is left out: it only says which one."""
    words = strip_bracket(name).replace("'s", "").split()
    if not words:
        return False
    last = words[-1]
    if last[0].isalpha() and last[0].islower():
        return True
    return last.lower() in ROLE_WORDS and not any(w in NAME_LINKS for w in words)


def gender_of(page):
    """ "male" or "female" if the wiki files the NPC as a male or female character, else None."""
    categories = page.get("categories", [])
    return "female" if "Female characters" in categories else "male" if "Male characters" in categories else None


def is_character(page, race):
    """True if the wiki files the NPC as a character (male or female characters), not an animal."""
    return gender_of(page) is not None and race not in ANIMAL_RACES


# Summoning familiars: rated by their Summoning level plus a bonus for the charm their pouch takes
# (or a binding contract, a Slayer reward), from common to at most epic. A few are set by hand
# (NPC_RARITY).
FAMILIAR_CHARM_BONUS = {"gold": 0, "green": 5, "crimson": 10, "elder": 12, "blue": 15}
BINDING_CONTRACT_BONUS = 15
SKILL_BANDS = [(90, "epic"), (65, "rare"), (35, "uncommon")]     # (and other NPCs rated by a skill level)


def number(value):
    """The first number in a value ("level 45" -> 45), or 0 if it has none."""
    found = re.search(r"\d+", value or "")
    return int(found.group()) if found else 0


def familiar_rarity(page):
    """A Summoning familiar's rarity and why, or None if the page is not a familiar's. The charm is
    the one in its "Familiars that require ... charm" category."""
    _, inside = find_template(page.get("text", ""), ["Infobox Summoning familiar"])
    if inside is None:
        return None
    fields = template_fields(inside)
    level = number(plain(first_version(fields, "level")))
    charm = next((m.group(1).lower() for c in page.get("categories", [])
                  if (m := re.fullmatch(r"Familiars that require (\w+) charms?", c))), None)
    if charm in FAMILIAR_CHARM_BONUS:
        bonus, how = FAMILIAR_CHARM_BONUS[charm], f"{charm} charm"
    elif "binding contract" in plain(first_version(fields, "pouch")).lower():
        bonus, how = BINDING_CONTRACT_BONUS, "binding contract"
    else:
        bonus, how = 0, "no charm"
    return band(level + bonus, SKILL_BANDS), f"a familiar of level {level} with a {how} (+{bonus})"


def automaton_rarity(page):
    """A Guthixian Cache automaton's rarity and why, or None if the page is not one's: rated by the
    Divination level needed to subdue it, on the familiars' bands (none needed is common)."""
    if "Automaton" not in page.get("categories", []):
        return None
    found = re.search(r"\[\[Divination\]\] level of (\d+) to subdue", page.get("text", ""))
    level = number(found and found.group(1))
    return band(level, SKILL_BANDS), (f"an automaton subdued at Divination level {level}" if level
                                         else "an automaton anyone can subdue")


def skill_level_rarity(page):
    """The rarity of a Hunter creature or an NPC to pickpocket, by the level it needs (its "Hunter
    info" or "Thieving info"), on the familiars' bands, and why; or None if it has neither."""
    for template, skill, verb in (("Hunter info", "Hunter", "caught"), ("Thieving info", "Thieving", "pickpocketed")):
        _, inside = find_template(page.get("text", ""), [template])
        if inside is None:
            continue
        # (the level of its first version; a box with versions for several skills, the black
        # warlock's net and barehanded, gives it as skill1lvl1)
        fields = template_fields(inside)
        found = re.search(r"\d+", plain(first_version(fields, "level") or first_version(fields, "skill1lvl")))
        if found:
            level = int(found.group())
            return band(level, SKILL_BANDS), f"{verb} at {skill} level {level}"
    return None


# A quest's official difficulty, and the rarity of a pet that needs it.
QUEST_TIERS = {"Novice": "common", "Intermediate": "uncommon", "Experienced": "rare", "Master": "epic",
               "Grandmaster": "epic"}


def quest_tier(quest):
    """The rarity of a pet that needs this quest (by its difficulty), or None if it isn't one."""
    return QUEST_TIERS.get(QUEST_DIFFICULTY.get(quest))
QUEST_DIFFICULTY = {}       # quest -> its official difficulty, read in main (see quest_difficulties)
PET_CATEGORIES = {"Pets", "Boss pets", "Skilling pets", "Companion pets", "Follower pets", "Object pets",
                  "Legendary pets", "Discontinued pets"}


# Items a pet is unlocked with that are rare finds (its page names the item, not a drop).
PET_RARE_ITEMS = {"Corrupted egg", "Mossy rock", "Golden compass", "Parasitic orb", "Lucky dragonkin coin"}
# Words in a pet's source that mean an event or a promotion.
PET_EVENT_WORDS = ("event", "runefest", "advent", "christmas", "halloween", "easter", "novtumberfest",
                   "winter chill", "field of screams", "gielinorian giving", "expedition to the wilderness",
                   "marketplace", "premier", "hero pass", "bundle", "steam", "code", "mobile", "treasure hunter",
                   "membership", "prime gaming", "golden gnome awards")


def pet_rarity(page):
    """A pet's rarity and why, or None if the page is not a pet's. Skilling and boss pets are
    legendary, the wiki's "Legendary pets" epic. Others by what it takes to get one: a skill level
    (on the skill bands: a terrier needs 4 Summoning, common) or a quest (by its difficulty), the
    higher of the two; else rare if it comes from a token, uncommon if a shop sells it, and common
    (a cat). Its details are in its pet infobox (Infobox Pet, or Infobox Pet details)."""
    categories = page.get("categories", [])
    _, inside = find_template(page.get("text", ""), ["Infobox Pet", "Infobox Pet details"])
    if inside is None and not PET_CATEGORIES & set(categories):
        return None
    if "Boss pets" in categories or "Skilling pets" in categories:
        return "legendary", "a skilling or boss pet"
    if "Legendary pets" in categories:
        return "epic", "one of the wiki's legendary pets"
    fields = template_fields(inside or "")
    found = []
    # (the highest level it needs: a gecko, "10 Summoning, 27 Hunter", is 27)
    skills = plain(first_version(fields, "skillrequired"))
    level = max((int(n) for n in re.findall(r"\d+", skills)), default=0)
    if level:
        found.append((band(level, SKILL_BANDS), f"a pet needing level {level} ({skills})"))
    # (each quest it needs, the highest counting; not one marked for another form of it, the cat's
    # "Rat Catchers for wily")
    entries = [e for e in re.split(r"[*\n]", first_version(fields, "questrequired")) if e.strip()]
    for entry in entries:
        if re.search(r"\]\]\s+for\b", entry):
            continue
        for quest in links(entry) or [plain(q).strip() for q in entry.split(",")]:
            if quest_tier(quest):
                found.append((quest_tier(quest), f"a pet needing {quest} ({QUEST_DIFFICULTY[quest]})"))
    if found:
        return max(found, key=lambda f: RARITIES.index(f[0]))
    location = plain(first_version(fields, "location")).strip()
    where = location.lower()
    if "token" in where:
        return "rare", "a pet from a token"
    if where in ("pet shop", "pet store"):
        return "common", "an everyday pet from the pet shop"
    if "Items sold by shops" in categories or "shop" in where or "store" in where:
        return "uncommon", "a pet sold in a shop"
    # Else by where it comes from: a drop or a rare item is epic, a quest by its difficulty, a league
    # rare, an event or a promotion uncommon, a gift from an NPC common (as is one with no source),
    # and any other place or activity rare.
    text = page.get("text", "")
    lead = text[text.find("'''"):][:500].lower()
    if re.search(r"\bdrop", lead) or location in PET_RARE_ITEMS:
        return "epic", f"a pet from a drop or a rare item ({location or 'a drop'})"
    if quest_tier(location):
        return quest_tier(location), f"a pet from {location} ({QUEST_DIFFICULTY[location]})"
    if "league" in where:
        return "rare", f"a pet from a league ({location})"
    if "Discontinued pets" in categories or any(w in where for w in PET_EVENT_WORDS):
        return "uncommon", f"a pet from an event or promotion ({location or 'discontinued'})"
    if "(npc)" in where:
        return "common", f"a pet given by an NPC ({location})"
    if location and where not in ("n/a", "none"):
        return "rare", f"a pet from {location}"
    return "common", "a pet"


def quest_difficulties(wiki, refresh):
    """{ quest: official difficulty } from the wiki's quest infoboxes (one request; cached)."""
    cached = None if refresh else read_cache("buckets", "quest difficulty")
    if cached is not None:
        return cached
    answer = wiki.get({"action": "bucket", "query":
                       "bucket('infobox_quest').select('page_name','official_difficulty').limit(5000).run()"})
    if answer is None:
        return {}
    found = {r["page_name"]: r["official_difficulty"] for r in answer.get("bucket", []) if r.get("official_difficulty")}
    write_cache("buckets", "quest difficulty", found)
    return found


# NPCs set by hand, where the rules can't see what makes them matter (by page title, or the title
# without its bracket, so "Sliske (Desperate Times)" is Sliske too).
NPC_RARITY = {
    "Sliske": ("legendary", "Sliske, for his weight in the story"),
    # (not filed as a boss, and his first version is Nomad's Requiem at 699; Memory of Nomad is 1001)
    "Nomad": ("legendary", "Nomad, whose Memory of Nomad fight is combat level 1001"),
    "Meerkats": ("rare", "a familiar only from Treasure Trails"),
    "Ghast (familiar)": ("epic", "the Ghast familiar"),
    # Sellers of the capes above a skillcape (a skillcape's seller, a skill master, is rare): none
    # is filed as a skill master. (The 120 master skillcapes are sold by the skill masters; the
    # completionist cape by a museum guard, who only guards it.)
    "Max": ("epic", "sells the max cape"),
    "Elen Anterth": ("epic", "sells the max cape, in the Max Guild"),
    "Curator Haig Halen": ("epic", "sells the master quest cape"),
    "Minerva": ("epic", "sells the master max cape"),
    "Golden Gnome": ("legendary", "the Golden Gnome, awarded at RuneFest"),
}
# The gods (the wiki's Category:Gods, October 2026), for a god whose NPC page is a bracketed one
# that is not filed there itself ("Azzanadra (Children of Mah)"). Not Gielinor or the Kendal, whose
# names are also a place and a quest's monster ("The Kendal (monster)").
GODS = {
    "Amascut", "Apmeken", "Armadyl", "Azzanadra", "Bandos", "Bik", "Birman", "Brassica Prime", "Crondis", "Ebeb",
    "Elidinis", "The Fates", "Ful", "Gara-Dul", "Guthix", "Hanalan", "Het", "Icthlarin", "Jas",
    "Jododu Otoku", "Kharazi", "Lord Vitur", "Mah", "Marimbo", "Ninbaradari", "Nyarlahydra",
    "Queen of Ashes", "Raharni", "Saradomin", "Scabaras", "Seren", "Shaika", "Skargaroth", "Tezcasathla",
    "Tumeken", "Tuska", "TzKal-Zuk", "Uvhastur", "V", "Wen", "Xau-Tak", "Yogsathla", "Zamorak", "Zaros",
}
# A boss from this combat level is legendary (the end-game ones: Nex, Telos, the Rise of the Six);
# below it, epic (the God Wars generals, the Barrows, the Giant mole) down to RARE_BOSS_LEVEL.
LEGENDARY_BOSS_LEVEL = 1000
# A boss below this combat level is rare: most quest and minigame bosses (Delrith, the Penance
# fighters, Barrelchest), but not the Barrows or the Daemonheim floor bosses.
RARE_BOSS_LEVEL = 100


def boss_named(categories):
    """True if the wiki files the page as a boss ("Bosses", "Free-to-play bosses"); not "Boss
    minions", the monsters fought alongside a boss, rated like any other."""
    return any("boss" in c.lower() and "minion" not in c.lower() for c in categories)


def npc_rarity(page, fields, character, named):
    """A guess at an NPC's rarity, and why: the "Guidelines for NPCs" in CONTRIBUTING.md, which
    follow the deck's own cards (keep the two the same). `character` is whether the wiki files it
    as a character, `named` whether its name is a person's rather than a role's (see is_role).
    Spawns are the spawn points in the page's location table (monsters), or the pins on its maps
    (NPCs). A quest is one linked in the infobox, or a "Characters in <quest>" category."""
    categories = page.get("categories", [])
    text = page.get("text", "")

    level = number(first_version(fields, "level") or first_version(fields, "combat"))
    slayer = number(fields.get("slaylvl"))
    # (linked, or written out: "A Clockwork Syringe, Pieces of Hate"; "No" and "None" are none)
    quest_text = " ".join(numbered_fields(fields, "quest"))
    quests = set(links(quest_text)) or {q.strip() for q in plain(quest_text).split(",")
                                         if q.strip() and q.strip().lower() not in ("no", "none", "n/a")}
    quests |= {c[len("Characters in "):] for c in categories if c.startswith("Characters in ")}
    # Each location row (LocLine) and each map lists its spawn points as x:..,y:.. (or x=..).
    location_rows = " ".join(re.findall(r"\{\{\s*LocLine.*?\}\}", text, re.S))
    maps = " ".join(numbered_fields(fields, "map"))
    spawns = len(re.findall(r"\bx\s*[:=]\s*\d+", location_rows or maps))
    royalty = any(c in ("Monarchs", "Royalty") for c in categories)
    skill_master = "Skill masters" in categories
    slayer_master = "Slayer Master" in categories
    # The great races of the story, epic like a boss: the Mahjarrat, and the dragonkin who have a
    # name or are fought as bosses (Kerapac, Strisath; not their Nodon soldiers, dragonkin too).
    race = slug(plain(first_version(fields, "race")))
    lore_race = ("a Mahjarrat" if "Mahjarrat" in categories
                 else "a dragonkin" if race == "dragonkin" and (named or boss_named(categories)) else None)
    # (the Dominion Tower holds the quests' bosses, the Evil Chicken and Sigmund among them)
    quest_boss = "Dominion Tower" in categories
    boss = quest_boss or boss_named(categories)

    hand_set = NPC_RARITY.get(page["title"]) or NPC_RARITY.get(strip_bracket(page["title"]))
    if hand_set:
        return hand_set
    # Gods (the wiki's Category:Gods, which takes those who rose to godhood, like Zamorak and
    # Azzanadra) are legendary, whatever their combat level.
    # (a god's own NPC page can be a bracketed one, "Azzanadra (Children of Mah)", so its title
    # without the bracket is looked for among the gods too)
    if "Gods" in categories or strip_bracket(page["title"]) in GODS:
        return "legendary", "a god"
    # Pets first (a boss pet's category has "boss" in it, but it is not a boss): see pet_rarity.
    pet = pet_rarity(page)
    if pet is not None:
        return pet
    by_skill = familiar_rarity(page) or automaton_rarity(page)
    if by_skill is not None:
        return by_skill
    if boss:
        what = "a quest boss (Dominion Tower)" if quest_boss else "a boss"
        if level >= LEGENDARY_BOSS_LEVEL:
            return "legendary", f"{what} of combat level {level}"
        # (a Mahjarrat or dragonkin boss stays epic however low its level, and 0 is a level the wiki
        # doesn't give)
        if 0 < level < RARE_BOSS_LEVEL and not lore_race:
            return "rare", f"{what} of combat level {level}"
        return "epic", what
    # (after the bosses, so one fought at an end-game level stays legendary)
    if lore_race:
        return "epic", lore_race
    if slayer >= 10 and spawns < 20:
        return "rare", f"a Slayer monster of level {slayer} with {spawns} spawns"
    if named or skill_master or slayer_master:
        if len(quests) >= 12 or (len(quests) >= 5 and spawns >= 5):
            return "epic", f"a character in {len(quests)} quests" + (f", with {spawns} spawns" if spawns >= 5 else "")
        if skill_master:
            return "rare", "a skill master (sells a skillcape)"
        if len(quests) >= 5 or royalty:
            return "rare", "royalty" if royalty else f"a character in {len(quests)} quests"
        if slayer_master and not quests:
            return "uncommon", "a Slayer master"
        if quests:
            return "uncommon", f"a named character in {len(quests)} quests"
        # (one in no quests that is fought at level 30 or more goes by its combat level, below:
        # Glophren, the Champion of Champions, at 119)
        if level < 30:
            return "common", "a named character in no quests"
    if character and len(quests) >= 2:
        return "uncommon", f"a role in {len(quests)} quests"
    if slayer >= 5:
        return "uncommon", f"a Slayer monster of level {slayer}" + (f" with {spawns} spawns" if slayer >= 10 else "")
    if spawns >= 60:
        return "common", f"{spawns} spawns"
    # A Hunter creature or an NPC to pickpocket, by the level it needs, if it has no combat level
    # (one that can be fought, like the imp, is rated by that below).
    by_level = skill_level_rarity(page) if level == 0 else None
    if by_level is not None:
        return by_level
    if level >= 100:
        return "rare", f"combat level {level}"
    if level >= 30:
        return "uncommon", f"combat level {level}"
    return "common", "an everyday NPC"


def npc_candidate(page, kind, fields, names, words):
    """A candidate from an NPC or monster page."""
    notes = []

    if page["title"].endswith("(unreleased)"):
        return None, "unreleased"
    ids = all_ids(fields)
    configs = [names[i] for i in ids if i in names]
    # (a copy in the player-owned house looks the same: POH_GROWNCAT is GROWNCAT)
    configs = [c for c in configs if not (c.startswith("POH_") and c[len("POH_"):] in configs)]
    if not configs:
        return None, "no NPC id the plugin knows" if ids else "no NPC id on the page"
    name, desc = name_and_desc(page, fields, notes, versions_merge=True)
    name = SAME_CARD.get(name, name)
    # A version the wiki gives no id is often the NPC as it usually is (Aris's "Human"): the game's
    # configs named for the NPC (DEMON_SLAYER_QIP_ARIS) come first then. And a blank stand-in a
    # cutscene uses (DEMON_SLAYER_QIP_BLANK_NPC) shows nothing, so it goes last.
    versions = [k for k in fields if re.fullmatch(r"version\d+", k)]
    if BLANK_CONFIG.search(configs[0]) and len(versions) > len([k for k in fields if re.fullmatch(r"id\d+", k)]):
        configs = [n for n in configs_named(name, names) if n not in configs][:3] + configs
    configs = sorted(configs, key=lambda c: bool(BLANK_CONFIG.search(c)))
    is_pet = bool(PET_CATEGORIES & set(page.get("categories", [])))
    # A pet named for its kind in its infobox ("Cat") but more fully in its title ("Purple cat")
    # takes the title, so it isn't taken for the plain one.
    if is_pet and page["title"].lower().endswith(" " + name.lower()):
        name = page["title"]
    # A pet's young models (a puppy, a kitten, a baby) come after its grown ones, for a
    # page that lists its NPCs without naming its stages (the terrier's).
    if is_pet:
        configs = sorted(configs, key=lambda c: bool(re.search(r"PUPPY|KITTEN|BABY|JUVI", c)))

    tags = {}
    # The league regions of the NPC's versions: the first, and every other but one named for a quest
    # it only appears in (Reldo is in Falador for Succession) or for a place that doesn't count
    # (SECONDARY_PLACES: Manor Farm, the Dominion Tower). Chancy is in Rimmington and Varrock; the
    # Mage of Zamorak in the Wilderness and Varrock. Found all over the world (Global, like Rat) or
    # in several regions (Imp, Chicken: "Misthalin, Asgarnia, Kandarin"), it is a general card, which
    # has no region (the Card Builder puts a candidate without one in the general deck).
    numbers = sorted(int(k[len("version"):]) for k in fields if re.fullmatch(r"version\d+", k)) or [0]
    regions = []
    for n in numbers:
        # (without its bracket or part number: "Ritual of the Mahjarrat (dying)", "Swan Song, 1")
        version = re.sub(r",\s*\d+$", "", strip_bracket(plain(fields.get(f"version{n}", "")).strip()))
        if n != numbers[0] and (version in QUEST_DIFFICULTY or version in SECONDARY_PLACES):
            continue
        for region in version_regions(fields, n):
            if region not in regions:
                regions.append(region)
    # (another version's Global, somewhere outside the regions, doesn't make one that has a region a
    # general card: Fairy Very Wise's in the Sparse Plane)
    if "global" in regions and len(regions) > 1 and "global" not in version_regions(fields, numbers[0]):
        regions.remove("global")
    # A minigame that brings back monsters from elsewhere puts them in its own region too, which is
    # not where they are from (see SECONDARY_PLACES): left out when they have another.
    categories = page.get("categories", [])
    refought = {SECONDARY_PLACES[place] for place in secondary_places(page, fields)}
    if len(regions) > 1:
        regions = [r for r in regions if r not in refought] or regions
    home = next((HOME_REGIONS[c] for c in categories if c in HOME_REGIONS), None)
    if home in regions:
        regions = [home]
    # A page named for one of its places ("Firefly (The Lost Grove)", found in the Lost Grove and the
    # Piscatoris Hunter area) gets that place's region: the wiki lists the regions in the order of
    # the places ("Tirannwn,Kandarin"), so when there are as many of each, the place's is the one in
    # its position.
    places_listed = links(first_version(fields, "location"))
    bracket = title_bracket(page["title"])
    if len(regions) > 1 and bracket in places_listed and len(places_listed) == len(regions):
        regions = [regions[places_listed.index(bracket)]]
    # The wiki gives some NPCs no region (Lucien): they take the regions of their places, as the
    # NPCs that have one place them (PLACE_REGIONS).
    if not regions:
        implied = list(dict.fromkeys(PLACE_REGIONS[place.lower()] for place in links(" ".join(numbered_fields(fields, "location")))
                                     if place.lower() in PLACE_REGIONS))
        if implied:
            regions = implied
            notes.append("no league region on the wiki: " + ", ".join(implied) + " from its places")
    # (the regions tag is decided in merge_versions, with any other pages of the same card)

    # The location words for the place in the page title's brackets ("Guard (Catherby)",
    # "Lumbridge guardsman (Lumbridge Market)") and the places the infobox links to (Lumbridge
    # Castle -> lumbridge). A bracketed place that isn't a word yet is suggested as a new one if
    # the page is filed under it (the Card Builder points that out); other unknown places are only
    # mentioned in a note, as the infobox often links to a shop or building rather than a town.
    def location_word(place):
        return place if place in words["location"] else max(
            (w for w in words["location"] if place.startswith(w + "_")), key=len, default=None)

    # (every version's, Lucien's Ritual Site and the Flying Horse Inn he hides in disguised, when
    # they come to at most VERSION_PLACES; more is a role found all over, the trader crewmember's
    # twelve ports, and only the first version's are used)
    location_text = " ".join(numbered_fields(fields, "location"))
    if len({p.lower() for p in links(location_text) if not DATE_LINK.search(p)}) > VERSION_PLACES:
        location_text = first_version(fields, "location")
    # A monster's places are often only in its location table, as LocLine rows ("|loc=[[Mazcab]]"):
    # those are used when the infobox gives none, and there are at most LOCATION_TABLE_PLACES of
    # them (the airut's three; a giant spider's nine say it is found all over).
    if not location_text.strip():
        rows = [template_fields(row).get("loc", "") for row in find_templates(page.get("text", ""), ["LocLine"])]
        if len(set(links(" ".join(rows)))) <= LOCATION_TABLE_PLACES:
            location_text = " ".join(rows)
    places, new_words = [], []

    def add_place(place, new_ok):
        word = location_word(place) or (place if new_ok else None)
        if word and word not in places:
            places.append(word)
            if word not in words["location"]:
                new_words.append(f"location '{word}'")

    bracket = title_bracket(page["title"])
    if bracket:
        add_place(slug(bracket), place_in_brackets(page, fields))
    # Every place the infobox links to, as a new word if there is none for it yet (a shop or a
    # building as well as a town: change it to the town's in the Card Builder). Not a region or
    # the whole world, which are what the deck files and general cards are for.
    for target in links(location_text):
        place = slug(target)
        if place not in LEAGUE_REGIONS and place not in REGION_ALIASES and place != "gielinor" and not DATE_LINK.search(target):
            add_place(place, True)
    # A known place the page is filed under (Aggie: Draynor Village -> draynor). The category must
    # be the place itself, give or take "village", "town" or "city": "Lumbridge quests" or
    # "Taverley Dungeon" only mention one.
    for wiki_category in page.get("categories", []):
        place = re.sub(r"_(village|town|city)$", "", slug(wiki_category))
        if place in words["location"] and place not in places:
            places.append(place)
    # (a place it is only fought again in, or met in the future, is left out when it has another:
    # Sigmund's Dominion Tower; the Stone face, only in the Dominion Tower, keeps it)
    secondary = {slug(place) for place in SECONDARY_PLACES}
    if any(p not in secondary for p in places):
        places = [p for p in places if p not in secondary]
    # (an NPC found all over, like Woman or Imp, has no location on the wiki, so a general card
    # only gets the places of something that lives in a few, like the crimson swift)
    if places:
        tags["location"] = places
    else:
        notes.append("no location on the wiki: add one if it has a home")

    category = []
    race = slug(plain(first_version(fields, "race")))
    # The race's word, or the race itself as a new word (implings, titans) if it has none.
    if race in RACE_WORDS:
        category.append(RACE_WORDS[race])
    elif race and race not in RACE_NOT_WORDS:
        category.append(race)
    page_categories = " ".join(page.get("categories", [])).lower()
    for key, word in CATEGORY_WORDS.items():
        if key in page_categories and word in words["category"] and word not in category:
            category.append(word)
    if kind == "Infobox Monster" and "monster" not in category:
        category.append("monster")
    if category:
        tags["category"] = category
    new_words += [f"category '{w}'" for w in category if w not in words["category"]]

    # Skills: a skill master's, from the skillcape they sell ("[[Defence cape]]" -> defence); a
    # skilling pet's ("the skilling pet for [[Mining]]"); and from the wiki's categories (thievable,
    # Slayer monsters, familiars).
    skills = []
    if "Skill masters" in page.get("categories", []):
        shop = " ".join(numbered_fields(fields, "shop")).lower()
        skills = [s for s in words["skills"] if re.search(r"\b" + s + r" (?:master )?cape\b", shop)]
    pet = re.search(r"skilling pets?\|skilling pet\]\] for (?:the )?\[\[(\w+)", page.get("text", ""))
    if pet and slug(pet.group(1)) in words["skills"]:
        skills.append(slug(pet.group(1)))
    for wiki_category in page.get("categories", []):
        # (a category named for a skill, "Hunter", files the NPCs that skill is trained on)
        named_for = slug(wiki_category)
        skill = CATEGORY_SKILLS.get(wiki_category) or (named_for if named_for in words["skills"] else None)
        if skill and skill not in skills:
            skills.append(skill)
    if skills:
        tags["skills"] = skills
    if new_words:
        notes.append("new tag words (add them to core/cards.lua, or change them): " + ", ".join(new_words))

    membership = membership_tag(fields, notes)
    if membership:
        tags["membership"] = membership

    gender = gender_of(page)
    character = is_character(page, race)
    # named: a person with a name, not a role (the Card Builder frames them close, like Bob; a
    # role or anyone else whole, like a guard).
    named = character and not is_role(name)
    rarity, why = npc_rarity(page, fields, character, named)
    notes.append(f"rarity is a guess ({why})")

    if first_version(fields, "removal") not in ("", "No"):
        notes.append("the wiki says this NPC was removed from the game")

    # (gender: the Card Builder picks a trade's male or female pose by it, such as
    # MALE_FARMER_INTERFACE_ANIM; race whether to frame it as short, like a dwarf.)
    return {"page": page["title"], "kind": "npc", "npc": configs[0], "others": configs[1:6], "name": name,
            "league_regions": regions,
            "named": named, "gender": gender, "race": race or None, "desc": desc, "rarity": rarity, "tags": tags,
            "notes": notes}, None


def lua_string(text):
    return '"' + str(text).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def lua_value(value):
    if isinstance(value, bool):
        return "true" if value else "false"
    if isinstance(value, dict):
        return "{ " + ", ".join(f"{k} = {lua_value(v)}" for k, v in value.items()) + " }"
    if isinstance(value, list):
        return "{ " + ", ".join(lua_value(v) for v in value) + " }"
    if isinstance(value, (int, float)):
        return str(value)
    if value is None:
        return "nil"
    return lua_string(value)


def write_candidates(found):
    lines = ["-- dev/wiki_candidates.lua",
             "-- Made by dev/wiki_cards.py from the RuneScape Wiki (runescape.wiki). Do not edit; run it again.",
             "-- Card candidates for the Wiki Review window (dev/wikireview.lua).",
             "return {"]
    for c in found:
        lines.append("    " + lua_value(c) + ",")
    lines.append("}")
    OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")


SOURCES = CACHE / "sources.json"


def source(name, races=(), members=None, npcs=False, within=None):
    """A category or region to fetch, with the filters asked for with it (saved as just the name
    when it has none). `npcs`: only its NPCs (see --npcs); `within`: only its NPCs of that league
    region (see --within)."""
    races = sorted({slug(r) for r in races})
    if not races and not members and not npcs and not within:
        return name
    entry = {"name": name, "races": races, "members": members}
    if npcs:
        entry["npcs"] = True
    if within:
        entry["within"] = within
    return entry


def within_region(entry):
    """The league region (as the wiki names it) a saved category is narrowed to, or None."""
    return entry.get("within") if isinstance(entry, dict) else None


def npcs_only(entry):
    """True if a saved category or region is fetched for its NPCs only (--npcs)."""
    return isinstance(entry, dict) and entry.get("npcs", False)


def source_parts(entry):
    """A saved category or region as (name, races, members)."""
    if isinstance(entry, str):
        return entry, [], None
    return entry["name"], entry.get("races", []), entry.get("members")


def source_label(entry, region=False):
    """How a category or region is named in the candidates' sources (and the Wiki Review's list):
    "Lumbridge", "Misthalin (region)", "Lumbridge (dog)", "Global (region; rat, f2p)"."""
    name, races, members = source_parts(entry)
    within = within_region(entry)
    filters = ", ".join((["in " + within] if within else []) + races
                        + ([members] if members else []) + (["NPCs"] if npcs_only(entry) else []))
    if region:
        return f"{name} (region" + (f"; {filters})" if filters else ")")
    return f"{name} ({filters})" if filters else name


# The regions whose NPCs are general cards: found all over the world, or in several regions.
GENERAL_REGIONS = ("Global", MULTIPLE, NO_REGION)
# The other way: the wiki's names for those region words (the others are the word, capitalised).
WIKI_REGION_NAMES = {word: name.title() for name, word in REGION_ALIASES.items() if name in LEAGUE_REGIONS}


def passes(candidate, entry, own):
    """True if a candidate passes the filters of a category or region (a race filter is only for
    NPCs; items pass it). A general region's (GENERAL_REGIONS) must also be a general card: one
    with no regions of its own (`own`)."""
    name, races, members = source_parts(entry)
    if npcs_only(entry) and candidate["kind"] == "item":
        return False
    within = within_region(entry)
    if within and REGION_ALIASES.get(slug(within), slug(within)) not in (own or []):
        return False
    if name in GENERAL_REGIONS and own:
        return False
    if races and candidate["kind"] == "npc" and candidate.get("race") not in races:
        return False
    return not members or members in candidate["tags"].get("membership", [])


def remembered_sources(args):
    """The categories, regions and pages to make candidates from: this run's (with this run's
    --race and --members), added to the ones asked for before (unless --only), which are saved for
    next time."""
    saved = {}
    if SOURCES.exists() and not args.forget:
        saved = json.loads(SOURCES.read_text(encoding="utf-8"))
    this_run = {"categories": [source(c, args.race, args.members, args.npcs, args.within) for c in args.category],
                "regions": [source(r, args.race, args.members, args.npcs) for r in args.region],
                "pages": list(args.page)}
    for key, new in this_run.items():
        saved.setdefault(key, [])
        for item in new:
            if item not in saved[key]:
                saved[key].append(item)
    if not args.count:              # (a preview keeps nothing)
        SOURCES.parent.mkdir(parents=True, exist_ok=True)
        SOURCES.write_text(json.dumps(saved, indent=1), encoding="utf-8")
    chosen = this_run if args.count or args.only else saved
    return chosen["categories"], chosen["regions"], chosen["pages"]


def candidate_sources(made, listed_in, filters, words):
    """The sources a candidate is shown under in the Wiki Review: those it was listed in whose
    filters it passes (a page asked for by name has none). One a general region listed that turns
    out to belong to one region (Fairy Very Wise, Global only in a later version) is filed under
    that region instead. (An NPC page's regions are its own here; merge_versions joins a card's.)"""
    own = made["tags"].get("regions") or region_tag(made.get("league_regions", []), words)[0]
    kept = [s for s in listed_in if s not in filters or passes(made, filters[s], own)]
    if not kept and own and any(source_parts(filters[s])[0] in GENERAL_REGIONS for s in listed_in if s in filters):
        kept = [source_label(WIKI_REGION_NAMES.get(own[0], own[0].replace("_", " ").title()), True)]
    return kept


def make_wiki(args):
    """The polite wiki client, with the contact from --contact or dev/wiki_contact.txt."""
    contact = args.contact
    if not contact and CONTACT_FILE.exists():
        # (utf-8-sig, as Windows editors often put an invisible marker at the start of the file)
        contact = (CONTACT_FILE.read_text(encoding="utf-8-sig").strip().splitlines() or [""])[0].strip()
    if not contact:
        print("No contact given: please pass --contact or put one in dev/wiki_contact.txt, so the wiki's"
              " admins can reach you if anything goes wrong.")
    return Wiki(contact, args.max_requests)


def show_subcategories(args):
    wiki = make_wiki(args)
    for category in args.subcategories:
        rows = list_subcategories(wiki, category, args.refresh)
        print(f"Subcategories of {category}: {len(rows)}")
        for name, pages, subcats in rows:
            print(f"  {name}  ({pages} pages" + (f", {subcats} subcategories" if subcats else "") + ")")
    print(f"{args.max_requests - wiki.left} requests made")
    print('Use a name with --category "NAME", or ask for its subcategories the same way.')
    return 0


def show_count(titles, sources, args, wiki):
    """The --count preview: how many pages each source would fetch, how many of them are cached
    already, and the requests and runs the rest take."""
    def cached(title):
        return not args.refresh and cache_path("pages", title).exists()

    for label in dict.fromkeys(label for title in titles for label in sources[title]):
        mine = [t for t in titles if label in sources[t]]
        print(f"  {label}: {len(mine)} pages ({sum(cached(t) for t in mine)} already cached)")
    to_fetch = sum(not cached(t) for t in titles)
    requests = math.ceil(to_fetch / BATCH)
    runs = max(1, math.ceil(requests / max(1, args.max_requests)))
    print(f"Total: {len(titles)} pages, {len(titles) - to_fetch} cached, {to_fetch} to fetch"
          f" = about {requests} requests ({runs} run{'s' if runs > 1 else ''} of {args.max_requests})")
    print(f"(This preview made {args.max_requests - wiki.left} requests; they are cached for the real run.)")
    return 0


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--category", action="append", default=[])
    parser.add_argument("--page", action="append", default=[])
    parser.add_argument("--region", action="append", default=[])
    parser.add_argument("--race", action="append", default=[])
    parser.add_argument("--members", choices=["f2p", "p2p"])
    parser.add_argument("--npcs", action="store_true")
    parser.add_argument("--within")
    parser.add_argument("--count", action="store_true")
    parser.add_argument("--contact", default="")
    parser.add_argument("--max-requests", type=int, default=30)
    parser.add_argument("--refresh", action="store_true")
    parser.add_argument("--only", action="store_true")
    parser.add_argument("--forget", action="store_true")
    parser.add_argument("--drops", action="append", default=[])
    parser.add_argument("--drops-from", action="append", default=[])
    parser.add_argument("--until", default="")
    parser.add_argument("--all-bosses", action="store_true")
    parser.add_argument("--subcategories", action="append", default=[])
    args = parser.parse_args()
    if args.subcategories:
        return show_subcategories(args)
    if args.all_bosses:
        args.drops_from.append("Bosses")
        args.until = args.until or "Quest bosses"
    if (not args.category and not args.region and not args.page and not args.drops and not args.drops_from
            and not SOURCES.exists()):
        print(__doc__)
        return 1
    categories, regions, page_titles = remembered_sources(args)
    if not categories and not regions and not page_titles and not args.drops and not args.drops_from:
        print("Nothing to fetch: give --category, --region or --page.")
        return 1

    wiki = make_wiki(args)
    print("From:", ", ".join([source_label(c) for c in categories] + [source_label(r, True) for r in regions]
                             + [f'page "{p}"' for p in page_titles]))
    # Each title, with the categories (or the page asked for) it came from, so the review window
    # can show one at a time.
    titles, sources = [], {}
    filters = {}        # a source's label -> the category or region it is, with its filters

    def add(title, source):
        if title not in sources:
            titles.append(title)
            sources[title] = []
        if source not in sources[title]:
            sources[title].append(source)

    for title in page_titles:
        add(title, title)
    # A filtered category or region is narrowed by asking the wiki first, so only its matching
    # pages are fetched (and checked again once they are).
    for entry in categories:
        name, races, members = source_parts(entry)
        label = source_label(entry)
        filters[label] = entry
        # (--refresh only re-asks for this run's categories, not every remembered one)
        refresh = args.refresh and name in args.category
        listed = category_pages(wiki, name, refresh)
        # (narrowed to the pages the region's structured data lists, before they are fetched: each
        # is checked by its own region once it is)
        within = within_region(entry)
        if within:
            in_region = region_pages(wiki, within, refresh)
            if in_region is None:
                print(f"  request limit reached before {label} was narrowed; it is fetched next run")
                continue
            in_region = set(in_region)
            listed = [t for t in listed if t in in_region]
        if races or members:
            listed = narrowed(wiki, listed, f'incategory:"{name}"', races, members, refresh)
            if listed is None:
                print(f"  request limit reached before {label} was narrowed; it is fetched next run")
                continue
        for title in listed:
            add(title, label)
    for entry in regions:
        name, races, members = source_parts(entry)
        label = source_label(entry, True)
        filters[label] = entry
        refresh = args.refresh and name in args.region
        listed = region_pages(wiki, name, refresh, members)
        if listed is None:
            continue                # (listed next run)
        if races:
            # (MULTIPLE's pages have no one value to search within, so the race is searched for
            # everywhere and matched against them)
            scope = "" if name in (MULTIPLE, NO_REGION) else f'insource:"leagueRegion = {name}"'
            listed = narrowed(wiki, listed, scope, races, None, refresh)
            if listed is None:
                print(f"  request limit reached before {label} was narrowed; it is fetched next run")
                continue
        for title in listed:
            add(title, label)
    if args.count:
        return show_count(titles, sources, args, wiki)
    pages = fetch_pages(wiki, titles, args.refresh)
    drop_titles = list(args.drops)
    for list_title in args.drops_from:
        listed = fetch_pages(wiki, [list_title], args.refresh).get(list_title)
        if listed is None or listed.get("missing"):
            print(f'The page "{list_title}" could not be read: no drop rates asked for from it')
            continue
        try:
            linked = linked_pages(listed.get("text", ""), args.until)
        except ValueError as problem:
            print(f'"{list_title}": {problem}, so nothing was taken from it')
            continue
        print(f'"{list_title}" links {len(linked)} pages' + (f' before "{args.until}"' if args.until else ""))
        drop_titles += [t for t in linked if t not in drop_titles]
    drop_pages = fetch_pages(wiki, drop_titles, args.refresh) if drop_titles else {}
    drops = remember_drops(drop_pages)
    if drop_titles:
        print(f"Drop rates for {len(drops)} items are kept in {DROPS.relative_to(ROOT)}")
    # The Grand Exchange price of each item page, by asking the wiki for {{GEP|name}}.
    price_names = {title: price_name(template_fields(find_template(pages[title]["text"], ["Infobox Item"])[1] or ""),
                                     title)
                   for title in titles if title in pages and "Infobox Item" in pages[title].get("text", "")}
    prices = fetch_prices(wiki, [n for n in price_names.values() if n], args.refresh) if price_names else {}

    names, words = npc_names(), allowed_words()
    QUEST_DIFFICULTY.update(quest_difficulties(wiki, args.refresh))
    PLACE_REGIONS.update(place_regions(json.loads(f.read_text(encoding="utf-8")) for f in (CACHE / "pages").glob("*.json")))
    # The other places of NPCs the wiki gives no region: their own pages give theirs (fetched once).
    unplaced = places_without_region(pages.values())
    for place, place_page in (fetch_pages(wiki, unplaced, False) if unplaced else {}).items():
        found = re.search(r"\|\s*leagueRegion\d*\s*=\s*([^\n|]+)", place_page.get("text", ""), re.I)
        regions = league_regions(plain(found.group(1))) if found else []
        if regions and regions != ["global"]:
            PLACE_REGIONS[place.lower()] = REGION_ALIASES.get(regions[0], regions[0])
    found, skipped = [], {}
    for title in titles:
        page = pages.get(title)
        if page is None:
            continue
        made, reason = candidate(page, names, words, prices.get(price_names.get(title)),
                                drops.get((pages[title].get('title') or title).lower()))
        if made is not None:
            made["sources"] = candidate_sources(made, sources[title], filters, words)
            if not made["sources"]:
                made, reason = None, "not what its sources ask for (a race, free to play, NPCs only, or a region)"
        if made is not None:
            found.append(made)
        else:
            skipped[reason] = skipped.get(reason, 0) + 1
    found = merge_versions(found, words)
    found.sort(key=lambda c: (c["kind"], (c["tags"].get("regions") or c["tags"].get("category") or ["~"])[0], c["name"]))
    write_candidates(found)

    print(f"{len(found)} candidates written to {OUTPUT.relative_to(ROOT)}")
    for reason, count in sorted(skipped.items()):
        print(f"  {count} pages skipped: {reason}")
    summary = f"{args.max_requests - wiki.left} requests made this run"
    if len(pages) < len(titles):
        summary += f"; {len(titles) - len(pages)} pages still to fetch (run it again)"
    print(summary)
    return 0


if __name__ == "__main__":
    sys.exit(main())
