#!/usr/bin/env python3
# 굿즈파우치 엑셀 L1에서 상품별 variant→가격 결정론 추출·분류. LLM 숫자 전사 0.
import csv, sys, json
from collections import defaultdict, OrderedDict

SRC = "24_master-extract-260610/goods-pouch-l1.csv"

def num(s):
    s = (s or "").strip().replace(",", "")
    if s == "": return None
    try:
        f = float(s); return int(f) if f == int(f) else f
    except: return s

prods = OrderedDict()  # prd_nm -> list of {opt, price, proc, proc_price, work_size}
with open(SRC, encoding="utf-8-sig") as f:
    r = csv.DictReader(f)
    for row in r:
        nm = (row.get("상품명") or "").strip()
        if not nm: continue
        opt = (row.get("상품(옵션)") or "").strip()
        price = num(row.get("가격"))
        proc = (row.get("가공(옵션)_가공") or "").strip()
        pprice = num(row.get("가공(옵션)_가격"))
        ws = (row.get("파일사양_작업사이즈") or "").strip()
        prods.setdefault(nm, []).append(dict(opt=opt, price=price, proc=proc, pprice=pprice, ws=ws))

# 분류
rows = []
for nm, items in prods.items():
    # variant = 가격이 있는 옵션행들
    priced = [(it["opt"], it["price"], it["ws"]) for it in items if it["price"] is not None]
    distinct_prices = sorted(set(p for _,p,_ in priced if isinstance(p,(int,float))))
    opts_with_price = [(o,p) for o,p,_ in priced if o]  # 옵션 라벨 있고 가격 있는
    # 가공 addon 축
    procs = sorted(set((it["proc"], it["pprice"]) for it in items if it["proc"] and it["proc"] not in ("라벨없음",)))
    n_priced_optrows = len([1 for o,p,_ in priced if o])
    kind = ""
    if len(distinct_prices) >= 2 and n_priced_optrows >= 2:
        kind = "VARIANT(multi-price)"
    elif len(distinct_prices) == 1 and n_priced_optrows >= 2:
        kind = "OPTION-same-price"
    elif len(distinct_prices) >= 1:
        kind = "SINGLE"
    else:
        kind = "NO-PRICE"
    rows.append((nm, kind, len(items), n_priced_optrows, distinct_prices, opts_with_price, procs))

print(f"{'상품명':<22} {'분류':<20} rows optr  가격들 / 옵션·가공")
print("-"*130)
for nm,kind,nrows,noptr,dp,owp,procs in rows:
    dpS = ",".join(str(x) for x in dp)
    owpS = " ".join(f"{o}={p}" for o,p in owp)
    procS = (" [가공:"+", ".join(f"{a}={b}" for a,b in procs)+"]") if procs else ""
    print(f"{nm:<22} {kind:<20} {nrows:>4} {noptr:>4}  [{dpS}]  {owpS}{procS}")

# variant만 별도 저장
variants = [(nm,dp,owp,procs) for nm,kind,_,_,dp,owp,procs in rows if kind=="VARIANT(multi-price)"]
print(f"\n=== VARIANT(multi-price) 상품 수: {len(variants)} ===")
with open("09_load/goods-pouch-gb2-propagate-260704/variants.json","w",encoding="utf-8") as o:
    json.dump([dict(prd_nm=nm, prices=dp, options=owp, procs=procs) for nm,dp,owp,procs in variants], o, ensure_ascii=False, indent=1)
