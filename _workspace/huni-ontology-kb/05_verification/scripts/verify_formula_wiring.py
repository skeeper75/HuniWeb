#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""공식 노드 has_component 배선 ↔ live-snapshot t_prc_formula_components 전수 diff.
재실행: python3 verify_formula_wiring.py"""
import json, csv, os, collections
ROOT=os.path.abspath(os.path.join(os.path.dirname(__file__),"../.."))
SNAP=os.path.abspath(os.path.join(ROOT,"../_foundation/live-snapshot/latest"))
# KB: formula -> set(component) from edges
kb=collections.defaultdict(set)
for line in open(os.path.join(ROOT,"04_graph/edges.jsonl")):
    e=json.loads(line)
    if e["rel"]=="has_component":
        kb[e["src"]].add(e["dst"])
# live: frm_cd -> set(comp)
live=collections.defaultdict(set)
for r in csv.DictReader(open(os.path.join(SNAP,"t_prc_formula_components.csv"))):
    live[r["frm_cd"]].add(r["comp_cd"])
issues=0
for fid in sorted(kb):
    frm=fid.replace("formula-","")
    kbset={c.replace("component-","") for c in kb[fid]}
    livset=live.get(frm,set())
    missing=livset-kbset  # live에 있는데 KB에 없음
    extra=kbset-livset    # KB에 있는데 live에 없음(환각/오배선)
    if missing or extra:
        issues+=1
        print(f"[DIFF] {fid} (frm={frm})")
        if missing: print(f"   live-only(KB누락): {sorted(missing)}")
        if extra:   print(f"   KB-only(환각/오배선): {sorted(extra)}")
    else:
        print(f"[OK] {fid}: {len(kbset)}행 일치")
print(f"\n총 공식 {len(kb)}개 · 불일치 {issues}개")
