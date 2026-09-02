"""M3 붙여넣기표 생성기 — 권위 격자를 단가표 그리드 행으로 편다 (REQ-007).

숫자를 사람이나 모델이 옮겨 적지 않는다. 권위 xlsx 를 직접 읽어 격자를 펴고,
그리드 컬럼 순서(적용일 · <use_dims 순서> · 단가 · 비고)에 맞춰 CSV 로 낸다.

컬럼 순서 근거: comp_price_grid_page.html:221~231 — 적용일(calendar) 이 맨 앞,
그다음 use_dims 순서대로, fk 축은 dropdown 이며 **저장값은 코드(id)** 다.
"""
import csv
import sys
import openpyxl

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
BASE = f'{WT}/_workspace/price-setup'
XLSX = '/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx'


def mm(v):
    """'20mm' · 20 · '20' → 20.0. 격자 머리·라벨을 숫자로 읽는다."""
    if v is None:
        return None
    if isinstance(v, (int, float)):
        return float(v)
    s = str(v).strip().replace('mm', '').replace(' ', '')
    try:
        return float(s)
    except ValueError:
        return None


def wh_grid(ws, g, mat_cd, min_qty, note):
    """가로 × 세로 격자 → 행 목록.

    **라벨 열 = 가로, 머리 행 = 세로.** 처음엔 반대로 읽었다가 실측으로 바로잡았다 —
    포스터 인화지 격자는 13행(600~3000mm) × 4열(600~1200)인데 라이브의
    `siz_width` 가 13종·`siz_height` 가 4종이다. 3000mm 를 담을 수 있는 축은
    행뿐이므로 행이 가로다. 아크릴 격자는 거의 대칭이라 이 방향이 드러나지 않았다.
    """
    r0, r1 = int(g['grid_head_row']), int(g['grid_last_row'])
    c0, c1 = int(g['grid_col_from']), int(g['grid_col_to'])
    heights = [(c, mm(ws.cell(r0, c).value)) for c in range(c0 + 1, c1 + 1)]
    heights = [(c, h) for c, h in heights if h is not None]
    rows = []
    for r in range(r0 + 1, r1 + 1):
        w = mm(ws.cell(r, c0).value)
        if w is None:
            continue
        for c, h in heights:
            v = ws.cell(r, c).value
            if not isinstance(v, (int, float)) or isinstance(v, bool):
                continue
            rows.append(['', mat_cd, f'{w:g}', f'{h:g}', str(min_qty), f'{v:g}', note])
    return rows


def main():
    code = sys.argv[1]
    mat_cd = sys.argv[2] if len(sys.argv) > 2 else ''
    min_qty = sys.argv[3] if len(sys.argv) > 3 else '1'
    grids = {g['code']: g for g in csv.DictReader(open(f'{BASE}/m1/authority-grids-trackA.csv'))}
    g = grids[code]
    wb = openpyxl.load_workbook(XLSX, data_only=True)
    ws = wb[g['sheet']]
    note = f"권위 {g['sheet']} r{g['grid_head_row']}~r{g['grid_last_row']}"
    rows = wh_grid(ws, g, mat_cd, min_qty, note)

    out = f'{BASE}/grid/{code}.csv'
    with open(out, 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(['적용일', '자재', '사이즈가로(이하)', '사이즈세로(이하)',
                    '수량(이상)', '단가', '비고'])
        w.writerows(rows)
    prices = [float(r[5]) for r in rows]
    print(f'{code}: {len(rows)}행 -> {out}')
    print(f'  권위 격자 숫자칸 {g["numeric_cells"]} · 만든 행 {len(rows)} · '
          f'{"일치 ✓" if int(g["numeric_cells"]) == len(rows) else "★불일치"}')
    print(f'  단가 범위 {min(prices):g} ~ {max(prices):g}')


if __name__ == '__main__':
    main()
