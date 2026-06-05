#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""round-3 L2 정합 재검증 — C 파이프라인(S0~S7) 코드화. 9속성 전수 expected-vs-actual.
DB read-only(추출본만). expected는 B 규칙으로 산출. 산출: v2/expected/*.csv + classified.
회귀게이트: R-PROC-2 digital-print MISSING ≥ 6."""
import os, re, sys, json
from collections import defaultdict
import common as C

OUT = os.path.join(C.AUDIT, 'v2', 'expected')
os.makedirs(OUT, exist_ok=True)

PRD_MAP, PRD_INFO = C.load_prd_map()
INACTIVE = C.load_inactive_signals()

def resolve(prd_nm):
    """prd_nm → [prd_cd]. 미해소 시 빈 리스트."""
    return PRD_MAP.get(C.norm_prd(prd_nm), [])

# ════════════════════════════════════════════════════════════════════
# 배제 사전 (C §⑥)
# ════════════════════════════════════════════════════════════════════
SIZE_EXCLUDE = re.compile(r'(사용자입력|★|온스|oz|ml|팩|아이폰|갤럭시|버즈|에어팟|폰|\d+~\d+)')
PROC_NOISE = re.compile(r'^(\*|0\.0$|[\d/ .]+$)')

excluded_log = []  # (prd_nm, attr, raw_token, reason)

# ════════════════════════════════════════════════════════════════════
# S3 변환함수군
# ════════════════════════════════════════════════════════════════════

# ── 사이즈 (R-SIZE-1/3/6) — 치수쌍(cut) 기준 정합 (표기차 브리지) ──
# [정정 v2-FIX1] siz_cd 자연키 직접대조는 동일 cut치수 복수 siz_cd(30그룹)로 인해
# 대량 false MISSING/EXTRA 양산(1차 size GO=표기차 브리지 100%와 모순). 따라서 자연키를
# siz_cd가 아니라 cut치수쌍 'WxH'로 두고 대조한다. SIZE_CUT: siz_cd → 'WxH'.
SIZE_CUT = {}
for _r in C.read_csv(os.path.join(C.SCHEMA, 'ref-sizes.csv')):
    _cw = _r['cut_width'].split('.')[0]; _ch = _r['cut_height'].split('.')[0]
    if _cw and _ch:
        SIZE_CUT[_r['siz_cd']] = f'{_cw}x{_ch}'

def norm_size_token(tok):
    t = tok.lower().replace(' ', '').replace('mm', '').replace('×', 'x')
    m = re.search(r'(\d+x\d+)', t)  # A4(210x297), 잔여라벨 무시하고 치수쌍 추출
    if m: return m.group(1)
    return t

def transform_size(prd_nm, prd_cd, tokens):
    """expected key = cut치수쌍 'WxH'(표기차 브리지). actual도 SIZE_CUT로 환산해 대조."""
    exp = []
    for tok in tokens:
        if SIZE_EXCLUDE.search(tok):
            excluded_log.append((prd_nm, 'size', tok, 'R-SIZE-4/5 비치수옵션축'))
            continue
        for sub in re.split(r'\s*/\s*', tok):  # 복합분해 R-SIZE-6
            n = norm_size_token(sub)
            if not re.match(r'^\d+x\d+$', n):
                excluded_log.append((prd_nm, 'size', sub, '비치수정규형'))
                continue
            exp.append((prd_cd, n, tok, 'R-SIZE-1'))  # key=치수쌍
    return exp

# ── 공정 (R-PROC) — ANCHOR 기반 ──
PROC_BY_NAME, PROC_INFO = C.proc_master()
# block4 anchor 로드
ANCHOR = defaultdict(list)
for r in C.read_csv(os.path.join(C.AUDIT, 'block4-proc-anchor.csv')):
    ANCHOR[r['sheet_slug']].append(r)

SHEET_SLUG = {
    '디지털인쇄':'digital-print','스티커':'sticker','책자':'booklet','포토북':'photobook',
    '캘린더':'calendar','디자인캘린더':'design-calendar','실사':'silsa','아크릴':'acrylic',
    '문구':'stationery','굿즈파우치':'goods-pouch','부속상품':'product-accessory',
}
SPECIAL_COLOR = {'화이트':'PROC_000008','클리어':'PROC_000009','핑크':'PROC_000010',
                 '금색':'PROC_000011','은색':'PROC_000012'}

def slugify_sheet(sheet):
    return SHEET_SLUG.get(sheet.strip(), sheet.strip())

def has_count_signal(tokens, pattern):
    """N줄/N개 블록 신호: '없음' 외 실제 수치(1~N)가 있으면 True."""
    return any(re.match(pattern, t) for t in tokens)

def transform_proc(prd_nm, prd_cd, sheet, tokens):
    """R-PROC-2(줄수/개수 신호=digital-print 한정) + R-PROC-1/3/4/5/6 enum 매칭."""
    exp = []
    slug = slugify_sheet(sheet)
    line_sig = has_count_signal(tokens, r'^\d+줄$')   # 오시/미싱 후보
    cnt_sig  = has_count_signal(tokens, r'^\d+개$')   # 가변텍스트/이미지 후보
    # R-PROC-2: digital-print 시트 한정 (block4 ANCHOR 권위)
    if slug == 'digital-print':
        if line_sig:
            exp.append((prd_cd, 'PROC_000029', '|줄수블록', 'R-PROC-2'))
            exp.append((prd_cd, 'PROC_000030', '|줄수블록', 'R-PROC-2'))
        if cnt_sig:
            exp.append((prd_cd, 'PROC_000031', '|개수블록', 'R-PROC-2'))
            exp.append((prd_cd, 'PROC_000032', '|개수블록', 'R-PROC-2'))
    # enum 매칭
    for tok in tokens:
        if PROC_NOISE.match(tok):
            excluded_log.append((prd_nm, 'process', tok, 'R-PROC-7 노이즈'))
            continue
        # 줄수/개수 토큰 자체는 위에서 신호로 처리 → enum 매칭 제외
        if re.match(r'^(없음|\d+줄|\d+개)$', tok):
            continue
        # [v2-FIX2] 부모-신호 토큰 배제: '박(있음)/박(없음)/형압(없음)/형압(양각)...'은
        # 부모공정 신호. 부모(033 박/050 형압/013 코팅)는 미적재 규칙(자식 leaf만 적재).
        # → '박'/'형압' 단독 매칭(부모코드) 금지. 자식(금유광/양각/음각/유광/무광)만 별도 토큰으로 매칭.
        if re.match(r'^박\(', tok) or tok.startswith('박크기') or tok.startswith('크기'):
            continue  # 박 부모/파라미터 신호 — 자식은 별도 토큰
        # 형압(음각)/(양각) → 자식 PROC_000051/052
        m_emb = re.match(r'^형압\((양각|음각)\)$', tok)
        if m_emb:
            exp.append((prd_cd, 'PROC_000051' if m_emb.group(1)=='양각' else 'PROC_000052', tok, 'R-PROC-4emb'))
            continue
        if re.match(r'^형압\(없음\)$', tok):
            continue
        # [v2-FIX2] 코팅 표기 정규화: '무광코팅(단면)'→무광(015), '유광코팅(양면)'→유광(014)
        if '무광코팅' in tok:
            exp.append((prd_cd, 'PROC_000015', tok, 'R-PROC-5')); continue
        if '유광코팅' in tok:
            exp.append((prd_cd, 'PROC_000014', tok, 'R-PROC-5')); continue
        if tok == '코팅없음':
            continue
        base = re.sub(r'\(.*?\)', '', tok).strip()  # 괄호 파라미터 제거
        # 별색 5종 (R-PROC-3): '화이트인쇄','클리어' 등 토큰 내 색상 키워드
        matched_color = None
        for ck, cc in SPECIAL_COLOR.items():
            if ck in tok and ('별색' in tok or '인쇄' in tok or tok.startswith(ck)):
                matched_color = cc; break
        if matched_color and slug in ('digital-print', 'silsa'):
            exp.append((prd_cd, matched_color, tok, 'R-PROC-3'))
            continue
        # enum 직접 매칭 (자식 leaf 우선). 부모코드(upr 빈값이면서 자식보유)는 배제.
        cands = PROC_BY_NAME.get(base, [])
        for pc in cands:
            info = PROC_INFO.get(pc, {})
            # 부모공정(귀돌이026/별색007/박033/코팅013/제본017/접지056/포장075)은 미적재 — 자식만
            if pc in ('PROC_000026','PROC_000007','PROC_000033','PROC_000013',
                      'PROC_000017','PROC_000056','PROC_000075','PROC_000050','PROC_000001'):
                continue
            exp.append((prd_cd, pc, tok, 'R-PROC-1/4/5/6'))
    # dedup
    seen=set(); out=[]
    for e in exp:
        k=(e[0],e[1])
        if k in seen: continue
        seen.add(k); out.append(e)
    return out

# ── 자재 (R-MAT-1/2) — IMPORT 해소 + 표기차 정규화 ──
# [v2-FIX3] mat_nm 표기차(공백·말미 'g'·'지'/'g' 평량표기) 정규화 매칭.
# 엑셀 '스타드림(다이아)240' vs DB '스타드림(다이아) 240g' → 정규화 후 동일.
_MAT_MASTER_RAW = C.mat_master()
def _norm_mat(s):
    s = s.strip().replace(' ', '')
    s = re.sub(r'g$', '', s)          # 말미 g
    s = re.sub(r'(\d+)지$', r'\1', s) # '아트250지'→'아트250'
    return s
MAT_NORM = defaultdict(list)
for _nm, _cds in _MAT_MASTER_RAW.items():
    MAT_NORM[_norm_mat(_nm)].extend(_cds)
MAT_MASTER = _MAT_MASTER_RAW  # 호환
IMPORT_RES = C.read_csv(os.path.join(C.AUDIT, 'import-resolution-resolved.csv'))
# prd_cd → IMPORT 종이수(해소). 실제 종이명 리스트는 import-paper-extract에서.
IMPORT_PAPERS = defaultdict(list)
imp_extract_path = os.path.join(C.AUDIT, 'import-paper-extract.csv')
IMPORT_PRD_PAPERCOUNT = {}
for r in IMPORT_RES:
    for pc in r['prd_cd'].split('|'):
        try: IMPORT_PRD_PAPERCOUNT[pc] = int(r.get('종이수','0') or 0)
        except: IMPORT_PRD_PAPERCOUNT[pc] = 0

def transform_mat(prd_nm, prd_cd, tokens):
    exp = []
    for tok in tokens:
        if tok == '*별도설정':
            # R-MAT-2: IMPORT 실자재. 종이명 미상이면 카운트만(MISSING 후보).
            n = IMPORT_PRD_PAPERCOUNT.get(prd_cd, 0)
            if n > 0:
                exp.append((prd_cd, f'__IMPORT__{n}종', '*별도설정', 'R-MAT-2'))
            else:
                exp.append((prd_cd, '__IMPORT__0종(부재)', '*별도설정', 'R-MAT-2-gap'))
            continue
        # 복합분해 R-MAT-3: '아트250+무광코팅' → 자재축만
        for sub in re.split(r'\s*\+\s*', tok):
            sub = sub.strip()
            if '코팅' in sub or '라미' in sub:  # 공정축 → 자재 배제
                excluded_log.append((prd_nm, 'material', sub, 'R-MAT-3 공정축분해'))
                continue
            mc = MAT_MASTER.get(sub) or MAT_NORM.get(_norm_mat(sub))
            if mc:
                exp.append((prd_cd, mc[0], tok, 'R-MAT-1'))
            else:
                exp.append((prd_cd, f'__NOMAT__{sub}', tok, 'R-MAT-1-nomaster'))
    return exp

# ── 인쇄옵션 (R-CLR-1) ──
def transform_print_option(prd_nm, prd_cd, tokens):
    exp = []
    for tok in tokens:
        if tok == '단면':
            exp.append((prd_cd, '단면', tok, 'R-CLR-1'))
        elif tok == '양면':
            exp.append((prd_cd, '양면', tok, 'R-CLR-1'))
    return exp

# ════════════════════════════════════════════════════════════════════
# actual 로더 (자연키 추출)
# ════════════════════════════════════════════════════════════════════
def actual_size():
    """actual siz_cd를 cut치수쌍으로 환산(표기차 브리지). 환산불가 siz_cd는 원코드 유지."""
    a=defaultdict(set)
    for r in C.load_ref('product-sizes'):
        a[r['prd_cd']].add(SIZE_CUT.get(r['siz_cd'], r['siz_cd']))
    return a
def actual_proc():
    a=defaultdict(set)
    for r in C.load_ref('product-processes'): a[r['prd_cd']].add(r['proc_cd'])
    return a
def actual_mat():
    a=defaultdict(set)
    for r in C.load_ref('product-materials'): a[r['prd_cd']].add(r['mat_cd'])
    return a
def actual_print_option():
    a=defaultdict(set)
    for r in C.load_ref('product-print-options'): a[r['prd_cd']].add(r['print_side'])
    return a

# ════════════════════════════════════════════════════════════════════
# S5/S6 — diff + classify (속성별)
# ════════════════════════════════════════════════════════════════════
def run_attr(attr, excel_attr, transform_fn, actual_fn, key_is_real=True, sheet_aware=False):
    """expected 생성 → actual 대조 → 4분류. key_is_real=False면 __PLACEHOLDER__ 키(MISSING 카운트만)."""
    excel = C.load_excel(excel_attr)
    actual = actual_fn()
    expected = defaultdict(set)   # prd_cd → set(key)
    exp_rows = []
    unresolved = []
    inactive = []
    for r in excel:
        prd_nm = r['prd_nm']; sv = r['source_values']
        toks = C.split_tokens(sv)
        if not toks: continue
        cds = resolve(prd_nm)
        if not cds:
            unresolved.append((prd_nm, attr))
            continue
        for prd_cd in cds:
            if sheet_aware:
                rows = transform_fn(prd_nm, prd_cd, r['sheet'], toks)
            else:
                rows = transform_fn(prd_nm, prd_cd, toks)
            for (pc, key, src, rule) in rows:
                expected[pc].add(key)
                exp_rows.append({'prd_cd':pc,'prd_nm':prd_nm,'key':key,'src_token':src,'rule_id':rule})
    # classify
    classified = []
    cnt = {'MATCH':0,'MISSING':0,'EXTRA':0,'MISMATCH':0}
    prd_class = defaultdict(set)  # prd_cd -> set(분류)
    all_pcs = set(expected) | set(actual)
    for pc in all_pcs:
        e = expected.get(pc, set())
        a = actual.get(pc, set())
        # placeholder 키(__로 시작)는 real actual과 직접 비교 불가 → MISSING 카운트만(actual 0이면)
        real_e = {k for k in e if not k.startswith('__')}
        ph_e = {k for k in e if k.startswith('__')}
        prd_nm = PRD_INFO.get(pc,{}).get('prd_nm', pc)
        for k in real_e - a:
            classified.append({'prd_cd':pc,'prd_nm':prd_nm,'attr':attr,'분류':'MISSING','expected_key':k,'actual_key':'','note':''})
            cnt['MISSING']+=1; prd_class[pc].add('MISSING')
        for k in real_e & a:
            classified.append({'prd_cd':pc,'prd_nm':prd_nm,'attr':attr,'분류':'MATCH','expected_key':k,'actual_key':k,'note':''})
            cnt['MATCH']+=1; prd_class[pc].add('MATCH')
        for k in a - real_e:
            # placeholder expected가 있으면 EXTRA를 IMPORT후보로 안내(자재)
            note = 'placeholder expected 존재(직접대조불가)' if ph_e else ''
            classified.append({'prd_cd':pc,'prd_nm':prd_nm,'attr':attr,'분류':'EXTRA','expected_key':'','actual_key':k,'note':note})
            cnt['EXTRA']+=1; prd_class[pc].add('EXTRA')
        for k in ph_e:
            if not a:  # actual 전무 → placeholder 만큼 MISSING 신호
                classified.append({'prd_cd':pc,'prd_nm':prd_nm,'attr':attr,'분류':'MISSING','expected_key':k,'actual_key':'(actual 0행)','note':'placeholder-MISSING'})
                cnt['MISSING']+=1; prd_class[pc].add('MISSING')
            else:
                classified.append({'prd_cd':pc,'prd_nm':prd_nm,'attr':attr,'분류':'MATCH','expected_key':k,'actual_key':f'(actual {len(a)}행)','note':'placeholder-부분존재'})
                cnt['MATCH']+=1; prd_class[pc].add('MATCH')
    # 상품(prd_cd) 단위 카운트
    prd_cnt = {'MATCH_only':0,'has_MISSING':0,'has_EXTRA':0,'has_MISMATCH':0}
    for pc, cls in prd_class.items():
        if 'MISSING' in cls: prd_cnt['has_MISSING']+=1
        if 'EXTRA' in cls: prd_cnt['has_EXTRA']+=1
        if 'MISMATCH' in cls: prd_cnt['has_MISMATCH']+=1
        if cls=={'MATCH'}: prd_cnt['MATCH_only']+=1
    # write
    C.write_csv(os.path.join(OUT, f'{attr}-expected.csv'),
                ['prd_cd','prd_nm','key','src_token','rule_id'], exp_rows)
    C.write_csv(os.path.join(C.AUDIT,'v2',f'{attr}-mismatches-v2.csv'),
                ['prd_cd','prd_nm','attr','분류','expected_key','actual_key','note'],
                [c for c in classified if c['분류']!='MATCH'])
    return {'attr':attr,'row_cnt':cnt,'prd_cnt':prd_cnt,'unresolved':len(set(unresolved)),
            'classified':classified,'exp_rows':len(exp_rows)}

if __name__ == '__main__':
    results = {}
    results['size'] = run_attr('size','size',transform_size,actual_size)
    results['process'] = run_attr('process','process',transform_proc,actual_proc,sheet_aware=True)
    results['material'] = run_attr('material','material',transform_mat,actual_mat)
    results['print_option'] = run_attr('print_option','print-option',transform_print_option,actual_print_option)

    # 배제로그
    C.write_csv(os.path.join(OUT,'excluded-tokens.csv'),
                ['prd_nm','attr','raw_token','reason'],
                [{'prd_nm':a,'attr':b,'raw_token':c,'reason':d} for (a,b,c,d) in excluded_log])

    # 요약 출력
    print("=== 4분류 요약 (행 단위 / 상품 단위) ===")
    for k,v in results.items():
        rc=v['row_cnt']; pc=v['prd_cnt']
        print(f"[{v['attr']:14s}] expected행={v['exp_rows']:4d} | "
              f"MATCH={rc['MATCH']:4d} MISSING={rc['MISSING']:4d} EXTRA={rc['EXTRA']:4d} MISMATCH={rc['MISMATCH']:3d} "
              f"| 상품:MISSING보유={pc['has_MISSING']} EXTRA보유={pc['has_EXTRA']} | unresolved={v['unresolved']}")

    # 회귀게이트: R-PROC-2 digital-print MISSING
    proc_cls = results['process']['classified']
    rproc2_missing = [c for c in proc_cls if c['분류']=='MISSING' and c['expected_key'] in
                      ('PROC_000029','PROC_000030','PROC_000031','PROC_000032')]
    print(f"\n=== 회귀게이트 R-PROC-2 ===")
    print(f"줄수/개수 공정(29/30/31/32) MISSING 검출 = {len(rproc2_missing)}건 (게이트: ≥6)")
    by_prd=defaultdict(list)
    for c in rproc2_missing: by_prd[c['prd_nm']].append(c['expected_key'].replace('PROC_0000',''))
    for nm,ks in sorted(by_prd.items()):
        print(f"   {nm}: {sorted(ks)}")
    print(f"게이트: {'PASS' if len(rproc2_missing)>=6 else 'FAIL'}")

    # 별색 교차
    spc_proc = [c for c in proc_cls if c['분류']=='MISSING' and c['expected_key'] in
                ('PROC_000008','PROC_000009','PROC_000010','PROC_000011','PROC_000012')]
    print(f"\n별색공정(008~012) MISSING = {len(spc_proc)}건")
    # 저장
    with open(os.path.join(C.AUDIT,'v2','_results.json'),'w',encoding='utf-8') as f:
        json.dump({k:{'row_cnt':v['row_cnt'],'prd_cnt':v['prd_cnt'],'exp_rows':v['exp_rows'],'unresolved':v['unresolved']} for k,v in results.items()}
                  | {'rproc2_missing':len(rproc2_missing),'rproc2_by_prd':{k:sorted(v) for k,v in by_prd.items()},'spc_proc_missing':len(spc_proc)},
                  f, ensure_ascii=False, indent=2)
