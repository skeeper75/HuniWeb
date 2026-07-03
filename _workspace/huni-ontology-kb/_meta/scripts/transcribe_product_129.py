#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000129 폼보드 (실사·★고정가형·D-9·§4·[HARD] LLM 손전사 금지).

폼보드(129)의 규격 사이즈(A3/A2)·보드 자재(화이트/블랙 5mm × A3/A2)·코팅/실사가공 공정·
수량규칙·★고정가 룩업 격자 SHAPE(mat_cd × siz_cd·값 아님·조합 coverage만)를 결정론 전사한다.
118(면적매트릭스형) 전사기와 달리 ★차원이 [mat_cd, siz_cd] 고정 룩업(nonspec_yn=N)이라 면적축(가로×세로)이 없다.
고정가형은 별 트랙(mapping.md §5·BLOCKED-OUT-OF-SCOPE from 면적매트릭스)이므로 이 보강 스크립트로 처리.

★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원·coverage"까지만(D-18·값=evaluate_price).
  고정가 격자는 SHAPE(어떤 (siz,mat) 조합에 단가행이 있나·조합 coverage·엇갈림)만 확인한다.
★실사=비종이류(대형 보드) → 판형(plate_size)은 파일사양 placeholder일 뿐 종이류 판형 아님(전사 제외·T-7).
★자재유형 = MAT_TYPE.16 실사부자재(현재값=정답·레더 .05/.08 crosscut과 무관·false-defect 방지).

사용:  python3 transcribe_product_129.py            # stdout markdown 블록
       python3 transcribe_product_129.py --json     # cache/transcribed-129-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000129"
SIZES_ACTIVE = ["SIZ_000315", "SIZ_000198"]                 # A3/A2 (링크 del_yn=N)
SIZES_SUPERSEDED = ["SIZ_000174", "SIZ_000197"]             # 구 A3/A2 (링크 del_yn=Y·07-01 재키잉)
MATS = ["MAT_000398", "MAT_000399", "MAT_000612", "MAT_000613"]  # 보드 4자재(화이트/블랙 × A3/A2·전부 del_yn=N)
PROCS_ACTIVE = ["PROC_000115", "PROC_000116", "PROC_000135"]  # 유광코팅/무광코팅/실사가공(del_yn=N)
PROCS_SUPERSEDED = ["PROC_000014", "PROC_000015"]           # 구 유광/무광라미(product del_yn=Y)
COMP = "COMP_POSTER_FOAMBOARD_BOARD"                        # 고정가 완제품가 구성요소(use_dims=[mat_cd,siz_cd])


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
    p = prod.get(PRD, {})
    # 상품 링크(활성 자재·사이즈)
    prd_mat = [r for r in rd("t_prd_product_materials.csv")
               if r["prd_cd"] == PRD and r.get("del_yn") != "Y"]
    prd_siz = [r for r in rd("t_prd_product_sizes.csv")
               if r["prd_cd"] == PRD and r.get("del_yn") != "Y"]
    # 고정가 격자 — 값(unit_price) 미전사, (siz_cd, mat_cd) 조합 coverage만
    cp = [r for r in rd("t_prc_component_prices.csv") if r["comp_cd"] == COMP]
    grid_combos = sorted({(r.get("siz_cd", ""), r.get("mat_cd", "")) for r in cp})
    prod_sizes = sorted({r["siz_cd"] for r in prd_siz})
    prod_mats = sorted({r["mat_cd"] for r in prd_mat})
    naive = [(s, m) for s in prod_sizes for m in prod_mats]         # 상품제공 조합 (naive cross)
    priced = set(grid_combos)
    unpriced = [c for c in naive if c not in priced]               # 엇갈림(대각선-밖)
    # 옵션 보드칼라가 참조하는 자재(A3 only 여부)
    oi = [r for r in rd("t_prd_product_option_items.csv")
          if r["prd_cd"] == PRD and r.get("ref_dim_cd") == "OPT_REF_DIM.03"]
    optref_mats = sorted({r["ref_key1"] for r in oi if r.get("ref_key1")})
    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "prd_cd": PRD,
                 "archetype": "고정가형(fixed-lookup·use_dims=[mat_cd,siz_cd])"},
        "product": {"min_qty": p.get("min_qty"), "max_qty": p.get("max_qty"),
                    "qty_incr": p.get("qty_incr"), "qty_unit_typ_cd": p.get("qty_unit_typ_cd"),
                    "nonspec_yn": p.get("nonspec_yn")},
        "sizes_active": [{"siz_cd": s, "siz_nm": siz.get(s, {}).get("siz_nm", "?"),
                          "work_w": _mm(siz.get(s, {}).get("work_width")),
                          "work_h": _mm(siz.get(s, {}).get("work_height")),
                          "link_del": "N"} for s in SIZES_ACTIVE],
        "sizes_superseded": [{"siz_cd": s, "siz_nm": siz.get(s, {}).get("siz_nm", "?"),
                              "link_del": "Y(07-01 재키잉)"} for s in SIZES_SUPERSEDED],
        "materials": [{"mat_cd": m, "mat_nm": mat.get(m, {}).get("mat_nm", "?"),
                       "mat_typ": mat.get(m, {}).get("mat_typ_cd", "?"),
                       "del": mat.get(m, {}).get("del_yn", "?")} for m in MATS],
        "procs_active": [{"proc_cd": pc, "proc_nm": proc.get(pc, {}).get("proc_nm", "?"),
                          "upr": proc.get(pc, {}).get("upr_proc_cd", "")} for pc in PROCS_ACTIVE],
        "procs_superseded": [{"proc_cd": pc, "proc_nm": proc.get(pc, {}).get("proc_nm", "?")}
                             for pc in PROCS_SUPERSEDED],
        "grid": {"comp_cd": COMP, "row_count": len(cp), "combos_priced": grid_combos,
                 "prod_sizes": prod_sizes, "prod_mats": prod_mats,
                 "naive_combos": len(naive), "priced_combos": len(grid_combos),
                 "unpriced_combos": unpriced, "optref_mats": optref_mats},
    }


def md(d):
    o = []
    m = d["meta"]
    o.append(f"## 치수·자재·공정·수량·고정가격자 전사표 (권위 = 라이브 마스터·{m['archetype']})")
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from {m['snapshot']} "
             f"t_siz_sizes {PRD} @ {m['captured_at']} -->")
    o.append("")
    o.append("**사이즈(이산 규격·nonspec_yn=N — 자유치수 없음)**")
    o.append("")
    o.append("| siz_cd | siz_nm | 작업(가로×세로) | 링크 del |")
    o.append("|---|---|---|---|")
    for s in d["sizes_active"]:
        o.append(f"| {s['siz_cd']} | {s['siz_nm']} | {s['work_w']}×{s['work_h']} | {s['link_del']} |")
    for s in d["sizes_superseded"]:
        o.append(f"| {s['siz_cd']} | {s['siz_nm']} | (구 코드) | {s['link_del']} |")
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from {m['snapshot']} "
             f"t_mat_materials {PRD} @ {m['captured_at']} -->")
    o.append("")
    o.append("**자재(보드 4종 = 색상 2 × 규격 2·자재명에 사이즈 내장·MAT_TYPE.16 실사부자재)**")
    o.append("")
    o.append("| mat_cd | mat_nm | mat_typ | del |")
    o.append("|---|---|---|---|")
    for x in d["materials"]:
        o.append(f"| {x['mat_cd']} | {x['mat_nm']} | {x['mat_typ']} | {x['del']} |")
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from {m['snapshot']} "
             f"t_proc_processes {PRD} @ {m['captured_at']} -->")
    o.append("")
    o.append("**공정(활성 = 유광/무광코팅 + 실사가공·구 라미네이팅 논리삭제)**")
    o.append("")
    o.append("| proc_cd | proc_nm | 상위 | 상태 |")
    o.append("|---|---|---|---|")
    for x in d["procs_active"]:
        o.append(f"| {x['proc_cd']} | {x['proc_nm']} | {x['upr']} | 활성(del_yn=N) |")
    for x in d["procs_superseded"]:
        o.append(f"| {x['proc_cd']} | {x['proc_nm']} | — | 구 라미(product del_yn=Y·07-01 교체) |")
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from {m['snapshot']} "
             f"t_prd_products {PRD} @ {m['captured_at']} -->")
    o.append("")
    pr = d["product"]
    o.append(f"**수량규칙(제품 레벨):** min={pr['min_qty']} · max={pr['max_qty']} · "
             f"incr={pr['qty_incr']} · 단위={pr['qty_unit_typ_cd']} · nonspec_yn={pr['nonspec_yn']}")
    o.append("")
    o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_129.py from {m['snapshot']} "
             f"t_prc_component_prices {COMP}(SHAPE·값 미전사) @ {m['captured_at']} -->")
    o.append("")
    g = d["grid"]
    o.append(f"**고정가 격자 SHAPE (구성요소 {g['comp_cd']}·use_dims=[mat_cd,siz_cd]·값 미전사·D-18):**")
    o.append("")
    o.append(f"- 단가행 실재 조합 **{g['priced_combos']}개**(대각선): "
             + " · ".join(f"({s},{mm})" for s, mm in g["combos_priced"]))
    o.append(f"- 상품제공 자재 {len(g['prod_mats'])} × 사이즈 {len(g['prod_sizes'])} = naive **{g['naive_combos']}조합**")
    o.append(f"- ★단가행 부재(엇갈림·대각선-밖) **{len(g['unpriced_combos'])}조합**: "
             + " · ".join(f"({s},{mm})" for s, mm in g["unpriced_combos"]))
    o.append(f"- 옵션 보드칼라 참조 자재(OPT_REF_DIM.03) = {g['optref_mats']} (★A3 자재만 배선·A2 자재 미배선)")
    o.append("")
    o.append("> ★해석(엇갈림·CN-2·§31 판례 P-1): 자재명에 사이즈 내장(A3/A2 전용 mat) → 격자는 (A3siz×A3mat)·"
             "(A2siz×A2mat) 대각선 4셀만 단가행. 옵션 보드칼라가 A3 자재(398/399)만 참조하므로 "
             "**사이즈=A2 선택 시 (A2siz, A3mat) 대각선-밖 조합 → 단가행 부재 → 견적 0 위험**. "
             "가격 값(6종 등)은 전사 안 함(evaluate_price 권위). 이 표는 격자 coverage(구조)만.")
    return "\n".join(o)


def main():
    d = build()
    if "--json" in sys.argv:
        cache = os.path.join(os.path.dirname(__file__), "cache")
        os.makedirs(cache, exist_ok=True)
        with open(os.path.join(cache, "transcribed-129-260703.json"), "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2)
        print("wrote cache/transcribed-129-260703.json")
    else:
        print(md(d))


if __name__ == "__main__":
    main()
