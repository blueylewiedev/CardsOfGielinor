#!/usr/bin/env python3
"""Proves that a change touched only comments and layout: python dev/check_bytecode.py [REV] [files...]

Compiles each shipped Lua file as it is in git revision REV (default HEAD) and as it is in the working tree, lists the
compiler's instructions for both (luac -l -l) with everything that depends on where the code sits in the file removed (line
numbers, the lines a function spans, memory addresses), and says whether the two listings are the same. The same
instructions, constants, locals and upvalues mean the code behaves exactly the same, whatever was done to comments, blank
lines or line breaks. With no files it checks main.lua, core/ and ui/. Exits 1 if any file differs or is missing.
"""
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
POSITION = [
    (re.compile(r"\[\d+\]"), ""),                       # the source line of an instruction
    (re.compile(r"<[^>]*:\d+,\d+>"), "<fn>"),            # "function <file:first,last>"
    (re.compile(r"\b0x[0-9A-Fa-f]+\b|\b[0-9A-F]{12,16}\b"), "@"),   # memory addresses
    (re.compile(r"\d+ lines? at "), ""),
]


def listing(source: bytes, work: Path):
    """The instruction listing of Lua source with positions removed, or None if it does not compile."""
    src = work / "in.lua"
    src.write_bytes(source)
    result = subprocess.run(["luac", "-l", "-l", "-p", str(src)], capture_output=True, text=True, cwd=work)
    if result.returncode != 0:
        return None
    text = result.stdout
    for pattern, replacement in POSITION:
        text = pattern.sub(replacement, text)
    return [line.strip() for line in text.splitlines() if line.strip()]


def shipped_files():
    listing_ = subprocess.run(["git", "ls-files", "main.lua", "core", "ui"], cwd=ROOT, capture_output=True, text=True).stdout
    return [name for name in listing_.split() if name.endswith(".lua")]


def main(argv):
    rev = "HEAD"
    if argv and not argv[0].endswith(".lua"):
        rev, argv = argv[0], argv[1:]
    files = argv or shipped_files()
    different = []
    with tempfile.TemporaryDirectory() as tmp:
        work = Path(tmp)
        for name in files:
            old = subprocess.run(["git", "show", f"{rev}:{name}"], cwd=ROOT, capture_output=True)
            path = ROOT / name
            if old.returncode != 0 or not path.exists():
                different.append(f"{name}: not in both {rev} and the working tree")
                continue
            before, after = listing(old.stdout, work), listing(path.read_bytes(), work)
            if before is None or after is None:
                different.append(f"{name}: does not compile ({'working tree' if after is None else rev})")
            elif before != after:
                first = next((i for i, (a, b) in enumerate(zip(before, after)) if a != b), min(len(before), len(after)))
                different.append(f"{name}: the code differs from {rev} (first difference at instruction line {first})")
    if different:
        print(f"Code differs from {rev} in {len(different)} of {len(files)} files:")
        for line in different:
            print("  " + line)
        return 1
    print(f"OK: {len(files)} files compile to the same instructions as {rev}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
