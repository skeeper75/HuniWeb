#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""인쇄상품 가격표 시트별 실무진 코멘트(셀 텍스트·주황/노랑 채색·설명형) 전수 추출.
답은 원본 셀에 다 있다 — 추측/재질문 금지, 이걸 읽어라. 새 버전 오면 XLSX만 바꿔 재실행.
사용: python3 extract_sheet_notes.py [xlsx경로]  (기본=260705)
"""
import sys, re, openpyxl
XLSX = sys.argv[1] if len(sys.argv) > 1 else "docs/huni/후니프린팅_인쇄상품_가격표_260705.xlsx"
KW = re.compile(r'의미|포함|합산|합가|단가|이하|이상|자동|주의|경우|마다|별도|기준|참고|제외|통용|직접입력|세트|구간|동판|박|판형|여백')
ORANGE = {'FFFF9900','FFFCE5CD','FFFEF1CC','FFFFF2CC','FFFFE599','FFFFFF00','FFFBD8D5','FFF4CCCC'}

wb = openpyxl.load_workbook(XLSX, data_only=True)
print(f"# {XLSX} — 시트별 실무진 코멘트/설명 셀")
for ws in wb.worksheets:
    rows = []
    for row in ws.iter_rows():
        for c in row:
            v = c.value
            if v is None:
                continue
            s = str(v).strip()
            if len(s) < 5 or not re.search(r'[가-힣]', s):
                continue
            f = c.fill
            rgb = getattr(f.fgColor, 'rgb', None) if f and f.patternType else None
            colored = rgb in ORANGE
            explain = len(s) >= 8 and KW.search(s) and not re.fullmatch(r'[\d,.\s원장개]+', s)
            if colored or explain:
                mark = "🟧" if colored else "  "
                rows.append(f"  {mark} {c.coordinate}: {s[:100]}")
    if rows:
        print(f"\n━━━ [{ws.title}] {len(rows)} ━━━")
        print("\n".join(rows))
