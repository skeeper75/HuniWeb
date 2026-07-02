#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — PRD_000042 프리미엄 쿠폰/상품권.

041(스탠다드 쿠폰/상품권)의 형제이나 **박(FOIL) 변형**이 추가된 상품이다:
  - 8 박색 공정(PROC_000037~044·공유 박 PROC_000033 자식·product-027-nodes.md mint 재사용)
  - 박칼라 CPQ 옵션그룹(OPT_000058·박없음 센티넬 + 8박)
  - 2번째 가격공식 바인딩 PRF_DGP_A_FOIL(apply 2026-07-01·박 분기)
  - 프리미엄 종이 8종(041 basic 4종과 다름)
transcribe_product_041.py로는 042의 상품 레벨 연결을 전사할 수 없어 이 보강 스크립트를 새로
추가한다(기존 041 스크립트 무수정·D-9 재현성).

★자재 오염 노출: 042 종이 옵션 4종(스타드림 실버/골드/다이아/로츠쿼츠 240g)이 라이브
t_prd_product_materials에서 굿즈 mat_cd(MAT_000128 면끈·129 아크릴키링고리·240 보드스탠딩·
241 핀버튼)를 가리킨다. 034 펄명함이 2026-06-30 정리(del_yn=Y·정답 MAT_000352/358/359/360 채택)
했으나 042에는 잔존. 이 스크립트는 자재 마스터명(mat_nm)+타입(mat_typ_cd)을 옵션 라벨(opt_nm)과
나란히 전사해 표시↔실제 불일치를 결정론으로 드러낸다(눈 대조 아님).

사용:  python3 transcribe_product_042.py            # stdout에 markdown 블록
       python3 transcribe_product_042.py --json     # cache/transcribed-042-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000042"

# 034가 2026-06-30 채택한 정답 스타드림 mat_cd(굿즈 오염 교정 대상 매핑) — 근거=product-034 노드+마스터명 조인
STARDREAM_FIX = {  # 042 오염 mat_cd -> (042 옵션의도, 정답 mat_cd)
    "MAT_000128": ("스타드림(실버) 240g", "MAT_000358"),
    "MAT_000129": ("스타드림(골드) 240g", "MAT_000359"),
    "MAT_000240": ("스타드림(다이아) 240g", "MAT_000352"),
    "MAT_000241": ("스타드림(로츠쿼츠) 240g", "MAT_000360"),
}


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
    popts = rows_for("t_prd_product_options.csv")
    opt_nm = {r["opt_cd"]: r["opt_nm"] for r in popts}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_product_042.py"},
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
                       "mat_typ_cd": mat_master.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "opt_intended": STARDREAM_FIX.get(r["mat_cd"], (None, None))[0],
                       "correct_matcd": STARDREAM_FIX.get(r["mat_cd"], (None, None))[1],
                       "contaminated": r["mat_cd"] in STARDREAM_FIX}
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
        "categories": [{"cat_cd": r["cat_cd"], "main_cat_yn": r["main_cat_yn"],
                        "disp_seq": r["disp_seq"]} for r in pcat],
        "price_formulas": [{"frm_cd": r["frm_cd"], "apply_bgn_ymd": r.get("apply_bgn_ymd"),
                            "note": r.get("note")} for r in pform],
        "counts": {"addons": len(paddon), "constraints": len(pconstr), "bundle_qtys": len(pbundle)},
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                           "sel_typ_cd": r["sel_typ_cd"], "min_sel_cnt": r["min_sel_cnt"],
                           "max_sel_cnt": r["max_sel_cnt"], "mand_yn": r["mand_yn"],
                           "disp_seq": r["disp_seq"]} for r in pgrp],
        "option_items": [{"opt_cd": r["opt_cd"], "ref_dim_cd": r["ref_dim_cd"],
                          "ref_key1": r["ref_key1"], "ref_key2": r["ref_key2"],
                          "item_seq": r["item_seq"], "opt_nm": opt_nm.get(r["opt_cd"])}
                         for r in pitem],
    }


def _tb(tbl, cols):
    return [f"<!-- transcribed-by: _meta/scripts/transcribe_product_042.py from {SNAP_ID} {tbl} @ {STAMP} -->",
            "| " + " | ".join(cols) + " |", "|" + "|".join(["---"] * len(cols)) + "|"]


def md(d):
    out = ["### 상품 요약 (전사)\n"]
    p = d["product"]
    out += _tb("t_prd_products", ["prd_typ_cd", "min_qty", "max_qty", "qty_incr", "qty_unit", "file_upload", "editor", "use_yn"])
    out.append(f'| {p["prd_typ_cd"]} | {p["min_qty"]} | {p["max_qty"]} | {p["qty_incr"]} | {p["qty_unit_typ_cd"]} | {p["file_upload_yn"]} | {p["editor_yn"]} | {p["use_yn"]} |')

    out.append("\n### 사이즈 (전사)\n")
    out += _tb("t_prd_product_sizes+t_siz_sizes", ["siz_cd", "라벨", "작업(mm)", "재단(mm)", "dflt"])
    for r in d["sizes"]:
        out.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["cut"]} | {r["dflt_yn"]} |')

    out.append("\n### 자재 (전사·★오염 노출: 마스터명 vs 옵션의도)\n")
    out += _tb("t_prd_product_materials+t_mat_materials+t_prd_product_options",
               ["mat_cd", "마스터명(현재값)", "mat_typ", "042 옵션의도", "정답 mat_cd", "usage", "dflt"])
    for r in d["materials"]:
        intended = r["opt_intended"] or "-"
        correct = r["correct_matcd"] or "-"
        flag = " 🔴" if r["contaminated"] else ""
        out.append(f'| {r["mat_cd"]}{flag} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {intended} | {correct} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    out.append("\n### 인쇄옵션·도수 (전사)\n")
    out += _tb("t_prd_product_print_options", ["opt_id", "print_side", "print_opt_cd", "dflt"])
    for r in d["print_options"]:
        out.append(f'| {r["opt_id"]} | {r["print_side"]} | {r["print_opt_cd"]} | {r["dflt_yn"]} |')

    out.append("\n### 공정 (전사·박색 8자식 포함)\n")
    out += _tb("t_prd_product_processes+t_proc_processes", ["proc_cd", "공정명", "mand", "disp_seq", "부모공정"])
    for r in d["processes"]:
        out.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["mand_proc_yn"]} | {r["disp_seq"]} | {r["upr_proc_cd"] or "-"} |')

    out.append("\n### 판형·카테고리·공식 (전사)\n")
    out += _tb("t_prd_product_plate_sizes/categories/price_formulas", ["축", "값"])
    for r in d["plate_sizes"]:
        out.append(f'| plate_size | {r["siz_cd"]} / {r["output_paper_typ_cd"]} (dflt {r["dflt_plt_yn"]}) |')
    for r in d["categories"]:
        out.append(f'| category | {r["cat_cd"]} (main {r["main_cat_yn"]}·disp {r["disp_seq"]}) |')
    for r in d["price_formulas"]:
        out.append(f'| price_formula | {r["frm_cd"]} (apply {r["apply_bgn_ymd"]}) |')
    c = d["counts"]
    out.append(f'| addons/constraints/bundle_qtys | {c["addons"]}/{c["constraints"]}/{c["bundle_qtys"]} (전부 0=없음) |')

    out.append("\n### CPQ 옵션그룹 (전사)\n")
    out += _tb("t_prd_product_option_groups", ["opt_grp_cd", "그룹명", "sel_typ", "min", "max", "mand", "disp"])
    for r in d["option_groups"]:
        out.append(f'| {r["opt_grp_cd"]} | {r["opt_grp_nm"]} | {r["sel_typ_cd"]} | {r["min_sel_cnt"]} | {r["max_sel_cnt"]} | {r["mand_yn"]} | {r["disp_seq"]} |')

    out.append("\n### CPQ 옵션 아이템 참조 (전사)\n")
    out += _tb("t_prd_product_option_items+options", ["opt_cd", "라벨", "ref_dim_cd", "ref_key1", "ref_key2"])
    for r in d["option_items"]:
        out.append(f'| {r["opt_cd"]} | {r["opt_nm"] or "-"} | {r["ref_dim_cd"]} | {r["ref_key1"]} | {r["ref_key2"] or "-"} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-042-260703.json")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
