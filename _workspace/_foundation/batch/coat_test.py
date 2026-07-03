import sys; sys.path.insert(0,"_workspace/_foundation/batch")
from lib_huni import HuniSim, load_env, price_of, components_of
load_env(); sim=HuniSim()
# variant A: coat_side_cnt top of selections
for sel in [
  {"siz_cd":"SIZ_000174","print_opt_cd":"POPT_000001","mat_cd":"MAT_000073","plt_siz_cd":"SIZ_000499","coat_side_cnt":1},
  {"siz_cd":"SIZ_000174","print_opt_cd":"POPT_000001","mat_cd":"MAT_000073","plt_siz_cd":"SIZ_000499","coat_side_cnt":"1"},
]:
  r=sim.simulate("PRD_000288", sel, 100, procs=[{"proc_cd":"PROC_000004"},{"proc_cd":"PROC_000015"}])
  print("288 price=", price_of(r))
  for cc,cn,sub,pansu,ok in components_of(r): print("  ",cn, sub, "pansu",pansu,"ok",ok)
