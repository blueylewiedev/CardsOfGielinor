#!/usr/bin/env python3
"""Lookalike NPCs: versions of one NPC that share its name and look the same become one card.

The rule (CONTRIBUTING, "Which NPCs get a card"): an NPC whose name is another card's with a bracket added
("Hellhound (God Wars Dungeon)" next to "Hellhound") and whose look is the same (the same models, recolours,
retextures and size in the client's cache) is not a card of its own. Its config is added to that card's
`variants` instead, and its places to the card's locations. Versions that look different keep their own card
("Cyclops (God Wars Dungeon)"), and so do NPCs with a different name (Hellhound Hunter), pets (rated by how they
are got) and roles (each "Wizard (...)" is someone else).

Used by dev/wiki_cards.py (a candidate that is such a version is named like the card, with a note) and
dev/card_queue.py (a queued card that is such a version is added to the card as a variant). The looks come
from a function, `look_of(config name)`, which gives None when a look isn't known: then nothing is folded.

    python dev/lookalikes.py        list the cards in the deck that share a name and a look (each pair is a
                                    fold still to make); needs the client's cache
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
NPC_DECK = ROOT / "deck" / "npcs"

# Words for a job: a name ending in one is a role ("Cooking Tutor"), not a person. dev/wiki_cards.py uses them too.
ROLE_WORDS = {"tutor", "instructor", "guard", "farmer", "guardsman", "guardswoman", "priest", "priestess", "herbalist",
              "shopkeeper", "assistant", "banker", "merchant", "musician", "citizen", "villager", "monk", "nun",
              "sailor", "worker", "cleaner", "trader", "soldier", "knight", "cook", "chef", "archaeologist",
              "attendee", "player", "bartender", "barman", "barmaid", "innkeeper", "druid", "druidess"}
# Roles are never folded: "Wizard (Rune Temple)" is someone other than "Wizard (Runecrafting Guild)" however alike
# they look. (A wizard counts here though the wiki tool names it like a person.)
NOT_FOLDED = ROLE_WORDS | {"wizard"}


def base_name(name):
    """A name without its bracket, in lower case: "Hellhound (God Wars Dungeon)" -> "hellhound"."""
    return re.sub(r"\s*\(.*\)$", "", name).strip().lower()


def foldable(name, categories=()):
    """True if an NPC of this name may be folded into a card: not a pet and not a role."""
    if "pet" in categories:
        return False
    words = base_name(name).replace("'s", "").split()
    return bool(words) and words[-1] not in NOT_FOLDED


def brace_end(text, first):
    """The position just after the } that closes the { at `first`."""
    depth = 0
    for i in range(first, len(text)):
        depth += {"{": 1, "}": -1}.get(text[i], 0)
        if depth == 0:
            return i + 1
    raise ValueError("a { with no closing }")


def card_span(text, at):
    """The start and end of the card's { ... } around position `at` (its `id = "..."`)."""
    start = text.rfind("{", 0, at)
    return start, brace_end(text, start)


def read_card(block, start=0, end=None):
    """The parts of a card's text that folding needs: { id, name, base (base_name), npc (its art's), configs (its
    own and its variants'), categories, start, end }. `start` and `end` are where it sits in its file."""
    found = re.search(r'\bid = "([^"]+)"', block)
    name = re.search(r'\bname = "((?:[^"\\]|\\.)*)"', block)
    art = re.search(r'\bart = \{[^\n]*?\bnpc = "([^"]+)"', block)
    variants = re.findall(r'\{ npc = "([^"]+)"', block[block.find("variants = {"):]) if "variants = {" in block else []
    tags = block[block.rfind("tags = {"):]
    categories = re.findall(r'"([^"]+)"', (re.search(r"\bcategory = \{([^{}]*)\}", tags) or [None, ""])[1])
    card_id = found.group(1) if found else ""
    own = art.group(1) if art else card_id.upper()
    name = name.group(1) if name else card_id
    return {"id": card_id, "name": name, "base": base_name(name), "npc": own,
            "configs": list(dict.fromkeys([own] + variants)), "categories": categories,
            "start": start, "end": len(block) if end is None else end}


def deck_cards(folder=NPC_DECK):
    """Every NPC card in the deck files: { id, name, npc, configs (its own and its variants'),
    categories, path, start, end }."""
    cards = []
    for path in sorted(Path(folder).glob("*.lua")):
        text = path.read_bytes().decode("utf-8")
        for found in re.finditer(r'\{\s*id = "', text):
            start, end = card_span(text, found.end())
            card = read_card(text[start:end], start, end)
            card["path"] = path
            cards.append(card)
    return cards


def twin(name, configs, cards, look_of, categories=(), skip_ids=()):
    """The card that an NPC called `name` with these configs is a lookalike version of, or None: a card of
    the same base name but not the very same name (that is the NPC's own card, or a duplicate), one of whose
    configs looks the same as one of these. Neither may be a pet or a role; cards in `skip_ids` are passed
    over."""
    if not foldable(name, categories):
        return None
    looks = {look_of(c) for c in configs} - {None}
    if not looks:
        return None
    base = base_name(name)
    for card in cards:
        if (card["base"] != base or card["id"] in skip_ids or card["name"].lower() == name.lower()
                or not foldable(card["name"], card["categories"])):
            continue
        if any(look_of(c) in looks for c in card["configs"]):
            return card
    return None


def locations(block):
    """The location words in a card's text."""
    tags = block[block.rfind("tags = {"):]
    found = re.search(r"\blocation = \{([^{}]*)\}", tags)
    return re.findall(r'"([^"]+)"', found.group(1)) if found else []


def add_variant(card, config, name, places=(), dry_run=False):
    """Adds `config` (shown as `name`) to the card's variants in its deck file, with these places in its
    locations. A card with no variants yet gets them, its own look first. Returns what was done."""
    if config in card["configs"]:
        return f"{config} is already on the card {card['id']}"
    raw = card["path"].read_bytes().decode("utf-8")
    newline = "\r\n" if "\r\n" in raw else "\n"
    text = raw.replace("\r\n", "\n")
    found = re.search(r'\{\s*id = "%s"' % re.escape(card["id"]), text)
    if found is None:
        raise ValueError(f"the card {card['id']} is no longer in {card['path'].name}")
    start, end = card_span(text, found.end())
    block = text[start:end]
    # (a card written on one line stays on one line; otherwise one variant to a line)
    item, close, after = (" ", " ", ", ") if "\n" not in block else ("\n            ", ",\n        ", ",\n        ")
    entry = f'{{ npc = "{config}", name = "{name}" }}'
    if "variants = {" in block:
        end_at = brace_end(block, block.find("variants = {") + len("variants = ")) - 1
        before = block[:end_at].rstrip()
        comma = "" if before.endswith((",", "{")) else ","
        block = before + comma + item + entry + close + block[end_at:]
    else:
        own = f'{{ npc = "{card["npc"]}", name = "{card["name"]}" }}'
        tags_at = block.rfind("tags = {")
        added = "variants = {" + item + own + "," + item + entry + close + "}" + after
        block = block[:tags_at] + added + block[tags_at:]
    new_places = [p for p in places if p not in locations(block)]
    if new_places:
        tags_at = block.rfind("tags = {")
        tags = block[tags_at:]
        words = ", ".join(f'"{p}"' for p in new_places)
        if re.search(r"\blocation = \{", tags):
            tags = re.sub(r"(\blocation = \{[^{}]*?)\s*\}", lambda m: m.group(1) + ", " + words + " }", tags, count=1)
        else:
            tags = tags.replace("tags = {", "tags = { location = { " + words + " },", 1)
        block = block[:tags_at] + tags
    if not dry_run:
        card["path"].write_bytes((text[:start] + block + text[end:]).replace("\n", newline).encode("utf-8"))
    places_note = f", with {', '.join(new_places)}" if new_places else ""
    return f"{'would add' if dry_run else 'added'} {config} to the card {card['id']} as a variant{places_note}"


def cache_looks(looks=None, ids=None):
    """A look_of function reading the client's cache (dev/npc_looks.py), or None without a cache. A caller that
    has a Looks and the config ids already passes them."""
    import npc_looks
    looks = looks or npc_looks.Looks()
    if looks.db is None:
        return None
    ids = ids or npc_looks.npc_ids()
    return lambda config: looks.look(ids[config]) if config in ids else None


def main():
    look_of = cache_looks()
    if look_of is None:
        print("No readable client cache: looks can't be compared.")
        return 1
    by_base = {}
    for card in deck_cards():
        by_base.setdefault(card["base"], []).append(card)
    shown = 0
    for group in by_base.values():
        for i, card in enumerate(group):
            other = twin(card["name"], card["configs"], group[i + 1:], look_of, card["categories"])
            if other is not None:
                print(f"{card['id']} ({card['name']}) looks the same as {other['id']} ({other['name']})")
                shown += 1
    print(f"{shown} lookalike pair(s) in the deck.")
    return 0


if __name__ == "__main__":
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    sys.exit(main())
