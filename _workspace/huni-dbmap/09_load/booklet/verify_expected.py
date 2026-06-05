#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""booklet 적재 CSV 자기검증 게이트 — L1+ref+IMPORT에서 기대행을 독립 재생성해 load CSV와 대조.
   누락0 / 날조0 입증. count → set → FK 실재 3단 대조.
   --sheet 파라미터화 정신(파일럿 베이스): SHEET / NM2CD / IMPORT_SLOT(슬롯인지) / EMBOSS_SIG 4맵만 교체.
   booklet 특화: 자재 IMPORT는 (prd_cd,mat_cd,usage_cd) 3튜플(내지.01/표지.02 슬롯 구분).
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
from collections import defaultdict

BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
SHEET = 'booklet'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 매핑만 교체


def load_csv(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


def load_load(name):
    with open(os.path.join(LOAD, name), encoding='utf-8') as f:
        return list(csv.DictReader(f))


mats = {r['mat_nm'].strip(): r['mat_cd'] for r in load_csv('00_schema/ref-materials.csv')}
prods = {r['prd_cd']: r for r in load_csv('00_schema/ref-products.csv')}

NM2CD = {
    '중철책자': 'PRD_000068', '무선책자': 'PRD_000069', 'PUR책자': 'PRD_000070',
    '트윈링책자': 'PRD_000071', '하드커버책자': 'PRD_000072', '레더 하드커버책자': 'PRD_000077',
    '하드커버 링책자': 'PRD_000082', '레더 링바인더': 'PRD_000088', '엽서북': 'PRD_000094',
    '떡메모지': 'PRD_000097', '포토북 [디자인명]': 'PRD_000100',
}
# IMPORT 컬럼 → (prd_cd, usage_cd) : 해소 확정 3상품(068/069/071)만 active 기대
IMPORT_SLOT = {
    '중철내지':                  ('PRD_000068', 'USAGE.01'),
    '중철표지':                  ('PRD_000068', 'USAGE.02'),
    '무선내지':                  ('PRD_000069', 'USAGE.01'),
    '무선표지 :: 코팅/오시':       ('PRD_000069', 'USAGE.02'),
    '트윈링내지':                ('PRD_000071', 'USAGE.01'),
    '트윈링표지 :: 코팅/오시':     ('PRD_000071', 'USAGE.02'),
}
# 형압 신호: L1 박/형압가공 컬럼값 → proc_cd (값 포함매칭)
EMBOSS_SIG = {'형압(양각)': 'PROC_000051', '형압(음각)': 'PROC_000052'}
COL_GAGONG = '박(표지) / 형압 (옵션)_박/형압가공'

results = []


def check(label, expected: set, actual: set):
    miss = expected - actual
    extra = actual - expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss:
        print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra:
        print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok


# ---- R1 material: IMPORT ●종이 → (prd_cd,mat_cd,usage_cd) 3튜플 독립 산출 ----
papers = defaultdict(list)
with open(os.path.join(ROOT, '06_extract', 'import-paper-matrix-long.csv'), encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        pc = row['product_col'].strip()
        if pc in IMPORT_SLOT and row['mark'].strip() == '●':
            papers[pc].append(row['paper_name'].strip())
exp_mat = set()
for impcol, (prd_cd, usage_cd) in IMPORT_SLOT.items():
    for p in papers[impcol]:
        mc = mats.get(p)
        if mc:
            exp_mat.add((prd_cd, mc, usage_cd))
act_mat = set((r['prd_cd'], r['mat_cd'], r['usage_cd']) for r in load_load('t_prd_product_materials.csv'))
check('R1-material', exp_mat, act_mat)

# ---- R2 process: L1 형압 신호 → (prd_cd,proc_cd) 독립 산출 ----
exp_proc = set()
with open(os.path.join(ROOT, '06_extract', 'booklet-l1.csv'), encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        nm = (row.get('prd_nm') or '').strip()
        if nm not in NM2CD:
            continue
        cd = NM2CD[nm]
        g = (row.get(COL_GAGONG) or '').strip()
        for token, pc in EMBOSS_SIG.items():
            if token in g:
                exp_proc.add((cd, pc))
# 기존 적재(중복PK) 제외 — 적재 기대는 신규분만
existing_proc = set((r['prd_cd'], r['proc_cd']) for r in load_csv('00_schema/ref-product-processes.csv'))
exp_proc_new = set(t for t in exp_proc if t not in existing_proc)
act_proc = set((r['prd_cd'], r['proc_cd']) for r in load_load('t_prd_product_processes.csv'))
check('R2-process', exp_proc_new, act_proc)

# ---- R6 qty_unit: booklet 11 parent 전건 QTY_UNIT.03(권). update CSV는 BASE 디렉토리에 위치 ----
exp_qu = set(NM2CD.values())
with open(os.path.join(BASE, 't_prd_products_qtyunit_update.csv'), encoding='utf-8') as f:
    act_qu = set(r['prd_cd'] for r in csv.DictReader(f) if r['target_qty_unit_typ_cd'] == 'QTY_UNIT.03')
check('R6-qtyunit', exp_qu, act_qu)

# ---- 날조 가드: 모든 적재 prd_cd/mat_cd/proc_cd/usage_cd가 마스터에 실재 ----
allproc = set(r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv'))
allmat = set(mats.values())
fab = []
for r in load_load('t_prd_product_materials.csv'):
    if r['mat_cd'] not in allmat:
        fab.append(('mat', r['mat_cd']))
    if r['prd_cd'] not in prods:
        fab.append(('prd', r['prd_cd']))
    if r['usage_cd'] not in ('USAGE.01', 'USAGE.02', 'USAGE.03', 'USAGE.05', 'USAGE.07'):
        fab.append(('usage', r['usage_cd']))
for r in load_load('t_prd_product_processes.csv'):
    if r['proc_cd'] not in allproc:
        fab.append(('proc', r['proc_cd']))
    if r['prd_cd'] not in prods:
        fab.append(('prd', r['prd_cd']))
results.append(('FK-existence', '-', '-', '-', len(fab), not fab))
if fab:
    print("  [FK] FABRICATED refs:", fab[:8])

# ---- 중복 PK 가드: material(prd,mat,usage) / process(prd,proc) 적재 내 중복 0 ----
mat_keys = [(r['prd_cd'], r['mat_cd'], r['usage_cd']) for r in load_load('t_prd_product_materials.csv')]
proc_keys = [(r['prd_cd'], r['proc_cd']) for r in load_load('t_prd_product_processes.csv')]
dup = (len(mat_keys) - len(set(mat_keys))) + (len(proc_keys) - len(set(proc_keys)))
results.append(('PK-dup', '-', '-', '-', dup, dup == 0))
if dup:
    print("  [PK] DUPLICATE keys in load CSV:", dup)

# ---- 출력 ----
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':22s} {'exp':>5s} {'act':>5s} {'miss':>5s} {'extra':>6s}  result")
allok = True
for lbl, e, a, m, x, ok in results:
    allok &= ok
    print(f"{lbl:22s} {str(e):>5s} {str(a):>5s} {str(m):>5s} {str(x):>6s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
