#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
round-24 2단계 — Layer B 상품 귀속 빌드 (dbm-category-mapper).
[round-24 검증 보정 반영: D-1 PK dedupe·main_cat_yn 단일성, D-2 del='Y' 노드 귀속 가드, D-5 라이브 재추출 카운트]
입력(1단계 산출, 재유도 금지):
  - release-status.csv          : MAP product 244건 (category·status·prd_cd)  [D-3/D-4 보정 반영]
  - _live/categories_live.tsv   : 라이브 카테고리 트리 (del_yn 권위, 재추출본)
  - _live/products_live.tsv     : 라이브 상품(재추출본)
  - _meta/alias-dict.csv        : 별칭 20건(다중분류·명명변형)
산출: product-cat.csv  — junction t_prd_product_categories(prd_cd, cat_cd, main_cat_yn) 적재 명세.
DB 미적재 — 매핑 명세 산출만.
"""
import csv, os, unicodedata, re
from collections import Counter, defaultdict

BASE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

def norm(s):
    s = unicodedata.normalize("NFC", s or "")
    return re.sub(r"[\s()/\-_,.·]", "", s)

def is_under(cats, cat_cd, ancestor):
    seen = set(); c = cat_cd
    while c and c in cats and c not in seen:
        if c == ancestor: return True
        seen.add(c); c = cats[c][1]
    return False

# --- 1) 라이브 카테고리 트리 (del_yn='N' = 활성 노드) ---
cats = {}            # cat_cd -> (nm, parent, level, use_yn, del_yn)
nm2cat_live = {}     # norm(nm) -> [cat_cd] (del_yn='N' 만 — D-2 가드)
with open(os.path.join(BASE, "_live", "categories_live.tsv"), encoding="utf-8") as f:
    for r in csv.reader(f, delimiter="\t"):
        if len(r) < 6: continue
        cat_cd, nm, parent, lvl, use_yn, del_yn = r[:6]
        cats[cat_cd] = (nm, parent, lvl, use_yn, del_yn)
        if del_yn == "N":
            nm2cat_live.setdefault(norm(nm), []).append(cat_cd)

MAP_L1 = {
    "01 엽서": "CAT_000001", "02 스티커": "CAT_000002", "03 인쇄홍보물": "CAT_000003",
    "04 포스터": "CAT_000004", "05 사인": "CAT_000005", "06 책자": "CAT_000006",
    "07 캘린더": "CAT_000007", "08 문구": "CAT_000008", "09 아크릴": "CAT_000009",
    "10 라이프": "CAT_000010", "11 에코백": "CAT_000011", "12 포장": "CAT_000012",
}

# --- 2) 라이브 상품 현재 귀속(path가 있으면) ---
prd_nm = {}
with open(os.path.join(BASE, "_live", "products_live.tsv"), encoding="utf-8") as f:
    for r in csv.reader(f, delimiter="\t"):
        if len(r) < 2: continue
        prd_nm[r[0]] = r[1]

# --- 3) release-status 조인 → 본체 귀속 행(main_cat_yn='Y') ---
STAT = {"✅정상등록가능": "GREEN", "🟡신규출시": "YELLOW", "❌미출시": "RED"}
body = []   # 본체(대표 카테고리) 후보
for_each_status = Counter()
with open(os.path.join(BASE, "release-status.csv"), encoding="utf-8-sig") as f:
    for row in csv.DictReader(f):
        mapcat, raw, status = row["category"], row["raw"], row["status"]
        prd, opt, priced = row["live_prd_cd"], row["live_opt_n"], row["live_priced"]
        st = STAT.get(status, "?"); for_each_status[st] += 1
        l1 = MAP_L1.get(mapcat, "?")
        nrm = norm(raw)
        target, match_lvl = "", "L1직속"
        # D-2 가드: nm2cat_live는 del='N'만 담으므로 del='Y' 노드는 후보에 안 들어옴
        if nrm in nm2cat_live:
            cands = [c for c in nm2cat_live[nrm] if is_under(cats, c, l1)]
            if cands:
                target = cands[0]; match_lvl = "L%s노드일치" % cats[target][2]
        cat_cd = target or l1   # 귀속 cat_cd = 노드일치 우선, 없으면 L1직속
        body.append({
            "prd_cd": prd, "prd_nm": raw, "map_category": mapcat, "status": st,
            "cat_cd": cat_cd, "cat_nm": cats.get(cat_cd, ("",))[0],
            "main_cat_yn": "Y", "match_level": match_lvl,
            "live_opt_n": opt, "live_priced": priced,
            "multi_class": "", "note": "",
        })

# --- 4) alias-dict 다중분류 (본체 prd를 추가 카테고리에 노출·main_cat_yn='N') ---
alias = []
seen_alias = set()  # (prd_cd, l1) dedupe — D-1 (J28/J40 PRD_000157 중복 제거)
with open(os.path.join(BASE, "_meta", "alias-dict.csv"), encoding="utf-8-sig") as f:
    for a in csv.DictReader(f):
        if a.get("live_exists") != "Y" or not a.get("resolves_to_live"): continue
        mapcat = a["category"]; prd = a["resolves_to_live"]
        l1 = MAP_L1.get(mapcat, "?")
        key = (prd, l1)
        if key in seen_alias:   # D-1: 동일 (prd_cd, cat_cd) 별칭 중복 스킵
            continue
        seen_alias.add(key)
        alias.append({
            "prd_cd": prd, "prd_nm": prd_nm.get(prd, a.get("norm", "")),
            "map_category": mapcat, "status": "ALIAS(다중분류)",
            "cat_cd": l1, "cat_nm": cats.get(l1, ("",))[0],
            "main_cat_yn": "N", "match_level": "L1직속(별칭노출)",
            "live_opt_n": "", "live_priced": "",
            "multi_class": "Y",
            "note": "별칭: 본체 %s를 %s에 추가 노출(중복상품 생성 금지)" % (prd, mapcat),
        })

# --- 5) D-1 통합 dedupe: (prd_cd, cat_cd) PK 충돌 제거 + main_cat_yn 단일성 ---
# 본체+별칭을 합쳐 (prd_cd,cat_cd) 키로 dedupe. 같은 키면 main='Y'(본체) 우선 보존.
all_rows = body + alias
by_pk = {}            # (prd_cd, cat_cd) -> row  (prd_cd 공백=미적재는 dedupe 제외)
unloadable = []       # prd_cd 공백(❌ 미적재): junction 적재 대상 아님(노드 예약만)
for r in all_rows:
    if not r["prd_cd"]:
        unloadable.append(r); continue
    pk = (r["prd_cd"], r["cat_cd"])
    if pk not in by_pk:
        by_pk[pk] = r
    else:
        # 충돌: main='Y'(본체)를 우선, 둘 다 main='Y'면 첫 행 유지(셀 중복)
        keep = by_pk[pk]
        if keep["main_cat_yn"] == "N" and r["main_cat_yn"] == "Y":
            by_pk[pk] = r
        # 그 외(둘 다 본체=동일셀중복, 또는 keep이 본체) → 첫 행 유지, 추가행 폐기

# main_cat_yn 단일성: prd_cd당 main='Y' 정확히 1행 — 위반 시 첫 본체만 'Y'
main_by_prd = defaultdict(list)
for r in by_pk.values():
    if r["main_cat_yn"] == "Y": main_by_prd[r["prd_cd"]].append(r)
for prd, rs in main_by_prd.items():
    if len(rs) > 1:
        for extra in rs[1:]:
            extra["main_cat_yn"] = "N"
            extra["note"] = (extra["note"] + " | " if extra["note"] else "") + "D-1: 본체 다중귀속→대표 1행만 main='Y', 나머지 강등"

dedup = list(by_pk.values())

# --- 6) 출력 ---
out = os.path.join(BASE, "product-cat.csv")
cols = ["prd_cd","prd_nm","map_category","status","cat_cd","cat_nm","main_cat_yn",
        "match_level","live_opt_n","live_priced","multi_class","note"]
with open(out, "w", encoding="utf-8-sig", newline="") as f:
    w = csv.DictWriter(f, fieldnames=cols); w.writeheader()
    # 적재 대상(dedup) + 미적재(노드예약, prd_cd 공백) 모두 기록(미적재는 cat_cd만 예약)
    for r in sorted(dedup, key=lambda x:(x["prd_cd"], x["cat_cd"])):
        w.writerow({k: r.get(k,"") for k in cols})
    for r in unloadable:
        w.writerow({k: r.get(k,"") for k in cols})

# --- 7) 검증 카운트 ---
pk_set = Counter((r["prd_cd"], r["cat_cd"]) for r in dedup)
pk_dups = {k:v for k,v in pk_set.items() if v>1}
main_dup = {p:len(rs) for p,rs in main_by_prd.items() if len([x for x in dedup if x["prd_cd"]==p and x["main_cat_yn"]=="Y"])>1}
# del='Y' 노드 귀속 0 확인
delY = [r for r in dedup if cats.get(r["cat_cd"], ("","","","","N"))[4] == "Y"]

print("=== product-cat.csv (보정본) ===")
print("적재 대상 junction 행:", len(dedup), "| 미적재(노드예약):", len(unloadable))
print("본체 status:", dict(for_each_status))
print("다중분류(main='N') 행:", sum(1 for r in dedup if r["main_cat_yn"]=="N"))
print("distinct prd_cd:", len({r["prd_cd"] for r in dedup}))
print("--- 게이트 ---")
print("[V4] (prd_cd,cat_cd) PK 충돌:", len(pk_dups), "(목표 0)")
print("[V4] main_cat_yn 단일성 위반 prd:", len(main_dup), "(목표 0)")
print("[V3] del='Y' 노드 귀속:", len(delY), "(목표 0)")
if pk_dups: print("  남은 충돌:", pk_dups)
if delY: print("  del=Y 귀속:", [(r["prd_cd"],r["cat_cd"]) for r in delY])
