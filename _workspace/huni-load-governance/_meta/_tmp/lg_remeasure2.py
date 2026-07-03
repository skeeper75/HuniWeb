#!/usr/bin/env python3
import sys, json
sys.path.insert(0, "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/batch")
from lib_huni import load_env, db, HuniSim, price_of
load_env()

def q(sql):
    try:
        return db(sql)
    except Exception as e:
        return [["ERR", str(e)]]

print("=== D2. 면지 자재 component_prices (cp.mat_cd) — 무가격 확인 ===")
for r in q("""SELECT cp.mat_cd, count(*) FROM t_prc_component_prices cp
   WHERE cp.mat_cd IN ('MAT_000382','MAT_000383','MAT_000384') GROUP BY cp.mat_cd"""):
    print(" ", r)
print("  (0행이면 무가격)")

print("\n=== E2. OPT_000064 참조 price_component 존재 여부 ===")
for r in q("""SELECT comp_cd, comp_nm, use_dims FROM t_prc_price_components
   WHERE use_dims::text LIKE '%OPT_000064%'"""):
    print(" ", r)
print("  (위 0행 = 면지색 옵션 가격 미참여 = 가격종속 N)")

print("\n=== I2. 공식 바인딩 테이블 탐색 ===")
for r in q("""SELECT table_name FROM information_schema.tables
   WHERE table_schema='public' AND (table_name LIKE '%formula%' OR table_name LIKE '%frm%' OR table_name LIKE '%prc_prd%') ORDER BY 1"""):
    print(" ", r)

print("\n=== J. evaluate_set_price 실호출 (072) ===")
sim = HuniSim()
# 073 표지: has_formula=false → 부모 COVERBIND 가 표지+제본 담당. mat MAT_246 plate SIZ_250
cover={"sub_prd_cd":"PRD_000073","selections":{"mat_cd":"MAT_000246","plt_siz_cd":"SIZ_000250"},"qty":1}
# 284 내지: PRF_DGP_INNER. mat MAT_072 print POPT_001 size A5 pages 24
inner={"sub_prd_cd":"PRD_000284","selections":{"siz_cd":"SIZ_000170","print_opt_cd":"POPT_000001","mat_cd":"MAT_000072"},"qty_mode":"derived","pages":24,"procs":[{"proc_cd":"PROC_000004"}]}
myeonji=[{"sub_prd_cd":c,"selections":{},"qty":1} for c in ("PRD_000074","PRD_000075","PRD_000076")]
members=[cover, inner]+myeonji
for copies in (1, 10, 100):
    r = sim.simulate_set("PRD_000072", copies, members, set_selections={})
    p = price_of(r)
    print(f"  copies={copies}: PRICE={p}")
    for mb in r.get("members", []):
        print(f"     member {mb.get('sub_prd_cd')} contrib={mb.get('contribution')} err={mb.get('error')}")
    se = r.get("set_eval") or {}
    print(f"     set_eval contrib={se.get('contribution')}")
    if r.get("error"): print("     ERROR:", r.get("error"))
