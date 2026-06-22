#!/usr/bin/env python3
"""dryrun_evaluate.py — 포토카드 V3 교정 DRY-RUN (라이브 트랜잭션 + evaluate_price 실호출 + ROLLBACK).

목적:
  BEFORE(현 라이브): 024·025 둘 다 PRF_PHOTOCARD_FIXED → 일반6,000+투명8,500 silent 합산=14,500.
  AFTER(교정 적용): 024→PRF_PHOTOCARD_NORMAL(일반6,000만)·025→PRF_PHOTOCARD_CLEAR(투명8,500만).
  → evaluate_price 실호출로 14,500→6,000(024)·14,500→8,500(025) 실증 → ROLLBACK(미커밋).

실행(webadmin 디렉터리 자동 부트스트랩):
    python dryrun_evaluate.py
실 COMMIT 없음 — transaction.atomic + 강제 예외로 ROLLBACK.

★ unit_price 미변경(verbatim). 교정 = 공식 분리(신규 FRM 2 + FC 배선 + BIND 재배선)만.
"""
import os
import sys
from decimal import Decimal

WEBADMIN = os.environ.get("WEBADMIN_DIR")
if not WEBADMIN:
    here = os.path.dirname(os.path.abspath(__file__))
    cand = os.path.abspath(os.path.join(here, "../../../../raw/webadmin/webadmin"))
    WEBADMIN = cand
sys.path.insert(0, WEBADMIN)
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

import django  # noqa: E402
django.setup()

from django.db import transaction, connection  # noqa: E402
from catalog import pricing as P  # noqa: E402


def base_total(prd_cd, selections, proc_sels=None):
    res = P.evaluate_price({"prd_cd": prd_cd}, selections, 1, mode="lenient", proc_sels=proc_sels)
    comps = res["base"]["components"]
    inc = [c for c in comps if c.get("comp_cd", "").startswith("COMP_PHOTOCARD") and c["included"]]
    total = sum((c["subtotal"] for c in inc), Decimal(0))
    return total, [(c["comp_cd"], str(c["subtotal"])) for c in inc], res["base"].get("amount")


class _Rollback(Exception):
    pass


print("=" * 72)
print("DRY-RUN: 포토카드 V3 공식분리 교정 (라이브 트랜잭션 · ROLLBACK 보장)")
print("=" * 72)

# 포토카드 세트 차원: siz_cd=SIZ_000012·bdl_qty=20·min_qty=1 (단가행 차원). 빈 selections로 매칭.
sel = {}
results = {}

try:
    with transaction.atomic():
        # --- BEFORE: 현 라이브(둘 다 PRF_PHOTOCARD_FIXED) ---
        b24_total, b24_detail, b24_amt = base_total("PRD_000024", sel)
        b25_total, b25_detail, b25_amt = base_total("PRD_000025", sel)
        print("\n[BEFORE 교정] (현 라이브·둘 다 PRF_PHOTOCARD_FIXED):")
        print(f"  024 포토카드      base.amount={b24_amt}  comps={b24_detail}")
        print(f"  025 투명포토카드  base.amount={b25_amt}  comps={b25_detail}")

        # --- 교정 적용 (apply.sql Phase A~D 동등) ---
        with connection.cursor() as cur:
            cur.execute(
                "INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) "
                "VALUES ('PRF_PHOTOCARD_NORMAL','일반포토카드 세트 고정가','dryrun','Y') "
                "ON CONFLICT (frm_cd) DO NOTHING")
            cur.execute(
                "INSERT INTO t_prc_price_formulas (frm_cd, frm_nm, note, use_yn) "
                "VALUES ('PRF_PHOTOCARD_CLEAR','투명포토카드 세트 고정가','dryrun','Y') "
                "ON CONFLICT (frm_cd) DO NOTHING")
            cur.execute(
                "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) "
                "VALUES ('PRF_PHOTOCARD_NORMAL','COMP_PHOTOCARD_SET',1,'Y') "
                "ON CONFLICT (frm_cd, comp_cd) DO NOTHING")
            cur.execute(
                "INSERT INTO t_prc_formula_components (frm_cd, comp_cd, disp_seq, addtn_yn) "
                "VALUES ('PRF_PHOTOCARD_CLEAR','COMP_PHOTOCARD_CLEAR_SET',1,'Y') "
                "ON CONFLICT (frm_cd, comp_cd) DO NOTHING")
            cur.execute(
                "UPDATE t_prd_product_price_formulas SET frm_cd='PRF_PHOTOCARD_NORMAL' "
                "WHERE prd_cd='PRD_000024' AND apply_bgn_ymd='2026-06-01'")
            cur.execute(
                "UPDATE t_prd_product_price_formulas SET frm_cd='PRF_PHOTOCARD_CLEAR' "
                "WHERE prd_cd='PRD_000025' AND apply_bgn_ymd='2026-06-01'")
            cur.execute(
                "UPDATE t_prc_price_formulas SET use_yn='N' WHERE frm_cd='PRF_PHOTOCARD_FIXED'")
        print("\n[교정 적용] 신규 FRM 2 + FC 배선 2 + BIND 재배선 2 + FIXED use_yn=N")

        # --- AFTER: 교정 후 각 상품 자기 comp만 ---
        a24_total, a24_detail, a24_amt = base_total("PRD_000024", sel)
        a25_total, a25_detail, a25_amt = base_total("PRD_000025", sel)
        print("\n[AFTER 교정] (024→NORMAL·025→CLEAR):")
        print(f"  024 포토카드      base.amount={a24_amt}  comps={a24_detail}")
        print(f"  025 투명포토카드  base.amount={a25_amt}  comps={a25_detail}")

        # --- 판정 ---
        print("\n" + "-" * 72)
        ok24 = (b24_total == Decimal(14500)) and (a24_total == Decimal(6000))
        ok25 = (b25_total == Decimal(14500)) and (a25_total == Decimal(8500))
        print(f"  024: BEFORE {b24_total} → AFTER {a24_total}  (기대 14500→6000)  {'✅' if ok24 else '⚠️'}")
        print(f"  025: BEFORE {b25_total} → AFTER {a25_total}  (기대 14500→8500)  {'✅' if ok25 else '⚠️'}")
        print(f"  V3 공식분리 silent 합산 제거 실증: {'✅ SUCCESS' if (ok24 and ok25) else '⚠️ 재확인 필요'}")
        print("-" * 72)

        # --- verbatim 게이트: 단가행 합 불변 ---
        with connection.cursor() as cur:
            cur.execute("SELECT comp_cd, sum(unit_price) FROM t_prc_component_prices "
                        "WHERE comp_cd IN ('COMP_PHOTOCARD_SET','COMP_PHOTOCARD_CLEAR_SET') "
                        "GROUP BY comp_cd ORDER BY comp_cd")
            sums = cur.fetchall()
        vb = {c: str(s) for c, s in sums}
        vb_ok = (vb.get("COMP_PHOTOCARD_SET") == "6000.00"
                 and vb.get("COMP_PHOTOCARD_CLEAR_SET") == "8500.00")
        print(f"  단가행 합(교정 후): {vb}  verbatim {'✅ PASS' if vb_ok else '⚠️ FAIL'}")

        results = {"ok24": ok24, "ok25": ok25, "vb_ok": vb_ok}
        raise _Rollback()
except _Rollback:
    print("\n[ROLLBACK] 트랜잭션 미커밋 — 라이브 무변경 확인.")

print("\n결과 요약:", results)
sys.exit(0 if all(results.values()) else 1)
