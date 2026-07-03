#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 유광아크릴스티커 PRD_000142 전용.

transcribe_product_130.py(포맥스보드·고정가 룩업) 패턴을 계승하되 아크릴스티커 특성에 맞춘다.

  - ★가격모델=고정가 룩업(fixed): COMP_POSTER_ACRYLSTK_GLOSS·use_dims=[siz_cd]**단일축**·수량축 없음
    (min_qty NULL·mat_cd NULL·색상 무관 통가격). 130(포맥스 [mat_cd,siz_cd] 2축)보다 얕은 1축 룩업.
    셀단가=아크릴스티커 완제품 통가격(소재+출력+가공 포함)·가격표 verbatim(comp note).
    ★값(unit_price)은 노드에 기록 안 함(D-18·값=evaluate_price) — 전사 evidence 표엔 range만(shape 증거).
  - ★소재=화이트/블랙 2종(MAT_000255/256·MAT_TYPE.08 실사소재·parent 없음). ★[정직 관찰] 둘 다
    마스터 del_yn=Y(06-16 논리삭제)인데 상품링크(product_materials)는 del_yn=N 활성 = 불일치(127 MAT_000188 선례).
    색상 CPQ 옵션(OPT_000069)이 이 두 자재를 OPT_REF_DIM.03으로 참조. 색상은 가격 무관(use_dims에 mat_cd 없음).
  - ★공정=0행. 아크릴스티커 인쇄방식=UV PROC_000002(레이저커팅 라인·pack §3.7)이나 라이브 공정 행 부재
    (실사 공통 po/proc=0·정당) = GAP-SL-A(UV 라우팅 공정 행 추가 여부·영향 작음).
  - ★비종이류(아크릴): 판형(plate_size) 무의미 — plate 4행(SIZ_000324~327) 전부 del_yn=Y(06-30 정리)·
    output_paper_typ 공백(파일사양 placeholder·output_file=AI). fn_best_plate/fn_calc_pansu 적용 금지(§3.8·T-7).
  - ★수량=min/max/qty_incr **전부 공백**(제품 레벨·GAP-SL-8). 130(1/10000/1 명시)과 차이·L1 원본 빈값 정합.
  - print_options/bundle_qtys/addons/constraints/sets = 0행(실측). option_groups=1(색상).
  - 카테고리 = CAT_000092(시트커팅/스티커·lvl2·upr CAT_000005·main_cat_yn=N) + CAT_000005(사인·root·main=Y·142 주분류).
  - 사이즈 = SIZ_000324~327 이산 규격 4종(290x90/290x190/390x290/590x390·nonspec_yn=N·연속범위 없음).

사용:  python3 transcribe_product_142.py            # stdout markdown
       python3 transcribe_product_142.py --json     # cache/transcribed-142-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000142"
SELF = "transcribe_product_142.py"
FIXED_COMP = "COMP_POSTER_ACRYLSTK_GLOSS"


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
    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat_nm = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc_nm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = active(by_prd_all("t_prd_product_categories.csv"))
    psizes = by_prd_all("t_prd_product_sizes.csv")           # del 표기 위해 전 행
    mats = active(by_prd_all("t_prd_product_materials.csv"))  # 링크 활성만
    popts = active(by_prd_all("t_prd_product_print_options.csv"))
    procs = active(by_prd_all("t_prd_product_processes.csv"))
    plates = by_prd_all("t_prd_product_plate_sizes.csv")     # del 표기 위해 전 행
    bqty = active(by_prd_all("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd_all("t_prd_product_addons.csv"))
    cons = active(by_prd_all("t_prd_product_constraints.csv"))
    grps = active(by_prd_all("t_prd_product_option_groups.csv"))
    opts = active(by_prd_all("t_prd_product_options.csv"))
    oitems = active(by_prd_all("t_prd_product_option_items.csv"))
    sets_parent = active([r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD])

    def size_row(r):
        s = sizes.get(r["siz_cd"], {})
        return {"siz_cd": r["siz_cd"], "siz_nm": s.get("siz_nm", "?"),
                "work": f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}',
                "link_del": r.get("del_yn", "N"), "master_del": s.get("del_yn", "?"),
                "dflt": r.get("dflt_yn", "")}

    def mat_row(r):
        m = mat_nm.get(r["mat_cd"], {})
        return {"mat_cd": r["mat_cd"], "mat_nm": m.get("mat_nm", "?"),
                "mat_typ_cd": m.get("mat_typ_cd", "?"), "upr_mat_cd": m.get("upr_mat_cd") or "",
                "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"],
                "link_del": r.get("del_yn", "N"), "master_del": m.get("del_yn", "?")}

    def plate_row(r):
        return {"siz_cd": r["siz_cd"],
                "output_paper_typ_cd": r.get("output_paper_typ_cd") or "",
                "output_file_typ": r.get("output_file_typ") or "",
                "dflt": r.get("dflt_plt_yn", ""), "del": r.get("del_yn", "N"),
                "note": r.get("note") or ""}

    # 옵션 레이어(색상 → 자재 참조) 요약
    opt_by_grp = {}
    for o in opts:
        opt_by_grp.setdefault(o["opt_grp_cd"], []).append(o)
    item_by_opt = {}
    for it in oitems:
        item_by_opt.setdefault(it["opt_cd"], []).append(it)

    option_layer = []
    for g in grps:
        gopts = []
        for o in opt_by_grp.get(g["opt_grp_cd"], []):
            items = [{"ref_dim_cd": it.get("ref_dim_cd"), "ref_key1": it.get("ref_key1"),
                      "ref_key2": it.get("ref_key2"), "qty": it.get("qty")}
                     for it in item_by_opt.get(o["opt_cd"], [])]
            gopts.append({"opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"],
                          "dflt_yn": o["dflt_yn"], "items": items})
        option_layer.append({"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g["opt_grp_nm"],
                             "sel_typ_cd": g["sel_typ_cd"], "mand_yn": g["mand_yn"],
                             "min_sel": g.get("min_sel_cnt"), "max_sel": g.get("max_sel_cnt"),
                             "options": gopts})

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

    # 고정가 룩업 셀 요약 (D-22 접기 — siz_cd 단일축·값은 range shape 증거만)
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == FIXED_COMP]

    def fixed_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        sset = sorted({r.get("siz_cd") for r in g if r.get("siz_cd")})
        mset = sorted({r.get("mat_cd") for r in g if r.get("mat_cd")})
        qset = sorted({r.get("min_qty") for r in g if r.get("min_qty")})
        prices = [float(r["unit_price"]) for r in g if r.get("unit_price")]
        cells = sorted({r.get("siz_cd") for r in g})
        return {"rows": len(g), "sizes": sset, "mats": mset, "qtys": qset,
                "cells_present": len(cells),
                "price_min": min(prices) if prices else None,
                "price_max": max(prices) if prices else None,
                "use_yn": pcomp.get(comp, {}).get("use_yn"),
                "use_dims": pcomp.get(comp, {}).get("use_dims"),
                "comp_nm": pcomp.get(comp, {}).get("comp_nm")}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD, "generated_by": SELF},
        "product": {k: prod.get(k) for k in
                    ["prd_cd", "prd_nm", "prd_typ_cd", "nonspec_yn",
                     "min_qty", "max_qty", "qty_incr", "qty_unit_typ_cd",
                     "file_upload_yn", "editor_yn", "use_yn", "del_yn"]},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm"),
                        "upr_cat_cd": cat.get(r["cat_cd"], {}).get("upr_cat_cd"),
                        "cat_lvl": cat.get(r["cat_cd"], {}).get("cat_lvl"),
                        "main_cat_yn": r["main_cat_yn"]} for r in cats],
        "sizes": [size_row(r) for r in psizes],
        "materials": [mat_row(r) for r in mats],
        "print_options": popts,
        "processes": procs,
        "plates": [plate_row(r) for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons,
        "option_groups": grps, "option_layer": option_layer, "sets_parent": sets_parent,
        "formulas": fbind, "formula_meta": {f: fmeta.get(f, {}) for f in fbind},
        "wiring": wiring,
        "grid": {FIXED_COMP: fixed_summary(FIXED_COMP)},
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000142"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    def blank(v): return v if v not in (None, "") else "(공백)"
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {blank(p['min_qty'])} | {blank(p['max_qty'])} | {blank(p['qty_incr'])} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {blank(p['editor_yn'])} | {p['use_yn']} |")
    o.append("\n> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 4종만). ★min/max/qty_incr **전부 공백**(GAP-SL-8·제품 레벨 수량 미설정).")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 부모 | lvl | main_cat_yn |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"]} | {r["cat_lvl"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 (전사·전 행·del 표기·nonspec_yn=N 이산 4종)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|")
    for r in d["sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["dflt"]} | {r["link_del"]} | {r["master_del"]} |')

    o.append("\n### 자재 (전사·화이트/블랙·MAT_TYPE.08 실사소재·★마스터 del_yn=Y 불일치)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["upr_mat_cd"] or "(없음)"} | {r["usage_cd"]} | {r["dflt_yn"]} | {r["link_del"]} | {r["master_del"]} |')
    o.append("\n> ★MAT_000255(화이트)·MAT_000256(블랙) 둘 다 **마스터 del_yn=Y**(06-16 논리삭제)인데 상품링크는 del_yn=N 활성 = 불일치(127 MAT_000188 선례·정직 관찰). 색상 CPQ 옵션이 이 두 자재를 참조.")

    o.append("\n### 공정 (전사·★0행 — 아크릴 UV PROC_000002 라우팅 미적재 GAP-SL-A)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append(f"| 공정 행수 | {len(d['processes'])} |")
    o.append("|---|---|")
    o.append("\n> 아크릴스티커 인쇄방식=UV PROC_000002(레이저커팅 라인·pack §3.7)이나 라이브 공정 행 부재(실사 공통 proc=0·정당). GAP-SL-A(UV 라우팅 공정 행 추가 여부·영향 작음).")

    o.append("\n### 옵션 레이어 (전사·색상 CPQ 그룹·화이트/블랙→자재 참조)\n")
    o.append(_tb("t_prd_product_option_groups+options+option_items"))
    for g in d["option_layer"]:
        o.append(f'\n옵션그룹 **{g["opt_grp_cd"]}** {g["opt_grp_nm"]} (sel={g["sel_typ_cd"]}·min/max={g["min_sel"]}/{g["max_sel"]}·mand={g["mand_yn"]})\n')
        o.append("| opt_cd | 옵션값 | dflt | ref_dim_cd | ref_key1(자재) | ref_key2 | qty |")
        o.append("|---|---|---|---|---|---|---|")
        for op in g["options"]:
            if op["items"]:
                for it in op["items"]:
                    o.append(f'| {op["opt_cd"]} | {op["opt_nm"]} | {op["dflt_yn"]} | {it["ref_dim_cd"]} | {it["ref_key1"]} | {it["ref_key2"]} | {it["qty"]} |')
            else:
                o.append(f'| {op["opt_cd"]} | {op["opt_nm"]} | {op["dflt_yn"]} | (참조 없음) | | | |')
    o.append("\n> OPT_REF_DIM.03=자재 참조. 색상(화이트/블랙)이 자재 MAT_000255/256을 가리킴(R11 option_refs·부모 142 uses_material 실재). ★색상은 **가격 무관**(구성요소 use_dims=[siz_cd]에 mat_cd 없음·4셀 색상 불문 동일가).")

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·전부 del_yn=Y)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del"]} | {r["note"]} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("print_options/bundle_qtys/addons/constraints/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| print_options(도수) | {len(d['print_options'])} |")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| sets(셋트 부모) | {len(d['sets_parent'])} |")

    o.append("\n### 가격 배선 (전사·priced_by→공식→구성요소)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    for frm in d["formulas"]:
        fm = d["formula_meta"].get(frm, {})
        o.append(f'\n공식 **{frm}** — {fm.get("frm_nm","")} (use_yn={fm.get("use_yn","")})\n')
        o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
        o.append("|---|---|---|---|---|---|")
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 고정가 룩업 셀 요약 (전사·D-22 접기 — 전개 금지·값=range shape 증거만·개별값 미노출)\n")
    o.append(_tb("t_prc_component_prices (COMP_POSTER_ACRYLSTK_GLOSS 집계)"))
    o.append("| comp_cd | use_yn | 행수 | 사이즈축(개수) | mat축 | 수량축 | 셀존재 | 단가범위(shape) | use_dims |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    g = d["grid"][FIXED_COMP]
    sizes_lbl = "/".join(g["sizes"]) if g["sizes"] else "-"
    pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
    mats_lbl = "/".join(g["mats"]) if g["mats"] else "NULL(색상무관)"
    qty_lbl = "/".join(g["qtys"]) if g["qtys"] else "NULL(수량무관)"
    o.append(f'| {FIXED_COMP} | {g["use_yn"]} | {g["rows"]} | {len(g["sizes"])}({sizes_lbl}) | {mats_lbl} | {qty_lbl} | {g["cells_present"]}/{len(g["sizes"])} | {pr} | `{g["use_dims"]}` |')
    o.append("\n> ★use_dims=[siz_cd] **단일축** 룩업: 사이즈 4종 = 4셀(각 규격 1행·색상/수량 무관·mat_cd·min_qty 전부 NULL).")
    o.append("> 격자완전(유효 4/4·규격당 1셀). 총액=셀단가×수량(수량구간 할인 없음·t_dsc 0행).")
    o.append("> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-142-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
