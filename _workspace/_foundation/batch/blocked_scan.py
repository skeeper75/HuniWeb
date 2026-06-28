#!/usr/bin/env python3
"""
blocked_scan — 두 권위 엑셀의 BLOCKED 위험 요소 전수 발굴(결정론).

상품마스터(24_master-extract-260610 *-l1.csv)를 스캔해 애매모호/미상 단가가 될 수 있는
셀을 카테고리로 분류한 레지스트리를 산출한다. 라이브 오라클로 카테고리 단위 해소하기 위한 자.

카테고리:
  FREEFORM_PAPER  별도설정 종이(자유선택·단가 미특정)        → 라이브 종이목록+무료여부
  ADDON_CONSTRAINT ★ 추가상품(추가상품 vs 제약 애매)          → 라이브 옵션구조
  FOIL_SIZE       ★ 박/형압 크기(크기 등급가)                  → 라이브 박 등급
  PROCESS_OPT     ★ 접지/코팅/커팅(공정 옵션 제약)             → 라이브 옵션
  POUCH_PRODUCT   ★ goods-pouch 상품(옵션)(최대 군집)          → 라이브 상품 옵션
  LINING_RING     ★ 면지/바인더링                              → 라이브(면지=무료 확인됨)
[HARD] 읽기 전용·값 날조 0. 출력=blocked-risk-registry.csv.
"""
import csv
import glob
import os

EXTRACT = os.path.abspath(os.path.join(
    os.path.dirname(__file__), "..", "..", "huni-dbmap", "24_master-extract-260610"))
OUT = os.path.join(os.path.dirname(__file__), "blocked-risk-registry.csv")

SKIP_COLS = {"sheet", "row_seq", "prd_nm", "_anchor_ffilled", "_row_hidden",
             "_work_size_col", "_work_size_value", "상품명", "ID", "MES ITEM_CD", "구분"}


# 카테고리 → 해소 (라이브/가격표 대조 결과 2026-06-29)
RESOLUTION = {
    "FREEFORM_PAPER": "PRICE_KNOWN — 별도설정=손님 종이 택1·단가=COMP_PAPER 절가(56행 적재). per-product 미적재는 score_batch CALC가 적발(투명엽서 PET처럼).",
    "FOIL_SIZE": "PRICE_KNOWN+CONSTRAINT — 박단가=가격표 후가공_박(소형 크기×수량·대형 면적격자·백업 동판)·라이브 COMP_*_FOIL 적재. ★크기=제약(셀에 min/max). ⚠️박 prc_typ .01/.02 혼재=band-total 점검.",
    "ADDON_CONSTRAINT": "PRICE_KNOWN+CONSTRAINT — 봉투류 단가=가격표 봉투제작[9] L2·COMP_ENV_MAKING 적재. ★사이즈선택=제약(셀에 값). addon=템플릿 mint·constraint=파싱.",
    "PROCESS_OPT": "PRICE_KNOWN+ENUM — 접지/코팅/커팅 단가=가격표 L1 블록. ★=종류 enumeration(셀에 값). 옵션 파싱.",
    "POUCH_PRODUCT": "CONSTRAINT/OC — 폰모델 variants(셀에 값). 가격=goods-pouch 가격표. 모델별 사이즈 variant 파싱.",
    "LINING_RING": "RESOLVED — 조건부 규칙(★...선택시만). 면지=무료 확인(hc072 라이브). 규칙 파싱.",
    "OTHER_STAR": "REVIEW — 개별 검토.",
    "FREEFORM_OTHER": "REVIEW — 종이 외 별도설정 개별 검토.",
}


def categorize(col, val):
    """(category, marker) 또는 None."""
    has_star = "★" in val
    is_free = ("별도설정" in val) or (val.strip() == "별도")
    c = col
    if is_free and ("종이" in c or "용지" in c or "소재" in c):
        return ("FREEFORM_PAPER", "별도설정")
    if has_star and "추가상품" in c:
        return ("ADDON_CONSTRAINT", "★")
    if has_star and ("박" in c or "형압" in c):
        return ("FOIL_SIZE", "★")
    if has_star and ("접지" in c or "코팅" in c or "커팅" in c):
        return ("PROCESS_OPT", "★")
    if has_star and "상품(옵션)" in c:
        return ("POUCH_PRODUCT", "★")
    if has_star and ("면지" in c or "바인더링" in c or "링" in c):
        return ("LINING_RING", "★")
    if has_star:
        return ("OTHER_STAR", "★")
    if is_free:
        return ("FREEFORM_OTHER", "별도설정")
    return None


def main():
    rows = []
    for fn in sorted(glob.glob(os.path.join(EXTRACT, "*-l1.csv"))):
        if "meta" in os.path.basename(fn):
            continue
        sheet = os.path.basename(fn).replace("-l1.csv", "")
        with open(fn, encoding="utf-8-sig") as f:
            for r in csv.DictReader(f):
                if (r.get("_row_hidden") or "").lower() == "true":
                    continue
                prd = (r.get("prd_nm") or "").strip()
                for col, val in r.items():
                    if col in SKIP_COLS:
                        continue
                    v = (val or "").strip()
                    if not v:
                        continue
                    cat = categorize(col, v)
                    if cat:
                        rows.append({
                            "sheet": sheet, "prd_nm": prd, "column": col,
                            "value": v[:60], "category": cat[0], "marker": cat[1]})

    for r in rows:
        r["resolution"] = RESOLUTION.get(r["category"], "")
    with open(OUT, "w", newline="", encoding="utf-8") as f:
        w = csv.DictWriter(f, fieldnames=["category", "sheet", "prd_nm", "column", "value", "marker", "resolution"])
        w.writeheader()
        w.writerows(sorted(rows, key=lambda x: (x["category"], x["sheet"], x["prd_nm"])))

    # 카테고리 집계
    import collections
    cat_n = collections.Counter(r["category"] for r in rows)
    cat_prod = collections.defaultdict(set)
    for r in rows:
        cat_prod[r["category"]].add((r["sheet"], r["prd_nm"]))
    print(f"BLOCKED 위험 요소 {len(rows)}건 → {OUT}\n")
    print(f"{'카테고리':18s} {'셀수':>5s} {'상품수':>6s}")
    for cat, n in cat_n.most_common():
        print(f"{cat:18s} {n:5d} {len(cat_prod[cat]):6d}")


if __name__ == "__main__":
    main()
