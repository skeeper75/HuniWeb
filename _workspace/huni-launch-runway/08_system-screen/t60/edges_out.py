#!/usr/bin/env python3
# t60 보강 — ⑤ 인프라 행에서 나가는 간선(누가 이것을 선행으로 다나) + 「오픈 테스트」 게이트 행. 읽기전용.
import csv, os

BASE = os.path.dirname(os.path.abspath(__file__))
plan = list(csv.DictReader(open(os.path.join(
    BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv'), encoding='utf-8')))

INF_PREFIX = ('F1-', 'F2-', 'F3-')
INF_ROWS = {'T1-1', 'T1-2', 'T1-3'}

print("=== ⑤ 인프라 행(F1·F2·F3·T1-1~3)을 prereq 로 가진 행 = 나가는 간선 ===")
n = 0
for r in plan:
    ts = [t.strip() for t in (r['prereq'] or '').split(';') if t.strip() and t.strip() != '—']
    hit = [t for t in ts if t in INF_ROWS or t.startswith(INF_PREFIX)]
    if hit:
        n += 1
        print(f"{r['row_id']:12} {r['owner_name']:14} {r['status']:8} ← {';'.join(hit)[:30]:32} {r['title'][:52]}")
print(f"합계 {n}행\n")

print("=== prereq 에 「오픈 테스트」가 적힌 행 ===")
for r in plan:
    if '오픈 테스트' in (r['prereq'] or ''):
        print(f"{r['row_id']:12} {r['owner_name']:14} ← {r['prereq'][:38]:40} {r['title'][:54]}")
print()

print("=== 페이지빌더 Lightsail 이전 행을 찾는다(제목+비고 전수) ===")
import re
rx = re.compile(r'(페이지빌더|pagebuilder|Pie ?Canvas).*(이전|이관|마이그|Lightsail|컨테이너|배포)'
                r'|(이전|이관|Lightsail).*(페이지빌더|pagebuilder|Pie ?Canvas)', re.I)
hits = [r for r in plan if rx.search(' '.join([r['title'], r.get('note', '') or '', r.get('evidence', '') or '']))]
print(f"적중 {len(hits)}행")
for h in hits:
    print(f"  {h['row_id']:12} {h['owner_name']:12} {h['title'][:64]}")
