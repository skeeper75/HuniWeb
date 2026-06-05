#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""product-accessory 적재 CSV 생성기 — round-3 remediation (대조군).
   본 시트는 정합 양호(GO수준)라 적재가 적다.
   - R3(qty_unit, C-4): 15상품 NULL → 부자재 상품군 기본단위 일괄 부여 (UPDATE-class).
   - R2(bundle_qty, G-PA-3 Low): DEFERRED — bundle PK=prd_cd 단일·장수 size표기 내포·정책의존(CONFIRM).
   - R1(size 입도, G-PA-2 Low): no-op (현 적재 동작·정책 확정 후). false MISSING 양산 금지.
   - G-PA-1/4/5: 정상(분기·process부재·MES중복) → 적재 변경 0.
   추정 0 · provenance 기록 · DB 쓰기 없음(CSV만).
   사용: python3 gen_load.py
"""
import csv, os
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
DEF = os.path.join(BASE, '_deferred')
os.makedirs(LOAD, exist_ok=True)
os.makedirs(DEF, exist_ok=True)
REGDT = '2026-06-05 00:00:00'  # 적재 예정 reg_dt(설계값, FK 무관)

def rd(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

# ----- 15 PA 상품 (prd_nm → prd_cd) from ref-products (PRD_000001~015, PRD_TYPE.03) -----
prods = {r['prd_cd']: r for r in rd('00_schema/ref-products.csv')}
PA_CDS = [f'PRD_0000{n:02d}' for n in range(1, 16)]
# 구분(봉투/케이스 11 + 상품액세서리 4) — L1 권위
ENVELOPE_CASE = {  # 봉투/케이스 (자연단위 후보=매/개)
    'PRD_000001', 'PRD_000002', 'PRD_000003', 'PRD_000004', 'PRD_000005',
    'PRD_000006', 'PRD_000007', 'PRD_000008', 'PRD_000009', 'PRD_000010', 'PRD_000011',
}
ACCESSORY = {  # 상품액세서리 (자연단위=EA)
    'PRD_000012', 'PRD_000013', 'PRD_000014', 'PRD_000015',
}

# ============ R3 (C-4): qty_unit 상품군 기본단위 일괄 (UPDATE set) ============
# 부자재/악세서리(PRD_TYPE.03) 상품군 기본단위 = EA(QTY_UNIT.01).
# 근거: L1 자연단위가 혼재(봉투=장/매, 볼체인=개1팩, 우드=EA, 잉크=cc)하나
#   상품군 단일 기본단위로 EA가 가장 포괄적(C-4 "상품군별 기본 일괄").
#   봉투류 '매' 세분은 발명 금지 → CONFIRM(D-PA-1)로 분리, 본 set은 EA 일괄.
QU_HDR = ['prd_cd', 'prd_nm', 'current_qty_unit_typ_cd', 'target_qty_unit_typ_cd', 'use_yn', '_provenance']
qu_rows = []
for cd in PA_CDS:
    r = prods[cd]
    grp = '봉투/케이스' if cd in ENVELOPE_CASE else '상품액세서리'
    qu_rows.append([
        cd, r['prd_nm'], (r['qty_unit_typ_cd'] or 'NULL'), 'QTY_UNIT.01', r['use_yn'],
        f'C-4 상품군별 일괄(부자재 PRD_TYPE.03={grp} 기본단위=EA=QTY_UNIT.01). 라이브 현재 NULL'
    ])
with open(os.path.join(LOAD, 't_prd_products_qtyunit_update.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(QU_HDR); w.writerows(qu_rows)

# ============ R2 (G-PA-3 Low, DEFERRED): bundle_qty 후보 ============
# bundle PK=prd_cd(단일행/상품). 장수는 size 문자열에 이미 내포(70x200mm(50장)).
# 라이브 권위: OPP접착(001)/비접착(002) = bdl_qty=50 이미 적재(reg_dt 2026-06-05, stale 추출 이후).
# 나머지 봉투/케이스류 묶음장수는 같은 치수에 여러 장수(예 트래싱지 20/40/100장)가 공존 →
#   PK=prd_cd 단일행 모델로는 어느 장수를 대표로 둘지 정책 미확정 → 발명 금지, DEFERRED.
DEF_HDR = ['prd_cd', 'prd_nm', 'candidate_bdl_qty', 'bdl_unit_typ_cd', 'reason', '_provenance']
# L1 size 문자열의 괄호 장수 신호를 상품별로 수집(대표값 미확정 — 후보만 기록).
l1 = rd('06_extract/product-accessory-l1.csv')
NM2CD = {prods[cd]['prd_nm']: cd for cd in PA_CDS}
import re
from collections import defaultdict
bundle_sig = defaultdict(set)  # prd_cd -> set(장수)
for row in l1:
    nm = (row.get('prd_nm') or '').strip()
    if nm not in NM2CD:
        continue
    sz = (row.get('사이즈(필수)') or '')
    m = re.findall(r'\((\d+)\s*[장개]', sz)  # (50장) (10개) (20장)
    for v in m:
        bundle_sig[NM2CD[nm]].add(int(v))
LIVE_LOADED = {'PRD_000001', 'PRD_000002'}  # 라이브 기적재(중복 회피)
def_rows = []
for cd in PA_CDS:
    if cd not in bundle_sig:
        continue
    qtys = sorted(bundle_sig[cd])
    if cd in LIVE_LOADED:
        reason = '라이브 bdl_qty=50 기적재(skip, 중복PK 회피)'
    elif len(qtys) > 1:
        reason = f'다중 장수 공존{qtys} → PK=prd_cd 단일행 대표값 미확정(CONFIRM D-PA-2)'
    else:
        reason = f'단일 장수={qtys[0]} 후보. bundle 별도 적재 필요여부 정책 미확정(CONFIRM D-PA-2)'
    def_rows.append([
        cd, prods[cd]['prd_nm'], ('|'.join(map(str, qtys)) if qtys else ''),
        'QTY_UNIT.01', reason,
        f'L1:{prods[cd]["prd_nm"]} size괄호 장수신호={qtys} (R2 G-PA-3 Low DEFERRED)'
    ])
with open(os.path.join(DEF, 't_prd_product_bundle_qtys_deferred.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(DEF_HDR); w.writerows(def_rows)

# ============ 출력 요약 ============
print('=== product-accessory 적재 생성 (대조군) ===')
print(f'R3 qty_unit UPDATE set rows : {len(qu_rows)} (15상품 EA 일괄, UPDATE-class)')
print(f'R2 bundle_qty DEFERRED rows : {len(def_rows)} (장수신호 보유 상품, 정책 미확정)')
print('R1 size 입도               : no-op (현 적재 동작·G-PA-2 Low·CONFIRM)')
print('G-PA-1/4/5 (분기·process부재·MES중복) : 정상 → 적재 변경 0')
print('size/material 기적재         : size 38행(7상품)·material 29행(8상품) = 라이브 정합(변경 0)')
