#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 메쉬현수막 PRD_000139 전용.

transcribe_product_128.py(메쉬프린트) 패턴을 계승하되, 139는 128보다 CPQ가 풍부한
실사 면적매트릭스 + 옵션 add-on(BUNDLE) 상품이라 옵션그룹/옵션/옵션아이템/제약/공정
전사 블록을 추가한다(138 일반현수막 파일럿 동형).

  - ★실사=포스터/사인 면적매트릭스: 기본가 use_dims=[siz_width, siz_height]·off-grid=한 단계 큰 규격 ceiling.
  - ★비종이류(대형 롤): 판형(plate_size) 무의미 — 라이브 plate 3행 전부 del_yn=Y(2026-06-30 정리)·output_paper_typ 공백.
  - 카테고리 CAT_000315(배너/현수막·부모 CAT_000005 사인·lvl2·main_cat_yn=N) 1행.
  - 사이즈 = SIZ_000323(900x900)·SIZ_000320(900x1200)·SIZ_000322(5000x900) 이산 규격 + nonspec 연속범위(products 컬럼).
  - 자재 2 = MAT_000183(메쉬·MAT_TYPE.08 미교정·128 공유) + MAT_000070(설치용끈·MAT_TYPE.16 실사부자재·끈 BUNDLE).
  - 공정 3 = PROC_000079(타공·param 구수)·PROC_000084(열재단·flat·★master del_yn=Y)·PROC_000081(부착·param 대상 enum).
  - 옵션그룹 2 = OPT_000022(가공·타공 택1 필수) + OPT_000023(추가·큐방/끈 택0~1).
    ★option_items = 타공 3행만(OPV_042/043/044→PROC_000079·OPT_REF_DIM.04). 큐방/끈(OPV_425/426)은 미배선(L1 LINK BLOCKED).
  - 제약 1 = RULE_001(사용자입력 치수 범위·RULE_TYPE.01·CN-5 범위형).
  - 공식 = PRF_POSTER_BANNER_M → 6구성요소:
    기본 COMP_POSTER_BANNER_MESH([단독] 면적매트릭스 48셀)
    + 옵션 add-on 5(큐방/끈 추가·타공4/6/8 추가·addtn_yn=Y).
  - 단가행 = D-22 접기(노드 미전개) → comp별 행수·가로/세로축·단가범위 요약만 전사.

사용:  python3 transcribe_product_139.py            # stdout markdown
       python3 transcribe_product_139.py --json     # cache/transcribed-139-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000139"
SELF = "transcribe_product_139.py"
BASE_COMP = "COMP_POSTER_BANNER_MESH"          # [단독] 면적매트릭스 기본가
OPT_COMP_PREFIX = "COMP_POSTEROPT_BANNER_MESH"  # add-on 옵션 구성요소 접두


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def active(rows):
    return [r for r in rows if r.get("del_yn", "N") != "Y"]


def by_prd_all(name):
    return [r for r in rd(name) if r["prd_cd"] == PRD]


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
    mat_nm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = active(by_prd_all("t_prd_product_categories.csv"))
    psizes = by_prd_all("t_prd_product_sizes.csv")           # del 표기 위해 전 행
    mats = active(by_prd_all("t_prd_product_materials.csv"))
    popts = active(by_prd_all("t_prd_product_print_options.csv"))
    procs = active(by_prd_all("t_prd_product_processes.csv"))
    plates = by_prd_all("t_prd_product_plate_sizes.csv")     # del 표기 위해 전 행
    bqty = active(by_prd_all("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd_all("t_prd_product_addons.csv"))
    cons = active(by_prd_all("t_prd_product_constraints.csv"))
    grps = active(by_prd_all("t_prd_product_option_groups.csv"))
    opts = active(by_prd_all("t_prd_product_options.csv"))
    items = active(by_prd_all("t_prd_product_option_items.csv"))
    sets_parent = active([r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD])

    def size_row(r):
        s = sizes.get(r["siz_cd"], {})
        return {"siz_cd": r["siz_cd"], "siz_nm": s.get("siz_nm", "?"),
                "work": f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}',
                "link_del": r.get("del_yn", "N"), "master_del": s.get("del_yn", "?"),
                "dflt": r.get("dflt_yn", "")}

    def plate_row(r):
        return {"siz_cd": r["siz_cd"],
                "output_paper_typ_cd": r.get("output_paper_typ_cd") or "",
                "output_file_typ": r.get("output_file_typ") or "",
                "dflt": r.get("dflt_plt_yn", ""), "del": r.get("del_yn", "N"),
                "note": r.get("note") or ""}

    def proc_row(r):
        m = proc.get(r["proc_cd"], {})
        return {"proc_cd": r["proc_cd"], "proc_nm": m.get("proc_nm", "?"),
                "mand": r.get("mand_proc_yn", ""), "link_del": r.get("del_yn", "N"),
                "master_del": m.get("del_yn", "?"),
                "param": "Y" if (m.get("prcs_dtl_opt") or "").strip() else "N"}

    def grp_row(r):
        return {"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                "sel_typ_cd": r["sel_typ_cd"], "min_sel_cnt": r.get("min_sel_cnt", ""),
                "max_sel_cnt": r.get("max_sel_cnt", ""), "mand_yn": r.get("mand_yn", ""),
                "note": (r.get("note") or "")}

    def opt_row(r):
        return {"opt_cd": r["opt_cd"], "opt_grp_cd": r["opt_grp_cd"],
                "opt_nm": r["opt_nm"], "dflt_yn": r.get("dflt_yn", "")}

    def item_row(r):
        return {"opt_cd": r["opt_cd"], "ref_dim_cd": r.get("ref_dim_cd", ""),
                "ref_key1": r.get("ref_key1", ""), "ref_key2": r.get("ref_key2", ""),
                "qty": r.get("qty", "")}

    def con_row(r):
        return {"rule_cd": r["rule_cd"], "rule_nm": r["rule_nm"],
                "rule_typ_cd": r["rule_typ_cd"], "use_yn": r.get("use_yn", "")}

    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fmeta = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    wiring = {}
    for frm in fbind:
        rows = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == frm]
        rows.sort(key=lambda x: (x.get("disp_seq") in (None, ""), x.get("disp_seq") or "", x["comp_cd"]))
        wiring[frm] = [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                        "addtn_yn": r.get("addtn_yn") or "",
                        "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                        "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                        "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")} for r in rows]

    # 단가행 요약 (D-22 접기 — 전개 금지·집계만). 이 상품 공식이 배선한 전 comp를 대상.
    wired_comps = [w["comp_cd"] for frm in fbind for w in wiring[frm]]
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] in wired_comps]

    def cell_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        widths = sorted({_mm(r["siz_width"]) for r in g if (r.get("siz_width") or "").strip()},
                        key=lambda x: (x == "?", float(x) if x not in ("?", "") else 0))
        heights = sorted({_mm(r["siz_height"]) for r in g if (r.get("siz_height") or "").strip()},
                         key=lambda x: (x == "?", float(x) if x not in ("?", "") else 0))
        prices = [float(r["unit_price"]) for r in g if (r.get("unit_price") or "").strip()]
        # add-on 판별키(proc_cd/opt_cd/dim_vals) — 첫 행 대표
        rep = g[0] if g else {}
        return {"rows": len(g), "widths": widths, "heights": heights,
                "price_min": min(prices) if prices else None,
                "price_max": max(prices) if prices else None,
                "use_yn": pcomp.get(comp, {}).get("use_yn"),
                "use_dims": pcomp.get(comp, {}).get("use_dims"),
                "comp_nm": pcomp.get(comp, {}).get("comp_nm"),
                "rep_proc": rep.get("proc_cd", ""), "rep_opt": rep.get("opt_cd", ""),
                "rep_dim_vals": rep.get("dim_vals", "")}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "nonspec_yn",
                     "nonspec_width_min", "nonspec_width_max", "nonspec_width_incr",
                     "nonspec_height_min", "nonspec_height_max", "nonspec_height_incr",
                     "min_qty", "max_qty", "qty_incr", "qty_unit_typ_cd",
                     "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd"),
                        "cat_lvl": cat.get(r["cat_cd"], {}).get("cat_lvl"),
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "sizes": [size_row(r) for r in psizes],
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_nm.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": popts,
        "processes": [proc_row(r) for r in procs],
        "plates": [plate_row(r) for r in plates],
        "bundle_qty": bqty, "addons": addons,
        "constraints": [con_row(r) for r in cons],
        "option_groups": [grp_row(r) for r in grps],
        "options": [opt_row(r) for r in opts],
        "option_items": [item_row(r) for r in items],
        "sets_parent": sets_parent,
        "formulas": fbind, "formula_meta": {f: fmeta.get(f, {}) for f in fbind},
        "wiring": wiring,
        "cells": {c: cell_summary(c) for c in dict.fromkeys(wired_comps)},
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량·비규격 범위 (전사)\n")
    o.append(_tb("t_prd_products PRD_000139"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty'] or '(빈값)'} | {p['max_qty'] or '(빈값)'} | {p['qty_incr'] or '(빈값)'} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")
    o.append("")
    o.append("| 비규격축 | width_min | width_max | width_incr | height_min | height_max | height_incr |")
    o.append("|---|---|---|---|---|---|---|")
    o.append(f"| nonspec | {_mm(p['nonspec_width_min'])} | {_mm(p['nonspec_width_max'])} | {_mm(p['nonspec_width_incr'])} | {_mm(p['nonspec_height_min'])} | {_mm(p['nonspec_height_max'])} | {_mm(p['nonspec_height_incr'])} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 부모 | lvl | main_cat_yn |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"]} | {r["cat_lvl"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 (전사·전 행·del 표기)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|")
    for r in d["sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["dflt"]} | {r["link_del"]} | {r["master_del"]} |')

    o.append("\n### 자재 (전사·2 슬롯 — 본체 메쉬 + 설치용끈 BUNDLE)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | usage_cd | dflt |")
    o.append("|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### 공정 (전사·전 행·del/param 표기)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 이름 | mand | 링크 del | 마스터 del | param |")
    o.append("|---|---|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["mand"]} | {r["link_del"]} | {r["master_del"]} | {r["param"]} |')

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        of = r["output_file_typ"] if r["output_file_typ"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {of} | {r["dflt"]} | {r["del"]} | {r["note"]} |')

    o.append("\n### 보유/미보유 축 (전사·행수 실측)\n")
    o.append(_tb("print_options/processes/bundle_qtys/addons/constraints/option_groups/options/option_items/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| print_options(도수) | {len(d['print_options'])} |")
    o.append(f"| processes(공정) | {len(d['processes'])} |")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| option_groups(CPQ 옵션그룹) | {len(d['option_groups'])} |")
    o.append(f"| options(옵션값) | {len(d['options'])} |")
    o.append(f"| option_items(옵션→차원 배선) | {len(d['option_items'])} |")
    o.append(f"| sets(셋트 부모) | {len(d['sets_parent'])} |")

    o.append("\n### 옵션그룹 (전사)\n")
    o.append(_tb("t_prd_product_option_groups"))
    o.append("| opt_grp_cd | 이름 | sel_typ | min_sel | max_sel | mand | note |")
    o.append("|---|---|---|---|---|---|---|")
    for r in d["option_groups"]:
        o.append(f'| {r["opt_grp_cd"]} | {r["opt_grp_nm"]} | {r["sel_typ_cd"]} | {r["min_sel_cnt"]} | {r["max_sel_cnt"]} | {r["mand_yn"]} | {r["note"]} |')

    o.append("\n### 옵션값 (전사)\n")
    o.append(_tb("t_prd_product_options"))
    o.append("| opt_cd | 그룹 | 이름 | dflt |")
    o.append("|---|---|---|---|")
    for r in d["options"]:
        o.append(f'| {r["opt_cd"]} | {r["opt_grp_cd"]} | {r["opt_nm"]} | {r["dflt_yn"]} |')

    o.append("\n### 옵션→차원 배선 (전사·option_items — ★타공만 배선·큐방/끈 미배선)\n")
    o.append(_tb("t_prd_product_option_items"))
    o.append("| opt_cd | ref_dim_cd | ref_key1 | ref_key2 | qty |")
    o.append("|---|---|---|---|---|")
    for r in d["option_items"]:
        o.append(f'| {r["opt_cd"]} | {r["ref_dim_cd"]} | {r["ref_key1"]} | {r["ref_key2"] or "(공백)"} | {r["qty"]} |')

    o.append("\n### 제약규칙 (전사)\n")
    o.append(_tb("t_prd_product_constraints (logic 원문은 노드 props로 접기·D-22)"))
    o.append("| rule_cd | 이름 | rule_typ | use_yn |")
    o.append("|---|---|---|---|")
    for r in d["constraints"]:
        o.append(f'| {r["rule_cd"]} | {r["rule_nm"]} | {r["rule_typ_cd"]} | {r["use_yn"]} |')

    o.append("\n### 가격 배선 (전사·priced_by→공식→구성요소)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    for frm in d["formulas"]:
        fm = d["formula_meta"].get(frm, {})
        o.append(f'\n공식 **{frm}** — {fm.get("frm_nm","")} (use_yn={fm.get("use_yn","")})\n')
        o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
        o.append("|---|---|---|---|---|---|")
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 단가행 셀 요약 (전사·D-22 접기 — 전개 금지·집계만)\n")
    o.append(_tb("t_prc_component_prices (공식 배선 comp 전건 집계)"))
    o.append("| comp_cd | use_yn | 행수 | 가로축(mm) | 세로축(mm) | 단가범위 | 판별키(proc/opt/dim_vals) |")
    o.append("|---|---|---|---|---|---|---|")
    for c, g in d["cells"].items():
        w = "/".join(g["widths"]) if g["widths"] else "-"
        h = "/".join(g["heights"]) if g["heights"] else "-"
        pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
        key = f'proc={g["rep_proc"] or "-"} opt={g["rep_opt"] or "-"} dim_vals={g["rep_dim_vals"] or "-"}'
        o.append(f'| {c} | {g["use_yn"]} | {g["rows"]} | {w} | {h} | {pr} | {key} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-139-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
