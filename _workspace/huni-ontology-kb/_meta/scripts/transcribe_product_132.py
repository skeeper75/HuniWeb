#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 레더아트액자 PRD_000132 전용.

transcribe_product_126.py(레더아트프린트·면적매트릭스형) 패턴을 계승하되 실사 **고정가형** 특성에 맞춘다:
  - ★실사 고정가형: 가격 use_dims=[siz_cd, min_qty]·규격(siz_cd) 룩업 단가(면적매트릭스 아님).
    COMP_POSTER_LEATHER_FRAME = 6 사이즈(5x5/5x7/8x8/8x10/A4/A3) 각 1행·min_qty=1 단일 tier·통가격.
  - ★비종이류(대형 롤/액자): 판형(plate_size) 무의미 — 라이브 plate 6행 전부 del_yn=Y(2026-06-30 정리)·output_paper_typ 공백.
  - nonspec_yn=N(규격 preset 전용·손님 자유입력 없음) — 126(nonspec=Y)과 다름.
  - materials = 0행(★레더 소재 미배선·MAT_000186 레더 crosscut 4상품(100/126/296/298)에 132 미포함).
  - print_options/processes/option_groups/bundle_qtys/addons/constraints/sets = 0행.
  - 카테고리 CAT_000080(보드액자·부모 CAT_000004 포스터·lvl2·main_cat_yn=N) 1행.
  - 공식 = PRF_POSTER_LEATHER_FRAME → COMP_POSTER_LEATHER_FRAME(고정가 siz_cd 룩업).
  - 고정가 단가행 = D-22 접기(노드 미전개) → siz_cd축·min_qty tier·단가범위 요약만 전사.

사용:  python3 transcribe_product_132.py            # stdout markdown
       python3 transcribe_product_132.py --json     # cache/transcribed-132-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000132"
SELF = "transcribe_product_132.py"
FIX_COMP = "COMP_POSTER_LEATHER_FRAME"


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
    dscs = active(by_prd_all("t_prd_product_discount_tables.csv"))
    sets_parent = active([r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD])
    sets_member = active([r for r in rd("t_prd_product_sets.csv") if r["sub_prd_cd"] == PRD])

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

    # 고정가 단가행 요약 (D-22 접기 — 전개 금지·집계만·siz_cd 축)
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == FIX_COMP]

    def grid_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        siz = sorted({r["siz_cd"] for r in g if r.get("siz_cd")})
        mq = sorted({r.get("min_qty") or "" for r in g})
        prices = [float(r["unit_price"]) for r in g if r.get("unit_price")]
        return {"rows": len(g), "siz_cds": siz, "min_qtys": mq,
                "price_min": min(prices) if prices else None,
                "price_max": max(prices) if prices else None,
                "use_yn": pcomp.get(comp, {}).get("use_yn"),
                "prc_typ": pcomp.get(comp, {}).get("prc_typ_cd"),
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
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_nm.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": popts, "processes": procs,
        "plates": [plate_row(r) for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons,
        "option_groups": grps, "discount_tables": dscs,
        "sets_parent": sets_parent, "sets_member": sets_member,
        "formulas": fbind, "formula_meta": {f: fmeta.get(f, {}) for f in fbind},
        "wiring": wiring,
        "grid": {FIX_COMP: grid_summary(FIX_COMP)},
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000132"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")
    o.append("\n★nonspec_yn=N — 규격 preset 전용(손님 자유입력 없음·126 nonspec=Y와 다름). 고정가형 실사.")

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

    o.append("\n### 자재 (전사·★0행 실측)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    if d["materials"]:
        o.append("| mat_cd | 이름 | mat_typ | usage_cd | dflt |")
        o.append("|---|---|---|---|---|")
        for r in d["materials"]:
            o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')
    else:
        o.append("| mat_cd | 행수 |")
        o.append("|---|---|")
        o.append("| (없음) | 0 |")
        o.append("\n★자재 0행 — 레더 소재(MAT_000186)가 132에 미배선(레더 crosscut 4상품 100/126/296/298에 132 미포함). 고정가 통가격(소재+출력+가공 포함)에 소재비 흡수 vs 미배선 결함=AMBIGUOUS(GAP).")

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del"]} | {r["note"]} |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("print_options/processes/bundle_qtys/addons/constraints/option_groups/discount_tables/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| print_options(도수) | {len(d['print_options'])} |")
    o.append(f"| processes(공정) | {len(d['processes'])} |")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| option_groups(CPQ 옵션) | {len(d['option_groups'])} |")
    o.append(f"| discount_tables(구간할인) | {len(d['discount_tables'])} |")
    o.append(f"| sets(셋트 부모) | {len(d['sets_parent'])} |")
    o.append(f"| sets(셋트 구성원) | {len(d['sets_member'])} |")

    o.append("\n### 가격 배선 (전사·priced_by→공식→구성요소)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    for frm in d["formulas"]:
        fm = d["formula_meta"].get(frm, {})
        o.append(f'\n공식 **{frm}** — {fm.get("frm_nm","")} (use_yn={fm.get("use_yn","")})\n')
        o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
        o.append("|---|---|---|---|---|---|")
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 고정가 단가행 요약 (전사·D-22 접기 — 전개 금지·집계만·siz_cd 룩업)\n")
    o.append(_tb("t_prc_component_prices (COMP_POSTER_LEATHER_FRAME 집계)"))
    o.append("| comp_cd | use_yn | prc_typ | 행수 | siz_cd 축 | min_qty tier | 단가범위 | comp_nm |")
    o.append("|---|---|---|---|---|---|---|---|")
    g = d["grid"][FIX_COMP]
    s = "/".join(g["siz_cds"]) if g["siz_cds"] else "-"
    mq = "/".join([str(x) for x in g["min_qtys"]]) if g["min_qtys"] else "-"
    pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
    o.append(f'| {FIX_COMP} | {g["use_yn"]} | {g["prc_typ"]} | {g["rows"]} | {s} | {mq} | {pr} | {g["comp_nm"]} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-132-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
