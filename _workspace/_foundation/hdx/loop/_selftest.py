#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""loop(P5) 셀프테스트 — 반자동 라운드 종합 정합 검증(라이브 읽기전용).

검증:
  [1] 라운드 종합 = board+plan+verify 무손실 반영(차원 결함·분류 카운트 일치)
  [2] 적재 후보 = P4 GO auto_data 만(재실측 NO-GO/SKIP 은 후보 아님)
  [3] 전 결함 회계: actionable + auto_nogo(결함) + 인간입력(worklist) 합 = 진단 총수(누락 0)
  [4] 산출물: round-report.md + loop-rounds.csv append
재실행: python3 _workspace/_foundation/hdx/loop/_selftest.py
"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2]))  # _foundation/
from hdx.foundation import Snapshot
from hdx.diagnose import PRICE_DIAGNOSERS
from hdx.remediate import PRICE_REMEDIATORS, plan
from hdx import board, verify as vf, loop as loop_mod


def main():
    snap = Snapshot()
    bres = board.run(PRICE_DIAGNOSERS, snap)
    pres = plan.run(PRICE_REMEDIATORS, bres.defects, snap)
    autos = pres.by_class.get("auto_data", [])
    verdicts = [vf.verify_fix(f) for f in autos]
    pairs = list(zip(autos, verdicts))

    rr = loop_mod.run_round(bres, pres, pairs, round_no="selftest", note="selftest")

    # [1] 무손실 반영
    assert sum(rr.dim_counts.values()) == len(bres.defects), "차원 결함 합 불일치"
    assert rr.global_go == bres.global_go, "전역 verdict 불일치"
    print(f"[1] 종합 무손실 OK (결함 {len(bres.defects)}·전역 {'GO' if rr.global_go else 'NO-GO'})")

    # [2] 적재 후보 = P4 GO auto_data 만
    for f, v in rr.actionable:
        assert v.verifiable and v.go, "적재 후보에 non-GO 혼입"
    assert len(rr.actionable) == sum(1 for _, v in pairs if v.verifiable and v.go)
    print(f"[2] 적재 후보 OK ({len(rr.actionable)}건·전부 P4 GO)")

    # [3] 전 결함 회계(누락 0)
    worklist_def = sum(rr.class_counts.get(c, (0, 0))[1]
                       for c in ("blocked_human", "needs_authority", "needs_design", "review"))
    auto_def = sum(rr.class_counts.get("auto_data", (0, 0))[1] for _ in [0])
    assert worklist_def + auto_def == len(bres.defects), \
        f"결함 회계 불일치: worklist {worklist_def} + auto {auto_def} != {len(bres.defects)}"
    print(f"[3] 전 결함 회계 OK (worklist {worklist_def} + auto_data {auto_def} = {len(bres.defects)}·누락 0)")

    # [4] 산출물
    assert rr.report_path and rr.report_path.exists(), "round-report.md 미생성"
    rounds = pathlib.Path(rr.report_path).parent / "loop-rounds.csv"
    assert rounds.exists(), "loop-rounds.csv 미생성"
    print(f"[4] 산출물 OK (round-report.md·loop-rounds.csv)")

    print("SELFTEST OK — hdx.loop P5 정합")


if __name__ == "__main__":
    main()
