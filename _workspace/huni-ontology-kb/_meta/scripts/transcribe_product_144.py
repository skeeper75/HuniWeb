#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000144 미니보드스탠딩 (실사·★고정가형[siz_cd×수량밴드 룩업]·D-9·§4·[HARD] LLM 손전사 금지).

미니보드스탠딩(144)의 카테고리(사인 CAT_000005 + POP CAT_000097)·규격 사이즈(A5/A4/A3)·수량밴드·
고정가 SHAPE(값 아님·차원·행수·siz_cd 셀·수량밴드만)를 결정론 전사한다.
★131 프레임리스우드액자(고정가·수량 단일밴드)와 달리 144는 **고정가 [규격(siz_cd)×수량밴드]** 룩업이다
  (use_dims=[siz_cd,min_qty]·수량축 5밴드 실충전) — pack §3.10 "고정가 15상품 = [수량×규격] 블록·수량축 보유" 대표.
★118 아트프린트포스터(면적매트릭스 [가로×세로])와도 다른 아키타입(등록 규격 siz_cd 키·off-grid ceiling 없음).
★자재/공정/인쇄옵션 = t_prd_product_materials/processes/print_options 0행(★거치대/보드접착=통가격 baked·note "출력+코팅+가공(보드접착+거치대) 포함가").
★실사=비종이류(대형 출력+보드+거치대) → 판형(plate_size)은 파일사양 placeholder(전부 del_yn=Y)·종이류 판형 아님(전사=관찰용·T-7).
★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원·격자완전성"까지만(D-18·값=evaluate_price).

사용:  python3 transcribe_product_144.py            # stdout markdown 블록
       python3 transcribe_product_144.py --json     # cache/transcribed-144-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000144"
SIZES_ACTIVE = ["SIZ_000170", "SIZ_000172", "SIZ_000174"]   # A5/A4/A3 (product_sizes junction del_yn=N)
PLATE_PLACEHOLDER = ["SIZ_000007", "SIZ_000050", "SIZ_000052"]  # 파일사양 placeholder(JPG·junction del_yn=Y·비종이류·판형 아님)
FRM = "PRF_POSTER_MINI_STANDBOARD"
COMP = "COMP_POSTER_MINI_STANDBOARD"                          # 고정가 완제품가 구성요소(siz_cd×수량밴드 룩업)


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _num(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    pcat = [r for r in rd("t_prd_product_categories.csv") if r["prd_cd"] == PRD]
    psz = {r["siz_cd"]: r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD}
    pplt = {r["siz_cd"]: r for r in rd("t_prd_product_plate_sizes.csv") if r["prd_cd"] == PRD}
    pmat = [r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD]
    pproc = [r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD]
    ppo = [r for r in rd("t_prd_product_print_options.csv") if r["prd_cd"] == PRD]
    pog = [r for r in rd("t_prd_product_option_groups.csv") if r["prd_cd"] == PRD]
    pcon = [r for r in rd("t_prd_product_constraints.csv") if r["prd_cd"] == PRD]
    padd = [r for r in rd("t_prd_product_addons.csv") if r["prd_cd"] == PRD]
    pset = [r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD]
    pbq = [r for r in rd("t_prd_product_bundle_qtys.csv") if r["prd_cd"] == PRD]
    pfrm = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fcomp = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == FRM]
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv") if r["comp_cd"] == COMP}
    # 고정가 SHAPE — 값(unit_price) 미전사, siz_cd 셀 수·수량밴드만
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP]
    siz_cells = sorted({r["siz_cd"] for r in cp if r.get("siz_cd")})
    qty_bands = sorted({int(r["min_qty"]) for r in cp if r.get("min_qty")})
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_144.py"},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm", "?"),
                        "upr": cat.get(r["cat_cd"], {}).get("upr_cat_cd", ""),
                        "lvl": cat.get(r["cat_cd"], {}).get("cat_lvl", ""),
                        "main": r.get("main_cat_yn", "")}
                       for r in pcat],
        "sizes_active": {s: {"siz_nm": siz[s]["siz_nm"],
                             "work": f'{_num(siz[s]["work_width"])}x{_num(siz[s]["work_height"])}',
                             "master_del_yn": siz[s].get("del_yn", "") or "N",
                             "junc_del_yn": psz.get(s, {}).get("del_yn", "") or "N"}
                         for s in SIZES_ACTIVE if s in siz},
        "materials_junction_rows": len(pmat),
        "processes_junction_rows": len(pproc),
        "print_options_rows": len(ppo),
        "option_groups_rows": len(pog),
        "constraints_rows": len(pcon),
        "addons_rows": len(padd),
        "sets_parent_rows": len(pset),
        "bundle_qtys_rows": len(pbq),
        "plate_placeholder": {s: {"siz_nm": siz.get(s, {}).get("siz_nm", "?"),
                                  "junc_del_yn": pplt.get(s, {}).get("del_yn", "") or "N"}
                              for s in PLATE_PLACEHOLDER},
        "qty": {"nonspec_yn": prod[PRD]["nonspec_yn"],
                "min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"],
                "use_yn": prod[PRD]["use_yn"], "del_yn": prod[PRD]["del_yn"],
                "editor_yn": prod[PRD]["editor_yn"], "file_upload_yn": prod[PRD]["file_upload_yn"],
                "prd_typ_cd": prod[PRD]["prd_typ_cd"], "prd_nm": prod[PRD]["prd_nm"]}
        if PRD in prod else {},
        "formula": {"frm_cd": FRM,
                    "bound": bool(pfrm),
                    "comp_wired": [{"comp_cd": r["comp_cd"], "disp_seq": r["disp_seq"], "addtn": r["addtn_yn"]}
                                   for r in fcomp]},
        "component": {"comp_cd": COMP,
                      "prc_typ_cd": pcomp.get(COMP, {}).get("prc_typ_cd", ""),
                      "comp_typ_cd": pcomp.get(COMP, {}).get("comp_typ_cd", ""),
                      "use_dims": "[siz_cd, min_qty]"},
        "fixed_shape": {"comp_cd": COMP, "row_count": len(cp),
                        "use_dims": ["siz_cd", "min_qty"],
                        "distinct_siz": len(siz_cells), "siz_cells": siz_cells,
                        "qty_bands": qty_bands,
                        "grid_full": len(cp) == len(siz_cells) * max(1, len(qty_bands)),
                        "qty_populated": len(qty_bands) > 1,
                        "band_floor": min(qty_bands) if qty_bands else None,
                        "product_min_qty": int(prod[PRD]["min_qty"]) if PRD in prod else None,
                        "size_price_match": sorted(SIZES_ACTIVE) == siz_cells},
    }


def md(d):
    out = []
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from {SNAP_ID} t_prd_product_categories+t_cat_categories PRD_000144 @ {STAMP} -->")
    out.append("| cat_cd | 분류명 | 상위 | lvl | main_cat_yn |")
    out.append("|---|---|---|---|---|")
    for c in d["categories"]:
        out.append(f'| {c["cat_cd"]} | {c["cat_nm"]} | {c["upr"] or "-"} | {c["lvl"]} | {c["main"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from {SNAP_ID} t_prd_product_sizes+t_siz_sizes PRD_000144 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 작업(work mm) | master_del_yn | junction_del_yn |")
    out.append("|---|---|---|---|---|")
    for s, v in d["sizes_active"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["master_del_yn"]} | {v["junc_del_yn"]} |')
    out.append("")
    out.append(f'자재(t_prd_product_materials) 활성 행수 = {d["materials_junction_rows"]} '
               f'(★소재 미등록·완제품 통가격 baked[출력+코팅+가공(보드접착+거치대)]·pack §3.5 보드/우드 5상품 L1 빈값 AMBIGUOUS·GAP)')
    out.append(f'공정(t_prd_product_processes) 활성 행수 = {d["processes_junction_rows"]} '
               f'(★보드접착·거치대 가공이 통가격 baked·별도 공정 미등록·pack §3.6)')
    out.append(f'인쇄옵션(t_prd_product_print_options) 행수 = {d["print_options_rows"]} (실사 도수 없음·대형 잉크젯 풀컬러·pack §3.3)')
    out.append(f'옵션그룹(t_prd_product_option_groups) 행수 = {d["option_groups_rows"]} '
               f'· 제약(t_prd_product_constraints) = {d["constraints_rows"]} '
               f'· 추가상품(t_prd_product_addons) = {d["addons_rows"]} '
               f'· 셋트부모(t_prd_product_sets) = {d["sets_parent_rows"]} '
               f'· bundle_qtys = {d["bundle_qtys_rows"]} (★전부 0행·CPQ 미적재 BATCH-6·수량 UI=상품레벨)')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from {SNAP_ID} t_prd_product_plate_sizes (★전 행 output_paper_typ 공란=파일사양 placeholder·junction del_yn=Y 논리삭제·비종이류 판형 무의미·pack §3.8·T-7) PRD_000144 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 용도 | junction_del_yn |")
    out.append("|---|---|---|---|")
    for s, v in d["plate_placeholder"].items():
        out.append(f'| {s} | {v["siz_nm"]} | JPG 파일사양(판형 아님) | {v["junc_del_yn"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from {SNAP_ID} t_prd_products PRD_000144 @ {STAMP} -->")
    out.append("| 항목 | 값 |")
    out.append("|---|---|")
    q = d["qty"]
    for k, lab in [("prd_nm", "prd_nm"), ("prd_typ_cd", "prd_typ_cd"), ("nonspec_yn", "nonspec_yn(★N=사용자입력 없음)"),
                   ("min_qty", "min_qty"), ("max_qty", "max_qty"), ("qty_incr", "qty_incr"),
                   ("unit", "qty_unit"), ("use_yn", "use_yn"), ("del_yn", "del_yn"),
                   ("file_upload_yn", "file_upload"), ("editor_yn", "editor")]:
        out.append(f'| {lab} | {q.get(k)} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from {SNAP_ID} t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components PRD_000144 @ {STAMP} -->")
    out.append("| frm_cd | 상품 바인딩 | comp_cd(배선) | prc_typ_cd | comp_typ_cd | use_dims |")
    out.append("|---|---|---|---|---|---|")
    f, c = d["formula"], d["component"]
    wired = ",".join(w["comp_cd"] for w in f["comp_wired"]) or "-"
    out.append(f'| {f["frm_cd"]} | {f["bound"]} | {wired} | {c["prc_typ_cd"]} | {c["comp_typ_cd"]} | {c["use_dims"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_144.py from {SNAP_ID} t_prc_component_prices COMP_POSTER_MINI_STANDBOARD (★고정가 SHAPE·수량밴드 존재·값 미전사) @ {STAMP} -->")
    out.append("| comp_cd | 차원(use_dims) | 규격셀수 | siz 셀 | 수량밴드수 | 수량밴드 하한 | 단가행수 | 격자완전 | 수량축충전 | 규격=가격셀 정합 |")
    out.append("|---|---|---|---|---|---|---|---|---|---|")
    fs = d["fixed_shape"]
    out.append(f'| {fs["comp_cd"]} | {"×".join(fs["use_dims"])} | {fs["distinct_siz"]} '
               f'| {",".join(fs["siz_cells"])} | {len(fs["qty_bands"])} | {fs["band_floor"]} | {fs["row_count"]} '
               f'| {fs["grid_full"]} | {fs["qty_populated"]} | {fs["size_price_match"]} |')
    out.append("")
    out.append(f'> ★수량밴드 개수={len(fs["qty_bands"])}(하한 코드값만 전사·단가 미전사)·상품 min_qty={fs["product_min_qty"]} '
               f'vs 가격 밴드 하한={fs["band_floor"]} (★분리 관찰·pack §3.4 "수량 UI 권위=상품레벨·가격구간과 역할 분리")')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-144-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
