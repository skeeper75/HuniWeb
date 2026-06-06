#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
엔진 부모/공식/배선/바인딩/코드 CSV 생성 (round-2 파일럿 5시트).

component_prices(transform_price_sheets.py 산출)의 distinct comp_cd를 토대로
나머지 t_prc_* / t_prd_* / t_cod_* 적재 CSV를 생성한다. DB 무접촉(파일 산출만).

설계 권위: dbm-price-formula SKILL + price-engine-ddl.md.
- comp_typ_cd: 인쇄=.01, 코팅=.02, 후가공=.04, 완제품가(봉투)=.06.
  (별색인쇄도 .01 인쇄비. 아크릴 인쇄가공비=.01 인쇄비.)
- frm_typ_cd: 합산형=FRM_TYPE.01, 단순형=FRM_TYPE.02 (C-5).
- .06 완제품비는 ref-base-codes 미존재 → t_cod_base_codes.csv 신규 코드행 1행.
- use_yn='Y'(C-8), addtn_yn='Y'(C-4 합산 플래그).
"""
import csv
import os

LOAD_DIR = os.path.join(os.path.dirname(__file__), "..", "load_price")
APPLY_YMD = "2026-06-01"


def read_comp_cds():
    path = os.path.join(LOAD_DIR, "t_prc_component_prices.csv")
    with open(path, encoding="utf-8") as f:
        return sorted({r["comp_cd"] for r in csv.DictReader(f)})


# ── comp_cd → (comp_nm, comp_typ_cd) 카탈로그 메타 ──
# comp_typ_cd: .01 인쇄비 / .02 코팅비 / .03 용지비 / .04 후가공비 / .05 박형압비 / .06 완제품비(신설)
COMP_META = {
    "COMP_COAT_MATTE":        ("무광코팅비", "PRC_COMPONENT_TYPE.02"),
    "COMP_COAT_GLOSSY":       ("유광코팅비", "PRC_COMPONENT_TYPE.02"),
    "COMP_PRINT_DIGITAL_S1":  ("디지털인쇄비(단면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_DIGITAL_S2":  ("디지털인쇄비(양면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_WHITE_S1":  ("별색인쇄비 화이트(단면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_WHITE_S2":  ("별색인쇄비 화이트(양면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_CLEAR_S1":  ("별색인쇄비 클리어(단면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_CLEAR_S2":  ("별색인쇄비 클리어(양면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_PINK_S1":   ("별색인쇄비 핑크(단면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_PINK_S2":   ("별색인쇄비 핑크(양면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_GOLD_S1":   ("별색인쇄비 금색(단면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_GOLD_S2":   ("별색인쇄비 금색(양면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_SILVER_S1": ("별색인쇄비 은색(단면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_PRINT_SPOT_SILVER_S2": ("별색인쇄비 은색(양면)", "PRC_COMPONENT_TYPE.01"),
    "COMP_ACRYL_CLEAR3T":     ("투명아크릴3T 인쇄가공비", "PRC_COMPONENT_TYPE.01"),
    "COMP_ACRYL_CLEAR15T":    ("투명아크릴1.5T 인쇄가공비", "PRC_COMPONENT_TYPE.01"),
    "COMP_ACRYL_MIRROR3T":    ("미러아크릴3T 인쇄가공비", "PRC_COMPONENT_TYPE.01"),
    "COMP_PP_CORNER_RIGHT":   ("모서리 직각", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_CORNER_ROUND":   ("모서리 둥근", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_CREASE_1L":      ("오시 1줄", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_CREASE_2L":      ("오시 2줄", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_CREASE_3L":      ("오시 3줄", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_PERF_1L":        ("미싱 1줄", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_PERF_2L":        ("미싱 2줄", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_PERF_3L":        ("미싱 3줄", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_VARTEXT_1EA":    ("가변텍스트 1개", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_VARTEXT_2EA":    ("가변텍스트 2개", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_VARTEXT_3EA":    ("가변텍스트 3개", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_VARIMG_1EA":     ("가변이미지 1개", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_VARIMG_2EA":     ("가변이미지 2개", "PRC_COMPONENT_TYPE.04"),
    "COMP_PP_VARIMG_3EA":     ("가변이미지 3개", "PRC_COMPONENT_TYPE.04"),
    "COMP_ENV_MAKING":        ("봉투제작 완제품가", "PRC_COMPONENT_TYPE.06"),
}

# ── 공식(frm_cd) 정의: 시트별 base 공식 ──
# coating/digital/acrylic/post-process = 원자합산형 공식의 구성요소(개별 공식 미부여 — 상위 상품공식에서 합산).
#   단, fit-gap 단계라 시트단위 "참조용 공식"은 만들지 않고, 봉투(완제품 단순형)만 상품바인딩 공식 생성.
# 봉투제작 = 단순형(FRM_TYPE.02): 판매가=[수량행][소재열] (단일 완제품가 component).
FORMULAS = [
    # frm_cd, frm_nm, frm_typ_cd, note
    ("PRF_ENV_MAKING", "봉투제작 소재/수량별 단가", "FRM_TYPE.02",
     "단순형: 판매가=[수량행][소재열] (계산공식집초안 행46). 완제품가 1 component. 봉투종류·소재는 component_prices 차원"),
]

# 공식↔구성요소 배선: 봉투 공식 → 봉투 완제품가 comp 1개
FORMULA_COMPONENTS = [
    # frm_cd, comp_cd, disp_seq, addtn_yn
    ("PRF_ENV_MAKING", "COMP_ENV_MAKING", 1, "Y"),
]

# 상품↔공식 바인딩: 봉투제작 상품(PRD_000050) → 봉투 공식
PRODUCT_PRICE_FORMULAS = [
    # prd_cd, frm_cd, apply_bgn_ymd, note
    ("PRD_000050", "PRF_ENV_MAKING", APPLY_YMD,
     "봉투제작→소재/수량별 단가 공식. 봉투종류(티켓/소/자켓/대) siz_cd 후니 등록 후 component_prices siz 채움"),
]

# 신규 코드행: PRC_COMPONENT_TYPE.06 완제품비 (ref-base-codes 미존재)
NEW_BASE_CODES = [
    # cod_cd, cod_nm, upr_cod_cd, disp_seq, use_yn, note
    ("PRC_COMPONENT_TYPE.06", "완제품비", "PRC_COMPONENT_TYPE", 6, "Y",
     "D-D 확정 신설(규칙⑩·AWK-7 해소). 완제품 통가격(비분해) 가격구성요소 유형. "
     "FK 부모 선행(t_prc_price_components보다 선적재). PRD_TYPE.01 완제품(상품분류)과 별개 축. "
     "봉투제작 COMP_ENV_MAKING이 사용"),
]


def w(name, header, rows):
    path = os.path.join(LOAD_DIR, name)
    with open(path, "w", encoding="utf-8", newline="") as f:
        wr = csv.writer(f)
        wr.writerow(header)
        for r in rows:
            wr.writerow(r)
    return path, len(rows)


def main():
    comp_cds = read_comp_cds()
    missing = [c for c in comp_cds if c not in COMP_META]
    if missing:
        raise SystemExit("comp_cd 메타 누락(침묵 금지): %s" % missing)

    # 1. t_prc_price_components (부모 카탈로그)
    comp_rows = []
    for c in comp_cds:
        nm, typ = COMP_META[c]
        comp_rows.append([c, nm, typ,
                          "round-2 파일럿 자동생성. comp_typ_cd=%s" % typ, "Y"])
    p1, n1 = w("t_prc_price_components.csv",
               ["comp_cd", "comp_nm", "comp_typ_cd", "note", "use_yn"], comp_rows)

    # 2. t_prc_price_formulas
    frm_rows = [[fc, fn, ft, note, "Y"] for fc, fn, ft, note in FORMULAS]
    p2, n2 = w("t_prc_price_formulas.csv",
               ["frm_cd", "frm_nm", "frm_typ_cd", "note", "use_yn"], frm_rows)

    # 3. t_prc_formula_components
    fcrows = [[fc, cc, ds, ay] for fc, cc, ds, ay in FORMULA_COMPONENTS]
    p3, n3 = w("t_prc_formula_components.csv",
               ["frm_cd", "comp_cd", "disp_seq", "addtn_yn"], fcrows)

    # 4. t_prd_product_price_formulas
    ppf = [[pc, fc, ay, note] for pc, fc, ay, note in PRODUCT_PRICE_FORMULAS]
    p4, n4 = w("t_prd_product_price_formulas.csv",
               ["prd_cd", "frm_cd", "apply_bgn_ymd", "note"], ppf)

    # 5. t_cod_base_codes (신규 코드행만)
    bc = [[cc, cn, up, ds, uy, note] for cc, cn, up, ds, uy, note in NEW_BASE_CODES]
    p5, n5 = w("t_cod_base_codes.csv",
               ["cod_cd", "cod_nm", "upr_cod_cd", "disp_seq", "use_yn", "note"], bc)

    print("생성 완료:")
    for p, n in [(p1, n1), (p2, n2), (p3, n3), (p4, n4), (p5, n5)]:
        print("  %-45s %d행" % (os.path.basename(p), n))
    print("\ncomp_typ_cd 분포:")
    from collections import Counter
    cnt = Counter(COMP_META[c][1] for c in comp_cds)
    for k, v in sorted(cnt.items()):
        print("  %s: %d" % (k, v))


if __name__ == "__main__":
    main()
