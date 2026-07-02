#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000050 봉투제작 (D-9·§4·[HARD] LLM 손전사 금지).

봉투제작(050)의 봉투종류 사이즈 4행(SIZ_000191~194)·전용 자재 3종(모조120g·레자크체크/줄무늬)·
수량규칙·가격매트릭스 SHAPE(값 아님, 차원·행수·수량구간만)를 결정론 전사한다.
기존 스크립트 범위 밖이라 이 보강 스크립트로 처리(기존 스크립트 수정 금지·새 파일 원칙).

★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원"까지만(D-18·값=evaluate_price).
  가격매트릭스는 SHAPE(차원 조합·행수·수량구간 목록)만 확인한다.

사용:  python3 transcribe_product_050.py            # stdout markdown 블록(사이즈·자재·수량·매트릭스shape)
       python3 transcribe_product_050.py --json     # cache/transcribed-050-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000050"
SIZES = ["SIZ_000191", "SIZ_000192", "SIZ_000193", "SIZ_000194"]   # 봉투종류 티켓/소/자켓/대
MATS = ["MAT_000159", "MAT_000168", "MAT_000169"]                  # 모조120g·레자크체크·레자크줄무늬
COMP = "COMP_ENV_MAKING"                                           # 봉투제작 완제품가 구성요소


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
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv") if r["mat_cd"] in MATS}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    # 가격매트릭스 SHAPE — 값(unit_price) 미전사, 차원 조합·행수·수량구간만
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP]
    combos = sorted({(r["siz_cd"], r["mat_cd"]) for r in cp})
    bands = sorted({int(r["min_qty"]) for r in cp if r["min_qty"]})
    dims_siz = sorted({r["siz_cd"] for r in cp})
    dims_mat = sorted({r["mat_cd"] for r in cp})
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_050.py"},
        "sizes": {s: {"siz_nm": siz[s]["siz_nm"],
                      "work": f'{_mm(siz[s]["work_width"])}x{_mm(siz[s]["work_height"])}',
                      "impos_yn": siz[s].get("impos_yn", "")}
                  for s in SIZES if s in siz},
        "materials": {m: {"mat_nm": mat[m]["mat_nm"], "mat_typ_cd": mat[m]["mat_typ_cd"],
                          "upr_mat_cd": mat[m]["upr_mat_cd"], "weight": _mm(mat[m]["weight"])}
                      for m in MATS if m in mat},
        "qty": {"min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"]}
        if PRD in prod else {},
        "matrix_shape": {"comp_cd": COMP, "row_count": len(cp),
                         "dims": ["siz_cd", "mat_cd", "min_qty"],
                         "distinct_siz": len(dims_siz), "distinct_mat": len(dims_mat),
                         "qty_bands": bands, "combo_count": len(combos),
                         "grid_full": len(cp) == len(dims_siz) * len(dims_mat) * len(bands)},
    }


def md(d):
    out = []
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_050.py from {SNAP_ID} t_siz_sizes PRD_000050 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 작업(work mm) | 조판(impos_yn) |")
    out.append("|---|---|---|---|")
    for s, v in d["sizes"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["impos_yn"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_050.py from {SNAP_ID} t_mat_materials PRD_000050 @ {STAMP} -->")
    out.append("| mat_cd | 자재명 | mat_typ | 상위자재 | 평량(g) |")
    out.append("|---|---|---|---|---|")
    for m, v in d["materials"].items():
        out.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"] or "-"} | {v["weight"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_050.py from {SNAP_ID} t_prd_products PRD_000050 @ {STAMP} -->")
    out.append("| min_qty | max_qty | qty_incr | 단위 |")
    out.append("|---|---|---|---|")
    q = d["qty"]
    out.append(f'| {q.get("min_qty")} | {q.get("max_qty")} | {q.get("qty_incr")} | {q.get("unit")} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_050.py from {SNAP_ID} t_prc_component_prices COMP_ENV_MAKING(SHAPE·값 미전사) @ {STAMP} -->")
    out.append("| comp_cd | 차원(use_dims) | 사이즈 | 자재 | 수량구간 | 단가행수 | 격자완전 |")
    out.append("|---|---|---|---|---|---|---|")
    ms = d["matrix_shape"]
    out.append(f'| {ms["comp_cd"]} | {"×".join(ms["dims"])} | {ms["distinct_siz"]} | {ms["distinct_mat"]} '
               f'| {"/".join(str(b) for b in ms["qty_bands"])} | {ms["row_count"]} | {ms["grid_full"]} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-050-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
