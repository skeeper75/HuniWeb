#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""calendar + design-calendar 적재 CSV 자기검증 게이트 — L1+ref+IMPORT에서 기대행을 독립 재생성해 대조.
   누락0 / 날조0 입증. count → set → FK 실재 3단 대조. + design-calendar 신규행=0 가드.
   --sheet 파라미터화 정신: SHEET 상수 + NM2CD/IMPORT_MAP/EXCL_LINK/EDITOR 4맵만 교체하면 타시트 확장.
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
from collections import defaultdict
BASE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(BASE,'..','..'))
LOAD=os.path.join(BASE,'load')
SHEET='calendar+design-calendar'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 4맵만 교체

def load_csv(p):
    with open(os.path.join(ROOT,p),encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
def load_load(name):
    with open(os.path.join(LOAD,name),encoding='utf-8') as f:
        return list(csv.DictReader(f))

mats={r['mat_nm'].strip():r['mat_cd'] for r in load_csv('00_schema/ref-materials.csv')}
prods={r['prd_cd']:r for r in load_csv('00_schema/ref-products.csv')}
# ---- 4 시트별 매핑 ----
NM2CD={'탁상형캘린더':'PRD_000108','미니탁상형캘린더':'PRD_000109','엽서캘린더':'PRD_000110',
       '벽걸이캘린더':'PRD_000111','와이드벽걸이캘린더':'PRD_000112'}
ALL_CAL=set(NM2CD.values())
IMPORT_MAP={'탁상형캘린더':'PRD_000108','미니탁상형캘린더':'PRD_000109',
            '엽서캘린더':'PRD_000110','벽걸이캘린더':'PRD_000111'}  # 112=직접명(기적재) 제외
# 택일그룹 멤버 연결 기대 (라이브 기적재 process 중 멤버) — calendar.md ③
EXCL_LINK_EXP={('PRD_000110','PROC_000079'),('PRD_000111','PROC_000021'),
               ('PRD_000111','PROC_000079'),('PRD_000112','PROC_000021')}

# 기적재 자재 (중복 PK 회피 — 적재 기대에서 제외)
existing_mat=defaultdict(set)
for r in load_csv('00_schema/ref-product-materials.csv'):
    if r['prd_cd'] in ALL_CAL: existing_mat[r['prd_cd']].add(r['mat_cd'])
# 라이브 확인 충돌(2026-06-05 dbm-validator SELECT): MAT_000107(몽블랑190g)이 108/109/110/111에 라이브 기적재.
# stale ref엔 미적재라 existing_mat에서 누락 → 적재 기대에서 명시 제외해 중복PK INSERT 차단(conditional 이동).
# @MX:NOTE: 적재 직전 라이브-export 재실행 시 existing_mat에 자동 반영되면 본 보정 라인은 중복(무해)·제거 가능.
LIVE_COLLISION_MAT={('PRD_000108','MAT_000107'),('PRD_000109','MAT_000107'),
                    ('PRD_000110','MAT_000107'),('PRD_000111','MAT_000107')}
for pc,mc in LIVE_COLLISION_MAT: existing_mat[pc].add(mc)
existing_excl_hdr={r['prd_cd'] for r in load_csv('00_schema/ref-product-process-excl-groups.csv')
                   if r['prd_cd'] in ALL_CAL}
existing_proc=defaultdict(set)
for r in load_csv('00_schema/ref-product-processes.csv'):
    if r['prd_cd'] in ALL_CAL: existing_proc[r['prd_cd']].add(r['proc_cd'])

results=[]
def check(label, expected:set, actual:set):
    miss=expected-actual; extra=actual-expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss: print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra: print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok

# ---- R3 material: IMPORT ●종이 → mat_cd 집합 독립 산출 (기적재 제외) ----
papers=defaultdict(list)
with open(os.path.join(ROOT,'06_extract/import-paper-matrix-long.csv'),encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        pc=row['product_col'].strip()
        if pc in IMPORT_MAP and row['mark'].strip()=='●':
            papers[pc].append(row['paper_name'].strip())
exp_mat=set()
for impcol,cd in IMPORT_MAP.items():
    for p in papers[impcol]:
        mc=mats.get(p)
        if mc and mc not in existing_mat[cd]:  # 기적재는 적재 기대 아님
            exp_mat.add((cd,mc))
act_mat=set((r['prd_cd'],r['mat_cd']) for r in load_load('t_prd_product_materials.csv'))
check('R3-material(IMPORT)', exp_mat, act_mat)

# ---- R1 process excl_grp_cd LINK: 기적재 멤버 process를 GRP-CAL-가공 연결 (UPDATE set) ----
# 기대 = EXCL_LINK_EXP 중 (헤더 적재 & 멤버 기적재)인 것만
exp_link=set((cd,pc) for cd,pc in EXCL_LINK_EXP if cd in existing_excl_hdr and pc in existing_proc[cd])
act_link=set((r['prd_cd'],r['proc_cd']) for r in load_load('t_prd_product_processes_excl_link_update.csv')
             if r['target_excl_grp_cd']=='GRP-CAL-가공')
check('R1-excl_link(UPDATE)', exp_link, act_link)

# ---- R6 qty_unit: 5상품 전건 QTY_UNIT.01(EA) ----
exp_qu=set(ALL_CAL)
act_qu=set(r['prd_cd'] for r in load_load('t_prd_products_qtyunit_update.csv') if r['target_qty_unit_typ_cd']=='QTY_UNIT.01')
check('R6-qtyunit(EA)', exp_qu, act_qu)

# ---- C-5 editor_yn 게이트 철회 (2026-06-05): design-calendar는 108~112 공유 variant가 아니라
#      신규 별도 prd_cd 등록 대상(라이브 113~117 부재·캘린더 108~112=업로드전용 editor_yn=N 정상).
#      108~112 editor_yn=Y UPDATE는 _deferred/t_prd_products_editor_yn_update_WITHDRAWN.csv로 철회 이력 보존.
#      디자인캘린더 신규 등록 검증은 09_load/design-calendar/verify_design_calendar.py(별도 설계)가 담당.
#      본 calendar 게이트는 일반 업로드 캘린더(108~112) 적재만 검증.

# ---- design-calendar 신규행=0 가드 (qtyunit UPDATE prd_cd ⊆ 108~112) ----
newrow=[]
for name in ('t_prd_products_qtyunit_update.csv',):  # editor_yn UPDATE 철회로 제외
    for r in load_load(name):
        if r['prd_cd'] not in ALL_CAL: newrow.append((name,r['prd_cd']))
# material/link도 캘린더 외 prd_cd면 신규/오염
for r in load_load('t_prd_product_materials.csv'):
    if r['prd_cd'] not in ALL_CAL: newrow.append(('material',r['prd_cd']))
results.append(('design-cal-신규행0', 0, '-', '-', len(newrow), not newrow))
if newrow: print("  [신규행0] VIOLATION(캘린더 외 prd_cd):", newrow[:8])

# ---- 날조 가드: 적재 prd_cd/mat_cd/proc_cd가 마스터에 실재 ----
allmat=set(mats.values()); allproc=set(r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv'))
fab=[]
for r in load_load('t_prd_product_materials.csv'):
    if r['prd_cd'] not in prods: fab.append(('prd',r['prd_cd']))
    if r['mat_cd'] not in allmat: fab.append(('mat',r['mat_cd']))
for r in load_load('t_prd_product_processes_excl_link_update.csv'):
    if r['proc_cd'] not in allproc: fab.append(('proc',r['proc_cd']))
results.append(('FK-existence', '-', '-', '-', len(fab), not fab))
if fab: print("  [FK] FABRICATED refs:", fab[:8])

# ---- 출력 ----
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':24s} {'exp':>5s} {'act':>5s} {'miss':>5s} {'extra':>6s}  result")
allok=True
for lbl,e,a,m,x,ok in results:
    allok &= ok
    print(f"{lbl:24s} {str(e):>5s} {str(a):>5s} {str(m):>5s} {str(x):>6s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0·신규행0' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
