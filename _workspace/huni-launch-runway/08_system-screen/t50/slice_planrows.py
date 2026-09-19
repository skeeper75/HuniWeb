"""t50 입력 준비: 9/17 원장 735행에서 mes / edicus / pitstop 관련 행만 잘라낸다.

계약(CONTRACT.md)의 plan_row_id 매핑용 참조표. 읽기 전용 — 원장은 건드리지 않는다.
"""
import csv
import os

BASE = os.path.dirname(os.path.abspath(__file__))
SRC = os.path.normpath(os.path.join(
    BASE, '..', '..', '07_rebaseline', 'S', 'S5-plan', 'plan-rows.csv'))
OUT = os.path.join(BASE, 'parts')

KEYS = {
    'mes': ['mes', '생산지시', '작업지시', 'easymes', '이카운트', 'ecount', '생산 연동'],
    'edicus': ['edicus', '에디터', 'editor', '편집기'],
    'pitstop': ['pitstop', '프리플라이트', 'preflight', '파일 검수', '검수'],
}
COLS = ['row_id', 'track', 'step', 'title', 'owner_name', 'status', 'evidence',
        'check_method', 'prereq', 'note', 'api_path', 'api_evidence', 'wait_target']
BLOB_COLS = ['title', 'evidence', 'note', 'check_method', 'prereq',
             'wait_target', 'api_path', 'api_evidence', 'step']


def main():
    rows = list(csv.DictReader(open(SRC, encoding='utf-8')))
    print('plan-rows.csv 총 %d행' % len(rows))
    for name, keys in KEYS.items():
        sel = [r for r in rows
               if any(k in ' '.join((r.get(c) or '') for c in BLOB_COLS).lower()
                      for k in keys)]
        path = os.path.join(OUT, 'planrows-%s.csv' % name)
        with open(path, 'w', newline='', encoding='utf-8') as f:
            w = csv.DictWriter(f, fieldnames=COLS, extrasaction='ignore')
            w.writeheader()
            w.writerows(sel)
        print('%-8s %3d행 -> %s' % (name, len(sel), path))


if __name__ == '__main__':
    main()
