#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — 메쉬배너 PRD_000137 전용.

transcribe_product_130.py(포맥스보드·고정가 (mat_cd×siz_cd) 룩업) 패턴을 계승하되
메쉬배너의 **고정가 (siz_cd×min_qty) 룩업**(규격×수량구간 블록)과 CPQ 옵션 레이어에 맞춘다.

  - ★가격모델=고정가 룩업(fixed): COMP_POSTER_MESH_BANNER·use_dims=[siz_cd, min_qty]·규격×수량구간
    블록(pack §3.10 고정가형 15상품 B29). ★값(unit_price)은 노드에 기록 안 함(D-18·값=evaluate_price) —
    전사 evidence 표에는 range(shape)만.
  - ★자재=메쉬 MAT_000183(MAT_TYPE.08 실사소재·미교정·upr 공백·USAGE.07)= **128 메쉬프린트가 canonical
    정의**한 공유 노드(material-MAT_000183)를 재사용(여기서 재정의 안 함·L-3). .08 미교정 잔존은 128의
    GAP(gap-128-mesh-mattype-correction)이 이미 정직 선언(양면 아님·정정 목표유형 미확정=GAP·pack §3.5·T-2).
    ★[HARD] 실사 자재유형 교정(레더 .08→.05 등) crosscut — 메쉬는 잔존 .08(형제 레더는 교정됨).
  - ★비종이류(배너·대형 롤): 판형(plate_size) 무의미 — 라이브 plate 1행(SIZ_000321) del_yn=Y
    (2026-06-30 정리)·output_paper_typ 공백(파일사양 placeholder). fn_best_plate/fn_calc_pansu 적용 금지.
  - 공정=타공 PROC_000079(4구 아일렛·mand N·prcs_dtl_opt "구수" min1/max8) = axis/processes.md canonical 재사용.
  - CPQ 옵션 레이어 2그룹(130과 차이·실사 CPQ 실재 사례):
      OPT_000020 가공(mand Y·택1)→OPV_000040 4구타공→option_item ref PROC_000079(OPT_REF_DIM.04 공정).
        ★구수 param(min1/max8)은 option_item에 미지정=GAP(GAP-SL-2).
      OPT_000021 추가(mand N·택1)→OPV_000041 거치대없음(option_item 없음)= 배너거치대 template BLOCKED
        (부속 우드거치대 PRD_000012 재연결 대기·addon/set 0행·pack §3.12·GAP-SL-4/5).
  - print_options/bundle_qtys/addons/constraints/sets = 0행(실측). option_groups=2행.
  - 카테고리 = CAT_000315(배너/현수막·lvl2·부모 CAT_000005 사인·신규노드 06-19)만 junction 연결(1행).
  - 사이즈 = SIZ_000321(600x1800mm·이산 단일 규격·nonspec_yn=N·impos_yn=N).

사용:  python3 transcribe_product_137.py            # stdout markdown
       python3 transcribe_product_137.py --json     # cache/transcribed-137-260703.json
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"
PRD = "PRD_000137"
SELF = "transcribe_product_137.py"
FIXED_COMP = "COMP_POSTER_MESH_BANNER"


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
    opts = active(by_prd_all("t_prd_product_options.csv"))
    oitems = active(by_prd_all("t_prd_product_option_items.csv"))
    sets_parent = active([r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD])

    def size_row(r):
        s = sizes.get(r["siz_cd"], {})
        return {"siz_cd": r["siz_cd"], "siz_nm": s.get("siz_nm", "?"),
                "work": f'{_mm(s.get("work_width"))}x{_mm(s.get("work_height"))}',
                "impos_yn": s.get("impos_yn", "?"), "nonspec": prod.get("nonspec_yn"),
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
                "dtl_opt": (m.get("prcs_dtl_opt") or "").replace("\n", " "),
                "link_del": r.get("del_yn", "N")}

    def grp_row(r):
        gopts = [o for o in opts if o["opt_grp_cd"] == r["opt_grp_cd"]]
        return {"opt_grp_cd": r["opt_grp_cd"], "opt_grp_nm": r["opt_grp_nm"],
                "sel_typ_cd": r["sel_typ_cd"], "min_sel": r["min_sel_cnt"],
                "max_sel": r["max_sel_cnt"], "mand_yn": r["mand_yn"],
                "note": r.get("note") or "",
                "options": [{"opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"], "dflt": o["dflt_yn"]}
                            for o in gopts]}

    def item_row(r):
        return {"opt_cd": r["opt_cd"], "item_seq": r["item_seq"],
                "ref_dim_cd": r.get("ref_dim_cd") or "", "ref_key1": r.get("ref_key1") or "",
                "ref_key2": r.get("ref_key2") or "", "qty": r.get("qty") or ""}

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
    # use_dims=[siz_cd, min_qty] → 격자축 = (siz_cd × min_qty)
    cp = active([r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == FIXED_COMP])

    def fixed_summary(comp):
        g = [r for r in cp if r["comp_cd"] == comp]
        sset = sorted({r.get("siz_cd") for r in g if r.get("siz_cd")})
        qset = sorted({r.get("min_qty") for r in g if r.get("min_qty")},
                      key=lambda x: (x in (None, ""), float(x) if x else 0))
        prices = [float(r["unit_price"]) for r in g if r.get("unit_price")]
        cells = sorted({(r.get("siz_cd"), r.get("min_qty")) for r in g})
        return {"rows": len(g), "sizes": sset, "qtys": qset,
                "cells_present": len(cells),
                "combos_potential": len(sset) * len(qset),
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
        "materials": [{"mat_cd": r["mat_cd"], "mat_nm": mat_nm.get(r["mat_cd"], {}).get("mat_nm"),
                       "mat_typ_cd": mat_nm.get(r["mat_cd"], {}).get("mat_typ_cd"),
                       "upr_mat_cd": mat_nm.get(r["mat_cd"], {}).get("upr_mat_cd") or "",
                       "usage_cd": r["usage_cd"], "dflt_yn": r["dflt_yn"]} for r in mats],
        "print_options": popts,
        "processes": [proc_row(r) for r in procs],
        "plates": [plate_row(r) for r in plates],
        "bundle_qty": bqty, "addons": addons, "constraints": cons,
        "option_groups": [grp_row(r) for r in grps],
        "option_items": [item_row(r) for r in oitems],
        "sets_parent": sets_parent,
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
    o.append(_tb("t_prd_products PRD_000137"))
    o.append("| prd_typ_cd | nonspec | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn |")
    o.append("|---|---|---|---|---|---|---|---|---|")
    o.append(f"| {p['prd_typ_cd']} | {p['nonspec_yn']} | {p['min_qty']} | {p['max_qty']} | {p['qty_incr']} | {p['qty_unit_typ_cd']} | {p['file_upload_yn']} | {p['editor_yn']} | {p['use_yn']} |")
    o.append("\n> nonspec_yn=N → 비규격 연속범위 없음(이산 단일 규격 600x1800만). 수량 min1/max10000/incr1(제품 레벨).")

    o.append("\n### 카테고리 (전사)\n")
    o.append(_tb("t_prd_product_categories+t_cat_categories"))
    o.append("| cat_cd | 이름 | 부모 | lvl | main_cat_yn(링크) |")
    o.append("|---|---|---|---|---|")
    for r in d["categories"]:
        o.append(f'| {r["cat_cd"]} | {r["cat_nm"]} | {r["upr_cat_cd"]} | {r["cat_lvl"]} | {r["main_cat_yn"]} |')
    o.append("\n> ★junction 1행(CAT_000315 배너/현수막·lvl2)만. 부모 CAT_000005(사인·root)는 카테고리 계층(upr_cat_cd)이지 junction 링크 아님. CAT_000315는 신규노드(06-19·pack §1.1 신규 314/315·leaf 귀속 정밀도 확인 대상).")

    o.append("\n### 사이즈 (전사·전 행·del 표기·nonspec_yn=N 이산 단일)\n")
    o.append(_tb("t_prd_product_sizes+t_siz_sizes"))
    o.append("| siz_cd | 라벨 | 작업(mm) | impos_yn | nonspec | dflt | 링크 del | 마스터 del |")
    o.append("|---|---|---|---|---|---|---|---|")
    for r in d["sizes"]:
        o.append(f'| {r["siz_cd"]} | {r["siz_nm"]} | {r["work"]} | {r["impos_yn"]} | {r["nonspec"]} | {r["dflt"]} | {r["link_del"]} | {r["master_del"]} |')

    o.append("\n### 자재 (전사·★메쉬 MAT_TYPE.08 미교정·128 canonical 재사용)\n")
    o.append(_tb("t_prd_product_materials+t_mat_materials"))
    o.append("| mat_cd | 이름 | mat_typ | 상위자재 | usage_cd | dflt |")
    o.append("|---|---|---|---|---|---|")
    for r in d["materials"]:
        upr = r["upr_mat_cd"] if r["upr_mat_cd"] else "(공백·부모)"
        o.append(f'| {r["mat_cd"]} | {r["mat_nm"]} | {r["mat_typ_cd"]} | {upr} | {r["usage_cd"]} | {r["dflt_yn"]} |')
    o.append("\n> ★메쉬 MAT_000183 = MAT_TYPE.08 실사소재(미교정 잔존·형제 레더 MAT_000186은 .05 교정됨). DB note '→원단(.05)'는 MAT_TYPE 코드 개편으로 STALE(pack T-2). material-MAT_000183·GAP은 128 메쉬프린트가 canonical 정의(재정의 안 함·L-3).")

    o.append("\n### 공정 (전사·타공 4구 아일렛·mand N·구수 param)\n")
    o.append(_tb("t_prd_product_processes+t_proc_processes"))
    o.append("| proc_cd | 공정명 | 상위공정 | mand | prcs_dtl_opt(param) | 링크 del |")
    o.append("|---|---|---|---|---|---|")
    for r in d["processes"]:
        upr = r["upr"] if r["upr"] else "(없음)"
        o.append(f'| {r["proc_cd"]} | {r["proc_nm"]} | {upr} | {r["mand"]} | `{r["dtl_opt"]}` | {r["link_del"]} |')

    o.append("\n### 판형 (전사·전 행·del 표기 — ★비종이류=판형 무의미·del_yn=Y)\n")
    o.append(_tb("t_prd_product_plate_sizes"))
    o.append("| siz_cd | output_paper_typ | output_file | dflt | del | note |")
    o.append("|---|---|---|---|---|---|")
    for r in d["plates"]:
        opt = r["output_paper_typ_cd"] if r["output_paper_typ_cd"] else "(공백)"
        o.append(f'| {r["siz_cd"]} | {opt} | {r["output_file_typ"]} | {r["dflt"]} | {r["del"]} | {r["note"]} |')

    o.append("\n### CPQ 옵션 레이어 (전사·★130과 차이·2그룹)\n")
    o.append(_tb("t_prd_product_option_groups+t_prd_product_options"))
    o.append("| opt_grp_cd | 그룹명 | sel_typ | min/max_sel | mand | 옵션값(opt_cd·dflt) | 그룹 note |")
    o.append("|---|---|---|---|---|---|---|")
    for g in d["option_groups"]:
        ov = " / ".join(f'{o["opt_nm"]}({o["opt_cd"]}·dflt={o["dflt"]})' for o in g["options"])
        o.append(f'| {g["opt_grp_cd"]} | {g["opt_grp_nm"]} | {g["sel_typ_cd"]} | {g["min_sel"]}/{g["max_sel"]} | {g["mand_yn"]} | {ov} | {g["note"]} |')

    o.append("\n### CPQ 옵션 아이템 (전사·다형참조 ref_dim_cd)\n")
    o.append(_tb("t_prd_product_option_items"))
    o.append("| opt_cd | item_seq | ref_dim_cd | ref_key1 | ref_key2 | qty |")
    o.append("|---|---|---|---|---|---|")
    if d["option_items"]:
        for r in d["option_items"]:
            o.append(f'| {r["opt_cd"]} | {r["item_seq"]} | {r["ref_dim_cd"]} | {r["ref_key1"]} | {r["ref_key2"] or "-"} | {r["qty"]} |')
    else:
        o.append("| (없음) | - | - | - | - | - |")
    o.append("\n> ★OPV_000040 4구타공 → OPT_REF_DIM.04(공정)·ref_key1=PROC_000079(타공)·qty 1. 구수 param(구수 min1/max8)은 item에 미지정=GAP. ★OPV_000041 거치대없음 → option_item 없음(배너거치대 template BLOCKED·부속 우드거치대 PRD_000012 재연결 대기).")

    o.append("\n### 미보유 축 (전사·0행 실측)\n")
    o.append(_tb("print_options/bundle_qtys/addons/constraints/sets"))
    o.append("| 축 | 행수 |")
    o.append("|---|---|")
    o.append(f"| print_options(도수) | {len(d['print_options'])} |")
    o.append(f"| bundle_qtys(묶음수) | {len(d['bundle_qty'])} |")
    o.append(f"| addons(추가상품) | {len(d['addons'])} |")
    o.append(f"| constraints(제약규칙) | {len(d['constraints'])} |")
    o.append(f"| sets(셋트 부모) | {len(d['sets_parent'])} |")
    o.append(f"| option_groups(CPQ 옵션) | {len(d['option_groups'])} |")

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
    o.append(_tb("t_prc_component_prices (COMP_POSTER_MESH_BANNER 집계)"))
    o.append("| comp_cd | use_yn | 행수 | 사이즈축 | 수량구간축(min_qty) | 셀존재/잠재 | 단가범위(shape) | use_dims |")
    o.append("|---|---|---|---|---|---|---|---|")
    g = d["grid"][FIXED_COMP]
    sizes_lbl = "/".join(g["sizes"]) if g["sizes"] else "-"
    qtys_lbl = "/".join(g["qtys"]) if g["qtys"] else "-"
    pr = f'{_mm(g["price_min"])}~{_mm(g["price_max"])}' if g["price_min"] is not None else "-"
    o.append(f'| {FIXED_COMP} | {g["use_yn"]} | {g["rows"]} | {sizes_lbl} | {qtys_lbl} | {g["cells_present"]}/{g["combos_potential"]} | {pr} | `{g["use_dims"]}` |')
    o.append("\n> ★셀존재/잠재 = 사이즈 1(SIZ_000321) × 수량구간(min_qty) 조합. use_dims=[siz_cd, min_qty]=규격×수량구간 블록")
    o.append("> (면적매트릭스 아님·siz_width/siz_height 미사용). 수량구간이 min_qty=1 단일 tier면 사실상 수량무관 flat 가격")
    o.append("> (600x1800 수량 1 이상 완제품가·출력+코팅+가공(4구아일렛) 포함가). 격자완전(cells_present=combos_potential).")
    o.append("> 단가범위는 격자 shape 증거일 뿐 — 개별 셀단가·계산=evaluate_price 권위(D-18·값 노드 미기록).")
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        pth = os.path.join(os.path.dirname(__file__), "cache", "transcribed-137-260703.json")
        with open(pth, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", pth)
    else:
        print(md(d))
