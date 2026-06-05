#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""digital-print 적재 CSV 생성기 (round-3 remediation 파일럿).
모든 행은 L1 셀 또는 ref/IMPORT 라인에 추적된다(추정 0). DB 쓰기 없음 — CSV 산출만."""
import csv, os
BASE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(BASE,'..','..'))
LOAD=os.path.join(BASE,'load'); DEF=os.path.join(BASE,'_deferred')
os.makedirs(LOAD,exist_ok=True); os.makedirs(DEF,exist_ok=True)
REGDT='2026-06-05 00:00:00'  # 적재 예정 reg_dt(설계값, FK 무관)

# ---- 마스터 사전 로드 ----
def load_csv(p):
    with open(os.path.join(ROOT,p),encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
mats={r['mat_nm'].strip():r['mat_cd'] for r in load_csv('00_schema/ref-materials.csv')}
prods={r['prd_cd']:r for r in load_csv('00_schema/ref-products.csv')}

# prd_nm -> prd_cd (digital-print)
NM2CD={
 '프리미엄엽서':'PRD_000016','스탠다드엽서':'PRD_000018','2단접지카드':'PRD_000027',
 '미니접지카드':'PRD_000028','3단접지카드':'PRD_000029','프리미엄명함':'PRD_000031',
 '스탠다드명함':'PRD_000033','형압명함':'PRD_000038',
 '스탠다드 쿠폰/상품권':'PRD_000041','프리미엄 쿠폰/상품권':'PRD_000042',
 '소량전단지':'PRD_000047','접지리플렛':'PRD_000048','와이드 접지리플렛':'PRD_000049',
}
def use_yn(cd): return prods[cd]['use_yn']

# ============ R1: process (줄수/개수 공정) ============
# L1 신호 검증 결과(앞선 추출): 오시·미싱 보유=29·30, 가변T·가변I 보유=31·32
# 줄수형(29,30,31,32): 016,018,041,042 | 개수형(31,32): 027,028,029,031,033,047,048,049
R1_OSI_MISING = ['프리미엄엽서','스탠다드엽서','스탠다드 쿠폰/상품권','프리미엄 쿠폰/상품권']  # 29,30,31,32
R1_GAESU_ONLY = ['2단접지카드','미니접지카드','3단접지카드','프리미엄명함','스탠다드명함',
                 '소량전단지','접지리플렛','와이드 접지리플렛']  # 31,32
# 016은 검증대상(수동시험 적재). ref-CSV는 016에 29/30/31/32 부재(27/28만) → R1 적재 대상에 016 포함
# (단 016 검증결과는 spec §load-spec에 별도 기록)

proc_active=[]; proc_def=[]; proc_cond=[]
# 016은 라이브(remediation §머리말)서 29/30/31/32 이미 적재됨 보고 / stale ref-CSV(2026-06-04)는 27/28만.
# 충돌 → 016 R1 행은 CONDITIONAL(라이브 재확인 후 적재여부 결정). 중복적재 방지.
CONDITIONAL_PRD={'PRD_000016'}

def add_proc(nm, procs, prov):
    cd=NM2CD[nm]; active = use_yn(cd)=='Y'
    seq=10  # 줄수/개수 후가공 disp_seq 시작(직각27/둥근28 이후)
    for i,pc in enumerate(procs):
        row=[cd, pc, '', 'N', seq+i, REGDT, '', prov]
        if cd in CONDITIONAL_PRD:
            proc_cond.append((row, '016=수동시험 적재(stale ref=27/28만, 라이브=29~32 보고). 라이브 재확인 후 적재여부 결정'))
        elif active:
            proc_active.append((row, ''))
        else:
            proc_def.append((row, 'use_yn=N 미출시'))

for nm in R1_OSI_MISING:
    add_proc(nm,['PROC_000029','PROC_000030','PROC_000031','PROC_000032'],
             f'L1:{nm} 오시/미싱(없음|1~3줄)+가변T/가변I(없음|1~3개) → 29오시·30미싱·31가변텍스트·32가변이미지 (R1)')
for nm in R1_GAESU_ONLY:
    add_proc(nm,['PROC_000031','PROC_000032'],
             f'L1:{nm} 가변T/가변I(없음|1~3개) 보유·오시/미싱 부재 → 31가변텍스트·32가변이미지 (R1)')

# R2: 형압명함 051/052 (DEFERRED — use_yn=N + 미출시)
add_proc_def_038 = []
cd038=NM2CD['형압명함']
for i,pc in enumerate(['PROC_000051','PROC_000052']):
    proc_def.append(([cd038, pc, '', 'N', 1+i, REGDT, '',
        f'L1:형압명함 박/형압 가공=형압(양각)|형압(음각) → 051양각·052음각 (R2, prcs_dtl_opt.크기 mm는 마스터 보유)'],
        'use_yn=N 미출시 + R2 Low(출시 시 적재)'))

# write process active
PROC_HDR=['prd_cd','proc_cd','excl_grp_cd','mand_proc_yn','disp_seq','reg_dt','upd_dt','_provenance']
with open(os.path.join(LOAD,'t_prd_product_processes.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(PROC_HDR)
    for row,_ in proc_active: w.writerow(row)
with open(os.path.join(DEF,'t_prd_product_processes_deferred.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(PROC_HDR+['_deferred_reason'])
    for row,rsn in proc_def: w.writerow(row+[rsn])
# 016 conditional (라이브 충돌 — 적재 보류, 별도 파일)
with open(os.path.join(BASE,'t_prd_product_processes_conditional.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(PROC_HDR+['_conditional_reason'])
    for row,rsn in proc_cond: w.writerow(row+[rsn])

# ============ R3: material (IMPORT 종이) ============
# IMPORT 컬럼 → 상품 매핑(seoljeong-import-map + import-resolution-resolved)
IMPORT_MAP={
 '프리미엄엽서':['프리미엄엽서'],
 '스탠다드엽서':['스탠다드엽서'],
 '2단접지카드 / 3단접지카드 / 미니접지카드':['2단접지카드','미니접지카드','3단접지카드'],
 '프리미엄명함':['프리미엄명함'],
 '소량전단지/접지리플렛 :: 소량전단지포스터/리플렛팜플렛 :: 코팅/오시/접지':['소량전단지','접지리플렛'],
}
from collections import defaultdict
papers=defaultdict(list)
with open(os.path.join(ROOT,'06_extract/import-paper-matrix-long.csv'),encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        pc=row['product_col'].strip()
        if pc in IMPORT_MAP and row['mark'].strip()=='●':
            papers[pc].append(row['paper_name'].strip())

MAT_HDR=['prd_cd','mat_cd','usage_cd','dep_proc_cd','dflt_yn','disp_seq','reg_dt','upd_dt','_provenance']
mat_rows=[]; mat_unmatched=[]
for impcol, prdnames in IMPORT_MAP.items():
    plist=papers[impcol]
    for nm in prdnames:
        cd=NM2CD[nm]
        seq=1
        for pname in plist:
            mc=mats.get(pname)
            if not mc:
                mat_unmatched.append((nm,pname)); continue
            dflt='Y' if seq==1 else 'N'
            mat_rows.append([cd, mc, 'USAGE.07','', dflt, seq, REGDT,'',
                f'IMPORT:{impcol[:20]}● {pname}→{mc} (R3, seoljeong-import-map)'])
            seq+=1
with open(os.path.join(LOAD,'t_prd_product_materials.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(MAT_HDR)
    for r in mat_rows: w.writerow(r)

# ============ R4: addon (누락 봉투) ============
# 봉투명 → addon_prd_cd (master 봉투 5종: 001 OPP접착,002 OPP비접착,003 트래싱지카드봉투,004 카드봉투,005 캘린더봉투)
# 016 기적재: 001,002,004. 018 기적재 확인 필요.
ADDON_MATCH={  # L1 봉투 표기 → master addon_prd_cd (brittle, flag)
 'OPP접착봉투':('PRD_000001','정확'),
 'OPP비접착봉투':('PRD_000002','정확'),
 '카드봉투(블랙)':('PRD_000004','색상자식→카드봉투 통합'),
 '카드봉투(화이트)':('PRD_000004','색상자식→카드봉투 통합'),
 '트레싱지봉투':('PRD_000003','표기차 트래싱지 카드봉투'),
 '엽서봉투':(None,'master 미존재 — 신규등록 또는 매칭 컨펌 필요'),
}
# 기적재 addon 라이브(stale ref) 로드 — prd별 (prd_cd,addon_prd_cd) 기적재 집합 → 중복(PK) 금지
existing_addon={}
for r in load_csv('00_schema/ref-product-addons.csv'):
    existing_addon.setdefault(r['prd_cd'],set()).add(r['addon_prd_cd'])
ADDON_HDR=['prd_cd','addon_prd_cd','disp_seq','note','reg_dt','upd_dt','_provenance']
addon_rows=[]; addon_flag=[]; addon_skipped=[]
# 엽서 봉투 6종(L1 016/018 동일 세트). 카드봉투 화/블 모두 PRD_000004(색상=비addon축) → 1링크로 통합(PK 충돌 방지)
ENVELOPES=[('엽서봉투','★사이즈선택 100x150'),('OPP비접착봉투','110x160 50장'),
           ('OPP접착봉투','110x160 50장'),('카드봉투(화이트)','165x115 50장'),
           ('카드봉투(블랙)','165x115 50장'),('트레싱지봉투','160x110 20장')]
for nm,cd in [('프리미엄엽서','PRD_000016'),('스탠다드엽서','PRD_000018')]:
    exist=existing_addon.get(cd,set())
    seen_acd=set()  # 이번 적재 내 PK 중복(카드봉투 화/블) 방지
    seq=1
    for envnm,spec in ENVELOPES:
        acd,conf=ADDON_MATCH[envnm]
        if acd is None:
            addon_flag.append((nm,cd,envnm,conf)); continue  # 매칭 미확정 — 보류(컨펌)
        if acd in exist:
            addon_skipped.append((nm,cd,acd,envnm,'기적재(라이브 중복 PK)')); continue
        if acd in seen_acd:
            addon_skipped.append((nm,cd,acd,envnm,f'동일 addon_prd_cd 색상변형 통합(PK 1행, note만 구분)')); continue
        seen_acd.add(acd)
        addon_rows.append([cd, acd, seq, f'{envnm} {spec}', REGDT,'',
            f'L1:{nm} 추가상품={envnm} → addon {acd} ({conf}) (R4)'])
        seq+=1
with open(os.path.join(LOAD,'t_prd_product_addons.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(ADDON_HDR)
    for r in addon_rows: w.writerow(r)

# ============ R6: qty_unit UPDATE set ============
# digital-print 36상품 → QTY_UNIT.02(매). UPDATE-class → 별도 update set CSV
QU_HDR=['prd_cd','prd_nm','current_qty_unit_typ_cd','target_qty_unit_typ_cd','use_yn','_provenance']
qu_rows=[]
for n in range(16,52):
    cd=f'PRD_0000{n:02d}'
    if cd in prods:
        r=prods[cd]
        qu_rows.append([cd, r['prd_nm'], r['qty_unit_typ_cd'] or 'NULL','QTY_UNIT.02', r['use_yn'],
            'C-4 상품군별 일괄(digital-print 낱장=매=QTY_UNIT.02). 라이브 현재 NULL'])
with open(os.path.join(LOAD,'t_prd_products_qtyunit_update.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(QU_HDR)
    for r in qu_rows: w.writerow(r)

# ============ 캐스케이드 제약 (benchmark §9 신설 1건) ============
# L1 코팅(옵션) 컬럼 주석: "★종이두께선택시 : 180g이상 코팅가능" = 자재(종이두께)→공정(코팅) disable
# constraint_json은 digital-print 전상품 NULL(약한 제약 테이블). shape 제안 + 실예 1행.
CC_HDR=['scope','prd_cd','constraint_type','trigger_axis','trigger_cond','target_axis','target_action','target_value','_provenance']
cc_rows=[
 ['digital-print','PRD_ALL_DP','material_thickness->process_disable','material(종이 평량 g)','평량 < 180g',
  'process(코팅 PROC_000014~016)','disable','코팅 비활성(180g 미만)',
  'L1:digital-print 코팅(옵션) 셀 주석 "★종이두께선택시 : 180g이상 코팅가능" (benchmark §9 캐스케이드 제약 신설)'],
]
with open(os.path.join(BASE,'cascade-constraints.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(CC_HDR)
    for r in cc_rows: w.writerow(r)

# ---- 리포트 ----
from collections import Counter
print("=== R1 process ACTIVE rows:", len(proc_active))
print("=== R1 process CONDITIONAL rows (016):", len(proc_cond))
print("=== R1/R2 process DEFERRED rows:", len(proc_def))
print("=== R3 material rows:", len(mat_rows), "| unmatched papers:", len(mat_unmatched))
for u in mat_unmatched: print("    MAT UNMATCHED:", u)
print("=== R4 addon rows:", len(addon_rows), "| flagged(미매칭):", len(addon_flag), "| skipped(기적재/통합):", len(addon_skipped))
for a in addon_flag: print("    ADDON FLAG:", a)
for s in addon_skipped: print("    ADDON SKIP:", s)
print("=== R6 qty_unit update rows:", len(qu_rows))
print("=== cascade-constraints rows:", len(cc_rows))
print("    proc ACTIVE per prd:", dict(Counter(r[0] for r,_ in proc_active)))
print("    proc DEFERRED per prd:", dict(Counter(r[0] for r,_ in proc_def)))
