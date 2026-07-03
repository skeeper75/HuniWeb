#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 무광시트커팅 PRD_000140 전용.

transcribe_product_130.py(포맥스보드·고정가 룩업) 패턴을 계승하되 무광시트커팅의
실측 구조에 맞춘다 — 130은 (mat_cd × siz_cd) 2축이나 140은 use_dims=[siz_cd] **단일축**
(A4/A3/A2 3셀)이고, 색상(화이트/블랙) 선택이 CPQ 옵션그룹(OPT_000068)으로 자재를 참조한다.

  - ★가격모델=고정가 룩업(fixed): COMP_POSTER_SHEETCUT_MATTE·use_dims=[siz_cd] **단일축**·수량축 없음
    (min_qty NULL·수량구간 할인 없음). 셀단가=무광시트커팅 완제품 통가격(소재+출력+가공 포함)·260527 verbatim.
    ★값(unit_price)은 노드에 기록 안 함(D-18·값=evaluate_price) — 전사 evidence 표에는 range만(shape 증거).
    ★색상(화이트/블랙)은 가격에 무관(use_dims에 mat_cd 없음) — 사이즈만 가격축.
  - ★자재=시트커팅지 2종: MAT_000388(화이트)·MAT_000389(블랙)·parent MAT_000189·MAT_TYPE.19 시트커팅지.
    ★[HARD] 실사 레더 .08→.05 crosscut과 무관(140=시트커팅지 .19 전용소재·레더는 100/126/296/298).
    ★2026-07-01 재키잉: 구 자재 MAT_000255/256(화이트/블랙·MAT_TYPE.08·06-16 del) → MAT_000388/389(.19).
  - ★비종이류(시트): 판형(plate_size) 무의미 — 라이브 plate 3행(SIZ_000050/052/198) 전부 del_yn=Y
    (2026-06-30 정리)·output_paper_typ 공백·output_file=AI(파일사양). fn_best_plate/fn_calc_pansu 적용 금지.
  - 공정=시트커팅 PROC_000125(상위 PROC_000121 커팅·mand_proc_yn=Y·06-29 신설) — 필수 공정 1개.
  - ★option_groups=1행: OPT_000068 색상(SEL_TYPE.01 단일·min1/max1·mand Y). 옵션값 화이트/블랙 →
    option_items가 OPT_REF_DIM.03(자재)로 MAT_000388/389 참조(ref_key1=mat_cd·ref_key2=USAGE.07).
    ★130과 차이: 130은 옵션그룹 0행, 140은 색상 옵션이 자재를 참조하는 라이브 CPQ 옵션 레이어 실례.
  - print_options/bundle_qtys/addons/constraints/sets = 0행(실측). constraints 0=140은 pack §1.1
    신규발현 7상품(118/120/121/122/124/125/139)에 미포함=정당.
  - 카테고리 = CAT_000092(시트커팅/스티커·부모 CAT_000005 사인·lvl2·main_cat_yn=N).
  - 사이즈 = SIZ_000258(A4)·SIZ_000315(A3)·SIZ_000198(A2) 활성(2026-07-01 재키잉)·구 172/174/197 del.

사용:  python3 transcribe_product_140.py            # stdout markdown
       python3 transcribe_product_140.py --json     # cache/transcribed-140-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000140"
SELF = "transcribe_product_140.py"
FIXED_COMP = "COMP_POSTER_SHEETCUT_MATTE"


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
    mats = by_prd_all("t_prd_product_materials.csv")         # del 표기 위해 전 행(재키잉 증거)
    popts = active(by_prd_all("t_prd_product_print_options.csv"))
    procs = active(by_prd_all("t_prd_product_processes.csv"))
    plates = by_prd_all("t_prd_product_plate_sizes.csv")     # del 표기 위해 전 행
    bqty = active(by_prd_all("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd_all("t_prd_product_addons.csv"))
    cons = active(by_prd_all("t_prd_product_constraints.csv"))
    grps = active(by_prd_all("t_prd_product_option_groups.csv"))
    opvs = active(by_prd_all("t_prd_product_options.csv"))
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

    def proc_row(r):
        m = proc_nm.get(r["proc_cd"], {})
        return {"proc_cd": r["proc_cd"], "proc_nm": m.get("proc_nm", "?"),
                "upr": m.get("upr_proc_cd") or "", "mand": r.get("mand_proc_yn", ""),
                "link_del": r.get("del_yn", "N")}

    # 옵션그룹→옵션값→옵션아이템(자재참조) 전사
    opv_by_grp = {}
    for o in opvs:
        opv_by_grp.setdefault(o["opt_grp_cd"], []).append(o)
    item_by_opv = {}
    for it in oitems:
        item_by_opv.setdefault(it["opt_cd"], []).append(it)

    opt_layer = []
    for g in grps:
        gopvs = []
        for o in opv_by_grp.get(g["opt_grp_cd"], []):
            items = [{"ref_dim_cd": it.get("ref_dim_cd"), "ref_key1": it.get("ref_key1"),
                      "ref_key2": it.get("ref_key2"), "qty": it.get("qty")}
                     for it in item_by_opv.get(o["opt_cd"], [])]
            gopvs.append({"opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"],
                          "dflt_yn": o.get("dflt_yn"), "items": items})
        opt_layer.append({"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g["opt_grp_nm"],
                          "sel_typ_cd": g.get("sel_typ_cd"), "min_sel": g.get("min_sel_cnt"),
                          "max_sel": g.get("max_sel_cnt"), "mand_yn": g.get("mand_yn"),
                          "options": gopvs})

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

    # 고정가 룩업 셀 요약 (D-22 접기 — 전개 금지·집계만·값은 range shape 증거만)
    # 140 = use_dims=[siz_cd] 단일축. product 활성 사이즈와 격자 도달 사이즈를 분리 판정.
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == FIXED_COMP]
    active_prd_siz = sorted({r["siz_cd"] for r in psizes if r.get("del_yn", "N") != "Y"})

    def fixed_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        sset = sorted({r.get("siz_cd") for r in g if r.get("siz_cd")})
        prices = [float(r["unit_price"]) for r in g if r.get("unit_price")]
        reachable = sorted(set(active_prd_siz) & set(sset))     # 상품 활성 사이즈 ∩ 격자행
        return {"rows": len(g), "sizes": sset,
                "active_prd_siz": active_prd_siz,
                "reachable_cells": len(reachable), "reachable": reachable,
                "legacy_siz": sorted(set(sset) - set(active_prd_siz)),
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
        "processes": [proc_row(r) for r in procs],
        "plates": [plate_row(r) for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons,
        "option_groups": grps, "opt_layer": opt_layer, "sets_parent": sets_parent,
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
    o.append(_tb("t_prd_products PRD_000140"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")
    o.append("\n> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 A4/A3/A2만). 수량 min1/max10000/incr1(제품 레벨).")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 부모 | lvl | main_cat_yn |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"]} | {r["cat_lvl"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 (전사·전 행·del 표기 — ★2026-07-01 재키잉)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|")
    for r in d["sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["dflt"]} | {r["link_del"]} | {r["master_del"]} |')
    o.append("\n> 구 A4/A3/A2(SIZ_000172/174/197)는 링크 del_yn=Y(2026-07-01 재키잉)·활성=258/315/198(스티커·시트커팅 태그 사이즈).")

    o.append("\n### 자재 (전사·전 행·del 표기 — ★MAT_TYPE.19 시트커팅지·2026-07-01 재키잉)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["upr_mat_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} | {r["link_del"]} | {r["master_del"]} |')
    o.append("\n> 구 자재 MAT_000255/256(화이트/블랙·MAT_TYPE.08·06-16 마스터 del) → MAT_000388/389(시트커팅지 화이트/블랙·.19)로 재키잉.")

    o.append("\n### 공정 (전사·시트커팅·mand Y)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 상위공정 | mand | 링크 del |")
    o.append("|---|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr"]} | {r["mand"]} | {r["link_del"]} |')

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·전부 del_yn=Y)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del"]} | {r["note"]} |')

    o.append("\n### 옵션그룹·옵션값·옵션아이템 (전사·★색상→자재 참조 CPQ 레이어)\n")
    o.append(_tb("t_prd_product_option_groups+options+option_items"))
    for g in d["opt_layer"]:
        o.append(f'\n옵션그룹 **{g["opt_grp_cd"]}** {g["opt_grp_nm"]} (sel={g["sel_typ_cd"]}·min{g["min_sel"]}/max{g["max_sel"]}·mand={g["mand_yn"]})\n')
        o.append("| opt_cd | 옵션값 | dflt | ref_dim | ref_key1(자재) | ref_key2 | qty |")
        o.append("|---|---|---|---|---|---|---|")
        for ov in g["options"]:
            if ov["items"]:
                for it in ov["items"]:
                    o.append(f'| {ov["opt_cd"]} | {ov["opt_nm"]} | {ov["dflt_yn"]} | {it["ref_dim_cd"]} | {it["ref_key1"]} | {it["ref_key2"]} | {it["qty"]} |')
            else:
                o.append(f'| {ov["opt_cd"]} | {ov["opt_nm"]} | {ov["dflt_yn"]} | (item 없음) | - | - | - |')

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
    o.append(_tb("t_prc_component_prices (COMP_POSTER_SHEETCUT_MATTE 집계)"))
    o.append("| comp_cd | use_yn | 격자행 | 사이즈축(격자) | 상품활성사이즈 | 도달셀/활성 | legacy siz | 단가범위(shape) | use_dims |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    g = d["grid"][FIXED_COMP]
    sizes_lbl = "/".join(g["sizes"]) if g["sizes"] else "-"
    aps_lbl = "/".join(g["active_prd_siz"]) if g["active_prd_siz"] else "-"
    legacy_lbl = "/".join(g["legacy_siz"]) if g["legacy_siz"] else "-"
    pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
    o.append(f'| {FIXED_COMP} | {g["use_yn"]} | {g["rows"]} | {sizes_lbl} | {aps_lbl} | {g["reachable_cells"]}/{len(g["active_prd_siz"])} | {legacy_lbl} | {pr} | `{g["use_dims"]}` |')
    o.append("\n> ★use_dims=[siz_cd] **단일축**(130 포맥스보드 [mat_cd,siz_cd]와 다름): 사이즈만 가격축이고 색상")
    o.append("> (화이트/블랙)은 가격 무관(mat_cd 비차원). 상품 활성 사이즈 3(A4 258/A3 315/A2 198)이 격자에")
    o.append("> 전부 도달(도달 3/3 완전격자·수량축 없음·min_qty NULL). legacy siz(172/174/197)=재키잉 잔여")
    o.append("> 격자행(상품이 더 이상 참조 안 함·2026-07-01 dedup rekey→258/315/198). 단가범위는 격자 shape")
    o.append("> 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-140-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
