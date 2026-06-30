#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
hpr-readiness-evaluator — 척추 285상품 전수 준비도 평가 (결정론 조인).
재사용 우선[HARD]: scoreboard-general/sets(D5/D2/D7/D11)·price-formula-master(D2)·
formula-block-map(D2)·§21 conformance-checklist(D1/D6~D10 needed)를 1차 증거로 조인.
라이브 실측은 D5 keystone 검증(scoreboard=batch 시뮬레이터 산출·2026-06-29 fresh·frm 라이브 정합 확인필).
"""
import csv, json, os
from collections import defaultdict

ROOT = "/Users/innojini/Dev/HuniWeb"
FND = f"{ROOT}/_workspace/_foundation"
OUT = f"{ROOT}/_workspace/huni-product-readiness/02_readiness"
SPINE = f"{ROOT}/_workspace/huni-product-readiness/00_spine/product-spine.csv"
CHECKLIST = f"{ROOT}/_workspace/huni-catalog-conformance/01_authority/conformance-checklist.csv"

# ---- load reuse artifacts ----
def load_csv(path):
    with open(path, encoding='utf-8-sig') as f:
        return list(csv.DictReader(f))

sg = {r['prd_cd']: r for r in load_csv(f"{FND}/batch/scoreboard-general.csv")}
sets = {r['prd_cd']: r for r in load_csv(f"{FND}/batch/scoreboard-sets.csv")}
# scoreboard-summary: PR 골든 대조 데이터(현재 digital-print 10상품·pansu 저청구 조사신호)
prov = {r['prd_cd']: r for r in load_csv(f"{FND}/batch/scoreboard-summary.csv")}
pfm = {r['prd_cd']: r for r in load_csv(f"{FND}/price-formula-master.csv")}
# formula-block-map: multiple rows per prd; collapse to binding status
fbm = defaultdict(list)
for r in load_csv(f"{FND}/formula-block-map-260629.csv"):
    fbm[r['prd_cd']].append(r)
# conformance checklist needed flags
need = defaultdict(dict)
for r in load_csv(CHECKLIST):
    need[r['prd_cd']][r['axis']] = r['needed'].strip()

# ---- weights (rubric §3) ----
W = {'D1':10,'D2':12,'D3':12,'D4':12,'D5':16,'D6':8,'D7':8,'D8':6,'D9':6,'D10':4,'D11':6}
SCORE = {'PASS':1.0,'WARN':0.5,'FAIL':0.0}
DIM_NAME = {
 'D1':'구성요소 요건','D2':'가격공식 바인딩','D3':'가격구성요소·단가행','D4':'차원 충전',
 'D5':'계산 가능성','D6':'기초마스터','D7':'옵션','D8':'추가상품 템플릿','D9':'제약조건',
 'D10':'판형 매핑','D11':'매핑 정합'}

def yn(prd, axis):
    return need.get(prd, {}).get(axis, '?')

# ---- per-product evaluation ----
def evaluate(row):
    prd = row['prd_cd'].strip()
    nm  = row['엑셀prd_nm'].strip() or row['이전사이트상품'].strip()
    grp = row['상품군'].strip()
    paper = row['종이류여부'].strip()   # Y/N/N/A
    typ = row['prd_typ'].strip()        # PRD_TYPE.01/.02/.03
    match = row['매칭상태'].strip()
    note_spine = row['비고'].strip()
    g = sg.get(prd); s = sets.get(prd); m = pfm.get(prd); blocks = fbm.get(prd, [])

    is_gisung = typ == 'PRD_TYPE.03'           # 기성(제조없음)
    is_semi   = typ == 'PRD_TYPE.02'           # 반제품(셋트구성원)
    is_set    = prd in sets                     # 셋트 완제품
    unregistered = (not prd)                   # 엑셀-only

    dims = {}
    notes = {}
    expected = {}
    actual = {}

    # ---------- helpers from sources ----------
    calc_status = (g or {}).get('calc_status','') or (s or {}).get('status','')
    priced = int((g or {}).get('priced','0') or 0)
    frm = (g or {}).get('frm','') or (s or {}).get('set_frm','') or ''
    if frm in ('(없음)',): frm = ''
    R1 = (g or {}).get('R1_contamination','').strip()
    R3ok = (g or {}).get('R3_dflt_ok','').strip()
    n_dflt = (g or {}).get('n_dflt','').strip()
    OC = (g or {}).get('OC_score','').strip()
    OC_miss = (g or {}).get('OC_missing','').strip()
    pansu = (g or {}).get('pansu_match','').strip()
    pfm_status = (m or {}).get('status','')
    pfm_method = (m or {}).get('calc_method','')
    pfm_gap = (m or {}).get('gap_note','')
    set_status = (s or {}).get('status','')

    # binding present?
    block_bound = any(b['status']=='바인딩있음' for b in blocks)
    # R1 정밀 분류: 진짜 silent 합산(타 상품 부속 묵음가산) vs 자기 구성부품(false-positive 가드)
    GENUINE_CONTAM = ('볼펜','지비츠','키링','면끈','자석','고리')
    r1_genuine = bool(R1) and any(k in R1 for k in GENUINE_CONTAM)

    # ================= D1 구성요소 요건 =================
    nd1 = any(yn(prd,a)=='Y' for a in ('자재','공정','사이즈코드','도수'))
    if is_gisung:
        dims['D1']='PASS'; expected['D1']='기성상품-최소 BOM(제조없음·고정가 부속)'; actual['D1']='기성 등록(부속물)'; notes['D1']='기성=제조없음·BOM 최소'
    elif unregistered:
        dims['D1']='FAIL'; expected['D1']='상품·구성요소 등록'; actual['D1']='미등록(엑셀-only)'; notes['D1']='라이브 미적재'
    elif calc_status=='OK' or pfm_status=='BOUND_OK' or block_bound:
        dims['D1']='PASS'; expected['D1']='자재·공정·사이즈·도수 BOM'; actual['D1']='BOM 적재(공식 계산됨)'; notes['D1']='계산성립=구성요소 존재'
    elif is_semi:
        dims['D1']='PASS'; expected['D1']='반제품 구성요소(표지/면지/내지)'; actual['D1']='반제품 등록'; notes['D1']='셋트 구성원'
    elif prd in need:
        dims['D1']='PASS' if nd1 else 'WARN'; expected['D1']='권위 요구 BOM 축'; actual['D1']='§21 needed 축 등록'; notes['D1']='§21 존재 스캐폴드'
    else:
        dims['D1']='WARN'; expected['D1']='BOM'; actual['D1']='확인 필요'; notes['D1']='checklist 미수록'

    # ================= D2 가격공식 바인딩 =================
    if is_gisung:
        dims['D2']='N/A'; expected['D2']='공식 불필요(고정가 부속)'; actual['D2']='inline 고정가'; notes['D2']='제조없음'
    elif unregistered:
        dims['D2']='FAIL'; expected['D2']='상품-공식 바인딩'; actual['D2']='미등록'; notes['D2']=''
    elif is_semi:
        # 반제품: 내지=공식O / 표지·면지=공식X 가격0(셋트서 가격) → 공식없음=정상
        if frm:
            dims['D2']='PASS'; expected['D2']='반제품 공식(내지 page파생)'; actual['D2']=f'{frm} 바인딩'; notes['D2']=''
        else:
            dims['D2']='N/A'; expected['D2']='표지/면지=공식無(셋트서 가격)'; actual['D2']='가격0·생산연결'; notes['D2']='반제품 역할별(표지/면지)'
    elif frm:
        if pfm_status=='BOUND_DEFECT':
            dims['D2']='WARN'; notes['D2']='바인딩 결함(BOUND_DEFECT)'
        else:
            dims['D2']='PASS'; notes['D2']=''
        expected['D2']='상품-공식 + formula_components 배선'; actual['D2']=f'{frm} 바인딩'
    elif pfm_status in ('DESIGNED_NOT_LOADED','DESIGN_BLOCKED'):
        dims['D2']='FAIL'; expected['D2']='설계 공식 적재'; actual['D2']=f'설계됨·미적재({pfm_status})'; notes['D2']=pfm_gap[:60]
    else:  # LIVE_UNBOUND / NEEDS_BASICS_FIRST / UNBOUND
        dims['D2']='FAIL'; expected['D2']='상품-공식 바인딩'; actual['D2']=f'미바인딩(frm None·{pfm_status or calc_status})'; notes['D2']='UNBOUND'

    # ================= D3 단가행 · D4 차원충전 =================
    d2 = dims['D2']
    for d,label in (('D3','가격구성요소·단가행'),('D4','차원 충전')):
        if d2=='N/A':
            dims[d]='N/A'; expected[d]='N/A(공식없음)'; actual[d]='-'; notes[d]=''
        elif d2=='FAIL':
            dims[d]='FAIL'; expected[d]='공식 선결 필요'; actual[d]='공식 미바인딩→cap'; notes[d]='D2 FAIL caps'
        elif calc_status=='PRICED-0':
            dims[d]='FAIL'; expected[d]='단가행/차원 충전'; actual[d]='PRICED-0(단가행/차원 결손)'; notes[d]='가격0 결함'
        elif calc_status in ('UNSCORED-축미탑재',):
            dims[d]='WARN' if d=='D3' else 'FAIL'; expected[d]='차원 enumerate'; actual[d]='축 미탑재(siz/면적 미노출)'; notes[d]='차원 미충전'
        elif calc_status in ('OFFGRID-격자밖',):
            dims[d]='WARN'; expected[d]='격자 셀 충전'; actual[d]='off-grid(ceiling)'; notes[d]='격자밖 케이스'
        elif calc_status=='OK' or set_status.startswith('PRICED'):
            dims[d]='PASS'; expected[d]='전 셀/차원 충전'; actual[d]='계산성립(셀 전수 미검증·§26 파일럿만)'; notes[d]='OK·셀전수 보강대상'
        else:
            dims[d]='WARN'; expected[d]='단가행/차원'; actual[d]=calc_status or '미확인'; notes[d]=''

    # ================= D5 계산가능성 [키스톤] =================
    pv = prov.get(prd, {})
    pr_verdict = pv.get('PR_verdict','').strip()
    pr_golden = pv.get('PR_golden','').strip()
    pr_engine = pv.get('PR_engine','').strip()
    pr_pct = pv.get('PR_pct','').strip()
    if d2=='N/A':
        dims['D5']='N/A'; expected['D5']='N/A(고정가 부속/반제품)'; actual['D5']='-'; notes['D5']=''
    elif d2=='FAIL':
        dims['D5']='FAIL'; expected['D5']='evaluate_price≠0'; actual['D5']='공식없음→계산불가'; notes['D5']='D2 FAIL caps'
    elif calc_status=='PRICED-0' or set_status.startswith('BLOCKED'):
        dims['D5']='FAIL'; expected['D5']='PRICE≠0'; actual['D5']='PRICE=0(PRICED-0/BLOCKED)'; notes['D5']='★결함신호'
    elif set_status.startswith('PRICED(★이중합산'):
        dims['D5']='WARN'; expected['D5']='셋트가 정합'; actual['D5']=f"{(s or {}).get('final_price','')}(이중합산 의심)"; notes['D5']='이중합산 의심'
    elif calc_status=='OK' or set_status.startswith('PRICED'):
        if pr_verdict=='mismatch':
            dims['D5']='WARN'; actual['D5']=f"PRICE≠0·골든 mismatch({pr_pct}%)"; notes['D5']='골든 불일치=조사신호(pansu 저청구·C트랙)'
        else:
            dims['D5']='PASS'; actual['D5']='PRICE≠0(라이브 시뮬 산출)'; notes['D5']=('골든 미대조' if pr_verdict in ('','no-pcode','no-golden') else '')
        expected['D5']='PRICE≠0 AND 골든 일치'
    elif calc_status in ('UNSCORED-축미탑재','OFFGRID-격자밖'):
        dims['D5']='WARN'; expected['D5']='전 케이스 PRICE≠0'; actual['D5']=calc_status; notes['D5']='축미탑재/격자밖'
    else:
        dims['D5']='WARN'; expected['D5']='PRICE≠0'; actual['D5']=calc_status or '미실측'; notes['D5']=''

    # ================= D6 기초마스터 =================
    if unregistered:
        dims['D6']='FAIL'; expected['D6']='-'; actual['D6']='미등록'; notes['D6']=''
    elif r1_genuine:  # 타상품 부속 묵음가산=코드 오매핑 신호(겸 D11)
        dims['D6']='WARN'; expected['D6']='상품 BOM↔마스터 코드 정합'; actual['D6']=f'타상품 부속 혼입({R1[:40]})'; notes['D6']='R1 오염'
    elif dims['D1'] in ('PASS',) and calc_status=='OK':
        dims['D6']='PASS'; expected['D6']='mat/siz/proc/clr 코드 정합'; actual['D6']='코드 환원 정상(계산성립)'; notes['D6']=''
    elif is_gisung or is_semi:
        dims['D6']='PASS'; expected['D6']='최소 코드'; actual['D6']='등록'; notes['D6']=''
    else:
        dims['D6']='WARN'; expected['D6']='마스터 코드 정합'; actual['D6']='확인 필요'; notes['D6']=''

    # ================= D7 옵션 =================
    nd7 = yn(prd,'옵션그룹')=='Y' or yn(prd,'인쇄옵션')=='Y'
    if unregistered:
        dims['D7']='FAIL'; expected['D7']='-'; actual['D7']='미등록'; notes['D7']=''
    elif is_gisung or is_semi:
        dims['D7']='N/A'; expected['D7']='옵션 불필요'; actual['D7']='-'; notes['D7']=''
    elif OC:
        ocv = float(OC)
        if not nd7 and ocv>=100:
            dims['D7']='PASS'; notes['D7']='요구 옵션축 충족'
        elif ocv>=100:
            dims['D7']='PASS'; notes['D7']=''
        elif ocv>=80:
            dims['D7']='WARN'; notes['D7']=f'일부 옵션축 미충족({OC_miss})'
        elif ocv>=60:
            dims['D7']='WARN'; notes['D7']=f'옵션축 미충족({OC_miss})'
        else:
            dims['D7']='FAIL'; notes['D7']=f'손님 선택축 부재({OC_miss})'
        expected['D7']=f'OC 요구축(needed={"Y" if nd7 else "N"})'; actual['D7']=f'OC={OC}'+(f'·미충족={OC_miss}' if OC_miss else '')
    elif not nd7:
        dims['D7']='N/A'; expected['D7']='옵션 불필요(단순상품)'; actual['D7']='-'; notes['D7']=''
    else:
        dims['D7']='WARN'; expected['D7']='옵션 적재'; actual['D7']='OC 미측정'; notes['D7']='라이브 미실측'

    # ================= D8 추가상품 · D9 제약 =================
    for d,axis,label in (('D8','추가상품','추가상품 템플릿'),('D9','제약규칙','제약조건')):
        nd = yn(prd,axis)=='Y' or (d=='D8' and yn(prd,'추가상품 템플릿')=='Y')
        if unregistered:
            dims[d]='FAIL'; expected[d]='-'; actual[d]='미등록'; notes[d]=''
        elif not nd or is_semi or is_gisung:
            dims[d]='N/A'; expected[d]=f'{label} 불필요'; actual[d]='-'; notes[d]=''
        else:
            # §21 needed=Y이나 filled 라이브 미검증 → 보수적 WARN(확인 필요)
            dims[d]='WARN'; expected[d]=f'권위 요구 {label}'; actual[d]='§21 needed=Y·적재 라이브 미검증'; notes[d]='보강 대상'

    # ================= D10 판형 [HARD·종이류만] =================
    if paper!='Y':
        dims['D10']='N/A'; expected['D10']='비종이=판형 N/A'; actual['D10']='-'; notes['D10']='비종이 가드'
    elif unregistered:
        dims['D10']='FAIL'; expected['D10']='plate_sizes 매핑'; actual['D10']='미등록'; notes['D10']=''
    elif is_gisung:
        dims['D10']='N/A'; expected['D10']='기성-판형 무관'; actual['D10']='-'; notes['D10']=''
    elif calc_status=='OK' or set_status.startswith('PRICED'):
        dims['D10']='PASS'; expected['D10']='종이류 best-plate 매칭'; actual['D10']='판형 정합(계산성립=plate 매칭)'; notes['D10']='셀전수 미검증'
    elif calc_status=='PRICED-0':
        dims['D10']='FAIL'; expected['D10']='plate_sizes 매핑'; actual['D10']='PRICED-0(판형 미/오매핑 의심)'; notes['D10']='★판형 재처리 후보'
    elif is_semi and frm:
        dims['D10']='PASS'; expected['D10']='종이류 판형'; actual['D10']='반제품 판형'; notes['D10']=''
    elif is_semi:
        dims['D10']='N/A'; expected['D10']='반제품(셋트서 판형)'; actual['D10']='-'; notes['D10']=''
    else:
        dims['D10']='WARN'; expected['D10']='종이류 판형 정합'; actual['D10']='공식미바인딩·판형 미확인'; notes['D10']='판형 재처리 검토'

    # ================= D11 매핑정합 =================
    if unregistered:
        dims['D11']='FAIL'; expected['D11']='-'; actual['D11']='미등록'; notes['D11']=''
    elif r1_genuine:
        dims['D11']='FAIL'; expected['D11']='silent 합산 0·차원 미스매치 0'; actual['D11']=f'타상품 부속 silent 오염({R1[:40]})'; notes['D11']='★돈크리티컬·addon 템플릿화 필요'
    elif R1:
        # 자기 구성부품(링/커버/삼각대/레더/골드실버아크릴/봉투지) 또는 설치부속(끈/거치대/각목)=false-positive 가드
        dims['D11']='WARN'; expected['D11']='자기 comp만 가산'; actual['D11']=f'자재/설치부속 직결({R1[:40]})'; notes['D11']='R1 신호이나 자기부품/addon화 검토(오염 아닐 수 있음)'
    elif set_status.startswith('PRICED(★이중합산'):
        dims['D11']='WARN'; expected['D11']='이중합산 0'; actual['D11']='셋트 이중합산 의심'; notes['D11']='조사신호'
    elif dims['D2'] in ('PASS','WARN') and calc_status=='OK':
        dims['D11']='PASS'; expected['D11']='자기 comp만 가산'; actual['D11']='오염 0(계산 정합)'; notes['D11']=''
    elif is_gisung or (is_semi and dims['D2']=='N/A'):
        dims['D11']='N/A'; expected['D11']='-'; actual['D11']='-'; notes['D11']=''
    else:
        dims['D11']='WARN'; expected['D11']='매핑 정합'; actual['D11']='확인 필요'; notes['D11']=''

    # ---------- 완성률 ----------
    wsum=0.0; wapp=0.0
    for d in W:
        st = dims[d]
        if st=='N/A': continue
        wapp += W[d]; wsum += W[d]*SCORE[st]
    pct = round(wsum/wapp*100,1) if wapp else 0.0

    # ---------- 등급 L0~L4 ----------
    d1,d2_,d5 = dims['D1'],dims['D2'],dims['D5']
    # needed CPQ axes pass check for L4
    cpq_ok = all(dims[d] in ('PASS','N/A') for d in ('D7','D8','D9'))
    d10_ok = dims['D10'] in ('PASS','N/A')
    if is_gisung:
        # 기성: 제조없음·고정가 부속 → 가격공식 N/A. 등급=등록+부속가 적재 여부.
        grade = 'L0' if unregistered else 'L1(기성)'
    elif unregistered:
        grade='L0'
    elif d1=='FAIL':
        grade='L0'
    elif d2_=='FAIL':
        grade='L1'
    elif d2_=='N/A' and is_semi:
        grade='L2(반제품)'   # 반제품 표지/면지: 셋트서 가격·자체 L3 불가
    elif d5=='PASS':
        if cpq_ok and d10_ok and dims['D7'] in ('PASS','N/A'):
            grade='L4'
        else:
            grade='L3'
    elif d5 in ('WARN',):
        grade='L2+'  # 계산되나 골든/이중합산 미해소
    else:  # D5 FAIL with D2 ok
        grade='L2'

    # ---------- 위젯 클래스 ----------
    wc='TBD'
    if frm:
        if is_set or 'SET' in frm or 'PCB' in frm or 'PHOTOBOOK' in frm or 'TTEOK' in frm or 'BIND' in frm: wc='W-SET'
        elif 'ACRYL' in frm or 'CLR' in frm: wc='W-AREA'
        elif 'POSTER' in frm or 'AREA' in frm or 'JOKJA' in frm or 'LEATHER' in frm: wc='W-AREA'
        elif 'DGP' in frm: wc='W-CASCADE'
        elif 'STK' in frm or 'GANGPAN' in frm or 'FIXED' in frm: wc='W-FIX'
        else: wc='W-CASCADE'
    elif is_semi: wc='W-SET(구성원)'
    elif is_gisung: wc='W-ADDON(부속)'
    elif grp=='아크릴': wc='W-AREA(설계후확정)'
    elif grp=='스티커': wc='W-FIX(설계후확정)'
    elif grp=='실사': wc='W-AREA(설계후확정)'
    elif grp in ('책자','포토북'): wc='W-SET(설계후확정)'

    # ---------- 다음 한 걸음 ----------
    if grade.startswith('L0'):
        step='상품·구성요소 라이브 등록(엑셀-only)' if unregistered else '구성요소 BOM 적재'
    elif grade.startswith('L1'):
        step='가격공식 바인딩(§18 설계→§7 적재)' if not is_gisung else '기성 고정가 적재 확인(§7)'
    elif grade.startswith('L2(반제품)'):
        step='셋트 부모 공식 바인딩(§23)→구성원 가격연결'
    elif grade=='L2' or grade=='L2+':
        if calc_status=='PRICED-0': step='PRICED-0 결함 교정(단가행/판형 적재·§26/§7)'
        elif dims['D5']=='WARN' and set_status.startswith('PRICED(★이중'): step='셋트 이중합산 해소(§23 부모공식만)'
        elif dims['D5']=='WARN': step='골든 불일치 조사(판수/단가 대조)'
        else: step='단가행·차원 충전(§26 무결성→§7 적재)'
    elif grade=='L3':
        miss=[d for d in ('D7','D8','D9','D10') if dims[d] not in ('PASS','N/A')]
        step=f'CPQ/판형 적재({",".join(miss)})→L4' if miss else 'CPQ 옵션·제약 적재→L4'
    else:
        step='위젯 구현(가격모델 클래스 기반)'

    # 근거 string
    ev=f'calc={calc_status or set_status or "n/a"}'
    if frm: ev+=f';frm={frm}'
    if R1: ev+=f';R1={R1[:20]}'
    if OC: ev+=f';OC={OC}'
    if pfm_status: ev+=f';pfm={pfm_status}'

    # golden
    golden = {
        '입력': f"{nm} 대표케이스",
        '기대가': pr_golden or '-',
        '실제가': pr_engine or (s or {}).get('final_price','') or '-',
        '판정': pr_verdict or set_status or calc_status or '-'
    }

    detail_dims=[]
    for d in W:
        detail_dims.append({
            'code':d,'name':DIM_NAME[d],'status':dims[d],
            '점수':(None if dims[d]=='N/A' else SCORE[dims[d]]),
            '가중':W[d],
            '예상':expected.get(d,''),'실제':actual.get(d,''),'note':notes.get(d,'')
        })

    return {
        'prd_cd':prd or '(미등록)','상품명':nm,'상품군':grp,'종이류':paper,'prd_typ':typ,
        '등급':grade,'완성률':pct,'위젯클래스':wc,'dims':detail_dims,
        '다음한걸음':step,'골든':golden,'근거':ev,'_dimstatus':dims,
        '_flags':{'R1':R1,'calc':calc_status,'set':set_status,'frm':frm,'paper':paper,
                  'is_gisung':is_gisung,'is_semi':is_semi,'unregistered':unregistered,
                  'pfm_status':pfm_status,'pr_verdict':pr_verdict}
    }

# ---- run over spine ----
rows = load_csv(SPINE)
results=[]
for row in rows:
    row = {('이전사이트상품' if k.startswith('﻿') else k):v for k,v in row.items()}
    # skip pure annotation rows that are 엑셀-only AND have no product name token like 주석
    nm = row['엑셀prd_nm'].strip() or row['이전사이트상품'].strip()
    bigo = row['비고'].strip()
    if not row['prd_cd'].strip() and ('주석행' in bigo):
        # 비상품 주석행 — 분모서 제외(엑셀 메모)
        continue
    results.append(evaluate(row))

# ---- write scorecard.csv ----
os.makedirs(OUT, exist_ok=True)
with open(f"{OUT}/scorecard.csv",'w',newline='') as f:
    w=csv.writer(f)
    w.writerow(['prd_cd','상품명','상품군','종이류','D1','D2','D3','D4','D5','D6','D7','D8','D9','D10','D11','등급','완성률','위젯클래스','다음한걸음','근거'])
    for r in results:
        ds=r['_dimstatus']
        w.writerow([r['prd_cd'],r['상품명'],r['상품군'],r['종이류']]+[ds[d] for d in W]+
                   [r['등급'],r['완성률'],r['위젯클래스'],r['다음한걸음'],r['근거']])

# ---- write product-details.json ----
clean=[]
for r in results:
    c={k:v for k,v in r.items() if not k.startswith('_')}
    clean.append(c)
with open(f"{OUT}/product-details.json",'w') as f:
    json.dump(clean,f,ensure_ascii=False,indent=1)

# ---- lists ----
miss=[r for r in results if r['_dimstatus']['D1']=='FAIL']
# 오매핑=R1 오염 신호(진짜 silent 합산 + 자기부품/addon화 검토)·미등록 제외(누락 리스트)
mismap=[r for r in results if r['_flags']['R1'] and not r['_flags']['unregistered']]
mismap.sort(key=lambda r:(r['_dimstatus']['D11']!='FAIL', r['prd_cd']))
plate=[r for r in results if r['종이류']=='Y' and r['_dimstatus']['D10'] in ('FAIL','WARN')]
zero=[r for r in results if r['_flags']['calc']=='PRICED-0' or r['_flags']['set'].startswith('BLOCKED') or r['_dimstatus']['D5']=='FAIL' and r['_dimstatus']['D2'] in ('PASS','WARN')]

def wl(path,rows,cols,getter):
    with open(path,'w',newline='') as f:
        w=csv.writer(f); w.writerow(cols)
        for r in rows: w.writerow(getter(r))

wl(f"{OUT}/list-missing-components.csv",miss,
   ['prd_cd','상품명','상품군','prd_typ','등급','D1실제','다음한걸음'],
   lambda r:[r['prd_cd'],r['상품명'],r['상품군'],r['prd_typ'],r['등급'],
             next(d['실제'] for d in r['dims'] if d['code']=='D1'),r['다음한걸음']])
wl(f"{OUT}/list-mismapped.csv",mismap,
   ['prd_cd','상품명','상품군','분류','D11','D6','오염증거','근거'],
   lambda r:[r['prd_cd'],r['상품명'],r['상품군'],
             ('진짜 silent합산(돈크리티컬)' if r['_dimstatus']['D11']=='FAIL' else '자기부품/addon화 검토(FP가드)'),
             r['_dimstatus']['D11'],r['_dimstatus']['D6'],r['_flags']['R1'],r['근거']])
wl(f"{OUT}/list-platesize-reprocess.csv",plate,
   ['prd_cd','상품명','상품군','종이류','D10','calc','사유','다음한걸음'],
   lambda r:[r['prd_cd'],r['상품명'],r['상품군'],r['종이류'],r['_dimstatus']['D10'],
             r['_flags']['calc'] or r['_flags']['set'],
             next(d['실제'] for d in r['dims'] if d['code']=='D10'),r['다음한걸음']])
wl(f"{OUT}/list-priced-zero.csv",zero,
   ['prd_cd','상품명','상품군','종이류','calc/set','frm','D5','등급','다음한걸음'],
   lambda r:[r['prd_cd'],r['상품명'],r['상품군'],r['종이류'],
             r['_flags']['calc'] or r['_flags']['set'],r['_flags']['frm'],
             r['_dimstatus']['D5'],r['등급'],r['다음한걸음']])

# ---- summary stats ----
from collections import Counter
gc=Counter(r['등급'].split('(')[0] for r in results)
avg=round(sum(r['완성률'] for r in results)/len(results),1)
l3plus=[r for r in results if r['등급'][:2] in ('L3','L4')]
print("=== 평가 완료 ===")
print("총 평가 상품:",len(results))
print("등급 분포:",dict(sorted(gc.items())))
print("평균 완성률:",avg,"%")
print("L3+ (계산가능):",len(l3plus),f"({round(len(l3plus)/len(results)*100,1)}%)")
print("PRICED-0/BLOCKED(D5 FAIL with formula):",len(zero))
print("--- 4 리스트 ---")
print("구성요소 누락:",len(miss))
print("오매핑:",len(mismap))
print("판형 재처리:",len(plate))
print("가격계산0:",len(zero))
