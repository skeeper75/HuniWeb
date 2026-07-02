#!/usr/bin/env python3
"""배정 축: 가격 경로 연결 완전성(전 36상품).
상품→차원→자재/공정→옵션→공식→구성요소 경로를 재귀 실탐색하고
끊김이 (a) 완결 (b) 상품에 배선된 GAP으로 정직 선언 (c) 조용한 누락/orphan-GAP 중 무엇인지 판정.
재실행 가능. 토큰0 결정론."""
import sqlite3, os, re, json
DB=os.path.join(os.path.dirname(__file__),'..','..','04_graph','graph.db')
con=sqlite3.connect(DB); cur=con.cursor()

def outdeg(src,rel): return cur.execute("SELECT count(*) FROM edge WHERE src=? AND rel=?",(src,rel)).fetchone()[0]
def out(src,rel): return [r[0] for r in cur.execute("SELECT dst FROM edge WHERE src=? AND rel=?",(src,rel))]

prods=[r[0] for r in cur.execute("SELECT id FROM node WHERE type='product' ORDER BY id")]

# gap wiring index: gap_id -> set of products it is connected to (either direction)
gaps={}
for g in [r[0] for r in cur.execute("SELECT id FROM node WHERE type='gap'")]:
    prodset=set()
    for s,r in cur.execute("SELECT src,rel FROM edge WHERE dst=?",(g,)):
        if s.startswith('product-'): prodset.add(s)
    for r,d in cur.execute("SELECT rel,dst FROM edge WHERE src=?",(g,)):
        if d.startswith('product-'): prodset.add(d)
    gaps[g]=prodset

def gap_for(prod, keyword):
    """상품에 배선되고 keyword 포함하는 gap이 있으면 반환."""
    pn=re.search(r'product-(\d+)',prod).group(1)
    hits=[]
    for g,ps in gaps.items():
        gid=g.lower()
        if prod in ps and (keyword in gid or pn in gid):
            hits.append(g)
    return hits

def any_gap_mentions(prod_num, keyword):
    """상품번호+keyword를 포함하는 gap 노드가 KB에 존재하는지(배선 무관)."""
    hits=[]
    for g in gaps:
        gid=g.lower()
        if prod_num in gid and keyword in gid:
            hits.append(g)
    return hits

print("== 전 36상품 가격경로 완전성 판정 ==\n")
SILENT=[]; ORPHANGAP=[]; DECLARED=[]
for p in prods:
    pn=re.search(r'product-(\d+)',p).group(1)
    f=out(p,'priced_by')
    sizes=outdeg(p,'has_size'); mats=outdeg(p,'uses_material'); procs=outdeg(p,'has_process')
    # formula -> components
    fcomp={fm:outdeg(fm,'has_component') for fm in f}
    issues=[]
    # 1) formula 부재
    if not f:
        wired=gap_for(p,'price') or gap_for(p,'skeleton') or [g for g in gaps if p in gaps[g]]
        if wired: DECLARED.append((p,'no-formula',wired)); issues.append(f"NO-FORMULA (배선gap: {wired})")
        else: SILENT.append((p,'no-formula')); issues.append("NO-FORMULA (배선gap 없음=SILENT)")
    # 2) formula에 component 0
    for fm,c in fcomp.items():
        if c==0: issues.append(f"{fm} component=0")
    # 3) size 부재 (면적/판수형 공식은 사이즈 필요)
    if sizes==0:
        wired=gap_for(p,'size') or gap_for(p,'pansu') or gap_for(p,'price-path')
        kbgap=any_gap_mentions(pn,'size') or any_gap_mentions(pn,'no-size')
        if wired: DECLARED.append((p,'no-size',wired)); issues.append(f"NO-SIZE (배선gap: {wired})")
        elif kbgap: ORPHANGAP.append((p,'no-size',kbgap)); issues.append(f"NO-SIZE (gap 존재하나 미배선=ORPHAN: {kbgap})")
        else: SILENT.append((p,'no-size')); issues.append("NO-SIZE (gap 없음=SILENT)")
    # 4) material 부재
    if mats==0:
        wired=gap_for(p,'material')
        kbgap=any_gap_mentions(pn,'material')
        if wired: DECLARED.append((p,'no-material',wired)); issues.append(f"NO-MATERIAL (배선gap: {wired})")
        elif kbgap: ORPHANGAP.append((p,'no-material',kbgap)); issues.append(f"NO-MATERIAL (gap 존재하나 미배선=ORPHAN: {kbgap})")
        else: SILENT.append((p,'no-material')); issues.append("NO-MATERIAL (gap 없음=SILENT)")
    tag='OK' if not issues else '  '.join(issues)
    mark='' if not issues else ' <<<'
    print(f"{p}\n   priced_by={len(f)} size={sizes} mat={mats} proc={procs} | {tag}{mark}")

print("\n== 요약 ==")
print(f"SILENT(조용한 누락, 배선gap 전무): {len(SILENT)} -> {SILENT}")
print(f"ORPHAN-GAP(KB에 gap 있으나 상품 미배선=traversal 미도달): {len(ORPHANGAP)} -> {ORPHANGAP}")
print(f"DECLARED(상품 배선gap 존재=정직): {len(DECLARED)} -> {[(x[0],x[1]) for x in DECLARED]}")

# 전역 orphan gap (어느 상품과도 무관)
print("\n== 전역 orphan-GAP (in=out=0, KB 선언되나 그래프 완전 고립) ==")
for g,ps in sorted(gaps.items()):
    deg=cur.execute("SELECT count(*) FROM edge WHERE src=? OR dst=?",(g,g)).fetchone()[0]
    if deg==0: print("  ",g)
