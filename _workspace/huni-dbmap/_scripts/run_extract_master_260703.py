#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
상품마스터 260703 13시트 L1 전수 충실추출 러너 (권위 재고정 스텝1a·260702→260703).

260702 러너(run_extract_master_260702.py)의 파일경로만 260703로 교체.
방법론=06_extract/scripts/extract_l1.extract_sheet 그대로 재사용(결정론 openpyxl 추출).
비파괴: 기존 260702/260610/260527 산출물 무수정. 산출=24_master-extract-260703/.
read-only. 원본·DB 무변경.

260702→260703 실변경(3): MAP '만년스탬프 리필잉크' 신규 · 디자인캘린더 '디자인보유' 열 제거 ·
굿즈파우치 사이즈 3정정(슬로건 625x315/315x625 · 초슬림마우스패드 240x158).
"""
import os, sys, json

ROOT = "/Users/innojini/Dev/HuniWeb"
sys.path.insert(0, os.path.join(ROOT, "_workspace/huni-dbmap/06_extract/scripts"))
from extract_l1 import extract_sheet  # noqa: E402

XLSX = os.path.join(ROOT, "docs/huni/후니프린팅_상품마스터_260703.xlsx")
SOURCE_FILE = "후니프린팅_상품마스터_260703.xlsx"
OUT = os.path.join(ROOT, "_workspace/huni-dbmap/24_master-extract-260703")

# 시트 -> 슬러그 (260702 러너와 동일)
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
