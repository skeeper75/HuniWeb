#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 보강 스크립트 — PRD_000138 일반현수막 (실사·면적매트릭스형 base + CPQ 옵션 추가가격·D-9·§4·[HARD] LLM 손전사 금지).

일반현수막(138)은 실사 면적매트릭스형 중 ★CPQ 파일럿(og=3·oi=18·라이브 최초 옵션 레이어)이다.
가격 = base 면적매트릭스 완제품가(COMP_POSTER_BANNER_NORMAL·[단독]·가로×세로 셀단가)
       + 8 옵션 추가가격 구성요소(가공/추가/각목). 118 아트프린트포스터(단일 comp)보다 공식이 복잡하다.

전사 대상: 본체 자재(현수막천)+CPQ 번들 자재(끈/큐방/각목/양면테입/봉제사)·후가공 공정(봉제/부착/열재단/현수막타공)·
          단일 규격(5000x900)·수량 규칙·nonspec 범위·base 면적매트릭스 SHAPE·9 구성요소 행수/차원.
★가격 값(unit_price)은 전사하지 않는다 — 온톨로지는 "연결·차원"까지만(D-18·값=evaluate_price).
★실사=비종이류(대형 롤) → 판형(plate_size)은 파일사양 placeholder(del)일 뿐 종이류 판형 아님(전사 제외·T-7).
★삭제 마스터 드리프트 관찰: 열재단 PROC_000084(06-30 del)·양면테입 MAT_000069(06-30 del)·봉제사 MAT_000340(06-27 del)이
  삭제됐으나 활성 option_item이 여전히 참조 → 현재값(master del) vs 정답(재연결/정리) 양면 대상. del_yn 그대로 전사.

사용:  python3 transcribe_product_138.py            # stdout markdown 블록
       python3 transcribe_product_138.py --json     # cache/transcribed-138-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

PRD = "PRD_000138"
SIZES = ["SIZ_000322"]                                   # 5000x900 (dflt·impos_yn=N)
# 본체 + CPQ 번들 자재(활성 상품링크 순). 069/340 = 마스터 del_yn=Y(삭제 드리프트)·339 = 링크 del
MATS = ["MAT_000182", "MAT_000070", "MAT_000337", "MAT_000338", "MAT_000069", "MAT_000340", "MAT_000339"]
# 후가공 공정. 084 = 마스터 del_yn=Y(삭제 드리프트)·079 = 상품링크 del(104로 교체)
PROCS = ["PROC_000080", "PROC_000081", "PROC_000104", "PROC_000084", "PROC_000079"]
CAT = "CAT_000315"
BASE_COMP = "COMP_POSTER_BANNER_NORMAL"                  # base 면적매트릭스 완제품가([단독])
OPT_COMPS = [                                            # 옵션 추가가격 구성요소(formula seq 2~9)
    "COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4",
    "COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE",
    "COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE",
    "COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW",
    "COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4",
    "COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4",
    "COMP_POPT_BNR_GAKMOK_STR_900_4_LE",
    "COMP_POPT_BNR_GAKMOK_STR_900_4_GT",
]
FRM = "PRF_POSTER_BANNER_N"


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
    cat = {r["cat_cd"]: r for r in rd("t_cat_categories.csv")}
    prod = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] == PRD}
    pmat = [r for r in rd("t_prd_product_materials.csv") if r["prd_cd"] == PRD]
    pproc = [r for r in rd("t_prd_product_processes.csv") if r["prd_cd"] == PRD]
    comp = {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    cp = rd("t_prc_component_prices.csv")
    fc = [r for r in rd("t_prc_formula_components.csv") if r["frm_cd"] == FRM]

    # 상품링크 del_yn (마스터 del과 구분)
    pmat_del = {r["mat_cd"]: r["del_yn"] for r in pmat}
    pproc_del = {r["proc_cd"]: r["del_yn"] for r in pproc}

    # base 면적매트릭스 SHAPE
    base = [r for r in cp if r["comp_cd"] == BASE_COMP]
    widths = sorted({_mm(r["siz_width"]) for r in base if r.get("siz_width")},
                    key=lambda x: int(x) if x.isdigit() else 0)
    heights = sorted({_mm(r["siz_height"]) for r in base if r.get("siz_height")},
                     key=lambda x: int(x) if x.isdigit() else 0)
    combos = {(_mm(r["siz_width"]), _mm(r["siz_height"])) for r in base
              if r.get("siz_width") and r.get("siz_height")}
    combos_rev = {(h, w) for (w, h) in combos}
    qty_bands = sorted({r["min_qty"] for r in base if r.get("min_qty")})

    def opt_shape(c):
        rows = [r for r in cp if r["comp_cd"] == c]
        return {"row_count": len(rows),
                "use_dims": comp[c]["use_dims"] if c in comp else "?",
                "comp_nm": comp[c]["comp_nm"] if c in comp else "?",
                "del_yn": comp[c].get("del_yn", "") if c in comp else "?"}

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP,
                 "generated_by": "transcribe_product_138.py"},
        "sizes": {s: {"siz_nm": siz[s]["siz_nm"],
                      "work": f'{_mm(siz[s]["work_width"])}x{_mm(siz[s]["work_height"])}',
                      "impos_yn": siz[s].get("impos_yn", ""), "del_yn": siz[s].get("del_yn", "")}
                  for s in SIZES if s in siz},
        "materials": {m: {"mat_nm": mat[m]["mat_nm"], "mat_typ_cd": mat[m]["mat_typ_cd"],
                          "master_del": mat[m].get("del_yn", ""),
                          "link_del": pmat_del.get(m, "(링크없음)")}
                      for m in MATS if m in mat},
        "processes": {p: {"proc_nm": proc[p]["proc_nm"], "master_del": proc[p].get("del_yn", ""),
                          "link_del": pproc_del.get(p, "(링크없음)")}
                      for p in PROCS if p in proc},
        "category": {CAT: {"cat_nm": cat[CAT]["cat_nm"], "cat_lvl": cat[CAT]["cat_lvl"],
                           "upr_cat_cd": cat[CAT]["upr_cat_cd"], "del_yn": cat[CAT].get("del_yn", "")}}
                    if CAT in cat else {},
        "qty": {"nonspec_yn": prod[PRD]["nonspec_yn"],
                "nonspec_w": f'{_mm(prod[PRD]["nonspec_width_min"])}~{_mm(prod[PRD]["nonspec_width_max"])}',
                "nonspec_h": f'{_mm(prod[PRD]["nonspec_height_min"])}~{_mm(prod[PRD]["nonspec_height_max"])}',
                "w_incr": _mm(prod[PRD]["nonspec_width_incr"]), "h_incr": _mm(prod[PRD]["nonspec_height_incr"]),
                "min_qty": prod[PRD]["min_qty"], "max_qty": prod[PRD]["max_qty"],
                "qty_incr": prod[PRD]["qty_incr"], "unit": prod[PRD]["qty_unit_typ_cd"]}
        if PRD in prod else {},
        "base_matrix": {"comp_cd": BASE_COMP, "row_count": len(base),
                        "use_dims": comp[BASE_COMP]["use_dims"] if BASE_COMP in comp else "?",
                        "distinct_w": len(widths), "distinct_h": len(heights),
                        "combo_count": len(combos),
                        "grid_w_range": f"{widths[0]}~{widths[-1]}" if widths else "-",
                        "grid_h_range": f"{heights[0]}~{heights[-1]}" if heights else "-",
                        "grid_full": len(combos) == len(widths) * len(heights) if widths and heights else False,
                        "asymmetric": bool(combos - combos_rev),
                        "qty_populated": len(qty_bands) > 0},
        "opt_components": {c: opt_shape(c) for c in OPT_COMPS},
        "formula": {"frm_cd": FRM, "comp_count": len(fc),
                    "comps": [(r["comp_cd"], r["disp_seq"], r["addtn_yn"]) for r in
                              sorted(fc, key=lambda x: int(x["disp_seq"]))]},
    }


def md(d):
    o = []
    def hdr(tbl, extra=""):
        o.append(f"<!-- transcribed-by: _meta/scripts/transcribe_product_138.py from {SNAP_ID} {tbl} PRD_000138{extra} @ {STAMP} -->")

    hdr("t_siz_sizes")
    o += ["| siz_cd | 라벨 | 작업(work mm) | 조판(impos_yn) | del_yn |", "|---|---|---|---|---|"]
    for s, v in d["sizes"].items():
        o.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["impos_yn"]} | {v["del_yn"] or "N"} |')
    o.append("")
    hdr("t_mat_materials")
    o += ["| mat_cd | 자재명 | mat_typ | 마스터 del | 상품링크 del | 비고 |", "|---|---|---|---|---|---|"]
    _mnote = {"MAT_000182": "본체(현수막천·dflt)", "MAT_000070": "설치용끈(CPQ)", "MAT_000337": "큐방(CPQ)",
              "MAT_000338": "각목 900이하(CPQ)", "MAT_000069": "양면테입(★마스터 삭제·item 참조 잔존)",
              "MAT_000340": "봉제사(★마스터 삭제·item 참조 잔존)", "MAT_000339": "각목 900초과(★완전 삭제)"}
    for m, v in d["materials"].items():
        o.append(f'| {m} | {v["mat_nm"]} | {v["mat_typ_cd"]} | {v["master_del"] or "N"} | {v["link_del"]} | {_mnote.get(m,"")} |')
    o.append("")
    hdr("t_proc_processes")
    o += ["| proc_cd | 공정명 | 마스터 del | 상품링크 del | 비고 |", "|---|---|---|---|---|"]
    _pnote = {"PROC_000080": "봉제(봉미싱 param)", "PROC_000081": "부착(끈/테입 등 대상)",
              "PROC_000104": "현수막타공(타공수 param·079 대체)", "PROC_000084": "열재단(★마스터 삭제·기본값 item 참조 잔존)",
              "PROC_000079": "타공(상품링크 삭제·104로 교체)"}
    for p, v in d["processes"].items():
        o.append(f'| {p} | {v["proc_nm"]} | {v["master_del"] or "N"} | {v["link_del"]} | {_pnote.get(p,"")} |')
    o.append("")
    hdr("t_cat_categories")
    o += ["| cat_cd | 분류명 | cat_lvl | 상위분류 | del_yn |", "|---|---|---|---|---|"]
    for c, v in d["category"].items():
        o.append(f'| {c} | {v["cat_nm"]} | {v["cat_lvl"]} | {v["upr_cat_cd"] or "-"} | {v["del_yn"] or "N"} |')
    o.append("")
    hdr("t_prd_products")
    o += ["| nonspec | 가로범위(mm·incr) | 세로범위(mm·incr) | min_qty | max_qty | qty_incr | 단위 |",
          "|---|---|---|---|---|---|---|"]
    q = d["qty"]
    o.append(f'| {q.get("nonspec_yn")} | {q.get("nonspec_w")} (incr {q.get("w_incr")}) '
             f'| {q.get("nonspec_h")} (incr {q.get("h_incr")}) | {q.get("min_qty")} | {q.get("max_qty")} '
             f'| {q.get("qty_incr")} | {q.get("unit")} |')
    o.append("")
    hdr("t_prc_component_prices", extra=" COMP_POSTER_BANNER_NORMAL(base SHAPE·값 미전사)")
    o += ["| comp_cd | 차원(use_dims) | 가로구간수 | 세로구간수 | 가로범위(mm) | 세로범위(mm) | (가로,세로)셀수 | 단가행수 | 격자완전 | 비대칭 | 수량축충전 |",
          "|---|---|---|---|---|---|---|---|---|---|---|"]
    b = d["base_matrix"]
    o.append(f'| {b["comp_cd"]} | {b["use_dims"]} | {b["distinct_w"]} | {b["distinct_h"]} '
             f'| {b["grid_w_range"]} | {b["grid_h_range"]} | {b["combo_count"]} | {b["row_count"]} '
             f'| {b["grid_full"]} | {b["asymmetric"]} | {b["qty_populated"]} |')
    o.append("")
    hdr("t_prc_formula_components + t_prc_component_prices", extra=" PRF_POSTER_BANNER_N(9 구성요소 배선·옵션 추가가격 SHAPE)")
    o += ["| disp_seq | comp_cd | addtn | use_dims | 단가행수 | 역할 |", "|---|---|---|---|---|---|"]
    _cnote = {"COMP_POSTER_BANNER_NORMAL": "base 면적매트릭스 완제품가([단독])",
              "COMP_POSTEROPT_BANNER_NORMAL_PROC_PUNCH_4": "타공 추가가격(현수막타공)",
              "COMP_POSTEROPT_BANNER_NORMAL_PROC_CUTEDGE": "열재단 추가가격",
              "COMP_POSTEROPT_BANNER_NORMAL_PROC_DTAPE": "양면테잎 추가가격",
              "COMP_POSTEROPT_BANNER_NORMAL_PROC_BONGSEW": "봉미싱 추가가격",
              "COMP_POSTEROPT_BANNER_NORMAL_ADD_QBANG_4": "큐방 추가가격",
              "COMP_POSTEROPT_BANNER_NORMAL_ADD_STRING_4": "끈 추가가격",
              "COMP_POPT_BNR_GAKMOK_STR_900_4_LE": "각목900이하+끈 추가가격",
              "COMP_POPT_BNR_GAKMOK_STR_900_4_GT": "각목900초과+끈 추가가격"}
    oc = d["opt_components"]
    for cc, seq, addtn in d["formula"]["comps"]:
        if cc == BASE_COMP:
            rc, ud = d["base_matrix"]["row_count"], d["base_matrix"]["use_dims"]
        else:
            rc, ud = oc.get(cc, {}).get("row_count", "?"), oc.get(cc, {}).get("use_dims", "?")
        o.append(f'| {seq} | {cc} | {addtn} | {ud} | {rc} | {_cnote.get(cc,"")} |')
    return "\n".join(o)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        os.makedirs(os.path.join(os.path.dirname(__file__), "cache"), exist_ok=True)
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-138-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print(md(d))
