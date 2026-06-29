#!/usr/bin/env python3
"""
공식집(상품마스터 계산공식집초안) = 정답 → 라이브 PRF/COMP 바인딩이 일치하는지 검증.
파일럿: 엽서군(원자합산형 block 3-12) + 책자 셋트군(block 63-89).

[HARD] 권위=공식집(엑셀). 라이브=검증대상. 라이브 읽기전용 SELECT만. 값 날조 0.
"""
import re
import lib_huni as H

# 공식집 기대 구성요소(키워드) — decode §2
EXPECT = {
    "엽서류": {"core": ["인쇄", "용지"], "opt": ["코팅", "별색", "후가공", "귀돌", "오시", "미싱", "박", "추가"]},
    "책자": {"core": ["내지", "표지", "제본"], "opt": ["코팅", "용지", "면지", "후가공", "박"]},
}


def latest_frm(prd):
    r = H.db(f"SELECT frm_cd FROM t_prd_product_price_formulas WHERE prd_cd='{prd}' "
             f"ORDER BY apply_bgn_ymd DESC NULLS LAST LIMIT 1")
    return r[0][0] if r else None


def frm_comps(frm):
    if not frm:
        return []
    rows = H.db(
        "SELECT fc.disp_seq, fc.comp_cd, pc.comp_nm, fc.addtn_yn, pc.prc_typ_cd, "
        "COALESCE(pc.use_dims::text,''), COALESCE(pc.del_yn,'N') "
        "FROM t_prc_formula_components fc "
        "JOIN t_prc_price_components pc ON fc.comp_cd=pc.comp_cd "
        f"WHERE fc.frm_cd='{frm}' ORDER BY fc.disp_seq")
    return rows


def kind(nm):
    nm = nm or ""
    for k in ["내지", "표지", "면지", "인쇄", "별색", "용지", "코팅", "제본",
              "귀돌", "오시", "미싱", "박", "타공", "커팅", "접지", "가변", "동판"]:
        if k in nm:
            return k
    return "기타"


def check(prd, nm, block):
    frm = latest_frm(prd)
    comps = frm_comps(frm)
    kinds = [kind(c[2]) for c in comps]
    exp = EXPECT[block]
    have_core = [c for c in exp["core"] if any(c in (cc[2] or "") for cc in comps)]
    miss_core = [c for c in exp["core"] if c not in have_core]
    # 오염 후보 = core/opt 어느 키워드에도 안 걸리는 구성요소
    allow = exp["core"] + exp["opt"]
    contam = [c for c in comps if not any(a in (c[2] or "") for a in allow)]
    return {"prd": prd, "nm": nm, "frm": frm, "n": len(comps),
            "kinds": kinds, "comps": comps,
            "miss_core": miss_core, "contam": contam}


def main():
    H.load_env()
    # 엽서군 — 디지털인쇄 시트 원자합산형 대상(이름 기준)
    eopseo = H.db(
        "SELECT prd_cd, prd_nm FROM t_prd_products "
        "WHERE (prd_nm LIKE '%엽서%' OR prd_nm LIKE '%상품권%' OR prd_nm LIKE '%슬로건%') "
        "AND COALESCE(del_yn,'N')<>'Y' ORDER BY prd_cd")
    # 책자 셋트 부모
    booklet = H.db(
        "SELECT DISTINCT s.prd_cd, p.prd_nm FROM t_prd_product_sets s "
        "JOIN t_prd_products p ON s.prd_cd=p.prd_cd "
        "WHERE COALESCE(s.del_yn,'N')<>'Y' ORDER BY s.prd_cd")

    print("="*78)
    print("파일럿 검증: 공식집(정답) vs 라이브 PRF/COMP 바인딩")
    print("="*78)

    for title, rows, block in [("[엽서군 — 원자합산형 block 3-12]", eopseo, "엽서류"),
                               ("[책자 셋트군 — block 63-89]", booklet, "책자")]:
        print(f"\n{title}  대상={len(rows)}")
        for prd, nm in rows:
            r = check(prd, nm, block)
            tag = "OK" if (r["frm"] and not r["miss_core"] and not r["contam"]) else \
                  ("미바인딩" if not r["frm"] else "신호")
            print(f"\n  {prd} {nm}  공식={r['frm'] or '없음'}  구성요소={r['n']}  [{tag}]")
            if r["frm"]:
                for ds, cc, cn, ad, pt, ud, dl in r["comps"]:
                    flag = ""
                    allow = EXPECT[block]["core"] + EXPECT[block]["opt"]
                    if not any(a in (cn or "") for a in allow):
                        flag = "  ←★공식집 밖(오염?)"
                    print(f"      - {cn}  [{cc}] addtn={ad} prc_typ={pt} dims={ud[:60]}{flag}")
            if r["miss_core"]:
                print(f"      ★누락(공식집 필수): {r['miss_core']}")


if __name__ == "__main__":
    main()
