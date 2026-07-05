# -*- coding: utf-8 -*-
"""완제품가형 상품: 완제품가 comp 시작수량(band_min) = 상품 min_qty 정합 진단.
사용자 원칙: 가격표 시작수량 = 최소주문수량. 완제품가(.06)는 주문 장수 기준이라 직접 적용."""
import csv
from collections import defaultdict
LS = "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest"
def load(t):
    with open(f"{LS}/{t}.csv", encoding="utf-8") as f: return list(csv.DictReader(f))
def i(v):
    try: return int(float(v)) if v not in (None,"") else None
    except: return None

comp_rows = load("t_prc_price_components")
comp_nm = {r["comp_cd"]: r.get("comp_nm","") for r in comp_rows}
finished = {r["comp_cd"] for r in comp_rows
            if r.get("comp_typ_cd")=="PRC_COMPONENT_TYPE.06" and (r.get("use_yn") or "Y")=="Y"}
band_min = {}
for r in load("t_prc_component_prices"):
    c,mq = r.get("comp_cd"), i(r.get("min_qty"))
    if c and mq is not None:
        band_min[c] = mq if c not in band_min else min(band_min[c], mq)
# 완제품가 comp → 공식 → 상품
frm_finished = defaultdict(set)
for r in load("t_prc_formula_components"):
    f,c = r.get("frm_cd"), r.get("comp_cd")
    if f and c in finished: frm_finished[f].add(c)
prod_frm = defaultdict(set)
for r in load("t_prd_product_price_formulas"):
    if r.get("prd_cd") and r.get("frm_cd"): prod_frm[r["prd_cd"]].add(r["frm_cd"])
prods = {r["prd_cd"]:r for r in load("t_prd_products")
         if r.get("prd_cd") and (r.get("del_yn") or "N")=="N" and (r.get("use_yn") or "Y")=="Y"}

cats = defaultdict(list)
for prd,prow in sorted(prods.items()):
    fcomps = set()
    for f in prod_frm.get(prd,()): fcomps |= frm_finished.get(f,set())
    fcomps = {c for c in fcomps if c in band_min}
    if not fcomps: continue  # 완제품가형 아님
    starts = {band_min[c] for c in fcomps}
    pmin = i(prow.get("min_qty"))
    nm = prow.get("prd_nm","")
    start = min(starts)  # 완제품가 시작수량(여러개면 최소)
    if prow.get("min_qty") in (None,""):
        cats["min 미등록"].append((nm,"미등록",sorted(starts)))
    elif pmin == start and len(starts)==1:
        cats["OK 일치"].append((nm,pmin,sorted(starts)))
    elif pmin < start:
        cats["상품min < 완제품가시작 (완제품가 무료 위험·저청구)"].append((nm,pmin,sorted(starts)))
    elif pmin > start:
        cats["상품min > 완제품가시작 (원칙 위반·시작수량 재확인)"].append((nm,pmin,sorted(starts)))
    else:
        cats["comp별 시작 상이"].append((nm,pmin,sorted(starts)))

for cat in ["상품min < 완제품가시작 (완제품가 무료 위험·저청구)",
            "상품min > 완제품가시작 (원칙 위반·시작수량 재확인)",
            "comp별 시작 상이","min 미등록","OK 일치"]:
    rows = cats.get(cat,[])
    print(f"\n=== {cat}: {len(rows)}건 ===")
    for nm,pmin,starts in rows[:25]:
        print(f"  {nm[:24]:<24} 상품min={pmin}  완제품가시작={starts}")
    if len(rows)>25: print(f"  ...외 {len(rows)-25}건")
