#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
보강 전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 미니모양명함 PRD_000036 전용.

미니모양명함(036)은 명함 전용 단일 사이즈(SIZ_000011 50x50)와 출력용지 판형(SIZ_000499),
상품 수량 스칼라(min/max/qty_incr)를 쓴다. 이 축을 라이브 스냅샷에서 결정론적으로 뽑아
노드 본문에 붙일 markdown 표(transcribed-by 마커 포함)로 출력한다.
★기존 스크립트는 수정하지 않는다(신규 파일 — 036 전용 네임스페이스).

가격 골든(단면 16000/양면 17000)은 노드 본문에 값으로 기록하지 않는다(값=evaluate_price 권위·
골든은 날짜 라벨로만 참조). 이 스크립트는 사이즈·수량 차원만 전사한다.

사용:  python3 transcribe_product_036.py           # stdout에 markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000036"
# 미니모양명함 전용 사이즈(재단 치수) + 출력용지(판형) 사이즈
SIZES = ["SIZ_000011", "SIZ_000499"]


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
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_036.py from {SNAP_ID} t_siz_sizes @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s in SIZES:
        r = sizes.get(s)
        if not r:
            continue
        out.append(f'| {s} | {r["siz_nm"]} | {_mm(r["work_width"])}x{_mm(r["work_height"])} '
                   f'| {_mm(r["cut_width"])}x{_mm(r["cut_height"])} |')
    return "\n".join(out)


def md_qty():
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}.get(PRD, {})
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_036.py from {SNAP_ID} t_prd_products {PRD} @ {STAMP} -->",
           "| min_qty | max_qty | qty_incr | qty_unit_typ_cd |", "|---|---|---|---|",
           f'| {prod.get("min_qty")} | {prod.get("max_qty")} | {prod.get("qty_incr")} | {prod.get("qty_unit_typ_cd")} |']
    return "\n".join(out)


if __name__ == "__main__":
    print("### 미니모양명함 사이즈 (전사)\n")
    print(md_sizes())
    print("\n### 미니모양명함 수량규칙 스칼라 (전사)\n")
    print(md_qty())
