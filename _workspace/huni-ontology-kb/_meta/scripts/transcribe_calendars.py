#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""캘린더(108~112) 단품 완제품 노드 BOM 결정론 전사기.
live-snapshot/latest CSV에서 각 캘린더의 사이즈·자재·인쇄옵션·공정·판형을
읽어 markdown 표로 출력한다(사람 손전사 금지·okb file-format-spec §4).

가격 골든(PRICE≠0)은 별도 cal_golden.py(라이브 evaluate_price simulate 실호출).
재실행: python3 transcribe_calendars.py [PRD_000108|...]
"""
from __future__ import annotations
import csv, pathlib, sys

SNAP = pathlib.Path("/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest")
CALS = ["PRD_000108", "PRD_000109", "PRD_000110", "PRD_000111", "PRD_000112"]


def load(name):
    with open(SNAP / name, newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))


def name_map(name, key, val):
    return {r[key]: r[val] for r in load(name)}


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def main(prd):
    siz_nm = name_map("t_siz_sizes.csv", "siz_cd", "siz_nm")
    mat_nm = name_map("t_mat_materials.csv", "mat_cd", "mat_nm")
    proc_nm = name_map("t_proc_processes.csv", "proc_cd", "proc_nm")

    print(f"\n===== {prd} =====")
    print("#### 사이즈")
    for r in active([r for r in load("t_prd_product_sizes.csv") if r["prd_cd"] == prd]):
        print(f"| {r['siz_cd']} | {siz_nm.get(r['siz_cd'],'?')} | dflt={r['dflt_yn']} |")

    print("#### 자재(활성)")
    for r in active([r for r in load("t_prd_product_materials.csv") if r["prd_cd"] == prd]):
        print(f"| {r['mat_cd']} | {mat_nm.get(r['mat_cd'],'?')} | {r['usage_cd']} | dflt={r['dflt_yn']} |")

    print("#### 인쇄옵션")
    for r in active([r for r in load("t_prd_product_print_options.csv") if r["prd_cd"] == prd]):
        print(f"| {r['print_opt_cd']} | {r['print_side']} | dflt={r['dflt_yn']} |")

    print("#### 공정")
    for r in active([r for r in load("t_prd_product_processes.csv") if r["prd_cd"] == prd]):
        print(f"| {r['proc_cd']} | {proc_nm.get(r['proc_cd'],'?')} | mand={r['mand_proc_yn']} |")

    print("#### 판형")
    for r in active([r for r in load("t_prd_product_plate_sizes.csv") if r["prd_cd"] == prd]):
        print(f"| {r['siz_cd']} | {r['output_paper_typ_cd']} | dflt={r['dflt_plt_yn']} |")

    print("#### 가격공식")
    for r in [r for r in load("t_prd_product_price_formulas.csv") if r["prd_cd"] == prd]:
        print(f"| {r['frm_cd']} | {r['note']} |")


if __name__ == "__main__":
    for p in (sys.argv[1:] or CALS):
        main(p)
