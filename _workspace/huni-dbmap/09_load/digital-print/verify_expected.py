#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적재 CSV 자기검증 게이트 — L1+ref+IMPORT에서 기대행을 독립 재생성해 load CSV와 대조.
   누락0 / 날조0 입증. count → set → value 3단 대조.
   --sheet 파라미터화 정신: SHEET 상수와 NM2CD/IMPORT_MAP만 시트별 교체하면 타시트 확장 가능.
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
BASE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(BASE,'..','..'))
LOAD=os.path.join(BASE,'load')
SHEET='digital-print'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 매핑만 교체

def load_csv(p):
    with open(os.path.join(ROOT,p),encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
def load_load(name):
    with open(os.path.join(LOAD,name),encoding='utf-8') as f:
        return list(csv.DictReader(f))

mats={r['mat_nm'].strip():r['mat_cd'] for r in load_csv('00_schema/ref-materials.csv')}
prods={r['prd_cd']:r for r in load_csv('00_schema/ref-products.csv')}
NM2CD={'프리미엄엽서':'PRD_000016','스탠다드엽서':'PRD_000018','2단접지카드':'PRD_000027',
 '미니접지카드':'PRD_000028','3단접지카드':'PRD_000029','프리미엄명함':'PRD_000031',
 '스탠다드명함':'PRD_000033','스탠다드 쿠폰/상품권':'PRD_000041','프리미엄 쿠폰/상품권':'PRD_000042',
 '소량전단지':'PRD_000047','접지리플렛':'PRD_000048','와이드 접지리플렛':'PRD_000049'}
CONDITIONAL={'PRD_000016'}  # 라이브 충돌 → active에서 제외 기대

results=[]
def check(label, expected:set, actual:set):
    miss=expected-actual; extra=actual-expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss: print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra: print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok

# ---- R1 process: L1 신호에서 기대 (prd_cd,proc_cd) 집합 독립 산출 ----
# 줄수형(오시·미싱 보유) → 29,30; 가변T·가변I 보유 → 31,32. L1 직접 재판독.
sig={}  # prd_cd -> set(procs)
SIGCOLS={'후가공(옵션)_오시':('PROC_000029',),'후가공(옵션)_미싱':('PROC_000030',),
         '후가공(옵션)_가변(텍스트)':('PROC_000031',),'후가공(옵션)_가변(이미지)':('PROC_000032',)}
with open(os.path.join(ROOT,'06_extract','digital-print-l1.csv'),encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        nm=row.get('prd_nm','').strip()
        if nm not in NM2CD: continue
        cd=NM2CD[nm]
        for col,procs in SIGCOLS.items():
            v=(row.get(col,'') or '').strip()
            if v and v!='없음':  # 1줄/2줄/1개… = 신호 (없음은 신호아님)
                sig.setdefault(cd,set()).update(procs)
exp_proc_active=set(); exp_proc_def=set()
for cd,procs in sig.items():
    target = exp_proc_def if (prods[cd]['use_yn']=='N') else exp_proc_active
    if cd in CONDITIONAL: continue  # conditional은 active/def 대상 아님
    for pc in procs: target.add((cd,pc))
act_proc=set((r['prd_cd'],r['proc_cd']) for r in load_load('t_prd_product_processes.csv'))
check('R1-proc-active', exp_proc_active, act_proc)

# ---- R3 material: IMPORT ●종이 → mat_cd 집합 독립 산출 ----
IMPORT_MAP={
 '프리미엄엽서':['프리미엄엽서'],'스탠다드엽서':['스탠다드엽서'],
 '2단접지카드 / 3단접지카드 / 미니접지카드':['2단접지카드','미니접지카드','3단접지카드'],
 '프리미엄명함':['프리미엄명함'],
 '소량전단지/접지리플렛 :: 소량전단지포스터/리플렛팜플렛 :: 코팅/오시/접지':['소량전단지','접지리플렛'],
}
from collections import defaultdict
papers=defaultdict(list)
with open(os.path.join(ROOT,'06_extract','import-paper-matrix-long.csv'),encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        pc=row['product_col'].strip()
        if pc in IMPORT_MAP and row['mark'].strip()=='●':
            papers[pc].append(row['paper_name'].strip())
exp_mat=set()
for impcol,prdnames in IMPORT_MAP.items():
    for nm in prdnames:
        cd=NM2CD[nm]
        for p in papers[impcol]:
            mc=mats.get(p)
            if mc: exp_mat.add((cd,mc))
act_mat=set((r['prd_cd'],r['mat_cd']) for r in load_load('t_prd_product_materials.csv'))
check('R3-material', exp_mat, act_mat)

# ---- R6 qty_unit: 36상품 전건 QTY_UNIT.02 ----
exp_qu=set(f'PRD_0000{n:02d}' for n in range(16,52) if f'PRD_0000{n:02d}' in prods)
act_qu=set(r['prd_cd'] for r in load_load('t_prd_products_qtyunit_update.csv') if r['target_qty_unit_typ_cd']=='QTY_UNIT.02')
check('R6-qtyunit', exp_qu, act_qu)

# ---- 날조 가드: 모든 적재 prd_cd/mat_cd/proc_cd가 마스터에 실재 ----
allproc=set(r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv'))
allmat=set(mats.values())
fab=[]
for r in load_load('t_prd_product_processes.csv'):
    if r['proc_cd'] not in allproc: fab.append(('proc',r['proc_cd']))
    if r['prd_cd'] not in prods: fab.append(('prd',r['prd_cd']))
for r in load_load('t_prd_product_materials.csv'):
    if r['mat_cd'] not in allmat: fab.append(('mat',r['mat_cd']))
results.append(('FK-existence', '-', '-', '-', len(fab), not fab))
if fab: print("  [FK] FABRICATED refs:", fab[:8])

# ---- 출력 ----
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':22s} {'exp':>5s} {'act':>5s} {'miss':>5s} {'extra':>6s}  result")
allok=True
for lbl,e,a,m,x,ok in results:
    allok &= ok
    print(f"{lbl:22s} {str(e):>5s} {str(a):>5s} {str(m):>5s} {str(x):>6s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
