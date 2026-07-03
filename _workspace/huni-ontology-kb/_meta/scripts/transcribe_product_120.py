#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000120 방수포스터 (실사 파일럿 첫 상품·D-9·§4·[HARD] LLM 손전사 금지).

방수포스터(120)는 실사(포스터/사인) 상품군의 첫 온톨로지 노드다. 이 스크립트는:
  - 상품 상태·수량·비규격(nonspec) 치수범위
  - 사이즈 3행(A3 SIZ_000174 / A2 SIZ_000197 / A1 SIZ_000293·master del_yn) + master 삭제여부
  - 자재(MAT_000178 PET·MAT_TYPE.08)
  - 공정(PROC_000014 유광라미 / PROC_000015 무광라미·둘 다 opt)
  - 인쇄옵션(도수) — 실사는 없음(po=0) 확인
  - 판형(plate) — 06-30 논리삭제·파일사양(비종이류·판형없음) 확인
  - 가격공식→구성요소 배선(PRF_POSTER_WATERPROOF → COMP_POSTER_ARTPRINT_PHOTO 동형결합)
  - 면적매트릭스 SHAPE(값 아님·가로×세로 셀·행수·격자완전·수량밴드)
  - 옵션그룹(OPT_000006 코팅)+옵션값
  - 제약규칙(RULE_001 사용자입력 치수범위·shape 마커)
를 결정론 전사한다(기존 스크립트 범위 밖 → 새 파일 원칙).

★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원"까지만(D-18·값=evaluate_price).
  면적매트릭스는 SHAPE(가로/세로 구간·셀수·격자완전·수량밴드)만 확인한다.

사용:  python3 transcribe_product_120.py            # stdout markdown 블록
       python3 transcribe_product_120.py --json     # cache/transcribed-120-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000120"
SIZES = ["SIZ_000174", "SIZ_000197", "SIZ_000293"]       # A3 / A2 / A1(master del)
MATS = ["MAT_000178"]                                     # PET (MAT_TYPE.08 실사소재)
PROCS = ["PROC_000014", "PROC_000015"]                    # 유광/무광 라미네이팅(둘 다 opt)
FRM = "PRF_POSTER_WATERPROOF"
COMP = "COMP_POSTER_ARTPRINT_PHOTO"                       # 동형결합 4소재 통합(방수 포함)
OPT_GRP = "OPT_000006"                                    # 코팅 택1


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    p = prod.get(PRD, {})
    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv") if r["siz_cd"] in SIZES}
    psiz = {r["siz_cd"]: r for r in rd("t_prd_product_sizes.csv")
            if r["prd_cd"] == PRD and r["siz_cd"] in SIZES}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv") if r["mat_cd"] in MATS}
    pmat = {r["mat_cd"]: r for r in rd("t_prd_product_materials.csv")
            if r["prd_cd"] == PRD and r["mat_cd"] in MATS}
    procm = {r["proc_cd"]: r for r in rd("t_proc_processes.csv") if r["proc_cd"] in PROCS}
    pproc = {r["proc_cd"]: r for r in rd("t_prd_product_processes.csv")
             if r["prd_cd"] == PRD and r["proc_cd"] in PROCS}
    po = [r for r in rd("t_prd_product_print_options.csv") if r["prd_cd"] == PRD]
    plate = [r for r in rd("t_prd_product_plate_sizes.csv") if r["prd_cd"] == PRD]
    fc = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == FRM]
    compdef = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv") if r["comp_cd"] == COMP}
    # 면적매트릭스 SHAPE — 값(unit_price) 미전사
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP]
    widths = sorted({r["siz_width"] for r in cp if r["siz_width"]}, key=lambda x: float(x))
    heights = sorted({r["siz_height"] for r in cp if r["siz_height"]}, key=lambda x: float(x))
    bands = sorted({r["min_qty"] for r in cp if r["min_qty"]})
    cells = {(r["siz_width"], r["siz_height"]) for r in cp}
    # 옵션그룹 + 옵션값
    og = [r for r in rd("t_prd_product_option_groups.csv")
          if r["prd_cd"] == PRD and r["opt_grp_cd"] == OPT_GRP]
    opts = [r for r in rd("t_prd_product_options.csv")
            if r["prd_cd"] == PRD and r["opt_grp_cd"] == OPT_GRP]
    items = {r["opt_cd"]: r for r in rd("t_prd_product_option_items.csv")
             if r["prd_cd"] == PRD}
    # 제약규칙
    cons = [r for r in rd("t_prd_product_constraints.csv") if r["prd_cd"] == PRD]

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_120.py"},
        "product": {"prd_nm": p.get("prd_nm"), "prd_typ_cd": p.get("prd_typ_cd"),
                    "use_yn": p.get("use_yn"), "del_yn": p.get("del_yn"),
                    "file_upload_yn": p.get("file_upload_yn"), "editor_yn": p.get("editor_yn"),
                    "min_qty": p.get("min_qty"), "max_qty": p.get("max_qty"),
                    "qty_incr": p.get("qty_incr"), "qty_unit_typ_cd": p.get("qty_unit_typ_cd"),
                    "nonspec_yn": p.get("nonspec_yn"),
                    "nonspec_w": f'{_mm(p.get("nonspec_width_min"))}~{_mm(p.get("nonspec_width_max"))}',
                    "nonspec_h": f'{_mm(p.get("nonspec_height_min"))}~{_mm(p.get("nonspec_height_max"))}',
                    "nonspec_w_incr": _mm(p.get("nonspec_width_incr")),
                    "nonspec_h_incr": _mm(p.get("nonspec_height_incr"))},
        "sizes": {s: {"siz_nm": siz[s]["siz_nm"] if s in siz else "?",
                      "work": f'{_mm(siz[s]["work_width"])}x{_mm(siz[s]["work_height"])}' if s in siz else "?",
                      "junction_del": psiz[s]["del_yn"] if s in psiz else "?",
                      "master_del": siz[s]["del_yn"] if s in siz else "?"}
                  for s in SIZES},
        "materials": {m: {"mat_nm": mat[m]["mat_nm"], "mat_typ_cd": mat[m]["mat_typ_cd"],
                          "usage_cd": pmat[m]["usage_cd"] if m in pmat else "?",
                          "dflt": pmat[m]["dflt_yn"] if m in pmat else "?"}
                      for m in MATS if m in mat},
        "processes": {pc: {"proc_nm": procm[pc]["proc_nm"], "upr": procm[pc]["upr_proc_cd"],
                           "mand": pproc[pc]["mand_proc_yn"] if pc in pproc else "?"}
                      for pc in PROCS if pc in procm},
        "print_options": {"row_count": len(po)},
        "plate": [{"siz_cd": r["siz_cd"], "output_paper_typ_cd": r["output_paper_typ_cd"],
                   "output_file_typ": r["output_file_typ"], "note": r["note"],
                   "del_yn": r["del_yn"]} for r in plate],
        "wiring": [{"frm_cd": r["frm_cd"], "comp_cd": r["comp_cd"],
                    "disp_seq": r["disp_seq"], "addtn_yn": r["addtn_yn"]} for r in fc],
        "component": {c: {"comp_nm": v["comp_nm"], "prc_typ_cd": v["prc_typ_cd"],
                          "comp_typ_cd": v["comp_typ_cd"], "use_dims": v["use_dims"],
                          "use_yn": v["use_yn"], "note": v["note"]}
                      for c, v in compdef.items()},
        "matrix_shape": {"comp_cd": COMP, "row_count": len(cp),
                         "widths": [_mm(w) for w in widths], "heights": [_mm(h) for h in heights],
                         "cell_count": len(cells),
                         "grid_full": len(cells) == len(widths) * len(heights),
                         "qty_bands": bands if bands else ["(EMPTY·수량축 없음)"]},
        "option_group": {"grp": og[0] if og else {},
                         "items": [{"opt_cd": o["opt_cd"], "opt_nm": o["opt_nm"],
                                    "dflt": o["dflt_yn"],
                                    "ref_dim_cd": items.get(o["opt_cd"], {}).get("ref_dim_cd", ""),
                                    "ref_key1": items.get(o["opt_cd"], {}).get("ref_key1", "")}
                                   for o in opts]},
        "constraints": [{"rule_cd": r["rule_cd"], "rule_nm": r["rule_nm"],
                         "rule_typ_cd": r["rule_typ_cd"], "err_msg": r["err_msg"],
                         "use_yn": r["use_yn"],
                         "logic_len": len(r["logic"] or "")} for r in cons],
    }


def md(d):
    o = []
    S = f"_meta/scripts/transcribe_product_120.py from {SNAP_ID}"
    p = d["product"]
    o.append(f"<!-- transcribed-by: {S} t_prd_products PRD_000120 @ {STAMP} -->")
    o.append("| prd_nm | prd_typ | use_yn | del_yn | file_upload | editor | min | max | incr | 단위 | nonspec | 가로(mm) | 세로(mm) | 가로incr | 세로incr |")
    o.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
    o.append(f'| {p["prd_nm"]} | {p["prd_typ_cd"]} | {p["use_yn"]} | {p["del_yn"]} | {p["file_upload_yn"]} '
             f'| {p["editor_yn"]} | {p["min_qty"]} | {p["max_qty"]} | {p["qty_incr"]} | {p["qty_unit_typ_cd"]} '
             f'| {p["nonspec_yn"]} | {p["nonspec_w"]} | {p["nonspec_h"]} | {p["nonspec_w_incr"]} | {p["nonspec_h_incr"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prd_product_sizes+t_siz_sizes PRD_000120 @ {STAMP} -->")
    o.append("| siz_cd | 라벨 | 작업(work mm) | junction_del | master_del |")
    o.append("|---|---|---|---|---|")
    for s, v in d["sizes"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["junction_del"]} | {v["master_del"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prd_product_materials+t_mat_materials PRD_000120 @ {STAMP} -->")
    o.append("| mat_cd | 자재명 | mat_typ | usage | dflt |")
    o.append("|---|---|---|---|---|")
    for m, v in d["materials"].items():
        o.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["usage_cd"]} | {v["dflt"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prd_product_processes+t_proc_processes PRD_000120 @ {STAMP} -->")
    o.append("| proc_cd | 공정명 | 상위 | mand |")
    o.append("|---|---|---|---|")
    for pc, v in d["processes"].items():
        o.append(f'| {pc} | {v["proc_nm"]} | {v["upr"]} | {v["mand"]} |')
    o.append(f'\n인쇄옵션(도수) 행수 = {d["print_options"]["row_count"]} (실사=풀컬러 잉크젯·도수 컬럼 없음·정당)')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prd_product_plate_sizes PRD_000120 @ {STAMP} -->")
    o.append("| siz_cd | output_paper_typ_cd | output_file_typ | note | del_yn |")
    o.append("|---|---|---|---|---|")
    for r in d["plate"]:
        o.append(f'| {r["siz_cd"]} | {r["output_paper_typ_cd"] or "(공란)"} | {r["output_file_typ"]} | {r["note"]} | {r["del_yn"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prd_product_price_formulas+t_prc_formula_components PRD_000120 @ {STAMP} -->")
    o.append("| frm_cd | comp_cd | disp_seq | addtn |")
    o.append("|---|---|---|---|")
    for r in d["wiring"]:
        o.append(f'| {r["frm_cd"]} | {r["comp_cd"]} | {r["disp_seq"]} | {r["addtn_yn"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prc_price_components(use_dims·note) COMP_POSTER_ARTPRINT_PHOTO @ {STAMP} -->")
    o.append("| comp_cd | 이름 | prc_typ | comp_typ | use_dims | use_yn |")
    o.append("|---|---|---|---|---|---|")
    for c, v in d["component"].items():
        o.append(f'| {c} | {v["comp_nm"]} | {v["prc_typ_cd"]} | {v["comp_typ_cd"]} | `{v["use_dims"]}` | {v["use_yn"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prc_component_prices COMP_POSTER_ARTPRINT_PHOTO(SHAPE·값 미전사·D-22 접기) @ {STAMP} -->")
    ms = d["matrix_shape"]
    o.append("| comp_cd | 가로 구간(mm) | 세로 구간(mm) | 셀수 | 격자완전 | 수량밴드 |")
    o.append("|---|---|---|---|---|---|")
    o.append(f'| {ms["comp_cd"]} | {"/".join(ms["widths"])} | {"/".join(ms["heights"])} '
             f'| {ms["cell_count"]} | {ms["grid_full"]} | {"/".join(str(b) for b in ms["qty_bands"])} |')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prd_product_option_groups+options+option_items OPT_000006 PRD_000120 @ {STAMP} -->")
    g = d["option_group"]["grp"]
    if g:
        o.append(f'**OPT_000006 {g.get("opt_grp_nm")}** (sel={g.get("sel_typ_cd")}·min/max={g.get("min_sel_cnt")}/{g.get("max_sel_cnt")}·mand={g.get("mand_yn")}·note:{g.get("note")})')
        o.append("| opt_cd | opt_nm | dflt | ref_dim_cd | ref_key1 |")
        o.append("|---|---|---|---|---|")
        for it in d["option_group"]["items"]:
            o.append(f'| {it["opt_cd"]} | {it["opt_nm"]} | {it["dflt"]} | {it["ref_dim_cd"]} | {it["ref_key1"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: {S} t_prd_product_constraints PRD_000120 @ {STAMP} -->")
    o.append("| rule_cd | rule_nm | rule_typ | use_yn | logic 길이(shape·raw 미전재) | err_msg |")
    o.append("|---|---|---|---|---|---|")
    for r in d["constraints"]:
        o.append(f'| {r["rule_cd"]} | {r["rule_nm"]} | {r["rule_typ_cd"]} | {r["use_yn"]} | {r["logic_len"]}자 | {r["err_msg"]} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-120-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
