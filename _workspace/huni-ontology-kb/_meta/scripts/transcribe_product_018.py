#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-018-standard-postcard 전용.

기존 transcribe_product_016.py(형제 프리미엄엽서)를 수정하지 않고, 스탠다드엽서(PRD_000018)의
상품별 차원·BOM·연결 수치를 라이브 스냅샷에서 결정론적으로 전사한다.
- 사이즈(+사이즈별 수량규칙) · 자재 BOM(활성) · 공정 라우트(mand/opt) · 판형 · 인쇄옵션
- 옵션그룹 · 옵션값(options) · 옵션아이템 다형참조(option_items ref_dim_cd) · 제약 · 추가상품 · 가격공식 바인딩
노드 본문의 표는 이 스크립트가 뽑은 것을 그대로 옮긴 것(사람 손전사 아님).

사용:  python3 transcribe_product_018.py           # stdout markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000018"

# 공유 axis에 노드가 민팅된 자재/공정/판형(그래프 배선 대상). 나머지는 GAP·needed_shared_nodes.
MINTED_MAT = {"MAT_000074", "MAT_000081", "MAT_000082", "MAT_000091", "MAT_000092", "MAT_000101", "MAT_000109"}
MINTED_PROC = {"PROC_000004", "PROC_000027", "PROC_000028", "PROC_000029", "PROC_000030",
               "PROC_000031", "PROC_000032", "PROC_000001", "PROC_000007", "PROC_000013",
               "PROC_000014", "PROC_000015", "PROC_000026", "PROC_000033", "PROC_000053",
               "PROC_000056", "PROC_000079", "PROC_000085"}


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd(name):
    return [r for r in rd(name) if r.get("prd_cd") == PRD]


def marker(tbl):
    return f"<!-- transcribed-by: _meta/scripts/transcribe_product_018.py from {SNAP_ID} {tbl} PRD_000018 @ {STAMP} -->"


def blank(v):
    return "" if v in (None, "") else v


def sizes():
    smaster = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    rows = [r for r in by_prd("t_prd_product_sizes.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["siz_cd"]))
    out = [marker("t_prd_product_sizes+t_siz_sizes"),
           "| siz_cd | 라벨 | dflt | 사이즈별 min | max | incr |", "|---|---|---|---|---|---|"]
    for r in rows:
        nm = smaster.get(r["siz_cd"], {}).get("siz_nm", "?")
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
           f'| t_prd_product_bundle_qtys | - | - | - | - | 행수 {len(bqs)} (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |']
    return "\n".join(out)


def materials():
    mm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    rows = [r for r in by_prd("t_prd_product_materials.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["mat_cd"]))
    out = [marker("t_prd_product_materials+t_mat_materials (활성 del_yn≠Y)"),
           f"활성 자재 {len(rows)}행 · 전부 usage_cd 단일 슬롯(팩 §3.5)",
           "", "| mat_cd | 자재명 | usage_cd | dflt | 공유축노드 |", "|---|---|---|---|---|"]
    for r in rows:
        mc = r["mat_cd"]
        out.append(f'| {mc} | {mm.get(mc, {}).get("mat_nm", "?")} | {blank(r.get("usage_cd"))} | '
                   f'{blank(r.get("dflt_yn"))} | {"O" if mc in MINTED_MAT else "X(미민팅·needed_shared)"} |')
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
    return "\n".join(out)


def print_options():
    pom = {r["print_opt_cd"]: r for r in rd("t_prt_print_options.csv")} if os.path.exists(os.path.join(SNAP, "t_prt_print_options.csv")) else {}
    rows = [r for r in by_prd("t_prd_product_print_options.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r.get("opt_id") or ""))
    out = [marker("t_prd_product_print_options+t_prt_print_options"),
           "| opt_id | print_side | print_opt_cd | front_clr | back_clr | dflt |", "|---|---|---|---|---|---|"]
    for r in rows:
        out.append(f'| {blank(r.get("opt_id"))} | {blank(r.get("print_side"))} | {blank(r.get("print_opt_cd"))} | '
                   f'{blank(r.get("front_colrcnt_cd"))} | {blank(r.get("back_colrcnt_cd"))} | {blank(r.get("dflt_yn"))} |')
    return "\n".join(out)


def plates():
    rows = [r for r in by_prd("t_prd_product_plate_sizes.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_plate_sizes"),
           "| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |", "|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["siz_cd"]} | {blank(r.get("output_paper_typ_cd"))} | '
                   f'{blank(r.get("item_siz_cd"))} | {blank(r.get("dflt_plt_yn"))} |')
    return "\n".join(out)


def optgroups():
    rows = [r for r in by_prd("t_prd_product_option_groups.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["opt_grp_cd"]))
    out = [marker("t_prd_product_option_groups"),
           "| opt_grp_cd | 그룹명 | sel_typ | min_sel | max_sel | mand | use |",
           "|---|---|---|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["opt_grp_cd"]} | {blank(r.get("opt_grp_nm"))} | {blank(r.get("sel_typ_cd"))} | '
                   f'{blank(r.get("min_sel_cnt"))} | {blank(r.get("max_sel_cnt"))} | '
                   f'{blank(r.get("mand_yn"))} | {blank(r.get("use_yn"))} |')
    return "\n".join(out)


def options_and_items():
    opts = [r for r in by_prd("t_prd_product_options.csv") if r.get("del_yn") != "Y"]
    items = {r["opt_cd"]: r for r in by_prd("t_prd_product_option_items.csv") if r.get("del_yn") != "Y"}
    opts.sort(key=lambda r: (r.get("opt_grp_cd") or "", r.get("disp_seq") or "", r["opt_cd"]))
    out = [marker("t_prd_product_options+t_prd_product_option_items"),
           "| opt_grp_cd | opt_cd | 옵션명 | ref_dim_cd | ref_key1 | ref_key2 | dflt |",
           "|---|---|---|---|---|---|---|"]
    for r in opts:
        it = items.get(r["opt_cd"], {})
        out.append(f'| {blank(r.get("opt_grp_cd"))} | {r["opt_cd"]} | {blank(r.get("opt_nm"))} | '
                   f'{blank(it.get("ref_dim_cd"))} | {blank(it.get("ref_key1"))} | '
                   f'{blank(it.get("ref_key2"))} | {blank(r.get("dflt_yn"))} |')
    return "\n".join(out)


def constraints():
    rows = [r for r in by_prd("t_prd_product_constraints.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_constraints"),
           "| rule_cd | 규칙명 | rule_typ | use |", "|---|---|---|---|"]
    if not rows:
        out.append("| (행 0 · 제약 미등록) |  |  |  |")
    for r in rows:
        out.append(f'| {r["rule_cd"]} | {blank(r.get("rule_nm"))} | {blank(r.get("rule_typ_cd"))} | '
                   f'{blank(r.get("use_yn"))} |')
    return "\n".join(out)


def addons():
    rows = by_prd("t_prd_product_addons.csv")
    out = [marker("t_prd_product_addons"),
           "| disp | tmpl_cd | base_prd_cd |", "|---|---|---|"]
    if not rows:
        out.append("| (행 0 · 추가상품 미등록) |  |  |")
    for r in rows:
        out.append(f'| {blank(r.get("disp_seq"))} | {blank(r.get("tmpl_cd"))} | {blank(r.get("base_prd_cd"))} |')
    return "\n".join(out)


def price_binding():
    rows = by_prd("t_prd_product_price_formulas.csv")
    out = [marker("t_prd_product_price_formulas"),
           "| frm_cd | note |", "|---|---|"]
    for r in rows:
        out.append(f'| {r.get("frm_cd")} | {blank(r.get("note"))} |')
    return "\n".join(out)


if __name__ == "__main__":
    for title, fn in [("사이즈+수량규칙", sizes), ("수량 규칙(상품/묶음)", qty),
                      ("자재 BOM", materials), ("공정 라우트", processes),
                      ("인쇄옵션", print_options), ("판형", plates),
                      ("옵션그룹", optgroups), ("옵션값·다형참조(options·option_items)", options_and_items),
                      ("제약", constraints), ("추가상품", addons),
                      ("가격공식 바인딩", price_binding)]:
        print(f"\n#### {title}\n")
        print(fn())
