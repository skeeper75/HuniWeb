#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 종이슬로건 PRD_000026 전용.

기존 transcribe_product_024.py(포토카드) 패턴을 계승하되, 종이슬로건이 필요로 하는
상품별 축 연결(사이즈 SIZ_000015/016·판형 SIZ_000499)·인쇄옵션 색상수·CPQ 옵션 레이어
(인쇄/종이/코팅 3그룹)·수량규칙(상품레벨 min4/incr4·bundle_qtys 0행)·가격 배선(PRF_DGP_A)을
라이브 스냅샷에서 결정론적으로 뽑아, 노드 본문에 붙일 markdown 표(transcribed-by 마커)와
JSON 캐시로 출력한다. 사람이 눈으로 읽어 손으로 옮기지 않는다.

포토카드(024)와 다른 점: bundle_qtys 0행·addons 0행·제작방식 옵션 없음·editor_yn=N·
공식=PRF_DGP_A(원자합산형·박 분기 미바인딩). 빈 섹션은 md()에서 생략한다.

사용:  python3 transcribe_product_026.py            # stdout에 markdown 블록
       python3 transcribe_product_026.py --json     # cache/transcribed-026-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000026"
SELF = "transcribe_product_026.py"


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
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    clr = {r["clr_cd"]: r for r in rd("t_clr_color_counts.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = active(by_prd("t_prd_product_categories.csv"))
    psizes = active(by_prd("t_prd_product_sizes.csv"))
    mats = active(by_prd("t_prd_product_materials.csv"))
    popts = active(by_prd("t_prd_product_print_options.csv"))
    procs = active(by_prd("t_prd_product_processes.csv"))
    plates = active(by_prd("t_prd_product_plate_sizes.csv"))
    bqty = active(by_prd("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd("t_prd_product_addons.csv"))
    cons = active(by_prd("t_prd_product_constraints.csv"))

    grps = active(by_prd("t_prd_product_option_groups.csv"))
    opts = active(by_prd("t_prd_product_options.csv"))
    items = active(by_prd("t_prd_product_option_items.csv"))
    opt_by_cd = {o["opt_cd"]: o for o in opts}

    linked_siz = sorted({r["siz_cd"] for r in psizes} | {r["siz_cd"] for r in plates})
    size_dims = {s: {"siz_nm": sizes[s]["siz_nm"],
                     "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                     "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}',
                     "note": sizes[s].get("note") or ""}
                 for s in linked_siz if s in sizes}

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
                 "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "sizes_linked": [r["siz_cd"] for r in psizes],
        "size_dims": size_dims,
        "materials": [{"mat_cd": r["mat_cd"], "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": [{"print_opt_cd": r["print_opt_cd"], "print_side": r["print_side"],
                           "opt_id": r["opt_id"],
                           "front_clr": clr.get(r["front_colrcnt_cd"], {}).get("clr_nm"),
                           "back_clr": clr.get(r["back_colrcnt_cd"], {}).get("clr_nm")} for r in popts],
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc_nm.get(r["proc_cd"]),
                       "mand_proc_yn": r["mand_proc_yn"]} for r in procs],
        "plates": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                    "dflt_plt_yn": r["dflt_plt_yn"]} for r in plates],
        "bundle_qty": [{"bdl_qty": r["bdl_qty"], "bdl_unit_typ_cd": r["bdl_unit_typ_cd"]} for r in bqty],
        "addons": [dict(r) for r in addons],
        "constraints": [dict(r) for r in cons],
        "option_groups": [{"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g["opt_grp_nm"],
                           "sel_typ_cd": g["sel_typ_cd"], "min_sel_cnt": g["min_sel_cnt"],
                           "max_sel_cnt": g["max_sel_cnt"], "mand_yn": g["mand_yn"]} for g in grps],
        "option_items": [{"opt_grp_cd": opt_by_cd.get(i["opt_cd"], {}).get("opt_grp_cd"),
                          "opt_cd": i["opt_cd"], "opt_nm": opt_by_cd.get(i["opt_cd"], {}).get("opt_nm"),
                          "ref_dim_cd": i["ref_dim_cd"], "ref_key1": i["ref_key1"],
                          "ref_key2": i["ref_key2"]} for i in items],
        "formulas": fbind,
        "wiring": wiring,
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000026"))
    p = d["product"]
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor |")
    o.append("|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} |")

    o.append("\n### 사이즈 치수 (전사)\n")
    o.append(_tb("t_siz_sizes (linked+plate)"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | note |")
    o.append("|---|---|---|---|---|")
    for s, v in d["size_dims"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["note"]} |')

    o.append("\n### 인쇄옵션 (전사)\n")
    o.append(_tb("t_prd_product_print_options+t_clr_color_counts"))
    o.append("| print_opt_cd | 면 | 앞도수 | 뒷도수 |")
    o.append("|---|---|---|---|")
    for r in d["print_options"]:
        o.append(f'| {r["print_opt_cd"]} | {r["print_side"]} | {r["front_clr"]} | {r["back_clr"]} |')

    o.append("\n### 공정 (전사)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | mand |")
    o.append("|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["mand_proc_yn"]} |')

    o.append("\n### 판형 (전사)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | dflt |")
    o.append("|---|---|---|")
    for r in d["plates"]:
        o.append(f'| {r["siz_cd"]} | {r["output_paper_typ_cd"]} | {r["dflt_plt_yn"]} |')

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

    # 빈 섹션 정직 표기(bundle_qtys/addons/constraints 0행)
    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons/constraints"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")

    o.append("\n### 가격 배선 PRF_DGP_A (전사)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-026-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
