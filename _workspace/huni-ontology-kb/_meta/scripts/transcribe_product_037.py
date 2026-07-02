#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
보강 전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 오리지널박명함 PRD_000037 전용.

기존 스크립트(transcribe_namecard032.py 등)는 코팅/스탠다드 명함 축만 전사한다.
오리지널박명함(037)은 ① 단일 사이즈(SIZ_000008 90x50) ② 큐리어스스킨 자재(MAT_000137, 색상 자식)
③ 박(foil) 색상 8자식 공정(PROC_000037~044) ④ 상품 수량 스칼라(min200/max1000/incr100)를 쓴다.
이 축을 결정론적으로 뽑아 노드 본문에 붙일 markdown 표(transcribed-by 마커 포함)로 출력한다.
★기존 스크립트는 수정하지 않는다(신규 파일 — 재현성).

사용:  python3 transcribe_product_037.py           # stdout에 markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000037"
SIZES = ["SIZ_000008"]
# 037 has_process 8종 (박색 자식 — live t_prd_product_processes 실측 순서)
FOIL_PROCS = ["PROC_000037", "PROC_000038", "PROC_000039", "PROC_000040",
              "PROC_000041", "PROC_000042", "PROC_000043", "PROC_000044"]
MAT_PARENT = "MAT_000137"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def md_sizes():
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv") if r["siz_cd"] in SIZES}
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_037.py from {SNAP_ID} t_siz_sizes @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s in SIZES:
        r = sizes.get(s)
        if not r:
            continue
        out.append(f'| {s} | {r["siz_nm"]} | {_mm(r["work_width"])}x{_mm(r["work_height"])} '
                   f'| {_mm(r["cut_width"])}x{_mm(r["cut_height"])} |')
    return "\n".join(out)


def md_material():
    mats = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    parent = mats.get(MAT_PARENT, {})
    children = [r for r in mats.values()
                if r.get("upr_mat_cd") == MAT_PARENT and r.get("del_yn") == "N"]
    children.sort(key=lambda r: r["mat_cd"])
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_037.py from {SNAP_ID} t_mat_materials @ {STAMP} -->",
           "| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | 관계 |", "|---|---|---|---|---|---|"]
    out.append(f'| {MAT_PARENT} | {parent.get("mat_nm")} | {parent.get("mat_typ_cd")} '
               f'| {_mm(parent.get("width"))}x{_mm(parent.get("height"))} | {_mm(parent.get("weight"))} | 부모(037 has_material dflt) |')
    for r in children:
        out.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | (부모상속) | (부모상속) | 색상 자식 |')
    return "\n".join(out)


def md_foil_procs():
    procs = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_037.py from {SNAP_ID} t_proc_processes @ {STAMP} -->",
           "| proc_cd | 공정명(박색) | 상위공정(upr) |", "|---|---|---|"]
    for p in FOIL_PROCS:
        r = procs.get(p, {})
        out.append(f'| {p} | {r.get("proc_nm")} | {r.get("upr_proc_cd")} |')
    return "\n".join(out)


def md_qty():
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}.get(PRD, {})
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_037.py from {SNAP_ID} t_prd_products {PRD} @ {STAMP} -->",
           "| min_qty | max_qty | qty_incr | qty_unit_typ_cd |", "|---|---|---|---|",
           f'| {prod.get("min_qty")} | {prod.get("max_qty")} | {prod.get("qty_incr")} | {prod.get("qty_unit_typ_cd")} |']
    return "\n".join(out)


if __name__ == "__main__":
    print("### 오리지널박명함 사이즈 (전사)\n")
    print(md_sizes())
    print("\n### 오리지널박명함 자재 (전사)\n")
    print(md_material())
    print("\n### 오리지널박명함 박색 공정 (전사)\n")
    print(md_foil_procs())
    print("\n### 오리지널박명함 수량규칙 스칼라 (전사)\n")
    print(md_qty())
