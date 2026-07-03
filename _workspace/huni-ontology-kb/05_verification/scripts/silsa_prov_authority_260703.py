#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
silsa_prov_authority_260703.py — 실사 28상품(PRD_000118~145) 출처 실재성·권위·오염 결정론 검증.
- 배정 축: 출처 5필드·transcribed-by 마커·배선 live-snapshot diff·오염 4종 + 레더/그래픽천 crosscut + 카테고리/constraints 해소 양면표기.
- 원천 비신뢰: build_graph 리포트 안 믿고 nodes.jsonl/edges.jsonl 직접 로드 + live-snapshot CSV 재조회.
출력: stdout 결함/확인 라인 (defect-silsa-prov-260703.md에 요약).
"""
import os, json, csv, re, sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "../.."))
G = os.path.join(ROOT, "04_graph")
SNAP = os.path.abspath(os.path.join(ROOT, "../_foundation/live-snapshot/latest"))

def load_csv(name):
    p = os.path.join(SNAP, name + ".csv")
    if not os.path.exists(p): return None
    with open(p, encoding="utf-8") as f:
        return list(csv.DictReader(f))

nodes = [json.loads(l) for l in open(os.path.join(G, "nodes.jsonl"), encoding="utf-8")]
edges = [json.loads(l) for l in open(os.path.join(G, "edges.jsonl"), encoding="utf-8")]
nid = {n["id"]: n for n in nodes}

SILSA_PRD = [f"PRD_000{n}" for n in range(118, 146)]
# silsa product node ids
silsa_prod_nodes = [n for n in nodes if n["type"]=="product" and n.get("props",{}).get("prd_cd") in SILSA_PRD]
# any node whose file_path is a silsa product file
def is_silsa_file(fp):
    return bool(re.search(r"product-1(1[89]|2[0-9]|3[0-9]|4[0-5])-", fp or ""))
silsa_nodes = [n for n in nodes if is_silsa_file(n.get("file_path"))]

print(f"[SCOPE] silsa product nodes={len(silsa_prod_nodes)} (expect 28) · silsa-file nodes total={len(silsa_nodes)}")
found_prd = sorted(n["props"]["prd_cd"] for n in silsa_prod_nodes)
missing = [p for p in SILSA_PRD if p not in found_prd]
if missing: print(f"[DEFECT scope] missing silsa product nodes: {missing}")

# ---------- AXIS 1: source 5-field completeness ----------
REQ = ["source_file","source_locator","captured_at","badge"]  # src_id optional but expected
prov_defects=[]
for n in silsa_nodes:
    srcs = n.get("sources",[])
    if n["type"]=="gap":
        # gap allowed anchor none; still needs sources
        pass
    if not srcs:
        prov_defects.append((n["id"],"NO_SOURCES","노드에 src 0"))
        continue
    for i,s in enumerate(srcs):
        for f in REQ:
            if not s.get(f):
                prov_defects.append((n["id"],f"MISSING_{f}",f"src#{i}"))
        if not s.get("src_id"):
            prov_defects.append((n["id"],"MISSING_src_id",f"src#{i} {s.get('source_file','')[:40]}"))
print(f"\n[AXIS1 src 5필드] defects={len(prov_defects)}")
for d in prov_defects[:40]: print("  ",d)

# ---------- AXIS 2: live-snapshot anchor re-query (authority) ----------
# for every source pointing at live-snapshot CSV with a 키:CODE(...) locator, re-verify the code exists
mats = {r["mat_cd"]:r for r in load_csv("t_mat_materials")}
cats = {r["cat_cd"]:r for r in load_csv("t_cat_categories")}
prd_mat = load_csv("t_prd_product_materials")
prd_cat = load_csv("t_prd_product_categories")
constraints = load_csv("t_prd_product_constraints")
addons = load_csv("t_prd_product_addons")
sets = load_csv("t_prd_product_sets")
base = {r["cod_cd"]:r for r in load_csv("t_cod_base_codes")}

anchor_defects=[]
CODE_RE = re.compile(r"키[:：]\s*([A-Z]{2,}_?[0-9A-Za-z_]+)")
for n in silsa_nodes:
    for s in n.get("sources",[]):
        sf = s.get("source_file","")
        loc = s.get("source_locator","")
        if "t_mat_materials.csv" in sf:
            m = re.search(r"MAT_\d+", loc)
            if m and m.group(0) not in mats:
                anchor_defects.append((n["id"],"MAT_NOT_IN_SNAP",m.group(0)))
        if "t_cat_categories.csv" in sf:
            m = re.search(r"CAT_\d+", loc)
            if m and m.group(0) not in cats:
                anchor_defects.append((n["id"],"CAT_NOT_IN_SNAP",m.group(0)))
print(f"\n[AXIS2 anchor 실재] defects={len(anchor_defects)}")
for d in anchor_defects: print("  ",d)

# ---------- CROSSCUT: MAT_000186 레더 authority + crosscut ----------
print("\n===== CROSSCUT 레더 MAT_000186 =====")
lm = mats.get("MAT_000186",{})
print(f"  live t_mat_materials MAT_000186: mat_typ_cd={lm.get('mat_typ_cd')} use_yn={lm.get('use_yn')} del_yn={lm.get('del_yn')} upd_dt={lm.get('upd_dt')}")
# node claim
lnode = nid.get("material-MAT_000186",{})
claimed = lnode.get("props",{}).get("mat_typ_cd")
print(f"  KB node claim mat_typ_cd={claimed}")
if claimed != lm.get("mat_typ_cd"):
    print(f"  [DEFECT] KB claim {claimed} != live {lm.get('mat_typ_cd')}")
else:
    print(f"  [OK] KB mat_typ_cd matches live")
# crosscut: products using MAT_000186 (active links)
leather_prds = sorted(set(r["prd_cd"] for r in prd_mat if r["mat_cd"]=="MAT_000186" and r.get("del_yn")=="N"))
leather_prds_all = sorted(set(r["prd_cd"] for r in prd_mat if r["mat_cd"]=="MAT_000186"))
print(f"  live MAT_000186 crosscut (del_yn=N)={leather_prds}")
print(f"  live MAT_000186 crosscut (all rows)={leather_prds_all}")
# KB claims 4상품 100/126/296/298
kb_claim_note = lnode.get("props",{}).get("note","")
print(f"  KB note claims: {'100/126/296/298' if '100/126/296/298' in kb_claim_note else 'NOT FOUND'}")

# MAT_TYPE code domain check
for c in ["MAT_TYPE.05","MAT_TYPE.06","MAT_TYPE.08","MAT_TYPE.19","MAT_TYPE.12"]:
    b = base.get(c,{})
    print(f"  base code {c}: cod_nm={b.get('cod_nm')} use_yn={b.get('use_yn')} del_yn={b.get('del_yn')}")

# graphic-cloth / fabric materials type check (claim: 181/182/183 still .08, 184/185/187/188 .05, 189 .19, 190 .12)
print("\n  --- 패브릭/특수 소재 mat_typ_cd 현재값 (claim 대조) ---")
fabric = {"MAT_000181":"그래픽천(.08?)","MAT_000182":"현수막천(.08?)","MAT_000183":"메쉬(.08?)",
          "MAT_000184":"린넨(.05?)","MAT_000185":"캔버스(.05?)","MAT_000186":"레더(.05?)",
          "MAT_000187":"타이벡(.05?)","MAT_000188":"타이벡(.05?)","MAT_000189":"시트커팅지(.19?)","MAT_000190":"카드거울(.12?)"}
for mc,exp in fabric.items():
    r=mats.get(mc,{})
    print(f"    {mc} {exp}: live={r.get('mat_typ_cd')} nm={r.get('mat_nm')}")

# ---------- CROSSCUT: category orphan resolution CAT_000298 ----------
print("\n===== CROSSCUT 카테고리 고아 해소 CAT_000298 =====")
c298 = cats.get("CAT_000298",{})
print(f"  live CAT_000298: cat_nm={c298.get('cat_nm')} del_yn={c298.get('del_yn')} upd_dt={c298.get('upd_dt')}")
# silsa product category links
silsa_cat_links = [r for r in prd_cat if r["prd_cd"] in SILSA_PRD]
still_298 = [r["prd_cd"] for r in silsa_cat_links if r["cat_cd"]=="CAT_000298"]
print(f"  silsa→CAT_000298 links remaining: {still_298 if still_298 else 'NONE (해소됨)'}")
catcount={}
for r in silsa_cat_links:
    catcount[r["cat_cd"]]=catcount.get(r["cat_cd"],0)+1
print(f"  silsa category distribution: {dict(sorted(catcount.items()))}")

# ---------- CROSSCUT: constraints 신규 발현 ----------
print("\n===== CROSSCUT constraints 발현 =====")
silsa_cons = [r for r in constraints if r["prd_cd"] in SILSA_PRD]
cons_by_prd={}
for r in silsa_cons:
    cons_by_prd.setdefault(r["prd_cd"],[]).append(r)
print(f"  silsa constraints rows total={len(silsa_cons)}; products with constraints={sorted(cons_by_prd.keys())}")
claim7 = ["PRD_000118","PRD_000120","PRD_000121","PRD_000122","PRD_000124","PRD_000125","PRD_000139"]
actual = sorted(cons_by_prd.keys())
print(f"  KB claims 7상품: {[p[-3:] for p in claim7]}")
print(f"  live actual: {[p[-3:] for p in actual]}")
if set(actual)!=set(claim7):
    print(f"  [DELTA] extra={set(actual)-set(claim7)} missing={set(claim7)-set(actual)}")
# 138 should be 0
print(f"  PRD_000138 (일반현수막) constraint rows: {len(cons_by_prd.get('PRD_000138',[]))} (claim=0)")

# ---------- CROSSCUT: addon/set 잔존 0 ----------
print("\n===== CROSSCUT addon/set 잔존 0 =====")
silsa_addon = [r for r in addons if r["prd_cd"] in SILSA_PRD]
silsa_set = [r for r in sets if r["prd_cd"] in SILSA_PRD]
print(f"  silsa addon rows={len(silsa_addon)} (claim=0); set(parent) rows={len(silsa_set)} (claim=0)")

# ---------- AXIS 3: contamination — STALE blocklist references ----------
print("\n===== AXIS3 오염 (STALE 인용) =====")
STALE_PAT = [r"v03", r"prdmaster_full_migration", r"price-engine-ddl", r"prcx01-pricing-model",
             r"huni-db-mapping\.md", r"후가공_박\(백업\)", r"constraint_json", r"dep_proc_cd"]
stale_hits=[]
for n in silsa_nodes:
    blob = json.dumps(n, ensure_ascii=False)
    for pat in STALE_PAT:
        for m in re.finditer(pat, blob):
            # allow if mentioned as STALE warning (context includes STALE/금지/구/은퇴)
            ctx = blob[max(0,m.start()-30):m.end()+30]
            if re.search(r"STALE|금지|구 |은퇴|무효|낡", ctx): continue
            stale_hits.append((n["id"],pat,ctx[:60]))
print(f"  STALE 인용(경고문맥 제외) hits={len(stale_hits)}")
for h in stale_hits[:20]: print("  ",h)

# ---------- AXIS 3b: two-sided labeling for corrected defects ----------
print("\n===== AXIS3b 양면표기 (round-13 결함 해소를 '현재값=정답' 표기) =====")
# category orphan resolved: node should NOT present CAT_000298 as current-value defect
# leather: node should NOT present .06 as answer (should say .05 current, .06 STALE)
lnote = nid.get("material-MAT_000186",{}).get("props",{}).get("note","")
two_sided_ok=[]
if "STALE" in lnote and ".05" in lnote:
    two_sided_ok.append("레더: .05 현재값+.06 STALE 양면표기 OK")
else:
    print("  [DEFECT] 레더 노드 양면표기 미흡")
# category node
cat_node = None
for n in silsa_nodes:
    if n["type"]=="category" and "CAT_000298" in json.dumps(n,ensure_ascii=False):
        cat_node = n; break
if cat_node:
    cn = json.dumps(cat_node,ensure_ascii=False)
    if "del_yn=Y" in cn and ("STALE" in cn or "해소" in cn):
        two_sided_ok.append(f"카테고리({cat_node['id']}): CAT_000298 해소+STALE 양면표기 OK")
for t in two_sided_ok: print("  [OK]",t)

print("\n[DONE]")
