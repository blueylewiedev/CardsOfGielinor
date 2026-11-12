#!/usr/bin/env python3
"""Checks the parts of dev/build_overlay.py that decide what the overlay says (no git, no Lua):

    python dev/test_build_overlay.py

What goes in it (new, changed, deprecated), the header, and when the revision rises. The "Check cards" workflow
runs it.
"""

import json
import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
import build_overlay as B


def line(card_id, **fields):
    return json.dumps(dict(fields, id=card_id), sort_keys=True, separators=(",", ":"))


class Diff(unittest.TestCase):
    def test_nothing_changed(self):
        base = {"a": line("a"), "b": line("b")}
        self.assertEqual(B.diff(base, dict(base)), ([], [], 0))

    def test_new_changed_and_removed(self):
        base = {"a": line("a", rarity="common"), "b": line("b"), "gone": line("gone")}
        current = {"a": line("a", rarity="rare"), "b": line("b"), "z": line("z"), "new": line("new")}
        changed, deprecated, new = B.diff(base, current)
        self.assertEqual(changed, [line("a", rarity="rare"), line("new"), line("z")])    # by id
        self.assertEqual(deprecated, ["gone"])
        self.assertEqual(new, 2)

    def test_a_card_that_came_back_is_not_deprecated(self):
        self.assertEqual(B.diff({"a": line("a")}, {"a": line("a")})[1], [])

    def test_empty_base_makes_every_card_new(self):
        changed, deprecated, new = B.diff({}, {"a": line("a"), "b": line("b")})
        self.assertEqual((len(changed), deprecated, new), (2, [], 2))


class Text(unittest.TestCase):
    def test_header_and_lines(self):
        body = B.body_lines([line("a")], ["old", "older"])
        text = B.overlay_text("0.2.0", 3, body)
        lines = text.split("\n")
        self.assertEqual(json.loads(lines[0]), {"base": "0.2.0", "format": 1, "revision": 3})
        self.assertEqual(lines[1], line("a"))
        self.assertEqual(json.loads(lines[2]), {"deprecated": "old"})
        self.assertEqual(json.loads(lines[3]), {"deprecated": "older"})
        self.assertTrue(text.endswith("\n") and not text.endswith("\n\n"))

    def test_empty_overlay_is_just_a_header(self):
        text = B.overlay_text("0.1.0", 1, [])
        self.assertEqual(text, '{"base":"0.1.0","format":1,"revision":1}\n')

    def test_each_line_is_json(self):
        for text in B.overlay_text("0.1.0", 1, B.body_lines([line("a", name='q"uote')], ["x"])).split("\n"):
            if text:
                json.loads(text)


class Revision(unittest.TestCase):
    def test_first_build(self):
        self.assertEqual(B.next_revision("", "0.1.0", []), 1)

    def test_same_content_keeps_the_revision(self):
        body = [line("a")]
        existing = B.overlay_text("0.1.0", 4, body)
        self.assertEqual(B.next_revision(existing, "0.1.0", body), 4)

    def test_new_content_raises_it(self):
        existing = B.overlay_text("0.1.0", 4, [line("a")])
        self.assertEqual(B.next_revision(existing, "0.1.0", [line("a"), line("b")]), 5)
        self.assertEqual(B.next_revision(existing, "0.1.0", []), 5)

    def test_a_new_base_starts_again(self):
        existing = B.overlay_text("0.1.0", 9, [line("a")])
        self.assertEqual(B.next_revision(existing, "0.2.0", [line("a")]), 1)

    def test_a_damaged_header_starts_again(self):
        self.assertEqual(B.next_revision("not json\n", "0.1.0", []), 1)
        self.assertEqual(B.next_revision('{"base":"0.1.0","revision":"x"}\n', "0.1.0", []), 1)

    def test_the_text_is_stable(self):
        body = [line("a")]
        first = B.overlay_text("0.1.0", B.next_revision("", "0.1.0", body), body)
        second = B.overlay_text("0.1.0", B.next_revision(first, "0.1.0", body), body)
        self.assertEqual(first, second)


if __name__ == "__main__":
    unittest.main(verbosity=1)
