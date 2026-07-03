#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000131 프레임리스우드액자 (실사·★고정가형[siz_cd 룩업]·D-9·§4·[HARD] LLM 손전사 금지).

프레임리스우드액자(131)의 규격 사이즈(A3/A2)·라미네이팅 공정·수량규칙·
고정가 SHAPE(값 아님·차원·행수·siz_cd 셀만)를 결정론 전사한다.
★118 아트프린트포스터(면적매트릭스 [가로×세로])와 달리 131은 **고정가형 [규격(siz_cd)×수량]** 룩업이다
  (use_dims=[siz_cd,min_qty]) — 실사 2 가격모델 공존(pack §3.10)의 "고정가 15상품" 대표.
★자재 = t_prd_product_materials 0행(우드 소재 미등록·통가격 baked·pack §3.5 보드/우드 5상품 L1 빈값 AMBIGUOUS) → 전사 자재 없음.
★실사=비종이류(대형 롤/우드) → 판형(plate_size)은 파일사양 placeholder일 뿐 종이류 판형 아님(전사 제외·T-7).
★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원"까지만(D-18·값=evaluate_price).
  고정가는 SHAPE(siz_cd 셀 수·수량축 충전 여부·격자완전)만 확인한다.

사용:  python3 transcribe_product_131.py            # stdout markdown 블록
       python3 transcribe_product_131.py --json     # cache/transcribed-131-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000131"
SIZES_ACTIVE = ["SIZ_000174", "SIZ_000197"]            # A3/A2 (product_sizes del_yn=N)
PLATE_PLACEHOLDER = ["SIZ_000175", "SIZ_000303"]        # 파일사양 placeholder(JPG·비종이류·판형 아님)
PROCS = ["PROC_000014", "PROC_000015"]                  # 유광/무광 라미네이팅(product del_yn=N·mand N·CPQ 미노출)
FRM = "PRF_POSTER_FRAMELESS"
COMP = "COMP_POSTER_FRAMELESS_WOOD"                     # 고정가 완제품가 구성요소(siz_cd 룩업)


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
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    pcat = [r for r in rd("t_prd_product_categories.csv") if r["prd_cd"] == PRD]
    psz = {r["siz_cd"]: r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD}
    pproc = {r["proc_cd"]: r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD}
    pmat = [r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD]
    pfrm = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fcomp = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == FRM]
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv") if r["comp_cd"] == COMP}
    # 고정가 SHAPE — 값(unit_price) 미전사, siz_cd 셀 수·수량축 충전만
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP]
    siz_cells = sorted({r["siz_cd"] for r in cp if r.get("siz_cd")})
    qty_bands = sorted({r["min_qty"] for r in cp if r.get("min_qty")})
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_131.py"},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm", "?"),
                        "upr": cat.get(r["cat_cd"], {}).get("upr_cat_cd", ""),
                        "lvl": cat.get(r["cat_cd"], {}).get("cat_lvl", ""),
                        "main": r.get("main_cat_yn", "")}
                       for r in pcat],
        "sizes_active": {s: {"siz_nm": siz[s]["siz_nm"],
                             "work": f'{_num(siz[s]["work_width"])}x{_num(siz[s]["work_height"])}',
                             "master_del_yn": siz[s].get("del_yn", ""),
                             "junc_del_yn": psz.get(s, {}).get("del_yn", "")}
                         for s in SIZES_ACTIVE if s in siz},
        "materials_junction_rows": len(pmat),
        "processes": {p: {"proc_nm": proc[p]["proc_nm"], "upr_proc_cd": proc[p]["upr_proc_cd"],
                          "mand": pproc.get(p, {}).get("mand_proc_yn", ""),
                          "junc_del_yn": pproc.get(p, {}).get("del_yn", "")}
                      for p in PROCS if p in proc},
        "plate_placeholder": {s: {"siz_nm": siz.get(s, {}).get("siz_nm", "?")}
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
                      "use_dims": pcomp.get(COMP, {}).get("use_dims", "")},
        "fixed_shape": {"comp_cd": COMP, "row_count": len(cp),
                        "use_dims": ["siz_cd", "min_qty"],
                        "distinct_siz": len(siz_cells), "siz_cells": siz_cells,
                        "qty_bands": qty_bands,
                        "grid_full": len(cp) == len(siz_cells) * max(1, len(qty_bands)),
                        "qty_populated": len(qty_bands) > 1,
                        "size_price_match": sorted(SIZES_ACTIVE) == siz_cells},
    }


def md(d):
    out = []
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from {SNAP_ID} t_prd_product_categories+t_cat_categories PRD_000131 @ {STAMP} -->")
    out.append("| cat_cd | 분류명 | 상위 | lvl | main |")
    out.append("|---|---|---|---|---|")
    for c in d["categories"]:
        out.append(f'| {c["cat_cd"]} | {c["cat_nm"]} | {c["upr"] or "-"} | {c["lvl"]} | {c["main"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from {SNAP_ID} t_prd_product_sizes+t_siz_sizes PRD_000131 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 작업(work mm) | master_del_yn | junction_del_yn |")
    out.append("|---|---|---|---|---|")
    for s, v in d["sizes_active"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["master_del_yn"] or "N"} | {v["junc_del_yn"] or "N"} |')
    out.append("")
    out.append(f'자재(t_prd_product_materials) 활성 행수 = {d["materials_junction_rows"]} '
               f'(★우드 프레임 소재 미등록·완제품 통가격 baked·pack §3.5 보드/우드 5상품 L1 빈값 AMBIGUOUS·GAP)')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from {SNAP_ID} t_proc_processes+t_prd_product_processes PRD_000131 @ {STAMP} -->")
    out.append("| proc_cd | 공정명 | 상위공정 | mand | junction_del_yn |")
    out.append("|---|---|---|---|---|")
    for p, v in d["processes"].items():
        out.append(f'| {p} | {v["proc_nm"]} | {v["upr_proc_cd"] or "-"} | {v["mand"] or "N"} | {v["junc_del_yn"] or "N"} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from {SNAP_ID} t_prd_product_plate_sizes (★전 행 output_paper_typ 공란=파일사양 placeholder·비종이류 판형 무의미·pack §3.8·T-7) PRD_000131 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 용도 |")
    out.append("|---|---|---|")
    for s, v in d["plate_placeholder"].items():
        out.append(f'| {s} | {v["siz_nm"]} | JPG 파일사양(판형 아님) |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from {SNAP_ID} t_prd_products PRD_000131 @ {STAMP} -->")
    out.append("| 항목 | 값 |")
    out.append("|---|---|")
    q = d["qty"]
    for k, lab in [("prd_nm", "prd_nm"), ("prd_typ_cd", "prd_typ_cd"), ("nonspec_yn", "nonspec_yn(★N=사용자입력 없음)"),
                   ("min_qty", "min_qty"), ("max_qty", "max_qty"), ("qty_incr", "qty_incr"),
                   ("unit", "qty_unit"), ("use_yn", "use_yn"), ("del_yn", "del_yn"),
                   ("file_upload_yn", "file_upload"), ("editor_yn", "editor")]:
        out.append(f'| {lab} | {q.get(k)} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from {SNAP_ID} t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components PRD_000131 @ {STAMP} -->")
    out.append("| frm_cd | 상품 바인딩 | comp_cd(배선) | prc_typ_cd | comp_typ_cd | use_dims |")
    out.append("|---|---|---|---|---|---|")
    f, c = d["formula"], d["component"]
    wired = ",".join(w["comp_cd"] for w in f["comp_wired"]) or "-"
    out.append(f'| {f["frm_cd"]} | {f["bound"]} | {wired} | {c["prc_typ_cd"]} | {c["comp_typ_cd"]} | {c["use_dims"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_131.py from {SNAP_ID} t_prc_component_prices COMP_POSTER_FRAMELESS_WOOD (★고정가 SHAPE·값 미전사) @ {STAMP} -->")
    out.append("| comp_cd | 차원(use_dims) | 규격셀수 | siz 셀 | 수량밴드수 | 단가행수 | 격자완전 | 수량축충전 | 규격=가격셀 정합 |")
    out.append("|---|---|---|---|---|---|---|---|---|")
    fs = d["fixed_shape"]
    out.append(f'| {fs["comp_cd"]} | {"×".join(fs["use_dims"])} | {fs["distinct_siz"]} '
               f'| {",".join(fs["siz_cells"])} | {len(fs["qty_bands"])} | {fs["row_count"]} '
               f'| {fs["grid_full"]} | {fs["qty_populated"]} | {fs["size_price_match"]} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-131-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
