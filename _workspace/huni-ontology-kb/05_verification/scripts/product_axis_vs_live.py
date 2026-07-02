#!/usr/bin/env python3
"""8상품 각 축(process/material/print_option/size) KB 배선 vs 라이브 활성 전수 diff.
누락(라이브 활성인데 KB 미배선)=조용한 누락 후보. 재실행 가능."""
import sqlite3, csv, os
HERE=os.path.dirname(__file__)
DB=os.path.join(HERE,'..','..','04_graph','graph.db')
SNAP=os.path.abspath(os.path.join(HERE,'..','..','..','_foundation','live-snapshot','latest'))
con=sqlite3.connect(DB); cur=con.cursor()
ANCHOR={r[0]:r[1] for r in cur.execute("SELECT id,anchor FROM node").fetchall()}
def code(nid):
    a=ANCHOR.get(nid); return a.split('/',1)[1] if a and '/' in a else None
prods={r[1].split('/',1)[1]:r[0] for r in cur.execute("SELECT id,anchor FROM node WHERE type='product'").fetchall()}
def kb_dst(pid,rel):
    return {code(d) for (d,) in cur.execute("SELECT dst FROM edge WHERE src=? AND rel=?",(pid,rel)).fetchall()}
def live_active(fname,prd,keycol,delcol='del_yn'):
    out=set()
    with open(os.path.join(SNAP,fname+'.csv'),encoding='utf-8') as f:
        for r in csv.DictReader(f):
            if r['prd_cd']!=prd: continue
            if delcol in r and r.get(delcol)=='Y': continue
            out.add(r[keycol])
    return out
AX=[('has_process','t_prd_product_processes','proc_cd'),
    ('uses_material','t_prd_product_materials','mat_cd'),
    ('has_print_option','t_prd_product_print_options','print_opt_cd'),
    ('has_size','t_prd_product_sizes','siz_cd')]
for prd in sorted(prods):
    pid=prods[prd]; print(f"\n{prd} ({pid})")
    for rel,fname,keycol in AX:
        kb=kb_dst(pid,rel); lv=live_active(fname,prd,keycol)
        miss=lv-kb; extra=kb-lv
        tag='OK' if not(miss or extra) else 'DIFF'
        line=f"  {rel}: {tag} KB={len(kb)} LIVE={len(lv)}"
        if miss: line+=f"  라이브에만(미배선)={sorted(miss)}"
        if extra: line+=f"  KB에만(라이브부재)={sorted(extra)}"
        print(line)
