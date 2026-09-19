#!/usr/bin/env python3
# t56 — STD-ADC-014 근거 직접 확인: 가이드파일 스냅샷의 표시명·태그·순서 채움 실태
import csv, collections

SNAP = ('/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/'
        'snap_20260827_1422/t_prd_guide_files.csv')

with open(SNAP, encoding='utf-8') as f:
    rows = list(csv.DictReader(f))


def blank(v):
    return not (v or '').strip()


print('행수', len(rows))
print('상품 수(prd_cd)', len({r['prd_cd'] for r in rows}))
for col in ('guide_nm', 'tags', 'disp_seq', 'note', 'orig_file_nm', 'file_key'):
    print(f'  {col} 공란 {sum(1 for r in rows if blank(r[col]))}')
print('del_yn 분포', dict(collections.Counter(r['del_yn'] for r in rows)))
print('use_yn 분포', dict(collections.Counter(r['use_yn'] for r in rows)))
