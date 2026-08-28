"""전 시트 2차원 격자 조사 — 전치가 생길 수 있는 자리를 전수로 찾는다.

무엇을 하나
    `parse_excel.py` 가 「포스터사인」 한 시트에만 적용하던 블록 탐지 규약
    (A열 제목 + 다음 행 A열이 'X / Y' 축 라벨)을 **19개 시트 전부**에 돌린다.

왜 필요한가
    전치는 **두 축이 같은 종류(둘 다 치수)** 일 때만 생기고, 그때만 값이 조용히 뒤바뀐다.
    아크릴이 그랬듯 격자가 대칭이면 값만 봐서는 드러나지 않는다(M4-18).
    그래서 「어느 블록이 전치 가능한가」를 먼저 전수로 세어야 검사 범위가 닫힌다.

규약
    · 값을 옮겨 적지 않는다 — 셀에서 그대로 읽는다(AC-PC-011).
    · 판정하지 않는다. 이 스크립트는 **조사**만 한다.
"""
import re
import sys
import collections
import openpyxl

SRC = 'docs/huni/후니프린팅_인쇄상품_가격표_260822_1.xlsx'


def num(v):
    m = re.search(r'[\d.]+', str(v) if v is not None else '')
    return float(m.group()) if m else None


def kind(v):
    """라벨 생김새로 축 종류를 판별한다 — 축 이름 순서를 믿지 않는다(diff.py 와 같은 규약)."""
    s = str(v).strip()
    if re.fullmatch(r'\d+(\.\d+)?\s*mm', s, re.I):
        return 'mm'
    if re.fullmatch(r'\d+(\.\d+)?', s):
        return 'num'
    if re.fullmatch(r'\*?[A-Z]\d+(절|)', s, re.I):
        return 'siz'
    return 'txt'


def blocks(ws, maxr, maxc):
    r = 1
    while r <= maxr:
        a = ws.cell(r, 1).value
        nxt = ws.cell(r + 1, 1).value
        if isinstance(a, str) and a.strip() and isinstance(nxt, str) and '/' in nxt:
            hdr = r + 1
            cols = []
            for c in range(2, maxc + 1):
                v = ws.cell(hdr, c).value
                if v in (None, ''):
                    break
                cols.append((c, str(v).strip()))
            body = []
            rr = hdr + 1
            while rr <= maxr:
                rl = ws.cell(rr, 1).value
                if rl in (None, ''):
                    break
                body.append((rr, str(rl).strip()))
                rr += 1
            if cols and body:
                yield a.strip(), nxt.strip(), cols, body
                r = rr
                continue
        r += 1


def main():
    wb = openpyxl.load_workbook(SRC, data_only=True)
    tot = collections.Counter()
    print(f'{"시트":<22}{"블록":<40}{"축 표기":<16}{"행축":>10}{"열축":>10}  전치가능?')
    print('-' * 116)
    for name in wb.sheetnames:
        ws = wb[name]
        maxr, maxc = ws.max_row, ws.max_column
        for title, axis, cols, body in blocks(ws, maxr, maxc):
            rk = collections.Counter(kind(lb) for _, lb in body).most_common(1)[0][0]
            ck = collections.Counter(kind(lb) for _, lb in cols).most_common(1)[0][0]
            R = sorted({num(lb) for _, lb in body} - {None})
            C = sorted({num(lb) for _, lb in cols} - {None})
            # 전치 가능 = 두 축이 같은 종류이고, 둘 다 치수(mm) 이며, 구간집합이 다르다
            risky = (rk == ck == 'mm')
            tot['blocks'] += 1
            if risky:
                tot['risky'] += 1
                sym = '구간집합 동일(대칭)' if set(R) == set(C) else '구간집합 다름'
                mark = f'❗ 예 — {sym}'
            else:
                mark = f'아니오 ({rk}/{ck})'
            rr = f'{min(R):.0f}~{max(R):.0f}({len(R)})' if R else f'{rk}({len(body)})'
            cc = f'{min(C):.0f}~{max(C):.0f}({len(C)})' if C else f'{ck}({len(cols)})'
            print(f'{name:<22}{title[:38]:<40}{axis[:14]:<16}{rr:>10}{cc:>10}  {mark}')
    print('-' * 116)
    print(f'블록 {tot["blocks"]} · 전치 가능(두 축 모두 치수) {tot["risky"]}')
    return 0


if __name__ == '__main__':
    sys.exit(main())
