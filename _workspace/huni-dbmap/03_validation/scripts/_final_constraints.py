#!/usr/bin/env python3
# 전수 4805행 C-1~9 제약 + 15시트 종합 대시보드 집계
import csv, collections

LOAD="02_mapping/load_price/t_prc_component_prices.csv"
rows=list(csv.DictReader(open(LOAD,encoding="utf-8")))
print(f"총 행수 = {len(rows)}")

# C-1: comp_price_id 유니크
ids=[r["comp_price_id"] for r in rows]
print(f"C-1 comp_price_id 중복 = {len(ids)-len(set(ids))}")

# C-2: 자연키8 (comp,apply,siz,clr,mat,coat,bdl,min) 유니크
nat=collections.Counter((r["comp_cd"],r["apply_ymd"],r["siz_cd"],r["clr_cd"],r["mat_cd"],r["coat_side_cnt"],r["bdl_qty"],r["min_qty"]) for r in rows)
dup=[k for k,c in nat.items() if c>1]
print(f"C-2 자연키8 중복 = {len(dup)}")
for k in dup[:10]: print("  dup:",k)

# C-3: apply_ymd 통일
ymd=collections.Counter(r["apply_ymd"] for r in rows)
print(f"C-3 apply_ymd 분포 = {dict(ymd)}")

# C-4: unit_price 숫자
nonnum=0
for r in rows:
    try: float(r["unit_price"])
    except: nonnum+=1
print(f"C-4 unit_price 비숫자/공란 = {nonnum}")

# C-5: comp_cd/apply_ymd NOT NULL
nn=sum(1 for r in rows if not r["comp_cd"].strip() or not r["apply_ymd"].strip())
print(f"C-5 comp_cd/apply_ymd NULL = {nn}")

# C-6: clr_cd 별색=NULL 점검 (SPOT/FOIL/POSTER 통가격은 clr NULL이어야)
spot_with_clr=sum(1 for r in rows if ('SPOT' in r["comp_cd"] or 'POSTER' in r["comp_cd"]) and r["clr_cd"].strip())
print(f"C-6 별색/포스터 comp에 clr_cd 채워짐(규칙① 위반) = {spot_with_clr}")

# C-7: varchar 길이 (siz_cd 등 추정 — placeholder가 길어질 수 있음)
maxlen=collections.defaultdict(int)
for r in rows:
    for col in ["comp_cd","siz_cd","clr_cd","mat_cd","note"]:
        maxlen[col]=max(maxlen[col],len(r[col]))
print(f"C-7 최장길이: comp_cd={maxlen['comp_cd']} siz_cd={maxlen['siz_cd']} clr_cd={maxlen['clr_cd']} mat_cd={maxlen['mat_cd']} note={maxlen['note']}")

# siz_cd 전수 분포
real=sum(1 for r in rows if r["siz_cd"].startswith("SIZ_0"))
pend=sum(1 for r in rows if r["siz_cd"].startswith("SIZ_PENDING"))
nullsiz=sum(1 for r in rows if r["siz_cd"].strip()=="")
print(f"\n[siz_cd 전수] 실코드 {real} / placeholder {pend} / NULL {nullsiz}")

# placeholder 군별
pend_group=collections.Counter()
for r in rows:
    s=r["siz_cd"]
    if s.startswith("SIZ_PENDING"):
        # SIZ_PENDING_<GROUP>...
        parts=s.split("_")
        grp=parts[2] if len(parts)>2 else "?"
        pend_group[grp]+=1
print(f"\n[placeholder 군별 행수]")
for g,c in pend_group.most_common():
    print(f"  SIZ_PENDING_{g}*: {c}")

# 시트(comp prefix 도메인)별 행수 + placeholder
def domain(cc):
    if cc.startswith("COMP_POSTEROPT"): return "POSTER(opt)"
    if cc.startswith("COMP_POSTER"): return "POSTER(main)"
    if cc.startswith("COMP_ACRYL"): return "ACRYL"
    if cc.startswith("COMP_PRINT_DIGITAL"): return "DIGITAL"
    if cc.startswith("COMP_PRINT_SPOT"): return "SPOT(별색)"
    if cc.startswith("COMP_COAT"): return "COATING"
    if cc.startswith("COMP_PP_") or cc.startswith("COMP_CORNER"): return "POSTPROC"
    if cc.startswith("COMP_ENV"): return "ENVELOPE"
    if cc.startswith("COMP_FOLD"): return "FOLDING"
    if cc.startswith("COMP_BIND"): return "BINDING"
    if cc.startswith("COMP_CUT"): return "CUTTING"
    if cc.startswith("COMP_STK"): return "STICKER"
    if cc.startswith("COMP_GANGPAN"): return "GANGPAN"
    if cc.startswith("COMP_NAMECARD"): return "NAMECARD"
    if cc.startswith("COMP_PHOTOCARD"): return "PHOTOCARD"
    if cc.startswith("COMP_PCB"): return "PCB(엽서북)"
    if cc.startswith("COMP_TTEOKME"): return "TTEOKME(떡메)"
    return "OTHER:"+cc[:15]

dom=collections.defaultdict(lambda:{"n":0,"real":0,"pend":0,"null":0})
for r in rows:
    d=domain(r["comp_cd"])
    dom[d]["n"]+=1
    if r["siz_cd"].startswith("SIZ_0"): dom[d]["real"]+=1
    elif r["siz_cd"].startswith("SIZ_PENDING"): dom[d]["pend"]+=1
    elif r["siz_cd"].strip()=="": dom[d]["null"]+=1

print(f"\n[도메인별 행수 / 실코드 / placeholder / NULL]")
tot_n=tot_r=tot_p=tot_nl=0
for d in sorted(dom, key=lambda x:-dom[x]["n"]):
    v=dom[d]
    print(f"  {d:15s}: 총 {v['n']:4d} | 실코드 {v['real']:4d} | pend {v['pend']:4d} | null {v['null']:3d}")
    tot_n+=v['n']; tot_r+=v['real']; tot_p+=v['pend']; tot_nl+=v['null']
print(f"  {'합계':15s}: 총 {tot_n:4d} | 실코드 {tot_r:4d} | pend {tot_p:4d} | null {tot_nl:3d}")

# 즉시 적재가능 = 실코드 + NULL siz (FK 충족). 차단 = placeholder
print(f"\n[적재 가능 vs 차단]")
print(f"  즉시 적재가능(실코드siz + NULLsiz, FK충족) = {tot_r+tot_nl}")
print(f"  차단(placeholder siz_cd FK부재) = {tot_p}")
print(f"  + comp_typ .06 코드행 미등록 = 별도 단계0 blocker")
