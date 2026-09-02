#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""배정 규칙을 501행에 기계 적용 — 미배정 0 을 증명한다."""
import csv, collections, os, json
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
def P(*p): return os.path.join(ROOT, *p)

canon = list(csv.DictReader(open(P('L0','N2','standard-feature-canon-v2.csv'))))
rules = list(csv.DictReader(open(P('L5','O2','assignment-rules.csv'))))
exc   = {r['std_id']: r for r in csv.DictReader(open(P('L5','O2','assignment-exceptions.csv')))}

# 규칙 인덱스: (대분류,중분류) 우선, 없으면 (대분류,'')
spec = {}; gen = {}
for r in rules:
    if r['중분류']: spec[(r['대분류'], r['중분류'])] = r
    else: gen[r['대분류']] = r

out = []; unassigned = []
for x in canon:
    key = (x['대분류'], x['중분류'])
    r = spec.get(key) or gen.get(x['대분류'])
    if r is None:
        unassigned.append(x['std_id']); owner, track, why, via = '', '', '', '미배정'
    else:
        owner, track, why = r['담당'], r['sub_track'], r['근거']
        via = f"규칙[{r['대분류']}/{r['중분류'] or '*'}]"
    if x['std_id'] in exc:
        e = exc[x['std_id']]
        ev = e['예외 값']
        if '/' in ev: owner, track = ev.split('/', 1)
        else: owner, track = ev, '-'
        why = e['근거']; via = '예외표'
    out.append({**x, '담당': owner, 'sub_track': track, '배정근거': why, '배정경로': via})

with open(P('L5','O2','_work','assignment-applied.csv'), 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)

# 상태 결합 (L4 353행)
status = {}
for d in ('a','b','c'):
    for r in csv.DictReader(open(P('L4', d, 'mapping.csv'))):
        status[r['std_id']] = r['상태']
byowner = collections.Counter(); bystat = collections.defaultdict(collections.Counter)
for o in out:
    k = o['담당'] + ('/' + o['sub_track'] if o['sub_track'] not in ('', '-') else '')
    byowner[k] += 1
    bystat[k][status.get(o['std_id'], '미판정(신규 148)')] += 1

print('총', len(out), '· 미배정', len(unassigned), unassigned[:10])
print('예외 적용', sum(1 for o in out if o['배정경로']=='예외표'))
print()
for k, v in byowner.most_common():
    print(f'{k:16s} {v:4d}   ' + ' · '.join(f'{s} {n}' for s, n in sorted(bystat[k].items())))
print()
print('상태 커버리지: L4 353 중 canon 에 있는 것', sum(1 for s in status if s in {o['std_id'] for o in out}))
