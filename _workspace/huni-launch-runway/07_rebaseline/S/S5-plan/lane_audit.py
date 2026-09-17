# -*- coding: utf-8 -*-
"""담당자 직렬(가정) 하한의 재현·감사 — build_plan_rows.py 의 lanes.csv 가 어떤 필터로 나왔는지 단계별로 센다.
   실행: python3 -B lane_audit.py [실명]   (기본 김동학)
"""
import collections
import csv
import re
import sys

import build_plan_rows as b
import stepmap

WHO = sys.argv[1] if len(sys.argv) > 1 else '김동학'
L = list(csv.DictReader(open(b.LEDGER, encoding='utf-8')))


def eff(rows):
    rs = [r for r in rows if b.pick_name(r['담당실명']) == WHO]
    return len(rs), sum(b.EFFORT.get(r['작업량구간'], 0) for r in rs), sum(r['작업량구간'] == '1주+' for r in rs)


cov = collections.defaultdict(list)
for t in b.TOP:
    for s in t['steps']:
        cov[s].append(t)


def in_pool(r):
    st = stepmap.step_of(r['대분류'], r['중분류'], r['std_id'])
    for t in cov.get(st, []):
        f = t.get('filt')
        if not f:
            return True
        if f == b.REST:
            sib = [o['filt'] for o in b.TOP if o is not t and o.get('filt') and o['filt'] != b.REST and set(o['steps']) & set(t['steps'])]
            if not any(re.search(x, r['기능']) for x in sib):
                return True
        elif re.search(f, r['기능']):
            return True
    return False


print('정규화 = 담당실명 문자열에서 7실명 중 가장 앞에 나오는 이름 하나(다인 표기는 첫 이름에 전량) · 실명 없으면 외부(원문)/미정')
base = [r for r in L if r['상태'] in ('todo', 'new', 'partial', '미판정') and r['오픈차단여부'] != '오픈 무관']
print(f'A 원장 654 → 상태∈{{todo,new,partial,미판정}} · 오픈차단여부≠오픈 무관: {len(base)}행 · {WHO} (행,일,1주+) {eff(base)}')
ext = [r for r in base if b.owner_work(r)[0] == 'ext']
print(f'B 제외: data-owner=ext(외부 대기 · 소요 0 규칙): {len(ext)}행 · {WHO} {eff(ext)}')
rest = [r for r in base if b.owner_work(r)[0] != 'ext']
out = [r for r in rest if not in_pool(r)]
print(f'C 제외: 어느 최상위 행 묶음(구간+filt)에도 안 들어감: {len(out)}행 · {WHO} {eff(out)} · 구간 {dict(collections.Counter(stepmap.step_of(r["대분류"], r["중분류"], r["std_id"]) for r in out))}')
inp = [r for r in rest if in_pool(r)]
print(f'= 최상위 행 묶음 안: {len(inp)}행 · {WHO} {eff(inp)}')
nondev = [r for r in inp if r['분류'] not in b.EFFORT_CLASSES]
print(f'D 제외: 분류 ∉ {{개발, 수정}}(지니 결정 260917 — 체크리스트엔 남고 소요만 미합산): {len(nondev)}행 · {WHO} {eff(nondev)} · 분류 {dict(collections.Counter(r["분류"] for r in nondev))}')
final = [r for r in inp if r['분류'] in b.EFFORT_CLASSES]
print(f'= lanes.csv 입력: {len(final)}행 · {WHO} {eff(final)}')
