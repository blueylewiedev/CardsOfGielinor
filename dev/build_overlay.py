#!/usr/bin/env python3
"""Builds docs/overlay.jsonl: the cards that changed since the last version Jagex approved.

    python dev/build_overlay.py                 write docs/overlay.jsonl against the newest "v*" tag
    python dev/build_overlay.py --base v0.1.0   against another tag or commit (for trying it out)
    python dev/build_overlay.py --check         fail if docs/overlay.jsonl is out of date (writes nothing)
    python dev/build_overlay.py --lua PATH      the Lua to use (else `lua`, `lua5.4` or `lua54` on the PATH, or $LUA)

The plugin ships with the whole deck and fetches this file when it starts, so card fixes and new cards reach
players between reviews. It is only meant for the version that was approved: every submission to Jagex is
tagged v<version> (for example v0.2.0), and this file holds only what is new or different since that tag, so it
empties itself when the next version is approved and tagged. With no tag yet it is empty.

How: dev/export_overlay.lua writes every live card as one JSON line (by id, in a fixed key order) for the deck in
the tag and for the deck in this checkout. A card that is new or whose line differs is written to the overlay in
full; a card that was in the tag and is not now is written as a deprecation. The file is JSON lines:

    {"base":"0.2.0","format":1,"revision":3}      the header: the plugin version this overlay is for
    {"art":{...},"id":"swamp_frog",...}           a new or changed card, as the game has it
    {"deprecated":"old_card_id"}                  a card to take out

`base` is the version in plugin.json at the tag. The plugin applies the overlay only if its own version is
`base`. `revision` goes up each time the content changes (and starts again at 1 for a new base). See
notes/Card Collector External Card Data Implementation Plan.md and CONTRIBUTING.md.
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OVERLAY = ROOT / "docs" / "overlay.jsonl"
EXPORTER = ROOT / "dev" / "export_overlay.lua"
FORMAT = 1


def run(command, cwd=None):
    result = subprocess.run(command, cwd=cwd, capture_output=True, text=True, encoding="utf-8")
    if result.returncode != 0:
        raise SystemExit(f"{' '.join(str(c) for c in command)} failed:\n{result.stderr.strip() or result.stdout.strip()}")
    return result.stdout


def find_lua(wanted):
    for name in [wanted, os.environ.get("LUA"), "lua", "lua5.4", "lua54"]:
        if name and shutil.which(name):
            return shutil.which(name)
    raise SystemExit("Lua not found: put lua on the PATH or pass --lua PATH")


def newest_tag():
    tags = run(["git", "tag", "--list", "v*", "--sort=-v:refname"], cwd=ROOT).split()
    return tags[0] if tags else None


def plugin_version(ref):
    """The version in plugin.json, in the checkout (ref None) or at a tag or commit."""
    if ref is None:
        text = (ROOT / "plugin.json").read_text(encoding="utf-8-sig")
    else:
        text = run(["git", "show", f"{ref}:plugin.json"], cwd=ROOT)
    return json.loads(text)["version"]


def export_lines(lua, folder):
    """{ card id: its line } for the deck in a plugin folder, from dev/export_overlay.lua."""
    with tempfile.TemporaryDirectory() as scratch:
        target = Path(scratch) / "cards.jsonl"
        run([lua, str(EXPORTER), str(target)], cwd=folder)
        text = target.read_text(encoding="utf-8")
    cards = {}
    for line in text.split("\n"):
        if line:
            cards[json.loads(line)["id"]] = line
    return cards


def export_at(lua, ref):
    """The same, for the deck as it was at a tag or commit (a throwaway checkout)."""
    folder = tempfile.mkdtemp(prefix="overlay_base_")
    try:
        run(["git", "worktree", "add", "--detach", "--force", folder, ref], cwd=ROOT)
        return export_lines(lua, folder)
    finally:
        subprocess.run(["git", "worktree", "remove", "--force", folder], cwd=ROOT, capture_output=True)
        shutil.rmtree(folder, ignore_errors=True)


def diff(base, current):
    """(changed lines, deprecated ids, how many of the changed are new): what the overlay must say, each in id order."""
    changed = [current[i] for i in sorted(current) if base.get(i) != current[i]]
    new = sum(1 for i in current if i not in base)
    deprecated = sorted(i for i in base if i not in current)
    return changed, deprecated, new


def body_lines(changed, deprecated):
    return list(changed) + [json.dumps({"deprecated": i}, separators=(",", ":")) for i in deprecated]


def next_revision(existing_text, base_version, body):
    """1 for a new base; the same revision if the content is the same; else one more."""
    if not existing_text:
        return 1
    lines = existing_text.split("\n")
    try:
        header = json.loads(lines[0])
    except ValueError:
        return 1
    if header.get("base") != base_version or not isinstance(header.get("revision"), int):
        return 1
    existing_body = [line for line in lines[1:] if line]
    return header["revision"] if existing_body == body else header["revision"] + 1


def overlay_text(base_version, revision, body):
    header = json.dumps({"base": base_version, "format": FORMAT, "revision": revision}, separators=(",", ":"), sort_keys=True)
    return "\n".join([header] + body) + "\n"


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--base", help="the tag or commit the approved version was made from (default: the newest v* tag)")
    parser.add_argument("--lua", help="the Lua to run")
    parser.add_argument("--check", action="store_true", help="only check that docs/overlay.jsonl is up to date")
    parser.add_argument("--out", type=Path, default=OVERLAY, help="where to write it (default docs/overlay.jsonl)")
    args = parser.parse_args()

    lua = find_lua(args.lua)
    base_ref = args.base or newest_tag()
    if base_ref is None:
        print("No v* tag yet (nothing has been submitted for approval): the overlay is empty.")
        base_version, body = plugin_version(None), []
    else:
        base_version = plugin_version(base_ref)
        current = export_lines(lua, ROOT)
        base = export_at(lua, base_ref)
        changed, deprecated, new = diff(base, current)
        body = body_lines(changed, deprecated)
        print(f"Against {base_ref} (plugin version {base_version}): {len(changed)} cards "
              f"({new} new, {len(changed) - new} changed), {len(deprecated)} deprecated.")

    existing = args.out.read_text(encoding="utf-8") if args.out.exists() else ""
    text = overlay_text(base_version, next_revision(existing, base_version, body), body)
    if args.check:
        if existing != text:
            print(f"{args.out.name} is out of date: run  python dev/build_overlay.py  and commit it.")
            return 1
        print(f"{args.out.name} is up to date.")
        return 0
    args.out.parent.mkdir(exist_ok=True)
    args.out.write_text(text, encoding="utf-8", newline="\n")
    print(f"{args.out}: {len(text.encode('utf-8'))} bytes, {len(body)} lines after the header.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
