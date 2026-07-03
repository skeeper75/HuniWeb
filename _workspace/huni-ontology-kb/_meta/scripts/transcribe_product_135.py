#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000135 족자포스터 (실사·★고정가형[siz_cd 룩업]·D-9·§4·[HARD] LLM 손전사 금지).

족자포스터(135)의 규격 사이즈(A3/A2/A1·300x600·900x1200)·본체 자재(PET)·족자제작 공정·
수량규칙·고정가 SHAPE(값 아님·차원·행수·격자완전성만)를 결정론 전사한다.
★118(면적매트릭스형·siz_width×siz_height)과 다른 아키타입 — 135는 고정가형(siz_cd 룩업+수량밴드).
  완제품가 COMP_POSTER_JOKJA(use_dims=[siz_cd,min_qty]) + 천정고리 가산 COMP_POSTEROPT_JOKJA_CEILHOOK(use_dims=[opt_cd,min_qty]).

★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원·격자완전성"까지만(D-18·값=evaluate_price).
★실사=비종이류(대형 롤) → 판형(plate_size)은 파일사양 placeholder일 뿐 종이류 판형 아님(전사 제외·T-7).

사용:  python3 transcribe_product_135.py            # stdout markdown 블록
       python3 transcribe_product_135.py --json     # cache/transcribed-135-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000135"
# 상품 사이즈 5행(t_prd_product_sizes·전부 del_yn=N) — 규격/정형치수
SIZES = ["SIZ_000174", "SIZ_000197", "SIZ_000294", "SIZ_000319", "SIZ_000320"]
MATS = ["MAT_000178"]                       # PET(실사소재 MAT_TYPE.08·단일·USAGE.07)
PROCS = ["PROC_000082"]                      # 족자제작(mand·param 모양=GAP)
COMP_MAIN = "COMP_POSTER_JOKJA"              # 고정가 완제품가(siz_cd×min_qty)
COMP_ADD = "COMP_POSTEROPT_JOKJA_CEILHOOK"   # 천정고리 가산(opt_cd×min_qty)


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
    pm = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")
          if r["comp_cd"] in (COMP_MAIN, COMP_ADD)}
    # 상품 사이즈행(del_yn 확인)
    psize = {r["siz_cd"]: r for r in rd("t_prd_product_sizes.csv") if r["prd_cd"] == PRD}
    # 고정가 SHAPE — 값(unit_price) 미전사, 차원별 셀수·격자완전성만
    cp_main = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP_MAIN]
    cp_add = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP_ADD]
    main_sizes = sorted({r["siz_cd"] for r in cp_main if r.get("siz_cd")})
    main_qty = sorted({r["min_qty"] for r in cp_main if r.get("min_qty")})
    add_opts = sorted({r["opt_cd"] for r in cp_add if r.get("opt_cd")})
    add_qty = sorted({r["min_qty"] for r in cp_add if r.get("min_qty")})
    # 완제품가 격자완전 = 상품 사이즈 전건이 단가행에 있나
    covered = set(main_sizes)
    product_sizes = set(psize.keys())
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_135.py"},
        "sizes": {s: {"siz_nm": siz[s]["siz_nm"],
                      "work": f'{_mm(siz[s]["work_width"])}x{_mm(siz[s]["work_height"])}',
                      "impos_yn": siz[s].get("impos_yn", ""),
                      "del_yn": psize.get(s, {}).get("del_yn", siz[s].get("del_yn", ""))}
                  for s in SIZES if s in siz},
        "materials": {m: {"mat_nm": mat[m]["mat_nm"], "mat_typ_cd": mat[m]["mat_typ_cd"],
                          "upr_mat_cd": mat[m]["upr_mat_cd"], "del_yn": mat[m].get("del_yn", "")}
                      for m in MATS if m in mat},
        "processes": {p: {"proc_nm": proc[p]["proc_nm"], "upr_proc_cd": proc[p]["upr_proc_cd"]}
                      for p in PROCS if p in proc},
        "qty": {"nonspec_yn": prod[PRD]["nonspec_yn"],
                "min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"]}
        if PRD in prod else {},
        "fixed_shape_main": {
            "comp_cd": COMP_MAIN, "use_dims": pm[COMP_MAIN]["use_dims"],
            "prc_typ_cd": pm[COMP_MAIN].get("prc_typ_cd", ""),
            "comp_typ_cd": pm[COMP_MAIN].get("comp_typ_cd", ""),
            "row_count": len(cp_main), "distinct_siz": len(main_sizes),
            "distinct_qty": len(main_qty),
            "product_size_count": len(product_sizes),
            "grid_full": product_sizes.issubset(covered) and covered.issubset(product_sizes),
            "missing_cells": sorted(product_sizes - covered),
        },
        "fixed_shape_add": {
            "comp_cd": COMP_ADD, "use_dims": pm[COMP_ADD]["use_dims"],
            "prc_typ_cd": pm[COMP_ADD].get("prc_typ_cd", ""),
            "row_count": len(cp_add), "distinct_opt": len(add_opts),
            "distinct_qty": len(add_qty), "opts": add_opts,
        },
    }


def md(d):
    out = []
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from {SNAP_ID} t_siz_sizes PRD_000135 @ {STAMP} -->")
    out.append("| siz_cd | 라벨 | 작업(work mm) | 조판(impos_yn) | del_yn |")
    out.append("|---|---|---|---|---|")
    for s, v in d["sizes"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["impos_yn"]} | {v["del_yn"] or "N"} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from {SNAP_ID} t_mat_materials PRD_000135 @ {STAMP} -->")
    out.append("| mat_cd | 자재명 | mat_typ | 상위자재 | del_yn |")
    out.append("|---|---|---|---|---|")
    for m, v in d["materials"].items():
        out.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["upr_mat_cd"] or "-"} | {v["del_yn"] or "N"} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from {SNAP_ID} t_proc_processes PRD_000135 @ {STAMP} -->")
    out.append("| proc_cd | 공정명 | 상위공정 | 상태 |")
    out.append("|---|---|---|---|")
    for p, v in d["processes"].items():
        out.append(f'| {p} | {v["proc_nm"]} | {v["upr_proc_cd"] or "-"} | 활성(del_yn=N)·mand |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from {SNAP_ID} t_prd_products PRD_000135 @ {STAMP} -->")
    out.append("| nonspec | min_qty | max_qty | qty_incr | 단위 |")
    out.append("|---|---|---|---|---|")
    q = d["qty"]
    out.append(f'| {q.get("nonspec_yn")} | {q.get("min_qty")} | {q.get("max_qty")} | {q.get("qty_incr")} | {q.get("unit")} |')
    out.append("")
    out.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_135.py from {SNAP_ID} t_prc_component_prices(SHAPE·값 미전사) @ {STAMP} -->")
    out.append("| comp_cd | 역할 | 차원(use_dims) | 규격셀수 | 수량밴드수 | 단가행수 | 상품사이즈수 | 격자완전 | 미적재셀 |")
    out.append("|---|---|---|---|---|---|---|---|---|")
    m = d["fixed_shape_main"]
    out.append(f'| {m["comp_cd"]} | 완제품가(고정룩업) | {m["use_dims"]} | {m["distinct_siz"]} '
               f'| {m["distinct_qty"]} | {m["row_count"]} | {m["product_size_count"]} '
               f'| {m["grid_full"]} | {m["missing_cells"] or "없음"} |')
    a = d["fixed_shape_add"]
    out.append(f'| {a["comp_cd"]} | 천정고리 가산 | {a["use_dims"]} | (opt {a["distinct_opt"]}) '
               f'| {a["distinct_qty"]} | {a["row_count"]} | - | - | opt={a["opts"]} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-135-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
