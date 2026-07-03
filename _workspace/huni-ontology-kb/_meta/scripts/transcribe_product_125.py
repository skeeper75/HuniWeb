#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000125 캔버스패브릭포스터 (실사 area-matrix·D-9·pack-silsa·[HARD] LLM 손전사 금지).

실사(silsa)는 디지털/스티커와 가격 모델이 다르다:
  - ★면적매트릭스형 = 포스터사인 [siz_width × siz_height] 셀단가(코팅/출력/가공 포함 통가격).
    off-grid=한 단계 큰 규격 ceiling(앱 계산·DB는 룩업행). use_dims=[siz_width,siz_height,min_qty].
  - COMP_POSTER_CANVAS_FABRIC = [동형결합] 가격표 동일 4소재 통합(캔버스/레더/메쉬/타이벡) 완제품가.
  - ★비종이류라 판형(plate_size) 무의미 — 실사 대형 롤 출력(pack §3.8·T-7). 라이브 plate 행은 논리삭제(del_yn=Y).
  - 도수(print_option) 축 없음(대형 잉크젯 풀컬러·po=0). 봉제(PROC_000080)=가공 CPQ 옵션.

이 스크립트는 125의 정체·사이즈(이산+nonspec)·자재·공정·카테고리 + 가격공식/구성요소(use_dims·면적 셀 행수요약)
+ CPQ 옵션(가공/봉제) + 제약(nonspec 치수범위) + 판형 논리삭제 상태를 결정론 전사한다.
실사 첫 상품이라 공유 축 미신설분은 companion에 mint하고 needed_shared_nodes로 반환.

사용:  python3 transcribe_product_125.py            # stdout markdown 블록
       python3 transcribe_product_125.py --json     # cache/transcribed-125-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000125"
SCRIPT = "transcribe_product_125.py"
AREA_COMP = "COMP_POSTER_CANVAS_FABRIC"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    # 사이즈: junction 활성(del_yn=N)이나 master 삭제 여부 별도 표기(A1 SIZ_000293 매달림 검출)
    ps = [r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    pm = [r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    pp = [r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    po = [r for r in rd("t_prd_product_print_options.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    plt_all = [r for r in rd("t_prd_product_plate_sizes.csv") if r["prd_cd"] == PRD]
    pf = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fc = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] in {x["frm_cd"] for x in pf}]

    og = [r for r in rd("t_prd_product_option_groups.csv")
          if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    opts = [r for r in rd("t_prd_product_options.csv")
            if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    oitems = {r["opt_cd"]: r for r in rd("t_prd_product_option_items.csv")
              if r["prd_cd"] == PRD and r["del_yn"] != "Y"}
    con = [r for r in rd("t_prd_product_constraints.csv")
           if r["prd_cd"] == PRD and r["del_yn"] != "Y"]

    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    comps = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    pc = [r for r in rd("t_prd_product_categories.csv") if r["prd_cd"] == PRD]

    comp_cds = [r["comp_cd"] for r in fc]
    price_comps = [{"comp_cd": c, "comp_nm": comps.get(c, {}).get("comp_nm", "?"),
                    "prc_typ_cd": comps.get(c, {}).get("prc_typ_cd", "?"),
                    "use_dims": comps.get(c, {}).get("use_dims", "?"),
                    "comp_typ_cd": comps.get(c, {}).get("comp_typ_cd", "?"),
                    "note": comps.get(c, {}).get("note", "")} for c in comp_cds]

    # 면적 매트릭스 행수 요약(값 나열 아님·D-22 접기): AREA_COMP 셀 총수 + (가로×세로) 순서쌍 개수
    cp = rd("t_prc_component_prices.csv")
    area_rows = [r for r in cp if r["comp_cd"] == AREA_COMP]
    wh_pairs = {(r["siz_width"], r["siz_height"]) for r in area_rows}
    widths = sorted({r["siz_width"] for r in area_rows if r["siz_width"]}, key=lambda x: float(x or 0))
    heights = sorted({r["siz_height"] for r in area_rows if r["siz_height"]}, key=lambda x: float(x or 0))
    grid_summary = {"total_rows": len(area_rows), "distinct_wh_pairs": len(wh_pairs),
                    "distinct_widths": len(widths), "distinct_heights": len(heights),
                    "width_min": widths[0] if widths else "?", "width_max": widths[-1] if widths else "?",
                    "height_min": heights[0] if heights else "?", "height_max": heights[-1] if heights else "?"}

    grp_items = {}
    for o in opts:
        it = oitems.get(o["opt_cd"], {})
        grp_items.setdefault(o["opt_grp_cd"], []).append({
            "opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"], "dflt": o["dflt_yn"],
            "ref_dim_cd": it.get("ref_dim_cd", ""), "ref_key1": it.get("ref_key1", ""),
            "ref_key2": it.get("ref_key2", "")})

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "generated_by": SCRIPT, "area_comp": AREA_COMP},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm", "?"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd", ""),
                        "cat_lvl": cat.get(r["cat_cd"], {}).get("cat_lvl", "?"),
                        "main": r["main_cat_yn"], "disp": r["disp_seq"]} for r in pc],
        "sizes": [{"siz_cd": r["siz_cd"], "siz_nm": siz.get(r["siz_cd"], {}).get("siz_nm", "?"),
                   "master_del_yn": siz.get(r["siz_cd"], {}).get("del_yn", "?"),
                   "work": f'{_mm(siz.get(r["siz_cd"],{}).get("work_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("work_height"))}',
                   "cut": f'{_mm(siz.get(r["siz_cd"],{}).get("cut_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("cut_height"))}',
                   "dflt": r["dflt_yn"], "disp": r["disp_seq"]} for r in ps],
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm", "?"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd", "?"),
                       "upr_mat_cd": mat.get(r["mat_cd"], {}).get("upr_mat_cd", ""),
                       "dflt": r["dflt_yn"], "disp": r["disp_seq"], "usage": r["usage_cd"]} for r in pm],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm", "?"),
                       "upr_proc_cd": proc.get(r["proc_cd"], {}).get("upr_proc_cd", ""),
                       "mand": r["mand_proc_yn"], "disp": r["disp_seq"]} for r in pp],
        "print_options_count": len(po),
        "plate_all": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"] or "(빈값)",
                       "output_file_typ": r["output_file_typ"], "note": r["note"], "del_yn": r["del_yn"]}
                      for r in plt_all],
        "formula": [{"frm_cd": r["frm_cd"], "note": r["note"]} for r in pf],
        "formula_components": [{"frm_cd": r["frm_cd"], "comp_cd": r["comp_cd"],
                                "disp_seq": r["disp_seq"], "addtn": r["addtn_yn"]} for r in fc],
        "price_components": price_comps,
        "area_grid": grid_summary,
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                           "sel_typ_cd": r["sel_typ_cd"], "min_sel": r["min_sel_cnt"],
                           "max_sel": r["max_sel_cnt"], "mand": r["mand_yn"], "disp": r["disp_seq"],
                           "items": grp_items.get(r["opt_grp_cd"], [])} for r in og],
        "constraints": [{"rule_cd": r["rule_cd"], "rule_nm": r["rule_nm"], "rule_typ_cd": r["rule_typ_cd"],
                         "logic": r["logic"], "err_msg": r["err_msg"], "use_yn": r["use_yn"]} for r in con],
        "product": {"prd_nm": prod[PRD]["prd_nm"], "prd_typ_cd": prod[PRD]["prd_typ_cd"],
                    "nonspec_yn": prod[PRD]["nonspec_yn"],
                    "nonspec_w": f'{_mm(prod[PRD]["nonspec_width_min"])}~{_mm(prod[PRD]["nonspec_width_max"])}',
                    "nonspec_h": f'{_mm(prod[PRD]["nonspec_height_min"])}~{_mm(prod[PRD]["nonspec_height_max"])}',
                    "nonspec_w_incr": _mm(prod[PRD]["nonspec_width_incr"]),
                    "nonspec_h_incr": _mm(prod[PRD]["nonspec_height_incr"]),
                    "min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                    "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"],
                    "use_yn": prod[PRD]["use_yn"], "del_yn": prod[PRD]["del_yn"],
                    "file_upload_yn": prod[PRD]["file_upload_yn"], "editor_yn": prod[PRD]["editor_yn"]}
                   if PRD in prod else {},
    }


def md(d):
    o = []
    tb = lambda tbl: o.append(f"<!-- transcribed-by: _meta/scripts/{SCRIPT} from {SNAP_ID} {tbl} {PRD} @ {STAMP} -->")

    tb("t_prd_product_categories+t_cat_categories")
    o += ["| cat_cd | 분류명 | 상위 | lvl | main | disp |", "|---|---|---|---|---|---|"]
    for v in d["categories"]:
        o.append(f'| {v["cat_cd"]} | {v["cat_nm"]} | {v["upr_cat_cd"]} | {v["cat_lvl"]} | {v["main"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_sizes+t_siz_sizes (junction del_yn=N·★master_del_yn 별도 검출)")
    o += ["| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | master_del_yn |",
          "|---|---|---|---|---|---|---|"]
    for v in d["sizes"]:
        o.append(f'| {v["siz_cd"]} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["dflt"]} | {v["disp"]} | {v["master_del_yn"]} |')
    o.append("")

    tb("t_prd_product_materials+t_mat_materials (del_yn=N·MAT_TYPE.05=특수소재 교정됨)")
    o += ["| mat_cd | 자재명 | mat_typ | 상위 | dflt | disp | usage |", "|---|---|---|---|---|---|---|"]
    for v in d["materials"]:
        o.append(f'| {v["mat_cd"]} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"]} | {v["dflt"]} | {v["disp"]} | {v["usage"]} |')
    o.append("")

    tb("t_prd_product_processes+t_proc_processes (del_yn=N·봉제=가공 CPQ)")
    o += ["| proc_cd | 공정명 | 상위공정 | mand | disp |", "|---|---|---|---|---|"]
    for v in d["processes"]:
        o.append(f'| {v["proc_cd"]} | {v["proc_nm"]} | {v["upr_proc_cd"]} | {v["mand"]} | {v["disp"]} |')
    o.append(f"\n인쇄옵션(print_option) 활성 행수 = {d['print_options_count']} (실사=대형 잉크젯 풀컬러·도수 축 없음·정당)\n")

    tb("t_prd_product_plate_sizes (★전 행 del_yn=Y 논리삭제=비종이류 판형 무의미·pack §3.8·T-7)")
    o += ["| siz_cd | output_paper_typ_cd | output_file_typ | del_yn | note |", "|---|---|---|---|---|"]
    for v in d["plate_all"]:
        o.append(f'| {v["siz_cd"]} | {v["output_paper_typ_cd"]} | {v["output_file_typ"]} | {v["del_yn"]} | {v["note"]} |')
    o.append("")

    tb("t_prd_product_price_formulas+t_prc_formula_components")
    o += ["| frm_cd | comp_cd | disp_seq | addtn |", "|---|---|---|---|"]
    for v in d["formula_components"]:
        o.append(f'| {v["frm_cd"]} | {v["comp_cd"]} | {v["disp_seq"]} | {v["addtn"]} |')
    o.append("")

    tb("t_prc_price_components (use_dims·prc_typ·[동형결합] 4소재 통합)")
    o += ["| comp_cd | 이름 | prc_typ_cd | comp_typ_cd | use_dims |", "|---|---|---|---|---|"]
    for v in d["price_components"]:
        o.append(f'| {v["comp_cd"]} | {v["comp_nm"]} | {v["prc_typ_cd"]} | {v["comp_typ_cd"]} | `{v["use_dims"]}` |')
    o.append("")

    tb(f"t_prc_component_prices {AREA_COMP} 면적 셀 행수요약 (값 나열 아님·D-22 접기·[siz_width×siz_height])")
    g = d["area_grid"]
    o += ["| 지표 | 값 |", "|---|---|",
          f'| 총 단가행(셀) | {g["total_rows"]} |',
          f'| 고유 (가로,세로) 순서쌍 | {g["distinct_wh_pairs"]} |',
          f'| 고유 가로값 수 | {g["distinct_widths"]} (범위 {g["width_min"]}~{g["width_max"]}mm) |',
          f'| 고유 세로값 수 | {g["distinct_heights"]} (범위 {g["height_min"]}~{g["height_max"]}mm) |', ""]

    tb("t_prd_product_option_groups+options+option_items (가공=봉제 CPQ)")
    for gg in d["option_groups"]:
        o.append(f'**{gg["opt_grp_cd"]} {gg["opt_grp_nm"]}** (sel={gg["sel_typ_cd"]}·min/max={gg["min_sel"]}/{gg["max_sel"]}·mand={gg["mand"]}·disp={gg["disp"]})')
        o += ["| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | ref_key2 |", "|---|---|---|---|---|---|"]
        for it in gg["items"]:
            o.append(f'| {it["opt_cd"]} | {it["opt_nm"]} | {it["dflt"]} | {it["ref_dim_cd"]} | {it["ref_key1"]} | {it["ref_key2"]} |')
        o.append("")

    tb("t_prd_product_constraints (nonspec 치수범위·JSONLogic·폼빌더 shape)")
    o += ["| rule_cd | 규칙명 | rule_typ_cd | use_yn | err_msg |", "|---|---|---|---|---|"]
    for v in d["constraints"]:
        o.append(f'| {v["rule_cd"]} | {v["rule_nm"]} | {v["rule_typ_cd"]} | {v["use_yn"]} | {v["err_msg"]} |')
    o.append("")
    for v in d["constraints"]:
        o.append(f'- {v["rule_cd"]} logic: `{v["logic"]}`')
    o.append("")

    tb("t_prd_products (정체·nonspec·수량·상태)")
    p = d["product"]
    o += ["| 항목 | 값 |", "|---|---|",
          f'| prd_nm | {p.get("prd_nm")} |',
          f'| prd_typ_cd | {p.get("prd_typ_cd")} |',
          f'| nonspec_yn | {p.get("nonspec_yn")} |',
          f'| nonspec 가로범위(mm) | {p.get("nonspec_w")} (incr {p.get("nonspec_w_incr")}) |',
          f'| nonspec 세로범위(mm) | {p.get("nonspec_h")} (incr {p.get("nonspec_h_incr")}) |',
          f'| min/max/incr 수량 | {p.get("min_qty")}/{p.get("max_qty")}/{p.get("qty_incr")} ({p.get("unit")}) |',
          f'| use_yn / del_yn | {p.get("use_yn")} / {p.get("del_yn")} |',
          f'| file_upload / editor | {p.get("file_upload_yn")} / {p.get("editor_yn")} |']
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-125-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
