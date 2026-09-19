"""t50 산출 병합·검산: parts/*.csv -> screens.csv

계약(../CONTRACT.md) 검사 항목
  - 헤더 고정 13열
  - system 은 허용 8종 안에서만
  - work_type 5값 · 한 행 한 값
  - integrate 행은 counterpart·direction·owner_side 필수
  - plan_row_id 는 원장 735행의 row_id 이거나 NEW
  - status 4값
  - evidence 빈 행 금지
  - 보충 1(260919): 분모밖 접두 `[오픈분모밖] ` 는 work_type=provided 행에만

위반은 고치지 않고 전부 보고한다(날조 금지 — 판정은 사람이 한다).
"""
import csv
import os
import sys
from collections import Counter

BASE = os.path.dirname(os.path.abspath(__file__))
PARTS = os.path.join(BASE, 'parts')
OUT = os.path.join(BASE, 'screens.csv')
LEDGER = os.path.normpath(os.path.join(
    BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv'))

HEADER = ['system', 'group', 'screen_id', 'screen_name', 'role', 'function',
          'work_type', 'counterpart', 'direction', 'owner_side',
          'plan_row_id', 'status', 'evidence']

PART_FILES = ['mes-ui.csv', 'mes-integration.csv', 'edicus.csv', 'pitstop.csv']

SYSTEMS = {'shopby', 'edicus', 'mes', 'huni-mall', 'webadmin', 'widget',
           'pagebuilder', 'pitstop'}
WORK_TYPES = {'build', 'integrate', 'config', 'provided', 'manual'}
STATUSES = {'완료', '진행', '미착수', '미확인'}
ROLES = {'고객', '운영자(CS·상품)', '생산(MES)', '관리자', '시스템(무인)'}

# 보충 1(260919 · 리드 lane-1): 오픈 분모 밖 기존 자산 표기
OUT_PREFIX = '[오픈분모밖] '


def load_ledger_ids():
    with open(LEDGER, encoding='utf-8') as f:
        return {r['row_id'] for r in csv.DictReader(f)}


def main():
    ledger = load_ledger_ids()
    rows = []
    violations = []
    missing_parts = []

    for name in PART_FILES:
        path = os.path.join(PARTS, name)
        if not os.path.exists(path):
            missing_parts.append(name)
            continue
        with open(path, encoding='utf-8-sig', newline='') as f:
            reader = csv.DictReader(f)
            if reader.fieldnames != HEADER:
                violations.append('%s: 헤더 불일치 %s' % (name, reader.fieldnames))
                continue
            for i, r in enumerate(reader, start=2):
                r['_src'] = '%s:%d' % (name, i)
                rows.append(r)

    for r in rows:
        src = r['_src']
        if r['system'] not in SYSTEMS:
            violations.append('%s: system 허용값 밖 "%s"' % (src, r['system']))
        if r['work_type'] not in WORK_TYPES:
            violations.append('%s: work_type 위반 "%s"' % (src, r['work_type']))
        if r['status'] not in STATUSES:
            violations.append('%s: status 위반 "%s"' % (src, r['status']))
        if r['role'] not in ROLES:
            violations.append('%s: role 허용값 밖 "%s"' % (src, r['role']))
        if r['work_type'] == 'integrate':
            for col in ('counterpart', 'direction', 'owner_side'):
                if not (r[col] or '').strip():
                    violations.append('%s: integrate 인데 %s 비어 있음' % (src, col))
        pid = (r['plan_row_id'] or '').strip()
        if pid != 'NEW' and pid not in ledger:
            violations.append('%s: plan_row_id "%s" 원장에 없음(NEW 도 아님)' % (src, pid))
        if not (r['evidence'] or '').strip():
            violations.append('%s: evidence 없음' % src)
        # 보충 1 개정(260919): 분모밖 접두는 scope 표식일 뿐, work_type 을 제약하지
        # 않는다(work_type 은 보충 3 축 = 「기능이 어떤 방식으로 생기는가」).
        # 따라서 접두 ↔ work_type 조합 검사는 두지 않는다.
        if OUT_PREFIX.strip() in r['evidence'] and not r['evidence'].startswith(OUT_PREFIX):
            violations.append('%s: 분모밖 표식이 evidence 맨 앞이 아님(고정 접두 위치 위반)'
                              % src)
        for col in ('screen_id', 'screen_name', 'function', 'group'):
            if not (r[col] or '').strip():
                violations.append('%s: %s 비어 있음' % (src, col))

    dup = [k for k, n in Counter(
        (r['screen_id'], r['function']) for r in rows).items() if n > 1]

    with open(OUT, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=HEADER, extrasaction='ignore')
        w.writeheader()
        w.writerows(rows)

    print('== t50 screens.csv ==')
    print('총 %d행 -> %s' % (len(rows), OUT))
    if missing_parts:
        print('빠진 parts: %s' % ', '.join(missing_parts))
    print('system     :', dict(Counter(r['system'] for r in rows)))
    print('work_type  :', dict(Counter(r['work_type'] for r in rows)))
    print('status     :', dict(Counter(r['status'] for r in rows)))
    print('role       :', dict(Counter(r['role'] for r in rows)))
    print('plan_row_id: NEW %d / 원장매핑 %d' % (
        sum(1 for r in rows if r['plan_row_id'].strip() == 'NEW'),
        sum(1 for r in rows if r['plan_row_id'].strip() != 'NEW')))
    print('integrate  : %d행' % sum(1 for r in rows if r['work_type'] == 'integrate'))
    out_rows = [r for r in rows if r['evidence'].startswith(OUT_PREFIX)]
    print('분모밖     : %d행 (분모 안 %d행)' % (len(out_rows), len(rows) - len(out_rows)))
    print('  분모밖 system:', dict(Counter(r['system'] for r in out_rows)))
    print('중복 (screen_id, function): %d건' % len(dup))
    for k in dup[:20]:
        print('  중복', k)
    print('위반 %d건' % len(violations))
    for v in violations[:80]:
        print('  -', v)
    if len(violations) > 80:
        print('  ... 외 %d건' % (len(violations) - 80))
    return 1 if (violations or missing_parts) else 0


if __name__ == '__main__':
    sys.exit(main())
