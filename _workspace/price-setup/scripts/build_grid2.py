"""이름표 축(사이즈·옵션·자재) 격자의 붙여넣기표 생성기.

권위 격자는 사람이 읽는 이름표(A3 · 화이트보드 · 열재단)로 적혀 있고, 단가표는 코드를
요구한다. 이름표를 코드로 옮기는 일은 **추측하면 안 되는 자리**라 다음 규칙만 쓴다.

  후보는 그 그릇을 갈음할 **옛 그릇이 실제로 쓰는 코드**로 한정한다(중복 코드를 잘못
  집는 것을 막는다). 그 안에서 이름이 **정확히 하나** 대응할 때만 옮기고, 없거나 둘 이상
  이면 옮기지 않고 미해결로 보고한다.

머리 칸 「X / Y」는 **X = 열 · Y = 행**이다(가로/세로와 같은 규칙, 미니스탠딩보드
「사이즈 / 수량」이 열=사이즈·행=수량인 것으로 확인).
"""
import csv
import re
import sys
import openpyxl

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
BASE = f'{WT}/_workspace/price-setup'
sys.path.insert(0, f'{BASE}/scripts')
import db                                                        # noqa: E402

XLSX = '/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx'
LABEL = {'siz_cd': '사이즈', 'mat_cd': '자재', 'opt_cd': '옵션코드', 'proc_cd': '공정',
         'bdl_qty': '묶음수', 'min_qty': '수량(이상)', 'siz_width': '사이즈가로(이하)',
         'siz_height': '사이즈세로(이하)', 'plt_siz_cd': '판형사이즈',
         'print_opt_cd': '인쇄옵션'}
# 머리 칸의 낱말 → 축 이름
AXIS_WORD = {'사이즈': 'siz_cd', '규격': 'siz_cd', '수량': 'min_qty', '제작수량': 'min_qty',
             '옵션명': 'opt_cd', '가공옵션명': 'opt_cd', '추가옵션명': 'opt_cd',
             '추가옵션': 'opt_cd', '가공옵션': 'opt_cd', '옵션': 'opt_cd',
             '소재': 'mat_cd', '자재': 'mat_cd'}


def norm(v):
    return '' if v is None else str(v).strip()


def qty_of(label):
    """'1~4' · '100~10000' · '1' → 하한값."""
    m = re.match(r'\s*(\d+)', str(label).replace(',', ''))
    return m.group(1) if m else None


def axis_of(word):
    w = norm(word)
    for k, v in AXIS_WORD.items():
        if k in w:
            return v
    return None


def name_map(axis, old_comp):
    """옛 그릇이 실제로 쓰는 코드만 후보로 삼아 {이름: 코드} 를 만든다."""
    if axis == 'siz_cd':
        sql = (f"SELECT DISTINCT s.siz_nm, p.siz_cd FROM t_prc_component_prices p "
               f"JOIN t_siz_sizes s ON s.siz_cd=p.siz_cd WHERE p.comp_cd='{old_comp}'")
    elif axis == 'opt_cd':
        sql = (f"SELECT DISTINCT o.opt_nm, p.opt_cd FROM t_prc_component_prices p "
               f"JOIN t_prd_product_options o ON o.opt_cd=p.opt_cd WHERE p.comp_cd='{old_comp}'")
    elif axis == 'mat_cd':
        sql = (f"SELECT DISTINCT m.mat_nm, p.mat_cd FROM t_prc_component_prices p "
               f"JOIN t_mat_materials m ON m.mat_cd=p.mat_cd WHERE p.comp_cd='{old_comp}'")
    else:
        return {}
    out = {}
    for line in db.q(sql, tuples=True).splitlines():
        if line.strip():
            nm, cd = line.split('\t')
            out.setdefault(norm(nm), cd)
    return out


def resolve(label, table):
    """이름표 → 코드. 정확히 하나만 대응할 때만 옮긴다."""
    lab = norm(label)
    if lab in table:
        return table[lab], ''
    hit = [c for n, c in table.items() if n.startswith(lab) or lab.startswith(n.split('(')[0])]
    if len(set(hit)) == 1:
        return hit[0], ''
    return None, ('후보 없음' if not hit else f'후보 {len(set(hit))}개')


def main():
    code = sys.argv[1]
    spec = {r['new_code']: r for r in csv.DictReader(open(f'{BASE}/m2/registration-spec-43.csv'))}
    grids = {g['code']: g for g in csv.DictReader(open(f'{BASE}/m1/authority-grids-trackA.csv'))}
    mapping = {m['new_code']: m for m in csv.DictReader(open(f'{BASE}/m1/mapping-43-trackA.csv'))}
    if code not in grids:
        print(f'{code}: 권위 격자 없음(코드 오기 등) — 건너뜀')
        return 2
    g, sp = grids[code], spec[code]
    dims = [d for d in sp['use_dims_to_pick'].split(',') if d]
    old = [c.strip() for c in mapping[code]['live_comp'].split(' + ')][0]

    wb = openpyxl.load_workbook(XLSX, data_only=True)
    ws = wb[g['sheet']]
    r0, r1 = int(g['grid_head_row']), int(g['grid_last_row'])
    c0, c1 = int(g['grid_col_from']), int(g['grid_col_to'])
    head = norm(ws.cell(r0, c0).value)
    parts = [p.strip() for p in head.split('/')]
    col_axis = axis_of(parts[0]) if parts else None
    row_axis = axis_of(parts[1]) if len(parts) > 1 else None
    if not col_axis or not row_axis:
        print(f'{code}: 머리 칸 「{head}」을 축으로 못 읽음 — 사람 판단 필요')
        return 2

    tables = {a: name_map(a, old) for a in {col_axis, row_axis} if a != 'min_qty'}
    unresolved, rows = [], []
    cols = [(c, norm(ws.cell(r0, c).value)) for c in range(c0 + 1, c1 + 1)]
    cols = [(c, v) for c, v in cols if v]
    for r in range(r0 + 1, r1 + 1):
        rlab = norm(ws.cell(r, c0).value)
        if not rlab:
            continue
        for c, clab in cols:
            v = ws.cell(r, c).value
            if not isinstance(v, (int, float)) or isinstance(v, bool):
                continue
            cell = {}
            bad = False
            for axis, lab in ((col_axis, clab), (row_axis, rlab)):
                if axis == 'min_qty':
                    cell['min_qty'] = qty_of(lab)
                    if cell['min_qty'] is None:
                        bad = True
                else:
                    cd, why = resolve(lab, tables.get(axis, {}))
                    if cd is None:
                        unresolved.append((axis, lab, why))
                        bad = True
                    else:
                        cell[axis] = cd
            if bad:
                continue
            cell.setdefault('min_qty', '1')
            rows.append([''] + [cell.get(d, '') for d in dims] + [f'{v:g}',
                        f"권위 {g['sheet']} r{r0}~r{r1}"])

    uniq = sorted({(a, l, w) for a, l, w in unresolved})
    if uniq:
        print(f'{code}: ★ 이름표를 못 옮긴 것 {len(uniq)}종 — 표를 만들지 않는다')
        for a, l, w in uniq:
            print(f'    {LABEL[a]} 「{l}」 — {w}')
        return 1
    out = f'{BASE}/grid/{code}.csv'
    with open(out, 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['적용일'] + [LABEL[d] for d in dims] + ['단가', '비고'])
        w.writerows(rows)
    print(f'{code}: {len(rows)}행 (권위 {g["numeric_cells"]}칸) '
          f'{"일치 ✓" if len(rows) == int(g["numeric_cells"]) else "★칸수 불일치"} -> {out}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
