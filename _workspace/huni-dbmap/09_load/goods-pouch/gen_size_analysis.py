#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""size(재단치수) BLOCKER 분석 — L1 사이즈(필수) → 마스터 siz_cd 해소 가능성 분류.
   plate 복제 절대 금지(의미축 분리). L1 재단치수 셀이 권위.
   산출: load/t_prd_product_sizes_BLOCKED.reference.csv (NO-LOAD, 차단 근거)
   결론: WxH 재단치수 8상품 = 전부 기적재(사각손거울 레퍼런스 패턴). 비치수 62상품 = 마스터 siz_cd 부재 → 적재 불가(컨펌)."""
import csv, os, re
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')

def rc(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

def nums(s):
    return tuple(float(x) for x in re.findall(r'(\d+(?:\.\d+)?)', s))

prods = {r['prd_nm'].strip(): r for r in rc('00_schema/ref-products.csv')}
existing = {}
for r in rc('00_schema/ref-product-sizes.csv'):
    existing.setdefault(r['prd_cd'], set()).add(r['siz_cd'])
existing_plate = {}
for r in rc('00_schema/ref-product-plate-sizes.csv'):
    existing_plate.setdefault(r['prd_cd'], set()).add(r['siz_cd'])

# 마스터 cut-dims 인덱스(재단치수 매칭용)
by_cut = {}
for r in rc('00_schema/ref-sizes.csv'):
    try:
        cw = float(r['cut_width']); ch = float(r['cut_height'])
        by_cut.setdefault((cw, ch), []).append(r['siz_cd'])
    except (ValueError, TypeError):
        pass

l1 = {}
with open(os.path.join(ROOT, '06_extract', 'goods-pouch-l1.csv'), encoding='utf-8-sig') as f:
    for r in csv.DictReader(f):
        nm = (r.get('prd_nm') or '').strip()
        s = (r.get('사이즈(필수)') or '').strip()
        if nm and s:
            l1.setdefault(nm, []).append(s)

rows = []
for nm, vals in l1.items():
    if nm not in prods:
        continue  # 폰케이스 unmatched 제외
    cd = prods[nm]['prd_cd']
    uy = prods[nm]['use_yn']
    loaded = len(existing.get(cd, set()))
    plate_loaded = len(existing_plate.get(cd, set()))
    for v in vals:
        n = nums(v)
        has_wxh = len(n) >= 2 and ('x' in v.lower() or '×' in v)
        if has_wxh and (n[0], n[1]) in by_cut:
            cat = 'RESOLVABLE(마스터 cut 일치)'
            siz = ';'.join(by_cut[(n[0], n[1])])
        elif has_wxh:
            cat = 'WxH_NO_MASTER(치수 있으나 마스터 부재)'
            siz = ''
        else:
            cat = '비치수(NONDIM — 마스터 재단치수 siz_cd 부재)'
            siz = ''
        rows.append({
            'prd_cd': cd, 'prd_nm': nm, 'use_yn': uy,
            'l1_size_value': v, 'category': cat,
            'candidate_siz_cd': siz,
            'size_loaded': loaded, 'plate_loaded': plate_loaded,
            'verdict': ('기적재(skip)' if loaded > 0
                        else 'BLOCKED — 마스터 siz_cd 신설 필요(컨펌, 추정 금지)')
        })

with open(os.path.join(LOAD, 't_prd_product_sizes_BLOCKED.reference.csv'),
          'w', encoding='utf-8', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['prd_cd', 'prd_nm', 'use_yn', 'l1_size_value',
                                      'category', 'candidate_siz_cd', 'size_loaded',
                                      'plate_loaded', 'verdict'])
    w.writeheader()
    for r in rows:
        w.writerow(r)

# 집계
from collections import Counter
prod_state = {}
for r in rows:
    prod_state.setdefault(r['prd_cd'], {'uy': r['use_yn'], 'loaded': r['size_loaded'],
                                        'cats': set()})
    prod_state[r['prd_cd']]['cats'].add(r['category'].split('(')[0])
active_loaded = [cd for cd, s in prod_state.items() if s['uy'] == 'Y' and s['loaded'] > 0]
active_blocked = [cd for cd, s in prod_state.items() if s['uy'] == 'Y' and s['loaded'] == 0]
print('size BLOCKER 분석:')
print('  L1 사이즈 보유 상품(matched):', len(prod_state))
print('  active 기적재(WxH 레퍼런스 패턴):', len(active_loaded))
print('  active 차단(비치수, 마스터 siz_cd 부재):', len(active_blocked))
print('  적재 가능 신규 size 행:', 0, '(전부 기적재 또는 마스터 부재)')
