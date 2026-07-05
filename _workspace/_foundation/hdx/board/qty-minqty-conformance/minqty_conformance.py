# -*- coding: utf-8 -*-
"""상품 min_qty(최소주문수량) ↔ 가격표 시작수량(comp band_min) 정합 전수 진단.
사용자 원칙: 인쇄상품 가격표의 처음 시작 수량 = 최소주문수량이어야 한다."""
import csv
from collections import defaultdict
LS = "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest"
def load(t):
    with open(f"{LS}/{t}.csv", encoding="utf-8") as f: return list(csv.DictReader(f))
def i(v):
    try: return int(float(v)) if v not in (None,"") else None
    except: return None

ACTIVE_C = lambda r:(r.get("use_yn") or "Y")=="Y"
ACTIVE_P = lambda r:(r.get("del_yn") or "N")=="N" and (r.get("use_yn") or "Y")=="Y"
active_comp = {r["comp_cd"] for r in load("t_prc_price_components") if r.get("comp_cd") and ACTIVE_C(r)}
band_min = {}
for r in load("t_prc_component_prices"):
    c,mq = r.get("comp_cd"), i(r.get("min_qty"))
    if c and mq is not None:
        band_min[c] = mq if c not in band_min else min(band_min[c],mq)
frm_comps = defaultdict(set)
for r in load("t_prc_formula_components"):
    f,c = r.get("frm_cd"), r.get("comp_cd")
    if f and c and c in active_comp and c in band_min: frm_comps[f].add(c)
prod_frms = defaultdict(set)
for r in load("t_prd_product_price_formulas"):
    if r.get("prd_cd") and r.get("frm_cd"): prod_frms[r["prd_cd"]].add(r["frm_cd"])
prods = {r["prd_cd"]:r for r in load("t_prd_products") if r.get("prd_cd") and ACTIVE_P(r)}

cats = defaultdict(list)
for prd,prow in sorted(prods.items()):
    comps=set()
    for f in prod_frms.get(prd,()): comps|=frm_comps.get(f,set())
    if not comps: continue  # 수량구간 comp 없음
    pmin_raw = prow.get("min_qty")
    eff = i(pmin_raw)
    strictest = max(band_min[c] for c in comps)  # 가장 늦게 시작(가장 큰 시작수량)
    loosest   = min(band_min[c] for c in comps)  # 가장 이른 시작
    nm = prow.get("prd_nm","")
    if pmin_raw in (None,""):
        cats["NO_RULES(min 미등록)"].append((prd,nm,"미등록",loosest,strictest))
    elif eff < strictest:
        cats["TRAP_MIN(상품min < 시작수량·저청구)"].append((prd,nm,eff,loosest,strictest))
    elif eff > loosest:
        cats["OVER_MIN(상품min > 시작수량·과다제약)"].append((prd,nm,eff,loosest,strictest))
    else:
        cats["OK(일치)"].append((prd,nm,eff,loosest,strictest))

for cat in ["TRAP_MIN(상품min < 시작수량·저청구)","NO_RULES(min 미등록)",
            "OVER_MIN(상품min > 시작수량·과다제약)","OK(일치)"]:
    rows=cats.get(cat,[])
    print(f"\n=== {cat}: {len(rows)}건 ===")
    for prd,nm,eff,lo,hi in rows[:20]:
        bandinfo = f"시작수량 {lo}" + (f"~{hi}(comp별상이)" if lo!=hi else "")
        print(f"  {nm[:22]:<22} 상품min={eff}  {bandinfo}")
    if len(rows)>20: print(f"  ...외 {len(rows)-20}건")
