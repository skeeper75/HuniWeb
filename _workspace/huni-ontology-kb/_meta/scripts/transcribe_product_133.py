#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·file-format §4·[HARD] LLM 손전사 금지) — 캔버스 행잉포스터 PRD_000133 전용.

★실사 고정가형(fixed-price) 첫 상품. transcribe_product_122.py(면적매트릭스형) 패턴을
계승하되 133의 고정가·부속 특성에 맞춘다:
  - 정체: nonspec_yn=N(자유입력 없음·이산 규격 3종만 A4/A3/A2) · editor_yn=Y(에디터 상품 3종 중 하나·pack §3.1).
  - 가격 = 고정가형([수량×규격] 블록·pack §3.10). 공식 PRF_POSTER_CANVAS_HANGING이
    구성요소 2개 배선:
      ① COMP_POSTER_CANVAS_HANGING(완제품가·prc_typ PRICE_TYPE.01·comp_typ .06 완제품비)
         — ★use_dims 선언=[siz_width,siz_height,min_qty](면적템플릿)인데 실 단가행은
           siz_cd+min_qty 키(고정가·이산 규격). 선언≠셀키 불일치를 그대로 전사(GAP 신호).
      ② COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER(우드행거+면끈 추가가격·use_dims=[opt_cd,siz_cd,opt_grp:OPT_000012])
         — 부속(우드행거)을 옵션×규격 단가행으로 표현. addon 테이블 아님(§3.12 재연결 GAP).
    단가행 실값은 count/range로 접는다(D-22·L-12·pack §3.11).
  - 자재 = MAT_000185 캔버스(옥스포드)·MAT_TYPE.05 특수소재(06-14 .08→.05 교정)·USAGE.07(125와 동일 자재).
  - 공정 = PROC_000080 봉제(패브릭 완성형태 후가공)·가공 옵션 참조.
  - 판형 = 3행 전부 del_yn=Y(파일사양 논리삭제) → 활성 0(비종이류 대형 롤·pack §3.8·T-7).
  - 인쇄옵션 = 0행(실사=대형 잉크젯 풀컬러·도수 컬럼 없음·po=0·정당·pack §3.3/§3.7).
  - 옵션그룹 2 = OPT_000011 가공(★mand=Y 필수·오버로크→PROC_000080) / OPT_000012 추가(우드행거 택0/1).
  - 제약 = 0행(133은 constraints 7상품 밖·pack §3.9 — 위키 대비 정합).
  - 부속(addon)/셋트(set) = 0행. 우드행거(PRD_000014·기성 PRD_TYPE.03) 재연결 GAP(pack §3.12).

사용:  python3 transcribe_product_133.py            # stdout에 markdown 블록
       python3 transcribe_product_133.py --json     # cache/transcribed-133-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000133"
SELF = "transcribe_product_133.py"


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

    cats = by_prd_all("t_prd_product_categories.csv")
    cats = [r for r in cats if r.get("del_yn", "N") != "Y"]
    psizes = by_prd_active("t_prd_product_sizes.csv")
    mats = by_prd_active("t_prd_product_materials.csv")
    popts = by_prd_active("t_prd_product_print_options.csv")
    procs = by_prd_active("t_prd_product_processes.csv")
    plates_all = by_prd_all("t_prd_product_plate_sizes.csv")   # del 이력 포함(활성0 확인)
    bqty = by_prd_active("t_prd_product_bundle_qtys.csv")
    addons = by_prd_active("t_prd_product_addons.csv")
    sets_parent = [r for r in rd("t_prd_product_sets.csv") if r.get("prd_cd") == PRD]
    sets_child = [r for r in rd("t_prd_product_sets.csv") if r.get("sub_prd_cd") == PRD]
    cons = by_prd_active("t_prd_product_constraints.csv")
    grps = by_prd_active("t_prd_product_option_groups.csv")
    opts = by_prd_active("t_prd_product_options.csv")
    items = by_prd_active("t_prd_product_option_items.csv")

    size_dims = {r["siz_cd"]: {
        "siz_nm": sizes[r["siz_cd"]]["siz_nm"],
        "work": f'{_mm(sizes[r["siz_cd"]]["work_width"])}x{_mm(sizes[r["siz_cd"]]["work_height"])}',
        "cut": f'{_mm(sizes[r["siz_cd"]]["cut_width"])}x{_mm(sizes[r["siz_cd"]]["cut_height"])}',
        "dflt": r.get("dflt_yn"),
        "master_del": sizes[r["siz_cd"]].get("del_yn"),
    } for r in psizes if r["siz_cd"] in sizes}

    # 가격 배선 + 단가행 요약(접기·값 나열 아님·D-22·L-12) — 선언 use_dims vs 실 셀키 둘 다 전사
    fbind = [r["frm_cd"] for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    frm_master = {r["frm_cd"]: r for r in rd("t_prc_price_formulas.csv")}
    all_cp = rd("t_prc_component_prices.csv")
    wiring = {}
    cellsum = {}
    DIMCOLS = ["siz_cd", "siz_width", "siz_height", "min_qty", "max_qty",
               "clr_cd", "mat_cd", "proc_cd", "opt_cd", "bdl_qty", "coat_cd"]
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
            cells = [cp for cp in all_cp if cp.get("comp_cd") == comp]
            nonempty = [c for c in DIMCOLS if any(cp.get(c) for cp in cells)]
            prices = [float(cp["unit_price"]) for cp in cells if cp.get("unit_price")]
            cellsum[comp] = {
                "cells": len(cells),
                "cell_dim_cols": nonempty,           # 실 단가행이 실제로 쓰는 차원 컬럼
                "declared_use_dims": pcomp.get(comp, {}).get("use_dims"),  # comp 선언 use_dims
                "distinct_siz_cd": sorted({cp.get("siz_cd") for cp in cells if cp.get("siz_cd")}),
                "distinct_opt_cd": sorted({cp.get("opt_cd") for cp in cells if cp.get("opt_cd")}),
                "distinct_min_qty": sorted({cp.get("min_qty") for cp in cells if cp.get("min_qty")},
                                           key=lambda x: (float(x) if x else 0)),
                "price_min": min(prices) if prices else None,
                "price_max": max(prices) if prices else None,
                "master_note": pcomp.get(comp, {}).get("note"),
                "comp_nm": pcomp.get(comp, {}).get("comp_nm"),
            }

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "min_qty", "max_qty", "qty_incr",
                     "qty_unit_typ_cd", "file_upload_yn", "editor_yn", "use_yn", "del_yn",
                     "output_paper_typ_cd", "nonspec_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "cat_lvl": cat.get(r["cat_cd"], {}).get("cat_lvl"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd"),
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
        "sets_parent": sets_parent, "sets_child": sets_child,
        "constraints": [{"rule_cd": r["rule_cd"], "rule_nm": r["rule_nm"],
                         "rule_typ_cd": r.get("rule_typ_cd"), "logic": r.get("logic"),
                         "err_msg": r.get("err_msg"), "use_yn": r.get("use_yn")} for r in cons],
        "option_groups": [{"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                           "sel_typ_cd": r["sel_typ_cd"], "min_sel_cnt": r.get("min_sel_cnt"),
                           "max_sel_cnt": r.get("max_sel_cnt"), "mand_yn": r.get("mand_yn"),
                           "disp_seq": r.get("disp_seq"), "note": r.get("note") or ""} for r in grps],
        "options": [{"opt_cd": r["opt_cd"], "opt_grp_cd": r["opt_grp_cd"], "opt_nm": r["opt_nm"],
                     "dflt_yn": r.get("dflt_yn"), "disp_seq": r.get("disp_seq")} for r in opts],
        "option_items": [{"opt_cd": r["opt_cd"], "item_seq": r.get("item_seq"),
                          "ref_dim_cd": r.get("ref_dim_cd"), "ref_key1": r.get("ref_key1"),
                          "qty": r.get("qty")} for r in items],
        "formulas": fbind,
        "formula_master": {f: {"frm_nm": frm_master.get(f, {}).get("frm_nm"),
                               "use_yn": frm_master.get(f, {}).get("use_yn")} for f in fbind},
        "wiring": wiring, "cellsum": cellsum,
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000133"))
    o.append("| prd_nm | prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_nm']} | {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} | {p['del_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | lvl | 상위 | main_cat_yn |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["cat_lvl"]} | {r["upr_cat_cd"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 치수 (이산 규격·nonspec_yn=N·전사)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes (del_yn=N·master_del 별도 검출)"))
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | dflt | master_del_yn |")
    o.append("|---|---|---|---|---|---|")
    for s, v in d["size_dims"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["dflt"]} | {v["master_del"]} |')

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
    o.append(f"\n> 활성 판형(del_yn=N) **{n_active}행** — 비종이류(캔버스 대형 롤)라 판형 무의미(pack §3.8·T-7). 3행 전부 파일사양 논리삭제.")

    o.append("\n### 제약규칙 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_constraints"))
    o.append(f"제약규칙 **{len(d['constraints'])}행** — 133은 실사 constraints 발현 7상품(118/120/121/122/124/125/139) 밖(pack §3.9·정합).")

    o.append("\n### 옵션그룹·옵션·아이템 (전사)\n")
    o.append(_tb("t_prd_product_option_groups+options+option_items"))
    for g in d["option_groups"]:
        o.append(f'\n**{g["opt_grp_cd"]} {g["opt_grp_nm"]}** (sel={g["sel_typ_cd"]}·min/max={g["min_sel_cnt"]}/{g["max_sel_cnt"]}·mand={g["mand_yn"]}·disp={g["disp_seq"]}·note:{g["note"]})')
        o.append("| opt_cd | opt_nm | dflt | disp | ref_dim_cd | ref_key1 | qty |")
        o.append("|---|---|---|---|---|---|---|")
        for op in [x for x in d["options"] if x["opt_grp_cd"] == g["opt_grp_cd"]]:
            it = next((x for x in d["option_items"] if x["opt_cd"] == op["opt_cd"]), {})
            o.append(f'| {op["opt_cd"]} | {op["opt_nm"]} | {op["dflt_yn"]} | {op["disp_seq"]} | {it.get("ref_dim_cd","")} | {it.get("ref_key1","")} | {it.get("qty","")} |')
    o.append("\n> ★OPT_000012 추가의 옵션값(출력만 OPV_000030·우드행거+면끈 OPV_000429)은 option_items 행이 없다(ref_dim 없음). 우드행거 가격은 공식 구성요소 COMP_POSTEROPT_CANVAS_HANGING_WOODHANGER의 (opt_cd,siz_cd) 단가행으로 표현(아래 배선).")

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("t_prd_product_bundle_qtys/addons/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| sets(부모 셋트) | {len(d['sets_parent'])} |")
    o.append(f"| sets(구성원) | {len(d['sets_child'])} |")
    o.append("\n> ★addon=0 — 133은 pack §3.12 '부속붙는 8상품'이나 우드행거(PRD_000014·기성 PRD_TYPE.03) addon 재연결 미적재(GAP 잔존). 현재는 CPQ 옵션(OPT_000012)+단가행으로만 부속 표현.")

    o.append("\n### 가격 배선 PRF_POSTER_CANVAS_HANGING (전사)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    for f in d["formulas"]:
        fm = d["formula_master"][f]
        o.append(f'\n**{f}** — {fm["frm_nm"]} (use_yn={fm["use_yn"]})')
        o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_typ | comp_nm | use_dims(선언) |")
        o.append("|---|---|---|---|---|---|---|")
        for r in d["wiring"][f]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 단가행 요약 (★고정가·접기·값 나열 아님·D-22·L-12·pack §3.11)\n")
    o.append(_tb("t_prc_component_prices (comp별 count/dim키/range 요약)"))
    o.append("| comp_cd | 단가셀수 | 선언 use_dims | 실 셀 차원컬럼 | siz_cd | opt_cd | min_qty | 단가 min | 단가 max |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    for comp, m in d["cellsum"].items():
        o.append(f'| {comp} | {m["cells"]} | `{m["declared_use_dims"]}` | `{m["cell_dim_cols"]}` | {m["distinct_siz_cd"]} | {m["distinct_opt_cd"]} | {m["distinct_min_qty"]} | {m["price_min"]} | {m["price_max"]} |')
    o.append("\n> ★고정가형 = [규격(siz_cd)×수량(min_qty)] 단가행(면적매트릭스의 siz_width×siz_height 아님). 값 전건은 KB에 나열하지 않고 count/range로 접는다(D-22). 값 계산=evaluate_price(가격 경계 D-18).")
    o.append("> ★[선언≠셀키 불일치] COMP_POSTER_CANVAS_HANGING의 comp 선언 use_dims=[siz_width,siz_height,min_qty](면적템플릿)이나 실 단가행은 siz_cd+min_qty 키(고정가·이산 규격). evaluate_price 룩업 정합은 엔진/검증 소관(GAP·양면 신호).")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-133-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
