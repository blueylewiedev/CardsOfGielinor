#!/usr/bin/env python3
"""Makes the card pictures of the site uniform (used by dev/build_site.py, needs Pillow).

The wiki's pictures come in every size and shape: trimmed to the item, so a rapier is a tall thin
strip, a small item is a tiny file, and a sword on the diagonal is a square. Shown as they are, the
long ones are cut off and the small ones are lost. This turns each into a picture on a canvas of
one size:

  1. A weapon that is long and thin and lies near vertical or horizontal is turned to the diagonal
     the other swords lie on, tip (or head) to the top right, so it fills the card the same way.
  2. The picture is trimmed to the item, scaled up or down to fill the canvas (a small one is only
     enlarged so far, MAX_UPSCALE), and centred on transparent padding.

The unprocessed pictures stay in dev/wiki_cache/img_raw/ (not committed), so this can be run again
and tuned as often as wanted without asking the wiki for anything.

Run on its own to look at the result without touching the site:
    python -I dev/site_images.py --sheet out.png id1 id2 ...   a contact sheet of before and after
"""

import math
import sys
from pathlib import Path

from PIL import Image, ImageDraw

CANVAS = (320, 272)         # the processed pictures' size: the card's picture box is 1 : 0.85
MAX_UPSCALE = 4.0           # a small picture is enlarged at most this much (it goes soft beyond)
ELONGATED = 2.0             # long side / short side of a weapon's shape above which it is turned
TALL_OR_WIDE = 1.6          # ...and the picture itself must be this much taller than wide (or wider than tall):
                            # a curved blade on the diagonal is long and thin too, but is fine as it is
OFF_DIAGONAL = 22.5         # degrees from the top-right diagonal beyond which it is turned
ALPHA_MIN = 12              # alpha at or below this counts as empty

# Weapon kinds whose business end is a point (the narrow end goes to the top right); the others
# (axes, maces, halberds, staffs...) have a head, the wide end, which goes to the top right.
POINTED = {"dagger", "sword", "scimitar", "two_handed_sword", "spear", "claw", "whip", "shortbow",
           "longbow", "crossbow", "thrown", "wand", "lantern", "siphon"}

# Pictures to turn the other way round after the automatic choice (the tip pointing down left), by
# card id. Filled in after looking at the contact sheet.
TURN_AROUND = {"argonite_battleaxe", "black_defender"}
# Pictures never to turn, by card id.
LEAVE_ALONE = set()


def trim(image):
    """The picture cut down to the parts that are not empty."""
    box = image.getchannel("A").point(lambda a: 255 if a > ALPHA_MIN else 0).getbbox()
    return image.crop(box) if box else image


def mask_points(image, size=96):
    """The filled pixels of a small copy of the picture as (x, y) with y up, centred on the
    middle of the picture, for working out its shape."""
    small = image.copy()
    small.thumbnail((size, size))
    alpha = small.getchannel("A")
    width, height = small.size
    data = alpha.tobytes()
    points = [(i % width - width / 2, height / 2 - i // width) for i, a in enumerate(data) if a > ALPHA_MIN]
    return points, max(width, height)


def principal_axis(points):
    """(angle in degrees from 0 to 180 measured anticlockwise from the right, long / short ratio)
    of the filled points: the direction the item mostly points in."""
    n = len(points)
    if n < 10:
        return 45.0, 1.0
    mx = sum(p[0] for p in points) / n
    my = sum(p[1] for p in points) / n
    sxx = sum((p[0] - mx) ** 2 for p in points) / n
    syy = sum((p[1] - my) ** 2 for p in points) / n
    sxy = sum((p[0] - mx) * (p[1] - my) for p in points) / n
    angle = 0.5 * math.degrees(math.atan2(2 * sxy, sxx - syy)) % 180
    spread = math.sqrt(((sxx - syy) / 2) ** 2 + sxy ** 2)
    long_, short = (sxx + syy) / 2 + spread, (sxx + syy) / 2 - spread
    return angle, math.sqrt(long_ / short) if short > 1e-9 else 99.0


def end_weights(points, angle, share=0.18):
    """How much of the item lies in the last `share` of its length at each end of its axis:
    (the end towards the top right, the end towards the bottom left)."""
    ux, uy = math.cos(math.radians(angle)), math.sin(math.radians(angle))
    along = [p[0] * ux + p[1] * uy for p in points]
    low, high = min(along), max(along)
    edge = (high - low) * share
    upper = sum(1 for a in along if a >= high - edge)
    lower = sum(1 for a in along if a <= low + edge)
    return upper, lower


def turn_to_diagonal(image, kinds, card_id):
    """The picture turned so a long thin weapon lies on the top right diagonal, or as it was if it
    already does (or is not long). Returns (picture, note) where the note says what was done."""
    if card_id in LEAVE_ALONE:
        return image, ""
    width, height = image.size
    if max(width, height) < TALL_OR_WIDE * min(width, height):
        return (image.rotate(180, expand=True, resample=Image.BICUBIC) if card_id in TURN_AROUND else image), ""
    points, _ = mask_points(image)
    angle, ratio = principal_axis(points)
    off = abs(((angle - 45) + 90) % 180 - 90)         # distance from the diagonal, 0 to 90
    if ratio < ELONGATED or off <= OFF_DIAGONAL:
        flip = card_id in TURN_AROUND
        return (image.rotate(180, expand=True, resample=Image.BICUBIC) if flip else image), ("turned around" if flip else "")
    turn = ((45 - angle) + 90) % 180 - 90             # degrees anticlockwise, the short way round
    turned = image.rotate(turn, expand=True, resample=Image.BICUBIC)
    # (which end is up now: the tip of a pointed weapon should be, or the head of the others)
    new_points, _ = mask_points(trim(turned))
    upper, lower = end_weights(new_points, 45)
    pointed = bool(set(kinds) & POINTED)
    want_upper_smaller = pointed
    wrong_way = (upper > lower) if want_upper_smaller else (upper < lower)
    if card_id in TURN_AROUND:
        wrong_way = not wrong_way
    if wrong_way:
        turned = turned.rotate(180, expand=False, resample=Image.BICUBIC)
    return turned, f"turned {turn:+.0f} degrees" + (" and round" if wrong_way else "")


def fit(image, size=CANVAS):
    """The picture trimmed, scaled to fill the canvas as far as it goes, and centred on it."""
    image = trim(image)
    width, height = image.size
    scale = min(size[0] / width, size[1] / height, MAX_UPSCALE)
    new_size = (max(1, round(width * scale)), max(1, round(height * scale)))
    resample = Image.LANCZOS
    scaled = image.resize(new_size, resample)
    canvas = Image.new("RGBA", size, (0, 0, 0, 0))
    canvas.paste(scaled, ((size[0] - new_size[0]) // 2, (size[1] - new_size[1]) // 2), scaled)
    return canvas, scale


def process(source, kinds=(), is_weapon=False, card_id=""):
    """The processed picture for the file `source`: (image, note). `kinds` are the card's category
    words; only a weapon is ever turned."""
    with Image.open(source) as opened:
        image = trim(opened.convert("RGBA"))
    note = ""
    if is_weapon:
        image, note = turn_to_diagonal(image, kinds, card_id)
    done, scale = fit(image)
    if scale >= MAX_UPSCALE - 1e-9:
        note = (note + "; " if note else "") + f"small source, enlarged {scale:.1f}x"
    return done, note


def sheet(pairs, path):
    """A contact sheet: each row is a picture as it was and as it is now, on the card's colour."""
    cell = (CANVAS[0] // 2, CANVAS[1] // 2)
    back = (38, 28, 44, 255)
    columns = 3
    rows = math.ceil(len(pairs) / columns)
    page = Image.new("RGBA", (columns * (cell[0] * 2 + 30), rows * (cell[1] + 28)), (20, 16, 12, 255))
    draw = ImageDraw.Draw(page)
    for index, (name, before, after, note) in enumerate(pairs):
        x = (index % columns) * (cell[0] * 2 + 30) + 4
        y = (index // columns) * (cell[1] + 28) + 4
        for offset, picture in enumerate((before, after)):
            box = Image.new("RGBA", cell, back)
            shown = picture.copy()
            shown.thumbnail(cell)
            box.paste(shown, ((cell[0] - shown.width) // 2, (cell[1] - shown.height) // 2), shown)
            page.paste(box, (x + offset * (cell[0] + 4), y))
        draw.text((x, y + cell[1] + 2), f"{name}  {note}"[:70], fill=(220, 210, 190, 255))
    page.convert("RGB").save(path)


if __name__ == "__main__":
    # python -I dev/site_images.py --sheet out.png id id ...   (reads docs/img and docs/cards.json)
    import json
    root = Path(__file__).resolve().parent.parent
    if len(sys.argv) < 4 or sys.argv[1] != "--sheet":
        raise SystemExit(__doc__)
    cards = {c["id"]: c for c in json.loads((root / "docs" / "cards.json").read_text(encoding="utf-8"))["cards"]}
    shown = []
    for card_id in sys.argv[3:]:
        card = cards[card_id]
        source = root / "docs" / card["img"]
        category = card["tags"].get("category", [])
        done, note = process(source, category, "weapon" in category, card_id)
        shown.append((card["name"], Image.open(source).convert("RGBA"), done, note))
    sheet(shown, sys.argv[2])
    print("wrote", sys.argv[2])
