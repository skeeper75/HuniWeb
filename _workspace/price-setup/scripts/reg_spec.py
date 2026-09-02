"""M2 등록 명세 — 43건의 화면 입력값을 결정론으로 뽑는다.

값을 지어내지 않는다. 세 곳에서만 가져온다.
  코드·이름·격자 위치  → 권위 가격표 파싱 결과(authority-grids-trackA.csv)
  구성요소유형·단가유형 → **갈음할 라이브 그릇에서 승계**(가장 방어 가능한 근거)
  사용차원             → 라이브 use_dims (축 결정표가 화면 등록과 일치함을 이미 확인)
계획 §I 가 가격유형을 따로 적어 둔 건은 라이브와 대조해 어긋나면 표에 드러낸다.
"""
import csv
import sys

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
sys.path.insert(0, f'{WT}/_workspace/price-setup/scripts')
import db                                                        # noqa: E402

BASE = f'{WT}/_workspace/price-setup'

# 계획 §I 가 가격유형을 명시한 건만 적는다(아크릴·스티커). 포스터는 표에 칸이 없다.
PLAN_PRC_TYP = {
    'ACRYLIC_CLEAR3T_PRINT': 'PRICE_TYPE.01', 'ACRYLIC_CLEAR15T_PRINT': 'PRICE_TYPE.01',
    'ACRYLIC_MIRROR3T_PRINT': 'PRICE_TYPE.01', 'ACRYLIC_TOTAL_FINISHING': 'PRICE_TYPE.01',
    'ACRYLIC_CLEAR8T_PRINT': 'PRICE_TYPE.01', 'ACRYLIC_CARABINER_FINAL': 'PRICE_TYPE.02',
    'STK_KISSCUT_PRINT': 'PRICE_TYPE.01', 'STK_CUT_PRINT': 'PRICE_TYPE.01',
    'STK_CUT_CLEAR_PRINT': 'PRICE_TYPE.01', 'STK_CUT_LARGE_PRINT': 'PRICE_TYPE.01',
    'STK_TATTOO_SETUP': 'PRICE_TYPE.03', 'STK_TATTOO_PRINT': 'PRICE_TYPE.01',
}
# REQ-023 이 정한 구조 — 라이브 합산본에서 승계하면 안 되는 두 건.
REQ023_DIMS = {
    'STK_TATTOO_SETUP': 'min_qty',                    # 수량만 (고정금액)
    'STK_TATTOO_PRINT': 'bdl_qty,siz_cd,min_qty',     # 묶음수(3장)·사이즈·수량
}

live = {}
for line in db.q("""
    SELECT comp_cd, comp_typ_cd, prc_typ_cd,
           replace(coalesce(use_dims::text,''), ',', ' ') FROM t_prc_price_components
""", tuples=True).splitlines():
    if line.strip():
        cd, typ, prc, dims = line.split('\t')
        live[cd] = (typ, prc, dims)


def dims_of(raw):
    """use_dims 문자열 → 위젯에 넣을 축 순서(수량구간은 위젯이 강제로 붙인다)."""
    out = []
    for d in raw.replace('[', ' ').replace(']', ' ').replace('"', ' ').split():
        d = d.strip()
        if d and d != 'min_qty' and not d.startswith('opt_grp') and not d.startswith('proc_grp'):
            if d not in out:
                out.append(d)
    return ','.join(out + ['min_qty'])


grids = {g['code']: g for g in csv.DictReader(open(f'{BASE}/m1/authority-grids-trackA.csv'))}
rows = []
for m in csv.DictReader(open(f'{BASE}/m1/mapping-43-trackA.csv')):
    code = m['new_code']
    srcs = [c.strip() for c in m['live_comp'].split(' + ') if c.strip() in live]
    src = srcs[0] if srcs else ''
    typ, prc, dims_raw = live.get(src, ('', '', ''))
    dims = REQ023_DIMS.get(code) or dims_of(dims_raw)
    g = grids.get(code)
    loc = (f"{m['sheet']} r{g['grid_head_row']}~r{g['grid_last_row']} "
           f"c{g['grid_col_from']}~c{g['grid_col_to']} · {g['numeric_cells']}칸") if g else '권위 코드 오기(D-3)'
    plan_prc = PLAN_PRC_TYP.get(code, '')
    # 리드 규칙(260902): 역할로 유형을 통일하고, setup 만 옛 그릇을 승계한다.
    #   print/출력가 → 인쇄비.01 · finishing/addon → 후가공비.04
    #   final/제작가·완제품가 → 완제품비.06 · setup → 승계
    if code.endswith('_SETUP'):
        typ_final = typ
    elif code.endswith('_PRINT'):
        typ_final = 'PRC_COMPONENT_TYPE.01'
    elif code.endswith('_FINISHING') or code.endswith('_ADDON'):
        typ_final = 'PRC_COMPONENT_TYPE.04'
    elif code.endswith('_FINAL'):
        typ_final = 'PRC_COMPONENT_TYPE.06'
    else:
        typ_final = typ
    # 가격유형은 계획이 명시한 건은 계획을 따르고(구조를 정한 결정), 없으면 승계한다.
    prc_final = plan_prc or prc
    rows.append(dict(
        no=m['no'], order='', new_code=code, new_name=m['new_name'],
        comp_typ_cd=typ_final, prc_typ_cd=prc_final, use_dims_to_pick=dims,
        inherited_from=src or '★승계원 없음',
        plan_prc_typ=plan_prc,
        prc_typ_conflict=('★계획 %s ≠ 라이브 %s' % (plan_prc, prc)) if (plan_prc and prc and plan_prc != prc) else '',
        products_in_scope=m['products_in_scope'], formula_cnt=m['formula_cnt'],
        authority_loc=loc,
        note=f"[권위 인쇄상품 가격표 260902_2 · {loc}] 대체: {src or '없음'}. SPEC-PRICECOMP-001 트랙A M2.",
        typ_inherited=typ, prc_inherited=prc))

# 등록 순서 — 되돌릴 비용이 낮은 것부터.
def rank(r):
    p, f = int(r['products_in_scope']), int(r['formula_cnt'])
    if p == 0 and f == 0:
        return 0                       # 금액 영향 0
    if f <= 1:
        return 1                       # 상품 1:1 단독
    return 2                           # 공유 그릇 갈래
for i, r in enumerate(sorted(rows, key=lambda r: (rank(r), int(r['no']))), 1):
    r['order'] = i

rows.sort(key=lambda r: int(r['order']))
path = f'{BASE}/m2/registration-spec-43.csv'
import os
os.makedirs(f'{BASE}/m2', exist_ok=True)
with open(path, 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

conf = [r for r in rows if r['prc_typ_conflict']]
noinh = [r for r in rows if r['inherited_from'].startswith('★')]
print(f'등록 명세 {len(rows)}행 -> {path}')
print(f'가격유형 계획↔라이브 어긋남 {len(conf)}건 · 승계원 없음 {len(noinh)}건\n')
for r in conf:
    print(f"  ★ #{r['no']} {r['new_code']}: {r['prc_typ_conflict']} (승계원 {r['inherited_from']})")
for r in noinh:
    print(f"  ★ #{r['no']} {r['new_code']}: 승계할 라이브 그릇이 없음")
print('\n[등록 순서 앞 8건]')
for r in rows[:8]:
    print(f"  {r['order']:>2}. {r['new_code']:<30} 상품{r['products_in_scope']:>2} 공식{r['formula_cnt']:>2} "
          f"{r['prc_typ_cd']:<14} dims={r['use_dims_to_pick']}")
