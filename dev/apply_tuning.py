"""Writes the cameras saved in the Preview into the deck files.

Save in the Preview keeps each card's whole art line in the client's plugin data (see
dev/tuning.lua). This replaces each of those cards' `art = { ... }` in deck/ with it, so a run of
saved cards needs no pasting. Entries saved before the line was kept are listed and left alone.

Reload or turn off the plugin first: the client may not have written a recent Save yet.

Usage: python dev/apply_tuning.py [--dry-run]
"""
import glob
import json
import re
import sqlite3
import sys

from card_queue import DEFAULT_DB, PLUGIN, unpack

KEY = "dev_card_tuning"


def saved_lines():
    """{ card id: art line } for the saved cards, and the ids saved with no line."""
    connection = sqlite3.connect(f"file:{DEFAULT_DB}?mode=ro", uri=True)
    row = connection.execute("select Value from DataStore where PluginID = ? and Key = ?", (PLUGIN, KEY)).fetchone()
    connection.close()
    if row is None:
        return {}, []
    saved = unpack(json.loads(row[0].rstrip(b"\x00")))    # (the client's value ends in a zero byte)
    lines = {card: entry["line"].rstrip(",") for card, entry in saved.items() if "line" in entry}
    return lines, sorted(set(saved) - set(lines))


def art_end(text, start):
    """Where the `art = { ... }` that starts at `start` ends."""
    i, depth = text.index("{", start) + 1, 1
    while depth > 0:
        depth += {"{": 1, "}": -1}.get(text[i], 0)
        i += 1
    return i


def apply_to(path, lines, done):
    """Replaces the art of each saved card in one deck file, and returns how many changed."""
    with open(path, encoding="utf-8", newline="") as f:
        text = original = f.read()
    changed = 0
    cards = list(re.finditer(r'\bid = "(\w+)"', text))
    for n, found in reversed(list(enumerate(cards))):
        card = found.group(1)
        # (only in this card's own block: one with no art of its own must not take the next card's)
        block_end = cards[n + 1].start() if n + 1 < len(cards) else len(text)
        art = re.compile(r"\bart = \{").search(text, found.end(), block_end)
        if card not in lines or art is None:
            continue
        end = art_end(text, art.start())
        done.add(card)
        if text[art.start():end] != lines[card]:
            text = text[:art.start()] + lines[card] + text[end:]
            changed += 1
    if text != original and "--dry-run" not in sys.argv:
        with open(path, "w", encoding="utf-8", newline="") as f:
            f.write(text)
    return changed


def main():
    lines, no_line = saved_lines()
    done, changed = set(), 0
    for path in glob.glob("deck/**/*.lua", recursive=True):
        changed += apply_to(path, lines, done)
    print(f"{len(lines)} saved, {changed} changed, {len(done) - changed} already the same")
    if set(lines) - done:
        print("Not in the deck files:", ", ".join(sorted(set(lines) - done)))
    if no_line:
        print("Saved without an art line (press Save on them again):", ", ".join(no_line))


if __name__ == "__main__":
    main()
