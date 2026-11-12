#!/usr/bin/env python3
"""Writes dev/clue_tiers.json: the clue tier of each treasure trail card.

    python dev/clue_tiers.py            write dev/clue_tiers.json from the wiki cache (no wiki requests)

The tier is the LOWEST tier the item can be got from (owner, 2026-11-12: a reward from a hard and an elite clue
is rare, not epic). It comes from, in order:

1. The drop sources the wiki lists for the item (dev/wiki_cache/buckets/dropsline_rows.json, written by
   `python dev/wiki_cards.py --item-drops`): every "Reward casket (elite)" style source is a tier.
2. Failing that, the item's wiki page: its "Items that can be stored in the X treasure chest" category, or a
   "Clue scroll (hard)" / "Reward casket (easy)" link in the text.

A card with neither is left out and keeps the rarity from the rules (apply_rarity.py). Run
`python dev/apply_rarity.py` afterwards.
"""

import glob
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
ORDER = ["beginner", "easy", "medium", "hard", "elite", "master"]
NOTE = (
    "Clue tier of each treasure trail card: the lowest tier it comes from (its Reward casket drop sources, else its "
    "wiki page's treasure chest category or Clue scroll / Reward casket links). Cards missing here have no tier on the "
    "wiki and keep the rules rarity. Written by dev/clue_tiers.py, used by dev/apply_rarity.py."
)


def load_json(path):
    with open(path, encoding="utf-8") as f:
        return json.load(f)


def from_drops(rows, name):
    found = set()
    for source in rows.get(name.lower()) or []:
        m = re.match(r"Reward casket \((\w+)\)", source[0], re.I)
        if m and m.group(1).lower() in ORDER:
            found.add(m.group(1).lower())
    return found


def from_page(pages, name):
    page = pages.get(name.lower())
    if not page:
        return set()
    found = {m.group(1).lower() for cat in page["categories"]
             for m in [re.match(r"Items that can be stored in the (\w+) treasure chest", cat)] if m}
    found |= {m.group(1).lower() for m in re.finditer(
        r"\[\[(?:Clue scroll|Reward casket) \((beginner|easy|medium|hard|elite|master)\)", page["text"])}
    return {t for t in found if t in ORDER}


def main():
    cards = load_json(ROOT / "docs" / "cards.json")["cards"]
    rows = load_json(ROOT / "dev" / "wiki_cache" / "buckets" / "dropsline_rows.json")["rows"]
    pages = {}
    for f in glob.glob(str(ROOT / "dev" / "wiki_cache" / "pages" / "*.json")):
        page = load_json(f)
        pages[page["title"].lower()] = page
    mapped = {}
    if (ROOT / "dev" / "wiki_pages.json").exists():
        mapped = {k: v["page"] for k, v in load_json(ROOT / "dev" / "wiki_pages.json").items()
                  if isinstance(v, dict) and v.get("page")}
    tiers, by_drops, by_page, none = {}, 0, 0, []
    for c in cards:
        if c["kind"] != "item" or "treasure_trail" not in c["tags"].get("category", []):
            continue
        title = mapped.get(c["id"], c["name"])       # the wiki's name, where the card's is shortened
        found = from_drops(rows, title)
        if found:
            by_drops += 1
        else:
            found = from_page(pages, title)
            by_page += bool(found)
        if found:
            tiers[c["id"]] = min(found, key=ORDER.index)
        else:
            none.append(c["name"])
    body = {"_note": NOTE}
    for k in sorted(tiers):
        body[k] = tiers[k]
    text = json.dumps(body, indent=2, ensure_ascii=False).replace("\n", "\r\n") + "\r\n"
    with open(ROOT / "dev" / "clue_tiers.json", "w", encoding="utf-8", newline="") as f:
        f.write(text)
    print(f"{len(tiers)} tiers ({by_drops} from drop sources, {by_page} from the page); {len(none)} without:")
    print("  " + ", ".join(none))


if __name__ == "__main__":
    sys.exit(main())
