#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 투명포토카드 PRD_000025 전용.

기존 transcribe_snapshot.py(파일럿 공통 사이즈·배선)를 수정하지 않고, 포토카드
상품 노드가 필요로 하는 상품별 축 연결·신규 축 코드(사이즈 SIZ_000012·라미/모서리 공정
4종)·CPQ 옵션 레이어·추가상품 템플릿·수량규칙·가격 배선을 라이브 스냅샷에서 결정론적으로
뽑아, 노드 본문에 붙일 markdown 표(transcribed-by 마커 포함)와 JSON 캐시로 출력한다.
상품 노드의 사이즈 치수·공정명·옵션참조·수량구간은 이 스크립트 전사분을 그대로 옮긴 것이며,
사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_product_025.py            # stdout에 markdown 블록
       python3 transcribe_product_025.py --json     # cache/transcribed-025-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000025"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def by_prd(name):
    return [r for r in rd(name) if r["prd_cd"] == PRD]


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return "?"


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc_nm = {r["proc_cd"]: r.get("proc_nm") for r in rd("t_proc_processes.csv")}
    mat_nm = {r["mat_cd"]: r.get("mat_nm") for r in rd("t_mat_materials.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    tmpls = {r["tmpl_cd"]: r for r in rd("t_prd_templates.csv")}
    prods = {r["prd_cd"]: r for r in rd("t_prd_products.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = active(by_prd("t_prd_product_categories.csv"))
    psizes = active(by_prd("t_prd_product_sizes.csv"))
    mats = active(by_prd("t_prd_product_materials.csv"))
    popts = active(by_prd("t_prd_product_print_options.csv"))
    procs = active(by_prd("t_prd_product_processes.csv"))
    plates = active(by_prd("t_prd_product_plate_sizes.csv"))
    bqty = active(by_prd("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd("t_prd_product_addons.csv"))

    grps = active(by_prd("t_prd_product_option_groups.csv"))
    opts = active(by_prd("t_prd_product_options.csv"))
    items = active(by_prd("t_prd_product_option_items.csv"))
    opt_by_cd = {o["opt_cd"]: o for o in opts}

    # size dims (linked + plate)
    linked_siz = sorted({r["siz_cd"] for r in psizes} | {r["siz_cd"] for r in plates})
    size_dims = {s: {"siz_nm": sizes[s]["siz_nm"],
                     "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                     "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}'}
                 for s in linked_siz if s in sizes}

    # formula binding + wiring
    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    wiring = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""), x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "generated_by": "transcribe_product_025.py"},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "sizes_linked": [r["siz_cd"] for r in psizes],
        "size_dims": size_dims,
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"]),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"],
                           "opt_id": r["opt_id"]} for r in popts],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc_nm.get(r["proc_cd"]),
                       "mand_proc_yn": r["mand_proc_yn"]} for r in procs],
        "plates": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                    "dflt_plt_yn": r["dflt_plt_yn"]} for r in plates],
        "bundle_qty": [{"bdl_qty": r["bdl_qty"], "bdl_unit_typ_cd": r["bdl_unit_typ_cd"]} for r in bqty],
        "option_groups": [{"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g["opt_grp_nm"],
                           "sel_typ_cd": g["sel_typ_cd"], "min_sel_cnt": g["min_sel_cnt"],
                           "max_sel_cnt": g["max_sel_cnt"], "mand_yn": g["mand_yn"]} for g in grps],
        "option_items": [{"opt_grp_cd": opt_by_cd.get(i["opt_cd"], {}).get("opt_grp_cd"),
                          "opt_cd": i["opt_cd"], "opt_nm": opt_by_cd.get(i["opt_cd"], {}).get("opt_nm"),
                          "ref_dim_cd": i["ref_dim_cd"], "ref_key1": i["ref_key1"],
                          "ref_key2": i["ref_key2"]} for i in items],
        "addons": [{"tmpl_cd": r["tmpl_cd"], "disp_seq": r["disp_seq"],
                    "base_prd_cd": tmpls.get(r["tmpl_cd"], {}).get("base_prd_cd"),
                    "base_prd_nm": prods.get(tmpls.get(r["tmpl_cd"], {}).get("base_prd_cd"), {}).get("prd_nm"),
                    "base_prd_typ_cd": prods.get(tmpls.get(r["tmpl_cd"], {}).get("base_prd_cd"), {}).get("prd_typ_cd"),
                    "tmpl_nm": tmpls.get(r["tmpl_cd"], {}).get("tmpl_nm")} for r in addons],
        "formulas": fbind,
        "wiring": wiring,
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/transcribe_product_025.py from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000025"))
    p = d["product"]
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |")
    o.append("|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} |")

    o.append("\n### 사이즈 치수 (전사)\n")
    o.append(_tb("t_siz_sizes (linked+plate)"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |")
    o.append("|---|---|---|---|")
    for s, v in d["size_dims"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} |')

    o.append("\n### 공정 (전사)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | mand |")
    o.append("|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["mand_proc_yn"]} |')

    o.append("\n### 자재 BOM (전사·활성 del_yn=N만)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials (active)"))
    o.append("| mat_cd | 자재명 | usage_cd | dflt |")
    o.append("|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### CPQ 옵션그룹 (전사)\n")
    o.append(_tb("t_prd_product_option_groups"))
    o.append("| opt_grp_cd | 그룹명 | sel_typ | min/max | mand |")
    o.append("|---|---|---|---|---|")
    for g in d["option_groups"]:
        o.append(f'| {g["opt_grp_cd"]} | {g["opt_grp_nm"]} | {g["sel_typ_cd"]} | {g["min_sel_cnt"]}/{g["max_sel_cnt"]} | {g["mand_yn"]} |')

    o.append("\n### CPQ 옵션 아이템 → 차원 참조 (전사)\n")
    o.append(_tb("t_prd_product_option_items"))
    o.append("| opt_grp | opt_cd | 옵션명 | ref_dim_cd | ref_key1 | ref_key2 |")
    o.append("|---|---|---|---|---|---|")
    for i in d["option_items"]:
        o.append(f'| {i["opt_grp_cd"]} | {i["opt_cd"]} | {i["opt_nm"]} | {i["ref_dim_cd"]} | {i["ref_key1"]} | {i["ref_key2"] or ""} |')

    o.append("\n### 추가상품 템플릿 (전사)\n")
    o.append(_tb("t_prd_product_addons+t_prd_templates"))
    o.append("| tmpl_cd | 템플릿명 | base_prd_cd | base 상품명 | base 유형 |")
    o.append("|---|---|---|---|---|")
    for r in d["addons"]:
        o.append(f'| {r["tmpl_cd"]} | {r["tmpl_nm"]} | {r["base_prd_cd"]} | {r["base_prd_nm"]} | {r["base_prd_typ_cd"]} |')

    o.append(f"\n### 가격 배선 {'·'.join(d['formulas']) or '(미바인딩)'} (전사)\n")
    o.append(_tb("t_prc_formula_components+t_prc_price_components"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-025-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
