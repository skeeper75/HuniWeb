#!/usr/bin/env python3
"""t56 검산 — rejudge.csv 가 입력 원장과 어긋나지 않는지 기계로 확인한다."""
import csv, os, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
BASE = os.path.dirname(os.path.dirname(HERE))
PLAN = os.path.join(BASE, '07_rebaseline/S/S5-plan/plan-rows.csv')
MERGED = os.path.join(os.path.dirname(HERE), 't51/merged.csv')
RJ = os.path.join(HERE, 'rejudge.csv')

VALID = {'담당맞음', '재배정', '분할', 'provided', '불필요', '미정'}
BASES = {'manual-read', 'merged-owner_side', 'evidence-path', 'rule-step', 'rule-track'}

plan = list(csv.DictReader(open(PLAN, encoding='utf-8')))
merged = list(csv.DictReader(open(MERGED, encoding='utf-8')))
rj = list(csv.DictReader(open(RJ, encoding='utf-8')))

fails = []


def check(name, ok, detail=''):
    print(('PASS' if ok else 'FAIL'), name, detail)
    if not ok:
        fails.append(name)


check('V1 입력 plan-rows 735행', len(plan) == 735, f'실측 {len(plan)}')
check('V2 입력 merged 747행', len(merged) == 747, f'실측 {len(merged)}')
check('V3 출력 행수 = 입력 행수', len(rj) == len(plan), f'{len(rj)} vs {len(plan)}')
check('V4 row_id 집합 동일',
      {r['row_id'] for r in rj} == {r['row_id'] for r in plan})
check('V5 판정값이 5분류(+불필요) 안에만',
      all(r['verdict'] in VALID for r in rj),
      str(sorted({r['verdict'] for r in rj})))
check('V6 근거등급이 정의된 5종 안에만',
      all(r['judged_by'] in BASES for r in rj),
      str(sorted({r['judged_by'] for r in rj})))
check('V7 판정 미기입 0건', all(r['verdict'] and r['owner_proposed'] for r in rj))
check('V8 owner_now 가 원장 owner_name 과 전건 일치',
      all(a['owner_now'] == b['owner_name'] for a, b in zip(rj, plan)))
check('V9 status 가 원장과 전건 일치',
      all(a['status'] == b['status'] for a, b in zip(rj, plan)))
check('V10 remaining 은 status 로만 파생',
      all((r['remaining'] == 'N') == (r['status'] in ('작동', '완료')) for r in rj))
# 재배정·분할 행은 반드시 근거 문자열이 있어야 한다(근거 없는 제안 금지)
noev = [r['row_id'] for r in rj if r['verdict'] in ('재배정', '분할') and not (r['basis'] or r['evidence'])]
check('V11 재배정·분할 행에 근거 문자열 존재', not noev, str(noev[:5]))

print('\n[판정 분포]', dict(collections.Counter(r['verdict'] for r in rj)))
print('[근거등급]', dict(collections.Counter(r['judged_by'] for r in rj)))
print('[남은 일 Y/N]', dict(collections.Counter(r['remaining'] for r in rj)))
print('\n실패', len(fails))
sys.exit(1 if fails else 0)
