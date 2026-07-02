#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""전 상품 수량 체계 (상품×사이즈) 정밀 진단 — 결정론·읽기전용 (2차 진단).

입력(라이브 읽기전용 SELECT 덤프 = _db2/*.csv, 2026-07-02 스냅샷):
  products / product_sizes / product_formulas / formula_comps /
  component_prices / direct_prices / bundle_qtys
권위: authority-records.csv (상품마스터 260610 제작수량 verbatim 468레코드)

진단 축:
  1. SIZE_TRAP  : (상품×사이즈) 유효최소수량 < 사이즈별 공식 comp 최소구간 → 소량주문 0원/제외
  2. REVERSAL   : 인접 구간 경계 역전(경계 직전 총액 > 다음 구간 시작 총액) — UI 절약배지 근거
  3. DIRECT     : 직접단가 상품 — 선형이라 구간함정 없음 확인 + 수량규칙 유무
  4. BDL        : bdl_qty(묶음수) 축 comp 보유 상품 — 묶음값의 선택수단 노출 여부
  5. MAX        : 사이즈/상품 max_qty 권위 verbatim 대조 → MAX_MISMATCH

엔진 규칙 정합(raw/webadmin/webadmin/catalog/pricing.py):
  - 구간 = 주문수량 이하 최대 min_qty(NULL=0). 최소구간 미달 = below_min_qty(합산 제외/차단)
  - 단가형(.01)=구간단가×실수량 · 합가형(.02)=구간총액÷구간min_qty×실수량 · 고정(.03)=금액 그대로
  - 행 차원 NULL=와일드카드 · 비수량 차원조합(combo)별 독립 매칭 · apply_ymd<=as_of
출력: size-trap.csv, reversal-scan.csv, direct-price-products.csv, bdl-axis.csv,
      max-mismatch.csv, fix-candidates.csv + stdout 요약. DB 쓰기 없음(제안만).
"""
import csv, json, os, re
from collections import defaultdict
from decimal import Decimal

BASE = os.path.dirname(os.path.abspath(__file__))
DB = os.path.join(BASE, "_db2")
AS_OF = "2026-07-02"

# 기처리/보류 (재진단 금지 — 결과에 태그만)
HANDLED = {
    "PRD_000065": "기처리(스티커팩 단가행 min 54→1 COMMIT)",
    "PRD_000097": "기처리(떡메 min 3→6 COMMIT)",
    "PRD_000094": "기처리(엽서북 min 1→2 COMMIT)",
    "PRD_000144": "보류(미니 수량축 해석 실무진 컨펌 CONFIRM-mini-qty-bands-260702)",
    "PRD_000145": "보류(미니 수량축 해석 실무진 컨펌 CONFIRM-mini-qty-bands-260702)",
}
FOIL_HOLD = {"PRD_000027", "PRD_000029", "PRD_000031", "PRD_000034",
             "PRD_000069", "PRD_000070"}  # FOIL 박 6상품 — 제약규칙 트랙 위임 확정

NON_QTY_DIMS = ("siz_cd", "plt_siz_cd", "print_opt_cd", "mat_cd", "proc_cd", "opt_cd",
                "coat_side_cnt", "bdl_qty")
OTHER_DIMS = tuple(d for d in NON_QTY_DIMS if d != "siz_cd")
COND_DIMS = ("proc_cd", "opt_cd")  # 손님이 안 고르면 no_match 되는 조건부 차원

def rd(name):
    with open(os.path.join(DB, name), encoding="utf-8") as f:
        return list(csv.DictReader(f))

def to_int(v):
    if v in (None, ""):
        return None
    try:
        return int(round(float(v)))
    except ValueError:
        return None

def norm_size(label):
    """build_qtyrules.py 와 동일한 사이즈 라벨 정규화."""
    if not label:
        return set()
    s = str(label).strip().lower()
    keys = set()
    inner = re.findall(r"\(([^)]*)\)", s)
    outer = re.sub(r"\([^)]*\)", " ", s)
    for cand in [s, outer] + inner:
        c = cand.replace("mm", "").replace(" ", "").replace("×", "x").replace("*", "x")
        c = c.strip("()").strip()
        if c:
            keys.add(c)
        dm = re.search(r"(\d+)x(\d+)", c)
        if dm:
            keys.add(f"{dm.group(1)}x{dm.group(2)}")
    return {k for k in keys if k}

# ---------------- 로드 ----------------
products = {r["prd_cd"]: r for r in rd("products.csv")}
psizes = defaultdict(list)
for r in rd("product_sizes.csv"):
    psizes[r["prd_cd"]].append(r)
pfrm = defaultdict(list)
for r in rd("product_formulas.csv"):
    pfrm[r["prd_cd"]].append(r["frm_cd"])
frm_comps = defaultdict(list)
comp_meta = {}
for r in rd("formula_comps.csv"):
    frm_comps[r["frm_cd"]].append(r["comp_cd"])
    comp_meta[r["comp_cd"]] = r
rows_by_comp = defaultdict(list)
for r in rd("component_prices.csv"):
    if (r["apply_ymd"] or "") <= AS_OF:
        rows_by_comp[r["comp_cd"]].append(r)
direct = defaultdict(list)
for r in rd("direct_prices.csv"):
    direct[r["prd_cd"]].append(r)
bqty = defaultdict(set)
for r in rd("bundle_qtys.csv"):
    bqty[r["prd_cd"]].add(to_int(r["bdl_qty"]))

# 권위 (상품/사이즈 레벨)
auth_prod = {}   # prd_nm -> (min,max,incr)
auth_size = defaultdict(dict)  # prd_nm -> {normkey: (label,min,max,incr)}
with open(os.path.join(BASE, "authority-records.csv"), encoding="utf-8") as _f:
    _auth_rows = list(csv.DictReader(_f))
for r in _auth_rows:
    tup = (to_int(r["min"]), to_int(r["max"]), to_int(r["incr"]))
    if r["level"] == "PRODUCT":
        auth_prod[r["prd_nm"]] = tup
    else:
        for k in norm_size(r["siz_label"]):
            auth_size[r["prd_nm"]].setdefault(k, (r["siz_label"],) + tup)

def auth_for_size(prd_nm, siz_nm):
    d = auth_size.get(prd_nm) or {}
    for k in norm_size(siz_nm):
        if k in d:
            return d[k]
    return None

def combo_key(r):
    return tuple((r[d] or "") for d in OTHER_DIMS) + (r["dim_vals"] or "{}",)

def comp_size_bands(comp_cd, siz_cd):
    """(comp, siz) 후보행(siz 일치 or 와일드카드)을 combo별로 그룹 →
    combo별 (band_min, bands정렬, prc_typ, rows). 후보 없으면 None."""
    cand = [r for r in rows_by_comp.get(comp_cd, [])
            if r["siz_cd"] in ("", siz_cd)]
    if not cand:
        return None
    combos = defaultdict(list)
    for r in cand:
        combos[combo_key(r)].append(r)
    out = []
    for k, grp in combos.items():
        bands = sorted({to_int(r["min_qty"]) or 0 for r in grp})
        dims_used = [d for d, v in zip(OTHER_DIMS, k) if v] + (["dim_vals"] if k[-1] not in ("{}", "") else [])
        out.append({"key": k, "band_min": bands[0], "bands": bands,
                    "dims_used": dims_used, "rows": grp})
    return out

# ---------------- 1. SIZE_TRAP ----------------
trap_rows = []
for prd_cd, prod in sorted(products.items()):
    frms = pfrm.get(prd_cd)
    if not frms:
        continue
    comps = []
    seen = set()
    for f in frms:
        for c in frm_comps.get(f, []):
            if c not in seen:
                seen.add(c)
                comps.append(c)
    p_min = to_int(prod["min_qty"])
    for sz in psizes.get(prd_cd, []):
        eff_min = to_int(sz["min_qty"]) or p_min or 1
        eff_src = ("SIZE" if to_int(sz["min_qty"]) else
                   "PRODUCT" if p_min else "DEFAULT1")
        trap_comps, partial_comps, cond_comps = [], [], []
        trap_band, partial_band = 0, 0
        for c in comps:
            groups = comp_size_bands(c, sz["siz_cd"])
            if not groups:
                continue
            loosest = min(g["band_min"] for g in groups)
            strictest = max(g["band_min"] for g in groups)
            conditional = any(d in COND_DIMS for g in groups for d in g["dims_used"])
            if loosest > eff_min:
                if conditional:
                    cond_comps.append(f"{c}:{loosest}")
                else:
                    trap_comps.append(f"{c}:{loosest}")
                    trap_band = max(trap_band, loosest)
            elif strictest > eff_min:
                partial_comps.append(f"{c}:{strictest}")
                partial_band = max(partial_band, strictest)
        if not (trap_comps or partial_comps or cond_comps):
            continue
        verdict = ("SIZE_TRAP" if trap_comps else
                   "SIZE_TRAP_PARTIAL" if partial_comps else "SIZE_TRAP_COND")
        note = HANDLED.get(prd_cd, "")
        if prd_cd in FOIL_HOLD and all(t.split(":")[0].startswith("COMP_FOIL") for t in
                                       (trap_comps + partial_comps + cond_comps)):
            note = "보류(FOIL 박 — 제약규칙 트랙 위임 확정)"
        a = auth_for_size(prod["prd_nm"], sz["siz_nm"])
        ap = auth_prod.get(prod["prd_nm"])
        trap_rows.append({
            "prd_cd": prd_cd, "prd_nm": prod["prd_nm"], "siz_cd": sz["siz_cd"],
            "siz_nm": sz["siz_nm"], "eff_min": eff_min, "eff_min_src": eff_src,
            "verdict": verdict,
            "trap_band_min": trap_band or "",
            "partial_band_min": partial_band or "",
            "trap_comps": ";".join(trap_comps),
            "partial_comps": ";".join(partial_comps),
            "cond_comps": ";".join(cond_comps),
            "auth_size_min": a[1] if a else "", "auth_size_max": a[2] if a else "",
            "auth_prod_min": ap[0] if ap else "",
            "status": note or "NEW",
        })

with open(os.path.join(BASE, "size-trap.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["prd_cd", "prd_nm", "siz_cd", "siz_nm", "eff_min",
                                      "eff_min_src", "verdict", "trap_band_min",
                                      "partial_band_min", "trap_comps", "partial_comps",
                                      "cond_comps", "auth_size_min", "auth_size_max",
                                      "auth_prod_min", "status"])
    w.writeheader(); w.writerows(trap_rows)

# ---------------- 2. 역전(more-for-less) 전수 스캔 ----------------
# comp×combo 단위로 인접 구간 경계 역전 계산 → 상품으로 귀속(공식 바인딩 경유)
comp_products = defaultdict(set)
for prd_cd in products:
    for f in pfrm.get(prd_cd, []):
        for c in frm_comps.get(f, []):
            comp_products[c].add(prd_cd)

def cost_at(prc_typ, unit, band, qty):
    """엔진 component_subtotal 재현(Decimal)."""
    u = Decimal(unit)
    if prc_typ == "PRICE_TYPE.03":
        return u
    if prc_typ == "PRICE_TYPE.02":
        return u / Decimal(band) * Decimal(qty) if band else None
    return u * Decimal(qty)

rev_events = []  # comp 단위 이벤트
for comp_cd, rows in rows_by_comp.items():
    if comp_cd not in comp_products:
        continue
    prc_typ = (comp_meta.get(comp_cd) or {}).get("prc_typ_cd") or "PRICE_TYPE.01"
    combos = defaultdict(dict)  # key -> band -> latest row
    for r in rows:
        k = (r["siz_cd"],) + combo_key(r)
        b = to_int(r["min_qty"]) or 0
        cur = combos[k].get(b)
        if cur is None or (r["apply_ymd"] or "") > (cur["apply_ymd"] or ""):
            combos[k][b] = r
    for k, bands in combos.items():
        bl = sorted(bands)
        for i in range(len(bl) - 1):
            b0, b1 = bl[i], bl[i + 1]
            if b1 <= 1:
                continue
            r0, r1 = bands[b0], bands[b1]
            q = b1 - 1  # 경계 직전(스캔 입도 1)
            c_prev = cost_at(prc_typ, r0["unit_price"], b0 or 1, q)
            c_next = cost_at(prc_typ, r1["unit_price"], b1, b1)
            if c_prev is None or c_next is None or c_prev <= c_next:
                continue
            saving = c_prev - c_next
            # 역전 창 폭: q' in (임계, b1) 에서 다음 구간 시작 구매가 더 쌈
            if prc_typ == "PRICE_TYPE.03":
                width = b1 - 1 - b0 + 1
            else:
                u0 = (Decimal(r0["unit_price"]) if prc_typ == "PRICE_TYPE.01"
                      else Decimal(r0["unit_price"]) / Decimal(b0 or 1))
                thr = c_next / u0  # u0*q > c_next ⇔ q > thr
                lo = max(b0, int(thr) + 1)
                width = b1 - lo if b1 > lo else 1
            rev_events.append({
                "comp_cd": comp_cd, "prc_typ": prc_typ,
                "siz_cd": k[0] or "(전사이즈)",
                "combo": "|".join(x for x in k[1:-1] if x) or "(무차원)",
                "band_prev": b0, "band_next": b1,
                "cost_prev_at_boundary": str(c_prev.quantize(Decimal("1"))),
                "cost_next_start": str(c_next.quantize(Decimal("1"))),
                "saving": str(saving.quantize(Decimal("1"))),
                "window_width": width,
                "products": ";".join(sorted(comp_products[comp_cd])),
            })

with open(os.path.join(BASE, "reversal-scan.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["comp_cd", "prc_typ", "siz_cd", "combo", "band_prev",
                                      "band_next", "cost_prev_at_boundary", "cost_next_start",
                                      "saving", "window_width", "products"])
    w.writeheader(); w.writerows(rev_events)

# 상품별 집계
prod_rev = defaultdict(lambda: {"n": 0, "max_saving": Decimal(0), "max_width": 0})
for e in rev_events:
    for p in e["products"].split(";"):
        a = prod_rev[p]
        a["n"] += 1
        a["max_saving"] = max(a["max_saving"], Decimal(e["saving"]))
        a["max_width"] = max(a["max_width"], e["window_width"])

# ---------------- 3. 직접단가 상품 ----------------
direct_rows = []
for prd_cd, rows in sorted(direct.items()):
    p = products.get(prd_cd) or {}
    direct_rows.append({
        "prd_cd": prd_cd, "prd_nm": p.get("prd_nm", "(삭제/미존재)"),
        "n_price_rows": len(rows),
        "unit_price": rows[-1]["unit_price"],
        "has_formula": "Y" if pfrm.get(prd_cd) else "N",
        "min_qty": p.get("min_qty", ""), "max_qty": p.get("max_qty", ""),
        "qty_incr": p.get("qty_incr", ""),
        "qty_rule": "Y" if to_int(p.get("min_qty")) else "N",
        "note": "선형 단가×수량 — 구간 함정 없음",
    })
with open(os.path.join(BASE, "direct-price-products.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["prd_cd", "prd_nm", "n_price_rows", "unit_price",
                                      "has_formula", "min_qty", "max_qty", "qty_incr",
                                      "qty_rule", "note"])
    w.writeheader(); w.writerows(direct_rows)

# ---------------- 4. bdl_qty 축 ----------------
bdl_rows = []
for comp_cd, rows in sorted(rows_by_comp.items()):
    vals = sorted({to_int(r["bdl_qty"]) for r in rows if r["bdl_qty"]})
    if not vals:
        continue
    for prd_cd in sorted(comp_products.get(comp_cd, [])):
        have = bqty.get(prd_cd, set())
        missing = [v for v in vals if v not in have]
        bdl_rows.append({
            "comp_cd": comp_cd, "prd_cd": prd_cd,
            "prd_nm": products.get(prd_cd, {}).get("prd_nm", ""),
            "comp_bdl_vals": ";".join(map(str, vals)),
            "product_bundle_qtys": ";".join(map(str, sorted(have))) or "(없음)",
            "exposure": "OK" if not missing else "MISSING:" + ";".join(map(str, missing)),
        })
with open(os.path.join(BASE, "bdl-axis.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["comp_cd", "prd_cd", "prd_nm", "comp_bdl_vals",
                                      "product_bundle_qtys", "exposure"])
    w.writeheader(); w.writerows(bdl_rows)

# ---------------- 5. MAX_MISMATCH (권위 verbatim) ----------------
max_rows = []
for prd_cd, prod in sorted(products.items()):
    ap = auth_prod.get(prod["prd_nm"])
    p_max = to_int(prod["max_qty"])
    # 상품 레벨
    if ap and ap[1] is not None and p_max is not None and p_max != ap[1]:
        max_rows.append({"prd_cd": prd_cd, "prd_nm": prod["prd_nm"], "level": "PRODUCT",
                         "siz_cd": "", "siz_nm": "", "live_max": p_max, "auth_max": ap[1],
                         "eff_from": "product", "status": HANDLED.get(prd_cd, "NEW")})
    for sz in psizes.get(prd_cd, []):
        a = auth_for_size(prod["prd_nm"], sz["siz_nm"])
        if not a or a[2] is None:
            continue
        s_max = to_int(sz["max_qty"])
        eff_max = s_max if s_max is not None else p_max
        src = "size" if s_max is not None else "product-fallback"
        if eff_max is not None and eff_max != a[2]:
            max_rows.append({"prd_cd": prd_cd, "prd_nm": prod["prd_nm"], "level": "SIZE",
                             "siz_cd": sz["siz_cd"], "siz_nm": sz["siz_nm"],
                             "live_max": eff_max, "auth_max": a[2], "eff_from": src,
                             "status": HANDLED.get(prd_cd, "NEW")})
with open(os.path.join(BASE, "max-mismatch.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["prd_cd", "prd_nm", "level", "siz_cd", "siz_nm",
                                      "live_max", "auth_max", "eff_from", "status"])
    w.writeheader(); w.writerows(max_rows)

# ---------------- 교정 후보 분류 ----------------
fixes = []
for t in trap_rows:
    if t["status"] != "NEW":
        continue
    if t["verdict"] == "SIZE_TRAP":
        band = int(t["trap_band_min"])
        a_min = to_int(str(t["auth_size_min"]))
        if a_min is not None and a_min >= band:
            fixes.append({"kind": "FIX_SIZE_MIN", "prd_cd": t["prd_cd"], "prd_nm": t["prd_nm"],
                          "siz_cd": t["siz_cd"], "siz_nm": t["siz_nm"],
                          "cur": t["eff_min"], "prop": a_min,
                          "basis": f"권위 사이즈 min={a_min} ≥ 최소구간 {band} (권위 정합)"})
        else:
            fixes.append({"kind": "FIX_SIZE_MIN", "prd_cd": t["prd_cd"], "prd_nm": t["prd_nm"],
                          "siz_cd": t["siz_cd"], "siz_nm": t["siz_nm"],
                          "cur": t["eff_min"], "prop": band,
                          "basis": f"가격표 최소구간 {band} 지지(엽서북/떡메 선례: 가격표=돈 권위)"
                                   + (f" · 권위min={a_min} 충돌" if a_min is not None else " · 권위 사이즈 min 없음")})
    elif t["verdict"] in ("SIZE_TRAP_PARTIAL", "SIZE_TRAP_COND"):
        fixes.append({"kind": "CONFIRM", "prd_cd": t["prd_cd"], "prd_nm": t["prd_nm"],
                      "siz_cd": t["siz_cd"], "siz_nm": t["siz_nm"],
                      "cur": t["eff_min"],
                      "prop": t["partial_band_min"] or "",
                      "basis": ("일부 조합만 함정(자재/조합 종속): " + t["partial_comps"])
                               if t["verdict"] == "SIZE_TRAP_PARTIAL"
                               else "조건부 공정/옵션 선택 시만 함정: " + t["cond_comps"]})
for m in max_rows:
    if m["status"] != "NEW":
        continue
    if m["level"] == "SIZE" and m["eff_from"] == "size":
        fixes.append({"kind": "FIX_MAX_SIZE", "prd_cd": m["prd_cd"], "prd_nm": m["prd_nm"],
                      "siz_cd": m["siz_cd"], "siz_nm": m["siz_nm"],
                      "cur": m["live_max"], "prop": m["auth_max"],
                      "basis": "권위 사이즈 max verbatim"})
    elif m["level"] == "PRODUCT":
        fixes.append({"kind": "FIX_MAX_PRODUCT", "prd_cd": m["prd_cd"], "prd_nm": m["prd_nm"],
                      "siz_cd": "", "siz_nm": "", "cur": m["live_max"], "prop": m["auth_max"],
                      "basis": "권위 상품 max verbatim"})
    else:  # size-level 권위가 product 폴백과 다름 → 사이즈행 min/max 미충전 케이스
        fixes.append({"kind": "FIX_MAX_SIZE_FILL", "prd_cd": m["prd_cd"], "prd_nm": m["prd_nm"],
                      "siz_cd": m["siz_cd"], "siz_nm": m["siz_nm"],
                      "cur": f"(NULL→상품폴백 {m['live_max']})", "prop": m["auth_max"],
                      "basis": "사이즈행 max 미충전·권위 사이즈 max 와 상품 폴백 상이"})
with open(os.path.join(BASE, "fix-candidates.csv"), "w", newline="", encoding="utf-8") as f:
    w = csv.DictWriter(f, fieldnames=["kind", "prd_cd", "prd_nm", "siz_cd", "siz_nm",
                                      "cur", "prop", "basis"])
    w.writeheader(); w.writerows(fixes)

# ---------------- 요약 ----------------
from collections import Counter
tv = Counter(r["verdict"] for r in trap_rows if r["status"] == "NEW")
th = Counter(r["status"] for r in trap_rows if r["status"] != "NEW")
print("=== 1. SIZE_TRAP (상품×사이즈) ===")
print("NEW:", dict(tv), "| 기처리/보류:", dict(th), "| 총 행:", len(trap_rows))
for r in trap_rows:
    if r["status"] == "NEW" and r["verdict"] == "SIZE_TRAP":
        print(f"  [TRAP] {r['prd_cd']} {r['prd_nm']} {r['siz_nm']}: eff_min={r['eff_min']}({r['eff_min_src']})"
              f" < band={r['trap_band_min']} | auth_size_min={r['auth_size_min']} | {r['trap_comps']}")
print("=== 2. 역전 스캔 ===")
print("역전 경계 이벤트:", len(rev_events), "| 역전 보유 comp:", len({e['comp_cd'] for e in rev_events}),
      "| 역전 보유 상품:", len(prod_rev))
top = sorted(prod_rev.items(), key=lambda kv: -kv[1]["max_saving"])[:5]
for p, a in top:
    print(f"  {p} {products.get(p, {}).get('prd_nm', '')}: 경계 {a['n']}건, 최대절약 {a['max_saving']}원, 최대창폭 {a['max_width']}")
print("=== 3. 직접단가 상품:", len(direct_rows), "===")
print("=== 4. bdl 축 행:", len(bdl_rows), "| MISSING:",
      sum(1 for b in bdl_rows if b["exposure"] != "OK"), "===")
for b in bdl_rows:
    if b["exposure"] != "OK":
        print(f"  {b['prd_cd']} {b['prd_nm']} {b['comp_cd']} vals={b['comp_bdl_vals']} live={b['product_bundle_qtys']} {b['exposure']}")
print("=== 5. MAX_MISMATCH:", len([m for m in max_rows if m['status'] == 'NEW']), "(NEW) /", len(max_rows), "===")
for m in max_rows:
    print(f"  [{m['status']}] {m['prd_cd']} {m['prd_nm']} {m['level']} {m['siz_nm']}: live={m['live_max']} vs auth={m['auth_max']} ({m['eff_from']})")
fk = Counter(fx["kind"] for fx in fixes)
print("=== 교정 후보:", dict(fk), "===")
