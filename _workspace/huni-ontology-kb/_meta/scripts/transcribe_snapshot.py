#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
전사 스크립트 (D-9·§4·[HARD] LLM 손전사 금지) — Huni-Ontology-KB.

라이브 스냅샷(live-snapshot/latest/) t_* CSV에서 디지털인쇄 파일럿 축 노드가 쓸
수치·배선을 결정론적으로 뽑아 ① JSON 캐시 ② 노드 본문에 붙일 markdown 표(transcribed-by
마커 포함)로 출력한다. 노드 파일의 사이즈 치수·가격공식 구성요소 배선은 이 스크립트가
전사한 것을 그대로 옮긴 것이며, 사람이 눈으로 읽어 손으로 옮기지 않는다.

사용:  python3 transcribe_snapshot.py            # stdout에 markdown 블록
       python3 transcribe_snapshot.py --json     # cache/transcribed-260703.json 갱신
원천:  _workspace/_foundation/live-snapshot/latest (= snap_20260702_1119)
"""
import csv, json, os, sys, datetime

SNAP = os.path.abspath(os.path.join(os.path.dirname(__file__),
       "../../../_foundation/live-snapshot/latest"))
SNAP_ID = "live-snapshot/latest (snap_20260702_1119)"
STAMP = "2026-07-03"

# 파일럿 8상품 (Phase 3 선정) — prd_cd 실측 검증용
PILOTS = {
    "PRD_000016": "프리미엄엽서", "PRD_000024": "포토카드", "PRD_000027": "2단접지카드",
    "PRD_000032": "코팅명함", "PRD_000033": "스탠다드명함", "PRD_000041": "스탠다드 쿠폰/상품권",
    "PRD_000043": "인쇄배경지(OPP봉투타입)", "PRD_000046": "라벨/택",
}
# 토대 공식 (PRF_DGP_* + 파일럿 고정가/배선교정)
FORMULAS = ["PRF_DGP_A", "PRF_DGP_B", "PRF_DGP_C", "PRF_DGP_D", "PRF_DGP_E", "PRF_DGP_F",
            "PRF_NAMECARD_COAT", "PRF_NAMECARD_FIXED", "PRF_PHOTOCARD_NORMAL"]
# 토대 공통 사이즈 (016 엽서 7행 + 국전 출력용지)
SIZES = ["SIZ_000001", "SIZ_000002", "SIZ_000003", "SIZ_000004",
         "SIZ_000005", "SIZ_000006", "SIZ_000007", "SIZ_000499"]


def rd(name):
    with open(os.path.join(SNAP, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))


def build():
    fcomp, pcomp = rd("t_prc_formula_components.csv"), {r["comp_cd"]: r for r in rd("t_prc_price_components.csv")}
    wiring = {}
    for r in fcomp:
        if r["frm_cd"] in FORMULAS:
            wiring.setdefault(r["frm_cd"], []).append(r)
    # disp_seq 정렬(빈값은 뒤로) — 결정론
    for frm in wiring:
        wiring[frm].sort(key=lambda x: (x.get("disp_seq") in (None, ""), _num(x.get("disp_seq")), x["comp_cd"]))

    sizes = {r["siz_cd"]: r for r in rd("t_siz_sizes.csv") if r["siz_cd"] in SIZES}
    prods = {r["prd_cd"]: r for r in rd("t_prd_products.csv") if r["prd_cd"] in PILOTS}
    bind = {}
    for r in rd("t_prd_product_price_formulas.csv"):
        if r["prd_cd"] in PILOTS:
            bind.setdefault(r["prd_cd"], []).append(r["frm_cd"])

    return {
        "meta": {"snapshot": SNAP_ID, "captured_at": STAMP, "generated_by": "transcribe_snapshot.py"},
        "pilots": {p: {"prd_nm": prods.get(p, {}).get("prd_nm"),
                       "prd_typ_cd": prods.get(p, {}).get("prd_typ_cd"),
                       "min_qty": prods.get(p, {}).get("min_qty"),
                       "formulas": bind.get(p, [])} for p in PILOTS},
        "wiring": {frm: [{"comp_cd": r["comp_cd"], "disp_seq": r.get("disp_seq") or "",
                          "addtn_yn": r.get("addtn_yn") or "",
                          "prc_typ_cd": pcomp.get(r["comp_cd"], {}).get("prc_typ_cd"),
                          "use_dims": pcomp.get(r["comp_cd"], {}).get("use_dims"),
                          "comp_nm": pcomp.get(r["comp_cd"], {}).get("comp_nm")}
                        for r in rows] for frm, rows in sorted(wiring.items())},
        "sizes": {s: {"siz_nm": sizes[s]["siz_nm"],
                      "work": f'{_mm(sizes[s]["work_width"])}x{_mm(sizes[s]["work_height"])}',
                      "cut": f'{_mm(sizes[s]["cut_width"])}x{_mm(sizes[s]["cut_height"])}'}
                  for s in SIZES if s in sizes},
    }


def _num(v):
    try:
        return float(v)
    except (TypeError, ValueError):
        return 1e9


def _mm(v):
    try:
        return str(int(float(v)))
    except (TypeError, ValueError):
        return "?"


def md_sizes(d):
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_snapshot.py from {SNAP_ID} t_siz_sizes @ {STAMP} -->",
           "| siz_cd | 라벨 | 작업(work mm) | 재단(cut mm) |", "|---|---|---|---|"]
    for s, v in d["sizes"].items():
        out.append(f'| {s} | {v["siz_nm"]} | {v["work"]} | {v["cut"]} |')
    return "\n".join(out)


def md_wiring(d, frm):
    rows = d["wiring"].get(frm, [])
    out = [f"<!-- transcribed-by: _meta/scripts/transcribe_snapshot.py from {SNAP_ID} t_prc_formula_components+t_prc_price_components frm_cd={frm} @ {STAMP} -->",
           "| disp_seq | comp_cd | addtn | prc_typ | comp_nm |", "|---|---|---|---|---|"]
    for r in rows:
        out.append(f'| {r["disp_seq"]} | {r["comp_cd"]} | {r["addtn_yn"]} | {r["prc_typ_cd"]} | {r["comp_nm"]} |')
    return "\n".join(out)


if __name__ == "__main__":
    d = build()
    if "--json" in sys.argv:
        p = os.path.join(os.path.dirname(__file__), "cache", "transcribed-260703.json")
        with open(p, "w", encoding="utf-8") as f:
            json.dump(d, f, ensure_ascii=False, indent=2, sort_keys=True)
        print("wrote", p)
    else:
        print("### 공통 사이즈 (전사)\n")
        print(md_sizes(d))
        for frm in FORMULAS:
            print(f"\n### {frm} 배선 (전사)\n")
            print(md_wiring(d, frm))
