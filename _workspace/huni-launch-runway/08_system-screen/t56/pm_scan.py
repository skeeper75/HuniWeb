#!/usr/bin/env python3
# t56 — 「PM 은 만들지 않는다」 위반 스캔: 구현 담당이 든 행을 신우진으로 보내는 제안
import csv, os

HERE = os.path.dirname(os.path.abspath(__file__))
rows = list(csv.DictReader(open(os.path.join(HERE, 'rejudge.csv'), encoding='utf-8')))
for r in rows:
    if '신우진' in r['owner_proposed'] and r['owner_now'] != '신우진':
        print(f"{r['row_id']}|{r['track']}.{r['step']}|{r['owner_now']}→{r['owner_proposed']}|"
              f"{r['verdict']}|{r['judged_by']}|{r['title'][:60]}")
