#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-039-transparent-namecard 전용.

투명명함(PRD_000039)의 상품별 차원·BOM·연결 수치를 라이브 스냅샷에서 결정론적으로 전사한다.
019 투명엽서 스크립트를 수정하지 않고 별도 파일로 둔다(재현성·자기 네임스페이스).
- 정체·수량 · 사이즈 · 자재 BOM(활성) · 공정 라우트(mand/opt) · 판형(전 행·del 표기)
- 인쇄옵션 · 옵션그룹(0행) · 제약(0행) · 추가상품(0행) · 가격공식 바인딩 + formula_components 배선
노드 본문의 표는 이 스크립트가 뽑은 것을 그대로 옮긴 것(사람 손전사 아님).

사용:  python3 transcribe_product_039.py           # stdout markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000039"
FRM = "PRF_NAMECARD_CLEAR"

# 039가 참조하는 코드 중 공유 axis에 이미 민팅된 것(2026-07-03 기준 실사)
MINTED_PROC = {"PROC_000027", "PROC_000028"}   # 디지털 base(004)·화이트인쇄(008)는 039에 미존재
MINTED_MAT = set()   # MAT_000178 PET(MAT_TYPE.08)=미민팅(공유 axis/materials 미보유)


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd(name):
    return [r for r in rd(name) if r.get("prd_cd") == PRD]


def marker(tbl):
    return f"<!-- transcribed-by: _meta/scripts/transcribe_product_039.py from {SNAP_ID} {tbl} PRD_000039 @ {STAMP} -->"


def blank(v):
    return "" if v in (None, "") else v


def identity():
    p = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}.get(PRD, {})
    out = [marker("t_prd_products"),
           "| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |",
           "|---|---|---|---|---|---|---|---|",
           f'| {p.get("prd_typ_cd")} | {p.get("min_qty")} | {p.get("max_qty")} | {p.get("qty_incr")} | '
           f'{p.get("qty_unit_typ_cd")} | {p.get("file_upload_yn")} | {p.get("editor_yn")} | {p.get("use_yn")} |']
    return "\n".join(out)


def categories():
    cm = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    rows = by_prd("t_prd_product_categories.csv")
    rows.sort(key=lambda r: (r.get("main_cat_yn") != "Y", r.get("disp_seq") or ""))
    out = [marker("t_prd_product_categories+t_cat_categories"),
           "| cat_cd | 분류명 | main_cat | lvl |", "|---|---|---|---|"]
    for r in rows:
        c = cm.get(r["cat_cd"], {})
        out.append(f'| {r["cat_cd"]} | {blank(c.get("cat_nm"))} | {blank(r.get("main_cat_yn"))} | {blank(c.get("cat_lvl"))} |')
    return "\n".join(out)


def sizes():
    smaster = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    rows = [r for r in by_prd("t_prd_product_sizes.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["siz_cd"]))
    out = [marker("t_prd_product_sizes+t_siz_sizes"),
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt |", "|---|---|---|---|---|"]
    for r in rows:
        m = smaster.get(r["siz_cd"], {})
        work = f'{blank(m.get("work_width"))}x{blank(m.get("work_height"))}'
        cut = f'{blank(m.get("cut_width"))}x{blank(m.get("cut_height"))}'
        out.append(f'| {r["siz_cd"]} | {blank(m.get("siz_nm"))} | {work} | {cut} | {blank(r.get("dflt_yn"))} |')
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
    act = [r for r in allrows if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_materials+t_mat_materials (전 행·del 표기)"),
           f"전 {len(allrows)}행 (활성 {len(act)}행) · usage_cd 단일 슬롯(팩 §3.5)",
           "", "| mat_cd | 자재명 | mat_typ | usage | dflt | del | 축노드 |", "|---|---|---|---|---|---|---|"]
    for r in sorted(allrows, key=lambda r: (r.get("disp_seq") or "", r["mat_cd"])):
        mc = r["mat_cd"]
        m = mm.get(mc, {})
        out.append(f'| {mc} | {blank(m.get("mat_nm"))} | {blank(m.get("mat_typ_cd"))} | '
                   f'{blank(r.get("usage_cd"))} | {blank(r.get("dflt_yn"))} | {blank(r.get("del_yn"))} | '
                   f'{"O" if mc in MINTED_MAT else "X(미민팅)"} |')
    return "\n".join(out)


def processes():
    pm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    rows = [r for r in by_prd("t_prd_product_processes.csv") if r.get("del_yn") != "Y"]
    rows.sort(key=lambda r: (r.get("mand_proc_yn") != "Y", r.get("disp_seq") or "", r["proc_cd"]))
    out = [marker("t_prd_product_processes+t_proc_processes"),
           "| proc_cd | 공정명 | 상위 proc | mand | 축노드 |", "|---|---|---|---|---|"]
    for r in rows:
        pc = r["proc_cd"]
        p = pm.get(pc, {})
        out.append(f'| {pc} | {blank(p.get("proc_nm"))} | {blank(p.get("upr_proc_cd"))} | '
                   f'{blank(r.get("mand_proc_yn"))} | {"O" if pc in MINTED_PROC else "X(미민팅)"} |')
    return "\n".join(out)


def plates():
    sm = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    rows = by_prd("t_prd_product_plate_sizes.csv")
    rows.sort(key=lambda r: (r.get("del_yn") == "Y", r["siz_cd"]))
    out = [marker("t_prd_product_plate_sizes (전 행·del 표기)"),
           "| siz_cd | 규격(전지) | output_paper_typ_cd | note | del |", "|---|---|---|---|---|"]
    for r in rows:
        m = sm.get(r["siz_cd"], {})
        spec = f'{blank(m.get("work_width"))}x{blank(m.get("work_height"))}'
        out.append(f'| {r["siz_cd"]} | {spec} | {blank(r.get("output_paper_typ_cd"))} | '
                   f'{blank(r.get("note"))} | {blank(r.get("del_yn"))} |')
    return "\n".join(out)


def print_options():
    cc = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    po = {r["print_opt_cd"]: r for r in rd("t_prt_print_options.csv")}
    rows = [r for r in by_prd("t_prd_product_print_options.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_print_options+t_prt_print_options+t_clr_color_counts"),
           "| print_opt_cd | 라벨 | print_side | 앞도수 | 뒷도수 |", "|---|---|---|---|---|"]
    for r in rows:
        pc = r.get("print_opt_cd")
        f = cc.get(r.get("front_colrcnt_cd"), {}).get("clr_nm", r.get("front_colrcnt_cd"))
        b = cc.get(r.get("back_colrcnt_cd"), {}).get("clr_nm", r.get("back_colrcnt_cd"))
        out.append(f'| {pc} | {po.get(pc, {}).get("print_opt_nm", "?")} | '
                   f'{blank(r.get("print_side"))} | {blank(f)} | {blank(b)} |')
    return "\n".join(out)


def optgroups():
    rows = [r for r in by_prd("t_prd_product_option_groups.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_option_groups"),
           f"활성 옵션그룹 {len(rows)}행" + (" (없음 — CPQ 옵션 레이어 미구성)" if not rows else "")]
    return "\n".join(out)


def constraints():
    rows = [r for r in by_prd("t_prd_product_constraints.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_constraints"),
           f"활성 제약 {len(rows)}행" + (" (없음)" if not rows else "")]
    return "\n".join(out)


def addons():
    rows = by_prd("t_prd_product_addons.csv")
    out = [marker("t_prd_product_addons"),
           f"추가상품 {len(rows)}행" + (" (없음)" if not rows else "")]
    return "\n".join(out)


def price_binding():
    fm = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    fcs = [r for r in rd("t_prc_formula_components.csv") if r.get("frm_cd") == FRM]
    fcs.sort(key=lambda r: (r.get("disp_seq") or ""))
    rows = by_prd("t_prd_product_price_formulas.csv")
    out = [marker("t_prd_product_price_formulas"),
           "| frm_cd | apply_bgn | note |", "|---|---|---|"]
    for r in rows:
        out.append(f'| {r.get("frm_cd")} | {blank(r.get("apply_bgn_ymd"))} | {blank(r.get("note"))} |')
    out += ["", marker("t_prc_price_formulas+t_prc_formula_components (배선)"),
            f'공식 {FRM} = {fm.get(FRM, {}).get("frm_nm", "?")} (use_yn={fm.get(FRM, {}).get("use_yn")})',
            "", "| comp_cd | disp_seq | addtn |", "|---|---|---|"]
    for r in fcs:
        out.append(f'| {r["comp_cd"]} | {blank(r.get("disp_seq"))} | {blank(r.get("addtn_yn"))} |')
    return "\n".join(out)


if __name__ == "__main__":
    for title, fn in [("정체·수량", identity), ("카테고리", categories),
                      ("사이즈", sizes), ("수량 규칙(상품/묶음)", qty),
                      ("자재 BOM", materials), ("공정 라우트", processes),
                      ("판형", plates), ("인쇄옵션", print_options),
                      ("옵션그룹", optgroups), ("제약", constraints),
                      ("추가상품", addons), ("가격공식 바인딩", price_binding)]:
        print(f"\n#### {title}\n")
        print(fn())
