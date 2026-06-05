#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적재 CSV 자기검증 게이트 (acrylic) — L1+ref에서 기대행을 독립 재생성해 load CSV와 대조.
   누락0 / 날조0 입증. count → set → FK 실재 3단 대조. 생성기(gen_load) 출력 미참조(독립).
   --sheet 파라미터화 정신: SHEET 상수 + 아래 매핑/규칙만 시트별 교체.
   사용: python3 verify_expected.py   (exit 0=PASS, 1=FAIL)

   게이트 맵(digital-print 대비 교체):
     R1-diecut-active   : 완칼 PROC_000053 (active, 묵시필수)
     R1-uv-active       : UV PROC_000002 (active, print_side 오적재 정정)
     R1-attach-active   : 부착 PROC_000081 (active)
     R3-mat-thickness   : 두께정정 update-set (192→042/043/044)
     R3-mat-accessory   : 부속자재 MAT_TYPE.07 (active)
     R2-bundle-piece    : 조각수 bundle_qty (active)
     R6-qtyunit         : QTY_UNIT.01(EA) 23상품
     R6-nonspec         : nonspec 범위 update-set
     FK-existence       : proc/mat/prd 마스터 실재 + 날조 0
"""
import csv, os, sys
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
DEF = os.path.join(BASE, '_deferred')
SHEET = 'acrylic'  # @MX:NOTE 시트 확장 시 이 상수 + 아래 매핑만 교체

def rd(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
def rl(name, sub=LOAD):
    with open(os.path.join(sub, name), encoding='utf-8') as f:
        return list(csv.DictReader(f))

prods = {r['prd_cd']: r for r in rd('00_schema/ref-products.csv')}
matset = set(r['mat_cd'] for r in rd('00_schema/ref-materials.csv'))
procset = set(r['proc_cd'] for r in rd('00_schema/ref-processes.csv'))

# acrylic 등록상품 = ref-products PRD_000146~169.
# PRD_000167(아크릴코롯토 중복, file_upload_yn=N·고유 L1 앵커 부재)은 stale 중복 후보 →
# 적재 대상에서 분리(D-AC-6 flag, §6). L1 앵커가 있는 상품만 적재모집단.
# 추정금지: 167에 L1 옵션을 매핑하면 날조 → 게이트 모집단에서 제외하고 flag로만 추적.
STALE_DUP = {'PRD_000167'}
ACR = [c for c in (f'PRD_0001{n}' for n in range(46, 70)) if c in prods and c not in STALE_DUP]

# L1 독립 재판독 — 상품별 인쇄사양(UV변형)·조각수·소재두께·가공 신호 재산출
import re
L1 = os.path.join(ROOT, '06_extract', 'acrylic-l1.csv')
from collections import defaultdict
# prd_nm → set of signal values
nm2uv = defaultdict(set)       # 인쇄사양 (UV변형)
nm2pcs = defaultdict(set)      # 조각수
nm2soje = defaultdict(set)     # 소재
nm2gagong = defaultdict(set)   # 가공(옵션)
nm2nonspec = {}                # (wmin,wmax,hmin,hmax)
hidden = {}
with open(L1, encoding='utf-8-sig') as f:
    cur = None
    for row in csv.DictReader(f):
        pn = (row.get('prd_nm') or '').strip()
        if pn:
            cur = pn
            hidden[pn] = (row.get('_row_hidden') or '').strip()
        if cur is None:
            continue
        uv = (row.get('인쇄사양', '') or '').strip()
        if uv:
            nm2uv[cur].add(uv.replace('★', ''))
        pc = (row.get('조각수(옵션)', '') or '').strip()
        m = re.match(r'(\d+)\s*조각', pc)
        if m:
            nm2pcs[cur].add(int(m.group(1)))
        so = (row.get('소재(필수)', '') or '').strip()
        if so:
            nm2soje[cur].add(so)
        gg = (row.get('가공(옵션)_가공', '') or '').strip()
        if gg:
            nm2gagong[cur].add(gg)
        wr = (row.get('비규격(최소/최대)_가로', '') or '').strip()
        hr = (row.get('비규격(최소/최대)_세로', '') or '').strip()
        if wr and hr and cur not in nm2nonspec:
            try:
                w = wr.split('~'); h = hr.split('~')
                nm2nonspec[cur] = (float(w[0]), float(w[1]), float(h[0]), float(h[1]))
            except Exception:
                pass

# 상품명 → prd_cd (L1 표기 = ref prd_nm 일치, hidden=true 미등록 제외)
nm2cd = {}
for cd in ACR:
    nm2cd.setdefault(prods[cd]['prd_nm'], cd)

def cd_active(cd):
    return prods[cd]['use_yn'] == 'Y'

results = []
def check(label, expected, actual):
    miss = expected - actual; extra = actual - expected
    ok = not miss and not extra
    results.append((label, len(expected), len(actual), len(miss), len(extra), ok))
    if miss: print(f"  [{label}] MISSING(기대>적재):", sorted(miss)[:8])
    if extra: print(f"  [{label}] FABRICATED(적재>기대):", sorted(extra)[:8])
    return ok

# ===== R1 완칼: per-product GROUNDED 근거 리스트 대조 (순환검증 보정, MAJOR) =====
# [보정 2026-06-05] 기존 게이트는 생성기와 동일하게 cd_active(cd) 전상품에 diecut=True
# 하드코딩 → 생성기·검증기 둘 다 동일 규칙이라 과적용(over-reach) 검출 구조적 불가
# (waveB2-load-validation §3-A "순환 검증"). 이를 끊기 위해 active 완칼 기대를
# **검증자 독립 per-product GROUNDED 14 prd_cd 명시 리스트**로 고정한다(생성기 규칙 비참조).
#   - GROUNDED(rule, UPHOLD) 14: 단품/조합 굿즈 = 모양대로 잘린 개별 아크릴 조각.
#   - OVER-REACH(보류) 3: 161 판아크릴(recipe Case10 UV→포장, 컷 없음)·168 입체코롯토
#     (L1 신호 전무)·169 입체블럭(라미 적층/조립). product-level 근거 부재 → active 금지.
# 이 리스트에 161/168/169가 active로 재출현하면 FABRICATED, 14 중 하나라도 빠지면 MISSING.
DIECUT_GROUNDED = {  # @MX:ANCHOR per-product 완칼 grounded 권위 — 생성기와 독립(과적용 검출용)
    'PRD_000146', 'PRD_000147', 'PRD_000148', 'PRD_000149', 'PRD_000150',
    'PRD_000151', 'PRD_000152', 'PRD_000154', 'PRD_000155', 'PRD_000157',
    'PRD_000158', 'PRD_000160', 'PRD_000162', 'PRD_000163',
}  # 14건. 161/168/169 의도적 제외(over-reach 보류, _deferred D-AC-8)
DIECUT_OVERREACH = {'PRD_000161', 'PRD_000168', 'PRD_000169'}  # active 재출현 시 FABRICATED 검출
# 무결성 가드: grounded와 over-reach는 active(use_yn=Y) 17상품을 정확히 분할해야 한다.
_active_all = set(cd for cd in ACR if cd_active(cd))
assert DIECUT_GROUNDED | DIECUT_OVERREACH == _active_all, \
    f"완칼 권위 리스트가 active 17과 불일치: {(DIECUT_GROUNDED|DIECUT_OVERREACH) ^ _active_all}"
assert not (DIECUT_GROUNDED & DIECUT_OVERREACH), "grounded/over-reach 중복"
exp_diecut = set((cd, 'PROC_000053') for cd in DIECUT_GROUNDED)
act_proc = rl('t_prd_product_processes.csv')
act_diecut = set((r['prd_cd'], r['proc_cd']) for r in act_proc if r['proc_cd'] == 'PROC_000053')
check('R1-diecut-active', exp_diecut, act_diecut)
# over-reach 3건이 active에 1건이라도 남으면 즉시 적발(독립 가드)
overreach_leak = set(r['prd_cd'] for r in act_proc
                     if r['proc_cd'] == 'PROC_000053' and r['prd_cd'] in DIECUT_OVERREACH)
results.append(('R1-diecut-overreach', 0, len(overreach_leak), 0, len(overreach_leak), not overreach_leak))
if overreach_leak:
    print("  [R1-diecut-overreach] OVER-REACH leaked into active:", sorted(overreach_leak))

# ===== R1 UV: L1 인쇄사양(UV변형) 보유 상품 → PROC_000002 1행(active) =====
exp_uv = set()
for nm, cd in nm2cd.items():
    if nm2uv.get(nm) and cd_active(cd):
        exp_uv.add((cd, 'PROC_000002'))
act_uv = set((r['prd_cd'], r['proc_cd']) for r in act_proc if r['proc_cd'] == 'PROC_000002')
check('R1-uv-active', exp_uv, act_uv)

# ===== R1 부착: L1 가공 = 자석부착/맥세이프 보유 상품 → PROC_000081(active) =====
# [보정 2026-06-05] 151(맥세이프 부착)은 라이브 기적재(중복PK BLOCKER, D-AC-1)라
# active에서 conditional로 분리 → active 기대에서 제외(t_prd_product_processes_conditional.csv).
# 147(자석부착)만 신규 active. 151이 active에 재출현하면 중복PK 위험이므로 FABRICATED로 잡는다.
ATTACH_TOKENS = ('자석부착', '맥세이프스마트톡')
ATTACH_CONDITIONAL = {'PRD_000151'}  # 라이브 기적재 중복PK → conditional 분리(active 금지)
exp_attach = set()
for nm, cd in nm2cd.items():
    if any(t in nm2gagong.get(nm, set()) for t in ATTACH_TOKENS) \
            and cd_active(cd) and cd not in ATTACH_CONDITIONAL:
        exp_attach.add((cd, 'PROC_000081'))
act_attach = set((r['prd_cd'], r['proc_cd']) for r in act_proc if r['proc_cd'] == 'PROC_000081')
check('R1-attach-active', exp_attach, act_attach)

# ===== R3 두께정정: L1 소재 두께 → MAT 코드 (전 등록상품, 두께 식별 가능한 것) =====
THICK = {'1.5mm': 'MAT_000042', '3mm': 'MAT_000043', '8mm': 'MAT_000044', '8t': 'MAT_000044'}
def thick_code(sojes):
    for so in sojes:
        s = so.lower()
        if '라미' in so or '10t' in s:
            return None  # 10T 마스터 부재 → 정정 불가(192 유지)
        if '골드' in so or '실버' in so:
            return None  # 색상 자재(195/196) 별도 — 두께정정 대상 아님
        for k, v in THICK.items():
            if k in s:
                return v
    return None
exp_thick = set()
for nm, cd in nm2cd.items():
    sojes = nm2soje.get(nm, set())
    tc = thick_code(sojes)
    if tc:
        exp_thick.add((cd, tc))
act_thick = set((r['prd_cd'], r['target_mat_cd']) for r in rl('t_prd_product_materials_thickness_update.csv'))
check('R3-mat-thickness', exp_thick, act_thick)

# ===== R3 부속자재(MAT_TYPE.07): L1 가공명 → 부속 mat_cd (마스터 실재한 것만, active) =====
GAGONG2MAT = {
 '은색고리': 'MAT_000051', '금색고리': 'MAT_000052', '실버고리': 'MAT_000051', '골드고리': 'MAT_000052',
 '원형핀': 'MAT_000047', '일자핀': 'MAT_000046', '1구자석': 'MAT_000048', '2구자석': 'MAT_000049',
 '투명집게': 'MAT_000056', '화이트바디': 'MAT_000054', '투명바디': 'MAT_000053', '블랙헤어끈': 'MAT_000057',
}  # 부착(자석부착/맥세이프)·색상-only(고리없음/볼펜색/지비츠형상/와이어링)는 자재행 아님
exp_acc = set()
for nm, cd in nm2cd.items():
    if not cd_active(cd):
        continue
    for gg in nm2gagong.get(nm, set()):
        mc = GAGONG2MAT.get(gg)
        if mc:
            exp_acc.add((cd, mc))
act_acc = set((r['prd_cd'], r['mat_cd']) for r in rl('t_prd_product_materials.csv'))
check('R3-mat-accessory', exp_acc, act_acc)

# ===== R2 조각수 bundle_qty: L1 조각수 → (prd,bdl_qty) active =====
exp_bdl = set()
for nm, cd in nm2cd.items():
    if cd_active(cd):
        for n in nm2pcs.get(nm, set()):
            exp_bdl.add((cd, str(n)))
act_bdl = set((r['prd_cd'], r['bdl_qty']) for r in rl('t_prd_product_bundle_qtys.csv'))
check('R2-bundle-piece', exp_bdl, act_bdl)

# ===== R6 qty_unit: 등록 23상품 전건 QTY_UNIT.01(EA) =====
exp_qu = set(ACR)
act_qu = set(r['prd_cd'] for r in rl('t_prd_products_qtyunit_update.csv') if r['target_qty_unit_typ_cd'] == 'QTY_UNIT.01')
check('R6-qtyunit', exp_qu, act_qu)

# ===== R6 nonspec: L1 비규격 범위 보유 상품 → update-set =====
exp_ns = set()
for nm, cd in nm2cd.items():
    if nm in nm2nonspec:
        exp_ns.add(cd)
act_ns = set(r['prd_cd'] for r in rl('t_prd_products_nonspec_update.csv'))
check('R6-nonspec', exp_ns, act_ns)

# ===== 날조 가드: 모든 적재 prd/proc/mat 코드가 마스터 실재 =====
fab = []
for r in act_proc:
    if r['proc_cd'] not in procset: fab.append(('proc', r['proc_cd']))
    if r['prd_cd'] not in prods: fab.append(('prd', r['prd_cd']))
for r in rl('t_prd_product_materials.csv'):
    if r['mat_cd'] not in matset: fab.append(('mat', r['mat_cd']))
    if r['prd_cd'] not in prods: fab.append(('prd', r['prd_cd']))
for r in rl('t_prd_product_bundle_qtys.csv'):
    if r['prd_cd'] not in prods: fab.append(('prd', r['prd_cd']))
for r in rl('t_prd_product_materials_thickness_update.csv'):
    if r['target_mat_cd'] not in matset: fab.append(('mat', r['target_mat_cd']))
results.append(('FK-existence', '-', '-', '-', len(fab), not fab))
if fab: print("  [FK] FABRICATED refs:", fab[:8])

# ===== 비활성 가드: active CSV에 use_yn=N 상품 0건 =====
inact_in_active = []
for name in ('t_prd_product_processes.csv', 't_prd_product_materials.csv', 't_prd_product_bundle_qtys.csv'):
    for r in rl(name):
        if prods.get(r['prd_cd'], {}).get('use_yn') == 'N':
            inact_in_active.append((name, r['prd_cd']))
results.append(('active-no-inactive', '-', '-', '-', len(inact_in_active), not inact_in_active))
if inact_in_active: print("  [active] INACTIVE leaked:", inact_in_active[:8])

# ===== 출력 =====
print(f"\n=== SELF-CHECK ({SHEET}) ===")
print(f"{'label':22s} {'exp':>5s} {'act':>5s} {'miss':>5s} {'extra':>6s}  result")
allok = True
for lbl, e, a, m, x, ok in results:
    allok &= ok
    print(f"{lbl:22s} {str(e):>5s} {str(a):>5s} {str(m):>5s} {str(x):>6s}  {'PASS' if ok else 'FAIL'}")
print(f"\nGATE: {'PASS — 누락0·날조0' if allok else 'FAIL'}")
sys.exit(0 if allok else 1)
