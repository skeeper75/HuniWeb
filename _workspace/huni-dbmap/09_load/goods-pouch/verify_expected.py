#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적재 CSV 자기검증 게이트 (goods-pouch) — L1+ref에서 기대행 독립 재생성해 load CSV와 대조.
   누락0 / 날조0 입증. count → set → FK 실재 3단 대조. + 폰케이스 신규행=0 가드 + size BLOCKER 가드.
   --sheet 파라미터화 정신: SHEET 상수 + 아래 4맵(NM2CD 역할은 prods로 대체·ADDON_MAP·GAGONG_MAP·PHONE5)만 교체.
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
SHEET = 'goods-pouch'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 4맵만 교체

def rc(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
def ll(name):
    with open(os.path.join(LOAD, name), encoding='utf-8') as f:
        return list(csv.DictReader(f))

prods = {r['prd_nm'].strip(): r for r in rc('00_schema/ref-products.csv')}
prods_cd = {r['prd_cd']: r for r in rc('00_schema/ref-products.csv')}

# 시트별 4맵 (gen_load.py와 동일 — 독립 재선언으로 생성기 출력 미참조)
ADDON_MAP = {'볼체인': 'PRD_000006', '검정': 'PRD_000015', '노랑': 'PRD_000015',
             '빨강': 'PRD_000015', '청보라': 'PRD_000015', '초록': 'PRD_000015',
             '파랑': 'PRD_000015', '핑크': 'PRD_000015', '아크릴스탠드': 'PRD_000160'}
GAGONG_MAP = {'에폭시': 'PROC_000083', '라벨부착': 'PROC_000081', '부착': 'PROC_000081'}
PHONE5 = {'슬림하드 폰케이스', '블랙젤리', '임팩트 젤하드', '에어팟케이스★', '버즈케이스★'}

# L1 신호 독립 재판독
l1 = {}
with open(os.path.join(ROOT, '06_extract', 'goods-pouch-l1.csv'), encoding='utf-8-sig') as f:
    for r in csv.DictReader(f):
        nm = (r.get('prd_nm') or '').strip()
        if not nm:
            continue
        d = l1.setdefault(nm, {'gagong': set(), 'addon': set(), 'size': []})
        if (r.get('가공(옵션)_가공') or '').strip():
            d['gagong'].add(r['가공(옵션)_가공'].strip())
        if (r.get('추가상품(옵션)_추가상품') or '').strip():
            d['addon'].add(r['추가상품(옵션)_추가상품'].strip())
        if (r.get('사이즈(필수)') or '').strip():
            d['size'].append(r['사이즈(필수)'].strip())

existing_addon = {}
for r in rc('00_schema/ref-product-addons.csv'):
    existing_addon.setdefault(r['prd_cd'], set()).add(r['addon_prd_cd'])
existing_proc = {}
for r in rc('00_schema/ref-product-processes.csv'):
    existing_proc.setdefault(r['prd_cd'], set()).add(r['proc_cd'])

results = []
def check(label, expected, actual):
    miss = expected - actual; extra = actual - expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss: print('  [%s] MISSING(기대>적재):' % label, sorted(miss)[:8])
    if extra: print('  [%s] FABRICATED(적재>기대):' % label, sorted(extra)[:8])
    return ok

# ---- R4 addon active 기대(use_yn=Y, 신호→addon_prd_cd, 기적재 skip) ----
exp_addon = set()
for nm, d in l1.items():
    if not d['addon'] or nm not in prods or prods[nm]['use_yn'] != 'Y':
        continue
    cd = prods[nm]['prd_cd']
    for sig in d['addon']:
        for k, v in ADDON_MAP.items():
            if sig.startswith(k) or sig.replace(' ', '').startswith(k):
                if v not in existing_addon.get(cd, set()):
                    exp_addon.add((cd, v))
                break
act_addon = set((r['prd_cd'], r['addon_prd_cd']) for r in ll('t_prd_product_addons.csv'))
check('R4-addon-active', exp_addon, act_addon)

# ---- R3 process active 기대(use_yn=Y, 가공→proc_cd, 기적재 skip) ----
exp_proc = set()
for nm, d in l1.items():
    if not d['gagong'] or nm not in prods or prods[nm]['use_yn'] != 'Y':
        continue
    cd = prods[nm]['prd_cd']
    for sig in d['gagong']:
        for k, v in GAGONG_MAP.items():
            if k in sig and v not in existing_proc.get(cd, set()):
                exp_proc.add((cd, v))
act_proc = set((r['prd_cd'], r['proc_cd']) for r in ll('t_prd_product_processes.csv'))
check('R3-proc-active', exp_proc, act_proc)

# ---- R6 qty_unit 기대(matched 98 전건 QTY_UNIT.01) ----
exp_qu = set(prods[nm]['prd_cd'] for nm in l1
             if nm in prods and prods[nm]['prd_cd'].startswith('PRD_')
             and 183 <= int(prods[nm]['prd_cd'][4:]) <= 280)
act_qu = set(r['prd_cd'] for r in ll('t_prd_products_qtyunit_update.csv')
             if r['target_qty_unit_typ_cd'] == 'QTY_UNIT.01')
check('R6-qtyunit', exp_qu, act_qu)

# ---- 가드1: 폰케이스 5상품 신규행 0 (active 어떤 CSV에도 부재) ----
phone_in_load = []
for fn in ['t_prd_product_addons.csv', 't_prd_product_processes.csv',
           't_prd_products_qtyunit_update.csv']:
    for r in ll(fn):
        cd = r.get('prd_cd', '')
        # 폰케이스는 prods에 미등록 → prd_cd가 존재할 수 없음. prd_nm 동반 시 검사
        nm = r.get('prd_nm', '')
        if nm in PHONE5 or cd not in prods_cd:
            if cd:  # 빈 prd_cd 무시
                phone_in_load.append((fn, cd, nm))
results.append(('GUARD-phonecase=0', '-', '-', '-', len(phone_in_load), not phone_in_load))
if phone_in_load: print('  [GUARD-phonecase] 폰케이스/미등록 prd 적재 발견:', phone_in_load[:8])

# ---- 가드2: size 신규 적재 0 (BLOCKED — 마스터 siz_cd 부재) ----
size_load = []
sp = os.path.join(LOAD, 't_prd_product_sizes.csv')
if os.path.exists(sp):
    with open(sp, encoding='utf-8') as f:
        size_load = list(csv.DictReader(f))
results.append(('GUARD-size-newrow=0', '-', '-', '-', len(size_load), not size_load))
if size_load: print('  [GUARD-size] 신규 size 적재 발견(마스터 siz_cd 부재 위반):', len(size_load))

# ---- 날조 가드: 적재 prd_cd/addon_prd_cd/proc_cd 마스터 실재 ----
allproc = set(r['proc_cd'] for r in rc('00_schema/ref-processes.csv'))
fab = []
for r in ll('t_prd_product_addons.csv'):
    if r['prd_cd'] not in prods_cd: fab.append(('prd', r['prd_cd']))
    if r['addon_prd_cd'] not in prods_cd: fab.append(('addon_prd', r['addon_prd_cd']))
for r in ll('t_prd_product_processes.csv'):
    if r['prd_cd'] not in prods_cd: fab.append(('prd', r['prd_cd']))
    if r['proc_cd'] not in allproc: fab.append(('proc', r['proc_cd']))
results.append(('FK-existence', '-', '-', '-', len(fab), not fab))
if fab: print('  [FK] FABRICATED refs:', fab[:8])

# ---- 출력 ----
print('\n=== SELF-CHECK (%s) ===' % SHEET)
print('%-22s %5s %5s %5s %6s  result' % ('label', 'exp', 'act', 'miss', 'extra'))
allok = True
for lbl, e, a, m, x, ok in results:
    allok &= ok
    print('%-22s %5s %5s %5s %6s  %s' % (lbl, e, a, m, x, 'PASS' if ok else 'FAIL'))
print('\nGATE: %s' % ('PASS — 누락0·날조0·폰케이스신규0·size신규0' if allok else 'FAIL'))
sys.exit(0 if allok else 1)
