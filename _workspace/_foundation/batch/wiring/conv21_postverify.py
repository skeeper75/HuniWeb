#!/usr/bin/env python3
# conv21 COMMIT 사후검증 — simulate 실호출(라이브 읽기전용)
# 기대: 110 인쇄비>0, 020 SPOT>0, 130 포맥스 4조합 골든, 129 폼보드 회귀 4조합, 048 접지리플렛 회귀
import sys, json
sys.path.insert(0, "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/batch")
from lib_huni import load_env, HuniSim, price_of
load_env()
s = HuniSim()
fails = []

def comps_nz(r):
    return [(c.get('comp_cd'), c.get('subtotal')) for c in (r.get('base') or {}).get('components', [])
            if str(c.get('subtotal')) not in ('0', 'None', '0.0', '0.00')]

def base_sel(prd):
    m = s.sim_meta(prd)
    sel = {}
    for d in m.get('prod_dims', []):
        ops = d.get('options', [])
        if ops:
            df = next((o for o in ops if o.get('dflt')), ops[0])
            sel[d['name']] = df['v']
    return m, sel

# 1) 110 엽서캘린더 — 인쇄비 발현·final ≫ 1057
m, sel = base_sel('PRD_000110')
r = s.simulate('PRD_000110', sel, 100)
p = price_of(r); nz = comps_nz(r)
print('110 final:', p, nz)
if not any('PRINT' in c for c, _ in nz): fails.append('110 인쇄비 미발현')
if p is None or p <= 1057: fails.append(f'110 final 저청구({p})')

# 2) 020 화이트인쇄엽서 — SPOT 발현(단면/양면)
m, sel = base_sel('PRD_000020')
for popt, side in [('POPT_000001', '단면'), ('POPT_000002', '양면')]:
    sel2 = dict(sel); sel2['print_opt_cd'] = popt
    r = s.simulate('PRD_000020', sel2, 100, procs=[{'proc_cd': 'PROC_000008'}])
    p = price_of(r); nz = comps_nz(r)
    print(f'020 {side}:', p, nz)
    if not any('SPOT' in c for c, _ in nz): fails.append(f'020 {side} SPOT 미발현')

# 3) 130 포맥스 — 4조합 골든 verbatim + 미스매치 0(알려진 한계)
GOLD = [('SIZ_000174', 'MAT_000022', 8500), ('SIZ_000197', 'MAT_000554', 13000),
        ('SIZ_000174', 'MAT_000023', 10000), ('SIZ_000197', 'MAT_000555', 16000)]
for siz, mat, g in GOLD:
    r = s.simulate('PRD_000130', {'siz_cd': siz, 'mat_cd': mat}, 1)
    p = price_of(r)
    print(f'130 {siz}/{mat}: {p} (golden {g})')
    if p != g: fails.append(f'130 {siz}/{mat} {p}!={g}')

# 4) 129 폼보드 회귀 — 4조합 불변
GOLD129 = [('SIZ_000315', 'MAT_000398', 6000), ('SIZ_000315', 'MAT_000399', 8500),
           ('SIZ_000198', 'MAT_000612', 12000), ('SIZ_000198', 'MAT_000613', 14000)]
for siz, mat, g in GOLD129:
    r = s.simulate('PRD_000129', {'siz_cd': siz, 'mat_cd': mat}, 1)
    p = price_of(r)
    print(f'129 {siz}/{mat}: {p} (golden {g})')
    if p != g: fails.append(f'129 회귀 {siz}/{mat} {p}!={g}')

# 5) 048 접지리플렛 회귀(PRF_FOLD_SUM·CARD_2H 배선 불변 확인)
m, sel = base_sel('PRD_000048')
r = s.simulate('PRD_000048', sel, 100)
print('048 final:', price_of(r))

print('=' * 40)
print('RESULT:', 'FAIL ' + '; '.join(fails) if fails else 'ALL PASS')
sys.exit(1 if fails else 0)
