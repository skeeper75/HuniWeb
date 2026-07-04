#!/usr/bin/env python3
# 카테고리 상세 파일({category, products}) 정본 파싱 → categories/멤버십/대표 CSV
import json, glob, csv, os

CAT = "/Users/innojini/Dev/HuniWeb/docs/wowpress/catalog"
OUT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-multibrand-ontology/_cache"

prof = {}
with open(f"{OUT}/wow_products.csv") as fh:
    for row in csv.DictReader(fh):
        prof[int(row["productId"])] = row

cat_rows, mem_rows, rep_rows = [], [], []
for f in sorted(glob.glob(f"{CAT}/categories/*.json")):
    d = json.load(open(f))
    c = d["category"]; prods = d.get("products") or []
    path = "/".join(c.get("path") or [])
    pric = c.get("pricing") or {}
    cat_rows.append(dict(
        id=c.get("id"), path=path, displayName=c.get("displayName"),
        productCount=c.get("productCount"), templated=pric.get("templated"), quoted=pric.get("quoted"),
        keywords="|".join((c.get("keywords") or [])[:8]),
    ))
    # membership
    for p in prods:
        mem_rows.append(dict(cat_id=c.get("id"), cat_path=path, productId=p.get("productId"), name=p.get("name")))
    # representative = product with max n_sizes (richest config); tie → first
    def score(p):
        pr = prof.get(p.get("productId"), {})
        try: return int(pr.get("n_sizes") or 0)
        except: return 0
    rep = max(prods, key=score) if prods else None
    if rep:
        pid = rep.get("productId"); pr = prof.get(pid, {})
        rep_rows.append(dict(
            cat_path=path, productCount=c.get("productCount"),
            rep_productId=pid, rep_name=rep.get("name"),
            selType=pr.get("selType"), n_sizes=pr.get("n_sizes"), n_papers=pr.get("n_papers"),
            n_colors=pr.get("n_colors"), n_prsjob=pr.get("n_prsjob"), n_awkjob=pr.get("n_awkjob"),
            n_prodadd=pr.get("n_prodadd"), n_optioninfo=pr.get("n_optioninfo"),
            ordqty_min=pr.get("ordqty_min"), ordqty_max=pr.get("ordqty_max"),
            pjoin=pr.get("pjoin"), pricing_source=pr.get("pricing_source"),
        ))

for fn, rows in [("wow_categories.csv",cat_rows),("wow_category_membership.csv",mem_rows),("wow_representatives.csv",rep_rows)]:
    rows_sorted = rows
    if fn=="wow_representatives.csv":
        rows_sorted = sorted(rows, key=lambda r: -(int(r["productCount"]) if str(r["productCount"]).isdigit() else 0))
    with open(f"{OUT}/{fn}","w",newline="") as fh:
        w=csv.DictWriter(fh, fieldnames=list(rows_sorted[0].keys())); w.writeheader(); w.writerows(rows_sorted)

print("categories:", len(cat_rows), " membership rows:", len(mem_rows), " reps:", len(rep_rows))
print("multi-category products:", len(mem_rows)-len(set(m['productId'] for m in mem_rows)), "(membership - distinct)")
print("\n=== TOP 20 CATEGORIES by productCount (representative) ===")
for r in sorted(rep_rows, key=lambda x:-(int(x['productCount']) if str(x['productCount']).isdigit() else 0))[:20]:
    print(f"{r['cat_path']:<24} n={str(r['productCount']):<3} rep={r['rep_name']}({r['rep_productId']}) sz={r['n_sizes']} pa={r['n_papers']} co={r['n_colors']} awk={r['n_awkjob']} add={r['n_prodadd']} pjoin={r['pjoin']}")
