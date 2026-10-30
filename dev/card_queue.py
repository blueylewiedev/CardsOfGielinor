#!/usr/bin/env python3
"""Writes the cards queued by the Wiki Review's Done button into their deck files.

When you mark a candidate Done after loading it into the Card Builder, the plugin saves the
builder's card block in its database as dev_card_queue_0001, 0002... (with the deck file the
builder had chosen). This script reads those from the database file, and adds each new card to
the end of its deck file (inside Set.cards). Run it on the computer the client runs on:

    python dev/card_queue.py --db "C:/ProgramData/Jagex/RuneScape-BETA/plugins/PluginData.db"
    python dev/card_queue.py --db ... --once      do what is queued now, then stop (default: keep watching)
    python dev/card_queue.py --db ... --dry-run   only say what would be added

The database is only ever read (never written). The entries already handled are remembered in
dev/.card_queue_state.json, so none is added twice; a card whose id is already in a deck file is
skipped and reported. Afterwards: reload the plugin to check the cards load, then commit.

(--db can also be set once with the environment variable CARD_DB.)
"""

import argparse
import json
import os
import re
import sqlite3
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
STATE = ROOT / "dev" / ".card_queue_state.json"
PLUGIN = "CardCollector"
KEY_PREFIX = "dev_card_queue_"
SEQ_KEY = "dev_card_queue_seq"
# the end of a deck file: the closing brace of Set.cards, then return Set
FILE_END = re.compile(r"\n\}\s*\n+return Set\s*$")


def unpack(node):
    """The client stores a Lua table as [{"key": k, "value": v}, ...]; this gives { k: v }."""
    if isinstance(node, list) and node and all(isinstance(n, dict) and set(n) == {"key", "value"} for n in node):
        return {n["key"]: unpack(n["value"]) for n in node}
    if isinstance(node, list):
        return [unpack(n) for n in node]
    return node


def read_queue(db_path):
    """The queued entries, oldest first, as (key, entry)."""
    uri = Path(db_path).resolve().as_uri() + "?mode=ro"
    con = sqlite3.connect(uri, uri=True, timeout=2)
    try:
        rows = con.execute("select Key, Value from DataStore where PluginID=? and Key like ? order by Key",
                           (PLUGIN, KEY_PREFIX + "%")).fetchall()
    finally:
        con.close()
    found = []
    for key, value in rows:
        if key == SEQ_KEY:
            continue
        try:
            entry = unpack(json.loads(bytes(value).rstrip(b"\x00").decode("utf-8")))
        except (ValueError, UnicodeDecodeError):
            continue
        if isinstance(entry, dict) and entry.get("block") and entry.get("deck") and entry.get("id"):
            found.append((key, entry))
    return found


def load_state():
    try:
        return set(json.loads(STATE.read_text(encoding="utf-8")))
    except (OSError, ValueError):
        return set()


def save_state(done):
    STATE.write_text(json.dumps(sorted(done), indent=1), encoding="utf-8")


def all_ids():
    """Every card id (live or draft) in the deck files."""
    ids = set()
    for path in (ROOT / "deck").rglob("*.lua"):
        ids.update(re.findall(r'\bid = "([^"]+)"', path.read_text(encoding="utf-8")))
    return ids


def add_block(entry, dry_run):
    """Adds the card's block to its deck file. Returns a message."""
    deck = ROOT / (entry["deck"] + ".lua")
    if not deck.is_file() or ROOT / "deck" not in deck.resolve().parents:
        return f"SKIPPED {entry['id']}: no deck file {entry['deck']}.lua"
    raw = deck.read_bytes().decode("utf-8")
    newline = "\r\n" if "\r\n" in raw else "\n"
    text = raw.replace("\r\n", "\n")
    end = FILE_END.search(text)
    if end is None:
        return f"SKIPPED {entry['id']}: {entry['deck']}.lua does not end with Set.cards' }} and return Set"
    before = text[:end.start()].rstrip("\n")
    updated = before + "\n    " + entry["block"] + "\n" + text[end.start() + 1:]
    if not dry_run:
        deck.write_bytes(updated.replace("\n", newline).encode("utf-8"))
    note = f"  (do by hand: {entry['notes']})" if entry.get("notes") else ""
    return f"{'would add' if dry_run else 'added'} {entry['id']} to {entry['deck']}.lua{note}"


def process(db_path, dry_run=False):
    done = load_state()
    ids = all_ids()
    count = 0
    for key, entry in read_queue(db_path):
        marker = f"{key}|{entry['id']}"
        if marker in done:
            continue
        if entry["id"] in ids:
            print(f"SKIPPED {entry['id']}: a card with that id is already in the deck files")
        else:
            message = add_block(entry, dry_run)
            print(message)
            if message.startswith("SKIPPED"):
                continue          # (tried again next time, once the problem is fixed)
            ids.add(entry["id"])
            count += 1
        if not dry_run:
            done.add(marker)
    if not dry_run:
        save_state(done)
    return count


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--db", default=os.environ.get("CARD_DB"), help="the client's PluginData.db")
    parser.add_argument("--once", action="store_true", help="process what is queued, then stop")
    parser.add_argument("--dry-run", action="store_true", help="only say what would be added")
    args = parser.parse_args()
    if not args.db:
        parser.error("give the database file with --db (or set CARD_DB)")
    if args.once or args.dry_run:
        print(f"{process(args.db, args.dry_run)} card(s) {'would be ' if args.dry_run else ''}added.")
        return
    print("Watching the card queue (Ctrl+C to stop)...")
    last = None
    while True:
        try:
            stamp = [(p.stat().st_mtime, p.stat().st_size) for p in (Path(args.db), Path(args.db + "-wal")) if p.exists()]
            if stamp != last:
                last = stamp
                process(args.db)
        except sqlite3.Error as error:
            print("cannot read the database yet:", error)
        time.sleep(1)


if __name__ == "__main__":
    main()
