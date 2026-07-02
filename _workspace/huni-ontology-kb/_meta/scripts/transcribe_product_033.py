#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 스탠다드명함 PRD_000033.

기존 transcribe_snapshot.py(엽서 016 파일럿 축)는 명함 전용 사이즈(SIZ_000008/133)·
명함 후가공 공정(PROC_000027/028/031/032)·CPQ 옵션그룹(OPT_000048~051)을 전사하지 않는다.
이 스크립트는 그 결손 축을 보강한다(기존 스크립트 무수정·별도 파일). 노드 파일의 명함
사이즈 치수·공정명·옵션그룹 배선은 이 스크립트가 전사한 것을 그대로 옮긴 것이며, 사람이
눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_product_033.py            # stdout에 markdown 블록
       python3 transcribe_product_033.py --json     # cache/transcribed-033-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000033"

# 명함 전용 사이즈(엽서 016 축에 없음) — 판걸이수는 사이즈 컬럼 아님(파생·fn_calc_pansu)
NC_SIZES = ["SIZ_000008", "SIZ_000133"]
# 명함 후가공 공정(엽서 축에 없는 자식 공정)
NC_PROCS = ["PROC_000027", "PROC_000028", "PROC_000031", "PROC_000032"]


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
    procs = {r["proc_cd"]: r for r in rd("t_proc_processes.csv") if r["proc_cd"] in NC_PROCS}

    def scope(name, keep=None):
        rows = [r for r in rd(name) if r.get("prd_cd") == PRD and r.get("del_yn", "N") != "Y"]
        if keep:
            rows = [{k: r.get(k) for k in keep} for r in rows]
        return rows

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_product_033.py"},
        "product": {k: prod.get(k) for k in
                    ("prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "del_yn")},
        "sizes": {s: {"siz_nm": sizes[s]["siz_nm"],
                      "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                      "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                      "note": sizes[s].get("note") or ""}
                  for s in NC_SIZES if s in sizes},
        "processes": {p: {"proc_nm": procs[p]["proc_nm"], "upr_proc_cd": procs[p].get("upr_proc_cd") or ""}
                      for p in NC_PROCS if p in procs},
        "bindings": {
            "sizes": scope("t_prd_product_sizes.csv", ("siz_cd", "dflt_yn")),
            "materials": scope("t_prd_product_materials.csv", ("mat_cd", "usage_cd", "dflt_yn")),
            "print_options": scope("t_prd_product_print_options.csv",
                                   ("opt_id", "print_side", "print_opt_cd")),
            "processes": scope("t_prd_product_processes.csv", ("proc_cd", "mand_proc_yn")),
            "plate_sizes": scope("t_prd_product_plate_sizes.csv", ("siz_cd", "output_paper_typ_cd")),
            "bundle_qtys": scope("t_prd_product_bundle_qtys.csv"),
            "addons": scope("t_prd_product_addons.csv"),
            "constraints": scope("t_prd_product_constraints.csv"),
            "price_formulas": scope("t_prd_product_price_formulas.csv", ("frm_cd",)),
            "categories": scope("t_prd_product_categories.csv", ("cat_cd", "main_cat_yn")),
            "option_groups": scope("t_prd_product_option_groups.csv",
                                   ("opt_grp_cd", "opt_grp_nm", "sel_typ_cd", "min_sel_cnt",
                                    "max_sel_cnt", "mand_yn", "disp_seq")),
            "option_items": scope("t_prd_product_option_items.csv",
                                  ("opt_cd", "ref_dim_cd", "ref_key1", "ref_key2")),
            "options": scope("t_prd_product_options.csv", ("opt_cd", "opt_grp_cd", "opt_nm")),
        },
    }


def md_sizes(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_033.py from {SNAP_ID} t_siz_sizes @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s, v in d["sizes"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} |')
    return "\n".join(out)


def md_procs(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_033.py from {SNAP_ID} t_proc_processes @ {STAMP} -->",
           "| proc_cd | 공정명 | 상위공정(upr) |", "|---|---|---|"]
    for p, v in d["processes"].items():
        out.append(f'| {p} | {v["proc_nm"]} | {v["upr_proc_cd"]} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-033-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print("### 명함 전용 사이즈 (전사)\n")
        print(md_sizes(d))
        print("\n### 명함 후가공 공정 (전사)\n")
        print(md_procs(d))
        print("\n### PRD_000033 바인딩 요약 (전사)\n")
        print(json.dumps(d["bindings"], ensure_ascii=False, indent=2, sort_keys=True))
