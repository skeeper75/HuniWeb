#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
상품마스터 13시트 L1 전수 추출 + verify 9게이트 배치 러너.
한글 시트명 -> 영문 슬러그 파일명. extract_l1.extract_sheet + verify_l1.run 재사용.
read-only. 산출만 06_extract/.
"""
import os, sys, json
sys.path.insert(0, os.path.dirname(__file__))
from extract_l1 import extract_sheet
from verify_l1 import run as verify_run

ROOT = "/Users/innojini/Dev/HuniWeb"
XLSX = os.path.join(ROOT, "docs/huni/후니프린팅_상품마스터_260527.xlsx")
OUT = os.path.join(ROOT, "_workspace/huni-dbmap/06_extract")

# 시트 -> 슬러그 (영문)
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

def main():
    summaries = {}
    gates = {}
    for sheet in SHEETS:
        slug = SLUG[sheet]
        out_csv = os.path.join(OUT, f"{slug}-l1.csv")
        out_meta = os.path.join(OUT, f"{slug}-l1-meta.csv")
        s = extract_sheet(XLSX, sheet, out_csv, out_meta)
        overall, results = verify_run(XLSX, sheet, out_csv, out_meta)
        summaries[sheet] = s
        gates[sheet] = {"overall": overall, "results": results}
        print(f"[{slug}] extract: rec={s['record_count']} fields={s['field_count']} "
              f"hidden_rows={s['hidden_row_count']} hidden_cols={s['hidden_col_count']} "
              f"formula={s['formula_cells']} hyperlink={s['hyperlink_cells']} "
              f"comments={s['comments_total']} | VERIFY={'PASS' if overall else 'FAIL'}")
        if not overall:
            for gname, g in results.items():
                if not g.get("pass", True):
                    print(f"    FAIL gate: {gname} -> {json.dumps(g, ensure_ascii=False)[:300]}")
    # dump combined json for report build
    with open(os.path.join(OUT, "_master-extract-summary.json"), "w", encoding="utf-8") as f:
        json.dump({"summaries": summaries, "gates": gates, "slug": SLUG},
                  f, ensure_ascii=False, indent=2)
    npass = sum(1 for g in gates.values() if g["overall"])
    print(f"\n=== {npass}/{len(SHEETS)} sheets PASS all 9 gates ===")

if __name__ == "__main__":
    main()
