#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
제작수량(필수) 규칙 추출 + 라이브 대조 + 채움 계획 산출 (결정론·읽기전용).

입력:
  - 권위 정규화 추출: _workspace/huni-dbmap/24_master-extract-260610/<sheet>-l1.csv
    (260702 diff에 제작수량 컬럼 변화 없음 확인 → 260610 재사용)
  - 가격표 최소구간 감사: _workspace/_foundation/batch/qty-rule-audit-260702.csv
  - 라이브 스냅샷(읽기전용 SELECT 덤프): _db/live-products.csv, _db/live-product-sizes.csv

출력:
  - authority-records.csv (권위 전수: 상품/사이즈 레벨)
  - fill-plan-products.csv
  - fill-plan-sizes.csv
  - unmatched.csv
실 적재 없음. SQL은 별도 스크립트에서 이 CSV로 생성.
"""
import csv, os, re, glob

BASE = os.path.dirname(os.path.abspath(__file__))
EXTRACT_DIR = os.path.abspath(os.path.join(BASE, "../../../huni-dbmap/24_master-extract-260610"))
AUDIT = os.path.abspath(os.path.join(BASE, "../qty-rule-audit-260702.csv"))
DB = os.path.join(BASE, "_db")

# 오늘 COMMIT 정합 완료분 — 건드리지 말 것
PROTECTED = {"PRD_000094", "PRD_000097", "PRD_000065"}

# 시트별 제작수량 컬럼명 (헤더 실측)
QTY_COLS = {
    "acrylic":        ("제작수량(필수)_최소", "제작수량(필수)_최대", "제작수량(필수)_증가"),
    "booklet":        ("제작수량(필수)_최소", "제작수량(필수)_최대", "제작수량(필수)_증가"),
    "calendar":       ("제작수량(필수)_최소", "제작수량(필수)_최대", "제작수량(필수)_증가"),
    "design-calendar":("제작수량(필수)_최소", "제작수량(필수)_최대", "제작수량(필수)_증가"),
    "digital-print":  ("제작수량(필수)_최소", "제작수량(필수)_최대", "제작수량(필수)_증가"),
    "goods-pouch":    ("제작수량(필수)_최소", "제작수량(필수)_최대", "제작수량(필수)_증가"),
    "stationery":     ("제작수량(필수)_최소", "제작수량(필수)_최대", "제작수량(필수)_증가"),
    "sticker":        ("제작수량(필수)_최소", "제작수량(필수)_최대", "제작수량(필수)_증가"),
    "photobook":      ("제작수량_최소", "제작수량_최대", "제작수량_증가"),
    "product-accessory": ("수량(필수)_최소", "수량(필수)_최대", "수량(필수)_증가"),
    # silsa/map/calc-formula-draft: 제작수량 컬럼 없음 → 제외
}
SIZE_COL = "사이즈(필수)"


def to_int(v):
    if v is None:
        return None
    v = str(v).strip()
    if v == "" or v.lower() == "nan":
        return None
    try:
        return int(round(float(v)))
    except ValueError:
        return None


def norm_size(label):
    """사이즈 라벨 정규화: 소문자·공백/mm 제거·괄호 안 치수 추출.
    'A6 (105 x 148 mm)' -> {'a6', '105x148'}, '100 x 150 mm' -> {'100x150'}"""
    if not label:
        return set()
    s = str(label).strip().lower()
    keys = set()
    # 괄호 안 치수
    m = re.findall(r"\(([^)]*)\)", s)
    inner = []
    for seg in m:
        inner.append(seg)
    # 괄호 제거한 바깥
    outer = re.sub(r"\([^)]*\)", " ", s)
    for cand in [s, outer] + inner:
        c = cand.replace("mm", "").replace(" ", "").replace("×", "x").replace("*", "x")
        c = c.strip("()").strip()
        if c:
            keys.add(c)
        # 순수 치수만 (WxH) 뽑기
        dm = re.search(r"(\d+)x(\d+)", c)
        if dm:
            keys.add(f"{dm.group(1)}x{dm.group(2)}")
    return {k for k in keys if k}


# ---------- 1. 권위 추출 ----------
authority = []  # dict rows
# 상품별: {prd_nm: {'sheet','prod':(mn,mx,inc), 'sizes':[(label,mn,mx,inc)]}}
prod_auth = {}

for sheet, (mc, xc, ic) in QTY_COLS.items():
    path = os.path.join(EXTRACT_DIR, f"{sheet}-l1.csv")
    if not os.path.exists(path):
        continue
    with open(path, encoding="utf-8-sig") as f:
        rows = list(csv.DictReader(f))
    # 상품 순서 보존
    order = []
    groups = {}
    for r in rows:
        p = (r.get("prd_nm") or "").strip()
        if not p:
            continue
        if p not in groups:
            groups[p] = []
            order.append(p)
        groups[p].append(r)
    for p in order:
        grp = groups[p]
        prod_level = None
        sizes = []
        for r in grp:
            mn, mx, inc = to_int(r.get(mc)), to_int(r.get(xc)), to_int(r.get(ic))
            has_qty = mn is not None or mx is not None or inc is not None
            label = (r.get(SIZE_COL) or "").strip() if SIZE_COL in r else ""
            if prod_level is None and has_qty:
                prod_level = (mn, mx, inc)
            if label and has_qty:
                sizes.append((label, mn, mx, inc))
        if prod_level is None and not sizes:
            continue
        prod_auth[p] = {"sheet": sheet, "prod": prod_level, "sizes": sizes}
        authority.append({"sheet": sheet, "prd_nm": p, "level": "PRODUCT",
                          "siz_label": "", "min": prod_level[0] if prod_level else "",
                          "max": prod_level[1] if prod_level else "",
                          "incr": prod_level[2] if prod_level else ""})
        for (label, mn, mx, inc) in sizes:
            authority.append({"sheet": sheet, "prd_nm": p, "level": "SIZE",
                              "siz_label": label, "min": mn if mn is not None else "",
                              "max": mx if mx is not None else "",
                              "incr": inc if inc is not None else ""})

with open(os.path.join(BASE, "authority-records.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["sheet", "prd_nm", "level", "siz_label", "min", "max", "incr"])
    w.writeheader()
    w.writerows(authority)

n_prod_lvl = sum(1 for a in authority if a["level"] == "PRODUCT")
n_size_lvl = sum(1 for a in authority if a["level"] == "SIZE")

# ---------- 2. 라이브 로드 ----------
live_products = {}       # prd_nm -> row  (JOIN KEY = prd_nm)
live_prod_by_cd = {}
dup_nm = set()
for r in csv.DictReader(open(os.path.join(DB, "live-products.csv"))):
    nm = r["prd_nm"].strip()
    if nm in live_products:
        dup_nm.add(nm)
    live_products[nm] = r
    live_prod_by_cd[r["prd_cd"]] = r

live_sizes = {}          # prd_cd -> [rows]
for r in csv.DictReader(open(os.path.join(DB, "live-product-sizes.csv"))):
    live_sizes.setdefault(r["prd_cd"], []).append(r)

# 감사(가격표 최소구간) — prd_cd 기준
audit = {}
for r in csv.DictReader(open(AUDIT)):
    audit[r["prd_cd"]] = r


def band_min(prd_cd):
    a = audit.get(prd_cd)
    if not a:
        return None
    v = a.get("strictest_band_min", "").strip()
    return to_int(v)


# ---------- 3. 상품 채움 계획 ----------
prod_plan = []
unmatched = []
for p, info in prod_auth.items():
    lv = live_products.get(p)
    if not lv:
        unmatched.append({"kind": "PRODUCT", "prd_nm": p, "siz_label": "",
                          "reason": "live t_prd_products prd_nm 언매치"})
        continue
    prd_cd = lv["prd_cd"]
    a_mn, a_mx, a_inc = info["prod"] if info["prod"] else (None, None, None)
    cur_mn, cur_mx, cur_inc, cur_df = (to_int(lv["min_qty"]), to_int(lv["max_qty"]),
                                       to_int(lv["qty_incr"]), to_int(lv["dflt_qty"]))
    bmin = band_min(prd_cd)
    prop_mn = a_mn
    band_note = ""
    if a_mn is not None and bmin is not None and a_mn < bmin:
        prop_mn = bmin
        band_note = f"권위min {a_mn} < 가격표최소구간 {bmin} → {bmin} 채택"
    prop_mx, prop_inc = a_mx, a_inc

    if prd_cd in PROTECTED:
        verdict = "PROTECTED"
    elif cur_mn is None and cur_mx is None and cur_inc is None:
        verdict = "FILL"
    else:
        # 현재값 존재
        if band_note:
            verdict = "BAND_CONFLICT"
        elif (cur_mn, cur_mx, cur_inc) == (prop_mn, prop_mx, prop_inc):
            verdict = "OK"
        else:
            verdict = "MISMATCH"
    if band_note and verdict == "FILL":
        verdict = "BAND_CONFLICT"
    prod_plan.append({
        "prd_cd": prd_cd, "prd_nm": p, "sheet": info["sheet"],
        "cur_min": cur_mn if cur_mn is not None else "", "cur_max": cur_mx if cur_mx is not None else "",
        "cur_incr": cur_inc if cur_inc is not None else "", "cur_dflt": cur_df if cur_df is not None else "",
        "auth_min": a_mn if a_mn is not None else "", "auth_max": a_mx if a_mx is not None else "",
        "auth_incr": a_inc if a_inc is not None else "",
        "band_min": bmin if bmin is not None else "",
        "prop_min": prop_mn if prop_mn is not None else "", "prop_max": prop_mx if prop_mx is not None else "",
        "prop_incr": prop_inc if prop_inc is not None else "",
        "prop_dflt": "",  # mint 금지 — UI가 min을 기본값으로 사용
        "verdict": verdict, "note": band_note,
    })

with open(os.path.join(BASE, "fill-plan-products.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["prd_cd", "prd_nm", "sheet", "cur_min", "cur_max", "cur_incr",
                                      "cur_dflt", "auth_min", "auth_max", "auth_incr", "band_min",
                                      "prop_min", "prop_max", "prop_incr", "prop_dflt", "verdict", "note"])
    w.writeheader()
    w.writerows(prod_plan)

# ---------- 4. 사이즈 채움 계획 ----------
size_plan = []
for p, info in prod_auth.items():
    if not info["sizes"]:
        continue
    lv = live_products.get(p)
    if not lv:
        continue  # 이미 상품 UNMATCHED 기록됨
    prd_cd = lv["prd_cd"]
    bmin = band_min(prd_cd)
    prod_level = info["prod"] if info["prod"] else (None, None, None)
    lsizes = live_sizes.get(prd_cd, [])
    # 라이브 사이즈 정규화 인덱스
    lindex = {}
    for lr in lsizes:
        for k in norm_size(lr["siz_nm"]):
            lindex.setdefault(k, []).append(lr)
    for (label, a_mn, a_mx, a_inc) in info["sizes"]:
        keys = norm_size(label)
        matched = None
        for k in keys:
            if k in lindex and lindex[k]:
                matched = lindex[k][0]
                break
        if not matched:
            unmatched.append({"kind": "SIZE", "prd_nm": p, "siz_label": label,
                              "reason": f"t_prd_product_sizes 사이즈 라벨 언매치 (prd_cd={prd_cd})"})
            continue
        siz_cd = matched["siz_cd"]
        cur_mn = to_int(matched["min_qty"])
        cur_mx = to_int(matched["max_qty"])
        cur_inc = to_int(matched["qty_incr"])
        # 밴드 가드 반영한 제안 min
        prop_mn = a_mn
        band_note = ""
        if a_mn is not None and bmin is not None and a_mn < bmin:
            prop_mn = bmin
            band_note = f"권위min {a_mn} < 가격표최소구간 {bmin}"
        same_as_prod = (a_mn, a_mx, a_inc) == prod_level
        cur_all_null = cur_mn is None and cur_mx is None and cur_inc is None
        if same_as_prod:
            verdict = "SKIP"  # 상품 규칙 폴백 — 사이즈 저장 불필요
        elif (cur_mn, cur_mx, cur_inc) == (prop_mn, a_mx, a_inc):
            verdict = "OK"    # 이미 정합 충전됨 (멱등 no-op)
        elif cur_all_null:
            verdict = "FILL"          # 빈곳 채움
        else:
            verdict = "MISMATCH"      # 기존 non-null ≠ 권위 → 교정(검토 필요)
        size_plan.append({
            "prd_cd": prd_cd, "prd_nm": p, "siz_cd": siz_cd, "siz_label": label,
            "siz_nm_live": matched["siz_nm"],
            "auth_min": a_mn if a_mn is not None else "", "auth_max": a_mx if a_mx is not None else "",
            "auth_incr": a_inc if a_inc is not None else "",
            "prod_min": prod_level[0] if prod_level[0] is not None else "",
            "prod_max": prod_level[1] if prod_level[1] is not None else "",
            "prod_incr": prod_level[2] if prod_level[2] is not None else "",
            "band_min": bmin if bmin is not None else "",
            "prop_min": prop_mn if prop_mn is not None else "", "prop_max": a_mx if a_mx is not None else "",
            "prop_incr": a_inc if a_inc is not None else "",
            "cur_min": cur_mn if cur_mn is not None else "",
            "cur_max": cur_mx if cur_mx is not None else "",
            "cur_incr": cur_inc if cur_inc is not None else "",
            "verdict": verdict, "note": band_note,
        })

with open(os.path.join(BASE, "fill-plan-sizes.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["prd_cd", "prd_nm", "siz_cd", "siz_label", "siz_nm_live",
                                      "auth_min", "auth_max", "auth_incr", "prod_min", "prod_max",
                                      "prod_incr", "band_min", "prop_min", "prop_max", "prop_incr",
                                      "cur_min", "cur_max", "cur_incr", "verdict", "note"])
    w.writeheader()
    w.writerows(size_plan)

with open(os.path.join(BASE, "unmatched.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["kind", "prd_nm", "siz_label", "reason"])
    w.writeheader()
    w.writerows(unmatched)

# ---------- 요약 stdout ----------
from collections import Counter
pv = Counter(r["verdict"] for r in prod_plan)
sv = Counter(r["verdict"] for r in size_plan)
print("=== 권위 레코드 ===")
print("PRODUCT level:", n_prod_lvl, "| SIZE level:", n_size_lvl, "| 총:", len(authority))
print("dup prd_nm in live:", sorted(dup_nm))
print("=== 상품 계획 verdict ===", dict(pv))
print("=== 사이즈 계획 verdict ===", dict(sv))
print("=== UNMATCHED ===", len(unmatched),
      "(PRODUCT", sum(1 for u in unmatched if u["kind"] == "PRODUCT"),
      "/ SIZE", sum(1 for u in unmatched if u["kind"] == "SIZE"), ")")
print("=== BAND_CONFLICT 상품 ===")
for r in prod_plan:
    if r["verdict"] == "BAND_CONFLICT":
        print(f"  {r['prd_cd']} {r['prd_nm']}: auth_min={r['auth_min']} band={r['band_min']} -> prop_min={r['prop_min']} | {r['note']}")
print("=== 사이즈 MISMATCH(기존 non-null≠권위) ===")
for r in size_plan:
    if r["verdict"] == "MISMATCH":
        print(f"  {r['prd_cd']} {r['prd_nm']} {r['siz_cd']}({r['siz_label']}): "
              f"cur=({r['cur_min']},{r['cur_max']},{r['cur_incr']}) -> "
              f"prop=({r['prop_min']},{r['prop_max']},{r['prop_incr']})")
print("=== 사이즈 레벨이 상품 레벨과 다른 상품(FILL/MISMATCH 있는 상품) ===")
fill_prods = {}
for r in size_plan:
    if r["verdict"] in ("FILL", "MISMATCH"):
        fill_prods.setdefault((r["prd_cd"], r["prd_nm"]), Counter())
        fill_prods[(r["prd_cd"], r["prd_nm"])][r["verdict"]] += 1
for (cd, nm), c in sorted(fill_prods.items()):
    print(f"  {cd} {nm}: FILL={c['FILL']} MISMATCH={c['MISMATCH']}")
