#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""compress_captures.py — t45 v2 실화면 캡처 압축(data URI 인코딩)
원본 1440x900 PNG → 720px 폭 JPEG/WebP 품질 비교 → 최적 선택 → base64 data URI 출력.
HTML 예산(총 ≤122,880B) 안에서 이미지 3장 배분이 목표.
"""
import base64
import pathlib
import sys

CAP = pathlib.Path(__file__).parent

TARGETS = [
    ("raw-product-viewer.png", "img-product-viewer"),
    ("raw-widget-builder.png", "img-widget-builder"),
    ("raw-widget-live.png", "img-widget-live"),
]
WIDTH = 720


def main():
    try:
        from PIL import Image
    except ImportError:
        print("PIL unavailable")
        sys.exit(2)
    out = {}
    for src, key in TARGETS:
        p = CAP / src
        if not p.exists():
            print(f"MISSING {src}")
            continue
        im = Image.open(p).convert("RGB")
        w, h = im.size
        nh = int(h * WIDTH / w)
        im2 = im.resize((WIDTH, nh), Image.LANCZOS)
        best = None  # (bytes, fmt, quality, datauri)
        for fmt, q in [("JPEG", 55), ("JPEG", 65), ("JPEG", 75), ("WEBP", 55), ("WEBP", 65)]:
            import io
            buf = io.BytesIO()
            if fmt == "JPEG":
                im2.save(buf, format="JPEG", quality=q, optimize=True)
                mime = "image/jpeg"
            else:
                try:
                    im2.save(buf, format="WEBP", quality=q, method=6)
                    mime = "image/webp"
                except Exception:
                    continue
            data = buf.getvalue()
            b64 = base64.b64encode(data).decode("ascii")
            if best is None or len(b64) < len(best[3]):
                best = (len(data), fmt, q, b64, mime)
        size_b, fmt, q, b64, mime = best
        uri = f"data:{mime};base64,{b64}"
        out[key] = uri
        print(f"{src}: {fmt} q{q} → {size_b}B raw → {len(uri)}B data-uri")
    total = sum(len(v) for v in out.values())
    print(f"TOTAL data-uri: {total}B")
    (CAP / "captures-datauri.txt").write_text(
        "\n".join(f"### {k}\n{v}" for k, v in out.items()), encoding="utf-8"
    )
    print("saved captures-datauri.txt")


if __name__ == "__main__":
    main()
