#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""design-calendar 신규 별도 prd_cd 등록 적재 CSV 자기검증 게이트.
   디자인캘린더는 calendar 108~112 공유 variant가 아니라 신규 별도 prd_cd 등록(라이브 113~117 부재 확증).
   검증: 5상품 일관성 · master FK 실재(siz/mat/proc/addon) · placeholder prd_cd 형식 · L1 provenance 비공란.
   추정 0: 모든 master 참조 코드는 ref 마스터에 실재해야 함. 발명 0.
   사용: python3 verify_design_calendar.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')

def load_csv(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

def load_load(name):
    with open(os.path.join(LOAD, name), encoding='utf-8') as f:
        return list(csv.DictReader(f))

# ---- master 코드 집합 (라이브/추출본 마스터 — 실재 검증용) ----
sizes = {r['siz_cd'] for r in load_csv('00_schema/ref-sizes.csv')}
mats = {r['mat_cd'] for r in load_csv('00_schema/ref-materials.csv')}
procs = {r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv')}
prods = {r['prd_cd'] for r in load_csv('00_schema/ref-products.csv')}  # addon_prd_cd 실재용

PLACEHOLDER = {f'PRD_NEW_DCAL_{i}' for i in range(1, 6)}

results = []
def check(label, ok, detail=''):
    results.append((label, ok, detail))
    if not ok and detail:
        print(f"  [{label}] FAIL: {detail}")
    return ok

# ---- 1. t_prd_products: 5상품·(N,Y)·PRD_TYPE.04·placeholder prd_cd ----
prd = load_load('t_prd_products.csv')
check('상품수=5', len(prd) == 5, f"len={len(prd)}")
check('prd_cd=placeholder', {r['prd_cd'] for r in prd} == PLACEHOLDER,
      f"{sorted(r['prd_cd'] for r in prd)}")
check('file_upload=N/editor=Y', all(r['file_upload_yn'] == 'N' and r['editor_yn'] == 'Y' for r in prd),
      "모든 신규=（N,Y) 디자인 제공 패턴이어야")
check('prd_typ=PRD_TYPE.04', all(r['prd_typ_cd'] == 'PRD_TYPE.04' for r in prd), '')
check('qty_unit=QTY_UNIT.01', all(r['qty_unit_typ_cd'] == 'QTY_UNIT.01' for r in prd), '')
# placeholder가 라이브 실 prd_cd와 충돌하지 않아야(발명·중복 금지)
check('placeholder≠실prd_cd', not (PLACEHOLDER & prods), "placeholder가 라이브 prd_cd와 겹치면 안 됨")

# ---- 2. size: 5행·각 prd 1사이즈·siz_cd master 실재 ----
sz = load_load('t_prd_product_sizes.csv')
check('size 5행', len(sz) == 5, f"len={len(sz)}")
check('size prd⊆placeholder', {r['prd_cd'] for r in sz} <= PLACEHOLDER, '')
bad_siz = [r['siz_cd'] for r in sz if r['siz_cd'] not in sizes]
check('siz_cd master 실재', not bad_siz, f"부재 siz_cd={bad_siz}")

# ---- 3. material: 5행·몽블랑190g 단일·mat_cd 실재 ----
mt = load_load('t_prd_product_materials.csv')
check('material 5행', len(mt) == 5, f"len={len(mt)}")
bad_mat = [r['mat_cd'] for r in mt if r['mat_cd'] not in mats]
check('mat_cd master 실재', not bad_mat, f"부재 mat_cd={bad_mat}")
# 몽블랑 계열만(MAT_000107 또는 3절 MAT_000111)
check('material=몽블랑190g 고정', {r['mat_cd'] for r in mt} <= {'MAT_000107', 'MAT_000111'},
      f"{sorted({r['mat_cd'] for r in mt})}")

# ---- 4. print_option / page_rule: 각 5행 ----
po = load_load('t_prd_product_print_options.csv')
check('print_option 5행', len(po) == 5, f"len={len(po)}")
check('print_side∈{단면,양면}', all(r['print_side'] in ('단면', '양면') for r in po), '')
pr = load_load('t_prd_product_page_rules.csv')
check('page_rule 5행', len(pr) == 5, f"len={len(pr)}")
check('page_rule min=max(고정)', all(r['page_min'] == r['page_max'] for r in pr),
      "디자인 페이지 고정 = min=max여야")

# ---- 5. process: proc_cd master 실재(코드 있는 것만 적재, 삼각대는 flag) ----
pc = load_load('t_prd_product_processes.csv')
bad_proc = [r['proc_cd'] for r in pc if r['proc_cd'] not in procs]
check('proc_cd master 실재(발명0)', not bad_proc, f"부재 proc_cd={bad_proc}")

# ---- 6. addon: addon_prd_cd 실재 ----
ad = load_load('t_prd_product_addons.csv')
bad_addon = [r['addon_prd_cd'] for r in ad if r['addon_prd_cd'] not in prods]
check('addon_prd_cd 실재', not bad_addon, f"부재 addon={bad_addon}")

# ---- 7. provenance 비공란(추정 0 — 모든 적재행 L1/master 추적) ----
prov_empty = []
for name in ('t_prd_products.csv', 't_prd_product_sizes.csv', 't_prd_product_materials.csv',
             't_prd_product_print_options.csv', 't_prd_product_page_rules.csv',
             't_prd_product_processes.csv', 't_prd_product_addons.csv'):
    for r in load_load(name):
        if not (r.get('_provenance', '') or '').strip():
            prov_empty.append((name, r.get('prd_cd', '?')))
check('provenance 전행 비공란', not prov_empty, f"공란={prov_empty[:5]}")

# ---- 8. DB 미적재 가드: 마스터 신설은 별도 승인(스크립트는 CSV만 검증) ----
#   (실 INSERT 없음 — 본 게이트는 CSV 정합만 확인, 적재는 Q-DC-0 승인 후)

# ---- 출력 ----
print("\n=== SELF-CHECK (design-calendar 신규 별도 prd_cd 등록) ===")
print(f"{'label':28s} result  detail")
allok = True
for lbl, ok, detail in results:
    allok &= ok
    print(f"{lbl:28s} {'PASS' if ok else 'FAIL'}  {detail if not ok else ''}")
print(f"\nGATE: {'PASS — 신규5상품·master FK실재·발명0·provenance전행' if allok else 'FAIL'}  (DB 미적재·등록 승인 Q-DC-0 대기)")
sys.exit(0 if allok else 1)
