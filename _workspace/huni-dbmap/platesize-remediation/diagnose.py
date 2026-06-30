#!/usr/bin/env python3
# 판형(plate_size) 오매핑 결정론 진단 — 라이브 스냅샷 기반·토큰0.
# 원리[HARD]: 판형=종이류 출력소재만 유효. COMP_PAPER 매칭축=[plt_siz_cd,mat_cd].
# 오류 정의: 종이류 COMP_PAPER 바인딩 상품인데, 상품 plate_size 어디에도
#   그 상품 자재(종이)의 COMP_PAPER 단가가 있는 판형이 없음 → 엔진 no-match → 견적0.
import csv, os, json
SNAP=os.path.abspath(os.path.join(os.path.dirname(__file__),"..","..","_foundation","live-snapshot","latest"))
def load(t): return list(csv.DictReader(open(f"{SNAP}/{t}.csv", encoding='utf-8')))

mats={m['mat_cd']:m for m in load('t_mat_materials')}
prds={p['prd_cd']:p for p in load('t_prd_products')}

# COMP_PAPER 단가: 자재별 단가 보유 판형
paper_plts_by_mat={}
for r in load('t_prc_component_prices'):
    if r['comp_cd']=='COMP_PAPER' and r.get('plt_siz_cd'):
        paper_plts_by_mat.setdefault(r['mat_cd'], set()).add(r['plt_siz_cd'])

# COMP_PAPER 바인딩 공식 → 상품
paper_frms=set(r['frm_cd'] for r in load('t_prc_formula_components') if r['comp_cd']=='COMP_PAPER')
paper_prds={}
for r in load('t_prd_product_price_formulas'):
    if r['frm_cd'] in paper_frms:
        paper_prds.setdefault(r['prd_cd'], set()).add(r['frm_cd'])

# 상품 종이자재 (MAT_TYPE.01=디지털인쇄용지·.18=디지털PET)
prd_paper_mats={}
for r in load('t_prd_product_materials'):
    m=mats.get(r['mat_cd'])
    if m and m.get('mat_typ_cd') in ('MAT_TYPE.01','MAT_TYPE.18') and m.get('del_yn')=='N':
        prd_paper_mats.setdefault(r['prd_cd'], set()).add(r['mat_cd'])

# 상품 판형(활성)
prd_plates={}
for r in load('t_prd_product_plate_sizes'):
    if r.get('del_yn')=='N':
        prd_plates.setdefault(r['prd_cd'], {})[r['siz_cd']]=r.get('dflt_plt_yn')

defects=[]; ok=0; no_paper_mat=0; no_priced_mat=0
for prd in sorted(paper_prds):
    plates=set(prd_plates.get(prd, {}).keys())
    pmats=prd_paper_mats.get(prd, set())
    if not pmats: no_paper_mat+=1; continue
    priced_plts=set()
    for M in pmats: priced_plts |= paper_plts_by_mat.get(M, set())
    if not priced_plts: no_priced_mat+=1; continue   # 자재 단가 자체 미적재(판형문제 아님)
    if plates & priced_plts:
        ok+=1
    else:
        # 판형 오매핑: 상품 판형에 자재 단가 판형 없음
        defects.append({
          'prd_cd':prd,'prd_nm':prds.get(prd,{}).get('prd_nm',''),
          'prd_typ':prds.get(prd,{}).get('prd_typ_cd',''),
          'cur_plates':sorted(plates),'need_plates':sorted(priced_plts),
          'paper_mats':sorted(pmats)})

print(f"COMP_PAPER 바인딩 상품: {len(paper_prds)}")
print(f"  판형 정합 OK: {ok}")
print(f"  종이자재 없음(skip): {no_paper_mat}")
print(f"  자재단가 미적재(판형문제 아님·skip): {no_priced_mat}")
print(f"  ★판형 오매핑 결함: {len(defects)}")
print()
for d in defects:
    print(f"  {d['prd_cd']} {d['prd_nm']} (typ={d['prd_typ']})")
    print(f"     현재판형={d['cur_plates']} → 필요판형(자재단가보유)={d['need_plates']}")
json.dump(defects, open(f"{os.path.dirname(__file__)}/platesize-defects.json","w"), ensure_ascii=False, indent=1)
print(f"\n→ platesize-defects.json ({len(defects)}건)")
