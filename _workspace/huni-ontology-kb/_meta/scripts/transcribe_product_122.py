#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 접착투명포스터 PRD_000122 전용.

★실사 파일럿 첫 상품(면적매트릭스형 area-matrix). transcribe_product_051.py 패턴을
계승하되 실사 특성에 맞춘다:
  - 가격 = 면적매트릭스형(COMP_POSTER_ADH_CLEAR_PVC·use_dims=[siz_width, siz_height]).
    단가행(52셀)은 노드로 펼치지 않고 count/range/golden 요약으로 접는다(D-22·pack §3.11).
  - 판형(plate) = 3행 전부 del_yn=Y(2026-06-30 파일사양 논리삭제) → 활성 판형 0.
    ★비종이류(투명PVC 대형 롤)라 판형 무의미(pack §3.8·T-7) — del 이력째 전사·활성0 확인.
  - 사이즈 = 이산 규격 3행(A3/A2/A1) + nonspec 연속범위(제약 RULE_001 width/height).
    면적매트릭스 셀(siz_width×siz_height)은 이 이산 SIZ와 독립(pack §3.2·off-grid ceiling).
  - 자재 = MAT_000180 투명PVC(MAT_TYPE.08 실사소재·USAGE.07 단일 슬롯).
  - 공정 = PROC_000008 화이트인쇄(upr PROC_000007 별색·mand=N·투명 소재 밑판 underbase).
  - 인쇄옵션 = 0행(실사=대형 잉크젯 풀컬러·도수 컬럼 없음·po=0·정당·pack §3.3/§3.7).
  - 옵션그룹 = OPT_000008 화이트별색(1옵션 OPV_000024→OPT_REF_DIM.04 ref_key1=PROC_000008).
  - 제약 = RULE_001 사용자입력 치수 범위(logic 그대로 전사·nonspec width 200~1200/height 200~3000).
  - 공식 = PRF_POSTER_ADH_CLEAR(면적/규격 단가 완제품 통가격).

사용:  python3 transcribe_product_122.py            # stdout에 markdown 블록
       python3 transcribe_product_122.py --json     # cache/transcribed-122-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000122"
SELF = "transcribe_product_122.py"


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def by_prd_active(name):
    return active([r for r in rd(name) if r.get("prd_cd") == PRD])


def by_prd_all(name):
    return [r for r in rd(name) if r.get("prd_cd") == PRD]


def _mm(v):
    try:
        f = float(v)
        return str(int(f)) if f == int(f) else str(f)
    except (TypeError, ValueError):
        return "?"


def build():
    prod = next((r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD), {})
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = by_prd_active("t_prd_product_categories.csv")
    psizes = by_prd_active("t_prd_product_sizes.csv")
    mats = by_prd_active("t_prd_product_materials.csv")
    popts = by_prd_active("t_prd_product_print_options.csv")
    procs = by_prd_active("t_prd_product_processes.csv")
    plates_all = by_prd_all("t_prd_product_plate_sizes.csv")   # del 이력 포함(활성0 확인)
    bqty = by_prd_active("t_prd_product_bundle_qtys.csv")
    addons = by_prd_active("t_prd_product_addons.csv")
    cons = by_prd_active("t_prd_product_constraints.csv")
    grps = by_prd_active("t_prd_product_option_groups.csv")
    opts = by_prd_active("t_prd_product_options.csv")
    items = by_prd_active("t_prd_product_option_items.csv")

    size_dims = {r["siz_cd"]: {
        "siz_nm": sizes[r["siz_cd"]]["siz_nm"],
        "work": f'{_mm(sizes[r["siz_cd"]]["work_width"])}x{_mm(sizes[r["siz_cd"]]["work_height"])}',
        "cut": f'{_mm(sizes[r["siz_cd"]]["cut_width"])}x{_mm(sizes[r["siz_cd"]]["cut_height"])}',
        "dflt": r.get("dflt_yn"),
    } for r in psizes if r["siz_cd"] in sizes}

    # 가격 배선 + 면적매트릭스 셀 요약(접기·값 나열 아님·D-22)
    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    wiring = {}
    matrix = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""), x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "comp_typ_cd": pcomp.get(r["comp_cd"], {}).get("comp_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm"),
                        "master_note": pcomp.get(r["comp_cd"], {}).get("note")} for r in rows]
        for r in rows:
            comp = r["comp_cd"]
            cells = [cp for cp in rd("t_prc_component_prices.csv") if cp.get("comp_cd") == comp]
            pairs = sorted({(cp.get("siz_width"), cp.get("siz_height")) for cp in cells})
            prices = [float(cp["unit_price"]) for cp in cells if cp.get("unit_price")]
            matrix[comp] = {"cells": len(cells), "wh_pairs": len(pairs),
                            "price_min": min(prices) if prices else None,
                            "price_max": max(prices) if prices else None,
                            "master_note": pcomp.get(comp, {}).get("note")}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn",
                     "output_paper_typ_cd", "nonspec_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "size_dims": size_dims,
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": popts,
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm"),
                       "upr_proc_cd": proc.get(r["proc_cd"], {}).get("upr_proc_cd"),
                       "mand_proc_yn": r["mand_proc_yn"]} for r in procs],
        "plates_all": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r.get("output_paper_typ_cd") or "",
                        "output_file_typ": r.get("output_file_typ"),
                        "dflt_plt_yn": r.get("dflt_plt_yn"), "del_yn": r.get("del_yn"),
                        "note": r.get("note") or ""} for r in plates_all],
        "bundle_qty": bqty, "addons": addons,
        "constraints": [{"rule_cd": r["rule_cd"], "rule_nm": r["rule_nm"],
                         "rule_typ_cd": r.get("rule_typ_cd"), "logic": r.get("logic"),
                         "err_msg": r.get("err_msg"), "use_yn": r.get("use_yn")} for r in cons],
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                           "sel_typ_cd": r["sel_typ_cd"], "min_sel_cnt": r.get("min_sel_cnt"),
                           "max_sel_cnt": r.get("max_sel_cnt"), "mand_yn": r.get("mand_yn"),
                           "note": r.get("note") or ""} for r in grps],
        "options": [{"opt_cd": r["opt_cd"], "opt_grp_cd": r["opt_grp_cd"], "opt_nm": r["opt_nm"],
                     "dflt_yn": r.get("dflt_yn")} for r in opts],
        "option_items": [{"opt_cd": r["opt_cd"], "item_seq": r.get("item_seq"),
                          "ref_dim_cd": r.get("ref_dim_cd"), "ref_key1": r.get("ref_key1"),
                          "qty": r.get("qty")} for r in items],
        "formulas": fbind, "wiring": wiring, "matrix": matrix,
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000122"))
    o.append("| prd_typ_cd | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | nonspec | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['nonspec_yn']} | {p['use_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | main_cat_yn |")
    o.append("|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 치수 (이산 규격·전사)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes (del_yn=N)"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt |")
    o.append("|---|---|---|---|---|")
    for s, v in d["size_dims"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["dflt"]} |')

    o.append("\n### 자재 (전사)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | usage_cd | dflt |")
    o.append("|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### 인쇄옵션 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_print_options"))
    o.append(f"인쇄옵션 **{len(d['print_options'])}행** — 실사=대형 잉크젯 풀컬러(도수 컬럼 없음·po=0·정당·pack §3.3/§3.7)")

    o.append("\n### 공정 (전사)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 상위공정 | mand |")
    o.append("|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr_proc_cd"]} | {r["mand_proc_yn"]} |')

    o.append("\n### 판형 (전사·★del 이력 포함·활성 0 확인)\n")
    o.append(_tb("t_prd_product_plate_sizes (전 행·del 표기)"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates_all"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt_plt_yn"]} | {r["del_yn"]} | {r["note"]} |')
    n_active = len([r for r in d["plates_all"] if r["del_yn"] != "Y"])
    o.append(f"\n> 활성 판형(del_yn=N) **{n_active}행** — 비종이류(투명PVC 대형 롤)라 판형 무의미(pack §3.8·T-7). 3행 전부 2026-06-30 파일사양 논리삭제.")

    o.append("\n### 제약규칙 (전사·logic 그대로)\n")
    o.append(_tb("t_prd_product_constraints"))
    o.append("| rule_cd | rule_nm | rule_typ | use | err_msg |")
    o.append("|---|---|---|---|---|")
    for r in d["constraints"]:
        o.append(f'| {r["rule_cd"]} | {r["rule_nm"]} | {r["rule_typ_cd"]} | {r["use_yn"]} | {r["err_msg"]} |')
    for r in d["constraints"]:
        o.append(f'\n> `{r["rule_cd"]}` logic(전사): `{r["logic"]}`')

    o.append("\n### 옵션그룹·옵션·아이템 (전사)\n")
    o.append(_tb("t_prd_product_option_groups+options+option_items"))
    for g in d["option_groups"]:
        o.append(f'\n**{g["opt_grp_cd"]} {g["opt_grp_nm"]}** (sel={g["sel_typ_cd"]}·min/max={g["min_sel_cnt"]}/{g["max_sel_cnt"]}·mand={g["mand_yn"]}·note:{g["note"]})')
        o.append("| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 | qty |")
        o.append("|---|---|---|---|---|---|")
        for op in [x for x in d["options"] if x["opt_grp_cd"] == g["opt_grp_cd"]]:
            it = next((x for x in d["option_items"] if x["opt_cd"] == op["opt_cd"]), {})
            o.append(f'| {op["opt_cd"]} | {op["opt_nm"]} | {op["dflt_yn"]} | {it.get("ref_dim_cd","")} | {it.get("ref_key1","")} | {it.get("qty","")} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")

    o.append("\n### 가격 배선 PRF_POSTER_ADH_CLEAR (전사)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_typ | comp_nm | use_dims |")
    o.append("|---|---|---|---|---|---|---|")
    for frm in d["formulas"]:
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 면적매트릭스 단가행 요약 (★접기·값 나열 아님·D-22·pack §3.11)\n")
    o.append(_tb("t_prc_component_prices (COMP_POSTER_ADH_CLEAR_PVC·count/range/golden 요약)"))
    o.append("| comp_cd | 단가셀수 | (가로,세로) 순서쌍수 | 단가 min | 단가 max | master note |")
    o.append("|---|---|---|---|---|---|")
    for comp, m in d["matrix"].items():
        o.append(f'| {comp} | {m["cells"]} | {m["wh_pairs"]} | {m["price_min"]} | {m["price_max"]} | {m["master_note"]} |')
    o.append("\n> ★단가행은 (siz_width×siz_height) long-form 격자다. 값 전건은 KB에 나열하지 않고 count/range/골든으로 접는다(D-22). 값 계산=evaluate_price(가격 경계 D-18). off-grid=가로·세로 각 한 단계 큰 규격 ceiling(앱 계산·pack §3.10).")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-122-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
