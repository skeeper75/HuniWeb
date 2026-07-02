#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — PRD_000041 스탠다드 쿠폰/상품권.

기존 transcribe_snapshot.py(파일럿 요약·공식 배선·016 사이즈)로는 PRD_000041의
상품 레벨 연결(그 상품 고유 사이즈 013/014·자재 072/078/088/105·공정 031/032·
CPQ 옵션 052/053/054)을 전사할 수 없어 이 보강 스크립트를 새로 추가한다(기존 스크립트 무수정).

라이브 스냅샷(live-snapshot/latest/) t_* CSV에서 PRD_000041 축을 결정론으로 뽑아
① JSON 캐시 ② 노드 본문에 붙일 markdown 표(transcribed-by 마커 포함)로 출력한다.
노드 파일(product-041-coupon*.md)의 수치·연결은 이 스크립트가 전사한 것을 그대로 옮긴 것이며,
사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_product_041.py            # stdout에 markdown 블록
       python3 transcribe_product_041.py --json     # cache/transcribed-041-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000041"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def rows_for(name, key="prd_cd", val=PRD):
    return [r for r in rd(name) if r.get(key) == val and r.get("del_yn", "N") != "Y"]


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})

    psizes = rows_for("t_prd_product_sizes.csv")
    siz_master = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}

    pmats = rows_for("t_prd_product_materials.csv")
    mat_master = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}

    ppopt = rows_for("t_prd_product_print_options.csv")
    pproc = rows_for("t_prd_product_processes.csv")
    proc_master = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}

    pplate = rows_for("t_prd_product_plate_sizes.csv")
    pcat = rows_for("t_prd_product_categories.csv")
    paddon = rows_for("t_prd_product_addons.csv")
    pconstr = rows_for("t_prd_product_constraints.csv")
    pbundle = rows_for("t_prd_product_bundle_qtys.csv")
    pform = rows_for("t_prd_product_price_formulas.csv")

    pgrp = rows_for("t_prd_product_option_groups.csv")
    pitem = rows_for("t_prd_product_option_items.csv")

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_product_041.py"},
        "product": {k: prod.get(k) for k in
                    ("prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn")},
        "sizes": [{"siz_cd": r["siz_cd"], "dflt_yn": r["dflt_yn"], "disp_seq": r["disp_seq"],
                   "siz_nm": siz_master.get(r["siz_cd"], {}).get("siz_nm"),
                   "work": f'{_mm(siz_master.get(r["siz_cd"], {}).get("work_width"))}x'
                           f'{_mm(siz_master.get(r["siz_cd"], {}).get("work_height"))}',
                   "cut": f'{_mm(siz_master.get(r["siz_cd"], {}).get("cut_width"))}x'
                          f'{_mm(siz_master.get(r["siz_cd"], {}).get("cut_height"))}'}
                  for r in psizes],
        "materials": [{"mat_cd": r["mat_cd"], "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"],
                       "mat_nm": mat_master.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_master.get(r["mat_cd"], {}).get("mat_typ_cd")}
                      for r in pmats],
        "print_options": [{"opt_id": r["opt_id"], "print_side": r["print_side"],
                           "print_opt_cd": r["print_opt_cd"], "dflt_yn": r["dflt_yn"]}
                          for r in ppopt],
        "processes": [{"proc_cd": r["proc_cd"], "mand_proc_yn": r["mand_proc_yn"],
                       "disp_seq": r["disp_seq"],
                       "proc_nm": proc_master.get(r["proc_cd"], {}).get("proc_nm"),
                       "upr_proc_cd": proc_master.get(r["proc_cd"], {}).get("upr_proc_cd")}
                      for r in pproc],
        "plate_sizes": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                         "dflt_plt_yn": r["dflt_plt_yn"]} for r in pplate],
        "categories": [{"cat_cd": r["cat_cd"], "main_cat_yn": r["main_cat_yn"]} for r in pcat],
        "price_formulas": [{"frm_cd": r["frm_cd"], "apply_bgn_ymd": r.get("apply_bgn_ymd")} for r in pform],
        "counts": {"addons": len(paddon), "constraints": len(pconstr), "bundle_qtys": len(pbundle)},
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                           "sel_typ_cd": r["sel_typ_cd"], "min_sel_cnt": r["min_sel_cnt"],
                           "max_sel_cnt": r["max_sel_cnt"], "mand_yn": r["mand_yn"],
                           "disp_seq": r["disp_seq"]} for r in pgrp],
        "option_items": [{"opt_cd": r["opt_cd"], "ref_dim_cd": r["ref_dim_cd"],
                          "ref_key1": r["ref_key1"], "ref_key2": r["ref_key2"],
                          "item_seq": r["item_seq"]} for r in pitem],
    }


def _tb(tbl, cols):
    return [f"<!-- transcribed-by: _meta/scripts/transcribe_product_041.py from {SNAP_ID} {tbl} @ {STAMP} -->",
            "| " + " | ".join(cols) + " |", "|" + "|".join(["---"] * len(cols)) + "|"]


def md(d):
    out = ["### 상품 요약 (전사)\n"]
    p = d["product"]
    out += _tb("t_prd_products", ["prd_typ_cd", "min_qty", "max_qty", "qty_incr", "qty_unit", "file_upload", "editor"])
    out.append(f'| {p["prd_typ_cd"]} | {p["min_qty"]} | {p["max_qty"]} | {p["qty_incr"]} | {p["qty_unit_typ_cd"]} | {p["file_upload_yn"]} | {p["editor_yn"]} |')

    out.append("\n### 사이즈 (전사)\n")
    out += _tb("t_prd_product_sizes+t_siz_sizes", ["siz_cd", "라벨", "작업(mm)", "재단(mm)", "dflt"])
    for r in d["sizes"]:
        out.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["cut"]} | {r["dflt_yn"]} |')

    out.append("\n### 자재 (전사)\n")
    out += _tb("t_prd_product_materials+t_mat_materials", ["mat_cd", "자재명", "usage_cd", "dflt"])
    for r in d["materials"]:
        out.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    out.append("\n### 인쇄옵션·도수 (전사)\n")
    out += _tb("t_prd_product_print_options", ["opt_id", "print_side", "print_opt_cd", "dflt"])
    for r in d["print_options"]:
        out.append(f'| {r["opt_id"]} | {r["print_side"]} | {r["print_opt_cd"]} | {r["dflt_yn"]} |')

    out.append("\n### 공정 (전사)\n")
    out += _tb("t_prd_product_processes+t_proc_processes", ["proc_cd", "공정명", "mand", "disp_seq", "부모공정"])
    for r in d["processes"]:
        out.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["mand_proc_yn"]} | {r["disp_seq"]} | {r["upr_proc_cd"] or "-"} |')

    out.append("\n### 판형·카테고리·공식 (전사)\n")
    out += _tb("t_prd_product_plate_sizes/categories/price_formulas", ["축", "값"])
    for r in d["plate_sizes"]:
        out.append(f'| plate_size | {r["siz_cd"]} / {r["output_paper_typ_cd"]} (dflt {r["dflt_plt_yn"]}) |')
    for r in d["categories"]:
        out.append(f'| category | {r["cat_cd"]} (main {r["main_cat_yn"]}) |')
    for r in d["price_formulas"]:
        out.append(f'| price_formula | {r["frm_cd"]} (apply {r["apply_bgn_ymd"]}) |')
    c = d["counts"]
    out.append(f'| addons/constraints/bundle_qtys | {c["addons"]}/{c["constraints"]}/{c["bundle_qtys"]} (전부 0=없음) |')

    out.append("\n### CPQ 옵션그룹 (전사)\n")
    out += _tb("t_prd_product_option_groups", ["opt_grp_cd", "그룹명", "sel_typ", "min", "max", "mand", "disp"])
    for r in d["option_groups"]:
        out.append(f'| {r["opt_grp_cd"]} | {r["opt_grp_nm"]} | {r["sel_typ_cd"]} | {r["min_sel_cnt"]} | {r["max_sel_cnt"]} | {r["mand_yn"]} | {r["disp_seq"]} |')

    out.append("\n### CPQ 옵션 아이템 참조 (전사)\n")
    out += _tb("t_prd_product_option_items", ["opt_cd", "ref_dim_cd", "ref_key1", "ref_key2"])
    for r in d["option_items"]:
        out.append(f'| {r["opt_cd"]} | {r["ref_dim_cd"]} | {r["ref_key1"]} | {r["ref_key2"] or "-"} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-041-260703.json")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
