#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""silsa_anchor_ownership_260703.py — 실사 그래프 무결성 축2 검증(재현 가능).

동형결합 구성요소·공유 축(size/material/component/category)의 단일 소유권을 결정론 스캔한다.
같은 live 앵커(table/key)를 2개 이상 노드가 소유하면 후보로 뽑고, 앵커 테이블 유형으로
① master 동일타입 = 엔티티 중복(단일소유권 위반) ② cross-type(by-design 후보)
③ junction 조밀 prd-level 앵커(피델리티)로 분류. 04_graph/nodes.jsonl만 읽음(토큰 0).

사용: python3 silsa_anchor_ownership_260703.py
"""
import json, collections, re, os

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
NODES = os.path.join(ROOT, "04_graph/nodes.jsonl")
MASTER = {"t_siz_sizes", "t_mat_materials", "t_prc_price_components", "t_proc_processes",
          "t_prt_print_options", "t_cat_categories", "t_prd_products", "t_bdl_bundles",
          "t_prc_price_formulas"}
SILSA = re.compile(r'-1(1[89]|[2-4][0-9])-')  # id에 -118-..-145- 포함 = 실사 로컬 노드


def main():
    anchor2 = collections.defaultdict(list); types = {}
    for ln in open(NODES, encoding="utf-8"):
        r = json.loads(ln); a = r.get("anchor"); types[r["id"]] = r["type"]
        if a and a not in ("none", "", None) and not str(a).startswith("xlsx:"):
            anchor2[a].append(r["id"])
    dups = {a: ids for a, ids in anchor2.items() if len(ids) > 1}
    catA = catB = catC = 0
    print(f"distinct anchors={len(anchor2)}  held-by->1={len(dups)}")
    print("\n== A: master 동일타입 엔티티 중복(단일소유권 위반) ==")
    for a, ids in sorted(dups.items()):
        tbl = a.split("/")[0]; tset = {types[i] for i in ids}
        if tbl in MASTER and len(tset) == 1:
            catA += 1
            mark = "[SILSA]" if any(SILSA.search(i) for i in ids) else ""
            print(f"  {mark} {a} ({list(tset)[0]}) x{len(ids)}: {ids}")
    print(f"\n== B: cross-type 동일앵커(by-design 후보) =={sum(1 for a,ids in dups.items() if a.split('/')[0] in MASTER and len({types[i] for i in ids})>1)}")
    print(f"== C: junction 조밀 prd-level 앵커(피델리티) =={sum(1 for a in dups if a.split('/')[0] not in MASTER)}")
    catA = sum(1 for a, ids in dups.items() if a.split('/')[0] in MASTER and len({types[i] for i in ids}) == 1)
    print(f"\nA={catA} (기준: master 테이블+동일타입+앵커키=PK)")


if __name__ == "__main__":
    main()
