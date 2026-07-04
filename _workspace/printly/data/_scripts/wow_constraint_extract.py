#!/usr/bin/env python3
"""와우프레스 catalog 326상품 → 전체 req_*/rst_* 제약 그래프 결정론 전사.

현 등록분(제약 2종: paper.rst_prsjob·color.req_prsjob는 wow-products.json에만 부분)을
전 유형으로 확장해 wow-constraints.json에 등록한다.

★게이트[HARD]: 값 지어내기 0(전 엣지 catalog 앵커)·LLM 값판단 금지(순수 파싱)·원천 무손상.

제약 부류(원천 raw.prod_info 구조 실측 기반):
  ① 노드→노드 엣지(id 참조·feasibility 그래프 핵심): from_node --kind(req/rst)/rel--> to_node
     - paper.rst_prsjob → prsjob | paper.rst_awkjob → awkjob
     - color.req_prsjob → prsjob | color.rst_prsjob → prsjob
     - prsjob.req_color → color | prsjob.rst_paper → paper | prsjob.rst_awkjob → awkjob(±size cond)
     - awkjob.rst_paper → paper | awkjob.rst_awkjob → awkjob
     - awkjob.req_awkjob → awkjob(paper cond) | size.rst_awkjob → awkjob(size-range cond)
     - size.req_awkjob → awkjob(area cond)
  ② 값-규칙(to_node 없음·범위 payload):
     - size.req_width/height·size.rst_ordqty | paper.req_width/height·paper.rst_ordqty
     - awkjob.req_joboption·req_jobsize·rst_jobqty·rst_cutcnt·rst_size

출력(04_wow-registration/):
  wow-constraints.json          edges[](노드→노드) + rules[](값-규칙) + meta + gaps
  wow-constraints-summary.md    제약 유형별 엣지수·공유 상위·GAP

앵커=catalog:products/<repProd>.json#<jsonpath>. used_by=제약 공유 상품 집계.
"""
import json, glob, os, hashlib
from collections import defaultdict

CAT = "/Users/innojini/Dev/HuniWeb/docs/wowpress/catalog/products"
OUT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-multibrand-ontology/04_wow-registration"

# rel(field) → 대상 노드 타입
REL_TO_TYPE = {
    "req_prsjob": "prsjob", "rst_prsjob": "prsjob",
    "req_awkjob": "awkjob", "rst_awkjob": "awkjob",
    "req_color": "color", "rst_paper": "paper",
}

# 엣지 dedup: key=(from, kind, rel, to, cond_json) → used_by:set
edges = defaultdict(lambda: {"src": None, "used_by": set()})
# 규칙 dedup: key=(node, kind, rel, payload_json) → used_by:set
rules = defaultdict(lambda: {"src": None, "used_by": set()})


def kind_of(rel):
    return "req" if rel.startswith("req_") else "rst"


def cond_key(cond):
    if not cond:
        return ""
    return json.dumps(cond, ensure_ascii=False, sort_keys=True)


def add_edge(from_node, rel, to_id, prod, anchor, cond=None):
    if to_id is None:
        return
    to_type = REL_TO_TYPE[rel]
    to_node = f"{to_type}:{to_id}"
    k = (from_node, kind_of(rel), rel, to_node, cond_key(cond))
    e = edges[k]
    if e["src"] is None:
        e["src"] = (anchor, cond)
    e["used_by"].add(prod)


def add_rule(node, rel, payload, prod, anchor):
    if payload is None or payload == "" or payload == [] or payload == {}:
        return
    pk = json.dumps(payload, ensure_ascii=False, sort_keys=True)
    k = (node, kind_of(rel), rel, pk)
    r = rules[k]
    if r["src"] is None:
        r["src"] = (anchor, payload)
    r["used_by"].add(prod)


def anc(prod, path):
    return f"catalog:products/{prod}.json#raw.prod_info.{path}"


for f in sorted(glob.glob(f"{CAT}/*.json")):
    r = json.load(open(f))["raw"]["prod_info"]
    prod = str(r.get("prodno"))

    # ── 규격 size ──
    for si in r.get("sizeinfo") or []:
        for s in si.get("sizelist") or []:
            sid = s.get("sizeno")
            if sid is None:
                continue
            fn = f"size:{sid}"
            base = f"sizeinfo[].sizelist[sizeno={sid}]"
            # 값-규칙: 비규격 입력범위·주문수량 제약
            for rel in ("req_width", "req_height", "rst_ordqty"):
                add_rule(fn, rel, s.get(rel), prod, anc(prod, f"{base}.{rel}"))
            # 노드→노드: rst_awkjob(size-range 조건별 joblist)
            for blk in s.get("rst_awkjob") or []:
                cond = {ck: blk.get(ck) for ck in
                        ("min_width", "max_width", "min_height", "max_height",
                         "min_verse", "max_verse", "min_sum_wh", "max_sum_wh")
                        if blk.get(ck) is not None}
                for j in blk.get("joblist") or []:
                    add_edge(fn, "rst_awkjob", j.get("jobno"), prod,
                             anc(prod, f"{base}.rst_awkjob"), cond or None)
            # 노드→노드: req_awkjob(면적 조건 + jobgrouplist)
            ra = s.get("req_awkjob")
            if isinstance(ra, dict):
                cond = {ck: ra.get(ck) for ck in ("min_area", "min_sum_wh", "max_area", "max_sum_wh")
                        if ra.get(ck) is not None}
                for grp in ra.get("jobgrouplist") or []:
                    for j in grp.get("joblist") or []:
                        add_edge(fn, "req_awkjob", j.get("jobno"), prod,
                                 anc(prod, f"{base}.req_awkjob"), cond or None)

    # ── 지류 paper ──
    for pi in r.get("paperinfo") or []:
        for pp in pi.get("paperlist") or []:
            pno = pp.get("paperno")
            if pno is None:
                continue
            fn = f"paper:{pno}"
            base = f"paperinfo[].paperlist[paperno={pno}]"
            for rel in ("req_width", "req_height", "rst_ordqty"):
                add_rule(fn, rel, pp.get(rel), prod, anc(prod, f"{base}.{rel}"))
            for j in pp.get("rst_prsjob") or []:
                add_edge(fn, "rst_prsjob", j.get("jobno"), prod, anc(prod, f"{base}.rst_prsjob"))
            for j in pp.get("rst_awkjob") or []:
                add_edge(fn, "rst_awkjob", j.get("jobno"), prod, anc(prod, f"{base}.rst_awkjob"))

    # ── 도수 color (+coloraddlist) ──
    for ci in r.get("colorinfo") or []:
        for pg in ci.get("pagelist") or []:
            for cl in pg.get("colorlist") or []:
                cno = cl.get("colorno")
                if cno is None:
                    continue
                fn = f"color:{cno}"
                base = f"colorinfo[].pagelist[].colorlist[colorno={cno}]"
                for rel in ("req_prsjob", "rst_prsjob"):
                    for j in cl.get(rel) or []:
                        add_edge(fn, rel, j.get("jobno"), prod, anc(prod, f"{base}.{rel}"))
                for cadd in cl.get("coloraddlist") or []:
                    cad = cadd.get("colorno")
                    if cad is None:
                        continue
                    fna = f"color:{cad}"
                    bapath = f"{base}.coloraddlist[colorno={cad}]"
                    for rel in ("req_prsjob", "rst_prsjob"):
                        for j in cadd.get(rel) or []:
                            add_edge(fna, rel, j.get("jobno"), prod, anc(prod, f"{bapath}.{rel}"))

    # ── 인쇄방식 prsjob ──
    for pj in r.get("prsjobinfo") or []:
        for j in pj.get("prsjoblist") or []:
            jno = j.get("jobno")
            if jno is None:
                continue
            fn = f"prsjob:{jno}"
            base = f"prsjobinfo[].prsjoblist[jobno={jno}]"
            for c in j.get("req_color") or []:
                add_edge(fn, "req_color", c.get("colorno"), prod, anc(prod, f"{base}.req_color"))
            for p in j.get("rst_paper") or []:
                add_edge(fn, "rst_paper", p.get("paperno"), prod, anc(prod, f"{base}.rst_paper"))
            for a in j.get("rst_awkjob") or []:
                sno = a.get("sizeno")
                cond = {"size": sno} if sno is not None else None
                add_edge(fn, "rst_awkjob", a.get("jobno"), prod,
                         anc(prod, f"{base}.rst_awkjob"), cond)

    # ── 후가공 awkjob ──
    for ai in r.get("awkjobinfo") or []:
        for grp in ai.get("jobgrouplist") or []:
            for j in grp.get("awkjoblist") or []:
                jno = j.get("jobno")
                if jno is None:
                    continue
                fn = f"awkjob:{jno}"
                base = f"awkjobinfo[].jobgrouplist[].awkjoblist[jobno={jno}]"
                # 값-규칙
                for rel in ("req_joboption", "req_jobsize", "req_jobqty",
                            "rst_jobqty", "rst_cutcnt", "rst_size"):
                    add_rule(fn, rel, j.get(rel), prod, anc(prod, f"{base}.{rel}"))
                # 노드→노드: rst_paper
                for p in j.get("rst_paper") or []:
                    add_edge(fn, "rst_paper", p.get("paperno"), prod, anc(prod, f"{base}.rst_paper"))
                # 노드→노드: rst_awkjob
                for a in j.get("rst_awkjob") or []:
                    add_edge(fn, "rst_awkjob", a.get("jobno"), prod, anc(prod, f"{base}.rst_awkjob"))
                # 노드→노드: req_awkjob(paper 조건별 jobgrouplist)
                ra = j.get("req_awkjob")
                if isinstance(ra, list):
                    for pblk in ra:
                        cond = {"paper": pblk.get("paperno")} if pblk.get("paperno") is not None else None
                        for g in pblk.get("jobgrouplist") or []:
                            for jj in g.get("joblist") or []:
                                add_edge(fn, "req_awkjob", jj.get("jobno"), prod,
                                         anc(prod, f"{base}.req_awkjob"), cond)

# ── 직렬화 ──
comps = json.load(open(f"{OUT}/wow-components.json"))
known = {t: set(comps.get(t, {}).keys()) for t in comps}


def to_exists(to_node):
    t, i = to_node.split(":", 1)
    return i in known.get(t, set())


edges_out, rules_out = [], []
gap_edges = []  # to_node가 등록 구성요소에 없음(GAP)
for (fr, kind, rel, to, ck), e in edges.items():
    anchor, cond = e["src"]
    ub = sorted(e["used_by"], key=lambda x: int(x))
    row = {"from": fr, "kind": kind, "rel": rel, "to": to,
           "source_anchor": anchor, "used_by": ub, "n_used": len(ub)}
    if cond:
        row["cond"] = cond
    edges_out.append(row)
    if not to_exists(to):
        gap_edges.append({"edge": f"{fr} -{rel}-> {to}", "n_used": len(ub)})

for (node, kind, rel, pk), rr in rules.items():
    anchor, payload = rr["src"]
    ub = sorted(rr["used_by"], key=lambda x: int(x))
    rules_out.append({"node": node, "kind": kind, "rel": rel, "payload": payload,
                      "source_anchor": anchor, "used_by": ub, "n_used": len(ub)})

# 결정론 정렬
edges_out.sort(key=lambda r: (r["rel"], r["from"], r["to"], r.get("cond") is not None))
rules_out.sort(key=lambda r: (r["rel"], r["node"], -r["n_used"]))
gap_edges.sort(key=lambda g: -g["n_used"])

n_prod = len(glob.glob(f"{CAT}/*.json"))
out = {
    "meta": {
        "generated_from": f"catalog {n_prod}상품 결정론 전사",
        "anchor_pattern": "catalog:products/<id>.json#raw.prod_info.<jsonpath>",
        "products_parsed": n_prod,
        "n_edges": len(edges_out), "n_rules": len(rules_out), "n_gap_edges": len(gap_edges),
        "edge_model": "node→node feasibility(from_node -kind(req/rst)/rel-> to_node)",
        "rule_model": "값-범위 규칙(to_node 없음·payload=min/max/interval/optionlist 등)",
        "note": "생성≠검증·값 지어내기 0·원천 무손상. 현 wow-components.json(dedup 레지스트리)은 무손상 유지.",
    },
    "edges": edges_out,
    "rules": rules_out,
    "gaps": gap_edges,
}
os.makedirs(OUT, exist_ok=True)
json.dump(out, open(f"{OUT}/wow-constraints.json", "w"), ensure_ascii=False, indent=1)

# ── 요약 md ──
by_rel_e = defaultdict(int)
for r_ in edges_out:
    by_rel_e[r_["rel"]] += 1
by_rel_r = defaultdict(int)
for r_ in rules_out:
    by_rel_r[r_["rel"]] += 1

L = ["# 와우프레스 전 제약 그래프 등록 — 요약 (2026-07-05)\n",
     f"> catalog {n_prod}상품 결정론 전사·앵커=catalog:products/<id>.json#raw.prod_info · 생성≠검증·값 지어내기 0\n",
     f"> 현 2종(paper.rst_prsjob·color.req_prsjob) → 전 유형 확장. 원천/wow-components.json 무손상.\n",
     "## 규모\n",
     f"- 노드→노드 제약 엣지(dedup): **{len(edges_out)}** (feasibility 그래프)",
     f"- 값-규칙 제약(dedup): **{len(rules_out)}**",
     f"- GAP 엣지(to_node 미등록 구성요소): {len(gap_edges)}\n",
     "## ① 노드→노드 엣지 — 유형(rel)별 엣지수\n",
     "| rel | kind | 엣지수 |", "|---|---|---|"]
for rel in sorted(by_rel_e, key=lambda k: -by_rel_e[k]):
    L.append(f"| {rel} | {kind_of(rel)} | {by_rel_e[rel]} |")
L += ["", "## ② 값-규칙 — 유형(rel)별 규칙수\n", "| rel | kind | 규칙수 |", "|---|---|---|"]
for rel in sorted(by_rel_r, key=lambda k: -by_rel_r[k]):
    L.append(f"| {rel} | {kind_of(rel)} | {by_rel_r[rel]} |")

L += ["", "## 공유 상위 — 가장 많은 상품이 공유하는 제약 엣지 (used_by 상위 15)\n"]
for r_ in sorted(edges_out, key=lambda r: -r["n_used"])[:15]:
    cond = f" [cond={json.dumps(r_['cond'],ensure_ascii=False)}]" if r_.get("cond") else ""
    L.append(f"- `{r_['from']} -{r_['rel']}-> {r_['to']}`{cond} — {r_['n_used']}개 상품")

L += ["", "## GAP — to_node가 등록 구성요소에 없는 엣지 (상위 15)\n"]
if gap_edges:
    for g in gap_edges[:15]:
        L.append(f"- `{g['edge']}` — {g['n_used']}개 상품")
    L.append(f"\n(총 {len(gap_edges)} GAP 엣지. 대상 노드=선택 구성요소 아님/제약 전용 참조. 조사 대상.)")
else:
    L.append("- GAP 0 — 전 엣지 to_node가 등록 구성요소에 존재.")

open(f"{OUT}/wow-constraints-summary.md", "w").write("\n".join(L))

print("=== 제약 그래프 등록 완료 ===")
print(f"상품 파싱: {n_prod}")
print(f"노드→노드 엣지(dedup): {len(edges_out)}")
print(f"값-규칙(dedup): {len(rules_out)}")
print(f"GAP 엣지: {len(gap_edges)}")
print("엣지 유형별:", dict(sorted(by_rel_e.items(), key=lambda kv: -kv[1])))
print("규칙 유형별:", dict(sorted(by_rel_r.items(), key=lambda kv: -kv[1])))
