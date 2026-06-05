#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""stationery(문구) 적재 CSV 생성기 (round-3 remediation 전수 확장, digital-print 파일럿 메서드 동일).
모든 행은 L1 셀 또는 ref 마스터 라인에 추적된다(추정 0, _provenance). DB 쓰기 없음 — CSV 산출만.
권위: L1 엑셀(06_extract/stationery-l1.csv) = 상품별 진실 · ref 마스터(00_schema/ref-*.csv, stale 2026-06-04 주의).
핵심: 제본사양 enum → 제본 공정(PROC_000017 family) 변환. 자재=직접명 매치(IMPORT 우회). 표지 코팅 분해."""
import csv, os
from collections import defaultdict, Counter
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load'); DEF = os.path.join(BASE, '_deferred')
os.makedirs(LOAD, exist_ok=True); os.makedirs(DEF, exist_ok=True)
REGDT = '2026-06-05 00:00:00'  # 적재 예정 reg_dt(설계값, FK 무관)


def load_csv(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))


# ---- 마스터 사전 로드 ----
mats = {r['mat_nm'].strip(): r['mat_cd'] for r in load_csv('00_schema/ref-materials.csv')}
procs = {r['proc_nm'].strip(): r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv')}
prods = {r['prd_cd']: r for r in load_csv('00_schema/ref-products.csv')}
allproc = set(r['proc_cd'] for r in load_csv('00_schema/ref-processes.csv'))
allmat = set(mats.values())

# prd_nm(L1 표기) -> prd_cd (stationery 11상품)
NM2CD = {
    '만년다이어리(소프트커버)': 'PRD_000172', '만년다이어리(하드커버)': 'PRD_000173',
    '만년다이어리(레더하드커버)': 'PRD_000174', '만년다이어리(레더소프트커버)': 'PRD_000175',
    '먼슬리플래너': 'PRD_000176', '스프링노트': 'PRD_000177', '스프링수첩': 'PRD_000178',
    '메모패드': 'PRD_000179', '메모패드(내지커스텀) 준비중': 'PRD_000180',
    '중철노트': 'PRD_000181', '떡메모지': 'PRD_000097',
}


def use_yn(cd):
    return prods[cd]['use_yn']


# ============ R1: process (제본 공정) — G-ST-1 PRIMARY/BLOCKER ============
# L1 제본사양 enum → 제본 proc_cd(마스터 ref-processes 직접 매핑, recipe 추정 023/094 폐기).
#   트윈링제본=PROC_000021 · 중철제본=PROC_000018 · 떡제본=PROC_000022 · 하드커버무선제본=PROC_000023
# excl_group: G-ST-3 — 문구 제본은 상품당 1종 고정(택일 아님) → excl_grp_cd 공란, 단독 적재(발명 금지).
# mand_proc_yn: 마스터 PROC_000017 note "필수,단일" → Y (도메인 권위). 097 ref가 N인 것은 ref 결함(spec 기록).
BIND_MAP = {  # prd_nm -> (제본사양 L1값, proc_cd, 방향note)
    '만년다이어리(하드커버)': ('하드커버(면지?)', 'PROC_000023', '하드커버무선제본'),
    '만년다이어리(레더하드커버)': ('하드커버(면지?)', 'PROC_000023', '하드커버무선제본'),
    '스프링노트': ('트윈링제본(좌철+실버링)', 'PROC_000021', '트윈링제본(좌철)'),
    '스프링수첩': ('트윈링제본(상철+실버링)', 'PROC_000021', '트윈링제본(상철)'),
    '메모패드': ('떡제본', 'PROC_000022', '떡제본'),
    '중철노트': ('중철제본', 'PROC_000018', '중철제본'),
}
# 제본사양 공란(엑셀 원천 부재) → CONFIRM, 적재 보류(발명 금지):
#   172 만년다이어리(소프트커버)·175 (레더소프트커버)·176 먼슬리플래너
BIND_CONFIRM = {
    '만년다이어리(소프트커버)': 'PRD_000172',
    '만년다이어리(레더소프트커버)': 'PRD_000175',
    '먼슬리플래너': 'PRD_000176',
}
# 097 떡메모지 = 이미 적재(ref=PROC_000022). 무비판 복제 금지 — skip + ref 결함 finding.
ALREADY_LOADED_BIND = {'PRD_000097'}

PROC_HDR = ['prd_cd', 'proc_cd', 'excl_grp_cd', 'mand_proc_yn', 'disp_seq', 'reg_dt', 'upd_dt', '_provenance']
proc_active = []; proc_def = []; proc_confirm = []

for nm, (l1val, pc, note) in BIND_MAP.items():
    cd = NM2CD[nm]
    prov = f'L1:{nm} 제본사양="{l1val}" → {pc} {note} (R1, ref-processes 마스터 직접매핑)'
    row = [cd, pc, '', 'Y', 1, REGDT, '', prov]  # excl_grp_cd 공란(단일고정), mand=Y(제본 필수)
    if use_yn(cd) == 'Y':
        proc_active.append((row, ''))
    else:
        proc_def.append((row, 'use_yn=N 미출시'))

# 제본사양 공란 상품 → CONFIRM(보류, 적재 안 함)
for nm, cd in BIND_CONFIRM.items():
    proc_confirm.append((cd, nm, '제본사양 L1 공란(엑셀 원천 부재) — 소프트커버/플래너 제본종류 미명시. 발명 금지·컨펌'))

# ---- G-ST-4: 표지 무광코팅 공정 분리 적재 ----
# L1 표지사양 "아트250 + 무광코팅" → 자재(아트지250)+공정(무광코팅 PROC_000015) 분해(entity-semantic §, C-8).
#   현 ref material에 MAT_000260(아트250+무광코팅 복합)이 이미 적재됨 → 코팅 공정행만 additive 추가(안전).
#   자재 평면→분해(MAT_000260→MAT_000081 swap)는 UPDATE성이라 보류·컨펌(D-ST-4).
COAT_PRDS = {  # 표지사양에 "+ 무광코팅" 명시 + 현 material에 MAT_000260 적재된 상품
    '만년다이어리(소프트커버)': 'PRD_000172', '만년다이어리(하드커버)': 'PRD_000173',
    '먼슬리플래너': 'PRD_000176', '스프링노트': 'PRD_000177', '스프링수첩': 'PRD_000178',
    '메모패드': 'PRD_000179', '중철노트': 'PRD_000181',
}
COAT_PROC = 'PROC_000015'  # 무광코팅 (ref-processes: PROC_000015 무광 < PROC_000013 코팅)
for nm, cd in COAT_PRDS.items():
    prov = f'L1:{nm} 표지사양="아트250 + 무광코팅" → 코팅공정 분리 PROC_000015 무광 (R2/G-ST-4, 자재 swap은 D-ST-4 보류)'
    row = [cd, COAT_PROC, '', 'N', 5, REGDT, '', prov]  # 코팅=선택후가공 mand=N, disp_seq 5(제본 1 이후)
    if use_yn(cd) == 'Y':
        proc_active.append((row, ''))
    else:
        proc_def.append((row, 'use_yn=N 미출시'))

# write process active
with open(os.path.join(LOAD, 't_prd_product_processes.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(PROC_HDR)
    for row, _ in proc_active:
        w.writerow(row)
# deferred (use_yn=N — 본 시트엔 비활성 노트 제본 없음, 빈 헤더만)
with open(os.path.join(DEF, 't_prd_product_processes_deferred.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(PROC_HDR + ['_deferred_reason'])
    for row, rsn in proc_def:
        w.writerow(row + [rsn])
# confirm (제본사양 공란 — 적재 보류)
with open(os.path.join(BASE, 't_prd_product_processes_confirm.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(['prd_cd', 'prd_nm', '_confirm_reason'])
    for cd, nm, rsn in proc_confirm:
        w.writerow([cd, nm, rsn])

# ============ R5: qty_unit UPDATE set — G-ST-6 ============
# stationery 11상품 → QTY_UNIT.03(권). C-4 상품군별 일괄. UPDATE-class(INSERT 아님) → 별도 set CSV.
QU_HDR = ['prd_cd', 'prd_nm', 'current_qty_unit_typ_cd', 'target_qty_unit_typ_cd', 'use_yn', '_provenance']
qu_rows = []
for nm, cd in NM2CD.items():
    r = prods[cd]
    qu_rows.append([cd, r['prd_nm'], r.get('qty_unit_typ_cd') or 'NULL', 'QTY_UNIT.03', r['use_yn'],
                    'C-4 상품군별 일괄(stationery 노트/문구=권=QTY_UNIT.03). 라이브 현재 NULL(G-ST-6)'])
with open(os.path.join(LOAD, 't_prd_products_qtyunit_update.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(QU_HDR)
    for r in qu_rows:
        w.writerow(r)

# ============ 097 레퍼런스 결함 finding (적재 변경 없음, 기록만) ============
# digital-print 016 교훈: "레퍼런스"가 깨끗이 적재됐는지 검증 선행. 097 ref-CSV 실태:
REF097_HDR = ['table', 'observed', 'verdict', '_finding']
ref097 = [
    ['t_prd_product_processes', 'PROC_000022 떡제본 · excl_grp_cd=BLANK · mand_proc_yn=N · disp_seq=1',
     'PARTIAL', '떡제본 proc_cd 정확(마스터 정합). 단 mand_proc_yn=N(제본 필수 도메인과 불일치)·excl_grp 미연결'],
    ['t_prd_product_process_excl_groups', 'GRP-BOOK-제본 헤더 존재(SEL_TYPE.01·max1·mand=Y·note=trigger=떡제본)',
     'ORPHAN', 'excl_group 헤더는 있으나 process 행 excl_grp_cd 공란 → 미연결 고아 헤더(booklet 떡제본 spillover)'],
    ['t_prd_product_bundle_qtys', '50/QTY_UNIT.03/dflt=Y/seq=1 + 100/QTY_UNIT.03/dflt=Y/seq=1',
     'DEFECT', '두 행 모두 dflt_yn=Y(이중 기본값)·disp_seq 동일(1) — 기본값 1개 원칙 위배'],
    ['t_prd_product_page_rules', '(행 없음)', 'CORRECT-BY-DOMAIN',
     'L1 페이지사양 3/3/3 있으나 떡제본은 page 무의미(recipe §3-2 rule4) → 미적재가 도메인상 정당(잡음 회피)'],
    ['t_prd_product_materials', 'MAT_000073(백색모조지 120g) USAGE.01 dflt=Y',
     'MATCH', 'L1 백모조120 → MAT_000073 정합. 내지 단일슬롯 정상'],
]
with open(os.path.join(BASE, 'ref097-validation.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.writer(f); w.writerow(REF097_HDR)
    for r in ref097:
        w.writerow(r)

# ---- 날조 가드: 적재된 모든 proc_cd/prd_cd 마스터 실재 ----
fab = []
for row, _ in proc_active:
    if row[1] not in allproc:
        fab.append(('proc', row[1]))
    if row[0] not in prods:
        fab.append(('prd', row[0]))

# ---- 리포트 ----
print("=== R1/R2 process ACTIVE rows:", len(proc_active))
print("    제본 active:", sum(1 for r, _ in proc_active if r[1] in
      {'PROC_000018', 'PROC_000021', 'PROC_000022', 'PROC_000023'}))
print("    코팅 active:", sum(1 for r, _ in proc_active if r[1] == 'PROC_000015'))
print("    proc per prd:", dict(Counter(r[0] for r, _ in proc_active)))
print("=== process DEFERRED(use_yn=N):", len(proc_def))
print("=== process CONFIRM(제본사양 공란):", len(proc_confirm), [c[0] for c in proc_confirm])
print("=== R5 qty_unit update rows:", len(qu_rows))
print("=== 097 ref-validation findings:", len(ref097))
print("=== FK 날조 가드:", 'PASS(0)' if not fab else f'FAIL {fab}')
print("--- no-op: material(직접명 이미 적재)·page_rule(엑셀 공란/떡제본무의미)·bundle(실버링=링색)·excl_group(단일고정) ---")
