import json
man=json.load(open('manifest.json'))
CDS=[m['prd_cd'] for m in man]
def inlist(xs): return ",".join("'"+x+"'" for x in xs)
u=["-- 굿즈 GB-2 전파(clean 28) UNDO — 이번 COMMIT 역제거. 기존 재사용 siz/CPQ는 미터치.",
   "\\set ON_ERROR_STOP on","BEGIN;"]
mint_siz=[v[2] for m in man for v in m['variants'] if v[3]=='mint']
all_siz=[v[2] for m in man for v in m['variants']]
u.append("-- 1) 신규 가격행 제거(이번 apply_ymd)")
u.append("DELETE FROM t_prc_component_prices WHERE apply_ymd='2026-07-03' AND siz_cd IN ("+inlist(all_siz)+") AND comp_cd LIKE 'COMP_GOODS_%';")
u.append("-- 2) 바인딩 제거")
u.append("DELETE FROM t_prd_product_price_formulas WHERE prd_cd IN ("+inlist(CDS)+") AND apply_bgn_ymd='2026-07-03';")
u.append("-- 3) 상품별 공식/구성요소(186/187)")
for cd in [m['prd_cd'] for m in man if m['per_prod_comp']]:
    n=cd[-3:]
    u.append("DELETE FROM t_prc_formula_components WHERE frm_cd='PRF_GOODS_FIX_"+n+"';")
    u.append("DELETE FROM t_prc_price_components WHERE comp_cd='COMP_GOODS_FIX_"+n+"';")
    u.append("DELETE FROM t_prc_price_formulas WHERE frm_cd='PRF_GOODS_FIX_"+n+"';")
u.append("-- 4) CPQ 신규(재사용 230 제외)")
new_cpq=[m['prd_cd'] for m in man if m['cpq']=='new']
u.append("DELETE FROM t_prd_product_option_items WHERE prd_cd IN ("+inlist(new_cpq)+") AND opt_cd BETWEEN 'OPV_000669' AND 'OPV_000733';")
u.append("DELETE FROM t_prd_product_options WHERE prd_cd IN ("+inlist(new_cpq)+") AND opt_cd BETWEEN 'OPV_000669' AND 'OPV_000733';")
u.append("DELETE FROM t_prd_product_option_groups WHERE prd_cd IN ("+inlist(new_cpq)+") AND opt_grp_cd BETWEEN 'OPT_000173' AND 'OPT_000199';")
u.append("-- 5) 신규 product_sizes + siz 제거(재사용분 보존)")
if mint_siz:
    u.append("DELETE FROM t_prd_product_sizes WHERE siz_cd IN ("+inlist(mint_siz)+");")
    u.append("DELETE FROM t_siz_sizes WHERE siz_cd IN ("+inlist(mint_siz)+");")
u.append("-- 6) 자재 delink 복원")
for m in man:
    if m['delink']:
        u.append("UPDATE t_prd_product_materials SET del_yn='N',del_dt=NULL WHERE prd_cd='"+m['prd_cd']+"' AND mat_cd IN ("+inlist(m['delink'])+");")
u.append("COMMIT;")
open('undo.sql','w').write("\n".join(u))
print("undo.sql:", len(u), "stmts · mint_siz", len(mint_siz), "· all_siz", len(all_siz))
