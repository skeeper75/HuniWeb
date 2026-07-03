#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 린넨 우드봉 족자 PRD_000134 전용.

transcribe_product_126.py(레더아트프린트) 패턴을 계승하되 ★실사 "고정가 룩업형"(fixed) 특성에 맞춘다:
  - ★실사 2모델 중 고정가형(pack §3.10): 면적매트릭스(122/126)와 달리 가격 use_dims=[siz_cd, min_qty]
    (이산 규격 A4/A3/A2 × 수량밴드 룩업)·nonspec_yn=N(자유치수·off-grid 없음).
  - ★비종이류(대형 롤): 판형(plate_size) 무의미 — plate 3행 전부 del_yn=Y(파일사양 JPG·작업사이즈=우드봉
    hem 확장 210x347/297x470/420x644·생산메타·가격축 아님).
  - 공정 = PROC_000080 봉제(린넨 hemming·param 유형/폭·족자제작 PROC_000082 아님·mand N).
  - 자재 = MAT_000184 린넨(MAT_TYPE.05·교정됨 2026-06-14 실사소재.08→.05·현재 라벨 특수소재·pack §1.1/T-2).
  - CPQ = 2 옵션그룹: OPT_000013 가공(봉제 택1·mand Y·OPV_000031→PROC_000080)·OPT_000014 추가(우드봉·mand N).
  - 공식 = PRF_POSTER_LINEN_WOODBONG → COMP_POSTER_LINEN_WOODBONG(base 규격×수량 [siz_cd,min_qty])
    + COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG(우드봉+면끈 추가가·[opt_cd,siz_cd,opt_grp:OPT_000014]).
  - 단가행 = D-22 접기(행수·siz set·min_qty·단가범위·골든만·값 나열 금지).
  - print_options/bundle_qtys/addons/constraints/sets = 0행 실측(우드봉 addon=0 잔존·pack §3.12).

사용:  python3 transcribe_product_134.py            # stdout markdown
       python3 transcribe_product_134.py --json     # cache/transcribed-134-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000134"
SELF = "transcribe_product_134.py"
BASE_COMP = "COMP_POSTER_LINEN_WOODBONG"
OPT_COMP = "COMP_POSTEROPT_LINEN_WOODBONG_WOODBONG"


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
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}

    cats = active(by_prd_all("t_prd_product_categories.csv"))
    psizes = by_prd_all("t_prd_product_sizes.csv")          # del 표기 위해 전 행
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
                "work": f'{_mm(sizes.get(r["siz_cd"],{}).get("work_width"))}x{_mm(sizes.get(r["siz_cd"],{}).get("work_height"))}',
                "dflt": r.get("dflt_plt_yn", ""), "del": r.get("del_yn", "N"),
                "note": r.get("note") or ""}

    # CPQ: 그룹 → 옵션값 → 아이템(ref)
    grp_view = []
    for g in grps:
        gopts = [o for o in opts if o["opt_grp_cd"] == g["opt_grp_cd"]]
        gopts.sort(key=lambda x: (x.get("disp_seq") or ""))
        ov = []
        for o in gopts:
            oitems = [it for it in items if it["opt_cd"] == o["opt_cd"]]
            ov.append({"opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"],
                       "dflt": o.get("dflt_yn"), "disp": o.get("disp_seq"),
                       "items": [{"ref_dim_cd": it.get("ref_dim_cd"), "ref_key1": it.get("ref_key1"),
                                  "ref_key2": it.get("ref_key2"), "qty": it.get("qty")} for it in oitems]})
        grp_view.append({"opt_grp_cd": g["opt_grp_cd"], "opt_grp_nm": g["opt_grp_nm"],
                         "sel_typ_cd": g["sel_typ_cd"], "min": g["min_sel_cnt"], "max": g["max_sel_cnt"],
                         "mand": g["mand_yn"], "disp": g["disp_seq"], "note": g.get("note") or "",
                         "options": ov})

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

    # 고정가 단가행 요약 (D-22 접기 — 값 나열 금지·행수/siz set/min_qty/단가범위/골든만)
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] in (BASE_COMP, OPT_COMP)]

    def price_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        sizset = sorted({r.get("siz_cd") for r in g if r.get("siz_cd")})
        mqs = sorted({(r.get("min_qty") or "").strip() for r in g})
        optset = sorted({r.get("opt_cd") for r in g if r.get("opt_cd")})
        prices = [float(r["unit_price"]) for r in g if r.get("unit_price")]
        # 골든 = 최대 규격(A2 SIZ_000317) 셀
        golden = next((r for r in g if r.get("siz_cd") == "SIZ_000317"), None)
        return {"rows": len(g), "siz_set": sizset, "min_qty_set": [m for m in mqs if m != ""],
                "opt_set": optset,
                "price_min": min(prices) if prices else None,
                "price_max": max(prices) if prices else None,
                "golden_siz": golden.get("siz_cd") if golden else None,
                "golden_price": _mm(golden.get("unit_price")) if golden else None,
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
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_nm.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": popts,
        "processes": [{"proc_cd": r["proc_cd"], "proc_nm": proc.get(r["proc_cd"], {}).get("proc_nm"),
                       "upr_proc_cd": proc.get(r["proc_cd"], {}).get("upr_proc_cd"),
                       "mand": r.get("mand_proc_yn")} for r in procs],
        "plates": [plate_row(r) for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons,
        "option_groups": grp_view, "sets_parent": sets_parent,
        "formulas": fbind, "formula_meta": {f: fmeta.get(f, {}) for f in fbind},
        "wiring": wiring,
        "price": {BASE_COMP: price_summary(BASE_COMP), OPT_COMP: price_summary(OPT_COMP)},
    }


def _tb(what):
    return f"<!-- transcribed-by: _meta/scripts/{SELF} from {SNAP_ID} {what} @ {STAMP} -->"


def md(d):
    o = []
    p = d["product"]
    o.append("### 상품 정체·수량 (전사)\n")
    o.append(_tb("t_prd_products PRD_000134"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 부모 | lvl | main_cat_yn |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"]} | {r["cat_lvl"]} | {r["main_cat_yn"]} |')

    o.append("\n### 사이즈 (전사·전 행·del 표기 — 이산 규격 A4/A3/A2·가격키 siz_cd)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|")
    for r in d["sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["dflt"]} | {r["link_del"]} | {r["master_del"]} |')

    o.append("\n### 자재 (전사)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | usage_cd | dflt |")
    o.append("|---|---|---|---|---|")
    for r in d["materials"]:
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {r["usage_cd"]} | {r["dflt_yn"]} |')

    o.append("\n### 공정 (전사 — 봉제·족자제작 아님)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 상위공정 | mand |")
    o.append("|---|---|---|---|")
    for r in d["processes"]:
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {r["upr_proc_cd"]} | {r["mand"]} |')

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·작업사이즈=우드봉 hem 생산메타)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | 작업(mm) | dflt | del | note |")
    o.append("|---|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["work"]} | {r["dflt"]} | {r["del"]} | {r["note"]} |')

    o.append("\n### CPQ 옵션그룹·옵션·아이템 (전사)\n")
    o.append(_tb("t_prd_product_option_groups+options+option_items"))
    for g in d["option_groups"]:
        o.append(f'\n**{g["opt_grp_cd"]} {g["opt_grp_nm"]}** (sel={g["sel_typ_cd"]}·min/max={g["min"]}/{g["max"]}·mand={g["mand"]}·disp={g["disp"]}·note:{g["note"]})')
        o.append("| opt_cd | opt_nm | dflt | disp | ref_dim_cd | ref_key1 | qty |")
        o.append("|---|---|---|---|---|---|---|")
        for ov in g["options"]:
            if ov["items"]:
                for it in ov["items"]:
                    o.append(f'| {ov["opt_cd"]} | {ov["opt_nm"]} | {ov["dflt"]} | {ov["disp"]} | {it["ref_dim_cd"]} | {it["ref_key1"]} | {it["qty"]} |')
            else:
                o.append(f'| {ov["opt_cd"]} | {ov["opt_nm"]} | {ov["dflt"]} | {ov["disp"]} | (없음) | (없음) | - |')

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("print_options/bundle_qtys/addons/constraints/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| print_options(도수) | {len(d['print_options'])} |")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| sets(셋트 부모) | {len(d['sets_parent'])} |")

    o.append("\n### 가격 배선 (전사·priced_by→공식→구성요소·★고정가 룩업형)\n")
    o.append(_tb("t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components"))
    for frm in d["formulas"]:
        fm = d["formula_meta"].get(frm, {})
        o.append(f'\n공식 **{frm}** — {fm.get("frm_nm","")} (use_yn={fm.get("use_yn","")})')
        o.append("| disp_seq | comp_cd | addtn | prc_typ | comp_nm | use_dims |")
        o.append("|---|---|---|---|---|---|")
        for r in d["wiring"][frm]:
            o.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} | `{r["use_dims"]}` |')

    o.append("\n### 고정가 단가행 요약 (전사·D-22 접기 — 값 나열 금지·행수/축/범위/골든만)\n")
    o.append(_tb("t_prc_component_prices (COMP_POSTER_LINEN_WOODBONG / COMP_POSTEROPT_..._WOODBONG 집계)"))
    o.append("| comp_cd | use_yn | 행수 | siz set | min_qty | opt set | 단가범위 | 골든(A2) |")
    o.append("|---|---|---|---|---|---|---|---|")
    for c in (BASE_COMP, OPT_COMP):
        g = d["price"][c]
        ss = "/".join(g["siz_set"]) if g["siz_set"] else "-"
        mq = "/".join(g["min_qty_set"]) if g["min_qty_set"] else "(공란)"
        os_ = "/".join(g["opt_set"]) if g["opt_set"] else "-"
        pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
        gd = f'{g["golden_siz"]}={g["golden_price"]}' if g["golden_siz"] else "-"
        o.append(f'| {c} | {g["use_yn"]} | {g["rows"]} | {ss} | {mq} | {os_} | {pr} | {gd} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-134-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
