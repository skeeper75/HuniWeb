"""9/17 원장에서 「MES 소스 없음 / 미실측」을 근거로 적힌 행을 뽑는다.

t50 에서 STD-MFG-060·061 두 건이 실제로는 코드가 있는데 원장에 "MES 소스 없음"
으로 적혀 있었다(MES 저장소를 읽지 않은 채 작성된 결과). 같은 이유로 과소평가된
행이 더 있을 수 있어, 같은 문구 패턴을 쓰는 행을 **후보**로 열거한다.

[HARD] 이 목록은 확정 결함이 아니다 — 문구 일치로 뽑은 가설이며, 각 행은 MES
코드를 직접 읽어 확인해야 판정된다. verdict.md 에도 후보로만 적는다.
"""
import csv
import os
import re

BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.join(BASE, 'parts', 'planrows-mes.csv')
OUT = os.path.join(BASE, 'unmeasured-candidates.csv')

# 「소스를 못 봤다」는 뜻으로 원장에 쓰인 문구들
PATTERNS = [
    r'MES\s*소스\s*없음',
    r'미실측',
    r'소스\s*미확보',
    r'코드\s*미확인',
    r'저장소\s*없음',
    r'접근\s*불가',
]
RX = re.compile('|'.join(PATTERNS))
SCAN_COLS = ['evidence', 'check_method', 'note', 'status', 'prereq']
CONFIRMED = {'STD-MFG-060', 'STD-MFG-061'}  # t50 에서 코드 실재 확인


def main():
    rows = list(csv.DictReader(open(SRC, encoding='utf-8')))
    hits = []
    for r in rows:
        matched = []
        for col in SCAN_COLS:
            val = r.get(col) or ''
            if RX.search(val):
                matched.append(col)
        if matched:
            hits.append({
                'row_id': r['row_id'],
                'step': r['step'],
                'title': r['title'],
                'matched_cols': '|'.join(matched),
                'status': r['status'],
                'evidence': (r.get('evidence') or '')[:300],
                't50_판정': '코드 실재 확인' if r['row_id'] in CONFIRMED else '후보(미확인)',
            })

    with open(OUT, 'w', newline='', encoding='utf-8') as f:
        w = csv.DictWriter(f, fieldnames=list(hits[0].keys()) if hits else
                           ['row_id', 'step', 'title', 'matched_cols',
                            'status', 'evidence', 't50_판정'])
        w.writeheader()
        w.writerows(hits)

    print('planrows-mes.csv %d행 중 %d행이 「소스 못 봄」 문구 사용' % (len(rows), len(hits)))
    print('-> %s' % OUT)
    for h in hits:
        print('  %-14s %-4s %s [%s] %s' % (
            h['row_id'], h['step'], h['title'][:46], h['matched_cols'], h['t50_판정']))


if __name__ == '__main__':
    main()
