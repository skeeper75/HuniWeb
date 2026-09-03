"""트랙 B P6 붙여넣기표 — 권위 격자를 기존 3그릇의 화면 열 모양 그대로 편다.

숫자·구간은 권위 xlsx 직독. 적용일은 기존 행 값(2026-06-01)을 그대로 승계하고,
비고는 화면에서 실측한 기존 서식을 같은 규칙으로 채운다(수량이 바뀌면 문구도 따라간다).
"""
import csv, os, openpyxl

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
BASE = f'{WT}/_workspace/price-setup'
XLSX = '/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx'
APPLY = '2026-06-01'          # 기존 행 실측값 승계 — 적용일 일괄 설정은 쓰지 않는다


def qty(v):
    """'101~300' → 101(하한) · 1.0 → 1. 권위 구간 라벨은 하한이 min_qty 다."""
    if v is None:
        return None
    if isinstance(v, (int, float)):
        return int(v)
    s = str(v).strip().replace(',', '')
    if '~' in s:
        s = s.split('~')[0]
    try:
        return int(float(s))
    except ValueError:
        return None


def rows_of(ws, r0, qcol, cols):
    out, r, blank = [], r0, 0
    while r <= ws.max_row and blank < 2:
        q = qty(ws.cell(r, qcol).value)
        if q is None:
            blank += 1; r += 1; continue
        blank = 0
        for c, meta in cols:
            v = ws.cell(r, c).value
            if v is None or (isinstance(v, str) and not v.strip()):
                continue
            out.append((q, meta, float(v)))
        r += 1
    return out


def main():
    wb = openpyxl.load_workbook(XLSX, data_only=True)
    os.makedirs(f'{BASE}/t34b/p6grid', exist_ok=True)
    ws = wb['인쇄후가공']

    # 귀돌이 — 적용일|공정|수량(이상)|고정|비고
    cols = [(2, ('PROC_000027', '직각모서리')), (3, ('PROC_000028', '둥근모서리'))]
    body = [[APPLY, m[0], q, f'{v:.2f}',
             f'모서리/{m[1]} 주문수량 {q}건 이상 / 작업 1건 고정 금액']
            for q, m, v in rows_of(ws, 5, 1, cols)]
    write('COMP_PP_CORNER_RIGHT', ['적용일', '공정', '수량(이상)', '고정', '비고'], body)

    # 오시·미싱 — 적용일|공정|줄수 (줄)|수량(이상)|고정|비고
    for comp, proc, label, c0 in (('COMP_PP_CREASE_1L', 'PROC_000090', '오시', 1),
                                  ('COMP_PP_PERF_1L', 'PROC_000086', '미싱', 6)):
        cols = [(c0 + i, (proc, i)) for i in (1, 2, 3)]
        body = [[APPLY, m[0], m[1], q, f'{v:.2f}',
                 f'{label}/{m[1]}줄 주문수량 {q}건 이상 / 작업 1건 고정 금액']
                for q, m, v in rows_of(ws, 26, c0, cols)]
        write(comp, ['적용일', '공정', '줄수 (줄)', '수량(이상)', '고정', '비고'], body)


def write(comp, hdr, body):
    p = f'{BASE}/t34b/p6grid/{comp}.csv'
    with open(p, 'w', newline='') as f:
        w = csv.writer(f); w.writerow(hdr); w.writerows(body)
    qs = sorted({r[hdr.index('수량(이상)')] for r in body})
    print(f'{comp:22} 행 {len(body):3} · 수량구간 {len(qs)} {qs}')


if __name__ == '__main__':
    main()
