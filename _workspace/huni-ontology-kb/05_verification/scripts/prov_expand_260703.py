#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""prov_expand_260703.py — 배정축 확장 검증 (출처 실재성 + 권위 정합 + 오염) 전 36상품.
provenance_audit(파일 실재)의 resolver 버그(live-snapshot/MEMORY prefix를 repo root로 오해)를
교정하고, live-snapshot CSV 출처는 locator 키를 CSV에서 재조회해 "그 행이 실재하는가"까지 확인한다.
또한 오염 4종(STALE 인용·구권위 잔재·환각 개체·라이브 오적재 verified)을 결정론 스캔한다.
재실행: python3 05_verification/scripts/prov_expand_260703.py
"""
import json, os, re, csv, glob
from collections import Counter, defaultdict

REPO = "/Users/innojini/Dev/HuniWeb"
FOUND = os.path.join(REPO, "_workspace/_foundation")
MEMDIR = os.path.expanduser("~/.claude/projects/-Users-innojini-Dev-HuniWeb/memory")
KB = os.path.join(REPO, "_workspace/huni-ontology-kb")
SNAP = os.path.join(FOUND, "live-snapshot/latest")
nodes = [json.loads(l) for l in open(os.path.join(KB, "04_graph/nodes.jsonl"))]

# ---------- resolver (교정) ----------
def resolve(sf):
    if not sf: return None
    if os.path.isabs(sf): return sf
    if sf.startswith("live-snapshot/"): return os.path.join(FOUND, sf)
    if sf.startswith("MEMORY/"): return os.path.join(MEMDIR, sf[len("MEMORY/"):])
    return os.path.join(REPO, sf)

# ---------- CSV 캐시 ----------
_csv = {}
def load_csv(name):
    if name in _csv: return _csv[name]
    p = os.path.join(SNAP, name)
    if not os.path.exists(p): _csv[name] = None; return None
    with open(p, encoding="utf-8") as f:
        _csv[name] = list(csv.DictReader(f))
    return _csv[name]

CODE = r"[A-Z][A-Z0-9]*(?:_[A-Z0-9]+)+"  # 전체 코드 토큰(꼬리 문자 포함: COMP_CUT_PERF_1H6)
ABSENT_MARK = ("0행", "행 0", "부재", "미실재", "미등록", "0건", "미바인딩", "(0)")

def first_code(loc):
    """locator에서 검증 가능한 코드 키 1개 추출. 우선순위: 비괄호 '키:CODE' → 필드:CODE → 괄호 첫 코드."""
    if not loc: return []
    m = re.search(r"키:(" + CODE + ")", loc)          # 테이블:.. 키:MAT_000128 형태 우선
    if m: return [m.group(1)]
    m = re.search(r"(?:prd_cd|frm_cd|comp_cd|mat_cd|proc_cd|siz_cd|opt_cd|print_opt_cd):(" + CODE + ")", loc)
    if m: return [m.group(1)]
    m = re.search(r"키:\((" + CODE + ")", loc)          # 괄호 복합키 첫 코드
    if m: return [m.group(1)]
    return []

# CSV 내 코드가 어느 컬럼에든 존재하는지(멤버십)
def code_in_csv(name, codes):
    rows = load_csv(name)
    if rows is None: return None  # CSV 부재
    allvals = set()
    for r in rows:
        allvals.update(v for v in r.values() if v)
    return all(c in allvals for c in codes)

# ---------- AXIS1: 파일 실재 + 행 실재 ----------
file_missing = []      # 실재하지 않는 파일(교정 resolver 후에도)
row_missing = []       # live CSV 출처인데 locator 키가 CSV에 없음
csv_absent = []        # 참조 CSV 자체 부재
badge_ct = Counter(); srcfile_ct = Counter()
n_sources = 0

for n in nodes:
    nid = n["id"]
    for s in n.get("sources", []):
        n_sources += 1
        sf = s.get("source_file", "")
        srcfile_ct[sf] += 1
        badge_ct[s.get("badge")] += 1
        rp = resolve(sf)
        if rp and not os.path.exists(rp):
            file_missing.append((nid, sf, s.get("src_id")))
            continue
        # live CSV 출처면 행 실재 재조회
        if sf.startswith("live-snapshot/latest/") and sf.endswith(".csv"):
            name = os.path.basename(sf)
            loc = s.get("source_locator", "")
            codes = first_code(loc)
            # 긍정 사실 인용만 기계 대조(gap/부재 마커 locator는 자연어 판단 대상 — 표본으로 별도 검토)
            positive = n.get("type") != "gap" and not any(m in loc for m in ABSENT_MARK)
            if codes and positive:
                res = code_in_csv(name, codes)
                if res is None:
                    csv_absent.append((nid, name))
                elif res is False:
                    row_missing.append((nid, name, codes, loc[:70]))

print("=== AXIS1 출처 실재성 (전 36상품 · resolver 교정) ===")
print(f"노드 {len(nodes)} · 소스 {n_sources} · distinct file {len(srcfile_ct)}")
print(f"badge 분포: {dict(badge_ct)}")
print(f"[A1.1] 실재하지 않는 파일: {len(file_missing)}")
for r in file_missing[:30]: print("   MISS", r)
print(f"[A1.2] live CSV 출처 행(locator 키) 미실재: {len(row_missing)}")
for r in row_missing[:40]: print("   ROWMISS", r[0], r[1], r[2], "|", r[3])
print(f"[A1.3] 참조 CSV 자체 부재: {len(csv_absent)}")
for r in csv_absent[:20]: print("   CSVABSENT", r)

# ---------- AXIS3: 오염 스캔 ----------
# §8 STALE 금지 패턴
STALE_PAT = [
    ("prdmaster_full_migration_v03", "v03 마이그레이션"),
    ("00_schema/price-engine-ddl", "구 가격 스키마 DDL"),
    ("prcx01-pricing-model", "구 8차원 설계"),
    ("pricing-erd", "구 ERD"),
    ("03_spec/huni-db-mapping", "구 위젯 매핑"),
    ("후가공_박(백업)", "박 백업시트"),
]
stale_hits = []
oldauth_hits = []   # 260610/260527 무대조 인용
for n in nodes:
    for s in n.get("sources", []):
        blob = (s.get("source_file","")+" "+s.get("source_locator","")).lower()
        for pat, why in STALE_PAT:
            if pat.lower() in blob:
                stale_hits.append((n["id"], pat, why))
        if ("260610" in blob or "260527" in blob) and "diff" not in blob and "260702" not in blob:
            oldauth_hits.append((n["id"], s.get("source_file","")[:40], s.get("source_locator","")[:50]))

print("\n=== AXIS3 오염 스캔 ===")
print(f"[A3.1] STALE 금지 패턴 인용: {len(stale_hits)}")
for r in stale_hits[:20]: print("   STALE", r)
print(f"[A3.2] 구권위 260610/260527 무대조(diff/260702 미동반) 인용: {len(oldauth_hits)}")
for r in oldauth_hits[:20]: print("   OLDAUTH", r)

# ---------- AXIS3 환각 개체: anchor 코드가 live CSV에 실재하는가 ----------
# 노드 type→(CSV, keycol)
ANCHOR_TBL = {
    "product": ("t_prd_products.csv","prd_cd"),
    "material": ("t_mat_materials.csv","mat_cd"),
    "process": ("t_proc_processes.csv","proc_cd"),
    "size": ("t_siz_sizes.csv","siz_cd"),
    "print_option": ("t_prt_print_options.csv",None),
    "price_component": ("t_prc_price_components.csv","comp_cd"),
    "price_formula": ("t_prc_price_formulas.csv","frm_cd"),
    "category": ("t_cat_categories.csv","cat_cd"),
}
def anchor_code(n):
    a = n.get("anchor","")
    return a.split("/",1)[1] if "/" in a else None

halluc = []
for n in nodes:
    t = n.get("type")
    if t not in ANCHOR_TBL: continue
    code = anchor_code(n)
    if not code: continue
    fname, keycol = ANCHOR_TBL[t]
    rows = load_csv(fname)
    if rows is None: continue
    if keycol:
        exists = any(r.get(keycol)==code for r in rows)
    else:
        exists = any(code in r.values() for r in rows)
    if not exists:
        halluc.append((n["id"], t, code, fname))
print(f"\n[A3.3] 환각 개체(anchor 코드 live 부재): {len(halluc)}")
for r in halluc[:40]: print("   HALLUC", r)

# ---------- 손전사(hand-transcription) 마커 수색 ----------
# 정본 md 본문에서 가격/치수 숫자 리터럴이 든 블록에 transcribed-by/companion/결정론/전사 마커 유무
NUM = re.compile(r"\b\d{1,3}(?:,\d{3})+\b")  # 1,000 이상 콤마 숫자 = 가격류
mdfiles = glob.glob(os.path.join(KB,"03_kb/product/**/*.md"), recursive=True)
handxfer = []
for p in mdfiles:
    txt = open(p, encoding="utf-8").read()
    body = txt.split("---",2)[-1] if txt.startswith("---") else txt
    # frontmatter 밖 본문 숫자
    prices = NUM.findall(body)
    if prices:
        has_marker = any(k in txt for k in ["전사","transcrib","companion","결정론","verbatim","score_batch","batch"])
        if not has_marker:
            handxfer.append((os.path.basename(p), sorted(set(prices))[:6]))
print(f"\n[A1.4] 가격류 숫자 리터럴 有 · 전사/결정론 마커 無 파일(손전사 의심): {len(handxfer)}")
for r in handxfer[:30]: print("   HANDXFER", r)
