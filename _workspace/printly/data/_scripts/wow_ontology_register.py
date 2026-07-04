#!/usr/bin/env python3
"""와우프레스 전 상품 온톨로지 등록(배치) — devshop catalog 326상품 결정론 전사.
구성요소를 dedup해 used_by(공유 맥락) + 제약(req_/rst_) 그래프로 등록.
★LLM 손전사 금지·수치 파싱·앵커=catalog:products/<id>.json#raw.prod_info.

출력(_workspace/huni-multibrand-ontology/04_wow-registration/):
  wow-products.json      상품별 구성요소 id 참조 + 제약
  wow-components.json    dedup 구성요소 + used_by(공유)
  wow-registration-summary.md  통계 + 맥락 발견
"""
import json, glob, os
from collections import defaultdict

CAT = "/Users/innojini/Dev/HuniWeb/docs/wowpress/catalog"
OUT = "/Users/innojini/Dev/HuniWeb/_workspace/huni-multibrand-ontology/04_wow-registration"

# dedup 레지스트리: type -> id -> {attrs, used_by:set}
reg = {t: {} for t in ["paper", "size", "color", "prsjob", "awkjob", "prodadd"]}
products = {}
constraint_stats = defaultdict(int)          # 제약 타입 카운트
constraint_examples = defaultdict(list)

def touch(t, cid, attrs, prod):
    if cid is None: return
    cid = str(cid)
    e = reg[t].setdefault(cid, {**attrs, "used_by": set()})
    e["used_by"].add(prod)

for f in sorted(glob.glob(f"{CAT}/products/*.json")):
    d = json.load(open(f)); r = d["raw"]["prod_info"]; m = d.get("meta", {})
    pid = str(r.get("prodno"))
    cat = d.get("categoryPath") or []
    P = {"name": r.get("prodname"), "category": cat, "selType": r.get("seltype"),
         "pjoin": r.get("pjoin"), "unit": r.get("unit"), "useCases": m.get("useCases"),
         "filetype": r.get("filetype"),
         "comp": {"paper": [], "size": [], "color": [], "prsjob": [], "awkjob": [], "prodadd": []},
         "constraints": []}
    # 규격
    for si in r.get("sizeinfo") or []:
        for s in si.get("sizelist") or []:
            sid = s.get("sizeno"); P["comp"]["size"].append(str(sid))
            touch("size", sid, {"name": s.get("sizename") or s.get("name"), "w": s.get("width"), "h": s.get("height"), "nonstd": s.get("non_standard")}, pid)
            for ck in ("req_awkjob", "req_width", "req_height", "rst_ordqty", "rst_awkjob"):
                if s.get(ck): constraint_stats[f"size.{ck}"] += 1
    # 재질
    for pi in r.get("paperinfo") or []:
        for pp in pi.get("paperlist") or []:
            pno = pp.get("paperno"); P["comp"]["paper"].append(str(pno))
            touch("paper", pno, {"name": pp.get("papername") or pp.get("name"), "group": pp.get("papergroup"), "gram": pp.get("pgram")}, pid)
            for ck in ("req_awkjob", "rst_ordqty", "rst_prsjob", "rst_awkjob"):
                if pp.get(ck): constraint_stats[f"paper.{ck}"] += 1
    # 도수 + req_prsjob(대표 제약)
    for ci in r.get("colorinfo") or []:
        for pg in ci.get("pagelist") or []:
            for cl in pg.get("colorlist") or []:
                cno = cl.get("colorno"); P["comp"]["color"].append(str(cno))
                rp = cl.get("req_prsjob")
                touch("color", cno, {"name": cl.get("colorname") or cl.get("name")}, pid)
                if rp:
                    jobs = [str(x.get("jobname")) for x in rp if isinstance(x, dict)]
                    P["constraints"].append({"type": "req_prsjob", "color": str(cno), "requires": jobs})
                    constraint_stats["color.req_prsjob"] += 1
                    if len(constraint_examples["color.req_prsjob"]) < 5:
                        constraint_examples["color.req_prsjob"].append(f"{P['name']}: {cl.get('colorname')}→{jobs}")
                for ck in ("rst_prsjob", "rst_awkjob", "rst_opt"):
                    if cl.get(ck): constraint_stats[f"color.{ck}"] += 1
    # 인쇄방식
    for pj in r.get("prsjobinfo") or []:
        for j in pj.get("prsjoblist") or []:
            jno = j.get("jobno"); P["comp"]["prsjob"].append(str(jno))
            touch("prsjob", jno, {"name": j.get("jobname") or j.get("name"), "preset": pj.get("jobpresetno")}, pid)
    # 후가공
    for ai in r.get("awkjobinfo") or []:
        for grp in ai.get("jobgrouplist") or []:
            for j in grp.get("awkjoblist") or []:
                jno = j.get("jobno"); P["comp"]["awkjob"].append(str(jno))
                touch("awkjob", jno, {"name": j.get("jobname") or j.get("namestep2") or j.get("name")}, pid)
    # 부자재
    for a in r.get("prodaddinfo") or []:
        ano = a.get("prodno"); P["comp"]["prodadd"].append(str(ano))
        touch("prodadd", ano, {"name": a.get("prodname") or a.get("name")}, pid)
    products[pid] = P

# used_by set -> sorted list + count
comps_out = {}
for t, d in reg.items():
    comps_out[t] = {}
    for cid, e in d.items():
        ub = sorted(e.pop("used_by"))
        comps_out[t][cid] = {**e, "used_by": ub, "n_used": len(ub)}

os.makedirs(OUT, exist_ok=True)
json.dump(products, open(f"{OUT}/wow-products.json", "w"), ensure_ascii=False, indent=1)
json.dump(comps_out, open(f"{OUT}/wow-components.json", "w"), ensure_ascii=False, indent=1)

# 요약
def top_shared(t, n=10):
    return sorted(comps_out[t].items(), key=lambda kv: -kv[1]["n_used"])[:n]

lines = ["# 와우프레스 전 상품 온톨로지 등록 — 요약\n",
         f"> 결정론 전사(catalog {len(products)}상품)·앵커=catalog:products/<id>.json#raw.prod_info · 생성≠검증\n",
         "## 규모\n",
         f"- 상품: {len(products)}",
         f"- dedup 구성요소: 재질 {len(comps_out['paper'])} · 규격 {len(comps_out['size'])} · 도수 {len(comps_out['color'])} · 인쇄방식 {len(comps_out['prsjob'])} · 후가공 {len(comps_out['awkjob'])} · 부자재 {len(comps_out['prodadd'])}",
         ""]
lines.append("## 공유 맥락 — 가장 많은 상품이 쓰는 구성요소 (used_by 상위)\n")
for t, label in [("prsjob", "인쇄방식"), ("paper", "재질"), ("awkjob", "후가공"), ("prodadd", "부자재")]:
    lines.append(f"### {label}")
    for cid, e in top_shared(t, 8):
        lines.append(f"- `{cid}` {e.get('name')} — {e['n_used']}개 상품 공유")
    lines.append("")
lines.append("## 제약(req_/rst_) 분포\n")
for k, v in sorted(constraint_stats.items(), key=lambda kv: -kv[1]):
    lines.append(f"- {k}: {v}")
lines.append("\n### req_prsjob 예시(도수→인쇄방식 필수)")
for ex in constraint_examples["color.req_prsjob"]:
    lines.append(f"- {ex}")
open(f"{OUT}/wow-registration-summary.md", "w").write("\n".join(lines))
print("등록 완료:", len(products), "상품 →", OUT)
print("dedup:", {t: len(comps_out[t]) for t in comps_out})
