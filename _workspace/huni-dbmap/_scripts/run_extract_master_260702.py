#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
상품마스터 260702 13시트 L1 전수 충실추출 러너 (권위 재고정 스텝1a).

260610 러너(24_master-extract-260610/_run_extract_260610.py)의 파일경로만 260702로 교체.
방법론=06_extract/scripts/extract_l1.extract_sheet 그대로 재사용(결정론 openpyxl 추출).
비파괴: 기존 260610/260527 산출물 무수정. 산출=24_master-extract-260702/.
read-only. 원본·DB 무변경.
"""
import os, sys, json

ROOT = "/Users/innojini/Dev/HuniWeb"
sys.path.insert(0, os.path.join(ROOT, "_workspace/huni-dbmap/06_extract/scripts"))
from extract_l1 import extract_sheet  # noqa: E402

XLSX = os.path.join(ROOT, "docs/huni/후니프린팅_상품마스터_260702.xlsx")
SOURCE_FILE = "후니프린팅_상품마스터_260702.xlsx"
OUT = os.path.join(ROOT, "_workspace/huni-dbmap/24_master-extract-260702")

# 시트 -> 슬러그 (260610 러너와 동일)
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
