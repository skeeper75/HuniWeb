#!/usr/bin/env python3
"""counterpart·direction 의 시스템 이름을 계약 8종 용어로 통일한다.

조사 에이전트 셋이 쇼핑몰 스킨을 저장소 이름(`huni-skin-shopby`)으로 적은 곳과
계약 용어(`huni-mall`)로 적은 곳이 섞였다. 같은 시스템이 두 이름으로 집계되면
t51 이 연동면을 둘로 센다. `s3` 는 계약 8종 밖이지만 실재하는 외부 상대이므로 그대로 둔다.
"""
import csv

RENAME = {"huni-skin-shopby": "huni-mall"}
PARTS = ["_part-webadmin.csv", "_part-widget.csv", "_part-pagebuilder.csv"]

for path in PARTS:
    with open(path, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        header = reader.fieldnames
        rows = list(reader)

    changed = 0
    for row in rows:
        before = (row["counterpart"], row["direction"])
        for old, new in RENAME.items():
            row["counterpart"] = row["counterpart"].replace(old, new)
            row["direction"] = row["direction"].replace(old, new)
        if (row["counterpart"], row["direction"]) != before:
            changed += 1

    with open(path, "w", newline="", encoding="utf-8") as fh:
        writer = csv.DictWriter(fh, fieldnames=header)
        writer.writeheader()
        writer.writerows(rows)
    print(f"{path}: {changed}행 이름 통일")
