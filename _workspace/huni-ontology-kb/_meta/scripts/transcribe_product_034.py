#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 펄명함 PRD_000034.

기존 명함 전사 스크립트(transcribe_product_033.py)는 스탠다드명함 축만 다룬다.
펄명함(034)은 스타드림 펄 자재 4종(MAT_000352/358/359/360)·박색 8자식 공정(PROC_000037~044)·
박 소형 구성요소(COMP_FOIL_*_SMALL)·펄 완제품가 구성요소(COMP_NAMECARD_PEARL_S1/S2)·
공식 2종(PRF_NAMECARD_PEARL·_FOIL)을 쓰며, 자재 오염(면끈/키링고리/보드/핀버튼)이
2026-06-30 논리삭제(del_yn=Y)된 이력을 갖는다. 이 스크립트는 그 축을 전사한다
(기존 스크립트 무수정·별도 파일). 노드 파일의 치수·사양·배선·삭제이력 표는 이 스크립트
출력을 그대로 옮긴 것이며, 사람이 눈으로 읽어 손으로 옮기지 않는다.

가격 값(9000/10000/11000 등 단가)은 여기서 전사하지 않는다 — 값 계산=evaluate_price 권위(D-18),
KB는 use_dims 차원 선언·배선까지만. 골든은 날짜 라벨로만.

사용:  python3 transcribe_product_034.py            # stdout에 markdown/json 블록
       python3 transcribe_product_034.py --json     # cache/transcribed-034-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000034"

# 펄 자재(스타드림 계열·활성)
PEARL_MATS = ["MAT_000352", "MAT_000358", "MAT_000359", "MAT_000360"]
# 명함 사이즈(펄명함 실 바인딩 = SIZ_000008 단일)
NC_SIZES = ["SIZ_000008"]
# 박색 8자식 공정(박 부모 PROC_000033의 자식·027이 이미 노드화)
FOIL_PROCS = ["PROC_000037", "PROC_000038", "PROC_000039", "PROC_000040",
              "PROC_000041", "PROC_000042", "PROC_000043", "PROC_000044"]
# 펄/박 구성요소
PEARL_COMPS = ["COMP_NAMECARD_PEARL_S1", "COMP_NAMECARD_PEARL_S2",
               "COMP_FOIL_SETUP_SMALL", "COMP_FOIL_PROC_SMALL_STD",
               "COMP_FOIL_PROC_SMALL_SPECIAL"]
FORMULAS = ["PRF_NAMECARD_PEARL", "PRF_NAMECARD_PEARL_FOIL"]


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
    matmaster = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    procs = {r["proc_cd"]: r for r in rd("t_proc_processes.csv") if r["proc_cd"] in FOIL_PROCS}
    compmaster = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv") if r["comp_cd"] in PEARL_COMPS}
    fc = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] in FORMULAS]
    frm = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv") if r["frm_cd"] in FORMULAS}

    # 상품-자재 바인딩: 활성 vs 논리삭제(오염 정리 이력)
    pm_all = [r for r in rd("t_prd_product_materials.csv") if r.get("prd_cd") == PRD]
    mat_active = [{"mat_cd": r["mat_cd"], "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"],
                   "mat_nm": matmaster.get(r["mat_cd"], {}).get("mat_nm", "?")}
                  for r in pm_all if r.get("del_yn", "N") != "Y"]
    mat_removed = [{"mat_cd": r["mat_cd"], "del_dt": r.get("del_dt", ""),
                    "mat_nm": matmaster.get(r["mat_cd"], {}).get("mat_nm", "?"),
                    "mat_typ_cd": matmaster.get(r["mat_cd"], {}).get("mat_typ_cd", "?")}
                   for r in pm_all if r.get("del_yn", "N") == "Y"]

    def scope(name, keep=None):
        rows = [r for r in rd(name) if r.get("prd_cd") == PRD and r.get("del_yn", "N") != "Y"]
        if keep:
            rows = [{k: r.get(k) for k in keep} for r in rows]
        return rows

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_product_034.py"},
        "product": {k: prod.get(k) for k in
                    ("prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "del_yn")},
        "sizes": {s: {"siz_nm": sizes[s]["siz_nm"],
                      "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                      "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                      "note": sizes[s].get("note") or ""}
                  for s in NC_SIZES if s in sizes},
        "pearl_materials": {m: {"mat_nm": matmaster.get(m, {}).get("mat_nm", "?"),
                                "mat_typ_cd": matmaster.get(m, {}).get("mat_typ_cd", "?"),
                                "upr_mat_cd": matmaster.get(m, {}).get("upr_mat_cd", ""),
                                "width": _mm(matmaster.get(m, {}).get("width")),
                                "height": _mm(matmaster.get(m, {}).get("height")),
                                "weight": _mm(matmaster.get(m, {}).get("weight"))}
                            for m in PEARL_MATS},
        "foil_processes": {p: {"proc_nm": procs[p]["proc_nm"],
                               "upr_proc_cd": procs[p].get("upr_proc_cd") or "",
                               "note": procs[p].get("note") or ""}
                           for p in FOIL_PROCS if p in procs},
        "components": {c: {"comp_nm": compmaster[c]["comp_nm"],
                           "prc_typ_cd": compmaster[c]["prc_typ_cd"],
                           "use_dims": compmaster[c]["use_dims"]}
                       for c in PEARL_COMPS if c in compmaster},
        "formulas": {f: {"frm_nm": frm.get(f, {}).get("frm_nm", "?"),
                         "use_yn": frm.get(f, {}).get("use_yn", "?")}
                     for f in FORMULAS},
        "formula_components": [{"frm_cd": r["frm_cd"], "comp_cd": r["comp_cd"],
                                "disp_seq": r["disp_seq"], "addtn_yn": r["addtn_yn"]}
                               for r in fc],
        "material_active": mat_active,
        "material_removed": mat_removed,
        "bindings": {
            "sizes": scope("t_prd_product_sizes.csv", ("siz_cd", "dflt_yn")),
            "print_options": scope("t_prd_product_print_options.csv",
                                   ("opt_id", "print_side", "print_opt_cd")),
            "processes": scope("t_prd_product_processes.csv", ("proc_cd", "mand_proc_yn")),
            "plate_sizes": scope("t_prd_product_plate_sizes.csv", ("siz_cd", "output_paper_typ_cd")),
            "bundle_qtys": scope("t_prd_product_bundle_qtys.csv"),
            "addons": scope("t_prd_product_addons.csv"),
            "constraints": scope("t_prd_product_constraints.csv"),
            "option_groups": scope("t_prd_product_option_groups.csv"),
            "sets": [r for r in rd("t_prd_product_sets.csv")
                     if r.get("prd_cd") == PRD or r.get("sub_prd_cd") == PRD],
            "price_formulas": scope("t_prd_product_price_formulas.csv", ("frm_cd",)),
            "categories": scope("t_prd_product_categories.csv", ("cat_cd", "main_cat_yn")),
        },
    }


def md_size(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from {SNAP_ID} t_siz_sizes @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s, v in d["sizes"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} |')
    return "\n".join(out)


def md_pearl_mats(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from {SNAP_ID} t_mat_materials @ {STAMP} -->",
           "| mat_cd | 자재명 | mat_typ | upr | 규격(mm) | 평량(g) |", "|---|---|---|---|---|---|"]
    for m, v in d["pearl_materials"].items():
        out.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"]} | {v["width"]}x{v["height"]} | {v["weight"]} |')
    return "\n".join(out)


def md_removed(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from {SNAP_ID} t_prd_product_materials(del_yn=Y) @ {STAMP} -->",
           "| mat_cd | 자재명 | mat_typ | del_dt |", "|---|---|---|---|"]
    for r in d["material_removed"]:
        out.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["del_dt"]} |')
    return "\n".join(out)


def md_wiring(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from {SNAP_ID} t_prc_formula_components @ {STAMP} -->",
           "| frm_cd | disp_seq | comp_cd | addtn |", "|---|---|---|---|"]
    for r in sorted(d["formula_components"], key=lambda x: (x["frm_cd"], int(x["disp_seq"]))):
        out.append(f'| {r["frm_cd"]} | {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} |')
    return "\n".join(out)


def md_comps(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_034.py from {SNAP_ID} t_prc_price_components @ {STAMP} -->",
           "| comp_cd | comp_nm | prc_typ | use_dims |", "|---|---|---|---|"]
    for c, v in d["components"].items():
        out.append(f'| {c} | {v["comp_nm"]} | {v["prc_typ_cd"]} | {v["use_dims"]} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-034-260703.json")
        os.makedirs(os.path.dirname(p), exist_ok=True)
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print("### 펄명함 사이즈 (전사)\n"); print(md_size(d))
        print("\n### 스타드림 펄 자재 (전사)\n"); print(md_pearl_mats(d))
        print("\n### 자재 오염 논리삭제 이력 (전사)\n"); print(md_removed(d))
        print("\n### 펄/박 구성요소 use_dims (전사)\n"); print(md_comps(d))
        print("\n### 공식 배선 (전사)\n"); print(md_wiring(d))
        print("\n### PRD_000034 바인딩 요약 (전사)\n")
        print(json.dumps(d["bindings"], ensure_ascii=False, indent=2, sort_keys=True))
