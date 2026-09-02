# -*- coding: utf-8 -*-
import csv, json, re, os, collections, random
ROOT=os.path.abspath(os.path.join(os.path.dirname(__file__),'..','..','..'))
def P(*a): return os.path.join(ROOT,*a)
V2=list(csv.DictReader(open(os.path.join(os.path.dirname(__file__),'..','standard-feature-canon-v2.csv'),encoding='utf-8')))
L1=list(csv.DictReader(open(P('L1','standard-feature-canon.csv'),encoding='utf-8')))
M3=list(csv.DictReader(open(P('L0','M3','production-feature-canon.csv'),encoding='utf-8')))
DEC=json.load(open(os.path.join(os.path.dirname(__file__),'decisions.json')))
ok=lambda b: 'PASS' if b else '**FAIL**'
print(f"[V-1] v2 행수 = {len(V2)}")
ids=[r['std_id'] for r in V2]
dup=[k for k,v in collections.Counter(ids).items() if v>1]
print(f"[V-2] std_id 중복 = {len(dup)} {dup[:5]} … {ok(not dup)}")
l1ids={r['std_id'] for r in L1}
newids=set(DEC['new'])
print(f"[V-3] 신규 std_id ∩ 기존353 = {len(newids&l1ids)} {ok(not (newids&l1ids))}")
print(f"[V-4] L1 353행 원문 보존(수정 0) = {ok(all(any(r==dict(zip(r.keys(),[x[c] for c in r])) for x in [next(y for y in V2 if y['std_id']==r['std_id'])]) for r in L1))}")
blank=[r['std_id'] for r in V2 if not r['근거출처'].strip()]
print(f"[V-5] 근거출처 빈칸 = {len(blank)} {ok(not blank)}")
cols=[len(r) for r in V2]; print(f"[V-6] 열수 이상 행 = {sum(1 for c in cols if c!=7)} {ok(all(c==7 for c in cols))}")

# ── 중복 신설 0 ──
STOP=set('선택 관리 처리 등록 조회 표시 발행 발송 적용 상품 주문 결제 배송 화면 목록 설정 연동 기준 정보 사용 확인 자동 대상 여부'.split())
def tk(s): return set(re.findall(r'[가-힣A-Za-z]{2,}',s))-STOP
def norm(s): return re.sub(r'[^가-힣A-Za-z0-9]','',s)
nd=[k for k,v in collections.Counter(norm(r['기능']) for r in V2).items() if v>1]
print(f"[V-7] 기능 문자열 완전중복 = {len(nd)} {nd[:3]} {ok(not nd)}")
delset={d[0] for d in DEC['deleted']}; tagset={t[0] for t in DEC['tagged']}|{f[0] for f in DEC['fp']}
cands=[]
for m in M3:
    tm=tk(m['기능'])
    if not tm: continue
    bj=0; bs=''
    for l in L1:
        tl=tk(l['기능']); ov=tm&tl
        if not ov: continue
        j=len(ov)/len(tm|tl)
        if j>bj: bj,bs=j,l['std_id']
    if bj>=0.20: cands.append((m['std_id'],round(bj,2),bs))
unres=[c for c in cands if c[0] not in delset and c[0] not in tagset]
distset={t[0] for t in DEC['tagged'] if t[1]=='DIST'}
hi=[c for c in cands if c[1]>=0.5 and c[0] not in delset and c[0] not in distset]
print(f"[V-8] 기계 중복후보 {len(cands)}건 · 미판정 {len(unres)} {unres[:6]} {ok(not unres)}")
print(f"[V-9] 고유사(J>=0.5) 미삭제·미DIST = {len(hi)} {[(h[0],h[1],h[2]) for h in hi]} {ok(not hi)}")
c1=['STD-MFG-041','STD-MFG-042','STD-MFG-043','STD-MFG-044','STD-MFG-045','STD-MFG-046','STD-MFG-047','STD-MFG-049','STD-MFG-054','STD-MFG-055','STD-MFG-056','STD-MFG-063','STD-MFG-091','STD-MFG-111']
unr2=[x for x in c1 if x not in delset and x not in tagset and x!='STD-MFG-046']
print(f"[V-10] M3 C-1 표 {len(c1)}건 미판정 = {len(unr2)} {unr2} {ok(not unr2)}")

# ── 갈래3: 진짜 부재 4축 ──
cnt=collections.Counter(r['중분류'] for r in V2 if r['std_id'].startswith('STD-MFG'))
absorb=collections.Counter()
for sid,ref,_f in DEC['deleted']:
    mm=next(x for x in M3 if x['std_id']==sid); absorb[mm['중분류']]+=1
for ax,exp in [('MES연동',21),('상태왕복',14),('공정관리',18),('포장·출고',13)]:
    print(f"[V-11:{ax}] v2 {cnt[ax]}행 + 기존행 흡수 {absorb[ax]} = {cnt[ax]+absorb[ax]} / M3 원본 {exp}행 {ok(cnt[ax]+absorb[ax]==exp)}")
print(f"[V-12] 「정보·콘텐츠」 대분류 = {sum(1 for r in V2 if r['대분류']=='정보·콘텐츠')}행 · 대분류 총 {len({r['대분류'] for r in V2})}종")

# ── 역방향 커버리지 재계산 ──
comp={c['legacy_id']:c for c in json.load(open(os.path.join(os.path.dirname(__file__),'legacy716.json')))}
l2s=json.load(open(os.path.join(os.path.dirname(__file__),'legacy2std.json')))
NEWMAP=json.load(open(os.path.join(os.path.dirname(__file__),'newmap.json'))) if os.path.exists(os.path.join(os.path.dirname(__file__),'newmap.json')) else {}
att=dict(l2s); att.update(NEWMAP)
un=[i for i in comp if i not in att]
kinds=collections.Counter(comp[i]['kind'] or 'IA/SCOPE' for i in un)
print(f"[V-13] legacy 716 귀속 = {len(att)} · 미귀속 = {len(un)} · 미귀속 성격 {dict(kinds)}")
bad=[i for i in un if (comp[i]['kind'] not in ('X','P'))]
print(f"[V-14] 미귀속 중 X/P 아닌 것 = {len(bad)} {bad[:8]} {ok(not bad)}")
