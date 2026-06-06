#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
박(foil) round-2 가격 매핑 — 적재용 CSV 생성기 (재현성·손편집 금지).

설계 원칙(사용자 KEY DIRECTIVE):
  - 박등급 A~E는 본질 가격 차원이 아니라 "엑셀 한계상 실무자가 만든 편의 표현"이다.
  - 등급은 DB 어느 컬럼에도 싣지 않는다(=조인 키로만 소멸).
  - 박을 본질 차원(면적·박종·수량)으로 환원:
      B02(면적→등급) ⋈ B03(등급×수량→가격) on grade  →  (가로,세로,수량)→가격
  - 박 = 면적매트릭스형(=실사/아크릴과 동일). siz_cd = 박 면적좌표(가로×세로).
  - off-grid(정확한 가로×세로 부재)는 앱 런타임 ceiling(DB 미저장).

입력: 06_extract/price-foil-small-l1.csv, price-foil-large-l1.csv (엑셀 명시값=권위)
출력: 02_mapping/load_price/_foil/*.csv  (component_prices, price_components,
       price_formulas, formula_components, product_price_formulas)
권위: dbm-price-formula skill 규칙①~⑩, 00_schema/price-engine-ddl.md
"""
import csv, re, os, json
from collections import defaultdict, OrderedDict

BASE = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..'))
EXTRACT = os.path.join(BASE, '06_extract')
OUT = os.path.join(BASE, '02_mapping', 'load_price', '_foil')
os.makedirs(OUT, exist_ok=True)

APPLY_YMD = '2026-06-01'          # 규칙⑦ go-live 단일 일자
CPID_BASE = 9100000              # 라이브 부재 확증된 surrogate PK 예약 블록(충돌 0)
SIZ_MINT_BASE = 722              # MIGRATION §10 조율: 면적 511~721 점유 → 박은 722부터
COMP_TYP_FOIL = 'PRC_COMPONENT_TYPE.05'   # 박형압비 (가공비/동판비 공통)
FRM_TYP_AREA = 'FRM_TYPE.02'     # 단순형 (실사/아크릴 면적매트릭스가 쓰는 라이브 FRM_TYPE — 재사용)

def load(fn):
    with open(os.path.join(EXTRACT, fn), encoding='utf-8') as f:
        return list(csv.DictReader(f))

small = load('price-foil-small-l1.csv')
large = load('price-foil-large-l1.csv')

# ───────────────────────── 파서들 ─────────────────────────

def parse_grade_matrix(rows, block, seroband):
    """B02/B04-type: 가로(row) × 세로(col) → 등급. returns dict[(garo,sero)]=grade"""
    sero = {}
    for r in rows:
        if r['block_id'] == block and r['row_key'] == '가로/세로' \
           and r['col'] in seroband and r['value'] and r['value'].endswith('mm'):
            sero[r['col']] = int(r['value'].replace('mm', ''))
    cells = {}
    for r in rows:
        if r['block_id'] != block:
            continue
        rk = r['row_key']
        if rk and re.match(r'^\d+mm$', rk):
            garo = int(rk.replace('mm', ''))
            c = r['col']; v = (r['value'] or '').strip()
            if c in sero and v in 'ABCDE':
                cells[(garo, sero[c])] = v
    return cells

def parse_price_qtyrows(rows, block, qtyheader, gradeband):
    """B03(소형)/B05-type: row_key=수량, col=등급 → 가격. returns dict[(qty,grade)]=price"""
    gax = {}
    for r in rows:
        if r['block_id'] == block and r['row_key'] == qtyheader \
           and r['col'] in gradeband and r['value'] in 'ABCDE':
            gax[r['col']] = r['value']
    price = {}
    for r in rows:
        if r['block_id'] != block:
            continue
        rk = r['row_key']
        if rk and re.match(r'^\d+$', rk):
            qty = int(rk); c = r['col']; v = (r['value'] or '').strip()
            if c in gax and v and re.match(r'^\d+$', v):
                price[(qty, gax[c])] = int(v)
    return price

def parse_price_embedded(rows, block, gradeband):
    """B03(대형 일반): 가격이 K..P에 임베드. K col 숫자=수량, L..P=등급가."""
    gax = {}
    for r in rows:
        if r['block_id'] == block and r['row_key'] == '가로/세로' \
           and r['col'] in gradeband and r['value'] in 'ABCDE':
            gax[r['col']] = r['value']
    byseq = defaultdict(dict)
    for r in rows:
        if r['block_id'] == block and r['col'] in (['K'] + gradeband):
            byseq[r['row_seq']][r['col']] = (r['value'] or '').strip()
    price = {}
    for seq, d in byseq.items():
        kq = d.get('K', '')
        if kq and re.match(r'^\d+$', kq):
            qty = int(kq)
            for c in gradeband:
                v = d.get(c, '')
                if c in gax and v and re.match(r'^\d+$', v):
                    price[(qty, gax[c])] = int(v)
    return price

def parse_die_small(rows):
    """소형 동판비 B01: 단일 셀 80x40 → 5000 (수량1)."""
    die = {}
    for r in rows:
        if r['block_id'] == 'B01' and r['row_key'] == '1' and r['col'] == 'B':
            v = (r['value'] or '').strip()
            if v and re.match(r'^\d+$', v):
                die[(80, 40)] = int(v)
    return die

def parse_die_large(rows):
    """대형 동판비 B01: 가로(row 30..170) × 세로(col 30..170) → 단가."""
    sero = {}
    for r in rows:
        if r['block_id'] == 'B01' and r['row_key'] == '가로 / 세로' \
           and r['col'] in list('BCDEFGHI') and r['value'] and r['value'].endswith('mm'):
            sero[r['col']] = int(r['value'].replace('mm', ''))
    die = {}
    for r in rows:
        if r['block_id'] != 'B01':
            continue
        rk = r['row_key']
        if rk and re.match(r'^\d+mm$', rk):
            garo = int(rk.replace('mm', ''))
            c = r['col']; v = (r['value'] or '').strip()
            if c in sero and v and re.match(r'^\d+$', v):
                die[(garo, sero[c])] = int(v)
    return die

# ───────────────────────── 추출 ─────────────────────────

s_gen_cells = parse_grade_matrix(small, 'B02', list('BCDEF'))
s_gen_price = parse_price_qtyrows(small, 'B03', '분류 / 수량', list('IJKLM'))
s_spc_cells = parse_grade_matrix(small, 'B04', list('BCDEF'))
s_spc_price = parse_price_qtyrows(small, 'B05', '분류 / 수량', list('IJKLM'))
s_die = parse_die_small(small)

l_gen_cells = parse_grade_matrix(large, 'B03', list('BCDEFGHI'))
l_gen_price = parse_price_embedded(large, 'B03', list('LMNOP'))
l_spc_cells = parse_grade_matrix(large, 'B04', list('BCDEFGHI'))
l_spc_price = parse_price_qtyrows(large, 'B05', '분류 / 수량', list('LMNOP'))
l_die = parse_die_large(large)

# ───────────────────────── 등급 소멸 조인 (B02 ⋈ B03) ─────────────────────────
# 결과: dict[(garo,sero,qty)] = price.  등급은 키로만 쓰이고 결과에 미포함.

def join_grade(cells, price):
    out = {}
    unmatched = []
    qtys = sorted(set(q for q, g in price))
    for (garo, sero), grade in cells.items():
        for qty in qtys:
            key = (qty, grade)
            if key not in price:
                unmatched.append((garo, sero, qty, grade))
                continue
            out[(garo, sero, qty)] = price[key]
    return out, unmatched

j_s_gen, u1 = join_grade(s_gen_cells, s_gen_price)
j_s_spc, u2 = join_grade(s_spc_cells, s_spc_price)
j_l_gen, u3 = join_grade(l_gen_cells, l_gen_price)
j_l_spc, u4 = join_grade(l_spc_cells, l_spc_price)
unmatched_all = u1 + u2 + u3 + u4

# ───────────────────────── siz 해소 (search-before-mint) ─────────────────────────
live = []
with open('/tmp/live_siz.tsv') as f:
    for line in f:
        p = line.rstrip('\n').split('\t')
        if len(p) < 6:
            continue
        cd, nm, cw, ch, ww, wh = p
        live.append((cd, nm, float(cw), float(ch), float(ww), float(wh)))

def find_exact(w, h):
    for cd, nm, cw, ch, ww, wh in live:
        if (cw == w and ch == h) or (ww == w and wh == h):
            return cd, nm, 'EXACT'
    return None
def find_rev(w, h):
    for cd, nm, cw, ch, ww, wh in live:
        if (cw == h and ch == w) or (ww == h and wh == w):
            return cd, nm, 'REVERSED'
    return None

all_coords = sorted(set([(w, h) for (w, h, q) in
                         list(j_s_gen) + list(j_s_spc) + list(j_l_gen) + list(j_l_spc)]
                        + list(s_die) + list(l_die)))

siz_map = {}      # (w,h) -> (siz_cd, status, note)
mint_rows = []    # rows to register
mint_seq = SIZ_MINT_BASE
for (w, h) in all_coords:
    e = find_exact(w, h)
    if e:
        siz_map[(w, h)] = (e[0], 'EXACT', '라이브 %s(%s) 정확매칭 재사용' % (e[0], e[1]))
        continue
    r = find_rev(w, h)
    if r:
        siz_map[(w, h)] = (r[0], 'REVERSED',
                           '라이브 %s(%s) 역방향(HxW) 재사용 — 박 면적은 방향 무관(스탬프 면적envelope)' % (r[0], r[1]))
        continue
    siz_cd = 'SIZ_%06d' % mint_seq
    mint_seq += 1
    siz_map[(w, h)] = (siz_cd, 'MINT', '라이브 부재 확증 → 신규 좌표 siz (박 면적좌표)')
    mint_rows.append((siz_cd, '%dx%d' % (w, h), w, h))

n_exact = sum(1 for v in siz_map.values() if v[1] == 'EXACT')
n_rev = sum(1 for v in siz_map.values() if v[1] == 'REVERSED')
n_mint = len(mint_rows)

# ───────────────────────── comp 카탈로그 ─────────────────────────
# 동일가 박종 = 1 shared comp.  (소형 일반 7박종 동일가 / 소형 특수 3 / 대형 일반 6 / 대형 특수 6)
COMPS = OrderedDict()
COMPS['COMP_FOIL_SMALL_GENERAL'] = (
    '소형박 일반박 가공비(면적·수량별)', COMP_TYP_FOIL,
    '박=공정(규칙①), 박형압비(.05). 일반박 7종(금유광/은유광/먹유광/청박/적박/동박/펄박) 동일가 공유 → 1 comp. 등급A~E 소멸(면적좌표=siz_cd, 수량=min_qty).')
COMPS['COMP_FOIL_SMALL_SPECIAL'] = (
    '소형박 특수박 가공비(면적·수량별)', COMP_TYP_FOIL,
    '특수박 3종(백박/홀로그램박/트윙클박) 동일가 공유 → 1 comp. 일반박과 단가표 상이(B04/B05).')
COMPS['COMP_FOIL_LARGE_GENERAL'] = (
    '대형박 일반박 가공비(면적·수량별)', COMP_TYP_FOIL,
    '일반박 6종(금유광/금무광/은유광/은무광/동박/청박) 동일가 공유 → 1 comp.')
COMPS['COMP_FOIL_LARGE_SPECIAL'] = (
    '대형박 특수박 가공비(면적·수량별)', COMP_TYP_FOIL,
    '특수박 6종(먹유광/백박/홀로그램/트윙클/적박/녹박) 동일가 공유 → 1 comp.')
COMPS['COMP_FOIL_DIE_SMALL'] = (
    '소형박 동판비(아연판 셋업·면적별)', COMP_TYP_FOIL,
    '동판비=1회성 셋업(아연판). 수량무관(min_qty NULL). 소형=단일셀 80x40.')
COMPS['COMP_FOIL_DIE_LARGE'] = (
    '대형박 동판비(아연판 셋업·면적별)', COMP_TYP_FOIL,
    '동판비=1회성 셋업. 수량무관(min_qty NULL). 대형=가로×세로 8x8 매트릭스.')

# ───────────────────────── formula + 배선 ─────────────────────────
FRM = ('PRF_FOIL_AREA', '박(후가공) 면적·박종·수량별 가공비 + 동판셋업', FRM_TYP_AREA,
       '박=면적매트릭스형(실사/아크릴과 동일 FRM_TYPE.02 단순형 재사용). 등급A~E는 본질 차원 아님→면적(siz_cd)·박종(comp_cd)·수량(min_qty)으로 환원. 가공비+동판비 2 구성요소.')
# formula_components: 가공비 4 comp + 동판 2 comp 모두 이 공식에 배선.
# addtn_yn='Y'(합산: 박가공비 + 동판셋업비). disp_seq: 가공비 먼저, 동판 다음.
FRM_COMPS = [
    ('COMP_FOIL_SMALL_GENERAL', 10, 'Y'),
    ('COMP_FOIL_SMALL_SPECIAL', 20, 'Y'),
    ('COMP_FOIL_LARGE_GENERAL', 30, 'Y'),
    ('COMP_FOIL_LARGE_SPECIAL', 40, 'Y'),
    ('COMP_FOIL_DIE_SMALL', 50, 'Y'),
    ('COMP_FOIL_DIE_LARGE', 60, 'Y'),
]

# ───────────────────────── component_prices 행 생성 ─────────────────────────
cp_rows = []  # dict per row
cpid = CPID_BASE

def emit(comp_cd, w, h, qty, price, note):
    global cpid
    siz_cd, status, _ = siz_map[(w, h)]
    cp_rows.append(OrderedDict([
        ('comp_price_id', cpid),
        ('comp_cd', comp_cd),
        ('apply_ymd', APPLY_YMD),
        ('siz_cd', siz_cd),
        ('clr_cd', ''),            # 규칙①: clr 매핑 금지
        ('mat_cd', ''),            # 박종은 comp_cd로 흡수(동일가) → mat 무관
        ('coat_side_cnt', ''),     # 코팅 무관
        ('bdl_qty', ''),           # 묶음 무관
        ('min_qty', '' if qty is None else qty),
        ('unit_price', price),
        ('note', note),
    ]))
    cpid += 1

# 가공비 (수량 있음)
for (w, h, q), p in sorted(j_s_gen.items()):
    emit('COMP_FOIL_SMALL_GENERAL', w, h, q, p,
         '소형 일반박 가공비 가로%dmm×세로%dmm 수량%d (등급소멸 조인가)' % (w, h, q))
for (w, h, q), p in sorted(j_s_spc.items()):
    emit('COMP_FOIL_SMALL_SPECIAL', w, h, q, p,
         '소형 특수박 가공비 가로%dmm×세로%dmm 수량%d' % (w, h, q))
for (w, h, q), p in sorted(j_l_gen.items()):
    emit('COMP_FOIL_LARGE_GENERAL', w, h, q, p,
         '대형 일반박 가공비 가로%dmm×세로%dmm 수량%d' % (w, h, q))
for (w, h, q), p in sorted(j_l_spc.items()):
    emit('COMP_FOIL_LARGE_SPECIAL', w, h, q, p,
         '대형 특수박 가공비 가로%dmm×세로%dmm 수량%d' % (w, h, q))
# 동판비 (수량무관 → min_qty NULL)
for (w, h), p in sorted(s_die.items()):
    emit('COMP_FOIL_DIE_SMALL', w, h, None, p,
         '소형 동판비(아연판 셋업) 가로%dmm×세로%dmm 수량무관' % (w, h))
for (w, h), p in sorted(l_die.items()):
    emit('COMP_FOIL_DIE_LARGE', w, h, None, p,
         '대형 동판비(아연판 셋업) 가로%dmm×세로%dmm 수량무관' % (w, h))

# 자연키8 중복제거 (C-2) — REVERSED siz 재사용으로 (가로W,세로H)와 (가로H,세로W)가
# 동일 siz_cd로 수렴할 때 발생. 박 면적가는 면적만으로 결정(방향 무관)이라 전건 SAME-PRICE.
# 무손실 collapse: 첫 행 유지 + note에 흡수된 좌표 명시(G7 완전성 추적). 가격충돌 0 사전확증.
seen = {}; dup = []; conflict = []
deduped = []
for r in cp_rows:
    nk = (r['comp_cd'], r['apply_ymd'], r['siz_cd'], r['clr_cd'], r['mat_cd'],
          r['coat_side_cnt'], r['bdl_qty'], r['min_qty'])
    if nk in seen:
        first = seen[nk]
        if str(first['unit_price']) != str(r['unit_price']):
            conflict.append((nk, first['unit_price'], r['unit_price']))  # STOP 신호
        dup.append(nk)
        # 흡수된 좌표 추적: 첫 행 note에 [+흡수: WxH] 부기
        first['note'] = first['note'] + ' [+REVERSED흡수동일가]'
        continue
    seen[nk] = r
    deduped.append(r)
assert not conflict, "NATURAL-KEY PRICE CONFLICT (STOP): %r" % conflict[:5]
cp_rows = deduped
# dedup 후 comp_price_id 연속 재배정 (gap 제거, 결정적)
for i, r in enumerate(cp_rows):
    r['comp_price_id'] = CPID_BASE + i
cpid = CPID_BASE + len(cp_rows)

# ───────────────────────── CSV 쓰기 ─────────────────────────
def write_csv(fn, header, rows):
    with open(os.path.join(OUT, fn), 'w', newline='', encoding='utf-8') as f:
        w = csv.writer(f)
        w.writerow(header)
        for r in rows:
            w.writerow(r)

write_csv('t_prc_component_prices.csv',
          ['comp_price_id','comp_cd','apply_ymd','siz_cd','clr_cd','mat_cd',
           'coat_side_cnt','bdl_qty','min_qty','unit_price','note'],
          [[r[k] for k in ['comp_price_id','comp_cd','apply_ymd','siz_cd','clr_cd',
            'mat_cd','coat_side_cnt','bdl_qty','min_qty','unit_price','note']] for r in cp_rows])

write_csv('t_prc_price_components.csv',
          ['comp_cd','comp_nm','comp_typ_cd','note','use_yn'],
          [[cd, v[0], v[1], v[2], 'Y'] for cd, v in COMPS.items()])

write_csv('t_prc_price_formulas.csv',
          ['frm_cd','frm_nm','frm_typ_cd','note','use_yn'],
          [[FRM[0], FRM[1], FRM[2], FRM[3], 'Y']])

write_csv('t_prc_formula_components.csv',
          ['frm_cd','comp_cd','disp_seq','addtn_yn'],
          [[FRM[0], cc, ds, ay] for cc, ds, ay in FRM_COMPS])

# siz 신규등록 (mint) — 별도 산출(좌표 siz 등록 CSV)
write_csv('t_siz_sizes_mint.csv',
          ['siz_cd','siz_nm','work_width','work_height','cut_width','cut_height',
           'margin_top','margin_bot','margin_lft','margin_rgt','impos_yn','use_yn','del_yn','note'],
          [[sc, nm, w, h, w, h, 0,0,0,0, 'N','Y','N',
            '박 면적좌표 가로%dmm×세로%dmm (라이브 부재→신규). 면적직접입력형, margin0.' % (w, h)]
           for sc, nm, w, h in mint_rows])

# product_price_formulas — 바인딩 대상 FLAG (라이브에 standalone 후가공_박 product 부재)
# 유일 후보 PRD_000037 오리지널박명함은 namecard 임베드 박(별도 처리)이라 부적합 → 미발행, FLAG.
write_csv('t_prd_product_price_formulas.csv',
          ['prd_cd','frm_cd','apply_bgn_ymd','note'],
          [])  # 빈 — 바인딩 대상 미확정(FLAG, 발명 금지)

# ───────────────────────── 리포트 ─────────────────────────
report = {
    'join': {
        'small_general': {'coords': len(s_gen_cells), 'qty_bands': len(set(q for q,g in s_gen_price)), 'rows': len(j_s_gen)},
        'small_special': {'coords': len(s_spc_cells), 'qty_bands': len(set(q for q,g in s_spc_price)), 'rows': len(j_s_spc)},
        'large_general': {'coords': len(l_gen_cells), 'qty_bands': len(set(q for q,g in l_gen_price)), 'rows': len(j_l_gen)},
        'large_special': {'coords': len(l_spc_cells), 'qty_bands': len(set(q for q,g in l_spc_price)), 'rows': len(j_l_spc)},
    },
    'die': {'small': len(s_die), 'large': len(l_die)},
    'unmatched_join': unmatched_all,
    'siz': {'distinct_coords': len(all_coords), 'exact': n_exact, 'reversed': n_rev, 'mint': n_mint,
            'mint_range': ('SIZ_%06d' % SIZ_MINT_BASE, 'SIZ_%06d' % (mint_seq-1)) if mint_rows else None},
    'component_prices_rows_raw': len(cp_rows) + len(dup),
    'component_prices_rows_deduped': len(cp_rows),
    'reversed_samepricE_collapses': len(dup),
    'natural_key_price_conflicts': len(conflict),
    'cpid_range': (CPID_BASE, cpid-1),
    'grade_in_output': 'NONE (dissolved as join key)',
}
print(json.dumps(report, ensure_ascii=False, indent=2))
json.dump({'%dx%d' % k: list(v) for k, v in siz_map.items()},
          open('/tmp/foil_siz_final.json', 'w'), ensure_ascii=False, indent=0)
