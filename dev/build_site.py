#!/usr/bin/env python3
"""Builds the card browser website (docs/) from the deck files.

    python dev/build_site.py              write docs/cards.json from the deck files (no internet needed)
    python dev/build_site.py --images     first fetch the card pictures the site does not have yet from
                                          the RuneScape Wiki (politely, see below), then write cards.json
    python dev/build_site.py --check      fail if docs/cards.json is out of date (what CI can run)

The site itself is docs/index.html, docs/app.js and docs/style.css: plain files with no build step,
so GitHub Pages can serve the docs folder as it is (Settings > Pages > Deploy from a branch >
main > /docs). Run this script again whenever the deck changes and commit docs/cards.json.

The cards are read straight from the Lua files with a small parser here, so this needs nothing but
Python 3. Drafts (cards whose art is still empty) are left out, as they are in the game. The
rarity colours and each themed pack's cards come from core/cards.lua and deck/packs.lua.

PICTURES. The site shows the wiki's picture of the item (File:<name> detail.png) or the NPC
(File:<name>.png, then <name> chathead.png), saved on your own computer in docs/img/ (not committed:
it is big and changes on every rebuild, see dev/HANDOVER_site_pictures.md), so visitors never load
anything from the wiki once that folder is published. They are
asked for the way dev/wiki_cards.py asks for pages: a User-Agent with a way to contact you (--contact,
or the first line of dev/wiki_contact.txt, e.g. "@yourname on Discord"), at most one request every two
seconds, maxlag, waiting when the wiki says so, up to 50 pictures looked up per request, and a limit on the
requests each run makes (--max-requests, default 200; run it again to carry on, what was fetched is
kept). A picture is only fetched once: docs/img/images.json remembers each card's, and the cards
the wiki had no picture for (they show a placeholder), until you use --refresh-images. The wiki's
text and pictures are CC BY-NC-SA, so the site credits the wiki and links each picture's file page.

ITEM PICTURES are kept twice: as the wiki has them in dev/wiki_cache/img_raw/ (not committed), and
processed in docs/img/ (dev/site_images.py: a weapon that is long and thin is turned to the diagonal,
then every picture is trimmed, scaled and centred on a canvas of one size). Processing needs Pillow and
no internet, so it can be tuned and run again as often as wanted:
    python dev/build_site.py --hires      fetch the full size pictures of the items that only have a
                                          small thumbnail (once; the same politeness), then process them
    python dev/build_site.py --process    process the saved full size pictures again (no internet)
"""

import argparse
import json
import re
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DECK = ROOT / "deck"
DOCS = ROOT / "docs"
IMG = DOCS / "img"
IMAGES_JSON = IMG / "images.json"
CARDS_JSON = DOCS / "cards.json"
IMAGE_WIDTH = 160           # the NPC thumbnails' width in pixels (the cards show them at about 120)
RAW = ROOT / "dev" / "wiki_cache" / "img_raw"    # the item pictures as the wiki has them (not committed)
RAW_WIDTH = 480             # an item picture wider than this is asked for scaled down to it
LOOKUP_BATCH = 50           # file titles per API request (the most the API allows)
WIKI_PAGE = "https://runescape.wiki/w/"


# ---------------------------------------------------------------------------------------------
# A reader for the Lua data in the deck files: tables, strings, numbers, true/false/nil. Nothing
# else is allowed (a card file holds data, not code), so anything else is reported with its place.
# ---------------------------------------------------------------------------------------------


class LuaError(Exception):
    pass


class LuaReader:
    def __init__(self, text, name):
        self.text, self.pos, self.name = text, 0, name

    def fail(self, message):
        line = self.text.count("\n", 0, self.pos) + 1
        raise LuaError(f"{self.name} line {line}: {message}")

    def skip(self):
        text = self.text
        while self.pos < len(text):
            ch = text[self.pos]
            if ch in " \t\r\n":
                self.pos += 1
            elif text.startswith("--", self.pos):
                if text.startswith("--[[", self.pos):
                    end = text.find("]]", self.pos)
                    self.pos = len(text) if end < 0 else end + 2
                else:
                    end = text.find("\n", self.pos)
                    self.pos = len(text) if end < 0 else end
            else:
                return

    def value(self):
        self.skip()
        text = self.text
        ch = text[self.pos] if self.pos < len(text) else ""
        if ch == "{":
            return self.table()
        if ch in "\"'":
            return self.string()
        match = re.compile(r"-?0[xX][0-9a-fA-F]+|-?\d+\.?\d*(?:[eE][-+]?\d+)?|-?\.\d+").match(text, self.pos)
        if match:
            self.pos = match.end()
            token = match.group()
            return int(token, 16) if "x" in token.lower() else (float(token) if re.search(r"[.eE]", token) else int(token))
        word = re.compile(r"[A-Za-z_]\w*").match(text, self.pos)
        if word and word.group() in ("true", "false", "nil"):
            self.pos = word.end()
            return {"true": True, "false": False, "nil": None}[word.group()]
        self.fail(f"cannot read a value here: {text[self.pos:self.pos + 30]!r}")

    def string(self):
        quote = self.text[self.pos]
        self.pos += 1
        out = []
        escapes = {"n": "\n", "t": "\t", "r": "\r", "\\": "\\", '"': '"', "'": "'"}
        while self.pos < len(self.text):
            ch = self.text[self.pos]
            if ch == quote:
                self.pos += 1
                return "".join(out)
            if ch == "\\":
                self.pos += 1
                nxt = self.text[self.pos]
                if nxt.isdigit():
                    match = re.compile(r"\d{1,3}").match(self.text, self.pos)
                    out.append(chr(int(match.group())))
                    self.pos = match.end()
                    continue
                out.append(escapes.get(nxt, nxt))
            else:
                out.append(ch)
            self.pos += 1
        self.fail("a string is not closed")

    def table(self):
        """A table: a dict if it has any name = value field, otherwise a list."""
        self.pos += 1
        items, named = [], {}
        while True:
            self.skip()
            if self.pos >= len(self.text):
                self.fail("a table is not closed")
            if self.text[self.pos] == "}":
                self.pos += 1
                break
            key = re.compile(r"([A-Za-z_]\w*)\s*=(?!=)").match(self.text, self.pos)
            if key:
                self.pos = key.end()
                named[key.group(1)] = self.value()
            elif self.text[self.pos] == "[":
                self.pos += 1
                key_value = self.value()
                self.skip()
                if self.text[self.pos] != "]":
                    self.fail("expected ]")
                self.pos += 1
                self.skip()
                if self.text[self.pos] != "=":
                    self.fail("expected =")
                self.pos += 1
                named[key_value] = self.value()
            else:
                items.append(self.value())
            self.skip()
            if self.pos < len(self.text) and self.text[self.pos] in ",;":
                self.pos += 1
        if named:
            if items:
                named["_list"] = items
            return named
        return items

    def assigned(self, target):
        """The value of the first `target = ...` in the text."""
        for match in re.finditer(r"(?<![\w.])" + re.escape(target) + r"\s*=\s*", self.text):
            line_start = self.text.rfind("\n", 0, match.start()) + 1
            if "--" in self.text[line_start:match.start()]:
                continue                      # inside a comment
            self.pos = match.end()
            return self.value()
        return None

    def returned(self):
        """The value after the last top level `return`."""
        found = list(re.finditer(r"(?m)^return\s+", self.text))
        if not found:
            return None
        self.pos = found[-1].end()
        return self.value()


def read_lua(path):
    return LuaReader(path.read_text(encoding="utf-8-sig"), str(path.relative_to(ROOT)))


# ---------------------------------------------------------------------------------------------
# The deck
# ---------------------------------------------------------------------------------------------


def listed_files():
    text = (DECK / "index.lua").read_text(encoding="utf-8")
    text = "\n".join(line.split("--", 1)[0] for line in text.splitlines())
    return re.findall(r'"([^"]+)"', text)


def words(text):
    return " ".join(part.capitalize() for part in text.split("_"))


def collection_name(set_name):
    """deck/items/weapons/daggers -> "Weapons: Daggers"; deck/npcs/karamja -> "NPCs: Karamja"."""
    parts = set_name.split("/")[1:]
    if parts[0] == "npcs":
        return "NPCs: " + words(parts[-1])
    rest = parts[1:]
    if len(rest) == 1:
        return "Items: " + words(rest[0])
    return f"{words(rest[0])}: {words(rest[-1])}"


def add_tags(card, tags):
    """Adds tags to a card without removing its own (the plugin's addTags)."""
    mine = card.setdefault("tags", {})
    for kind, found in tags.items():
        have = mine.setdefault(kind, [])
        for word in found:
            if word not in have:
                have.append(word)


def is_draft(card):
    art = card.get("art")
    if art is None:
        return False
    if card.get("kind") == "item":
        return art.get("item") == ""
    return art.get("npc") == ""


def rarity_table():
    reader = read_lua(ROOT / "core" / "cards.lua")
    rarities = reader.assigned("Cards.rarities")
    order = reader.assigned("Cards.rarityOrder")
    out = []
    for key in order:
        entry = rarities[key]
        colour = entry["colour"] >> 8            # 0xRRGGBBAA -> RRGGBB
        out.append({"id": key, "name": entry["name"], "colour": "#%06x" % colour})
    return out


def load_deck():
    """Returns (cards, draft count, errors): the live cards in the plugin's order."""
    cards, drafts, errors = [], 0, []
    for set_name in listed_files():
        path = ROOT / (set_name + ".lua")
        if not path.is_file():
            errors.append(f"{set_name}.lua does not exist")
            continue
        try:
            reader = read_lua(path)
            defaults = reader.assigned("Set.defaults")
            found = reader.assigned("Set.cards") or []
        except LuaError as error:
            errors.append(str(error))
            continue
        for card in found:
            if not isinstance(card, dict) or "id" not in card:
                errors.append(f"{set_name}.lua: a card without an id")
                continue
            if defaults:
                add_tags(card, defaults)
            card["_collection"] = collection_name(set_name)
            card["_file"] = set_name + ".lua"
            if is_draft(card):
                drafts += 1
            else:
                cards.append(card)
    rank = {key["id"]: n for n, key in enumerate(rarity_table())}
    position = {id(card): n for n, card in enumerate(cards)}
    cards.sort(key=lambda c: (rank.get(c.get("rarity"), 0), position[id(c)]))
    return cards, drafts, errors


def matches(card, filt):
    """The plugin's Cards.matches."""
    if not filt:
        return True
    for key, wanted in filt.items():
        wanted = wanted if isinstance(wanted, list) else [wanted]
        if key == "kind":
            hit = (card.get("kind") or "npc") in wanted
        else:
            hit = any(w in (card.get("tags") or {}).get(key, []) for w in wanted)
        if not hit:
            return False
    return True


def load_packs(cards, rarities):
    packs = []
    rank = {r["id"]: n for n, r in enumerate(rarities)}
    for entry in read_lua(DECK / "packs.lua").returned() or []:
        filt = entry.get("filter")
        lowest = rank.get(entry.get("minRarity"), 0)
        ids = [c["id"] for c in cards if matches(c, filt) and rank.get(c.get("rarity"), 0) >= lowest]
        packs.append({"id": entry["id"], "name": entry.get("name") or entry["id"], "cards": ids})
    return packs


def export(cards, images):
    out = []
    for n, card in enumerate(cards):
        tags = {kind: list(found) for kind, found in (card.get("tags") or {}).items() if found}
        entry = {"id": card["id"], "name": card.get("name") or card["id"], "kind": card.get("kind") or "npc",
                 "rarity": card.get("rarity") or "common", "desc": card.get("desc") or "",
                 "tags": tags, "collection": card["_collection"], "file": card["_file"], "order": n}
        if card.get("variants"):
            entry["variants"] = len(card["variants"])
        found = images.get("cards", {}).get(card["id"])
        if found and found.get("name") == entry["name"]:
            entry["img"] = "img/" + found["file"]
            entry["imgPage"] = found["title"]
        out.append(entry)
    return out


def build(images):
    rarities = rarity_table()
    cards, drafts, errors = load_deck()
    if errors:
        raise SystemExit("Cannot read the deck:\n  " + "\n  ".join(errors))
    data = {"rarities": rarities, "drafts": drafts, "cards": export(cards, images),
            "packs": load_packs(cards, rarities)}
    # (the same cards in the same order give the same file, so a change shows only what changed)
    return json.dumps(data, ensure_ascii=False, indent=1) + "\n"


# ---------------------------------------------------------------------------------------------
# The pictures, fetched politely
# ---------------------------------------------------------------------------------------------


def read_images():
    try:
        return json.loads(IMAGES_JSON.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {"cards": {}, "missing": {}}


def write_images(images):
    IMG.mkdir(parents=True, exist_ok=True)
    IMAGES_JSON.write_text(json.dumps(images, ensure_ascii=False, indent=1, sort_keys=True) + "\n", encoding="utf-8")


OFF_HAND = re.compile(r"\boff[ -]?hand\b|\bOH\b", re.I)


def spellings(name):
    """The other ways the wiki may spell an item's name, best first (without the name itself): "OH" and
    "off hand" as "off-hand", the off-hand word after the metal ("Off-hand bathus longsword" is
    "Bathus off-hand longsword" on the wiki), and last the main hand item, whose picture is the
    same weapon ("Bathus longsword")."""
    if not OFF_HAND.search(name):
        return []
    words = [w for w in OFF_HAND.sub(" ", name).split() if w]
    hyphen = OFF_HAND.sub("off-hand", name)
    out = [hyphen[:1].upper() + hyphen[1:]]
    # (the words before it are the metal or tier; "Superior OH dragon longsword" has two)
    keep = 2 if words[0].lower() == "superior" else 1
    if len(words) > keep and words[keep].lower() not in ("of", "the"):
        moved = " ".join(words[:keep] + ["off-hand"] + words[keep:])
        out.append(moved[:1].upper() + moved[1:])
    out.append(" ".join(words)[:1].upper() + " ".join(words)[1:])
    return [n for n in dict.fromkeys(out) if n != name]


def file_candidates(card):
    """The file names to try for a card's picture, best first."""
    name = card.get("name") or card["id"]
    bases = [name]
    plain = re.sub(r"\s*\([^)]*\)$", "", name).strip()
    if plain and plain != name:
        bases.append(plain)
    if (card.get("kind") or "npc") == "item":
        bases += [s for b in list(bases) for s in spellings(b) if s not in bases]
        return [f"{b} detail.png" for b in bases]
    return [f"{b}.png" for b in bases] + [f"{b} chathead.png" for b in bases]


def download(wiki, url):
    """One picture, as polite as an API request (same gap, same limit, same User-Agent). None if
    the request limit is used up."""
    for attempt in range(4):
        if wiki.left <= 0:
            return None
        wait = wiki.last + 2.0 - time.monotonic()
        if wait > 0:
            time.sleep(wait)
        wiki.left -= 1
        wiki.last = time.monotonic()
        request = urllib.request.Request(url, headers={"User-Agent": wiki.agent})
        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                return response.read()
        except urllib.error.HTTPError as error:
            if error.code in (429, 503) and attempt < 3:
                delay = int(error.headers.get("Retry-After") or 30)
                print(f"  the wiki asked us to wait ({error.code}); waiting {delay}s")
                time.sleep(delay)
                continue
            raise
    return None


def look_up(wiki, titles, width=IMAGE_WIDTH):
    """{ requested title: (file title, thumbnail url, mime, the picture's own width, height) } for the
    titles that exist. The thumbnail is `width` wide, or the picture itself if that is narrower."""
    answer = wiki.get({"action": "query", "titles": "|".join(titles), "prop": "imageinfo",
                       "iiprop": "url|mime|size", "iiurlwidth": str(width)})
    if answer is None:
        return None
    query = answer.get("query", {})
    renamed = {n["from"]: n["to"] for n in query.get("normalized", [])}
    found = {}
    for page in query.get("pages", []):
        info = (page.get("imageinfo") or [None])[0]
        if page.get("missing") or not info:
            continue
        found[page["title"]] = (page["title"], info.get("thumburl") or info.get("url"), info.get("mime", ""),
                                info.get("width", 0), info.get("height", 0))
    return {title: found.get(renamed.get(title, title)) for title in titles}


def fetch_images(cards, wiki, refresh):
    images = read_images()
    have, missing = images.setdefault("cards", {}), images.setdefault("missing", {})
    todo = []
    for card in cards:
        name = card.get("name") or card["id"]
        done = have.get(card["id"])
        if done and done.get("name") == name and (IMG / done["file"]).exists() and not refresh:
            continue
        tried = missing.get(card["id"], {})
        if tried.get("name") == name and not refresh and set(file_candidates(card)) <= set(tried.get("tried", [])):
            continue
        todo.append(card)
    print(f"{len(cards)} cards, {len(cards) - len(todo)} with a picture or known to have none, {len(todo)} to look up")
    pending = {card["id"]: card for card in todo}
    kinds = {card["id"]: card.get("kind") or "npc" for card in todo}
    saved = 0
    tries = {card["id"]: file_candidates(card) for card in todo}
    for round_number in range(max((len(t) for t in tries.values()), default=0)):
        asking = [(cid, tries[cid][round_number]) for cid in pending if round_number < len(tries[cid])]
        if not asking:
            break
        for is_item in (True, False):
            # (items are asked for at full size and processed, the NPCs as small thumbnails)
            part = [(cid, file) for cid, file in asking if (kinds[cid] == "item") == is_item]
            for start in range(0, len(part), LOOKUP_BATCH):
                batch = part[start:start + LOOKUP_BATCH]
                found = look_up(wiki, ["File:" + file for _, file in batch], RAW_WIDTH if is_item else IMAGE_WIDTH)
                if found is None:
                    print("request limit reached: run again to carry on")
                    write_images(images)
                    return images
                for cid, file in batch:
                    hit = found.get("File:" + file)
                    if not hit or cid not in pending:
                        continue
                    title, url, mime = hit[:3]
                    data = download(wiki, url)
                    if data is None:
                        print("request limit reached: run again to carry on")
                        write_images(images)
                        return images
                    suffix = ".gif" if "gif" in mime else (".jpg" if "jpeg" in mime else ".png")
                    entry = {"file": cid + suffix, "title": title, "name": pending[cid].get("name") or cid}
                    if is_item:
                        RAW.mkdir(parents=True, exist_ok=True)
                        (RAW / (cid + suffix)).write_bytes(data)
                        entry["raw"] = cid + suffix
                        have[cid] = entry
                        process_card(pending[cid], entry)
                    else:
                        IMG.mkdir(parents=True, exist_ok=True)
                        (IMG / (cid + suffix)).write_bytes(data)
                        have[cid] = entry
                    missing.pop(cid, None)
                    pending.pop(cid)
                    saved += 1
                write_images(images)
    for cid, card in pending.items():
        missing[cid] = {"name": card.get("name") or cid, "tried": tries[cid]}
    write_images(images)
    print(f"{saved} pictures saved, {len(pending)} cards have none on the wiki")
    return images


def process_card(card, entry):
    """Makes the site's picture of an item from its full size one (dev/site_images.py), and points
    the card's entry at it. Returns what was done to it, or None without a full size picture."""
    raw = RAW / entry.get("raw", "")
    if not entry.get("raw") or not raw.exists():
        return None
    sys.path.insert(0, str(ROOT / "dev"))
    import site_images
    category = list((card.get("tags") or {}).get("category") or [])
    done, note = site_images.process(raw, category, "weapon" in category, card["id"])
    IMG.mkdir(parents=True, exist_ok=True)
    target = IMG / (card["id"] + ".png")
    done.save(target, optimize=True)
    if entry["file"] != target.name and (IMG / entry["file"]).exists():
        (IMG / entry["file"]).unlink()
    entry["file"] = target.name
    entry["processed"] = True
    return note


def process_all(cards, images):
    """Processes every item that has a full size picture saved (no internet needed)."""
    done = turned = 0
    for card in cards:
        entry = images.get("cards", {}).get(card["id"])
        if (card.get("kind") or "npc") != "item" or not entry or not entry.get("raw"):
            continue
        note = process_card(card, entry)
        if note is not None:
            done += 1
            turned += "turned" in note
            if note:
                print(f"  {card['id']}: {note}")
    write_images(images)
    print(f"{done} item pictures processed, {turned} of them turned")


def fetch_hires(cards, wiki, images):
    """Fetches the full size picture of each item that has only a small thumbnail so far, and
    saves it in RAW. A picture the wiki has no bigger than the thumbnail is copied instead."""
    have = images.setdefault("cards", {})
    todo = [(card, have[card["id"]]) for card in cards
            if (card.get("kind") or "npc") == "item" and card["id"] in have
            and not (RAW / have[card["id"]].get("raw", "-")).exists()]
    print(f"{len(todo)} item pictures to fetch at full size")
    RAW.mkdir(parents=True, exist_ok=True)
    got = copied = 0
    for start in range(0, len(todo), LOOKUP_BATCH):
        batch = todo[start:start + LOOKUP_BATCH]
        found = look_up(wiki, [entry["title"] for _, entry in batch], RAW_WIDTH)
        if found is None:
            print("request limit reached: run again to carry on")
            break
        for card, entry in batch:
            hit = found.get(entry["title"])
            if not hit:
                print(f"  {card['id']}: the wiki no longer has {entry['title']}")
                continue
            _, url, mime, native_w, native_h = hit
            suffix = ".gif" if "gif" in mime else (".jpg" if "jpeg" in mime else ".png")
            name = card["id"] + suffix
            stored = IMG / entry["file"]
            from PIL import Image
            with Image.open(stored) as small:
                small_w, small_h = small.size
            if not entry.get("processed") and native_w <= small_w and native_h <= small_h:
                (RAW / name).write_bytes(stored.read_bytes())      # (the thumbnail is the whole picture)
                copied += 1
            else:
                data = download(wiki, url)
                if data is None:
                    print("request limit reached: run again to carry on")
                    write_images(images)
                    print(f"{got} fetched, {copied} copied")
                    return
                (RAW / name).write_bytes(data)
                got += 1
                if got % 25 == 0:
                    print(f"  {got} fetched")
            entry["raw"] = name
        write_images(images)
    write_images(images)
    print(f"{got} fetched, {copied} copied")


def make_wiki(args):
    sys.path.insert(0, str(ROOT / "dev"))
    import wiki_cards
    contact = args.contact
    if not contact and wiki_cards.CONTACT_FILE.exists():
        contact = (wiki_cards.CONTACT_FILE.read_text(encoding="utf-8-sig").strip().splitlines() or [""])[0].strip()
    if not contact:
        print("No contact given: please pass --contact or put one in dev/wiki_contact.txt, so the wiki's"
              " admins can reach you if anything goes wrong.")
    return wiki_cards.Wiki(contact, args.max_requests)


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--images", action="store_true", help="fetch the pictures not saved yet from the wiki")
    parser.add_argument("--refresh-images", action="store_true", help="with --images: look every card's picture up again")
    parser.add_argument("--hires", action="store_true", help="fetch the full size pictures of the items that only have a thumbnail, then process them")
    parser.add_argument("--process", action="store_true", help="process the saved full size item pictures again (no internet)")
    parser.add_argument("--contact", default="", help="how the wiki's admins can reach you (added to the User-Agent)")
    parser.add_argument("--max-requests", type=int, default=200, help="the most requests a run of --images makes (each picture is one, plus one per 50 looked up)")
    parser.add_argument("--check", action="store_true", help="only check that docs/cards.json is up to date")
    args = parser.parse_args()

    if args.hires or args.process:
        cards, _, errors = load_deck()
        if errors:
            raise SystemExit("Cannot read the deck:\n  " + "\n  ".join(errors))
        images = read_images()
        if args.hires:
            wiki = make_wiki(args)
            fetch_hires(cards, wiki, images)
            print(f"{args.max_requests - wiki.left} requests made")
        process_all(cards, images)
    elif args.images:
        cards, _, errors = load_deck()
        if errors:
            raise SystemExit("Cannot read the deck:\n  " + "\n  ".join(errors))
        wiki = make_wiki(args)
        images = fetch_images(cards, wiki, args.refresh_images)
        print(f"{args.max_requests - wiki.left} requests made")
    else:
        images = read_images()
    text = build(images)
    if args.check:
        current = CARDS_JSON.read_text(encoding="utf-8") if CARDS_JSON.exists() else ""
        if current != text:
            print("docs/cards.json is out of date: run  python dev/build_site.py  and commit it.")
            return 1
        print("docs/cards.json is up to date.")
        return 0
    DOCS.mkdir(exist_ok=True)
    CARDS_JSON.write_text(text, encoding="utf-8")
    data = json.loads(text)
    print(f"docs/cards.json: {len(data['cards'])} cards ({data['drafts']} drafts left out), {len(data['packs'])} packs")
    return 0


if __name__ == "__main__":
    sys.exit(main())
