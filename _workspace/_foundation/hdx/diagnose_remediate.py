#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""hdx 진입점 — 입체 진단 → 통합 결함보드 → 전역 verdict (설계 §2·§5 P2).

    python3 _workspace/_foundation/hdx/diagnose_remediate.py --scope price [--round N] [--snap DIR]

흐름(P2 범위): snapshot 로드 → 5 Diagnoser.scan → 통합 보드(CSV+HTML) → 전역 GO/NO-GO 출력.
교정 생성(P3)·적대적 재실측(P4)·반자동 루프(P5)는 후속. 완전 무인 아님(적재=인간 게이트).

[HARD] 라이브 스냅샷 읽기전용·결정론·토큰0. 스냅샷은 시점 사본 → 교정/게이트 단계는 라이브 재-SELECT.
재실행 안전(멱등): 보드 산출만 덮어씀.
"""
from __future__ import annotations
import argparse
import csv
import pathlib
import sys

_HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(_HERE.parent))          # _foundation/ (hdx 패키지 루트)

from hdx.foundation import Snapshot            # noqa: E402
from hdx.diagnose import PRICE_DIAGNOSERS      # noqa: E402
from hdx import board                          # noqa: E402
from hdx.remediate import PRICE_REMEDIATORS, plan  # noqa: E402

SCOPES = {"price": PRICE_DIAGNOSERS}           # 전파 시 platesize/option/qty 추가
REMEDIATORS = {"price": PRICE_REMEDIATORS}


def main():
    ap = argparse.ArgumentParser(description="hdx 통합 진단·교정 배치(P2 진단·보드)")
    ap.add_argument("--scope", default="price", choices=sorted(SCOPES),
                    help="진단 도메인(파일럿=price)")
    ap.add_argument("--round", dest="rnd", default=None, help="라운드 번호(수렴 추이 기록)")
    ap.add_argument("--snap", default=None, help="스냅샷 디렉토리(기본=live-snapshot/latest)")
    ap.add_argument("--note", default="", help="라운드 메모")
    ap.add_argument("--remediate", action="store_true",
                    help="진단 후 교정 플랜(P3) 생성: worklist(md/csv) + auto_data SQL 트리플")
    args = ap.parse_args()

    snap = Snapshot(args.snap)
    diagnosers = SCOPES[args.scope]

    res = board.run(diagnosers, snap)
    csv_path = board.write_csv(res)
    html_path = board.write_html(res)

    # 콘솔 요약(연속 라운드 비교용 1줄 + 차원별)
    print(f"[hdx] scope={args.scope} snap={res.snap_name} "
          f"defects={len(res.defects)} => {'GO' if res.global_go else 'NO-GO'}")
    for dx in diagnosers:
        n = len(res.per_dim.get(dx.dimension, []))
        ok = res.verdicts.get(dx.dimension)
        print(f"    {dx.dimension:16s} {n:4d}건  {'GO' if ok else 'NO-GO'}  ({dx.title})")
    money_n = sum(1 for d in res.defects if d.money_impact in ("undercharge", "overcharge"))
    crit_n = sum(1 for d in res.defects if d.severity == "critical")
    print(f"    돈영향(저/과청구) {money_n}건 · 치명 {crit_n}건")
    print(f"  -> {csv_path}")
    print(f"  -> {html_path}")

    # ── P3 교정 플랜(옵션) ──
    if args.remediate:
        pres = plan.run(REMEDIATORS[args.scope], res.defects, snap)
        sql_files = plan.write_sql(pres)
        plan_md = plan.write_plan(pres)
        plan_csv = plan.write_csv(pres)
        print("  [remediate P3]")
        for c in plan.CLASS_ORDER:
            fs = pres.by_class.get(c, [])
            if fs:
                ndef = sum(len(f.defects) for f in fs)
                print(f"    {c:16s} {len(fs):3d} Fix / {ndef:4d} 결함  ({plan.CLASS_LABEL[c]})")
        print(f"    auto_data SQL 파일 {len(sql_files)}개 (dryrun/fix/undo·인간 승인 전 실행 금지)")
        print(f"  -> {plan_md}")
        print(f"  -> {plan_csv}")

    # 라운드 추적(append-only) — 수렴 추이
    if args.rnd is not None:
        rounds = _HERE / "board" / "board-rounds.csv"
        new = not rounds.exists()
        with rounds.open("a", encoding="utf-8", newline="") as f:
            w = csv.writer(f)
            if new:
                w.writerow(["round", "scope", "snap", "total_defects", "money", "critical",
                            "verdict", "note"])
            w.writerow([args.rnd, args.scope, res.snap_name, len(res.defects), money_n,
                        crit_n, "GO" if res.global_go else "NO-GO", args.note])

    return 0 if res.global_go else 1


if __name__ == "__main__":
    sys.exit(main())
