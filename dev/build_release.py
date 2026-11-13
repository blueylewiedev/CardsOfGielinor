#!/usr/bin/env python3
"""Builds the release version of the Cards of Gielinor plugin.

Usage:  python build_release.py <plugin folder> <output folder>

The release holds only what the plugin needs to run, from an allow-list, so a file added to the repository
later (a config file, a note, a new folder) is left out until it is listed here on purpose:

    main.lua, plugin.json, LICENSE and the folders core, ui, deck and resources

Inside those folders it also leaves out hidden files and folders (anything starting with a dot),
`__pycache__`, backups (.bak), Python files and Markdown files (README, notes), except the artwork credits
(resources/images/CREDITS.md), which belong with the artwork. Everything else in the repository stays out: the
development tools (`dev`), the card browser website (`docs`), the workflows (`.github`), editor and git files,
notes, and the Markdown documents (README.md, CONTRIBUTING.md, RELEASING.md).

The plugin checks for `dev/dev.lua` when it starts, so without that folder it runs as the released version.
After copying it checks the result and stops with a message if anything is wrong. Jagex's good practice page
asks for development files to be left out ("such as .git, .gitignore, .luarc.json or README.md").
"""
import shutil
import sys
from pathlib import Path

# The only top-level entries in the release.
RELEASE_FILES = {"main.lua", "plugin.json", "LICENSE"}
RELEASE_FOLDERS = {"core", "ui", "deck", "resources"}
# Never copied from inside those folders.
LEFT_OUT_SUFFIXES = {".md", ".bak", ".py", ".pyc"}
KEPT_ANYWAY = {"resources/images/CREDITS.md"}


def left_out_inside(relative):
    """True if a file or folder inside a release folder (path from the plugin folder, with /) stays out."""
    if relative in KEPT_ANYWAY:
        return False
    name = relative.rsplit("/", 1)[-1]
    return name.startswith(".") or name == "__pycache__" or Path(name).suffix in LEFT_OUT_SUFFIXES


def copy_release(source, target):
    """Copies the release from the plugin folder `source` to `target` (replaced if it exists)."""
    if target.exists():
        shutil.rmtree(target)
    target.mkdir(parents=True)
    for name in sorted(RELEASE_FILES):
        if (source / name).exists():
            shutil.copy2(source / name, target / name)

    def copy_folder(folder, destination):
        destination.mkdir(parents=True, exist_ok=True)
        for entry in sorted(folder.iterdir()):
            relative = entry.relative_to(source).as_posix()
            if left_out_inside(relative):
                continue
            if entry.is_dir():
                copy_folder(entry, destination / entry.name)
            else:
                shutil.copy2(entry, destination / entry.name)

    for name in sorted(RELEASE_FOLDERS):
        if (source / name).is_dir():
            copy_folder(source / name, target / name)


def problems_in(target):
    """What is wrong with a release folder, as a list of messages (empty if it is fine)."""
    problems = []
    for needed in ("main.lua", "plugin.json", "core/cards.lua", "deck/index.lua"):
        if not (target / needed).is_file():
            problems.append(f"{needed} is missing")
    for entry in sorted(target.iterdir()):
        if entry.name not in RELEASE_FILES and entry.name not in RELEASE_FOLDERS:
            problems.append(f"{entry.name} should not be in the release")
    for path in sorted(target.rglob("*")):
        relative = path.relative_to(target).as_posix()
        if any(part.startswith(".") or part == "__pycache__" for part in relative.split("/")):
            problems.append(f"{relative} is a hidden or cache file")
        elif path.is_file() and path.suffix in LEFT_OUT_SUFFIXES and relative not in KEPT_ANYWAY:
            problems.append(f"{relative} should not be in the release")
    if (target / "dev").exists():
        problems.append("the dev folder is in the release: the plugin would run with the development tools")
    return problems


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 1
    source, target = Path(sys.argv[1]).resolve(), Path(sys.argv[2]).resolve()
    if not (source / "main.lua").exists():
        print("No main.lua in", source, "- is that the plugin folder?")
        return 1
    if target == source or target in source.parents or source in target.parents:
        print("The output folder must be somewhere else: not the plugin folder, inside it, or a folder that holds it.")
        return 1
    copy_release(source, target)
    problems = problems_in(target)
    if problems:
        print("The release is not right:")
        for problem in problems:
            print("  ", problem)
        return 1

    files = [path for path in sorted(target.rglob("*")) if path.is_file()]
    print("Release written to", target)
    print(f"  {len(files)} files; top level: " + ", ".join(sorted(entry.name for entry in target.iterdir())))
    left_out = sorted(entry.name for entry in source.iterdir()
                      if entry.name not in RELEASE_FILES and entry.name not in RELEASE_FOLDERS and entry.name != ".git")
    print("  left out of the top level: " + ", ".join(left_out))
    print("Before submitting: a real contactEmailAddress in plugin.json, and the version in plugin.json and core/version.lua.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
