#!/usr/bin/env python3
"""Makes the two images of the holo shine (see CardView.SHINE in ui/cardview.lua).

Usage:  python dev/make_holo.py     (run from anywhere)

  resources/images/holo_a.png, holo_b.png   the size of a whole card (twice 160 x 224), a faint pastel rainbow in
                                            diagonal bands with a few small sparkles, almost see-through. The game
                                            lays both over a holo card and cross-fades between them, so the bands
                                            seem to drift; b has the bands half a cycle on and its sparkles
                                            elsewhere.

Everything is drawn from the numbers below, so the look can be changed here and the images made again.
"""
import colorsys
import math
import random
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
IMAGES = ROOT / "resources" / "images"

WIDTH, HEIGHT = 320, 448        # twice a card's 160 x 224 units, so it stays sharp at the preview's larger sizes
LEAN = 30                       # degrees the bands lean from upright ("/" bands)
PERIOD = 300                    # pixels across the bands for the rainbow to go once round
SATURATION = 0.42               # 0 is grey, 1 is full colour: pastel
ALPHA_LOW, ALPHA_HIGH = 26, 74  # the see-through-ness of the bands, 0 clear to 255 solid; the bands swell between them
SPARKLES = 14
SPARKLE_ALPHA = 190


def bands(phase):
    """The rainbow: one pixel per x, y, coloured and made see-through by how far along the bands it is."""
    image = Image.new("RGBA", (WIDTH, HEIGHT))
    pixels = image.load()
    lean = math.radians(LEAN)
    across, down = math.sin(lean), math.cos(lean)       # the direction the colour changes in
    for y in range(HEIGHT):
        for x in range(WIDTH):
            u = (x * across + y * down) / PERIOD + phase
            r, g, b = colorsys.hsv_to_rgb(u % 1.0, SATURATION, 1.0)
            swell = 0.5 + 0.5 * math.sin(2 * math.pi * (u * 2 + 0.25))
            alpha = round(ALPHA_LOW + (ALPHA_HIGH - ALPHA_LOW) * swell)
            pixels[x, y] = (round(r * 255), round(g * 255), round(b * 255), alpha)
    return image


def sparkles(seed):
    """Small four-pointed crosses, soft grey-white, scattered over the card."""
    layer = Image.new("RGBA", (WIDTH * 2, HEIGHT * 2), (0, 0, 0, 0))     # drawn at twice the size, then shrunk, to soften them
    draw = ImageDraw.Draw(layer)
    rng = random.Random(seed)
    for _ in range(SPARKLES):
        x, y = rng.randint(16, WIDTH - 16) * 2, rng.randint(16, HEIGHT - 16) * 2
        reach = rng.randint(5, 11) * 2
        colour = (235, 235, 245, round(SPARKLE_ALPHA * rng.uniform(0.6, 1.0)))
        draw.line([(x - reach, y), (x + reach, y)], fill=colour, width=3)
        draw.line([(x, y - reach), (x, y + reach)], fill=colour, width=3)
    return layer.resize((WIDTH, HEIGHT), Image.LANCZOS).filter(ImageFilter.GaussianBlur(0.4))


def make(name, phase, seed):
    image = Image.alpha_composite(bands(phase), sparkles(seed))
    # (not reduced to 256 colours: that made the smooth bands step, and the full image is only about 20 KB)
    path = IMAGES / (name + ".png")
    image.save(path, optimize=True)
    print(f"{path.relative_to(ROOT)}: {WIDTH} x {HEIGHT}, {path.stat().st_size // 1024} KB")


if __name__ == "__main__":
    make("holo_a", 0.0, 1)
    make("holo_b", 0.5, 2)
