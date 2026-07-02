#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""audit_integrity_r2_260703.py — 검증 라운드 2 (그래프 무결성·스키마 정합 재실측).
정본(03_kb)에서 노드·엣지를 build_graph.py와 독립적으로 재구성해 04_graph 산출과 대조한다.
목적: (1) 정본↔그래프 대응(날조 엣지 0·스푸리어스 노드 0) (2) 파서 밖 문법 위반 수색
      (3) updated(L-7) 강제 여부 (4) 블록 출처 상속·한글 라벨 명세 정합.
재실행: python3 audit_integrity_r2_260703.py  (cwd=05_verification/scripts 또는 KB 루트)
"""
import os, re, glob, json, yaml

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
KB = os.path.join(ROOT, "03_kb")
G = os.path.join(ROOT, "04_graph")

file_nodes, block_nodes, spurious = set(), set(), []
frontmatter_no_start, updated_missing_file, block_no_src, kor_labels = [], [], [], []
recon_edges = set()

for p in sorted(glob.glob(os.path.join(KB, "**", "*.md"), recursive=True)):
    base = os.path.basename(p)
    if base.startswith("_") and base != "_glossary.md":
        continue
    txt = open(p, encoding="utf-8").read()
    fm = re.match(r"^---\n(.*?)\n---\n(.*)$", txt, re.S)
    body = txt
    if fm:
        meta = yaml.safe_load(fm.group(1)) or {}
        body = fm.group(2)
        if isinstance(meta, dict) and "id" in meta:
            file_nodes.add(meta["id"])
            if "updated" not in meta:
                updated_missing_file.append(meta["id"])
            for r in (meta.get("relations") or []):
                if isinstance(r, dict) and "rel" in r and "target" in r:
                    recon_edges.add((meta["id"], r["rel"], r["target"]))
    elif re.search(r"^id:", txt, re.M):
        frontmatter_no_start.append(base)
    if "- 출처:" in body or "- 연결:" in body:
        kor_labels.append(base)
    blocks = list(re.finditer(r"^###\s+\[([^\]]+)\]\s+.*?\{(\w+)\}\s*$", body, re.M))
    for i, mb in enumerate(blocks):
        bid = mb.group(1).strip()
        block_nodes.add(bid)
        start, end = mb.end(), blocks[i + 1].start() if i + 1 < len(blocks) else len(body)
        seg = body[start:end]
        if not re.search(r"^-\s+src:", seg, re.M):
            block_no_src.append(bid)
        for m in re.finditer(r"^-\s+rel:\s*(.*)$", seg, re.M):
            try:
                d = yaml.safe_load(m.group(1))
                if isinstance(d, dict) and "rel" in d and "target" in d:
                    recon_edges.add((bid, d["rel"], d["target"]))
            except Exception:
                pass
    if base in ("index.md", "log.md"):
        for mb in blocks:
            spurious.append((base, mb.group(1)))

recon = file_nodes | block_nodes
jids = {json.loads(l)["id"] for l in open(os.path.join(G, "nodes.jsonl"))}
jedges = {(e["src"], e["rel"], e["dst"]) for e in
          (json.loads(l) for l in open(os.path.join(G, "edges.jsonl")))
          if e["rel"] not in ("references", "alias_of")}

print("[1] 노드 대응: recon=%d jsonl=%d 일치=%s" % (len(recon), len(jids), recon == jids))
print("    jsonl-only(날조):", sorted(jids - recon)[:10])
print("    recon-only(누락):", sorted(recon - jids)[:10])
print("[2] 엣지(비ref/alias) 대응: recon=%d jsonl=%d" % (len(recon_edges - {e for e in recon_edges if e[1] == 'references'}), len(jedges)))
print("    jsonl-only(날조 엣지):", sorted(jedges - recon_edges)[:10])
print("[3] index/log 스푸리어스 블록:", spurious or "0")
print("[4] frontmatter id: 있으나 --- 미시작(누락 위험):", frontmatter_no_start or "0")
print("[5] 블록 자체 src 없음(상속 의존):", block_no_src or "0")
print("[6] 한글 라벨(- 출처:/- 연결:) 사용 파일(명세 §3.1과 정합 시 존재해야):", kor_labels or "0")
print("[7] file-node updated 필드 없음(L-7 미강제 확인):", updated_missing_file or "0(전부 보유·단 강제 아님)")
