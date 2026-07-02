#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 모양명함 PRD_000035.

기존 transcribe_product_033.py(스탠다드명함)는 PRD_000033 전용 바인딩만 전사한다.
이 스크립트는 모양명함(PRD_000035)의 사이즈(SIZ_000008 단일)·자재(MAT_000109 몽블랑240g
단일)·인쇄옵션(단/양면)·가격공식/구성요소 배선(PRF_NAMECARD_SHAPE→S1/S2)·카테고리와,
비어 있는 축(공정 0·옵션그룹 0·추가상품 0·제약 0·수량구간 0)을 전사한다.
기존 스크립트 무수정·별도 파일. 노드 파일의 치수·배선 수치는 사람이 눈으로 읽어 손으로
옮기지 않고 이 스크립트가 전사한 것을 그대로 옮긴다.

사용:  python3 transcribe_product_035.py            # stdout에 markdown 블록
       python3 transcribe_product_035.py --json     # cache/transcribed-035-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000035"

# 모양명함 사이즈(단일)·판형 출력용지
NC_SIZES = ["SIZ_000008", "SIZ_000499"]
# 단일 본문 자재
NC_MATS = ["MAT_000109"]


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv") if r["siz_cd"] in NC_SIZES}
    mats = {r["mat_cd"]: r for r in rd("t_mat_materials.csv") if r["mat_cd"] in NC_MATS}

    def scope(name, keep=None):
        rows = [r for r in rd(name) if r.get("prd_cd") == PRD and r.get("del_yn", "N") != "Y"]
        if keep:
            rows = [{k: r.get(k) for k in keep} for r in rows]
        return rows

    # 가격 사슬(공식→구성요소→단가행 use_dims·값 미기록·연결/차원만)
    frm = scope("t_prd_product_price_formulas.csv", ("frm_cd", "note"))
    frm_cds = [r["frm_cd"] for r in frm]
    fcomps = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] in frm_cds]
    comp_cds = sorted({r["comp_cd"] for r in fcomps})
    pcomps = {r["comp_cd"]: {"comp_nm": r["comp_nm"], "comp_typ_cd": r["comp_typ_cd"],
                            "prc_typ_cd": r["prc_typ_cd"], "use_dims": r["use_dims"]}
              for r in rd("t_prc_price_components.csv") if r["comp_cd"] in comp_cds}
    # 단가행은 노드로 펼치지 않음(D-22) — 구성요소별 행수만 집계(차원 존재 신호)
    cp_rows = {}
    for r in rd("t_prc_component_prices.csv"):
        if r["comp_cd"] in comp_cds and r.get("del_yn", "N") != "Y":
            cp_rows[r["comp_cd"]] = cp_rows.get(r["comp_cd"], 0) + 1

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_product_035.py"},
        "product": {k: prod.get(k) for k in
                    ("prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn")},
        "sizes": {s: {"siz_nm": sizes[s]["siz_nm"],
                      "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                      "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                      "note": sizes[s].get("note") or ""}
                  for s in NC_SIZES if s in sizes},
        "materials": {m: {"mat_nm": mats[m]["mat_nm"], "mat_typ_cd": mats[m]["mat_typ_cd"],
                          "upr_mat_cd": mats[m].get("upr_mat_cd") or "",
                          "weight": _mm(mats[m].get("weight"))}
                      for m in NC_MATS if m in mats},
        "bindings": {
            "sizes": scope("t_prd_product_sizes.csv", ("siz_cd", "dflt_yn")),
            "materials": scope("t_prd_product_materials.csv", ("mat_cd", "usage_cd", "dflt_yn")),
            "print_options": scope("t_prd_product_print_options.csv",
                                   ("opt_id", "print_side", "print_opt_cd",
                                    "front_colrcnt_cd", "back_colrcnt_cd")),
            "processes": scope("t_prd_product_processes.csv", ("proc_cd", "mand_proc_yn")),
            "plate_sizes": scope("t_prd_product_plate_sizes.csv", ("siz_cd", "output_paper_typ_cd")),
            "bundle_qtys": scope("t_prd_product_bundle_qtys.csv"),
            "addons": scope("t_prd_product_addons.csv"),
            "constraints": scope("t_prd_product_constraints.csv"),
            "price_formulas": frm,
            "categories": scope("t_prd_product_categories.csv", ("cat_cd", "main_cat_yn")),
            "option_groups": scope("t_prd_product_option_groups.csv",
                                   ("opt_grp_cd", "opt_grp_nm", "sel_typ_cd", "mand_yn")),
            "option_items": scope("t_prd_product_option_items.csv",
                                  ("opt_cd", "ref_dim_cd", "ref_key1", "ref_key2")),
            "options": scope("t_prd_product_options.csv", ("opt_cd", "opt_grp_cd", "opt_nm")),
        },
        "price_chain": {
            "formula_components": [{"frm_cd": r["frm_cd"], "comp_cd": r["comp_cd"],
                                    "disp_seq": r["disp_seq"], "addtn_yn": r["addtn_yn"]}
                                   for r in fcomps],
            "components": pcomps,
            "component_price_rowcount": cp_rows,
        },
    }


def md_sizes(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_035.py from {SNAP_ID} t_siz_sizes @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s, v in d["sizes"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} |')
    return "\n".join(out)


def md_chain(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_035.py from {SNAP_ID} t_prc_formula_components/t_prc_price_components @ {STAMP} -->",
           "| comp_cd | 구성요소명 | prc_typ | use_dims(차원) | 단가행수 |", "|---|---|---|---|---|"]
    for r in d["price_chain"]["formula_components"]:
        c = d["price_chain"]["components"].get(r["comp_cd"], {})
        n = d["price_chain"]["component_price_rowcount"].get(r["comp_cd"], 0)
        out.append(f'| {r["comp_cd"]} | {c.get("comp_nm","")} | {c.get("prc_typ_cd","")} | {c.get("use_dims","")} | {n} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-035-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print("### 모양명함 사이즈 (전사)\n")
        print(md_sizes(d))
        print("\n### 가격 사슬 (전사·값 미기록·차원만)\n")
        print(md_chain(d))
        print("\n### PRD_000035 바인딩 요약 (전사)\n")
        print(json.dumps(d["bindings"], ensure_ascii=False, indent=2, sort_keys=True))
