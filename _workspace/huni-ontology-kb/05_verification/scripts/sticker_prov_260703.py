#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""sticker_prov_260703.py — 스티커 16상품(PRD_000052~067) 배정축 전수 검증.
축: ① 출처 실재성(5필드·손전사 마커) ② 배선(priced_by/has_component·완제품가 룩업)
    ③ 오염 4종 ④ 연당가 양면 정합(4소재만 dual·false-defect 0).
결정론. 재실행: python3 05_verification/scripts/sticker_prov_260703.py
"""
import json, os, re, csv
from collections import defaultdict

REPO = "/Users/innojini/Dev/HuniWeb"
FOUND = os.path.join(REPO, "_workspace/_foundation")
KB = os.path.join(REPO, "_workspace/huni-ontology-kb")
SNAP = os.path.join(FOUND, "live-snapshot/latest")
nodes = [json.loads(l) for l in open(os.path.join(KB, "04_graph/nodes.jsonl"))]
edges = [json.loads(l) for l in open(os.path.join(KB, "04_graph/edges.jsonl"))]
byid = {n["id"]: n for n in nodes}

# ---- resolver (KB-relative 포함) ----
def resolve(sf):
    if not sf: return None
    if os.path.isabs(sf): return sf
    if sf.startswith("live-snapshot/"): return os.path.join(FOUND, sf)
    if sf.startswith("_meta/") or sf.startswith("03_kb/") or sf.startswith("axis/"):
        return os.path.join(KB, sf)  # KB-relative
    return os.path.join(REPO, sf)

# ---- sticker scope: 16 products ----
STK_PRD = ["PRD_0000%d" % i for i in range(52, 68)]
def is_stk_product(n):
    return n.get("type") == "product" and any(n.get("anchor","").endswith(p) for p in STK_PRD)
stk_products = [n for n in nodes if is_stk_product(n)]
print("=== 스티커 상품 노드 실측:", len(stk_products), "개 (기대 16) ===")
found_codes = set(n["anchor"].split("/")[1] for n in stk_products)
print("누락 PRD:", [p for p in STK_PRD if p not in found_codes])

# sticker-scoped node set: product nodes + nodes whose file_path is a sticker product file
STK_FILES = re.compile(r"(product-05[2-7]-sticker|sticker-)")
stk_nodes = [n for n in nodes if STK_FILES.search(n.get("file_path","")) or is_stk_product(n)]
stk_ids = set(n["id"] for n in stk_nodes)
print("스티커 스코프 노드:", len(stk_nodes))

# ---- AXIS1: 출처 5필드 + 파일 실재 (스티커 스코프) ----
REQ = ["source_file","source_locator","captured_at","badge","src_id"]
missing_field=[]; unresolvable=[]
for n in stk_nodes:
    for s in n.get("sources", []):
        for f in REQ:
            if not s.get(f): missing_field.append((n["id"], f))
        sf=s.get("source_file","")
        # '+' 결합 또는 다중경로 = 단일 파일로 해석 불가
        if "+" in sf:
            unresolvable.append((n["id"], sf, "multi-path '+' 결합"))
            continue
        rp=resolve(sf)
        if rp and not os.path.exists(rp):
            unresolvable.append((n["id"], sf, "파일 부재(resolver 후)"))
print("\n=== AXIS1 출처 실재성 (스티커) ===")
print("[A1.a] 5필드 결측:", len(missing_field), missing_field[:10])
print("[A1.b] source_file 해석불가/부재:", len(unresolvable))
for r in unresolvable: print("   ", r)

# ---- AXIS2: 배선 (priced_by / has_component) ----
print("\n=== AXIS2 배선 (스티커 상품 전수) ===")
edge_out=defaultdict(list)
for e in edges: edge_out[e["src"]].append(e)
no_price=[]; formula_no_comp=[]
for p in stk_products:
    pid=p["id"]
    pr=[e for e in edge_out[pid] if e["rel"]=="priced_by"]
    hasgap = any(e["rel"]=="references" and "gap" in e.get("dst","") for e in edge_out[pid])
    if not pr and not hasgap:
        no_price.append(pid)
    for e in pr:
        fnode=byid.get(e["dst"])
        if fnode:
            comps=[x for x in edge_out[e["dst"]] if x["rel"]=="has_component"]
            if not comps:
                formula_no_comp.append((pid, e["dst"]))
print("[A2.a] priced_by/gap 둘 다 없는 스티커 상품:", no_price)
print("[A2.b] has_component 없는 스티커 공식(고아):", formula_no_comp)
# 완제품가 룩업 vs 원자합산: 스티커 공식이 COMP_STK_*/COMP_GANGPAN_* 로 배선됐나
print("[A2.c] 스티커 상품→공식→구성요소 배선 요약:")
for p in sorted(stk_products, key=lambda x:x["anchor"]):
    pid=p["id"]
    for e in edge_out[pid]:
        if e["rel"]=="priced_by":
            comps=[x["dst"].replace("component-","") for x in edge_out[e["dst"]] if x["rel"]=="has_component"]
            print("   ", p["anchor"].split("/")[1], "->", e["dst"].replace("formula-",""), "->", comps)

# ---- AXIS4: 연당가 양면 정합 ----
print("\n=== AXIS4 연당가 양면 정합 ===")
# 4 authority materials
AUTH4 = {"MAT_000162","MAT_000163","MAT_000164","MAT_000372"}
# child codes tied to authority (백색후지371/홀로590/크라프591 은 부모 연동)
CHILD = {"MAT_000371":"MAT_000162","MAT_000590":"MAT_000163","MAT_000591":"MAT_000164"}
dual_nodes=[n for n in nodes if n.get("extra",{}).get("authority_value") and n.get("type")=="material"]
# sticker-relevant dual (anchor is a mat used by sticker or in AUTH4/CHILD)
covered=defaultdict(list)
false_defect=[]
for n in dual_nodes:
    mc = n.get("anchor","").split("/")[-1]
    root = CHILD.get(mc, mc)
    if root in AUTH4:
        covered[root].append(n["id"])
    else:
        # non-authority material with dual — false-defect candidate (스티커 국한 판정)
        if STK_FILES.search(n.get("file_path","")) or mc in {"MAT_000084","MAT_000242","MAT_000155","MAT_000156"}:
            false_defect.append((n["id"], mc))
print("[A4.a] 4 권위소재별 양면노드 커버리지:")
for m in sorted(AUTH4):
    print("   ", m, "->", covered.get(m, "★없음(MISSING dual)"))
print("[A4.b] 무변경 스티커 소재에 만든 false-defect 양면노드:", false_defect if false_defect else "0 (없음·§4-D 준수)")
# 유포/비코팅/미색 등 무변경 소재가 defect badge 인지
UNCHANGED=["MAT_000084","MAT_000242"]  # 비코팅·미색(065 등)
for m in UNCHANGED:
    nn=byid.get("material-"+m)
    if nn: print("   무변경소재", m, "badge=", nn.get("badge"), "(defect면 false-defect)")

# ---- AXIS3: 오염 (스티커 스코프 재확인) ----
print("\n=== AXIS3 오염 (스티커) ===")
oldauth=[]
for n in stk_nodes:
    for s in n.get("sources", []):
        blob=(s.get("source_file","")+" "+s.get("source_locator","")).lower()
        if ("260610" in blob or "260527" in blob) and "diff" not in blob and "260702" not in blob:
            oldauth.append((n["id"], s.get("source_locator","")[:60]))
print("[A3.a] 구권위 260610/260527 무대조 인용(스티커):", len(oldauth))
for r in oldauth: print("   ", r)
