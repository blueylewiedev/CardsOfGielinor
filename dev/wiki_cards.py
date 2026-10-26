#!/usr/bin/env python3
"""Makes card candidates from the RuneScape Wiki, for review in the plugin's Wiki Review window
(dev/wikireview.lua), which loads each one into the Card Builder to check, frame and copy.

Usage:  python dev/wiki_cards.py [--category NAME ...] [--page TITLE ...] [options]
  e.g.  python dev/wiki_cards.py --category Lumbridge --contact "@me on Discord"

  --category NAME   the NPC pages in a wiki category (without "Category:"), e.g. Lumbridge
  --page TITLE      one page, e.g. "Duke Horacio" (both can be given, and more than once)
  --contact TEXT    how the wiki's admins can reach you; added to the User-Agent (recommended).
                    Without it, the first line of dev/wiki_contact.txt is used (a file on your
                    own computer, not committed), e.g.  @yourname on Discord
  --max-requests N  the most requests this run may make (default 30). Anything not fetched yet
                    is fetched next run; what was fetched is kept.
  --refresh         fetch again even what is in the cache (only for pages changed on the wiki)

It writes dev/wiki_candidates.lua: for each NPC page with an infobox, the NPC's config name
(the wiki gives the NPC ids; dev/npc.txt turns them into names), the card name, the examine text
as the description, tags, a suggested rarity, and notes on anything to check. Cards that are
already in the deck are left out by the review window, not here.

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
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
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
MAX_DESC = 40           # the longest description that fits on a card without being cut off

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
        found = {}
        for answer in answers:
            query = answer.get("query", {})
            # A title asked for may come back under its normalised or redirected name.
            for hop in query.get("normalized", []) + query.get("redirects", []):
                found.setdefault("_asked", {})[hop["to"]] = hop["from"]
            for page in query.get("pages", []):
                entry = found.setdefault(page["title"], {"title": page["title"], "categories": []})
                if page.get("missing"):
                    entry["missing"] = True
                for revision in page.get("revisions", []):
                    entry["revid"] = revision["revid"]
                    entry["text"] = revision["slots"]["main"]["content"]
                entry["categories"] += [c["title"].removeprefix("Category:") for c in page.get("categories", [])]
        asked = found.pop("_asked", {})
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
    """The words cards may use for regions, location and NPC category, from core/cards.lua."""
    text = CARDS.read_text(encoding="utf-8")

    def quoted(block):
        return re.findall(r'"([a-z0-9_]+)"', block)

    words = {}
    for kind in ("regions", "location"):
        match = re.search(r"Cards\.tagWords\s*=\s*\{.*?" + kind + r"\s*=\s*\{([^}]*)\}", text, re.S)
        words[kind] = quoted(match.group(1)) if match else []
    groups = re.search(r"Cards\.tagGroups\s*=\s*\{(.*?)\n\}", text, re.S)
    words["category"] = quoted(groups.group(1)) if groups else []
    return words


# The wiki's region names that differ from the plugin's region words.
REGION_ALIASES = {"desert": "kharidian_desert", "kharidian_desert": "kharidian_desert",
                  "fremennik": "fremennik_province", "fremennik_provinces": "fremennik_province"}

# Category words suggested by the infobox's race.
RACE_WORDS = {
    "human": "humanoid", "dwarf": "humanoid", "elf": "humanoid", "gnome": "humanoid", "halfling": "humanoid",
    "werewolf": "humanoid", "vampyre": "undead", "goblin": "goblin", "hobgoblin": "goblin", "dragon": "dragon",
    "demon": "demon", "giant": "giant", "ogre": "giant", "troll": "troll", "undead": "undead", "skeleton": "undead",
    "zombie": "undead", "ghost": "undead", "spirit": "spirit", "elemental": "elemental", "spider": "insect",
    "insect": "insect", "golem": "construct", "construct": "construct", "cow": "animal", "chicken": "animal",
    "dog": "animal", "cat": "animal", "rat": "animal", "bird": "animal", "bear": "animal", "wolf": "animal",
    "sheep": "animal", "goat": "animal", "horse": "animal", "unicorn": "animal",
}

# Category words suggested by the page's wiki categories (a category name containing the key).
CATEGORY_WORDS = {
    "merchants": "shopkeeper", "shopkeepers": "shopkeeper", "stall": "stallholder", "monarchs": "royalty",
    "royalty": "royalty", "bankers": "banker", "guards": "guard", "knights": "knight", "wizards": "wizard",
    "priests": "priest", "monks": "priest", "pirates": "pirate", "farmers": "farmer", "thieves": "thief",
    "bosses": "boss", "adventurers": "adventurer",
}


def slug(text):
    return re.sub(r"[^a-z0-9]+", "_", text.lower()).strip("_")


# ---------------------------------------------------------------------------------------------
# Candidates
# ---------------------------------------------------------------------------------------------


def candidate(page, names, words):
    """A card candidate from a page, or (None, reason) if it isn't one."""
    kind, inside = find_template(page.get("text", ""), ["Infobox NPC", "Infobox Monster"])
    if inside is None:
        return None, "no NPC infobox"
    fields = template_fields(inside)
    notes = []

    ids = all_ids(fields)
    configs = [names[i] for i in ids if i in names]
    if not configs:
        return None, "no NPC id the plugin knows" if ids else "no NPC id on the page"
    if len(configs) > 1:
        notes.append(f"{len(configs)} models listed; using the first ({configs[0]})")

    name = plain(first_version(fields, "name")) or re.sub(r"\s*\(.*\)$", "", page["title"])
    desc = plain(first_version(fields, "examine"))
    if not desc:
        notes.append("no examine text: write a description")
    elif len(desc) > MAX_DESC:
        notes.append(f"description is {len(desc)} letters; cards show about {MAX_DESC}")

    tags = {}
    region = slug(plain(first_version(fields, "leagueregion")))
    region = REGION_ALIASES.get(region, region)
    if region in words["regions"]:
        tags["regions"] = [region]
    else:
        notes.append("region unknown: choose the deck file")

    # The location words for the places the infobox links to (Lumbridge Castle -> lumbridge).
    # Failing that, the place in the page title's brackets ("Guard (Catherby)"), when the page is
    # also in that place's category: it is suggested as a new word if it isn't one yet (the Card
    # Builder points that out). Other unknown places are only mentioned in a note, as the infobox
    # often links to a shop or building rather than a town.
    def location_word(place):
        return place if place in words["location"] else max(
            (w for w in words["location"] if place.startswith(w + "_")), key=len, default=None)

    location_text = first_version(fields, "location")
    places = []
    for target in links(location_text):
        word = location_word(slug(target))
        if word and word not in places:
            places.append(word)
    bracket = re.search(r"\(([^)]+)\)$", page["title"])
    if not places and bracket and bracket.group(1) in page.get("categories", []):
        place = slug(bracket.group(1))
        places.append(location_word(place) or place)
        if place not in words["location"]:
            notes.append(f"new location word '{place}' (add it to Cards.tagWords.location, or change it)")
    if places:
        tags["location"] = places
    elif location_text:
        notes.append(f"location on the wiki: {plain(location_text)[:60]} (no location word for it)")
    else:
        notes.append("no location on the wiki: add one if it has a home")

    category = []
    race = slug(plain(fields.get("race", "")))
    if RACE_WORDS.get(race) in words["category"]:
        category.append(RACE_WORDS[race])
    page_categories = " ".join(page.get("categories", [])).lower()
    for key, word in CATEGORY_WORDS.items():
        if key in page_categories and word in words["category"] and word not in category:
            category.append(word)
    if kind == "Infobox Monster" and "monster" not in category:
        category.append("monster")
    if category:
        tags["category"] = category

    # A rough rarity: the reviewer decides.
    level = re.search(r"\d+", first_version(fields, "level") or first_version(fields, "combat") or "")
    level = int(level.group()) if level else 0
    quests = links(first_version(fields, "quest"))
    if "boss" in category:
        rarity, why = "epic", "a boss"
    elif level >= 150:
        rarity, why = "rare", f"combat level {level}"
    elif "royalty" in category or len(quests) >= 3:
        rarity, why = "uncommon", "royalty" if "royalty" in category else f"in {len(quests)} quests"
    else:
        rarity, why = "common", "nothing stands out"
    notes.append(f"rarity is a guess ({why})")

    if first_version(fields, "removal") not in ("", "No"):
        notes.append("the wiki says this NPC was removed from the game")

    return {"page": page["title"], "npc": configs[0], "others": configs[1:6], "name": name, "desc": desc,
            "rarity": rarity, "tags": tags, "notes": notes, "revid": page.get("revid")}, None


def lua_string(text):
    return '"' + str(text).replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n") + '"'


def lua_value(value):
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


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--category", action="append", default=[])
    parser.add_argument("--page", action="append", default=[])
    parser.add_argument("--contact", default="")
    parser.add_argument("--max-requests", type=int, default=30)
    parser.add_argument("--refresh", action="store_true")
    args = parser.parse_args()
    if not args.category and not args.page:
        print(__doc__)
        return 1

    contact = args.contact
    if not contact and CONTACT_FILE.exists():
        contact = (CONTACT_FILE.read_text(encoding="utf-8").strip().splitlines() or [""])[0].strip()
    if not contact:
        print("No contact given: please pass --contact or put one in dev/wiki_contact.txt, so the wiki's"
              " admins can reach you if anything goes wrong.")
    wiki = Wiki(contact, args.max_requests)
    titles = list(args.page)
    for category in args.category:
        for title in category_pages(wiki, category, args.refresh):
            if title not in titles:
                titles.append(title)
    pages = fetch_pages(wiki, titles, args.refresh)

    names, words = npc_names(), allowed_words()
    found, skipped = [], {}
    for title in titles:
        page = pages.get(title)
        if page is None:
            continue
        made, reason = candidate(page, names, words)
        if made is not None:
            found.append(made)
        else:
            skipped[reason] = skipped.get(reason, 0) + 1
    found.sort(key=lambda c: (c["tags"].get("regions", ["~"])[0], c["name"]))
    write_candidates(found)

    print(f"{len(found)} candidates written to {OUTPUT.relative_to(ROOT)}")
    for reason, count in sorted(skipped.items()):
        print(f"  {count} pages skipped: {reason}")
    print(f"{args.max_requests - wiki.left} requests made this run;"
          f" {len(titles) - len(pages)} pages still to fetch" if len(pages) < len(titles) else
          f"{args.max_requests - wiki.left} requests made this run")
    return 0


if __name__ == "__main__":
    sys.exit(main())
