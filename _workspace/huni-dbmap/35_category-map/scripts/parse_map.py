#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MAP 시트(고객 카테고리 IA) 결정적 파서 — round-24 1단계.
컬럼1~12 = 1차 카테고리. R3 = 카테고리명. 이후 행:
  '▶︎' 접두 = 섹션 헤더(상품 아님)
  '→' 접두 = 별칭/교차참조
  일반 텍스트 = 상품 엔트리
산출: map-entries.csv (좌표·카테고리·유형·정규화명).
"""
import csv, re, sys, unicodedata
import openpyxl

XLSX = "docs/huni/후니프린팅_상품마스터_260610.xlsx"
OUT = "_workspace/huni-dbmap/35_category-map/map-entries.csv"

def norm(s):
    """공백·괄호·특수문자 제거 정규화(한글 음절 보존)."""
    if s is None:
        return ""
    s = unicodedata.normalize("NFC", str(s)).strip()
    # 장식/별칭/섹션 마커 제거
    s = re.sub(r"[▶▷►▼▶︎→→]", "", s)
    s = re.sub(r"[\s/\-_(),.·／]", "", s)
    return s.strip()

def main():
    wb = openpyxl.load_workbook(XLSX, data_only=True)
    ws = wb["MAP"]
    # 카테고리 헤더는 R3에서 읽음
    rows = list(ws.iter_rows(values_only=False))
    # 헤더 행(R1, index 0) — 1차 카테고리명
    header = {}
    for c in rows[0]:
        v = c.value
        if v and re.match(r"^\d{2}\s", str(v).strip()):
            header[c.column] = str(v).strip()
    entries = []
    for r_idx, row in enumerate(rows):
        if r_idx < 1:  # R1 헤더 skip
            continue
        for c in row:
            if c.column not in header:
                continue
            v = c.value
            if v is None:
                continue
            txt = unicodedata.normalize("NFC", str(v)).strip()
            if not txt:
                continue
            # 카테고리명 반복(01 엽서 등)은 skip(헤더 재출현)
            if re.match(r"^\d{2}\s", txt) and txt == header[c.column]:
                continue
            # 유형 판정
            is_section = bool(re.match(r"^[▶▷►▼▶]", txt))
            is_alias = ("→" in txt or "→" in txt) and not is_section
            if is_section:
                etype = "section"
            elif is_alias:
                etype = "alias"
            else:
                etype = "product"
            entries.append({
                "category": header[c.column],
                "cell": c.coordinate,
                "col": c.column_letter,
                "row": c.row,
                "type": etype,
                "raw": txt,
                "norm": norm(txt),
            })
    with open(OUT, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=["category","cell","col","row","type","raw","norm"])
        w.writeheader()
        w.writerows(entries)
    # 요약
    from collections import Counter
    tc = Counter(e["type"] for e in entries)
    cc = Counter(e["category"] for e in entries)
    print("TOTAL", len(entries), dict(tc))
    for k in sorted(cc):
        sub = [e for e in entries if e["category"]==k]
        ts = Counter(e["type"] for e in sub)
        print(f"  {k}: total={len(sub)} {dict(ts)}")

if __name__ == "__main__":
    main()
