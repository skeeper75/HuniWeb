#!/usr/bin/env python3
"""t63 담당 범위(탐색~결제)를 원장 735행에서 잘라 scope.csv 로 고정한다.
STD-ART 는 고객 쪽(업로드·미리보기·에디터·보관)만 담당이고,
검판(C4)·생산연계(C5)·PitStop 은 t64(lane-4) 경계 행으로 따로 뺀다."""
import csv, json, os, re

HERE = os.path.dirname(os.path.abspath(__file__))
LEDGER = os.path.join(HERE, '../../08_system-screen/t56/rejudge.csv')
CANON = os.path.join(HERE, '../../07_rebaseline/L1/standard-feature-canon.csv')

MINE_PREFIX = ('STD-CAT', 'STD-OPT', 'STD-ORD', 'STD-PAY', 'STD-SHP')

# STD-ART 경계: t64(생산·검판) 로 넘기는 행
ART_T64 = {f'STD-ART-{n:03d}' for n in list(range(8, 19)) + [28, 33, 34, 35]}


def main():
    canon = {r['std_id']: r for r in csv.DictReader(open(CANON))}
    mine, boundary = [], []
    for r in csv.DictReader(open(LEDGER)):
        rid = r['row_id']
        c = canon.get(rid, {})
        rec = {
            'row_id': rid,
            'track': r['track'], 'step': r['step'],
            'title': r['title'],
            'status': r['status'],
            'owner': r['owner_proposed'],
            'daebun': c.get('대분류', ''),
            'jungbun': c.get('중분류', ''),
            'in_canon': 'Y' if rid in canon else 'N',
        }
        if rid.startswith(MINE_PREFIX):
            mine.append(rec)
        elif rid.startswith('STD-ART'):
            (boundary if rid in ART_T64 else mine).append(rec)

    cols = ['row_id', 'daebun', 'jungbun', 'track', 'step', 'title',
            'status', 'owner', 'in_canon']
    for name, rows in [('scope.csv', mine), ('boundary-t64.csv', boundary)]:
        with open(os.path.join(HERE, name), 'w', newline='', encoding='utf-8') as f:
            w = csv.DictWriter(f, fieldnames=cols, lineterminator='\n')
            w.writeheader()
            w.writerows(rows)
    print(f'담당 {len(mine)}행 · t64 경계 {len(boundary)}행')
    from collections import Counter
    print(Counter(re.match(r'STD-[A-Z]+', r['row_id']).group(0) for r in mine))


main()
