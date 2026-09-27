#!/usr/bin/env python3
"""Draw short looping demos for Settle. Original line figures, not filmed people."""
from __future__ import annotations

import math
import shutil
import subprocess
from pathlib import Path

from PIL import Image, ImageDraw

W, H = 720, 960
OUT = Path(__file__).resolve().parents[1] / "Settle" / "Resources" / "Videos"
FRAMES = 36
FPS = 12

PAPER = (245, 240, 230, 255)
INK = (42, 68, 56, 255)
CLAY = (184, 98, 72, 255)
SOFT = (214, 204, 188, 255)
LINE = 10


def wave(t: float) -> float:
    return math.sin(2 * math.pi * t)


def hump(t: float) -> float:
    return 0.5 - 0.5 * math.cos(2 * math.pi * t)


def rot(p, origin, deg):
    a = math.radians(deg)
    x, y = p[0] - origin[0], p[1] - origin[1]
    return (
        origin[0] + x * math.cos(a) - y * math.sin(a),
        origin[1] + x * math.sin(a) + y * math.cos(a),
    )


def mix(a, b, t):
    return (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t)


def draw_scene(draw: ImageDraw.ImageDraw, kind: str) -> None:
    if kind == "flight":
        draw.rounded_rectangle((120, 250, 250, 700), radius=28, fill=SOFT)
        draw.rounded_rectangle((180, 620, 560, 700), radius=24, fill=SOFT)
        draw.rounded_rectangle((150, 860, 570, 900), radius=8, fill=(230, 222, 208, 255))
    elif kind == "hotel":
        draw.rectangle((0, 0, 180, H), fill=SOFT)
        draw.rectangle((0, 800, W, H), fill=(230, 222, 208, 255))
    else:
        draw.rounded_rectangle((70, 520, 660, 760), radius=36, fill=SOFT)
        draw.ellipse((90, 500, 250, 640), fill=(236, 228, 214, 255))


def bone(draw, a, b, color, width=LINE):
    draw.line((a[0], a[1], b[0], b[1]), fill=color, width=width)


def joint(draw, p, r, color):
    draw.ellipse((p[0] - r, p[1] - r, p[0] + r, p[1] + r), fill=color)


def figure(draw, pts, hot, avatar: str):
    pairs = [
        ("head", "neck", False),
        ("neck", "shoulder", False),
        ("shoulder", "hip", False),
        ("shoulder", "elbow", "arm" in hot),
        ("elbow", "hand", "arm" in hot),
        ("hip", "knee", "leg" in hot),
        ("knee", "ankle", "leg" in hot),
        ("ankle", "toe", "foot" in hot),
        ("hip", "knee2", "leg2" in hot),
        ("knee2", "ankle2", "leg2" in hot),
        ("ankle2", "toe2", "foot2" in hot),
        ("shoulder", "elbow2", "arm2" in hot),
        ("elbow2", "hand2", "arm2" in hot),
    ]
    for a, b, on in pairs:
        if a in pts and b in pts:
            bone(draw, pts[a], pts[b], CLAY if on else INK, 14 if on else LINE)
    head = pts["head"]
    if avatar == "f":
        draw.arc((head[0] - 52, head[1] - 46, head[0] + 40, head[1] + 58), start=200, end=40, fill=INK, width=8)
    joint(draw, head, 34, (245, 240, 230, 255))
    draw.ellipse(
        (head[0] - 34, head[1] - 34, head[0] + 34, head[1] + 34),
        outline=INK,
        width=8,
    )
    label = "Female" if avatar == "f" else "Male"
    draw.text((40, 40), label, fill=INK)
    for name in ("shoulder", "hip", "knee", "ankle", "elbow", "knee2", "ankle2"):
        if name in pts:
            joint(draw, pts[name], 8, CLAY if name.startswith(tuple(hot)) or any(h in name for h in hot) else INK)


def seat(t, kind):
    w = wave(t)
    u = hump(t)
    hip = (340, 600)
    shoulder = (330, 390)
    neck = (328, 330)
    head = (326, 270)
    elbow = (250, 500)
    hand = (230, 610)
    elbow2 = (400, 470)
    hand2 = (430, 580)
    knee = (470, 600)
    ankle = (470, 800)
    toe = (540, 805)
    knee2 = (400, 640)
    ankle2 = (390, 820)
    toe2 = (450, 825)
    pts = dict(
        head=head, neck=neck, shoulder=shoulder, hip=hip,
        elbow=elbow, hand=hand, elbow2=elbow2, hand2=hand2,
        knee=knee, ankle=ankle, toe=toe, knee2=knee2, ankle2=ankle2, toe2=toe2,
    )
    hot = set()
    if kind == "ankle-circles":
        ang = 2 * math.pi * t
        pts["toe"] = (ankle[0] + 70 * math.cos(ang), ankle[1] + 28 * math.sin(ang))
        hot = {"foot"}
    elif kind == "foot-pumps":
        lift = -50 * u
        pts["toe"] = (toe[0], toe[1] + lift)
        pts["toe2"] = (toe2[0], toe2[1] + lift)
        hot = {"foot", "foot2"}
    elif kind == "seat-march":
        pts["knee"] = (knee[0] - 30 * u, knee[1] - 150 * u)
        pts["ankle"] = (ankle[0] - 10 * u, ankle[1] - 150 * u)
        pts["toe"] = (toe[0] - 10 * u, toe[1] - 150 * u)
        hot = {"leg"}
    elif kind == "hip-shift":
        shift = 70 * w
        for name in ("hip", "knee", "knee2", "ankle", "ankle2", "toe", "toe2"):
            pts[name] = (pts[name][0] + shift, pts[name][1])
        hot = {"leg", "leg2"}
    elif kind == "seat-figure-4":
        pts["ankle"] = mix(ankle, (knee2[0] + 10, knee2[1] - 20), u)
        pts["knee"] = mix(knee, (430, 520), u)
        pts["toe"] = (pts["ankle"][0] + 50, pts["ankle"][1] + 10)
        hot = {"leg"}
    elif kind == "seat-turn":
        turn = 18 * w
        pts["shoulder"] = rot(shoulder, hip, turn)
        pts["neck"] = rot(neck, hip, turn)
        pts["head"] = rot(head, hip, turn * 0.6)
        pts["elbow2"] = rot(elbow2, hip, turn)
        pts["hand2"] = mix(hand2, (knee[0] - 20, knee[1] - 30), abs(w))
        hot = {"arm2"}
    elif kind == "neck-turns":
        pts["head"] = (head[0] + 46 * w, head[1])
        hot = set()
    elif kind == "shoulder-circles":
        ang = 2 * math.pi * t
        pts["shoulder"] = (shoulder[0] + 18 * math.cos(ang), shoulder[1] + 22 * math.sin(ang))
        pts["neck"] = (neck[0], neck[1] + 8 * math.sin(ang))
        hot = set()
    elif kind == "chest-open":
        pts["elbow2"] = mix(elbow2, (250, 430), u)
        pts["hand2"] = mix(hand2, (210, 560), u)
        pts["shoulder"] = (shoulder[0] - 10 * u, shoulder[1] - 16 * u)
        pts["head"] = (head[0], head[1] - 10 * u)
        hot = {"arm2"}
    elif kind == "wrist-circles":
        ang = 2 * math.pi * t
        pts["hand"] = (elbow[0] - 20 + 36 * math.cos(ang), elbow[1] + 70 + 36 * math.sin(ang))
        hot = {"arm"}
    return pts, hot


def bed(t, kind):
    w = wave(t)
    u = hump(t)
    head = (150, 430)
    neck = (200, 450)
    shoulder = (250, 470)
    hip = (430, 500)
    elbow = (250, 560)
    hand = (210, 640)
    elbow2 = (280, 400)
    hand2 = (340, 360)
    knee = (560, 390)
    ankle = (650, 470)
    toe = (700, 450)
    knee2 = (520, 560)
    ankle2 = (640, 600)
    toe2 = (700, 590)
    pts = dict(
        head=head, neck=neck, shoulder=shoulder, hip=hip,
        elbow=elbow, hand=hand, elbow2=elbow2, hand2=hand2,
        knee=knee, ankle=ankle, toe=toe, knee2=knee2, ankle2=ankle2, toe2=toe2,
    )
    hot = set()
    if kind == "pelvic-rock":
        pts["hip"] = (hip[0], hip[1] - 28 * w)
        pts["knee"] = (knee[0], knee[1] - 10 * w)
        hot = {"leg"}
    elif kind == "knee-chest":
        pts["knee"] = mix(knee, (360, 340), u)
        pts["ankle"] = mix(ankle, (430, 300), u)
        pts["toe"] = mix(toe, (470, 280), u)
        pts["hand2"] = mix(hand2, (pts["knee"][0] - 20, pts["knee"][1] + 10), u)
        pts["elbow2"] = mix(elbow2, (320, 360), u)
        hot = {"leg", "arm2"}
    elif kind == "supine-twist":
        drop = 90 * w
        for name in ("knee", "ankle", "toe", "knee2", "ankle2", "toe2"):
            pts[name] = (pts[name][0], pts[name][1] + drop)
        hot = {"leg", "leg2"}
    elif kind == "bed-figure-4":
        pts["ankle"] = mix(ankle, (knee2[0] + 20, knee2[1] - 30), u)
        pts["knee"] = mix(knee, (500, 340), u)
        pts["toe"] = (pts["ankle"][0] + 40, pts["ankle"][1] - 10)
        hot = {"leg"}
    elif kind == "windshield":
        sway = 80 * w
        for name in ("knee", "ankle", "toe", "knee2", "ankle2", "toe2"):
            pts[name] = (pts[name][0], pts[name][1] + sway * (1 if "2" in name else 0.7))
        hot = {"leg", "leg2"}
    elif kind == "open-book":
        # side lying: open the top arm
        pts["elbow2"] = mix(elbow2, (300, 280), u)
        pts["hand2"] = mix(hand2, (180, 240), u)
        pts["head"] = (head[0], head[1] - 8 * u)
        hot = {"arm2"}
    elif kind == "side-knee":
        pts["knee"] = mix(knee, (340, 360), u)
        pts["ankle"] = mix(ankle, (400, 320), u)
        pts["toe"] = mix(toe, (450, 310), u)
        hot = {"leg"}
    elif kind == "heel-slide":
        slide = 80 * u
        pts["knee"] = (knee[0] + slide, knee[1] + 40 * u)
        pts["ankle"] = (ankle[0] + slide, ankle[1] + 20 * u)
        pts["toe"] = (toe[0] + slide, toe[1] + 16 * u)
        hot = {"leg"}
    elif kind == "ankle-alphabet":
        ang = 2 * math.pi * t
        pts["toe"] = (ankle[0] + 36 * math.cos(ang), ankle[1] - 10 + 28 * math.sin(ang))
        hot = {"foot"}
    elif kind == "bent-knee-breath":
        rise = 16 * wave(t * 0.5) if False else 14 * math.sin(2 * math.pi * t)
        pts["shoulder"] = (shoulder[0], shoulder[1] - rise)
        pts["neck"] = (neck[0], neck[1] - rise * 0.6)
        pts["head"] = (head[0], head[1] - rise * 0.4)
        hot = set()
    return pts, hot


def room(t, kind):
    w = wave(t)
    u = hump(t)
    head = (430, 230)
    neck = (440, 290)
    shoulder = (450, 350)
    hip = (460, 530)
    elbow = (360, 390)
    hand = (190, 360)
    elbow2 = (390, 430)
    hand2 = (200, 430)
    knee = (470, 680)
    ankle = (480, 820)
    toe = (540, 830)
    knee2 = (420, 690)
    ankle2 = (360, 820)
    toe2 = (300, 830)
    pts = dict(
        head=head, neck=neck, shoulder=shoulder, hip=hip,
        elbow=elbow, hand=hand, elbow2=elbow2, hand2=hand2,
        knee=knee, ankle=ankle, toe=toe, knee2=knee2, ankle2=ankle2, toe2=toe2,
    )
    hot = set()
    if kind == "wall-chest":
        shift = 50 * u
        for name in ("head", "neck", "shoulder", "hip"):
            pts[name] = (pts[name][0] - shift, pts[name][1])
        hot = {"arm", "arm2"}
    elif kind == "wall-calf":
        pts["hip"] = (hip[0] - 30 * u, hip[1])
        pts["knee2"] = (knee2[0] - 20 * u, knee2[1])
        pts["ankle2"] = (ankle2[0] - 70, ankle2[1])
        pts["toe2"] = (toe2[0] - 80, toe2[1] - 8 * u)
        hot = {"leg2"}
    elif kind == "stand-hip":
        pts["hip"] = (hip[0] + 36 * w, hip[1])
        pts["knee"] = (knee[0] + 20 * w, knee[1])
        pts["knee2"] = (knee2[0] + 20 * w, knee2[1])
        hot = {"leg", "leg2"}
    elif kind == "thread-needle":
        head = (180, 480)
        pts = dict(
            head=head, neck=(230, 500), shoulder=(280, 520), hip=(460, 540),
            elbow=(300, 430), hand=(250, 360),
            elbow2=(320, 560), hand2=mix((360, 600), (220, 620), u),
            knee=(560, 480), ankle=(640, 500), toe=(690, 490),
            knee2=(540, 600), ankle2=(640, 640), toe2=(700, 630),
        )
        hot = {"arm2"}
    return pts, hot


MOVES = [
    ("ankle-circles", "flight"),
    ("foot-pumps", "flight"),
    ("seat-march", "flight"),
    ("hip-shift", "flight"),
    ("seat-figure-4", "flight"),
    ("seat-turn", "flight"),
    ("neck-turns", "flight"),
    ("shoulder-circles", "flight"),
    ("chest-open", "flight"),
    ("wrist-circles", "flight"),
    ("pelvic-rock", "bed"),
    ("knee-chest", "bed"),
    ("supine-twist", "bed"),
    ("bed-figure-4", "bed"),
    ("windshield", "bed"),
    ("open-book", "bed"),
    ("side-knee", "bed"),
    ("heel-slide", "bed"),
    ("ankle-alphabet", "bed"),
    ("bent-knee-breath", "bed"),
    ("wall-chest", "hotel"),
    ("wall-calf", "hotel"),
    ("stand-hip", "hotel"),
    ("thread-needle", "hotel"),
]


def pose(place: str, t: float, name: str):
    if place == "flight":
        return seat(t, name)
    if place == "hotel":
        return room(t, name)
    return bed(t, name)


def render_one(name: str, place: str, avatar: str, tmp: Path) -> None:
    tmp.mkdir(parents=True, exist_ok=True)
    for i in range(FRAMES):
        t = i / FRAMES
        img = Image.new("RGBA", (W, H), PAPER)
        draw = ImageDraw.Draw(img)
        draw_scene(draw, place)
        pts, hot = pose(place, t, name)
        figure(draw, pts, hot, avatar)
        frame = tmp / f"f{i:03d}.png"
        img.convert("RGB").save(frame)
    suffix = "f" if avatar == "f" else "m"
    dest = OUT / f"{name}-{suffix}.mp4"
    subprocess.run(
        [
            "ffmpeg", "-y", "-framerate", str(FPS),
            "-i", str(tmp / "f%03d.png"),
            "-c:v", "libx264", "-pix_fmt", "yuv420p",
            "-movflags", "+faststart",
            str(dest),
        ],
        check=True,
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL,
    )


def main() -> None:
    OUT.mkdir(parents=True, exist_ok=True)
    root = Path("/tmp/settle-frames")
    if root.exists():
        shutil.rmtree(root)
    for old in OUT.glob("*.mp4"):
        if not old.stem.endswith(("-m", "-f")):
            old.unlink()
    for name, place in MOVES:
        for avatar in ("f", "m"):
            render_one(name, place, avatar, root / f"{name}-{avatar}")
            print(f"{name}-{avatar}", (OUT / f"{name}-{avatar[0]}.mp4").stat().st_size)
    shutil.rmtree(root)


if __name__ == "__main__":
    main()
