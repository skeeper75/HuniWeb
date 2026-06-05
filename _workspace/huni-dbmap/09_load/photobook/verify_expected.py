#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적재 CSV 자기검증 게이트 (photobook) — L1+ref에서 기대행을 독립 재생성해 load CSV와 대조.
   누락0 / 날조0 입증. count → set → value 3단 대조 + photobook 고유 무결성 게이트.
   --sheet 파라미터화 정신: SHEET 상수 + 4맵(NM2CD/QTY_TARGET/NOOP_INVARIANTS/PUR_CODE)만 시트별 교체.
   photobook 특화: 라이브 거의 완비 → active 적재 = qty_unit UPDATE 1행. 나머지는 no-op 불변식 검사.
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
BASE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(BASE,'..','..'))
LOAD=os.path.join(BASE,'load')
SHEET='photobook'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 매핑만 교체

# ---- 시트별 교체 맵 (4) ----
NM2CD={'포토북 [디자인명]':'PRD_000100'}        # 상품명 → prd_cd (단일상품)
QTY_TARGET={'PRD_000100':'QTY_UNIT.03'}         # R5: 포토북=권 (C-4)
PUR_CODE='PROC_000020'                           # 제본 권위 = PUR (C-10, 레이플랫 025 미운영)
LEAFLAT_CODE='PROC_000025'                        # 레이플랫 = 적재 0 기대 (미운영)

def load_csv(p):
    with open(os.path.join(ROOT,p),encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
def load_load(name):
    with open(os.path.join(LOAD,name),encoding='utf-8') as f:
        return list(csv.DictReader(f))

mats={r['mat_nm'].strip():r['mat_cd'] for r in load_csv('00_schema/ref-materials.csv')}
prods={r['prd_cd']:r for r in load_csv('00_schema/ref-products.csv')}
allproc=set(r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv'))
allmat=set(mats.values())

# 라이브(추출본) PRD_000100 기적재 상태 — no-op 불변식 검사 권위
live_proc=set(r['proc_cd'] for r in load_csv('00_schema/ref-product-processes.csv') if r['prd_cd']=='PRD_000100')
live_mat=[(r['mat_cd'],r['usage_cd']) for r in load_csv('00_schema/ref-product-materials.csv') if r['prd_cd']=='PRD_000100']
live_pagerule=[r for r in load_csv('00_schema/ref-product-page-rules.csv') if r['prd_cd']=='PRD_000100']
live_sets=[r for r in load_csv('00_schema/ref-product-sets.csv') if r['prd_cd']=='PRD_000100']

results=[]
def check(label, expected:set, actual:set):
    miss=expected-actual; extra=actual-expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss: print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra: print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok
def check_bool(label, cond, detail=''):
    results.append((label,'-','-','-', 0 if cond else 1, cond))
    if not cond: print(f"  [{label}] INVARIANT FAIL: {detail}")
    return cond

# ---- R5 qty_unit (active 적재): L1 단일상품 → QTY_UNIT.03 (권) ----
exp_qu=set((cd,t) for cd,t in QTY_TARGET.items())
act_qu=set((r['prd_cd'],r['target_qty_unit_typ_cd']) for r in load_load('t_prd_products_qtyunit_update.csv'))
check('R5-qtyunit(active)', exp_qu, act_qu)

# ---- G-PB-1 no-op 불변식: 제본 = PUR(PROC_000020) 기적재 · 레이플랫(025) 적재 0 ----
check_bool('G-PB-1 제본=PUR 기적재(no-op)', PUR_CODE in live_proc,
           f'live PRD_000100 proc={sorted(live_proc)}')
leaflat_any=any(r['proc_cd']==LEAFLAT_CODE for r in load_csv('00_schema/ref-product-processes.csv'))
check_bool('G-PB-1 레이플랫(025) 적재0(미운영)', not leaflat_any,
           '레이플랫이 어떤 상품에 적재됨 — 미운영 위반')

# ---- G-PB-5 no-op 불변식: 표지 sub_prd variant·내지·면지·page_rule·sets 기적재(재적재 금지) ----
cover_u02=[mc for mc,u in live_mat if u=='USAGE.02']
inner_u01=[mc for mc,u in live_mat if u=='USAGE.01']
myeon_u03=[mc for mc,u in live_mat if u=='USAGE.03']
check_bool('G-PB-5 표지 variant 5종 USAGE.02 기적재', len(cover_u02)==5,
           f'cover USAGE.02 count={len(cover_u02)} (기대5: 하드/레더하드/소프트/레더화이트/아트250+무광)')
check_bool('G-PB-5 내지 USAGE.01 기적재', len(inner_u01)==1, f'inner count={len(inner_u01)}')
check_bool('G-PB-5 면지 USAGE.03 기적재', len(myeon_u03)==1, f'myeonji count={len(myeon_u03)}')
check_bool('G-PB-5 page_rule(24/150/2) 기적재', any(r['page_min']=='24' and r['page_max']=='150' and r['page_incr']=='2' for r in live_pagerule),
           f'page_rule={[(r["page_min"],r["page_max"],r["page_incr"]) for r in live_pagerule]}')
check_bool('G-PB-5 sets 7행(내지1·표지5·면지1) 기적재', len(live_sets)==7, f'sets count={len(live_sets)}')

# ---- 재적재 금지 가드: active load에 process/material INSERT 0 (no-op 보장) ----
proc_insert=os.path.exists(os.path.join(LOAD,'t_prd_product_processes.csv'))
mat_insert=os.path.exists(os.path.join(LOAD,'t_prd_product_materials.csv'))
check_bool('재적재 금지: active process INSERT 0', not proc_insert,
           'load/에 process INSERT CSV 존재 — 라이브 기적재 중복 위험')
check_bool('재적재 금지: active material INSERT 0', not mat_insert,
           'load/에 material INSERT CSV 존재 — 라이브 기적재 중복 위험')

# ---- FK 실재 가드: active 적재 prd_cd 실재 + deferred 제안 FK 실재 ----
fab=[]
for r in load_load('t_prd_products_qtyunit_update.csv'):
    if r['prd_cd'] not in prods: fab.append(('prd',r['prd_cd']))
DEF=os.path.join(BASE,'_deferred')
def _deferred(name):
    p=os.path.join(DEF,name)
    if not os.path.exists(p): return []
    with open(p,encoding='utf-8') as f: return list(csv.DictReader(f))
for r in _deferred('t_prd_product_materials_gpb3_split_proposal.csv'):
    if r['mat_cd'] not in allmat: fab.append(('def-mat',r['mat_cd']))
for r in _deferred('t_prd_product_processes_gpb3_split_proposal.csv'):
    if r['proc_cd'] not in allproc: fab.append(('def-proc',r['proc_cd']))
results.append(('FK-existence(active+deferred)', '-', '-', '-', len(fab), not fab))
if fab: print("  [FK] FABRICATED refs:", fab[:8])

# ---- 출력 ----
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':42s} {'exp':>4s} {'act':>4s} {'miss':>4s} {'extra':>5s}  result")
allok=True
for lbl,e,a,m,x,ok in results:
    allok &= ok
    print(f"{lbl:42s} {str(e):>4s} {str(a):>4s} {str(m):>4s} {str(x):>5s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0·no-op불변식 충족' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
