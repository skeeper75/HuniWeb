#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — product-019-transparent-postcard 전용.

기존 transcribe_snapshot.py(공통 축)·transcribe_product_016.py(형제 엽서)를 수정하지 않고,
투명엽서(PRD_000019)의 상품별 차원·BOM·연결 수치를 라이브 스냅샷에서 결정론적으로 전사한다.
- 사이즈 · 수량규칙(상품/묶음) · 자재 BOM(활성) · 공정 라우트(mand/opt) · 판형 · 추가상품(없음)
- 인쇄옵션 · 옵션그룹 · 옵션아이템(ref_dim) · 제약(없음) · 가격공식 바인딩
노드 본문의 표는 이 스크립트가 뽑은 것을 그대로 옮긴 것(사람 손전사 아님).

사용:  python3 transcribe_product_019.py           # stdout markdown 블록
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, os

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000019"

# 019가 참조하는 코드 중 공유 axis에 이미 민팅된 것(2026-07-03 기준 실사)
MINTED_PROC = {"PROC_000004", "PROC_000027", "PROC_000028"}   # PROC_000008 화이트인쇄=미민팅
MINTED_MAT = set()   # MAT_000144/147 투명·반투명 PET=미민팅(공유 axis/materials 미보유)


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def by_prd(name):
    return [r for r in rd(name) if r.get("prd_cd") == PRD]


def marker(tbl):
    return f"<!-- transcribed-by: _meta/scripts/transcribe_product_019.py from {SNAP_ID} {tbl} PRD_000019 @ {STAMP} -->"


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
    allrows = by_prd("t_prd_product_materials.csv")
    act = [r for r in allrows if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_materials+t_mat_materials (전 행·del 표기)"),
           f"전 {len(allrows)}행 (활성 {len(act)}행) · 전부 usage_cd 단일 슬롯(팩 §3.5)",
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
           "| proc_cd | 공정명 | 상위 proc_grp | mand | 축노드 |", "|---|---|---|---|---|"]
    for r in rows:
        pc = r["proc_cd"]
        p = pm.get(pc, {})
        # t_proc_processes: proc_cd,proc_nm,parent_proc_cd(3열)
        parent = list(p.values())[2] if len(p) >= 3 else ""
        out.append(f'| {pc} | {blank(p.get("proc_nm"))} | {blank(parent)} | '
                   f'{blank(r.get("mand_proc_yn"))} | {"O" if pc in MINTED_PROC else "X(미민팅)"} |')
    return "\n".join(out)


def plates():
    rows = by_prd("t_prd_product_plate_sizes.csv")
    rows.sort(key=lambda r: (r.get("del_yn") == "Y", r["siz_cd"]))
    out = [marker("t_prd_product_plate_sizes (전 행·del 표기)"),
           "| siz_cd | output_paper_typ_cd | item_siz_cd | 비고 | del |", "|---|---|---|---|---|"]
    for r in rows:
        # 컬럼: prd_cd,siz_cd,dflt_yn,output_paper_typ_cd,item_siz_cd,note?,reg,upd,del_yn...
        out.append(f'| {r["siz_cd"]} | {blank(r.get("output_paper_typ_cd"))} | '
                   f'{blank(r.get("item_siz_cd"))} | {blank(r.get("note"))} | {blank(r.get("del_yn"))} |')
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
    rows = [r for r in by_prd("t_prd_product_option_groups.csv")]
    rows.sort(key=lambda r: (r.get("disp_seq") or "", r["opt_grp_cd"]))
    out = [marker("t_prd_product_option_groups"),
           "| opt_grp_cd | 그룹명 | sel_typ | min~max | mand | use | del |", "|---|---|---|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["opt_grp_cd"]} | {blank(r.get("opt_grp_nm"))} | {blank(r.get("sel_typ_cd"))} | '
                   f'{blank(r.get("min_sel_cnt"))}~{blank(r.get("max_sel_cnt"))} | {blank(r.get("mand_yn"))} | '
                   f'{blank(r.get("use_yn"))} | {blank(r.get("del_yn"))} |')
    return "\n".join(out)


def option_items():
    opts = {r["opt_cd"]: r for r in by_prd("t_prd_product_options.csv")}
    grp = {r["opt_grp_cd"]: r for r in by_prd("t_prd_product_option_groups.csv")}
    rows = [r for r in by_prd("t_prd_product_option_items.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_options+t_prd_product_option_items"),
           "| opt_grp | opt_cd | 옵션명 | ref_dim_cd | ref_key1 |", "|---|---|---|---|---|"]
    for r in rows:
        o = opts.get(r["opt_cd"], {})
        g = grp.get(o.get("opt_grp_cd"), {})
        out.append(f'| {blank(g.get("opt_grp_nm"))} | {r["opt_cd"]} | {blank(o.get("opt_nm"))} | '
                   f'{blank(r.get("ref_dim_cd"))} | {blank(r.get("ref_key1"))} |')
    # 옵션값 중 option_items ref 미보유(약참조 미배선) 표시
    item_optcds = {r["opt_cd"] for r in rows}
    noref = [o for c, o in opts.items() if o.get("del_yn") != "Y" and c not in item_optcds]
    if noref:
        out.append("")
        out.append("옵션값 중 option_items ref 행 미보유(차원 미배선·관찰): " +
                   ", ".join(f'{o["opt_cd"]}({o.get("opt_nm")})' for o in sorted(noref, key=lambda x: x["opt_cd"])))
    return "\n".join(out)


def constraints():
    rows = [r for r in by_prd("t_prd_product_constraints.csv") if r.get("del_yn") != "Y"]
    out = [marker("t_prd_product_constraints"),
           f"활성 제약 {len(rows)}행" + (" (없음)" if not rows else ""),
           "| rule_cd | 규칙명 | rule_typ | use |", "|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["rule_cd"]} | {blank(r.get("rule_nm"))} | {blank(r.get("rule_typ_cd"))} | '
                   f'{blank(r.get("use_yn"))} |')
    return "\n".join(out)


def addons():
    rows = by_prd("t_prd_product_addons.csv")
    out = [marker("t_prd_product_addons"),
           f"추가상품 {len(rows)}행" + (" (없음 — 형제 016은 봉투 5행 보유)" if not rows else "")]
    return "\n".join(out)


def price_binding():
    rows = by_prd("t_prd_product_price_formulas.csv")
    out = [marker("t_prd_product_price_formulas"),
           "| frm_cd | apply_bgn | note |", "|---|---|---|"]
    for r in rows:
        out.append(f'| {r.get("frm_cd")} | {blank(r.get("apply_bgn_ymd"))} | {blank(r.get("note"))} |')
    return "\n".join(out)


if __name__ == "__main__":
    for title, fn in [("사이즈", sizes), ("수량 규칙(상품/묶음)", qty),
                      ("자재 BOM", materials), ("공정 라우트", processes),
                      ("판형", plates), ("인쇄옵션", print_options),
                      ("옵션그룹", optgroups), ("옵션아이템(ref_dim)", option_items),
                      ("제약", constraints), ("추가상품", addons),
                      ("가격공식 바인딩", price_binding)]:
        print(f"\n#### {title}\n")
        print(fn())
