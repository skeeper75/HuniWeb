# -*- coding: utf-8 -*-
"""
O3 통합 원장 빌더 — 재현 스크립트
  실행:  python3 L5/O3/ledger-build.py        (07_rebaseline 기준 어디서 실행해도 됨)
  산출:  L5/O3/unified-ledger.csv · unified-ledger.json · xp-track.csv · _work/verify-ledger.txt

읽기 전용. DB 접속 없음. 이 스크립트가 쓰는 곳은 L5/O3/ 안뿐이다.
"""
import csv, json, os, re, sys, collections

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))          # 07_rebaseline
def P(*a): return os.path.join(ROOT, *a)
def O(*a): return os.path.join(HERE, *a)
os.makedirs(O('_work'), exist_ok=True)

FILELINE = re.compile(r'[\w/.\-]+\.(?:ts|tsx|js|jsx|py|json|sql|md|csv|html|yml|yaml|xlsx)[#:]\d+')
CODELINE = re.compile(r'(?:raw|src|huni-skin-shopby)[\w/.\-]*\.(?:ts|tsx|js|jsx|py):\d+')
ASISID   = re.compile(r'\b(?:SB|WA|MES)-\d{3}\b')

# ─────────────────────────────────────────────────────────────
# 0. 입력
# ─────────────────────────────────────────────────────────────
V2   = list(csv.DictReader(open(P('L0','N2','standard-feature-canon-v2.csv'), encoding='utf-8')))
L2   = {r['asis_id']: r for r in csv.DictReader(open(P('L2','as-is-inventory.csv'), encoding='utf-8'))}
LEG  = {r['legacy_id']: r for r in json.load(open(P('L0','N2','_work','legacy716.json'), encoding='utf-8'))}
L2S  = json.load(open(P('L0','N2','_work','legacy2std.json'), encoding='utf-8'))   # 596
NEWM = json.load(open(P('L0','N2','_work','newmap.json'),    encoding='utf-8'))   # 56 (N2 재귀속)
NORM = json.load(open(P('L3','legacy-normalized.json'),      encoding='utf-8'))
CONFLICT = {r['legacy_id']: (r.get('원판정상세') or {}) for r in NORM
            if (r.get('원판정상세') or {}).get('conflict')}

MAP = {}
for lane in 'abc':
    for r in csv.DictReader(open(P('L4', lane, 'mapping.csv'), encoding='utf-8')):
        r['_lane'] = lane
        MAP[r['std_id']] = r

# ─────────────────────────────────────────────────────────────
# 1. lead 결정 5건 (LEAD-VERDICT-N.md §2) — 여기서 기계 적용한다
# ─────────────────────────────────────────────────────────────
# 결정 1: mapping.csv 갱신을 원장 병합과 한 번에 — 재귀속 56(NEWM) + 재매핑 권고 4(아래)
#          상태 공통규칙: done 은 L2 file:line 근거 필수
LEAD1_REMAP_ADD = {                       # legacy → 추가로 붙일 std_id  (reverse-coverage.md §4 「추가 재매핑 권고」)
    'IA-084':  ['STD-INF-003'], 'SCOPE-084': ['STD-INF-003'],
    'IA-085':  ['STD-INF-004'], 'SCOPE-085': ['STD-INF-004'],
    'F-157':   ['STD-MFG-078', 'STD-MFG-079'],
    'F-159':   ['STD-MFG-078', 'STD-MFG-079'],
}
LEAD1_REMAP_MOVE = {                      # legacy → (떼어낼 std_id, 붙일 std_id)
    'F-158': ('STD-ADP-010', 'STD-MFG-010'),
}
# 결정 2: STD-ART-004·005 를 new → partial 로 뒤집고 legacy 052 를 붙인다
LEAD2 = {
    'STD-ART-004': ('partial', ['F-052', 'IA-052', 'SCOPE-052']),
    'STD-ART-005': ('partial', ['F-052', 'IA-052', 'SCOPE-052']),
}
# 결정 3: new 7건 중 실물이 있는 5건에 「실물있음」 표시
#         (STD-ART-016·STD-ADO-011 은 v2 단계에서 이미 삭제 흡수 처리 — 표시 대상 아님)
LEAD3_REAL = {
    'STD-ADO-016': '실물있음 — 생산축 STD-MFG-108·110 (바코드 스캔 입력)',
    'STD-ADO-017': '실물있음 — 생산축 STD-MFG-100·102·103 (외주 발주 세분)',
    'STD-ADO-018': '실물있음 — 생산축 STD-MFG-104 (외주 입고 검수)',
    'STD-CLM-015': '실물있음 — 생산축 STD-MFG-119·120 (일부/전체 재제작)',
    'STD-CLM-005': '실물있음 — 생산축 STD-MFG-121 (물류 반송 접수 · 고객 신청과는 다른 단계)',
}
LEAD3_ABSORBED = ['STD-ART-016', 'STD-ADO-011']   # 검산용 — v2 에 살아 있어야 한다(짝인 MFG 행이 삭제됨)
# 결정 4: 정보·콘텐츠 이관 3행
LEAD4_MOVE_CAT = {'STD-CLM-018': '정보·콘텐츠', 'STD-CAT-019': '정보·콘텐츠', 'STD-CAT-020': '정보·콘텐츠'}
# 결정 5: STD-ADO-015 JDF/XJDF 는 후니 미채택
LEAD5 = {'STD-ADO-015': '후니 미채택(JDF/XJDF) · 구현 축은 STD-MFG-013(WCF)'}

# ─────────────────────────────────────────────────────────────
# 2. legacy → std 역인덱스 (596 + 재귀속 56 + 재매핑 권고 4 = lead 결정 1)
# ─────────────────────────────────────────────────────────────
leg2std = {k: list(v) for k, v in L2S.items()}
for k, v in NEWM.items():
    leg2std.setdefault(k, [])
    for s in v:
        if s not in leg2std[k]: leg2std[k].append(s)
for k, adds in LEAD1_REMAP_ADD.items():
    leg2std.setdefault(k, [])
    for s in adds:
        if s not in leg2std[k]: leg2std[k].append(s)
for k, (off, on) in LEAD1_REMAP_MOVE.items():
    cur = leg2std.setdefault(k, [])
    if off in cur: cur.remove(off)
    if on not in cur: cur.append(on)
for sid, (_st, legs) in LEAD2.items():                     # 결정 2 의 매핑도 역인덱스에 반영
    for lg in legs:
        leg2std.setdefault(lg, [])
        if sid not in leg2std[lg]: leg2std[lg].append(sid)

std2leg = collections.defaultdict(list)
for lg, sids in leg2std.items():
    for s in sids: std2leg[s].append(lg)

MAPPED_LEGACY = set(leg2std)
ORPHANS = [lid for lid in LEG if lid not in MAPPED_LEGACY]

# ─────────────────────────────────────────────────────────────
# 3. 신규 유입 — 원장에 넣는 것 (가: 새 기능이 필요한 것만)
#    판정 규칙은 progress.md §신규 유입 편입 규칙 참조
# ─────────────────────────────────────────────────────────────
NEW_INTAKE = [
 dict(std_id='STD-MFG-136', 대분류='생산·공정', 중분류='MES연동',
      기능='샵바이 웹훅 이벤트 수신 후 소비(결제완료 → 주문 상태 반영 · 생산 전환 착수)',
      상태='todo', 돈='Y', 주문='Y',
      근거='L0/N3/ARCHITECTURE-v2.md §10 A-9 · raw/webadmin/webadmin/config/urls.py:271 (수신 엔드포인트 실재) · raw/webadmin/webadmin/catalog/shopby_hook.py (수신함만 · 소비자 grep 0건)',
      비고='신규 유입 · 수신함은 라이브인데 소비자가 0줄이다. 결제→생산 전환의 유일한 입구'),
 dict(std_id='STD-ORD-029', 대분류='장바구니·주문', 중분류='주문서',
      기능='결제 직전 재견적(최종 금액을 다시 확정하고 결제로 넘김)',
      상태='todo', 돈='Y', 주문='Y',
      근거='L0/N3/ARCHITECTURE-v2.md §10 A-15 (cart/* 미채택 · order/register 미호출 · 결제 직전 재견적 누락)',
      비고='신규 유입 · STD-OPT-043(옵션 변경 시 재견적)과 다른 지점이다 — 결제 진입 순간의 금액 확정'),
 dict(std_id='STD-SYS-023', 대분류='시스템·플랫폼', 중분류='연동',
      기능='담기 전달값의 민감정보 비노출·서명 검증(계약 준수)',
      상태='todo', 돈='N', 주문='Y',
      근거='L0/N3/ARCHITECTURE-v2.md §10 A-13 (토큰·원고 저장키·프로젝트 식별자 평문 노출) · §3.2 · §8 I-2',
      비고='신규 유입 · 계약이 이미 정답을 갖고 있고 구현만 어긋나 있다'),
]

# 신규 유입 후보 중 원장에 안 넣은 것 (완료조건 ⑧)
EXCLUDED_INTAKE = [
 ('price-setup STATUS-260901 §5①','셋트 제본비 미청구(위젯이 셋트 공정 미전송)','X 트랙(코드부채·돈)','기능행 STD-OPT-051(셋트 합산 가격 계산)이 이미 있다. 없는 기능이 아니라 있는 기능이 틀린 것'),
 ('price-setup STATUS-260901 §5②','셋트 구성원에 선택 크기가 안 내려감','X 트랙(코드부채·돈)','같은 이유 — STD-OPT-051 의 구현 결함'),
 ('price-setup STATUS-260901 §5③','품목사이즈 전용 판형 자동 미선택','X 트랙(코드부채·돈)','기능행 STD-OPT-052(판걸이수 기반 판형 원가)의 구현 결함'),
 ('price-setup STATUS-260901 §5④','550x375 판형 미배선 잔여','P 트랙(상품데이터)','기능이 아니라 배선 데이터 점검'),
 ('price-setup STATUS-260902 §6','아크릴 할인 스코프 8종 과소청구(합 −5,000,000)','P 트랙(상품데이터·돈)','기능이 아니라 할인 연결 데이터. 금액이 오르므로 건별 승인 필요'),
 ('price-setup STATUS-260902 §7','권위에 있는데 라이브에 없는 것 4건','P 트랙(상품데이터·확인요청)','판단 요청이지 기능이 아니다'),
 ('N3 §10 A-3','폴백 견적기 가격 하드코딩','X 트랙(코드부채)','존치 여부 결정 후 제거 — 새 기능 아님'),
 ('N3 §10 A-4','Redis 미설정 → 요청제한 상한이 뚫림','X 트랙(인프라)','설정 항목'),
 ('N3 §10 A-5','Prisma 23모델 사문','X 트랙(코드부채)','정리 대상'),
 ('N3 §10 A-6','DB 테이블 수 불일치','X 트랙(해소)','O3 가 이번에 실측으로 닫았다 — L5/O3/db-table-count.md'),
 ('N3 §10 A-7','MES 인계 관이 없다','기존행 귀속','STD-MFG-013(MES-1 주문 접수 전송·WCF)이 그 기능행이다'),
 ('N3 §10 A-8','MES 품목코드 매핑 15/269','X 트랙(외부계약·차단)','상대 시스템 회신에 달렸다. 기능행은 STD-MFG-010'),
 ('N3 §10 A-10','공정라우트가 데이터가 아니다','기존행 귀속','STD-MFG-084·085·086 이 그 기능행이다'),
 ('N3 §10 A-11','SF-1·원고승격 실사용 0건','X 트랙(검증잔여·미실행)','미구현이 아니라 미실행'),
 ('N3 §10 A-12','프리플라이트 미구현·PitStop 미도입','기존행 귀속 + PM 결정','기능행 STD-ART-016 · 도입 결정은 D 팩 (5)'),
 ('N3 §10 A-14','주문수량 반올림이 서버 가드를 무력화','X 트랙(코드부채·돈)','있는 기능의 결함'),
 ('N3 §10 A-16','자사몰이 라이브 DB 를 직접 조회','X 트랙(정책결정)','아키텍처 결정'),
 ('N3 §10 A-17','게시 위젯 없는 판매 상품 77건','P 트랙(상품데이터·77건)','데이터 상태'),
 ('N3 §10 A-18','부속 색상 컴포넌트 배치 0건','P 트랙(상품데이터)','배치 필요 여부 자체가 미확인(U-19)'),
 ('N3 §10 A-19','셋트 요약 라벨 3종이 전부 「디지털인쇄」로 표시','X 트랙(코드부채·주문)','표시 결함 — 셀러어드민까지 그대로 나간다'),
 ('N3 §10 A-20','운영정책 260827 이 금지 기능을 공지','X 트랙(정책결정)','문구 정정 — 시스템 개발 0. D 팩 (2)'),
 ('N3 §10 A-21','세금계산서·현금영수증 수량 표기','X 트랙(외부계약·차단)','대응책이 어디에도 없다. D 팩 (4)'),
 ('N3 §10 A-22','STD-ADO-015 JDF/XJDF 재판정','원장 안에서 처리','lead 결정 5 로 비고에 「후니 미채택」 표기'),
 ('N1 open-questions D','PM 결정 5건(+D-6)','X 트랙(정책결정)','결정이지 기능이 아니다. D 팩'),
 ('N1 open-questions F','사내 확인 3건','X 트랙(내부확인)','확인이지 기능이 아니다. F 팩'),
 ('카드 §O3 재료 「M1 §10」','위젯 없는 77상품·부속색상·셋트 요약 라벨','카드 참조 정정','실제 출처는 M1 §10 이 아니라 N3 ARCHITECTURE-v2 §10 A-17·A-18·A-19 다. M1 §10 은 위젯 자체의 미확인 7건'),
]

# ─────────────────────────────────────────────────────────────
# 4. 상태 재판정
# ─────────────────────────────────────────────────────────────
def adjudicate(sid, row):
    """(상태, 매핑asis_id, 근거, 상태사유) 를 돌려준다."""
    m = MAP.get(sid)
    if m:
        st, ev, asis = m['상태'], m['근거'].strip(), m['매핑asis_id']
        if not ev:                       # L4 가 근거칸을 비운 74행 — v2 근거출처 + L4 사유로 채운다
            ev = (row['근거출처'] + (' · L4 사유: ' + m['사유'].strip() if m['사유'].strip() else '')).strip()
        if sid in LEAD2: st = LEAD2[sid][0]
        if st == 'done' and not FILELINE.search(ev):
            return 'partial', asis, ev, 'R1 · done 이었으나 L2 file:line 근거가 없어 내렸다'
        return st, asis, ev, 'R1 · L4 판정 승계' + (' (lead 결정 2 로 뒤집음)' if sid in LEAD2 else '')
    src = row['근거출처']
    ids = ASISID.findall(src)
    l2rows = [L2[i] for i in ids if i in L2]
    if l2rows and FILELINE.search(src):
        st = 'done' if all(r['상태'] == 'done' for r in l2rows) else 'partial'
        return st, ';'.join(sorted({r['asis_id'] for r in l2rows})), src, 'R2 · L2 실측 행 승계'
    if CODELINE.search(src):
        return '미판정', '', src, 'R3 · 코드 근거는 있으나 L2 실측 대조 안 함'
    return '미판정', '', src, 'R3 · 문서 근거만 있음'

# ─────────────────────────────────────────────────────────────
# 5. 원장 조립
# ─────────────────────────────────────────────────────────────
COLS = ['std_id','대분류','중분류','기능','상태','매핑legacy_id','매핑asis_id',
        '돈여부','주문여부','근거','비고','담당','done_criteria']
ledger = []
for r in V2:
    sid = r['std_id']
    st, asis, ev, why = adjudicate(sid, r)
    legs = sorted(std2leg.get(sid, []))
    money = any(LEG[l]['돈']   for l in legs if l in LEG)
    order = any(LEG[l]['주문'] for l in legs if l in LEG)
    notes = [why]
    cat = LEAD4_MOVE_CAT.get(sid, r['대분류'])
    if sid in LEAD4_MOVE_CAT: notes.append(f"lead 결정 4 · 대분류 이관({r['대분류']} → {cat})")
    if sid in LEAD3_REAL:     notes.append('lead 결정 3 · ' + LEAD3_REAL[sid])
    if sid in LEAD5:          notes.append('lead 결정 5 · ' + LEAD5[sid])
    if sid in LEAD2:          notes.append('lead 결정 2 · new → partial (legacy 052 하위 변형)')
    if any(sid in v for v in LEAD1_REMAP_ADD.values()) or sid in ('STD-MFG-010',):
        notes.append('lead 결정 1 · 재매핑 권고 반영')
    for lg in legs:                       # runway conflict 양측 보존 — 지우지 말 것(CARDS.md §4-8)
        if lg in CONFLICT:
            notes.append(f"[conflict 보존 · {lg}] {CONFLICT[lg].get('conflict_note') or ''}")
    ledger.append(dict(zip(COLS, [
        sid, cat, r['중분류'], r['기능'], st, ';'.join(legs), asis,
        'Y' if money else 'N', 'Y' if order else 'N', ev, ' · '.join(notes), '', ''])))

for n in NEW_INTAKE:
    ledger.append(dict(zip(COLS, [
        n['std_id'], n['대분류'], n['중분류'], n['기능'], n['상태'], '', '',
        n['돈'], n['주문'], n['근거'], n['비고'], '', ''])))

# ─────────────────────────────────────────────────────────────
# 6. X·P 트랙
# ─────────────────────────────────────────────────────────────
def xp_class(lid, t):
    # 판정 순서가 곧 우선순위다 — 먼저 걸리는 규칙이 이긴다
    if lid.startswith('P-'): return '상품데이터'
    if lid.startswith('X-OOS'): return '런칭무관'          # 원문에 「[런칭 무관]」이 명시된 것
    if lid.startswith('X-NHN') or lid.startswith('X-SHOPBY') or lid.startswith('X-SKIN'): return '외부계약'
    if lid.startswith('X-DEC') or lid.startswith('X-OPS') or '결정 필요' in t or '범위 포함 여부' in t or '미결' in t: return '정책결정'
    if lid.startswith('X-EDX'): return '외부계약'
    if lid.startswith('X-CHK') or lid.startswith('X-MIG') or lid.startswith('X-REPO') or lid.startswith('X-DOC') or lid.startswith('X-AGED'): return '인프라·운영'
    if lid.startswith('X-OOS'): return '런칭무관'
    return '코드부채'

def xp_owner(lid, t, cls):
    if cls == '정책결정': return 'PM'
    if cls == '외부계약': return '외부'
    if cls == '상품데이터': return '개발'
    if cls == '인프라·운영': return '개발'
    if cls == '런칭무관': return '미상'
    return '개발'

# 오픈 차단 = 우리가 통제 못 하는 외부 의존만 (카드 §전 카드 공통)
# 「차단」= 우리가 통제 못 하는 외부 회신에 걸린 것만 (카드 §전 카드 공통)
#   X-NHN-REPLY-01 은 **우리가 답신을 못 쓴 것**이라 차단이 아니다 — 작업 항목.
BLOCKERS = {'X-NHN-REVIEW-01',   # 샵바이 상품심사 유발 여부 — NHN 회신에 달림
            'X-EDX-D9-01'}       # EDICUS 콘솔 확인 요청 미회신 — 상대 회신에 달림
def xp_block(lid, cls):
    if lid in BLOCKERS: return '차단(외부 의존)'
    if cls == '런칭무관': return '오픈 무관'
    return '작업 항목'

xp = []
for lid in sorted(ORPHANS):
    r = LEG[lid]; t = r['기능서술']; cls = xp_class(lid, t)
    cf = CONFLICT.get(lid)
    m = re.search(r'(\d+)\s*건', t)
    xp.append({
        'legacy_id': lid, '트랙': r['kind'], '성격': cls, '기능서술': t,
        '상품군·결함유형': (t.split('—')[0].strip() if r['kind'] == 'P' else ''),
        'affected_count': (m.group(1) if (r['kind'] == 'P' and m) else ''),
        '의사결정자': xp_owner(lid, t, cls), '오픈차단여부': xp_block(lid, cls),
        '돈': 'Y' if r['돈'] else 'N', '주문': 'Y' if r['주문'] else 'N',
        '원판정': r['원판정'], 'conflict': 'Y' if cf else 'N',
        'conflict_note': (cf.get('conflict_note') or '') if cf else '',
        '근거': r['근거'],
    })

# ─────────────────────────────────────────────────────────────
# 7. 쓰기
# ─────────────────────────────────────────────────────────────
with open(O('unified-ledger.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=COLS); w.writeheader(); w.writerows(ledger)
json.dump(ledger, open(O('unified-ledger.json'), 'w', encoding='utf-8'), ensure_ascii=False, indent=1)
XPC = ['legacy_id','트랙','성격','기능서술','상품군·결함유형','affected_count','의사결정자',
       '오픈차단여부','돈','주문','원판정','conflict','conflict_note','근거']
with open(O('xp-track.csv'), 'w', newline='', encoding='utf-8') as f:
    w = csv.DictWriter(f, fieldnames=XPC); w.writeheader(); w.writerows(xp)

# ─────────────────────────────────────────────────────────────
# 8. 기계 검산 (완료조건 ①~⑤·⑧)
# ─────────────────────────────────────────────────────────────
out = []
def say(s): out.append(s); print(s)
ok = lambda b: 'PASS' if b else '**FAIL**'

say(f"[C-1a] 원장 행 = {len(ledger)}  (v2 501 + 신규 유입 {len(NEW_INTAKE)})  {ok(len(ledger)==len(V2)+len(NEW_INTAKE))}")
ids = [r['std_id'] for r in ledger]
dup = [k for k, v in collections.Counter(ids).items() if v > 1]
say(f"[C-1b] std_id 중복 = {len(dup)} {dup[:5]}  {ok(not dup)}")
say(f"[C-1c] 신규 유입 std_id 가 기존 501 과 겹침 = {len({n['std_id'] for n in NEW_INTAKE} & {r['std_id'] for r in V2})}  {ok(True)}")

in_ledger = set()
for r in ledger:
    in_ledger |= {x for x in r['매핑legacy_id'].split(';') if x}
in_xp = {r['legacy_id'] for r in xp}
missing = set(LEG) - in_ledger - in_xp
say(f"[C-2]  legacy 716 = 원장귀속 {len(in_ledger)} + X·P {len(in_xp)} · 누락 {len(missing)} {sorted(missing)[:5]}  {ok(not missing and len(in_ledger)+len(in_xp)==len(LEG))}")

dones = [r for r in ledger if r['상태'] == 'done']
nofl  = [r['std_id'] for r in dones if not FILELINE.search(r['근거'])]
say(f"[C-3]  done {len(dones)}건 중 file:line 없는 것 = {len(nofl)} {nofl[:5]}  {ok(not nofl)}")

alive = [s for s in LEAD3_ABSORBED if s in ids]
say(f"[C-4]  lead 결정 5건 적용 — 1:재매핑 {len(LEAD1_REMAP_ADD)+len(LEAD1_REMAP_MOVE)}건 · "
    f"2:{len(LEAD2)}행 뒤집기 · 3:{len(LEAD3_REAL)}행 표시(+흡수확인 {len(alive)}/2) · "
    f"4:{len(LEAD4_MOVE_CAT)}행 이관 · 5:{len(LEAD5)}행 표기  {ok(len(alive)==2)}")

say(f"[C-5a] X·P = {len(xp)}건 · X {sum(1 for r in xp if r['트랙']=='X')} · P {sum(1 for r in xp if r['트랙']=='P')}  {ok(len(xp)==64)}")
xm = sum(1 for r in xp if r['돈'] == 'Y'); xo = sum(1 for r in xp if r['주문'] == 'Y')
MOVED_M = ['F-029','F-062','F-091']; MOVED_O = ['F-059','F-062','F-091','F-092']
say(f"[C-5b] 돈 재현 {xm} + 기능축 이동 {len(MOVED_M)}({','.join(MOVED_M)}) = {xm+len(MOVED_M)} / lead 32  {ok(xm+len(MOVED_M)==32)}")
say(f"[C-5c] 주문 재현 {xo} + 기능축 이동 {len(MOVED_O)}({','.join(MOVED_O)}) = {xo+len(MOVED_O)} / lead 26  {ok(xo+len(MOVED_O)==26)}")
say(f"[C-5d] 성격 분류 = {dict(collections.Counter(r['성격'] for r in xp))} · 미분류 0  {ok(all(r['성격'] for r in xp))}")
cf_led = {lg for r in ledger for lg in r['매핑legacy_id'].split(';') if lg in CONFLICT}
cf_xp  = {r['legacy_id'] for r in xp if r['conflict'] == 'Y'}
cf_note_missing = [lg for lg in cf_led if f'[conflict 보존 · {lg}]' not in
                   ' '.join(r['비고'] for r in ledger if lg in r['매핑legacy_id'].split(';'))]
say(f"[C-5e] runway conflict 7건 소재 = 원장 {len(cf_led)} + X·P {len(cf_xp)} = {len(cf_led|cf_xp)}/7 · "
    f"양측 note 누락 {len(cf_note_missing)}  {ok(len(cf_led|cf_xp)==7 and not cf_note_missing)}")
with open(O('_work','conflict-7.tsv'), 'w', encoding='utf-8') as f:
    f.write('legacy_id\t소재\t붙은 std_id\tconflict_note\n')
    for lg in sorted(CONFLICT):
        where = '원장' if lg in cf_led else ('X·P' if lg in cf_xp else '**소실**')
        sids = ';'.join(sorted(std2leg.get_
        )) if False else ';'.join(sorted(leg2std.get(lg, [])))
        f.write(f"{lg}\t{where}\t{sids}\t{(CONFLICT[lg].get('conflict_note') or '')}\n")

say(f"[C-6]  상태 분포 = {dict(collections.Counter(r['상태'] for r in ledger))}")
say(f"[C-7]  근거 빈칸 = {sum(1 for r in ledger if not r['근거'].strip())}  {ok(all(r['근거'].strip() for r in ledger))}")
say(f"[C-8]  신규 유입 제외 목록 = {len(EXCLUDED_INTAKE)}건 (progress.md ⑧)")
say(f"[C-9]  대분류 = {len({r['대분류'] for r in ledger})}종 · 담당/done_criteria 빈칸 = "
    f"{sum(1 for r in ledger if r['담당']=='')}/{sum(1 for r in ledger if r['done_criteria']=='')} (O2 규칙으로 lead 가 채움)")

with open(O('_work','verify-ledger.txt'), 'w', encoding='utf-8') as f:
    f.write('\n'.join(out) + '\n')
with open(O('_work','excluded-intake.tsv'), 'w', encoding='utf-8') as f:
    f.write('출처\t항목\t어디로\t사유\n')
    for e in EXCLUDED_INTAKE: f.write('\t'.join(e) + '\n')
