#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000067 타투스티커 (D-9·pack-sticker §4·[HARD] LLM 손전사 금지).

타투스티커 = 스티커 5분기 중 "전사(열전사)" 계열의 순수 인쇄물(커팅 공정 0행).
가격 모델 = 완제품가 "합가형" 룩업(PRF_STK_TATTOO→COMP_STK_TATTOO·PRICE_TYPE.02·3장 1세트당 합산가).
052(반칼·COMP_STK_PRINT·PRICE_TYPE.01)와 다른 공식/구성요소이므로 상품-local mint.

이 스크립트는 067의 카테고리·사이즈·자재(재키잉 167→594)·공정(0행)·도수·판형(기타 .03·재키잉)
+ 옵션 레이어(용지 그룹 1) + 가격구성요소(COMP_STK_TATTOO use_dims·행수 요약·구/신 자재 격자)
+ 연당가 대조(067 소재가 260702 substantive 연당가 변경 대상인지)를 결정론 전사한다.
기존 transcribe_product_052.py 등 미수정(새 파일 원칙).

사용:  python3 transcribe_sticker_tattoo.py            # stdout markdown 블록
       python3 transcribe_sticker_tattoo.py --json     # cache/transcribed-sticker-tattoo-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000067"
COMP = "COMP_STK_TATTOO"
SCRIPT = "transcribe_sticker_tattoo.py"

# 260702 diff의 substantive 연당가 변경 소재(pack §4-A) = 투명/홀로/크라프트/투명후지.
# 067 자재(타투전용지 167 / 타투스티커 594)는 이 목록 밖(diff에 "타투" 0행 실측).
SUBSTANTIVE_PRICE_MATS = {"MAT_000162", "MAT_000371", "MAT_000372",
                          "MAT_000163", "MAT_000590", "MAT_000164", "MAT_000591"}


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    pm_all = [r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD]
    pm = [r for r in pm_all if r["del_yn"] != "Y"]                 # 활성 자재
    pm_retired = [r for r in pm_all if r["del_yn"] == "Y"]         # 은퇴(재키잉 이력)
    ps = [r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    pp = [r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    po = [r for r in rd("t_prd_product_print_options.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    plt = [r for r in rd("t_prd_product_plate_sizes.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    pc = [r for r in rd("t_prd_product_categories.csv") if r["prd_cd"] == PRD]
    pf = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fc = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] in {x["frm_cd"] for x in pf}]

    og = [r for r in rd("t_prd_product_option_groups.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    opts = [r for r in rd("t_prd_product_options.csv") if r["prd_cd"] == PRD and r["del_yn"] != "Y"]
    oitems = {r["opt_cd"]: r for r in rd("t_prd_product_option_items.csv")
              if r["prd_cd"] == PRD and r["del_yn"] != "Y"}

    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    comps = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    comp_cds = [r["comp_cd"] for r in fc]
    price_comps = [{"comp_cd": c, "comp_nm": comps.get(c, {}).get("comp_nm", "?"),
                    "prc_typ_cd": comps.get(c, {}).get("prc_typ_cd", "?"),
                    "use_dims": comps.get(c, {}).get("use_dims", "?"),
                    "comp_typ_cd": comps.get(c, {}).get("comp_typ_cd", "?")}
                   for c in comp_cds]

    # COMP_STK_TATTOO 단가행 행수요약 — 값 나열 아님·행수 집계(D-22 접기). 구/신 자재 모두 표기(재키잉 문서화)
    active_mat_set = {r["mat_cd"] for r in pm}
    cp = rd("t_prc_component_prices.csv")
    grid = {}
    for r in cp:
        if r["comp_cd"] == COMP:
            grid[(r["siz_cd"], r["mat_cd"])] = grid.get((r["siz_cd"], r["mat_cd"]), 0) + 1
    grid_summary = [{"siz_cd": s, "mat_cd": m, "rows": n,
                     "role": "활성(옵션 노출)" if m in active_mat_set else "레거시(구 자재코드·룩업 미노출)"}
                    for (s, m), n in sorted(grid.items())]

    grp_items = {}
    for o in opts:
        it = oitems.get(o["opt_cd"], {})
        grp_items.setdefault(o["opt_grp_cd"], []).append({
            "opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"], "dflt": o["dflt_yn"],
            "ref_dim_cd": it.get("ref_dim_cd", ""), "ref_key1": it.get("ref_key1", ""),
            "ref_key2": it.get("ref_key2", ""),
        })

    liandan = [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm", "?"),
                "upr_mat_cd": mat.get(r["mat_cd"], {}).get("upr_mat_cd", ""),
                "substantive_price_change": r["mat_cd"] in SUBSTANTIVE_PRICE_MATS}
               for r in (pm + pm_retired)]

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "generated_by": SCRIPT},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm", "?"),
                        "cat_lvl": cat.get(r["cat_cd"], {}).get("cat_lvl", "?"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd", ""),
                        "main": r["main_cat_yn"]} for r in pc],
        "sizes": [{"siz_cd": r["siz_cd"], "siz_nm": siz.get(r["siz_cd"], {}).get("siz_nm", "?"),
                   "master_del_yn": siz.get(r["siz_cd"], {}).get("del_yn", "?"),
                   "work": f'{_mm(siz.get(r["siz_cd"],{}).get("work_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("work_height"))}',
                   "cut": f'{_mm(siz.get(r["siz_cd"],{}).get("cut_width"))}x{_mm(siz.get(r["siz_cd"],{}).get("cut_height"))}',
                   "dflt": r["dflt_yn"], "disp": r["disp_seq"]} for r in ps],
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm", "?"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd", "?"),
                       "upr_mat_cd": mat.get(r["mat_cd"], {}).get("upr_mat_cd", ""),
                       "weight": _mm(mat.get(r["mat_cd"], {}).get("weight")),
                       "junction_del_yn": r["del_yn"],
                       "dflt": r["dflt_yn"], "disp": r["disp_seq"], "usage": r["usage_cd"]}
                      for r in (pm + pm_retired)],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm", "?"),
                       "upr_proc_cd": proc.get(r["proc_cd"], {}).get("upr_proc_cd", ""),
                       "mand": r["mand_proc_yn"], "disp": r["disp_seq"]} for r in pp],
        "print_options": [{"opt_id": r["opt_id"], "print_side": r["print_side"], "print_opt_cd": r["print_opt_cd"],
                           "front": f'{r["front_colrcnt_cd"]}({clr.get(r["front_colrcnt_cd"],{}).get("clr_nm","?")})',
                           "back": f'{r["back_colrcnt_cd"]}({clr.get(r["back_colrcnt_cd"],{}).get("clr_nm","?")})'}
                          for r in po],
        "plate": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                   "dflt_plt": r["dflt_plt_yn"], "note": r["note"]} for r in plt],
        "formula": [{"frm_cd": r["frm_cd"], "note": r["note"]} for r in pf],
        "formula_components": [{"frm_cd": r["frm_cd"], "comp_cd": r["comp_cd"],
                                "disp_seq": r["disp_seq"], "addtn": r["addtn_yn"]} for r in fc],
        "price_components": price_comps,
        "price_grid_rows": grid_summary,
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                           "sel_typ_cd": r["sel_typ_cd"], "min_sel": r["min_sel_cnt"],
                           "max_sel": r["max_sel_cnt"], "mand": r["mand_yn"], "disp": r["disp_seq"],
                           "items": grp_items.get(r["opt_grp_cd"], [])} for r in og],
        "liandan_crosscheck": liandan,
        "qty": {"min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"],
                "use_yn": prod[PRD]["use_yn"], "del_yn": prod[PRD]["del_yn"],
                "prd_typ_cd": prod[PRD]["prd_typ_cd"], "file_upload_yn": prod[PRD]["file_upload_yn"],
                "editor_yn": prod[PRD]["editor_yn"], "prd_nm": prod[PRD]["prd_nm"]} if PRD in prod else {},
    }


def md(d):
    o = []
    tb = lambda tbl: o.append(f"<!-- transcribed-by: _meta/scripts/{SCRIPT} from {SNAP_ID} {tbl} {PRD} @ {STAMP} -->")

    tb("t_prd_product_categories+t_cat_categories")
    o += ["| cat_cd | 이름 | lvl | 상위 | main |", "|---|---|---|---|---|"]
    for v in d["categories"]:
        o.append(f'| {v["cat_cd"]} | {v["cat_nm"]} | {v["cat_lvl"]} | {v["upr_cat_cd"]} | {v["main"]} |')
    o.append("")

    tb("t_prd_product_sizes+t_siz_sizes (del_yn=N)")
    o += ["| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | disp | master_del_yn |",
          "|---|---|---|---|---|---|---|"]
    for v in d["sizes"]:
        o.append(f'| {v["siz_cd"]} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["dflt"]} | {v["disp"]} | {v["master_del_yn"]} |')
    o.append("")

    tb("t_prd_product_materials+t_mat_materials (활성+은퇴·재키잉 167->594 문서화)")
    o += ["| mat_cd | 자재명 | mat_typ | 상위 | 평량(g) | junction_del | dflt | disp | usage |",
          "|---|---|---|---|---|---|---|---|---|"]
    for v in d["materials"]:
        o.append(f'| {v["mat_cd"]} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"]} | {v["weight"]} | {v["junction_del_yn"]} | {v["dflt"]} | {v["disp"]} | {v["usage"]} |')
    o.append("")

    tb("t_prd_product_processes (067 = 0행·순수 인쇄물·커팅 없음)")
    o += ["| proc_cd | 공정명 | 상위공정 | mand | disp |", "|---|---|---|---|---|"]
    if not d["processes"]:
        o.append("| (없음) | 타투스티커=순수 인쇄물(전사 계열)·커팅/라미 공정 0행 | — | — | — |")
    for v in d["processes"]:
        o.append(f'| {v["proc_cd"]} | {v["proc_nm"]} | {v["upr_proc_cd"]} | {v["mand"]} | {v["disp"]} |')
    o.append("")

    tb("t_prd_product_print_options+t_clr_color_counts")
    o += ["| opt_id | print_side | print_opt_cd | front 도수 | back 도수 |", "|---|---|---|---|---|"]
    for v in d["print_options"]:
        o.append(f'| {v["opt_id"]} | {v["print_side"]} | {v["print_opt_cd"]} | {v["front"]} | {v["back"]} |')
    o.append("")

    tb("t_prd_product_plate_sizes (del_yn=N)")
    o += ["| siz_cd | output_paper_typ_cd | dflt_plt | note |", "|---|---|---|---|"]
    for v in d["plate"]:
        o.append(f'| {v["siz_cd"]} | {v["output_paper_typ_cd"]} | {v["dflt_plt"]} | {v["note"]} |')
    o.append("")

    tb("t_prd_product_price_formulas+t_prc_formula_components")
    o += ["| frm_cd | comp_cd | disp_seq | addtn |", "|---|---|---|---|"]
    for v in d["formula_components"]:
        o.append(f'| {v["frm_cd"]} | {v["comp_cd"]} | {v["disp_seq"]} | {v["addtn"]} |')
    o.append("")

    tb("t_prc_price_components (use_dims·prc_typ)")
    o += ["| comp_cd | 이름 | prc_typ_cd | comp_typ_cd | use_dims |", "|---|---|---|---|---|"]
    for v in d["price_components"]:
        o.append(f'| {v["comp_cd"]} | {v["comp_nm"]} | {v["prc_typ_cd"]} | {v["comp_typ_cd"]} | `{v["use_dims"]}` |')
    o.append("")

    tb("t_prc_component_prices COMP_STK_TATTOO 행수요약 (067 siz×mat·값 나열 아님·D-22 접기)")
    o += ["| siz_cd | mat_cd | 단가행수 | 역할 |", "|---|---|---|---|"]
    for v in d["price_grid_rows"]:
        o.append(f'| {v["siz_cd"]} | {v["mat_cd"]} | {v["rows"]} | {v["role"]} |')
    o.append("")

    tb("t_prd_product_option_groups+options+option_items")
    for g in d["option_groups"]:
        o.append(f'**{g["opt_grp_cd"]} {g["opt_grp_nm"]}** (sel={g["sel_typ_cd"]}·min/max={g["min_sel"]}/{g["max_sel"]}·mand={g["mand"]}·disp={g["disp"]})')
        o += ["| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | ref_key2 |", "|---|---|---|---|---|---|"]
        for it in g["items"]:
            o.append(f'| {it["opt_cd"]} | {it["opt_nm"]} | {it["dflt"]} | {it["ref_dim_cd"]} | {it["ref_key1"]} | {it["ref_key2"]} |')
        o.append("")

    tb("연당가 대조 (067 자재가 260702 substantive 연당가 변경 대상인가·pack §4-A)")
    o += ["| mat_cd | 자재명 | 상위 | substantive 연당가 변경? |", "|---|---|---|---|"]
    for v in d["liandan_crosscheck"]:
        o.append(f'| {v["mat_cd"]} | {v["mat_nm"]} | {v["upr_mat_cd"]} | {"YES" if v["substantive_price_change"] else "NO(diff에 타투 0행·무관)"} |')
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
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-sticker-tattoo-260703.json")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
