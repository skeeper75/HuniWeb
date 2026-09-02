"""M1② — plan §I 43행 ↔ 권위 가격표 격자 ↔ 라이브 그릇을 3원 대조한다.

세 쪽이 서로 어긋난 칸만 뽑아 낸다. plan §I 는 권위 브리프를 옮겨 적은 것이므로
여기서 고칠 대상이고, 권위 가격표가 기준이다.
"""
import csv
import sys
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db

BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup'

plan = list(csv.DictReader(open(f'{BASE}/m1/plan-registry-43.csv')))
grids = list(csv.DictReader(open(f'{BASE}/m1/authority-grids-trackA.csv')))

# 권위 격자를 코드로 묶는다. 같은 코드가 두 번 나오면 둘 다 붙든다(오기 탐지).
by_code = {}
for g in grids:
    by_code.setdefault(g['code'], []).append(g)

# 라이브 그릇의 단가행 수·존재 여부
live_codes = set()
counts = {}
for line in db.q("""
    SELECT c.comp_cd, c.use_yn, c.prc_typ_cd,
           replace(coalesce(c.use_dims::text,''), ',', ' ') AS dims,
           count(p.comp_price_id)
    FROM t_prc_price_components c
    LEFT JOIN t_prc_component_prices p ON p.comp_cd = c.comp_cd
    GROUP BY c.comp_cd, c.use_yn, c.prc_typ_cd, c.use_dims ORDER BY c.comp_cd
""", tuples=True).splitlines():
    if not line.strip():
        continue
    cd, use, typ, dims, n = line.split('\t')
    live_codes.add(cd)
    counts[cd] = (use, int(n), typ, dims)

rows, issues = [], []
for p in plan:
    code = p['code']
    gs = by_code.get(code, [])
    auth_cells = gs[0]['numeric_cells'] if gs else ''
    auth_loc = (f"r{gs[0]['grid_head_row']}~r{gs[0]['grid_last_row']}"
                f" c{gs[0]['grid_col_from']}~c{gs[0]['grid_col_to']}") if gs else ''
    plan_rows = p['plan_rows']
    # 라이브 쪽 — 여러 그릇을 합친 칸은 '+' 로 적혀 있다
    tgt = p['live_target']
    live_n, live_state, live_typ, live_dims = '', '', '', ''
    if tgt in counts:
        live_state, live_n, live_typ, live_dims = counts[tgt]
    rows.append(dict(no=p['no'], code=code, name=p['name'],
                     authority_cells=auth_cells, authority_loc=auth_loc,
                     plan_claimed_rows=plan_rows,
                     live_target=tgt, live_exists='Y' if tgt in live_codes else 'N',
                     live_use_yn=live_state, live_price_rows=live_n,
                     live_prc_typ=live_typ, live_use_dims=live_dims))
    if not gs:
        issues.append(f"#{p['no']} {code} — 권위 가격표에서 이 코드를 찾지 못했다")
    elif plan_rows and auth_cells and int(plan_rows) != int(auth_cells):
        issues.append(f"#{p['no']} {code} — 계획 {plan_rows}칸 vs 권위 실측 {auth_cells}칸 "
                      f"({auth_loc})")
    if tgt not in live_codes and '+' not in tgt and '(' not in tgt:
        issues.append(f"#{p['no']} {code} — 대체할 라이브 그릇 {tgt} 가 라이브에 없다")

# 권위에는 있는데 계획 43행에 없는 코드
plan_codes = {p['code'] for p in plan}
for g in grids:
    if g['code'] not in plan_codes:
        issues.append(f"권위에만 있음: {g['code']} ({g['name']}) "
                      f"r{g['grid_head_row']} — 계획 43행에 없음")
# 권위 안에서 코드가 겹치는 것
for code, gs in by_code.items():
    if len(gs) > 1:
        locs = ', '.join(f"r{g['grid_head_row']}" for g in gs)
        issues.append(f"권위 안 코드 중복: {code} at {locs}")

out = f'{BASE}/m1/registry-3way-check.csv'
with open(out, 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

print(f'3원 대조표 -> {out}\n')
print(f'어긋난 칸 {len(issues)}건')
for i in issues:
    print('  -', i)
