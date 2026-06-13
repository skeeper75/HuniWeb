#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
상품마스터 260610 13시트 L1 전수 충실추출 러너 (round-... 라이브 정정 단일 권위 갱신).

권위 입력 = docs/huni/후니프린팅_상품마스터_260610.xlsx (유일 추출 대상).
방법론 = 06_extract/scripts/extract_l1.py (G 기준서 구현체) 그대로 재사용.
  - 전 컬럼·전 행 무손실 보존, 속성별 단일컬럼 평면화 금지.
  - 그룹헤더 composite, 화이트리스트 ffill, 빈셀/유효0 보존, 셀메타 8축.
산출 = 24_master-extract-260610/<slug>-l1.csv + <slug>-l1-meta.csv + _master-extract-summary.json.
생성자 역할 — verify 게이트 미실행(검증은 dbm-validator 단계).
read-only. 원본·DB 무변경. 기존 06_extract(260527) 무수정.
"""
import os, sys, json

# extract_l1.extract_sheet 재사용 (06_extract/scripts 의 G 구현체)
ROOT = "/Users/innojini/Dev/HuniWeb"
sys.path.insert(0, os.path.join(ROOT, "_workspace/huni-dbmap/06_extract/scripts"))
from extract_l1 import extract_sheet  # noqa: E402

XLSX = os.path.join(ROOT, "docs/huni/후니프린팅_상품마스터_260610.xlsx")
SOURCE_FILE = "후니프린팅_상품마스터_260610.xlsx"
OUT = os.path.join(ROOT, "_workspace/huni-dbmap/24_master-extract-260610")

# 시트 -> 슬러그 (기존 06_extract 와 동일)
SLUG = {
    "계산공식집초안": "calc-formula-draft",
    "MAP": "map",
    "디지털인쇄": "digital-print",
    "스티커": "sticker",
    "책자": "booklet",
    "포토북(가격포함)": "photobook",
    "캘린더": "calendar",
    "디자인캘린더(가격포함)": "design-calendar",
    "실사": "silsa",
    "아크릴": "acrylic",
    "문구(가격포함)": "stationery",
    "굿즈파우치(가격포함)": "goods-pouch",
    "상품악세사리(가격포함)": "product-accessory",
}
SHEETS = list(SLUG.keys())


def main() -> None:
    summaries = {}
    for sheet in SHEETS:
        slug = SLUG[sheet]
        out_csv = os.path.join(OUT, f"{slug}-l1.csv")
        out_meta = os.path.join(OUT, f"{slug}-l1-meta.csv")
        s = extract_sheet(XLSX, sheet, out_csv, out_meta)
        summaries[sheet] = s
        print(f"[{slug}] rec={s['record_count']} fields={s['field_count']} "
              f"hidden_rows={s['hidden_row_count']} hidden_cols={s['hidden_col_count']} "
              f"formula={s['formula_cells']} hyperlink={s['hyperlink_cells']} "
              f"comments={s['comments_total']}")
    with open(os.path.join(OUT, "_master-extract-summary.json"), "w", encoding="utf-8") as f:
        json.dump({"source_file": SOURCE_FILE, "summaries": summaries, "slug": SLUG},
                  f, ensure_ascii=False, indent=2)
    total = sum(v["record_count"] for v in summaries.values())
    print(f"\n=== 13 sheets extracted, total records={total}, source={SOURCE_FILE} ===")


if __name__ == "__main__":
    main()
