#!/usr/bin/env python3
"""Which wiki page each card comes from (dev/wiki_pages.json), and the card's picture on that page.

dev/wiki_pages.json maps a card id to the wiki page its data was taken from, and optionally the
wiki file to show on the card site when the page's own choice is wrong:

    "zanik": {"page": "Zanik"},
    "some_card": {"page": "Some page", "image": "File:Some picture.png"},

dev/card_queue.py adds each card it writes into a deck file (and resolves its picture, below).
Cards made before that are filled in once with --backfill. The card site (dev/build_site.py) uses the page to choose the card's
picture, best first:

  1. the entry's "image", if it has one;
  2. for a card built from scenery (art.model is set), the page's version with no NPC id ("id = no"),
     which is how the wiki lists a look that is scenery (The Spirit of Rhythm at its drums);
  3. the version whose NPC ids include the card's NPC (art.npc): Zanik's crossbow version, or a
     pet as it follows you (its pet infobox), not its item's icon;
  4. otherwise the card's name, as before, and last the page's first picture.

The wiki cache (dev/wiki_cache) is not in the repository, so --resolve writes the picture chosen
from each NPC card's page into its entry as "resolved", and the page's first picture as "first"
when that is another picture: a checkout without the cache uses those instead. --report says
when they are out of date (a card's art.npc changed).

    "richie": {"page": "Richie (NPC)", "resolved": "File:Richie (NPC).png"},
    "blazehound": {"page": "Blazehound", "resolved": "File:Blazehound adult.png", "first": "File:Baby-blazehound.png"},

    python dev/wiki_pages.py --backfill    add the cards with no entry yet, matched to the cached
                                           wiki pages by name and NPC id (no internet); never
                                           changes an entry; lists the cards it can't match
    python dev/wiki_pages.py --report      how each NPC card's picture would be chosen (no internet)
    python dev/wiki_pages.py --resolve     write each NPC card's picture from the cached pages into
                                           its entry, for a checkout without the cache (no internet)
"""

import argparse
import json
import re
import sys
from collections import namedtuple
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
PAGES_JSON = ROOT / "dev" / "wiki_pages.json"
PICTURE = re.compile(r"(?:(?:File|Image):)?\s*([^\[\]|{}<>=:\n]+?\.(?:png|gif|jpe?g|webp))", re.I)


def load():
    """{ card id: { "page", "image"?, "resolved"?, "first"? } }. Stops if the file can't be read,
    rather than have the next save write over every entry with only the new ones."""
    if not PAGES_JSON.exists():
        return {}
    try:
        return json.loads(PAGES_JSON.read_text(encoding="utf-8"))
    except ValueError as error:
        raise SystemExit(f"{PAGES_JSON} is not valid JSON ({error}): fix it (a merge "
                         "conflict?) and run again")


def save(pages):
    """Writes the file with one card to a line, in id order, so a change shows only that card."""
    lines = [f"  {json.dumps(cid)}: {json.dumps(pages[cid], ensure_ascii=False)}" for cid in sorted(pages)]
    PAGES_JSON.write_text("{\n" + ",\n".join(lines) + "\n}\n", encoding="utf-8")


def record(added):
    """Keeps the pages new cards came from, given as { card id: page }, and resolves their pictures
    from the wiki cache. A new card's id is in no deck file, so an entry it already has is left
    from a removed or renamed card, and is replaced."""
    new = {cid: page for cid, page in added.items() if page}
    if not new:
        return
    pages = load()
    pages.update({cid: {"page": page} for cid, page in new.items()})
    try:
        cards, npc_ids = deck_and_ids()
        resolve_entries(pages, [card for card in cards if card["id"] in new], npc_ids)
    except SystemExit as error:
        print(f"Could not resolve the new cards' pictures ({error}): run python dev/wiki_pages.py --resolve")
    save(pages)


# ---------------------------------------------------------------------------------------------
# The picture on a page
# ---------------------------------------------------------------------------------------------


def file_title(value):
    """An infobox image value ("[[File:Babe.png|300px]]", "Babe.png", "No") as "File:Babe.png", or None."""
    from wiki_cards import plain
    found = PICTURE.search(re.sub(r"<!--.*?-->", "", value or "", flags=re.S))
    if not found or plain(value).lower() in ("no", "none"):
        return None
    name = found.group(1).strip().replace("_", " ")
    return "File:" + name[:1].upper() + name[1:]


def versions(fields):
    """An infobox's versions as (NPC ids, "no id", picture): a field without its number is the
    value of every version that leaves it out."""
    from wiki_cards import all_ids, plain
    numbers = sorted({int(m.group(1)) for k in fields for m in [re.fullmatch(r"(?:version|id|image)(\d+)", k)] if m})
    out = []
    for n in numbers or [None]:
        own = lambda key: fields.get(key + ("" if n is None else str(n)), fields.get(key, ""))
        image = own("image") or fields.get("image", "")
        out.append((all_ids({"id": own("id"), "map": own("map")}), plain(own("id")).lower() == "no", file_title(image)))
    return out


def page_pictures(text):
    """Every version of every NPC, monster and pet infobox in a page's text, in order. A pet's
    infobox gives the pet as it follows you (not its item's icon), with its NPC ids as npcid."""
    from wiki_cards import find_templates, template_fields
    found = []
    for kind, inside in find_templates(text, ["Infobox NPC", "Infobox Monster", "Infobox Pet"], kinds=True):
        fields = template_fields(inside)
        if kind == "Infobox Pet":
            fields = {re.sub(r"^npcid(\d*)$", r"id\1", k): v for k, v in fields.items() if not re.fullmatch(r"id\d*", k)}
        found += versions(fields)
    return found


Choice = namedtuple("Choice", "file reason how default page")
# file: the picture chosen (or None); reason: entry, scenery, npc, resolved (no cached page: the
# entry's "resolved"), missing (the NPC is not on the page), none (no page, not an NPC); how: the
# same in words; default: the page's first picture (without the cached page, the entry's "first")


def chosen_picture(card, entry, found, npc_ids):
    """(file title, reason, how) for a card from its wiki_pages entry and its page's pictures
    (page_pictures, or None without the page): see Choice."""
    if entry and entry.get("image"):
        return entry["image"], "entry", "the entry's image"
    if (card.get("kind") or "npc") != "npc":
        return None, "none", "not an NPC: by name"
    if found is None:
        if entry and entry.get("resolved"):
            return entry["resolved"], "resolved", "the entry's resolved picture (no cached page)"
        return None, "none", "no page"
    art = card.get("art") or {}
    if art.get("model"):
        for _, no_id, picture in found:
            if no_id and picture:
                return picture, "scenery", "scenery: the page's version with no NPC id"
    npc_id = npc_ids.get(art.get("npc") or "")
    for ids, _, picture in found:
        if npc_id in ids and picture:
            return picture, "npc", f"NPC {npc_id}'s version"
    return None, "missing", (f"NPC {npc_id} not on the page" if npc_id else "no NPC id") + "; by name"


def page_default(found):
    """The first of a page's pictures (page_pictures), or None."""
    return next((picture for _, _, picture in found or [] if picture), None)


def choices(cards, entries, npc_ids, found=None):
    """{ card id: Choice } for the cards with an entry in dev/wiki_pages.json (`entries`), from the
    pages in the wiki cache (or `found`, from pictures_by_page). The card site (dev/build_site.py)
    and --report both use this."""
    if found is None:
        found = pictures_by_page({entries[c["id"]]["page"] for c in cards if c["id"] in entries})
    out = {}
    for card in cards:
        entry = entries.get(card["id"])
        if entry:
            pictures = found.get(entry["page"])
            default = page_default(pictures) if pictures is not None else entry.get("first") or entry.get("resolved")
            out[card["id"]] = Choice(*chosen_picture(card, entry, pictures, npc_ids), default, entry["page"])
    return out


def cached_pages():
    """Every page in the wiki cache, as { its own title: text }. (A page is cached under the title
    asked for, which for a redirect is not its own: "Lumbridge Guide" holds Lumbridge Sage.)"""
    from wiki_cards import CACHE
    return {title: json.loads((CACHE / "pages" / name).read_text(encoding="utf-8"))["text"]
            for title, name in cached_titles().items()}


def cached_titles():
    """{ a cached page's own title: its file in the cache's pages }. Kept in the cache as
    page_titles.json, and made again when a page is added or changed."""
    from wiki_cards import CACHE
    files = list((CACHE / "pages").glob("*.json"))
    if not files:
        return {}
    stamp = [len(files), max(path.stat().st_mtime_ns for path in files)]
    index = CACHE / "page_titles.json"
    try:
        kept = json.loads(index.read_text(encoding="utf-8"))
        if kept.get("stamp") == stamp:
            return kept["titles"]
    except (OSError, ValueError):
        pass
    titles = {}
    for path in files:
        try:
            page = json.loads(path.read_text(encoding="utf-8"))
        except ValueError:
            continue
        if page.get("title") and page.get("text") and not page.get("missing"):
            titles[page["title"]] = path.name
    index.write_text(json.dumps({"stamp": stamp, "titles": titles}), encoding="utf-8")
    return titles


def pictures_by_page(titles, texts=None):
    """{ title: its page_pictures } for the titles whose pages are in the wiki cache (or `texts`):
    under the title asked for, or else (a page reached by a redirect) its own (cached_titles)."""
    from wiki_cards import CACHE, read_cache
    found, own = {}, None
    for title in set(titles):
        text = (texts or {}).get(title) or (read_cache("pages", title) or {}).get("text")
        if not text and texts is None:
            own = cached_titles() if own is None else own
            if title in own:
                text = json.loads((CACHE / "pages" / own[title]).read_text(encoding="utf-8")).get("text")
        if text:
            found[title] = page_pictures(text)
    return found


# ---------------------------------------------------------------------------------------------
# Filling in the cards made before the file
# ---------------------------------------------------------------------------------------------


def candidate_pages():
    """{ card name (lower case): page } from dev/wiki_candidates.lua."""
    from build_site import read_lua
    path = ROOT / "dev" / "wiki_candidates.lua"
    if not path.exists():
        return {}
    return {(c.get("name") or "").lower(): c["page"] for c in read_lua(path).returned() or [] if c.get("page")}


def match(card, by_title, by_id, by_candidate, npc_ids):
    """The page a card most likely came from, or None: one listing its NPC id (named as the card if
    several do), else the page named as the card, else the candidate of that name."""
    from wiki_cards import strip_bracket
    name = (card.get("name") or card["id"]).lower()
    plain_name = strip_bracket(name)
    named = by_title.get(name)
    listing = by_id.get(npc_ids.get((card.get("art") or {}).get("npc") or ""), [])
    if listing:
        for title in listing:
            if title.lower() in (name, plain_name):
                return title
        if len(listing) == 1 and not named:
            return listing[0]
    return named or by_candidate.get(name)


def deck_and_ids():
    """(the live cards, { NPC config name: id })."""
    from build_site import load_deck
    from npc_looks import npc_ids
    cards, _, errors = load_deck()
    if errors:
        raise SystemExit("Cannot read the deck:\n  " + "\n  ".join(errors))
    return cards, npc_ids()


def backfill():
    cards, npc_ids = deck_and_ids()
    texts = cached_pages()
    found = pictures_by_page(texts, texts)
    by_title = {title.lower(): title for title in found}
    by_id = {}
    for title, pictures in found.items():
        for ids, _, _ in pictures:
            for npc_id in ids:
                if title not in by_id.setdefault(npc_id, []):
                    by_id[npc_id].append(title)
    by_candidate = candidate_pages()
    pages = load()
    added, unmatched = 0, []
    for card in cards:
        if card["id"] in pages:
            continue
        page = match(card, by_title, by_id, by_candidate, npc_ids)
        if page:
            pages[card["id"]] = {"page": page}
            added += 1
        else:
            unmatched.append(card)
    save(pages)
    print(f"{added} cards added, {len(pages)} in {PAGES_JSON.relative_to(ROOT)}, {len(unmatched)} not matched:")
    for card in unmatched:
        print(f"  {card['id']}  ({card.get('kind') or 'npc'}, {card['_file']})")


def resolve_entries(pages, cards, npc_ids, found=None):
    """Writes each NPC card's picture, chosen from its cached page (or `found`, from
    pictures_by_page), into its entry in `pages` ("resolved", and the page's first picture as
    "first" when that is another picture). An entry whose page is not cached is left alone.
    Returns (the ids changed, the ids not cached)."""
    npc_cards = [card for card in cards if card["id"] in pages and (card.get("kind") or "npc") == "npc"]
    if found is None:
        found = pictures_by_page({pages[card["id"]]["page"] for card in npc_cards})
    changed, uncached = [], []
    for card in npc_cards:
        cid, entry = card["id"], pages[card["id"]]
        pictures = found.get(entry["page"])
        if pictures is None:
            uncached.append(cid)
            continue
        # (without the entry's "image": the page's own choice)
        picture, reason, _ = chosen_picture(card, None, pictures, npc_ids)
        picture = picture if reason in ("npc", "scenery") else None
        first = page_default(pictures)
        new = {key: value for key, value in entry.items() if key not in ("resolved", "first")}
        if picture:
            new["resolved"] = picture
        if first and first != picture:
            new["first"] = first
        if new != entry:
            pages[cid] = new
            changed.append(cid)
    return changed, uncached


def resolve():
    cards, npc_ids = deck_and_ids()
    pages = load()
    changed, uncached = resolve_entries(pages, cards, npc_ids)
    save(pages)
    resolved = sum("resolved" in entry for entry in pages.values())
    print(f"{resolved} NPC cards resolved ({len(changed)} changed), {len(uncached)} with no cached page:")
    for cid in uncached:
        print(f"  {cid}")


def report():
    cards, npc_ids = deck_and_ids()
    pages = load()
    pictures = pictures_by_page({entry["page"] for entry in pages.values()})
    found = choices(cards, pages, npc_ids, pictures)
    tally = {}
    for card in cards:
        if (card.get("kind") or "npc") != "npc":
            continue
        choice = found.get(card["id"]) or Choice(None, "none", "no entry", None, None)
        tally[choice.reason] = tally.get(choice.reason, 0) + 1
        print(f"{card['id']}: {choice.file or '-'}  ({choice.how})")
    print()
    for reason, count in sorted(tally.items(), key=lambda kv: -kv[1]):
        print(f"{count:5}  {reason}")
    stale, _ = resolve_entries(dict(pages), cards, npc_ids, pictures)
    if stale:
        print(f"\n{len(stale)} entries' resolved pictures are out of date (run --resolve): {', '.join(stale[:10])}")


def main():
    sys.path.insert(0, str(ROOT / "dev"))
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--backfill", action="store_true", help="add the cards with no entry yet")
    parser.add_argument("--report", action="store_true", help="how each NPC card's picture would be chosen")
    parser.add_argument("--resolve", action="store_true", help="write each NPC card's picture into its entry")
    args = parser.parse_args()
    if args.backfill:
        backfill()
    elif args.report:
        report()
    elif args.resolve:
        resolve()
    else:
        parser.print_help()


if __name__ == "__main__":
    main()
