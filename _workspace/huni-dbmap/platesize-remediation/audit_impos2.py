#!/usr/bin/env python3
# C(비판형 338행) 분해: 면적가(siz_width/height 매칭=1:1출력 정당) vs 완제품가/고정가(전지출력이어야=오적재의심).
import csv, os, json
from collections import Counter, defaultdict
SNAP=os.path.abspath(os.path.join(os.path.dirname(__file__),"..","..","_foundation","live-snapshot","latest"))
def load(t): return list(csv.DictReader(open(f"{SNAP}/{t}.csv", encoding='utf-8')))
sizes={s['siz_cd']:s for s in load('t_siz_sizes')}
prds={p['prd_cd']:p for p in load('t_prd_products')}
pcs={c['comp_cd']:c for c in load('t_prc_price_components')}
# 면적 comp(siz_width/siz_height 매칭) 바인딩 상품
area_comps=set(cd for cd,c in pcs.items() if 'siz_width' in (c.get('use_dims') or ''))
fc={}
for r in load('t_prc_formula_components'): fc.setdefault(r['frm_cd'],set()).add(r['comp_cd'])
prd_area=set(); prd_anyformula=set()
for r in load('t_prd_product_price_formulas'):
    prd_anyformula.add(r['prd_cd'])
    if fc.get(r['frm_cd'],set()) & area_comps: prd_area.add(r['prd_cd'])

audit=json.load(open(f"{os.path.dirname(__file__)}/platesize-impos-audit.json"))
byprd=defaultdict(list)
for r in audit['nonimpact']: byprd[r['prd_cd']].append(r)

area_ok=[]; fixed_price_susp=[]; noformula=[]
for prd, recs in byprd.items():
    nm=prds.get(prd,{}).get('prd_nm','')
    if prd in prd_area:
        area_ok.append((prd,nm,len(recs)))      # 면적가=완제품판형 정당
    elif prd not in prd_anyformula:
        noformula.append((prd,nm,len(recs)))     # 공식 미바인딩(판형 판정 보류)
    else:
        fixed_price_susp.append((prd,nm,len(recs)))  # 완제품가/고정가인데 비판형=오적재 의심

print(f"C(비판형 338행) 분해 — 상품 {len(byprd)}개:")
print(f"  C1. 면적가 상품(완제품=출력 정당): {len(area_ok)}상품 {sum(x[2] for x in area_ok)}행")
print(f"  C2. 완제품가/고정가 상품 + 비판형(★전지출력이어야=오적재 의심): {len(fixed_price_susp)}상품 {sum(x[2] for x in fixed_price_susp)}행")
print(f"  C3. 공식 미바인딩(판형 판정 보류): {len(noformula)}상품 {sum(x[2] for x in noformula)}행")
print(f"\n--- C2 오적재 의심 상품 (전지출력이어야 하는데 완제품 판형) ---")
for prd,nm,n in sorted(fixed_price_susp): print(f"  {prd} {nm} ({n}행)")
print(f"\n--- C1 면적가(정당·교정 불요) 샘플 ---")
for prd,nm,n in sorted(area_ok)[:10]: print(f"  {prd} {nm} ({n}행)")
