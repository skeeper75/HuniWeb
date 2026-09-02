#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""배정 규칙을 O3 통합 원장 504행에 적용 — 미배정 0 을 증명한다."""
import csv, collections, os
ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
def P(*p): return os.path.join(ROOT, *p)

led   = list(csv.DictReader(open(P('L5','O3','unified-ledger.csv'))))
rules = list(csv.DictReader(open(P('L5','O2','assignment-rules.csv'))))
exc   = {r['std_id']: r for r in csv.DictReader(open(P('L5','O2','assignment-exceptions.csv')))}

spec, gen = {}, {}
for r in rules:
    (spec if r['중분류'] else gen).__setitem__((r['대분류'], r['중분류']) if r['중분류'] else r['대분류'], r)

out, unassigned = [], []
for x in led:
    r = spec.get((x['대분류'], x['중분류'])) or gen.get(x['대분류'])
    if r is None:
        unassigned.append((x['std_id'], x['대분류'], x['중분류'], x['기능']))
        owner = track = why = ''; via = '미배정'
    else:
        owner, track, why, via = r['담당'], r['sub_track'], r['근거'], f"규칙[{r['대분류']}/{r['중분류'] or '*'}]"
    if x['std_id'] in exc:
        e = exc[x['std_id']]; ev = e['예외 값']
        owner, track = (ev.split('/', 1) if '/' in ev else (ev, '-'))
        why, via = e['근거'], '예외표'
    out.append({**x, '담당': owner, 'sub_track': track, '배정근거': why, '배정경로': via})

with open(P('L5','O2','_work','assignment-applied-504.csv'), 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(out[0].keys())); w.writeheader(); w.writerows(out)

own = lambda o: o['담당'] + ('/' + o['sub_track'] if o['sub_track'] not in ('', '-') else '')
byowner = collections.Counter(); bystat = collections.defaultdict(collections.Counter)
for o in out:
    byowner[own(o)] += 1; bystat[own(o)][o['상태']] += 1

print('원장', len(out), '· 미배정', len(unassigned), '· 예외 적용', sum(1 for o in out if o['배정경로']=='예외표'))
for u in unassigned: print('  미배정:', u)
print()
hdr = ['done','partial','todo','new','미판정']
print(f"{'담당':28s} {'계':>4}  " + '  '.join(f'{h:>6}' for h in hdr))
for k, v in byowner.most_common():
    print(f'{k:28s} {v:4d}  ' + '  '.join(f'{bystat[k][h]:6d}' for h in hdr))
tot = collections.Counter()
for k in bystat:
    for h in hdr: tot[h] += bystat[k][h]
print(f"{'합':28s} {sum(byowner.values()):4d}  " + '  '.join(f'{tot[h]:6d}' for h in hdr))
print()
# 신규 3건 어디로 갔나
for o in out:
    if o['std_id'] in ('STD-MFG-136','STD-ORD-029','STD-SYS-023'):
        print('신규:', o['std_id'], o['대분류'], '/', o['중분류'], '→', own(o), '|', o['상태'], '|', o['기능'][:50])
print()
# 미판정 143 이 어느 담당에 몰렸나
u = collections.Counter(own(o) for o in out if o['상태']=='미판정')
print('미판정 143 담당별:', dict(u))
c = collections.Counter(o['대분류'] for o in out if o['상태']=='미판정')
print('미판정 143 대분류별:', dict(c))
