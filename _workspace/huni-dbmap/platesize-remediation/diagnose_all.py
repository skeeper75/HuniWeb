#!/usr/bin/env python3
# 판형 오매핑 일반화 진단 — 모든 판형축(plt_siz_cd) comp 대상. 라이브 스냅샷·토큰0.
# 미스매치 정의: 상품이 판형축 comp C를 공식으로 바인딩하는데, 상품 plate_size 어디에도
#   C가 단가를 가진 판형이 없음 → 그 comp는 어떤 옵션조합으로도 no-match(부분 견적0).
import csv, os, json
SNAP=os.path.abspath(os.path.join(os.path.dirname(__file__),"..","..","_foundation","live-snapshot","latest"))
def load(t): return list(csv.DictReader(open(f"{SNAP}/{t}.csv", encoding='utf-8')))
prds={p['prd_cd']:p for p in load('t_prd_products')}

# 판형축 comp = use_dims에 plt_siz_cd 포함
plt_axis_comps=set(c['comp_cd'] for c in load('t_prc_price_components')
                   if c.get('del_yn')=='N' and 'plt_siz_cd' in (c.get('use_dims') or ''))
# comp별 단가 보유 판형
comp_plts={}
for r in load('t_prc_component_prices'):
    if r['comp_cd'] in plt_axis_comps and r.get('plt_siz_cd'):
        comp_plts.setdefault(r['comp_cd'], set()).add(r['plt_siz_cd'])
# 공식→comp, 상품→공식
fc={}
for r in load('t_prc_formula_components'):
    fc.setdefault(r['frm_cd'], set()).add(r['comp_cd'])
prd_comps={}
for r in load('t_prd_product_price_formulas'):
    for c in fc.get(r['frm_cd'], ()):
        if c in plt_axis_comps:
            prd_comps.setdefault(r['prd_cd'], set()).add(c)
# 상품 판형
prd_plates={}
for r in load('t_prd_product_plate_sizes'):
    if r.get('del_yn')=='N':
        prd_plates.setdefault(r['prd_cd'], set()).add(r['siz_cd'])

defects=[]
for prd in sorted(prd_comps):
    plates=prd_plates.get(prd, set())
    for C in sorted(prd_comps[prd]):
        cp=comp_plts.get(C, set())
        if not cp: continue   # 그 comp 단가 자체 없음(판형 무관 결손)
        if not (plates & cp):
            defects.append({'prd_cd':prd,'prd_nm':prds.get(prd,{}).get('prd_nm',''),
              'comp_cd':C,'cur_plates':sorted(plates),'comp_priced_plates':sorted(cp)})
print(f"판형축 comp: {sorted(plt_axis_comps)}")
print(f"판형축 comp 바인딩 상품: {len(prd_comps)}")
print(f"★판형 미스매치(상품판형 ∩ comp단가판형 = 0): {len(defects)}건\n")
for d in defects:
    print(f"  {d['prd_cd']} {d['prd_nm']} · {d['comp_cd']}")
    print(f"     상품판형={d['cur_plates']} ∩ comp단가판형={d['comp_priced_plates'][:6]}{'...' if len(d['comp_priced_plates'])>6 else ''} = 0")
json.dump(defects, open(f"{os.path.dirname(__file__)}/platesize-defects-all.json","w"), ensure_ascii=False, indent=1)
