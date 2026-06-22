#!/usr/bin/env python3
"""dryrun_evaluate.py — 접지카드 V2 교정 DRY-RUN (라이브 트랜잭션 + evaluate_price 실호출 + ROLLBACK).

목적: STEP 1(3FOLD) 교정을 라이브 트랜잭션 안에서 적용 → evaluate_price 실호출로
  "교정 전=4개 합산(25,000) vs 교정 후 3단 택일=6,000만 매칭"을 실증 → ROLLBACK(미커밋).

실행(webadmin 디렉터리에서, Django 부트스트랩):
    python dryrun_evaluate.py
실 COMMIT 없음 — 전 작업을 transaction.atomic + 강제 예외로 ROLLBACK.

★ unit_price 미변경(verbatim). 교정 = proc_cd 충전 + use_dims 토큰 등재만.
"""
import os
import sys
from decimal import Decimal

WEBADMIN = os.environ.get("WEBADMIN_DIR")
if not WEBADMIN:
    # raw/webadmin/webadmin 추정
    here = os.path.dirname(os.path.abspath(__file__))
    cand = os.path.abspath(os.path.join(here, "../../../../raw/webadmin/webadmin"))
    WEBADMIN = cand
sys.path.insert(0, WEBADMIN)
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

import django  # noqa: E402
django.setup()

from django.db import transaction, connection  # noqa: E402
from catalog import pricing as P  # noqa: E402
from catalog import models as M  # noqa: E402

PRD = "PRD_000027"  # 2단접지카드 (PRF_DGP_E 바인딩)
FRM = "PRF_DGP_E"

def fold_sum_at_qty1(selections, proc_sels):
    res = P.evaluate_price({"prd_cd": PRD}, selections, 1, mode="lenient", proc_sels=proc_sels)
    comps = res["base"]["components"]
    fold = [c for c in comps if c["comp_cd"].startswith("COMP_FOLD_LEAF_") and c["included"]]
    total = sum((c["subtotal"] for c in fold), Decimal(0))
    return total, [(c["comp_cd"], str(c["subtotal"])) for c in fold]

class _Rollback(Exception):
    pass

print("=" * 70)
print("DRY-RUN: 접지카드 V2 교정 (라이브 트랜잭션 · ROLLBACK 보장)")
print("=" * 70)

# 기준 차원(첫 구성요소 단가행에서 채움) — 접지비는 min_qty만 쓰므로 빈 selections로 충분
base_sel = {}

try:
    with transaction.atomic():
        # --- BEFORE: 교정 전, proc_sels 없이(현 라이브 상태) 4 접지비 합산 재현 ---
        # 현 라이브: use_dims=["min_qty"]·proc_cd NULL → is_proc=False → 4개 다 자동매칭 합산
        before_total, before_detail = fold_sum_at_qty1(base_sel, None)
        print(f"\n[BEFORE 교정] proc_sels=None (현 라이브):")
        print(f"  접지비 합산 = {before_total}  detail={before_detail}")

        # --- 교정 적용 (STEP 1: 3FOLD만 — proc_cd 실재분) ---
        with connection.cursor() as cur:
            cur.execute(
                "UPDATE t_prc_component_prices SET proc_cd=%s "
                "WHERE comp_cd=%s AND (proc_cd IS DISTINCT FROM %s)",
                ["PROC_000060", "COMP_FOLD_LEAF_3FOLD", "PROC_000060"])
            n_rows = cur.rowcount
            cur.execute(
                "UPDATE t_prc_price_components SET use_dims=%s::jsonb "
                "WHERE comp_cd=%s",
                ['["proc_cd","min_qty","proc_grp:PROC_000056"]', "COMP_FOLD_LEAF_3FOLD"])
        print(f"\n[교정 적용] 3FOLD proc_cd=PROC_000060 충전 {n_rows}행 + use_dims 토큰 등재")

        # --- AFTER: 손님이 3단접지(PROC_000060) 1개 택일 ---
        # proc_sels에 선택 공정 1개만 전달 → P8-1: is_proc comp(3FOLD)는 그 proc_cd로만 매칭
        sel_3fold = [{"proc_cd": "PROC_000060", "detail": {}}]
        after_total, after_detail = fold_sum_at_qty1(base_sel, sel_3fold)
        print(f"\n[AFTER 교정] proc_sels=[3단접지 PROC_000060] (손님 택일):")
        print(f"  접지비 합산 = {after_total}  detail={after_detail}")

        # --- 판정 ---
        print("\n" + "-" * 70)
        print(f"  교정 전 합산: {before_total}  (기대 25000 = 6000+7000+7000+5000)")
        print(f"  교정 후 택일: {after_total}  (기대 6000 = 3단접지만)")
        ok = (before_total == Decimal(25000)) and (after_total == Decimal(6000))
        print(f"  P8-1 택일 분리 실증: {'✅ SUCCESS' if ok else '⚠️ 재확인 필요'}")
        print("-" * 70)

        # --- verbatim 게이트: 단가행 합 불변 ---
        with connection.cursor() as cur:
            cur.execute("SELECT sum(unit_price) FROM t_prc_component_prices "
                        "WHERE comp_cd='COMP_FOLD_LEAF_3FOLD'")
            sum_after = cur.fetchone()[0]
        print(f"  3FOLD 단가행 합(교정 후) = {sum_after}  (기대 31965.00·불변)")
        print(f"  verbatim 게이트: {'✅ PASS' if str(sum_after)=='31965.00' else '⚠️ FAIL'}")

        raise _Rollback()  # 강제 ROLLBACK
except _Rollback:
    print("\n[ROLLBACK] 트랜잭션 미커밋 — 라이브 무변경 확인.")
