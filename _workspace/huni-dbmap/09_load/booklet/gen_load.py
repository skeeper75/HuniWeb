#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""booklet 적재 CSV 생성기 (재현 가능) — round-3 remediation 전수 확장.
   L1 엑셀 + ref 마스터 + IMPORT 매트릭스에서 적재행을 결정적으로 산출한다.
   추정 0 — 모든 행에 _provenance 컬럼(L1 셀 또는 ref/IMPORT 라인 추적).
   DB 쓰기 절대 없음 — CSV 산출만.
   생성 대상:
     load/t_prd_product_materials.csv   (R1 내지/표지 IMPORT 종이, active 83행)
     load/t_prd_product_processes.csv   (R2 형압 자식, active 4행)
     _deferred/t_prd_product_materials_deferred.csv  (PUR/하드커버/바인더 내지 미해소 — B1 잔여 flag)
     page-rule-noise-flag.csv           (R4 떡메모지 page_rule 잡음 — 삭제 단정 금지, flag만)
     t_prd_products_qtyunit_update.csv  (R6 qty_unit=권 UPDATE, 11 parent)
   사용: python3 gen_load.py
"""
import csv, os
from collections import defaultdict

BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
DEFER = os.path.join(BASE, '_deferred')
os.makedirs(LOAD, exist_ok=True)
os.makedirs(DEFER, exist_ok=True)


def rd(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


# ---- 마스터 로드 ----
mats = {r['mat_nm'].strip(): r['mat_cd'] for r in rd('00_schema/ref-materials.csv')}
prods = {r['prd_cd']: r for r in rd('00_schema/ref-products.csv')}

# ---- 상품명 → prd_cd (booklet 11 parent) ----
NM2CD = {
    '중철책자': 'PRD_000068', '무선책자': 'PRD_000069', 'PUR책자': 'PRD_000070',
    '트윈링책자': 'PRD_000071', '하드커버책자': 'PRD_000072', '레더 하드커버책자': 'PRD_000077',
    '하드커버 링책자': 'PRD_000082', '레더 링바인더': 'PRD_000088', '엽서북': 'PRD_000094',
    '떡메모지': 'PRD_000097', '포토북 [디자인명]': 'PRD_000100',
}

# ---- IMPORT 컬럼 → (prd_cd, usage_cd) : seoljeong-import-map + import-resolution-resolved 권위 ----
# booklet 내지=USAGE.01, 표지=USAGE.02. 해소 확정 3상품(068/069/071)만 active.
IMPORT_SLOT = {
    '중철내지':                  ('PRD_000068', 'USAGE.01'),
    '중철표지':                  ('PRD_000068', 'USAGE.02'),
    '무선내지':                  ('PRD_000069', 'USAGE.01'),
    '무선표지 :: 코팅/오시':       ('PRD_000069', 'USAGE.02'),
    '트윈링내지':                ('PRD_000071', 'USAGE.01'),
    '트윈링표지 :: 코팅/오시':     ('PRD_000071', 'USAGE.02'),
}

# IMPORT ● 종이 집계
papers = defaultdict(list)
for r in rd('06_extract/import-paper-matrix-long.csv'):
    pc = r['product_col'].strip()
    if pc in IMPORT_SLOT and r['mark'].strip() == '●':
        papers[pc].append(r['paper_name'].strip())

# ====================================================================
# R1 — 내지/표지 종이 자재 (t_prd_product_materials, active)
# ====================================================================
MAT_HEADER = ['prd_cd', 'mat_cd', 'usage_cd', 'dep_proc_cd', 'dflt_yn', 'disp_seq',
              'reg_dt', 'upd_dt', '_provenance']
mat_rows = []
# (prd_cd, usage_cd)별 disp_seq 누적 + 첫행 dflt_yn=Y
seq_ctr = defaultdict(int)
for impcol, (prd_cd, usage_cd) in IMPORT_SLOT.items():
    for paper in papers[impcol]:
        mc = mats.get(paper)
        if not mc:
            continue  # 매칭 실패는 적재 안 함(추정 금지) — verify가 누락 검출
        seq_ctr[(prd_cd, usage_cd)] += 1
        seq = seq_ctr[(prd_cd, usage_cd)]
        dflt = 'Y' if seq == 1 else 'N'
        slot = '내지' if usage_cd == 'USAGE.01' else '표지'
        prov = f'IMPORT:{impcol}● {paper}→{mc} (R1 G-BK-1/2 {slot} usage_cd={usage_cd}, seoljeong-import-map)'
        mat_rows.append([prd_cd, mc, usage_cd, '', dflt, seq, '', '', prov])

with open(os.path.join(LOAD, 't_prd_product_materials.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(MAT_HEADER)
    w.writerows(mat_rows)

# ====================================================================
# R2 — 형압 자식 공정 (t_prd_product_processes, active)
#   L1 무선책자(069)·PUR책자(070) 박/형압가공 = 형압(양각)/형압(음각) → PROC_000051/052
#   크기 param(★30x30~170x170)은 마스터(prcs_dtl_opt) 상속 — 연결행은 proc_cd FK만 적재
# ====================================================================
PROC_HEADER = ['prd_cd', 'proc_cd', 'excl_grp_cd', 'mand_proc_yn', 'disp_seq',
               'reg_dt', 'upd_dt', '_provenance']
# L1 신호 재판독: 박/형압가공 컬럼에서 형압(양각)/형압(음각) 신호가 있는 상품
COL_GAGONG = '박(표지) / 형압 (옵션)_박/형압가공'
emboss_sig = defaultdict(set)  # prd_cd -> set(proc_cd)
for r in rd('06_extract/booklet-l1.csv'):
    nm = (r.get('prd_nm') or '').strip()
    if nm not in NM2CD:
        continue
    cd = NM2CD[nm]
    g = (r.get(COL_GAGONG) or '').strip()
    if '형압(양각)' in g:
        emboss_sig[cd].add('PROC_000051')
    if '형압(음각)' in g:
        emboss_sig[cd].add('PROC_000052')

# 마스터 형압 자식 param(크기) 보유 확인용
proc_master = {r['proc_cd']: r for r in rd('00_schema/ref-processes.csv')}
PROC_NM = {'PROC_000051': '형압(양각)', 'PROC_000052': '형압(음각)'}
# 기존 적재 공정(중복 PK 회피)
existing_proc = set()
for r in rd('00_schema/ref-product-processes.csv'):
    existing_proc.add((r['prd_cd'], r['proc_cd']))

proc_rows = []
# disp_seq: 기존 박색상 자식(037~044) 이후. 박색상 max disp 미상 → 형압은 50대 부여(시각 분리)
for cd in sorted(emboss_sig):
    seq = 50
    for pc in sorted(emboss_sig[cd]):
        seq += 1
        if (cd, pc) in existing_proc:
            continue  # 이미 적재(중복PK) — skip (stale 기준; 라이브 재확인 권고)
        sz = proc_master[pc].get('prcs_dtl_opt', '')
        prov = (f'L1:{[k for k,v in NM2CD.items() if v==cd][0]} 박/형압가공={PROC_NM[pc]} '
                f'→ {pc}(upr=PROC_000050, 크기 param 마스터상속) (R2 G-BK-3)')
        proc_rows.append([cd, pc, '', 'N', seq, '', '', prov])

with open(os.path.join(LOAD, 't_prd_product_processes.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(PROC_HEADER)
    w.writerows(proc_rows)

# ====================================================================
# _deferred — PUR/하드커버/바인더 내지종이 미해소 (B1 잔여 = IMPORT 컬럼 부재, 추정 금지 flag)
#   엑셀 내지종이=*별도설정(070/072/077/082) 또는 빈값(088)이나 IMPORT 매트릭스에 상품컬럼 부재.
#   → 자재 소스 미확정 → 발명 금지, 보류. reason 컬럼 명기.
# ====================================================================
DEFER_MAT_HEADER = ['prd_cd', 'prd_nm', 'slot', 'usage_cd', 'l1_paper_cell',
                    'import_col_status', 'reason', '_provenance']
defer_mat = [
    ['PRD_000070', 'PUR책자', '내지', 'USAGE.01', '*별도설정', 'IMPORT 컬럼 부재',
     'B1 잔여 — PUR내지 IMPORT 상품컬럼 부재, 자재 소스 미확정. 추정 발명 금지. 컨펌 D-BK-1',
     'seoljeong-import-map row6: PUR책자 내지 import_col=(확인 필요), matched=0'],
    ['PRD_000070', 'PUR책자', '표지', 'USAGE.02', '*별도설정', 'IMPORT 컬럼 부재',
     'B1 잔여 — PUR표지 IMPORT 상품컬럼 부재. 컨펌 D-BK-1',
     'seoljeong-import-map row7: PUR책자 표지 import_col=(확인 필요), matched=0'],
    ['PRD_000072', '하드커버책자', '내지', 'USAGE.01', '*별도설정', 'IMPORT 컬럼 부재',
     'B1 잔여 — 하드커버 내지 IMPORT 부재(표지=전용지는 기적재 USAGE.02). 컨펌 D-BK-1',
     'seoljeong-import-map row10: 하드커버책자 내지 import_col=(확인 필요), matched=0'],
    ['PRD_000077', '레더 하드커버책자', '내지', 'USAGE.01', '*별도설정', 'IMPORT 컬럼 부재',
     'B1 잔여 — 레더하드 내지 IMPORT 부재(표지=레더 기적재). 컨펌 D-BK-1',
     'seoljeong-import-map row11: 레더 하드커버책자 내지 import_col=(확인 필요), matched=0'],
    ['PRD_000082', '하드커버 링책자', '내지', 'USAGE.01', '*별도설정', 'IMPORT 컬럼 부재',
     'B1 잔여 — 하드링 내지 IMPORT 부재(표지=전용지 기적재). 컨펌 D-BK-1',
     'seoljeong-import-map row12: 하드커버 링책자 내지 import_col=(확인 필요), matched=0'],
    ['PRD_000088', '레더 링바인더', '내지', 'USAGE.01', '(L1 내지종이 빈값)', 'IMPORT 컬럼 부재 + L1 원천 공백',
     'B1 잔여 + G-BK-4 — 레더바인더 내지종이 L1 빈값·IMPORT 부재. 제본/excl/page도 전무(MISMATCH). 발명 금지. 컨펌 D-BK-1·D-BK-3',
     'L1: 레더 링바인더 내지종이=빈값; booklet.md G-BK-4 088 proc/excl/page 0행'],
]
with open(os.path.join(DEFER, 't_prd_product_materials_deferred.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(DEFER_MAT_HEADER)
    w.writerows(defer_mat)

# ====================================================================
# R4 flag — 떡메모지(097) page_rule 잡음 (삭제 단정 금지, flag만)
#   라이브 097 page_rule=3/3/3 보고(booklet.md G-BK-5). 떡제본은 page 무의미(묶음수=권 도메인).
#   stale ref(ref-product-page-rules.csv)엔 097 부재 → stale/라이브 충돌. 삭제 단정 금지.
# ====================================================================
PR_FLAG_HEADER = ['prd_cd', 'prd_nm', 'live_page_min', 'live_page_max', 'live_page_incr',
                  'stale_ref_state', 'verdict', 'action', '_provenance']
# stale ref 097 부재 확인
ref_pr = {r['prd_cd'] for r in rd('00_schema/ref-product-page-rules.csv')}
pr097_stale = '존재' if 'PRD_000097' in ref_pr else '부재(stale ref에 097 행 없음)'
pr_flag = [
    ['PRD_000097', '떡메모지', '3', '3', '3', pr097_stale,
     'MISMATCH/잡음 의심 — 떡제본은 page 무의미(묶음수 권 도메인, bundle_qty 50/100장1권 적재됨)',
     'FLAG only — 삭제 단정 금지. 라이브 097 page_rule 실재 재확인 후 제거 여부 컨펌(D-BK-4)',
     'booklet.md G-BK-5: 라이브 097 page_rule=3/3/3, 엑셀 떡메모지 내지페이지 컬럼 부재. stale ref-product-page-rules.csv: '
     + pr097_stale],
]
with open(os.path.join(BASE, 'page-rule-noise-flag.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(PR_FLAG_HEADER)
    w.writerows(pr_flag)

# ====================================================================
# R6 — qty_unit 일괄 (UPDATE, 11 parent)
#   C-4 binding: 상품군별 기본 일괄. 책자 → QTY_UNIT.03(권). UPDATE-class(INSERT 아님).
# ====================================================================
QU_HEADER = ['prd_cd', 'prd_nm', 'current_qty_unit_typ_cd', 'target_qty_unit_typ_cd',
             'use_yn', '_provenance']
qu_rows = []
for nm, cd in NM2CD.items():
    p = prods.get(cd, {})
    cur = (p.get('qty_unit_typ_cd') or '').strip() or 'NULL'
    qu_rows.append([cd, nm, cur, 'QTY_UNIT.03', p.get('use_yn', '?'),
                    f'C-4 책자→권(QTY_UNIT.03). 라이브 현재 {cur}(272 글로벌 NULL 갭 G-BK-7). (R6)'])
qu_rows.sort(key=lambda r: r[0])
with open(os.path.join(BASE, 't_prd_products_qtyunit_update.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f)
    w.writerow(QU_HEADER)
    w.writerows(qu_rows)

# ---- 요약 출력 ----
print('=== booklet gen_load 산출 ===')
print(f'  material active   : {len(mat_rows):3d} 행  (068/069/071 내지·표지 IMPORT)')
print(f'  process  active   : {len(proc_rows):3d} 행  (069/070 형압 양각/음각)')
print(f'  material deferred  : {len(defer_mat):3d} 행  (PUR/하드커버/바인더 내지 — B1 잔여)')
print(f'  page-rule flag     : {len(pr_flag):3d} 행  (097 page 잡음 — flag만)')
print(f'  qty_unit UPDATE    : {len(qu_rows):3d} 행  (11 parent → 권)')
