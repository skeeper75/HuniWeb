#!/usr/bin/env python3
# t60 ㉮ 사전 실측 — 리드가 말한 「241행·남은 일 181」을 어떤 집계 규칙으로 재현할 수 있는지 탐색.
# 읽기전용. t56 원장은 열기만 한다.
import csv, re, os

BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE, '..', 't56', 'rejudge.csv')
rows = list(csv.DictReader(open(SRC, encoding='utf-8')))


def toks(op, seps='+'):
    return [t.strip() for t in re.split('[' + re.escape(seps) + ']', op or '')]


VARIANTS = {
    'contains':     lambda r: '서희항' in (r['owner_proposed'] or ''),
    'plus_token':   lambda r: '서희항' in toks(r['owner_proposed'], '+'),
    'plus_or_dot':  lambda r: '서희항' in toks(r['owner_proposed'], '+·'),
    'sole':         lambda r: (r['owner_proposed'] or '').strip() == '서희항',
    'now_contains': lambda r: '서희항' in (r['owner_now'] or ''),
}

print(f"{'variant':14} {'n':>5} {'remY':>5} {'n-prov':>7} {'remY-prov':>10}")
for k, f in VARIANTS.items():
    g = [r for r in rows if f(r)]
    y = [r for r in g if r['remaining'] == 'Y']
    gp = [r for r in g if r['verdict'] != 'provided']
    yp = [r for r in y if r['verdict'] != 'provided']
    print(f"{k:14} {len(g):5} {len(y):5} {len(gp):7} {len(yp):10}")
