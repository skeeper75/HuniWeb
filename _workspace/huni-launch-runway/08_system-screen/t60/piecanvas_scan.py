#!/usr/bin/env python3
# t60 보강 — 페이지빌더(Pie Canvas)가 원장에서 어떻게 취급되는지 실측.
# 리드 전달(지니 확정 260919): 「파트너사」= 김동학 대표 · 제3자 제품 아님.
# 이 스크립트는 그 정정이 원장의 무엇을 건드리는지를 센다. 읽기전용.
import csv, os, re, collections

BASE = os.path.dirname(os.path.abspath(__file__))
plan = list(csv.DictReader(open(os.path.join(
    BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv'), encoding='utf-8')))

pc = [r for r in plan if 'EXT-PIECANVAS' in (r['prereq'] or '')]
print(f"prereq 에 EXT-PIECANVAS(= 외부 대기 토큰)를 단 행: {len(pc)}")
print('  담당 분포:', dict(collections.Counter(r['owner_name'] for r in pc)))
for r in pc[:12]:
    print(f"  {r['row_id']:14} {r['owner_name']:12} {r['status']:8} {r['title'][:56]}")
if len(pc) > 12:
    print(f"  … 외 {len(pc)-12}행")

rx = re.compile(r'페이지빌더|pagebuilder|Pie ?Canvas', re.I)
allpc = [r for r in plan if rx.search(' '.join([r['title'], r.get('note', '') or '',
                                                r.get('evidence', '') or '']))]
print(f"\n페이지빌더를 언급하는 행 전체: {len(allpc)}")
print('  담당 분포:', dict(collections.Counter(r['owner_name'] for r in allpc)))
print('  status 분포:', dict(collections.Counter(r['status'] for r in allpc)))
