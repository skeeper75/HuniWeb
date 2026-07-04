#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""diagnose 셀프테스트 — OptionCpqDx 신뢰도 모델 회귀 가드(라이브 읽기전용).

WiringDx/ContributionDx/ComponentMergeDx 는 원본 스캐너 카운트 일치로 검증됨(README 참조).
여기서는 신규 로직 OptionCpqDx 의 HIGH/REVIEW 판별을 가드:
  [1] HIGH = 형제 dtl_opt 가 param 을 채운 옵션선택형(저청구 확정) — 메쉬배너 타공(PRD_000137)
  [2] REVIEW = 형제 미충전(수치입력 가능성) — 개수(변수텍스트/이미지)
  [3] 판별 건전성: 모든 HIGH 는 undercharge·high · 모든 REVIEW 는 low
재실행: python3 _workspace/_foundation/hdx/diagnose/_selftest.py
"""
import sys
import pathlib

sys.path.insert(0, str(pathlib.Path(__file__).resolve().parents[2]))  # _foundation/
from hdx.foundation import Snapshot
from hdx.diagnose import OptionCpqDx


def main():
    snap = Snapshot()
    ds = OptionCpqDx().scan(snap)
    high = [d for d in ds if d.severity == "high"]
    review = [d for d in ds if d.severity != "high"]
    print(f"[0] OptionCpqDx: 총 {len(ds)} (HIGH {len(high)} · REVIEW {len(review)})")

    # [1] HIGH 에 메쉬배너 타공 저청구 포함(형제 dtl_opt 존재 입증형)
    mesh = [d for d in high if d.prd_cd == "PRD_000137"
            and d.evidence.get("missing_param") == "타공수"]
    assert mesh, "메쉬배너(PRD_000137) 타공수 HIGH 저청구 미검출 — 신뢰도 모델 회귀"
    assert mesh[0].evidence.get("sibling_filled", 0) > 0, "HIGH 인데 형제 dtl_opt 입증 없음"
    print(f"[1] HIGH 저청구 확정 OK (메쉬배너 타공수·형제 {mesh[0].evidence['sibling_filled']}개 입증)")

    # [2] REVIEW = 개수(수치입력 가능성·형제 미충전)
    cnt = [d for d in review if d.evidence.get("missing_param") == "개수"]
    assert cnt, "개수 REVIEW 분류 없음 — 오탐 가드 회귀"
    assert cnt[0].evidence.get("sibling_filled", 0) == 0, "REVIEW 인데 형제 dtl_opt 존재(HIGH 여야)"
    print(f"[2] REVIEW 오탐 가드 OK (개수 {len(cnt)}건·형제 미충전=수치입력 가능성)")

    # [3] 판별 건전성
    assert all(d.money_impact == "undercharge" for d in high), "HIGH 인데 저청구 아님"
    assert all(d.severity == "low" for d in review), "REVIEW 인데 low 아님"
    print("[3] 판별 건전성 OK (HIGH=undercharge·REVIEW=low)")

    print("SELFTEST OK — hdx.diagnose OptionCpqDx 정합")


if __name__ == "__main__":
    main()
