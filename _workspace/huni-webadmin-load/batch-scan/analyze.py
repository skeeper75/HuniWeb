#!/usr/bin/env python3
"""배치 스캔 결과 분석 — 상품별 진단을 문제 버킷으로 분류·랭킹.
입력: results/all-v4.jsonl (스캐너 v4 산출). 출력: 요약 + 버킷별 + CSV.
읽기전용 분석. 실 교정은 별도(원인별 하나씩).
v4 스캐너: 필수공정 자동선택·수량 재시도·final>0 재분류·조합 재시도로 오탐 저감(17→6)."""
import json, csv, collections, sys, os

_f='_workspace/huni-webadmin-load/batch-scan/results/all-v4.jsonl'
if not os.path.exists(_f): _f='_workspace/huni-webadmin-load/batch-scan/results/all.jsonl'
ROWS=[json.loads(l) for l in open(_f) if l.strip()]

# 상품유형 라벨
TYP={'PRD_TYPE.01':'완제품','PRD_TYPE.02':'반제품','PRD_TYPE.03':'기성'}

# 버킷 판정 (타입·pricing 메커니즘 인지 → 오탐 방지)
def bucket(r):
    typ=r.get('typ'); st=r.get('status'); frm=r.get('frm'); final=r.get('final')
    # 기성(.03)=제조 없음·고정가 상품 → 견적 대상 아님(별도 정책)
    if typ=='PRD_TYPE.03':
        return 'B0_기성_견적대상아님'
    # 반제품(.02)=셋트 부모가 가격 → 단독 0원 정상일 수 있음
    if typ=='PRD_TYPE.02':
        if st=='OK': return 'A_정상'
        return 'B1_반제품_셋트경유(정상가능)'
    # 완제품(.01) — 실제 견적돼야 (v4: final>0=OK, final 0/null만 결함)
    if st=='OK': return 'A_정상'
    if st=='ZERO_PRICE':
        if not frm: return 'C2_공식무배선(0원)'
        return 'C3_공식있으나0원(차원/셀/옵션)'
    if st=='NO_PRICE': return 'C4_가격없음'
    if st=='HAS_EXCLUDED': return 'C1_제외있음(구버전)'
    if st and st.startswith('SIM_HTTP'): return 'D_SIM오류'
    if st in ('META_FAIL','EXC'): return 'D_스캔오류'
    return 'Z_미분류_'+str(st)

buckets=collections.defaultdict(list)
for r in ROWS:
    buckets[bucket(r)].append(r)

print(f"=== 배치 스캔 분석 (총 {len(ROWS)}개) ===\n")
print(f"{'버킷':<32} {'수':>4}  {'예시'}")
print('-'*90)
for b in sorted(buckets):
    rs=buckets[b]
    ex=', '.join(f"{r['nm']}" for r in rs[:3])
    print(f"{b:<32} {len(rs):>4}  {ex[:50]}")

# 제외 원인 집계 (C1 버킷) — 어떤 구성요소가 제외되나
print("\n=== C1 제외 구성요소 빈도 (교정 우선순위) ===")
excl_freq=collections.Counter()
for r in buckets.get('C1_제외있음(차원/배선/셀누락)',[]):
    for ec in r.get('excl_comps',[]):
        comp=ec.split(':')[0]
        excl_freq[comp]+=1
for comp,n in excl_freq.most_common(20):
    print(f"  {n:>3}  {comp}")

# CSV 산출
with open('_workspace/huni-webadmin-load/batch-scan/results/diagnosis.csv','w',newline='') as f:
    w=csv.writer(f)
    w.writerow(['bucket','prd_cd','nm','typ','status','frm','final','excl','excl_comps'])
    for b in sorted(buckets):
        for r in buckets[b]:
            w.writerow([b,r['prd_cd'],r['nm'],TYP.get(r.get('typ'),r.get('typ')),
                        r.get('status'),r.get('frm'),r.get('final'),r.get('excl'),
                        '|'.join(r.get('excl_comps',[]))])
print("\n→ results/diagnosis.csv 저장")
