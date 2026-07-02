#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""적대적 그래프 무결성 감사 (검증 라운드1). build_graph.py를 신뢰하지 않고
   jsonl/sqlite/정본을 직접 재실측. L-18(option_refs 부모정합)·중복엣지·고아·문법 재검사."""
import os, re, json, glob, sqlite3, collections
ROOT=os.path.abspath(os.path.join(os.path.dirname(__file__),"../.."))
G=os.path.join(ROOT,"04_graph"); KB=os.path.join(ROOT,"03_kb")
nodes={json.loads(l)['id']:json.loads(l) for l in open(os.path.join(G,"nodes.jsonl"))}
edges=[json.loads(l) for l in open(os.path.join(G,"edges.jsonl"))]

print("### 1. 중복 엣지(SQLite PK로 접힘) ###")
c=collections.Counter((e['src'],e['rel'],e['dst']) for e in edges)
print("edges.jsonl행=%d 고유(src,rel,dst)=%d 중복=%d"%(len(edges),len(c),sum(v-1 for v in c.values() if v>1)))

print("\n### 2. L-18 option_refs 부모정합 (미구현 검사 직접 실행) ###")
# 부모 product = has_option_group의 src. option_refs 타깃이 부모의 uses_material/has_process/has_print_option/has_size 대상인가
parent_of={}
for e in edges:
    if e['rel']=='has_option_group': parent_of[e['dst']]=e['src']
prod_items=collections.defaultdict(set)  # product -> set(target)
for e in edges:
    if e['rel'] in ('uses_material','has_process','has_print_option','has_size'):
        prod_items[e['src']].add(e['dst'])
viol=[]; noparent=[]
for e in edges:
    if e['rel']!='option_refs': continue
    og=e['src']; tgt=e['dst']
    p=parent_of.get(og)
    if not p:
        noparent.append(og); continue
    if tgt not in prod_items.get(p,set()):
        viol.append((og,p,tgt))
print("option_refs 엣지=%d, 부모 has_option_group 없는 optgroup=%d"%(sum(1 for e in edges if e['rel']=='option_refs'),len(set(noparent))))
print("부모정합 위반(부모product가 그 자재/공정을 안 씀)=%d"%len(viol))
for v in viol[:40]: print("  VIOL optgroup=%s parent=%s ref=%s"%v)
print("부모연결 자체가 없는 optgroup(고아 옵션그룹):",sorted(set(noparent)))

print("\n### 3. 고아 노드 전수(degree=0) 실제 재계산 ###")
deg=collections.Counter()
real_ids=set(nodes)
for e in edges:
    if e['src'] in real_ids: deg[e['src']]+=1
    if e['dst'] in real_ids: deg[e['dst']]+=1
orphans=[(nid,n['type']) for nid,n in nodes.items() if deg[nid]==0]
print("고아 총=%d"%len(orphans))
bytype=collections.Counter(t for _,t in orphans)
print("타입별:",dict(bytype))

print("\n### 4. 정본 블록 헤딩 문법: {badge} 없는 ### [ID] 헤딩(파서가 조용히 스킵) ###")
missing=[]
for p in sorted(glob.glob(os.path.join(KB,"**","*.md"),recursive=True)):
    b=os.path.basename(p)
    if b.startswith("_") and b!="_glossary.md": continue
    txt=open(p,encoding="utf-8").read()
    fm=re.match(r"^---\n(.*?)\n---\n(.*)$",txt,re.S)
    body=fm.group(2) if fm else txt
    for m in re.finditer(r"^###\s+\[([^\]]+)\]\s+(.*)$",body,re.M):
        line=m.group(0)
        if not re.search(r"\{(\w+)\}\s*$",line):
            missing.append((os.path.relpath(p,KB),m.group(1),line.strip()[:70]))
print("badge 없는 ### [ID] 헤딩(노드화 안 됨)=%d"%len(missing))
for mm in missing[:30]: print("  ",mm)
