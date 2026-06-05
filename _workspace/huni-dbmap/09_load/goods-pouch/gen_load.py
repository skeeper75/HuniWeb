#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""goods-pouch 적재 CSV 생성기 (재현 가능). L1 + ref 마스터에서 적재행 독립 산출.
   DB 쓰기 0 — CSV 산출만. 추정 0 — 모든 행은 L1 셀/ref 마스터에 추적(provenance).
   사용: python3 gen_load.py"""
import csv, os
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
DEFER = os.path.join(BASE, '_deferred')
os.makedirs(LOAD, exist_ok=True)
os.makedirs(DEFER, exist_ok=True)

def rc(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

prods = {r['prd_nm'].strip(): r for r in rc('00_schema/ref-products.csv')}
prods_by_cd = {r['prd_cd']: r for r in rc('00_schema/ref-products.csv')}

# L1 신호 수집(상품별 가공·추가상품·사이즈)
l1 = {}
with open(os.path.join(ROOT, '06_extract', 'goods-pouch-l1.csv'), encoding='utf-8-sig') as f:
    for r in csv.DictReader(f):
        nm = (r.get('prd_nm') or '').strip()
        if not nm:
            continue
        d = l1.setdefault(nm, {'gagong': set(), 'addon': set(), 'size': []})
        g = (r.get('가공(옵션)_가공') or '').strip()
        a = (r.get('추가상품(옵션)_추가상품') or '').strip()
        s = (r.get('사이즈(필수)') or '').strip()
        if g:
            d['gagong'].add(g)
        if a:
            d['addon'].add(a)
        if s:
            d['size'].append(s)

def is_active(nm):
    return nm in prods and prods[nm]['use_yn'] == 'Y'

# ---------------------------------------------------------------------------
# ④ addon (R4) — 추가상품 신호 → addon_prd_cd. 색상=variant=note(C-8 과세분화 금지).
#    볼체인(PRD_000006)·아크릴스탠드는 기적재/use_yn=N → active 제외.
#    만년스탬프(217) 잉크색상 → 리필잉크(PRD_000015), 미적재 → active 1행.
# ---------------------------------------------------------------------------
existing_addon = {}
for r in rc('00_schema/ref-product-addons.csv'):
    existing_addon.setdefault(r['prd_cd'], set()).add(r['addon_prd_cd'])

ADDON_MAP = {  # L1 추가상품 접두 → addon_prd_cd (마스터 실재)
    '볼체인': 'PRD_000006',
    '검정': 'PRD_000015', '노랑': 'PRD_000015', '빨강': 'PRD_000015',
    '청보라': 'PRD_000015', '초록': 'PRD_000015', '파랑': 'PRD_000015',
    '핑크': 'PRD_000015',  # 만년스탬프 잉크(5cc)
    '아크릴스탠드': 'PRD_000160',
}
addon_active = []
addon_defer = []
for nm, d in l1.items():
    if not d['addon'] or nm not in prods:
        continue
    cd = prods[nm]['prd_cd']
    uy = prods[nm]['use_yn']
    # 신호 → addon_prd_cd 집합(색상 등 variant는 note로 통합 — C-8)
    a2colors = {}
    for sig in d['addon']:
        # 접두 토큰으로 addon_prd_cd 결정
        addcd = None
        for k, v in ADDON_MAP.items():
            if sig.startswith(k) or sig.replace(' ', '').startswith(k):
                addcd = v
                break
        if addcd:
            a2colors.setdefault(addcd, []).append(sig)
    for i, (addcd, colors) in enumerate(sorted(a2colors.items()), start=1):
        # 기적재 skip(재적재 금지)
        if addcd in existing_addon.get(cd, set()):
            continue
        note = '색상 variant 통합(C-8): ' + ' / '.join(sorted(set(colors)))
        if len(note) > 480:
            note = note[:477] + '...'
        prov = 'L1:%s 추가상품=%s → addon %s (R4)' % (nm, sorted(set(colors))[0], addcd)
        row = {'prd_cd': cd, 'addon_prd_cd': addcd, 'disp_seq': i,
               'note': note, '_provenance': prov}
        (addon_active if uy == 'Y' else addon_defer).append(row)

# ---------------------------------------------------------------------------
# ⑤ process (R3) — 가공 신호 → proc_cd. 에폭시(083)·부착(081).
#    부착 6캔버스 = 기적재 skip. 에폭시 = 미니우치와키링(227) use_yn=N → deferred.
# ---------------------------------------------------------------------------
existing_proc = {}
for r in rc('00_schema/ref-product-processes.csv'):
    existing_proc.setdefault(r['prd_cd'], set()).add(r['proc_cd'])

GAGONG_MAP = {  # L1 가공 토큰 → proc_cd (마스터 실재)
    '에폭시': 'PROC_000083',
    '라벨부착': 'PROC_000081', '부착': 'PROC_000081',
}
proc_active = []
proc_defer = []
for nm, d in l1.items():
    if not d['gagong'] or nm not in prods:  # 폰케이스(unmatched)는 prods 부재 → skip
        continue
    cd = prods[nm]['prd_cd']
    uy = prods[nm]['use_yn']
    pcs = set()
    for sig in d['gagong']:
        for k, v in GAGONG_MAP.items():
            if k in sig:
                pcs.add(v)
    for j, pc in enumerate(sorted(pcs), start=10):
        if pc in existing_proc.get(cd, set()):
            continue  # 기적재 skip
        prov = 'L1:%s 가공=%s → %s (R3)' % (nm, sorted(d['gagong'])[0], pc)
        row = {'prd_cd': cd, 'proc_cd': pc, 'excl_grp_cd': '',
               'mand_proc_yn': 'N', 'disp_seq': j, '_provenance': prov}
        (proc_active if uy == 'Y' else proc_defer).append(row)

# ---------------------------------------------------------------------------
# ① qty_unit UPDATE (R6/C-4) — 굿즈 → EA(QTY_UNIT.01). matched 98 전건(use_yn 무관, 컬럼 업데이트).
# ---------------------------------------------------------------------------
qu_rows = []
for nm, r in prods.items():
    cd = r['prd_cd']
    if not (cd.startswith('PRD_') and 183 <= int(cd[4:]) <= 280):
        continue
    if nm not in l1:  # L1 시트에 없는 상품(범위 내 비-goods) 방지
        continue
    qu_rows.append({
        'prd_cd': cd, 'prd_nm': nm,
        'current_qty_unit_typ_cd': (r.get('qty_unit_typ_cd') or ''),
        'target_qty_unit_typ_cd': 'QTY_UNIT.01',
        'use_yn': r['use_yn'],
        '_provenance': 'C-4 굿즈→EA(QTY_UNIT.01) 일괄. L1 goods-pouch matched 98 전건'})

# ---------------------------------------------------------------------------
# write helpers
# ---------------------------------------------------------------------------
def write(path, header, rows):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=header)
        w.writeheader()
        for r in rows:
            w.writerow({k: r.get(k, '') for k in header})

write(os.path.join(LOAD, 't_prd_product_addons.csv'),
      ['prd_cd', 'addon_prd_cd', 'disp_seq', 'note', '_provenance'], addon_active)
write(os.path.join(LOAD, 't_prd_product_processes.csv'),
      ['prd_cd', 'proc_cd', 'excl_grp_cd', 'mand_proc_yn', 'disp_seq', '_provenance'], proc_active)
write(os.path.join(LOAD, 't_prd_products_qtyunit_update.csv'),
      ['prd_cd', 'prd_nm', 'current_qty_unit_typ_cd', 'target_qty_unit_typ_cd', 'use_yn', '_provenance'], qu_rows)

write(os.path.join(DEFER, 't_prd_product_processes_deferred.csv'),
      ['prd_cd', 'proc_cd', 'excl_grp_cd', 'mand_proc_yn', 'disp_seq', 'reason', '_provenance'],
      [dict(r, reason='use_yn=N 미출시(C-1) — 출시 시 적재') for r in proc_defer])
write(os.path.join(DEFER, 't_prd_product_addons_deferred.csv'),
      ['prd_cd', 'addon_prd_cd', 'disp_seq', 'note', 'reason', '_provenance'],
      [dict(r, reason='use_yn=N 미출시(C-1) — 출시 시 적재') for r in addon_defer])

# 폰케이스 5상품(그레이밴딩=미출시/보류, C-1) — 신규행 0, 기록만
PHONE5 = ['슬림하드 폰케이스', '블랙젤리', '임팩트 젤하드', '에어팟케이스★', '버즈케이스★']
write(os.path.join(DEFER, 'phonecase_inactive_record.csv'),
      ['prd_nm', 'status', 'reason'],
      [{'prd_nm': p, 'status': '미등록(그레이밴딩 FFD9D9D9)',
        'reason': 'C-1 미출시/보류 — 신규 t_prd_products 행 적재 절대 금지. 출시 시 별도 등록'} for p in PHONE5])

print('addon active:', len(addon_active), '| process active:', len(proc_active),
      '| qty_unit:', len(qu_rows))
print('deferred — proc:', len(proc_defer), 'addon:', len(addon_defer), 'phone:', len(PHONE5))
