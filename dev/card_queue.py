#!/usr/bin/env python3
"""Writes the cards queued by the Wiki Review's Done button into their deck files.

When you mark a candidate Done after loading it into the Card Builder, the plugin saves the
builder's card block in its database as dev_card_queue_0001, 0002... (with the deck file the
builder had chosen and the wiki page it came from). This script reads those from the database
file and adds each new card to the end of its deck file (inside Set.cards). Run it on the computer
the client runs on, from the plugin's folder. The commands (DB is the client's PluginData.db):

    python dev/card_queue.py --db DB               keep watching: add each card as it is queued
    python dev/card_queue.py --db DB --once        add everything queued now (and retry failed ones), then stop
    python dev/card_queue.py --db DB --dry-run     say what would be added, change nothing
    python dev/card_queue.py --db DB --list        show every queued card not added yet, with why, and its block
    python dev/card_queue.py --db DB --list --all  show the added ones too
    python dev/card_queue.py --db DB --rename 0007 new_id   give a queued card another id, then run --once

(--db can be set once with the environment variable CARD_DB.)

The database is only ever read, never written. What the script has done is kept in
dev/.card_queue_state.json: each queued card is "done", or "failed" with the reason (a duplicate id,
a missing deck file...). A failed card is tried again every time the script runs, and --list shows
it with the wiki page it came from: type that page into the Wiki Review's "Reopen" box to put the
candidate back in the Card Builder, then press Done again. Afterwards reload the plugin to check
the cards load, then commit.
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
    """{ key: { "id", "status": "done" or "failed", "reason", "rename" } }."""
    try:
        data = json.loads(STATE.read_text(encoding="utf-8"))
    except (OSError, ValueError):
        return {}
    if isinstance(data, list):          # (the first version kept "key|id" markers of finished cards)
        return {m.split("|")[0]: {"id": m.split("|", 1)[1], "status": "done"} for m in data if "|" in m}
    return data


def save_state(state):
    STATE.write_text(json.dumps(state, indent=1, sort_keys=True), encoding="utf-8")


def full_key(text):
    """'7', '0007' or 'dev_card_queue_0007' -> 'dev_card_queue_0007'."""
    return text if text.startswith(KEY_PREFIX) else KEY_PREFIX + text.zfill(4)


def with_id(entry, new_id):
    """The entry with another id (also in its block)."""
    changed = dict(entry, id=new_id)
    changed["block"] = re.sub(r'\bid = "[^"]*"', f'id = "{new_id}"', entry["block"], count=1)
    return changed


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


def entries_with_state(db_path, state):
    """(key, entry, record) for each queued card, with any rename applied. The record is the
    state of this card, or None if the script has not seen it (a record for another id under the
    same key is from an earlier database, and is ignored)."""
    found = []
    for key, entry in read_queue(db_path):
        record = state.get(key)
        if record is not None and record.get("rename"):
            entry = with_id(entry, record["rename"])
        if record is not None and record.get("id") != entry["id"]:
            record = None
        found.append((key, entry, record))
    return found


def process(db_path, dry_run=False):
    state = load_state()
    ids = all_ids()
    added = 0
    for key, entry, record in entries_with_state(db_path, state):
        if record is not None and record.get("status") == "done":
            continue
        if entry["id"] in ids:
            status, reason = "failed", "a card with the id %s is already in the deck files" % entry["id"]
        else:
            message = add_block(entry, dry_run)
            if message.startswith("SKIPPED"):
                status, reason = "failed", message.split(": ", 1)[1]
            else:
                status, reason = "done", ""
                ids.add(entry["id"])
                added += 1
                print(message)
        if status == "failed" and (record is None or record.get("reason") != reason):
            print(f"FAILED {key[len(KEY_PREFIX):]} {entry['id']}: {reason}  (python dev/card_queue.py --db ... --list)")
        if not dry_run:
            keep = {"id": entry["id"], "status": status, "reason": reason, "rename": (state.get(key) or {}).get("rename", "")}
            state[key] = keep
    if not dry_run:
        save_state(state)
    return added


def list_entries(db_path, show_all):
    state = load_state()
    shown = 0
    for key, entry, record in entries_with_state(db_path, state):
        status = record["status"] if record else "pending"
        if status == "done" and not show_all:
            continue
        shown += 1
        why = f" - {record['reason']}" if record and record.get("reason") else ""
        print(f"#{key[len(KEY_PREFIX):]}  {entry['id']}  [{status}]{why}")
        print(f"    wiki page: {entry.get('page') or '(not recorded)'}   deck file: {entry['deck']}.lua")
        print(f"    {entry['block']}")
        if entry.get("notes"):
            print(f"    by hand: {entry['notes']}")
    print(f"{shown} card(s) {'queued' if show_all else 'not added yet'}.")


def rename(db_path, key, new_id):
    state = load_state()
    key = full_key(key)
    if not re.fullmatch(r"[a-z0-9_]+", new_id):
        raise SystemExit("A card id is lower case letters, digits and underscores.")
    match = [e for k, e, _ in entries_with_state(db_path, state) if k == key]
    if not match:
        raise SystemExit(f"No queued card {key}. See --list.")
    record = state.get(key) or {"id": match[0]["id"], "status": "pending", "reason": ""}
    if record.get("status") == "done":
        raise SystemExit("That card has already been added; change it in its deck file.")
    record["rename"], record["id"], record["status"], record["reason"] = new_id, new_id, "pending", ""
    state[key] = record
    save_state(state)
    print(f"{key[len(KEY_PREFIX):]} will be added as {new_id}. Run with --once to add it.")


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--db", default=os.environ.get("CARD_DB") or r"C:/ProgramData/Jagex/RuneScape-BETA/plugins/PluginData.db",
                    help="the client's PluginData.db")
    parser.add_argument("--once", action="store_true", help="process what is queued, then stop")
    parser.add_argument("--dry-run", action="store_true", help="only say what would be added")
    parser.add_argument("--list", action="store_true", help="list the queued cards not added yet, and why")
    parser.add_argument("--all", action="store_true", help="with --list: the added ones too")
    parser.add_argument("--rename", nargs=2, metavar=("NUMBER", "NEW_ID"), help="give a queued card another id")
    args = parser.parse_args()
    if not args.db:
        parser.error("give the database file with --db (or set CARD_DB)")
    if args.list:
        list_entries(args.db, args.all)
        return
    if args.rename:
        rename(args.db, *args.rename)
        return
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
