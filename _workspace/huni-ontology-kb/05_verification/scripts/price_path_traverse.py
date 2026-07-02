#!/usr/bin/env python3
"""가격경로 연결 완전성 탐색 (재귀 CTE). 8상품 각각:
product → priced_by → formula → has_component → component
        → has_size / has_process / uses_material / has_option_group → option_refs
끊긴 축은 명시. 재실행 가능."""
import sqlite3, sys, os
DB=os.path.join(os.path.dirname(__file__),'..','..','04_graph','graph.db')
con=sqlite3.connect(DB); cur=con.cursor()
prods=[r[0] for r in cur.execute("SELECT id FROM node WHERE type='product' ORDER BY id")]
AXES=['priced_by','has_size','has_process','uses_material','has_option_group','has_print_option','has_plate_size','in_category']
print("== 상품별 축 연결 현황 ==")
for p in prods:
    parts=[]
    for ax in AXES:
        n=cur.execute("SELECT count(*) FROM edge WHERE src=? AND rel=?",(p,ax)).fetchone()[0]
        parts.append(f"{ax}={n}")
    print(p)
    print("   "+" ".join(parts))
    # formula -> component chain
    fs=[r[0] for r in cur.execute("SELECT dst FROM edge WHERE src=? AND rel='priced_by'",(p,))]
    for f in fs:
        comps=[r[0] for r in cur.execute("SELECT dst FROM edge WHERE src=? AND rel='has_component'",(f,))]
        print(f"     {f}: {len(comps)} components")
        # each component leaf?
        for c in comps:
            out=cur.execute("SELECT count(*) FROM edge WHERE src=?",(c,)).fetchone()[0]
            exists=cur.execute("SELECT count(*) FROM node WHERE id=?",(c,)).fetchone()[0]
            if exists==0:
                print(f"        !! DEAD component node: {c}")
print()
print("== 끊긴/dead 엣지 (dst 노드 부재) 전수 ==")
dead=cur.execute("""SELECT e.src,e.rel,e.dst FROM edge e
  LEFT JOIN node n ON e.dst=n.id WHERE n.id IS NULL""").fetchall()
for r in dead: print("  DEAD-DST:",r)
print(f"  총 {len(dead)}건")
print("== 끊긴 src (src 노드 부재) ==")
deads=cur.execute("""SELECT e.src,e.rel,e.dst FROM edge e
  LEFT JOIN node n ON e.src=n.id WHERE n.id IS NULL""").fetchall()
for r in deads: print("  DEAD-SRC:",r)
print(f"  총 {len(deads)}건")
print("== 고아 노드 (엣지 전무) ==")
orph=cur.execute("""SELECT id,type FROM node WHERE id NOT IN (SELECT src FROM edge) AND id NOT IN (SELECT dst FROM edge)""").fetchall()
for r in orph: print("  ORPHAN:",r)
print(f"  총 {len(orph)}건")
