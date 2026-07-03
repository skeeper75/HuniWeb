#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000121 접착방수포스터 (실사·면적매트릭스) (D-9·§4·[HARD] LLM 손전사 금지).

접착방수포스터(121)의 등록 규격 사이즈 3행(SIZ_000174/197/293)·본체 자재(PVC MAT_000179)·
수량규칙·비규격 입력범위(nonspec)·코팅 옵션 항목(OPV→PROC)·면적매트릭스 SHAPE(값 아님,
차원·행수·distinct 가로/세로만)를 결정론 전사한다. 새 파일 원칙(기존 스크립트 미수정).

★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원"까지만(D-18·값=evaluate_price).
  면적매트릭스는 SHAPE(distinct 가로/세로·셀수·grid_full)만 확인한다.
★실사=포스터/사인 면적매트릭스 [가로×세로]·비종이류 판형없음(HARNESS-DOMAIN-RULES·pack-silsa §3.8).

사용:  python3 transcribe_product_121.py            # stdout markdown 블록
       python3 transcribe_product_121.py --json     # cache/transcribed-121-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000121"
SIZES = ["SIZ_000174", "SIZ_000197", "SIZ_000293"]   # 등록규격 A3/A2/A1
MAT = "MAT_000179"                                    # PVC(접착방수 본체)
COMP = "COMP_POSTER_ARTPRINT_PHOTO"                   # 동형결합 4소재 완제품가(활성 배선)
COMP_LEGACY = "COMP_POSTER_ADH_WATERPROOF_PVC"        # 레거시(use_yn=N·미배선)


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv") if r["siz_cd"] in SIZES}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv") if r["mat_cd"] == MAT}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    pr = prod.get(PRD, {})
    # 면적매트릭스 SHAPE — 값(unit_price) 미전사, 가로/세로 차원·셀수만
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP]
    cp_legacy = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP_LEGACY]
    ws = sorted({_mm(r["siz_width"]) for r in cp if r.get("siz_width")}, key=lambda x: int(x) if x.isdigit() else 0)
    hs = sorted({_mm(r["siz_height"]) for r in cp if r.get("siz_height")}, key=lambda x: int(x) if x.isdigit() else 0)
    cells = {(r["siz_width"], r["siz_height"]) for r in cp}
    # 코팅 옵션 항목: OPV → PROC (OPT_REF_DIM.04)
    opts = {r["opt_cd"]: r for r in rd("t_prd_product_options.csv")
            if r["prd_cd"] == PRD}
    items = [r for r in rd("t_prd_product_option_items.csv") if r["prd_cd"] == PRD]
    coat = [{"opt_cd": r["opt_cd"], "opt_nm": opts.get(r["opt_cd"], {}).get("opt_nm", "?"),
             "ref_dim_cd": r["ref_dim_cd"], "ref_key1": r["ref_key1"],
             "dflt": opts.get(r["opt_cd"], {}).get("dflt_yn", "")} for r in items]
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_121.py"},
        "sizes": {s: {"siz_nm": siz[s]["siz_nm"],
                      "work": f'{_mm(siz[s]["work_width"])}x{_mm(siz[s]["work_height"])}',
                      "cut": f'{_mm(siz[s]["cut_width"])}x{_mm(siz[s]["cut_height"])}',
                      "impos_yn": siz[s].get("impos_yn", ""),
                      "master_del_yn": siz[s].get("del_yn", "")}
                  for s in SIZES if s in siz},
        "material": {MAT: {"mat_nm": mat[MAT]["mat_nm"], "mat_typ_cd": mat[MAT]["mat_typ_cd"],
                           "upr_mat_cd": mat[MAT]["upr_mat_cd"] or "-"}} if MAT in mat else {},
        "qty": {"min_qty": pr.get("min_qty"), "max_qty": pr.get("max_qty"),
                "qty_incr": pr.get("qty_incr"), "unit": pr.get("qty_unit_typ_cd"),
                "nonspec_yn": pr.get("nonspec_yn"),
                "w_range": f'{_mm(pr.get("nonspec_width_min"))}~{_mm(pr.get("nonspec_width_max"))}',
                "h_range": f'{_mm(pr.get("nonspec_height_min"))}~{_mm(pr.get("nonspec_height_max"))}',
                "incr_mm": _mm(pr.get("nonspec_width_incr"))},
        "matrix_shape": {"comp_cd": COMP, "row_count": len(cp),
                         "dims": ["siz_width", "siz_height", "min_qty"],
                         "distinct_width": ws, "distinct_height": hs,
                         "cell_count": len(cells),
                         "grid_full": len(cells) == len(ws) * len(hs),
                         "legacy_comp": COMP_LEGACY, "legacy_row_count": len(cp_legacy)},
        "coating": coat,
    }


def md(d):
    o = []
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from {SNAP_ID} t_siz_sizes PRD_000121 @ {STAMP} -->")
    o.append("| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) | 조판(impos_yn) | 마스터 del_yn |")
    o.append("|---|---|---|---|---|---|")
    for s, v in d["sizes"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} | {v["impos_yn"]} | {v["master_del_yn"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from {SNAP_ID} t_mat_materials PRD_000121 @ {STAMP} -->")
    o.append("| mat_cd | 자재명 | mat_typ | 상위자재 |")
    o.append("|---|---|---|---|")
    for m, v in d["material"].items():
        o.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from {SNAP_ID} t_prd_products PRD_000121 @ {STAMP} -->")
    o.append("| min_qty | max_qty | qty_incr | 단위 | 비규격 | 가로범위(mm) | 세로범위(mm) | 입력증분(mm) |")
    o.append("|---|---|---|---|---|---|---|---|")
    q = d["qty"]
    o.append(f'| {q.get("min_qty")} | {q.get("max_qty")} | {q.get("qty_incr")} | {q.get("unit")} '
             f'| {q.get("nonspec_yn")} | {q.get("w_range")} | {q.get("h_range")} | {q.get("incr_mm")} |')
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from {SNAP_ID} t_prc_component_prices COMP_POSTER_ARTPRINT_PHOTO(SHAPE·값 미전사) @ {STAMP} -->")
    o.append("| comp_cd | 차원(use_dims) | distinct 가로 | distinct 세로 | 셀수(단가행) | grid_full | 레거시 comp(use_yn=N) | 레거시 셀수 |")
    o.append("|---|---|---|---|---|---|---|---|")
    ms = d["matrix_shape"]
    o.append(f'| {ms["comp_cd"]} | {"×".join(ms["dims"])} | {len(ms["distinct_width"])} '
             f'| {len(ms["distinct_height"])} | {ms["row_count"]} | {ms["grid_full"]} '
             f'| {ms["legacy_comp"]} | {ms["legacy_row_count"]} |')
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_121.py from {SNAP_ID} t_prd_product_option_items PRD_000121(코팅) @ {STAMP} -->")
    o.append("| opt_cd | 옵션명 | ref_dim_cd | ref_key1(공정) | 기본 |")
    o.append("|---|---|---|---|---|")
    for c in d["coating"]:
        o.append(f'| {c["opt_cd"]} | {c["opt_nm"]} | {c["ref_dim_cd"]} | {c["ref_key1"]} | {c["dflt"]} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        cd = os.path.join(os.path.dirname(__file__), "cache")
        os.makedirs(cd, exist_ok=True)
        p = os.path.join(cd, "transcribed-121-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
