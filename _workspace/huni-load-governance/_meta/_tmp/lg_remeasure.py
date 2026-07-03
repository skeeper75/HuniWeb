#!/usr/bin/env python3
# LG1~LG7 독립 재실측 — PRD_072 하드커버책자 셋트 옵션 거버넌스 게이트
import sys, json
sys.path.insert(0, "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/batch")
from lib_huni import load_env, db, HuniSim, price_of
load_env()

def q(sql):
    try:
        return db(sql)
    except Exception as e:
        return [["ERR", str(e)]]

print("=== A. 인벤토리: t_prd_product_sets (부모 072 구성원) ===")
for r in q("SELECT prd_cd, sub_prd_cd, sub_prd_qty, disp_seq, del_yn FROM t_prd_product_sets WHERE prd_cd='PRD_000072' ORDER BY disp_seq"):
    print(" ", r)

print("\n=== B. 옵션그룹 전수 (6 prd_cd, del_yn 필터 없음) ===")
for r in q("""SELECT g.prd_cd, g.opt_grp_cd, g.opt_grp_nm, g.use_yn, g.del_yn,
   (SELECT count(*) FROM t_prd_product_options o WHERE o.opt_grp_cd=g.opt_grp_cd) AS nopt
   FROM t_prd_product_option_groups g
   WHERE g.prd_cd IN ('PRD_000072','PRD_000073','PRD_000284','PRD_000074','PRD_000075','PRD_000076')
   ORDER BY g.prd_cd, g.opt_grp_cd"""):
    print(" ", r)

print("\n=== C. 면지색 옵션 item ref (OPT_000064) ===")
for r in q("""SELECT o.opt_cd, o.opt_nm, o.dflt_yn, i.item_seq, i.ref_dim_cd, i.ref_key1
   FROM t_prd_product_options o
   JOIN t_prd_product_option_items i ON i.opt_cd=o.opt_cd
   WHERE o.opt_grp_cd='OPT_000064' ORDER BY o.opt_cd, i.item_seq"""):
    print(" ", r)

print("\n=== D. 면지 자재 component_prices (무가격 확인) ===")
for r in q("""SELECT pc.mat_cd, count(cp.*) AS nprice
   FROM t_prc_price_components pc
   LEFT JOIN t_prc_component_prices cp ON cp.comp_cd=pc.comp_cd
   WHERE pc.mat_cd IN ('MAT_000382','MAT_000383','MAT_000384')
   GROUP BY pc.mat_cd"""):
    print(" ", r)
for r in q("""SELECT 'comp_by_mat' t, count(*) FROM t_prc_price_components WHERE mat_cd IN ('MAT_000382','MAT_000383','MAT_000384')"""):
    print(" ", r)

print("\n=== E. opt 를 use_dims 에 쓰는 price_component (가격종속 여부) ===")
for r in q("""SELECT comp_cd, comp_nm, use_dims FROM t_prc_price_components
   WHERE use_dims::text LIKE '%opt%' AND (use_dims::text LIKE '%OPT_000064%' OR comp_nm LIKE '%면지%')"""):
    print(" ", r)
for r in q("""SELECT count(*) FROM t_prc_price_components WHERE use_dims::text LIKE '%opt_cd%'"""):
    print("  opt_cd use_dims total:", r)

print("\n=== F. 부모 072 자재 (MAT_382/383/384 실재 = ref 백킹) ===")
for r in q("""SELECT mat_cd, del_yn FROM t_prd_product_materials WHERE prd_cd='PRD_000072' ORDER BY mat_cd"""):
    print(" ", r)

print("\n=== G. 면지 멤버 074/075/076 빈 껍데기 확인 ===")
for m in ('PRD_000074','PRD_000075','PRD_000076','PRD_000073','PRD_000284'):
    row=[]
    for tbl,label in [("t_prd_product_materials","mat"),("t_prd_product_processes","proc"),
                      ("t_prd_product_sizes","siz"),("t_prd_product_plate_sizes","plt"),
                      ("t_prd_product_option_groups","optg")]:
        c=q(f"SELECT count(*) FROM {tbl} WHERE prd_cd='{m}'")
        row.append(f"{label}={c[0][0]}")
    po=q(f"SELECT count(*) FROM t_prd_product_print_options WHERE prd_cd='{m}'")
    row.append(f"print_opt={po[0][0]}")
    print(" ", m, " ".join(row))

print("\n=== H. print_opt: 부모 072 + 내지 284 (O-2 규범 §3-4) ===")
for m in ('PRD_000072','PRD_000284'):
    for r in q(f"SELECT prd_cd, print_opt_cd, del_yn FROM t_prd_product_print_options WHERE prd_cd='{m}' ORDER BY print_opt_cd"):
        print(" ", r)

print("\n=== I. 공식 바인딩 (부모/구성원) ===")
for r in q("""SELECT prd_cd, frm_cd FROM t_prd_product_formulas
   WHERE prd_cd IN ('PRD_000072','PRD_000073','PRD_000284') ORDER BY prd_cd"""):
    print(" ", r)

print("\n=== J. evaluate_set_price 실호출 (PRICE!=0 · 이중합산 0) ===")
try:
    sim = HuniSim()
    meta = sim.sim_meta("PRD_000072")
    print("  sim_meta keys:", list(meta.keys()))
    print("  RAW(truncated):", json.dumps(meta, ensure_ascii=False)[:3000])
except Exception as e:
    print("  SIM ERR:", repr(e))
