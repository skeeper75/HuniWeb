#!/usr/bin/env python3
"""t49 screens.csv 조립 + 계약 검산. 읽기전용 입력 -> screens.csv 1개 산출."""
import collections
import csv
import os
import sys

HDR = [
    "system", "group", "screen_id", "screen_name", "role", "function", "work_type",
    "counterpart", "direction", "owner_side", "plan_row_id", "status", "evidence",
]
SYSTEMS = {"shopby", "edicus", "mes", "huni-mall", "webadmin", "widget", "pagebuilder", "pitstop"}
WORK = {"build", "integrate", "config", "provided", "manual"}
ROLES = {"고객", "운영자(CS·상품)", "생산(MES)", "관리자", "시스템(무인)"}
STATUS = {"완료", "진행", "미착수", "미확인"}
PARTS = ["_part-webadmin.csv", "_part-widget.csv", "_part-pagebuilder.csv"]
LINK = ("counterpart", "direction", "owner_side")
# 계약 보충 1 — 오픈과 인과관계 없는 기존 자산의 고정 접두. work_type 은 반드시 provided.
OUT_OF_SCOPE = "[오픈분모밖] "

rows: list[dict] = []
errs: list[str] = []

for part in PARTS:
    if not os.path.exists(part):
        errs.append(f"MISSING PART: {part}")
        continue
    with open(part, newline="", encoding="utf-8") as fh:
        reader = csv.DictReader(fh)
        if reader.fieldnames != HDR:
            errs.append(f"{part}: header mismatch -> {reader.fieldnames}")
        for i, row in enumerate(reader, 2):
            row["_src"] = f"{part}:{i}"
            rows.append(row)

valid_ids: set[str] = set()
PLAN_ROWS = "../../07_rebaseline/S/S5-plan/plan-rows.csv"
if os.path.exists(PLAN_ROWS):
    with open(PLAN_ROWS, newline="", encoding="utf-8") as fh:
        valid_ids = {r["row_id"] for r in csv.DictReader(fh)}
else:
    errs.append(f"MISSING plan-rows: {PLAN_ROWS}")


def cell(row: dict, name: str) -> str:
    """빈칸·누락을 같게 다룬다."""
    return (row.get(name) or "").strip()


seen: set[tuple] = set()
for row in rows:
    src = row["_src"]
    for field, allowed in (
        ("system", SYSTEMS), ("work_type", WORK), ("role", ROLES), ("status", STATUS),
    ):
        if cell(row, field) not in allowed:
            errs.append(f"{src}: {field}={row.get(field)!r} 는 허용값 밖")
    if not cell(row, "evidence"):
        errs.append(f"{src}: evidence 비어 있음(계약 금지)")

    if cell(row, "work_type") == "integrate":
        for field in LINK:
            if not cell(row, field):
                errs.append(f"{src}: integrate 인데 {field} 비어 있음")
    else:
        for field in LINK:
            if cell(row, field):
                errs.append(f"{src}: work_type={row.get('work_type')} 인데 {field} 채워짐")

    # 보충 1 개정(리드 260919): 접두는 고정 문자열이어야 하지만, work_type 은 provided 로 덮지 않고
    # 보충 3 축 그대로 적는다. 집계 제외는 접두가 진다 — 그래서 work_type 을 강제하는 검사는 없다.
    if cell(row, "evidence").startswith(OUT_OF_SCOPE.strip()) and not row["evidence"].startswith(OUT_OF_SCOPE):
        errs.append(f"{src}: 분모밖 접두가 고정 문자열 '{OUT_OF_SCOPE}' 과 다름")

    plan_row_id = cell(row, "plan_row_id")
    if plan_row_id != "NEW" and valid_ids and plan_row_id not in valid_ids:
        errs.append(f"{src}: plan_row_id={plan_row_id!r} 가 735행에 없음")

    key = (cell(row, "system"), cell(row, "screen_id"), cell(row, "function"))
    if key in seen:
        errs.append(f"{src}: 중복 행 {key}")
    seen.add(key)

rows.sort(key=lambda r: (cell(r, "system"), cell(r, "group"), cell(r, "screen_id")))
with open("screens.csv", "w", newline="", encoding="utf-8") as fh:
    writer = csv.DictWriter(fh, fieldnames=HDR, extrasaction="ignore")
    writer.writeheader()
    writer.writerows(rows)


def tally(field: str) -> dict:
    return dict(collections.Counter(cell(r, field) for r in rows))


print(f"rows={len(rows)}")
print("system:", tally("system"))
print("work_type:", tally("work_type"))
print("status:", tally("status"))
print("NEW:", sum(1 for r in rows if cell(r, "plan_row_id") == "NEW"))
print("분모밖(보충 1):", sum(1 for r in rows if r.get("evidence", "").startswith(OUT_OF_SCOPE)))
print(f"errors={len(errs)}")
for err in errs[:80]:
    print("  !", err)
sys.exit(1 if errs else 0)
