#!/usr/bin/env python3
# t56 — rejudge.csv 열람: python3 show.py <owner> [verdict]
import csv, os, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
rows = list(csv.DictReader(open(os.path.join(HERE, 'rejudge.csv'), encoding='utf-8')))
owner = sys.argv[1] if len(sys.argv) > 1 else None
verdict = sys.argv[2] if len(sys.argv) > 2 else None
sel = [r for r in rows
       if (not owner or owner == '*' or r['owner_now'] == owner)
       and (not verdict or r['verdict'] == verdict)]
print(f'{owner} / {verdict} = {len(sel)}행')
print(dict(collections.Counter(r['judged_by'] for r in sel)))
for r in sel:
    print(f"{r['row_id']}|{r['track']}.{r['step']}|{r['status']}|→{r['owner_proposed']}|{r['judged_by']}|{r['title'][:58]}")
    if r['note']:
        print(f"    {r['note'][:150]}")
