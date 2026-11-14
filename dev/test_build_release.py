#!/usr/bin/env python3
"""Checks dev/build_release.py: python dev/test_build_release.py

Builds a release from a made-up plugin folder full of things that must stay out (and things that must go in),
then from this repository, and checks what came out. The "Check cards" workflow runs it.
"""

import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build_release as B

ROOT = Path(__file__).resolve().parent.parent


def write(folder, relative, text="x"):
    path = folder / relative
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text, encoding="utf-8")


def tree(folder):
    return sorted(p.relative_to(folder).as_posix() for p in folder.rglob("*") if p.is_file())


class MadeUpPlugin(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory()
        self.source = Path(self.scratch.name) / "plugin"
        self.target = Path(self.scratch.name) / "release"
        for name in ("main.lua", "plugin.json", "LICENSE", "core/cards.lua", "core/json.lua", "ui/kit.lua",
                     "deck/index.lua", "deck/npcs/a.lua", "resources/images/frame.png", "resources/images/CREDITS.md"):
            write(self.source, name)
        for name in ("dev/dev.lua", "docs/index.html", "docs/cards.json", ".github/workflows/x.yml", ".github/CODEOWNERS",
                     ".vscode/settings.json", ".git/config", ".gitignore", ".prettierignore", ".luarc.json", ".gitattributes",
                     "notes/plan.md", "README.md", "CONTRIBUTING.md", "RELEASING.md", "CLAUDE.md", "build.py", "extra.txt",
                     "newfolder/file.lua", "core/.hidden", "core/__pycache__/x.pyc", "core/old.bak", "core/tool.py",
                     "core/NOTES.md", "resources/README.md", "deck/npcs/.DS_Store", "ui/.vscode/x.json"):
            write(self.source, name)
        B.copy_release(self.source, self.target)

    def tearDown(self):
        self.scratch.cleanup()

    def test_only_the_plugin_is_copied(self):
        self.assertEqual(tree(self.target), [
            "LICENSE", "core/cards.lua", "core/json.lua", "deck/index.lua", "deck/npcs/a.lua", "main.lua",
            "plugin.json", "resources/images/CREDITS.md", "resources/images/frame.png", "ui/kit.lua"])

    def test_the_result_has_no_problems(self):
        self.assertEqual(B.problems_in(self.target), [])

    def test_it_replaces_an_old_release(self):
        write(self.target, "stale.lua")
        B.copy_release(self.source, self.target)
        self.assertNotIn("stale.lua", tree(self.target))

    def test_problems_are_found(self):
        write(self.target, "dev/dev.lua")
        write(self.target, ".vscode/settings.json")
        write(self.target, "README.md")
        write(self.target, "core/leftover.bak")
        write(self.target, "notes.txt")
        messages = " | ".join(B.problems_in(self.target))
        for expected in ("dev folder", ".vscode", "README.md", "leftover.bak", "notes.txt"):
            self.assertIn(expected, messages)

    def test_a_missing_file_is_a_problem(self):
        (self.target / "plugin.json").unlink()
        self.assertTrue(any("plugin.json is missing" in m for m in B.problems_in(self.target)))


class ThisRepository(unittest.TestCase):
    def test_the_real_release_is_clean(self):
        with tempfile.TemporaryDirectory() as scratch:
            target = Path(scratch) / "release"
            B.copy_release(ROOT, target)
            self.assertEqual(B.problems_in(target), [])
            names = {p.name for p in target.iterdir()}
            self.assertEqual(names, {"main.lua", "plugin.json", "LICENSE", "core", "ui", "deck", "resources"})
            files = tree(target)
            for bad in (".github", ".vscode", ".gitignore", ".prettierignore", "dev/", "docs/", "notes/", "CLAUDE.md",
                        "README.md", "CONTRIBUTING.md", "RELEASING.md"):
                self.assertFalse(any(f.startswith(bad) or f == bad for f in files), bad)
            self.assertIn("resources/images/CREDITS.md", files)


if __name__ == "__main__":
    unittest.main(verbosity=1)
