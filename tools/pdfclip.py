"""Visible (clipped) rectangles of images placed on a PDF page.

Word crops pictures with a clip path (`x y w h re W n`) around a larger image placement, which
pymupdf's get_image_info() does not take into account. This module walks the page content stream,
tracks the CTM and the clip rectangle, and returns, for each image XObject drawn, its full placement
and its visible part, in pymupdf (top-left origin) coordinates.
"""
import re

import pymupdf

TOKEN = re.compile(rb"""
    (?P<str>\((?:\\.|[^\\()])*\)) | (?P<hex><[0-9A-Fa-f\s]*>) | (?P<dict><<|>>) | (?P<arr>[\[\]]) |
    (?P<name>/[^\s/\[\]()<>{}%]+) | (?P<num>[+-]?(?:\d+\.?\d*|\.\d+)) | (?P<op>[A-Za-z'"*]+) | (?P<comment>%[^\r\n]*)
""", re.X)


def _tokens(data):
    pos, depth = 0, 0
    while pos < len(data):
        if data[pos:pos + 1] == b"(":  # literal strings may nest parentheses
            depth, i = 0, pos
            while i < len(data):
                ch = data[i:i + 1]
                if ch == b"\\":
                    i += 2; continue
                depth += ch == b"("
                depth -= ch == b")"
                i += 1
                if depth == 0:
                    break
            pos = i
            yield "str", None
            continue
        m = TOKEN.match(data, pos)
        if not m:
            pos += 1
            continue
        pos = m.end()
        kind = m.lastgroup
        if kind == "op" and m.group() == b"BI":  # skip inline images
            end = data.find(b"EI", pos)
            pos = len(data) if end < 0 else end + 2
            continue
        if kind != "comment":
            yield kind, m.group()


def _grow(path, *points):
    xs = [p.x for p in points] + ([path[0], path[2]] if path else [])
    ys = [p.y for p in points] + ([path[1], path[3]] if path else [])
    return [min(xs), min(ys), max(xs), max(ys)]


def image_rects(page):
    """[(xref, placement Rect, visible Rect)] in drawing order, in pymupdf coordinates."""
    xobjects = {img[7]: img[0] for img in page.get_images(full=True)}
    flip = page.transformation_matrix  # PDF user space -> pymupdf space
    out = []
    ctm = pymupdf.Matrix(1, 0, 0, 1, 0, 0)
    clip = pymupdf.Rect(page.mediabox)  # PDF user space
    stack, args, path, want_clip = [], [], None, False
    for kind, tok in _tokens(page.read_contents()):
        if kind == "num":
            args.append(float(tok)); continue
        if kind == "name":
            args.append(tok.decode("latin-1")[1:]); continue
        if kind != "op":
            args.append(None); continue
        op = tok.decode("latin-1")
        nums = [a for a in args if isinstance(a, float)]
        if op == "q":
            stack.append((ctm, pymupdf.Rect(clip)))
        elif op == "Q" and stack:
            ctm, clip = stack.pop()
        elif op == "cm" and len(nums) >= 6:
            ctm = pymupdf.Matrix(*nums[-6:]) * ctm
        elif op == "re" and len(nums) >= 4:
            x, y, w, h = nums[-4:]
            path = _grow(path, *(pymupdf.Point(px, py) * ctm for px in (x, x + w) for py in (y, y + h)))
        elif op in ("m", "l", "c", "v", "y") and len(nums) >= 2:
            pts = nums[-6:] if op == "c" else nums[-4:] if op in ("v", "y") else nums[-2:]
            path = _grow(path, *(pymupdf.Point(pts[i], pts[i + 1]) * ctm for i in range(0, len(pts) - 1, 2)))
        elif op in ("W", "W*"):
            want_clip = True
        elif op in ("n", "S", "s", "f", "F", "f*", "B", "B*", "b", "b*"):
            if want_clip and path is not None:
                clip = clip & pymupdf.Rect(path)
            path, want_clip = None, False
        elif op == "Do" and args and args[-1] in xobjects:
            placed = pymupdf.Rect(0, 0, 1, 1) * ctm
            out.append((xobjects[args[-1]], placed * flip, (placed & clip) * flip))
        args = []
    return out
