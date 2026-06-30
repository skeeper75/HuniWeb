#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""항목 단위 BOM enrich — product-details-final.json에 component_bom·price_bom 추가.
출처: 라이브 스냅샷(live-snapshot/latest) actual + conformance-checklist/formula expected."""
import csv, json, os, collections

ROOT = "/Users/innojini/Dev/HuniWeb"
SNAP = f"{ROOT}/_workspace/_foundation/live-snapshot/latest"
CONF = f"{ROOT}/_workspace/huni-catalog-conformance/01_authority/conformance-checklist.csv"
PFM  = f"{ROOT}/_workspace/_foundation/price-formula-master.csv"
PDF  = f"{ROOT}/_workspace/huni-product-readiness/05_gate/product-details-final.json"
OUT2 = f"{ROOT}/_workspace/huni-product-readiness/02_readiness/product-details.json"

def load(name):
    with open(f"{SNAP}/{name}.csv", encoding="utf-8") as f:
        return list(csv.DictReader(f))

def alive(rows):
    return [r for r in rows if r.get("del_yn","N") != "Y"]

mat_nm  = {r["mat_cd"]: r["mat_nm"] for r in load("t_mat_materials")}
proc_nm = {r["proc_cd"]: r["proc_nm"] for r in load("t_proc_processes")}
siz_nm  = {r["siz_cd"]: r["siz_nm"] for r in load("t_siz_sizes")}
clr_nm  = {r["clr_cd"]: r["clr_nm"] for r in load("t_clr_color_counts")}
popt_nm = {r["print_opt_cd"]: r["print_opt_nm"] for r in load("t_prt_print_options")}

pc_meta = {}
for r in load("t_prc_price_components"):
    try: dims = json.loads(r["use_dims"]) if r["use_dims"] else []
    except Exception: dims = []
    pc_meta[r["comp_cd"]] = {"nm": r["comp_nm"], "prc_typ": r["prc_typ_cd"],
                             "dims": dims, "del_yn": r.get("del_yn","N")}

frm_meta = {r["frm_cd"]: {"nm": r["frm_nm"], "use_yn": r["use_yn"]} for r in load("t_prc_price_formulas")}
frm_comps = collections.defaultdict(list)
for r in sorted(load("t_prc_formula_components"), key=lambda x:(x["frm_cd"], int(x["disp_seq"] or 0))):
    frm_comps[r["frm_cd"]].append({"comp_cd": r["comp_cd"], "addtn": r.get("addtn_yn","N"), "seq": r["disp_seq"]})

cp_by_comp = collections.defaultdict(list)
for r in load("t_prc_component_prices"):
    cp_by_comp[r["comp_cd"]].append(r)

prd_frm = collections.defaultdict(list)
for r in load("t_prd_product_price_formulas"):
    prd_frm[r["prd_cd"]].append(r["frm_cd"])

# 직접단가(가격포함) 모델 — t_prd_product_prices 적재분
prd_direct = {r["prd_cd"]: r["unit_price"] for r in load("t_prd_product_prices")}

prd_mat = collections.defaultdict(list)
for r in alive(load("t_prd_product_materials")):
    prd_mat[r["prd_cd"]].append((r["mat_cd"], r.get("dflt_yn","N")))
prd_proc = collections.defaultdict(list)
for r in alive(load("t_prd_product_processes")):
    prd_proc[r["prd_cd"]].append(r["proc_cd"])
prd_siz = collections.defaultdict(list)
for r in alive(load("t_prd_product_sizes")):
    prd_siz[r["prd_cd"]].append((r["siz_cd"], r.get("dflt_yn","N")))
prd_popt = collections.defaultdict(list)
for r in alive(load("t_prd_product_print_options")):
    prd_popt[r["prd_cd"]].append(r)
prd_plate = collections.defaultdict(list)
for r in alive(load("t_prd_product_plate_sizes")):
    prd_plate[r["prd_cd"]].append(r["siz_cd"])  # plate size stored as siz_cd; matches cp.plt_siz_cd
prd_opt = collections.defaultdict(list)
for r in alive(load("t_prd_product_options")):
    prd_opt[r["prd_cd"]].append(r)

conf = collections.defaultdict(dict)
with open(CONF, encoding="utf-8") as f:
    for r in csv.DictReader(f):
        conf[r["prd_cd"]][r["axis"]] = (r["needed"], r.get("note",""))

pfm = {}
with open(PFM, encoding="utf-8") as f:
    for r in csv.DictReader(f):
        pfm[r["prd_cd"]] = r

def cp_matches(row, prd):
    # proc_cd 제외: 인쇄/코팅 comp의 proc_cd는 인쇄공정(PROC_000004 등)으로
    # product_processes(접지/타공 등 후가공)에 없음 → 매칭에 쓰면 false negative.
    msz = set(s for s,_ in prd_siz[prd])
    mmt = set(m for m,_ in prd_mat[prd])
    mpo = set(r["print_opt_cd"] for r in prd_popt[prd] if r.get("print_opt_cd"))
    mpl = set(prd_plate[prd])
    if row.get("siz_cd") and msz and row["siz_cd"] not in msz: return False
    if row.get("mat_cd") and mmt and row["mat_cd"] not in mmt: return False
    if row.get("print_opt_cd") and mpo and row["print_opt_cd"] not in mpo: return False
    if row.get("plt_siz_cd") and mpl and row["plt_siz_cd"] not in mpl: return False
    return True

def build_price_bom(prd):
    frms = prd_frm.get(prd, [])
    reasons = []
    if not frms:
        hint = pfm.get(prd, {})
        cm = hint.get("calc_method",""); st = hint.get("status",""); gap = hint.get("gap_note","")
        # 직접단가(가격포함) 모델: t_prd_product_prices 적재분이면 견적 가능(공식 비대상)
        if prd in prd_direct:
            note = f"직접단가 적재(가격포함 모델·{prd_direct[prd]}원)"
            return {"formula": {"frm_cd": None, "status": "direct_price", "예상": "직접단가 or 공식",
                                "실제": note}, "formula_components": [], "price_components": [],
                    "견적0원인": []}
        reason_map = {
            "NA_NO_FORMULA":      ("비대상", "공식 비대상(기성/inline고정가·별도)"),
            "NEEDS_BASICS_FIRST": ("미바인딩", f"기초데이터 결손→공식 미바인딩({gap})"),
            "DESIGNED_NOT_LOADED":("미바인딩", f"§18 설계 있음·라이브 t_prc_* 미적재(민팅 대상)"),
            "LIVE_UNBOUND":       ("미바인딩", "설계됨≠적재됨(상품-공식 미바인딩)"),
            "DESIGN_BLOCKED":     ("미바인딩", f"설계 BLOCKED({gap})"),
        }
        cls, note = reason_map.get(st, ("미바인딩", "가격공식 미바인딩(상품-공식 배선 없음)"))
        reasons = [] if cls == "비대상" else [note + "→견적 불가"]
        return {"formula": {"frm_cd": None, "status": "missing" if cls!="비대상" else "n/a",
                            "예상": "상품-공식 바인딩", "실제": note, "pfm_status": st},
                "formula_components": [], "price_components": [], "견적0원인": reasons}
    frm = frms[0]
    fm = frm_meta.get(frm, {})
    fstat = "present"
    if not fm: fstat = "frm_부재"
    elif fm.get("use_yn") == "N": fstat = "use_yn=N"
    fcomps_out, pcomps_out = [], []
    for fc in frm_comps.get(frm, []):
        cc = fc["comp_cd"]; meta = pc_meta.get(cc)
        cnm = meta["nm"] if meta else cc
        fcomps_out.append({"comp_cd": cc, "name": cnm, "addtn": fc["addtn"],
                           "status": "present" if meta else "missing"})
        if not meta:
            pcomps_out.append({"comp_cd": cc, "name": cc, "단가행_적재셀수": 0,
                               "전역셀수": 0, "status": "missing", "근거": "price_component 부재"})
            reasons.append(f"{cc}: price_component 부재")
            continue
        rows = cp_by_comp.get(cc, [])
        glob = len(rows)
        match = sum(1 for r in rows if cp_matches(r, prd))
        if glob == 0:
            st = "단가행_전무"; reasons.append(f"{cnm}({cc}): 단가행 전무→견적0")
        elif match == 0:
            st = "차원_미스매치"
            if fc["addtn"] != "Y" or cc.startswith(("COMP_PRINT","COMP_PAPER")):
                reasons.append(f"{cnm}({cc}): 상품 차원에 맞는 단가행 0→견적0 위험")
        else:
            st = "present"
        if meta["del_yn"] == "Y" and st == "present":
            st = "del_yn"
        pcomps_out.append({"comp_cd": cc, "name": cnm, "prc_typ": meta["prc_typ"],
                           "use_dims": meta["dims"], "단가행_적재셀수": match, "전역셀수": glob,
                           "del_yn": meta["del_yn"], "status": st,
                           "근거": "component_prices 매칭"})
    # 전 구성요소 단가행 미매칭 가드: 합산할 셀이 하나도 없으면 견적0
    # (addtn=Y 완제품가 comp만 있는 고정가형에서 차원 미스매치 누락 방지·프리미엄명함류)
    priced = [p for p in pcomps_out if p["status"] in ("present", "del_yn")]
    if pcomps_out and not priced:
        miss_names = "·".join(p["name"] for p in pcomps_out[:3])
        msg = f"전 가격구성요소 단가행 미매칭({miss_names})→견적0(자재/차원에 맞는 완제품가/단가 없음)"
        if msg not in reasons:
            reasons.insert(0, msg)
    return {"formula": {"frm_cd": frm, "name": fm.get("nm", frm), "status": fstat,
                        "예상": "상품-공식 바인딩+formula_components", "실제": f"{frm} 바인딩"},
            "formula_components": fcomps_out, "price_components": pcomps_out,
            "견적0원인": reasons, "추가공식": frms[1:]}

def paper_mat_coverage(prd):
    frms = prd_frm.get(prd, [])
    covered = set(); has_mat_comp = False
    for frm in frms:
        for fc in frm_comps.get(frm, []):
            meta = pc_meta.get(fc["comp_cd"])
            if meta and "mat_cd" in meta["dims"]:
                has_mat_comp = True
                for r in cp_by_comp.get(fc["comp_cd"], []):
                    if r.get("mat_cd"): covered.add(r["mat_cd"])
    return has_mat_comp, covered

def axis_need(prd, axis_name):
    return conf.get(prd, {}).get(axis_name, ("?", ""))[0]

def build_component_bom(prd):
    out = []
    has_mat_comp, mat_cov = paper_mat_coverage(prd)
    items = []
    for mc, dflt in sorted(prd_mat[prd], key=lambda x:(x[1]!="Y", x[0])):
        st = "present"; gv = "product_materials 적재"
        if has_mat_comp and mat_cov and mc not in mat_cov:
            st = "price_gap"; gv = "자재 단가행(COMP_PAPER 등) 없음→선택 시 견적0"
        items.append({"code": mc, "name": mat_nm.get(mc, mc), "dflt": dflt, "status": st, "근거": gv})
    need = axis_need(prd, "자재")
    if need == "Y" and not items:
        items.append({"code": None, "name": None, "status": "missing", "근거": "축 needed=Y이나 라이브 미적재"})
    out.append({"axis": "자재", "needed": need, "actual_cnt": len(prd_mat[prd]), "items": items})
    items = [{"code": pc, "name": proc_nm.get(pc, pc), "status": "present", "근거": "product_processes 적재"}
             for pc in sorted(set(prd_proc[prd]))]
    need = axis_need(prd, "공정")
    if need == "Y" and not items:
        items.append({"code": None, "name": None, "status": "missing", "근거": "축 needed=Y이나 라이브 미적재"})
    out.append({"axis": "공정", "needed": need, "actual_cnt": len(set(prd_proc[prd])), "items": items})
    items = [{"code": sc, "name": siz_nm.get(sc, sc), "dflt": d, "status": "present", "근거": "product_sizes 적재"}
             for sc, d in sorted(prd_siz[prd], key=lambda x:(x[1]!="Y", x[0]))]
    need = axis_need(prd, "사이즈코드")
    if need == "Y" and not items:
        items.append({"code": None, "name": None, "status": "missing", "근거": "축 needed=Y이나 라이브 미적재"})
    out.append({"axis": "사이즈", "needed": need, "actual_cnt": len(prd_siz[prd]), "items": items})
    items = []
    for r in prd_popt[prd]:
        pcd = r.get("print_opt_cd",""); side = r.get("print_side","")
        fc = clr_nm.get(r.get("front_colrcnt_cd",""), r.get("front_colrcnt_cd",""))
        bc = clr_nm.get(r.get("back_colrcnt_cd",""), r.get("back_colrcnt_cd",""))
        nm = popt_nm.get(pcd, pcd) or f"{side} {fc}/{bc}"
        items.append({"code": pcd, "name": nm, "side": side, "front": fc, "back": bc,
                      "dflt": r.get("dflt_yn","N"), "status": "present", "근거": "product_print_options 적재"})
    need = axis_need(prd, "도수")
    if need == "Y" and not items:
        items.append({"code": None, "name": None, "status": "missing", "근거": "축 needed=Y이나 라이브 미적재(인쇄/도수)"})
    out.append({"axis": "도수", "needed": need, "actual_cnt": len(prd_popt[prd]), "items": items})
    items = [{"code": r["opt_cd"], "name": r.get("opt_nm", r["opt_cd"]), "grp": r.get("opt_grp_cd",""),
              "status": "present", "근거": "product_options 적재"} for r in prd_opt[prd]]
    need = axis_need(prd, "옵션그룹")
    out.append({"axis": "옵션", "needed": need, "actual_cnt": len(prd_opt[prd]), "items": items})
    return out

data = json.load(open(PDF, encoding="utf-8"))
n_priced0, n_matgap, n_axismiss = 0, 0, 0
priced0_list, matgap_list, axismiss_list = [], [], []
for obj in data:
    prd = obj["prd_cd"]
    cb = build_component_bom(prd)
    pb = build_price_bom(prd)
    obj["component_bom"] = cb
    obj["price_bom"] = pb
    obj["bom_method"] = "live-snapshot(20260630_0033)+conformance/formula expected"
    if pb["견적0원인"]:
        n_priced0 += 1; priced0_list.append((prd, obj["상품명"], obj["상품군"], obj["등급"], pb["견적0원인"][:3]))
    for ax in cb:
        if ax["axis"] == "자재":
            gaps = [it for it in ax["items"] if it.get("status") == "price_gap"]
            if gaps:
                n_matgap += 1
                matgap_list.append((prd, obj["상품명"], obj["상품군"], len(gaps),
                                    [g["name"] for g in gaps[:4]]))
        for it in ax["items"]:
            if it.get("status") == "missing":
                n_axismiss += 1
                axismiss_list.append((prd, obj["상품명"], obj["상품군"], ax["axis"]))

json.dump(data, open(PDF, "w", encoding="utf-8"), ensure_ascii=False, indent=1)
json.dump(data, open(OUT2, "w", encoding="utf-8"), ensure_ascii=False, indent=1)

# --- BOM 동반 리스트(기존 큐레이트 리스트 보존·BOM 항목단위 신규) ---
RD = f"{ROOT}/_workspace/huni-product-readiness/02_readiness"
def cls_of(reason):
    if "미적재(민팅" in reason: return "DESIGNED_NOT_LOADED"
    if "기초데이터 결손" in reason: return "NEEDS_BASICS_FIRST"
    if "설계됨≠적재됨" in reason: return "LIVE_UNBOUND"
    if "BLOCKED" in reason: return "DESIGN_BLOCKED"
    if "단가행 전무" in reason or "차원에 맞는 단가행" in reason or "price_component 부재" in reason: return "단가행/차원결손(공식바인딩됨)"
    return "기타미바인딩"
with open(f"{RD}/list-bom-priced-zero.csv","w",encoding="utf-8",newline="") as f:
    w=csv.writer(f); w.writerow(["prd_cd","상품명","상품군","등급","frm_cd","class","견적0원인"])
    for o in data:
        pb=o["price_bom"]
        if pb["견적0원인"]:
            w.writerow([o["prd_cd"],o["상품명"],o["상품군"],o["등급"],
                        pb["formula"].get("frm_cd") or "", cls_of(pb["견적0원인"][0]),
                        " | ".join(pb["견적0원인"])])
with open(f"{RD}/list-bom-axis-missing.csv","w",encoding="utf-8",newline="") as f:
    w=csv.writer(f); w.writerow(["prd_cd","상품명","상품군","등급","축","근거"])
    for o in data:
        for ax in o["component_bom"]:
            for it in ax["items"]:
                if it.get("status")=="missing":
                    w.writerow([o["prd_cd"],o["상품명"],o["상품군"],o["등급"],ax["axis"],it["근거"]])
with open(f"{RD}/list-bom-material-pricegap.csv","w",encoding="utf-8",newline="") as f:
    w=csv.writer(f); w.writerow(["prd_cd","상품명","상품군","등급","자재코드","자재명","근거"])
    for o in data:
        for ax in o["component_bom"]:
            if ax["axis"]=="자재":
                for it in ax["items"]:
                    if it.get("status")=="price_gap":
                        w.writerow([o["prd_cd"],o["상품명"],o["상품군"],o["등급"],it["code"],it["name"],it["근거"]])

print(f"enriched: {len(data)} products")
print(f"견적0원인 있는 상품: {n_priced0}")
print(f"자재 price_gap 상품: {n_matgap}")
print(f"축 missing 항목 수: {n_axismiss}")
print("\n=== 견적0 원인 상위 (등급포함) ===")
for prd, nm, grp, gr, rs in priced0_list[:40]:
    print(f"  {prd} {nm}({grp}/{gr}): {rs}")
print(f"\n=== 자재 price_gap 상위 ===")
for prd, nm, grp, c, gs in matgap_list[:20]:
    print(f"  {prd} {nm}({grp}): {c}건 {gs}")
print(f"\n=== 축 missing 상위 ===")
for prd, nm, grp, ax in axismiss_list[:25]:
    print(f"  {prd} {nm}({grp}): {ax}")
