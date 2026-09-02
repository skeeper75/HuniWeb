# -*- coding: utf-8 -*-
"""L4a 완료조건 ①~⑤ 자체 검산 + 표본 15건 재대조."""
import csv, json, os, re, random
BASE=os.path.dirname(os.path.abspath(__file__)); ROOT=os.path.abspath(os.path.join(BASE,"..",".."))
MY={"상품·카탈로그","옵션·견적","원고·파일","장바구니·주문","결제","배송","클레임·CS"}
std=[r for r in csv.DictReader(open(os.path.join(ROOT,"L1/standard-feature-canon.csv"))) if r["대분류"] in MY]
mp=list(csv.DictReader(open(os.path.join(BASE,"mapping.csv"))))
asis={r["asis_id"]:r for r in csv.DictReader(open(os.path.join(ROOT,"L2/as-is-inventory.csv")))}
leg={r["legacy_id"]:r for r in json.load(open(os.path.join(BASE,"_legacy-lean.json")))}
fail=[]

# ① 자기 도메인 std 전건
if {r["std_id"] for r in mp}!={r["std_id"] for r in std}: fail.append("① std 집합 불일치")
print("① std 전건 커버: %d/%d" % (len(mp), len(std)))

# ② done 전건 L2 file:line 인용
n=0
for r in mp:
    if r["상태"]!="done": continue
    n+=1
    if not re.search(r"[\w/\.\-\[\]\(\)]+\.(tsx|ts|py|prisma):\d", r["근거"]): fail.append("② file:line 없음 "+r["std_id"])
    if not r["매핑asis_id"]: fail.append("② asis 미인용 "+r["std_id"])
print("② done %d건 전건 file:line + asis 인용" % n)

# ③ new 전건 사유 + 오염 표시
n=0
for r in mp:
    if r["상태"]!="new": continue
    n+=1
    if not r["사유"].strip(): fail.append("③ 사유 없음 "+r["std_id"])
    if ("오염" not in r["사유"]): fail.append("③ 오염표시 없음 "+r["std_id"])
    if r["매핑legacy_id"]: fail.append("③ new인데 legacy 매핑 있음 "+r["std_id"])
print("③ new %d건 전건 사유+ia.md 오염여부 표시" % n)

# ⑤ 미귀속 목록 존재
un=list(csv.DictReader(open(os.path.join(BASE,"unassigned-candidates.csv"))))
used={l for r in mp for l in r["매핑legacy_id"].split(";") if l}
if len(un)+len(used)!=len(leg): fail.append("⑤ 귀속+미귀속 != 716")
print("⑤ 귀속 %d + 미귀속 %d = %d" % (len(used), len(un), len(used)+len(un)))

# ④ 표본 15건 재대조 — 인용 근거를 L2 «원문 텍스트»(csv 파싱 아닌 raw)와 대조
#    ※ L2 as-is-inventory.csv 는 근거 컬럼에 미인용 쉼표가 있어 29/124 행이 파싱 시 잘린다.
#      따라서 raw 텍스트를 권위로 쓴다 (progress.md 인계사항 H-1).
RAW = open(os.path.join(ROOT,"L2/as-is-inventory.csv")).read()
random.seed(20260902)
smp=random.sample(mp,15)
bad=0
for r in smp:
    toks=re.findall(r"[\w/\.\-\[\]\(\)@]+\.(?:tsx|ts|py|prisma):[\d,\-]+", r["근거"])
    for t in toks:
        if t in RAW: continue
        if t.replace("huni-skin-shopby/","") in RAW: continue
        bad+=1; fail.append("④ 근거 불일치 %s : %s" % (r["std_id"], t))
    for a in [x for x in r["매핑asis_id"].split(";") if x]:
        if a not in asis: bad+=1; fail.append("④ asis 부재 %s" % a)
    for l in [x for x in r["매핑legacy_id"].split(";") if x]:
        if l not in leg: bad+=1; fail.append("④ legacy 부재 %s" % l)
print("④ 표본 15건 재대조 불일치: %d" % bad)
print("   표본:", ", ".join(r["std_id"] for r in smp))

# ④-b done 37건 «전건» 근거를 L2 원문과 대조 (표본을 넘어선 전수 검산)
bad2=0
for r in mp:
    if r["상태"]!="done": continue
    for t in re.findall(r"[\w/\.\-\[\]\(\)@]+\.(?:tsx|ts|py|prisma):[\d,\-]+", r["근거"]):
        if t in RAW or t.replace("huni-skin-shopby/","") in RAW: continue
        bad2+=1; fail.append("④b done 근거 불일치 %s : %s" % (r["std_id"], t))
print("④b done 전건(37) 근거 L2 원문 대조 불일치: %d" % bad2)

print()
print("FAIL:" if fail else "ALL PASS")
for f in fail: print(" -",f)
