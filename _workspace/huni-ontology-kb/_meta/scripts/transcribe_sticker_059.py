#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
transcribe_sticker_059.py — 반칼정사각스티커(PRD_000059) 수치 전사기.

LLM 손전사 금지(§32 [HARD]). 라이브 스냅샷 CSV → markdown 표 stdout.
- 자재 사양(규격·평량)·사이즈 사양(작업/재단 mm)·수량규칙(min/max/incr)
- 가격경로 연결 증거(COMP_STK_PRINT 행수·059 사이즈 참조 행수) — ★단가값(unit_price)은 전사하지 않음
  (스티커 완제품 retail=260702 무변경·pack §4-B, 값 계산=evaluate_price 권위·D-18).

사용: python3 transcribe_sticker_059.py
원천: _workspace/_foundation/live-snapshot/latest (snap_20260702_1119).
"""
import os, csv

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
                                    "../../../_foundation/live-snapshot/latest"))
PRD = "PRD_000059"
MATS = ["MAT_000153", "MAT_000084", "MAT_000242", "MAT_000155", "MAT_000156"]
SIZES = ["SIZ_000520", "SIZ_000521"]  # 활성 사이즈·활성 판형참조


def rows(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def clean(v):
    # markdown 표 셀 안전화: 내부 파이프·개행 치환(원문 의미 보존)
    return (v or "").replace("|", "·").replace("\n", " ").strip()


def main():
    mat = {r["mat_cd"]: r for r in rows("t_mat_materials.csv")}
    siz = {r["siz_cd"]: r for r in rows("t_siz_sizes.csv")}
    prd = {r["prd_cd"]: r for r in rows("t_prd_products.csv")}[PRD]

    print("### 자재 사양 전사표 (권위 = 라이브 마스터 t_mat_materials)")
    print("| mat_cd | 자재명 | mat_typ | 규격(mm) | 평량(g) | note |")
    print("|---|---|---|---|---|---|")
    for m in MATS:
        r = mat[m]
        wh = f'{r["width"]}x{r["height"]}' if r["width"] and r["height"] else "미기재"
        note = clean(r["note"]) or "-"
        print(f'| {m} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {wh} | {r["weight"] or "미기재"} | {note} |')

    print("\n### 사이즈 사양 전사표 (권위 = 라이브 마스터 t_siz_sizes)")
    print("| siz_cd | siz_nm | 작업(mm) | 재단(mm) | del_yn | note |")
    print("|---|---|---|---|---|---|")
    for s in SIZES:
        r = siz[s]
        work = f'{r["work_width"]}x{r["work_height"]}' if r["work_width"] else "미기재"
        cut = f'{r["cut_width"]}x{r["cut_height"]}' if r["cut_width"] else "미기재"
        note = clean(r["note"]) or "-"
        print(f'| {s} | {r["siz_nm"]} | {work} | {cut} | {r["del_yn"]} | {note} |')

    print("\n### 수량규칙 전사표 (권위 = 라이브 t_prd_products)")
    print("| min_qty | max_qty | qty_incr | 단위 |")
    print("|---|---|---|---|")
    print(f'| {prd["min_qty"]} | {prd["max_qty"]} | {prd["qty_incr"]} | {prd["qty_unit_typ_cd"]} |')

    # --- 가격경로 연결 증거 (행수만·단가값 전사 안 함) ---
    stk = [r for r in rows("t_prc_component_prices.csv") if r["comp_cd"] == "COMP_STK_PRINT"]
    n520 = sum(1 for r in stk if r["siz_cd"] == "SIZ_000520")
    n_mat = {m: sum(1 for r in stk if r["mat_cd"] == m and r["siz_cd"] == "SIZ_000520") for m in MATS}
    print("\n### 가격경로 연결 증거 (COMP_STK_PRINT 단가행 존재·값 미전사)")
    print(f"- COMP_STK_PRINT 전체 단가행: {len(stk)}")
    print(f"- 059 활성 사이즈 SIZ_000520 참조 단가행: {n520}")
    for m in MATS:
        print(f"- SIZ_000520 x {m}: {n_mat[m]} 단가행")


if __name__ == "__main__":
    main()
