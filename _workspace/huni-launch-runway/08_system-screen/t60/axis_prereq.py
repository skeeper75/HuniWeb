#!/usr/bin/env python3
# t60 ㉰ — 축별 선행 구조 실측(원장 밖 외부 선행 · 축 내부/교차 간선 · 선행 없음). 읽기전용.
import csv, os, re, collections

BASE = os.path.dirname(os.path.abspath(__file__))
rows = list(csv.DictReader(open(os.path.join(BASE, 'axis-rows.csv'), encoding='utf-8')))
plan = {r['row_id']: r for r in csv.DictReader(
    open(os.path.join(BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv'), encoding='utf-8'))}
axis = {r['row_id']: r['axis'] for r in rows}
NAME = {r['axis']: r['axis_name'] for r in rows}

ext = collections.defaultdict(collections.Counter)
intra = collections.Counter()
cross = collections.Counter()
none = collections.Counter()
total = collections.Counter()

for r in rows:
    a = r['axis']
    total[a] += 1
    toks = [t.strip() for t in (r['prereq'] or '').split(';') if t.strip()]
    toks = [t for t in toks if t != '—']
    if not toks:
        none[a] += 1
        continue
    for t in toks:
        if t in axis:
            (intra if axis[t] == a else cross)[a] += 1
        elif t in plan:
            cross[a] += 1          # 원장 안이지만 서희항 남은 일 밖(완료 행 또는 타인 행)
        else:
            ext[a][t] += 1

print(f"{'축':2} {'이름':30} {'행':>4} {'선행없음':>6} {'축내부':>6} {'축밖(원장)':>9} {'원장밖(외부)':>10}")
for a in sorted(total):
    print(f"{a:2} {NAME[a]:30} {total[a]:4} {none[a]:6} {intra[a]:6} {cross[a]:9} {sum(ext[a].values()):10}")
print()
for a in sorted(total):
    if ext[a]:
        print(f"축{a} 외부 선행: {dict(ext[a].most_common())}")
