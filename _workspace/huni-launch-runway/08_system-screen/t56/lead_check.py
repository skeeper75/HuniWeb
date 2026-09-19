#!/usr/bin/env python3
# t56 ② — 리드 1차 후보 17행 검증 + 김동학 T2·T4 41행 전수
import csv, os, collections

HERE = os.path.dirname(os.path.abspath(__file__))
rows = {r['row_id']: r for r in csv.DictReader(open(os.path.join(HERE, 'rejudge.csv'), encoding='utf-8'))}

LEAD = [
    ('위젯/webadmin/페이지빌더 의심', ['STD-ART-019', 'STD-ART-020', 'STD-SYS-008', 'STD-SYS-010', 'STD-ADP-015']),
    ('운영자·생산 기능 의심', ['STD-ADO-001', 'STD-ADO-002', 'STD-ADO-003', 'STD-ADO-004', 'STD-ADO-005',
                        'STD-ADO-006', 'STD-ADO-007', 'STD-ADO-020', 'STD-ADO-021',
                        'STD-SHP-012', 'STD-SHP-013', 'STD-MFG-114']),
    ('경계 걸침', ['STD-SYS-009']),
]

agree = collections.Counter()
print('## 리드 1차 후보 17행 — t56 재판정\n')
print('| row_id | 리드 분류 | t56 판정 | 제안 담당 | 근거등급 | 리드와 |')
print('|---|---|---|---|---|---|')
for label, ids in LEAD:
    for i in ids:
        r = rows[i]
        # 리드 주장 = 「스킨 밖으로 보인다」 = 김동학이 아니다
        lead_says_out = True
        t56_out = r['verdict'] in ('재배정', 'provided', '분할', '불필요')
        mark = '일치' if lead_says_out == t56_out else '어긋남'
        agree[mark] += 1
        print(f"| {i} | {label} | {r['verdict']} | {r['owner_proposed']} | {r['judged_by']} | {mark} |")
print(f'\n리드 후보 17행 대조: {dict(agree)}')

print('\n## 김동학 T2·T4 41행 전수')
sel = [r for r in rows.values() if r['owner_now'] == '김동학' and r['track'] in ('T2', 'T4')]
print(len(sel), dict(collections.Counter(r['verdict'] for r in sel)))
for r in sel:
    print(f"  {r['row_id']}|{r['step']}|{r['status']}|{r['verdict']}→{r['owner_proposed']}|{r['judged_by']}|{r['title'][:50]}")
