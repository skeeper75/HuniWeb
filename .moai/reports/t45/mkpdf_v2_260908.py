#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mkpdf_v2_260908.py — t45 v2 오프라인 백업 PDF 생성 (REQ-SB-025 · findings-3 페이지번호)
- headless Chrome --print-to-pdf + --footer-template(페이지번호 n / N) 시도.
- 크로아니엄 CLI가 footer-template를 무시하는 경우를 대비해 생성 후 안내만 출력(후처리는 별도 판단).
- 사용: python3 mkpdf_v2_260908.py
"""
import subprocess
import pathlib
import sys

CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
BASE = pathlib.Path(__file__).parent
SRC = BASE / "huni-staffbrief-260909.html"
OUT = BASE / "huni-staffbrief-260909.pdf"

FOOTER = (
    '<div style="font-size:9px;width:100%;text-align:center;'
    'color:#6F6F6F;font-family:sans-serif;">'
    '<span class="pageNumber"></span> / <span class="totalPages"></span></div>'
)

cmd = [
    CHROME,
    "--headless",
    "--disable-gpu",
    "--print-to-pdf=" + str(OUT),
    "--footer-template=" + FOOTER,
    str(SRC),
]
print("RUN: headless chrome --print-to-pdf (footer-template)")
r = subprocess.run(cmd, capture_output=True, text=True, timeout=180)
if OUT.exists():
    print(f"OK: {OUT} ({OUT.stat().st_size} bytes)")
    sys.exit(0)
print("STDERR:", r.stderr[-800:])
sys.exit(1)
