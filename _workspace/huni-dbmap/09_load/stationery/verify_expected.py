#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적재 CSV 자기검증 게이트 (stationery) — L1+ref 마스터에서 기대행을 독립 재생성해 load CSV와 대조.
   누락0 / 날조0 입증. count → set → FK실재 3단 대조. 생성기(gen_load.py) 출력 미참조 — L1 직접 재판독.
   --sheet 파라미터화: SHEET 상수 + NM2CD + BIND_NM2PROC(제본사양→proc) + COAT_PRDS 4개만 시트별 교체.
   stationery는 IMPORT_MAP/SIGCOLS 비어있음(자재=직접명 이미 적재, 줄수신호 없음) — 제본 enum 변환이 핵심축.
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)"""
import csv, os, sys
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
SHEET = 'stationery'  # @MX:NOTE: 시트 확장 시 이 상수 + 아래 매핑만 교체


def load_csv(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


def load_load(name):
    with open(os.path.join(LOAD, name), encoding='utf-8') as f:
        return list(csv.DictReader(f))


prods = {r['prd_cd']: r for r in load_csv('00_schema/ref-products.csv')}
allproc = set(r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv'))

NM2CD = {
    '만년다이어리(소프트커버)': 'PRD_000172', '만년다이어리(하드커버)': 'PRD_000173',
    '만년다이어리(레더하드커버)': 'PRD_000174', '만년다이어리(레더소프트커버)': 'PRD_000175',
    '먼슬리플래너': 'PRD_000176', '스프링노트': 'PRD_000177', '스프링수첩': 'PRD_000178',
    '메모패드': 'PRD_000179', '메모패드(내지커스텀) 준비중': 'PRD_000180',
    '중철노트': 'PRD_000181', '떡메모지': 'PRD_000097',
}
# 제본사양 L1 enum 토큰 → 제본 proc_cd (마스터 ref-processes 직접). 공란/미명시는 신호 아님(보류).
BIND_NM2PROC = {
    '하드커버': 'PROC_000023',      # 하드커버무선제본
    '트윈링제본': 'PROC_000021',    # 트윈링제본
    '떡제본': 'PROC_000022',        # 떡제본
    '중철제본': 'PROC_000018',      # 중철제본
}
ALREADY_LOADED = {'PRD_000097'}  # 097은 라이브 기적재 → active 기대에서 제외
COAT_TOKEN = '무광코팅'           # 표지사양에 이 토큰 → 코팅공정 PROC_000015 분리 기대
COAT_PROC = 'PROC_000015'

results = []


def check(label, expected: set, actual: set):
    miss = expected - actual; extra = actual - expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss:
        print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra:
        print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok


# ---- L1 직접 재판독: 상품별 제본사양·표지사양 추출 ----
bind_l1 = {}   # cd -> 제본사양 원문
coat_l1 = {}   # cd -> 표지사양 원문
with open(os.path.join(ROOT, '06_extract', 'stationery-l1.csv'), encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        nm = (row.get('prd_nm') or '').strip()
        if nm not in NM2CD:
            continue
        cd = NM2CD[nm]
        b = (row.get('제본사양') or '').strip()
        c = (row.get('표지사양') or '').strip()
        if b and cd not in bind_l1:
            bind_l1[cd] = b
        if c and cd not in coat_l1:
            coat_l1[cd] = c

# ---- 기대 제본 active (prd_cd, proc_cd): L1 제본사양 enum → proc, use_yn=Y, 097 제외 ----
exp_bind = set()
for cd, b in bind_l1.items():
    if cd in ALREADY_LOADED:
        continue
    if prods[cd]['use_yn'] != 'Y':
        continue
    for token, pc in BIND_NM2PROC.items():
        if token in b:
            exp_bind.add((cd, pc))
            break

# ---- 기대 코팅 active (prd_cd, PROC_000015): 표지사양에 무광코팅 토큰, use_yn=Y, 097 제외 ----
exp_coat = set()
for cd, c in coat_l1.items():
    if cd in ALREADY_LOADED:
        continue
    if prods[cd]['use_yn'] != 'Y':
        continue
    if COAT_TOKEN in c:
        exp_coat.add((cd, COAT_PROC))

# 적재행 분할(제본 family vs 코팅)
BIND_PROCS = set(BIND_NM2PROC.values())
act_all = [(r['prd_cd'], r['proc_cd']) for r in load_load('t_prd_product_processes.csv')]
act_bind = set((p, c) for p, c in act_all if c in BIND_PROCS)
act_coat = set((p, c) for p, c in act_all if c == COAT_PROC)

check('R1-bind-active', exp_bind, act_bind)
check('R2-coat-active', exp_coat, act_coat)

# ---- R5 qty_unit: 11상품 전건 QTY_UNIT.03 ----
exp_qu = set(NM2CD.values())
act_qu = set(r['prd_cd'] for r in load_load('t_prd_products_qtyunit_update.csv')
             if r['target_qty_unit_typ_cd'] == 'QTY_UNIT.03')
check('R5-qtyunit', exp_qu, act_qu)

# ---- 날조 가드: 적재 proc_cd/prd_cd 마스터 실재 + excl_grp 공란(단일고정 G-ST-3) ----
fab = []
exclviolation = 0
for r in load_load('t_prd_product_processes.csv'):
    if r['proc_cd'] not in allproc:
        fab.append(('proc', r['proc_cd']))
    if r['prd_cd'] not in prods:
        fab.append(('prd', r['prd_cd']))
    if (r.get('excl_grp_cd') or '').strip():  # G-ST-3: 문구 제본 단일고정 → excl_grp 비워야 함
        exclviolation += 1
results.append(('FK-existence', '-', '-', '-', len(fab), not fab))
results.append(('excl-empty(G-ST-3)', '-', '-', '-', exclviolation, exclviolation == 0))
if fab:
    print("  [FK] FABRICATED refs:", fab[:8])

# ---- 출력 ----
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':22s} {'exp':>5s} {'act':>5s} {'miss':>5s} {'extra':>6s}  result")
allok = True
for lbl, e, a, m, x, ok in results:
    allok &= ok
    print(f"{lbl:22s} {str(e):>5s} {str(a):>5s} {str(m):>5s} {str(x):>6s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
