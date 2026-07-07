#!/usr/bin/env python3
"""드리프트 전수 스캔 결과 분석 — 상품 base코드 ≠ 가격 base코드 드리프트를 버킷·랭킹.
입력: results/drift-v1.jsonl. 출력: 요약 + drift-diagnosis.csv + drift-cells.csv.
읽기전용. v4 배치스캐너가 놓친 '일부 조합만 되는' 부분 드리프트를 커버리지 diff로 적발한다.

버킷:
  DRIFT            = 상품 제공 값 중 가격 그리드 미커버 셀 존재(부분 드리프트·★신규 적발)
  MISSING_DIM_DRIFT= 가격 그리드가 요구하는 차원을 상품이 선택지로 미등록(구조 드리프트)
  FULL_DRIFT_0원    = 공식은 있으나 baseline 전면 0(v4가 이미 잡음)
  NO_FORMULA       = 공식 무배선
  CLEAN            = 전 값 커버(드리프트 없음)
  SKIP_기성/반제품  = 견적 대상 아님
"""
import json, csv, collections, os

_f='_workspace/huni-webadmin-load/batch-scan/results/drift-v1.jsonl'
ROWS=[json.loads(l) for l in open(_f) if l.strip()]
TYP={'PRD_TYPE.01':'완제품','PRD_TYPE.02':'반제품','PRD_TYPE.03':'기성'}

def bucket(r):
    typ=r.get('typ'); st=r.get('status')
    if typ=='PRD_TYPE.02': return 'SKIP_반제품'
    return st or 'Z_미분류'

buckets=collections.defaultdict(list)
for r in ROWS: buckets[bucket(r)].append(r)

print(f"=== 드리프트 전수 스캔 분석 (총 {len(ROWS)}개) ===\n")
print(f"{'버킷':<24} {'수':>4}  예시")
print('-'*84)
order=['DRIFT','MISSING_DIM_DRIFT','FULL_DRIFT_0원','NO_FORMULA','CLEAN',
       'SKIP_기성','SKIP_반제품','META_FAIL','EXC']
for b in order+[x for x in sorted(buckets) if x not in order]:
    if b not in buckets: continue
    rs=buckets[b]
    ex=', '.join(r['nm'] for r in rs[:3])
    print(f"{b:<24} {len(rs):>4}  {ex[:52]}")

# ── 부분 드리프트 상세: 상품×미커버 값(교정 대상) ──
print("\n=== ★부분 드리프트(DRIFT) 미커버 셀 상세 ===")
for r in buckets.get('DRIFT',[]):
    cells=', '.join(f"{d['dim']}={d['v']}({d['t']})" for d in (r.get('drift') or [])[:6])
    print(f"  {r['prd_cd']} {r['nm']} [{r.get('covered')}커버/{r.get('uncovered')}미커버]  {cells}")

print("\n=== 구조 드리프트(MISSING_DIM_DRIFT) 상세 ===")
for r in buckets.get('MISSING_DIM_DRIFT',[]):
    print(f"  {r['prd_cd']} {r['nm']}  미등록차원={r.get('missing_dims')} frm={r.get('frm')}")

# ── CSV 1: 상품별 진단 ──
with open('_workspace/huni-webadmin-load/batch-scan/results/drift-diagnosis.csv','w',newline='') as f:
    w=csv.writer(f)
    w.writerow(['bucket','prd_cd','nm','typ','frm','baseline_final','swept_dims',
                'covered','uncovered','missing_dims'])
    for b in order+[x for x in sorted(buckets) if x not in order]:
        for r in buckets.get(b,[]):
            w.writerow([b,r['prd_cd'],r['nm'],TYP.get(r.get('typ'),r.get('typ')),r.get('frm'),
                        r.get('baseline_final'),'|'.join(r.get('swept_dims') or []),
                        r.get('covered'),r.get('uncovered'),'|'.join(r.get('missing_dims') or [])])

# ── CSV 2: 미커버 셀 단위(교정 매니페스트 씨앗) ──
with open('_workspace/huni-webadmin-load/batch-scan/results/drift-cells.csv','w',newline='') as f:
    w=csv.writer(f)
    w.writerow(['prd_cd','nm','frm','dim','uncovered_v','value_label','reason'])
    for r in buckets.get('DRIFT',[]):
        for d in (r.get('drift') or []):
            w.writerow([r['prd_cd'],r['nm'],r.get('frm'),d['dim'],d['v'],d['t'],d.get('reason')])

n_drift=len(buckets.get('DRIFT',[])); n_miss=len(buckets.get('MISSING_DIM_DRIFT',[]))
n_full=len(buckets.get('FULL_DRIFT_0원',[]))+len(buckets.get('NO_FORMULA',[]))
print(f"\n→ 부분 드리프트 {n_drift} · 구조 드리프트 {n_miss} · 전면0/무공식 {n_full}")
print("→ results/drift-diagnosis.csv · drift-cells.csv 저장")
