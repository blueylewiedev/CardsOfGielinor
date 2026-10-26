#!/usr/bin/env python3
"""Makes the images played when a flipped card's picture and text appear (see the flip in
ui/packwindow.lua), one set per rarity in the rarity's colour (Cards.rarities in core/cards.lua).

Usage:  python dev/make_burst.py     (run from anywhere)

For every rarity:
  resources/images/burst_<rarity>.png    a soft flash with rays, white-hot in the middle and fading
                                         out to the edges. It grows and fades over the card.
  resources/images/ring_<rarity>.png     a thick glowing ring that grows out round the opening the
                                         picture and text appear through. Its bright line is at
                                         RING_RADIUS of the image's half-width (the game sizes it
                                         by that), with a haze inside it that softens the
                                         opening's corners.
  resources/images/sparkle_<rarity>.png  a small four-pointed star. A few fly out from the middle
                                         of the card as it is revealed.

And once:
  resources/images/tear_guide.png        a glowing gold line, faded at both ends, laid along the
                                         line a pack tears on (it pulses while the pack is sealed).

All are drawn on a see-through background, larger than they are shown. Run it again after
changing a rarity's colour or adding a rarity.
"""
import math
import random
import re
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFilter

ROOT = Path(__file__).resolve().parent.parent
IMAGES = ROOT / "resources" / "images"
CARDS = ROOT / "core" / "cards.lua"

WHITE_HOT = (255, 250, 236)     # the colour of the brightest parts, whatever the rarity

BURST_SIZE = 256
RAYS = 18
RING_SIZE = 256
RING_RADIUS = 0.7               # keep in step with RING_RADIUS in ui/packwindow.lua
SPARKLE_SIZE = 48
GUIDE_W, GUIDE_H = 320, 48
GUIDE_GOLD = (255, 200, 70)


def rarity_colours():
    """{ rarity: (r, g, b) } read from Cards.rarities in core/cards.lua."""
    text = CARDS.read_text(encoding="utf-8")
    block = re.search(r"Cards\.rarities\s*=\s*\{(.*?)\n\}", text, re.S).group(1)
    colours = {}
    for name, hex_colour in re.findall(r"(\w+)\s*=\s*\{[^}]*colour\s*=\s*0x([0-9A-Fa-f]{8})", block):
        value = int(hex_colour, 16)
        colours[name] = ((value >> 24) & 0xFF, (value >> 16) & 0xFF, (value >> 8) & 0xFF)
    return colours


def lighten(colour, amount):
    """`colour` moved `amount` (0 to 1) of the way to white, so dark rarities still glow."""
    return tuple(int(c + (255 - c) * amount) for c in colour)


def field(size, fn):
    """A greyscale image whose value at each pixel is fn(d) * 255, d being the distance from the
    middle as a fraction of the half-width (0 in the middle, 1 at the edge)."""
    img = Image.new("L", (size, size))
    px = img.load()
    c = (size - 1) / 2
    for y in range(size):
        for x in range(size):
            px[x, y] = max(0, min(255, int(255 * fn(math.hypot(x - c, y - c) / c))))
    return img


def radial(size, power):
    """Full in the middle, falling to nothing at the edge (faster for a bigger `power`)."""
    return field(size, lambda d: max(0.0, 1 - d) ** power)


def coloured(alpha, heat, colour):
    """Colours an alpha mask: white-hot where `heat` is high, `colour` elsewhere."""
    size = alpha.size
    rgb = Image.composite(Image.new("RGB", size, WHITE_HOT), Image.new("RGB", size, colour), heat)
    out = rgb.convert("RGBA")
    out.putalpha(alpha)
    return out


def burst(colour):
    size = BURST_SIZE
    c = size / 2
    rays = Image.new("L", (size, size))
    draw = ImageDraw.Draw(rays)
    rng = random.Random(7)          # fixed, so the image is the same every run
    for i in range(RAYS):
        angle = (i + rng.uniform(-0.25, 0.25)) * 2 * math.pi / RAYS
        length = c * rng.uniform(0.7, 0.98)
        half = rng.uniform(0.07, 0.13)
        tip = (c + math.cos(angle) * length, c + math.sin(angle) * length)
        left = (c + math.cos(angle - half) * c * 0.3, c + math.sin(angle - half) * c * 0.3)
        right = (c + math.cos(angle + half) * c * 0.3, c + math.sin(angle + half) * c * 0.3)
        draw.polygon([(c, c), left, tip, right], fill=rng.randint(200, 255))
    rays = rays.filter(ImageFilter.GaussianBlur(2.5))
    rays = ImageChops.multiply(rays, radial(size, 0.6))     # rays fade towards their tips
    alpha = ImageChops.lighter(radial(size, 1.7), rays)
    return coloured(alpha, radial(size, 5), lighten(colour, 0.25))


def ring(colour):
    size = RING_SIZE

    def gauss(d, mid, width):
        return math.exp(-((d - mid) / width) ** 2)

    # A sharp bright line, a wide glow round it, and a faint haze filling the inside.
    alpha = field(size, lambda d: min(1.0, gauss(d, RING_RADIUS, 0.07)
                                      + 0.8 * gauss(d, RING_RADIUS, 0.17)
                                      + (0.35 * (d / RING_RADIUS) ** 2 if d < RING_RADIUS else 0)))
    heat = field(size, lambda d: gauss(d, RING_RADIUS, 0.045))
    return coloured(alpha, heat, lighten(colour, 0.2))


def sparkle(colour):
    size = SPARKLE_SIZE * 2           # drawn at twice the size, then shrunk for smooth edges
    c = size / 2
    star = Image.new("L", (size, size))
    draw = ImageDraw.Draw(star)
    long, short = c * 0.95, c * 0.16
    points = []
    for i in range(8):
        angle = i * math.pi / 4 - math.pi / 2
        r = long if i % 2 == 0 else short
        points.append((c + math.cos(angle) * r, c + math.sin(angle) * r))
    draw.polygon(points, fill=255)
    halo = field(size, lambda d: 0.6 * max(0.0, 1 - d) ** 3)
    alpha = ImageChops.lighter(star.filter(ImageFilter.GaussianBlur(1.5)), halo)
    out = coloured(alpha, radial(size, 4), lighten(colour, 0.3))
    return out.resize((SPARKLE_SIZE, SPARKLE_SIZE), Image.LANCZOS)


def tear_guide():
    w, h = GUIDE_W, GUIDE_H
    alpha = Image.new("L", (w, h))
    heat = Image.new("L", (w, h))
    a, t = alpha.load(), heat.load()
    mid = (h - 1) / 2
    for x in range(w):
        # Faded over the first and last eighth.
        taper = min(1.0, x / (w / 8), (w - 1 - x) / (w / 8))
        for y in range(h):
            d = abs(y - mid) / mid                  # 0 on the line, 1 at the top and bottom
            core = math.exp(-(d / 0.09) ** 2)
            glow = 0.7 * math.exp(-(d / 0.45) ** 2)
            a[x, y] = int(255 * taper * min(1.0, core + glow))
            t[x, y] = int(255 * core)
    return coloured(alpha, heat, GUIDE_GOLD)


def main():
    for name, colour in rarity_colours().items():
        burst(colour).save(IMAGES / f"burst_{name}.png")
        ring(colour).save(IMAGES / f"ring_{name}.png")
        sparkle(colour).save(IMAGES / f"sparkle_{name}.png")
        print("wrote burst, ring and sparkle for", name)
    tear_guide().save(IMAGES / "tear_guide.png")
    print("wrote tear_guide.png")


if __name__ == "__main__":
    main()
