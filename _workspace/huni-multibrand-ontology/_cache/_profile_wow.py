#!/usr/bin/env python3
# 와우프레스 catalog JSON 결정론 전수 파싱 → _cache CSV 전사 (LLM 손전사 금지)
import json, glob, csv, os, collections

CAT = "/Users/innojini/Dev/HuniWeb/docs/wowpress/catalog"
OUT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-multibrand-ontology/_cache"
os.makedirs(OUT, exist_ok=True)

def jlen(x):
    return len(x) if isinstance(x, list) else 0

prod_rows = []
size_rows = []
axis_constraint = collections.Counter()
seltype_dist = collections.Counter()
unit_dist = collections.Counter()
pjoin_dist = collections.Counter()
usecase_dist = collections.Counter()
awkjob_present = 0
prodadd_present = 0
optioninfo_present = 0

files = sorted(glob.glob(f"{CAT}/products/*.json"))
for f in files:
    d = json.load(open(f))
    r = d["raw"]["prod_info"]
    m = d["meta"]
    pid = d["productId"]
    catpath = "/".join(d.get("categoryPath") or [])
    seltype = m.get("selType"); seltype_dist[seltype]+=1
    unit = m.get("unit"); unit_dist[unit]+=1
    pjoin = r.get("pjoin"); pjoin_dist[pjoin]+=1
    for uc in (m.get("useCases") or []): usecase_dist[uc]+=1

    sizeinfo = r.get("sizeinfo") or []
    paperinfo = r.get("paperinfo") or []
    colorinfo = r.get("colorinfo") or []
    prsjobinfo = r.get("prsjobinfo") or []
    awkjobinfo = r.get("awkjobinfo")
    prodaddinfo = r.get("prodaddinfo")
    optioninfo = r.get("optioninfo")
    coverinfo = r.get("coverinfo") or []
    ordqty = r.get("ordqty") or []

    n_sizes = sum(jlen(c.get("sizelist")) for c in sizeinfo)
    n_papers = sum(jlen(c.get("paperlist")) for c in paperinfo)
    n_colors = 0
    for c in colorinfo:
        for pg in (c.get("pagelist") or []):
            n_colors += jlen(pg.get("colorlist"))
    n_prsjob = 0
    for pj in prsjobinfo:
        n_prsjob += jlen(pj.get("prsjoblist"))
    n_awkjob = 0
    if isinstance(awkjobinfo, list):
        awkjob_present += 1
        for a in awkjobinfo:
            if isinstance(a, dict):
                for k in a:
                    if isinstance(a.get(k), list):
                        n_awkjob += len(a[k])
    n_prodadd = jlen(prodaddinfo) if isinstance(prodaddinfo, list) else 0
    if n_prodadd: prodadd_present += 1
    if isinstance(optioninfo, list) and optioninfo:
        optioninfo_present += 1
        n_option = jlen(optioninfo)
    else:
        n_option = 0
    n_cover = jlen(coverinfo)

    oq = ordqty[0] if ordqty else {}
    oq_type = oq.get("type"); oq_min = oq.get("ordqtymin"); oq_max=oq.get("ordqtymax"); oq_int=oq.get("ordqtyinterval")

    def has_constraint(items, keys):
        for it in items:
            for k in keys:
                if it.get(k) not in (None, [], ""):
                    return True
        return False
    size_flat = [s for c in sizeinfo for s in (c.get("sizelist") or [])]
    paper_flat = [p for c in paperinfo for p in (c.get("paperlist") or [])]
    color_flat = [cl for c in colorinfo for pg in (c.get("pagelist") or []) for cl in (pg.get("colorlist") or [])]
    if has_constraint(size_flat, ["req_width","req_height","req_paper","req_color","req_awkjob","rst_ordqty","rst_awkjob"]):
        axis_constraint["size"]+=1
    if has_constraint(paper_flat, ["req_width","req_height","req_awkjob","rst_ordqty","rst_prsjob","rst_awkjob"]):
        axis_constraint["paper"]+=1
    if has_constraint(color_flat, ["req_prsjob","req_awkjob","rst_prsjob","rst_awkjob","rst_opt"]):
        axis_constraint["color"]+=1

    pricing = d.get("pricing", {})
    tmpl = pricing.get("template")
    prod_rows.append(dict(
        productId=pid, name=m.get("name"), category=catpath,
        selType=seltype, unit=unit, pjoin=pjoin,
        useCases="|".join(m.get("useCases") or []),
        n_covertypes=n_cover, n_sizes=n_sizes, n_papers=n_papers,
        n_colors=n_colors, n_prsjob=n_prsjob, n_awkjob=n_awkjob,
        n_prodadd=n_prodadd, n_optioninfo=n_option,
        ordqty_type=oq_type, ordqty_min=oq_min, ordqty_max=oq_max, ordqty_interval=oq_int,
        prepayRequired=r.get("dlvyprepay"), dlvygrpno=r.get("dlvygrpno"),
        pricing_status=pricing.get("status"), pricing_source=pricing.get("source"),
        has_template=tmpl is not None,
        pricing_jobpresetno=(tmpl or {}).get("payload",{}).get("jobpresetno") if tmpl else None,
        pricing_error=(pricing.get("error") or "")[:80],
    ))

    for c in sizeinfo:
        for s in (c.get("sizelist") or []):
            size_rows.append(dict(
                productId=pid, name=m.get("name"), covercd=c.get("covercd"),
                sizeno=s.get("sizeno"), sizename=s.get("sizename"),
                width=s.get("width"), height=s.get("height"),
                cutsize=s.get("cutsize"), non_standard=s.get("non_standard"),
                has_req=any(s.get(k) not in (None,[],"") for k in ["req_width","req_height","req_paper","req_color","req_awkjob"]),
                has_rst=any(s.get(k) not in (None,[],"") for k in ["rst_ordqty","rst_awkjob"]),
            ))

with open(f"{OUT}/wow_products.csv","w",newline="") as fh:
    w=csv.DictWriter(fh, fieldnames=list(prod_rows[0].keys())); w.writeheader(); w.writerows(prod_rows)
with open(f"{OUT}/wow_size_options.csv","w",newline="") as fh:
    w=csv.DictWriter(fh, fieldnames=list(size_rows[0].keys())); w.writeheader(); w.writerows(size_rows)

cat_rows=[]
for f in sorted(glob.glob(f"{CAT}/categories/*.json")):
    c=json.load(open(f))
    cat_rows.append(dict(
        id=c.get("id"), path="/".join(c.get("path") or []),
        displayName=c.get("displayName"), productCount=c.get("productCount"),
        templated=(c.get("pricing") or {}).get("templated"),
        quoted=(c.get("pricing") or {}).get("quoted"),
        keywords="|".join((c.get("keywords") or [])[:8]),
        sampleProductIds="|".join(str(sp.get("productId")) for sp in (c.get("sampleProducts") or [])[:3]),
    ))
with open(f"{OUT}/wow_categories.csv","w",newline="") as fh:
    w=csv.DictWriter(fh, fieldnames=list(cat_rows[0].keys())); w.writeheader(); w.writerows(cat_rows)

print("=== SUMMARY (script-transcribed) ===")
print("products:", len(prod_rows), " categories:", len(cat_rows), " size rows:", len(size_rows))
print("selType dist:", dict(seltype_dist))
print("unit dist (top):", dict(collections.Counter(unit_dist).most_common(10)))
print("pjoin dist:", dict(pjoin_dist))
print("useCase dist (top):", dict(usecase_dist.most_common(12)))
print("awkjob present:", awkjob_present, " prodadd present:", prodadd_present, " optioninfo present:", optioninfo_present)
print("cross-axis constraint holders:", dict(axis_constraint))
cov=collections.Counter()
for p in prod_rows:
    for ax in ["n_sizes","n_papers","n_colors","n_prsjob","n_awkjob","n_prodadd","n_optioninfo"]:
        if p[ax] and p[ax]>0: cov[ax]+=1
print("axis coverage (products with >0):", dict(cov))
print("ordqty_type dist:", dict(collections.Counter(p["ordqty_type"] for p in prod_rows)))
print("pricing_status dist:", dict(collections.Counter(p["pricing_status"] for p in prod_rows)))
print("has_template count:", sum(1 for p in prod_rows if p["has_template"]))
print("selType=M count:", seltype_dist.get("M"), " (M=multi-config?)")
