import sys, json, os
sys.path.insert(0, "_workspace/_foundation/batch")
from lib_huni import HuniSim, load_env, db, price_of
load_env()
sim = HuniSim()
BIND_GRP = "PROC_000017"
COAT_GRP = "PROC_000013"
sets = {}
for r in db("SELECT prd_cd, sub_prd_cd, disp_seq FROM t_prd_product_sets WHERE del_yn='N' ORDER BY prd_cd, disp_seq"):
    sets.setdefault(r[0], []).append(r[1])
plate = {}
for prd, siz, dflt in db("SELECT prd_cd, siz_cd, dflt_plt_yn FROM t_prd_product_plate_sizes WHERE del_yn='N'"):
    if prd not in plate or dflt == "Y": plate[prd] = siz
procs = {}
for prd, proc, grp in db("""SELECT pp.prd_cd, pp.proc_cd, coalesce(pr.upr_proc_cd,'-')
    FROM t_prd_product_processes pp LEFT JOIN t_proc_processes pr ON pr.proc_cd=pp.proc_cd WHERE pp.del_yn='N'"""):
    procs.setdefault(prd, []).append((proc, grp))
pf = {}
for prd, frm in db("SELECT prd_cd, frm_cd FROM t_prd_product_price_formulas"): pf[prd] = frm
fc_dims = {}
for frm, comp, ud in db("""SELECT fc.frm_cd, fc.comp_cd, coalesce(pc.use_dims::text,'[]')
    FROM t_prc_formula_components fc LEFT JOIN t_prc_price_components pc ON pc.comp_cd=fc.comp_cd"""):
    fc_dims.setdefault(frm, []).append((comp, ud))
psize = {}
for prd, siz in db("SELECT prd_cd, siz_cd FROM t_prd_product_sizes WHERE del_yn='N' ORDER BY prd_cd, disp_seq"):
    psize.setdefault(prd, siz)
pname = {r[0]: r[1] for r in db("SELECT prd_cd, prd_nm FROM t_prd_products")}
mats_by = {}
for prd, mat in db("SELECT prd_cd, mat_cd FROM t_prd_product_materials WHERE del_yn='N' ORDER BY prd_cd, disp_seq"):
    mats_by.setdefault(prd, mat)
pops_by = {}
for prd, po in db("SELECT prd_cd, print_opt_cd FROM t_prd_product_print_options WHERE del_yn='N' ORDER BY prd_cd, disp_seq"):
    pops_by.setdefault(prd, po)

def member_payload(sub):
    mb = {"sub_prd_cd": sub}
    if sub in psize: mb["siz_cd"] = psize[sub]
    if sub in mats_by: mb["mat_cd"] = mats_by[sub]
    if sub in pops_by: mb["print_opt_cd"] = pops_by[sub]
    if sub in plate: mb["plt_siz_cd"] = plate[sub]
    mp = [{"proc_cd": p} for p, g in procs.get(sub, []) if g != BIND_GRP]
    if mp: mb["procs"] = mp
    if any(g == COAT_GRP for p, g in procs.get(sub, [])): mb["coat_side_cnt"] = 1
    nm = pname.get(sub, "")
    if "내지" in nm:
        mb["qty_mode"] = "derived"; mb["pages"] = 24
    else:
        mb["qty_mode"] = "manual"
    return mb, nm

def set_selections_for(prd):
    frm = pf.get(prd); sel = {}
    if not frm: return sel
    dims = set()
    for comp, ud in fc_dims.get(frm, []):
        try:
            for d in json.loads(ud): dims.add(d)
        except Exception: pass
    if "siz_cd" in dims and prd in psize: sel["siz_cd"] = psize[prd]
    if "print_opt_cd" in dims: sel["print_opt_cd"] = pops_by.get(prd, "POPT_000001")
    if "bdl_qty" in dims: sel["bdl_qty"] = 1000
    return sel

COPIES = 100
GOLDEN = {"PRD_000068":158688,"PRD_000069":138688,"PRD_000070":288688,"PRD_000077":51146,"PRD_000082":44123}
print("PRD\tname\tfinal\tset_eval\tmembers\tgold\tW")
for prd in sorted(sets):
    members = []
    for sub in sets[prd]:
        try:
            mb, nm = member_payload(sub); members.append(mb)
        except Exception as e:
            pass
    setsel = set_selections_for(prd)
    setprocs = [{"proc_cd": p} for p, g in procs.get(prd, []) if g == BIND_GRP]
    try:
        r = sim.simulate_set(prd, COPIES, members, set_selections=setsel, set_procs=setprocs or None)
    except Exception as e:
        print(f"{prd}\t{pname.get(prd,'')[:12]}\tSIMERR\t{str(e)[:50]}"); continue
    fp = price_of(r)
    contribs = [(mb.get("sub_prd_cd","?").replace("PRD_000",""), mb.get("contribution") or mb.get("subtotal") or 0) for mb in (r.get("members") or [])]
    se = (r.get("set_eval") or {}).get("contribution")
    warns = r.get("warnings") or []
    g = GOLDEN.get(prd, "")
    cs = ",".join(f"{c[0]}:{c[1]}" for c in contribs)
    flag = ""
    if not fp: flag = " <<PRICE=0"
    elif g and abs((fp or 0)-g) > 1: flag = f" <<!=gold{g}"
    print(f"{prd}\t{pname.get(prd,'')[:14]}\t{fp}\t{se}\t{cs}\t{g}\t{len(warns)}{flag}")
    for w in warns[:2]: print("   W:", w[:88])
