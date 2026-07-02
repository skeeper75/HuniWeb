#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000023 모양엽서 (D-9·§4·[HARD] LLM 손전사 금지).

기존 transcribe_046.py는 라벨/택(046)만 전사한다. 모양엽서(023)는 완칼 die-cut 엽서로
사이즈(SIZ_000119 90x90 단일)·자재 3종(MAT_000107/109/113)·완칼커팅 공정(PROC_000123)이
046과 다르므로 이 보강 스크립트로 결정론 전사한다(기존 스크립트 수정 금지·새 파일 원칙).

사용:  python3 transcribe_product_023.py            # stdout markdown 블록(사이즈·자재·공정·도수·판형·수량·공식)
       python3 transcribe_product_023.py --json     # cache/transcribed-023-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000023"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    pm = [r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    ps = [r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    pp = [r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    po = [r for r in rd("t_prd_product_print_options.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    plt = [r for r in rd("t_prd_product_plate_sizes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    pf = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fc = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] in {x["frm_cd"] for x in pf}]

    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "generated_by": "transcribe_product_023.py"},
        "sizes": [{"siz_cd": r["siz_cd"], "siz_nm": siz.get(r["siz_cd"], {}).get("siz_nm", "?"),
                   "work": f'{_mm(siz.get(r["siz_cd"],{}).get("work_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("work_height"))}',
                   "cut": f'{_mm(siz.get(r["siz_cd"],{}).get("cut_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("cut_height"))}',
                   "dflt": r["dflt_yn"], "disp": r["disp_seq"]} for r in ps],
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm", "?"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd", "?"),
                       "upr_mat_cd": mat.get(r["mat_cd"], {}).get("upr_mat_cd", ""),
                       "spec": f'{_mm(mat.get(r["mat_cd"],{}).get("width"))}x{_mm(mat.get(r["mat_cd"],{}).get("height"))}',
                       "weight": _mm(mat.get(r["mat_cd"], {}).get("weight")),
                       "usage": r["usage_cd"]} for r in pm],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm", "?"),
                       "upr_proc_cd": proc.get(r["proc_cd"], {}).get("upr_proc_cd", ""),
                       "mand": r["mand_proc_yn"], "disp": r["disp_seq"]} for r in pp],
        "print_options": [{"opt_id": r["opt_id"], "print_side": r["print_side"], "print_opt_cd": r["print_opt_cd"],
                           "front": f'{r["front_colrcnt_cd"]}({clr.get(r["front_colrcnt_cd"],{}).get("clr_nm","?")})',
                           "back": f'{r["back_colrcnt_cd"]}({clr.get(r["back_colrcnt_cd"],{}).get("clr_nm","?")})'}
                          for r in po],
        "plate": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                   "dflt_plt": r["dflt_plt_yn"], "item_siz_cd": r["item_siz_cd"]} for r in plt],
        "formula": [{"frm_cd": r["frm_cd"], "note": r["note"]} for r in pf],
        "formula_components": [{"frm_cd": r["frm_cd"], "comp_cd": r["comp_cd"],
                                "disp_seq": r["disp_seq"], "addtn": r["addtn_yn"]} for r in fc],
        "qty": {"min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"],
                "use_yn": prod[PRD]["use_yn"], "del_yn": prod[PRD]["del_yn"],
                "prd_typ_cd": prod[PRD]["prd_typ_cd"], "file_upload_yn": prod[PRD]["file_upload_yn"],
                "editor_yn": prod[PRD]["editor_yn"]} if PRD in prod else {},
    }


def md(d):
    o = []
    tb = lambda tbl: o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_023.py from {SNAP_ID} {tbl} PRD_000023 @ {STAMP} -->")

    tb("t_prd_product_sizes+t_siz_sizes")
    o += ["| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp |", "|---|---|---|---|---|---|"]
    for v in d["sizes"]:
        o.append(f'| {v["siz_cd"]} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["dflt"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_materials+t_mat_materials")
    o += ["| mat_cd | 자재명 | mat_typ | 상위 | 규격(mm) | 평량(g) | usage |", "|---|---|---|---|---|---|---|"]
    for v in d["materials"]:
        o.append(f'| {v["mat_cd"]} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"]} | {v["spec"]} | {v["weight"]} | {v["usage"]} |')
    o.append("")

    tb("t_prd_product_processes+t_proc_processes")
    o += ["| proc_cd | 공정명 | 상위공정 | mand | disp |", "|---|---|---|---|---|"]
    for v in d["processes"]:
        o.append(f'| {v["proc_cd"]} | {v["proc_nm"]} | {v["upr_proc_cd"]} | {v["mand"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_print_options+t_clr_color_counts")
    o += ["| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |", "|---|---|---|---|---|"]
    for v in d["print_options"]:
        o.append(f'| {v["opt_id"]} | {v["print_side"]} | {v["print_opt_cd"]} | {v["front"]} | {v["back"]} |')
    o.append("")

    tb("t_prd_product_plate_sizes")
    o += ["| siz_cd | output_paper_typ_cd | dflt_plt | item_siz_cd |", "|---|---|---|---|"]
    for v in d["plate"]:
        o.append(f'| {v["siz_cd"]} | {v["output_paper_typ_cd"]} | {v["dflt_plt"]} | {v["item_siz_cd"]} |')
    o.append("")

    tb("t_prd_product_price_formulas+t_prc_formula_components")
    o += ["| frm_cd | comp_cd | disp_seq | addtn |", "|---|---|---|---|"]
    for v in d["formula_components"]:
        o.append(f'| {v["frm_cd"]} | {v["comp_cd"]} | {v["disp_seq"]} | {v["addtn"]} |')
    o.append("")

    tb("t_prd_products (수량·상태)")
    o += ["| min_qty | max_qty | qty_incr | 단위 | prd_typ | use_yn | del_yn | file_upload | editor |",
          "|---|---|---|---|---|---|---|---|---|"]
    q = d["qty"]
    o.append(f'| {q.get("min_qty")} | {q.get("max_qty")} | {q.get("qty_incr")} | {q.get("unit")} | '
             f'{q.get("prd_typ_cd")} | {q.get("use_yn")} | {q.get("del_yn")} | {q.get("file_upload_yn")} | {q.get("editor_yn")} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-023-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
