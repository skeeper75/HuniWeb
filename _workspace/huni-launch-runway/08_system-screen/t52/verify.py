# -*- coding: utf-8 -*-
"""t52 검산 — rejudge.csv 의 근거가 실재하는지, 판정 분류가 닫히는지 확인.
G1 분모 83 보존(입력=산출·순서 동일) / G2 판정 3분류 전수 / G3 근거 path:line 전수 실재 /
G4 83행 전부가 레인 원장 plan_row_id 에 부재(미수록 전제) / G5 라우팅 판정의 1차 근거가 레인
screens.csv 실재 행이고 그 행의 plan_row_id 가 미수록 id 와 다름 / G6 인용 plan_row_id 실재 /
G7 verdict.md 의 「빠진 일」 묶음 분해가 전수·무중복."""
import csv, re, sys, pathlib
BASE = pathlib.Path(__file__).resolve().parent.parent
REF = re.compile(r'([A-Za-z0-9_./-]+\.(?:csv|md|txt|py)):(\d+)')
LABELS = {"빠진 일", "라우팅 대상 오류", "불필요"}

rows = list(csv.DictReader(open(BASE / 't52/rejudge.csv', encoding='utf-8')))
src = list(csv.DictReader(open(BASE / 't52/unlisted-input.csv', encoding='utf-8')))
ledger = {}          # plan_row_id -> [ "t48/screens.csv:12", ... ]
for card in ('t48', 't49', 't50'):
    with open(BASE / card / 'screens.csv', encoding='utf-8') as f:
        for i, r in enumerate(csv.DictReader(f), start=2):
            ledger.setdefault(r['plan_row_id'], []).append(f"{card}/screens.csv:{i}")

fail = []
# G1
if len(rows) != 83 or len(rows) != len(src):
    fail.append(f"G1 분모 불일치: rejudge {len(rows)} vs 입력 {len(src)}")
if [r['plan_row_id'] for r in rows] != [r['원장행'] for r in src]:
    fail.append("G1 행 순서/집합 불일치")

# G2
bad = [r['plan_row_id'] for r in rows if r['판정'] not in LABELS]
if bad:
    fail.append(f"G2 미분류 판정: {bad}")

# G3
checked = 0
for r in rows:
    for ref in REF.finditer(r['근거'] + ' ' + r['근거 요지']):
        p, ln = BASE / ref.group(1), int(ref.group(2))
        checked += 1
        if not p.exists():
            fail.append(f"G3 파일 부재 {r['plan_row_id']}: {ref.group(0)}")
        elif len(p.read_text(encoding='utf-8').splitlines()) < ln:
            fail.append(f"G3 행 초과 {r['plan_row_id']}: {ref.group(0)}")

# G4 / G5 — 미수록 행 자신의 plan_row_id 는 어느 판정이든 레인 원장에 없어야 한다(미수록의 정의)
for r in rows:
    if r['plan_row_id'] in ledger:
        fail.append(f"G4 미수록 전제 붕괴 {r['plan_row_id']} → {ledger[r['plan_row_id']]}")

# G5 — 라우팅 판정 행의 1차 근거는 반드시 레인 screens.csv 의 실재 행이어야 하고,
#      그 행의 plan_row_id 는 미수록 id 와 달라야 한다(= 다른 id 로 이미 원장에 있다).
byline = {}          # "t48/screens.csv:12" -> row
for card in ('t48', 't49', 't50'):
    with open(BASE / card / 'screens.csv', encoding='utf-8') as f:
        for i, r in enumerate(csv.DictReader(f), start=2):
            byline[f"{card}/screens.csv:{i}"] = r
for r in rows:
    if r['판정'] != '라우팅 대상 오류':
        continue
    hit = byline.get(r['근거'])
    if hit is None:
        fail.append(f"G5 1차 근거가 레인 원장 행이 아님 {r['plan_row_id']}: {r['근거']}")
    elif hit['plan_row_id'] == r['plan_row_id']:
        fail.append(f"G5 근거 행의 plan_row_id 가 미수록 id 와 같음 {r['plan_row_id']}")

# G6 — 근거 요지에 인용한 다른 plan_row_id 는 레인 원장 / 미수록 83 / decisions.md 셋 중 하나에
#      실재해야 한다(어디에도 없는 id 를 지어내지 않았음을 담보).
PID = re.compile(r'\b(STD-[A-Z0-9]{3}-\d{3})\b')
unlisted = {r['plan_row_id'] for r in rows}
decided = set()
for p in sorted(BASE.glob('t4*/*-decisions.md')) + sorted(BASE.glob('t5*/*-decisions.md')):
    decided |= set(PID.findall(p.read_text(encoding='utf-8')))
known = set(ledger) | unlisted | decided
for r in rows:
    for pid in set(PID.findall(r['근거 요지'])) - {r['plan_row_id']}:
        if pid not in known:
            fail.append(f"G6 인용 plan_row_id 가 원장·미수록·결정안건 어디에도 부재 {r['plan_row_id']} → {pid}")
print(f"G6 조회 분모: 원장 {len(ledger)} · 미수록 {len(unlisted)} · 결정안건 {len(decided)}")

# G7 — verdict.md §2-3 이 「빠진 일」 58행을 묶음으로 분해한 것이 전수·무중복인지
GROUPS = {
    "프린트머니 webadmin 측": "STD-MYP-028 STD-MYP-029 STD-MYP-043 STD-MYP-046",
    "운영자 CS·전시": "STD-ADC-002 STD-ADC-003 STD-ADC-013 STD-ADC-016 STD-PRM-017",
    "B2B·거래처": "STD-B2B-002 STD-B2B-003 STD-B2B-004 STD-B2B-005 STD-B2B-006 STD-B2B-007 "
                  "STD-B2B-008 STD-B2B-009 STD-B2B-010 STD-B2B-011 STD-B2B-015",
    "정산·통계": "STD-FIN-001 STD-FIN-002 STD-FIN-003 STD-FIN-004 STD-FIN-005 STD-FIN-006 "
                "STD-FIN-008 STD-FIN-009 STD-FIN-010 STD-FIN-011 STD-FIN-012 STD-FIN-013 "
                "STD-FIN-014 STD-FIN-019",
    "주문 상태·MES 연동": "STD-MFG-022 STD-MFG-023 STD-MFG-024 STD-MFG-025 STD-MFG-026 "
                        "STD-MFG-028 STD-MFG-033 STD-MFG-035",
    "MES 포장·출하·재제작": "STD-MFG-106 STD-MFG-107 STD-MFG-108 STD-MFG-109 STD-MFG-112 "
                          "STD-MFG-113 STD-MFG-115 STD-MFG-117 STD-MFG-118 STD-MFG-119 "
                          "STD-MFG-120 STD-MFG-121 STD-MFG-122",
    "기타": "STD-SYS-003 STD-MFG-126 STD-MFG-129",
}
gone = {r['plan_row_id'] for r in rows if r['판정'] == '빠진 일'}
flat = []
for v in GROUPS.values():
    flat += v.split()
if len(flat) != len(set(flat)):
    fail.append("G7 묶음 중복")
if set(flat) != gone:
    fail.append(f"G7 묶음 불일치 누락={sorted(gone - set(flat))} 잉여={sorted(set(flat) - gone)}")
print("G7 빠진 일 묶음: " + " · ".join(f"{k} {len(v.split())}" for k, v in GROUPS.items())
      + f" = {len(flat)} / {len(gone)}")

print(f"검사한 path:line 근거 {checked}건 · 원장 plan_row_id {len(ledger)}종")
if fail:
    print("FAIL")
    for x in fail:
        print("  -", x)
    sys.exit(1)
print("PASS G1~G7")
