#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000030 지그재그엽서 (D-9·§4·[HARD] LLM 손전사 금지).

지그재그엽서(030)는 접지카드 구분의 6단접지(6크리즈) 완제품이다. 027(2단접지카드)과 달리
① 신규 공식 PRF_DGP_C_6CR(6단접지·3절 판형이관·07-01 신설)
② 신규 구성요소 COMP_FOLD_CARD_6CR(접지비 카드 6크리즈)
③ 3절 판형(OUTPUT_PAPER_TYPE.03 "기타"·SIZ_000475 330x660)
④ 6단오시접지 PROC_000073·6단미싱접지 PROC_000074(공유 축 미등재)
⑤ 지그재그 사이즈 2행(SIZ_000031 600x150·SIZ_000032 150x600)
을 쓰므로 이 보강 스크립트로 결정론 전사한다(기존 스크립트 수정 금지·새 파일 원칙).

★자재 MAT_000105(몽블랑 130g)는 07-01 del_yn=Y로 논리삭제되고 MAT_000110(몽블랑 130g 3절)로
교체됐으나, 종이 옵션(OPV-000056)은 여전히 삭제된 MAT_000105를 참조한다 — 이 불일치가 전사로
드러나도록 option_items는 raw ref_key를 그대로 전사하고, product_materials는 활성/삭제를 함께 표기한다.

사용:  python3 transcribe_product_030.py            # stdout markdown 블록
       python3 transcribe_product_030.py --json     # cache/transcribed-030-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000030"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    # product_* rows — active(del_yn!=Y)와 삭제 구분을 위해 del_yn 유지
    pm = [r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD]
    ps = [r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    pp = [r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    po = [r for r in rd("t_prd_product_print_options.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    plt = [r for r in rd("t_prd_product_plate_sizes.csv") if r["prd_cd"] == PRD]
    pf = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fc = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] in {x["frm_cd"] for x in pf}]
    og = [r for r in rd("t_prd_product_option_groups.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    opv = [r for r in rd("t_prd_product_options.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    oi = [r for r in rd("t_prd_product_option_items.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    ad = [r for r in rd("t_prd_product_addons.csv") if r["prd_cd"] == PRD]

    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    comp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    frm = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    tmpl = {r["tmpl_cd"]: r for r in rd("t_prd_templates.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    grpnm = {r["opt_grp_cd"]: r for r in og}
    optnm = {r["opt_cd"]: r for r in opv}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "generated_by": "transcribe_product_030.py"},
        "sizes": [{"siz_cd": r["siz_cd"], "siz_nm": siz.get(r["siz_cd"], {}).get("siz_nm", "?"),
                   "work": f'{_mm(siz.get(r["siz_cd"],{}).get("work_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("work_height"))}',
                   "cut": f'{_mm(siz.get(r["siz_cd"],{}).get("cut_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("cut_height"))}',
                   "dflt": r["dflt_yn"], "disp": r["disp_seq"],
                   "note": siz.get(r["siz_cd"], {}).get("note", "")} for r in ps],
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm", "?"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd", "?"),
                       "upr_mat_cd": mat.get(r["mat_cd"], {}).get("upr_mat_cd", ""),
                       "spec": f'{_mm(mat.get(r["mat_cd"],{}).get("width"))}x{_mm(mat.get(r["mat_cd"],{}).get("height"))}',
                       "weight": _mm(mat.get(r["mat_cd"], {}).get("weight")),
                       "usage": r["usage_cd"], "pm_del": r["del_yn"]} for r in pm],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm", "?"),
                       "upr_proc_cd": proc.get(r["proc_cd"], {}).get("upr_proc_cd", ""),
                       "mand": r["mand_proc_yn"], "disp": r["disp_seq"]} for r in pp],
        "print_options": [{"opt_id": r["opt_id"], "print_side": r["print_side"], "print_opt_cd": r["print_opt_cd"],
                           "front": f'{r["front_colrcnt_cd"]}({clr.get(r["front_colrcnt_cd"],{}).get("clr_nm","?")})',
                           "back": f'{r["back_colrcnt_cd"]}({clr.get(r["back_colrcnt_cd"],{}).get("clr_nm","?")})'}
                          for r in po],
        "plate": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                   "dflt_plt": r["dflt_plt_yn"], "del": r["del_yn"],
                   "siz_nm": siz.get(r["siz_cd"], {}).get("siz_nm", "?")} for r in plt],
        "formula": [{"frm_cd": r["frm_cd"], "frm_nm": frm.get(r["frm_cd"], {}).get("frm_nm", "?"),
                     "note": frm.get(r["frm_cd"], {}).get("note", "")} for r in pf],
        "formula_components": [{"frm_cd": r["frm_cd"], "comp_cd": r["comp_cd"],
                                "comp_nm": comp.get(r["comp_cd"], {}).get("comp_nm", "?"),
                                "prc_typ": comp.get(r["comp_cd"], {}).get("prc_typ_cd", "?"),
                                "use_dims": comp.get(r["comp_cd"], {}).get("use_dims", "?"),
                                "disp_seq": r["disp_seq"], "addtn": r["addtn_yn"]} for r in fc],
        "opt_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                        "sel_typ": r["sel_typ_cd"], "mand": r["mand_yn"], "disp": r["disp_seq"]} for r in og],
        "opt_items": [{"opt_cd": r["opt_cd"],
                       "opt_nm": optnm.get(r["opt_cd"], {}).get("opt_nm", "?"),
                       "opt_grp_cd": optnm.get(r["opt_cd"], {}).get("opt_grp_cd", "?"),
                       "opt_grp_nm": grpnm.get(optnm.get(r["opt_cd"], {}).get("opt_grp_cd", ""), {}).get("opt_grp_nm", "?"),
                       "ref_dim_cd": r["ref_dim_cd"], "ref_key1": r["ref_key1"], "ref_key2": r["ref_key2"]}
                      for r in oi],
        "addons": [{"tmpl_cd": r["tmpl_cd"], "disp": r["disp_seq"],
                    "tmpl_nm": tmpl.get(r["tmpl_cd"], {}).get("tmpl_nm", "?"),
                    "base_prd_cd": tmpl.get(r["tmpl_cd"], {}).get("base_prd_cd", "?")} for r in ad],
        "qty": {"min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"],
                "use_yn": prod[PRD]["use_yn"], "del_yn": prod[PRD]["del_yn"],
                "prd_typ_cd": prod[PRD]["prd_typ_cd"], "file_upload_yn": prod[PRD]["file_upload_yn"],
                "editor_yn": prod[PRD]["editor_yn"], "prd_nm": prod[PRD]["prd_nm"]} if PRD in prod else {},
    }


def md(d):
    o = []
    tb = lambda tbl: o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_030.py from {SNAP_ID} {tbl} PRD_000030 @ {STAMP} -->")

    tb("t_prd_products (수량·상태)")
    o += ["| prd_nm | min_qty | max_qty | qty_incr | 단위 | prd_typ | use_yn | del_yn | file_upload | editor |",
          "|---|---|---|---|---|---|---|---|---|---|"]
    q = d["qty"]
    o.append(f'| {q.get("prd_nm")} | {q.get("min_qty")} | {q.get("max_qty")} | {q.get("qty_incr")} | {q.get("unit")} | '
             f'{q.get("prd_typ_cd")} | {q.get("use_yn")} | {q.get("del_yn")} | {q.get("file_upload_yn")} | {q.get("editor_yn")} |')
    o.append("")

    tb("t_prd_product_sizes+t_siz_sizes")
    o += ["| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | note |", "|---|---|---|---|---|---|---|"]
    for v in d["sizes"]:
        o.append(f'| {v["siz_cd"]} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["dflt"]} | {v["disp"]} | {v["note"]} |')
    o.append("")

    tb("t_prd_product_materials+t_mat_materials (pm_del=상품자재 논리삭제여부)")
    o += ["| mat_cd | 자재명 | mat_typ | 상위 | 규격(mm) | 평량(g) | usage | pm_del |", "|---|---|---|---|---|---|---|---|"]
    for v in d["materials"]:
        o.append(f'| {v["mat_cd"]} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"]} | {v["spec"]} | {v["weight"]} | {v["usage"]} | {v["pm_del"]} |')
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

    tb("t_prd_product_plate_sizes (del=판형 논리삭제여부)")
    o += ["| siz_cd | 라벨 | output_paper_typ_cd | dflt_plt | del |", "|---|---|---|---|---|"]
    for v in d["plate"]:
        o.append(f'| {v["siz_cd"]} | {v["siz_nm"]} | {v["output_paper_typ_cd"]} | {v["dflt_plt"]} | {v["del"]} |')
    o.append("")

    tb("t_prd_product_price_formulas+t_prc_price_formulas")
    o += ["| frm_cd | frm_nm | note |", "|---|---|---|"]
    for v in d["formula"]:
        o.append(f'| {v["frm_cd"]} | {v["frm_nm"]} | {v["note"]} |')
    o.append("")

    tb("t_prc_formula_components+t_prc_price_components")
    o += ["| frm_cd | comp_cd | 구성요소명 | prc_typ | use_dims | disp_seq | addtn |", "|---|---|---|---|---|---|---|"]
    for v in d["formula_components"]:
        o.append(f'| {v["frm_cd"]} | {v["comp_cd"]} | {v["comp_nm"]} | {v["prc_typ"]} | {v["use_dims"]} | {v["disp_seq"]} | {v["addtn"]} |')
    o.append("")

    tb("t_prd_product_option_groups")
    o += ["| opt_grp_cd | 그룹명 | sel_typ | mand | disp |", "|---|---|---|---|---|"]
    for v in d["opt_groups"]:
        o.append(f'| {v["opt_grp_cd"]} | {v["opt_grp_nm"]} | {v["sel_typ"]} | {v["mand"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_options+t_prd_product_option_items")
    o += ["| opt_cd | 옵션값 | 소속그룹 | ref_dim_cd | ref_key1 | ref_key2 |", "|---|---|---|---|---|---|"]
    for v in d["opt_items"]:
        o.append(f'| {v["opt_cd"]} | {v["opt_nm"]} | {v["opt_grp_cd"]}({v["opt_grp_nm"]}) | {v["ref_dim_cd"]} | {v["ref_key1"]} | {v["ref_key2"]} |')
    o.append("")

    tb("t_prd_product_addons+t_prd_templates")
    o += ["| tmpl_cd | 템플릿명 | base_prd_cd | disp |", "|---|---|---|---|"]
    for v in d["addons"]:
        o.append(f'| {v["tmpl_cd"]} | {v["tmpl_nm"]} | {v["base_prd_cd"]} | {v["disp"]} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-030-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
