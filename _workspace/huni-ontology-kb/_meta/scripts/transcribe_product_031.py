#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 프리미엄명함 PRD_000031.

명함 형제(032 코팅·033 스탠다드)와 동형 축이나, PRD_000031 고유 바인딩(사이즈·자재·
도수·공정·판형·수량·옵션그룹·공식)을 라이브 스냅샷에서 결정론적으로 전사한다. 노드 파일의
치수·공정명·옵션그룹 배선·수량 스칼라는 이 스크립트가 전사한 값을 그대로 옮긴 것이며,
사람이 눈으로 읽어 손으로 옮기지 않는다(기존 transcribe_product_033.py 무수정·별도 파일).

사용:  python3 transcribe_product_031.py            # stdout에 markdown 블록
       python3 transcribe_product_031.py --json     # cache/transcribed-031-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000031"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def scope(name, keep=None):
    rows = [r for r in rd(name) if r.get("prd_cd") == PRD and r.get("del_yn", "N") != "Y"]
    if keep:
        rows = [{k: r.get(k) for k in keep} for r in rows]
    return rows


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    b = {
        "sizes": scope("t_prd_product_sizes.csv", ("siz_cd", "dflt_yn")),
        "materials": scope("t_prd_product_materials.csv", ("mat_cd", "usage_cd", "dflt_yn")),
        "print_options": scope("t_prd_product_print_options.csv",
                               ("opt_id", "print_side", "print_opt_cd", "front_colrcnt_cd", "back_colrcnt_cd")),
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
    }
    # 참조 마스터(치수·공정명) — 바인딩에 등장한 코드만
    siz_ids = [r["siz_cd"] for r in b["sizes"]]
    proc_ids = [r["proc_cd"] for r in b["processes"]]
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv") if r["siz_cd"] in siz_ids}
    procs = {r["proc_cd"]: r for r in rd("t_proc_processes.csv") if r["proc_cd"] in proc_ids}
    mats_master = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")
                   if r["mat_cd"] in [m["mat_cd"] for m in b["materials"]]}
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_product_031.py"},
        "product": {k: prod.get(k) for k in
                    ("prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "del_yn")},
        "size_master": {s: {"siz_nm": sizes[s]["siz_nm"],
                            "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                            "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                            "note": sizes[s].get("note") or ""}
                        for s in siz_ids if s in sizes},
        "proc_master": {p: {"proc_nm": procs[p]["proc_nm"], "upr_proc_cd": procs[p].get("upr_proc_cd") or ""}
                        for p in proc_ids if p in procs},
        "mat_master": {m: {"mat_nm": mats_master[m].get("mat_nm"),
                           "mat_typ_cd": mats_master[m].get("mat_typ_cd"),
                           "upr_mat_cd": mats_master[m].get("upr_mat_cd") or "",
                           "width": mats_master[m].get("width") or "",
                           "height": mats_master[m].get("height") or "",
                           "weight": mats_master[m].get("weight") or ""}
                       for m in mats_master},
        "bindings": b,
    }


def md_sizes(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_031.py from {SNAP_ID} t_siz_sizes @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s, v in d["size_master"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} |')
    return "\n".join(out)


def md_procs(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_031.py from {SNAP_ID} t_proc_processes @ {STAMP} -->",
           "| proc_cd | 공정명 | 상위공정(upr) |", "|---|---|---|"]
    for p, v in d["proc_master"].items():
        out.append(f'| {p} | {v["proc_nm"]} | {v["upr_proc_cd"]} |')
    return "\n".join(out)


def md_qty(d):
    p = d["product"]
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_031.py from {SNAP_ID} t_prd_products PRD_000031 @ {STAMP} -->",
           "| min_qty | max_qty | qty_incr | qty_unit_typ_cd |", "|---|---|---|---|",
           f'| {p["min_qty"]} | {p["max_qty"]} | {p["qty_incr"]} | {p["qty_unit_typ_cd"]} |']
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-031-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print("### 사이즈 (전사)\n")
        print(md_sizes(d))
        print("\n### 공정 (전사)\n")
        print(md_procs(d))
        print("\n### 수량 스칼라 (전사)\n")
        print(md_qty(d))
        print("\n### PRD_000031 바인딩 요약 (전사)\n")
        print(json.dumps({"product": d["product"], "mat_master": d["mat_master"],
                          "bindings": d["bindings"]}, ensure_ascii=False, indent=2, sort_keys=True))
