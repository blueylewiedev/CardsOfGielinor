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
from unittest import mock

sys.path.insert(0, str(Path(__file__).resolve().parent))
import card_queue
import lookalikes
import wiki_cards

try:
    import make_pack_art                      # needs Pillow (the workflow installs it); without it that one test is skipped
except ModuleNotFoundError:
    make_pack_art = None

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

    @unittest.skipIf(make_pack_art is None, "Pillow is not installed")
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


DECK = (
    "local Set = {}\r\nSet.cards = {\r\n"
    "    {\r\n        id = \"zz_hound\", name = \"Zz hound\", rarity = \"common\",\r\n        desc = \"x\",\r\n"
    "        art = { npc = \"ZZ_HOUND\", anim = 1, cam = { dist = 2 } },\r\n"
    "        tags = { location = { \"zz_cave\" }, category = { \"monster\" }, membership = { \"p2p\" } },\r\n    },\r\n"
    "    { id = \"zz_crab\", name = \"Zz crab\", rarity = \"common\", desc = \"y\", art = { npc = \"ZZ_CRAB\" }, tags = { category = { \"monster\" } } },\r\n"
    "    { id = \"zz_pet\", name = \"Zz pet\", rarity = \"rare\", desc = \"z\", art = { npc = \"ZZ_PET\" }, tags = { category = { \"pet\" } } },\r\n"
    "}\r\n\r\nreturn Set\r\n")
# (made-up looks: the configs in one group look the same)
LOOKS = {"ZZ_HOUND": "hound", "ZZ_HOUND_GWD": "hound", "ZZ_HOUND_RED": "red hound", "ZZ_CRAB": "crab", "ZZ_PET": "pet",
         "ZZ_PET_2": "pet"}


def queued(card_id, name, npc, tags):
    return {"id": card_id, "deck": "deck/npcs/zz",
            "block": f'{{ id = "{card_id}", name = "{name}", art = {{ npc = "{npc}" }}, tags = {{ {tags} }} }},'}


class Lookalikes(unittest.TestCase):
    """dev/lookalikes.py and the queue's use of it: a version that shares a card's name and look is added to it."""

    def setUp(self):
        self.scratch = tempfile.TemporaryDirectory()
        self.folder = Path(self.scratch.name)
        self.deck = self.folder / "zz.lua"
        self.deck.write_bytes(DECK.encode("utf-8"))
        patcher = mock.patch.object(card_queue, "look_of", lambda: LOOKS.get)
        patcher.start()
        self.addCleanup(patcher.stop)
        self.addCleanup(self.scratch.cleanup)

    def cards(self):
        return lookalikes.deck_cards(self.folder)

    def card(self, card_id):
        return next(c for c in self.cards() if c["id"] == card_id)

    def test_the_rule(self):
        cards = self.cards()
        self.assertEqual(lookalikes.twin("Zz hound (God Wars)", ["ZZ_HOUND_GWD"], cards, LOOKS.get)["id"], "zz_hound")
        self.assertIsNone(lookalikes.twin("Zz hound (Red)", ["ZZ_HOUND_RED"], cards, LOOKS.get), "a different look")
        self.assertIsNone(lookalikes.twin("Zz hound hunter", ["ZZ_HOUND_GWD"], cards, LOOKS.get), "a different name")
        self.assertIsNone(lookalikes.twin("Zz hound", ["ZZ_HOUND_GWD"], cards, LOOKS.get), "the card's own name")
        self.assertIsNone(lookalikes.twin("Zz pet (Somewhere)", ["ZZ_PET_2"], cards, LOOKS.get), "a pet")
        self.assertFalse(lookalikes.foldable("Zz guard (Somewhere)"), "a role")
        self.assertFalse(lookalikes.foldable("Wizard (Rune Temple)"), "a role")
        self.assertTrue(lookalikes.foldable("Hellhound (God Wars Dungeon)"))
        self.assertIsNone(lookalikes.twin("Zz hound (God Wars)", ["ZZ_HOUND_GWD"], cards, lambda c: None), "no looks")

    def test_a_queued_lookalike_becomes_a_variant_with_its_places(self):
        entry = queued("zz_hound_gwd", "Zz hound (God Wars)", "ZZ_HOUND_GWD", 'location = { "zz_gwd" }, category = { "monster" }')
        message = card_queue.fold(entry, self.cards(), False)
        self.assertIn("zz_hound", message)
        card = self.card("zz_hound")
        self.assertEqual(card["configs"], ["ZZ_HOUND", "ZZ_HOUND_GWD"])
        self.assertEqual(lookalikes.locations(self.deck.read_text(encoding="utf-8")[card["start"]:card["end"]]), ["zz_cave", "zz_gwd"])
        data = self.deck.read_bytes()
        self.assertEqual(data.count(b"\n"), data.count(b"\r\n"))

    def test_a_one_line_card_and_a_second_variant(self):
        lookalikes.add_variant(self.card("zz_crab"), "ZZ_CRAB_2", "Zz crab (Beach)", ["zz_beach"])
        lookalikes.add_variant(self.card("zz_crab"), "ZZ_CRAB_3", "Zz crab (Rock)")
        self.assertEqual(self.card("zz_crab")["configs"], ["ZZ_CRAB", "ZZ_CRAB_2", "ZZ_CRAB_3"])
        self.assertIn("already", lookalikes.add_variant(self.card("zz_crab"), "ZZ_CRAB_3", "Zz crab (Rock)"))

    def test_other_cards_are_left_to_be_added(self):
        before = self.deck.read_bytes()
        self.assertIsNone(card_queue.fold(queued("zz_red", "Zz hound (Red)", "ZZ_HOUND_RED", ""), self.cards(), False))
        self.assertIsNone(card_queue.fold(dict(queued("zz_x", "Zz hound (X)", "ZZ_HOUND_GWD", ""), deck="deck/items/zz"),
                                          self.cards(), False), "an item card")
        self.assertIn("would add", card_queue.fold(queued("zz_hound_gwd", "Zz hound (God Wars)", "ZZ_HOUND_GWD", ""), self.cards(), True))
        self.assertEqual(self.deck.read_bytes(), before, "nothing written (and a dry run writes nothing)")

    @unittest.skipIf(LUA is None, "no lua on the path")
    def test_the_deck_file_still_loads(self):
        card_queue.fold(queued("zz_hound_gwd", "Zz hound (God Wars)", "ZZ_HOUND_GWD", 'location = { "zz_gwd" }'), self.cards(), False)
        lookalikes.add_variant(self.card("zz_crab"), "ZZ_CRAB_2", "Zz crab (Beach)", ["zz_beach"])
        self.assertEqual(lua_words(self.deck, "#T.cards[1].variants .. ' ' .. #T.cards[2].variants .. ' ' .. T.cards[2].tags.location[1]"),
                         "2 2 zz_beach")


if __name__ == "__main__":
    unittest.main()
