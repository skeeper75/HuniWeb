#!/usr/bin/env python3
"""KB 배선 주장(priced_by·has_component) ↔ 라이브 스냅샷 전수 대조.
[수정] 커서 재사용 버그 제거 — 모든 edge/anchor를 dict로 선적재 후 대조. 재실행 가능."""
import sqlite3, csv, os
HERE=os.path.dirname(__file__)
DB=os.path.join(HERE,'..','..','04_graph','graph.db')
SNAP=os.path.abspath(os.path.join(HERE,'..','..','..','_foundation','live-snapshot','latest'))
con=sqlite3.connect(DB); cur=con.cursor()
# 선적재
ANCHOR={r[0]:r[1] for r in cur.execute("SELECT id,anchor FROM node").fetchall()}
def code(nid):
    a=ANCHOR.get(nid)
    if not a or '/' not in a: return None
    return a.split('/',1)[1]
def edges(rel):
    return cur.execute("SELECT src,dst FROM edge WHERE rel=?",(rel,)).fetchall()
def load_csv(name):
    with open(os.path.join(SNAP,name+'.csv'),encoding='utf-8') as f:
        return list(csv.DictReader(f))
prod_codes={r[0]:r[1].split('/',1)[1] for r in cur.execute("SELECT id,anchor FROM node WHERE type='product'").fetchall()}
PRDSET=set(prod_codes.values())

print("=== ① priced_by: KB(prd→frm) vs live t_prd_product_price_formulas ===")
live_pf={(r['prd_cd'],r['frm_cd']) for r in load_csv('t_prd_product_price_formulas')}
kb_pf={(code(s),code(d)) for s,d in edges('priced_by')}
print(f"KB priced_by({len(kb_pf)}):",sorted(kb_pf))
print("  ! KB-only:",sorted(kb_pf-live_pf) or "없음")
print("  ! LIVE-only(8상품):",sorted({x for x in live_pf if x[0] in PRDSET}-kb_pf) or "없음")

print("\n=== ② has_component: KB(frm→comp) vs live t_prc_formula_components ===")
live_fc={(r['frm_cd'],r['comp_cd']) for r in load_csv('t_prc_formula_components')}
comp_rows={r['comp_cd']:r for r in load_csv('t_prc_price_components')}
kb_fc={(code(s),code(d)) for s,d in edges('has_component')}
kb_frms={f for f,c in kb_fc}
mm=0
for f in sorted(kb_frms):
    kb_c={c for ff,c in kb_fc if ff==f}
    lv_c={c for ff,c in live_fc if ff==f}
    ko=kb_c-lv_c; lo=lv_c-kb_c
    if ko or lo:
        mm+=1; print(f"  {f}: KB-only={sorted(ko) or '-'}  LIVE-only={sorted(lo) or '-'}")
    else: print(f"  {f}: MATCH ({len(kb_c)})")
print("  frm 불일치:",mm)

print("\n=== ②b KB 인용 component의 라이브 del_yn=Y/use_yn=N/부재 ===")
flag=0
for f,c in sorted(kb_fc):
    row=comp_rows.get(c)
    if not row: print(f"  !! {c} (via {f}): 라이브 부재"); flag+=1; continue
    if row.get('del_yn','N')=='Y' or row.get('use_yn','Y')=='N':
        print(f"  !! {c}: del_yn={row.get('del_yn')} use_yn={row.get('use_yn')} (via {f})"); flag+=1
if not flag: print("  없음")

print("\n=== ②c 라이브 frm에 있으나 KB has_component 미기재(누락) — 8상품 관련 frm만 ===")
kb_frm_set=set(kb_frms)
for f in sorted(kb_frm_set):
    lv_c={c for ff,c in live_fc if ff==f}
    kb_c={c for ff,c in kb_fc if ff==f}
    miss=lv_c-kb_c
    if miss: print(f"  {f}: 라이브에만 {sorted(miss)}")
