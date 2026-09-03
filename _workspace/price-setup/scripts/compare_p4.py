"""트랙 B P4 — 기존 7블록(B8~B13·B15) 권위 ↔ 라이브 대조. 읽기 전용, 아무것도 바꾸지 않는다."""
import sys, json, openpyxl
sys.path.insert(0, '/Users/innojini/Dev/HuniWeb/.claude/worktrees/t34/_workspace/price-setup/scripts')
import db

XLSX = '/Users/innojini/Dev/HuniWeb/docs/huni/후니프린팅_인쇄상품_가격표_260902_2.xlsx'
ENV_SIZ = {'티켓봉투': 'SIZ_000191', '소봉투': 'SIZ_000192',
           '자켓봉투': 'SIZ_000193', '대봉투': 'SIZ_000194'}
ENV_MAT = {'모조 120g': ['MAT_000709'],
           '레자크체크백색 110g / 레자크줄무늬백색 110g': ['MAT_000595', 'MAT_000596']}

# (블록, 그릇, 시트, 머리행, 데이터 시작행, 수량열, {열: 축값dict}, 라이브 키 컬럼)
BLOCKS = [
 ('B8  귀돌이',        'COMP_PP_CORNER_RIGHT', '인쇄후가공', 5, 1,
  {2: {'proc_cd':'PROC_000027'}, 3: {'proc_cd':'PROC_000028'}}, ['proc_cd']),
 ('B9  오시',          'COMP_PP_CREASE_1L',    '인쇄후가공', 26, 1,
  {2: {'proc_cd':'PROC_000090','줄수':1}, 3: {'proc_cd':'PROC_000090','줄수':2},
   4: {'proc_cd':'PROC_000090','줄수':3}}, ['proc_cd']),
 ('B10 미싱',          'COMP_PP_PERF_1L',      '인쇄후가공', 26, 6,
  {7: {'proc_cd':'PROC_000086','줄수':1}, 8: {'proc_cd':'PROC_000086','줄수':2},
   9: {'proc_cd':'PROC_000086','줄수':3}}, ['proc_cd']),
 ('B11 가변텍스트',    'COMP_PP_VARTEXT_1EA',  '인쇄후가공', 50, 1,
  {2: {'proc_cd':'PROC_000031','개수':1}, 3: {'proc_cd':'PROC_000031','개수':2},
   4: {'proc_cd':'PROC_000031','개수':3}}, ['proc_cd']),
 ('B12 가변이미지',    'COMP_PP_VARIMG_1EA',   '인쇄후가공', 50, 6,
  {7: {'proc_cd':'PROC_000032','개수':1}, 8: {'proc_cd':'PROC_000032','개수':2},
   9: {'proc_cd':'PROC_000032','개수':3}}, ['proc_cd']),
 ('B13 완칼(국4절)',   'COMP_CUT_FULL_DIECUT', '커팅타공',   5, 1,
  {2: {'proc_cd':'PROC_000123','plt_siz_cd':'SIZ_000499'}}, ['proc_cd','plt_siz_cd']),
]


def qty(v):
    """'101~300' → 101 · 1.0 → 1. 권위의 구간 라벨을 하한으로 읽는다."""
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


def authority(sheet, r0, qcol, cols):
    ws = openpyxl.load_workbook(XLSX, data_only=True)[sheet]
    out, r, blank = {}, r0, 0
    while r <= ws.max_row and blank < 2:
        q = qty(ws.cell(r, qcol).value)
        if q is None:
            blank += 1; r += 1; continue
        blank = 0
        for c, ax in cols.items():
            v = ws.cell(r, c).value
            if v is None or isinstance(v, str) and not v.strip():
                continue
            key = tuple(sorted((k, str(x)) for k, x in ax.items())) + (('min_qty', str(q)),)
            out[key] = float(v)
        r += 1
    return out


def live_rows(comp, keycols):
    sel = ', '.join(f"coalesce({c}::text,'')" for c in keycols)
    out = {}
    for ln in db.q(f"SELECT {sel}, coalesce(dim_vals::text,'{{}}'), min_qty, unit_price "
                   f"FROM t_prc_component_prices WHERE comp_cd='{comp}'", tuples=True).splitlines():
        if not ln.strip():
            continue
        f = ln.split('\t')
        ax = dict(zip(keycols, f[:len(keycols)]))
        ax.update({k: str(v) for k, v in json.loads(f[len(keycols)]).items()})
        key = tuple(sorted(ax.items())) + (('min_qty', str(int(float(f[-2])))),)
        out[key] = float(f[-1])
    return out


print('== P4 기존 블록 권위 ↔ 라이브 대조 (읽기만 · 변경 0) ==\n')
print(f"{'블록':18} {'권위':>5} {'라이브':>6} {'공통':>5} {'권위만':>6} {'라이브만':>8} {'값차이':>6}")
for label, comp, sheet, r0, qcol, cols, keycols in BLOCKS:
    A = authority(sheet, r0, qcol, cols)
    L = live_rows(comp, keycols)
    both = set(A) & set(L)
    diff = [k for k in both if A[k] != L[k]]
    print(f"{label:18} {len(A):5} {len(L):6} {len(both):5} {len(set(A)-set(L)):6} "
          f"{len(set(L)-set(A)):8} {len(diff):6}" + ('  ← 값차이 있음' if diff else ''))
    for k in diff[:3]:
        print('      ', dict(k), '권위=', A[k], '라이브=', L[k])

# B15 봉투 — 2단 머리(옵션 × 소재) · 소재 1칸이 자재 2종을 덮는다
ws = openpyxl.load_workbook(XLSX, data_only=True)['봉투제작']
opt, A = '', {}
cols = {}
for c in range(2, ws.max_column + 1):
    o = (ws.cell(4, c).value or '').strip() if ws.cell(4, c).value else ''
    if o:
        opt = o
    m = (ws.cell(5, c).value or '').strip() if ws.cell(5, c).value else ''
    if opt and m and opt in ENV_SIZ and m in ENV_MAT:
        cols[c] = (ENV_SIZ[opt], ENV_MAT[m])
r, blank = 6, 0
while r <= ws.max_row and blank < 2:
    q = qty(ws.cell(r, 1).value)
    if q is None:
        blank += 1; r += 1; continue
    blank = 0
    for c, (siz, mats) in cols.items():
        v = ws.cell(r, c).value
        if v is None:
            continue
        for mat in mats:      # 소재 1칸 → 자재 2행으로 편다
            A[(siz, mat, q)] = float(v)
    r += 1
L = {}
for ln in db.q("SELECT coalesce(siz_cd,''), coalesce(mat_cd,''), min_qty, unit_price, "
               "to_char(coalesce(upd_dt,reg_dt),'MM-DD HH24:MI') "
               "FROM t_prc_component_prices WHERE comp_cd='COMP_ENV_MAKING'", tuples=True).splitlines():
    if ln.strip():
        f = ln.split('\t')
        L[(f[0], f[1], int(float(f[2])))] = (float(f[3]), f[4])
both = set(A) & set(L)
diff = [k for k in both if A[k] != L[k][0]]
print(f"{'B15 봉투제작':18} {len(A):5} {len(L):6} {len(both):5} {len(set(A)-set(L)):6} "
      f"{len(set(L)-set(A)):8} {len(diff):6}" + ('  ← 값차이 있음' if diff else ''))
for k in diff[:3]:
    print('      ', k, '권위=', A[k], '라이브=', L[k])
ts = {}
for k, (_, t) in L.items():
    ts[t[:5]] = ts.get(t[:5], 0) + 1
print('       봉투 라이브 행 최종수정일 분포:', dict(sorted(ts.items())))
