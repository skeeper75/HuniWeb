#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
인쇄상품 가격표 260702 L1 전수 재추출 러너 (권위 재고정 스텝1a).

기존 260527 추출기(06_extract/scripts/extract_price_sheets.py + extract_price.py)를
그대로 재사용하되, 모듈 전역 XLSX/OUT만 260702 입력·새 출력디렉토리로 monkeypatch.
  - extract_price_sheets: 15 단가시트 → price-<slug>-l1.csv (+ _price-sheets-extract-raw.json)
  - extract_price:        판걸이수(pangeori) + 출력소재IMPORT(import-paper) (+ _price-extract-summary.json)
비파괴: 06_extract(260527) 무수정. 산출=24_price-extract-260702/.
read-only. 원본·DB 무변경.
"""
import os, sys

ROOT = "/Users/innojini/Dev/HuniWeb"
SCRIPTS = os.path.join(ROOT, "_workspace/huni-dbmap/06_extract/scripts")
sys.path.insert(0, SCRIPTS)

XLSX_260702 = os.path.join(ROOT, "docs/huni/후니프린팅_인쇄상품_가격표_260702.xlsx")
OUT_260702 = os.path.join(ROOT, "_workspace/huni-dbmap/24_price-extract-260702")


def run_price_sheets():
    import extract_price_sheets as m
    m.XLSX = XLSX_260702
    m.OUT = OUT_260702
    print("--- extract_price_sheets (15 단가시트) → 260702 ---")
    m.main()


def run_price_pangeori_import():
    import extract_price as m
    m.XLSX = XLSX_260702
    m.OUT = OUT_260702
    print("--- extract_price (판걸이수 + 출력소재IMPORT) → 260702 ---")
    m.main()


if __name__ == "__main__":
    run_price_sheets()
    run_price_pangeori_import()
    print(f"\n=== price L1 re-extracted → {OUT_260702} ===")
