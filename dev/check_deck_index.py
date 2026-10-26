#!/usr/bin/env python3
"""Checks that deck/index.lua and the files under deck/ agree.

The plugin cannot look inside folders, so every deck file has to be listed in deck/index.lua.
This fails if a deck file is not listed (it would never load) or if the index lists a file
that does not exist (it would break loading).

Run from anywhere:  python dev/check_deck_index.py
"""
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
DECK = ROOT / "deck"
NOT_DECKS = {"index.lua", "packs.lua"}


def listed_files():
    text = (DECK / "index.lua").read_text(encoding="utf-8")
    # Ignore comments so a commented-out line does not count as registered.
    text = "\n".join(line.split("--", 1)[0] for line in text.splitlines())
    return re.findall(r'"([^"]+)"', text)


def main():
    listed = listed_files()
    problems = []

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
