#!/usr/bin/env python3
# 축별 도메인 인벤토리 + 후가공/부자재 플랫튼 + 카테고리 대표 원자추출 (결정론 전사)
import json, glob, csv, os, collections

CAT = "/Users/innojini/Dev/HuniWeb/docs/wowpress/catalog"
OUT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-multibrand-ontology/_cache"

paper_groups = collections.Counter()
color_names = collections.Counter()
awkjob_names = collections.Counter()
prsjob_names = collections.Counter()
prodadd_names = collections.Counter()

awk_rows = []      # 후가공 flatten
prodadd_rows = []  # 부자재/추가상품 flatten
awkgroup_names = collections.Counter()  # 후가공 그룹(제본/코팅/박...)

def walk_awkjob(awk):
    """awkjobinfo: [{covercd, jobgrouplist:[{jobgroup, awkjoblist:[{jobno,jobname}]}]}] → (covercd, jobgroup, jobno, jobname)"""
    out = []
    if not isinstance(awk, list): return out
    for cov in awk:
        if not isinstance(cov, dict): continue
        covercd = cov.get("covercd")
        for grp in (cov.get("jobgrouplist") or []):
            gname = grp.get("jobgroup")
            for it in (grp.get("awkjoblist") or []):
                out.append((covercd, gname, it.get("jobno"), it.get("jobname")))
    return out

for f in sorted(glob.glob(f"{CAT}/products/*.json")):
    d = json.load(open(f))
    r = d["raw"]["prod_info"]
    pid = d["productId"]; nm = d["meta"]["name"]
    for c in (r.get("paperinfo") or []):
        for p in (c.get("paperlist") or []):
            if p.get("papergroup"): paper_groups[p["papergroup"]] += 1
    for c in (r.get("colorinfo") or []):
        for pg in (c.get("pagelist") or []):
            for cl in (pg.get("colorlist") or []):
                if cl.get("colorname"): color_names[cl["colorname"]] += 1
    for pj in (r.get("prsjobinfo") or []):
        for j in (pj.get("prsjoblist") or []):
            if j.get("jobname"): prsjob_names[j["jobname"]] += 1
    for (covercd, gname, no, name) in walk_awkjob(r.get("awkjobinfo")):
        if name: awkjob_names[name] += 1
        if gname: awkgroup_names[gname] += 1
        awk_rows.append(dict(productId=pid, name=nm, covercd=covercd, awkgroup=gname, awkjobno=no, awkjobname=name))
    pa = r.get("prodaddinfo")
    if isinstance(pa, list):
        for it in pa:
            if isinstance(it, dict):
                anm = it.get("prodname"); ano = it.get("prodno")
                if anm: prodadd_names[anm] += 1
                prodadd_rows.append(dict(productId=pid, name=nm, add_prodno=ano, add_prodname=anm))

def dump_domain(fn, counter, colname):
    with open(f"{OUT}/{fn}","w",newline="") as fh:
        w=csv.writer(fh); w.writerow([colname,"product_count"])
        for k,v in counter.most_common():
            w.writerow([k,v])

dump_domain("wow_domain_papergroups.csv", paper_groups, "papergroup")
dump_domain("wow_domain_colors.csv", color_names, "colorname")
dump_domain("wow_domain_prsjob.csv", prsjob_names, "prsjob_name")
dump_domain("wow_domain_awkjob.csv", awkjob_names, "awkjob_name")
dump_domain("wow_domain_awkgroup.csv", awkgroup_names, "awkjob_group")
dump_domain("wow_domain_prodadd.csv", prodadd_names, "prodadd_name")

if awk_rows:
    with open(f"{OUT}/wow_awkjob_flat.csv","w",newline="") as fh:
        w=csv.DictWriter(fh, fieldnames=list(awk_rows[0].keys())); w.writeheader(); w.writerows(awk_rows)
if prodadd_rows:
    with open(f"{OUT}/wow_prodadd_flat.csv","w",newline="") as fh:
        w=csv.DictWriter(fh, fieldnames=list(prodadd_rows[0].keys())); w.writeheader(); w.writerows(prodadd_rows)

print("papergroups distinct:", len(paper_groups), "top:", paper_groups.most_common(8))
print("colors distinct:", len(color_names), "top:", color_names.most_common(8))
print("prsjob distinct:", len(prsjob_names), "top:", prsjob_names.most_common(10))
print("awkjob GROUPS distinct:", len(awkgroup_names), "top:", awkgroup_names.most_common(15))
print("awkjob distinct:", len(awkjob_names), "rows:", len(awk_rows), "top:", awkjob_names.most_common(12))
print("prodadd distinct:", len(prodadd_names), "rows:", len(prodadd_rows), "top:", prodadd_names.most_common(8))
