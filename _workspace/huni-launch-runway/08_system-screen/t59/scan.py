# -*- coding: utf-8 -*-
"""t59 ㉮ 5축 후보 행 수집 — 결정론 스캔.

판정은 하지 않는다. 키워드로 후보만 모으고, 실제 귀속은 사람이 evidence 를 열어 확인한다.
입력: plan-rows.csv(735) · t56/rejudge.csv(735) — 두 파일은 row_id 로 1:1.
"""
import csv, sys, re

BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t59/_workspace/huni-launch-runway/'
PLAN = BASE + '07_rebaseline/S/S5-plan/plan-rows.csv'
REJ = BASE + '08_system-screen/t56/rejudge.csv'


def load(p):
    with open(p, encoding='utf-8') as f:
        return list(csv.DictReader(f))


plan = load(PLAN)
rej = {r['row_id']: r for r in load(REJ)}

AX = {
    '1가이드북': [r'가이드북', r'인쇄\s*가이드', r'제작\s*가이드', r'가이드 11종'],
    '2상세탭': [r'상세\s*페이지', r'상세\s*탭', r'상세탭', r'탭\s*콘텐츠', r'페이지\s*빌더', r'상품\s*상세'],
    '3정책': [r'정책', r'약관', r'개인정보', r'취소|환불|교환|반품', r'운영\s*정책'],
    '4프로세스': [r'프로세스', r'업무\s*흐름', r'운영\s*절차', r'검수', r'접수', r'제작\s*대기', r'MES'],
    '5테스트역할': [r'테스트', r'리허설', r'시나리오', r'Go/?No-?Go', r'컷오버', r'역할\s*배정', r'담당\s*확정'],
}


def axes_of(txt):
    return [a for a, pats in AX.items() if any(re.search(p, txt) for p in pats)]


rows = []
for r in plan:
    txt = ' '.join([r.get('title', ''), r.get('note', ''), r.get('evidence', ''),
                    r.get('data_work', ''), r.get('check_method', ''), r.get('step', '')])
    j = rej.get(r['row_id'], {})
    ax = axes_of(txt)
    is_csj = (r.get('owner_name', '') == '최숙진') or (j.get('owner_proposed', '') == '최숙진')
    if not ax and not is_csj:
        continue
    rows.append({
        'row_id': r['row_id'], 'track': r.get('track', ''), 'step': r.get('step', ''),
        'title': r.get('title', ''), 'owner_now': r.get('owner_name', ''),
        'status': r.get('status', ''), 'axes': '|'.join(ax), 'csj': 'Y' if is_csj else '',
        'verdict': j.get('verdict', ''), 'owner_proposed': j.get('owner_proposed', ''),
        'judged_by': j.get('judged_by', ''), 'evidence': r.get('evidence', ''),
    })

w = csv.DictWriter(sys.stdout, fieldnames=list(rows[0].keys()))
w.writeheader()
for r in rows:
    w.writerow(r)
print('#TOTAL %d' % len(rows), file=sys.stderr)
