#!/usr/bin/env python3
"""verdict.md 에 적을 분포를 screens.csv 에서 직접 센다."""
import collections
import csv

rows = list(csv.DictReader(open("screens.csv", newline="", encoding="utf-8")))
print("전체 화면 종수:", len({(r["system"], r["screen_id"]) for r in rows}))
for system in ("webadmin", "widget", "pagebuilder"):
    sub = [r for r in rows if r["system"] == system]
    work = dict(collections.Counter(r["work_type"] for r in sub))
    status = dict(collections.Counter(r["status"] for r in sub))
    print(
        f"-- {system}: {len(sub)}행 · 화면 {len({r['screen_id'] for r in sub})}종\n"
        f"     work_type {work}\n"
        f"     status {status}\n"
        f"     NEW {sum(1 for r in sub if r['plan_row_id'] == 'NEW')}"
    )
print("role:", dict(collections.Counter(r["role"] for r in rows)))
print("counterpart:", dict(collections.Counter(r["counterpart"] for r in rows if r["counterpart"])))
