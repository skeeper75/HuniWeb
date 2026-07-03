#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 포맥스보드 PRD_000130 전용.

transcribe_product_126.py(레더아트프린트·면적매트릭스) 패턴을 계승하되 실사(silsa)
**고정가 룩업형**(fixed-price) 특성에 맞춘다 — 126은 면적매트릭스(siz_width×siz_height)이나
130은 (mat_cd × siz_cd) 고정 룩업이라 grid_summary를 좌표축이 아닌 (자재축×사이즈축)으로 요약한다.

  - ★가격모델=고정가 룩업(fixed): COMP_POSTER_FOMEXBOARD_BOARD·use_dims=[mat_cd, siz_cd]·수량축 없음
    (min_qty NULL·수량구간 할인 없음). 셀단가=포맥스보드 완제품 통가격(소재+출력+가공 포함)·260527 verbatim.
    ★값(unit_price)은 노드에 기록 안 함(D-18·값=evaluate_price) — 전사 evidence 표에는 range만(shape 증거).
  - ★자재=포맥스(화이트) 4종: 두께(3mm/5mm) × 사이즈(A3/A2)를 자재코드에 내장(MAT_000022/023/554/555·
    parent MAT_000021·MAT_TYPE.16 실사부자재). ★[HARD] 실사 레더 .08→.05 crosscut과 무관(130=보드).
  - ★비종이류(보드): 판형(plate_size) 무의미 — 라이브 plate 2행(SIZ_000175/303) 전부 del_yn=Y
    (2026-06-30 정리)·output_paper_typ 공백(파일사양 placeholder). fn_best_plate/fn_calc_pansu 적용 금지.
  - 공정=유광/무광 라미네이팅(PROC_000014/015·상위 013·mand N·del_yn=N) — 118과 달리 재키잉 전 구 코드 유지.
    ★단 option_groups=0행 → 라미 선택 CPQ UI 없음(공정 부착만·가격은 mat×siz 통가격 포함) = GAP 후보.
  - print_options/bundle_qtys/addons/constraints/option_groups/sets = 0행(실측).
  - 카테고리 = CAT_000080(보드액자·부모 CAT_000004 포스터·lvl2·main_cat_yn=N) + CAT_000004(포스터·root·main=Y).
  - 사이즈 = SIZ_000174(A3)·SIZ_000197(A2) 이산 규격(nonspec_yn=N·연속범위 없음).

사용:  python3 transcribe_product_130.py            # stdout markdown
       python3 transcribe_product_130.py --json     # cache/transcribed-130-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000130"
SELF = "transcribe_product_130.py"
FIXED_COMP = "COMP_POSTER_FOMEXBOARD_BOARD"


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
    mats = active(by_prd_all("t_prd_product_materials.csv"))
    popts = active(by_prd_all("t_prd_product_print_options.csv"))
    procs = active(by_prd_all("t_prd_product_processes.csv"))
    plates = by_prd_all("t_prd_product_plate_sizes.csv")     # del 표기 위해 전 행
    bqty = active(by_prd_all("t_prd_product_bundle_qtys.csv"))
    addons = active(by_prd_all("t_prd_product_addons.csv"))
    cons = active(by_prd_all("t_prd_product_constraints.csv"))
    grps = active(by_prd_all("t_prd_product_option_groups.csv"))
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
        m = proc_nm.get(r["proc_cd"], {})
        return {"proc_cd": r["proc_cd"], "proc_nm": m.get("proc_nm", "?"),
                "upr": m.get("upr_proc_cd") or "", "mand": r.get("mand_proc_yn", ""),
                "link_del": r.get("del_yn", "N")}

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
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == FIXED_COMP]

    def fixed_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        mset = sorted({r.get("mat_cd") for r in g if r.get("mat_cd")})
        sset = sorted({r.get("siz_cd") for r in g if r.get("siz_cd")})
        prices = [float(r["unit_price"]) for r in g if r.get("unit_price")]
        # (mat_cd, siz_cd) 조합 존재 여부 — 격자완전성 판정(값은 미노출)
        cells = sorted({(r.get("mat_cd"), r.get("siz_cd")) for r in g})
        return {"rows": len(g), "mats": mset, "sizes": sset,
                "cells_present": len(cells),
                "combos_potential": len(mset) * len(sset),
                "price_min": min(prices) if prices else None,
                "price_max": max(prices) if prices else None,
                "use_yn": pcomp.get(comp, {}).get("use_yn"),
                "use_dims": pcomp.get(comp, {}).get("use_dims"),
                "comp_nm": pcomp.get(comp, {}).get("comp_nm"),
                "mat_labels": {m: mat_nm.get(m, {}).get("mat_nm") for m in mset}}

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
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_nm.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "upr_mat_cd": mat_nm.get(r["mat_cd"], {}).get("upr_mat_cd"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": popts,
        "processes": [proc_row(r) for r in procs],
        "plates": [plate_row(r) for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons,
        "option_groups": grps, "sets_parent": sets_parent,
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
    o.append(_tb("t_prd_products PRD_000130"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")
    o.append("\n> nonspec_yn=N → 비규격 연속범위 없음(이산 규격 A3/A2만). 수량 min1/max10000/incr1(제품 레벨).")

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

    o.append("\n### 자재 (전사·★두께×사이즈 내장·MAT_TYPE.16 실사부자재)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt |")
    o.append("|---|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["upr_mat_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### 공정 (전사·라미네이팅·mand N)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 상위공정 | mand | 링크 del |")
    o.append("|---|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr"]} | {r["mand"]} | {r["link_del"]} |')

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del"]} | {r["note"]} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("print_options/bundle_qtys/addons/constraints/option_groups/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| print_options(도수) | {len(d['print_options'])} |")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| option_groups(CPQ 옵션) | {len(d['option_groups'])} |")
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
    o.append(_tb("t_prc_component_prices (COMP_POSTER_FOMEXBOARD_BOARD 집계)"))
    o.append("| comp_cd | use_yn | 행수 | 자재축(개수) | 사이즈축 | 셀존재/잠재 | 단가범위(shape) | use_dims |")
    o.append("|---|---|---|---|---|---|---|---|")
    g = d["grid"][FIXED_COMP]
    mats_lbl = "/".join(g["mats"]) if g["mats"] else "-"
    sizes_lbl = "/".join(g["sizes"]) if g["sizes"] else "-"
    pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
    o.append(f'| {FIXED_COMP} | {g["use_yn"]} | {g["rows"]} | {len(g["mats"])}({mats_lbl}) | {sizes_lbl} | {g["cells_present"]}/{g["combos_potential"]} | {pr} | `{g["use_dims"]}` |')
    o.append("\n> ★셀존재/잠재=4/8: 자재 4종 × 사이즈 2종 = 8 잠재조합이나, **자재코드가 사이즈를 내장**")
    o.append("> (3mm-A3/5mm-A3=SIZ_000174·3mm-A2/5mm-A2=SIZ_000197)이라 유효 격자는 **두께2 × 사이즈2 = 4셀**")
    o.append("> (각 자재의 내장 사이즈와 siz_cd 일치행만 실재). 격자완전(유효 4/4)·수량축 없음(min_qty NULL).")
    o.append("> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-130-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
