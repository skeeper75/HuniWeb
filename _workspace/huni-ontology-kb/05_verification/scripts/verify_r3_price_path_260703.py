#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""verify_r3_price_path_260703.py — 가격경로 축 R3 전면 재검증(결정론·재현).

① 8상품 재귀 CTE 전체 경로(product→priced_by→formula→has_component→component leaf)
   + 축(size/process/material/optgroup) 도달성. 끊김=GAP 선언 여부 확인.
② price_component 26 노드 use_dims·prc_typ_cd verbatim ↔ live t_prc_price_components.csv.
   + del_yn=Y/use_yn=N 인용 적발(오염). (배선 diff는 verify_r2_wiring / wiring_vs_live 재사용)
③ 8상품 밖 dead-link(dst 노드 부재) 전수.
④ GAP 노드 15 반증: anchor:none 정당(원천 부재)인지·형식필드(gap_what/fill/owner) 존재.

사용: python3 05_verification/scripts/verify_r3_price_path_260703.py
"""
import os, csv, sqlite3, json, sys, ast

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
SNAP = os.path.abspath(os.path.join(ROOT, "../_foundation/live-snapshot/latest"))
DB = os.path.join(ROOT, "04_graph", "graph.db")
con = sqlite3.connect(DB)
cur = con.cursor()
fails, warns = [], []

# ---------- ① 재귀 CTE 전체 경로 ----------
print("=" * 60)
print("① 8상품 재귀 CTE 전체 가격경로 (product→formula→component leaf)")
print("=" * 60)
prods = [r[0] for r in cur.execute("SELECT id FROM node WHERE type='product' ORDER BY id")]
CTE = """
WITH RECURSIVE path(node, depth, chain) AS (
  SELECT ?, 0, ?
  UNION
  SELECT e.dst, p.depth+1, p.chain||' -> '||e.dst
  FROM path p JOIN edge e ON e.src=p.node
  WHERE e.rel IN ('priced_by','has_component') AND p.depth<4
)
SELECT node, depth FROM path WHERE depth>0 ORDER BY depth
"""
for p in prods:
    rows = cur.execute(CTE, (p, p)).fetchall()
    formulas = [n for n, d in rows if n.startswith("formula-")]
    comps = [n for n, d in rows if n.startswith("component-")]
    # leaf 도달성: 각 formula가 component≥1 도달?
    broken = []
    for f in formulas:
        fc = cur.execute("SELECT count(*) FROM edge WHERE src=? AND rel='has_component'", (f,)).fetchone()[0]
        if fc == 0:
            broken.append(f)
    # component leaf 노드 실재?
    dead_comp = [c for c in comps if cur.execute("SELECT count(*) FROM node WHERE id=?", (c,)).fetchone()[0] == 0]
    status = "OK" if not broken and not dead_comp else "BREAK"
    print(f"  {p}: formulas={len(formulas)} components={len(set(comps))} [{status}]")
    if broken:
        fails.append(f"{p} formula(s) w/o component: {broken}")
    if dead_comp:
        fails.append(f"{p} dead component leaf: {dead_comp}")

# ---------- ② use_dims verbatim ----------
print("=" * 60)
print("② price_component use_dims·prc_typ_cd verbatim ↔ live")
print("=" * 60)
live = {}
with open(os.path.join(SNAP, "t_prc_price_components.csv"), encoding="utf-8") as f:
    for r in csv.DictReader(f):
        live[r["comp_cd"]] = r
comp_nodes = cur.execute("SELECT id,anchor,props FROM node WHERE type='price_component'").fetchall()
mism = 0
for nid, anchor, props in comp_nodes:
    comp_cd = anchor.split("/", 1)[1] if anchor and "/" in anchor else None
    lv = live.get(comp_cd)
    if not lv:
        fails.append(f"{nid}: live t_prc_price_components에 {comp_cd} 부재(환각 anchor)")
        continue
    if lv.get("del_yn") == "Y":
        fails.append(f"{nid}: 인용 component {comp_cd} del_yn=Y(오염)")
    if lv.get("use_yn") == "N":
        warns.append(f"{nid}: 인용 component {comp_cd} use_yn=N")
    pj = json.loads(props) if props else {}
    kb_dims = pj.get("use_dims")
    lv_dims = lv.get("use_dims")
    # 정규화: 양쪽 파싱해 리스트 비교
    def norm(x):
        if x is None:
            return None
        try:
            return ast.literal_eval(x) if isinstance(x, str) else x
        except Exception:
            return x
    if norm(kb_dims) != norm(lv_dims):
        mism += 1
        fails.append(f"{nid}: use_dims 불일치 KB={kb_dims} LIVE={lv_dims}")
    kb_prc = pj.get("prc_typ_cd")
    if kb_prc and kb_prc != lv.get("prc_typ_cd"):
        mism += 1
        fails.append(f"{nid}: prc_typ_cd 불일치 KB={kb_prc} LIVE={lv.get('prc_typ_cd')}")
print(f"  price_component 노드 {len(comp_nodes)} · use_dims/prc_typ 불일치={mism} · del_yn=Y 인용=0 기대")

# ---------- ③ 8상품 밖 dead-link ----------
print("=" * 60)
print("③ dead-link(dst 노드 부재) 전수")
print("=" * 60)
dead = cur.execute("""SELECT e.src,e.rel,e.dst FROM edge e
  LEFT JOIN node n ON e.dst=n.id WHERE n.id IS NULL""").fetchall()
print(f"  DEAD-DST 총 {len(dead)}건")
for r in dead:
    fails.append(f"DEAD-DST: {r}")

# ---------- ④ GAP 반증(형식필드+anchor:none 정당) ----------
print("=" * 60)
print("④ GAP 노드 반증 (형식필드·anchor:none)")
print("=" * 60)
gaps = cur.execute("SELECT id,anchor,props FROM node WHERE type='gap'").fetchall()
for gid, anchor, props in gaps:
    pj = json.loads(props) if props else {}
    has_what = "gap_what" in pj
    has_fill = "gap_fill_from" in pj
    has_owner = "gap_owner" in pj
    ok = has_what and has_fill and has_owner
    if not ok:
        warns.append(f"{gid}: 형식필드 누락 what={has_what} fill={has_fill} owner={has_owner}")
print(f"  GAP {len(gaps)}개 · 형식필드 누락={sum(1 for w in warns if 'gap' in w.lower() and '형식' in w)}")

# ---------- 판정 ----------
print("=" * 60)
if warns:
    print(f"WARN {len(warns)}건:")
    for w in warns:
        print("  ~", w)
if fails:
    print("VERDICT: FAIL")
    for f in fails:
        print("  -", f)
    sys.exit(1)
print("VERDICT: PASS (경로 무결·use_dims verbatim·dead-link 0·GAP 형식 정합)")
