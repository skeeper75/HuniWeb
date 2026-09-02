"""블록마다 격자를 정확히 잘라 낸다 (M1② 검증 + M3 붙여넣기표의 공통 토대).

숫자 칸을 뭉뚱그려 세면 뒤따라오는 다른 표(아크릴 수량할인 등)가 섞여 들어온다.
그래서 이름 행 다음부터 **열 구간 안에서 통째로 빈 행이 나올 때까지**를 격자로 잡고,
그 첫 행을 축 머리로 읽는다.
"""
import csv
import sys
import openpyxl

BASE = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup'
XLSX = '/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx'


def norm(v):
    return '' if v is None else str(v).strip()


def row_blank(ws, r, c0, c1):
    return all(norm(ws.cell(r, c).value) == '' for c in range(c0, c1 + 1))


def col_blank(ws, c, r0, r1):
    return all(norm(ws.cell(r, c).value) == '' for r in range(r0, r1 + 1))


def extract(ws, blk):
    c0, c1 = blk['col_from'], blk['col_to']
    # 이름 행 다음부터 시작. 앞의 빈 행은 건너뛴다.
    r = blk['code_row'] + 2
    while r <= ws.max_row and row_blank(ws, r, c0, c1):
        r += 1
    head = r
    end = head
    # 빈 행 하나로 끊지 않는다 — 반칼처럼 머리가 두 줄이고 그 아래 한 줄이 비는
    # 격자가 있어서, 한 줄만 보고 끊으면 684칸짜리 표가 통째로 0칸이 된다.
    # 빈 행이 둘 잇따를 때, 또는 다음 블록의 코드 행에 닿을 때 끊는다.
    while end + 1 <= ws.max_row:
        nxt = end + 1
        if norm(ws.cell(nxt, c0).value).lower() in ('code', '구성요소코드'):
            break
        if row_blank(ws, nxt, c0, c1) and (
                nxt + 1 > ws.max_row or row_blank(ws, nxt + 1, c0, c1)):
            break
        end = nxt
    while end > head and row_blank(ws, end, c0, c1):
        end -= 1
    # 격자와 떨어져 있는 오른쪽 덩어리는 잘라 낸다 — 통째로 빈 열이 경계다.
    for c in range(c0, c1 + 1):
        if col_blank(ws, c, head, end):
            c1 = c - 1
            break
    while c1 > c0 and col_blank(ws, c1, head, end):
        c1 -= 1
    return head, end, c0, c1


def main():
    blocks = list(csv.DictReader(open(f'{BASE}/m1/authority-blocks-trackA.csv')))
    wb = openpyxl.load_workbook(XLSX, data_only=True)
    out = []
    for b in blocks:
        ws = wb[b['sheet']]
        b['code_row'] = int(b['code_row'])
        b['col_from'] = int(b['col_from'])
        b['col_to'] = int(b['col_to'])
        head, end, c0, c1 = extract(ws, b)
        # 머리 행과 라벨 열은 세지 않는다 — 수량 라벨(1.0 · 2.0 …)이 숫자여서
        # 함께 세면 값 칸이 실제보다 부풀어 오른다.
        n_num = sum(1 for r in range(head + 1, end + 1) for c in range(c0 + 1, c1 + 1)
                    if isinstance(ws.cell(r, c).value, (int, float))
                    and not isinstance(ws.cell(r, c).value, bool))
        axis_head = [norm(ws.cell(head, c).value) for c in range(c0, c1 + 1)]
        row_labels = [norm(ws.cell(r, c0).value) for r in range(head + 1, end + 1)]
        out.append(dict(
            sheet=b['sheet'], code=b['code_as_written'].upper(), name=b['name'],
            grid_head_row=head, grid_last_row=end, grid_col_from=c0, grid_col_to=c1,
            data_rows=end - head, data_cols=c1 - c0,
            numeric_cells=n_num,
            axis_header=' | '.join(x for x in axis_head if x),
            row_labels=' | '.join(x for x in row_labels if x)))

    path = f'{BASE}/m1/authority-grids-trackA.csv'
    with open(path, 'w', newline='') as f:
        w = csv.DictWriter(f, fieldnames=list(out[0].keys()))
        w.writeheader()
        w.writerows(out)
    print(f'{len(out)}블록 격자 -> {path}', file=sys.stderr)
    for o in out:
        print(f"{o['sheet']:6s} {o['code']:<32s} r{o['grid_head_row']}~r{o['grid_last_row']} "
              f"c{o['grid_col_from']}~c{o['grid_col_to']}  "
              f"{o['data_rows']}행×{o['data_cols']}열  숫자 {o['numeric_cells']:>4d}")


if __name__ == '__main__':
    main()
