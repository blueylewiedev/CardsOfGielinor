#!/usr/bin/env python3
"""Builds the release version of the Card Collector plugin.

Usage:  python build_release.py <plugin folder> <output folder>

Copies the plugin folder to the output folder, leaving out the development tools (the `dev`
folder) and anything that is not part of the plugin (notes, backups, test files). The plugin
checks for `dev/dev.lua` when it starts, so without that folder it runs as the released version.
"""
import shutil
import sys
from pathlib import Path

# Folders and file types that never go into the release.
LEFT_OUT_FOLDERS = {"dev", ".git", "__pycache__", "notes"}
LEFT_OUT_SUFFIXES = {".md", ".bak", ".py", ".pyc"}


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 1
    source, target = Path(sys.argv[1]), Path(sys.argv[2])
    if not (source / "main.lua").exists():
        print("No main.lua in", source, "- is that the plugin folder?")
        return 1
    if target.exists():
        shutil.rmtree(target)

    def ignore(folder, names):
        return [name for name in names
                if name in LEFT_OUT_FOLDERS or Path(name).suffix in LEFT_OUT_SUFFIXES]

    shutil.copytree(source, target, ignore=ignore)
    if (target / "dev").exists():
        print("The dev folder is still in the release!")
        return 1
    print("Release written to", target)
    for path in sorted(target.rglob("*")):
        if path.is_file():
            print("  ", path.relative_to(target))
    print("Remember: set a real contactEmailAddress in plugin.json before submitting.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
