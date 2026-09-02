#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""O2 의존 그래프 빌더 — 엣지 전건에 출처를 붙인다. 읽기전용."""
import json, csv, collections, os, datetime

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
def P(*p): return os.path.join(ROOT, *p)

legacy = json.load(open(P('L3','legacy-normalized.json')))
svc    = json.load(open(P('L2','service-dependency.json')))

nodes = {}   # id -> dict
edges = []   # dict(src,dst,kind,source)

def node(nid, **kw):
    if nid not in nodes:
        nodes[nid] = {'id': nid, 'label': kw.get('label', nid), 'kind': kw.get('kind','unknown'),
                      'grade': kw.get('grade','작업 항목'), 'source': kw.get('source',''),
                      'money': kw.get('money', False), 'order': kw.get('order', False)}
    else:
        for k,v in kw.items():
            if k in ('label','kind','grade','source') and v and not nodes[nid].get(k):
                nodes[nid][k]=v
    return nodes[nid]

def edge(src, dst, kind, source):
    """src 가 dst 를 막는다(= dst 는 src 뒤에 온다)."""
    edges.append({'src': src, 'dst': dst, 'kind': kind, 'source': source})

# ── 1. legacy 716 → 노드 ────────────────────────────────────────────
by_id = {}
for r in legacy:
    lid = r['legacy_id']
    by_id[lid] = r
    kind = 'legacy'
    if lid.startswith('X-'): kind = 'x-track'
    elif lid.startswith('P-'): kind = 'p-track'
    node(lid, label=r['기능서술'][:90], kind=kind,
         source=(r.get('근거') or [''])[0],
         money=bool(r.get('돈여부')), order=bool(r.get('주문여부')))

# ── 2. blocked_by 엣지 ─────────────────────────────────────────────
for r in legacy:
    dep = r.get('의존') or {}
    src_ev = (r.get('근거') or [''])[0]
    for b in dep.get('blocked_by') or []:
        if b not in nodes:
            node(b, label=(by_id.get(b,{}).get('기능서술','(원장 밖 참조)'))[:90],
                 kind='x-track' if b.startswith('X-') else ('p-track' if b.startswith('P-') else 'legacy'),
                 source='blocked_by 참조로만 등장')
        edge(b, r['legacy_id'], 'blocked_by',
             f"L3/legacy-normalized.json 의 {r['legacy_id']}.의존.blocked_by · 원근거 {src_ev}")

# ── 3. 외부 계약 의존 노드 + 엣지 ────────────────────────────────────
# 원문 external_dep 문자열 → 외부 계약 주체로 정규화
EXT_MAP = [
    ('이니시스', 'EXT-PG'), ('Shopby', 'EXT-SHOPBY-PLATFORM'), ('NHN', 'EXT-NHN'),
    ('MES', 'EXT-MES'), ('Edicus', 'EXT-EDICUS'), ('Pie Canvas', 'EXT-PIECANVAS'),
    ('파트너사(스킨)', 'EXT-PIECANVAS'),
    ('구DB', 'EXT-OLDDB'), ('SMS/알림톡', 'EXT-ALIMTALK'), ('알림톡', 'EXT-ALIMTALK'),
    ('본인인증', 'EXT-IDENTITY'), ('팝빌/국세청', 'EXT-TAXBILL'),
    ('네이버', 'EXT-NAVERPAY'), ('AWS', 'EXT-AWS'), ('레드프린팅', 'EXT-REDPRINTING'),
    ('RedPrinting', 'EXT-REDPRINTING'), ('업체(맥세이프)', 'EXT-VENDOR-MAGSAFE'),
    ('공급자 레지스트리', 'EXT-SUPPLIER-REG'),
]
EXT_LABEL = {
    'EXT-PG': '이니시스 PG (결제 원천사 심사)', 'EXT-NHN': 'NHN커머스 회신 대기 (웹훅·정산·심사 정책)',
    'EXT-SHOPBY-PLATFORM': '샵바이 플랫폼 표준 기능 상시 의존 (차단 아님)',
    'EXT-MES': 'MES 벤더/인쇄팀 (스펙·품목코드)', 'EXT-EDICUS': 'Edicus 온라인 편집기 계약',
    'EXT-PIECANVAS': '파트너사 Pie Canvas (페이지빌더·스킨)', 'EXT-OLDDB': '구 DB 보유측 (회원·머니 원천)',
    'EXT-ALIMTALK': '알림톡/SMS 사업자 계약', 'EXT-IDENTITY': '본인인증 사업자 계약',
    'EXT-TAXBILL': '팝빌/국세청 증빙 발행', 'EXT-NAVERPAY': '네이버페이 원천사',
    'EXT-AWS': 'AWS (S3·인프라)', 'EXT-REDPRINTING': 'RedPrinting 라이브(역공학 참조원)',
    'EXT-VENDOR-MAGSAFE': '맥세이프 부자재 업체', 'EXT-SUPPLIER-REG': '공급자 레지스트리(별도 도메인)',
}
# 내부 주체(개발팀·실무진·사장님 등)는 외부 계약이 아니라 「내부 배정」으로 분리
INTERNAL_TOKENS = ['개발팀','개발자','실무진','사장님','인쇄팀','담당자','Claude Code','codex','발표 도메인','별도사업','신규 BFF']

ext_hits = collections.Counter(); internal_hits = collections.Counter()
for r in legacy:
    dep = r.get('의존') or {}
    src_ev = (r.get('근거') or [''])[0]
    for e in dep.get('external_dep') or []:
        mapped = None
        for tok, nid in EXT_MAP:
            if tok in e: mapped = nid; break
        if mapped is None:
            if any(t in e for t in INTERNAL_TOKENS):
                internal_hits[e] += 1
                continue
            mapped = 'EXT-UNCLASSIFIED'
            EXT_LABEL.setdefault('EXT-UNCLASSIFIED','분류 미상 외부 의존')
        node(mapped, label=EXT_LABEL[mapped], kind='external',
             grade=('작업 항목' if mapped=='EXT-SHOPBY-PLATFORM' else '차단'))
        ext_hits[mapped] += 1
        edge(mapped, r['legacy_id'], 'external_dep',
             f"L3/legacy-normalized.json 의 {r['legacy_id']}.의존.external_dep=\"{e}\" · 원근거 {src_ev}")

# ── 4. precondition 텍스트 → 규칙 매칭 ──────────────────────────────
PRE_RULES = [
    ('PG', 'EXT-PG'), ('결제대행', 'EXT-PG'), ('이니시스', 'EXT-PG'),
    ('알림톡', 'EXT-ALIMTALK'), ('SMS', 'EXT-ALIMTALK'), ('문자 서비스', 'EXT-ALIMTALK'),
    ('휴대폰 인증', 'EXT-IDENTITY'),
    ('에디터 도입', 'DEC-EDITOR'), ('편집기 도입', 'DEC-EDITOR'),
    ('수작 브랜드', 'DEC-SUJAK'),
    ('배송비', 'DEC-SHIPFEE'), ('도서산간', 'DEC-SHIPFEE'),
    ('증빙', 'DEC-PROOF'), ('현금영수증', 'DEC-PROOF'),
    ('본인확인', 'DEC-IDVERIFY'),
]
DEC_LABEL = {
    'DEC-EDITOR':'PM 결정 — 온라인 에디터 도입 여부', 'DEC-SUJAK':'PM 결정 — 수작 브랜드 존치 여부',
    'DEC-SHIPFEE':'PM 결정 — 배송비·도서산간 정책', 'DEC-PROOF':'PM 결정 — 증빙(세금계산서·현금영수증) 정책',
    'DEC-IDVERIFY':'PM 결정 — 본인확인 방법',
}
unparsed = []
for r in legacy:
    dep = r.get('의존') or {}
    pre = (dep.get('precondition') or '').strip()
    if not pre: continue
    src_ev = (r.get('근거') or [''])[0]
    hit = None
    for tok, nid in PRE_RULES:
        if tok in pre: hit = nid; break
    if hit is None:
        unparsed.append((r['legacy_id'], pre, src_ev)); continue
    if hit.startswith('DEC-'):
        node(hit, label=DEC_LABEL[hit], kind='decision', grade='작업 항목')
    edge(hit, r['legacy_id'], 'precondition',
         f"L3/legacy-normalized.json 의 {r['legacy_id']}.의존.precondition=\"{pre}\" · 원근거 {src_ev}")

# ── 5. L2 연계 서비스 18종 ─────────────────────────────────────────
for s in svc['services']:
    node(s['id'], label=s['name'], kind='service',
         grade=('차단' if s['risk']=='critical' and s.get('contract_required') else '작업 항목'),
         source='L2/service-dependency.json · call_sites=' + ';'.join(s.get('call_sites',[])[:2]))

SVC_EXT = {'D-01':'EXT-SHOPBY-PLATFORM','D-02':'EXT-SHOPBY-PLATFORM','D-03':'EXT-PG','D-06':'EXT-EDICUS',
           'D-07':'EXT-AWS','D-08':'EXT-NHN','D-09':'EXT-PIECANVAS','D-17':'EXT-IDENTITY',
           'D-18':'EXT-TAXBILL'}
for sid, ext in SVC_EXT.items():
    node(ext, label=EXT_LABEL.get(ext,ext), kind='external',
         grade=('작업 항목' if ext=='EXT-SHOPBY-PLATFORM' else '차단'))
    edge(ext, sid, 'service_contract', f"L2/service-dependency.json 의 {sid} contract_required/endpoint 필드")

# ── 6. N3 결함 A-3~A-22 (수기 전사 · 출처 = ARCHITECTURE-v2.md §10.2) ─
A = [
 ('A-3','폴백 견적기 가격 하드코딩(a4=75000)','작업 항목',[],'configurator.tsx:45-52'),
 ('A-4','Redis 미설정 → LocMem 폴백','작업 항목',[],'settings.py:339-368'),
 ('A-5','Prisma 23모델 사문','작업 항목',[],'import 0건'),
 ('A-6','DB 테이블 수 불일치(44 vs 60/120)','작업 항목',[],'ARCHITECTURE-v2.md §6'),
 ('A-7','MES 인계 관이 없다 — 결제 주문이 생산에 도달 못함','작업 항목',['A-8'],'grep wcf|soap|zeep 0건'),
 ('A-8','MES 품목코드 매핑 15/269 (5.6%) · 08-18 이후 진전 0','차단',['EXT-MES'],'라이브 실측 2026-09-02'),
 ('A-9','웹훅 수신함에 소비자가 없다','작업 항목',['EXT-NHN'],'shopby_hook.py 소비자 grep 0건'),
 ('A-10','공정라우트가 데이터가 아니다 (라우트 테이블 0)','작업 항목',[],'t_proc_processes 143 · 라우트 0'),
 ('A-11','SF-1·승격 실사용 0건 (미실행)','작업 항목',['EXT-PG'],'t_ord_orders·t_ord_artworks 0행'),
 ('A-12','프리플라이트 미구현 · PitStop 미도입','작업 항목',['DEC-PITSTOP'],'grep 0건'),
 ('A-13','optionInputs 계약 드리프트 (토큰·S3키·prjid 평문)','작업 항목',[],'ARCHITECTURE-v2.md §3.2·§8 I-2'),
 ('A-14','orderCnt 반올림이 서버 가드를 무력화','작업 항목',[],'widget-order.ts:34 ↔ widget_api.py:3229'),
 ('A-15','cart/* 미채택 · order/register 미호출 · 결제 직전 재견적 누락','작업 항목',[],'ARCHITECTURE-v2.md §8 I-3·I-4·I-6'),
 ('A-16','자사몰이 라이브 DB 를 직접 SELECT','작업 항목',['DEC-DBCONTRACT'],'widget.ts:65-99'),
 ('A-17','게시 위젯 없는 판매 상품 77건','작업 항목',[],'라이브 SELECT 2026-09-02'),
 ('A-18','부속 색상 컴포넌트 라이브 배치 0건','작업 항목',[],'t_wgt_widget_items 실측'),
 ('A-19','셋트 위젯 summary 3라벨 붕괴','작업 항목',[],'재현됨'),
 ('A-20','운영정책 260827 이 금지 기능을 공지','작업 항목',['DEC-SHIPFEE'],'운영정책_260827.xlsx'),
 ('A-21','세금계산서·현금영수증 수량 표기','차단',['EXT-NHN'],'ARCHITECTURE-v2.md §3.4'),
 ('A-22','STD-ADO-015 JDF/XJDF 재판정','작업 항목',[],'MES 연계는 WCF(SOAP) 확정'),
]
node('DEC-PITSTOP', label='PM 결정 — PitStop Server 도입 여부', kind='decision')
node('DEC-DBCONTRACT', label='PM/아키텍처 결정 — 라이브 DB 직접 SELECT 를 API 계약으로 되돌릴지', kind='decision')
for aid, lbl, grade, blockers, ev in A:
    node(aid, label=lbl, kind='defect', grade=grade,
         source='L0/N3/ARCHITECTURE-v2.md §10.2 · ' + ev)
    for b in blockers:
        node(b, label=EXT_LABEL.get(b, DEC_LABEL.get(b, b)), kind=('external' if b.startswith('EXT-') else ('decision' if b.startswith('DEC-') else 'defect')))
        edge(b, aid, 'defect_blocked_by', f'L0/N3/ARCHITECTURE-v2.md §10.2 {aid} 행 · {ev}')

# ── 7. 가격 결함 (price-setup) ─────────────────────────────────────
PR = [
 ('PRICE-1','셋트 제본비 미청구 — 무선책자 A5 5,964원 vs 권위 13,160원','_workspace/price-setup/STATUS-260901.md §5①'),
 ('PRICE-2','고객이 고른 크기가 셋트 구성품까지 안 내려감(069·070·072·077) — 094 엽서북은 260902 §3 에서 철회','_workspace/price-setup/STATUS-260901.md §5② + STATUS-260902.md §3'),
 ('PRICE-3','품목사이즈 전용 판형 자동 미선택 — 524행이 자동 경로에서 미사용','_workspace/price-setup/STATUS-260901.md §5③'),
 ('PRICE-4','550x375 판형 미배선 잔여 (동일 표지사이즈 타 상품 미확인)','_workspace/price-setup/STATUS-260901.md §5④'),
 ('PRICE-5','아크릴 할인 스코프 — 8종 과소청구 합 −5,000,000/1,000개','_workspace/price-setup/STATUS-260902.md §6'),
]
for pid, lbl, ev in PR:
    node(pid, label=lbl, kind='defect', grade='작업 항목', money=True, source=ev)

# ── 8. 게이트 노드 + 게이트 종속 ────────────────────────────────────
GATES = [('G0','결정·열쇠 주간','2026-09-04'),('G1','기능 동결','2026-09-11'),
         ('G2','돈 사슬 완결','2026-09-18'),('G3','통합 QA 1차','2026-09-22'),
         ('G4','오픈 리허설','2026-09-30'),('G5','오픈','2026-10-06')]
for gid, lbl, d in GATES:
    node(gid, label=f'{lbl} ({d})', kind='gate', source='L5/O2/gates.md')
GATE_REQ = {
 'G0': ['DEC-EDITOR','DEC-SHIPFEE','DEC-PROOF','DEC-PITSTOP','DEC-DBCONTRACT','X-PG-CONTRACT-01'],
 'G1': ['G0'],
 'G2': ['G1','PRICE-1','PRICE-2','PRICE-3','PRICE-4','PRICE-5','A-15','A-9','A-14','A-19','A-20'],
 'G3': ['G2','A-17','A-13'],
 'G4': ['G3','A-11','A-7','A-10'],
 'G5': ['G4','EXT-PG','X-PRICE-BRIDGE-01','X-MIG-MONEY-RECON-01'],
}
for g, reqs in GATE_REQ.items():
    for r in reqs:
        if r not in nodes: node(r, label=r, kind='unknown')
        edge(r, g, 'gate_entry', f'L5/O2/gates.md {g} 진입 조건 표')

# ── 9. 순환 검출 ───────────────────────────────────────────────────
adj = collections.defaultdict(set)
for e in edges: adj[e['src']].add(e['dst'])
WHITE,GRAY,BLACK = 0,1,2
color = collections.defaultdict(int); cycles=[]
def dfs(u, stack):
    color[u]=GRAY; stack.append(u)
    for v in sorted(adj[u]):
        if color[v]==GRAY:
            i=stack.index(v); cycles.append(stack[i:]+[v])
        elif color[v]==WHITE: dfs(v, stack)
    stack.pop(); color[u]=BLACK
for n in sorted(list(nodes)):
    if color[n]==WHITE: dfs(n, [])

# ── 10. 임계경로: G5 로 가는 최장 사슬 ─────────────────────────────
rev = collections.defaultdict(set)
for e in edges: rev[e['dst']].add(e['src'])
memo={}
def longest(u, seen=None):
    seen = seen or set()
    if u in memo: return memo[u]
    if u in seen: return [u]
    best=[u]
    for p in sorted(rev[u]):
        c = longest(p, seen|{u})
        if len(c)+1 > len(best): best = c+[u]
    memo[u]=best
    return best
crit = longest('G5')

out = {
 'card':'O2 (L5)', 'generated':datetime.datetime.now().isoformat(timespec='seconds'),
 'method':'L3/legacy-normalized.json 의존 필드 + L2/service-dependency.json + N3 §10.2 + price-setup STATUS 를 결정론 스크립트로 결합. 엣지 전건에 source 문자열.',
 'counts':{'nodes':len(nodes),'edges':len(edges),
           'edge_kind':dict(collections.Counter(e['kind'] for e in edges)),
           'node_kind':dict(collections.Counter(n['kind'] for n in nodes.values())),
           'cycles':len(cycles),'unparsed_precondition':len(unparsed)},
 'external_dep_hits':dict(ext_hits), 'internal_dep_hits':dict(internal_hits),
 'cycles':cycles, 'critical_path_to_G5':crit,
 'nodes':list(nodes.values()), 'edges':edges,
}
json.dump(out, open(P('L5','O2','dep-graph.json'),'w'), ensure_ascii=False, indent=1)

with open(P('L5','O2','unparsed-preconditions.md'),'w') as f:
    f.write('# 규칙으로 못 가른 선행조건 원문 (`precondition`)\n\n')
    f.write(f'- 총 `precondition` 보유 행 104 · 규칙 매칭 {104-len(unparsed)} · **미매칭 {len(unparsed)}**\n')
    f.write('- 미매칭은 「의존 없음」이 아니라 **기계 규칙으로 못 가른 것**이다. 사람이 읽고 판정해야 한다.\n\n')
    f.write('| legacy_id | precondition 원문 | 근거 |\n|---|---|---|\n')
    for lid, pre, ev in unparsed:
        f.write(f'| {lid} | {pre} | {ev} |\n')

print('nodes',len(nodes),'edges',len(edges),'cycles',len(cycles),'unparsed',len(unparsed))
print('ext hits',dict(ext_hits))
print('internal(외부아님)',dict(internal_hits))
print('critical path len',len(crit)); print(' -> '.join(crit))
