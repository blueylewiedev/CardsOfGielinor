#!/usr/bin/env python3
"""What NPC configs look like, read from the RuneScape client's own cache on this computer: the
body models and colours each is built from, so two configs that only differ in name can be told
apart from two that really look different. dev/wiki_cards.py uses it to keep one config of each
look on a candidate.

The cache is only read (the client can stay open). Its layout isn't documented; this follows what
it was found to hold (October 2026). A config is only trusted if every field in it is understood
and it ends where it should: anything else gives no look, and is then treated as different from
everything, so nothing is lost if a game update changes the layout.

    python dev/npc_looks.py                  how many NPC configs read cleanly (and which didn't)
    python dev/npc_looks.py CONFIG_NAME ...  the look of these configs
"""
import sqlite3
import struct
import sys
import zlib
from pathlib import Path

from anim_sets import DEFAULT_CACHE, archive_files, big_smart, file_ids, unzip

ROOT = Path(__file__).resolve().parent.parent
NPC_INDEX = "js5-18.jcache"     # the NPC configs of the cache: group = id >> 7, file = id & 127

# Fields of a fixed size, by opcode (their values don't change how an NPC looks on a card). The
# sizes were worked out from the data; only ones that hundreds of configs agree on are here, as a
# size that suits a few is usually a misread. A config with any other field gives no look.
FIXED = {}
for size, opcodes in {
    0: [93, 99, 107, 109, 111, 141, 143, 158, 159, 162, 169, 178, 182],
    1: [12, 79, 100, 101, 119, 125, 128, 134, 140, 163, 165, 168, 184, 253],
    2: [26, 27, 44, 45, 95, 103, 122, 123, 127, 137, 142, 170, 172],
    4: [102, 255],
    7: [85],
    10: [187],
    12: [58, 179, 188],
}.items():
    FIXED.update(dict.fromkeys(opcodes, size))
STRINGS = set(range(30, 40)) | set(range(150, 155))
COUNTED = {160: 2, 121: 4}      # a count, then this many bytes each
NORMAL_SCALE = 128              # an NPC's width (opcode 97) and height (98) if it doesn't set them
# What a changed or half-written cache can raise while being read.
CACHE_ERRORS = (sqlite3.Error, OSError, ValueError, IndexError, TypeError, struct.error, zlib.error)


class Unread(Exception):
    """A config holds something this reader doesn't know."""


def read_look(data):
    """The look of an NPC config: (body models, recolours, retextures, palette, scale), or None for
    a config with no models of its own (a stand-in that turns into others). Raises Unread if the
    config doesn't read cleanly to its end."""
    pos, models, recolours, retextures, palette, named = 0, None, (), (), (), False
    scale = [NORMAL_SCALE, NORMAL_SCALE]

    def smart_list():
        nonlocal pos
        count = data[pos]
        pos += 1
        found = []
        for _ in range(count):
            value, pos = big_smart(data, pos)
            found.append(value)
        return tuple(found)

    def pairs():
        nonlocal pos
        count = data[pos]
        pos += 1
        found = struct.unpack(f">{2 * count}H", data[pos:pos + 4 * count])
        pos += 4 * count
        return found

    def text():
        nonlocal pos
        end = data.index(0, pos)
        if not all(32 <= byte < 127 or byte >= 160 for byte in data[pos:end]):
            raise Unread(f"text that isn't text at {pos}")
        pos = end + 1

    try:
        while True:
            opcode = data[pos]
            pos += 1
            if opcode == 0:
                break
            if opcode == 1:
                if models is not None:
                    raise Unread(f"a second model list at {pos - 1}")
                models = smart_list()
            elif opcode == 60:
                smart_list()                    # (the chathead)
            elif opcode == 40:
                recolours = pairs()
            elif opcode == 41:
                retextures = pairs()
            elif opcode == 42:
                count = data[pos]
                palette = tuple(data[pos + 1:pos + 1 + count])
                pos += 1 + count
            elif opcode in (97, 98):
                scale[opcode - 97] = struct.unpack(">H", data[pos:pos + 2])[0]
                pos += 2
            elif opcode in STRINGS:
                text()
            elif opcode == 2:
                if named:
                    raise Unread(f"a second name at {pos - 1}")
                named = True
                text()
            elif opcode in FIXED:
                pos += FIXED[opcode]
            elif opcode in COUNTED:
                pos += 1 + data[pos] * COUNTED[opcode]
            elif opcode == 249:
                count = data[pos]
                pos += 1
                for _ in range(count):
                    is_text = data[pos]
                    pos += 4
                    if is_text:
                        text()
                    else:
                        pos += 4
            else:
                raise Unread(f"opcode {opcode} at {pos - 1}")
    except (IndexError, ValueError, struct.error) as problem:
        raise Unread(f"ran off the end ({problem})") from problem
    if pos != len(data):
        raise Unread(f"{len(data) - pos} bytes after the end")
    return (models, recolours, retextures, palette, tuple(scale)) if models else None


class Looks:
    """The looks of NPC configs by id, read from the cache as they are asked for."""

    def __init__(self):
        path = DEFAULT_CACHE / NPC_INDEX
        self.db = None
        self.groups = {}
        if path.exists():
            try:
                # (read-only and immutable, so the running client is never locked or written to)
                self.db = sqlite3.connect(f"file:{path.as_posix()}?mode=ro&immutable=1", uri=True)
                self.index = unzip(self.db.execute("SELECT DATA FROM cache_index").fetchone()[0])
            except CACHE_ERRORS as problem:
                print(f"Can't read {path}: {problem}")
                self.db = None

    def config(self, npc_id):
        """The raw config of an NPC, or None if the cache doesn't hold it."""
        if self.db is None:
            return None
        group, file = npc_id >> 7, npc_id & 127
        if group not in self.groups:
            try:
                row = self.db.execute("SELECT DATA FROM cache WHERE KEY = ?", (group,)).fetchone()
                self.groups[group] = dict(zip(file_ids(self.index, group), archive_files(row[0]))) if row else {}
            except CACHE_ERRORS:
                self.groups[group] = {}
        return self.groups[group].get(file)

    def look(self, npc_id):
        """The look of an NPC, or None if it has none that can be trusted."""
        data = self.config(npc_id)
        if not data:
            return None
        try:
            return read_look(data)
        except Unread:
            return None


def npc_ids():
    """{ config name: id } from dev/npc.txt."""
    found = {}
    for line in (ROOT / "dev" / "npc.txt").read_text(encoding="utf-8").splitlines():
        parts = line.split(None, 1)
        if len(parts) == 2 and parts[0].isdigit():
            found[parts[1].strip()] = int(parts[0])
    return found


def main():
    looks = Looks()
    if looks.db is None:
        print(f"No cache at {DEFAULT_CACHE}.")
        return 1
    ids = npc_ids()
    if len(sys.argv) > 1:
        for name in sys.argv[1:]:
            print(name, looks.look(ids[name]))
        return 0
    clean, empty, problems = 0, 0, {}
    for name, npc_id in ids.items():
        data = looks.config(npc_id)
        if not data:
            empty += 1
            continue
        try:
            read_look(data)
            clean += 1
        except Unread as problem:
            problems.setdefault(str(problem).split(" at ")[0], []).append((name, npc_id))
    print(f"{clean} read cleanly, {empty} not in the cache, {sum(map(len, problems.values()))} didn't read")
    for why, names in sorted(problems.items(), key=lambda p: -len(p[1]))[:25]:
        print(f"  {why}: {len(names)}, such as {names[0]}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
