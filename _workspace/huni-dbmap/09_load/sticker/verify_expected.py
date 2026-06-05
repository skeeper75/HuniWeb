#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적재 CSV 자기검증 게이트 (sticker) — L1+ref에서 기대행을 독립 재생성해 load CSV와 대조.
   누락0 / 날조0 입증. count → set → FK실재 3단 대조.
   --sheet 파라미터화 정신: SHEET 상수 + NM2CD + WHITE_SIGCOL + 비활성/마스터부재 룰만 시트별 교체.
   sticker 특화: (1) 화이트별색=별색인쇄(옵션)_화이트 신호→자식 PROC_000008 (부모007 미적재 R-PROC-4)
                 (2) use_yn=N(063·064) active 제외→deferred (3) 066 원형11종 master부재→BLOCKED(적재 대상 아님)
                 (4) 빈 가변/코팅/addon 컬럼은 신호0→기대행 미생성(false MISSING 차단)
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
BASE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(BASE,'..','..'))
LOAD=os.path.join(BASE,'load')
SHEET='sticker'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 매핑만 교체

def load_csv(p):
    with open(os.path.join(ROOT,p),encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
def load_load(name):
    with open(os.path.join(LOAD,name),encoding='utf-8') as f:
        return list(csv.DictReader(f))

prods={r['prd_cd']:r for r in load_csv('00_schema/ref-products.csv')}
# sticker 상품명 → prd_cd (라이브 매칭 권위, remediation ①표)
NM2CD={
 '반칼 자유형 스티커':'PRD_000052','반칼 자유형 투명스티커':'PRD_000053',
 '반칼 자유형 홀로그램스티커':'PRD_000054','낱장 자유형 스티커':'PRD_000055',
 '낱장 자유형 투명스티커':'PRD_000056','대형 자유형 스티커':'PRD_000057',
 '반칼원형스티커':'PRD_000058','반칼정사각스티커':'PRD_000059','반칼직사각스티커':'PRD_000060',
 '반칼띠지스티커':'PRD_000061','반칼팬시스티커':'PRD_000062','반칼팬시투명스티커':'PRD_000063',
 '소량자유형스티커':'PRD_000064','스티커팩':'PRD_000065','합판도무송스티커':'PRD_000066',
 '타투스티커':'PRD_000067'}
CD2NM={v:k for k,v in NM2CD.items()}
WHITE_SIGCOL='별색인쇄(옵션)_화이트'   # 값이 '화이트인쇄(단면)' 등 신호 → 자식 PROC_000008
WHITE_PROC='PROC_000008'             # 자식 leaf(부모 007 미적재 R-PROC-4)

results=[]
def check(label, expected:set, actual:set):
    miss=expected-actual; extra=actual-expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss: print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra: print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok

# ---- R1 화이트별색: L1 _화이트 신호 보유 상품 → (prd_cd, PROC_000008) 독립 산출 ----
# 신호 규칙: 화이트 컬럼 값이 '없음' 아닌 비공백 = 화이트별색 공정 존재. use_yn=N은 active제외(deferred).
exp_white_active=set(); exp_white_def=set()
with open(os.path.join(ROOT,'06_extract','sticker-l1.csv'),encoding='utf-8-sig') as f:
    seen=set()
    for row in csv.DictReader(f):
        nm=(row.get('prd_nm','') or '').strip()
        if nm not in NM2CD: continue
        cd=NM2CD[nm]
        v=(row.get(WHITE_SIGCOL,'') or '').strip()
        if v and v!='없음' and '없음' not in v:  # '화이트인쇄(단면)' = 신호 / '화이트인쇄(없음)' 제외
            key=(cd,WHITE_PROC)
            if cd in seen: continue
            seen.add(cd)
            if prods[cd]['use_yn']=='N': exp_white_def.add(key)
            else: exp_white_active.add(key)
act_white=set((r['prd_cd'],r['proc_cd']) for r in load_load('t_prd_product_processes.csv'))
check('R1-whitespot-active', exp_white_active, act_white)

# ---- R6 qty_unit: 16 sticker 상품 전건 QTY_UNIT.02 ----
exp_qu=set(NM2CD.values())
act_qu=set(r['prd_cd'] for r in load_load('t_prd_products_qtyunit_update.csv') if r['target_qty_unit_typ_cd']=='QTY_UNIT.02')
check('R6-qtyunit', exp_qu, act_qu)

# ---- 비활성 분리 가드: deferred CSV의 prd_cd 전부 use_yn=N 이어야 함 ----
def_rows=[]
dpath=os.path.join(BASE,'_deferred','t_prd_product_processes_deferred.csv')
if os.path.exists(dpath):
    with open(dpath,encoding='utf-8') as f: def_rows=list(csv.DictReader(f))
bad_def=[r['prd_cd'] for r in def_rows if prods.get(r['prd_cd'],{}).get('use_yn')!='N']
results.append(('deferred=use_yn:N', len(def_rows), len(def_rows), len(bad_def), 0, not bad_def))
if bad_def: print("  [deferred] active 상품이 deferred에 잘못 분류:", bad_def)
# deferred 기대 = exp_white_def 와 일치
act_def=set((r['prd_cd'],r['proc_cd']) for r in def_rows)
check('R1-whitespot-deferred', exp_white_def, act_def)

# ---- 날조 가드: active 적재의 모든 prd_cd/proc_cd가 마스터에 실재 + active에 use_yn=N 없음 ----
allproc=set(r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv'))
fab=[]
for r in load_load('t_prd_product_processes.csv'):
    if r['proc_cd'] not in allproc: fab.append(('proc',r['proc_cd']))
    if r['prd_cd'] not in prods: fab.append(('prd',r['prd_cd']))
    if prods.get(r['prd_cd'],{}).get('use_yn')=='N': fab.append(('inactive-in-active',r['prd_cd']))
results.append(('FK+active-guard', '-', '-', '-', len(fab), not fab))
if fab: print("  [FK] FABRICATED/inactive refs:", fab[:8])

# ---- BLOCKED 가드: 066 원형 size는 master 부재라 load/ 에 없어야 함(적재 대상 아님) ----
sizefiles=[fn for fn in os.listdir(LOAD) if 'size' in fn.lower()]
results.append(('R2-size-blocked(no-load)', 0, len(sizefiles), 0, len(sizefiles), not sizefiles))
if sizefiles: print("  [R2] 원형 size가 load/에 잘못 존재(마스터 mint 선행 필요, BLOCKED여야):", sizefiles)

# ---- 출력 ----
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':26s} {'exp':>5s} {'act':>5s} {'miss':>5s} {'extra':>6s}  result")
allok=True
for lbl,e,a,m,x,ok in results:
    allok &= ok
    print(f"{lbl:26s} {str(e):>5s} {str(a):>5s} {str(m):>5s} {str(x):>6s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0·비활성분리·마스터부재차단' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
