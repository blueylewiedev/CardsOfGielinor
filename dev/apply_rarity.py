#!/usr/bin/env python3
"""Gives every item card the rarity the wiki tool's rules suggest, then the pins.

    python dev/apply_rarity.py                  dry run: what would change, nothing written
    python dev/apply_rarity.py --apply          rewrite `rarity = "..."` on the item cards in deck/
    python dev/apply_rarity.py --csv FILE       also write every change, with its signals, to FILE

For each item card with a page in dev/wiki_cache this runs the wiki tool's own candidate() (the rules are
in dev/wiki_cards.py: item_rarity and what feeds it), with the Grand Exchange price from the cache, the
most common drop rate (dev/drop_items.json, else dev/wiki_cache/drops.json) and the shops
(dev/shop_items.json), and takes the rarity it suggests. Then:

- A pin in dev/rarity_pins.json (card id: rarity and why) replaces the rules' answer: it is for a
  rarity the wiki data cannot show (an effort, a tier of staff). Pins are kept when this is re-run.
- A card whose page gives no level, price, drop rate or source at all has nothing to work from, so it
  keeps its rarity, as does a card with no page in the cache, or one the tool skips. They are listed.

Only the rarity value on the card's line is changed (the file's line endings are kept). Run
python dev/build_site.py afterwards: docs/cards.json holds the rarities too.
"""

import argparse
import collections
import csv
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT / "dev"))
import wiki_cards as W

PINS = ROOT / "dev" / "rarity_pins.json"
ORDER = W.RARITIES


def page_names(name):
    """The titles a card's wiki page may have, in lower case: its own name, "OH" and "off hand" as
    "Off-hand", a ceremonial sword's "V" (its highest version), and without a bracket."""
    spelt = re.sub(r"\bOH\b", "Off-hand", name)
    spelt = re.sub(r"\boff hand\b", "Off-hand", spelt, flags=re.I)
    spelt = spelt[:1].upper() + spelt[1:]
    out = [name, spelt, re.sub(r"^Superior Off-hand ", "Superior off-hand ", spelt),
           re.sub(r"\s*\([^)]*\)$", "", name)]
    if "ceremonial sword" in spelt.lower() and not spelt.endswith(" V"):
        out.append(spelt + " V")
    out += {"Wilderness sword": ["Wilderness sword 4"], "Blisterwood crossbow": ["Blisterwood stake-thrower crossbow"],
            "coins": ["Coins"], "Rod of ivandis (1)": ["Rod of Ivandis"]}.get(name, [])
    return [title.lower() for title in dict.fromkeys(out)]


def cached_pages():
    pages = {}
    for path in (W.CACHE / "pages").glob("*.json"):
        try:
            page = json.loads(path.read_text(encoding="utf-8"))
        except ValueError:
            continue
        if page.get("title") and page.get("text") and not page.get("missing"):
            pages[page["title"].lower()] = page
    return pages


def work_out(cards):
    """({ card id: {the signals, "new", "by"} } for the cards that could be rated, { card id: why not }).
    "by" is "rules", "pin" or "no signal"."""
    pages = cached_pages()
    drops = json.loads(W.DROPS.read_text(encoding="utf-8")) if W.DROPS.exists() else {}
    pins = {k: v for k, v in json.loads(PINS.read_text(encoding="utf-8")).items() if not k.startswith("_")}
    names, words = W.npc_names(), W.allowed_words()
    seen = {}
    real = W.item_rarity

    def spy(**given):
        seen.clear()
        seen.update(given)
        result = real(**given)
        seen["new"], seen["why"] = result
        return result

    W.item_rarity = spy
    rated, left = {}, {}
    try:
        for card in cards:
            if card["id"] in pins:
                rated[card["id"]] = {"new": pins[card["id"]]["rarity"], "by": "pin"}
                continue
            page = next((pages[title] for title in page_names(card["name"]) if title in pages), None)
            if page is None:
                left[card["id"]] = "no page in the cache"
                continue
            fields = W.template_fields(W.find_template(page["text"], ["Infobox Item"])[1] or "")
            price_name = W.price_name(fields, page["title"])
            cached = W.read_cache("prices", price_name) if price_name else None
            seen.clear()
            try:
                made, reason = W.candidate(page, names, words, cached.get("price") if cached else None,
                                           W.common_drop(page["title"], drops))
            except Exception as error:      # a page the wiki tool cannot read
                made, reason = None, f"the wiki tool cannot read it ({type(error).__name__})"
            if made is None or "new" not in seen:
                left[card["id"]] = f"the wiki tool skips it: {reason}"
            elif seen["why"] == ["no signal"]:
                rated[card["id"]] = dict(seen, new=card["rarity"], by="no signal")
            else:
                rated[card["id"]] = dict(seen, by="rules")
    finally:
        W.item_rarity = real
    return rated, left


def rewrite_deck(new):
    """Sets rarity = "..." on each card in `new` ({ id: rarity }) in the deck files. Returns the ids done."""
    done = set()
    for path in sorted((ROOT / "deck").rglob("*.lua")):
        raw = path.read_bytes().decode("utf-8")
        crlf = "\r\n" in raw
        text = raw.replace("\r\n", "\n")
        changed = False
        for cid in [c for c in new if f'id = "{c}"' in text]:
            pattern = re.compile(r'(\bid = "' + re.escape(cid) + r'"[^\n]*?\brarity = ")(\w+)(")')
            if len(pattern.findall(text)) != 1:
                raise SystemExit(f"{path.name}: cannot find the rarity of {cid}")
            text = pattern.sub(lambda m: m.group(1) + new[cid] + m.group(3), text)
            done.add(cid)
            changed = True
        if changed:
            path.write_bytes((text.replace("\n", "\r\n") if crlf else text).encode("utf-8"))
    return done


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--apply", action="store_true", help="rewrite the deck files")
    parser.add_argument("--csv", help="write every change, with its signals, to this file")
    args = parser.parse_args()
    cards = [c for c in json.loads((ROOT / "docs" / "cards.json").read_text(encoding="utf-8"))["cards"]
             if c["kind"] == "item"]
    rated, left = work_out(cards)
    old = {c["id"]: c["rarity"] for c in cards}
    name = {c["id"]: c["name"] for c in cards}
    changes = {cid: r["new"] for cid, r in rated.items() if r["new"] != old[cid]}

    share = collections.Counter(r["new"] for r in rated.values())
    print(f"{len(cards)} item cards: {len(rated)} rated, {len(left)} left as they are")
    print("  from the rules:", sum(r["by"] == "rules" for r in rated.values()),
          "| pinned:", sum(r["by"] == "pin" for r in rated.values()),
          "| no signal, kept:", sum(r["by"] == "no signal" for r in rated.values()))
    print("  new spread:", ", ".join(f"{k} {100 * share[k] / len(rated):.1f}%" for k in ORDER))
    moves = collections.Counter((old[c], new) for c, new in changes.items())
    print(f"  {len(changes)} cards change:")
    for (before, after), n in sorted(moves.items(), key=lambda kv: (ORDER.index(kv[0][0]), ORDER.index(kv[0][1]))):
        print(f"    {before:9} -> {after:9} {n}")
    if left:
        print("  left as they are:", "; ".join(f"{name[c]} ({why})" for c, why in left.items()))

    if args.csv:
        with open(args.csv, "w", newline="", encoding="utf-8") as out:
            writer = csv.writer(out)
            writer.writerow(["id", "name", "old", "new", "by", "level", "price", "drop", "shop", "easiest_drop_source", "reasons"])
            for cid in sorted(changes, key=lambda c: (ORDER.index(old[c]) - ORDER.index(changes[c]), name[c])):
                r = rated[cid]
                writer.writerow([cid, name[cid], old[cid], r["new"], r["by"], r.get("level"), r.get("price"), r.get("drop"),
                                 r.get("shop"), json.dumps(r.get("source")) if r.get("source") else "", "; ".join(r.get("why", []))])
        print("  changes written to", args.csv)
    if args.apply:
        done = rewrite_deck(changes)
        print(f"{len(done)} cards rewritten in deck/. Now run: python dev/build_site.py")
    else:
        print("(dry run: nothing written; add --apply to rewrite the deck)")


if __name__ == "__main__":
    main()
