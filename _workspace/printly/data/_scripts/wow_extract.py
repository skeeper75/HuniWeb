#!/usr/bin/env python3
# 와우 catalog products/<id>.json 의 6+2축을 raw.prod_info에서 결정론 전사.
# ★LLM 손전사 금지(원칙)·수치는 파싱. 출처=catalog:products/<id>.json#raw.prod_info.<axis>
import json, sys, os
CAT = "/Users/innojini/Dev/HuniWeb/docs/wowpress/catalog"

def load(pid):
    return json.load(open(f"{CAT}/products/{pid}.json"))

def axis_summary(pid):
    p = load(pid); r = p["raw"]["prod_info"]; m = p["meta"]
    out = {"prodno": r.get("prodno"), "name": r.get("prodname"),
           "selType": r.get("seltype"), "pjoin": r.get("pjoin"), "unit": r.get("unit"),
           "useCases": m.get("useCases"), "fileTypes": r.get("filetype")}
    # 규격
    sizes=[]
    for si in r.get("sizeinfo") or []:
        for s in si.get("sizelist") or []:
            sizes.append({"sizeno": s.get("sizeno"), "name": s.get("sizename") or s.get("name"),
                          "w": s.get("width"), "h": s.get("height"), "nonstd": s.get("non_standard")})
    out["sizes"]=sizes
    # 재질
    papers=[]
    for pi in r.get("paperinfo") or []:
        for pp in pi.get("paperlist") or []:
            papers.append({"paperno": pp.get("paperno"), "name": pp.get("papername") or pp.get("name"),
                           "group": pp.get("papergroup"), "gram": pp.get("pgram")})
    out["papers"]=papers
    # 도수
    colors=[]
    for ci in r.get("colorinfo") or []:
        for pg in ci.get("pagelist") or []:
            for cl in pg.get("colorlist") or []:
                colors.append({"colorno": cl.get("colorno"), "name": cl.get("colorname") or cl.get("name"),
                               "req_prsjob": cl.get("req_prsjob")})
    out["colors"]=colors
    # 인쇄방식
    prsjobs=[]
    for pj in r.get("prsjobinfo") or []:
        for j in pj.get("prsjoblist") or []:
            prsjobs.append({"jobno": j.get("jobno"), "name": j.get("jobname") or j.get("name"),
                            "presetno": pj.get("jobpresetno")})
    out["prsjobs"]=prsjobs
    # 후가공 (2단 중첩)
    awk=[]
    for ai in r.get("awkjobinfo") or []:
        for grp in ai.get("jobgrouplist") or []:
            gname=grp.get("jobgroupname") or grp.get("namestep1")
            for j in grp.get("awkjoblist") or []:
                awk.append({"group": gname, "jobno": j.get("jobno"),
                            "name": j.get("jobname") or j.get("namestep2") or j.get("name")})
    out["awkjobs"]=awk
    # 부자재
    padd=[]
    for a in r.get("prodaddinfo") or []:
        padd.append({"prodno": a.get("prodno"), "name": a.get("prodname") or a.get("name")})
    out["prodadds"]=padd
    # 수량/건수
    oq=[]
    for q in r.get("ordqty") or []:
        oq.append({"type": q.get("type"), "min": q.get("minimum"), "max": q.get("maximum"),
                   "interval": q.get("interval"), "n_values": len(q.get("values") or [])})
    out["ordqty"]=oq[:2]
    out["coverinfo"]=[{"name": c.get("covername"), "pages":[pg.get("pagename") for pg in c.get("pagelist") or []]} for c in r.get("coverinfo") or []]
    return out

if __name__=="__main__":
    for pid in sys.argv[1:]:
        s=axis_summary(pid)
        print(f"\n{'='*70}\n{pid} {s['name']} (selType={s['selType']} pjoin={s['pjoin']} unit={s['unit']} useCases={s['useCases']})")
        for ax in ["sizes","papers","colors","prsjobs","awkjobs","prodadds","ordqty","coverinfo"]:
            v=s[ax]; print(f"  {ax} [{len(v)}]:")
            for it in v[:12]: print("     ", it)
            if len(v)>12: print(f"      ... +{len(v)-12} more")
