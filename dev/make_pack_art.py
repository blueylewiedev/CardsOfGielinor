#!/usr/bin/env python3
"""Makes the files the pack wrappers are drawn from (see ui/packart.lua).

Usage:  python dev/make_pack_art.py <Cinzel .ttf>     (run from the plugin folder)

Cinzel is a free font (SIL Open Font License) from Google Fonts; the variable-weight file
(Cinzel-VariableFont_wght.ttf) is used at its Bold weight.

From resources/images/pack.png it makes:
  ui/packmask.lua                       strips that trace the pack's outline at 200 x 320. Each
                                        strip is a clipping layer in the game, showing its part of
                                        the art: body rows are horizontal strips, the crimped ends
                                        narrow columns, each with a small up/down shift (dy) taken
                                        from the crimp's ridges so the art looks pinched there.
  resources/images/pack_shading.png      the front's light and shadow: crimp ridges, the body's edge
                                        shadow and a thin outline, without the pack's lettering
  resources/images/pack_shading_back.png the same mirrored, with a seal seam down the middle

And for every region in Cards.tagWords.regions (core/cards.lua):
  resources/images/title_<region>.png    the region's name in Cinzel Bold, gold with a dark outline
                                        and a shadow, cropped to the text. The client can't scale
                                        text (and Cinzel Bold only comes at 18pt in game), so titles
                                        are drawn here, larger than shown, and shrunk in game.
  ui/packtitles.lua                     the titles in order, with each image's size (the client
                                        reports 0 x 0 for a sprite's size)

Run it again after changing pack.png or adding a region.
"""
import re
import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

ROOT = Path(__file__).resolve().parent.parent
IMAGES = ROOT / "resources" / "images"

# The pack mask -------------------------------------------------------------------------------
W, H = 200, 320                     # the size the mask is made at (ui/packart.lua scales it)
SRC_W, SRC_H = 320, 512             # pack.png
CRIMP_TOP, CRIMP_BOTTOM = 72, 446   # pack.png rows: above / below these are the crimps
BODY_INSET = 44, 74, 276, 444       # pack.png body rect that holds the lettering (left unshaded)
COL_W = 2                           # width of a crimp column, mask pixels
MAX_DY = 3                          # largest crimp shift, mask pixels
SEAM_W = 22                         # width of the seal seam on the back, pack.png pixels

# The titles ------------------------------------------------------------------------------------
TITLE_SIZE = 40                     # font size; titles are shown at about half this
OUTLINE = 3
SHADOW = (2, 3)
PAD = 8
GOLD_TOP, GOLD_BOTTOM = (255, 240, 180), (196, 140, 52)
OUTLINE_COLOUR = (36, 22, 8)


def lum(p):
    return 0.299 * p[0] + 0.587 * p[1] + 0.114 * p[2]


def make_mask(pack):
    small = pack.resize((W, H), Image.LANCZOS)
    alpha = small.getchannel("A").load()
    pix = small.load()
    top_band = CRIMP_TOP * H // SRC_H
    bottom_band = CRIMP_BOTTOM * H // SRC_H

    def opaque(x, y):
        return alpha[x, y] >= 128

    rects = []
    # Crimps: columns, each spanning its opaque rows inside the band, shifted by its ridge.
    for y0, y1 in ((0, top_band), (bottom_band, H)):
        lums = []
        for x in range(0, W, COL_W):
            vals = [lum(pix[xx, y]) for xx in range(x, min(W, x + COL_W)) for y in range(y0, y1) if opaque(xx, y)]
            lums.append(sum(vals) / len(vals) if vals else None)
        known = [v for v in lums if v is not None]
        mean = sum(known) / len(known)
        spread = max(1.0, (sum((v - mean) ** 2 for v in known) / len(known)) ** 0.5)
        for i, x in enumerate(range(0, W, COL_W)):
            if lums[i] is None:
                continue
            ys = [y for y in range(y0, y1) if any(opaque(xx, y) for xx in range(x, min(W, x + COL_W)))]
            if ys:
                dy = max(-MAX_DY, min(MAX_DY, round((lums[i] - mean) / spread * MAX_DY / 2)))
                rects.append((x, ys[0], min(COL_W, W - x), ys[-1] - ys[0] + 1, dy))
    # Body: one strip per run of rows with the same left/right extent.
    prev, start = None, top_band
    for y in range(top_band, bottom_band + 1):
        run = None
        if y < bottom_band:
            xs = [x for x in range(W) if opaque(x, y)]
            run = (xs[0], xs[-1] + 1) if xs else None
        if run != prev:
            if prev is not None:
                rects.append((prev[0], start, prev[1] - prev[0], y - start, 0))
            prev, start = run, y

    with open(ROOT / "ui" / "packmask.lua", "w", encoding="utf-8") as f:
        f.write("-- ui/packmask.lua\n")
        f.write("-- Made by dev/make_pack_art.py from resources/images/pack.png. Do not edit; run it again.\n")
        f.write("-- Strips that trace the pack's outline at %d x %d: { x, y, w, h, dy }.\n" % (W, H))
        f.write("return {\n    w = %d, h = %d,\n    rects = {\n" % (W, H))
        for r in rects:
            f.write("        { %d, %d, %d, %d, %d },\n" % r)
        f.write("    },\n}\n")
    print("ui/packmask.lua:", len(rects), "strips")


def make_shading(pack):
    src = pack.load()
    out = Image.new("RGBA", (SRC_W, SRC_H), (0, 0, 0, 0))
    o = out.load()
    crimp_vals = sorted(lum(src[x, y]) for y in range(SRC_H) for x in range(SRC_W)
                        if src[x, y][3] > 200 and (y < CRIMP_TOP or y > CRIMP_BOTTOM))
    crimp_mid = crimp_vals[len(crimp_vals) // 2]
    body_mid = 56
    bx0, by0, bx1, by1 = BODY_INSET
    for y in range(SRC_H):
        for x in range(SRC_W):
            r, g, b, a = src[x, y]
            if a == 0:
                continue
            crimp = y < CRIMP_TOP or y > CRIMP_BOTTOM
            if not crimp and bx0 <= x <= bx1 and by0 <= y <= by1:
                continue
            mid, k = (crimp_mid, 2.2) if crimp else (body_mid, 3.0)
            d = lum((r, g, b)) - mid
            strength = min(200, int(abs(d) * k))
            o[x, y] = ((255, 255, 255) if d > 0 else (0, 0, 0)) + (strength * a // 255,)
    # A thin dark outline where the pack meets the background, to hide the strips' steps.
    a_src = pack.getchannel("A").load()
    for y in range(1, SRC_H - 1):
        for x in range(1, SRC_W - 1):
            if a_src[x, y] > 0 and min(a_src[x - 1, y], a_src[x + 1, y], a_src[x, y - 1], a_src[x, y + 1]) < 128:
                o[x, y] = (20, 18, 15, max(o[x, y][3], 230 * a_src[x, y] // 255))
    out.save(IMAGES / "pack_shading.png", optimize=True)

    # The back: mirrored, with the seal seam: a raised strip with fine crosswise ridges, a dark
    # line down each side and a soft shadow beside it.
    back = out.transpose(Image.FLIP_LEFT_RIGHT)
    b = back.load()
    mid, half, shadow = SRC_W // 2, SEAM_W // 2, 8
    for y in range(CRIMP_TOP, CRIMP_BOTTOM + 1):
        if a_src[mid, y] == 0:
            continue
        for x in range(mid - half - shadow, mid + half + shadow + 1):
            d = abs(x - mid)
            if d < half:
                b[x, y] = (255, 255, 255, 70) if (y // 3) % 2 == 0 else (0, 0, 0, 90)
            elif d == half:
                b[x, y] = (10, 8, 6, 170)
            else:
                b[x, y] = (0, 0, 0, int(60 * (1 - (d - half) / shadow)))
    back.save(IMAGES / "pack_shading_back.png", optimize=True)
    print("resources/images/pack_shading.png, pack_shading_back.png")


def regions():
    """The region words from Cards.tagWords.regions in core/cards.lua, in order."""
    text = (ROOT / "core" / "cards.lua").read_text(encoding="utf-8")
    match = re.search(r"Cards\.tagWords\s*=\s*\{.*?regions\s*=\s*\{([^}]*)\}", text, re.DOTALL)
    return re.findall(r'"([a-z0-9_]+)"', match.group(1))


def render_title(font, text):
    left, top, right, bottom = font.getbbox(text)
    w, h = right - left + 2 * PAD + SHADOW[0], bottom - top + 2 * PAD + SHADOW[1]
    origin = (PAD - left, PAD - top)
    mask = Image.new("L", (w, h), 0)
    ImageDraw.Draw(mask).text(origin, text, font=font, fill=255)
    outline = mask.filter(ImageFilter.MaxFilter(2 * OUTLINE + 1))
    clear = Image.new("RGBA", (w, h), (0, 0, 0, 0))

    out = clear.copy()
    shadow = clear.copy()
    shadow.putalpha(outline.point(lambda a: a * 150 // 255))
    out.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(1.5)), SHADOW)
    out.alpha_composite(Image.composite(Image.new("RGBA", (w, h), OUTLINE_COLOUR + (255,)), clear, outline))
    # Gold, lighter at the top of the letters.
    gold = Image.new("RGBA", (w, h))
    g = gold.load()
    t0, t1 = PAD, h - PAD - SHADOW[1]
    for y in range(h):
        k = min(1, max(0, (y - t0) / max(1, t1 - t0)))
        c = tuple(int(GOLD_TOP[i] + (GOLD_BOTTOM[i] - GOLD_TOP[i]) * k) for i in range(3)) + (255,)
        for x in range(w):
            g[x, y] = c
    out.alpha_composite(Image.composite(gold, clear, mask))
    return out.crop(out.getbbox())


def make_titles(font_path):
    font = ImageFont.truetype(font_path, TITLE_SIZE)
    font.set_variation_by_name("Bold")
    rows = []
    for word in regions():
        text = " ".join(part.capitalize() for part in word.split("_"))
        image = render_title(font, text)
        image.save(IMAGES / ("title_" + word + ".png"), optimize=True)
        rows.append((word, text, image.width, image.height))
    with open(ROOT / "ui" / "packtitles.lua", "w", encoding="utf-8") as f:
        f.write("-- ui/packtitles.lua\n")
        f.write("-- Made by dev/make_pack_art.py. Do not edit; run it again.\n")
        f.write("-- Pack titles: resources/images/title_<id>.png, with each image's size in pixels.\n")
        f.write("return {\n")
        for word, text, w, h in rows:
            f.write(f'    {{ id = "{word}", text = "{text}", w = {w}, h = {h} }},\n')
        f.write("}\n")
    print("ui/packtitles.lua:", ", ".join(r[1] for r in rows))


def main():
    if len(sys.argv) != 2:
        print(__doc__)
        return 1
    pack = Image.open(IMAGES / "pack.png").convert("RGBA")
    if pack.size != (SRC_W, SRC_H):
        print("pack.png should be", SRC_W, "x", SRC_H, "but is", pack.size)
        return 1
    make_mask(pack)
    make_shading(pack)
    make_titles(sys.argv[1])
    return 0


if __name__ == "__main__":
    sys.exit(main())
