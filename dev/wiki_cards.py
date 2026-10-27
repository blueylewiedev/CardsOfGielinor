#!/usr/bin/env python3
"""Makes card candidates from the RuneScape Wiki, for review in the plugin's Wiki Review window
(dev/wikireview.lua), which loads each one into the Card Builder to check, frame and copy. The
Wiki Fetch window (dev/wikifetch.lua) puts the command together for you.

Usage:  python dev/wiki_cards.py [--category NAME ...] [--page TITLE ...] [options]
  e.g.  python dev/wiki_cards.py --category Lumbridge --category Logs

  --category NAME   the pages in a wiki category (without "Category:"): places for NPCs, such as
                    Lumbridge, or kinds of item, such as Logs or Scimitars
  --page TITLE      one page, e.g. "Duke Horacio" (both can be given, and more than once)
  --contact TEXT    how the wiki's admins can reach you; added to the User-Agent (recommended).
                    Without it, the first line of dev/wiki_contact.txt is used (a file on your
                    own computer, not committed), e.g.  @yourname on Discord
  --max-requests N  the most requests this run may make (default 30). Anything not fetched yet
                    is fetched next run; what was fetched is kept.
  --refresh         fetch again even what is in the cache (only for pages changed on the wiki)
  --only            candidates from this run's categories and pages only (see below)
  --forget          forget the categories and pages asked for before (see below)
  --subcategories NAME
                    list the subcategories of a wiki category with how many pages each has, to find
                    category names to use with --category (one request, cached). Makes no candidates
                    and does not change the remembered categories. e.g.
                    python dev/wiki_cards.py --subcategories "Equipment Slots"

The categories and pages asked for are remembered (dev/wiki_cache/sources.json), and the
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
MAX_DESC = 65           # the longest description that fits on a card (as in the Card Builder)

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
    another, that word (item_requires: scimitar -> weapon)."""
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
    for requires, block in re.findall(r'\{\s*title\s*=\s*"[^"]*",\s*(?:requires\s*=\s*"(\w+)",\s*)?'
                                      r'words\s*=\s*\{([^}]*)\}', item_groups.group(1) if item_groups else ""):
        for word in quoted(block):
            words["item_category"].append(word)
            if requires:
                words["item_requires"][word] = requires
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
    "logs": ["raw_material"], "ores": ["raw_material"], "ore": ["raw_material"], "hides": ["raw_material"],
    "bars": ["processed_material"], "bar": ["processed_material"], "planks": ["processed_material"],
    "runes": ["rune"], "food": ["food"], "fish": ["food"], "drinks": ["drink"], "potions": ["potion"],
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
    "herbs": ["raw_material"], "herb": ["raw_material"], "gems": ["raw_material"], "gem": ["raw_material"],
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


# Wiki categories of pages about things no longer in the game (the Saradominist priests of the
# Battle of Lumbridge camp, the old attackable Lumbridge guard). Those make no candidates.
REMOVED_CATEGORIES = {"Removed content", "Historical article"}


def only_in_cutscenes(page, fields):
    """True if the NPC is only seen in cutscenes (the guards Billy and Bob, in Falador's cutscene):
    the wiki files it under cutscene characters, and every location it gives says "(cutscene)".
    One filed there that can also be met in the world (a location without it) is kept."""
    if "Cutscene characters" not in page.get("categories", []):
        return False
    locations = [v for v in numbered_fields(fields, "location") if v.strip()]
    return all("cutscene" in v.lower() for v in locations)


def candidate(page, names, words):
    """A card candidate from a page (an NPC or an item), or (None, reason) if it isn't one."""
    if REMOVED_CATEGORIES & set(page.get("categories", [])):
        return None, "removed from the game"
    text = page.get("text", "")
    kind, inside = find_template(text, ["Infobox NPC", "Infobox Monster"])
    if inside is not None:
        fields = template_fields(inside)
        if only_in_cutscenes(page, fields):
            return None, "only seen in cutscenes"
        return npc_candidate(page, kind, fields, names, words)
    _, inside = find_template(text, ["Infobox Item"])
    if inside is not None:
        _, bonuses = find_template(text, ["Infobox Bonuses"])
        return item_candidate(page, template_fields(inside), template_fields(bonuses or ""), words)
    return None, "no NPC or item infobox"


def title_bracket(title):
    """The text in brackets at the end of a title or name ("Cook (Lumbridge)" -> Lumbridge), or None."""
    bracket = re.search(r"\(([^)]+)\)$", title)
    return bracket.group(1) if bracket else None


def strip_bracket(name):
    """A title or name without its bracket ("Guard (Catherby)" -> Guard)."""
    return re.sub(r"\s*\(.*\)$", "", name)


def place_in_brackets(page):
    """The place in a page title's brackets ("Cook (Lumbridge)" -> Lumbridge), if the page is
    filed under it; None for other brackets, which only say which version it is ("(attackable)")."""
    bracket = title_bracket(page["title"])
    return bracket if bracket in page.get("categories", []) else None


def name_and_desc(page, fields, notes, versions_merge=False):
    """The card name and description (the examine text), with a note if the description needs
    work. The name is the page title when it has brackets, as the wiki uses those to tell NPCs of
    the same name apart ("Cook (Lumbridge)", "Cook (Blue Moon Inn)"), and the deck names cards
    the same way; otherwise the infobox's name, or the title. With versions_merge (NPCs, whose
    version pages become one card: see merge_versions), only a place is kept in brackets."""
    infobox_name = plain(first_version(fields, "name"))
    if title_bracket(page["title"]) and (not versions_merge or place_in_brackets(page)):
        name = page["title"]
    else:
        name = infobox_name or strip_bracket(page["title"])
    desc = plain(first_version(fields, "examine"))
    if not desc:
        notes.append("no examine text: write a description")
    elif len(desc) > MAX_DESC:
        notes.append(f"description is {len(desc)} letters; cards show about {MAX_DESC}")
    return name, desc


def item_candidate(page, fields, bonuses, words):
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
    cosmetic = [c for c in page.get("categories", []) if COSMETIC_CATEGORY.search(c.lower())]
    if cosmetic:
        found = ["fashion"]
        notes.append(f"looks like a cosmetic ({cosmetic[0]}): tagged fashion only")
    else:
        for category in page.get("categories", []):
            name_part = category.lower().removeprefix("disassemble category/")
            for key, keyed in ITEM_CATEGORY_WORDS.items():
                if re.search(r"\b" + re.escape(key) + r"\b", name_part):
                    found += keyed
    category = []
    for word in found:
        parent = words["item_requires"].get(word)
        for needed in ([parent] if parent else []) + [word]:
            if needed in words["item_category"] and needed not in category:
                category.append(needed)
    tags = {"category": category} if category else {}
    if not category:
        notes.append("no category found: choose what kind of item it is")

    skills = [s for s in words["skills"]
              if any(c.lower() in (s, s + " items") for c in page.get("categories", []))]
    if skills:
        tags["skills"] = skills

    value = re.search(r"\d[\d,]*", first_version(fields, "value"))
    value = int(value.group().replace(",", "")) if value else 0
    if value >= 500000:
        rarity = "epic"
    elif value >= 50000:
        rarity = "rare"
    elif value >= 5000:
        rarity = "uncommon"
    else:
        rarity = "common"
    notes.append(f"rarity is a guess (worth {value:,} coins)")

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


def merge_versions(found):
    """One NPC candidate per card. The wiki often has a page for each version of an NPC ("Lumbridge
    guard (attackable)", "Lumbridge guardsman (bridge)"): candidates with the same card name (see
    name_and_desc and SAME_CARD) become one, with every page's models to choose from (in order,
    without repeats, everyday looks first: see everyday_first). Its other details come from the
    page named like the card if there is one, otherwise the first; a note lists the pages."""
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
        if len(group) > 1:
            first["notes"] = [f"{len(group)} wiki pages: " + ", ".join(c["page"] for c in group)] + first["notes"]
        if len(models) > 1:
            first["notes"] = [f"{len(models)} models (Next model); first is {models[0]}"] + first["notes"]
        out.append(first)
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


def npc_rarity(page, fields, character, named):
    """A guess at an NPC's rarity, and why: the "Guidelines for NPCs" in CONTRIBUTING.md, which
    follow the deck's own cards (keep the two the same). `character` is whether the wiki files it
    as a character, `named` whether its name is a person's rather than a role's (see is_role).
    Spawns are the spawn points in the page's location table (monsters), or the pins on its maps
    (NPCs). A quest is one linked in the infobox, or a "Characters in <quest>" category."""
    categories = page.get("categories", [])
    text = page.get("text", "")

    def number(value):
        found = re.search(r"\d+", value or "")
        return int(found.group()) if found else 0

    level = number(first_version(fields, "level") or first_version(fields, "combat"))
    slayer = number(fields.get("slaylvl"))
    quests = set(links(" ".join(numbered_fields(fields, "quest"))))
    quests |= {c[len("Characters in "):] for c in categories if c.startswith("Characters in ")}
    # Each location row (LocLine) and each map lists its spawn points as x:..,y:.. (or x=..).
    location_rows = " ".join(re.findall(r"\{\{\s*LocLine.*?\}\}", text, re.S))
    maps = " ".join(numbered_fields(fields, "map"))
    spawns = len(re.findall(r"\bx\s*[:=]\s*\d+", location_rows or maps))
    royalty = any(c in ("Monarchs", "Royalty") for c in categories)
    skill_master = "Skill masters" in categories
    slayer_master = "Slayer Master" in categories

    if any("boss" in c.lower() for c in categories):
        return ("legendary", f"a boss of combat level {level}") if level >= 200 else ("epic", "a boss")
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
        if not quests:
            return "common", "a named character in no quests"
        return "uncommon", f"a named character in {len(quests)} quests"
    if character and len(quests) >= 3:
        return "uncommon", f"a role in {len(quests)} quests"
    if slayer >= 5:
        return "uncommon", f"a Slayer monster of level {slayer}" + (f" with {spawns} spawns" if slayer >= 10 else "")
    if spawns >= 60:
        return "common", f"{spawns} spawns"
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
    if not configs:
        return None, "no NPC id the plugin knows" if ids else "no NPC id on the page"
    name, desc = name_and_desc(page, fields, notes, versions_merge=True)
    name = SAME_CARD.get(name, name)

    tags = {}
    region = slug(plain(first_version(fields, "leagueregion")))
    region = REGION_ALIASES.get(region, region)
    if region in words["regions"]:
        tags["regions"] = [region]
    else:
        notes.append("region unknown: choose the deck file")

    # The location words for the place in the page title's brackets ("Guard (Catherby)",
    # "Lumbridge guardsman (Lumbridge Market)") and the places the infobox links to (Lumbridge
    # Castle -> lumbridge). A bracketed place that isn't a word yet is suggested as a new one if
    # the page is filed under it (the Card Builder points that out); other unknown places are only
    # mentioned in a note, as the infobox often links to a shop or building rather than a town.
    def location_word(place):
        return place if place in words["location"] else max(
            (w for w in words["location"] if place.startswith(w + "_")), key=len, default=None)

    location_text = first_version(fields, "location")
    places = []
    bracket = title_bracket(page["title"])
    if bracket:
        place = slug(bracket)
        word = location_word(place)
        if word is None and place_in_brackets(page):
            word = place
            notes.append(f"new location word '{place}' (add it to Cards.tagWords.location, or change it)")
        if word:
            places.append(word)
    for target in links(location_text):
        word = location_word(slug(target))
        if word and word not in places:
            places.append(word)
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

    # A skill master's skill, from the skillcape they sell ("[[Defence cape]]" -> defence).
    shop = " ".join(numbered_fields(fields, "shop")).lower()
    skills = [s for s in words["skills"] if re.search(r"\b" + s + r" (?:master )?cape\b", shop)]
    if skills and "Skill masters" in page.get("categories", []):
        tags["skills"] = skills

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


def remembered_sources(args):
    """The categories and pages to make candidates from: this run's, added to the ones asked for
    before (unless --only), which are saved for next time."""
    saved = {"categories": [], "pages": []}
    if SOURCES.exists() and not args.forget:
        saved = json.loads(SOURCES.read_text(encoding="utf-8"))
    for key, new in (("categories", args.category), ("pages", args.page)):
        for item in new:
            if item not in saved[key]:
                saved[key].append(item)
    SOURCES.parent.mkdir(parents=True, exist_ok=True)
    SOURCES.write_text(json.dumps(saved, indent=1), encoding="utf-8")
    if args.only:
        return list(args.category), list(args.page)
    return saved["categories"], saved["pages"]


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


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    parser.add_argument("--category", action="append", default=[])
    parser.add_argument("--page", action="append", default=[])
    parser.add_argument("--contact", default="")
    parser.add_argument("--max-requests", type=int, default=30)
    parser.add_argument("--refresh", action="store_true")
    parser.add_argument("--only", action="store_true")
    parser.add_argument("--forget", action="store_true")
    parser.add_argument("--subcategories", action="append", default=[])
    args = parser.parse_args()
    if args.subcategories:
        return show_subcategories(args)
    if not args.category and not args.page and not SOURCES.exists():
        print(__doc__)
        return 1
    categories, page_titles = remembered_sources(args)
    if not categories and not page_titles:
        print("Nothing to fetch: give --category or --page.")
        return 1

    wiki = make_wiki(args)
    print("From:", ", ".join(categories + [f'page "{p}"' for p in page_titles]))
    # Each title, with the categories (or the page asked for) it came from, so the review window
    # can show one at a time.
    titles, sources = [], {}

    def add(title, source):
        if title not in sources:
            titles.append(title)
            sources[title] = []
        if source not in sources[title]:
            sources[title].append(source)

    for title in page_titles:
        add(title, title)
    for category in categories:
        # (--refresh only re-asks for this run's categories, not every remembered one)
        for title in category_pages(wiki, category, args.refresh and category in args.category):
            add(title, category)
    pages = fetch_pages(wiki, titles, args.refresh)

    names, words = npc_names(), allowed_words()
    found, skipped = [], {}
    for title in titles:
        page = pages.get(title)
        if page is None:
            continue
        made, reason = candidate(page, names, words)
        if made is not None:
            made["sources"] = sources[title]
            found.append(made)
        else:
            skipped[reason] = skipped.get(reason, 0) + 1
    found = merge_versions(found)
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
