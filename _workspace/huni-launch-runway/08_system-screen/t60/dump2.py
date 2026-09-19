#!/usr/bin/env python3
# t60 — 행 제목만 압축 덤프(축 배분 판단용). 읽기전용.
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from scan import SHH, prefix

want = sys.argv[1]
for r in SHH:
    if prefix(r['row_id']) != want:
        continue
    if r['remaining'] != 'Y':
        continue
    ev = (r['evidence'] or '')
    head = ev.split('·')[0].strip()[:58]
    print(f"{r['row_id']:14} {r['status']:7} {r['verdict']:5} {r['owner_proposed']:12} {r['title'][:52]:54} | {head}")
