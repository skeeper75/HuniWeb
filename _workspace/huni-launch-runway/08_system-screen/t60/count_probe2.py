#!/usr/bin/env python3
# t60 ㉮ 사전 실측 2 — 241/181 재현 시도(배제 규칙 조합 탐색). 읽기전용.
import csv, re, os, itertools

BASE = os.path.dirname(os.path.abspath(__file__))
rows = list(csv.DictReader(open(os.path.join(BASE, '..', 't56', 'rejudge.csv'), encoding='utf-8')))


def tok(op, seps='+·'):
    return [t.strip() for t in re.split('[' + re.escape(seps) + ']', op or '')]


BASES = {
    'contains': lambda r: '서희항' in (r['owner_proposed'] or ''),
    'plus_token': lambda r: '서희항' in tok(r['owner_proposed'], '+'),
    'dot_token': lambda r: '서희항' in tok(r['owner_proposed'], '+·'),
}
EXCL = {
    'provided': lambda r: r['verdict'] == 'provided',
    'blk': lambda r: r['row_id'].startswith('BLK-'),
    'sun_prefix': lambda r: (r['title'] or '').startswith('[선행 입력]'),
    'multi': lambda r: len(tok(r['owner_proposed'], '+·')) > 1,
    'unnecessary': lambda r: r['verdict'] == '불필요',
}

hits = []
for bname, bf in BASES.items():
    g0 = [r for r in rows if bf(r)]
    for k in range(len(EXCL) + 1):
        for combo in itertools.combinations(EXCL, k):
            g = [r for r in g0 if not any(EXCL[c](r) for c in combo)]
            y = [r for r in g if r['remaining'] == 'Y']
            if (len(g), len(y)) == (241, 181):
                hits.append((bname, combo, len(g), len(y)))
            print(f"{bname:11} {'+'.join(combo) or '(none)':40} n={len(g):4} remY={len(y):4}")
print('\n=== 241/181 재현 조합 ===')
print(hits or '없음 — 재현 실패')
