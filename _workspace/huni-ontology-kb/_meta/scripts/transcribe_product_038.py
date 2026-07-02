#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 형압명함 PRD_000038.

형압명함은 명함 카테고리(032/033 형제)이나 라이브 바인딩이 스켈레톤이다(자재 0·공식 0·
옵션그룹 0·형압 공정 미바인딩·use_yn=N). 이 스크립트는 038의 사이즈(SIZ_000008)·수량 스칼라·
도수(색상수)·바인딩 행수를 라이브 스냅샷에서 결정론적으로 전사한다(사람이 눈으로 읽어 손으로
옮기지 않는다). 명함 사이즈 치수·공정명은 이미 공유 축(transcribe_product_033.py)에 있으므로
여기서는 038 실측 바인딩과 "무엇이 비었나"를 정직하게 전사하는 데 집중한다.

사용:  python3 transcribe_product_038.py            # stdout에 markdown 블록
       python3 transcribe_product_038.py --json     # cache/transcribed-038-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000038"

# 형압명함 실 바인딩 사이즈(라이브 1행) — 판걸이수는 사이즈 컬럼 아님(파생·fn_calc_pansu)
NC_SIZES = ["SIZ_000008"]
# 마스터에 실재하나 038엔 미바인딩인 형압 공정(정의적 특징) — 정직 전사용
EMBOSS_PROC = "PROC_000050"


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
    clrs = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    emboss = next((r for r in rd("t_proc_processes.csv") if r["proc_cd"] == EMBOSS_PROC), {})

    def scope(name, keep=None):
        rows = [r for r in rd(name) if r.get("prd_cd") == PRD and r.get("del_yn", "N") != "Y"]
        if keep:
            rows = [{k: r.get(k) for k in keep} for r in rows]
        return rows

    pos = scope("t_prd_product_print_options.csv",
                ("opt_id", "print_side", "front_colrcnt_cd", "back_colrcnt_cd", "print_opt_cd"))
    for r in pos:  # 색상수 라벨 결합(도수=print_opt_cd·front/back는 색상수)
        r["front_clr_nm"] = clrs.get(r["front_colrcnt_cd"], {}).get("clr_nm", "?")
        r["back_clr_nm"] = clrs.get(r["back_colrcnt_cd"], {}).get("clr_nm", "?")

    bindings = {
        "sizes": scope("t_prd_product_sizes.csv", ("siz_cd", "dflt_yn")),
        "materials": scope("t_prd_product_materials.csv", ("mat_cd", "usage_cd", "dflt_yn")),
        "print_options": pos,
        "processes": scope("t_prd_product_processes.csv", ("proc_cd", "mand_proc_yn")),
        "plate_sizes": scope("t_prd_product_plate_sizes.csv", ("siz_cd", "output_paper_typ_cd", "dflt_plt_yn")),
        "bundle_qtys": scope("t_prd_product_bundle_qtys.csv"),
        "addons": scope("t_prd_product_addons.csv"),
        "constraints": scope("t_prd_product_constraints.csv"),
        "price_formulas": scope("t_prd_product_price_formulas.csv", ("frm_cd",)),
        "categories": scope("t_prd_product_categories.csv", ("cat_cd", "main_cat_yn", "disp_seq")),
        "option_groups": scope("t_prd_product_option_groups.csv", ("opt_grp_cd", "opt_grp_nm")),
        "option_items": scope("t_prd_product_option_items.csv", ("opt_cd", "ref_dim_cd")),
        "options": scope("t_prd_product_options.csv", ("opt_cd", "opt_grp_cd", "opt_nm")),
        "page_rules": scope("t_prd_product_page_rules.csv"),
    }

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_product_038.py"},
        "product": {k: prod.get(k) for k in
                    ("prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn")},
        "sizes": {s: {"siz_nm": sizes[s]["siz_nm"],
                      "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                      "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                      "note": sizes[s].get("note") or ""}
                  for s in NC_SIZES if s in sizes},
        "emboss_master": {"proc_cd": emboss.get("proc_cd"), "proc_nm": emboss.get("proc_nm"),
                          "use_yn": emboss.get("use_yn"), "note": emboss.get("note") or "",
                          "bound_to_038": any(b["proc_cd"] == EMBOSS_PROC for b in bindings["processes"])},
        "bind_counts": {k: len(v) for k, v in bindings.items()},
        "bindings": bindings,
    }


def md_scalar(d):
    p = d["product"]
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_038.py from {SNAP_ID} t_prd_products PRD_000038 @ {STAMP} -->",
           "| prd_nm | prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | use_yn | del_yn |",
           "|---|---|---|---|---|---|---|---|",
           f'| {p["prd_nm"]} | {p["prd_typ_cd"]} | {p["min_qty"]} | {p["max_qty"]} | {p["qty_incr"]} | {p["qty_unit_typ_cd"]} | {p["use_yn"]} | {p["del_yn"]} |']
    return "\n".join(out)


def md_sizes(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_038.py from {SNAP_ID} t_siz_sizes @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s, v in d["sizes"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} |')
    return "\n".join(out)


def md_printopts(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_038.py from {SNAP_ID} t_prd_product_print_options+t_clr_color_counts @ {STAMP} -->",
           "| opt_id | print_opt_cd | 면 | 앞면 색상수 | 뒷면 색상수 |", "|---|---|---|---|---|"]
    for r in d["bindings"]["print_options"]:
        out.append(f'| {r["opt_id"]} | {r["print_opt_cd"]} | {r["print_side"]} | {r["front_clr_nm"]} | {r["back_clr_nm"]} |')
    return "\n".join(out)


def md_counts(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_product_038.py from {SNAP_ID} t_prd_product_* @ {STAMP} -->",
           "| 바인딩 테이블 | 행수 |", "|---|---|"]
    for k, n in d["bind_counts"].items():
        out.append(f'| {k} | {n} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-038-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print("### 상품 스칼라 (전사)\n")
        print(md_scalar(d))
        print("\n### 사이즈 (전사)\n")
        print(md_sizes(d))
        print("\n### 도수(인쇄옵션)·색상수 (전사)\n")
        print(md_printopts(d))
        print("\n### 바인딩 행수 (전사 — 무엇이 비었나)\n")
        print(md_counts(d))
        print("\n### 형압 공정 마스터 실재 vs 038 바인딩\n")
        print(json.dumps(d["emboss_master"], ensure_ascii=False, indent=2, sort_keys=True))
