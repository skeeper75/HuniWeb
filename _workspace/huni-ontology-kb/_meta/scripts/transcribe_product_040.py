#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-040-white-print-namecard 전용.

화이트인쇄명함(PRD_000040)의 상품별 차원·BOM·연결 수치를 라이브 스냅샷에서 결정론적으로 전사한다.
- 정체 · 카테고리 · 사이즈(단일) · 수량규칙 · 자재 BOM(활성 색지 4·굿즈오염/화이트 del 표기)
- 공정 라우트(화이트/클리어 별색 + 직각/둥근 모서리) · 인쇄옵션 · 판형 · 추가상품(0)
- 옵션그룹(클리어별색 1) · 옵션(OPV) · 옵션아이템(0=ref 레이어 부재) · 제약(0) · 가격공식 바인딩
- 가격공식 구성요소 배선(PRF_NAMECARD_WHITE 4구성요소·차원키만·단가값 제외)

★040은 020(화이트인쇄엽서)의 명함 버전 + 032(코팅명함) 고정가 골격의 하이브리드.
  - 색지 4종(MAT_000362~365)·별색 공정(PROC_000008/009) = 020 공유(product-020-nodes 정의 재사용)
  - 모서리 공정(PROC_000027/028) = 공유 axis/processes
  - flat 명함 공식 PRF_NAMECARD_WHITE + 4구성요소 = 040 신규(product-local mint)

기존 transcribe_product_020.py를 수정하지 않고 040 전용 신설(하네스 지침: 기존 스크립트 수정 금지).
단가값(unit_price)은 전사하지 않는다(D-18 가격 경계·값=evaluate_price 권위). 차원키(print_opt/opt)만.

사용:  python3 transcribe_product_040.py           # stdout markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000040"
FRM = "PRF_NAMECARD_WHITE"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd(name):
    return [r for r in rd(name) if r.get("prd_cd") == PRD]


def marker(tbl):
    return f"<!-- transcribed-by: _meta/scripts/transcribe_product_040.py from {SNAP_ID} {tbl} PRD_000040 @ {STAMP} -->"


def blank(v):
    return "" if v in (None, "") else v


def identity():
    p = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}.get(PRD, {})
    out = [marker("t_prd_products"),
           "| 컬럼 | 값 |", "|---|---|",
           f'| prd_cd | {p.get("prd_cd")} |',
           f'| prd_nm | {blank(p.get("prd_nm"))} |',
           f'| prd_typ_cd | {blank(p.get("prd_typ_cd"))} |',
           f'| min_qty | {blank(p.get("min_qty"))} |',
           f'| max_qty | {blank(p.get("max_qty"))} |',
           f'| qty_incr | {blank(p.get("qty_incr"))} |',
           f'| qty_unit_typ_cd | {blank(p.get("qty_unit_typ_cd"))} |',
           f'| file_upload_yn | {blank(p.get("file_upload_yn"))} |',
           f'| editor_yn | {blank(p.get("editor_yn"))} |',
           f'| use_yn | {blank(p.get("use_yn"))} |',
           f'| del_yn | {blank(p.get("del_yn"))} |']
    return "\n".join(out)


def categories():
    cm = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    rows = [r for r in by_prd("t_prd_product_categories.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["cat_cd"]))
    out = [marker("t_prd_product_categories+t_cat_categories"),
           "| cat_cd | 분류명 | main_cat_yn |", "|---|---|---|"]
    for r in rows:
        c = cm.get(r["cat_cd"], {})
        out.append(f'| {r["cat_cd"]} | {blank(c.get("cat_nm"))} | {blank(r.get("main_cat_yn"))} |')
    return "\n".join(out)


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
    allrows = by_prd("t_prd_product_materials.csv")
    active = [r for r in allrows if r.get("del_yn") != "Y"]
    deleted = [r for r in allrows if r.get("del_yn") == "Y"]
    active.sort(key=lambda r: (r.get("disp_seq") or "", r["mat_cd"]))
    deleted.sort(key=lambda r: r["mat_cd"])
    out = [marker("t_prd_product_materials+t_mat_materials (활성 del_yn≠Y)"),
           f"활성 자재 {len(active)}행 · 화이트인쇄=유색 색지(흰 색지·화이트 용지 제외·도메인 필터). "
           f"del_yn=Y {len(deleted)}행(굿즈 자재 오염 + 화이트 대비0 정리·2026-06-30).",
           "", "| mat_cd | 자재명 | mat_typ | usage_cd | 상태 |", "|---|---|---|---|---|"]
    for r in active:
        m = mm.get(r["mat_cd"], {})
        out.append(f'| {r["mat_cd"]} | {blank(m.get("mat_nm"))} | {blank(m.get("mat_typ_cd"))} | {blank(r.get("usage_cd"))} | 활성 |')
    for r in deleted:
        m = mm.get(r["mat_cd"], {})
        out.append(f'| {r["mat_cd"]} | {blank(m.get("mat_nm"))} | {blank(m.get("mat_typ_cd"))} | {blank(r.get("usage_cd"))} | del_yn=Y(정리) |')
    return "\n".join(out)


def processes():
    pm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    rows = [r for r in by_prd("t_prd_product_processes.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("mand_proc_yn") != "Y", r.get("disp_seq") or "", r["proc_cd"]))
    # 040이 참조하는 축노드: 008/009=product-020-nodes, 027/028=axis/processes(승격 260703)
    minted = {"PROC_000008", "PROC_000009", "PROC_000027", "PROC_000028"}
    src = {"PROC_000008": "020-nodes", "PROC_000009": "020-nodes",
           "PROC_000027": "axis", "PROC_000028": "axis"}
    out = [marker("t_prd_product_processes+t_proc_processes"),
           "| proc_cd | 공정명 | mand | 축노드 존재 | 정의 위치 |", "|---|---|---|---|---|"]
    for r in rows:
        pc = r["proc_cd"]
        out.append(f'| {pc} | {pm.get(pc, {}).get("proc_nm", "?")} | {blank(r.get("mand_proc_yn"))} | '
                   f'{"O" if pc in minted else "X(미민팅)"} | {src.get(pc, "-")} |')
    return "\n".join(out)


def print_options():
    ptm = {r["print_opt_cd"]: r for r in rd("t_prt_print_options.csv")}
    rows = [r for r in by_prd("t_prd_product_print_options.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r.get("print_opt_cd") or ""))
    out = [marker("t_prd_product_print_options+t_prt_print_options"),
           "| print_opt_cd | 인쇄옵션명 | print_side | front_clr | back_clr |", "|---|---|---|---|---|"]
    for r in rows:
        pc = r.get("print_opt_cd")
        t = ptm.get(pc, {})
        out.append(f'| {blank(pc)} | {blank(t.get("print_opt_nm"))} | {blank(r.get("print_side"))} | '
                   f'{blank(r.get("front_colrcnt_cd"))} | {blank(r.get("back_colrcnt_cd"))} |')
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
    if len(rows) == 0:
        out.append("| (행 없음) | | | |")
    return "\n".join(out)


def optgroups():
    rows = [r for r in by_prd("t_prd_product_option_groups.csv")]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["opt_grp_cd"]))
    out = [marker("t_prd_product_option_groups"),
           "| opt_grp_cd | 그룹명 | sel_typ | mand | min/max | use | del |", "|---|---|---|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["opt_grp_cd"]} | {blank(r.get("opt_grp_nm"))} | {blank(r.get("sel_typ_cd"))} | '
                   f'{blank(r.get("mand_yn"))} | {blank(r.get("min_sel_cnt"))}/{blank(r.get("max_sel_cnt"))} | '
                   f'{blank(r.get("use_yn"))} | {blank(r.get("del_yn"))} |')
    return "\n".join(out)


def options():
    rows = [r for r in by_prd("t_prd_product_options.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("opt_grp_cd") or "", r.get("disp_seq") or ""))
    out = [marker("t_prd_product_options"),
           "| opt_cd | opt_grp_cd | 옵션명 | dflt |", "|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["opt_cd"]} | {blank(r.get("opt_grp_cd"))} | {blank(r.get("opt_nm"))} | {blank(r.get("dflt_yn"))} |')
    if len(rows) == 0:
        out.append("| (행 없음) | | | |")
    return "\n".join(out)


def option_items():
    rows = [r for r in by_prd("t_prd_product_option_items.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_option_items"),
           "| opt_cd | ref_dim_cd | ref_key1 | ref_key2 |", "|---|---|---|---|"]
    for r in rows:
        out.append(f'| {blank(r.get("opt_cd"))} | {blank(r.get("ref_dim_cd"))} | '
                   f'{blank(r.get("ref_key1"))} | {blank(r.get("ref_key2"))} |')
    if len(rows) == 0:
        out.append("| (행 없음 — CPQ ref_dim 레이어 부재·GAP) | | | |")
    return "\n".join(out)


def constraints():
    rows = [r for r in by_prd("t_prd_product_constraints.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_constraints"),
           "| rule_cd | 규칙명 | rule_typ | use |", "|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["rule_cd"]} | {blank(r.get("rule_nm"))} | {blank(r.get("rule_typ_cd"))} | '
                   f'{blank(r.get("use_yn"))} |')
    if len(rows) == 0:
        out.append("| (행 없음) | | | |")
    return "\n".join(out)


def price_binding():
    rows = by_prd("t_prd_product_price_formulas.csv")
    out = [marker("t_prd_product_price_formulas"),
           "| frm_cd | apply_bgn_ymd |", "|---|---|"]
    for r in rows:
        out.append(f'| {r.get("frm_cd")} | {blank(r.get("apply_bgn_ymd"))} |')
    if len(rows) == 0:
        out.append("| (행 없음) | |")
    return "\n".join(out)


def formula_wiring():
    """PRF_NAMECARD_WHITE 배선 — 4구성요소·차원키(print_opt/opt)만·단가값 제외(D-18)."""
    fc = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    cps = {}
    for r in rd("t_prc_component_prices.csv"):
        cps.setdefault(r["comp_cd"], []).append(r)
    wire = [r for r in rd("t_prc_formula_components.csv") if r.get("frm_cd") == FRM]
    wire.sort(key=lambda r: (r.get("disp_seq") or ""))
    out = [marker(f"t_prc_formula_components+t_prc_price_components (frm_cd:{FRM})"),
           "| disp | comp_cd | prc_typ | use_dims | 차원키(print_opt·opt) |",
           "|---|---|---|---|---|"]
    for r in wire:
        c = fc.get(r["comp_cd"], {})
        keys = sorted({(p.get("print_opt_cd") or "", p.get("opt_cd") or "")
                       for p in cps.get(r["comp_cd"], [])})
        keystr = "; ".join(f"{k[0] or '-'}/{k[1] or '-'}" for k in keys) or "-"
        out.append(f'| {blank(r.get("disp_seq"))} | {r["comp_cd"]} | {blank(c.get("prc_typ_cd"))} | '
                   f'{blank(c.get("use_dims"))} | {keystr} |')
    return "\n".join(out)


if __name__ == "__main__":
    for title, fn in [("정체", identity), ("카테고리", categories),
                      ("사이즈+수량규칙", sizes), ("수량 규칙(상품/묶음)", qty),
                      ("자재 BOM", materials), ("공정 라우트", processes),
                      ("인쇄옵션", print_options), ("판형", plates),
                      ("추가상품(템플릿)", addons), ("옵션그룹", optgroups),
                      ("옵션(OPV)", options), ("옵션아이템(ref_dim)", option_items),
                      ("제약", constraints), ("가격공식 바인딩", price_binding),
                      ("가격공식 구성요소 배선", formula_wiring)]:
        print(f"\n#### {title}\n")
        print(fn())
