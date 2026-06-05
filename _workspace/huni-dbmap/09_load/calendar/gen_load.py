#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""calendar + design-calendar 적재 CSV 생성기 (round-3 remediation 전수 확장 · digital-print 파일럿 메서드 복제).
calendar/design-calendar는 prd_cd 108~112 완전 공유 — design-calendar는 신규행 0, editor_yn UPDATE만.
모든 행은 L1 셀 또는 ref/IMPORT 라인에 추적된다(추정 0). DB 쓰기 없음 — CSV/update-set CSV 산출만."""
import csv, os
from collections import defaultdict, Counter
BASE=os.path.dirname(os.path.abspath(__file__))
ROOT=os.path.abspath(os.path.join(BASE,'..','..'))
LOAD=os.path.join(BASE,'load'); DEF=os.path.join(BASE,'_deferred')
os.makedirs(LOAD,exist_ok=True); os.makedirs(DEF,exist_ok=True)
REGDT='2026-06-05 00:00:00'  # 적재 예정 reg_dt(설계값, FK 무관)
UPDDT='2026-06-05 00:00:00'  # UPDATE성 행의 upd_dt(설계값)

def load_csv(p):
    with open(os.path.join(ROOT,p),encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

mats={r['mat_nm'].strip():r['mat_cd'] for r in load_csv('00_schema/ref-materials.csv')}
cd2matnm={r['mat_cd']:r['mat_nm'] for r in load_csv('00_schema/ref-materials.csv')}
prods={r['prd_cd']:r for r in load_csv('00_schema/ref-products.csv')}

# ===== calendar/design-calendar 공유 prd_cd (라이브 권위, calendar.md ①·design-calendar.md ①) =====
NM2CD={'탁상형캘린더':'PRD_000108','미니탁상형캘린더':'PRD_000109','엽서캘린더':'PRD_000110',
       '벽걸이캘린더':'PRD_000111','와이드벽걸이캘린더':'PRD_000112'}
ALL_CAL=['PRD_000108','PRD_000109','PRD_000110','PRD_000111','PRD_000112']

# 기적재 라이브(stale ref 2026-06-04) — 중복 PK 회피용
existing_proc=defaultdict(set); existing_mat=defaultdict(set); existing_addon=defaultdict(set)
for r in load_csv('00_schema/ref-product-processes.csv'):
    if r['prd_cd'] in ALL_CAL: existing_proc[r['prd_cd']].add(r['proc_cd'])
for r in load_csv('00_schema/ref-product-materials.csv'):
    if r['prd_cd'] in ALL_CAL: existing_mat[r['prd_cd']].add(r['mat_cd'])
for r in load_csv('00_schema/ref-product-addons.csv'):
    if r['prd_cd'] in ALL_CAL: existing_addon[r['prd_cd']].add(r['addon_prd_cd'])
# 기적재 excl_groups 헤더 (110/111/112)
existing_excl_hdr={r['prd_cd'] for r in load_csv('00_schema/ref-product-process-excl-groups.csv')
                   if r['prd_cd'] in ALL_CAL}

# ============================================================
# R3 (High) — 자재 IMPORT 종이 적재 [material, calendar G-CL-4]
# ============================================================
# IMPORT 컬럼 → 상품 (seoljeong-import-map.csv: 탁상형8·미니7·엽서10·벽걸이22)
# 와이드(112)는 *별도설정 아님 — 직접명(스노우지/몽블랑 3절) 이미 기적재 → 적재 대상 아님(no-op).
IMPORT_MAP={'탁상형캘린더':'PRD_000108','미니탁상형캘린더':'PRD_000109',
            '엽서캘린더':'PRD_000110','벽걸이캘린더':'PRD_000111'}
papers=defaultdict(list)
with open(os.path.join(ROOT,'06_extract/import-paper-matrix-long.csv'),encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        pc=row['product_col'].strip()
        if pc in IMPORT_MAP and row['mark'].strip()=='●':
            papers[pc].append(row['paper_name'].strip())

MAT_HDR=['prd_cd','mat_cd','usage_cd','dep_proc_cd','dflt_yn','disp_seq','reg_dt','upd_dt','_provenance']
mat_rows=[]; mat_unmatched=[]; mat_skipped=[]
for impcol,cd in IMPORT_MAP.items():
    seq=1
    for pname in papers[impcol]:
        mc=mats.get(pname)
        if not mc:
            mat_unmatched.append((impcol,pname)); continue
        if mc in existing_mat[cd]:
            mat_skipped.append((cd,mc,pname,'기적재(라이브 중복 PK)')); continue
        dflt='Y' if seq==1 else 'N'
        mat_rows.append([cd, mc, 'USAGE.07','', dflt, seq, REGDT,'',
            f'IMPORT:{impcol}● {pname}→{mc} (R3 G-CL-4, seoljeong-import-map)'])
        seq+=1
with open(os.path.join(LOAD,'t_prd_product_materials.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(MAT_HDR)
    for r in mat_rows: w.writerow(r)

# ============================================================
# R1 (High, BLOCKER) — 택일그룹 멤버 연결 [process UPDATE, calendar G-CL-1]
# ============================================================
# GRP-CAL-가공 헤더는 110/111/112 적재됨. 멤버 process행 excl_grp_cd 전부 NULL → UPDATE로 연결.
# C-2 binding: 택일(하나만)=멤버 연결. entity-model: process_excl_group은 헤더+멤버FK 둘 다 필요.
# **발명 금지**: 가공없음/우드거치대/삼각대/제본없음은 master proc_cd 부재 → UPDATE 불가(flag).
#   연결 가능 = 이미 적재된 멤버 process(타공079·트윈링021)뿐.
EXCL_GRP='GRP-CAL-가공'
# 택일 멤버 후보 → master proc_cd 매핑 (라이브·recipe-tree 권위, 비명칭은 None=flag)
CAL_MEMBER_PROC={
 '타공(1구/2구)':'PROC_000079','고리형트윈링제본':'PROC_000021',
 '가공없음(재단만)':None,'우드거치대':None,'삼각대':None,'제본없음(재단만)':None,
}
# 상품별 기적재 process 중 GRP-CAL-가공 멤버여야 하는 것(라이브 calendar.md ③)
PROC_EXCL_LINK={
 'PRD_000110':[('PROC_000079','타공079=1구타공+끈 택일멤버')],
 'PRD_000111':[('PROC_000021','트윈링021=고리형트윈링 택일멤버'),
               ('PROC_000079','타공079=2구타공+끈 택일멤버')],
 'PRD_000112':[('PROC_000021','트윈링021=고리형트윈링 택일멤버')],
}
PROC_UPD_HDR=['prd_cd','proc_cd','current_excl_grp_cd','target_excl_grp_cd',
              'current_mand_proc_yn','target_mand_proc_yn','use_yn','upd_dt','_provenance']
proc_upd_rows=[]; proc_link_flag=[]
for cd,members in PROC_EXCL_LINK.items():
    if cd not in existing_excl_hdr:
        proc_link_flag.append((cd,'GRP-CAL-가공 헤더 미적재 — 연결 불가')); continue
    for pc,why in members:
        if pc not in existing_proc[cd]:
            proc_link_flag.append((cd,pc,'멤버 process 미적재 — 연결 전 적재 필요')); continue
        # mand_proc_yn: 택일그룹 멤버는 그룹 mand_yn=Y(필수 택일)이나 멤버 개별은 선택 → N 유지(SEL_TYPE.01 그룹이 필수성 담당)
        proc_upd_rows.append([cd, pc, 'NULL', EXCL_GRP, 'N','N', prods[cd]['use_yn'], UPDDT,
            f'라이브 process행 excl_grp_cd NULL → {EXCL_GRP} 연결 ({why}) (R1 G-CL-1 BLOCKER, C-2 택일 SEL_TYPE.01)'])
with open(os.path.join(LOAD,'t_prd_product_processes_excl_link_update.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(PROC_UPD_HDR)
    for r in proc_upd_rows: w.writerow(r)

# 미적재 멤버(가공없음/우드거치대/삼각대/제본없음 — master proc_cd 부재) = flag (발명 금지)
# + 108/109 excl_group 헤더 0행(삼각대 단일) → 그룹 신설 여부 컨펌
MEMBER_MISSING_HDR=['prd_cd','member_label','reason','_provenance']
member_missing=[
 ['PRD_000108','삼각대(그레이)','master proc_cd 부재(거치대=addon 후보)·108 excl_group 헤더 0행','L1:탁상형 캘린더가공=삼각대(그레이) 단일 (G-CL-2 CONFIRM, 발명 금지)'],
 ['PRD_000109','삼각대(블랙)','master proc_cd 부재·109 excl_group 헤더 0행','L1:미니탁상형 캘린더가공=삼각대(블랙) 단일 (G-CL-2 CONFIRM, 발명 금지)'],
 ['PRD_000110','가공없음(재단만)','master proc_cd 부재(택일 멤버 "가공없음")','L1:엽서 캘린더가공 택일=가공없음/우드거치대/1구타공+끈 (G-CL-1, 발명 금지)'],
 ['PRD_000110','우드거치대','=addon(PRD_000012) 단일축(G-CL-3) — process 멤버 아님','L1:엽서 캘린더가공 택일=우드거치대 (C-6 거치대=addon, 이중분류 정정)'],
 ['PRD_000111','가공없음(재단만)','master proc_cd 부재(택일 멤버)','L1:벽걸이 캘린더가공 택일=고리형트윈링/가공없음/2구타공+끈 (G-CL-1, 발명 금지)'],
 ['PRD_000112','제본없음(재단만)','master proc_cd 부재(택일 멤버)','L1:와이드 캘린더가공 택일=고리형트윈링/제본없음 (G-CL-1, 발명 금지)'],
]
with open(os.path.join(BASE,'t_prd_product_processes_excl_member_flag.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(MEMBER_MISSING_HDR)
    for r in member_missing: w.writerow(r)

# ============================================================
# R4 (Medium) — 우드거치대 이중분류 정정 [excl_group trigger 정정, calendar G-CL-3]
# ============================================================
# 110 excl_group note: trigger=우드거치대. 우드거치대는 addon(PRD_000012)으로 적재됨(110 addon).
# C-6: 거치대=addon 단일축. → excl_group note의 trigger를 우드거치대에서 process 멤버로 정정.
# UPDATE성(헤더 note) → update-set. addon 행은 유지(삭제 금지).
EXCL_NOTE_UPD_HDR=['prd_cd','excl_grp_cd','current_note','target_note','_provenance']
excl_note_upd=[
 ['PRD_000110','GRP-CAL-가공','trigger=우드거치대',
  'trigger=1구타공+끈 (우드거치대=addon PRD_000012로 분리)',
  '우드거치대 이중분류(excl trigger ↔ addon) 정정: addon 단일축 유지, trigger를 process 멤버(타공)로 (R4 G-CL-3, C-6)'],
]
with open(os.path.join(LOAD,'t_prd_product_process_excl_groups_note_update.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(EXCL_NOTE_UPD_HDR)
    for r in excl_note_upd: w.writerow(r)

# ============================================================
# C-5 — design-calendar editor_yn UPDATE [신규행 0, design-calendar G-DC-1]
# ============================================================
# design-calendar = calendar와 동일 prd_cd(108~112). 별도 상품/행 절대 금지.
# 디자인 제공 축 = editor_yn 플래그(컬럼 실재, 현재 전 5상품 N). design-calendar L1 디자인보유● → editor_yn=Y.
# **신규행 0 가드**: 이 set은 기존 108~112 UPDATE만. prd_cd ∈ ALL_CAL 강제.
# design-calendar L1: 디자인보유(●) 보유 + design-calendar 시트 등장(가격 포함) 확인.
# 디자인보유●를 1차 권위로 editor_yn=Y. 단 ● 비표시인데 가격·고정페이지가 있어 design-calendar에 등장하는
# 상품(110 엽서)은 셀 모호 → flag(발명 금지, 임의 Y/N 결정 안 함).
dc_design_yn=set(); dc_in_sheet=set()  # ●표시 / 가격 등장(시트 멤버)
with open(os.path.join(ROOT,'06_extract/design-calendar-l1.csv'),encoding='utf-8-sig') as f:
    for row in csv.DictReader(f):
        nm=row.get('prd_nm','').strip()
        if nm not in NM2CD: continue
        cd=NM2CD[nm]
        if (row.get('디자인보유','') or '').strip()=='●': dc_design_yn.add(cd)
        if (row.get('가격','') or '').strip(): dc_in_sheet.add(cd)  # 가격 있는 행 = 디자인캘린더 판매 멤버
dc_ambiguous = dc_in_sheet - dc_design_yn  # 시트엔 있으나 ● 비표시 = 셀 모호
EDITOR_UPD_HDR=['prd_cd','prd_nm','current_editor_yn','target_editor_yn','use_yn','upd_dt','_provenance']
editor_upd_rows=[]; editor_flag=[]
for cd in ALL_CAL:  # 신규행 금지: 기존 108~112만
    r=prods[cd]
    has_design = cd in dc_design_yn
    tgt='Y' if has_design else r['editor_yn']  # 디자인보유● → Y, 아니면 현행 유지(no-op)
    prov=(f'design-calendar L1 디자인보유●→editor_yn=Y (C-5, 신규행0)' if has_design
          else f'design-calendar 디자인보유(없음)→현행 유지 no-op (C-5, 신규행0)')
    if cd in dc_ambiguous:
        prov=f'design-calendar 가격 등장(시트 멤버)이나 디자인보유● 비표시 → 셀 모호, 현행 유지 no-op + flag (C-5, 발명 금지)'
        editor_flag.append((cd, r['prd_nm'], 'design-calendar 시트 등장(가격O)이나 디자인보유● 비표시 — editor_yn=Y 여부 CONFIRM'))
    editor_upd_rows.append([cd, r['prd_nm'], r['editor_yn'], tgt, r['use_yn'], UPDDT, prov])
with open(os.path.join(LOAD,'t_prd_products_editor_yn_update.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(EDITOR_UPD_HDR)
    for r in editor_upd_rows: w.writerow(r)

# ============================================================
# R6 (Medium) — qty_unit 일괄 부여 [UPDATE set, calendar G-CL-6]
# ============================================================
# C-4 binding: 캘린더=EA=QTY_UNIT.01. 라이브 현재 전 NULL.
QU_HDR=['prd_cd','prd_nm','current_qty_unit_typ_cd','target_qty_unit_typ_cd','use_yn','upd_dt','_provenance']
qu_rows=[]
for cd in ALL_CAL:
    r=prods[cd]
    qu_rows.append([cd, r['prd_nm'], r['qty_unit_typ_cd'] or 'NULL','QTY_UNIT.01', r['use_yn'], UPDDT,
        'C-4 상품군별 일괄(캘린더=EA=QTY_UNIT.01). 라이브 현재 NULL (R6 G-CL-6)'])
with open(os.path.join(LOAD,'t_prd_products_qtyunit_update.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(QU_HDR)
    for r in qu_rows: w.writerow(r)

# ============================================================
# G-CL-5 / G-DC-4 (DEFERRED) — 장수/페이지(page_rule) / 링칼라 조건부
# ============================================================
# 장수(calendar)=4(8P)/8(16P)… 다중·page vs variant 미확정(CONFIRM). design-calendar 페이지=단일 고정(30P/26P/12P/13P).
# 링칼라=★고리형트윈링선택시만(조건부 자식). 발명 금지 → 전부 deferred + flag.
PAGE_DEF_HDR=['prd_cd','sheet','page_label','interpretation','reason','_provenance']
page_def=[]
# calendar 장수 (다중 — variant/page 미확정)
CAL_JANGSU={'PRD_000108':'4(8P)/8(16P)/12(24P)/16(32P)','PRD_000109':'12(24P)/16(32P)',
            'PRD_000110':'12/13/14/15/16','PRD_000111':'4~15(8P~30P)','PRD_000112':'4~15(8P~30P)'}
for cd,lab in CAL_JANGSU.items():
    page_def.append([cd,'calendar',lab,'장수↔페이지 다중(variant 또는 page_rule min/max 미확정)',
        'G-CL-5 CONFIRM: 장수=variant인가 page_rule인가 미확정 (발명 금지)',
        f'L1 calendar 장수(필수)={lab}'])
# design-calendar 페이지 (단일 고정 — page_rule min=max 자연스러우나 G-DC-1 인코딩 의존)
DC_PAGE={'PRD_000108':'30P','PRD_000109':'26P','PRD_000110':'12P','PRD_000111':'13P','PRD_000112':'13P'}
for cd,lab in DC_PAGE.items():
    page_def.append([cd,'design-calendar',lab,'페이지 단일 고정(page_rule min=max 또는 고정 variant)',
        'G-DC-4 CONFIRM: 고정 페이지 적재방식 미확정(G-DC-1 editor_yn 인코딩에 의존) (발명 금지)',
        f'L1 design-calendar 페이지사양={lab} 단일'])
# 링칼라 조건부 (111/112 ★고리형트윈링선택시만)
page_def.append(['PRD_000111','calendar','링칼라(블랙)','고리형트윈링 선택시만 조건부 자식 옵션',
    'G-CL-5 CONFIRM: 조건부 의존(트윈링 proc param vs 별도 옵션) 인코딩 미확정 (발명 금지)',
    'L1 calendar 링칼라=★고리형트윈링제본선택시만'])
page_def.append(['PRD_000112','calendar','링칼라(블랙)','고리형트윈링 선택시만 조건부 자식 옵션',
    'G-CL-5 CONFIRM: 조건부 의존 인코딩 미확정 (발명 금지)',
    'L1 calendar 링칼라=★고리형트윈링제본선택시만'])
with open(os.path.join(DEF,'page_rule_ringcolor_deferred.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(PAGE_DEF_HDR)
    for r in page_def: w.writerow(r)

# ============================================================
# G-CL-4 보강 — 삼각대/링 mis-axis 자재 flag (삭제 금지, 정정 제안만)
# ============================================================
# 108/109 기적재 "material" = 삼각대(MAT_000252/254)·링블랙(MAT_000253) = 거치대/링칼라 축.
# 종이 아님 → mis-axis. EXTRA 삭제 절대 금지 → flag만(거치대=addon, 링=process param 후보).
MISAXIS_HDR=['prd_cd','mat_cd','mat_nm','current_axis','suggested_axis','reason']
misaxis=[]
MISAXIS_MATS={'MAT_000252':('삼각대(그레이)','addon/process(거치대)'),
              'MAT_000254':('삼각대(블랙)','addon/process(거치대)'),
              'MAT_000253':('링 블랙','process param(링칼라, 트윈링 자식)')}
for cd in ALL_CAL:
    for mc in sorted(existing_mat[cd]):
        if mc in MISAXIS_MATS:
            nm,sug=MISAXIS_MATS[mc]
            misaxis.append([cd, mc, nm, 'material(자재)', sug,
                'mis-axis: 거치대/링칼라가 material로 적재됨(종이 아님). 삭제 금지·축 정정 CONFIRM (G-CL-3/G-CL-5)'])
with open(os.path.join(BASE,'material_misaxis_flag.csv'),'w',newline='',encoding='utf-8') as f:
    w=csv.writer(f); w.writerow(MISAXIS_HDR)
    for r in misaxis: w.writerow(r)

# ============================================================
# 리포트
# ============================================================
print("=== R3 material (IMPORT 종이) rows:", len(mat_rows), "| unmatched:", len(mat_unmatched), "| skipped(기적재):", len(mat_skipped))
print("    material per prd:", dict(Counter(r[0] for r in mat_rows)))
for u in mat_unmatched: print("    MAT UNMATCHED:", u)
for s in mat_skipped: print("    MAT SKIP:", s)
print("=== R1 process excl_grp_cd LINK update rows:", len(proc_upd_rows), "| flag:", len(proc_link_flag))
print("    link per prd:", dict(Counter(r[0] for r in proc_upd_rows)))
print("=== R1 excl member MISSING flag rows (발명 금지):", len(member_missing))
print("=== R4 excl_group note update rows (우드거치대 정정):", len(excl_note_upd))
print("=== C-5 editor_yn UPDATE rows:", len(editor_upd_rows), "(신규행 0, prd_cd⊆ALL_CAL 강제)")
print("    editor_yn→Y:", [r[0] for r in editor_upd_rows if r[3]=='Y'])
print("    editor_yn flag(셀 모호):", editor_flag)
print("=== R6 qty_unit UPDATE rows:", len(qu_rows), "(캘린더=EA=QTY_UNIT.01)")
print("=== DEFERRED page/ring rows:", len(page_def))
print("=== material mis-axis flag rows (삭제 금지):", len(misaxis))
# 신규행 0 가드 (design-calendar)
nonmember=[r[0] for r in editor_upd_rows if r[0] not in ALL_CAL]
assert not nonmember, f"FATAL: design-calendar 신규행 발생 {nonmember}"
print("=== GUARD: design-calendar 신규행 0 확인 OK (editor set 전건 ⊆ 108~112)")
