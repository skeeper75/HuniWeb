"""권위 격자(엑셀) ↔ 라이브 단가 **셀 단위 값** 대조 — 결정론, LLM 전사 없음.

이전 판(개수 대조)의 구멍
    「엑셀 26셀 vs 라이브 26행」처럼 개수만 셌다. 개수가 같아도 값이 틀릴 수 있고,
    2026-08-22 전수 감사가 놓친 결함이 정확히 그 종류(「0 이 아닌 잘못된 값」)다.
    AC-PC-011 은 「각 단가행이 권위 엑셀 **셀과 일치**」를 요구한다 — 개수 일치는 그 증거가 아니다.

이 판의 규약
    · 분모는 **라이브(상품뷰어)** 다 (AC-PC-002). 권위 엑셀을 분모로 삼지 않는다.
      엑셀에만 있고 라이브에 상품 자체가 없으면 그것은 결함이 아니라 범위 밖이다(§4.2).
    · 블록↔상품 대응은 **하드코딩하지 않는다**. 라이브 상품명에서 유도하고,
      유도 실패한 블록은 침묵하지 않고 보고한다.
    · 축 라벨은 **순서를 가정하지 않고 생김새로** 판별한다.
      「사이즈 / 수량」 축의 실제 행 라벨이 '1'(수량), 열 라벨이 'A3'(사이즈)이라
      축 이름 순서를 믿으면 전부 어긋난다.
    · **추가상품 템플릿 경로**를 포함한다 — 거치대·천정고리 과금이 여기 산다.
    · 라이브는 SELECT 만. 쓰기 질의 없음(AC-PC-014).

사용
    python3 diff.py                # 최신 스냅샷으로 대조
    python3 diff.py --refresh      # 라이브에서 스냅샷을 새로 뜬 뒤 대조
"""
import argparse
import collections
import csv
import datetime as dt
import glob
import os
import re
import subprocess
import sys

HERE = '_workspace/postersign-audit'
AUTH = f'{HERE}/authority.csv'

# ── 라이브 스냅샷 질의 (SELECT 전용) ────────────────────────────────────────────
# 본품: 상품 → 공식 → 구성요소 → 단가행
SQL_MAIN = """
SELECT 'main' AS kind, ppf.prd_cd, p.prd_nm, ppf.frm_cd, fc.disp_seq,
       pc.comp_cd, pc.comp_nm, pc.prc_typ_cd,
       COALESCE(cp.siz_cd,'') , COALESCE(s.siz_nm,''),
       COALESCE(cp.siz_width::text,''), COALESCE(cp.siz_height::text,''),
       COALESCE(cp.opt_cd,''), COALESCE(cp.mat_cd,''), COALESCE(cp.proc_cd,''),
       COALESCE(cp.min_qty::text,''), COALESCE(cp.unit_price::text,''),
       COALESCE(o.opt_nm,''), COALESCE(m.mat_nm,'')
FROM t_prd_product_price_formulas ppf
JOIN t_prd_products p           ON p.prd_cd = ppf.prd_cd
JOIN t_prc_formula_components fc ON fc.frm_cd = ppf.frm_cd
JOIN t_prc_price_components pc  ON pc.comp_cd = fc.comp_cd AND COALESCE(pc.del_yn,'N') <> 'Y'
LEFT JOIN t_prc_component_prices cp ON cp.comp_cd = pc.comp_cd
LEFT JOIN t_siz_sizes s         ON s.siz_cd = cp.siz_cd
LEFT JOIN t_prd_product_options o ON o.prd_cd = ppf.prd_cd AND o.opt_cd = cp.opt_cd
                                 AND COALESCE(o.del_yn,'N') <> 'Y'
LEFT JOIN t_mat_materials m     ON m.mat_cd = cp.mat_cd
WHERE ppf.prd_cd BETWEEN :LO AND :HI
"""

# 추가상품: 상품 → 템플릿 → 템플릿 단가 (본품과 다른 경로)
SQL_ADDON = """
SELECT 'addon' AS kind, a.prd_cd, p.prd_nm, '' , a.disp_seq,
       t.tmpl_cd, t.tmpl_nm, '',
       '', '', '', '', '', '', '',
       COALESCE(t.dflt_qty::text,''), COALESCE(tp.unit_price::text,''), '', ''
FROM t_prd_product_addons a
JOIN t_prd_products p    ON p.prd_cd = a.prd_cd
JOIN t_prd_templates t   ON t.tmpl_cd = a.tmpl_cd AND COALESCE(t.del_yn,'N') <> 'Y'
LEFT JOIN t_prd_template_prices tp ON tp.tmpl_cd = t.tmpl_cd
WHERE a.prd_cd BETWEEN :LO AND :HI
"""

COLS = ['kind', 'prd_cd', 'prd_nm', 'frm_cd', 'disp_seq', 'comp_cd', 'comp_nm',
        'prc_typ_cd', 'siz_cd', 'siz_nm', 'siz_width', 'siz_height',
        'opt_cd', 'mat_cd', 'proc_cd', 'min_qty', 'unit_price', 'opt_nm', 'mat_nm']


def refresh(lo, hi):
    """라이브에서 스냅샷을 새로 뜬다. 반환: 기록한 파일 경로."""
    env = dict(os.environ)
    for line in open('.env.local', encoding='utf-8'):
        if '=' in line and not line.lstrip().startswith('#'):
            k, _, v = line.partition('=')
            env.setdefault(k.strip(), v.strip().strip('"').strip("'"))
    env['PGPASSWORD'] = env['RAILWAY_DB_PASSWORD']
    sql = '\nUNION ALL\n'.join(
        q.replace(':LO', f"'{lo}'").replace(':HI', f"'{hi}'") for q in (SQL_MAIN, SQL_ADDON)
    ) + '\nORDER BY 2, 1, 5, 6;'
    out = subprocess.run(
        ['psql', '-h', env['RAILWAY_DB_HOST'], '-p', env['RAILWAY_DB_PORT'],
         '-U', env['RAILWAY_DB_USER'], '-d', env['RAILWAY_DB_NAME'],
         '-A', '-F', '|', '-t', '-c', sql],
        env=env, capture_output=True, text=True, check=True).stdout

    stamp = dt.datetime.now(dt.timezone.utc).strftime('%y%m%d-%H%M')
    path = f'{HERE}/live-snapshot-{stamp}.csv'
    n = 0
    with open(path, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(COLS)
        for line in out.splitlines():
            if not line.strip():
                continue
            parts = line.split('|')
            if len(parts) == len(COLS):
                w.writerow(parts)
                n += 1
    print(f'스냅샷 {n}행 → {path}  (실측 {dt.datetime.now(dt.timezone.utc):%Y-%m-%d %H:%M:%S} UTC)')
    return path


def latest_snapshot():
    # 파일명 정렬은 쓰지 않는다 — 'live-snapshot-260828.csv' 와
    # 'live-snapshot-260828-1416.csv' 는 '-'(0x2D) < '.'(0x2E) 라 구판이 뒤로 정렬된다.
    files = glob.glob(f'{HERE}/live-snapshot-*.csv')
    if not files:
        sys.exit('스냅샷이 없습니다. --refresh 로 먼저 뜨세요.')
    return max(files, key=os.path.getmtime)


# ── 용어 별칭 — 권위 엑셀 표기 ↔ 라이브 표기 ────────────────────────────────
# 값은 같은데 이름만 다른 것들. 별칭표 없이 대조하면 전부 거짓 결함으로 잡힌다.
# 등재 근거는 라이브 t_prd_product_options.opt_nm 실측(2026-08-28)이며,
# 새 별칭은 실측 확인 뒤에만 추가한다 — 추정 등재 금지.
ALIAS = [
    ('타공', '아일렛'),      # 권위 「타공(4개)」 = 라이브 「아일렛(4구)」 — 지니 지적 260828
    ('테잎', '테입'),        # 「양면테잎」 = 「양면테입」
    ('개)', '구)'),          # 「(4개)」 = 「(4구)」
]


def apply_alias(s):
    for src, dst in ALIAS:
        s = s.replace(src, dst)
    return s


# 사이즈 라벨의 치수 괄호만 떼어낸다: 'A3 (297x420mm)' → 'A3', '5x7(127x178mm)' → '5x7'.
# 괄호 안이 치수(가로x세로 + mm)일 때만 떼며, '화이트포맥스(3mm)' 처럼 두께를 담은
# 괄호는 그대로 둔다 — 떼면 3mm/5mm 구분이 사라져 서로 다른 단가가 한 셀로 뭉친다.
DIM_PAREN = re.compile(r'\s*\(\s*\d+\s*[xX×]\s*\d+\s*mm\s*\)\s*$')


# ── 라벨 판별: 축 이름 순서를 믿지 않고 라벨 생김새로 종류를 정한다 ──────────────
def label_kind(v):
    s = DIM_PAREN.sub('', apply_alias(str(v).strip()))
    if re.fullmatch(r'\d+(\.\d+)?\s*mm', s, re.I):
        return 'mm', re.sub(r'[^\d.]', '', s).rstrip('.')
    if re.fullmatch(r'\d+(\.\d+)?', s):
        return 'qty', s.rstrip('0').rstrip('.') if '.' in s else s
    if re.fullmatch(r'\*?[A-Z]\d+(절|)', s, re.I) or s.startswith('*'):
        return 'siz', s.lstrip('*')
    return 'txt', s


def cell_key(row_label, col_label):
    """(종류, 값) 쌍 2개를 집합으로. 축 이름 순서에 의존하지 않는다.

    [주의] 무순서 집합이라 **전치를 못 잡는다.** 두 축이 같은 종류(둘 다 'mm')면
    (가로1400, 세로900) 과 (가로900, 세로1400) 이 같은 키가 된다. 실제로 이 맹점 때문에
    포스터·현수막 13상품의 가로/세로 전치 적재가 축③ PASS 로 통과했다(M4-16).
    순서 의존으로 되돌리면 M4-3 의 「축 이름 순서 가정」 오판이 되살아나므로,
    매칭은 이대로 두고 **방향은 axis_orient() 로 따로 검사한다.**
    """
    return frozenset([label_kind(row_label), label_kind(col_label)])


def axis_orient(row_label, col_label, live_row):
    """권위 (가로=row, 세로=col) 와 라이브 (siz_width, siz_height) 의 방향을 대조한다.

    반환: 'ok' | 'transposed' | None(검사 대상 아님)

    검사 대상은 **두 축이 모두 치수(mm)이고 값이 서로 다른** 셀뿐이다.
    가로=세로인 대각선 셀은 전치돼 있어도 구분되지 않으므로 판정하지 않는다 —
    구분 못 하는 것을 ok 로 세면 전치가 그만큼 묻힌다.
    """
    kr, kc = label_kind(row_label), label_kind(col_label)
    if kr[0] != 'mm' or kc[0] != 'mm':
        return None
    g, s = num(kr[1]), num(kc[1])
    w, h = num(live_row.get('siz_width')), num(live_row.get('siz_height'))
    if None in (g, s, w, h) or g == s:
        return None
    if (w, h) == (g, s):
        return 'ok'
    if (w, h) == (s, g):
        return 'transposed'
    return None


def norm_name(s):
    return re.sub(r'[\s()（）/·]', '', str(s))


# ── 자재명·옵션명 후보 매칭 ─────────────────────────────────────────────────
# 권위 「화이트보드」 ↔ 라이브 「A3 폼보드(화이트) 5mm」 처럼 토큰이 흩어져 있어
# 단순 치환(ALIAS)으로는 못 잇는 쌍이 있다. 여기서 하는 일은 **후보 제시**이며,
# 확정은 사람이 한다 — 규칙을 지어내 자동 확정하면 그것은 추정이고, 검증되지
# 않은 결함 주장이 된다(verification-claim-integrity §1.1). 판정은 CANDIDATE 로만 낸다.
UNIT_TOK = re.compile(r'\d+\s*mm', re.I)


def lcs_len(a, b):
    """최장 공통 부분문자열 길이 — 흩어진 토큰의 겹침 정도를 재는 값."""
    if not a or not b:
        return 0
    prev = [0] * (len(b) + 1)
    best = 0
    for ca in a:
        cur = [0] * (len(b) + 1)
        for j, cb in enumerate(b, 1):
            if ca == cb:
                cur[j] = prev[j - 1] + 1
                best = max(best, cur[j])
        prev = cur
    return best


def txt_candidate(auth_txt, live_txt):
    """후보 자격 판정. 통과하면 겹침 점수, 아니면 0."""
    a, b = norm_name(auth_txt), norm_name(live_txt)
    # 두께·치수 토큰은 권위 쪽 것이 라이브에 전부 있어야 한다.
    # 없으면 3mm 단가와 5mm 단가가 한 후보로 뭉쳐 서로 다른 값이 섞인다.
    for t in UNIT_TOK.findall(auth_txt):
        if t.replace(' ', '') not in b:
            return 0
    n = lcs_len(a, b)
    return n if n >= 2 else 0


def num(v):
    try:
        return round(float(v))
    except (TypeError, ValueError):
        return None


def live_key(r):
    """라이브 행이 보유한 축 **전부**를 집합으로 낸다.

    권위 셀은 이 집합의 부분집합으로 매칭한다(§부분집합 매칭).
    라이브가 권위보다 축을 더 갖는 일이 흔하기 때문이다 — 예: 권위는 가로/세로
    2축인데 라이브 단가행에는 min_qty=1 이 함께 붙어 있다. 이 1을 축으로 세면
    권위 키와 영영 만나지 못한다(초판의 오보고 원인).
    """
    parts = set()
    for f in ('siz_width', 'siz_height'):
        if r[f] and num(r[f]):
            parts.add(('mm', str(num(r[f]))))
    if r['siz_nm']:
        parts.add(label_kind(r['siz_nm']))
    if r['min_qty'] and num(r['min_qty']):
        parts.add(('qty', str(num(r['min_qty']))))
    for f in ('opt_nm', 'mat_nm'):
        if r.get(f):
            parts.add(label_kind(r[f]))
    return frozenset(parts)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--refresh', action='store_true', help='라이브에서 스냅샷을 새로 뜬다')
    ap.add_argument('--lo', default='PRD_000118', help='대상 prd_cd 하한')
    ap.add_argument('--hi', default='PRD_000145', help='대상 prd_cd 상한')
    ap.add_argument('--emit', metavar='CSV',
                    help='상품별 축③ 판정을 기계판독 CSV 로 내보낸다(축③×축④ 결합용)')
    args = ap.parse_args()

    snap = refresh(args.lo, args.hi) if args.refresh else latest_snapshot()
    print(f'스냅샷: {snap}')

    auth = list(csv.DictReader(open(AUTH, encoding='utf-8')))
    live = [r for r in csv.DictReader(open(snap, encoding='utf-8'))]
    if 'kind' not in (live[0] if live else {}):
        sys.exit('구판 스냅샷입니다(kind 열 없음). --refresh 로 새로 뜨세요.')

    # ── 분모 = 라이브 상품 (AC-PC-002) ────────────────────────────────────────
    live_prd = {}                       # prd_cd -> prd_nm
    for r in live:
        live_prd[r['prd_cd']] = r['prd_nm']

    # ── 블록 → prd_cd 유도 (하드코딩 없음) ────────────────────────────────────
    block2prd = collections.defaultdict(list)
    unresolved = []
    for block in sorted({r['block'] for r in auth}):
        nb = norm_name(block)
        hits = [c for c, n in live_prd.items() if norm_name(n) and norm_name(n) in nb]
        if hits:
            block2prd[block] = sorted(hits)
        else:
            unresolved.append(block)

    # ── 셀 대조 ──────────────────────────────────────────────────────────────
    live_cells = collections.defaultdict(list)   # prd_cd -> [(key, price)]
    for r in live:
        if r['kind'] != 'main' or not r['unit_price']:
            continue
        # 원본 행을 함께 들고 간다 — 방향 검사(axis_orient)가 siz_width/siz_height 를 봐야 한다.
        live_cells[r['prd_cd']].append((live_key(r), num(r['unit_price']), r))

    findings = collections.defaultdict(list)     # verdict -> rows
    matched = collections.Counter()
    consumed = collections.defaultdict(set)      # prd_cd -> 매칭에 쓰인 라이브 행 index

    for a in auth:
        if a['kind'] != 'main':
            continue
        prds = block2prd.get(a['block'], [])
        if not prds:
            continue
        k = cell_key(a['row_label'], a['col_label'])
        want = num(a['price'])
        seen_anywhere = False
        for p in prds:
            # 부분집합 매칭: 권위 축 ⊆ 라이브 축
            got = [(i, pr, lr) for i, (lk, pr, lr) in enumerate(live_cells[p]) if k <= lk]
            if not got:
                continue
            seen_anywhere = True
            consumed[p].update(i for i, _, _ in got)
            prices = [pr for _, pr, _ in got]

            # 값이 맞아도 축 방향이 뒤집혔을 수 있다 — 무순서 키는 그것을 통과시킨다.
            #
            # [함정] 키가 무순서라 got 에는 **양쪽 방향이 모두** 걸린다. 권위에
            # (가로600,세로800) 과 (가로800,세로600) 이 둘 다 있으면 라이브에도 둘 다 있고,
            # 그중 반대 방향 행 하나만 보고 전치로 찍으면 정상 격자를 전건 오탐한다
            # (실제로 교정 후 146건 오탐이 났다).
            # 따라서 **바른 방향 행이 하나도 없을 때만** 전치로 판정한다.
            orients = [axis_orient(a['row_label'], a['col_label'], lr) for _, _, lr in got]
            if 'ok' not in orients and 'transposed' in orients:
                lr = next(lr for (_, _, lr), o in zip(got, orients) if o == 'transposed')
                findings['TRANSPOSED'].append(
                    (p, live_prd[p], a['block'],
                     f"권위 가로{a['row_label']}×세로{a['col_label']}",
                     f"라이브 가로{lr['siz_width']}×세로{lr['siz_height']}",
                     want, [lr['unit_price']]))

            if want in prices:
                matched[p] += 1
            else:
                findings['VALUE'].append(
                    (p, live_prd[p], a['block'], a['row_label'], a['col_label'], want, prices))
        if seen_anywhere:
            continue

        # 권위 축에 자유 텍스트(자재명·옵션명)가 섞이면 대응 규칙이 없다.
        # 그런 셀을 「미적재」로 세면 검증되지 않은 결함 주장이 된다.
        auth_txt = [v for t, v in k if t == 'txt']
        if not auth_txt:
            findings['MISSING'].append(
                (prds[0], live_prd.get(prds[0], '?'), a['block'],
                 a['row_label'], a['col_label'], want, None))
            continue

        rest = frozenset((t, v) for t, v in k if t != 'txt')
        best = None
        for p in prds:
            for i, (lk, pr, _lr) in enumerate(live_cells[p]):
                if not rest <= lk:                       # 사이즈·수량 축이 먼저 맞아야 한다
                    continue
                if i in consumed[p]:
                    # 이미 다른 권위 셀이 가져간 행이다. 한 단가행이 두 셀의 근거가 될 수는
                    # 없고, 빼지 않으면 겹침 동점일 때 먼저 처리된 셀이 가로챈다 —
                    # 「블랙보드」가 「…(화이트)」 행에 붙는 오매칭이 실제로 났다.
                    continue
                for lt, lv in ((t, v) for t, v in lk if t == 'txt'):
                    sc = txt_candidate(auth_txt[0], lv)
                    if sc and (best is None or sc > best[0]):
                        best = (sc, p, lv, pr, i)
        if best:
            sc, p, lv, pr, i = best
            consumed[p].add(i)
            findings['CANDIDATE'].append(
                (p, live_prd[p], a['block'], f'{a["row_label"]} × {a["col_label"]}',
                 f'↔ {lv} (겹침{sc})', want, [pr]))
        else:
            findings['UNRESOLVED'].append(
                (prds[0], live_prd.get(prds[0], '?'), a['block'],
                 a['row_label'], a['col_label'], want, None))

    # 라이브에만 있는 셀 = 어떤 권위 셀에도 걸리지 않은 단가행 (권위 근거 없음)
    for p, cells in live_cells.items():
        if p not in {q for prds in block2prd.values() for q in prds}:
            continue                       # 권위 블록이 대응되지 않은 상품은 판정 보류
        for i, (lk, pr, _lr) in enumerate(cells):
            if i not in consumed[p]:
                findings['EXTRA'].append((p, live_prd[p], '', sorted(lk), '', None, [pr]))

    # ── 추가상품 템플릿 경로 ─────────────────────────────────────────────────
    addons = [r for r in live if r['kind'] == 'addon']
    auth_addon = [a for a in auth if a['kind'] == 'addon']

    # ── 보고 ─────────────────────────────────────────────────────────────────
    print(f'\n분모(라이브 상품) {len(live_prd)}건 · 권위 블록 {len(block2prd)}개 대응 · '
          f'미대응 블록 {len(unresolved)}개')
    if unresolved:
        print('  ⚠ 유도 실패 블록:', ' · '.join(unresolved))

    print(f'\n{"판정":<9}{"건수":>5}')
    print('-' * 74)
    print(f'{"일치":<9}{sum(matched.values()):>5}')
    for v in ('VALUE', 'TRANSPOSED', 'CANDIDATE', 'MISSING', 'EXTRA', 'UNRESOLVED'):
        print(f'{v:<11}{len(findings[v]):>5}')

    for v, title in (('TRANSPOSED', '축 방향 전치 — 값은 맞아도 가로/세로가 뒤바뀌어 적재됨 (무순서 키가 통과시키는 유형)'),
                     ('VALUE', '값 불일치 — 권위·라이브 둘 다 있는데 값이 다름 (8/22 감사가 못 잡는 유형)'),
                     ('CANDIDATE', '후보 — 자재명이 흩어져 있어 기계로 확정 못 함. **사람 확정 필요**, 결함 단정 아님'),
                     ('MISSING', '권위에만 있음 — 라이브 미적재 (상품뷰어가 그 상품을 보유할 때만 결함)'),
                     ('EXTRA', '라이브에만 있음 — 권위 근거 없는 단가'),
                     ('UNRESOLVED', '판정 보류 — 대응 후보조차 못 찾음. 결함 아님')):
        rows = findings[v]
        if not rows:
            continue
        print(f'\n■ {v} ({len(rows)}) — {title}')
        by_p = collections.defaultdict(list)
        for r in rows:
            by_p[r[0]].append(r)
        for p in sorted(by_p):
            print(f'  {p} {by_p[p][0][1]}  ({len(by_p[p])}건)')
            for r in by_p[p][:6]:
                if v == 'EXTRA':
                    print(f'      키={r[3]}  라이브={r[6]}')
                else:
                    print(f'      {r[2]} [{r[3]} × {r[4]}]  권위={r[5]}  라이브={r[6]}')
            if len(by_p[p]) > 6:
                print(f'      … 외 {len(by_p[p]) - 6}건')

    # ── 축 구간집합 대조 (블록 단위) ─────────────────────────────────────────
    # 셀 단위 방향 검사(TRANSPOSED)는 권위에 (가로A,세로B)와 (가로B,세로A)가 **둘 다**
    # 있는 셀에서 판정 불가다 — 전치돼 있든 아니든 라이브 행 집합이 같기 때문이다.
    # 축의 **구간 집합**을 통째로 비교하면 그 모호함을 받지 않는다: 라이브 가로 구간이
    # 권위 세로 구간과 같고 라이브 세로 구간이 권위 가로 구간과 같으면 전치가 확정된다.
    print('\n■ 축 구간집합 대조 (블록 단위 — 셀 단위 판정 불가 구간까지 덮는다)')
    axis_bad = 0
    for block in sorted(block2prd):
        a_w = {num(label_kind(a['row_label'])[1]) for a in auth
               if a['block'] == block and a['kind'] == 'main'
               and label_kind(a['row_label'])[0] == 'mm'}
        a_h = {num(label_kind(a['col_label'])[1]) for a in auth
               if a['block'] == block and a['kind'] == 'main'
               and label_kind(a['col_label'])[0] == 'mm'}
        if not a_w or not a_h or a_w == a_h:
            continue                      # 치수 격자가 아니거나 두 축이 같으면 판정 대상 아님
        for p in block2prd[block]:
            l_w = {num(r['siz_width']) for r in live
                   if r['prd_cd'] == p and r['kind'] == 'main' and num(r['siz_width'])}
            l_h = {num(r['siz_height']) for r in live
                   if r['prd_cd'] == p and r['kind'] == 'main' and num(r['siz_height'])}
            if not l_w or not l_h:
                continue
            if (l_w, l_h) == (a_w, a_h):
                continue                  # 정상
            if (l_w, l_h) == (a_h, a_w):
                axis_bad += 1
                print(f'  ❌ 전치 {p} {live_prd[p]:<16} '
                      f'가로 권위{len(a_w)}구간(~{max(a_w):.0f}) ↔ 라이브{len(l_w)}구간(~{max(l_w):.0f})')
            else:
                print(f'  ⚠ 구간 불일치 {p} {live_prd[p]:<16} '
                      f'권위 가로{len(a_w)}·세로{len(a_h)} vs 라이브 가로{len(l_w)}·세로{len(l_h)}')
    if not axis_bad:
        print('  ✅ 전치 0건')

    print(f'\n■ 추가상품 템플릿 경로 — 라이브 {len(addons)}행 / 권위 추가옵션 {len(auth_addon)}셀')
    for r in addons:
        print(f'  {r["prd_cd"]} {r["prd_nm"]:<16} seq{r["disp_seq"]} '
              f'{r["comp_cd"]} {r["comp_nm"]:<24} {r["unit_price"] or "(단가없음)"}')

    print('\n※ 이 대조는 축 ③(값 정합)이다. 축 ④(위젯 supply 종단 대조)는 별도다 — AC-PC-013.')

    if args.emit:
        emit_axis3(args.emit, snap, live_prd, block2prd, matched, findings)
    return 0


# ── 축③ 상품별 판정 내보내기 (AC-PC-009 결합용) ────────────────────────────────
# 값은 전부 비교기 산출을 그대로 옮긴다. LLM 이 셀 값을 전사하지 않는다(AC-PC-011).
def emit_axis3(path, snap, live_prd, block2prd, matched, findings):
    covered = {q for prds in block2prd.values() for q in prds}

    # CANDIDATE 는 「사람 확정 필요」지 결함 단정이 아니다(M4-2b).
    # 다만 그 안에서 권위값과 라이브값이 실제로 어긋난 건은 값 불일치이므로 갈라 센다.
    cand_ok, cand_bad = collections.Counter(), collections.Counter()
    for p, _nm, _blk, _r, _c, want, prices in findings['CANDIDATE']:
        (cand_ok if prices and want in prices else cand_bad)[p] += 1

    per = {v: collections.Counter(r[0] for r in findings[v])
           for v in ('VALUE', 'MISSING', 'EXTRA', 'UNRESOLVED')}

    with open(path, 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(['prd_cd', 'prd_nm', 'a3_verdict', 'a3_matched', 'a3_value_mismatch',
                    'a3_candidate_ok', 'a3_candidate_mismatch', 'a3_missing',
                    'a3_extra', 'a3_unresolved', 'a3_basis'])
        for p in sorted(live_prd):
            bad = per['VALUE'][p] + cand_bad[p]
            if p not in covered:
                # 권위 블록이 이 상품에 대응되지 않았다. 대조를 못 한 것이지 통과가 아니다.
                verdict, basis = 'UNVERIFIED', '권위 블록 미대응 — 대조 불가'
            elif bad:
                verdict, basis = 'FAIL', f'값 불일치 {bad}건'
            elif matched[p] or cand_ok[p]:
                verdict, basis = 'PASS', f'일치 {matched[p]}건 + 후보일치 {cand_ok[p]}건'
            else:
                verdict, basis = 'UNVERIFIED', '대조된 셀 0건'
            w.writerow([p, live_prd[p], verdict, matched[p], per['VALUE'][p],
                        cand_ok[p], cand_bad[p], per['MISSING'][p],
                        per['EXTRA'][p], per['UNRESOLVED'][p], basis])
    print(f'\n축③ 상품별 판정 {len(live_prd)}행 → {path}  (스냅샷 {os.path.basename(snap)})')


if __name__ == '__main__':
    sys.exit(main())
