#!/usr/bin/env python3
"""
공식형 구성요소 정합 전수 검증 — 원자합산형(구성요소 합산) 대상.
공식집(정답) 블록별 기대 구성요소 ↔ 라이브 PRF 구성요소 대조. 누락(core)·오염(allow밖) 적발.
false-positive 가드: 가변/추가상품/별색은 정당 옵션. block 정확배정(formula-block-map).

[HARD] 권위=공식집. 라이브 읽기전용. 산출=verify-atomic-260629.csv.
"""
import csv
import os
import lib_huni as H

HERE = os.path.dirname(os.path.abspath(__file__))
MAP = os.path.join(HERE, "..", "formula-block-map-260629.csv")
OUT = os.path.join(HERE, "..", "verify-atomic-260629.csv")

# 원자합산 블록별: core(필수 키워드·하나라도 없으면 누락) / allow(허용 전체·밖이면 오염)
SPEC = {
    "B03_엽서류": (["인쇄", "용지"],
                 ["인쇄", "별색", "용지", "코팅", "귀돌", "오시", "미싱", "가변", "후가공", "박", "추가"]),
    "B14_모양": (["인쇄", "용지", "커팅"], ["인쇄", "용지", "커팅", "코팅", "오시"]),
    "B18_배경지": (["인쇄", "용지"], ["인쇄", "용지", "접지", "타공", "커팅", "오시", "추가"]),
    "B24_전단": (["인쇄", "용지"], ["인쇄", "용지", "코팅", "후가공", "귀돌", "오시", "미싱"]),
    "B28_접지": (["인쇄", "용지"], ["인쇄", "용지", "코팅", "접지", "후가공", "박", "오시", "미싱", "커팅", "추가"]),
    "B48_썬캡": (["인쇄", "용지", "커팅"], ["인쇄", "용지", "커팅"]),
    "B94_캘린더": (["인쇄", "용지"], ["인쇄", "용지", "제본", "가공", "후가공", "코팅"]),
    # 원자합산세트: 부모공식=표지+제본(내지는 구성원). core=표지 or 제본(부모기준)
    "B63_책자무선": (["표지", "제본"], ["표지", "내지", "제본", "코팅", "용지", "후가공", "박", "합산"]),
    "B72_트윈링": (["표지", "제본"], ["표지", "내지", "제본", "코팅", "용지", "후가공", "합산"]),
    "B81_하드커버링": (["표지", "제본"], ["표지", "내지", "면지", "제본", "코팅", "용지", "후가공", "합산"]),
    "B_포토북": (["표지"], ["표지", "내지", "면지", "제본", "코팅", "용지", "완제품", "기본"]),
}


def latest_frm(prd):
    r = H.db(f"SELECT frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='{prd}' "
             f"ORDER BY apply_bgn_ymd DESC NULLS LAST LIMIT 1")
    return r[0][0] if r else None


def comps(frm):
    return H.db("SELECT pc.comp_nm FROM t_prc_formula_components fc "
                "JOIN t_prc_price_components pc ON fc.comp_cd=pc.comp_cd "
                f"WHERE fc.frm_cd='{frm}' ORDER BY fc.disp_seq")


def main():
    H.load_env()
    rows = list(csv.DictReader(open(MAP, encoding="utf-8")))
    targets = [r for r in rows if r["block"] in SPEC and r["status"] == "바인딩있음"]
    out = []
    print(f"원자합산형 구성요소 정합 검증  대상={len(targets)}")
    for r in targets:
        prd, nm, blk = r["prd_cd"], r["prd_nm"], r["block"]
        frm = latest_frm(prd)
        cs = [c[0] or "" for c in comps(frm)] if frm else []
        core, allow = SPEC[blk]
        miss = [k for k in core if not any(k in c for c in cs)]
        contam = [c for c in cs if not any(a in c for a in allow)]
        verdict = "OK" if (not miss and not contam) else ("누락" if miss else "오염")
        out.append({"prd_cd": prd, "prd_nm": nm, "block": blk, "frm": frm or "",
                    "n_comp": len(cs), "miss_core": ";".join(miss),
                    "contam": ";".join(contam), "verdict": verdict})
        mark = "" if verdict == "OK" else f"  ★{verdict} miss={miss} contam={contam}"
        print(f"  {prd} {nm[:16]:16} {blk:14} {frm or '없음':22} n={len(cs)} [{verdict}]{mark}")
    with open(OUT, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["prd_cd", "prd_nm", "block", "frm", "n_comp",
                                          "miss_core", "contam", "verdict"])
        w.writeheader()
        w.writerows(out)
    from collections import Counter
    v = Counter(o["verdict"] for o in out)
    print(f"\n[판정] {dict(v)}  →  {OUT}")


if __name__ == "__main__":
    main()
