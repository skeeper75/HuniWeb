#!/usr/bin/env python3
"""
authority — 권위 엑셀 추출 CSV(24_master-extract-260610) 리더.

상품마스터 260610 의 시트별 L1 추출 CSV 를 읽어, prd_nm 기준으로
각 상품의 권위 행(사이즈별)·주자재(종이)·권위 판수·OC 요구 축을 제공한다.
[HARD] 권위 엑셀이 절대 기준(SOT). 이 모듈은 읽기 전용이며 값을 날조하지 않는다.
"""
import os
import csv
import re

EXTRACT_DIR = os.path.abspath(os.path.join(
    os.path.dirname(__file__), "..", "..",
    "huni-dbmap", "24_master-extract-260610"))

# 상품군 → 추출 CSV 파일명
GROUP_CSV = {
    "digital-print": "digital-print-l1.csv",
    "booklet": "booklet-l1.csv",
    "acrylic": "acrylic-l1.csv",
    "goods-pouch": "goods-pouch-l1.csv",
    "calendar": "calendar-l1.csv",
    "design-calendar": "design-calendar-l1.csv",
    "photobook": "photobook-l1.csv",
    "silsa": "silsa-l1.csv",
    "map": "map-l1.csv",
    "product-accessory": "product-accessory-l1.csv",
}

# OC 요구 축 판정에 쓰는 권위 컬럼(비어있지 않으면 그 축을 손님이 골라야 함)
OC_AXIS_COLS = {
    "size": ["사이즈(필수)"],
    "material": ["종이(필수)", "소재(필수)", "자재(필수)"],
    "print_opt": ["인쇄(옵션)", "인쇄(필수)"],
    "spot_color": ["별색인쇄(옵션)_화이트", "별색인쇄(옵션)_클리어",
                   "별색인쇄(옵션)_핑크", "별색인쇄(옵션)_금색", "별색인쇄(옵션)_은색"],
    "coating": ["코팅(옵션)"],
    "cutting": ["커팅(옵션)"],
    "folding": ["접지(옵션)"],
    "finish": ["후가공(옵션)_모서리", "후가공(옵션)_오시", "후가공(옵션)_미싱",
               "후가공(옵션)_가변(텍스트)"],
    "qty": ["제작수량(필수)_최소"],
}


def norm_size(s):
    """'73 x 98 mm' / '73x98' → '73x98' (공백·mm 제거·소문자 x)."""
    if not s:
        return ""
    s = str(s).lower().replace("mm", "").replace(" ", "")
    s = s.replace("×", "x").replace("X", "x")
    return s.strip()


def _load_csv(group):
    fn = GROUP_CSV.get(group)
    if not fn:
        raise ValueError(f"미지원 상품군: {group}")
    path = os.path.join(EXTRACT_DIR, fn)
    with open(path, encoding="utf-8-sig") as f:
        return list(csv.DictReader(f))


def product_rows(group, prd_nm):
    """그 상품(prd_nm)의 권위 행 전부(사이즈별). _row_hidden=true 제외."""
    rows = _load_csv(group)
    out = [r for r in rows
           if (r.get("prd_nm") or "").strip() == prd_nm.strip()
           and (r.get("_row_hidden") or "").lower() != "true"]
    return out


def authority_pansu(group, prd_nm):
    """사이즈 → 권위 판수(판걸이수) 매핑. {norm_size: int}."""
    out = {}
    for r in product_rows(group, prd_nm):
        sz = norm_size(r.get("사이즈(필수)"))
        pansu = r.get("판수")
        if sz and pansu:
            try:
                out[sz] = int(float(pansu))
            except ValueError:
                pass
    return out


def main_materials(group, prd_nm):
    """권위 주자재(종이) 토큰 집합. '*별도설정'=손님 택1(목록 비특정)."""
    cols = OC_AXIS_COLS["material"]
    toks = set()
    freeform = False
    for r in product_rows(group, prd_nm):
        for c in cols:
            v = (r.get(c) or "").strip()
            if not v:
                continue
            if v.startswith("*") or "별도설정" in v:
                freeform = True
                continue
            for t in re.split(r"[\/,·\n]", v):
                t = t.strip()
                if t:
                    toks.add(t)
    return {"tokens": toks, "freeform": freeform}


def required_axes(group, prd_nm):
    """권위가 요구하는 OC 축 집합(컬럼에 값 있으면 needed)."""
    rows = product_rows(group, prd_nm)
    needed = set()
    for axis, cols in OC_AXIS_COLS.items():
        for r in rows:
            if any((r.get(c) or "").strip() for c in cols):
                needed.add(axis)
                break
    return needed


def price_formula_note(group, prd_nm):
    """권위 가격공식 컬럼(있으면). 모델 분류 힌트."""
    for r in product_rows(group, prd_nm):
        for k, v in r.items():
            if v and ("[출력]" in str(v) or "x [" in str(v) or "면적" in str(v)):
                return str(v).strip()
    return ""


if __name__ == "__main__":
    # 셀프테스트: 프리미엄엽서 권위 추출
    print("판수:", authority_pansu("digital-print", "프리미엄엽서"))
    print("주자재:", main_materials("digital-print", "프리미엄엽서"))
    print("요구축:", sorted(required_axes("digital-print", "프리미엄엽서")))
    print("공식:", price_formula_note("digital-print", "프리미엄엽서"))
