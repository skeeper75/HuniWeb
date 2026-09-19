#!/usr/bin/env python3
# t60 ㉮ — 서희항 몫 전수 스캔. t56/rejudge.csv 읽기전용.
# 집계 규칙(명시): owner_proposed 에 '서희항' 이 토큰으로 들어간 행 = 서희항 몫.
import csv, re, os, collections, sys

BASE = os.path.dirname(os.path.abspath(__file__))
rows = list(csv.DictReader(open(os.path.join(BASE, '..', 't56', 'rejudge.csv'), encoding='utf-8')))


def tok(op):
    return [t.strip() for t in re.split(r'[+·]', op or '')]


def is_shh(r):
    return '서희항' in tok(r['owner_proposed'])


SHH = [r for r in rows if is_shh(r)]


def prefix(rid):
    m = re.match(r'^([A-Z]+-[A-Z0-9]+)-\d+$', rid)
    if m:
        return m.group(1)
    m = re.match(r'^([A-Z]+\d*)-', rid)
    return m.group(1) if m else rid


if __name__ == '__main__':
    print('서희항 몫 총', len(SHH), '· 남은 일', sum(1 for r in SHH if r['remaining'] == 'Y'))
    c = collections.Counter(prefix(r['row_id']) for r in SHH)
    cy = collections.Counter(prefix(r['row_id']) for r in SHH if r['remaining'] == 'Y')
    print(f"\n{'prefix':12} {'행':>4} {'남은':>4}")
    for k, v in c.most_common():
        print(f"{k:12} {v:4} {cy.get(k,0):4}")
    print('\ntrack:', dict(collections.Counter(r['track'] for r in SHH)))
    print('status:', dict(collections.Counter(r['status'] for r in SHH)))
    print('basis:', dict(collections.Counter(r['basis'] for r in SHH)))
    if len(sys.argv) > 1:  # 특정 prefix 행 덤프
        for r in SHH:
            if prefix(r['row_id']) == sys.argv[1]:
                print('|'.join([r['row_id'], r['track'], r['status'], r['remaining'],
                                r['owner_proposed'], r['title'][:70]]))
