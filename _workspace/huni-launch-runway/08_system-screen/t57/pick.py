#!/usr/bin/env python3
# t57 — L1 이음매별 원장 행을 뽑아 본다(읽기전용 · 화면 확인용).
import csv, os, sys

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
rows = list(csv.DictReader(open(os.path.join(BASE, "t51", "merged.csv"), encoding="utf-8")))

want = sys.argv[1:] or ["mes|pitstop"]
for spec in want:
    a, b = spec.split("|")
    print(f"=== {a} <-> {b}")
    for x in rows:
        pair = {x["system"], x["counterpart"]}
        if x["work_type"] != "integrate" or pair != {a, b}:
            continue
        print(f'  [{x["status"]}] {x["screen_id"]} | {x["screen_name"]} | {x["function"][:70]}')
        print(f'      dir={x["direction"]} own={x["owner_side"]} plan={x["plan_row_id"]}')
        print(f'      ev={x["evidence"][:150]}')
    print()
