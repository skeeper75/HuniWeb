#!/usr/bin/env python3
# t56 — plan-rows 열람용 덤프(읽기전용). 사용: python3 dump.py <owner> [track ...]
import csv, os, sys

BASE = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
PLAN = os.path.join(BASE, '07_rebaseline/S/S5-plan/plan-rows.csv')


def load():
    with open(PLAN, encoding='utf-8') as f:
        return list(csv.DictReader(f))


if __name__ == '__main__':
    owner = sys.argv[1]
    tracks = sys.argv[2:]
    rows = load()
    MAIN = {'김동학', '서희항', '최숙진', '신우진', '미정'}
    if owner == 'OTHERS':
        sel = [r for r in rows if r['owner_name'] not in MAIN]
    else:
        sel = [r for r in rows if (owner == '*' or r['owner_name'] == owner)
               and (not tracks or r['track'] in tracks)]
    print(f'## {owner} {tracks} = {len(sel)}행')
    for r in sel:
        print(f"{r['row_id']}|{r['track']}.{r['step']}|{r['owner_name']}|{r['status']}|{r['title'][:90]}")
        print(f"   ev={r['evidence'][:190]}")
