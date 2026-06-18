#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""MAP × 데이터시트 × 라이브 DB 3원 매칭 + 출시상태 3분류 — round-24 1단계.
산출: matching.csv, release-status.csv, _meta/alias-dict.csv, unmatched_*.csv
매칭 = 정규화명 완전일치(1차) → 부분일치(2차, 후보) → 미매칭.
출시상태: ❌부재(시트0 AND 라이브0) / 🟡옵션부족(존재하나 opt|price 결손) / ✅완비.
"""
import csv, os, unicodedata, re
from collections import defaultdict, Counter

BASE = "_workspace/huni-dbmap/35_category-map"
LIVE = f"{BASE}/_live"

def rd(path, enc="utf-8-sig"):
    with open(path, encoding=enc) as f:
        return list(csv.DictReader(f))

def rd_tsv(path):
    rows = []
    with open(path, encoding="utf-8") as f:
        for line in f:
            rows.append(line.rstrip("\n").split("\t"))
    return rows

def nstrip(s):
    if not s: return ""
    s = unicodedata.normalize("NFC", str(s)).strip()
    return re.sub(r"[\s/\-_(),.·／]", "", s)

# ---- load ----
map_entries = rd(f"{BASE}/map-entries.csv")
sheet_prods = rd(f"{LIVE}/sheet_products.csv")
live_raw = rd_tsv(f"{LIVE}/products_live.tsv")
# products_live cols: prd_cd prd_nm prd_typ use_yn del_yn opt_n frm_n priced cats
live = []
for r in live_raw:
    if len(r) < 9: continue
    live.append({
        "prd_cd": r[0], "prd_nm": r[1], "prd_typ": r[2], "use_yn": r[3],
        "del_yn": r[4], "opt_n": int(r[5] or 0), "frm_n": int(r[6] or 0),
        "priced": r[7] == "1", "cats": r[8], "norm": nstrip(r[1]),
    })

# index live & sheet by norm
live_by_norm = defaultdict(list)
for l in live:
    live_by_norm[l["norm"]].append(l)
sheet_by_norm = defaultdict(list)
for s in sheet_prods:
    sheet_by_norm[s["norm"]].append(s)

def find_match(norm_name, index):
    """완전→부분(포함) 매칭. 반환 (grade, list)."""
    if not norm_name:
        return ("none", [])
    if norm_name in index:
        return ("exact", index[norm_name])
    # 부분: norm_name이 후보를 포함하거나 후보가 norm_name을 포함
    cands = []
    for k, v in index.items():
        if not k: continue
        if norm_name == k:
            continue
        if norm_name in k or k in norm_name:
            cands.extend(v)
    if cands:
        return ("partial", cands)
    return ("none", [])

# ---- match MAP products only (sections/aliases handled separately) ----
matching_rows = []
matched_sheet_norms = set()
matched_live_cds = set()
alias_rows = []

for e in map_entries:
    if e["type"] == "section":
        matching_rows.append({**e, "sheet_grade":"-","sheet_match":"➖N/A(section)",
                              "live_grade":"-","live_prd_cd":"","live_opt_n":"",
                              "live_priced":"","status":"➖N/A","reason":"섹션 헤더(비상품)"})
        continue
    if e["type"] == "alias":
        # 별칭: 본체 카테고리 추적 시도(정규화 매칭으로 라이브 존재 여부만 표기)
        sg, sm = find_match(e["norm"], sheet_by_norm)
        lg, lm = find_match(e["norm"], live_by_norm)
        alias_rows.append({**e,
            "resolves_to_sheet": sm[0]["prd_nm"] if sm else "",
            "resolves_to_live": lm[0]["prd_cd"] if lm else "",
            "live_exists": "Y" if lm else "N"})
        matching_rows.append({**e, "sheet_grade":sg,
                              "sheet_match": sm[0]["prd_nm"] if sm else "",
                              "live_grade":lg, "live_prd_cd": lm[0]["prd_cd"] if lm else "",
                              "live_opt_n":"", "live_priced":"",
                              "status":"◆교차참조","reason":"별칭(→) — 본체 타 카테고리"})
        continue
    # product
    sg, sm = find_match(e["norm"], sheet_by_norm)
    lg, lm = find_match(e["norm"], live_by_norm)
    if sm: matched_sheet_norms.add(e["norm"])
    if lm:
        for x in lm: matched_live_cds.add(x["prd_cd"])
    # release status
    has_sheet = bool(sm)
    has_live = bool(lm)
    if not has_sheet and not has_live:
        status, reason = "❌미출시", "데이터시트 0 AND 라이브 0"
        lopt = lpriced = ""
    else:
        # pick best live (exact preferred, with opt+price)
        lpick = None
        if lm:
            exact = [x for x in lm if x["norm"] == e["norm"]]
            pool = exact if exact else lm
            # prefer one with opt and price
            pool_sorted = sorted(pool, key=lambda x: (x["priced"], x["opt_n"]>0), reverse=True)
            lpick = pool_sorted[0]
        if lpick:
            lopt = lpick["opt_n"]; lpriced = "Y" if lpick["priced"] else "N"
            complete = lpick["opt_n"] > 0 and lpick["priced"]
            if complete:
                status, reason = "✅정상등록가능", f"라이브 opt={lpick['opt_n']}·price사슬=Y"
            else:
                missing = []
                if lpick["opt_n"] == 0: missing.append("옵션0")
                if not lpick["priced"]: missing.append("가격사슬X")
                status, reason = "🟡신규출시", f"라이브 존재({lpick['prd_cd']})·결손:{'/'.join(missing)}"
        else:
            # sheet exists but no live product
            lopt = lpriced = ""
            status, reason = "🟡신규출시", "데이터시트 존재·라이브 상품 미적재"
    matching_rows.append({**e, "sheet_grade":sg,
        "sheet_match": (sm[0]["sheet_label"]+":"+sm[0]["prd_nm"]) if sm else "",
        "live_grade":lg, "live_prd_cd": lpick["prd_cd"] if (has_live and lpick) else "",
        "live_opt_n":lopt, "live_priced":lpriced, "status":status, "reason":reason})

# ---- write matching.csv ----
fields = ["category","cell","col","row","type","raw","norm","sheet_grade","sheet_match",
          "live_grade","live_prd_cd","live_opt_n","live_priced","status","reason"]
with open(f"{BASE}/matching.csv","w",newline="",encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=fields); w.writeheader()
    for r in matching_rows:
        w.writerow({k: r.get(k,"") for k in fields})

# ---- release-status.csv (products only) ----
rel_fields = ["category","cell","raw","norm","status","reason","sheet_match",
              "live_prd_cd","live_opt_n","live_priced","routing"]
def routing(r):
    if r["status"] == "🟡신규출시":
        rt = []
        if r.get("live_opt_n") in ("0","") and "옵션" in r["reason"]: rt.append("round-6 CPQ(옵션)")
        if r.get("live_priced") == "N" or "가격" in r["reason"]: rt.append("round-16/18 가격")
        if "미적재" in r["reason"]: rt.append("round-5 적재")
        return "; ".join(rt) or "검토"
    if r["status"] == "❌미출시": return "신규 상품 정의 필요(부재)"
    return ""
with open(f"{BASE}/release-status.csv","w",newline="",encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=rel_fields); w.writeheader()
    for r in matching_rows:
        if r["type"] != "product": continue
        w.writerow({"category":r["category"],"cell":r["cell"],"raw":r["raw"],"norm":r["norm"],
                    "status":r["status"],"reason":r["reason"],"sheet_match":r["sheet_match"],
                    "live_prd_cd":r["live_prd_cd"],"live_opt_n":r["live_opt_n"],
                    "live_priced":r["live_priced"],"routing":routing(r)})

# ---- alias dict ----
os.makedirs(f"{BASE}/_meta", exist_ok=True)
with open(f"{BASE}/_meta/alias-dict.csv","w",newline="",encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=["category","cell","raw","norm","resolves_to_sheet","resolves_to_live","live_exists"], extrasaction="ignore")
    w.writeheader(); w.writerows(alias_rows)

# ---- Sheet-only board (data-sheet products not matched by any MAP product) ----
map_prod_norms = set(e["norm"] for e in map_entries if e["type"]=="product")
# also include alias norms (they ARE in MAP, just cross-ref)
map_all_norms = set(e["norm"] for e in map_entries if e["type"] in ("product","alias"))
sheet_only = []
for s in sheet_prods:
    n = s["norm"]
    matched = (n in map_all_norms) or any((n in m or m in n) for m in map_all_norms if m)
    if not matched:
        sheet_only.append(s)
with open(f"{BASE}/_live/sheet_only.csv","w",newline="",encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=["sheet","sheet_label","prd_nm","norm","first_row"])
    w.writeheader(); w.writerows(sheet_only)

# live-only (live products not matched by any MAP entry)
live_only = []
for l in live:
    n = l["norm"]
    matched = (n in map_all_norms) or any((n in m or m in n) for m in map_all_norms if m)
    if not matched:
        live_only.append(l)
with open(f"{BASE}/_live/live_only.csv","w",newline="",encoding="utf-8-sig") as f:
    w = csv.DictWriter(f, fieldnames=["prd_cd","prd_nm","prd_typ","cats","opt_n","frm_n"])
    w.writeheader()
    for l in live_only:
        w.writerow({"prd_cd":l["prd_cd"],"prd_nm":l["prd_nm"],"prd_typ":l["prd_typ"],
                    "cats":l["cats"],"opt_n":l["opt_n"],"frm_n":l["frm_n"]})

# ---- summary ----
prod_rows = [r for r in matching_rows if r["type"]=="product"]
print("=== RELEASE STATUS by category ===")
cats = sorted(set(r["category"] for r in prod_rows))
hdr = f"{'category':14} {'tot':>4} {'OK':>4} {'NEW':>4} {'NONE':>5}"
print(hdr)
tot=Counter()
for c in cats:
    sub=[r for r in prod_rows if r["category"]==c]
    sc=Counter(r["status"] for r in sub)
    ok=sc.get("✅정상등록가능",0); new=sc.get("🟡신규출시",0); none=sc.get("❌미출시",0)
    tot["ok"]+=ok; tot["new"]+=new; tot["none"]+=none; tot["tot"]+=len(sub)
    print(f"{c:14} {len(sub):>4} {ok:>4} {new:>4} {none:>5}")
print(f"{'TOTAL':14} {tot['tot']:>4} {tot['ok']:>4} {tot['new']:>4} {tot['none']:>5}")
alias_n = len([r for r in matching_rows if r['type']=='alias'])
sect_n = len([r for r in matching_rows if r['type']=='section'])
print(f"\naliases(◆): {alias_n}   sections(➖): {sect_n}")
print(f"sheet-only: {len(sheet_only)}   live-only: {len(live_only)}")

if __name__ == "__main__":
    pass
