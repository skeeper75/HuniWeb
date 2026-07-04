#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""remediate(P3) 셀프테스트 — 교정 생성 결정론·구조 정합 검증(라이브 읽기전용).

검증:
  [1] 전 결함 라우팅(누락 0·no silent caps): Σ Fix.defects == 진단 결함 총수
  [2] auto_data SQL 건전성: fix_sql=BEGIN…COMMIT + 백업(CREATE TABLE) + 게이트(RAISE) + undo 존재
  [3] 근본원인 dedup: wiring+calcability placeholder 가 blocked_human 1건으로 병합(차원 교차)
  [4] 값 날조 금지: needs_authority/blocked_human/needs_design 는 fix_sql 없음(worklist만)
재실행: python3 _workspace/_foundation/hdx/remediate/_selftest.py
"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2]))  # _foundation/
from hdx.foundation import Snapshot
from hdx.diagnose import PRICE_DIAGNOSERS
from hdx.remediate import PRICE_REMEDIATORS, plan


def main():
    snap = Snapshot()
    defects = []
    for dx in PRICE_DIAGNOSERS:
        defects.extend(dx.scan(snap))
    print(f"[0] 진단 결함 {len(defects)}건 (snap={snap.dir.name})")

    pres = plan.run(PRICE_REMEDIATORS, defects, snap)

    # [1] 전 결함 라우팅
    routed = sum(len(f.defects) for f in pres.fixes)
    assert routed == len(defects), f"라우팅 누락: {routed} != {len(defects)}"
    print(f"[1] 전 결함 라우팅 OK ({routed}건·누락 0)")

    # [2] auto_data SQL 건전성
    autos = [f for f in pres.by_class.get("auto_data", []) if f.fix_sql]
    for f in autos:
        s = f.fix_sql
        assert s.strip().startswith("--") and "BEGIN;" in s and "COMMIT;" in s, "트랜잭션 래핑 누락"
        assert "CREATE TABLE" in s and f.backup_table in s, "물리 백업 누락"
        assert "RAISE EXCEPTION" in s, "게이트 하드어서션 누락"
        assert f.dryrun_sql and "ROLLBACK" in f.dryrun_sql, "dryrun 롤백 누락"
        assert f.undo_sql and f.backup_table in f.undo_sql, "undo 백업참조 누락"
    print(f"[2] auto_data SQL 건전성 OK ({len(autos)}건: BEGIN/COMMIT·백업·게이트·dryrun·undo)")

    # [3] 근본원인 dedup (차원 교차)
    cross = [f for f in pres.by_class.get("blocked_human", []) if "+" in f.dimension]
    assert cross, "차원 교차 blocked_human 병합 미발생(placeholder 근본원인 dedup 실패)"
    print(f"[3] 근본원인 dedup OK (차원 교차 병합 {len(cross)}건: {cross[0].dimension}·{len(cross[0].defects)}결함)")

    # [4] 값 날조 금지: worklist 계열은 SQL 없음
    for c in ("needs_authority", "blocked_human", "needs_design", "review"):
        for f in pres.by_class.get(c, []):
            assert not f.fix_sql, f"{c} 는 SQL 금지(값 날조 방지)인데 fix_sql 존재"
    print("[4] 값 날조 금지 OK (worklist 계열 fix_sql 없음)")

    print("SELFTEST OK — hdx.remediate P3 정합")


if __name__ == "__main__":
    main()
