"""트랙 B P3 붙여넣기표 생성기 — 권위 격자를 단가표 그리드 행으로 편다.

숫자를 사람이나 모델이 옮겨 적지 않는다. 권위 xlsx 를 직접 읽어 격자를 펴고,
그리드 컬럼 순서(적용일 · <use_dims 순서> · 단가/합가/고정 · 비고)에 맞춰 CSV 로 낸다.
머리행이 2단(방식 × 단면/양면)인 블록은 1단을 forward-fill 해서 조합을 만든다.
"""
import csv, sys, openpyxl

WT = '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34'
BASE = f'{WT}/_workspace/price-setup'
XLSX = '/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx'

PRICE_TITLE = {'PRICE_TYPE.01': '단가', 'PRICE_TYPE.02': '합가', 'PRICE_TYPE.03': '고정'}
LABEL = {'plt_siz_cd': '판형사이즈', 'print_opt_cd': '인쇄옵션', 'proc_cd': '공정',
         'coat_side_cnt': '코팅면수', 'spot_side_cnt': '별색면수', 'min_qty': '수량(이상)'}

# 1단 머리 라벨 → 축값. 전부 P1 실측(t34b/P1-AXIS-260903.md)에서 확정된 코드다.
SIDE = {'단면': 1, '양면': 2}                       # 2단 머리(면수)
PRINT_OPT = {('흑백(1도)', 1): 'POPT_000008', ('흑백(1도)', 2): 'POPT_000009',
             ('칼라(CMYK)', 1): 'POPT_000001', ('칼라(CMYK)', 2): 'POPT_000002'}
SPOT = {'별색(화이트)': 'PROC_000008', '별색(클리어)': 'PROC_000009',
        '별색(핑크)': 'PROC_000010', '별색(금색)': 'PROC_000011', '별색(은색)': 'PROC_000012'}
COAT = {'무광코팅': 'PROC_000015', '유광코팅': 'PROC_000014'}
# B14 r48 권위 오기(코드 대신 이름) 보정 — 이름은 마스터에서 유일 매칭.
PROC_BY_NAME = {'2구 6mm 타공': 'PROC_000127'}

BLOCKS = {
  'PRINT_SUPERA3_CMYK':      dict(sheet='디지털인쇄비', code_r=2, kind='print', h1=4, h2=5, d0=6,
                                  plt='SIZ_000499', proc='PROC_000004', prc='PRICE_TYPE.01'),
  'PRINT_WIDE_CMYK':         dict(sheet='디지털인쇄비', code_r=64, kind='print', h1=66, h2=67, d0=68,
                                  plt='SIZ_000475', proc='PROC_000004', prc='PRICE_TYPE.01'),
  'PRINT_SUPERA3_SPOT':      dict(sheet='디지털인쇄비', code_r=126, kind='spot', h1=128, h2=129, d0=130,
                                  plt='SIZ_000499', prc='PRICE_TYPE.01'),
  'COAT_SUPERA3_LAMINATING': dict(sheet='코팅', code_r=2, kind='coat', h1=4, h2=5, d0=6,
                                  plt='SIZ_000499', prc='PRICE_TYPE.01'),
  'COAT_WIDE_LAMINATING':    dict(sheet='코팅', code_r=34, kind='coat', h1=36, h2=37, d0=38,
                                  plt='SIZ_000475', prc='PRICE_TYPE.01'),
  'FOLD_CARD_PROCESSING':    dict(sheet='접지옵션', code_r=2, kind='proc', h1=4, h2=5, d0=6,
                                  prc='PRICE_TYPE.03'),
  'FOLD_LEAFLLET_PROCESSING':dict(sheet='접지옵션', code_r=59, kind='proc', h1=61, h2=62, d0=63,
                                  prc='PRICE_TYPE.03'),
  'PUNCHING_PROCESSING':     dict(sheet='커팅타공', code_r=45, kind='proc', h1=47, h2=48, d0=49,
                                  prc='PRICE_TYPE.02'),
}
DIMS = {  # 그릇 use_dims 순서 그대로(proc_grp 토큰 제외)
  'print': ['proc_cd', 'plt_siz_cd', 'print_opt_cd'],
  'spot':  ['plt_siz_cd', 'proc_cd', 'spot_side_cnt'],
  'coat':  ['proc_cd', 'plt_siz_cd', 'coat_side_cnt'],
  'proc':  ['proc_cd'],
}


def txt(ws, r, c):
    v = ws.cell(r, c).value
    return '' if v is None else str(v).strip()


def num(v):
    if v is None or isinstance(v, str) and not v.strip():
        return None
    try:
        return float(v)
    except (TypeError, ValueError):
        return None


def columns(ws, b):
    """열 → 축값 dict. 2단 머리는 1단 forward-fill."""
    out, cur = [], ''
    for c in range(2, ws.max_column + 1):
        lv1 = txt(ws, b['h1'], c) or (cur if b['kind'] != 'proc' else '')
        if b['kind'] == 'proc':
            name, code = txt(ws, b['h1'], c), txt(ws, b['h2'], c)
            if not name:
                continue
            if not code.startswith('PROC_'):
                code = PROC_BY_NAME.get(code) or PROC_BY_NAME.get(name)
                if not code:
                    sys.exit(f'★ 공정코드 미해결: {name!r}/{txt(ws, b["h2"], c)!r}')
                print(f'   · 권위 오기 보정: {name} → {code} (이름 유일매칭)', file=sys.stderr)
            out.append((c, {'proc_cd': code}))
            continue
        cur = lv1
        side = SIDE.get(txt(ws, b['h2'], c))
        if not cur or side is None:
            continue
        if b['kind'] == 'print':
            key = PRINT_OPT.get((cur, side))
            if not key:
                sys.exit(f'★ 인쇄옵션 미해결: {cur!r}/{side}')
            out.append((c, {'proc_cd': b['proc'], 'plt_siz_cd': b['plt'], 'print_opt_cd': key}))
        elif b['kind'] == 'spot':
            code = SPOT.get(cur)
            if not code:
                sys.exit(f'★ 별색 미해결: {cur!r}')
            out.append((c, {'plt_siz_cd': b['plt'], 'proc_cd': code, 'spot_side_cnt': side}))
        else:  # coat
            code = COAT.get(cur)
            if not code:
                sys.exit(f'★ 코팅 미해결: {cur!r}')
            out.append((c, {'proc_cd': code, 'plt_siz_cd': b['plt'], 'coat_side_cnt': side}))
    return out


def build(code):
    b = BLOCKS[code]
    wb = openpyxl.load_workbook(XLSX, data_only=True)
    ws = wb[b['sheet']]
    got = txt(ws, b['code_r'], 2)
    print(f'[{code}] 시트 {b["sheet"]} r{b["code_r"]} code={got!r}', file=sys.stderr)
    cols = columns(ws, b)
    dims = DIMS[b['kind']]
    ptitle = PRICE_TITLE[b['prc']]
    hdr = ['적용일'] + [LABEL[d] for d in dims] + [LABEL['min_qty'], ptitle, '비고']
    rows, r, blanks = [], b['d0'], 0
    while r <= ws.max_row and blanks < 2:
        q = num(ws.cell(r, 1).value)
        if q is None:
            blanks += 1
            r += 1
            continue
        blanks = 0
        for c, ax in cols:
            p = num(ws.cell(r, c).value)
            if p is None:
                continue
            rows.append([''] + [ax[d] for d in dims] + [int(q), p, ''])
        r += 1
    out = f'{BASE}/t34b/grid/{code}.csv'
    with open(out, 'w', newline='') as f:
        w = csv.writer(f)
        w.writerow(hdr)
        w.writerows(rows)
    qs = sorted({x[len(dims) + 1] for x in rows})
    print(f'[{code}] 열 {len(cols)} · 수량구간 {len(qs)}({qs[0]}~{qs[-1]}) · 행 {len(rows)} → {out}',
          file=sys.stderr)
    print(f'[{code}] 머리: {hdr}', file=sys.stderr)


if __name__ == '__main__':
    import os
    os.makedirs(f'{BASE}/t34b/grid', exist_ok=True)
    for c in (sys.argv[1:] or list(BLOCKS)):
        build(c)
