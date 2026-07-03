#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""축 ③ — 스티커 파일 명명 비일관이 index.md 링크·질의 라우팅에 dead-link 유발하는지 결정론 검증.
검사: ① index.md 내 링크 target 파일 실재 여부 ② 스티커 상품 노드 index 등재 여부
      ③ nl-query-paths.md 라우팅 target 실재 여부 ④ 명명 규칙 분포."""
import os,re,glob,json
KB=os.path.join(os.path.dirname(__file__),"..","..","03_kb")
KB=os.path.abspath(KB)
files={os.path.relpath(p,KB).replace(os.sep,"/") for p in glob.glob(os.path.join(KB,"**","*.md"),recursive=True)}
basenames={os.path.basename(f)[:-3] for f in files}  # ".md" 제거
nodes={}
for ln in open(os.path.join(KB,"..","04_graph","nodes.jsonl")):
    r=json.loads(ln); nodes[r["id"]]=r

def md_links(path):
    txt=open(path,encoding="utf-8").read()
    # [text](target)  및  [[wikilink]]
    md=[m for m in re.findall(r"\]\(([^)]+)\)",txt)]
    wl=[m for m in re.findall(r"\[\[([^\]]+)\]\]",txt)]
    return txt,md,wl

print("=== ① index.md 마크다운 링크 target 파일 실재 ===")
idxp=os.path.join(KB,"index.md")
itxt,imd,iwl=md_links(idxp)
dead=[]
for t in imd:
    t0=t.split("#")[0].strip()
    if not t0 or t0.startswith(("http","mailto")): continue
    # 상대경로 정규화(index.md는 03_kb/ 기준)
    rel=os.path.normpath(os.path.join("",t0)).replace(os.sep,"/")
    if rel.endswith(".md"):
        if rel not in files and os.path.basename(rel) not in basenames:
            dead.append(t)
print("index.md .md 링크 총:",len([t for t in imd if t.split('#')[0].endswith('.md')]),"· dead:",len(dead))
for d in dead: print("   DEAD:",d)

print("\n=== ② 스티커 상품 노드(PRD_000052~067) index.md 등재 ===")
for i in range(52,68):
    code=f"PRD_0000{i}"
    prod=[nid for nid,r in nodes.items() if r.get("type")=="product" and str(r.get("anchor",""))==f"t_prd_products/{code}"]
    for nid in prod:
        fp=nodes[nid]["file_path"]; base=os.path.basename(fp)
        in_id = nid in itxt
        in_file = (fp in itxt) or (base in itxt)
        flag="" if (in_id or in_file) else "  ★index 미등재(dead route)"
        print(f"   {code} node={nid:40s} file={base:36s} id_in_idx={in_id} file_in_idx={in_file}{flag}")

print("\n=== ③ nl-query-paths.md 라우팅 target 실재 ===")
qp=os.path.join(KB,"..","02_ontology","nl-query-paths.md")
if os.path.exists(qp):
    qtxt=open(qp,encoding="utf-8").read()
    qids=re.findall(r"\[\[([^\]#]+)",qtxt)
    missing=sorted({q.strip() for q in qids if "/" not in q and q.strip() not in nodes and q.strip() not in basenames})
    print("nl-query-paths [[ ]] 참조:",len(qids),"· 미해결(노드/파일 부재):",len(missing))
    for m in missing[:30]: print("   MISSING:",m)
else:
    print("   nl-query-paths.md 없음")

print("\n=== ④ 스티커 명명 규칙 분포 ===")
prodN=0; slug=0
for i in range(52,68):
    code=f"PRD_0000{i}"
    for nid,r in nodes.items():
        if r.get("type")=="product" and str(r.get("anchor",""))==f"t_prd_products/{code}":
            base=os.path.basename(r["file_path"])[:-3]
            if base.startswith("product-0"): prodN+=1
            elif base.startswith("sticker-"): slug+=1
print(f"   파일명 product-NNN: {prodN} · sticker-slug: {slug}")
