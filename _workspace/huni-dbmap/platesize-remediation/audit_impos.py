#!/usr/bin/env python3
# 판형 컬럼 오적재 전수 진단 — impos_yn 기준. 판형(plate_size)=출력 전지규격(impos_yn=Y)만 유효.
# 완제품/재단 사이즈(impos_yn=N)가 판형 자리에 들어가면 오적재. 가격모델로 영향도 분류.
import csv, os, json
from collections import Counter
SNAP=os.path.abspath(os.path.join(os.path.dirname(__file__),"..","..","_foundation","live-snapshot","latest"))
def load(t): return list(csv.DictReader(open(f"{SNAP}/{t}.csv", encoding='utf-8')))
sizes={s['siz_cd']:s for s in load('t_siz_sizes')}
prds={p['prd_cd']:p for p in load('t_prd_products')}
# 판형축 comp(plt_siz_cd 매칭) + 단가보유 판형
plt_axis=set(c['comp_cd'] for c in load('t_prc_price_components') if c.get('del_yn')=='N' and 'plt_siz_cd' in (c.get('use_dims') or ''))
priced_plts=set(r['plt_siz_cd'] for r in load('t_prc_component_prices') if r['comp_cd'] in plt_axis and r.get('plt_siz_cd'))
fc={}
for r in load('t_prc_formula_components'): fc.setdefault(r['frm_cd'],set()).add(r['comp_cd'])
prd_pltcomp=set()
for r in load('t_prd_product_price_formulas'):
    if fc.get(r['frm_cd'],set()) & plt_axis: prd_pltcomp.add(r['prd_cd'])

cls=Counter(); impact=[]; nonimpact=[]
for r in load('t_prd_product_plate_sizes'):
    if r.get('del_yn')!='N': continue
    s=sizes.get(r['siz_cd'],{}); imp=(s.get('impos_yn') or '').strip()
    prd=r['prd_cd']; nm=prds.get(prd,{}).get('prd_nm','')
    rec={'prd_cd':prd,'prd_nm':nm,'siz_cd':r['siz_cd'],'siz_nm':s.get('siz_nm',''),
         'impos':imp,'uses_plt_comp':prd in prd_pltcomp,'priced_plt':r['siz_cd'] in priced_plts}
    if imp=='Y':
        cls['A.판형(impos=Y) 정상']+=1
    else:  # impos=N → 비판형(완제품/재단)
        if prd in prd_pltcomp:
            cls['B.★결함: 종이인쇄(판형축comp) 상품인데 비판형 적재(견적영향)']+=1; impact.append(rec)
        else:
            cls['C.완제품가/면적가 상품 + 비판형(가격영향 없음·정합보정 후보)']+=1; nonimpact.append(rec)

print("=== plate_size 적재 분류 (impos_yn 기준) ===")
for k,v in sorted(cls.items()): print(f"  {k}: {v}행")
print(f"\n=== B. 견적영향 결함 ({len(impact)}행·상품 {len(set(r['prd_cd'] for r in impact))}) ===")
for r in impact: print(f"  {r['prd_cd']} {r['prd_nm']} · 판형={r['siz_cd']}({r['siz_nm']}) impos={r['impos']} 단가판형여부={r['priced_plt']}")
print(f"\n=== C. 가격영향 없음 비판형 — 상품군별 집계 ({len(nonimpact)}행) ===")
grp=Counter()
for r in nonimpact:
    g=prds.get(r['prd_cd'],{}).get('prd_typ_cd','?')
    grp[g]+=1
for k,v in sorted(grp.items()): print(f"  prd_typ={k}: {v}행")
json.dump({'impact':impact,'nonimpact':nonimpact}, open(f"{os.path.dirname(__file__)}/platesize-impos-audit.json","w"), ensure_ascii=False, indent=1)
print(f"\n→ platesize-impos-audit.json")
