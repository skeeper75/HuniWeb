#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""스텝2 통합 스코프(--scope all) 셀프테스트 — 4축 통합 배선 회귀 가드(라이브 읽기전용).

★[HARD] 이건 생성측 자기점검(드리프트 0 대조)이다. 최종 검증은 별도 에이전트가 한다.

검증:
  [0] 통합 구성 — ALL_DIAGNOSERS == [linkage, price_grid, registration, contribution] (4축·순서)
  [1] 드리프트 0(Registration) — RegistrationDx 결함수 == registration_check.check() 레코드수(1:1 어댑터)
  [2] 드리프트 0(Contribution)  — ContributionDx 결함수 == contribution_scan.scan()(uncovered+mismatch+orphan)
  [3] 드리프트 0(PriceGrid·§26) — PriceGridDx 결함수 == run_all.main() 레코드 독립 재집계(시트×결함유형+pending)
  [4] 드리프트 0(Linkage)       — LinkageDx E3/E4 == DimConformanceDx(UNDECLARED/MISSING)·에지 메타 유효
  [5] 통합 보드 무손실 — board.run(ALL) 결함 총수 == Σ 4축 개별 scan(누락·중복 0)
  [6] 값 날조 금지 라우팅 — worklist(needs_authority/review)는 fix_sql 없음·전건 라우팅(Σ Fix.defects==진단)
  [7] needs_human 자동 결론 금지 — RegistrationDx needs_human 결함은 severity=low(HIGH 불가)
재실행: python3 _workspace/_foundation/hdx/all_selftest.py
"""
import sys
import pathlib

_HERE = pathlib.Path(__file__).resolve().parent
sys.path.insert(0, str(_HERE.parent))  # _foundation/

from hdx.foundation import Snapshot, Defect                # noqa: E402
from hdx.diagnose import (ALL_DIAGNOSERS, LinkageDx, PriceGridDx,        # noqa: E402
                          RegistrationDx, ContributionDx)
from hdx.diagnose.dim_conformance_dx import DimConformanceDx  # noqa: E402
from hdx.diagnose.linkage_dx import EDGE_LABEL              # noqa: E402
from hdx.remediate import ALL_REMEDIATORS, plan            # noqa: E402
from hdx import board                                      # noqa: E402

# 스탠드얼론 원본 스캐너(드리프트 대조용)
sys.path.insert(0, str(_HERE / "board"))
import registration_check as rc                            # noqa: E402
sys.path.insert(0, str(_HERE.parent / "batch"))
import contribution_scan                                   # noqa: E402
_S26 = _HERE.parent.parent / "huni-price-table-integrity" / "_batch" / "scripts"
sys.path.insert(0, str(_S26))
import run_all                                             # noqa: E402

# PriceGridDx 와 동일한 결함유형 집계 규칙(독립 재집계·§26 재구현 아님)
_PENDING = {"UNMAPPED", "L2_PENDING", "AREA_PENDING"}


def _expected_pricegrid_count(records) -> int:
    """run_all 레코드 → PriceGridDx 가 낼 Defect 수 독립 재집계(DIFFED 시트당 결함유형 수 + pending 1)."""
    from collections import defaultdict
    n = 0
    for rec in records:
        status = rec.get("status")
        if status == "OUT_OF_SCOPE":
            continue
        if status in _PENDING:
            n += 1
            continue
        if status != "DIFFED":
            continue
        by_type = defaultdict(list)
        for d in rec.get("defect_rows", []):
            by_type[d.get("defect", "?")].append(d)
        n += len(by_type)
    return n


def main():
    snap = Snapshot()

    # [0] 통합 구성
    dims = [dx.dimension for dx in ALL_DIAGNOSERS]
    assert dims == ["linkage", "price_grid", "registration", "contribution"], f"4축 구성 불일치: {dims}"
    print(f"[0] 통합 구성 OK — --scope all 4축: {dims}")

    # 축별 scan(1회씩·결정론)
    reg_ds = RegistrationDx().scan(snap)
    con_ds = ContributionDx().scan(snap)
    pg_ds = PriceGridDx().scan(snap)
    lk_ds = LinkageDx().scan(snap)

    # [1] 드리프트 0 — Registration
    recs = rc.check()
    assert len(reg_ds) == len(recs), f"Registration 드리프트: Dx {len(reg_ds)} vs check {len(recs)}"
    n_high = sum(1 for d in reg_ds if d.severity == "high")
    n_hum = sum(1 for d in reg_ds if d.evidence.get("needs_human"))
    print(f"[1] 드리프트 0(Registration) OK — {len(reg_ds)}건(=check 레코드) · HIGH {n_high} · needs_human {n_hum}")

    # [2] 드리프트 0 — Contribution
    r = contribution_scan.scan(None, snap.dir)
    exp_con = len(r.get("uncovered", [])) + len(r.get("mismatch", [])) + len(r.get("orphan_proc", []))
    assert len(con_ds) == exp_con, f"Contribution 드리프트: Dx {len(con_ds)} vs scan {exp_con}"
    print(f"[2] 드리프트 0(Contribution) OK — {len(con_ds)}건(=uncovered+mismatch+orphan {exp_con})")

    # [3] 드리프트 0 — PriceGrid(§26)
    records = run_all.main()
    exp_pg = _expected_pricegrid_count(records)
    assert len(pg_ds) == exp_pg, f"PriceGrid 드리프트: Dx {len(pg_ds)} vs run_all 재집계 {exp_pg}"
    print(f"[3] 드리프트 0(PriceGrid·§26) OK — {len(pg_ds)}건(=run_all 레코드 독립 재집계)")

    # [4] 드리프트 0 — Linkage(E3/E4 재사용 + 에지 메타)
    dc = DimConformanceDx().scan(snap)
    dc_und = sum(1 for d in dc if "UNDECLARED" in d.summary)
    dc_mis = sum(1 for d in dc if "MISSING" in d.summary)
    e3 = sum(1 for d in lk_ds if d.evidence.get("edge") == "E3")
    e4 = sum(1 for d in lk_ds if d.evidence.get("edge") == "E4")
    assert e3 == dc_und and e4 == dc_mis, f"Linkage E3/E4 드리프트: E3 {e3}/{dc_und} E4 {e4}/{dc_mis}"
    for d in lk_ds:
        assert d.evidence.get("edge") in EDGE_LABEL, f"미상 에지: {d.evidence.get('edge')}"
    print(f"[4] 드리프트 0(Linkage) OK — E3={e3}(=UNDECLARED)·E4={e4}(=MISSING)·에지 메타 유효({len(lk_ds)}건)")

    # [5] 통합 보드 무손실
    res = board.run(ALL_DIAGNOSERS, snap)
    axis_sum = len(reg_ds) + len(con_ds) + len(pg_ds) + len(lk_ds)
    assert len(res.defects) == axis_sum, f"보드 무손실 위반: board {len(res.defects)} vs Σ축 {axis_sum}"
    per = {dim: len(res.per_dim.get(dim, [])) for dim in dims}
    print(f"[5] 통합 보드 무손실 OK — 총 {len(res.defects)}건(=Σ 4축 {axis_sum}) · 차원별 {per}")

    # [6] 값 날조 금지 라우팅 + 전건 라우팅
    pres = plan.run(ALL_REMEDIATORS, res.defects, snap)
    routed = sum(len(f.defects) for f in pres.fixes)
    # 병합(_merge_root)으로 Fix 수는 줄어도 defects 합은 보존 — 다만 근본원인 dedup 은 defect.key() 중복
    # 제거 없이 extend 하므로 Σ defects >= 진단수. 축별 remediator 전건 라우팅을 개별 확인한다.
    from hdx.remediate import ALL_REMEDIATORS as _R
    for rmd in _R:
        mine = [d for d in res.defects if d.dimension == rmd.dimension]
        fxs = rmd.generate(mine, snap)
        rr = sum(len(f.defects) for f in fxs)
        assert rr == len(mine), f"{rmd.dimension} 라우팅 누락: {rr} vs {len(mine)}"
    for f in pres.fixes:
        if f.remediation_class in ("needs_authority", "needs_design", "review", "blocked_human"):
            assert not f.fix_sql, f"worklist 인데 fix_sql 존재(값 날조 위험): {f.title}"
    print(f"[6] 값 날조 금지·전건 라우팅 OK — 축별 전건 라우팅·worklist SQL 미생성({len(pres.fixes)} Fix)")

    # [7] needs_human 자동 결론 금지
    for d in reg_ds:
        if d.evidence.get("needs_human"):
            assert d.severity == "low", f"needs_human 인데 HIGH(자동 결론 금지 위반): {d.summary}"
    print(f"[7] needs_human 자동 결론 금지 OK — 조인 불확실 {n_hum}건 전부 advisory(HIGH 불가)")

    print("SELFTEST OK — hdx --scope all(4축 통합·드리프트 0·무손실·값 날조 금지·자동 결론 금지)")


if __name__ == "__main__":
    main()
