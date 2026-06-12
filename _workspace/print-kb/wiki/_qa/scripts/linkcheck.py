import re, os, glob
ROOT="/Users/innojini/Dev/HuniWeb/_workspace/print-kb/wiki"
scope = glob.glob(f"{ROOT}/base/*.md") + glob.glob(f"{ROOT}/huni/*.md")
all_pages = scope + [f"{ROOT}/index.md", f"{ROOT}/README.md", f"{ROOT}/log.md"] + glob.glob(f"{ROOT}/policy/*.md") + glob.glob(f"{ROOT}/sources/*.md")
PLACEHOLDER={"링크","교차참조","페이지#항목ID","옛페이지#ID","새페이지#ID","다른-페이지#항목","recipes/<family>#항목ID","axis-x#항목ID","../huni/...","../base/...","index"}

def gh_slug(h):
    h=h.strip().lower()
    h=re.sub(r'[^\w\s­\-가-힣]', '', h, flags=re.U)
    h=h.replace(' ','-')
    return h

anchors={}; item_ids={}
for f in all_pages:
    base=os.path.basename(f)[:-3]; txt=open(f).read()
    item_ids[base]=set(re.findall(r'\[([A-Z][A-Z0-9\-]+)\]', txt))
    anchors[base]=set(gh_slug(h) for h in re.findall(r'^#{1,6}\s+(.*)$', txt, re.M))

broken=[]
for f in scope:
    base=os.path.basename(f)[:-3]; txt=open(f).read()
    for m in re.findall(r'\[\[([^\]]+)\]\]', txt):
        if m in PLACEHOLDER or "..." in m: continue
        page,anchor=(m.split('#',1)+[None])[:2] if '#' in m else (m,None)
        page=page.strip().replace('../base/','').replace('../huni/','').replace('../','').strip('/')
        tgt=base if page=='' else os.path.basename(page)
        if tgt not in anchors:
            broken.append((base,m,f"PAGE-MISSING:{tgt}")); continue
        if anchor:
            if anchor in item_ids[tgt]: continue
            if gh_slug(anchor) in anchors[tgt]: continue
            broken.append((base,m,f"ANCHOR-MISSING:{tgt}#{anchor}"))
print(f"BROKEN: {len(broken)}")
for b in broken: print(f"  [{b[0]}] [[{b[1]}]] -> {b[2]}")
