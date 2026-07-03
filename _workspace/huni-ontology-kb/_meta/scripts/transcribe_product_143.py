#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 미러아크릴스티커 PRD_000143 전용.

transcribe_product_130.py(포맥스보드·고정가 룩업) 패턴을 계승하되 미러아크릴스티커(실사 사인·
아크릴스티커) 특성에 맞춘다:
  - ★가격모델=고정가 룩업(fixed): COMP_POSTER_ACRYLSTK_MIRROR·use_dims=[siz_cd]·mat_cd/수량축 없음
    (min_qty NULL·수량구간 할인 없음). 130은 [mat_cd,siz_cd] 2축이나 143은 siz_cd 단일축(4셀=규격4).
    셀단가=미러아크릴스티커 완제품 통가격(소재+출력+가공 포함)·260527 verbatim. ★골드/실버 무관(동일가).
    ★값(unit_price)은 노드에 기록 안 함(D-18·값=evaluate_price) — 전사 evidence 표에는 range만(shape).
  - ★자재 재키잉(★"레더 .08→.06 주의"의 아크릴판): 구 골드 MAT_000258·실버 MAT_000259(MAT_TYPE.08 실사소재)
    = 상품링크 del_yn=Y(07-01 언링크)·마스터 del_yn=Y(06-16). 현행 = 아크릴(골드) MAT_000377·아크릴(실버)
    MAT_000378(MAT_TYPE.20 아크릴·상위 MAT_000195/196·07-01 링크·06-27 마스터 신설). 현재값=.20 아크릴(정합).
  - ★비종이류(아크릴): 판형(plate_size) 무의미 — plate 4행(SIZ_000324~327) 전부 del_yn=Y(06-30 정리)·
    output_paper_typ 공란·output_file=AI(파일사양). fn_best_plate/fn_calc_pansu 적용 금지.
  - 공정 = 레이저커팅 PROC_000124(상위 PROC_000121 커팅·mand_proc_yn=Y·del_yn=N·06-29 신설). 아크릴 절단.
    ★인쇄방식(UV PROC_000002) 공정 행은 라이브 부재(print_options=0) — pack §3.7 UV 라우팅=GAP(Q-SL-A).
  - ★CPQ 옵션그룹 보유(130과 차이): OPT-000046 칼라(SEL_TYPE.01·min0/max1/mand N)·옵션 2(골드아크릴 OPV-000095·
    실버아크릴 OPV-000096)·option_items가 OPT_REF_DIM.03(자재)로 MAT_000377/378 참조(fn_chk_opt_item_ref 정합).
    ★칼라 옵션=자재(골드/실버) 선택이나 가격 무관(use_dims=[siz_cd]·동일가).
  - print_options/bundle_qtys/addons/constraints/sets = 0행(실측).
  - 카테고리 = CAT_000005 사인(root·main_cat_yn=Y·disp_seq 9) + CAT_000092 시트커팅/스티커(lvl2·upr CAT_000005·main=N).
  - 사이즈 = SIZ_000324(290x90)·325(290x190)·326(390x290)·327(590x390) 이산 규격(nonspec_yn=N·연속범위 없음).

사용:  python3 transcribe_product_143.py            # stdout markdown
       python3 transcribe_product_143.py --json     # cache/transcribed-143-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000143"
SELF = "transcribe_product_143.py"
FIXED_COMP = "COMP_POSTER_ACRYLSTK_MIRROR"


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
    mats = by_prd_all("t_prd_product_materials.csv")          # ★재키잉 이력 표기 위해 전 행
    popts = active(by_prd_all("t_prd_product_print_options.csv"))
    procs = active(by_prd_all("t_prd_product_processes.csv"))
    plates = by_prd_all("t_prd_product_plate_sizes.csv")      # del 표기 위해 전 행
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

    def proc_row(r):
        m = proc_nm.get(r["proc_cd"], {})
        return {"proc_cd": r["proc_cd"], "proc_nm": m.get("proc_nm", "?"),
                "upr": m.get("upr_proc_cd") or "", "mand": r.get("mand_proc_yn", ""),
                "link_del": r.get("del_yn", "N")}

    # CPQ 옵션 레이어 (그룹→옵션→아이템)
    grp_meta = {r["opt_grp_cd"]: r for r in grps}
    opt_by_grp = {}
    for o in opts:
        opt_by_grp.setdefault(o["opt_grp_cd"], []).append(o)
    item_by_opt = {}
    for it in oitems:
        item_by_opt.setdefault(it["opt_cd"], []).append(it)

    option_layer = []
    for g in grps:
        gopts = []
        for o in sorted(opt_by_grp.get(g["opt_grp_cd"], []), key=lambda x: x.get("disp_seq") or ""):
            items = [{"item_seq": it.get("item_seq"), "ref_dim_cd": it.get("ref_dim_cd"),
                      "ref_key1": it.get("ref_key1"), "ref_key2": it.get("ref_key2"),
                      "qty": it.get("qty") or ""} for it in item_by_opt.get(o["opt_cd"], [])]
            gopts.append({"opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"],
                          "dflt_yn": o.get("dflt_yn"), "items": items})
        option_layer.append({"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g["opt_grp_nm"],
                             "sel_typ_cd": g.get("sel_typ_cd"), "min_sel_cnt": g.get("min_sel_cnt"),
                             "max_sel_cnt": g.get("max_sel_cnt"), "mand_yn": g.get("mand_yn"),
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

    # 고정가 룩업 셀 요약 (D-22 접기 — use_dims=[siz_cd]·siz 단일축·값은 range shape 증거만)
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == FIXED_COMP]

    def fixed_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        sset = sorted({r.get("siz_cd") for r in g if r.get("siz_cd")})
        mset = sorted({r.get("mat_cd") for r in g if r.get("mat_cd")})
        prices = [float(r["unit_price"]) for r in g if r.get("unit_price")]
        cells = sorted({r.get("siz_cd") for r in g})
        return {"rows": len(g), "sizes": sset, "mats": mset,
                "cells_present": len(cells), "combos_potential": len(sset),
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
    o.append(_tb("t_prd_products PRD_000143"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")
    o.append("\n> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 4종만). 수량 min1/max10000/incr1(제품 레벨).")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 부모 | lvl | main_cat_yn |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"]} | {r["cat_lvl"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 (전사·전 행·del 표기·이산 규격 4종)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|")
    for r in d["sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["dflt"]} | {r["link_del"]} | {r["master_del"]} |')

    o.append("\n### 자재 (전사·전 행·★재키잉 이력: 구 .08 실사소재 → 현행 .20 아크릴)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["upr_mat_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} | {r["link_del"]} | {r["master_del"]} |')
    o.append("\n> ★구 골드 MAT_000258·실버 MAT_000259(MAT_TYPE.08 실사소재)=상품링크 del_yn=Y(07-01 언링크)·마스터 del_yn=Y(06-16).")
    o.append("> 현행 = 아크릴(골드) MAT_000377·아크릴(실버) MAT_000378(MAT_TYPE.20 아크릴·상위 195/196·07-01 링크). 현재값 .20=정합.")

    o.append("\n### 공정 (전사·레이저커팅·mand Y — 아크릴 절단)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 상위공정 | mand | 링크 del |")
    o.append("|---|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr"]} | {r["mand"]} | {r["link_del"]} |')
    o.append("\n> ★인쇄방식(UV PROC_000002) 공정 행은 라이브 부재(print_options=0·도수 없음) — pack §3.7 UV 라우팅=GAP(Q-SL-A).")

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·전부 del_yn=Y)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del"]} | {r["note"]} |')

    o.append("\n### CPQ 옵션 레이어 (전사·★칼라 옵션그룹 — 130과 차이·option_items→자재 참조)\n")
    o.append(_tb("t_prd_product_option_groups+options+option_items"))
    for g in d["option_layer"]:
        o.append(f'\n옵션그룹 **{g["opt_grp_cd"]}** — {g["opt_grp_nm"]} (sel_typ={g["sel_typ_cd"]}·min {g["min_sel_cnt"]}/max {g["max_sel_cnt"]}·mand {g["mand_yn"]})\n')
        o.append("| opt_cd | 옵션명 | dflt | item ref_dim | ref_key1(자재) | ref_key2 |")
        o.append("|---|---|---|---|---|---|")
        for o2 in g["options"]:
            if o2["items"]:
                for it in o2["items"]:
                    o.append(f'| {o2["opt_cd"]} | {o2["opt_nm"]} | {o2["dflt_yn"]} | {it["ref_dim_cd"]} | {it["ref_key1"]} | {it["ref_key2"]} |')
            else:
                o.append(f'| {o2["opt_cd"]} | {o2["opt_nm"]} | {o2["dflt_yn"]} | (아이템 없음) |  |  |')

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
    o.append(_tb("t_prc_component_prices (COMP_POSTER_ACRYLSTK_MIRROR 집계)"))
    o.append("| comp_cd | use_yn | 행수 | 사이즈축(개수) | 자재축 | 셀존재/잠재 | 단가범위(shape) | use_dims |")
    o.append("|---|---|---|---|---|---|---|---|")
    g = d["grid"][FIXED_COMP]
    sizes_lbl = "/".join(g["sizes"]) if g["sizes"] else "-"
    mats_lbl = "/".join(g["mats"]) if g["mats"] else "(없음·siz 단일축)"
    pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
    o.append(f'| {FIXED_COMP} | {g["use_yn"]} | {g["rows"]} | {len(g["sizes"])}({sizes_lbl}) | {mats_lbl} | {g["cells_present"]}/{g["combos_potential"]} | {pr} | `{g["use_dims"]}` |')
    o.append("\n> ★셀존재/잠재=4/4: 사이즈 4종 각 1셀(use_dims=[siz_cd] 단일축·mat_cd 컬럼 공란=골드/실버 동일가).")
    o.append("> 격자완전(유효 4/4)·수량축 없음(min_qty NULL). 130(2축 mat×siz)보다 단순한 siz 단일축 룩업.")
    o.append("> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-143-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
