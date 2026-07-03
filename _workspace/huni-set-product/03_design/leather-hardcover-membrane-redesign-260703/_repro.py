import sys, json
sys.path.insert(0, "_workspace/_foundation/batch")
from lib_huni import HuniSim, load_env, db, price_of
load_env()
sim = HuniSim()

SET = sys.argv[1] if len(sys.argv) > 1 else "PRD_000072"

sets = [r[0] for r in db(f"SELECT sub_prd_cd FROM t_prd_product_sets WHERE prd_cd='{SET}' AND del_yn='N' ORDER BY disp_seq")]
pname = {r[0]: r[1] for r in db("SELECT prd_cd, prd_nm FROM t_prd_products")}
def sizes(prd):
    return [r[0] for r in db(f"SELECT siz_cd FROM t_prd_product_sizes WHERE prd_cd='{prd}' AND del_yn<>'Y' ORDER BY disp_seq")]
def mats(prd):
    return [r[0] for r in db(f"SELECT mat_cd FROM t_prd_product_materials WHERE prd_cd='{prd}' AND del_yn<>'Y' ORDER BY (dflt_yn='Y') DESC, disp_seq")]
def pops(prd):
    return [r[0] for r in db(f"SELECT print_opt_cd FROM t_prd_product_print_options WHERE prd_cd='{prd}' AND del_yn<>'Y' ORDER BY disp_seq")]
def plate(prd):
    r = db(f"SELECT siz_cd FROM t_prd_product_plate_sizes WHERE prd_cd='{prd}' AND del_yn<>'Y' ORDER BY (dflt_plt_yn='Y') DESC, siz_cd")
    return r[0][0] if r else None

def build_members(subs):
    ms = []
    for sub in subs:
        nm = pname.get(sub, "")
        mb = {"sub_prd_cd": sub, "label": nm}
        sz = sizes(sub); mt = mats(sub); po = pops(sub)
        if sz: mb["siz_cd"] = sz[0]
        if mt: mb["mat_cd"] = mt[0]
        if po: mb["print_opt_cd"] = po[0]
        if "내지" in nm:
            mb["qty_mode"] = "derived"; mb["pages"] = 24
            pl = plate(sub) or plate(SET)
            if pl: mb["plt_siz_cd"] = pl
        else:
            mb["qty_mode"] = "manual"
        ms.append(mb)
    return ms

def run(label, subs):
    members = build_members(subs)
    print(f"\n########## {label} : members={[s for s in subs]} ##########")
    for copies in (1, 10, 100):
        res = sim.simulate_set(SET, copies, members)
        setc = (res.get("set_eval") or {}).get("contribution")
        print(f"copies={copies:>4} final={res.get('final_price')} base_total={res.get('base_total')} set_contrib={setc}")
        for m in res.get("members", []):
            print(f"     member {m.get('label')}: contribution={m.get('contribution')} included={m.get('included')}")

# BASELINE: current 5 members (cover+inner+3 membrane)
run("BASELINE (current)", sets)

# REDESIGN sim: collapse membrane to 1 (drop 075/076 style) — keep cover+inner+1 membrane
membrane = [s for s in sets if "면지" in pname.get(s, "")]
non_membrane = [s for s in sets if "면지" not in pname.get(s, "")]
keep_one = non_membrane + membrane[:1]
run("REDESIGN (membrane collapsed to 1)", keep_one)

# Also: membrane fully removed (sanity — membrane contributes 0?)
run("SANITY (no membrane at all)", non_membrane)
