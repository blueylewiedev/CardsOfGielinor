#!/usr/bin/env python3
"""Checks that deck/index.lua and the files under deck/ agree.

The plugin cannot look inside folders, so every deck file has to be listed in deck/index.lua.
This fails if a deck file is not listed (it would never load) or if the index lists a file
that does not exist (it would break loading).

It also checks dev/parked_cards/index.lua against the files under dev/parked_cards/deck/ the same way (the parked
cards, which dev/check_parked.lua loads: a file missing from that index is never checked).

Run from anywhere:  python dev/check_deck_index.py
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DECK = ROOT / "deck"
NOT_DECKS = {"index.lua", "packs.lua", "sets.lua"}


def listed_files():
    text = (DECK / "index.lua").read_text(encoding="utf-8")
    # Ignore comments so a commented-out line does not count as registered.
    text = "\n".join(line.split("--", 1)[0] for line in text.splitlines())
    return re.findall(r'"([^"]+)"', text)


PARKED = ROOT / "dev" / "parked_cards"


def parked_problems():
    """The same check for dev/parked_cards/: every file under deck/ there is in its index.lua, and every entry exists."""
    index = PARKED / "index.lua"
    if not index.is_file():
        return []
    text = chr(10).join(line.split("--", 1)[0] for line in index.read_text(encoding="utf-8").splitlines())
    listed = re.findall(r'"([^"]+)"', text)
    problems = []
    seen = set()
    for name in listed:
        if name in seen:
            problems.append(f'dev/parked_cards/index.lua lists "{name}" more than once')
        seen.add(name)
        if not (ROOT / (name + ".lua")).is_file():
            problems.append(f'dev/parked_cards/index.lua lists "{name}" but {name}.lua does not exist')
    on_disk = {p.relative_to(ROOT).as_posix()[: -len(".lua")] for p in (PARKED / "deck").rglob("*.lua")}
    for name in sorted(on_disk - seen):
        problems.append(f'{name}.lua is not listed in dev/parked_cards/index.lua (add "{name}")')
    return problems


def main():
    listed = listed_files()
    problems = parked_problems()

    seen = set()
    for name in listed:
        if name in seen:
            problems.append(f'deck/index.lua lists "{name}" more than once')
        seen.add(name)
        if not name.startswith("deck/"):
            problems.append(f'deck/index.lua entry "{name}" does not start with "deck/"')
        elif not (ROOT / (name + ".lua")).is_file():
            problems.append(f'deck/index.lua lists "{name}" but {name}.lua does not exist')

    on_disk = set()
    for path in DECK.rglob("*.lua"):
        rel = path.relative_to(ROOT).as_posix()
        if path.parent == DECK and path.name in NOT_DECKS:
            continue
        on_disk.add(rel[: -len(".lua")])
    for name in sorted(on_disk - seen):
        problems.append(f'{name}.lua is not listed in deck/index.lua (add "{name}")')

    if problems:
        print("Deck index problems:")
        for problem in problems:
            print("  - " + problem)
        return 1
    print(f"OK: {len(listed)} deck files, all registered in deck/index.lua")
    return 0


if __name__ == "__main__":
    sys.exit(main())
