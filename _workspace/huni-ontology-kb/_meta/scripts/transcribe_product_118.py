#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000118 아트프린트포스터 (실사·면적매트릭스형·D-9·§4·[HARD] LLM 손전사 금지).

아트프린트포스터(118)의 규격 사이즈(A3/A2/A1)·본체 자재(인화지 부모/자식)·코팅 공정(재키잉)·
수량규칙·면적매트릭스 SHAPE(값 아님·차원·행수·가로/세로 구간만)를 결정론 전사한다.
050(봉투제작 완제품가 매트릭스) 전사기와 동형이나 ★차원이 siz_width×siz_height(면적)라는 점이 다르다.
기존 스크립트 범위 밖이라 이 보강 스크립트로 처리(기존 스크립트 수정 금지·새 파일 원칙).

★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원"까지만(D-18·값=evaluate_price).
  면적매트릭스는 SHAPE(가로/세로 구간·행수·대칭성)만 확인한다.
★실사=비종이류(대형 롤) → 판형(plate_size)은 파일사양 placeholder일 뿐 종이류 판형 아님(전사 제외·T-7).

사용:  python3 transcribe_product_118.py            # stdout markdown 블록
       python3 transcribe_product_118.py --json     # cache/transcribed-118-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000118"
SIZES_ACTIVE = ["SIZ_000315", "SIZ_000198", "SIZ_000294"]   # A3/A2/A1 (del_yn=N)
SIZES_SUPERSEDED = ["SIZ_000174", "SIZ_000197", "SIZ_000293"]  # 구 A3/A2/A1 (del_yn=Y·07-01 재키잉)
MATS = ["MAT_000176", "MAT_000599"]                          # 인화지 부모/자식(둘 다 del_yn=N)
PROCS_ACTIVE = ["PROC_000115", "PROC_000116"]               # 유광코팅/무광코팅(del_yn=N·재키잉)
PROCS_SUPERSEDED = ["PROC_000014", "PROC_000015"]           # 구 유광/무광라미(product del_yn=Y)
COMP = "COMP_POSTER_ARTPRINT_PHOTO"                         # 면적매트릭스 완제품가 구성요소


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def build():
    siz = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv")}
    mat = {r["mat_cd"]: r for r in rd("t_mat_materials.csv")}
    proc = {r["proc_cd"]: r for r in rd("t_proc_processes.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    # 면적매트릭스 SHAPE — 값(unit_price) 미전사, 가로/세로 구간·행수·대칭성만
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP]
    widths = sorted({_mm(r["siz_width"]) for r in cp if r.get("siz_width")}, key=lambda x: int(x) if x.isdigit() else 0)
    heights = sorted({_mm(r["siz_height"]) for r in cp if r.get("siz_height")}, key=lambda x: int(x) if x.isdigit() else 0)
    combos = {(_mm(r["siz_width"]), _mm(r["siz_height"])) for r in cp if r.get("siz_width") and r.get("siz_height")}
    combos_rev = {(h, w) for (w, h) in combos}
    qty_bands = sorted({r["min_qty"] for r in cp if r.get("min_qty")})
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_118.py"},
        "sizes_active": {s: {"siz_nm": siz[s]["siz_nm"],
                             "work": f'{_mm(siz[s]["work_width"])}x{_mm(siz[s]["work_height"])}',
                             "impos_yn": siz[s].get("impos_yn", ""),
                             "del_yn": siz[s].get("del_yn", "")}
                         for s in SIZES_ACTIVE if s in siz},
        "sizes_superseded": {s: {"siz_nm": siz[s]["siz_nm"], "del_yn": siz[s].get("del_yn", "")}
                             for s in SIZES_SUPERSEDED if s in siz},
        "materials": {m: {"mat_nm": mat[m]["mat_nm"], "mat_typ_cd": mat[m]["mat_typ_cd"],
                          "upr_mat_cd": mat[m]["upr_mat_cd"], "del_yn": mat[m].get("del_yn", "")}
                      for m in MATS if m in mat},
        "processes_active": {p: {"proc_nm": proc[p]["proc_nm"], "upr_proc_cd": proc[p]["upr_proc_cd"]}
                             for p in PROCS_ACTIVE if p in proc},
        "processes_superseded": {p: {"proc_nm": proc[p]["proc_nm"], "upr_proc_cd": proc[p]["upr_proc_cd"]}
                                 for p in PROCS_SUPERSEDED if p in proc},
        "qty": {"nonspec_yn": prod[PRD]["nonspec_yn"],
                "nonspec_w": f'{_mm(prod[PRD]["nonspec_width_min"])}~{_mm(prod[PRD]["nonspec_width_max"])}',
                "nonspec_h": f'{_mm(prod[PRD]["nonspec_height_min"])}~{_mm(prod[PRD]["nonspec_height_max"])}',
                "min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"]}
        if PRD in prod else {},
        "matrix_shape": {"comp_cd": COMP, "row_count": len(cp),
                         "use_dims": ["siz_width", "siz_height", "min_qty"],
                         "distinct_w": len(widths), "distinct_h": len(heights),
                         "combo_count": len(combos),
                         "grid_w_range": f"{widths[0]}~{widths[-1]}" if widths else "-",
                         "grid_h_range": f"{heights[0]}~{heights[-1]}" if heights else "-",
                         "grid_full": len(combos) == len(widths) * len(heights),
                         "asymmetric": bool(combos - combos_rev),
                         "qty_populated": len(qty_bands) > 0},
    }


def md(d):
    out = []
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from {SNAP_ID} t_siz_sizes PRD_000118 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 작업(work mm) | 조판(impos_yn) | del_yn |")
    out.append("|---|---|---|---|---|")
    for s, v in d["sizes_active"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["impos_yn"]} | {v["del_yn"] or "N"} |')
    for s, v in d["sizes_superseded"].items():
        out.append(f'| {s} | {v["siz_nm"]} (구·재키잉) | - | - | {v["del_yn"]} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from {SNAP_ID} t_mat_materials PRD_000118 @ {STAMP} -->")
    out.append("| mat_cd | 자재명 | mat_typ | 상위자재 | del_yn |")
    out.append("|---|---|---|---|---|")
    for m, v in d["materials"].items():
        out.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"] or "-"} | {v["del_yn"] or "N"} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from {SNAP_ID} t_proc_processes PRD_000118 @ {STAMP} -->")
    out.append("| proc_cd | 공정명 | 상위공정 | 상태 |")
    out.append("|---|---|---|---|")
    for p, v in d["processes_active"].items():
        out.append(f'| {p} | {v["proc_nm"]} | {v["upr_proc_cd"] or "-"} | 활성(del_yn=N) |')
    for p, v in d["processes_superseded"].items():
        out.append(f'| {p} | {v["proc_nm"]} | {v["upr_proc_cd"] or "-"} | 상품 del_yn=Y(재키잉전) |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from {SNAP_ID} t_prd_products PRD_000118 @ {STAMP} -->")
    out.append("| nonspec | 가로범위(mm) | 세로범위(mm) | min_qty | max_qty | qty_incr | 단위 |")
    out.append("|---|---|---|---|---|---|---|")
    q = d["qty"]
    out.append(f'| {q.get("nonspec_yn")} | {q.get("nonspec_w")} | {q.get("nonspec_h")} '
               f'| {q.get("min_qty")} | {q.get("max_qty")} | {q.get("qty_incr")} | {q.get("unit")} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_118.py from {SNAP_ID} t_prc_component_prices COMP_POSTER_ARTPRINT_PHOTO(SHAPE·값 미전사) @ {STAMP} -->")
    out.append("| comp_cd | 차원(use_dims) | 가로구간수 | 세로구간수 | 가로범위(mm) | 세로범위(mm) | (가로,세로)셀수 | 단가행수 | 격자완전 | 비대칭 | 수량축충전 |")
    out.append("|---|---|---|---|---|---|---|---|---|---|---|")
    ms = d["matrix_shape"]
    out.append(f'| {ms["comp_cd"]} | {"×".join(ms["use_dims"])} | {ms["distinct_w"]} | {ms["distinct_h"]} '
               f'| {ms["grid_w_range"]} | {ms["grid_h_range"]} '
               f'| {ms["combo_count"]} | {ms["row_count"]} | {ms["grid_full"]} | {ms["asymmetric"]} | {ms["qty_populated"]} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-118-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
