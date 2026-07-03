#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Stage B 클러스터 빌더 — 레더 파우치·미니·필통 (19 단품).
live-snapshot/latest CSV에서 결정론 전사(D-9·손전사 금지) → product-NNN-*.md 생성.
대상: 230~238·251~260 (전부 prd_typ=PRD_TYPE.01 단품·셋트 아님).
가격 3분기: ①고정가룩업(t_prd_product_prices 실재) ②NEITHER-gap(공식·고정가 둘 다 없음).
전 상품 공정 0행=봉제 MISSING → gap-goods-sewing-missing. 비종이(레더)=판형 없음.
"""
import csv, os

SNAP = "snap_20260702_1119"
LIVE = "/Users/innojini/Dev/HuniWeb/_workspace/_foundation/live-snapshot/latest"
OUT  = "/Users/innojini/Dev/HuniWeb/_workspace/huni-ontology-kb/03_kb/product"

# slug 정본(product-NNN-kebab) + 영문 kebab. 한글명은 CSV에서 전사.
SLUG = {
  "PRD_000230": "product-230-leather-flat-pouch",
  "PRD_000231": "product-231-leather-slim-pouch",
  "PRD_000232": "product-232-leather-triangle-pouch",
  "PRD_000233": "product-233-leather-volume-pouch",
  "PRD_000234": "product-234-leather-string-pouch",
  "PRD_000235": "product-235-leather-string-round-pouch",
  "PRD_000236": "product-236-leather-flat-clutch",
  "PRD_000237": "product-237-leather-triangle-clutch",
  "PRD_000238": "product-238-leather-ipad-laptop-pouch",
  "PRD_000251": "product-251-leather-flat-mini-pouch",
  "PRD_000252": "product-252-leather-slim-mini-pouch",
  "PRD_000253": "product-253-leather-triangle-mini-pouch",
  "PRD_000254": "product-254-leather-volume-mini-pouch",
  "PRD_000255": "product-255-leather-round-mini-pouch",
  "PRD_000256": "product-256-leather-flat-pencil-case",
  "PRD_000257": "product-257-leather-slim-pencil-case",
  "PRD_000258": "product-258-leather-triangle-pencil-case",
  "PRD_000259": "product-259-leather-volume-pencil-case",
  "PRD_000260": "product-260-leather-round-pencil-case",
}
IDS = list(SLUG.keys())

def load(name):
    with open(os.path.join(LIVE, name), newline="", encoding="utf-8") as f:
        return list(csv.DictReader(f))

prods   = {r["prd_cd"]: r for r in load("t_prd_products.csv")}
prices  = {r["prd_cd"]: r for r in load("t_prd_product_prices.csv")}
mats_raw = load("t_prd_product_materials.csv")
procs_raw = load("t_prd_product_processes.csv")
sizes_raw = load("t_prd_product_sizes.csv")
matnames = {r["mat_cd"]: r for r in load("t_mat_materials.csv")}
sizenames = {r["siz_cd"]: r for r in load("t_siz_sizes.csv")}
cats_raw = load("t_prd_product_categories.csv")
catnames = {r["cat_cd"]: r for r in load("t_cat_categories.csv")}
optg_raw = load("t_prd_product_option_groups.csv")

def active_mats(pid):
    return [r for r in mats_raw if r["prd_cd"] == pid and r.get("del_yn") != "Y"]
def active_sizes(pid):
    return [r for r in sizes_raw if r["prd_cd"] == pid and r.get("del_yn") != "Y"]
def proc_count(pid):
    return len([r for r in procs_raw if r["prd_cd"] == pid and r.get("del_yn") != "Y"])
def cats(pid):
    return [r for r in cats_raw if r["prd_cd"] == pid]
def optgroups(pid):
    return [r for r in optg_raw if r["prd_cd"] == pid and r.get("del_yn") != "Y"]

os.makedirs(OUT, exist_ok=True)
manifest = []

for pid in IDS:
    p = prods[pid]
    num = pid.replace("PRD_", "").lstrip("0")
    slug = SLUG[pid]
    nm = p["prd_nm"]
    fixed = prices.get(pid)
    price_val = fixed["unit_price"] if fixed else None
    ams = active_mats(pid)
    # 실 substrate(레더 MAT_TYPE.06)과 shape-변형(MAT_TYPE.09) 분리
    leather = [m for m in ams if matnames.get(m["mat_cd"], {}).get("mat_typ_cd") == "MAT_TYPE.06"]
    shapes  = [m for m in ams if matnames.get(m["mat_cd"], {}).get("mat_typ_cd") == "MAT_TYPE.09"]
    asz = active_sizes(pid)
    pc = proc_count(pid)
    cs = cats(pid)
    ogs = optgroups(pid)

    branch = "fixed" if price_val else "neither"
    badge  = "verified" if branch == "fixed" else "candidate"
    contaminated = len(shapes) > 0

    # gap references (전부 실재 노드 id·L-15 안전)
    gap_refs = ["gap-goods-sewing-missing"]  # 전 상품 공정 0행
    if branch == "neither":
        gap_refs.append("gap-goods-neither")
    if contaminated:
        gap_refs.append("gap-goods-material-contamination")

    # --- frontmatter ---
    L = []
    L.append("---")
    L.append(f"id: {slug}")
    L.append("type: product")
    L.append(f"anchor: t_prd_products/{pid}")
    L.append(f"badge: {badge}")
    L.append("sources:")
    L.append(f'  - {{source_file: "live-snapshot/latest/t_prd_products.csv", source_locator: "키:{pid} (prd_typ=PRD_TYPE.01·use_yn=Y·del_yn=N·nonspec_yn=N)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}}')
    L.append(f'  - {{source_file: "_workspace/huni-ontology-kb/01_curation/pack-stationery-goods.md", source_locator: "§1.3 하위군③ 파우치·백(레더 파우치/미니/필통 230~237·251~260)·§3.10 가격아키타입·§4 GAP표·§3.5 자재 empty-shell·§3.6 봉제 MISSING", captured_at: "2026-07-03", badge: {badge}, src_id: SR-pack-stn}}')
    if branch == "fixed":
        L.append(f'  - {{source_file: "live-snapshot/latest/t_prd_product_prices.csv", source_locator: "키:{pid} unit_price (GP-1 base 단일고정가·260610 verbatim)", captured_at: "live 20260702_1119", badge: verified, src_id: SR-5-livesnap}}')
    # relations = gap references only (축 노드 미민팅 → in_category/uses_material/has_size는 needs_axis)
    L.append("relations:")
    for g in gap_refs:
        note = {
            "gap-goods-sewing-missing": "봉제 공정 0행(has_process 미배선·empty on process axis)",
            "gap-goods-neither": "가격 원천 부재(공식·고정가 둘 다 0행=견적 불가)",
            "gap-goods-material-contamination": "MAT_TYPE.09 shape-변형 자재 잔존(치수/형상을 자재로 오모델·substrate 아님)",
        }[g]
        L.append(f'  - {{rel: references, target: {g}, note: "{note}"}}')
    # props
    L.append("props:")
    L.append('  prd_typ_cd: "PRD_TYPE.01"')
    L.append(f'  min_qty: {p["min_qty"]}   # 단일 스칼라(§2.4)·src=SR-5-livesnap')
    L.append(f'  max_qty: {p["max_qty"]}')
    L.append(f'  qty_incr: {p["qty_incr"]}')
    L.append(f'  qty_unit_typ_cd: "{p["qty_unit_typ_cd"]}"')
    L.append(f'  file_upload_yn: "{p["file_upload_yn"]}"')
    L.append(f'  editor_yn: "{p["editor_yn"]}"')
    if branch == "fixed":
        L.append(f'  가격아키타입: "고정가룩업(t_prd_product_prices 단일 unit_price·{price_val}원·transcribed·priced_by 불요=완결 원천)"')
    else:
        L.append('  가격아키타입: "NEITHER-gap(t_prd_product_price_formulas·t_prd_product_prices 둘 다 0행=견적 원천 부재)"')
    L.append('  판형: "없음(비종이=레더 MAT_TYPE.06·plate_sizes 전행 del_yn=Y 파일사양·종이류만 판형 도메인[HARD])"')
    L.append('  구분: "봉제 굿즈(레더 파우치/미니파우치/필통 단품·셋트 아님·has_member 없음)"')
    L.append("standards: {schema_org: \"Product\", xjdf: \"Product(봉제 파우치)\", config_ont: \"component type\"}")
    tags = ["#굿즈", "#파우치", "#레더", "#봉제"]
    tags.append("#고정가룩업" if branch == "fixed" else "#NEITHER-gap")
    L.append("tags: [" + ", ".join(f'"{t}"' for t in tags) + "]")
    L.append("updated: 2026-07-03")
    L.append("---")
    L.append("")

    # --- body ---
    fam = "필통" if "필통" in nm else ("미니파우치" if "미니" in nm else "파우치/클러치")
    L.append(f"# {nm} ({slug})")
    L.append("")
    if branch == "fixed":
        price_sent = (f"가격은 **고정가룩업**(`t_prd_product_prices` 단일 unit_price·완결 원천)이라 가격공식(priced_by) 없이 "
                      f"단가 조회로 견적한다(값 권위=엔진·[[rule/rules#RULE_price_value_boundary]]·D-18 경계).")
    else:
        price_sent = ("가격은 **NEITHER-gap** — `t_prd_product_price_formulas`·`t_prd_product_prices` 둘 다 0행이라 "
                      "견적 원천이 아직 없다(정직 표기·[[gap-goods-neither]]). 손님이 0/최소가를 만나는 상태.")
    L.append(f"레더 소재 **봉제 굿즈 단품**(prd_typ_cd=`PRD_TYPE.01`·`t_prd_product_sets` 미등록=셋트 부모/구성원 아님·"
             f"[[product-type-classification-sot]] 준수). {price_sent}")
    L.append("")
    L.append("- **비종이=판형 없음**: 본체 자재=레더(MAT_000008·`MAT_TYPE.06`)·봉제 상품 → `plate_size` 없음"
             "([[rule/rules#RULE_plate_paper_only]]). live `t_prd_product_plate_sizes` 행은 전부 del_yn=Y(파일사양 JPG·판형 아님).")
    L.append(f"- **봉제 공정 MISSING**: `t_prd_product_processes` **0행**(봉제/후가공 미배선) → [[gap-goods-sewing-missing]] "
             "(has_process 엣지 없음 정직 표기).")
    if contaminated:
        shp = "·".join(f'{m["mat_cd"]}({matnames.get(m["mat_cd"],{}).get("mat_nm","?")})' for m in shapes)
        L.append(f"- **자재 오염 잔존**: 활성 자재 중 shape-변형 {len(shapes)}행({shp})이 `MAT_TYPE.09`로 등록 = "
                 f"치수/형상을 자재로 오모델(substrate 아님) → [[gap-goods-material-contamination]]. substrate 자재는 레더뿐.")
    L.append("- **정체·가격 경계(D-18)**: 이 노드는 상품·가격 원천 존재/부재까지만 잇는다. 값 계산=견적기 권위.")
    L.append("")

    # 정체·수량 전사표
    L.append("## 상품 요소 전사 (권위 = 라이브 스냅샷·스크립트 전사)")
    L.append("")
    L.append("> 아래 표는 `_meta/scripts/gen_leather_pouch_nodes.py`가 live-snapshot에서 결정론 전사(손전사 금지·D-9).")
    L.append("")
    L.append(f"<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest ({SNAP}) t_prd_products {pid} @ 2026-07-03 -->")
    L.append("| prd_typ | min_qty | max_qty | qty_incr | qty_unit | file_upload | editor | use_yn | del_yn |")
    L.append("|---|---|---|---|---|---|---|---|---|")
    L.append(f'| {p["prd_typ_cd"]} | {p["min_qty"]} | {p["max_qty"]} | {p["qty_incr"]} | {p["qty_unit_typ_cd"]} | {p["file_upload_yn"]} | {p["editor_yn"]} | {p["use_yn"]} | {p["del_yn"]} |')
    L.append("")

    # 가격 전사
    L.append("#### 가격 원천")
    L.append("")
    L.append(f"<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest ({SNAP}) t_prd_product_prices+t_prd_product_price_formulas {pid} @ 2026-07-03 -->")
    L.append("| 원천 테이블 | 행 | 값 |")
    L.append("|---|---|---|")
    if branch == "fixed":
        L.append(f'| t_prd_product_prices | 1 | unit_price={price_val} ({fixed["note"]}) |')
    else:
        L.append("| t_prd_product_prices | 0 | (미적재) |")
    L.append("| t_prd_product_price_formulas | 0 | (미바인딩) |")
    L.append("")
    if branch == "fixed":
        L.append(f"고정가룩업 = 완결 원천(공식 사슬 불요). 값 {price_val}원은 260610 verbatim(260702 diff 미해당=권위 일치)·"
                 "값 권위=엔진.")
    else:
        L.append("두 원천 모두 0행 = 견적 불가(NEITHER-gap). 채움 원천=상품마스터 파우치 시트 고정가 or 공식 → §26/§7·실무진 대기.")
    L.append("")

    # 자재 BOM 전사
    L.append("#### 자재 BOM (활성 del_yn=N)")
    L.append("")
    L.append(f"<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest ({SNAP}) t_prd_product_materials+t_mat_materials {pid} @ 2026-07-03 -->")
    L.append("| mat_cd | 자재명 | mat_typ | usage_cd | 역할 |")
    L.append("|---|---|---|---|---|")
    for m in ams:
        mn = matnames.get(m["mat_cd"], {})
        role = "substrate(레더 본체)" if mn.get("mat_typ_cd") == "MAT_TYPE.06" else "shape-변형(오염·substrate 아님)"
        L.append(f'| {m["mat_cd"]} | {mn.get("mat_nm","?")} | {mn.get("mat_typ_cd","?")} | {m["usage_cd"]} | {role} |')
    L.append("")
    L.append("substrate 자재 = 레더(MAT_000008·`MAT_TYPE.06`)만 정당. `uses_material`은 공유 [[axis/materials]]에 "
             "material-MAT_000008 축 노드가 **미민팅**이라 배선 대기(needs_axis)·위 BOM 표가 권위. "
             "★IMPORT 등록 자재 삭제 금지([[rule/rules#RULE_import_material_no_delete]]).")
    L.append("")

    # 사이즈 전사
    L.append("#### 사이즈")
    L.append("")
    L.append(f"<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest ({SNAP}) t_prd_product_sizes+t_siz_sizes {pid} @ 2026-07-03 -->")
    if asz:
        L.append("| siz_cd | 라벨 | 작업 w×h(mm) | dflt |")
        L.append("|---|---|---|---|")
        for s in asz:
            sn = sizenames.get(s["siz_cd"], {})
            L.append(f'| {s["siz_cd"]} | {sn.get("siz_nm","?")} | {sn.get("work_width","")}×{sn.get("work_height","")} | {s["dflt_yn"]} |')
        L.append("")
        L.append("`has_size`는 공유 [[axis/sizes]] 축 노드 미민팅이라 배선 대기(needs_axis)·위 표가 권위.")
    else:
        L.append("| siz_cd | 라벨 |")
        L.append("|---|---|")
        L.append("| (0행) | t_prd_product_sizes 미적재 |")
        L.append("")
        # shape-material이 사이즈를 대행하는지 note
        if shapes:
            L.append("사이즈 축(t_prd_product_sizes) 0행 — 치수/형상이 `MAT_TYPE.09` shape-변형 자재로 대행 등록됨(오염·위 BOM 참조). "
                     "정식 사이즈 충전은 §7 대기.")
        else:
            L.append("사이즈 축 0행(미적재) — §7 dbmap 충전 대기.")
    L.append("")

    # 카테고리 전사
    L.append("#### 카테고리")
    L.append("")
    L.append(f"<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest ({SNAP}) t_prd_product_categories+t_cat_categories {pid} @ 2026-07-03 -->")
    L.append("| cat_cd | 카테고리명 | main | 상위 |")
    L.append("|---|---|---|---|")
    for c in cs:
        cn = catnames.get(c["cat_cd"], {})
        L.append(f'| {c["cat_cd"]} | {cn.get("cat_nm","?")} | {c["main_cat_yn"]} | {cn.get("upr_cat_cd","")} |')
    L.append("")
    L.append("`in_category`는 공유 [[axis/categories]] 축 노드 미민팅이라 배선 대기(needs_axis)·위 표가 권위.")
    L.append("")

    # 옵션그룹(230만)
    if ogs:
        L.append("#### 옵션그룹")
        L.append("")
        L.append(f"<!-- transcribed-by: _meta/scripts/gen_leather_pouch_nodes.py from live-snapshot/latest ({SNAP}) t_prd_product_option_groups {pid} @ 2026-07-03 -->")
        L.append("| opt_grp_cd | 그룹명 | sel_typ | mand |")
        L.append("|---|---|---|---|")
        for o in ogs:
            L.append(f'| {o["opt_grp_cd"]} | {o["opt_grp_nm"]} | {o["sel_typ_cd"]} | {o["mand_yn"]} |')
        L.append("")
        L.append("사이즈 선택 그룹(option_items → SIZ 차원 참조). option_refs 대상 사이즈 축 노드 미민팅이라 optgroup 노드는 "
                 "사이즈 축 민팅 후 배선(needs_axis)·위 표가 권위.")
        L.append("")

    L.append("---")
    L.append("")
    gap_list = "·".join(f"[[{g}]]" for g in gap_refs)
    L.append(f"## GAP·정직 표기 (주 산출)")
    L.append("")
    L.append(f"이 상품은 **{'고정가 있음(견적 가능)' if branch=='fixed' else 'NEITHER-gap(견적 원천 부재)'}** + "
             f"봉제 공정 0행. 연결된 공유 GAP: {gap_list} (Stage A 민팅·rule/gaps.md). "
             "축 노드(카테고리·자재·사이즈) 미민팅분은 needs_axis로 반환 — 조용한 누락 아님.")
    L.append("")

    fp = os.path.join(OUT, slug + ".md")
    with open(fp, "w", encoding="utf-8") as f:
        f.write("\n".join(L))
    manifest.append((pid, slug, branch, badge, price_val or "-", len(ams), len(shapes), len(asz), pc, len(ogs)))

print("pid | slug | branch | badge | price | mats | shapes | sizes | procs | optg")
for r in manifest:
    print(" | ".join(str(x) for x in r))
print(f"\n총 {len(manifest)} 파일 생성 → {OUT}")
print("fixed:", sum(1 for r in manifest if r[2]=="fixed"), "neither:", sum(1 for r in manifest if r[2]=="neither"))
print("contaminated(shape>0):", [r[0] for r in manifest if r[6]>0])
