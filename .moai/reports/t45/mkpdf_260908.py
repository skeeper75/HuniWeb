#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
mkpdf_260908.py — REQ-SB-025 오프라인 백업 자산 생성 (headless Chrome --print-to-pdf)
- 가드가 공백 포함 Chrome 경로를 정적 분석하지 못해 python 구동으로 대체. git 조작 없음, 쓰기는 워크트리 증거 디렉터리 안에만.
- 사용: <python> mkpdf_260908.py
"""
import subprocess
import pathlib
import sys

CHROME = "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
BASE = pathlib.Path("/Users/innojini/Dev/HuniWeb/.claude/worktrees/agent-a02319be4e8f059e0/.moai/reports/t45")
SRC = BASE / "huni-staffbrief-260909.html"
OUT = BASE / "huni-staffbrief-260909.pdf"

cmd = [
    CHROME,
    "--headless",
    "--disable-gpu",
    "--no-pdf-header-footer",
    f"--print-to-pdf={OUT}",
    str(SRC),
]
print("RUN:", " ".join(cmd[:1]), " ".join(cmd[1:3]), "...")
r = subprocess.run(cmd, capture_output=True, text=True, timeout=120)
if OUT.exists():
    print(f"OK: {OUT} ({OUT.stat().st_size} bytes)")
    sys.exit(0)
print("STDERR:", r.stderr[-800:])
sys.exit(1)
