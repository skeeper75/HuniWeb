#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""acrylic 적재 CSV 생성기 — round-3 remediation 전수 확장.
   L1(acrylic-l1.csv) + ref 마스터(ref-materials/processes/products)에서 적재행을 도출한다.
   DB 쓰기 없음 — CSV 산출만. provenance 컬럼으로 모든 행을 L1 셀/ref 라인에 추적.
   재현: python3 gen_load.py  (load/*.csv + _deferred/*.csv 재생성)

   설계근거: 08_remediation/acrylic.md ⑤ R1~R8, _confirmations.md C-1/C-4/C-6/C-7/C-8,
            07_domain entity-semantic-model §2-3 + process-recipe-tree.
   @MX:NOTE 시트 확장 시 PRODUCTS 테이블·매핑 규칙 교체.
"""
import csv, os
BASE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(BASE, '..', '..'))
LOAD = os.path.join(BASE, 'load')
DEF = os.path.join(BASE, '_deferred')
os.makedirs(LOAD, exist_ok=True)
os.makedirs(DEF, exist_ok=True)
REG = '2026-06-05 00:00:00'  # 적재 reg_dt 자리표시(실 적재 시 now())

# ===== ref 로드 =====
def load_csv(p):
    with open(os.path.join(ROOT, p), encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))
prods = {r['prd_cd']: r for r in load_csv('00_schema/ref-products.csv')}
mats = {r['mat_cd']: r for r in load_csv('00_schema/ref-materials.csv')}
procs = {r['proc_cd']: r for r in load_csv('00_schema/ref-processes.csv')}

# ===== acrylic 상품 매핑 테이블 (L1 권위, 두께/부속/완칼/UV/조각수/nonspec 명시) =====
# 필드:
#   thickness_mat : L1 소재 두께 → MAT 코드(192 일괄 정정 대상). None=정정 불가/no-op.
#   thickness_src : provenance용 L1 소재 표기
#   accessories   : L1 가공(옵션) 부속명 → (MAT 부속코드 or None) 리스트. 자석부착/맥세이프=부착공정.
#   uv_variants   : L1 인쇄사양 = UV 변형 enum (현 print_side 오적재 → process 이동 + print_side 정정)
#   piece_counts  : L1 조각수(옵션) 정수 리스트(C-7 bundle_qty)
#   diecut        : 완칼 PROC_000053 적재 대상(아크릴 묵시 필수, G-AC-1)
#   nonspec       : (wmin,wmax,hmin,hmax) 사용자입력 비규격 범위 or None
#   addon_volchain: 볼체인 addon 보유(키링·포카키링)
# use_yn / hidden / registered 는 ref/L1에서 자동 판정.

PRODUCTS = {
 'PRD_000146': dict(nm='아크릴키링', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('고리없음', None), ('은색고리','MAT_000051'), ('금색고리','MAT_000052')],
   uv_variants=['배면양면'], nonspec=(20,100,20,100), addon_volchain=True),
 'PRD_000147': dict(nm='아크릴마그넷', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('자석부착','ATTACH')], uv_variants=['풀빼다','투명테두리','단면인쇄'], nonspec=(20,80,20,80)),
 'PRD_000148': dict(nm='아크릴뱃지', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('원형핀','MAT_000047'), ('1구자석','MAT_000048')], uv_variants=['풀빼다','투명테두리'], nonspec=(30,80,30,80)),
 'PRD_000149': dict(nm='아크릴집게', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('투명집게','MAT_000056')], uv_variants=['풀빼다','투명테두리'], nonspec=(30,60,30,60)),
 'PRD_000150': dict(nm='아크릴스마트톡', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('화이트바디','MAT_000054'), ('투명바디','MAT_000053')], uv_variants=['투명테두리'], nonspec=(50,80,50,80)),
 'PRD_000151': dict(nm='맥세이프 스마트톡', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('맥세이프스마트톡','MAT_000055_ATTACH')], uv_variants=['투명테두리'], nonspec=(50,80,50,80)),
 'PRD_000152': dict(nm='아크릴명찰', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('일자핀','MAT_000046'), ('2구자석','MAT_000049')], uv_variants=['풀빼다'], nonspec=(60,80,20,50)),
 'PRD_000153': dict(nm='아크릴명찰(골드실버)', diecut=True, thickness_mat=None, thickness_src='골드아크릴 3mm | 실버아크릴 3mm',
   accessories=[('일자핀','MAT_000046'), ('2구자석','MAT_000049')], uv_variants=['풀빼다'], nonspec=(60,80,20,50),
   thickness_note='골드/실버는 색상 자재(195/196) 이미 정상 적재 — 두께정정 대상 아님(C-8)'),
 'PRD_000154': dict(nm='아크릴 머리끈', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('블랙헤어끈','MAT_000057')], uv_variants=[], nonspec=(20,40,20,40)),
 'PRD_000155': dict(nm='아크릴볼펜', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('블랙',None),('레드',None),('오렌지',None),('라이트그린',None),('블루',None),('바이올렛',None)],
   uv_variants=['풀빼다'], nonspec=(20,40,20,40),
   acc_note='볼펜 색상=완제 볼펜바디 색(부속 마스터 미존재) — 추정금지, 부속 미적재(flag)'),
 'PRD_000156': dict(nm='아크릴지비츠', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('투명',None),('스핀',None)], uv_variants=['풀빼다'], nonspec=(15,35,15,35),
   acc_note='지비츠 투명/스핀=형상 variant(부속 아님) — 부속 미적재'),
 'PRD_000157': dict(nm='아크릴네임택', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[('선택안함',None),('와이어링(실버)',None),('와이어링(화이트)',None),('와이어링(블랙)',None),('스트랩(투명)',None)],
   uv_variants=['배면양면'], nonspec=None,
   acc_note='와이어링/스트랩=완제 부속(마스터 미존재) — 추정금지, 부속 미적재(flag)'),
 'PRD_000158': dict(nm='아크릴 포카키링', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[], uv_variants=['배면양면'], nonspec=None, addon_volchain=True),
 'PRD_000159': dict(nm='아크릴 코스터', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[], uv_variants=['배면양면'], nonspec=None),
 'PRD_000160': dict(nm='아크릴자유형스탠드', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[], uv_variants=['배면양면'], piece_counts=[2,3,4,5,6], nonspec=None),
 'PRD_000161': dict(nm='판아크릴', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[], uv_variants=['배면양면'], nonspec=None),
 'PRD_000162': dict(nm='아크릴포카스탠드', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm',
   accessories=[], uv_variants=['배면양면'], nonspec=None),
 'PRD_000163': dict(nm='아크릴미니파츠', diecut=True, thickness_mat='MAT_000042', thickness_src='투명아크릴 1.5mm',
   accessories=[], uv_variants=['배면양면'], piece_counts=[10], nonspec=None),
 'PRD_000164': dict(nm='아크릴코롯토', diecut=True, thickness_mat='MAT_000044', thickness_src='투명아크릴 8mm | (8T)',
   accessories=[], uv_variants=['배면양면'], nonspec=(30,80,30,80)),
 'PRD_000165': dict(nm='포카코롯토', diecut=True, thickness_mat='MAT_000044', thickness_src='투명아크릴 8mm',
   accessories=[], uv_variants=['배면양면'], nonspec=None),
 'PRD_000166': dict(nm='아크릴카라비너', diecut=True, thickness_mat='MAT_000043', thickness_src='투명아크릴 3mm+3mm 접합',
   accessories=[('실버고리','MAT_000051'),('골드고리','MAT_000052'),('화이트고리',None),('블랙고리',None),
                ('레드고리',None),('하늘고리',None),('핑크고리',None)],
   uv_variants=['배면양면'], nonspec=None,
   thickness_note='3mm+3mm 접합 → 3mm(043) + note(접합). 접합은 공정(부착/라미)이나 마스터 접합공정 부재 — 두께만 정정',
   acc_note='고리 색상 다수: 실버/골드만 부속코드 실재(051/052), 나머지 색상 부속 미존재 → 색상 variant(추정금지, 미적재)'),
 'PRD_000168': dict(nm='아크릴입체코롯토', diecut=True, thickness_mat=None, thickness_src='(L1 소재 없음)',
   accessories=[], uv_variants=[], nonspec=None,
   thickness_note='L1 소재칸 공란 — 정정 대상 자재행 자체 미적재(no-op). nonspec_yn=Y(라이브)'),
 'PRD_000169': dict(nm='아크릴입체블럭', diecut=True, thickness_mat=None, thickness_src='투명아크릴라미(10T)',
   accessories=[], uv_variants=[], nonspec=None,
   thickness_note='라미(10T) 두께코드 마스터 부재(042/043/044=1.5/3/8mm만) → 발명금지, 192 유지+flag'),
}

# ===== L1 nonspec 범위는 위 테이블에 명시(L1 비규격_가로/세로 셀 권위). 자동 일치 검증은 verify가 수행. =====

# 활성/비활성 판정(ref-products use_yn) — 비활성은 _deferred로 분리(C-1)
def is_active(cd):
    return prods.get(cd, {}).get('use_yn') == 'Y'

# ============ 1) material : 두께 정정(UPDATE성) + 부속 자재 적재(INSERT) ============
# 두께 정정 = 기존 192 1행을 두께코드로 교체 → update-set(별도 CSV, _provenance).
# 부속 = MAT_TYPE.07 신규 INSERT 행.
mat_update_rows = []   # 두께 정정(UPDATE)
mat_insert_rows = []   # 부속 INSERT (active)
mat_insert_def = []    # 부속 INSERT (deferred=비활성)
for cd, p in PRODUCTS.items():
    active = is_active(cd)
    # --- 두께 정정 ---
    tm = p.get('thickness_mat')
    if tm:
        mat_update_rows.append(dict(
            prd_cd=cd, usage_cd='USAGE.07', current_mat_cd='MAT_000192',
            target_mat_cd=tm, target_mat_nm=mats[tm]['mat_nm'], use_yn=prods[cd]['use_yn'],
            _provenance=f"L1:{p['nm']} 소재={p['thickness_src']} → {tm} 두께정정(192 평면화 해소, G-AC-3/C-8)"))
    # --- 부속 자재 INSERT (MAT_TYPE.07) ---
    seq = 1
    for accname, code in p.get('accessories', []):
        if code is None:
            continue  # 마스터 부속코드 미존재 → 발명금지(미적재). acc_note 참조.
        if code.endswith('_ATTACH') or code == 'ATTACH':
            continue  # 부착공정으로 처리(아래 process 블록). 자재행 아님.
        row = dict(prd_cd=cd, mat_cd=code, usage_cd='USAGE.07', dep_proc_cd='',
                   dflt_yn='N', disp_seq=10 + seq, reg_dt=REG, upd_dt='',
                   _provenance=f"L1:{p['nm']} 가공(옵션)={accname} → 부속자재 {code} {mats[code]['mat_nm']} (MAT_TYPE.07, G-AC-3)")
        (mat_insert_rows if active else mat_insert_def).append(row)
        seq += 1

# ============ 2) process : 완칼(053) + 조각수(bundle_qty) + 부착(081) + UV변형(002) ============
proc_rows = []      # active INSERT
proc_def = []       # deferred INSERT
# disp_seq: UV=5(인쇄방식), 완칼=12(완칼 마스터 disp), 부착=19
for cd, p in PRODUCTS.items():
    active = is_active(cd)
    target = proc_rows if active else proc_def
    # 완칼 (G-AC-1, 묵시필수) — PROC_000053
    if p.get('diecut'):
        target.append(dict(prd_cd=cd, proc_cd='PROC_000053', excl_grp_cd='',
            mand_proc_yn='Y', disp_seq=12, reg_dt=REG, upd_dt='',
            _provenance=f"도메인(아크릴 die-cut 묵시필수, G-AC-1/C-7): {p['nm']} → 완칼 PROC_000053 (모양 param=사용자입력형)"))
    # UV 변형 (G-AC-5) — PROC_000002, print_side 오적재를 process로 이동
    for v in p.get('uv_variants', []):
        target.append(dict(prd_cd=cd, proc_cd='PROC_000002', excl_grp_cd='',
            mand_proc_yn='Y', disp_seq=5, reg_dt=REG, upd_dt='',
            _provenance=f"L1:{p['nm']} 인쇄사양={v} → UV PROC_000002 변형 enum (print_side 오적재 정정, G-AC-5/§3)"))
        break  # UV process 1행/상품(변형은 prcs_dtl_opt param, 변형값 다수=1 process). 변형 목록은 print_side update-set에 기록.
    # 부착 (G-AC-4) — PROC_000081
    for accname, code in p.get('accessories', []):
        if code and (code.endswith('_ATTACH') or code == 'ATTACH'):
            target.append(dict(prd_cd=cd, proc_cd='PROC_000081', excl_grp_cd='',
                mand_proc_yn='N', disp_seq=19, reg_dt=REG, upd_dt='',
                _provenance=f"L1:{p['nm']} 가공={accname} → 부착 PROC_000081 (대상 param, G-AC-4/C-6)"))

# ============ 3) bundle_qty : 조각수(C-7) ============
bdl_rows = []
bdl_def = []
for cd, p in PRODUCTS.items():
    active = is_active(cd)
    target = bdl_rows if active else bdl_def
    pcs = p.get('piece_counts')
    if pcs:
        for i, n in enumerate(pcs):
            target.append(dict(prd_cd=cd, bdl_qty=n, bdl_unit_typ_cd='QTY_UNIT.01',
                dflt_yn=('Y' if i == 0 else 'N'), disp_seq=i + 1, reg_dt=REG, upd_dt='',
                _provenance=f"L1:{p['nm']} 조각수(옵션)={n}조각 → bundle_qty {n} (C-7 조각수=묶음수차원·위젯표시 조각수). bdl_unit=EA(조각 코드부재)"))

# ============ 4) print_side 정정 update-set (G-AC-5 UPDATE) ============
# 오적재된 UV변형 print_side 행 → 변형은 process로 이동, print_side는 실제 단/양면으로 정정 필요.
psupd_rows = []
for cd, p in PRODUCTS.items():
    uv = p.get('uv_variants', [])
    if uv:
        psupd_rows.append(dict(prd_cd=cd, current_print_side_values=' | '.join(uv),
            action='UV변형→PROC_000002 이동, print_side 정정필요',
            target_print_side='(실 단/양면 미상 — 컨펌 D-AC-3)', use_yn=prods[cd]['use_yn'],
            _provenance=f"라이브 print_options:{p['nm']} print_side={'/'.join(uv)} = UV변형(인쇄면 아님) → process 이동(G-AC-5)"))

# ============ 5) addon : 볼체인 (G-AC-7, 기적재 skip) ============
# 볼체인 6색은 addon 1상품(PRD_000006)의 색상 variant인지 6 addon인지 미확정(D-AC-5).
# 라이브 기적재 = PRD_000006 1행/상품(146·158). 추정금지 → 적재 변경 없음(현 1행 유지), 6색은 flag.
addon_rows = []  # 신규 적재 없음(기적재 유지) — flag만

# ============ 6) qty_unit update-set (G-AC-9, C-4 굿즈→EA) ============
quupd_rows = []
for cd, p in PRODUCTS.items():
    quupd_rows.append(dict(prd_cd=cd, prd_nm=p['nm'], current_qty_unit_typ_cd='NULL',
        target_qty_unit_typ_cd='QTY_UNIT.01', use_yn=prods[cd]['use_yn'],
        _provenance=f"C-4 굿즈→EA: {p['nm']} qty_unit NULL → QTY_UNIT.01(EA)"))

# ============ 7) nonspec update-set (G-AC-6) ============
nsupd_rows = []
for cd, p in PRODUCTS.items():
    ns = p.get('nonspec')
    if ns:
        wmin, wmax, hmin, hmax = ns
        nsupd_rows.append(dict(prd_cd=cd, prd_nm=p['nm'],
            current_nonspec_yn='N', target_nonspec_yn='Y',
            nonspec_width_min=f'{wmin:.2f}', nonspec_width_max=f'{wmax:.2f}',
            nonspec_height_min=f'{hmin:.2f}', nonspec_height_max=f'{hmax:.2f}',
            use_yn=prods[cd]['use_yn'],
            _provenance=f"L1:{p['nm']} 사용자입력+비규격 가로{wmin}~{wmax}/세로{hmin}~{hmax} → nonspec 범위(G-AC-6)"))

# ===== 출력 =====
def write(path, rows, fields):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=fields)
        w.writeheader()
        for r in rows:
            w.writerow(r)

# load/ (DB 컬럼명 정확 + _provenance)
write(os.path.join(LOAD, 't_prd_product_processes.csv'), proc_rows,
      ['prd_cd','proc_cd','excl_grp_cd','mand_proc_yn','disp_seq','reg_dt','upd_dt','_provenance'])
write(os.path.join(LOAD, 't_prd_product_materials.csv'), mat_insert_rows,
      ['prd_cd','mat_cd','usage_cd','dep_proc_cd','dflt_yn','disp_seq','reg_dt','upd_dt','_provenance'])
write(os.path.join(LOAD, 't_prd_product_bundle_qtys.csv'), bdl_rows,
      ['prd_cd','bdl_qty','bdl_unit_typ_cd','dflt_yn','disp_seq','reg_dt','upd_dt','_provenance'])
# update-set
write(os.path.join(LOAD, 't_prd_product_materials_thickness_update.csv'), mat_update_rows,
      ['prd_cd','usage_cd','current_mat_cd','target_mat_cd','target_mat_nm','use_yn','_provenance'])
write(os.path.join(LOAD, 't_prd_product_print_options_uv_update.csv'), psupd_rows,
      ['prd_cd','current_print_side_values','action','target_print_side','use_yn','_provenance'])
write(os.path.join(LOAD, 't_prd_products_qtyunit_update.csv'), quupd_rows,
      ['prd_cd','prd_nm','current_qty_unit_typ_cd','target_qty_unit_typ_cd','use_yn','_provenance'])
write(os.path.join(LOAD, 't_prd_products_nonspec_update.csv'), nsupd_rows,
      ['prd_cd','prd_nm','current_nonspec_yn','target_nonspec_yn',
       'nonspec_width_min','nonspec_width_max','nonspec_height_min','nonspec_height_max','use_yn','_provenance'])
# _deferred/ (비활성)
write(os.path.join(DEF, 't_prd_product_processes_deferred.csv'), proc_def,
      ['prd_cd','proc_cd','excl_grp_cd','mand_proc_yn','disp_seq','reg_dt','upd_dt','_provenance'])
write(os.path.join(DEF, 't_prd_product_materials_deferred.csv'), mat_insert_def,
      ['prd_cd','mat_cd','usage_cd','dep_proc_cd','dflt_yn','disp_seq','reg_dt','upd_dt','_provenance'])
write(os.path.join(DEF, 't_prd_product_bundle_qtys_deferred.csv'), bdl_def,
      ['prd_cd','bdl_qty','bdl_unit_typ_cd','dflt_yn','disp_seq','reg_dt','upd_dt','_provenance'])

# 요약 출력
print("=== gen_load (acrylic) ===")
print(f"process active        : {len(proc_rows)}")
print(f"  완칼(053)           : {sum(1 for r in proc_rows if r['proc_cd']=='PROC_000053')}")
print(f"  UV(002)             : {sum(1 for r in proc_rows if r['proc_cd']=='PROC_000002')}")
print(f"  부착(081)           : {sum(1 for r in proc_rows if r['proc_cd']=='PROC_000081')}")
print(f"process deferred      : {len(proc_def)}")
print(f"material 부속 active   : {len(mat_insert_rows)}")
print(f"material 부속 deferred : {len(mat_insert_def)}")
print(f"material 두께정정 update: {len(mat_update_rows)}")
print(f"bundle_qty active     : {len(bdl_rows)} (조각수)")
print(f"bundle_qty deferred   : {len(bdl_def)}")
print(f"print_side UV update   : {len(psupd_rows)}")
print(f"qty_unit update       : {len(quupd_rows)}")
print(f"nonspec update        : {len(nsupd_rows)}")
