#!/usr/bin/env python3
# 문구 셋트(SB-1) 공유축 수치 전사 — component_prices sparse 셀수만 결정론 집계(손전사 금지·D-9).
# 사용: python3 transcribe_stationery_axis_260703.py
# 원천: live-snapshot/latest (snap_20260702_1119). 값(unit_price)은 전사 안 함(L-12) — 셀수만.
import csv, collections, pathlib
SNAP = pathlib.Path("/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest")
COMPS = ["COMP_STN_DIARY_SOFT","COMP_STN_DIARY_HARD","COMP_STN_DIARY_LHARD",
         "COMP_STN_DIARY_LSOFT","COMP_STN_MONTHLY","COMP_STN_SPRINGNOTE",
         "COMP_STN_SPRINGNOTEBK","COMP_STN_MEMOPAD","COMP_STN_JUNGCHEOL"]
cnt = collections.Counter()
with (SNAP/"t_prc_component_prices.csv").open() as f:
    for row in csv.DictReader(f):
        if row["comp_cd"] in COMPS:
            cnt[row["comp_cd"]] += 1
for c in COMPS:
    print(f"{c}\t{cnt[c]}셀")
