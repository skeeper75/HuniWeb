import csv, collections
ASM=f"{ROOT}/_workspace/huni-dbmap/09_load/_assembled".replace("ROOT","/Users/innojini/Dev/HuniWeb") if False else "/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap/09_load/_assembled"
ASP="/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap/09_load/_assembled_price"
OUT="/Users/innojini/Dev/HuniWeb/_workspace/huni-dbmap/09_load/_exec/load-preview.md"

def tsv(p):
    d={}
    for l in open(p, encoding="utf-8"):
        if "\t" in l:
            k,v=l.rstrip("\n").split("\t",1); d[k]=v
    return d
PRD=tsv("/tmp/map_prd.tsv"); MAT=tsv("/tmp/map_mat.tsv"); PROC=tsv("/tmp/map_proc.tsv")
USAGE={"USAGE.01":"내지","USAGE.02":"표지","USAGE.03":"면지","USAGE.04":"간지","USAGE.05":"투명커버","USAGE.06":"표지타입","USAGE.07":"공통"}
QU={"QTY_UNIT.01":"EA","QTY_UNIT.02":"매","QTY_UNIT.03":"권","QTY_UNIT.04":"세트"}

def rows(p):
    try: return list(csv.DictReader(open(p, encoding="utf-8")))
    except FileNotFoundError: return []

mats=rows(f"{ASM}/load/05_t_prd_product_materials.csv")
procs=rows(f"{ASM}/load/06_t_prd_product_processes.csv")
bundles=rows(f"{ASM}/load/09_t_prd_product_bundle_qtys.csv")
# group by prd
by=collections.defaultdict(lambda:{"mat":[],"proc":[],"bdl":[]})
for r in mats: by[r["prd_cd"]]["mat"].append(r)
for r in procs: by[r["prd_cd"]]["proc"].append(r)
for r in bundles: by[r["prd_cd"]]["bdl"].append(r)

L=[]
L.append("# round-5 적재 미리보기 (커밋 없음 · DB 무변경)\n")
L.append("> 이 문서는 round-5가 라이브 `railway` DB에 **넣을 데이터**를 사람이 읽는 형태로 보여준다.")
L.append("> **실제 적재(COMMIT)는 하지 않았다** — 뷰어에는 아직 안 보이는 게 정상. 커밋 승인 시 아래대로 들어간다.")
L.append("> 코드→이름은 라이브 마스터(read-only) 기준. usage: 01내지·02표지·07공통 등.\n")
L.append("---\n## 1. 상품마스터 트랙 — 상품별 추가분\n")
L.append(f"적재 대상 상품 **{len(by)}개** · 자재 {len(mats)}행 · 공정 {len(procs)}행 · 묶음수 {len(bundles)}행\n")

for prd in sorted(by):
    g=by[prd]; nm=PRD.get(prd,"(이름?)")
    L.append(f"### {nm} ({prd})")
    if g["mat"]:
        # group by usage
        ug=collections.defaultdict(list)
        for r in g["mat"]: ug[r["usage_cd"]].append(r)
        parts=[]
        for u,rs in ug.items():
            names=[]
            for r in sorted(rs,key=lambda x:int(x["disp_seq"] or 0)):
                tag="기본" if r["dflt_yn"]=="Y" else ""
                names.append(MAT.get(r["mat_cd"],r["mat_cd"])+(f"({tag})" if tag else ""))
            parts.append(f"**{USAGE.get(u,u)}** {len(rs)}종: "+" · ".join(names))
        L.append(f"- 자재 +{len(g['mat'])} — "+" / ".join(parts))
    if g["proc"]:
        ps=[]
        for r in sorted(g["proc"],key=lambda x:int(x["disp_seq"] or 0)):
            mand="필수" if r["mand_proc_yn"]=="Y" else "옵션"
            ps.append(f"{PROC.get(r['proc_cd'],r['proc_cd'])}({mand})")
        L.append(f"- 공정 +{len(g['proc'])} — "+" · ".join(ps))
    if g["bdl"]:
        bs=[f"{r['bdl_qty']}{QU.get(r['bdl_unit_typ_cd'],'')}"+("(기본)" if r['dflt_yn']=='Y' else "") for r in sorted(g['bdl'],key=lambda x:int(x['disp_seq'] or 0))]
        L.append(f"- 묶음수 +{len(g['bdl'])} — "+" · ".join(bs))
    L.append("")

# code rows
L.append("### 코드행 선적재 (마스터 신규 코드 — 후니 라이브 등록 대상)")
for p,label in [(f"{ASM}/load/00_proc_laser.csv","공정 t_proc_processes"),(f"{ASM}/load/00_siz_sticker_circle.csv","사이즈 t_siz_sizes")]:
    rs=rows(p)
    if rs:
        L.append(f"- {label}: {len(rs)}행 — "+", ".join((r.get('proc_nm') or r.get('siz_nm') or list(r.values())[1]) for r in rs[:12]))
L.append("")

# price track
L.append("---\n## 2. 가격 트랙 — 추가분 (라이브 t_prc_* 현재 0행 → 신규 적재)\n")
fnm={r["frm_cd"]:r["frm_nm"] for r in rows(f"{ASP}/load/01_prc_price_formulas.csv")}
cnm={r["comp_cd"]:r["comp_nm"] for r in rows(f"{ASP}/load/02_prc_price_components.csv")}
binds=rows(f"{ASP}/load/05_prd_product_price_formulas.csv")
L.append(f"### 상품 ↔ 가격공식 바인딩 +{len(binds)}")
for r in binds:
    L.append(f"- {PRD.get(r['prd_cd'],r['prd_cd'])} ({r['prd_cd']}) → {fnm.get(r['frm_cd'],r['frm_cd'])}")
L.append("")
cps=rows(f"{ASP}/load/04_prc_component_prices.csv")
cg=collections.defaultdict(list)
for r in cps: cg[r["comp_cd"]].append(r)
L.append(f"### 구성요소 다차원 단가 +{len(cps)}행 ({len(cg)}개 구성요소)\n")
L.append("| 구성요소 | 행수 | 단가범위(원) | 비고 |")
L.append("|---|---|---|---|")
for c in sorted(cg,key=lambda x:-len(cg[x])):
    rs=cg[c]; pr=[float(x["unit_price"]) for x in rs if x["unit_price"]]
    rng=f"{min(pr):,.0f} ~ {max(pr):,.0f}" if pr else "-"
    L.append(f"| {cnm.get(c,c)} | {len(rs)} | {rng} | {c} |")
L.append("")
L.append("> 단가값은 round-2 검증(GO)·S-gate(도메인 정합) 완료분. 음수 0·0원=직각모서리/1구타공 기본옵션 무료.")

open(OUT,"w",encoding="utf-8").write("\n".join(L))
print(f"생성: {OUT}")
print(f"상품 {len(by)}개 · 자재 {len(mats)} · 공정 {len(procs)} · 묶음 {len(bundles)} · 바인딩 {len(binds)} · 단가 {len(cps)}행 / 구성요소 {len(cg)}")
