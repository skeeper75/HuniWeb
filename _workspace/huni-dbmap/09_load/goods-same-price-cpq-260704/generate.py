#!/usr/bin/env python3
# OPTION-same-price 7상품 형상/방향 CPQ. 가격동일→공식/단가행 없음·CPQ 옵션만. 멱등. dryrun=ROLLBACK.
siz_n=614; grp_n=205; opv_n=752
def SIZ():
    global siz_n; c=f"SIZ_{siz_n:06d}"; siz_n+=1; return c
def GRP():
    global grp_n; c=f"OPT_{grp_n:06d}"; grp_n+=1; return c
def OPV():
    global opv_n; c=f"OPV_{opv_n:06d}"; opv_n+=1; return c
def q(s): return s.replace("'","''")

# 상품: (prd_cd, nm, group_nm, items)
#  items ref→mat: (label, 'MAT', mat_cd)  |  ref→siz mint: (label, 'SIZ', None)
SPEC=[
 ('PRD_000188','레더코스터','형상',[('원형 90mm','MAT','MAT_000263'),('사각 90mm','MAT','MAT_000264')]),
 ('PRD_000190','우드코스터','형상',[('원형 90mm','MAT','MAT_000475'),('사각 90mm','MAT','MAT_000476')]),
 ('PRD_000192','규조토코스터','형상',[('원형 102mm','MAT','MAT_000266'),('사각 100mm','MAT','MAT_000267')]),
 ('PRD_000267','린넨 에코백','방향',[('세로형','MAT','MAT_000332'),('가로형','MAT','MAT_000333')]),
 ('PRD_000208','슬로건','방향',[('양면 가로형','SIZ',None),('양면 세로형','SIZ',None)]),
 ('PRD_000221','말랑키링','형상',[('원형','SIZ',None),('사각','SIZ',None),('꽃','SIZ',None),('별','SIZ',None),('하트','SIZ',None)]),
 ('PRD_000242','광목 스트링 라벨파우치','규격',[('100*70','SIZ',None),('100*40','SIZ',None)]),
]
sql=["-- 굿즈 OPTION-same-price 7상품 형상/방향 CPQ (2026-07-04)","-- 가격동일→공식/단가행 없음. 자재보유=ref→mat(유지)·미보유=siz mint+ref→siz.","\\set ON_ERROR_STOP on","BEGIN;",""]
man=[]
for cd,nm,gnm,items in SPEC:
    grp=GRP()
    sql.append(f"-- ===== {cd} {nm} ({gnm}·{len(items)}) =====")
    # siz mint 필요분 먼저
    mint=[]
    resolved=[]  # (label, ref_dim, ref_key1, ref_key2)
    for lab,kind,ref in items:
        if kind=='MAT':
            resolved.append((lab,'OPT_REF_DIM.03',ref,'USAGE.07'))
        else:
            s=SIZ(); mint.append((s,lab)); resolved.append((lab,'OPT_REF_DIM.01',s,None))
    if mint:
        vals=",".join(f"('{s}','{q((nm+' '+lab))[:60]}','N','Y','N',now())" for s,lab in mint)
        sql.append(f"INSERT INTO t_siz_sizes (siz_cd,siz_nm,impos_yn,use_yn,del_yn,reg_dt) VALUES {vals} ON CONFLICT (siz_cd) DO UPDATE SET siz_nm=EXCLUDED.siz_nm,use_yn='Y',del_yn='N';")
        vals=",".join(f"('{cd}','{s}','{'Y' if i==0 else 'N'}','N',now())" for i,(s,_) in enumerate(mint))
        sql.append(f"INSERT INTO t_prd_product_sizes (prd_cd,siz_cd,dflt_yn,del_yn,reg_dt) VALUES {vals} ON CONFLICT (prd_cd,siz_cd) DO UPDATE SET del_yn='N';")
    # 옵션그룹(택1·필수)
    sql.append(f"INSERT INTO t_prd_product_option_groups (prd_cd,opt_grp_cd,opt_grp_nm,sel_typ_cd,mand_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES ('{cd}','{grp}','{gnm}','SEL_TYPE.01','Y',1,'Y','N',now()) ON CONFLICT (prd_cd,opt_grp_cd) DO UPDATE SET opt_grp_nm=EXCLUDED.opt_grp_nm,mand_yn='Y',use_yn='Y',del_yn='N';")
    ov=[];iv=[]
    for j,(lab,rd,rk1,rk2) in enumerate(resolved):
        o=OPV()
        ov.append(f"('{cd}','{o}','{grp}','{q(lab)[:40]}','{'Y' if j==0 else 'N'}',{j+1},'Y','N',now())")
        rk2s=f"'{rk2}'" if rk2 else "NULL"
        iv.append(f"('{cd}','{o}',1,'{rd}','{rk1}',{rk2s},'Y','N',now())")
    sql.append(f"INSERT INTO t_prd_product_options (prd_cd,opt_cd,opt_grp_cd,opt_nm,dflt_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES {','.join(ov)} ON CONFLICT (prd_cd,opt_cd) DO UPDATE SET opt_grp_cd=EXCLUDED.opt_grp_cd,opt_nm=EXCLUDED.opt_nm,dflt_yn=EXCLUDED.dflt_yn,use_yn='Y',del_yn='N';")
    sql.append(f"INSERT INTO t_prd_product_option_items (prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,ref_key2,use_yn,del_yn,reg_dt) VALUES {','.join(iv)} ON CONFLICT (prd_cd,opt_cd,item_seq) DO UPDATE SET ref_dim_cd=EXCLUDED.ref_dim_cd,ref_key1=EXCLUDED.ref_key1,ref_key2=EXCLUDED.ref_key2,use_yn='Y',del_yn='N';")
    sql.append("")
    man.append(dict(prd_cd=cd,prd_nm=nm,grp=gnm,items=[(lab,rd,rk1) for lab,rd,rk1,_ in resolved],mint=[s for s,_ in mint]))

cds=",".join(f"'{c}' " for c,_,_,_ in SPEC).replace(" ","")
sql.append("\\echo '=== POST: 7상품 CPQ 요약 ==='")
sql.append(f"SELECT (SELECT count(*) FROM t_prd_product_option_groups WHERE prd_cd IN ({cds}) AND del_yn='N') grps, (SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd IN ({cds}) AND del_yn='N') items, (SELECT count(*) FROM t_prd_product_prices WHERE prd_cd IN ({cds})) dprice;")
sql.append("ROLLBACK;")
open('apply.sql','w').write("\n".join(sql))
import json; json.dump(man,open('manifest.json','w'),ensure_ascii=False,indent=1)
print(f"생성: 옵션그룹 7 · siz mint {siz_n-614}(614~{siz_n-1}) · OPV {opv_n-752}(752~{opv_n-1})")
