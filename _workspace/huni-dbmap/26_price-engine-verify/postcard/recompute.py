#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""recompute.py — round-18 가격엔진 검증용 재계산기 (프리미엄엽서 PRD_000016 파일럿)

라이브 evaluate_price 엔진이 미구현이므로, Phase11 명세(11-CONTEXT/prcx01)대로
계산을 재구현해 라이브 데이터로 돌린다. 읽기전용(SELECT만). DB 쓰기 없음.

두 가지 매칭을 모두 계산해 차이를 드러낸다:
  (A) 명세 순수 차원매칭(naive) — 선택값↔component_prices 차원만으로 자동판정.
  (B) 선택→구성요소 보정매칭(corrected) — 상호배타 옵션을 옳은 comp로 한정.

핵심 해석 단계(명세 미기술 갭): 작업사이즈 → 출력판형(t_prd_product_plate_sizes) → 단가행 siz_cd.
"""
import os, subprocess, json
from decimal import Decimal, ROUND_HALF_UP

ROOT = subprocess.check_output(["git","rev-parse","--show-toplevel"]).decode().strip()
ENV = {}
for line in open(os.path.join(ROOT, ".env.local")):
    line = line.strip()
    if line and not line.startswith("#") and "=" in line:
        k, v = line.split("=", 1); ENV[k] = v
PRD = "PRD_000016"
FRM = "PRF_DGP_A"
BASE_YMD = "2026-06-14"

def q(sql):
    env = dict(os.environ); env["PGPASSWORD"] = ENV["RAILWAY_DB_PASSWORD"]
    out = subprocess.check_output(
        ["psql","-h",ENV["RAILWAY_DB_HOST"],"-p",ENV["RAILWAY_DB_PORT"],
         "-U",ENV["RAILWAY_DB_USER"],"-d",ENV["RAILWAY_DB_NAME"],
         "-At","-F","\t","--no-psqlrc","-c",sql], env=env).decode()
    return [r.split("\t") for r in out.splitlines() if r]

# ── 1. 출력판형 해석 (작업사이즈 → 출력판형) ──
plate = q(f"select siz_cd from t_prd_product_plate_sizes where prd_cd='{PRD}' and del_yn='N' order by dflt_plt_yn desc limit 1")
PLATE_SIZ = plate[0][0]   # SIZ_000499

# ── 2. 공식 구성요소 + 메타 + 단가행 적재(메모리) ──
comps = {}
for cd, nm, ptyp, dims in q(f"""
  select fc.comp_cd, pc.comp_nm, pc.prc_typ_cd, pc.use_dims
  from t_prc_formula_components fc join t_prc_price_components pc on pc.comp_cd=fc.comp_cd
  where fc.frm_cd='{FRM}' order by fc.disp_seq"""):
    comps[cd] = {"nm": nm, "ptyp": ptyp, "dims": json.loads(dims), "rows": []}
for cd in comps:
    for siz, clr, mat, coat, bdl, mq, up, ymd in q(f"""
      select coalesce(siz_cd,''),coalesce(clr_cd,''),coalesce(mat_cd,''),
             coalesce(coat_side_cnt::text,''),coalesce(bdl_qty::text,''),
             coalesce(min_qty::text,''),unit_price,apply_ymd
      from t_prc_component_prices where comp_cd='{cd}'"""):
        comps[cd]["rows"].append({"siz":siz,"clr":clr,"mat":mat,"coat":coat,
                                  "bdl":bdl,"mq":int(mq) if mq else None,
                                  "up":Decimal(up),"ymd":ymd})

def match_rows(cd, sel, qty):
    """use_dims·NULL 와일드카드·수량구간(이하 최대 min_qty)·시계열(최신 ymd) 적용."""
    dims = comps[cd]["dims"]; cand = []
    for r in comps[cd]["rows"]:
        if r["ymd"] > BASE_YMD: continue
        ok = True
        if "siz_cd" in dims and r["siz"] and r["siz"] != sel["siz"]: ok = False
        if "clr_cd" in dims and r["clr"] and r["clr"] != sel.get("clr",""): ok = False
        if "mat_cd" in dims and r["mat"] and r["mat"] != sel.get("mat",""): ok = False
        if "coat_side_cnt" in dims and r["coat"] and r["coat"] != str(sel.get("coat","")): ok = False
        if ok: cand.append(r)
    if not cand: return []
    if any(c["mq"] is not None for c in cand):       # 수량구간: 이하 최대 min_qty
        elig = [c for c in cand if c["mq"] is not None and c["mq"] <= qty]
        if not elig: return [("MIN_UNMET", None)]
        best = max(c["mq"] for c in elig)
        cand = [c for c in elig if c["mq"] == best]
    # 시계열: 최신 ymd
    ny = max(c["ymd"] for c in cand); cand = [c for c in cand if c["ymd"] == ny]
    return cand

def line_price(cd, r, qty):
    up = r["up"]
    if comps[cd]["ptyp"] == "PRICE_TYPE.02":          # 합가형: 구간총액÷min_qty 환산
        unit = up / (r["mq"] or 1)
    else:                                             # 단가형: 장당가
        unit = up
    return (unit * qty)

# ── 3-A. 명세 순수 차원매칭 (naive) — 전 comp 무차별 매칭 ──
def compute_naive(sel, qty):
    total = Decimal(0); lines = []; over = []
    for cd in comps:
        m = match_rows(cd, sel, qty)
        if not m or m == [("MIN_UNMET", None)]: continue
        r = m[0]; lp = line_price(cd, r, qty); total += lp
        lines.append((cd, comps[cd]["nm"], r["up"], lp)); over.append(cd)
    return total, lines, over

# ── 3-B. 선택→구성요소 보정매칭 (corrected) ──
def compute_corrected(sel, qty):
    active = []
    active.append("COMP_PRINT_DIGITAL_S1" if sel["side"]=="단면" else "COMP_PRINT_DIGITAL_S2")
    active.append("COMP_PAPER")
    if sel.get("coating")=="matte": active.append("COMP_COAT_MATTE")
    elif sel.get("coating")=="glossy": active.append("COMP_COAT_GLOSSY")
    for s in sel.get("spot", []):
        suf = "S1" if sel["side"]=="단면" else "S2"
        active.append(f"COMP_PRINT_SPOT_{s}_{suf}")
    active += sel.get("postproc", [])
    total = Decimal(0); lines = []; warn = []
    for cd in active:
        m = match_rows(cd, sel, qty)
        if m == [("MIN_UNMET", None)]: warn.append((cd,"최소수량 미달")); continue
        if not m: warn.append((cd,"매칭 단가행 없음(계산불가)")); continue
        if len(m) > 1: warn.append((cd,f"동시매칭 {len(m)}행(데이터 오류)"))
        r = m[0]; lp = line_price(cd, r, qty); total += lp
        lines.append((cd, comps[cd]["nm"], r["up"], lp))
    return total, lines, warn

def won(d): return int(d.quantize(Decimal("1"), rounding=ROUND_HALF_UP))

CASES = [
  {"name":"C1 단면4도·아트지300g·무코팅·100매","side":"단면","clr":"CLR_000005",
   "siz":PLATE_SIZ,"mat":"MAT_000082","coating":None,"spot":[],"postproc":[],"qty":100},
  {"name":"C2 단면4도·아트지300g·무코팅·500매","side":"단면","clr":"CLR_000005",
   "siz":PLATE_SIZ,"mat":"MAT_000082","coating":None,"spot":[],"postproc":[],"qty":500},
  {"name":"C3 단면4도·아트지300g·무광코팅단면·100매","side":"단면","clr":"CLR_000005",
   "siz":PLATE_SIZ,"mat":"MAT_000082","coating":"matte","coat":1,"spot":[],"postproc":[],"qty":100},
]
print(f"# 프리미엄엽서 PRD_000016 재계산 (출력판형={PLATE_SIZ}, 공식={FRM}, 기준일={BASE_YMD})\n")
for c in CASES:
    qty = c["qty"]
    ct, cl, cw = compute_corrected(c, qty)
    nt, nl, no = compute_naive(c, qty)
    print(f"## {c['name']}")
    print("  [보정매칭] 활성 구성요소:")
    for cd, nm, up, lp in cl:
        print(f"    - {nm:<22} 장당 {up:>8}  ×{qty} = {won(lp):>10,}")
    print(f"    → 보정 최종가 = {won(ct):>12,} 원")
    if cw: print(f"    ⚠ 경고: {cw}")
    print(f"  [명세 순수매칭] 매칭 comp {len(no)}개 → 합계 {won(nt):>12,} 원 (과대: {no})")
    print(f"  Δ 과대합산 = {won(nt-ct):>12,} 원\n")
