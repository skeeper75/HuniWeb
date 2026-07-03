#!/usr/bin/env python3
# clean 28 굿즈 variant → GB-2 전파(교정판). search-before-mint 재사용 + 186/187 상품별 구성요소.
import json, csv, re
V = {d['prd_nm']: d for d in json.load(open('variants.json'))}
NM2CD = {
 '사각손거울':'PRD_000186','블랙사각손거울':'PRD_000187','벨벳쿠션':'PRD_000195','핀버튼':'PRD_000200',
 '레더스트랩키링':'PRD_000201','키캡키링':'PRD_000202','LED투명키캡키링':'PRD_000203','클립보드':'PRD_000215',
 '투명클립보드':'PRD_000216','폰스트랩':'PRD_000220','이미지피켓':'PRD_000229','레더 플랫 파우치':'PRD_000230',
 '레더 슬림 파우치':'PRD_000231','레더 삼각 파우치':'PRD_000232','레더 볼륨 파우치':'PRD_000233',
 '레더 아이패드/노트북 파우치':'PRD_000238','캔버스 플랫 파우치':'PRD_000239','린넨 스트링 파우치':'PRD_000243',
 '타이벡 플랫 파우치':'PRD_000244','타이벡 슬림 파우치':'PRD_000245','타이벡 삼각 파우치':'PRD_000246',
 '타이벡 스트링 파우치':'PRD_000247','메쉬슬림파우치':'PRD_000249','레더 슬림 미니파우치':'PRD_000252',
 '레더 볼륨 미니파우치':'PRD_000254','타이벡 양면 백팩':'PRD_000273','타이벡보냉보틀백':'PRD_000274','레더라벨제작':'PRD_000280',
}
CD2NM = {v:k for k,v in NM2CD.items()}
CLEAN_ORDER = sorted(NM2CD.values())

# 기존 siz 재사용 맵(엑셀 variant 순서 = 기존 siz 순서·실측 확인). None=신규 mint.
REUSE = {
 'PRD_000186':['SIZ_000384','SIZ_000386','SIZ_000388'],
 'PRD_000187':['SIZ_000384','SIZ_000386','SIZ_000388'],
 'PRD_000200':['SIZ_000548','SIZ_000549'],
 'PRD_000201':['SIZ_000550','SIZ_000551'],
 'PRD_000202':[None,None,None,'SIZ_000406'],       # 2구/3구/4구 mint · 2x2구 재사용
 'PRD_000215':['SIZ_000413','SIZ_000415'],
 'PRD_000220':[None,None],                          # 단면/양면(인쇄면)=신규(기존 17x320mm은 물리치수·미터치)
 'PRD_000230':['SIZ_000433','SIZ_000434'],
 'PRD_000231':['SIZ_000435','SIZ_000436'],
 'PRD_000232':['SIZ_000437','SIZ_000438'],
 'PRD_000280':['SIZ_000492','SIZ_000494','SIZ_000496'],
}
# 186/187=동일 siz 공유·가격상이 → 상품별 구성요소. 나머지=공유 COMP_GOODS_FIXED_SIZ.
PER_PRODUCT_COMP = {'PRD_000186','PRD_000187'}
# 기존 CPQ 사이즈 옵션그룹 완비(재사용·신규 옵션그룹 생성 안 함)
REUSE_CPQ = {'PRD_000230'}

DELINK = {}
with open('live_materials.tsv') as f:
    for row in csv.DictReader(f, delimiter='\t'):
        if row['mat_typ_cd']=='MAT_TYPE.09':
            DELINK.setdefault(row['prd_cd'], []).append(row['mat_cd'])

siz_n=564; grp_n=173; opv_n=669
def SIZ():
    global siz_n; c=f"SIZ_{siz_n:06d}"; siz_n+=1; return c
def GRP():
    global grp_n; c=f"OPT_{grp_n:06d}"; grp_n+=1; return c
def OPV():
    global opv_n; c=f"OPV_{opv_n:06d}"; opv_n+=1; return c
def group_name(opts):
    labs=" ".join(o for o,_ in opts)
    if re.search(r'\d+\s*구', labs): return '구수'
    if re.search(r'단면|양면', labs) and not re.search(r'mm|cm|인치|용|ml', labs): return '인쇄면'
    if re.search(r'A[345]용', labs): return '규격'
    if re.search(r'인치', labs): return '사이즈'
    if re.search(r'정사각|직사각|원형|마카롱', labs) and not re.search(r'mm', labs): return '형태'
    return '사이즈'
def q(s): return s.replace("'","''")

APPLY='2026-07-03'
sql=[]; man=[]
sql.append("-- 굿즈파우치 GB-2 전파(교정판·clean 28) 2026-07-04")
sql.append("-- 26상품=공유 PRF/COMP_GOODS_FIXED_SIZ·기존 siz 재사용 · 186/187=상품별 구성요소(공유siz·가격상이) · 230=기존CPQ재사용")
sql.append("-- 값=엑셀 verbatim(스크립트). 멱등. dryrun=ROLLBACK.")
sql.append("\\set ON_ERROR_STOP on\nBEGIN;\n")
sql.append("INSERT INTO t_prc_price_formulas (frm_cd,frm_nm,use_yn,reg_dt) VALUES ('PRF_GOODS_FIXED_SIZ','굿즈 사이즈등급 고정가','Y',now()) ON CONFLICT (frm_cd) DO UPDATE SET use_yn='Y';")
sql.append("INSERT INTO t_prc_price_components (comp_cd,comp_nm,prc_typ_cd,use_dims,use_yn,del_yn,reg_dt) VALUES ('COMP_GOODS_FIXED_SIZ','굿즈 사이즈별 완제품가','PRICE_TYPE.01','[\"siz_cd\"]','Y','N',now()) ON CONFLICT (comp_cd) DO UPDATE SET use_yn='Y',del_yn='N';")
sql.append("INSERT INTO t_prc_formula_components (frm_cd,comp_cd,disp_seq,addtn_yn,reg_dt) VALUES ('PRF_GOODS_FIXED_SIZ','COMP_GOODS_FIXED_SIZ',1,'N',now()) ON CONFLICT (frm_cd,comp_cd) DO NOTHING;\n")

tot=dict(siz_mint=0,siz_reuse=0,opv=0,cp=0,delink=0,ppcomp=0,cpq_new=0,cpq_reuse=0)
for cd in CLEAN_ORDER:
    nm=CD2NM[cd]; opts=V[nm]['options']; gname=group_name(opts)
    reuse=REUSE.get(cd,[None]*len(opts))
    assert len(reuse)==len(opts), f"{cd} reuse len mismatch {len(reuse)} vs {len(opts)}"
    per_prod = cd in PER_PRODUCT_COMP
    comp = f"COMP_GOODS_FIX_{cd[-3:]}" if per_prod else "COMP_GOODS_FIXED_SIZ"
    frm  = f"PRF_GOODS_FIX_{cd[-3:]}"  if per_prod else "PRF_GOODS_FIXED_SIZ"
    sql.append(f"-- ===== {cd} {nm} ({gname}·v{len(opts)}·{'상품별comp' if per_prod else '공유comp'}{'·CPQ재사용' if cd in REUSE_CPQ else ''}) =====")
    # 상품별 공식/구성요소/배선(186/187)
    if per_prod:
        sql.append(f"INSERT INTO t_prc_price_formulas (frm_cd,frm_nm,use_yn,reg_dt) VALUES ('{frm}','{q(nm)} 사이즈등급 고정가','Y',now()) ON CONFLICT (frm_cd) DO UPDATE SET use_yn='Y';")
        sql.append(f"INSERT INTO t_prc_price_components (comp_cd,comp_nm,prc_typ_cd,use_dims,use_yn,del_yn,reg_dt) VALUES ('{comp}','{q(nm)} 사이즈별 완제품가','PRICE_TYPE.01','[\"siz_cd\"]','Y','N',now()) ON CONFLICT (comp_cd) DO UPDATE SET use_yn='Y',del_yn='N';")
        sql.append(f"INSERT INTO t_prc_formula_components (frm_cd,comp_cd,disp_seq,addtn_yn,reg_dt) VALUES ('{frm}','{comp}',1,'N',now()) ON CONFLICT (frm_cd,comp_cd) DO NOTHING;")
        tot['ppcomp']+=1
    # siz 확정(재사용 or mint)
    rows=[]
    for i,(lab,price) in enumerate(opts):
        s=reuse[i]
        if s is None:
            s=SIZ(); tot['siz_mint']+=1
            rows.append((s,lab,int(price),i==0,True))
        else:
            tot['siz_reuse']+=1
            rows.append((s,lab,int(price),i==0,False))
    mint=[r for r in rows if r[4]]
    if mint:
        vals=",".join(f"('{s}','{q((nm+' '+lab))[:60]}','N','Y','N',now())" for s,lab,_,_,_ in mint)
        sql.append(f"INSERT INTO t_siz_sizes (siz_cd,siz_nm,impos_yn,use_yn,del_yn,reg_dt) VALUES {vals} ON CONFLICT (siz_cd) DO UPDATE SET siz_nm=EXCLUDED.siz_nm,use_yn='Y',del_yn='N';")
    # product_sizes(전부·멱등)
    vals=",".join(f"('{cd}','{s}','{'Y' if first else 'N'}','N',now())" for s,_,_,first,_ in rows)
    sql.append(f"INSERT INTO t_prd_product_sizes (prd_cd,siz_cd,dflt_yn,del_yn,reg_dt) VALUES {vals} ON CONFLICT (prd_cd,siz_cd) DO UPDATE SET dflt_yn=EXCLUDED.dflt_yn,del_yn='N';")
    # component_prices verbatim(멱등 DELETE→INSERT·해당 comp+siz)
    sizlist=",".join(f"'{s}'" for s,_,_,_,_ in rows)
    sql.append(f"DELETE FROM t_prc_component_prices WHERE comp_cd='{comp}' AND apply_ymd='{APPLY}' AND siz_cd IN ({sizlist});")
    vals=",".join(f"('{comp}','{APPLY}','{s}',{price},'굿즈 variant 고정가 260704(엑셀 verbatim)',now())" for s,_,price,_,_ in rows)
    sql.append(f"INSERT INTO t_prc_component_prices (comp_cd,apply_ymd,siz_cd,unit_price,note,reg_dt) VALUES {vals};")
    tot['cp']+=len(rows)
    # 바인딩
    sql.append(f"INSERT INTO t_prd_product_price_formulas (prd_cd,frm_cd,apply_bgn_ymd,reg_dt) VALUES ('{cd}','{frm}','{APPLY}',now()) ON CONFLICT (prd_cd,apply_bgn_ymd) DO UPDATE SET frm_cd=EXCLUDED.frm_cd;")
    # CPQ
    if cd in REUSE_CPQ:
        sql.append(f"-- CPQ: 기존 옵션그룹 재사용(신규 생성 없음)")
        tot['cpq_reuse']+=1
    else:
        grp=GRP(); tot['cpq_new']+=1
        sql.append(f"INSERT INTO t_prd_product_option_groups (prd_cd,opt_grp_cd,opt_grp_nm,sel_typ_cd,mand_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES ('{cd}','{grp}','{gname}','SEL_TYPE.01','Y',1,'Y','N',now()) ON CONFLICT (prd_cd,opt_grp_cd) DO UPDATE SET opt_grp_nm=EXCLUDED.opt_grp_nm,mand_yn='Y',use_yn='Y',del_yn='N';")
        ov=[]; iv=[]
        for j,(s,lab,_,first,_) in enumerate(rows):
            o=OPV(); tot['opv']+=1
            ov.append(f"('{cd}','{o}','{grp}','{q(lab)[:40]}','{'Y' if first else 'N'}',{j+1},'Y','N',now())")
            iv.append(f"('{cd}','{o}',1,'OPT_REF_DIM.01','{s}','Y','N',now())")
        sql.append(f"INSERT INTO t_prd_product_options (prd_cd,opt_cd,opt_grp_cd,opt_nm,dflt_yn,disp_seq,use_yn,del_yn,reg_dt) VALUES {','.join(ov)} ON CONFLICT (prd_cd,opt_cd) DO UPDATE SET opt_grp_cd=EXCLUDED.opt_grp_cd,opt_nm=EXCLUDED.opt_nm,dflt_yn=EXCLUDED.dflt_yn,use_yn='Y',del_yn='N';")
        sql.append(f"INSERT INTO t_prd_product_option_items (prd_cd,opt_cd,item_seq,ref_dim_cd,ref_key1,use_yn,del_yn,reg_dt) VALUES {','.join(iv)} ON CONFLICT (prd_cd,opt_cd,item_seq) DO UPDATE SET ref_dim_cd=EXCLUDED.ref_dim_cd,ref_key1=EXCLUDED.ref_key1,use_yn='Y',del_yn='N';")
    # 자재 delink
    dl=DELINK.get(cd,[])
    if dl:
        matlist=",".join(f"'{m}'" for m in dl)
        sql.append(f"UPDATE t_prd_product_materials SET del_yn='Y',del_dt=now() WHERE prd_cd='{cd}' AND mat_cd IN ({matlist}) AND del_yn='N';")
        tot['delink']+=len(dl)
    sql.append("")
    man.append(dict(prd_cd=cd,prd_nm=nm,grp=gname,per_prod_comp=per_prod,cpq='reuse' if cd in REUSE_CPQ else 'new',
        variants=[(lab,price,s,('reuse' if not m else 'mint')) for s,lab,price,_,m in rows], delink=dl))

sql.append("\\echo '=== POST: clean 28 종단 요약 ==='")
cds=",".join(f"'{c}'" for c in CLEAN_ORDER)
sql.append(f"""SELECT
 (SELECT count(*) FROM t_prd_product_price_formulas WHERE prd_cd IN ({cds})) binds,
 (SELECT count(*) FROM t_prd_product_sizes WHERE prd_cd IN ({cds}) AND del_yn='N') psizes,
 (SELECT count(*) FROM t_prd_product_option_items WHERE prd_cd IN ({cds}) AND del_yn='N') opt_items,
 (SELECT count(*) FROM t_prd_product_materials pm JOIN t_mat_materials m ON m.mat_cd=pm.mat_cd WHERE pm.prd_cd IN ({cds}) AND pm.del_yn='N' AND m.mat_typ_cd='MAT_TYPE.09') variant_mat_left;""")
sql.append("ROLLBACK;")
open('apply.sql','w').write("\n".join(sql))
json.dump(man, open('manifest.json','w'), ensure_ascii=False, indent=1)
print("교정판 생성:", json.dumps(tot,ensure_ascii=False))
print(f"채번: SIZ_000564~SIZ_{siz_n-1:06d} · OPT_000173~OPT_{grp_n-1:06d} · OPV_000669~OPV_{opv_n-1:06d}")
