#!/usr/bin/env python3
"""dryrun_evaluate.py — V1 과대청구 교정 DRY-RUN (라이브 트랜잭션 + evaluate_price 실호출 + ROLLBACK).

목적: print_opt_cd 충전 + use_dims 토큰을 라이브 트랜잭션 안에서 적용 → evaluate_price 실호출로
  "교정 전=단면+양면 둘 다 합산 vs 교정 후 단면 택일=단면값만 / 양면 택일=양면값만"을 실증 → ROLLBACK.

대상:
  명함  PRD_000031 ← PRF_NAMECARD_FIXED ← STD_S1(단면 3500)/STD_S2(양면 4500)  [MAT_000074·min_qty 100]
  엽서북 PRD_000094 ← PRF_PCB_FIXED      ← PCB_S1_20P(단면)/PCB_S2_20P(양면)     [SIZ_000003·min_qty 2]

실행(webadmin 디렉터리 자동 부트스트랩):  python dryrun_evaluate.py
실 COMMIT 없음 — transaction.atomic + 강제 예외로 ROLLBACK. unit_price 미변경(verbatim).
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


def comp_unit_sum(prd, selections, qty, comp_prefixes):
    """included comp들의 per_item(장당 단가) 합 + detail. 단가형 ×qty라 per_item으로 비교."""
    res = P.evaluate_price({"prd_cd": prd}, selections, qty, mode="lenient")
    comps = res["base"]["components"]
    inc = [c for c in comps
           if any(c["comp_cd"].startswith(p) for p in comp_prefixes) and c["included"]]
    total = sum((Decimal(str(c["per_item"])) for c in inc if c["per_item"] is not None), Decimal(0))
    return total, [(c["comp_cd"], str(c["per_item"])) for c in inc]


class _Rollback(Exception):
    pass


print("=" * 72)
print("DRY-RUN: V1 과대청구 교정 (라이브 트랜잭션 · ROLLBACK 보장)")
print("=" * 72)

NC_PREFIX = ["COMP_NAMECARD_STD_"]
PCB_PREFIX = ["COMP_PCB_S1_20P", "COMP_PCB_S2_20P"]
NC_QTY = 100   # 명함 min_qty=100 구간 (단가형 per_item 비교)
PCB_QTY = 2    # 엽서북 SIZ_000003 min_qty=2 구간

try:
    with transaction.atomic():
        # ====== BEFORE: 현 라이브 (print_opt_cd NULL → 단/양면 둘 다 합산) ======
        nc_before_single, nc_d0 = comp_unit_sum("PRD_000031", {"mat_cd": "MAT_000074"}, NC_QTY, NC_PREFIX)
        pcb_before_single, pcb_d0 = comp_unit_sum("PRD_000094", {"siz_cd": "SIZ_000003"}, PCB_QTY, PCB_PREFIX)
        print("\n[BEFORE 교정] print_opt_cd 미선택(현 라이브 NULL=와일드카드)·장당 단가 합:")
        print(f"  명함 PRD_000031 (qty={NC_QTY}) 장당합 = {nc_before_single}  detail={nc_d0}  (기대 8000 = 3500+4500 둘 다 매칭=과대)")
        print(f"  엽서북 PRD_000094 (qty={PCB_QTY}) 장당합 = {pcb_before_single}  detail={pcb_d0}  (기대 22500 = 11000+11500 둘 다=과대)")

        # ====== 교정 적용 (print_opt_cd 충전 + use_dims 토큰) ======
        with connection.cursor() as cur:
            cur.execute("UPDATE t_prc_component_prices SET print_opt_cd='POPT_000001' WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_PCB_S1_20P') AND print_opt_cd IS DISTINCT FROM 'POPT_000001'")
            n1 = cur.rowcount
            cur.execute("UPDATE t_prc_component_prices SET print_opt_cd='POPT_000002' WHERE comp_cd IN ('COMP_NAMECARD_STD_S2','COMP_PCB_S2_20P') AND print_opt_cd IS DISTINCT FROM 'POPT_000002'")
            n2 = cur.rowcount
            cur.execute("UPDATE t_prc_price_components SET use_dims='[\"mat_cd\",\"min_qty\",\"print_opt_cd\"]'::jsonb WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2')")
            cur.execute("UPDATE t_prc_price_components SET use_dims='[\"siz_cd\",\"min_qty\",\"print_opt_cd\"]'::jsonb WHERE comp_cd IN ('COMP_PCB_S1_20P','COMP_PCB_S2_20P')")
        print(f"\n[교정 적용] 단면행 {n1}행→POPT_000001 · 양면행 {n2}행→POPT_000002 + use_dims 토큰")

        # ====== AFTER: 손님이 단면(POPT_000001) 택일 ======
        nc_single, nc_d1 = comp_unit_sum("PRD_000031", {"mat_cd": "MAT_000074", "print_opt_cd": "POPT_000001"}, NC_QTY, NC_PREFIX)
        pcb_single, pcb_d1 = comp_unit_sum("PRD_000094", {"siz_cd": "SIZ_000003", "print_opt_cd": "POPT_000001"}, PCB_QTY, PCB_PREFIX)
        print("\n[AFTER 교정] 단면(POPT_000001) 택일·장당 단가:")
        print(f"  명함 = {nc_single}  detail={nc_d1}  (기대 3500 = 단면만)")
        print(f"  엽서북 = {pcb_single}  detail={pcb_d1}  (기대 11000 = 단면만·이중합산 제거)")

        # ====== AFTER: 손님이 양면(POPT_000002) 택일 ======
        nc_double, nc_d2 = comp_unit_sum("PRD_000031", {"mat_cd": "MAT_000074", "print_opt_cd": "POPT_000002"}, NC_QTY, NC_PREFIX)
        pcb_double, pcb_d2 = comp_unit_sum("PRD_000094", {"siz_cd": "SIZ_000003", "print_opt_cd": "POPT_000002"}, PCB_QTY, PCB_PREFIX)
        print("\n[AFTER 교정] 양면(POPT_000002) 택일·장당 단가:")
        print(f"  명함 = {nc_double}  detail={nc_d2}  (기대 4500 = 양면만)")
        print(f"  엽서북 = {pcb_double}  detail={pcb_d2}  (기대 11500 = 양면만·이중합산 제거)")

        # ====== verbatim 게이트: 단가행 합 불변 ======
        with connection.cursor() as cur:
            cur.execute("SELECT comp_cd, count(*), sum(unit_price) FROM t_prc_component_prices WHERE comp_cd IN ('COMP_NAMECARD_STD_S1','COMP_NAMECARD_STD_S2','COMP_PCB_S1_20P','COMP_PCB_S2_20P') GROUP BY comp_cd ORDER BY comp_cd")
            rows = cur.fetchall()
        print("\n[verbatim 게이트] 단가행 행수·합 (불변 기대):")
        expect = {"COMP_NAMECARD_STD_S1": (2, "7300.00"), "COMP_NAMECARD_STD_S2": (2, "9300.00"),
                  "COMP_PCB_S1_20P": (117, "505980.00"), "COMP_PCB_S2_20P": (117, "526540.00")}
        vbat_ok = True
        for cc, n, s in rows:
            exp = expect[cc]
            ok = (n == exp[0] and str(s) == exp[1])
            vbat_ok = vbat_ok and ok
            print(f"  {cc}: rows={n} sum={s}  {'OK' if ok else 'FAIL exp '+str(exp)}")

        gate_ok = (nc_before_single == Decimal(8000) and pcb_before_single == Decimal(22500)
                   and nc_single == Decimal(3500) and nc_double == Decimal(4500)
                   and pcb_single == Decimal(11000) and pcb_double == Decimal(11500))
        print("\n" + "-" * 72)
        print(f"  명함  BEFORE 8000(이중) → 단면 {nc_single}(기대3500) · 양면 {nc_double}(기대4500)")
        print(f"  엽서북 BEFORE 22500(이중) → 단면 {pcb_single}(기대11000) · 양면 {pcb_double}(기대11500)")
        print(f"  택일 분리 실증: {'SUCCESS' if gate_ok else 'REVIEW'}  ·  verbatim: {'PASS' if vbat_ok else 'FAIL'}")
        print("-" * 72)

        raise _Rollback()
except _Rollback:
    print("\n[ROLLBACK] 트랜잭션 미커밋 — 라이브 무변경 확인.")
