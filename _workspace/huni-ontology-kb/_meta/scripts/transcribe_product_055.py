#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000055 낱장 자유형 스티커 (D-9·§4·[HARD] LLM 손전사 금지).

스티커 파일럿(pack-sticker.md)의 첫 상품. 023(모양엽서·완칼 엽서) 스크립트를 계승하되
스티커 특유 축을 추가한다:
  - 완제품가 고정 룩업 공식(PRF_STK_FIXED → COMP_STK_PRINT, use_dims=[siz_cd,mat_cd,min_qty])
  - CPQ 옵션 레이어(종이·인쇄·커팅·조각수 4그룹 + option_items ref_dim 다형참조)
  - 카테고리(스티커/자유형스티커)
del_yn=Y(논리삭제) 행은 제외하고 "현재 활성" 상태만 전사한다(라이브 재키잉 복구 반영).

사용:  python3 transcribe_product_055.py            # stdout markdown 블록
       python3 transcribe_product_055.py --json     # cache/transcribed-055-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000055"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    active = lambda rows: [r for r in rows if r.get("del_yn") != "Y"]
    pm = active([r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD])
    ps = active([r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD])
    pp = active([r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD])
    po = active([r for r in rd("t_prd_product_print_options.csv") if r["prd_cd"] == PRD])
    plt = active([r for r in rd("t_prd_product_plate_sizes.csv") if r["prd_cd"] == PRD])
    pf = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fc = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] in {x["frm_cd"] for x in pf}]
    og = active([r for r in rd("t_prd_product_option_groups.csv") if r["prd_cd"] == PRD])
    ov = active([r for r in rd("t_prd_product_options.csv") if r["prd_cd"] == PRD])
    oi = active([r for r in rd("t_prd_product_option_items.csv") if r["prd_cd"] == PRD])
    pc = active([r for r in rd("t_prd_product_categories.csv") if r["prd_cd"] == PRD])

    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    comp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}

    # 완제품가 룩업 커버리지: 활성 사이즈×활성 자재의 COMP_STK_PRINT 단가행 수(값은 접기·D-22)
    cprices = rd("t_prc_component_prices.csv")
    act_siz = {r["siz_cd"] for r in ps}
    act_mat = {r["mat_cd"] for r in pm}
    retail = {}
    for r in cprices:
        if r["comp_cd"] == "COMP_STK_PRINT" and r["siz_cd"] in act_siz and r["mat_cd"] in act_mat:
            retail.setdefault((r["siz_cd"], r["mat_cd"]), 0)
            retail[(r["siz_cd"], r["mat_cd"])] += 1

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "generated_by": "transcribe_product_055.py"},
        "sizes": [{"siz_cd": r["siz_cd"], "siz_nm": siz.get(r["siz_cd"], {}).get("siz_nm", "?"),
                   "work": f'{_mm(siz.get(r["siz_cd"],{}).get("work_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("work_height"))}',
                   "cut": f'{_mm(siz.get(r["siz_cd"],{}).get("cut_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("cut_height"))}',
                   "dflt": r["dflt_yn"], "disp": r["disp_seq"]} for r in ps],
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm", "?"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd", "?"),
                       "upr_mat_cd": mat.get(r["mat_cd"], {}).get("upr_mat_cd", ""),
                       "spec": f'{_mm(mat.get(r["mat_cd"],{}).get("width"))}x{_mm(mat.get(r["mat_cd"],{}).get("height"))}',
                       "weight": _mm(mat.get(r["mat_cd"], {}).get("weight")),
                       "usage": r["usage_cd"], "dflt": r["dflt_yn"]} for r in pm],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm", "?"),
                       "upr_proc_cd": proc.get(r["proc_cd"], {}).get("upr_proc_cd", ""),
                       "mand": r["mand_proc_yn"], "disp": r["disp_seq"]} for r in pp],
        "print_options": [{"opt_id": r["opt_id"], "print_side": r["print_side"], "print_opt_cd": r["print_opt_cd"],
                           "front": f'{r["front_colrcnt_cd"]}({clr.get(r["front_colrcnt_cd"],{}).get("clr_nm","?")})',
                           "back": f'{r["back_colrcnt_cd"]}({clr.get(r["back_colrcnt_cd"],{}).get("clr_nm","?")})'}
                          for r in po],
        "plate": [{"siz_cd": r["siz_cd"], "siz_nm": siz.get(r["siz_cd"], {}).get("siz_nm", "?"),
                   "output_paper_typ_cd": r["output_paper_typ_cd"],
                   "dflt_plt": r["dflt_plt_yn"], "note": r["note"]} for r in plt],
        "formula": [{"frm_cd": r["frm_cd"], "note": r["note"]} for r in pf],
        "formula_components": [{"frm_cd": r["frm_cd"], "comp_cd": r["comp_cd"],
                                "disp_seq": r["disp_seq"], "addtn": r["addtn_yn"],
                                "use_dims": comp.get(r["comp_cd"], {}).get("use_dims", ""),
                                "prc_typ_cd": comp.get(r["comp_cd"], {}).get("prc_typ_cd", "")}
                               for r in fc],
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                           "sel_typ_cd": r["sel_typ_cd"], "min_sel": r["min_sel_cnt"],
                           "max_sel": r["max_sel_cnt"], "mand": r["mand_yn"], "disp": r["disp_seq"]}
                          for r in sorted(og, key=lambda x: int(x["disp_seq"]))],
        "options": [{"opt_cd": r["opt_cd"], "opt_grp_cd": r["opt_grp_cd"], "opt_nm": r["opt_nm"],
                     "dflt": r["dflt_yn"], "disp": r["disp_seq"]}
                    for r in sorted(ov, key=lambda x: (x["opt_grp_cd"], int(x["disp_seq"])))],
        "option_items": [{"opt_cd": r["opt_cd"], "ref_dim_cd": r["ref_dim_cd"],
                          "ref_key1": r["ref_key1"], "ref_key2": r["ref_key2"], "qty": r["qty"]}
                         for r in oi],
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm", "?"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd", ""),
                        "main": r["main_cat_yn"], "disp": r["disp_seq"]} for r in pc],
        "retail_coverage": [{"siz_cd": k[0], "mat_cd": k[1], "rows": v}
                            for k, v in sorted(retail.items())],
        "qty": {"min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"],
                "use_yn": prod[PRD]["use_yn"], "del_yn": prod[PRD]["del_yn"],
                "prd_typ_cd": prod[PRD]["prd_typ_cd"], "nonspec_yn": prod[PRD]["nonspec_yn"],
                "file_upload_yn": prod[PRD]["file_upload_yn"],
                "editor_yn": prod[PRD]["editor_yn"], "prd_nm": prod[PRD]["prd_nm"]} if PRD in prod else {},
    }


def md(d):
    o = []
    tb = lambda tbl: o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_055.py from {SNAP_ID} {tbl} PRD_000055 (del_yn!=Y 활성분) @ {STAMP} -->")

    tb("t_prd_products (정체·수량·상태)")
    o += ["| prd_nm | prd_typ | nonspec | min | max | incr | 단위 | use_yn | del_yn | file_upload | editor |",
          "|---|---|---|---|---|---|---|---|---|---|---|"]
    q = d["qty"]
    o.append(f'| {q.get("prd_nm")} | {q.get("prd_typ_cd")} | {q.get("nonspec_yn")} | {q.get("min_qty")} | '
             f'{q.get("max_qty")} | {q.get("qty_incr")} | {q.get("unit")} | {q.get("use_yn")} | {q.get("del_yn")} | '
             f'{q.get("file_upload_yn")} | {q.get("editor_yn")} |')
    o.append("")

    tb("t_prd_product_categories+t_cat_categories")
    o += ["| cat_cd | 분류명 | 상위 | main | disp |", "|---|---|---|---|---|"]
    for v in d["categories"]:
        o.append(f'| {v["cat_cd"]} | {v["cat_nm"]} | {v["upr_cat_cd"]} | {v["main"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_sizes+t_siz_sizes")
    o += ["| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp |", "|---|---|---|---|---|---|"]
    for v in d["sizes"]:
        o.append(f'| {v["siz_cd"]} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["dflt"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_materials+t_mat_materials")
    o += ["| mat_cd | 자재명 | mat_typ | 상위 | 규격(mm) | 평량(g) | usage | dflt |", "|---|---|---|---|---|---|---|---|"]
    for v in d["materials"]:
        o.append(f'| {v["mat_cd"]} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"]} | {v["spec"]} | {v["weight"]} | {v["usage"]} | {v["dflt"]} |')
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
    o += ["| siz_cd | 라벨 | output_paper_typ_cd | dflt_plt | note |", "|---|---|---|---|---|"]
    for v in d["plate"]:
        o.append(f'| {v["siz_cd"]} | {v["siz_nm"]} | {v["output_paper_typ_cd"]} | {v["dflt_plt"]} | {v["note"]} |')
    o.append("")

    tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components(use_dims)")
    o += ["| frm_cd | comp_cd | disp_seq | addtn | prc_typ_cd | use_dims |", "|---|---|---|---|---|---|"]
    for v in d["formula_components"]:
        o.append(f'| {v["frm_cd"]} | {v["comp_cd"]} | {v["disp_seq"]} | {v["addtn"]} | {v["prc_typ_cd"]} | {v["use_dims"]} |')
    o.append("")

    tb("t_prc_component_prices (COMP_STK_PRINT 완제품가 룩업 커버리지·활성 사이즈×자재 행수·값 접기 D-22)")
    o += ["| siz_cd | mat_cd | 단가행수 |", "|---|---|---|"]
    for v in d["retail_coverage"]:
        o.append(f'| {v["siz_cd"]} | {v["mat_cd"]} | {v["rows"]} |')
    o.append("")

    tb("t_prd_product_option_groups")
    o += ["| opt_grp_cd | 그룹명 | sel_typ | min_sel | max_sel | mand | disp |", "|---|---|---|---|---|---|---|"]
    for v in d["option_groups"]:
        o.append(f'| {v["opt_grp_cd"]} | {v["opt_grp_nm"]} | {v["sel_typ_cd"]} | {v["min_sel"]} | {v["max_sel"]} | {v["mand"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_options (그룹별 선택값)")
    o += ["| opt_cd | opt_grp_cd | 선택값 | dflt | disp |", "|---|---|---|---|---|"]
    for v in d["options"]:
        o.append(f'| {v["opt_cd"]} | {v["opt_grp_cd"]} | {v["opt_nm"]} | {v["dflt"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_option_items (다형참조 ref_dim_cd)")
    o += ["| opt_cd | ref_dim_cd | ref_key1 | ref_key2 | qty |", "|---|---|---|---|---|"]
    for v in d["option_items"]:
        o.append(f'| {v["opt_cd"]} | {v["ref_dim_cd"]} | {v["ref_key1"]} | {v["ref_key2"]} | {v["qty"]} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-055-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
