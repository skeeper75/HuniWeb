#!/usr/bin/env python3
# t60 — 서희항 행 덤프(prefix 지정 / 미분류 확인). 읽기전용.
import sys, os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from scan import SHH, prefix

AXIS_PREFIX = {
    'STD-OPT': '1', 'STD-CAT': '1',
    'STD-ART': '2',
    'STD-SYS': '3', 'BLK-S1': '3', 'BLK-S2': '3',
    'STD-MFG': '4', 'STD-ADO': '4',
    'F1': '5', 'F2': '5', 'F3': '5', 'STD-ADP': '5',
}

args = sys.argv[1:]
want = args[0] if args else 'UNMAPPED'
only_remaining = '--all' not in args

for r in SHH:
    p = prefix(r['row_id'])
    if want == 'UNMAPPED':
        if p in AXIS_PREFIX:
            continue
    elif p != want:
        continue
    if only_remaining and r['remaining'] != 'Y':
        continue
    print(' | '.join([r['row_id'], r['track'], r['status'], r['verdict'],
                      r['owner_proposed'], r['title'][:66]]))
    print('      ev: ' + (r['evidence'] or '')[:150])
