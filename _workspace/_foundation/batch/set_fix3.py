import sys; sys.path.insert(0, "_workspace/_foundation/batch")
from lib_huni import HuniSim, load_env, price_of
load_env(); sim = HuniSim()
# 097 떡메모지: parent COMP_TTEOKME siz119 bdl_qty50; member 098 inner
r = sim.simulate_set("PRD_000097", 100,
    [{"sub_prd_cd":"PRD_000098","qty_mode":"derived","pages":24}],
    set_selections={"siz_cd":"SIZ_000119","bdl_qty":50}, set_procs=[{"proc_cd":"PROC_000022"}])
print("097 떡메모지:", price_of(r), "set_eval=", (r.get('set_eval') or {}).get('contribution'), "W", len(r.get('warnings') or []))
# 094 엽서북: parent PRF_PCB siz003 print001 opt491; members inner095 cover096
r = sim.simulate_set("PRD_000094", 100,
    [{"sub_prd_cd":"PRD_000095","qty_mode":"derived","pages":20},
     {"sub_prd_cd":"PRD_000096","qty_mode":"manual"}],
    set_selections={"siz_cd":"SIZ_000003","print_opt_cd":"POPT_000001","opt_cd":"OPV_000491"},
    set_procs=[{"proc_cd":"PROC_000022"}])
print("094 엽서북:", price_of(r), "set_eval=", (r.get('set_eval') or {}).get('contribution'), "W", len(r.get('warnings') or []))
for w in (r.get('warnings') or [])[:3]: print("   W:", w[:80])
# 100 포토북: parent siz269 opt484
r = sim.simulate_set("PRD_000100", 100,
    [{"sub_prd_cd":"PRD_000101","qty_mode":"derived","pages":24}],
    set_selections={"siz_cd":"SIZ_000269","opt_cd":"OPV_000484"},
    set_procs=[{"proc_cd":"PROC_000020"}])
print("100 포토북:", price_of(r), "set_eval=", (r.get('set_eval') or {}).get('contribution'), "W", len(r.get('warnings') or []))
