#!/usr/bin/env python3
"""Writes dev/anim_sets.lua: every animation set (an NPC's `bas`, such as HUMAN_2) and the
animations in it (stand, walk, run, turns, and the random idles it plays now and then), read from
the RuneScape client's own cache on this computer. An NPC's set is known in the game
(config.NPC.FromID(id).bas.id), so its real standing animation can be looked up here instead of
guessed from names.

The cache is only read (the client can stay open). Run it again after a game update:

    python dev/anim_sets.py                  the cache in C:\\ProgramData\\Jagex\\RuneScape
    python dev/anim_sets.py --cache DIR      a cache somewhere else

The cache's layout isn't documented; this follows what it was found to hold (October 2026). If a
set doesn't read cleanly, nothing is written and the set is named, so a changed layout is noticed
rather than misread.
"""
import argparse
import sqlite3
import struct
import sys
import zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
OUTPUT = ROOT / "dev" / "anim_sets.lua"
SEQ_NAMES = ROOT / "dev" / "seq.txt"
DEFAULT_CACHE = Path("C:/ProgramData/Jagex/RuneScape")

CONFIG_INDEX = "js5-2.jcache"   # the config index of the cache
ANIM_SET_GROUP = 32             # its group of animation sets, one file per set id

# What each opcode of a set holds. Its animations, by name ("walk" is forward; the turns are on
# the spot, or while walking, running or crawling):
ANIMS = {
    2: "crawl", 3: "crawlBack", 4: "crawlLeft", 5: "crawlRight",
    6: "run", 7: "runBack", 8: "runLeft", 9: "runRight",
    38: "turnLeft", 39: "turnRight", 40: "walkBack", 41: "walkLeft", 42: "walkRight",
    46: "crawlTurnLeft", 47: "crawlTurnRight", 48: "runTurnLeft", 49: "runTurnRight",
    50: "walkTurnLeft", 51: "walkTurnRight",
}
STAND_WALK = 1          # stand, then walk
IDLES = 52              # a count, then for each: animation, weight, a byte not used here
SETTINGS = {26: 2, 53: 0, 54: 2}    # not animations: how many bytes each takes


def big_smart(data, pos):
    """An animation id: two bytes, or four when the top bit is set; 0x7fff is none (-1)."""
    if data[pos] & 0x80:
        return struct.unpack(">I", data[pos:pos + 4])[0] & 0x7fffffff, pos + 4
    value = struct.unpack(">H", data[pos:pos + 2])[0]
    return (-1 if value == 0x7fff else value), pos + 2


def unzip(blob):
    """A cache entry's data: "ZLB", a version byte, the length, then zlib data."""
    if blob[:3] != b"ZLB":
        raise ValueError("not a ZLB entry")
    return zlib.decompress(blob[8:])


def file_ids(index, group):
    """The file ids of a group, from the cache's index of the whole config index (its reference
    table): the ids have gaps (animation sets 2558 to 2573 don't exist), so a file's place in its
    group is not its id."""
    pos = 0

    def take(size, fmt):
        nonlocal pos
        value = struct.unpack(fmt, index[pos:pos + size])[0]
        pos += size
        return value

    def smart():
        return take(4, ">I") & 0x7fffffff if index[pos] & 0x80 else take(2, ">H")

    protocol = take(1, ">B")
    if protocol != 7:
        raise ValueError(f"unknown index format {protocol}")
    take(4, ">I")                           # revision
    flags = take(1, ">B")
    count = smart()
    groups, last = [], 0
    for _ in range(count):
        last += smart()
        groups.append(last)
    # per group: name hashes, checksums, uncompressed checksums, digests, lengths, versions
    pos += count * (4 * bool(flags & 1) + 4 + 4 * bool(flags & 8) + 64 * bool(flags & 2) + 8 * bool(flags & 4) + 4)
    counts = [smart() for _ in range(count)]
    for each, files in zip(groups, counts):
        ids, last = [], 0
        for _ in range(files):
            last += smart()
            ids.append(last)
        if each == group:
            return ids
    raise ValueError(f"the index has no group {group}")


def archive_files(blob):
    """The files of a cache archive: its data starts with 1, the files' start offsets (four bytes
    each), then the files."""
    raw = unzip(blob)
    if raw[0] != 1:
        raise ValueError(f"unknown archive format {raw[0]}")
    count = (struct.unpack(">I", raw[1:5])[0] - 1) // 4
    starts = [struct.unpack(">I", raw[1 + 4 * i:5 + 4 * i])[0] for i in range(count)] + [len(raw)]
    return [raw[starts[i]:starts[i + 1]] for i in range(count)]


def read_set(data):
    """A set's animations as { name: id } (idles: a list of [id, weight]), or raises ValueError if
    it doesn't read cleanly to its closing 0."""
    found, pos = {}, 0
    while pos < len(data):
        opcode = data[pos]
        pos += 1
        if opcode == 0:
            if pos != len(data):
                raise ValueError("bytes after the end")
            return found
        if opcode == STAND_WALK:
            found["stand"], pos = big_smart(data, pos)
            found["walk"], pos = big_smart(data, pos)
        elif opcode in ANIMS:
            found[ANIMS[opcode]], pos = big_smart(data, pos)
        elif opcode == IDLES:
            count, pos = data[pos], pos + 1
            found["idles"] = []
            for _ in range(count):
                anim, pos = big_smart(data, pos)
                found["idles"].append([anim, data[pos]])
                pos += 2
        elif opcode in SETTINGS:
            pos += SETTINGS[opcode]
        else:
            raise ValueError(f"unknown opcode {opcode}")
    raise ValueError("no end")


# The order a set's animations are written in: stand and walk first, idles last.
ORDER = ["stand", "walk"] + list(ANIMS.values()) + ["idles"]


def lua_line(set_id, anims, names):
    """A set's line of dev/anim_sets.lua, its animations in ORDER (one that is -1, none, is left out), and
    its standing animation's name as a comment."""
    parts = []
    for key in (k for k in ORDER if k in anims):
        value = anims[key]
        if key == "idles":
            parts.append("idles = { " + ", ".join(f"{{ {a}, {w} }}" for a, w in value) + " }")
        elif value != -1:
            parts.append(f"{key} = {value}")
    stand = anims.get("stand", -1)
    comment = f"  -- {names[stand]}" if stand in names else ""
    return f"    [{set_id}] = {{ {', '.join(parts)} }},{comment}"


def main():
    parser = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    parser.add_argument("--cache", type=Path, default=DEFAULT_CACHE)
    args = parser.parse_args()

    path = args.cache / CONFIG_INDEX
    if not path.exists():
        print(f"No cache at {path}: pass --cache with the folder the RuneScape client keeps it in.")
        return 1
    # (read-only and immutable, so the running client is never locked or written to)
    db = sqlite3.connect(f"file:{path.as_posix()}?mode=ro&immutable=1", uri=True)
    row = db.execute("SELECT DATA FROM cache WHERE KEY = ?", (ANIM_SET_GROUP,)).fetchone()
    if row is None:
        print(f"The cache has no group {ANIM_SET_GROUP} (animation sets) in {CONFIG_INDEX}.")
        return 1

    ids = file_ids(unzip(db.execute("SELECT DATA FROM cache_index").fetchone()[0]), ANIM_SET_GROUP)
    files = archive_files(row[0])
    if len(files) < len(ids):
        print(f"The index lists {len(ids)} animation sets but the cache holds {len(files)}: nothing was written.")
        return 1
    sets, problems = {}, []
    for set_id, data in zip(ids, files):
        if not data:
            continue
        try:
            sets[set_id] = read_set(data)
        except (ValueError, IndexError, struct.error) as problem:
            problems.append(f"  set {set_id}: {problem} ({data[:24].hex(' ')})")
    if problems:
        print(f"{len(problems)} animation sets didn't read cleanly, so nothing was written (the cache's"
              " layout may have changed):\n" + "\n".join(problems[:20]))
        return 1

    names = {}
    if SEQ_NAMES.exists():
        for line in SEQ_NAMES.read_text(encoding="utf-8").splitlines():
            seq_id, _, name = line.partition(" ")
            if seq_id.isdigit():
                names[int(seq_id)] = name
    lines = ["-- dev/anim_sets.lua",
             "-- Made by dev/anim_sets.py from the RuneScape client's cache. Do not edit; run it again.",
             "-- Data from the RuneScape client, which belongs to Jagex: not covered by this repository's licence.",
             "-- Used only by the developer tools (dev/), which are left out of the released plugin.",
             "-- Every animation set (an NPC's `bas`: config.NPC.FromID(id).bas.id) and its animations:",
             "-- stand, walk, run and their directions and turns, and `idles`, the animations it plays",
             "-- now and then, as { id, weight }. The comment is the standing animation's name.",
             "return {"]
    lines += [lua_line(set_id, anims, names) for set_id, anims in sorted(sets.items())]
    lines.append("}")
    OUTPUT.write_text("\n".join(lines) + "\n", encoding="utf-8")
    print(f"{len(sets)} animation sets written to {OUTPUT.relative_to(ROOT)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
