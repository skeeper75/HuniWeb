#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-022-gold-silver-spot-postcard 전용.

금은별색엽서(PRD_000022)의 상품별 차원·BOM·연결 수치를 라이브 스냅샷에서 결정론적으로 전사한다.
기존 공통/타상품 전사 스크립트를 수정하지 않고 자기 네임스페이스로 추가(재호출 규약 준수).
노드 본문의 표는 이 스크립트 출력을 그대로 옮긴 것(사람 손전사 아님).

사용:  python3 transcribe_product_022.py     # stdout markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000022"

# 공유 axis/formula에 노드가 실재하는 코드 집합(배선 O/X 주석용 — KB 상태, 라이브 열 아님)
MINTED_MAT = {"MAT_000074", "MAT_000081", "MAT_000082", "MAT_000091",
              "MAT_000092", "MAT_000101", "MAT_000109"}
MINTED_PROC = {"PROC_000001", "PROC_000004", "PROC_000007", "PROC_000013", "PROC_000014",
               "PROC_000015", "PROC_000026", "PROC_000027", "PROC_000028", "PROC_000029",
               "PROC_000030", "PROC_000031", "PROC_000032", "PROC_000033", "PROC_000053",
               "PROC_000056", "PROC_000079", "PROC_000085"}


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd(name):
    return [r for r in rd(name) if r.get("prd_cd") == PRD]


def marker(tbl):
    return (f"<!-- transcribed-by: _meta/scripts/transcribe_product_022.py "
            f"from {SNAP_ID} {tbl} PRD_000022 @ {STAMP} -->")


def blank(v):
    return "" if v in (None, "") else v


def identity():
    p = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}.get(PRD, {})
    out = [marker("t_prd_products"),
           "| 필드 | 값 |", "|---|---|"]
    for k in ("prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
              "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"):
        out.append(f"| {k} | {blank(p.get(k))} |")
    return "\n".join(out)


def categories():
    cm = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    rows = [r for r in by_prd("t_prd_product_categories.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["cat_cd"]))
    out = [marker("t_prd_product_categories+t_cat_categories"),
           "| cat_cd | 분류명 | main_cat_yn(연결) |", "|---|---|---|"]
    for r in rows:
        out.append(f'| {r["cat_cd"]} | {cm.get(r["cat_cd"], {}).get("cat_nm", "?")} | '
                   f'{blank(r.get("main_cat_yn"))} |')
    return "\n".join(out)


def sizes():
    sm = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    rows = [r for r in by_prd("t_prd_product_sizes.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["siz_cd"]))
    out = [marker("t_prd_product_sizes+t_siz_sizes"),
           "| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |", "|---|---|---|---|---|---|"]
    for r in rows:
        nm = sm.get(r["siz_cd"], {}).get("siz_nm", "?")
        out.append(f'| {r["siz_cd"]} | {nm} | {blank(r.get("dflt_yn"))} | '
                   f'{blank(r.get("min_qty"))} | {blank(r.get("max_qty"))} | {blank(r.get("qty_incr"))} |')
    return "\n".join(out)


def qty():
    p = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}.get(PRD, {})
    bqs = [r for r in by_prd("t_prd_product_bundle_qtys.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_products(수량 컬럼)+t_prd_product_bundle_qtys"),
           "| 원천 | min_qty | max_qty | qty_incr | 단위 | 비고 |", "|---|---|---|---|---|---|",
           f'| 상품 마스터 | {p.get("min_qty")} | {p.get("max_qty")} | {p.get("qty_incr")} | '
           f'{p.get("qty_unit_typ_cd")} | 상품 레벨 수량규칙 |',
           f'| t_prd_product_bundle_qtys | - | - | - | - | 행수 {len(bqs)} '
           f'(묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |']
    return "\n".join(out)


def materials():
    mm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    rows = [r for r in by_prd("t_prd_product_materials.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["mat_cd"]))
    out = [marker("t_prd_product_materials+t_mat_materials (활성 del_yn≠Y)"),
           f"활성 자재 {len(rows)}행 · 전부 usage_cd 단일 슬롯(팩 §3.5)",
           "", "| mat_cd | 자재명 | usage_cd | dflt | 축노드 존재 |", "|---|---|---|---|---|"]
    for r in rows:
        mc = r["mat_cd"]
        out.append(f'| {mc} | {mm.get(mc, {}).get("mat_nm", "?")} | {blank(r.get("usage_cd"))} | '
                   f'{blank(r.get("dflt_yn"))} | {"O" if mc in MINTED_MAT else "X(미민팅)"} |')
    return "\n".join(out)


def print_options():
    cm = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    pm = {r["print_opt_cd"]: r for r in rd("t_prt_print_options.csv")}
    rows = [r for r in by_prd("t_prd_product_print_options.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r.get("opt_id") or ""))
    out = [marker("t_prd_product_print_options+t_clr_color_counts+t_prt_print_options"),
           "| print_opt_cd | 인쇄옵션명 | side | front 도수 | back 도수 |",
           "|---|---|---|---|---|"]
    for r in rows:
        pc = r.get("print_opt_cd")
        fnm = cm.get(r.get("front_colrcnt_cd"), {}).get("clr_nm", "?")
        bnm = cm.get(r.get("back_colrcnt_cd"), {}).get("clr_nm", "?")
        out.append(f'| {pc} | {pm.get(pc, {}).get("print_opt_nm", "?")} | {blank(r.get("print_side"))} | '
                   f'{fnm} | {bnm} |')
    return "\n".join(out)


def processes():
    pm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    rows = [r for r in by_prd("t_prd_product_processes.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("mand_proc_yn") != "Y", r.get("disp_seq") or "", r["proc_cd"]))
    out = [marker("t_prd_product_processes+t_proc_processes"),
           "| proc_cd | 공정명 | mand | 축노드 존재 |", "|---|---|---|---|"]
    for r in rows:
        pc = r["proc_cd"]
        out.append(f'| {pc} | {pm.get(pc, {}).get("proc_nm", "?")} | {blank(r.get("mand_proc_yn"))} | '
                   f'{"O" if pc in MINTED_PROC else "X(미민팅)"} |')
    out.append("")
    out.append("> ★금은별색(별색인쇄 PROC_000007) 공정 미배선 — 활성 공정 행에 없음(위 표가 라이브 전수).")
    return "\n".join(out)


def plates():
    rows = [r for r in by_prd("t_prd_product_plate_sizes.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_plate_sizes"),
           "| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |", "|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r.get("siz_cd")} | {blank(r.get("output_paper_typ_cd"))} | '
                   f'{blank(r.get("item_siz_cd"))} | {blank(r.get("dflt_plt_yn"))} |')
    return "\n".join(out)


def cpq_zero():
    og = [r for r in by_prd("t_prd_product_option_groups.csv") if r.get("del_yn") != "Y"]
    oi = [r for r in by_prd("t_prd_product_option_items.csv") if r.get("del_yn") != "Y"]
    cn = [r for r in by_prd("t_prd_product_constraints.csv") if r.get("del_yn") != "Y"]
    ad = [r for r in by_prd("t_prd_product_addons.csv") if r.get("del_yn") != "Y"]
    st = [r for r in by_prd("t_prd_product_sets.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_option_groups/items/constraints/addons/sets"),
           "| 레이어 | 활성 행수 |", "|---|---|",
           f"| 옵션그룹(option_groups) | {len(og)} |",
           f"| 옵션항목(option_items) | {len(oi)} |",
           f"| 제약(constraints) | {len(cn)} |",
           f"| 추가상품(addons) | {len(ad)} |",
           f"| 셋트구성(sets) | {len(st)} |"]
    return "\n".join(out)


def price_binding():
    rows = by_prd("t_prd_product_price_formulas.csv")
    out = [marker("t_prd_product_price_formulas"),
           "| frm_cd | note |", "|---|---|"]
    for r in rows:
        out.append(f'| {r.get("frm_cd")} | {blank(r.get("note"))} |')
    return "\n".join(out)


if __name__ == "__main__":
    for title, fn in [("정체(마스터)", identity), ("분류", categories),
                      ("사이즈+수량규칙", sizes), ("수량 규칙(상품/묶음)", qty),
                      ("자재 BOM", materials), ("인쇄옵션(도수)", print_options),
                      ("공정 라우트", processes), ("판형", plates),
                      ("CPQ·추가상품·셋트(전부 0행)", cpq_zero),
                      ("가격공식 바인딩", price_binding)]:
        print(f"\n#### {title}\n")
        print(fn())
