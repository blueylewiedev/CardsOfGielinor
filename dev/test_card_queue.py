#!/usr/bin/env python3
"""Checks how the card tools read and edit the tag words in core/tagwords.lua: python dev/test_card_queue.py

dev/card_queue.py adds the location and NPC category words a queued card uses, writing into core/tagwords.lua as text; dev/wiki_cards.py and
dev/make_pack_art.py read the same file with regular expressions. The tests run the word-adding on a COPY of the file with made-up cards,
and read the real file the way the tools do. The "Check cards" workflow runs it.
"""

import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import card_queue
import make_pack_art
import wiki_cards

ROOT = Path(__file__).resolve().parent.parent
LUA = shutil.which("lua5.4") or shutil.which("lua")


def lua_words(path, expression):
    """What a Lua expression over the module at `path` prints, with the module as T."""
    script = f'package.path = "./?.lua;" .. package.path; local T = dofile("{path.as_posix()}"); print({expression})'
    return subprocess.run([LUA, "-e", script], capture_output=True, text=True, cwd=ROOT, check=True).stdout.strip()


def entry(card_id, deck, tags):
    return {"id": card_id, "deck": deck, "block": f'{{ id = "{card_id}", name = "{card_id}", tags = {{ {tags} }} }},'}


class ReadingTheWords(unittest.TestCase):
    def test_the_wiki_tool_reads_every_kind(self):
        words = wiki_cards.allowed_words()
        self.assertIn("misthalin", words["regions"])
        self.assertIn("lumbridge", words["location"])
        self.assertIn("thieving", words["skills"])
        self.assertIn("humanoid", words["category"])
        self.assertIn("food", words["item_category"])
        self.assertEqual(words["item_requires"].get("scimitar"), ["weapon"])
        self.assertEqual(len(set(words["regions"])), len(words["regions"]))

    def test_the_pack_art_tool_reads_the_regions(self):
        self.assertEqual(make_pack_art.regions(), wiki_cards.allowed_words()["regions"])

    def test_the_limits_are_read(self):
        self.assertEqual(wiki_cards.MAX_DESC, 80)
        self.assertEqual(wiki_cards.MAX_NPC_REGIONS, 2)


@unittest.skipIf(LUA is None, "no lua on the path")
class AddingWords(unittest.TestCase):
    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory()
        self.copy = Path(self.scratch.name) / "tagwords.lua"
        shutil.copy(card_queue.TAGWORDS, self.copy)
        self.real = card_queue.TAGWORDS
        card_queue.TAGWORDS = self.copy

    def tearDown(self):
        card_queue.TAGWORDS = self.real
        self.scratch.cleanup()

    def test_a_new_location_and_npc_category_are_added_and_the_file_still_loads(self):
        before = self.copy.read_bytes()
        card_queue.add_tag_words([entry("zz_test", "deck/npcs/misthalin", 'location = { "zz_new_place" }, category = { "zz_new_kind" }')], False)
        self.assertNotEqual(self.copy.read_bytes(), before)
        self.assertEqual(lua_words(self.copy, 'T.words.location[#T.words.location]'), "zz_new_place")
        self.assertEqual(lua_words(self.copy, 'T.groups.category[1].words[#T.groups.category[1].words]'), "zz_new_kind")

    def test_a_dry_run_changes_nothing(self):
        before = self.copy.read_bytes()
        card_queue.add_tag_words([entry("zz_test", "deck/npcs/misthalin", 'location = { "zz_new_place" }')], True)
        self.assertEqual(self.copy.read_bytes(), before)

    def test_words_already_listed_are_not_added_again(self):
        before = self.copy.read_bytes()
        card_queue.add_tag_words([entry("zz_test", "deck/npcs/misthalin", 'location = { "lumbridge" }, category = { "humanoid" }, regions = { "misthalin" }')], False)
        self.assertEqual(self.copy.read_bytes(), before)

    def test_words_that_are_not_added_are_left_alone(self):
        before = self.copy.read_bytes()
        card_queue.add_tag_words([
            entry("zz_item", "deck/items/zz", 'category = { "zz_item_kind" }'),                 # an item category goes in its group by hand
            entry("zz_typo", "deck/npcs/misthalin", 'skills = { "zz_no_skill" }, location = { "Not A Word" }'),
        ], False)
        self.assertEqual(self.copy.read_bytes(), before)

    def test_it_keeps_the_files_line_endings(self):
        crlf = self.copy.read_bytes().replace(b"\r\n", b"\n").replace(b"\n", b"\r\n")
        self.copy.write_bytes(crlf)
        card_queue.add_tag_words([entry("zz_test", "deck/npcs/misthalin", 'location = { "zz_new_place" }')], False)
        data = self.copy.read_bytes()
        self.assertEqual(data.count(b"\n"), data.count(b"\r\n"))


if __name__ == "__main__":
    unittest.main()
