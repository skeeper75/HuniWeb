#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-021-pink-spot-postcard 전용.

기존 transcribe_snapshot.py(공통 축)·transcribe_product_016.py(형제 엽서)를 수정하지 않고,
핑크별색엽서(PRD_000021)의 상품별 차원·BOM·연결 수치를 라이브 스냅샷에서 결정론적으로 전사한다.
- 사이즈 · 자재 BOM(활성) · 공정 라우트(base+핑크인쇄=별색공정) · 판형 · 추가상품(봉투 5행)
- 옵션그룹(인쇄/종이/핑크인쇄) · 제약(0행) · 가격공식 바인딩(PRF_DGP_A·use_yn=N 미출시)
노드 본문의 표는 이 스크립트가 뽑은 것을 그대로 옮긴 것(사람 손전사 아님).

사용:  python3 transcribe_product_021.py           # stdout markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000021"

# 공유 axis/processes.md에 민팅된 공정 코드(축노드 존재 O). PROC_000010(핑크인쇄)은 021 단독→미민팅.
MINTED_PROC = {"PROC_000004", "PROC_000001", "PROC_000007", "PROC_000013", "PROC_000026",
               "PROC_000014", "PROC_000015", "PROC_000027", "PROC_000028", "PROC_000029",
               "PROC_000030", "PROC_000031", "PROC_000032", "PROC_000033", "PROC_000053",
               "PROC_000056", "PROC_000079", "PROC_000085"}
# 공유 axis/materials.md에 민팅된 자재 코드(축노드 존재 O).
MINTED_MAT = {"MAT_000074", "MAT_000081", "MAT_000082", "MAT_000091", "MAT_000092",
              "MAT_000101", "MAT_000103", "MAT_000109"}


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd(name):
    return [r for r in rd(name) if r.get("prd_cd") == PRD]


def marker(tbl):
    return f"<!-- transcribed-by: _meta/scripts/transcribe_product_021.py from {SNAP_ID} {tbl} PRD_000021 @ {STAMP} -->"


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
           f'{p.get("qty_unit_typ_cd")} | 상품 레벨 수량규칙(use_yn={p.get("use_yn")}) |',
           f'| t_prd_product_bundle_qtys | - | - | - | - | 행수 {len(bqs)} (묶음수 미적재·수량 UI 권위=상품/사이즈 규칙) |']
    return "\n".join(out)


def materials():
    mm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    rows = [r for r in by_prd("t_prd_product_materials.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["mat_cd"]))
    out = [marker("t_prd_product_materials+t_mat_materials (활성 del_yn≠Y)"),
           f"활성 자재 {len(rows)}행 · 전부 usage_cd 단일 슬롯(팩 §3.5)",
           "", "| mat_cd | 자재명 | usage_cd | 축노드 존재 |", "|---|---|---|---|"]
    for r in rows:
        mc = r["mat_cd"]
        out.append(f'| {mc} | {mm.get(mc, {}).get("mat_nm", "?")} | {blank(r.get("usage_cd"))} | '
                   f'{"O" if mc in MINTED_MAT else "X(미민팅)"} |')
    return "\n".join(out)


def processes():
    pm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    rows = [r for r in by_prd("t_prd_product_processes.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("mand_proc_yn") != "Y", r.get("disp_seq") or "", r["proc_cd"]))
    out = [marker("t_prd_product_processes+t_proc_processes"),
           "| proc_cd | 공정명 | upr_proc | mand | 축노드 존재 |", "|---|---|---|---|---|"]
    for r in rows:
        pc = r["proc_cd"]
        out.append(f'| {pc} | {pm.get(pc, {}).get("proc_nm", "?")} | '
                   f'{blank(pm.get(pc, {}).get("upr_proc_cd"))} | {blank(r.get("mand_proc_yn"))} | '
                   f'{"O" if pc in MINTED_PROC else "X(미민팅·단독상품)"} |')
    return "\n".join(out)


def plates():
    rows = [r for r in by_prd("t_prd_product_plate_sizes.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_plate_sizes"),
           "| siz_cd | output_paper_typ_cd | item_siz_cd | dflt_plt |", "|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["siz_cd"]} | {blank(r.get("output_paper_typ_cd"))} | '
                   f'{blank(r.get("item_siz_cd"))} | {blank(r.get("dflt_plt_yn"))} |')
    return "\n".join(out)


def addons():
    tm = {r["tmpl_cd"]: r for r in rd("t_prd_templates.csv")}
    rows = by_prd("t_prd_product_addons.csv")
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["tmpl_cd"]))
    out = [marker("t_prd_product_addons+t_prd_templates"),
           "| disp | tmpl_cd | 템플릿명 | base_prd_cd |", "|---|---|---|---|"]
    for r in rows:
        t = tm.get(r["tmpl_cd"], {})
        out.append(f'| {blank(r.get("disp_seq"))} | {r["tmpl_cd"]} | '
                   f'{blank(t.get("tmpl_nm"))} | {blank(t.get("base_prd_cd"))} |')
    return "\n".join(out)


def optgroups():
    rows = [r for r in by_prd("t_prd_product_option_groups.csv")]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["opt_grp_cd"]))
    out = [marker("t_prd_product_option_groups"),
           "| opt_grp_cd | 그룹명 | sel_typ | mand | use | del |", "|---|---|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["opt_grp_cd"]} | {blank(r.get("opt_grp_nm"))} | {blank(r.get("sel_typ_cd"))} | '
                   f'{blank(r.get("mand_yn"))} | {blank(r.get("use_yn"))} | {blank(r.get("del_yn"))} |')
    return "\n".join(out)


def constraints():
    rows = [r for r in by_prd("t_prd_product_constraints.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_constraints"),
           f"제약 행수 {len(rows)}", ""]
    if rows:
        out += ["| rule_cd | 규칙명 | rule_typ | use |", "|---|---|---|---|"]
        for r in rows:
            out.append(f'| {r["rule_cd"]} | {blank(r.get("rule_nm"))} | {blank(r.get("rule_typ_cd"))} | '
                       f'{blank(r.get("use_yn"))} |')
    else:
        out.append("(제약 미등록 — 016 데모 제약과 달리 021은 제약 0행)")
    return "\n".join(out)


def print_options():
    pm = {r["print_opt_cd"]: r for r in rd("t_prt_print_options.csv")}
    rows = [r for r in by_prd("t_prd_product_print_options.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r.get("opt_id") or ""))
    out = [marker("t_prd_product_print_options+t_prt_print_options"),
           "| print_opt_cd | 라벨 | print_side | front_clr | back_clr |", "|---|---|---|---|---|"]
    for r in rows:
        pc = r.get("print_opt_cd")
        out.append(f'| {pc} | {blank(pm.get(pc, {}).get("print_opt_nm"))} | {blank(r.get("print_side"))} | '
                   f'{blank(r.get("front_colrcnt_cd"))} | {blank(r.get("back_colrcnt_cd"))} |')
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
                      ("인쇄옵션(도수)", print_options),
                      ("판형", plates), ("추가상품(템플릿)", addons),
                      ("옵션그룹", optgroups), ("제약", constraints),
                      ("가격공식 바인딩", price_binding)]:
        print(f"\n#### {title}\n")
        print(fn())
