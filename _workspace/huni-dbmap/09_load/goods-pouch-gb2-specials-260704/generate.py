#!/usr/bin/env python3
# 특수 4상품(194/198/217/226) GB-2 흡수. 값=엑셀 verbatim. 멱등. dryrun=ROLLBACK.
import json
V={d['prd_nm']:d for d in json.load(open('../goods-pouch-gb2-propagate-260704/variants.json'))}
APPLY='2026-07-03'
siz_n=609; grp_n=200; opv_n=734
def SIZ():
    global siz_n; c=f"SIZ_{siz_n:06d}"; siz_n+=1; return c
def GRP():
    global grp_n; c=f"OPT_{grp_n:06d}"; grp_n+=1; return c
def OPV():
    global opv_n; c=f"OPV_{opv_n:06d}"; opv_n+=1; return c
def q(s): return s.replace("'","''")

sql=["-- 굿즈 variant 특수 4상품(194/198/217/226) 2026-07-04","-- 공유 PRF/COMP_GOODS_FIXED_SIZ 재사용. 값=엑셀 verbatim.","\\set ON_ERROR_STOP on","BEGIN;",""]
man=[]

def size_grid(cd, nm, pairs, reuse=None, gname='사이즈', delink=None, extra_cpq=None, rebind_update=False):
    """pairs=[(label,price)]·reuse=[siz or None]. 공유 COMP_GOODS_FIXED_SIZ 사용."""
    reuse = reuse or [None]*len(pairs)
    rows=[]
    for i,(lab,price) in enumerate(pairs):
        s=reuse[i] or SIZ(); rows.append((s,lab,int(price),reuse[i] is None,i==0))
    mint=[r for r in rows if r[3]]
    sql.append(f"-- ===== {cd} {nm} =====")
    if mint:
        vals=",".join(f"('{s}','{q((nm+' '+lab))[:60]}','N','Y','N',now())" for s,lab,_,_,_ in mint)
        sql.append(f"INSERT INTO t_siz_sizes (siz_cd,siz_nm,impos_yn,use_yn,del_yn,reg_dt) VALUES {vals} ON CONFLICT (siz_cd) DO UPDATE SET siz_nm=EXCLUDED.siz_nm,use_yn='Y',del_yn='N';")
    vals=",".join(f"('{cd}','{s}','{'Y' if first else 'N'}','N',now())" for s,_,_,_,first in rows)
    sql.append(f"INSERT INTO t_prd_product_sizes (prd_cd,siz_cd,dflt_yn,del_yn,reg_dt) VALUES {vals} ON CONFLICT (prd_cd,siz_cd) DO UPDATE SET dflt_yn=EXCLUDED.dflt_yn,del_yn='N';")
    sizlist=",".join(f"'{s}'" for s,_,_,_,_ in rows)
    sql.append(f"DELETE FROM t_prc_component_prices WHERE comp_cd='COMP_GOODS_FIXED_SIZ' AND apply_ymd='{APPLY}' AND siz_cd IN ({sizlist});")
    vals=",".join(f"('COMP_GOODS_FIXED_SIZ','{APPLY}','{s}',{price},'굿즈 variant 고정가 260704(엑셀 verbatim)',now())" for s,_,price,_,_ in rows)
    sql.append(f"INSERT INTO t_prc_component_prices (comp_cd,apply_ymd,siz_cd,unit_price,note,reg_dt) VALUES {vals};")
    if rebind_update:
        sql.append(f"UPDATE t_prd_product_price_formulas SET frm_cd='PRF_GOODS_FIXED_SIZ' WHERE prd_cd='{cd}';")
    else:
        sql.append(f"INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,reg_dt) VALUES ('{cd}','PRF_GOODS_FIXED_SIZ','{APPLY}',now()) ON CONFLICT (prd_cd,apply_bgn_ymd) DO UPDATE SET frm_cd=EXCLUDED.frm_cd;")
    # CPQ 사이즈/축(신규)
    grp=GRP()
    sql.append(f"INSERT INTO t_prd_product_option_groups (prd_cd,opt_grp_cd,opt_grp_nm,sel_typ_cd,mand_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES ('{cd}','{grp}','{gname}','SEL_TYPE.01','Y',1,'Y','N',now()) ON CONFLICT (prd_cd,opt_grp_cd) DO UPDATE SET opt_grp_nm=EXCLUDED.opt_grp_nm,mand_yn='Y',use_yn='Y',del_yn='N';")
    ov=[]; iv=[]
    for j,(s,lab,_,_,first) in enumerate(rows):
        o=OPV()
        ov.append(f"('{cd}','{o}','{grp}','{q(lab)[:40]}','{'Y' if first else 'N'}',{j+1},'Y','N',now())")
        iv.append(f"('{cd}','{o}',1,'OPT_REF_DIM.01','{s}','Y','N',now())")
    sql.append(f"INSERT INTO t_prd_product_options (prd_cd,opt_cd,opt_grp_cd,opt_nm,dflt_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES {','.join(ov)} ON CONFLICT (prd_cd,opt_cd) DO UPDATE SET opt_grp_cd=EXCLUDED.opt_grp_cd,opt_nm=EXCLUDED.opt_nm,dflt_yn=EXCLUDED.dflt_yn,use_yn='Y',del_yn='N';")
    sql.append(f"INSERT INTO t_prd_product_option_items (prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,use_yn,del_yn,reg_dt) VALUES {','.join(iv)} ON CONFLICT (prd_cd,opt_cd,item_seq) DO UPDATE SET ref_dim_cd=EXCLUDED.ref_dim_cd,ref_key1=EXCLUDED.ref_key1,use_yn='Y',del_yn='N';")
    # 추가 CPQ(226 글리터=무가·ref mat)
    if extra_cpq:
        eg=GRP(); en,items=extra_cpq['nm'],extra_cpq['items']  # items=[(label,ref_dim,ref_key)]
        sql.append(f"INSERT INTO t_prd_product_option_groups (prd_cd,opt_grp_cd,opt_grp_nm,sel_typ_cd,mand_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES ('{cd}','{eg}','{en}','SEL_TYPE.01','Y',2,'Y','N',now()) ON CONFLICT (prd_cd,opt_grp_cd) DO UPDATE SET opt_grp_nm=EXCLUDED.opt_grp_nm,use_yn='Y',del_yn='N';")
        ov=[];iv=[]
        for j,it in enumerate(items):
            lab,rd,rk1 = it[0],it[1],it[2]; rk2 = it[3] if len(it)>3 else None
            o=OPV()
            ov.append(f"('{cd}','{o}','{eg}','{q(lab)[:40]}','{'Y' if j==0 else 'N'}',{j+1},'Y','N',now())")
            rk2s = f"'{rk2}'" if rk2 else "NULL"
            iv.append(f"('{cd}','{o}',1,'{rd}','{rk1}',{rk2s},'Y','N',now())")
        sql.append(f"INSERT INTO t_prd_product_options (prd_cd,opt_cd,opt_grp_cd,opt_nm,dflt_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES {','.join(ov)} ON CONFLICT (prd_cd,opt_cd) DO UPDATE SET opt_grp_cd=EXCLUDED.opt_grp_cd,opt_nm=EXCLUDED.opt_nm,use_yn='Y',del_yn='N';")
        sql.append(f"INSERT INTO t_prd_product_option_items (prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,use_yn,del_yn,reg_dt) VALUES {','.join(iv)} ON CONFLICT (prd_cd,opt_cd,item_seq) DO UPDATE SET ref_dim_cd=EXCLUDED.ref_dim_cd,ref_key1=EXCLUDED.ref_key1,ref_key2=EXCLUDED.ref_key2,use_yn='Y',del_yn='N';")
    # 자재 delink
    if delink:
        lst=",".join(f"'{m}'" for m in delink)
        sql.append(f"UPDATE t_prd_product_materials SET del_yn='Y',del_dt=now() WHERE prd_cd='{cd}' AND mat_cd IN ({lst}) AND del_yn='N';")
    sql.append("")
    man.append(dict(prd_cd=cd,prd_nm=nm,rows=[(s,lab,price,'mint' if m else 'reuse') for s,lab,price,m,_ in rows],delink=delink or [],extra_cpq=bool(extra_cpq),rebind=rebind_update))

# 194 워터북보틀 — 용량 mint + 자재 delink
size_grid('PRD_000194','워터북보틀', V['워터북보틀']['options'], gname='용량', delink=['MAT_000269','MAT_000343'])
# 198 피크닉매트 — 사이즈 reuse + 색상 유지(무delink)
size_grid('PRD_000198','피크닉매트', V['피크닉매트']['options'], reuse=['SIZ_000399','SIZ_000402'], gname='사이즈')
# 217 만년스탬프 — 사이즈 7 reuse(라벨매칭)
S217={'원형 13x13mm':'SIZ_000419','원형 19x19mm':'SIZ_000420','원형 24x24mm':'SIZ_000421','원형 35x35mm':'SIZ_000422','사각 30x30mm':'SIZ_000423','사각 67x32mm':'SIZ_000424','사각 78x28mm':'SIZ_000425'}
size_grid('PRD_000217','만년스탬프', V['만년스탬프']['options'], reuse=[S217[l] for l,_ in V['만년스탬프']['options']], gname='사이즈')
# 226 아크릴쉐이커코롯토 — TBD 은퇴+rebind·인쇄면 mint·글리터 무가 CPQ·인쇄면 자재 delink
sql.append("-- 226: TBD 공식 은퇴(226 전용·rebind로 대체)")
sql.append("UPDATE t_prc_price_formulas SET use_yn='N' WHERE frm_cd='PRF_ACRYL_SHCOROTTO_TBD';")
size_grid('PRD_000226','아크릴쉐이커코롯토', V['아크릴쉐이커코롯토']['options'], gname='인쇄면',
          delink=['MAT_000309','MAT_000311','MAT_000313'], rebind_update=True,
          extra_cpq=dict(nm='글리터', items=[('핑크글리터','OPT_REF_DIM.03','MAT_000310','USAGE.07'),('화이트글리터','OPT_REF_DIM.03','MAT_000312','USAGE.07'),('블루글리터','OPT_REF_DIM.03','MAT_000314','USAGE.07'),('블랙글리터','OPT_REF_DIM.03','MAT_000315','USAGE.07')]))

sql.append("\\echo '=== POST: 특수 4 요약 ==='")
sql.append("""SELECT
 (SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd IN ('PRD_000194','PRD_000198','PRD_000217','PRD_000226') AND frm_cd='PRF_GOODS_FIXED_SIZ') binds,
 (SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd IN ('PRD_000194','PRD_000198','PRD_000217','PRD_000226') AND del_yn='N') opt_items,
 (SELECT count(*) FROM t_prc_component_prices WHERE comp_cd='COMP_GOODS_FIXED_SIZ' AND apply_ymd='2026-07-03' AND siz_cd BETWEEN 'SIZ_000609' AND 'SIZ_000613') new_cp;""")
sql.append("ROLLBACK;")
open('apply.sql','w').write("\n".join(sql))
json.dump(man,open('manifest.json','w'),ensure_ascii=False,indent=1)
print(f"특수4 생성: SIZ mint {siz_n-609}(609~{siz_n-1}) · OPT {grp_n-200}(200~{grp_n-1}) · OPV {opv_n-734}(734~{opv_n-1})")
