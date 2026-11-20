#!/usr/bin/env python3
"""Proves that a change touched only comments and layout: python dev/check_bytecode.py [REV] [files...]

Compiles each shipped Lua file as it is in git revision REV (default HEAD) and as it is in the working tree, with the
compiler's debug information stripped (luac -s), and says whether the two are byte for byte the same. Identical
bytecode means the code behaves exactly the same, whatever was done to comments, blank lines or line breaks.
With no files it checks main.lua, core/ and ui/. Exits 1 if any file differs or is missing from one side.
"""
import os
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent


def compile_bytes(source: bytes, work: Path):
    """The stripped bytecode of Lua source, or None if it does not compile."""
    src, out = work / "in.lua", work / "out.luac"
    src.write_bytes(source)
    result = subprocess.run(["luac", "-s", "-o", str(out), str(src)], capture_output=True)
    return out.read_bytes() if result.returncode == 0 else None


def shipped_files():
    listing = subprocess.run(["git", "ls-files", "main.lua", "core", "ui"], cwd=ROOT, capture_output=True, text=True).stdout
    return [name for name in listing.split() if name.endswith(".lua")]


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
            before, after = compile_bytes(old.stdout, work), compile_bytes(path.read_bytes(), work)
            if before is None or after is None:
                different.append(f"{name}: does not compile ({'working tree' if after is None else rev})")
            elif before != after:
                different.append(f"{name}: the code differs from {rev}")
    if different:
        print(f"Code differs from {rev} in {len(different)} of {len(files)} files:")
        for line in different:
            print("  " + line)
        return 1
    print(f"OK: {len(files)} files compile to the same bytecode as {rev}")
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
