"""프리미엄엽서(PRD_000016) 인쇄비 구성요소 교정 — 개선 루프 recompute 증명.

목적: 구성요소(가격구성요소) 재배선이 골든을 재현하는지 라이브 엔진 verbatim 으로 증명.
- 엔진: raw/webadmin/.../pricing.py 의 순수함수(match_component/component_subtotal/...)를 무수정 임포트.
- 데이터: print-postcard 검증이 추출한 라이브 comp_prices.json/formula_comps.json(읽기전용 SELECT).
- 교정(데이터만): 프리미엄엽서=칼라전용·print_opt=면(단/양).
    · 단일 인쇄비 comp(S1, plt_siz_cd 키)로 통합.
    · POPT_000001(단면) ← 현재 S1/POPT_000002 값(칼라단면 D열) verbatim.
    · POPT_000002(양면) ← 현재 S2/POPT_000002 값(칼라양면 E열) verbatim.
    · 흑백 행(현 POPT_000001) 제거, S2 배선 제거(F-2 이중 해소).
- 날조 0: 모든 값은 라이브 실재 행에서 이동만. 엔진 코드 무변경.
"""
import json
import os
import sys
import types
import importlib.util
from decimal import Decimal

HERE = os.path.dirname(os.path.abspath(__file__))
PRIOR = os.path.join(HERE, "..", "..", "..", "print-postcard", "02_verify", "_recompute")
PRICING_PY = "/Users/innojini/Dev/HuniWeb/raw/webadmin/webadmin/catalog/pricing.py"

# --- 실제 pricing.py 순수함수 로드(catalog.models 스텁) ---
fake_catalog = types.ModuleType("catalog")
fake_models = types.ModuleType("catalog.models")
fake_catalog.models = fake_models
sys.modules["catalog"] = fake_catalog
sys.modules["catalog.models"] = fake_models
spec = importlib.util.spec_from_file_location("pricing", PRICING_PY)
pricing = importlib.util.module_from_spec(spec)
spec.loader.exec_module(pricing)

match_component = pricing.match_component
component_subtotal = pricing.component_subtotal
round_won = pricing.round_won
PRC_TYPE_UNIT = pricing.PRC_TYPE_UNIT

ALL_ROWS = json.load(open(os.path.join(PRIOR, "comp_prices.json"), encoding="utf-8"))
FORMULA_COMPS = json.load(open(os.path.join(PRIOR, "formula_comps.json"), encoding="utf-8"))

from collections import defaultdict


def build_index(rows):
    idx = defaultdict(list)
    for r in rows:
        row = dict(r)
        if row.get("unit_price") is not None:
            row["unit_price"] = Decimal(str(row["unit_price"]))
        idx[row["comp_cd"]].append(row)
    return idx


def evaluate(formula_comps, rows_by_comp, selections, qty, as_of="2026-06-18"):
    total = Decimal(0)
    out = []
    for c in sorted(formula_comps, key=lambda x: x["disp_seq"]):
        rows = rows_by_comp.get(c["comp_cd"], [])
        m = match_component(rows, selections, qty, as_of)
        prc_typ = c["comp_cd__prc_typ_cd"] or PRC_TYPE_UNIT
        if m.get("error") or m["row"] is None:
            out.append((c["comp_cd"], m.get("error") or "no_match", None, None))
            continue
        sub, per = component_subtotal(prc_typ, m["row"]["unit_price"], m["tier_min_qty"], qty)
        out.append((c["comp_cd"], "INCL", sub, per))
        total += sub
    return total, out


def show(name, total, out):
    print(f"\n=== {name} ===")
    for comp, st, sub, per in out:
        if st == "INCL":
            print(f"  [INCL] {comp:<26} subtotal={sub:>12}  (단가 per={per})")
        else:
            print(f"  [{st:<7}] {comp}")
    print(f"  ---- 인쇄비/소계 합 = {total}  (round_won={round_won(total)})")


# 인쇄비만 격리해서 본다(용지/코팅 등 다른 결함 분리). proc_cd=PROC_000004(디지털인쇄) 공급.
PRINT_ONLY = [c for c in FORMULA_COMPS
              if c["comp_cd"] in ("COMP_PRINT_DIGITAL_S1", "COMP_PRINT_DIGITAL_S2")]

SEL_DANMYEON = {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499",
                "print_opt_cd": "POPT_000001", "proc_cd": "PROC_000004"}
SEL_YANGMYEON = {"plt_siz_cd": "SIZ_000499", "siz_cd": "SIZ_000499",
                 "print_opt_cd": "POPT_000002", "proc_cd": "PROC_000004"}

# ---------- BASELINE (현재 라이브) ----------
base_idx = build_index(ALL_ROWS)
print("#" * 70)
print("# BASELINE (현재 라이브 데이터·S1+S2 둘다 배선)")
print("#" * 70)
t, o = evaluate(PRINT_ONLY, base_idx, dict(SEL_DANMYEON), 25)
show("단면(POPT_000001) 국4절 출력매수=25  [권위 골든 인쇄비=20,000]", t, o)

# ---------- 교정 적용 (데이터만) ----------
# S1.POPT_000002 = 칼라단면 D / S2.POPT_000002 = 칼라양면 E 를 단일 comp로 재배선.
def tier_map(comp_cd, key_field, key_val, print_opt):
    out = {}
    for r in ALL_ROWS:
        if (r["comp_cd"] == comp_cd and r.get(key_field) == key_val
                and r.get("print_opt_cd") == print_opt):
            out[r["min_qty"]] = Decimal(str(r["unit_price"]))
    return out

color_danmyeon = tier_map("COMP_PRINT_DIGITAL_S1", "plt_siz_cd", "SIZ_000499", "POPT_000002")  # D
color_yangmyeon = tier_map("COMP_PRINT_DIGITAL_S2", "siz_cd", "SIZ_000499", "POPT_000002")      # E

fixed_rows = []
for r in ALL_ROWS:
    if r["comp_cd"] == "COMP_PRINT_DIGITAL_S2":
        continue  # S2 배선 제거(F-2 이중 해소) — 인쇄비는 단일 comp
    if (r["comp_cd"] == "COMP_PRINT_DIGITAL_S1" and r.get("plt_siz_cd") == "SIZ_000499"):
        nr = dict(r)
        mq = r["min_qty"]
        if r.get("print_opt_cd") == "POPT_000001" and mq in color_danmyeon:
            nr["unit_price"] = color_danmyeon[mq]   # 단면 ← 칼라단면 D (F-1 교정)
            fixed_rows.append(nr)
        elif r.get("print_opt_cd") == "POPT_000002" and mq in color_yangmyeon:
            nr["unit_price"] = color_yangmyeon[mq]   # 양면 ← 칼라양면 E
            fixed_rows.append(nr)
        # 흑백 잔여행은 칼라전용 상품이라 제외(자연 누락)
    else:
        fixed_rows.append(r)

fixed_idx = build_index(fixed_rows)
FORMULA_FIXED = [c for c in PRINT_ONLY if c["comp_cd"] == "COMP_PRINT_DIGITAL_S1"]

print("\n" + "#" * 70)
print("# AFTER 교정 (단일 인쇄비 comp·print_opt=면·칼라전용 D/E·S2 제거)")
print("#" * 70)
t1, o1 = evaluate(FORMULA_FIXED, fixed_idx, dict(SEL_DANMYEON), 25)
show("단면 국4절 출력매수=25  [골든 800×25=20,000]", t1, o1)
t2, o2 = evaluate(FORMULA_FIXED, fixed_idx, dict(SEL_YANGMYEON), 25)
show("양면 국4절 출력매수=25  [골든 1600×25=40,000]", t2, o2)

# 잔여 caller-normalization 경계 입증: 주문수량(200매)을 그대로 넣으면(출력매수 미환산)
t3, o3 = evaluate(FORMULA_FIXED, fixed_idx, dict(SEL_DANMYEON), 200)
show("단면 국4절 qty=주문수량200(출력매수 미환산)  [엔진 한계: 호출측이 25로 줘야 함]", t3, o3)

print("\n" + "=" * 70)
print("판정:")
print(f"  단면 출력매수25 = {round_won(t1)}  (골든 20,000) -> {'PASS' if round_won(t1)==20000 else 'FAIL'}")
print(f"  양면 출력매수25 = {round_won(t2)}  (골든 40,000) -> {'PASS' if round_won(t2)==40000 else 'FAIL'}")
print(f"  baseline(교정전) 단면25 = {round_won(t)}  (틀림: 흑백+이중)")
print("=" * 70)
