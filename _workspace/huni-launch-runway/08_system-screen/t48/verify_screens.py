# -*- coding: utf-8 -*-
"""t48 · screens.csv 계약 준수 검산기. 읽기전용. exit 0 = 전항 PASS."""
import csv
import os
import re
import sys
from collections import Counter

BASE = os.path.dirname(os.path.abspath(__file__))
SCREENS = os.path.join(BASE, 'screens.csv')
OOS = os.path.join(BASE, 'out-of-scope.csv')
DEC = [os.path.join(BASE, n + '-decisions.md') for n in ('shopby', 'huni-mall')]
PLAN = os.path.join(BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv')

COLS = ['system', 'group', 'screen_id', 'screen_name', 'role', 'function', 'work_type',
        'counterpart', 'direction', 'owner_side', 'plan_row_id', 'status', 'evidence']
SYSTEMS = {'shopby', 'edicus', 'mes', 'huni-mall', 'webadmin', 'widget', 'pagebuilder', 'pitstop'}
ROLES = {'고객', '운영자(CS·상품)', '생산(MES)', '관리자', '시스템(무인)'}
WT = {'build', 'integrate', 'config', 'provided', 'manual'}
ST = {'완료', '진행', '미착수', '미확인'}
SCOPE_STEPS = {'A4', 'A5', 'B1', 'B4', 'B5', 'B6', 'B7', 'C1', 'C3', 'C6', 'C7',
               'D1', 'D2', 'D3', 'D4', 'D5', 'E1', 'E2', 'E3', 'F4'}

fails = []


def check(name, ok, detail=''):
    print(('PASS ' if ok else 'FAIL ') + name + ((' — ' + detail) if detail else ''))
    if not ok:
        fails.append(name)


rows = list(csv.DictReader(open(SCREENS, encoding='utf-8')))
oos = list(csv.DictReader(open(OOS, encoding='utf-8')))
plan = [r for r in csv.DictReader(open(PLAN, encoding='utf-8')) if r['data_role'] == 'detail']
dec = set()
for path in DEC:
    for line in open(path, encoding='utf-8'):
        m = re.match(r'\| ((?:STD|BLK|F4)-[A-Z0-9-]+) \|', line)
        if m:
            dec.add(m.group(1))
scope = [r for r in plan if r['step'] in SCOPE_STEPS]

check('V1 헤더 고정', list(rows[0].keys()) == COLS, ','.join(rows[0].keys()))
check('V2 system 허용값(이 카드는 shopby·huni-mall 만)',
      set(r['system'] for r in rows) == {'shopby', 'huni-mall'} and
      set(r['system'] for r in rows) <= SYSTEMS)
check('V3 role 허용값', set(r['role'] for r in rows) <= ROLES)
check('V4 work_type 5값', set(r['work_type'] for r in rows) <= WT,
      str(dict(Counter(r['work_type'] for r in rows))))
check('V5 status 4값', set(r['status'] for r in rows) <= ST,
      str(dict(Counter(r['status'] for r in rows))))
bad = [r for r in rows if r['work_type'] == 'integrate' and
       not (r['counterpart'] and r['direction'] and r['owner_side'])]
check('V6 integrate 는 counterpart·direction·owner_side 필수', not bad, '결손 %d' % len(bad))
bad = [r for r in rows if r['work_type'] != 'integrate' and
       (r['counterpart'] or r['direction'] or r['owner_side'])]
check('V7 비-integrate 행에 연동 3열 없음', not bad, '오염 %d' % len(bad))
bad = [r for r in rows if not r['evidence'].strip() or r['evidence'].strip() == '—']
check('V8 근거 없는 행 0', not bad, '빈 근거 %d' % len(bad))
bad = [r for r in rows if r['status'] in ('완료', '진행') and
       not re.search(r'(:\d+|https?://|\.csv|\.md|\.py|\.ts|\.tsx)', r['evidence'])]
check('V9 완료/진행 행은 파일:줄·URL·산출물 경로 근거 보유', not bad, '약한 근거 %d' % len(bad))
ids = set(r['row_id'] for r in scope)
mapped = set(r['plan_row_id'] for r in rows if r['plan_row_id'] != 'NEW')
skipped = set(r['plan_row_id'] for r in oos)
check('V10 plan_row_id 는 실재하는 735행 id', mapped <= ids, '미존재 %d' % len(mapped - ids))
check('V11 대상 구간 원장 누락 0 (screens ∪ out-of-scope ∪ decisions == scope)',
      mapped | skipped | dec == ids,
      '미분류 %d' % len(ids - mapped - skipped - dec))
check('V14 decisions 는 screens 와 겹치지 않는다(보충 4 이중계상 방지)',
      not (dec & mapped), '겹침 %d' % len(dec & mapped))
check('V15 decisions 는 원장 실재 id', dec <= ids, '미존재 %d' % len(dec - ids))
check('V12 screens 와 out-of-scope 교집합 0', not (mapped & skipped), str(len(mapped & skipped)))
pref = [r for r in rows if r['evidence'].startswith('[오픈분모밖] ')]
check('V13 보충1 분모밖 접두는 provided 행에만',
      all(r['work_type'] == 'provided' for r in pref), '분모밖 %d 행' % len(pref))

print()
print('행수            : %d (screens.csv)' % len(rows))
print('화면 수         : %d' % len(set(r['screen_id'] for r in rows)))
print('system          : %s' % dict(Counter(r['system'] for r in rows)))
print('work_type       : %s' % dict(Counter(r['work_type'] for r in rows)))
print('status          : %s' % dict(Counter(r['status'] for r in rows)))
print('role            : %s' % dict(Counter(r['role'] for r in rows)))
print('미확인          : %d' % sum(1 for r in rows if r['status'] == '미확인'))
print('NEW             : %d' % sum(1 for r in rows if r['plan_row_id'] == 'NEW'))
print('오픈분모밖      : %d' % len(pref))
print('결정·관리 안건  : %d (shopby+huni-mall decisions.md)' % len(dec))
print('대상 구간 원장  : %d (screens %d + out-of-scope %d + decisions %d)'
      % (len(scope), len(mapped), len(skipped), len(dec)))
sys.exit(1 if fails else 0)
