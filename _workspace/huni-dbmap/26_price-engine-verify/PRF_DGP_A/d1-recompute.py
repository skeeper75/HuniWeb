#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""d1-recompute.py — round-18+ PRF_DGP_A D-1 변환 + D-2 멤버십 결합 재계산 검증기.

목적: 작업사이즈→출력판형 변환(D-1)을 라이브 룩업(t_siz_sizes.note 전지치수)으로
구현하고, D-2 멤버십(가설 A: 옵션 선택→활성 comp 집합)을 명세 표로 적용해
대표 케이스를 재계산. 결과를 가격표 엑셀 known 단가와 대조.

[HARD] 보정 하드코딩(compute_corrected류) 금지. 활성 comp는
remediation-plan §1 멤버십 표(가설 A로 채택·DDL 제안 상태)를 "선언 데이터"로 두고,
단가/차원매칭/수량구간/시계열은 전부 라이브 component_prices에서 조회. 읽기전용(SELECT만).

D-1 변환 = note 전지치수 파싱 → impos_yn=Y 동일 work 치수 siz 룩업 (라이브, 추정 0).
"""
import os
import subprocess
import json
from decimal import Decimal, ROUND_HALF_UP

ROOT = subprocess.check_output(["git", "rev-parse", "--show-toplevel"]).decode().strip()
ENV: dict[str, str] = {}
for line in open(os.path.join(ROOT, ".env.local")):
    line = line.strip()
    if line and not line.startswith("#") and "=" in line:
        k, v = line.split("=", 1)
        ENV[k] = v

FRM = "PRF_DGP_A"
BASE_YMD = "2026-06-14"


def q(sql: str) -> list[list[str]]:
    """라이브 읽기전용 SELECT만 실행."""
    env = dict(os.environ)
    env["PGPASSWORD"] = ENV["RAILWAY_DB_PASSWORD"]
    out = subprocess.check_output(
        ["psql", "-h", ENV["RAILWAY_DB_HOST"], "-p", ENV["RAILWAY_DB_PORT"],
         "-U", ENV["RAILWAY_DB_USER"], "-d", ENV["RAILWAY_DB_NAME"],
         "-At", "-F", "\t", "--no-psqlrc", "-c", sql], env=env).decode()
    return [r.split("\t") for r in out.splitlines() if r]


# ── D-1 변환: 작업사이즈 → 출력판형 siz_cd (라이브 note 룩업) ──
def resolve_plate(prd_cd: str, work_siz: str) -> str | None:
    """작업사이즈 note의 '전지=WxH'를 파싱해 impos_yn=Y 동일 work 치수 siz 반환."""
    rows = q(f"""
      with src as (
        select substring(s.note from '전지=([0-9]+x[0-9]+)') as jeonji
        from t_prd_product_sizes ps join t_siz_sizes s on s.siz_cd=ps.siz_cd
        where ps.prd_cd='{prd_cd}' and ps.siz_cd='{work_siz}' and ps.del_yn='N')
      select p.siz_cd from src
        join t_siz_sizes p
          on p.work_width = split_part(src.jeonji,'x',1)::numeric
         and p.work_height = split_part(src.jeonji,'x',2)::numeric
         and p.impos_yn='Y'
      where src.jeonji is not null
      limit 1""")
    return rows[0][0] if rows else None


# ── 공식 구성요소 메타 + 단가행 적재 ──
def load_comps() -> dict[str, dict]:
    comps: dict[str, dict] = {}
    for cd, ptyp, dims in q(f"""
      select fc.comp_cd, pc.prc_typ_cd, pc.use_dims
      from t_prc_formula_components fc
      join t_prc_price_components pc on pc.comp_cd=fc.comp_cd
      where fc.frm_cd='{FRM}' order by fc.disp_seq"""):
        comps[cd] = {"ptyp": ptyp, "dims": json.loads(dims), "rows": []}
    for cd in comps:
        for siz, clr, mat, coat, mq, up, ymd in q(f"""
          select coalesce(siz_cd,''),coalesce(clr_cd,''),coalesce(mat_cd,''),
                 coalesce(coat_side_cnt::text,''),coalesce(min_qty::text,''),
                 unit_price,apply_ymd
          from t_prc_component_prices where comp_cd='{cd}'"""):
            comps[cd]["rows"].append({
                "siz": siz, "clr": clr, "mat": mat, "coat": coat,
                "mq": int(mq) if mq else None, "up": Decimal(up), "ymd": ymd})
    return comps


def match_rows(comps: dict, cd: str, sel: dict, qty: int):
    """use_dims·NULL 와일드카드·수량구간(이하 최대 min_qty)·시계열(최신 ymd)."""
    dims = comps[cd]["dims"]
    cand = []
    for r in comps[cd]["rows"]:
        if r["ymd"] > BASE_YMD:
            continue
        ok = True
        if "siz_cd" in dims and r["siz"] and r["siz"] != sel.get("siz", ""):
            ok = False
        if "clr_cd" in dims and r["clr"] and r["clr"] != sel.get("clr", ""):
            ok = False
        if "mat_cd" in dims and r["mat"] and r["mat"] != sel.get("mat", ""):
            ok = False
        if "coat_side_cnt" in dims and r["coat"] and r["coat"] != str(sel.get("coat", "")):
            ok = False
        if ok:
            cand.append(r)
    if not cand:
        return []
    if any(c["mq"] is not None for c in cand):
        elig = [c for c in cand if c["mq"] is not None and c["mq"] <= qty]
        if not elig:
            return [("MIN_UNMET", None)]
        best = max(c["mq"] for c in elig)
        cand = [c for c in elig if c["mq"] == best]
    ny = max(c["ymd"] for c in cand)
    cand = [c for c in cand if c["ymd"] == ny]
    return cand


# 후가공 13 comp: 가격표 헤더 "(합가)" 명시·셀 값=수량구간 총액(가격표 실측 §A).
# 라이브 prc_typ_cd=.01(단가형) = 오적재(결함 D-1b). 단가행값=가격표 총액과 전건 일치.
# 정확 의미 = ⓒ "구간 총액 그대로(수량 무관 1회 부과)" — 명세 .02 환산(÷min_qty×qty)도
# 가격표 단조성 위반(250매가 300매 초과)이라 부적합. 세 방식 비교용.
POSTPROC_TOTAL_TYPE = {
    "COMP_PP_CORNER_ROUND", "COMP_PP_CREASE_1L", "COMP_PP_CREASE_2L", "COMP_PP_CREASE_3L",
    "COMP_PP_PERF_1L", "COMP_PP_PERF_2L", "COMP_PP_PERF_3L",
    "COMP_PP_VARIMG_1EA", "COMP_PP_VARIMG_2EA", "COMP_PP_VARIMG_3EA",
    "COMP_PP_VARTEXT_1EA", "COMP_PP_VARTEXT_2EA", "COMP_PP_VARTEXT_3EA",
}

# mode: "live01"=라이브 선언대로(.01 단가형, up×qty) /
#       "spec02"=명세 합가형(.02, up÷min_qty×qty) /
#       "fixedtotal"=ⓒ 구간총액 그대로(up, 후가공 정확 의미)
def line_price(comps: dict, cd: str, r: dict, qty: int, postproc_mode: str = "live01") -> Decimal:
    up = r["up"]
    if cd in POSTPROC_TOTAL_TYPE:
        if postproc_mode == "fixedtotal":
            return up                                   # ⓒ 구간총액 그대로(정확)
        if postproc_mode == "spec02":
            return (up / (r["mq"] or 1)) * qty          # 명세 .02 환산(가격표 단조성 위반)
        return up * qty                                 # live01: .01 단가형 오적재(×qty 과대)
    # 비-후가공: 라이브 prc_typ_cd 그대로(인쇄/용지/코팅=단가형 .01)
    if comps[cd]["ptyp"] == "PRICE_TYPE.02":
        return (up / (r["mq"] or 1)) * qty
    return up * qty


def won(d: Decimal) -> int:
    return int(d.quantize(Decimal("1"), rounding=ROUND_HALF_UP))


# ── D-2 멤버십 (가설 A·remediation-plan §1) ──
# 옵션 선택 → 활성 comp 집합. 라이브 option_items는 오적재(검증 §13)라 직접 못 씀.
# 가설 A 채택분(DDL 제안 상태)을 "선언 데이터"로 둠 — 단가/매칭은 전부 라이브.
def membership(sel: dict) -> list[str]:
    active: list[str] = []
    active.append("COMP_PRINT_DIGITAL_S1" if sel["side"] == "단면" else "COMP_PRINT_DIGITAL_S2")
    active.append("COMP_PAPER")
    if sel.get("coating") == "matte":
        active.append("COMP_COAT_MATTE")
    elif sel.get("coating") == "glossy":
        active.append("COMP_COAT_GLOSSY")
    if sel.get("corner") == "round":
        active.append("COMP_PP_CORNER_ROUND")
    elif sel.get("corner") == "right":
        active.append("COMP_PP_CORNER_RIGHT")
    active += sel.get("postproc", [])
    return active


def recompute(comps: dict, sel: dict, qty: int, postproc_mode: str = "live01"):
    active = membership(sel)
    total = Decimal(0)
    lines = []
    warn = []
    for cd in active:
        m = match_rows(comps, cd, sel, qty)
        if m == [("MIN_UNMET", None)]:
            warn.append((cd, "최소수량 미달"))
            continue
        if not m:
            warn.append((cd, "매칭 단가행 없음(계산불가)"))
            continue
        if len(m) > 1:
            warn.append((cd, f"동시매칭 {len(m)}행(데이터 오류)"))
        r = m[0]
        lp = line_price(comps, cd, r, qty, postproc_mode)
        total += lp
        lines.append((cd, r["up"], won(lp)))
    return total, lines, warn


def main() -> None:
    comps = load_comps()
    # 대표 케이스: 016 프리미엄엽서, 작업사이즈 100x150(SIZ_000003), 단면 4도, 아트지300g, 무코팅, 직각, 오시 1선
    cases = [
        {"name": "C1 016·100x150·단면4도·아트지300g·무코팅·직각·100매",
         "prd": "PRD_000016", "work": "SIZ_000003", "side": "단면",
         "clr": "CLR_000005", "mat": "MAT_000082", "coating": None,
         "corner": "right", "postproc": [], "qty": 100},
        {"name": "C2 016·100x150·단면4도·아트지300g·무코팅·직각·500매",
         "prd": "PRD_000016", "work": "SIZ_000003", "side": "단면",
         "clr": "CLR_000005", "mat": "MAT_000082", "coating": None,
         "corner": "right", "postproc": [], "qty": 500},
        {"name": "C3 016·100x150·단면4도·아트지300g·무광코팅단면·직각·오시1선·100매",
         "prd": "PRD_000016", "work": "SIZ_000003", "side": "단면",
         "clr": "CLR_000005", "mat": "MAT_000082", "coating": "matte", "coat": 1,
         "corner": "right", "postproc": ["COMP_PP_CREASE_1L"], "qty": 100},
        {"name": "C4 016·100x150·단면4도·아트지300g·무코팅·직각·오시1선·250매 (비경계 수량=ⓒ vs .02 분기)",
         "prd": "PRD_000016", "work": "SIZ_000003", "side": "단면",
         "clr": "CLR_000005", "mat": "MAT_000082", "coating": None,
         "corner": "right", "postproc": ["COMP_PP_CREASE_1L"], "qty": 250},
    ]
    print(f"# PRF_DGP_A D-1+D-2 결합 재계산 (공식={FRM}, 기준일={BASE_YMD})\n")
    for c in cases:
        plate = resolve_plate(c["prd"], c["work"])
        c["siz"] = plate
        qty = c["qty"]
        t_live, lines, warn = recompute(comps, c, qty, "live01")
        t_spec, _, _ = recompute(comps, c, qty, "spec02")
        t_fix, lines_fix, _ = recompute(comps, c, qty, "fixedtotal")
        print(f"## {c['name']}")
        print(f"  [D-1 변환] 작업사이즈 {c['work']} → note 전지 → 출력판형 siz = {plate}")
        print("  활성 구성요소(단가행 = 가격표 셀과 전건 일치):")
        for (cd, up, lp), (_, _, lpf) in zip(lines, lines_fix):
            tag = "  ← 후가공" if cd in POSTPROC_TOTAL_TYPE else ""
            print(f"    - {cd:<26} 단가행 {up:>9}  / 정정라인 {lpf:>9,}{tag}")
        has_pp = any(cd in POSTPROC_TOTAL_TYPE for cd, *_ in lines)
        print(f"    → 라이브 선언(.01 ×qty)     = {won(t_live):>12,} 원" + (
            "  🔴 후가공 ×수량 과대" if has_pp else ""))
        if has_pp:
            print(f"    → 명세 .02 환산(÷mq×qty)   = {won(t_spec):>12,} 원  "
                  "🟡 가격표 단조성 위반(부적합)")
            print(f"    → ⓒ 정정(구간총액 그대로)  = {won(t_fix):>12,} 원  ✅ 가격표 정합")
        if warn:
            print(f"    ⚠ 경고: {warn}")
        print()


if __name__ == "__main__":
    main()
