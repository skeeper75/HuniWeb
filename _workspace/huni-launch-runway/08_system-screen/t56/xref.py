#!/usr/bin/env python3
# t56 — plan_row_id 로 merged.csv(747행) 교차조회: 그 일이 어느 system/owner_side 에 사는가
import csv, os, sys, collections

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
M = os.path.join(BASE, 't51/merged.csv')


def load():
    with open(M, encoding='utf-8') as f:
        return list(csv.DictReader(f))


def index():
    idx = collections.defaultdict(list)
    for r in load():
        for pid in (r['plan_row_id'] or '').replace(';', ' ').replace(',', ' ').split():
            idx[pid.strip()].append(r)
    return idx


if __name__ == '__main__':
    idx = index()
    for pid in sys.argv[1:]:
        hits = idx.get(pid, [])
        print(f'\n### {pid} → merged {len(hits)}행')
        for r in hits:
            print(f"  {r['row_uid']}|{r['system']}>{r['counterpart']}|owner_side={r['owner_side']}|{r['work_type']}|{r['status']}|{r['screen_name'][:35]}|{r['function'][:70]}")
