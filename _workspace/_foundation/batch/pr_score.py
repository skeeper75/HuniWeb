#!/usr/bin/env python3
"""
pr_score — PR(가격 재현) 채점: 엔진 simulate 금액 ↔ 예전사이트 골든 공급가 대조.

배치 채점기에 "가격이 맞나"(정답 대조)를 붙이는 토대. score_batch 의 기존
채점(CALC/PR-pansu/R1/R3/OC)은 손대지 않고, PR-가격재현 점수를 별도 산출한다.

흐름:
  1) prd-pcode-map.csv 로 prd_cd → 예전사이트 pcode(high/mid 만).
  2) 엔진 케이스(사이즈 라벨·용지·인쇄·수량)를 예전사이트 폼 라벨로 브리지.
  3) golden_fetch 로 같은 구성의 공급가 골든 추출.
  4) 엔진가 vs 골든가 대조 → match / mismatch(차이=조사신호) / no-golden.

★위상[HARD]: 예전사이트=구 시스템·권위 엑셀이 절대. PR-mismatch 는 **조사
  신호**일 뿐 자동 교정 트리거가 아니다(라이브에 맞춰 우리 값 변경 금지).
★브라우저 독점: golden_fetch(gstack browse)는 단일 세션 — PR 채점이 전담.

[HARD] 라이브 읽기탐색만. 값 날조 0. 골든 못 읽으면 'no-golden'(누락 은폐 금지).
"""
import os
import re
import csv

HERE = os.path.dirname(os.path.abspath(__file__))
PCODE_MAP = os.path.join(HERE, "prd-pcode-map.csv")

import golden_fetch as GF

# 허용오차: 정확 일치가 기본. round-off/표시차 흡수용 소폭(원). 0 = strict.
PR_TOLERANCE_ABS = 0
PR_TOLERANCE_PCT = 0.0   # 0% = 완전 일치 요구(차이는 전부 신호)


# ─────────────────────────────────────────────────────────────────────
# prd_cd → pcode 매핑 로드
# ─────────────────────────────────────────────────────────────────────
_MAP = None


def _load_map():
    global _MAP
    if _MAP is not None:
        return _MAP
    m = {}
    if os.path.exists(PCODE_MAP):
        with open(PCODE_MAP, encoding="utf-8") as f:
            for r in csv.DictReader(f):
                m[r["prd_cd"]] = r
    _MAP = m
    return m


def pcode_for(prd_cd):
    """prd_cd → (pcode, confidence) 또는 (None, 사유). high/mid 만 채점 후보."""
    row = _load_map().get(prd_cd)
    if not row:
        return None, "맵 미등재"
    conf = row.get("confidence", "")
    pc = (row.get("pcode") or "").strip()
    if not pc or conf.startswith("미상"):
        return None, conf or "pcode 미상"
    return pc, conf


# ─────────────────────────────────────────────────────────────────────
# 엔진 라벨 → 예전사이트 폼 라벨 브리지
# ─────────────────────────────────────────────────────────────────────
def size_to_live(engine_size_label):
    """엔진 사이즈 '73x98' / '100x150' → 예전사이트 '73mm x 98mm'.
       매칭은 golden_fetch._opt_match 가 공백무시 부분일치라 'mm' 유무 흡수되나,
       명시 변환으로 정확도↑. 변환 불가면 원문 그대로(폴백)."""
    if not engine_size_label:
        return None
    s = str(engine_size_label).strip().lower().replace("mm", "").replace(" ", "")
    m = re.match(r"^(\d+)x(\d+)$", s)
    if m:
        return f"{m.group(1)}mm x {m.group(2)}mm"
    return engine_size_label


def material_to_live(engine_mat_label):
    """엔진 자재 라벨 '백색모조지 220g (MAT_000074)' → '백색모조지 220g'.
       (코드 괄호 제거). golden_fetch 가 부분일치라 이대로 매칭됨."""
    if not engine_mat_label:
        return None
    return re.sub(r"\s*\([A-Z]+_\d+\)\s*$", "", str(engine_mat_label)).strip()


def print_to_live(engine_popt_label):
    """인쇄옵션 라벨 '단면 (POPT_000001)' → '단면'."""
    if not engine_popt_label:
        return None
    t = re.sub(r"\s*\([A-Z]+_\d+\)\s*$", "", str(engine_popt_label)).strip()
    if "단면" in t:
        return "단면"
    if "양면" in t:
        return "양면"
    return t


# ─────────────────────────────────────────────────────────────────────
# PR 채점 — 한 케이스
# ─────────────────────────────────────────────────────────────────────
def _verdict(engine_price, golden):
    """엔진가 vs 골든가 판정."""
    if golden is None:
        return "no-golden"
    if engine_price is None or engine_price == 0:
        return "engine-0"          # 엔진이 0 — CALC 결함과 중복신호
    diff = engine_price - golden
    tol = max(PR_TOLERANCE_ABS, golden * PR_TOLERANCE_PCT)
    if abs(diff) <= tol:
        return "match"             # 가격 정확 재현(고신뢰)
    return "mismatch"              # 차이=조사신호(자동교정 아님)


def score_pr_case(prd_cd, engine_price, size_label=None, mat_label=None,
                  popt_label=None, qty=100, extra=None):
    """한 케이스 PR 채점. golden_fetch 1회 호출(브라우저 독점).
    반환 dict: {pcode, conf, golden, engine, diff, pct, verdict, note, picked}."""
    pc, conf = pcode_for(prd_cd)
    if not pc:
        return {"prd_cd": prd_cd, "pcode": None, "conf": conf,
                "golden": None, "engine": engine_price, "verdict": "no-pcode",
                "note": f"pcode 미상({conf})", "picked": {}}
    g = GF.fetch_golden(
        pc,
        size=size_to_live(size_label),
        paper=material_to_live(mat_label),
        print_side=print_to_live(popt_label) or "단면",
        qty=qty,
        extra_selects=extra,
    )
    golden = g.get("supply")
    v = _verdict(engine_price, golden)
    diff = (engine_price - golden) if (golden and engine_price) else None
    pct = round(100 * diff / golden, 1) if (diff is not None and golden) else None
    return {
        "prd_cd": prd_cd, "pcode": pc, "conf": conf,
        "golden": golden, "engine": engine_price,
        "diff": diff, "pct": pct, "verdict": v,
        "note": g.get("note", ""), "breadcrumb": g.get("breadcrumb", ""),
        "picked": g.get("picked", {}),
    }


# ─────────────────────────────────────────────────────────────────────
# CLI(단독 점검) — prd_cd 하나 PR 채점 데모
# ─────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    import sys
    import json
    import lib_huni as H
    H.load_env()
    prd = sys.argv[1] if len(sys.argv) > 1 else "PRD_000016"
    sim = H.HuniSim()
    meta = sim.sim_meta(prd)

    def dim_opts(name):
        for d in meta.get("prod_dims", []):
            if d.get("name") == name:
                return d.get("options", [])
        return []

    sizes = dim_opts("siz_cd")
    mats = dim_opts("mat_cd")
    popts = dim_opts("print_opt_cd")
    if not sizes:
        print("siz_cd 옵션 없음 — 면적/세트 모델은 별도 케이스 빌더 필요")
        sys.exit(0)
    sz = sizes[0]
    sel = {"siz_cd": sz["v"]}
    if mats:
        sel["mat_cd"] = mats[0]["v"]
    if popts:
        sel["print_opt_cd"] = popts[0]["v"]
    # 인쇄공정 폴백(프리미엄엽서 셀프테스트 정합)
    procs = [{"proc_cd": "PROC_000004"}] if prd == "PRD_000016" else None
    res = sim.simulate(prd, sel, 100, procs=procs)
    eng = H.price_of(res)
    pr = score_pr_case(
        prd, eng,
        size_label=sz["t"], mat_label=(mats[0]["t"] if mats else None),
        popt_label=(popts[0]["t"] if popts else None), qty=100)
    print(json.dumps({"engine_price": eng, "pr": pr},
                     ensure_ascii=False, indent=2))
