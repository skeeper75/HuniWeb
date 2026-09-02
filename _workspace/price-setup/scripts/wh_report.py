"""가로·세로 격자 그릇의 붙여넣기표를 만들고, 라이브 대비 무엇이 교정되는지 가른다.

라이브 포스터·현수막 그릇은 전치 적재된 기존 결함이므로(방향 권위 = 상품뷰어
직접입력 범위) 새 그릇은 그 전치를 교정한다. 따라서 「셀 단위 차이 0」이 성립하지
않는 칸이 생긴다 — 그것을 결함으로 읽지 않도록 세 갈래로 갈라 적는다.
"""
import csv
import os
import subprocess
import sys

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
BASE = f'{WT}/_workspace/price-setup'
sys.path.insert(0, f'{BASE}/scripts')
import db                                                        # noqa: E402

spec = {r['new_code']: r for r in csv.DictReader(open(f'{BASE}/m2/registration-spec-43.csv'))}
mapping = {m['new_code']: m for m in csv.DictReader(open(f'{BASE}/m1/mapping-43-trackA.csv'))}
targets = sorted(c for c, r in spec.items() if 'siz_width' in r['use_dims_to_pick'])

# 자재 축을 쓰는 그릇은 자재코드를 함께 넣어야 한다.
MAT = {'ACRYLIC_CLEAR3T_PRINT': 'MAT_000386', 'ACRYLIC_CLEAR15T_PRINT': 'MAT_000387'}

out_rows = []
print(f"{'신설 코드':<28}{'행':>5}{'그대로':>7}{'교정':>6}{'신규':>6}{'라이브만':>8}")
for code in targets:
    subprocess.run([sys.executable, f'{BASE}/scripts/build_grid.py', code,
                    MAT.get(code, ''), '1'], capture_output=True)
    f = f'{BASE}/grid/{code}.csv'
    if not os.path.exists(f):
        print(f'{code:<28} 표 생성 실패')
        continue
    mine = {(float(r['사이즈가로(이하)']), float(r['사이즈세로(이하)'])): float(r['단가'])
            for r in csv.DictReader(open(f))}
    old = [c.strip() for c in mapping[code]['live_comp'].split(' + ')][0]
    extra = f" AND mat_cd='{MAT[code]}'" if code in MAT else ''
    live = {}
    for line in db.q(f"""SELECT siz_width, siz_height, unit_price FROM t_prc_component_prices
        WHERE comp_cd='{old}' AND siz_width IS NOT NULL{extra}""", tuples=True).splitlines():
        if line.strip():
            w, h, p = line.split('\t')
            live[(float(w), float(h))] = float(p)

    same = corr = new = 0
    for k, v in mine.items():
        if k in live:
            if live[k] == v:
                same += 1
            else:
                corr += 1
                out_rows.append(dict(new_code=code, kind='교정(전치)', 가로=f'{k[0]:g}',
                                     세로=f'{k[1]:g}', 라이브=f'{live[k]:g}', 권위=f'{v:g}',
                                     근거=f'라이브 전치 적재. 권위 {mapping[code]["authority_loc"]}'))
        else:
            new += 1
            tv = live.get((k[1], k[0]))
            out_rows.append(dict(new_code=code, kind='신규(라이브 없음)', 가로=f'{k[0]:g}',
                                 세로=f'{k[1]:g}',
                                 라이브=(f'전치칸 {tv:g}' if tv is not None else '없음'),
                                 권위=f'{v:g}', 근거='권위에 있고 라이브에 없던 칸'))
    onlylive = len(set(live) - set(mine))
    print(f'{code:<28}{len(mine):>5}{same:>7}{corr:>6}{new:>6}{onlylive:>8}')

p = f'{BASE}/m3/correction-cells.csv'
with open(p, 'w', newline='') as f:
    w = csv.DictWriter(f, fieldnames=['new_code', 'kind', '가로', '세로', '라이브', '권위', '근거'])
    w.writeheader()
    w.writerows(out_rows)
print(f'\n교정·신규 칸 원장 {len(out_rows)}행 -> {p}')
