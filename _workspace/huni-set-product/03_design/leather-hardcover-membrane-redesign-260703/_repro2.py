import sys, json
sys.path.insert(0, "_workspace/_foundation/batch")
from lib_huni import HuniSim, load_env, db
load_env()
sim = HuniSim()
SET = "PRD_000072"
pname = {r[0]: r[1] for r in db("SELECT prd_cd, prd_nm FROM t_prd_products")}
def one(sql):
    r = db(sql); return r[0][0] if r else None
def mat(prd): return one(f"SELECT mat_cd FROM t_prd_product_materials WHERE prd_cd='{prd}' AND del_yn<>'Y' ORDER BY (dflt_yn='Y') DESC, disp_seq")
def siz(prd): return one(f"SELECT siz_cd FROM t_prd_product_sizes WHERE prd_cd='{prd}' AND del_yn<>'Y' ORDER BY disp_seq")
def pop(prd): return one(f"SELECT print_opt_cd FROM t_prd_product_print_options WHERE prd_cd='{prd}' AND del_yn<>'Y' ORDER BY disp_seq")
def plt(prd): return one(f"SELECT siz_cd FROM t_prd_product_plate_sizes WHERE prd_cd='{prd}' AND del_yn<>'Y' ORDER BY (dflt_plt_yn='Y') DESC, siz_cd")

# Simulator-faithful members: is_inner is FALSE for 284 (no SEMI_ROLE.01) -> manual qty=copies
cover = {"sub_prd_cd":"PRD_000073","label":pname["PRD_000073"],"qty_mode":"manual"}
if siz("PRD_000073"): cover["siz_cd"]=siz("PRD_000073")
if mat("PRD_000073"): cover["mat_cd"]=mat("PRD_000073")
if pop("PRD_000073"): cover["print_opt_cd"]=pop("PRD_000073")
inner_manual = {"sub_prd_cd":"PRD_000284","label":pname["PRD_000284"],"qty_mode":"manual"}
if siz("PRD_000284"): inner_manual["siz_cd"]=siz("PRD_000284")
if mat("PRD_000284"): inner_manual["mat_cd"]=mat("PRD_000284")
if pop("PRD_000284"): inner_manual["print_opt_cd"]=pop("PRD_000284")
inner_derived = dict(inner_manual); inner_derived["qty_mode"]="derived"; inner_derived["pages"]=24
p=plt("PRD_000284") or plt(SET)
if p: inner_derived["plt_siz_cd"]=p
membrane = {"sub_prd_cd":"PRD_000074","label":pname["PRD_000074"],"qty_mode":"manual"}

for tag, inner in (("INNER=manual(qty=copies) [simulator is_inner=FALSE]", inner_manual),
                   ("INNER=derived(pages=24) [if semi_role.01 assigned]", inner_derived)):
    print(f"\n===== {tag} =====")
    members=[cover, inner, membrane]
    for copies in (1,10,100):
        res=sim.simulate_set(SET, copies, members)
        setc=(res.get("set_eval") or {}).get("contribution")
        inner_c=next((m.get("contribution") for m in res.get("members",[]) if m.get("sub_prd_cd")=="PRD_000284"), None)
        print(f"copies={copies:>4} final={res.get('final_price')} set_contrib={setc} inner_contrib={inner_c}")
