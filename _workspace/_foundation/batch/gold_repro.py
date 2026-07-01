import sys; sys.path.insert(0,"_workspace/_foundation/batch")
from lib_huni import HuniSim, load_env, price_of
load_env(); sim=HuniSim()
# 068 golden: cover 288 (coat in selections) + inner 287 + set bind PROC_000018
cover={"sub_prd_cd":"PRD_000288","selections":{"siz_cd":"SIZ_000174","print_opt_cd":"POPT_000001","mat_cd":"MAT_000073","plt_siz_cd":"SIZ_000499","coat_side_cnt":1},"qty":100,"procs":[{"proc_cd":"PROC_000004"},{"proc_cd":"PROC_000015"}]}
inner={"sub_prd_cd":"PRD_000287","selections":{"plt_siz_cd":"SIZ_000499","print_opt_cd":"POPT_000009","mat_cd":"MAT_000073"},"qty_mode":"derived","pages":24,"procs":[{"proc_cd":"PROC_000004"}]}
r=sim.simulate_set("PRD_000068",100,[cover,inner],set_selections={},set_procs=[{"proc_cd":"PROC_000018"}])
print("068 nested-selections:", price_of(r), "(golden表紙+bind=158,688)")
for mb in r.get("members",[]): print("  ",mb.get("sub_prd_cd"),"contrib",mb.get("contribution"))
print("  set_eval bind:", (r.get("set_eval") or {}).get("contribution"))
# cover-only + bind (golden definition excl inner)
r2=sim.simulate_set("PRD_000068",100,[cover],set_selections={},set_procs=[{"proc_cd":"PROC_000018"}])
print("068 cover+bind only:", price_of(r2))
