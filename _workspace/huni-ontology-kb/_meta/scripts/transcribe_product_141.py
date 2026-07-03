#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000141 홀로그램 시트커팅 (실사·★고정가형[siz_cd 룩업]·D-9·§4·[HARD] LLM 손전사 금지).

홀로그램 시트커팅(141)의 규격 사이즈(A4/A3/A2)·자재(홀로그램)·수량규칙·
고정가 SHAPE(값 아님·차원·행수·siz_cd 셀만)를 결정론 전사한다.
★118 아트프린트포스터(면적매트릭스 [가로×세로])와 달리 141은 **고정가형** 룩업이다.
  단 131 프레임리스우드액자(use_dims=[siz_cd,min_qty])와도 달리 141은 **use_dims=[siz_cd] 단일축**
  (수량밴드 없음·규격당 통가격·min_qty 공란) — 실사 고정가 15상품(pack §3.10) 변형.
★자재 = MAT_000257 홀로그램(USAGE.07·MAT_TYPE.08 실사소재)·★마스터 del_yn=Y 논리삭제(2026-06-16)이나
  상품링크(junction) del_yn=N 활성 = 링크활성/마스터삭제 불일치(정직 관찰·127 타이벡소프트 동형).
★공정 = t_prd_product_processes 0행(★화이트 underbase PROC_000008 미연결·pack §3.3 홀로그램 도메인필수인데
  라이브 부재 → GAP·시트커팅 커팅공정도 0행·통가격 baked 추정).
★실사=비종이류(대형 롤/시트) → 판형(plate_size)은 파일사양 placeholder(전부 del_yn=Y)·종이류 판형 아님(전사 제외·T-7).
★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원"까지만(D-18·값=evaluate_price).

사용:  python3 transcribe_product_141.py            # stdout markdown 블록
       python3 transcribe_product_141.py --json     # cache/transcribed-141-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000141"
SIZES_ACTIVE = ["SIZ_000172", "SIZ_000174", "SIZ_000197"]   # A4/A3/A2 (product_sizes del_yn=N)
PLATE_PLACEHOLDER = ["SIZ_000050", "SIZ_000052", "SIZ_000198"]  # 파일사양 placeholder(AI·비종이류·판형 아님·전부 del_yn=Y)
MAT = "MAT_000257"                                          # 홀로그램(USAGE.07·MAT_TYPE.08·마스터 del_yn=Y)
FRM = "PRF_POSTER_SHEETCUT_HOLO"
COMP = "COMP_POSTER_SHEETCUT_HOLO"                          # 고정가 완제품가 구성요소(siz_cd 룩업)


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _num(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    pcat = [r for r in rd("t_prd_product_categories.csv") if r["prd_cd"] == PRD]
    psz = {r["siz_cd"]: r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD}
    pproc = [r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD]
    ppo = [r for r in rd("t_prd_product_print_options.csv") if r["prd_cd"] == PRD]
    pog = [r for r in rd("t_prd_product_option_groups.csv") if r["prd_cd"] == PRD]
    pcn = [r for r in rd("t_prd_product_constraints.csv") if r["prd_cd"] == PRD]
    padd = [r for r in rd("t_prd_product_addons.csv") if r["prd_cd"] == PRD]
    pset = [r for r in rd("t_prd_product_sets.csv") if r["prd_cd"] == PRD]
    pbq = [r for r in rd("t_prd_product_bundle_qtys.csv") if r["prd_cd"] == PRD]
    pmatj = [r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD]
    pfrm = [r for r in rd("t_prd_product_price_formulas.csv") if r["prd_cd"] == PRD]
    fcomp = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == FRM]
    pcomp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv") if r["comp_cd"] == COMP}
    # 고정가 SHAPE — 값(unit_price) 미전사, siz_cd 셀 수·수량축 충전만
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP]
    siz_cells = sorted({r["siz_cd"] for r in cp if r.get("siz_cd")})
    qty_bands = sorted({r["min_qty"] for r in cp if r.get("min_qty")})
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_141.py"},
        "categories": [{"cat_cd": r["cat_cd"], "cat_nm": cat.get(r["cat_cd"], {}).get("cat_nm", "?"),
                        "upr": cat.get(r["cat_cd"], {}).get("upr_cat_cd", ""),
                        "lvl": cat.get(r["cat_cd"], {}).get("cat_lvl", ""),
                        "main": r.get("main_cat_yn", "")}
                       for r in pcat],
        "sizes_active": {s: {"siz_nm": siz[s]["siz_nm"],
                             "work": f'{_num(siz[s]["work_width"])}x{_num(siz[s]["work_height"])}',
                             "master_del_yn": siz[s].get("del_yn", ""),
                             "junc_del_yn": psz.get(s, {}).get("del_yn", "")}
                         for s in SIZES_ACTIVE if s in siz},
        "material": {"mat_cd": MAT,
                     "mat_nm": mat.get(MAT, {}).get("mat_nm", "?"),
                     "mat_typ_cd": mat.get(MAT, {}).get("mat_typ_cd", ""),
                     "usage_cd": next((r["usage_cd"] for r in pmatj if r["mat_cd"] == MAT), ""),
                     "master_del_yn": mat.get(MAT, {}).get("del_yn", ""),
                     "junc_del_yn": next((r["del_yn"] for r in pmatj if r["mat_cd"] == MAT), "")},
        "materials_junction_rows": len(pmatj),
        "process_rows": len(pproc),
        "print_option_rows": len(ppo),
        "option_group_rows": len(pog),
        "constraint_rows": len(pcn),
        "addon_rows": len(padd),
        "set_rows": len(pset),
        "bundle_qty_rows": len(pbq),
        "plate_placeholder": {s: {"siz_nm": siz.get(s, {}).get("siz_nm", "?")}
                              for s in PLATE_PLACEHOLDER},
        "qty": {"nonspec_yn": prod[PRD]["nonspec_yn"],
                "min_qty": prod[PRD]["min_qty"] or "(공란)", "max_qty": prod[PRD]["max_qty"] or "(공란)",
                "qty_incr": prod[PRD]["qty_incr"] or "(공란)", "unit": prod[PRD]["qty_unit_typ_cd"],
                "use_yn": prod[PRD]["use_yn"], "del_yn": prod[PRD]["del_yn"],
                "editor_yn": prod[PRD]["editor_yn"], "file_upload_yn": prod[PRD]["file_upload_yn"],
                "prd_typ_cd": prod[PRD]["prd_typ_cd"], "prd_nm": prod[PRD]["prd_nm"]}
        if PRD in prod else {},
        "formula": {"frm_cd": FRM,
                    "bound": bool(pfrm),
                    "comp_wired": [{"comp_cd": r["comp_cd"], "disp_seq": r["disp_seq"], "addtn": r["addtn_yn"]}
                                   for r in fcomp]},
        "component": {"comp_cd": COMP,
                      "prc_typ_cd": pcomp.get(COMP, {}).get("prc_typ_cd", ""),
                      "comp_typ_cd": pcomp.get(COMP, {}).get("comp_typ_cd", ""),
                      "use_dims": pcomp.get(COMP, {}).get("use_dims", ""),
                      "del_yn": pcomp.get(COMP, {}).get("del_yn", "")},
        "fixed_shape": {"comp_cd": COMP, "row_count": len(cp),
                        "distinct_siz": len(siz_cells), "siz_cells": siz_cells,
                        "qty_bands": qty_bands,
                        "grid_full": len(cp) == len(siz_cells) * max(1, len(qty_bands)),
                        "qty_populated": len(qty_bands) > 1,
                        "size_price_match": sorted(SIZES_ACTIVE) == siz_cells},
    }


def md(d):
    out = []
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from {SNAP_ID} t_prd_product_categories+t_cat_categories PRD_000141 @ {STAMP} -->")
    out.append("| cat_cd | 분류명 | 상위 | lvl | main |")
    out.append("|---|---|---|---|---|")
    for c in d["categories"]:
        out.append(f'| {c["cat_cd"]} | {c["cat_nm"]} | {c["upr"] or "-"} | {c["lvl"]} | {c["main"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from {SNAP_ID} t_prd_product_sizes+t_siz_sizes PRD_000141 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 작업(work mm) | master_del_yn | junction_del_yn |")
    out.append("|---|---|---|---|---|")
    for s, v in d["sizes_active"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["master_del_yn"] or "N"} | {v["junc_del_yn"] or "N"} |')
    out.append("")
    m = d["material"]
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from {SNAP_ID} t_mat_materials+t_prd_product_materials PRD_000141 @ {STAMP} -->")
    out.append("| mat_cd | 자재명 | mat_typ | usage | master_del_yn(★) | junction_del_yn |")
    out.append("|---|---|---|---|---|---|")
    out.append(f'| {m["mat_cd"]} | {m["mat_nm"]} | {m["mat_typ_cd"]} | {m["usage_cd"]} | {m["master_del_yn"] or "N"} | {m["junc_del_yn"] or "N"} |')
    out.append(f'> ★자재 마스터 del_yn={m["master_del_yn"] or "N"}(논리삭제)이나 상품링크(junction) del_yn={m["junc_del_yn"] or "N"} 활성 = 링크활성/마스터삭제 불일치(정직 관찰·127 동형).')
    out.append("")
    out.append(f'공정(t_prd_product_processes) 활성 행수 = {d["process_rows"]} '
               f'(★화이트 underbase PROC_000008 미연결·pack §3.3 홀로그램 도메인필수인데 라이브 부재=GAP·시트커팅 커팅공정도 0행·통가격 baked 추정)')
    out.append(f'인쇄옵션(t_prd_product_print_options) 행수 = {d["print_option_rows"]} (실사 대형잉크젯 풀컬러·도수 컬럼 없음·설계상 정당)')
    out.append(f'옵션그룹(t_prd_product_option_groups) 행수 = {d["option_group_rows"]} / 제약(t_prd_product_constraints) 행수 = {d["constraint_rows"]} (nonspec_yn=N·141은 constraints 신규발현 7상품 미포함=정당)')
    out.append(f'추가상품(t_prd_product_addons) 행수 = {d["addon_rows"]} / 셋트(t_prd_product_sets 부모) 행수 = {d["set_rows"]} (부속 8상품 미해당·통가격 단일상품)')
    out.append(f'수량규칙(t_prd_product_bundle_qtys) 행수 = {d["bundle_qty_rows"]} (제품 레벨 수량 공란·pack §3.4 GAP-SL-8 홀로그램 L1 빈값)')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from {SNAP_ID} t_prd_product_plate_sizes (★전 행 output_paper_typ 공란·del_yn=Y=파일사양 placeholder·비종이류 판형 무의미·pack §3.8·T-7) PRD_000141 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 용도 |")
    out.append("|---|---|---|")
    for s, v in d["plate_placeholder"].items():
        out.append(f'| {s} | {v["siz_nm"]} | AI 파일사양(판형 아님·del_yn=Y) |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from {SNAP_ID} t_prd_products PRD_000141 @ {STAMP} -->")
    out.append("| 항목 | 값 |")
    out.append("|---|---|")
    q = d["qty"]
    for k, lab in [("prd_nm", "prd_nm"), ("prd_typ_cd", "prd_typ_cd"), ("nonspec_yn", "nonspec_yn(★N=사용자입력 없음)"),
                   ("min_qty", "min_qty"), ("max_qty", "max_qty"), ("qty_incr", "qty_incr"),
                   ("unit", "qty_unit"), ("use_yn", "use_yn"), ("del_yn", "del_yn"),
                   ("file_upload_yn", "file_upload"), ("editor_yn", "editor")]:
        out.append(f'| {lab} | {q.get(k)} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from {SNAP_ID} t_prd_product_price_formulas+t_prc_formula_components+t_prc_price_components PRD_000141 @ {STAMP} -->")
    out.append("| frm_cd | 상품 바인딩 | comp_cd(배선) | prc_typ_cd | comp_typ_cd | use_dims |")
    out.append("|---|---|---|---|---|---|")
    f, c = d["formula"], d["component"]
    wired = ",".join(w["comp_cd"] for w in f["comp_wired"]) or "-"
    out.append(f'| {f["frm_cd"]} | {f["bound"]} | {wired} | {c["prc_typ_cd"]} | {c["comp_typ_cd"]} | {c["use_dims"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_141.py from {SNAP_ID} t_prc_component_prices COMP_POSTER_SHEETCUT_HOLO (★고정가 SHAPE·값 미전사) @ {STAMP} -->")
    out.append("| comp_cd | 차원(use_dims) | 규격셀수 | siz 셀 | 수량밴드수 | 단가행수 | 격자완전 | 수량축충전 | 규격=가격셀 정합 |")
    out.append("|---|---|---|---|---|---|---|---|---|")
    fs = d["fixed_shape"]
    dims = c["use_dims"] or '["siz_cd"]'
    out.append(f'| {fs["comp_cd"]} | {dims} | {fs["distinct_siz"]} '
               f'| {",".join(fs["siz_cells"])} | {len(fs["qty_bands"])} | {fs["row_count"]} '
               f'| {fs["grid_full"]} | {fs["qty_populated"]} | {fs["size_price_match"]} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-141-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
