import sqlite3, csv, os
HERE=os.path.dirname(__file__)
DB=os.path.join(HERE,'..','..','04_graph','graph.db')
SNAP=os.path.abspath(os.path.join(HERE,'..','..','..','_foundation','live-snapshot','latest'))
con=sqlite3.connect(DB); cur=con.cursor()
ANCHOR={r[0]:r[1] for r in cur.execute("SELECT id,anchor FROM node").fetchall()}
TYPE={r[0]:r[1] for r in cur.execute("SELECT id,type FROM node").fetchall()}
def code(nid):
    a=ANCHOR.get(nid)
    return a.split('/',1)[1] if a and '/' in a else None
def tbl(nid):
    a=ANCHOR.get(nid)
    return a.split('/',1)[0] if a and '/' in a else None
def load_keys(name,col):
    p=os.path.join(SNAP,name+'.csv')
    if not os.path.exists(p): return None
    with open(p,encoding='utf-8') as f:
        return {r[col] for r in csv.DictReader(f)}
MAT=load_keys('t_mat_materials','mat_cd')
PROC=load_keys('t_proc_processes','proc_cd')
PRT=load_keys('t_prt_print_options','print_opt_cd') or load_keys('t_prt_print_options',list(csv.DictReader(open(os.path.join(SNAP,'t_prt_print_options.csv'))))[0].keys().__iter__().__next__() if False else 'opt_id')
# print options table header
with open(os.path.join(SNAP,'t_prt_print_options.csv')) as f:
    prt_hdr=f.readline().strip().split(',')
print("t_prt_print_options header:",prt_hdr)

print("\n=== option_refs dst → 라이브 실재 대조 ===")
bad=0; tot=0
for s,d in cur.execute("SELECT src,dst FROM edge WHERE rel='option_refs'").fetchall():
    tot+=1
    c=code(d); t=tbl(d); ty=TYPE.get(d)
    live=None
    if ty=='material': live=(c in MAT) if MAT else None
    elif ty=='process': live=(c in PROC) if PROC else None
    elif ty=='print_option': live=None  # 코드계 확인 별도
    if live is False:
        print(f"  !! option_refs dst 라이브 부재: {d} (code={c}, type={ty})"); bad+=1
print(f"  option_refs 총 {tot} · 라이브부재 {bad}")

print("\n=== PRD_000043 라이브 option group 실재? (KB=0) ===")
with open(os.path.join(SNAP,'t_prd_product_option_groups.csv')) as f:
    rows=[r for r in csv.DictReader(f) if r['prd_cd']=='PRD_000043']
print(f"  라이브 PRD_000043 option_groups: {len(rows)}건", [(r['opt_grp_cd'],r.get('use_yn'),r.get('del_yn')) for r in rows])

print("\n=== PRF_DGP_D / PRF_DGP_F: 파일럿 8상품에 priced_by? 라이브 바인딩? ===")
with open(os.path.join(SNAP,'t_prd_product_price_formulas.csv')) as f:
    pf=[r for r in csv.DictReader(f)]
for frm in ['PRF_DGP_D','PRF_DGP_F']:
    binds=[r['prd_cd'] for r in pf if r['frm_cd']==frm]
    print(f"  {frm}: 라이브 바인딩 상품 {binds}")
