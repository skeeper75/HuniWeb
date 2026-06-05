#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적재 CSV 자기검증 게이트 (silsa) — L1+ref에서 기대행을 독립 재생성해 load CSV와 대조.
   누락0 / 날조0 / 모범(봉제·타공·족자·부착·코팅) 재적재0 입증. count → set → FK 3단 대조.
   --sheet 파라미터화 정신: SHEET 상수 + NM2CD/WSC_MAP/NONSPEC_MAP/QU_MAP 4개 매핑만 시트별 교체.
   digital-print verify_expected.py를 silsa 게이트맵으로 교체(권위반전: 봉제/타공/족자 모범=재적재 금지 가드 추가).
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
BASE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(BASE,'..','..'))
LOAD=os.path.join(BASE,'load')
SHEET='silsa'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 매핑만 교체

def load_csv(p):
    with open(os.path.join(ROOT,p),encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
def load_load(name):
    with open(os.path.join(LOAD,name),encoding='utf-8') as f:
        return list(csv.DictReader(f))

prods={r['prd_cd']:r for r in load_csv('00_schema/ref-products.csv')}
allproc=set(r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv'))

# 상품명→prd_cd (silsa 28등록, ★투명포스터 미등록 제외)
NM2CD={'아트프린트포스터':'PRD_000118','아트페이퍼포스터':'PRD_000119','방수포스터':'PRD_000120',
 '접착방수포스터':'PRD_000121','접착투명포스터':'PRD_000122','아트패브릭포스터':'PRD_000123',
 '린넨패브릭포스터':'PRD_000124','캔버스패브릭포스터':'PRD_000125','레더아트프린트':'PRD_000126',
 '타이벡프린트':'PRD_000127','메쉬프린트':'PRD_000128','폼보드':'PRD_000129','포맥스보드':'PRD_000130',
 '프레임리스우드액자':'PRD_000131','레더아트액자':'PRD_000132','캔버스 행잉포스터':'PRD_000133',
 '린넨 우드봉 족자':'PRD_000134','족자포스터':'PRD_000135','PET배너':'PRD_000136','메쉬배너':'PRD_000137',
 '일반현수막':'PRD_000138','메쉬현수막':'PRD_000139','무광시트커팅':'PRD_000140','홀로그램 시트커팅':'PRD_000141',
 '유광아크릴스티커':'PRD_000142','미러아크릴스티커':'PRD_000143','미니보드스탠딩':'PRD_000144','미니배너':'PRD_000145'}

# 화이트별색(옵션) 신호컬럼 → proc_cd (값≠없음 → 공정 존재)
WSC_COL='화이트별색(옵션)'; WSC_PROC='PROC_000008'
# nonspec: 비규격 가로/세로 둘 다 있고 nonspec_yn=Y면 active UPDATE 대상
NONSPEC_W='비규격(최소/최대)_가로'; NONSPEC_H='비규격(최소/최대)_세로'
# 모범 재적재 금지 가드 — 봉제/타공/족자/부착/코팅(라이브 기적재 정상)
MOBEUM_PROCS={'PROC_000079','PROC_000080','PROC_000081','PROC_000082',
              'PROC_000014','PROC_000015','PROC_000016','PROC_000053','PROC_000054'}

l1=[]
with open(os.path.join(ROOT,'06_extract','silsa-l1.csv'),encoding='utf-8-sig') as f:
    l1=list(csv.DictReader(f))

results=[]
def check(label, expected:set, actual:set):
    miss=expected-actual; extra=actual-expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss: print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra: print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok

# ---- R2 화이트별색 process: L1 신호에서 기대 (prd_cd,PROC_000008) 독립 산출 ----
exp_proc=set()
for row in l1:
    nm=row.get('prd_nm','').strip()
    if nm not in NM2CD: continue
    if row['_row_hidden']=='true': continue  # 숨김=비활성
    v=(row.get(WSC_COL,'') or '').strip()
    if v and v!='없음':
        exp_proc.add((NM2CD[nm],WSC_PROC))
act_proc=set((r['prd_cd'],r['proc_cd']) for r in load_load('t_prd_product_processes.csv'))
check('R2-white-spot', exp_proc, act_proc)

# ---- 모범 재적재 금지 가드: load CSV에 봉제/타공/족자/부착/코팅 proc 0건이어야 함 ----
mobeum_in_load=set(r['proc_cd'] for r in load_load('t_prd_product_processes.csv')
                   if r['proc_cd'] in MOBEUM_PROCS)
results.append(('mobeum-no-reload', 0, len(mobeum_in_load), '-', len(mobeum_in_load), not mobeum_in_load))
if mobeum_in_load: print("  [mobeum-no-reload] 모범 공정 재적재 위반:", sorted(mobeum_in_load))

# ---- R4 nonspec: 비규격 가로/세로 보유 + nonspec_yn=Y + 숨김아님 → active UPDATE 기대 ----
exp_ns=set()
for row in l1:
    nm=row.get('prd_nm','').strip()
    if nm not in NM2CD: continue
    cd=NM2CD[nm]
    if row['_row_hidden']=='true': continue       # 폼보드 사용자입력 숨김 → 제외
    if prods.get(cd,{}).get('nonspec_yn')!='Y': continue  # nonspec_yn=N(폼보드) → 제외
    ga=(row.get(NONSPEC_W,'') or '').strip(); se=(row.get(NONSPEC_H,'') or '').strip()
    if ga and se:
        exp_ns.add(cd)
act_ns=set(r['prd_cd'] for r in load_load('t_prd_products_nonspec_update.csv'))
check('R4-nonspec', exp_ns, act_ns)

# ---- R6 qty_unit: silsa 28등록 전건 QTY_UNIT.01 ----
exp_qu=set(f'PRD_000{n}' for n in range(118,146) if f'PRD_000{n}' in prods)
act_qu=set(r['prd_cd'] for r in load_load('t_prd_products_qtyunit_update.csv') if r['target_qty_unit_typ_cd']=='QTY_UNIT.01')
check('R6-qtyunit', exp_qu, act_qu)

# ---- R3 addon: L1 천정형고리(족자포스터) → (135,PRD_000008). 배너거치대/큐방/끈=flag(_deferred, active 제외) ----
exp_addon={('PRD_000135','PRD_000008')}
act_addon=set((r['prd_cd'],r['addon_prd_cd']) for r in load_load('t_prd_product_addons.csv'))
check('R3-addon', exp_addon, act_addon)

# ---- 날조 가드: 적재 prd_cd/proc_cd/addon_prd_cd가 마스터에 실재 ----
fab=[]
for r in load_load('t_prd_product_processes.csv'):
    if r['proc_cd'] not in allproc: fab.append(('proc',r['proc_cd']))
    if r['prd_cd'] not in prods: fab.append(('prd',r['prd_cd']))
for r in load_load('t_prd_product_addons.csv'):
    if r['addon_prd_cd'] not in prods: fab.append(('addon',r['addon_prd_cd']))
    if r['prd_cd'] not in prods: fab.append(('prd',r['prd_cd']))
for r in load_load('t_prd_products_nonspec_update.csv'):
    if r['prd_cd'] not in prods: fab.append(('prd',r['prd_cd']))
results.append(('FK-existence', '-', '-', '-', len(fab), not fab))
if fab: print("  [FK] FABRICATED refs:", fab[:8])

# ---- nonspec numeric(8,2) 범위 가드: 8자리 정밀·2소수 초과 0 ----
rng_viol=[]
for r in load_load('t_prd_products_nonspec_update.csv'):
    for c in ('nonspec_width_min','nonspec_width_max','nonspec_height_min','nonspec_height_max'):
        try:
            v=float(r[c])
            if v>=10**6: rng_viol.append((r['prd_cd'],c,r[c]))  # numeric(8,2) 정수부 6자리 한계
        except ValueError:
            rng_viol.append((r['prd_cd'],c,r[c]))
results.append(('nonspec-numeric(8,2)', '-', '-', '-', len(rng_viol), not rng_viol))
if rng_viol: print("  [nonspec] numeric(8,2) 초과:", rng_viol[:8])

# ---- 출력 ----
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':22s} {'exp':>5s} {'act':>5s} {'miss':>5s} {'extra':>6s}  result")
allok=True
for lbl,e,a,m,x,ok in results:
    allok &= ok
    print(f"{lbl:22s} {str(e):>5s} {str(a):>5s} {str(m):>5s} {str(x):>6s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0·모범재적재0' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
