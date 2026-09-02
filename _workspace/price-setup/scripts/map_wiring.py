"""M1③ — 대체할 라이브 그릇 → 걸린 공식 → 그 공식을 쓰는 상품 을 전수로 편다."""
import csv
import sys
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db

BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup'

# 계획 §I 의 '대체할 라이브 그릇' 칸을 실제 코드로 편다.
EXPAND = {
    'COMP_STK_PRINT(반칼)': ['COMP_STK_PRINT'],
    'COMP_STK_PRINT(완칼)': ['COMP_STK_PRINT'],
    'COMP_STK_PRINT(완칼투명)': ['COMP_STK_PRINT'],
    'COMP_STK_PRINT(대형)': ['COMP_STK_PRINT'],
    'COMP_POSTER_SHEETCUT_MATTE+HOLO': ['COMP_POSTER_SHEETCUT_MATTE', 'COMP_POSTER_SHEETCUT_HOLO'],
    'COMP_POSTER_ACRYLSTK_GLOSS+MIRROR': ['COMP_POSTER_ACRYLSTK_GLOSS', 'COMP_POSTER_ACRYLSTK_MIRROR'],
}

plan = list(csv.DictReader(open(f'{BASE}/m1/plan-registry-43.csv')))
targets = {}
for p in plan:
    for cd in EXPAND.get(p['live_target'], [p['live_target']]):
        targets.setdefault(cd, []).append(p['code'])

codes = sorted(targets)
inlist = ', '.join(f"'{c}'" for c in codes)

sql = f"""
SELECT fc.comp_cd, fc.frm_cd, f.frm_nm, coalesce(f.use_yn,'') AS frm_use,
       coalesce(pf.prd_cd,'') AS prd_cd, coalesce(pr.prd_nm,'') AS prd_nm,
       coalesce(pr.use_yn,'') AS prd_use, coalesce(pr.nonspec_yn,'') AS nonspec
FROM t_prc_formula_components fc
JOIN t_prc_price_formulas f ON f.frm_cd = fc.frm_cd
LEFT JOIN t_prd_product_price_formulas pf ON pf.frm_cd = fc.frm_cd
LEFT JOIN t_prd_products pr ON pr.prd_cd = pf.prd_cd
WHERE fc.comp_cd IN ({inlist})
ORDER BY fc.comp_cd, fc.frm_cd, pf.prd_cd
"""

rows = []
for line in db.q(' '.join(sql.split()), tuples=True).splitlines():
    if not line.strip():
        continue
    f = line.split('\t')
    if len(f) != 8:
        continue
    rows.append(dict(zip(
        ['live_comp', 'frm_cd', 'frm_nm', 'frm_use', 'prd_cd', 'prd_nm', 'prd_use', 'nonspec'], f)))
    rows[-1]['new_codes'] = ' / '.join(targets[f[0]])

path = f'{BASE}/m1/wiring-current-trackA.csv'
with open(path, 'w', newline='') as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

live_prd = {r['prd_cd'] for r in rows if r['prd_cd'] and r['prd_use'] == 'Y'}
dead_prd = {r['prd_cd'] for r in rows if r['prd_cd'] and r['prd_use'] != 'Y'}
frms = {r['frm_cd'] for r in rows}
print(f'배선표 {len(rows)}줄 -> {path}')
print(f'닿는 라이브 그릇 {len({r["live_comp"] for r in rows})} / 대상 {len(codes)}')
print(f'걸린 공식 {len(frms)}  ·  상품 살아있음 {len(live_prd)}  ·  사용중지 {len(dead_prd)}')
missing = [c for c in codes if c not in {r['live_comp'] for r in rows}]
if missing:
    print('공식이 하나도 걸려 있지 않은 그릇:', ', '.join(missing))
