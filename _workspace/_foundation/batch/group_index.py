#!/usr/bin/env python3
"""
group_index — prd_nm → 권위 시트(그룹) 자동 해소 인덱스.

빌드스크립트 일반 sweep(general)이 "모든 상품"을 권위 그룹에 매핑하기 위한
결정론 인덱스. 24_master-extract-260610 의 13개 L1 CSV(시트별)에서
prd_nm 을 수집해 역인덱스를 만든다(라이브 prd_nm ↔ 권위 시트).

★(가격포함) 시트 의미[사용자 directive]: 시트명에 '(가격포함)'이 있으면
그 상품군은 옵션이 결합되어 마스터 시트 자체에서 가격이 계산되는 부분이다
(별도 인쇄상품 가격표가 아니라 마스터 시트에 가격 내장). 따라서 그 시트의
미바인딩 상품은 "가격 원천 없음"이 아니라 "마스터 시트에서 추출 설계 가능"
(UNBOUND-PRICE-IN-SHEET)으로 분류해야 한다.

[HARD] 읽기 전용·값 날조 0. prd_nm 정확 일치(공백 정규화)만 신뢰.
"""
import os
import csv
import glob

EXTRACT_DIR = os.path.abspath(os.path.join(
    os.path.dirname(__file__), "..", "..",
    "huni-dbmap", "24_master-extract-260610"))

# 그룹명(authority.GROUP_CSV 키) → L1 CSV 파일명
GROUP_CSV = {
    "digital-print": "digital-print-l1.csv",
    "booklet": "booklet-l1.csv",
    "acrylic": "acrylic-l1.csv",
    "sticker": "sticker-l1.csv",
    "stationery": "stationery-l1.csv",
    "goods-pouch": "goods-pouch-l1.csv",
    "calendar": "calendar-l1.csv",
    "design-calendar": "design-calendar-l1.csv",
    "photobook": "photobook-l1.csv",
    "silsa": "silsa-l1.csv",
    "map": "map-l1.csv",
    "product-accessory": "product-accessory-l1.csv",
}

# 다중 매칭(같은 prd_nm 이 여러 시트) 시 우선순위.
# 캘린더: design-calendar(가격포함=마스터 가격 내장)를 우선(더 유용한 권위).
# 떡메모지: booklet(세트) 우선 — 세트 경로에서 채점되므로 일반 sweep 제외.
GROUP_PRIORITY = [
    "photobook", "booklet", "design-calendar", "calendar", "acrylic",
    "sticker", "digital-print", "silsa", "goods-pouch",
    "product-accessory", "stationery", "map",
]


def _norm(s):
    return (s or "").strip()


def build_index():
    """반환:
       idx        : {prd_nm: set(group,...)}
       pricein    : {group: bool}  — 시트명에 '(가격포함)' 포함 여부
    """
    idx = {}
    pricein = {}
    for g, fn in GROUP_CSV.items():
        path = os.path.join(EXTRACT_DIR, fn)
        if not os.path.exists(path):
            continue
        with open(path, encoding="utf-8-sig") as f:
            for r in csv.DictReader(f):
                sh = _norm(r.get("sheet"))
                if sh:
                    pricein[g] = "가격포함" in sh
                nm = _norm(r.get("prd_nm"))
                if nm:
                    idx.setdefault(nm, set()).add(g)
    return idx, pricein


_IDX = None
_PRICEIN = None


def _ensure():
    global _IDX, _PRICEIN
    if _IDX is None:
        _IDX, _PRICEIN = build_index()


def resolve_group(prd_nm):
    """prd_nm → (group, ambiguous_bool, all_groups_set).
       미발견이면 (None, False, set())."""
    _ensure()
    gs = _IDX.get(_norm(prd_nm))
    if not gs:
        return None, False, set()
    if len(gs) == 1:
        return next(iter(gs)), False, gs
    # 다중 — 우선순위로 결정 + ambiguous 플래그
    for g in GROUP_PRIORITY:
        if g in gs:
            return g, True, gs
    return sorted(gs)[0], True, gs


def is_pricein_sheet(group):
    """그 그룹 시트가 '(가격포함)'(마스터 가격 내장)인가."""
    _ensure()
    return bool(_PRICEIN.get(group))


if __name__ == "__main__":
    idx, pricein = build_index()
    print(f"prd_nm 인덱스 {len(idx)}건 · 가격포함 시트:",
          sorted(g for g, v in pricein.items() if v))
    for nm in ["프리미엄엽서", "만년다이어리", "아크릴입체코롯토", "탁상형캘린더"]:
        print(f"  {nm} → {resolve_group(nm)}")
