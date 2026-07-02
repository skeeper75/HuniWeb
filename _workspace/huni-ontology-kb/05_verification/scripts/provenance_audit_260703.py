#!/usr/bin/env python3
# 출처 실재성 전수 검증 — 라운드 2 (배정축: 출처 실재성 + 권위 정합 + 오염)
# 각 노드 source(5필드)의 source_file 이 레포 루트 기준 실재하는지 전수 확인.
# 재실행: python3 05_verification/scripts/provenance_audit_260703.py
import json, os, re, sys
from collections import Counter, defaultdict

REPO = "/Users/innojini/Dev/HuniWeb"
KB = os.path.join(REPO, "_workspace/huni-ontology-kb")
nodes = [json.loads(l) for l in open(os.path.join(KB, "04_graph/nodes.jsonl"))]

REQUIRED = ["badge", "captured_at", "source_file", "source_locator", "src_id"]

def resolve(path):
    # 노드 source_file 은 레포 루트 상대 또는 절대(_workspace/... 시작)
    if os.path.isabs(path):
        return path
    return os.path.join(REPO, path)

missing = []          # 실재하지 않는 파일
field_missing = []    # 5필드 누락
badge_ct = Counter()
node_no_source = []
srcfile_ct = Counter()
all_sources = []

for n in nodes:
    nid = n["id"]
    srcs = n.get("sources", [])
    if not srcs:
        node_no_source.append((nid, n.get("type")))
        continue
    for s in srcs:
        all_sources.append((nid, s))
        for f in REQUIRED:
            if f not in s or s.get(f) in (None, ""):
                field_missing.append((nid, f, s.get("src_id")))
        sf = s.get("source_file", "")
        srcfile_ct[sf] += 1
        badge_ct[s.get("badge")] += 1
        if sf:
            rp = resolve(sf)
            # 파일 또는 디렉터리 실재
            if not os.path.exists(rp):
                missing.append((nid, sf, s.get("src_id"), s.get("source_locator")))

print("=== 노드/소스 규모 ===")
print(f"노드 {len(nodes)} · 소스 인용 {len(all_sources)} · distinct source_file {len(srcfile_ct)}")
print(f"소스 없는 노드 {len(node_no_source)}")
print(f"badge 분포: {dict(badge_ct)}")
print()
print("=== 5필드 누락 ===", len(field_missing))
for r in field_missing[:50]:
    print("  ", r)
print()
print("=== 실재하지 않는 source_file ===", len(missing))
for r in missing:
    print("  NODE", r[0], "| src_id", r[2], "| FILE", r[1])
    print("        locator:", r[3])
print()
print("=== 소스 없는 노드(타입별) ===")
tc = Counter(t for _, t in node_no_source)
print(dict(tc))
for nid, t in node_no_source:
    print("  ", t, nid)
