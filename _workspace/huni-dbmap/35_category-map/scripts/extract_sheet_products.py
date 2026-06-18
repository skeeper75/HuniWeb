#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""11 데이터시트의 distinct 상품명(prd_nm) 추출 — round-24 1단계."""
import csv, re, glob, os, unicodedata
from collections import OrderedDict

SRC = "_workspace/huni-dbmap/24_master-extract-260610"
OUT = "_workspace/huni-dbmap/35_category-map/_live/sheet_products.csv"

SHEETS = {
    "digital-print": "디지털인쇄", "sticker": "스티커", "booklet": "책자",
    "photobook": "포토북", "calendar": "캘린더", "design-calendar": "디자인캘린더",
    "silsa": "실사", "acrylic": "아크릴", "stationery": "문구",
    "goods-pouch": "굿즈파우치", "product-accessory": "상품악세사리",
}

def norm(s):
    if not s:
        return ""
    s = unicodedata.normalize("NFC", str(s)).strip()
    s = re.sub(r"[\s/\-_(),.·／]", "", s)
    return s

def main():
    rows = []
    for key, label in SHEETS.items():
        path = os.path.join(SRC, f"{key}-l1.csv")
        if not os.path.exists(path):
            print("MISSING", path); continue
        seen = OrderedDict()
        with open(path, encoding="utf-8-sig") as f:
            rd = csv.DictReader(f)
            for r in rd:
                nm = (r.get("prd_nm") or "").strip()
                if not nm or nm.lower() in ("none","nan"):
                    continue
                if nm not in seen:
                    seen[nm] = r.get("row_seq","")
        for nm, rseq in seen.items():
            rows.append({"sheet": key, "sheet_label": label, "prd_nm": nm,
                         "norm": norm(nm), "first_row": rseq})
        print(f"{label:8} ({key}): {len(seen)} distinct products")
    with open(OUT, "w", newline="", encoding="utf-8-sig") as f:
        w = csv.DictWriter(f, fieldnames=["sheet","sheet_label","prd_nm","norm","first_row"])
        w.writeheader(); w.writerows(rows)
    print("TOTAL sheet product rows:", len(rows))

if __name__ == "__main__":
    main()
