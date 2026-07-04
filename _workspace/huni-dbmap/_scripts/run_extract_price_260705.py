#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
인쇄상품 가격표 260705 L1 전수 재추출 러너 (권위 재고정 스텝1a·260702→260705).

기존 260527 추출기(06_extract/scripts/extract_price_sheets.py + extract_price.py)를
그대로 재사용하되, 모듈 전역 XLSX/OUT만 260705 입력·새 출력디렉토리로 monkeypatch.
  - extract_price_sheets: 15 단가시트 → price-<slug>-l1.csv (+ _price-sheets-extract-raw.json)
  - extract_price:        판걸이수(pangeori) + 출력소재IMPORT(import-paper) (+ _price-extract-summary.json)
비파괴: 06_extract(260527)·24_price-extract-260702 무수정. 산출=24_price-extract-260705/.
read-only. 원본·DB 무변경.

260702→260705 실변경(3): 엽서북떡메 수량 최소구간 2→1 신설(값은 수량2 복제·기존가 불변) ·
출력소재IMPORT '레더 링바인더 A4' 신규 소재(636*374 기준 9000) · 제본 싸바리바인더→링바인더 명칭.
"""
import os, sys

ROOT = "/Users/innojini/Dev/HuniWeb"
SCRIPTS = os.path.join(ROOT, "_workspace/huni-dbmap/06_extract/scripts")
sys.path.insert(0, SCRIPTS)

XLSX_260705 = os.path.join(ROOT, "docs/huni/후니프린팅_인쇄상품_가격표_260705.xlsx")
OUT_260705 = os.path.join(ROOT, "_workspace/huni-dbmap/24_price-extract-260705")


def run_price_sheets():
    import extract_price_sheets as m
    m.XLSX = XLSX_260705
    m.OUT = OUT_260705
    print("--- extract_price_sheets (15 단가시트) → 260705 ---")
    m.main()


def run_price_pangeori_import():
    import extract_price as m
    m.XLSX = XLSX_260705
    m.OUT = OUT_260705
    print("--- extract_price (판걸이수 + 출력소재IMPORT) → 260705 ---")
    m.main()


if __name__ == "__main__":
    run_price_sheets()
    run_price_pangeori_import()
    print(f"\n=== price L1 re-extracted → {OUT_260705} ===")
