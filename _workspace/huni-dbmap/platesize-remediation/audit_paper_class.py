#!/usr/bin/env python3
# 판형 적재 정합 — 종이류 여부 기준(올바른 진단). 판형=종이류 출력소재만[HARD].
# 종이류 자재 보유 → 판형 대상. 비종이류만 → 판형 불필요(있으면 오적재).
import csv, os, json
from collections import Counter
SNAP=os.path.abspath(os.path.join(os.path.dirname(__file__),"..","..","_foundation","live-snapshot","latest"))
def load(t): return list(csv.DictReader(open(f"{SNAP}/{t}.csv", encoding='utf-8')))
PAPER={'MAT_TYPE.01','MAT_TYPE.11','MAT_TYPE.13','MAT_TYPE.14','MAT_TYPE.18','MAT_TYPE.21'}
mats={m['mat_cd']:m for m in load('t_mat_materials')}
prds={p['prd_cd']:p for p in load('t_prd_products') if p.get('del_yn')=='N'}
sizes={s['siz_cd']:s for s in load('t_siz_sizes')}
# 상품별 종이류 자재 보유
prd_paper=set(); prd_hasmat=set()
for r in load('t_prd_product_materials'):
    m=mats.get(r['mat_cd'])
    if not m or m.get('del_yn')!='N': continue
    prd_hasmat.add(r['prd_cd'])
    if m.get('mat_typ_cd') in PAPER: prd_paper.add(r['prd_cd'])
# 상품별 plate_size(활성)
prd_plate={}
for r in load('t_prd_product_plate_sizes'):
    if r.get('del_yn')=='N': prd_plate.setdefault(r['prd_cd'],[]).append(r['siz_cd'])

A=[];B=[];C=[];Dn=[]
for prd,p in prds.items():
    is_paper = prd in prd_paper
    plates = prd_plate.get(prd,[])
    if is_paper and plates: A.append(prd)
    elif is_paper and not plates: B.append(prd)
    elif (not is_paper) and plates: C.append(prd)   # ★비종이류 + 판형 = 오적재
    else: Dn.append(prd)

print(f"A. 종이류+판형(정상): {len(A)}")
print(f"B. 종이류+판형없음(검토): {len(B)}")
print(f"★C. 비종이류+판형 적재(오적재·판형 삭제 대상): {len(C)}상품")
print(f"D. 비종이류+판형없음(정상): {len(Dn)}\n")
print("=== ★C 오적재 목록 (비종이류인데 판형 들어감) ===")
rows=[]
for prd in sorted(C):
    nm=prds[prd]['prd_nm']
    # 주 자재유형
    mtyps=Counter()
    for r in load('t_prd_product_materials'):
        if r['prd_cd']==prd:
            m=mats.get(r['mat_cd'])
            if m and m.get('del_yn')=='N': mtyps[m['mat_typ_cd']]+=1
    pl=prd_plate[prd]
    plnames=[sizes.get(s,{}).get('siz_nm','') for s in pl]
    rows.append({'prd_cd':prd,'prd_nm':nm,'mat_typs':dict(mtyps),'plates':pl,'plate_nms':plnames})
    print(f"  {prd} {nm} · 자재유형={dict(mtyps)} · 판형={pl}{plnames}")
json.dump(rows, open(f"{os.path.dirname(__file__)}/nonpaper-plate-defects.json","w"), ensure_ascii=False, indent=1)
print(f"\n→ nonpaper-plate-defects.json ({len(C)}건)")
