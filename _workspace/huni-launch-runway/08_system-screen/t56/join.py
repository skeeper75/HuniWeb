#!/usr/bin/env python3
# t56 — plan-rows(735) × merged(747) 전건 조인: 담당자별로 그 일이 사는 system/owner_side 를 붙인다.
# 사용: python3 join.py [owner]  (owner 생략 시 전원 요약)
import csv, os, sys, collections

BASE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PLAN = os.path.join(BASE, '07_rebaseline/S/S5-plan/plan-rows.csv')
MERGED = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 't51/merged.csv')


def load(p):
    with open(p, encoding='utf-8') as f:
        return list(csv.DictReader(f))


def merged_index():
    idx = collections.defaultdict(list)
    for r in load(MERGED):
        for pid in (r['plan_row_id'] or '').replace(';', ' ').replace(',', ' ').split():
            idx[pid.strip()].append(r)
    return idx


def sites(hits):
    """그 일이 사는 곳 = owner_side 우선, 없으면 system."""
    out = []
    for r in hits:
        out.append(r['owner_side'] or r['system'])
    return sorted(set(out))


if __name__ == '__main__':
    idx = merged_index()
    rows = load(PLAN)
    want = sys.argv[1] if len(sys.argv) > 1 else None
    tally = collections.Counter()
    for r in rows:
        if want and r['owner_name'] != want:
            continue
        hits = idx.get(r['row_id'], [])
        s = sites(hits)
        tally[(r['owner_name'], tuple(s))] += 1
        if want:
            st = ','.join(s) if s else '-'
            sysl = ','.join(sorted({h['system'] for h in hits})) if hits else '-'
            print(f"{r['row_id']}|{r['track']}.{r['step']}|{r['status']}|merged={len(hits)}|sys={sysl}|lives={st}|{r['title'][:60]}")
    if not want:
        for k, v in sorted(tally.items(), key=lambda x: (-x[1])):
            print(v, k)
