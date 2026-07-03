#!/usr/bin/env python3
# 셋트 계열 공유축(사이즈) 전사 — Stage A(okb-knowledge-builder).
# t_siz_sizes.csv에서 셋트 구성원 공유 사이즈 치수를 전사(LLM 손전사 금지·D-9).
# 사용: python3 transcribe_set_axis_260703.py  → stdout에 사이즈 전사표 행.
import csv, sys

SNAP = "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest"
# 셋트 구성원이 공유하는 신규 사이즈(sizes.md 기존 제외: SIZ_000170 A5 이미 존재).
SET_SHARED_SIZES = ["SIZ_000172", "SIZ_000380", "SIZ_000174"]


def load_sizes():
    rows = {}
    with open(f"{SNAP}/t_siz_sizes.csv", newline="", encoding="utf-8") as f:
        for r in csv.DictReader(f):
            rows[r["siz_cd"]] = r
    return rows


def main():
    rows = load_sizes()
    print("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |")
    print("|---|---|---|---|")
    for sc in SET_SHARED_SIZES:
        r = rows.get(sc)
        if not r:
            print(f"<!-- MISSING {sc} -->", file=sys.stderr)
            continue
        ww = r["work_width"].rstrip("0").rstrip(".")
        wh = r["work_height"].rstrip("0").rstrip(".")
        cw = r["cut_width"].rstrip("0").rstrip(".")
        ch = r["cut_height"].rstrip("0").rstrip(".")
        print(f"| {sc} | {r['siz_nm']} | {ww}x{wh} | {cw}x{ch} |")


if __name__ == "__main__":
    main()
