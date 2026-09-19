#!/usr/bin/env python3
# t56 — merged.csv(747행) 시스템×status 분포 · 위젯 몫 역방향 확인용
import csv, collections, os

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
M = os.path.join(BASE, 't51/merged.csv')

with open(M, encoding='utf-8') as f:
    rows = list(csv.DictReader(f))

print('총', len(rows))
print('\n[system × scope]')
for k, v in sorted(collections.Counter((r['system'], r['scope']) for r in rows).items()):
    print(' ', k, v)
print('\n[system × status]')
for k, v in sorted(collections.Counter((r['system'], r['status']) for r in rows).items()):
    print(' ', k, v)
print('\n[work_type]')
for k, v in sorted(collections.Counter(r['work_type'] for r in rows).items()):
    print(' ', k, v)
print('\n[widget 행 전부]')
for r in rows:
    if r['system'] == 'widget' or r['counterpart'] == 'widget':
        print(f"  {r['row_uid']}|{r['card']}|{r['system']}>{r['counterpart']}|{r['work_type']}|{r['status']}|{r['screen_name'][:40]}|{r['function'][:60]}")
