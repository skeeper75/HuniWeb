#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적재 CSV 자기검증 게이트 (product-accessory · 대조군).
   L1 + ref 마스터에서 기대행을 독립 재생성해 load CSV와 대조. 누락0/날조0 입증.
   대조군 특화: 적재가 적으므로(qty_unit 15행만) "정상=적재없음" 항목은 false MISSING을
   양산하지 않도록 별도 INVARIANT 게이트로 검증(size+material가 15상품 완전커버·변경0).
   --sheet 파라미터화 정신: SHEET 상수 + PA_CDS + ENVELOPE/ACCESSORY만 교체하면 타시트 확장.
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
SHEET = 'product-accessory'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 매핑만 교체

def rd(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
def rl(name, sub='load'):
    with open(os.path.join(BASE, sub, name), encoding='utf-8') as f:
        return list(csv.DictReader(f))

prods = {r['prd_cd']: r for r in rd('00_schema/ref-products.csv')}
PA_CDS = [f'PRD_0000{n:02d}' for n in range(1, 16)]  # PRD_000001~015, 전부 PRD_TYPE.03

results = []
def check(label, expected: set, actual: set):
    miss = expected - actual; extra = actual - expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss: print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra: print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok

# ---- R3 qty_unit: PA 15상품 전건 QTY_UNIT.01(EA) 부여 대상 ----
exp_qu = set(cd for cd in PA_CDS if cd in prods)
act_qu = set(r['prd_cd'] for r in rl('t_prd_products_qtyunit_update.csv')
             if r['target_qty_unit_typ_cd'] == 'QTY_UNIT.01')
check('R3-qtyunit(EA)', exp_qu, act_qu)

# ---- 모든 적재 prd_cd가 마스터 실재 + PRD_TYPE.03 (날조 가드) ----
fab = []
for r in rl('t_prd_products_qtyunit_update.csv'):
    if r['prd_cd'] not in prods: fab.append(('prd', r['prd_cd']))
    elif prods[r['prd_cd']]['prd_typ_cd'] != 'PRD_TYPE.03': fab.append(('typ', r['prd_cd']))
results.append(('FK/typ-existence', '-', '-', '-', len(fab), not fab))
if fab: print("  [FK] FABRICATED refs:", fab[:8])

# ---- INVARIANT (대조군 정합·false MISSING 회피): size+material가 15상품 완전커버 ----
# 라이브 권위(remediation §3): size 7상품 + material 8상품 = 15, 완전 누락 0.
# 추출본 ref-product-{sizes,materials}.csv로 재집계해 이를 재현(변경 0 = 적재없음이 정상임을 입증).
sized = set(r['prd_cd'] for r in rd('00_schema/ref-product-sizes.csv') if r['prd_cd'] in PA_CDS)
matd = set(r['prd_cd'] for r in rd('00_schema/ref-product-materials.csv') if r['prd_cd'] in PA_CDS)
covered = sized | matd
uncovered = set(PA_CDS) - covered
# size·material 상호배타(한 상품이 둘 다 가질 수도 있으나 PA는 분기) — 둘다0 상품이 곧 진짜 MISSING
results.append(('INV size+material 커버15', len(PA_CDS), len(covered),
                len(uncovered), 0, not uncovered))
if uncovered: print("  [INV] 진짜 size+material 둘다0(MISSING):", sorted(uncovered))

# ---- INVARIANT (정상=적재없음): process/addon/discount/plate 적재CSV 부재 = 정상 ----
# 대조군에서 이 테이블들은 적재 0이 정상(G-PA-4). load/에 해당 CSV가 없으면 PASS.
NORMAL_EMPTY = ['t_prd_product_processes.csv', 't_prd_product_addons.csv',
                't_prd_product_discount_tables.csv', 't_prd_product_plate_sizes.csv']
empty_ok = all(not os.path.exists(os.path.join(LOAD, n)) for n in NORMAL_EMPTY)
results.append(('INV process/addon/disc/plate 미적재=정상', '-', '0', '-', 0, empty_ok))
if not empty_ok:
    print("  [INV] 경고: 정상=적재없음 테이블에 적재 CSV 존재(대조군 false MISSING 의심)")

# ---- 출력 ----
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':38s} {'exp':>5s} {'act':>5s} {'miss':>5s} {'extra':>6s}  result")
allok = True
for lbl, e, a, m, x, ok in results:
    allok &= ok
    print(f"{lbl:38s} {str(e):>5s} {str(a):>5s} {str(m):>5s} {str(x):>6s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0 (대조군: 적재 적음=정상)' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
